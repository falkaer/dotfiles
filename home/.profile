export QT_QPA_PLATFORMTHEME="qt5ct"
export _JAVA_AWT_WM_NONREPARENTING=1

export VISUAL=vim
export EDITOR="$VISUAL"
export PAGER=less
export LESS=-asrRix8

export PROJECTS_DIR="$HOME/projects"
export SCRATCH_DIR="$HOME/scratch"
export DATA_STORAGE_ROOT="$HOME/data"
export CLEARML_ROOT="$HOME/clearml"

# Start Julia with all threads
export JULIA_NUM_THREADS="$(grep -c ^processor /proc/cpuinfo)"

