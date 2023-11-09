from dataclasses import dataclass
from typing import Any, Callable, Optional

from IPython.core.magic import register_line_magic, needs_local_scope


def _format(ms_time: float) -> str:
    if ms_time < 1e-3:  # nanosecond
        return f"{(ms_time * 1e6):.2f} ns"
    elif ms_time < 1:  # microsecond
        return f"{(ms_time * 1e3):.2f} µs"
    elif ms_time < 1e3:  # millisecond
        return f"{ms_time:.2f} ms"
    else:  # second
        return f"{ms_time * 1e-3:.2f} s"


@dataclass
class ProfilingResult:
    N: int
    min_time: float
    max_time: float
    median_time: float
    mean_time: float
    std: float
    quantiles: list[float]

    def __repr__(self) -> str:
        return (
            f"Timed for {self.N} loops:\n"
            f"\ttime per loop: best={_format(self.min_time)}, "
            f"mean={_format(self.mean_time)} ± {_format(self.std)}."
        )


def cutimeit(
    fn: Callable[[], Any],
    warmup: int = 100,
    rep: int = 300,
    device: Optional["torch.device"] = None,
    quantiles: tuple[float] = (0.2, 0.8),
) -> ProfilingResult:
    """
    Utility for accurately timing a function that runs asynchronously on the GPU.

    Args:
        fn: a callable to profile.
        warmup: milliseconds to spend warming up.
        rep: milliseconds to spend on timing.
        device: device to profile on.
        quantiles: timing quantiles to compute.
    """
    import torch

    device = torch.cuda.current_device() if device is None else device
    stream = torch.cuda.current_stream(device)

    fn()  # ensure function is JIT compiled
    torch.cuda.synchronize(device)

    # we maintain a buffer of 256 MB that we clear
    # before each kernel call to make sure that the L2
    # doesn't contain any input data before the run
    cache = torch.empty(int(256e6), dtype=torch.int8, device=device)

    # estimate the runtime of the function
    start_event = torch.cuda.Event(enable_timing=True)
    end_event = torch.cuda.Event(enable_timing=True)
    start_event.record(stream)
    for _ in range(5):
        cache.zero_()
        fn()
    end_event.record(stream)
    torch.cuda.synchronize(device)
    estimate_ms = start_event.elapsed_time(end_event) / 5

    # compute number of warmup and repeat iterations
    n_warmup = max(1, int(warmup / estimate_ms))
    n_repeat = max(1, int(rep / estimate_ms))
    start_event = [torch.cuda.Event(enable_timing=True) for _ in range(n_repeat)]
    end_event = [torch.cuda.Event(enable_timing=True) for _ in range(n_repeat)]

    # warmup
    for _ in range(n_warmup):
        fn()

    # benchmark
    for i in range(n_repeat):
        # clear L2 cache
        cache.zero_()
        start_event[i].record(stream)
        fn()
        end_event[i].record(stream)

    torch.cuda.synchronize(device)
    times = torch.tensor([s.elapsed_time(e) for s, e in zip(start_event, end_event)])
    return ProfilingResult(
        len(times),
        torch.min(times).item(),
        torch.max(times).item(),
        torch.median(times).item(),
        torch.mean(times).item(),
        torch.std(times).item(),
        torch.quantile(times, torch.tensor(quantiles)).tolist(),
    )


# SYNTAX: %cutimeit (...)
# (same as the builtin %timeit IPython magic)
def _register_ipython_magic():
    @needs_local_scope
    @register_line_magic
    def cutimeit(line, local_ns):
        fn = lambda: exec(line, globals(), local_ns)
        return _cutimeit(fn)


# @register_line_magic uses the function name, so we have to do
# all these gymnastics to make sure we can shadow it properly
_cutimeit = cutimeit
_register_ipython_magic()

