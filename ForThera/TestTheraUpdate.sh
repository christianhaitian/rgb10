#!/bin/bash
clear

UPDATE_DATE="09302020"
LOG_FILE="/home/odroid/update$UPDATE_DATE.log"
UPDATE_DONE="/home/odroid/.config/testupdate$UPDATE_DATE"

if [ -f "$UPDATE_DONE" ]; then
  msgbox "No more updates available.  Check back later."
  rm -- "$0"
  exit 187
fi

if [ -f "$LOG_FILE" ]; then
  sudo rm "$LOG_FILE"
fi

printf "\nInstalling the base vlc files to allow video snaps to play in emulationstation...\n" | tee -a "$LOG_FILE"
sudo apt update -y | tee -a "$LOG_FILE"
sudo apt -y install vlc-plugin-base | tee -a "$LOG_FILE"

printf "\nChange retroarch hotkey exit and related file permissions...\n" | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/retroarch/chng_exitbtn.txt -O /home/odroid/chng_exitbtn.txt
if [ $? -eq 0 ]; then
  sed -e '/input_exit_emulator_btn/{r /home/odroid/chng_exitbtn.txt' -e 'd}' /home/odroid/.config/retroarch/retroarch.cfg > /home/odroid/retroarch64.cfg
  sed -e '/input_exit_emulator_btn/{r /home/odroid/chng_exitbtn.txt' -e 'd}' /home/odroid/.config/retroarch32/retroarch.cfg > /home/odroid/retroarch32.cfg
  mv /home/odroid/.config/retroarch/retroarch.cfg /home/odroid/.config/retroarch/retroarch.update$UPDATE_DATE.bak
  mv /home/odroid/.config/retroarch32/retroarch.cfg /home/odroid/.config/retroarch32/retroarch.update$UPDATE_DATE.bak
  mv -v /home/odroid/retroarch64.cfg /home/odroid/.config/retroarch/retroarch.cfg | tee -a "$LOG_FILE"
  mv -v /home/odroid/retroarch32.cfg /home/odroid/.config/retroarch32/retroarch.cfg | tee -a "$LOG_FILE"
  sudo rm -v /home/odroid/chng_exitbtn.txt | tee -a "$LOG_FILE"
  sudo chmod -v 777 /home/odroid/.config/retroarch/retroarch.cfg | tee -a "$LOG_FILE"
  sudo chmod -v 777 /home/odroid/.config/retroarch32/retroarch.cfg | tee -a "$LOG_FILE"
  sudo chown -v odroid:odroid /home/odroid/.config/retroarch/retroarch.cfg | tee -a "$LOG_FILE"
  sudo chown -v odroid:odroid /home/odroid/.config/retroarch32/retroarch.cfg | tee -a "$LOG_FILE"
else
  printf "Can't download necessary github file.  Check your internet connection and try again." | tee -a "$LOG_FILE"
  rm -- "$0"
  exit 1
fi

printf "\nChange PPSSPP for new exit combo and related file permissions...\n" | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/ppsspp/PPSSPPSDL -O /opt/ppsspp/PPSSPPSDL
if [ $? -eq 0 ]; then
  sudo chmod -v 777 /opt/ppsspp/PPSSPPSDL | tee -a "$LOG_FILE"
  sudo chown -v odroid:odroid /opt/ppsspp/PPSSPPSDL | tee -a "$LOG_FILE"
else
  printf "Can't download necessary github file.  Check your internet connection and try again." | tee -a "$LOG_FILE"
  rm -- "$0"
  exit 1
fi

