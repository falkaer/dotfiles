#!/bin/bash

patch_setcap(){
    sudo setcap 'cap_net_raw,cap_net_admin+eip' $1
}

export -f patch_setcap
find /usr/lib/python* -name bluepy-helper -exec bash -c 'patch_setcap "$0"' {} \;
