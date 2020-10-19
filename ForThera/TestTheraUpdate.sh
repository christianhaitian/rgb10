#!/bin/bash
clear

UPDATE_DATE="10192020"
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

sudo chmod 666 /dev/tty1
echo 255 > /sys/devices/platform/backlight/backlight/backlight/brightness
touch $LOG_FILE
tail -f $LOG_FILE >> /dev/tty1 &

if [ ! -f "/home/odroid/.config/imageshift.sh" ]; then
msgbox "This update is fairly large and significant.  It may take 10 to 30 minutes to complete depending on your internet connection.  During this time, you will not see anything on your screen until the update is completed.  If the update does not complete after 30 minutes has passed, you may need to restart this update or restore a backup of your games on to a new image.  Press A to continue."

printf "\nInstalling the base vlc files to allow video snaps to play in emulationstation...\n" | tee -a "$LOG_FILE"
sudo apt update -y | tee -a "$LOG_FILE"
sudo apt -y install vlc-plugin-base | tee -a "$LOG_FILE"

printf "\nChange retroarch hotkey exit and related file permissions...\n" | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/retroarch/chng_exitbtn.txt -O /home/odroid/chng_exitbtn.txt -a "$LOG_FILE"
wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/retroarch/chng_gamepadbtn.txt -O /home/odroid/chng_gamepadbtn.txt -a "$LOG_FILE"
if [ $? -eq 0 ]; then
  sed -e '/input_exit_emulator_btn/{r /home/odroid/chng_exitbtn.txt' -e 'd}' /home/odroid/.config/retroarch/retroarch.cfg > /home/odroid/retroarch64.cfg
  sed -e '/input_exit_emulator_btn/{r /home/odroid/chng_exitbtn.txt' -e 'd}' /home/odroid/.config/retroarch32/retroarch.cfg > /home/odroid/retroarch32.cfg
  mv -v /home/odroid/.config/retroarch/retroarch.cfg /home/odroid/.config/retroarch/retroarch.update$UPDATE_DATE.bak
  mv -v /home/odroid/.config/retroarch32/retroarch.cfg /home/odroid/.config/retroarch32/retroarch.update$UPDATE_DATE.bak
  mv -v /home/odroid/retroarch64.cfg /home/odroid/.config/retroarch/retroarch.cfg | tee -a "$LOG_FILE"
  mv -v /home/odroid/retroarch32.cfg /home/odroid/.config/retroarch32/retroarch.cfg | tee -a "$LOG_FILE"
  sed -e '/input_menu_toggle_gamepad_combo/{r /home/odroid/chng_gamepadbtn.txt' -e 'd}' /home/odroid/.config/retroarch/retroarch.cfg > /home/odroid/retroarch64.cfg
  sed -e '/input_menu_toggle_gamepad_combo/{r /home/odroid/chng_gamepadbtn.txt' -e 'd}' /home/odroid/.config/retroarch32/retroarch.cfg > /home/odroid/retroarch32.cfg
  mv -v /home/odroid/retroarch64.cfg /home/odroid/.config/retroarch/retroarch.cfg | tee -a "$LOG_FILE"
  mv -v /home/odroid/retroarch32.cfg /home/odroid/.config/retroarch32/retroarch.cfg | tee -a "$LOG_FILE"
  sudo rm -v /home/odroid/chng_gamepadbtn.txt | tee -a "$LOG_FILE"
  sudo rm -v /home/odroid/chng_exitbtn.txt | tee -a "$LOG_FILE"
  sudo chmod -v 777 /home/odroid/.config/retroarch/retroarch.cfg | tee -a "$LOG_FILE"
  sudo chmod -v 777 /home/odroid/.config/retroarch32/retroarch.cfg | tee -a "$LOG_FILE"
  sudo chown -v odroid:odroid /home/odroid/.config/retroarch/retroarch.cfg | tee -a "$LOG_FILE"
  sudo chown -v odroid:odroid /home/odroid/.config/retroarch32/retroarch.cfg | tee -a "$LOG_FILE"
else
  printf "Can't download necessary github file.  Check your internet connection and try again." | tee -a "$LOG_FILE"
  rm -- "$0"
  printf "\033c" >> /dev/tty1
  exit 1
fi

