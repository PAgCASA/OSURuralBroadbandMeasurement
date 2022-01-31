#!/bin/bash

# cd to infra root folder
cd "$(dirname "$0")"/.. || exit

# create virtual enviroment named virtual_enviroment
python3 -m venv virtual_enviroment

# activate virtual enviroment
source virtual_enviroment/bin/activate

pip install -r requirements.txt

printf "\n\nPlease run 'source virtual_enviroment/bin/activate' from the infra folder to activate virtual enviroment\n"
