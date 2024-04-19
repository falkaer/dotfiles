export QT_QPA_PLATFORMTHEME="qt5ct"
export _JAVA_AWT_WM_NONREPARENTING=1

export TERMINAL=kitty
export VISUAL=hx
export EDITOR="$VISUAL"
export PAGER=less
export LESS=-asrRix8

# use bat as man pager
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

# nice LS_COLORS
export LS_COLORS="$(vivid generate lava)"

# DTU-specific storage directories
export DTU_HOME="/zhome/98/d/117538"
export COMPUTE_DIR="/dtu-compute/kfaol"
export WORK3_DIR="/work3/kfaol"

export PROJECTS_DIR="$HOME/projects"
export SCRATCH_DIR="$HOME/scratch"
export DATA_STORAGE_ROOT="$HOME/data"
export CLEARML_ROOT="$HOME/clearml"

# Start Julia with all threads
export JULIA_NUM_THREADS="$(grep -c ^processor /proc/cpuinfo)"

# https://github.com/python-poetry/poetry/issues/5250
export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring

# https://stackoverflow.com/questions/53979362/you-dont-have-path-in-your-path-gem-executables-will-not-run-while-using
if [ -x "$(command -v ruby)" ]; then
  export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
fi

export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin:/usr/local/bin:$PATH"
