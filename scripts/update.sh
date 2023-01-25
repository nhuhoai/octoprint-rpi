#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

service octoprint stop

su octoprint -c "
cd /opt/octoprint
pip install octoprint --upgrade --no-cache-dir
"

service octoprint start