printf "\nFix analog stick not responding in N64 games and Mame2003 with no control ...\n" | tee -a "$LOG_FILE"
mv -v /home/odroid/.config/retroarch/retroarch-core-options.cfg /home/odroid/.config/retroarch/retroarch-core-options.cfg.update$UPDATE_DATE.bak | tee -a "$LOG_FILE"
mv -v /home/odroid/.config/retroarch32/retroarch-core-options.cfg /home/odroid/.config/retroarch32/retroarch-core-options.cfg.update$UPDATE_DATE.bak | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/retroarch/retroarch-core-options.cfg -O /home/odroid/.config/retroarch/retroarch-core-options.cfg -a "$LOG_FILE"
wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/retroarch32/retroarch-core-options.cfg -O /home/odroid/.config/retroarch32/retroarch-core-options.cfg -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/retroarch-core-options.cfg | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch32/retroarch-core-options.cfg | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/retroarch-core-options.cfg | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch32/retroarch-core-options.cfg | tee -a "$LOG_FILE"

printf "\nDownload and install updated Emulationstation and additional themes...\n" | tee -a "$LOG_FILE"
#sudo systemctl stop emulationstation
sudo apt-get install -y unzip libboost-system-dev libboost-filesystem-dev libboost-date-time-dev libboost-locale-dev libfreeimage-dev libfreetype6-dev libeigen3-dev libcurl4-openssl-dev libasound2-dev cmake libsdl2-dev libsdl2-mixer-2.0-0 | tee -a "$LOG_FILE"
sudo mv -v /usr/bin/emulationstation/emulationstation /usr/bin/emulationstation/emulationstation.update$UPDATE_DATE.bak | tee -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/emulationstation-fcamod/emulationstation -O /usr/bin/emulationstation/emulationstation -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/emulationstation-fcamod/.emulationstation/es_settings.cfg -O /home/odroid/.emulationstation/es_settings.cfg -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/emulationstation-fcamod/es_systems.cfg -O /etc/emulationstation/es_systems.cfg -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/emulationstation-fcamod/es-resources.tar -a "$LOG_FILE"
sudo tar -xfv es-resources.tar -C /usr/bin/emulationstation/ | tee -a "$LOG_FILE"
sudo rm -v es-resources.tar | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.emulationstation/es_settings.cfg | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.emulationstation/es_settings.cfg | tee -a "$LOG_FILE"
sudo chmod -v 777 /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
sudo chown odroid:odroid /etc/emulationstation/es_systems.cfg | tee -a "$LOG_FILE"
sudo chmod -v 777 /etc/emulationstation/es_systems.cfg | tee -a "$LOG_FILE"
sudo mkdir -v /roms/x68000 | tee -a "$LOG_FILE"
sudo mkdir -v /roms/neogeocd | tee -a "$LOG_FILE"
sudo wget http://eple.us/retroroller/libretro/aarch64/neocd_libretro.so.zip -a "$LOG_FILE"
sudo wget http://eple.us/retroroller/libretro/aarch64/duckstation_libretro.so.zip -a "$LOG_FILE"
sudo wget http://eple.us/retroroller/libretro/aarch64/px68k_libretro.so.zip -a "$LOG_FILE"
sudo unzip -n neocd_libretro.so.zip -d /home/odroid/.config/retroarch/cores/ | tee -a "$LOG_FILE"
sudo unzip -n duckstation_libretro.so.zip -d /home/odroid/.config/retroarch/cores/ | tee -a "$LOG_FILE"
sudo unzip -n px68k_libretro.so.zip -d /home/odroid/.config/retroarch/cores/ | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/cores/neocd_libretro.so | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/cores/neocd_libretro.so | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/cores/duckstation_libretro.so | tee -a "$LOG_FILE"
sudo chown odroid:odroid /home/odroid/.config/retroarch/cores/duckstation_libretro.so | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/cores/px68k_libretro.so | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/cores/px68k_libretro.so | tee -a "$LOG_FILE"
sudo rm -v neocd_libretro.so.zip | tee -a "$LOG_FILE"
sudo rm -v duckstation.so.zip | tee -a "$LOG_FILE"
sudo rm -v px68k_libretro.so.zip | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/Freeplay9-30-v1.zip -a "$LOG_FILE"
wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/Switch9-29-20-v4.zip -a "$LOG_FILE"
wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/es-theme-theRA_NTFS-carbon.zip -a "$LOG_FILE"
sudo unzip -o Freeplay9-30-v1.zip -d /etc/emulationstation/themes/ | tee -a "$LOG_FILE"
sudo unzip -o Switch9-29-20-v4.zip -d /etc/emulationstation/themes/ | tee -a "$LOG_FILE"
sudo unzip -o es-theme-theRA_NTFS-carbon.zip -d /etc/emulationstation/themes/ | tee -a "$LOG_FILE"
sudo rm -v Freeplay9-30-v1.zip | tee -a "$LOG_FILE"
sudo rm -v Switch9-29-20-v4.zip | tee -a "$LOG_FILE"
sudo rm -v es-theme-theRA_NTFS-carbon.zip | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid -R /etc/emulationstation/ | tee -a "$LOG_FILE"
#sudo systemctl start emulationstation