printf "\nChange PPSSPP for new exit combo and related file permissions...\n" | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/ppsspp/PPSSPPSDL -O /opt/ppsspp/PPSSPPSDL -a "$LOG_FILE"
if [ $? -eq 0 ]; then
  sudo chmod -v 777 /opt/ppsspp/PPSSPPSDL | tee -a "$LOG_FILE"
  sudo chown -v odroid:odroid /opt/ppsspp/PPSSPPSDL | tee -a "$LOG_FILE"
else
  printf "Can't download necessary github file.  Check your internet connection and try again." | tee -a "$LOG_FILE"
  rm -- "$0"
  printf "\033c" >> /dev/tty1
  exit 1
fi

printf "\nUpdated Rertroarch 1.9.0 with RGA Scaling...\n" | tee -a "$LOG_FILE"
mv -v /opt/retroarch/bin/retroarch /opt/retroarch/bin/retroarch.update$UPDATE_DATE.bak | tee -a "$LOG_FILE"
mv -v /opt/retroarch/bin/retroarch32 /opt/retroarch/bin/retroarch32.update$UPDATE_DATE.bak | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/retroarch/retroarch -O /opt/retroarch/bin/retroarch -a "$LOG_FILE"
wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/retroarch32/retroarch32 -O /opt/retroarch/bin/retroarch32 -a "$LOG_FILE"
wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/retroarch/chng_viddrv.txt -O /home/odroid/chng_viddrv.txt -a "$LOG_FILE"
sed -e '/video_driver/{r /home/odroid/chng_viddrv.txt' -e 'd}' /home/odroid/.config/retroarch/retroarch.cfg > /home/odroid/retroarch64.cfg
mv -v /home/odroid/retroarch64.cfg /home/odroid/.config/retroarch/retroarch.cfg | tee -a "$LOG_FILE"
sudo rm -v /home/odroid/chng_viddrv.txt | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/retroarch.cfg | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/retroarch.cfg | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /opt/retroarch/bin/retroarch | tee -a "$LOG_FILE"
sudo chmod -v 777 /opt/retroarch/bin/retroarch | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /opt/retroarch/bin/retroarch32 | tee -a "$LOG_FILE"
sudo chmod -v 777 /opt/retroarch/bin/retroarch32 | tee -a "$LOG_FILE"
sudo ln -sfv /usr/lib/aarch64-linux-gnu/librga.so /usr/lib/aarch64-linux-gnu/librga.so.2 | tee -a "$LOG_FILE"

printf "\nFix analog stick not responding in N64 games and Mame2003 with no control ...\n" | tee -a "$LOG_FILE"
mv -v /home/odroid/.config/retroarch/retroarch-core-options.cfg /home/odroid/.config/retroarch/retroarch-core-options.cfg.update$UPDATE_DATE.bak | tee -a "$LOG_FILE"
mv -v /home/odroid/.config/retroarch32/retroarch-core-options.cfg /home/odroid/.config/retroarch32/retroarch-core-options.cfg.update$UPDATE_DATE.bak | tee -a "$LOG_FILE"
mv -v /home/odroid/.config/retroarch32/retroarch.cfg /home/odroid/.config/retroarch32/retroarch.cfg.update$UPDATE_DATE.bak | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/retroarch/retroarch-core-options.cfg -O /home/odroid/.config/retroarch/retroarch-core-options.cfg -a "$LOG_FILE"
wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/retroarch32/retroarch-core-options.cfg -O /home/odroid/.config/retroarch32/retroarch-core-options.cfg -a "$LOG_FILE"
wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/retroarch32/retroarch.cfg -O /home/odroid/.config/retroarch32/retroarch.cfg -a "$LOG_FILE"
sudo mkdir -v /home/odroid/.config/retroarch32/config/remaps/ | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch32/config/remaps/ | tee -a "$LOG_FILE"
wget -N https://github.com/christianhaitian/rgb10/raw/master/ForThera/retroarch32/config/ParaLLEl%20N64/ParaLLEl%20N64.rmp -P "/home/odroid/.config/retroarch32/config/remaps/ParaLLEl N64" -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/retroarch-core-options.cfg | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch32/retroarch-core-options.cfg | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch32/retroarch.cfg | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid -R /home/odroid/.config/retroarch32/config/remaps/ -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/retroarch-core-options.cfg | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch32/retroarch-core-options.cfg | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch32/retroarch.cfg | tee -a "$LOG_FILE"

