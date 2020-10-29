abbr mount 'sudo mount'
abbr umount 'sudo umount'
abbr htop 'htop --sort-key PERCENT_CPU'
abbr services "systemctl list-units -t service --no-pager --no-legend | grep active | egrep -v 'systemd|exited' | cut -d' ' -f1"
abbr who 'command w'
abbr person 'man'

abbr bspwmrc 'xdg-open ~/.config/bspwm/bspwmrc'
abbr sxhkdrc 'xdg-open ~/.config/sxhkd/sxhkdrc'
