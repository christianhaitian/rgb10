#!/bin/bash
sudo wget https://github.com/christianhaitian/rgb10/master/ForThera/BootFileUpdates.tar.gz -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rgb10/master/ForThera/KernelUpdate.tar.gz -a "$LOG_FILE"
sudo tar --same-owner -zxvf BootFileUpdates.tar.gz -C / | tee -a "$LOG_FILE"
sudo tar --same-owner -zxvf KernelUpdate.tar.gz -C / | tee -a "$LOG_FILE"
sudo rm -v BootFileUpdates.tar.gz | tee -a "$LOG_FILE"
sudo rm -v KernelUpdate.tar.gz | tee -a "$LOG_FILE"
rm -- "$0"
sudo reboot