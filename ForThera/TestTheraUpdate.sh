#!/bin/bash
clear

LOG_FILE="/home/odroid/update09192020.log"
UPDATE_DONE="/home/odroid/.config/update09192020"

if [ -f "$UPDATE_DONE" ]; then
  msgbox "No more updates available.  Check back later."
  exit 187
fi

if [ -f "$LOG_FILE" ]; then
  sudo rm "$LOG_FILE"
fi

printf "\nChange retroarch hotkey exit and related file permissions...\n" | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/retroarch/chng_exitbtn.txt -O /home/odroid/chng_exitbtn.txt
if [ $? -eq 0 ]; then
  mv /home/odroid/.config/retroarch/retroarch.cfg /home/odroid/.config/retroarch/retroarch.update09192020.bak
  mv /home/odroid/.config/retroarch32/retroarch.cfg /home/odroid/.config/retroarch32/retroarch.update09192020.bak
  sed -e '/input_exit_emulator_btn/{r /home/odroid/chng_exitbtn.txt' -e 'd}' /home/odroid/.config/retroarch/retroarch.cfg > /home/odroid/retroarch64.cfg
  sed -e '/input_exit_emulator_btn/{r /home/odroid/chng_exitbtn.txt' -e 'd}' /home/odroid/.config/retroarch32/retroarch.cfg > /home/odroid/retroarch32.cfg
  mv -v /home/odroid/retroarch64.cfg /home/odroid/.config/retroarch/retroarch.cfg | tee -a "$LOG_FILE"
  mv -v /home/odroid/retroarch32.cfg /home/odroid/.config/retroarch32/retroarch.cfg | tee -a "$LOG_FILE"
  sudo rm -v /home/odroid/chng_exitbtn.txt | tee -a "$LOG_FILE"
  sudo chmod -v 777 /home/odroid/.config/retroarch/retroarch.cfg | tee -a "$LOG_FILE"
  sudo chmod -v 777 /home/odroid/.config/retroarch32/retroarch.cfg | tee -a "$LOG_FILE"
  sudo chown -v odroid:odroid /home/odroid/.config/retroarch/retroarch.cfg | tee -a "$LOG_FILE"
  sudo chown -v odroid:odroid /home/odroid/.config/retroarch32/retroarch.cfg | tee -a "$LOG_FILE"
else
  printf "Can't download necessary github file.  Check your internet connection and try again." | tee -a "$LOG_FILE"
  exit 1
fi

printf "\nChange PPSSPP for new exit combo and related file permissions...\n" | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/ppsspp/PPSSPPSDL -O /opt/ppsspp/PPSSPPSDL
if [ $? -eq 0 ]; then
  sudo chmod -v 777 /opt/ppsspp/PPSSPPSDL | tee -a "$LOG_FILE"
  sudo chown -v odroid:odroid /opt/ppsspp/PPSSPPSDL | tee -a "$LOG_FILE"
else
  printf "Can't download necessary github file.  Check your internet connection and try again." | tee -a "$LOG_FILE"
  exit 1
fi

touch /home/odroid/.config/update09192020
msgbox "Updates have been completed."
exit 187
