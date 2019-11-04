#!/usr/bin/env python3

import subprocess
import sys

ramps = {
    0: '▁',
    1: '▂',
    2: '▃',
    3: '▄',
    4: '▅',
    5: '▆',
    6: '▇',
    7: '█'
}

def make_ramp(frac):
    ramp_font = '%{T3}'
    return ramp_font + ramps[int(frac / 100 * 7)] + '%{T-}'

def make_bar(frac, width=10):
    background = '%{F#444444}'
    green = '%{F#aaff77}'
    orange = '%{F#fba922}'
    red = '%{F#ff5555}'
    reset = '%{F-}'
    
    out = green
    
    frac /= 100
    
    orangecut = int(0.5 * width)
    redcut = int(0.75 * width)
    pipecut = int(frac * width)
    
    for i in range(width):
        
        if i < pipecut and i == orangecut:
            out += orange
        elif i < pipecut and i == redcut:
            out += red
        
        if i == pipecut:
            out += reset + '|' + background
        else:
            out += '─'
    
    return out

if __name__ == '__main__':
    
    proc = subprocess.Popen(['nvidia-smi', '-l', '1', '--format=csv,noheader,nounits',
                             '--query-gpu=memory.used,memory.total,power.draw,power.limit,utilization.gpu,utilization.memory'],
                            stdout=subprocess.PIPE)
    
    while True:
        strs = proc.stdout.readline().decode('utf-8').split(', ')
        mem_usage, max_mem, tdp_usage, max_tdp, gpu_util, mem_util = tuple(map(float, strs))
        
        mem_frac = mem_usage / max_mem * 100
        tdp_frac = tdp_usage / max_tdp * 100
        
        sys.stdout.write('{} {} {}\n'.format(make_ramp(gpu_util), make_ramp(mem_util), make_bar(mem_frac)))
        sys.stdout.flush()
