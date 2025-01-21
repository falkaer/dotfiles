use path

fn activate {|&venv-path=.venv|
  var full-path = (path:abs $venv-path)
  if (not (path:is-dir $full-path)) {
    fail "Virtual environment directory not found: "$full-path
  }
  var bin-dir = $full-path/bin
  if (not (path:is-dir $bin-dir)) {
    fail "Bin directory not found in venv: "$bin-dir
  }
  set paths = [$bin-dir $@paths]
  set-env VIRTUAL_ENV $full-path
  unset-env PYTHONHOME
}

fn deactivate {
  if (has-env VIRTUAL_ENV) {
    var venv-bin = $E:VIRTUAL_ENV/bin
    set paths = [(each {|p| if (not-eq $p $venv-bin) { put $p }} $paths)]
    unset-env VIRTUAL_ENV
  }
}

