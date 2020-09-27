#!/bin/bash
sudo systemctl stop emulationstation
sudo apt-get install -y libboost-system-dev libboost-filesystem-dev libboost-date-time-dev libboost-locale-dev libfreeimage-dev libfreetype6-dev libeigen3-dev libcurl4-openssl-dev libasound2-dev cmake libsdl2-dev libsdl2-mixer-2.0-0
sudo mv -v /usr/bin/emulationstation/emulationstation /usr/bin/emulationstation/emulationstation.temp92620.bak
sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/emulationstation-fcamod/emulationstation -O /usr/bin/emulationstation/emulationstation
sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/emulationstation-fcamod/.emulationstation/es_settings.cfg -O /home/odroid/.emulationstaton/es_settings.cfg
sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/emulationstation-fcamod/es-resources.tar
sudo tar -xf es-resources.tar -C /usr/bin/emulationstation/
sudo rm es-resources.tar
sudo chown odroid:odroid /home/odroid/.emulationstaton/es_settings.cfg
sudo chmod -v 777 /home/odroid/.emulationstaton/es_settings.cfg
sudo chmod -v 777 /usr/bin/emulationstation/emulationstation
sudo systemctl start emulationstation