#!/bin/bash
sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/BootFileUpdates.tar.gz
sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/KernelUpdate.tar.gz
sudo tar --same-owner -zxvf BootFileUpdates.tar.gz -C /
sudo tar --same-owner -zxvf KernelUpdate.tar.gz -C /
sudo rm -v BootFileUpdates.tar.gz
sudo rm -v KernelUpdate.tar.gz
rm -- "$0"
sudo reboot