printf "\nDownload and install updated Emulationstation and additional themes...\n" | tee -a "$LOG_FILE"
#sudo systemctl stop emulationstation
sudo apt-get install -y fonts-droid-fallback unzip libboost-system-dev libboost-filesystem-dev libboost-date-time-dev libboost-locale-dev libfreeimage-dev libfreetype6-dev libeigen3-dev libcurl4-openssl-dev libasound2-dev cmake libsdl2-dev libsdl2-mixer-2.0-0 | tee -a "$LOG_FILE"
sudo mv -v /usr/bin/emulationstation/emulationstation /usr/bin/emulationstation/emulationstation.update$UPDATE_DATE.bak | tee -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/emulationstation-fcamod/emulationstation -O /usr/bin/emulationstation/emulationstation -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/emulationstation-fcamod/.emulationstation/es_settings.cfg -O /home/odroid/.emulationstation/es_settings.cfg -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/emulationstation-fcamod/es_systems.cfg -O /etc/emulationstation/es_systems.cfg -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/emulationstation-fcamod/es-resources.tar -a "$LOG_FILE"
sudo tar -vxf es-resources.tar -C /usr/bin/emulationstation/ | tee -a "$LOG_FILE"
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
sudo wget http://eple.us/retroroller/libretro/aarch64/tgbdual_libretro.so.zip -a "$LOG_FILE"
sudo wget http://eple.us/retroroller/libretro/aarch64/fbalpha2012_libretro.so.zip -a "$LOG_FILE"
sudo wget http://eple.us/retroroller/libretro/aarch64/picodrive_libretro.so.zip -a "$LOG_FILE"
wget -O ~/.asoundrc https://www.batocera.org/users/lbrpdx/asoundrc -a "$LOG_FILE"
sudo unzip -n neocd_libretro.so.zip -d /home/odroid/.config/retroarch/cores/ | tee -a "$LOG_FILE"
sudo unzip -n duckstation_libretro.so.zip -d /home/odroid/.config/retroarch/cores/ | tee -a "$LOG_FILE"
sudo unzip -n px68k_libretro.so.zip -d /home/odroid/.config/retroarch/cores/ | tee -a "$LOG_FILE"
sudo unzip -n tgbdual_libretro.so.zip -d /home/odroid/.config/retroarch/cores/ | tee -a "$LOG_FILE"
sudo unzip -n fbalpha2012_libretro.so.zip -d /home/odroid/.config/retroarch/cores/ | tee -a "$LOG_FILE"
sudo unzip -n picodrive_libretro.so.zip -d /home/odroid/.config/retroarch/cores/ | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/cores/neocd_libretro.so | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/cores/neocd_libretro.so | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/cores/duckstation_libretro.so | tee -a "$LOG_FILE"
sudo chown odroid:odroid /home/odroid/.config/retroarch/cores/duckstation_libretro.so | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/cores/px68k_libretro.so | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/cores/px68k_libretro.so | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/cores/tgbdual_libretro.so | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/cores/tgbdual_libretro.so | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/cores/fbalpha2012_libretro.so | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/cores/fbalpha2012_libretro.so | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/cores/picodrive_libretro.so | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/cores/picodrive_libretro.so | tee -a "$LOG_FILE"
sudo rm -v neocd_libretro.so.zip | tee -a "$LOG_FILE"
sudo rm -v duckstation_libretro.so.zip | tee -a "$LOG_FILE"
sudo rm -v px68k_libretro.so.zip | tee -a "$LOG_FILE"
sudo rm -v tgbdual_libretro.so.zip | tee -a "$LOG_FILE"
sudo rm -v fbalpha2012_libretro.so.zip | tee -a "$LOG_FILE"
sudo rm -v picodrive_libretro.so.zip | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/Freeplay9-30-v1.zip -a "$LOG_FILE"
wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/Switch.zip -a "$LOG_FILE"
wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/es-theme-theRA_NTFS-carbon.zip -a "$LOG_FILE"
wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/es-theme-super-retro-rk3326.zip -a "$LOG_FILE"
wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/es-theme-gbz35-mod.zip -a "$LOG_FILE"
wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/dosirakF.zip -a "$LOG_FILE"
wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/es-theme-minimal.zip -a "$LOG_FILE"
wget -O ~/.asoundrc https://www.batocera.org/users/lbrpdx/asoundrc -a "$LOG_FILE"
sudo unzip -o Freeplay9-30-v1.zip -d /etc/emulationstation/themes/ | tee -a "$LOG_FILE"
sudo unzip -o Switch.zip -d /etc/emulationstation/themes/ | tee -a "$LOG_FILE"
sudo unzip -o es-theme-theRA_NTFS-carbon.zip -d /etc/emulationstation/themes/ | tee -a "$LOG_FILE"
sudo unzip -o es-theme-super-retro-rk3326.zip -d /etc/emulationstation/themes/ | tee -a "$LOG_FILE"
sudo unzip -o es-theme-gbz35-mod.zip -d /etc/emulationstation/themes/ | tee -a "$LOG_FILE"
sudo unzip -o es-theme-gbz35-mod.zip -d /etc/emulationstation/themes/ | tee -a "$LOG_FILE"
sudo unzip -o dosirakF.zip -d /etc/emulationstation/themes/ | tee -a "$LOG_FILE"
sudo rm -v Freeplay9-30-v1.zip | tee -a "$LOG_FILE"
sudo rm -v Switch.zip | tee -a "$LOG_FILE"
sudo rm -v es-theme-super-retro-rk3326.zip | tee -a "$LOG_FILE"
sudo rm -v es-theme-theRA_NTFS-carbon.zip | tee -a "$LOG_FILE"
sudo rm -v es-theme-gbz35-mod.zip | tee -a "$LOG_FILE"
sudo rm -v dosirakF.zip | tee -a "$LOG_FILE"
sudo rm -v es-theme-minimal.zip | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid ~/.asoundrc | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid -R /etc/emulationstation/ >> /dev/tty2
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

