set-env QT_QPA_PLATFORMTHEME 'qt5ct'
set-env _JAVA_AWT_WM_NONREPARENTING 1
set-env TERMINAL 'kitty'
set-env VISUAL 'hx'
set-env EDITOR $E:VISUAL
set-env PAGER 'less'
set-env LESS '-asrRix8'

# use bat as man pager
set-env MANPAGER 'sh -c "col -bx | bat -l man -p"'
set-env MANROFFOPT '-c'

# nice LS_COLORS
set-env LS_COLORS (e:vivid generate lava)

# DTU-specific directories
set-env DTU_HOME '/zhome/98/d/117538'
set-env COMPUTE_DIR '/dtu-compute/kfaol'
set-env WORK3_DIR '/work3/kfaol'
set-env PROJECTS_DIR $E:HOME'/projects'
set-env SCRATCH_DIR $E:HOME'/scratch'
set-env DATA_STORAGE_ROOT $E:HOME'/data'
set-env CLEARML_ROOT $E:COMPUTE_DIR'/clearml'

set-env JULIA_NUM_THREADS (e:grep -c '^processor' /proc/cpuinfo)
set-env CUDA_HOME '/opt/cuda'
set-env PYTHON_KEYRING_BACKEND 'keyring.backends.null.Keyring'

if (has-external ruby) {
    set-env GEM_HOME (ruby -e 'puts Gem.user_dir')
}

use str

var new_paths = [
    $E:HOME'/bin'
    $E:HOME'/.local/bin'
    $E:HOME'/.cargo/bin'
    $E:CUDA_HOME'/bin'
    $E:HOME'/go/bin'
]

var old_paths = [(str:split ':' $E:PATH)]
set paths = [$@new_paths $@old_paths]

# Binds
set edit:insert:binding['Ctrl-l'] = { edit:clear }
set edit:insert:binding['Alt-l'] = { edit:location:start } 

# Python
use python
set edit:insert:binding['Alt-L'] = { python:activate }

fn latpath { put $E:PROJECTS_DIR/latent-features }
fn notespath { put $E:PROJECTS_DIR/notes }
fn lat { cd (latpath) }
fn notes { cd (notespath) }

fn ls {|@args| e:eza $@args }
fn ll {|@args| e:eza -l $@args }
fn cat {|@args| e:bat --style="rule" --paging=never $@args }

fn fuck {
  var last = (edit:command-history &cmd-only &newest-first | drop 1 | take 1)
  if (not (str:has-prefix $last "sudo ")) {
    # eval "sudo "$last
    edit:replace-input "sudo "$last
  }
}

fn zj {|@args| e:zellij $@args }
fn zjl { e:zellij --layout lat }
fn lg { e:lazygit }
fn lj { e:lazyjj }

fn pt {|@args|
    e:ptw --runner "pytest" . --testmon $@args
}

fn ns {|@args|
    e:ns $@args
}

fn with-env {|k v fn|
    set-env $k $v
    $fn
}

fn cudev {|device fn|
    with-env CUDA_VISIBLE_DEVICES $device $fn
}

eval (starship init elvish)

set-env CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense'
eval (carapace _carapace elvish | slurp)
