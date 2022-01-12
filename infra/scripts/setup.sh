#!/bin/bash

# cd to root project folder
cd "$(dirname "$0")"/../.. || exit

# create /etc/ansible if it doesn't already exist
if [ ! -d /etc/ansible ]; then
    mkdir -p /etc/ansible
fi

# link /etc/ansible/hosts to hosts
ln -s /etc/ansible/hosts ./hosts