printf "\nAdd support for Cannonball, Cavestory, Doom, Doom2 and Rick Dangerous...\n" | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/ports.zip -a "$LOG_FILE"
sudo wget http://eple.us/retroroller/libretro/aarch64/prboom_libretro.so.zip -a "$LOG_FILE"
sudo wget http://eple.us/retroroller/libretro/aarch64/nxengine_libretro.so.zip -a "$LOG_FILE"
sudo wget http://eple.us/retroroller/libretro/aarch64/cannonball_libretro.so.zip -a "$LOG_FILE"
sudo wget http://eple.us/retroroller/libretro/aarch64/xrick_libretro.so.zip -a "$LOG_FILE"
sudo unzip -o ports.zip -d /roms/ | tee -a "$LOG_FILE"
sudo unzip -n prboom_libretro.so.zip -d /home/odroid/.config/retroarch/cores/ | tee -a "$LOG_FILE"
sudo unzip -n nxengine_libretro.so.zip -d /home/odroid/.config/retroarch/cores/ | tee -a "$LOG_FILE"
sudo unzip -n cannonball_libretro.so.zip -d /home/odroid/.config/retroarch/cores/ | tee -a "$LOG_FILE"
sudo unzip -n xrick_libretro.so.zip -d /home/odroid/.config/retroarch/cores/ | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/cores/prboom_libretro.so | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/cores/prboom_libretro.so | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/cores/nxengine_libretro.so | tee -a "$LOG_FILE"
sudo chown odroid:odroid /home/odroid/.config/retroarch/cores/nxengine_libretro.so | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/cores/cannonball_libretro.so | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/cores/cannonball_libretro.so | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/cores/xrick_libretro.so | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/cores/xrick_libretro.so | tee -a "$LOG_FILE"
sudo rm -v prboom_libretro.so.zip | tee -a "$LOG_FILE"
sudo rm -v nxengine_libretro.so.zip | tee -a "$LOG_FILE"
sudo rm -v cannonball_libretro.so.zip | tee -a "$LOG_FILE"
sudo rm -v xrick_libretro.so.zip | tee -a "$LOG_FILE"
sudo rm -v ports.zip | tee -a "$LOG_FILE"

printf "\nFix Quake shortcut option...\n" | tee -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/ports/Quake.sh -O /roms/ports/Quake.sh -a "$LOG_FILE"

