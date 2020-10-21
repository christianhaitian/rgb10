#!/bin/bash

sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/ogasleepfix/sleep -O /usr/lib/systemd/system-sleep/sleep
sudo chmod 775 /usr/lib/systemd/system-sleep/sleep
rm -v -- "$0"
msgbox "OGA 1.1 wifi sleep test fix has been applied.  Your device will now restart."
sudo reboot