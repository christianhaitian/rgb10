#!/bin/bash
sudo systemctl stop emulationstation
sudo apt-get install -y libboost-system-dev libboost-filesystem-dev libboost-date-time-dev libboost-locale-dev libfreeimage-dev libfreetype6-dev libeigen3-dev libcurl4-openssl-dev libasound2-dev cmake libsdl2-dev libsdl2-mixer-2.0-0 | tee -a "$LOG_FILE"
sudo mv -v /usr/bin/emulationstation/emulationstation /usr/bin/emulationstation/emulationstation.temp92620.bak
sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/emulationstation/emulationstation -O /usr/bin/emulationstation/emulationstation
sudo chmod -v 777 /usr/bin/emulationstation/emulationstation
sudo systemctl start emulationstation