printf "\nAtari800 bios file location and default controller fix...\n" | tee -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/home/odroid/.atari800.cfg -O /home/odroid/.atari800.cfg -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/retroarch/config/remaps/Atari800.zip -a "$LOG_FILE"
sudo unzip -o Atari800.zip -d /home/odroid/.config/retroarch/config/remaps/ | tee -a "$LOG_FILE"
sudo rm -v Atari800.zip | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid -R /home/odroid/.config/retroarch/config/remaps/Atari800/ | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.atari800.cfg | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.atari800.cfg | tee -a "$LOG_FILE"

printf "\nInstall updated kernel with wifi sleep fix...\n" | tee -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/BootFileUpdates.tar.gz -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/KernelUpdate.tar.gz -a "$LOG_FILE"
sudo tar --same-owner -zxvf BootFileUpdates.tar.gz -C / | tee -a "$LOG_FILE"
sudo tar --same-owner -zxvf KernelUpdate.tar.gz -C / | tee -a "$LOG_FILE"
sudo rm -v BootFileUpdates.tar.gz | tee -a "$LOG_FILE"
sudo rm -v KernelUpdate.tar.gz | tee -a "$LOG_FILE"

printf "\nLast but not least, let's ensure that Drastic performance has not been negatively impacted by these updates...\n" | tee -a "$LOG_FILE"
sudo ln -sfv /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0.10.0 /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0 | tee -a "$LOG_FILE"

msgbox "Version 2 updates have been completed.  System will now reboot so the kernel updates can take effect."
rm -v -- "$0" | tee -a "$LOG_FILE"
sudo reboot
exit 187

elif [ ! -f "/home/odroid/.config/testupdate10172020-1" ]; then
printf "\nInstalling Atari800 fix...\n" | tee -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/Atari800sep.tar -a "$LOG_FILE"
sudo mv -v /etc/emulationstation/es_systems.cfg /etc/emulationstation/es_systems.cfg.update$UPDATE_DATE.bak | tee -a "$LOG_FILE"
sudo tar -vxf Atari800sep.tar --strip-components=1 -C / | tee -a "$LOG_FILE"
sudo rm -v Atari800sep.tar | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid -R /home/odroid/.config/retroarch/config/Atari800/ | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid -R /home/odroid/.config/retroarch/config/remaps/Atari800/ | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid -R /home/odroid/.atari800.cfg | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /etc/emulationstation/es_systems.cfg | tee -a "$LOG_FILE"

printf "\nLet's get some wolfenstein 3D in here...\n" | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/ecwolf.zip -a "$LOG_FILE"
wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/ecwolf_libretro.so.zip -a "$LOG_FILE"
sudo unzip -o ecwolf.zip -d /roms/ | tee -a "$LOG_FILE"
sudo unzip -n ecwolf_libretro.so.zip -d /home/odroid/.config/retroarch/cores/ | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/cores/ecwolf_libretro.so | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/cores/ecwolf_libretro.so | tee -a "$LOG_FILE"
sudo rm -v ecwolf_libretro.so.zip | tee -a "$LOG_FILE"
sudo rm -v ecwolf.zip | tee -a "$LOG_FILE"

msgbox "Atari800 fix update have been applied and as an added bonus, you can now run the Wolfenstein 3D port. Hit A to go back to Emulationstation."
touch "/home/odroid/.config/testupdate10172020-1"
rm -v -- "$0" | tee -a "$LOG_FILE"
printf "\033c" >> /dev/tty1
sudo systemctl restart emulationstation
exit 187

elif [ ! -f "$UPDATE_DONE" ]; then
printf "\nAllow the ability to quit Emulationstation...\n" | tee -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/emulationstation-fcamod/emulationstation.service -O /etc/systemd/system/emulationstation.service -a "$LOG_FILE"
sudo systemctl daemon-reload
msgbox "You can now quit EmulationStation.  This could be handy if you want to access a terminal via keyboard by doing alt-f2 or alt-f3 for testing or debugging purposes."
touch "$UPDATE_DONE"
rm -v -- "$0" | tee -a "$LOG_FILE"
printf "\033c" >> /dev/tty1
sudo systemctl restart emulationstation
exit 187

else 
msgbox "No more updates available.  Check back later."
rm -- "$0"
printf "\033c" >> /dev/tty1
exit 187
fi