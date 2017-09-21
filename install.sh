#!/bin/bash


#Step 1) Check if root--------------------------------------
if [[ $EUID -ne 0 ]]; then
   echo "Please execute script as root." 
   exit 1
fi
#-----------------------------------------------------------

#Step 2) enable UART----------------------------------------
cd /boot/
File=config.txt
if grep -q "enable_uart=1" "$File";
	then
		echo "UART already enabled. Doing nothing."
	else
		echo "enable_uart=1" >> $File
		echo "UART enabled."
fi
#-----------------------------------------------------------

#Step 3) Update repository----------------------------------
sudo apt-get update -y
#-----------------------------------------------------------

#Step 4) Install gpiozero module----------------------------
sudo apt-get install -y python3-gpiozero
#-----------------------------------------------------------

#Step 5) Download Python script-----------------------------
cd /opt/
sudo mkdir Rasptendo
cd /opt/Rasptendo
script=halt_wake.py

if [ -e $script ];
	then
		echo "Script halt_wake.py already exists. Doing nothing."
	else
		wget "https://raw.githubusercontent.com/Argon40Tech/Super-Rasptendo-Case-Power-Switch/master/halt_wake.py"
fi
#-----------------------------------------------------------

#Step 6) Enable Python script to run on start up------------
cd /etc/
RC=rc.local

if grep -q "sudo python3 \/opt\/Rasptendo\/halt_wake.py \&" "$RC";
	then
		echo "File /etc/rc.local already configured. Doing nothing."
	else
		sed -i -e "s/^exit 0/sudo python3 \/opt\/Rasptendo\/halt_wake.py \&\n&/g" "$RC"
		echo "File /etc/rc.local configured."
fi
#-----------------------------------------------------------

#Step 7) Reboot to apply changes----------------------------
echo "RASPTENDO SNES Switch installation done. Will now reboot after 3 seconds."
sleep 3
sudo reboot
#-----------------------------------------------------------









