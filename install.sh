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
echo "octoprint ALL=NOPASSWD: /opt/octoprint/scripts/*.sh" | tee -a /etc/sudoers > /dev/null
cd /opt/octoprint
git clone https://github.com/nhuhoai/octoprint-rpi.git .
cp ./octoprint.service /etc/systemd/system/octoprint.service
su octoprint -c "
cd /opt/octoprint
python3 -m venv .venv
source /opt/octoprint/.venv/bin/activate
pip install pip --upgrade
pip install octoprint
"
systemctl enable octoprint
