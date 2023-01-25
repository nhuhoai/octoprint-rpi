# Requirements

-   Raspberry Pi 3 or 4 (I do not have tested on another one)
-   An SD card with a least 400 Mb
-   A USB stick (USB 2.0 or USB 3.0) with at least 8 Gb
-   ```Raspberry Pi Imager```

# Prepare default boot on USB

-   Insert the SD card to your PC
-   Run ```Raspberry Pi Imager```
-   For ```Operating system```, select ```Misc utility images```, then ```Bootloader``` and select ```USB Boot```
-   For ```Storage```, select your SD card and click on ```Write```
-   When it is done, insert remove your SD card from your PC and insert it in the Raspberry Pi

# Prepare ```Raspberry Pi OS```

-   Insert the USB stick to your PC
-   Run ```Raspberry Pi Imager```
-   For ```Operating system``` select ```Raspberry Pi OS (other)``` then:
    -   ```Raspberry Pi OS (64-bit)``` if you will connect your Raspberry Pi a screen and want use the desktop mode
    -   ```Raspberry Pi OS Lite (64-bit)``` if you want the server mode (only console)
-   For ```Storage```, select your USB stick
-   Click on the cog for more settings
    -   ```Set hostname```: put the Rasperry Pi name showed on your network (for example: octoprint, piserver or rpi)
    -   ```Enable SSH```: check the box and choose ```Use password authentification``` (or the other option if you know what you are doing)
    -   ```Set username and password```: check the box and fill data
    -   ```Configure wireless LAN```: check the box and fill data if you want use the wifi to connect to your network
    -   ```Set locale settings```: check the box and fill data
-   Click ```Save``` to save settings
-   Click ```Write```
-   When it is done, unplug your USB stick and replug it. You must have two partitions (on MacOS and Windows, the second one cannot be read)
-   Open the ```boot``` partition and open the ```config.txt``` file with your favorite text editor
-   The last line must be ```[all]```, if not, add a new line with ```[all]```
-   Under ```[all]```, put the following lines:
    -   ```gpu_mem=16```: if you want use the Raspberry Pi OS Lite, otherwise, do not insert this line)
    -   ```dtoverlay=disable-bt```: Disable Bluetooth
    -   ```dtoverlay=disable-wifi```: Disable wifi (do not insert this line if you want to use the wifi to connect to your network)
-   Look for ```dtparam=audio=on``` and replace it by ```dtparam=audio=off``` if you want to disable the sound card
-   Look for ```camera_auto_detect=1``` and replace it by ```camera_auto_detect=0``` if you know you never use a camera with the Raspberry Pi0

# First run of Raspberry Pi

-   Turn on your Raspberry Pi
    -   If you have a screen, the Raspberry Pi will reboot and wait until you see the login line
    -   If you do not have a screen connected to your Raspberry Pi, please just wait about 3 minutes
-   Use your router or an app like ```fing``` to find your Raspberry Pi IP address
-   Connect from you PC to your Raspberry Pi the following command:
    ```bash
    ssh username@ip_address
    ```
    If you have the following message ```WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!```, please use this command:
    ```bash
    ssh-keygen -R ip_address
    ssh username@ip_address
    ```
-   If you success, it is meaning your Raspberry Pi is running and reaching from your local network, you can logout with
    ```exit``` command or stay connected for the next steps

# Update the Raspberry Pi firmware (not required)

-   The official documentation says you must do it only if it required, I always do it for the first launch and never have an issue. Do it if
    you want
-   ```bash
    sudo rpi-update
    ```
-   After the update, reboot your Raspberry Pi
    ```bash
    sudo reboot
    ```

# Update and install required packages

-   Update your packages manager
    ```bash
    sudo apt update
    ```
-   Upgrade all packages
    ```bash
    sudo apt upgrade -y
    ```
-   Clean old packages
    ```bash
    sudo apt autoclean -y && sudo apt autoremove -y
    ```
-   Install required packages
    ```bash
    sudo apt install -y build-essential \
                        git \
                        libffi-dev \
                        libssl-dev \
                        libyaml-dev \
                        python3 \
                        python3-dev \
                        python3-pip \
                        python3-setuptools \
                        python3-venv
    ```

# Create specific user for Octoprint

-   Create user
    ```bash
    sudo useradd -m -d /opt/octoprint octoprint
    ```
-   Allow access to USB data
    ```bash
    sudo usermod -a -G dialout octoprint
    ```
-   Allow access to webcam data (not required if you a remote webcam)
    ```bash
    sudo usermod -a -G video octoprint
    ```
-   Allow sudo commands for ```/opt/octoprint/scripts``` for ```octoprint```
    ```bash
    echo "octoprint ALL=NOPASSWD: /opt/octoprint/scripts/*.sh" | sudo tee -a /etc/sudoers > /dev/null
    ```

# Install Octoprint with ```octoprint``` account

-   Log as ```octoprint```
    ```bash
    sudo su octoprint
    ```
-   Be sure to be on the home directory
    ```bash
    cd /opt/octoprint
    ```
-   Create the virtualenv
    ```bash
    python3 -m venv .venv
    ```
-   Load the virtualenv
    ```bash
    source /opt/octoprint/.venv/bin/activate
    # you must see (.venv) on your prompt
    ```
-   Upgrade ```pip```
    ```bash
    pip install pip --upgrade
    ```
-   Install ```octoprint```
    ```bash
    pip install --no-cache-dir octoprint
    ```
