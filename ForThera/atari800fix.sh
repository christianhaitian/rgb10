#!/bin/bash
sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/Atari800sep.tar
sudo mv -v /etc/emulationstation/es_systems.cfg /etc/emulationstation/es_systems.cfg.temp101720.bak
sudo tar -xf Atari800sep.zip /
sudo chown odroid:odroid -R /home/odroid/.config/retroarch/config/Atari800/
sudo chown odroid:odroid -R /home/odroid/.config/retroarch/config/remaps/Atari800/
sudo chown odroid:odroid -R /home/odroid/.atari800.cfg
sudo chown odroid:odroid /etc/emulationstation/es_systems.cfg
sudo systemctl restart emulationstation
rm -- "$0"
