$env.QT_QPA_PLATFORMTHEME = 'qt5ct'
$env._JAVA_AWT_WM_NONREPARENTING = 1

$env.TERMINAL = 'kitty'
$env.VISUAL = 'hx'
$env.EDITOR = $env.VISUAL
$env.PAGER = 'less'
$env.LESS = '-asrRix8'

# use bat as man pager
$env.MANPAGER = 'sh -c "col -bx | bat -l man -p"'
$env.MANROFFOPT = '-c'

# nice LS_COLORS
$env.LS_COLORS = (vivid generate lava)

# DTU-specific storage directories
$env.DTU_HOME = '/zhome/98/d/117538'
$env.COMPUTE_DIR = '/dtu-compute/kfaol'
$env.WORK3_DIR = '/work3/kfaol'

$env.PROJECTS_DIR = $"($env.HOME)/projects"
$env.SCRATCH_DIR = $"($env.HOME)/scratch"
$env.DATA_STORAGE_ROOT = $"($env.HOME)/data"
$env.CLEARML_ROOT  = $"($env.HOME)/clearml"

# Start Julia with all threads
$env.JULIA_NUM_THREADS = (grep -c ^processor /proc/cpuinfo)
$env.CUDA_HOME = "/opt/cuda"

# https://github.com/python-poetry/poetry/issues/5250
$env.PYTHON_KEYRING_BACKEND = 'keyring.backends.null.Keyring'

# https://stackoverflow.com/questions/53979362/you-dont-have-path-in-your-path-gem-executables-will-not-run-while-using
if not (which ruby | is-empty) {
    $env.GEM_HOME = (ruby -e 'puts Gem.user_dir')
}

$env.PATH = ([$"($env.HOME)/bin", 
              $"($env.HOME)/.local/bin",
              $"($env.HOME)/.cargo/bin",
              $"($env.CUDA_HOME)/bin",
              $"($env.HOME)/go/bin"]
             | append ($env.PATH | split row (char esep)))
