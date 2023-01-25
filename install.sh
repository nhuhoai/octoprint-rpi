#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

apt update
apt upgrade -y
apt autoclean -y
apt autoremove -y
apt install -y build-essential \
               ffmpeg \
               git \
               libffi-dev \
               libssl-dev \
               libyaml-dev \
               python3 \
               python3-dev \
               python3-pip \
               python3-setuptools \
               python3-venv
useradd -m -d /opt/octoprint octoprint
usermod -a -G dialout octoprint
usermod -a -G video octoprint
echo "octoprint ALL=NOPASSWD: /opt/octoprint/scripts/*.sh" | tee -a /etc/sudoers > /dev/null
su octoprint -c "
cd /opt/octoprint
git init .
git remote add origin https://github.com/nhuhoai/octoprint-rpi.git
git fetch
git checkout -t origin/main
python3 -m venv .venv
source /opt/octoprint/.venv/bin/activate
pip install pip --upgrade
pip install octoprint
"
cp /opt/octoprint/octoprint.service /etc/systemd/system/octoprint.service
systemctl enable octoprint
systemctl start octoprint