LOGODIR="/boot/BMPs/"

if [ -d "$LOGODIR" ]; then
  printf "\nDownloading and copying logos to /boot/BMPs folder if they don't exist already...\n" | tee -a "$LOG_FILE"
  sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/BMPs/logo1.bmp -O /boot/BMPs/logo1.bmp -a "$LOG_FILE"
  sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/BMPs/logo2.bmp -O /boot/BMPs/logo2.bmp -a "$LOG_FILE"
  sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/BMPs/logo3.bmp -O /boot/BMPs/logo3.bmp -a "$LOG_FILE"
  sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/BMPs/logo4.bmp -O /boot/BMPs/logo4.bmp -a "$LOG_FILE"
else
  printf "\nCreating logo directory in boot folder...\n" | tee -a "$LOG_FILE"
  sudo mkdir /boot/BMPs | tee -a "$LOG_FILE"
  printf "\nDownloading and copying logos to /boot/BMPs folder...\n" | tee -a "$LOG_FILE"
  sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/BMPs/logo1.bmp -O /boot/BMPs/logo1.bmp -a "$LOG_FILE"
  sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/BMPs/logo2.bmp -O /boot/BMPs/logo2.bmp -a "$LOG_FILE"
  sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/BMPs/logo3.bmp -O /boot/BMPs/logo3.bmp -a "$LOG_FILE"
  sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/BMPs/logo4.bmp -O /boot/BMPs/logo4.bmp -a "$LOG_FILE"
  wget -nc https://github.com/christianhaitian/rgb10/raw/master/ForThera/imageshift.sh -P /home/odroid/.config -a "$LOG_FILE"
  sudo chmod -v 777 /home/odroid/.config/imageshift.sh | tee -a "$LOG_FILE"
  sudo chown -v odroid:odroid /home/odroid/.config/imageshift.sh | tee -a "$LOG_FILE"
fi

IMAGESHIFTEXIST=$(sudo crontab -l | sed -n '/imageshift.sh/p')

if [[ "$IMAGESHIFTEXIST" == *"imageshift.sh"* ]]; then
  printf "\nimageshift script already exists, moving on...\n" | tee -a "$LOG_FILE"
else
  printf "\nDownloading and copying imageshift script to proper location and setting cron job at each boot...\n" | tee -a "$LOG_FILE"
  wget -nc https://github.com/christianhaitian/rgb10/raw/master/ForThera/imageshift.sh -P /home/odroid/.config/  | tee -a "$LOG_FILE"
  sudo chown -v odroid:odroid /home/odroid/.config/imageshift.sh | tee -a "$LOG_FILE"
  sudo chmod -v 777 /home/odroid/.config/imageshift.sh | tee -a "$LOG_FILE"
  (sudo crontab -l 2>/dev/null; echo "@reboot /home/odroid/.config/imageshift.sh") | sudo crontab -  | tee -a "$LOG_FILE"
  sudo service cron reload | tee -a "$LOG_FILE"
fi

printf "\nLast but not least, let's ensure that Drastic performance has not been negatively impacted by these updates...\n" | tee -a "$LOG_FILE"
sudo ln -sfv /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0.10.0 /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0 | tee -a "$LOG_FILE"

touch "$UPDATE_DONE"
msgbox "Updates have been completed."
rm -- "$0"
exit 187
done