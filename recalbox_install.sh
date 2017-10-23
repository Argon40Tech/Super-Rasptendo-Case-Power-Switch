#!/bin/bash
#Step 1 make /boot writable---------------------------------
mount -o remount, rw /boot
mount -o remount, rw /

#Step 2) enable UART and system.power.switch----------------
File=/boot/config.txt
if grep -q "enable_uart=1" "$File";
	then
		echo "UART already enabled. Doing nothing."
	else
		echo "enable_uart=1" >> $File
		echo "UART enabled."
fi
if grep -q "^system.power.switch=PIN56PUSH*" "/recalbox/share/system/recalbox.conf";
	then
		echo "PIN56PUSH configuration already enabled."
	else
		echo "system.power.switch=PIN56PUSH" >> /recalbox/share/system/recalbox.conf
		echo "PIN56PUSH configuration enabled."
fi
#-----------------------------------------------------------



#Step 3) Download Python script-----------------------------
mkdir /opt/Rasptendo
script=/opt/Rasptendo/halt_wake.py

if [ -e $script ];
	then
		echo "Script halt_wake.py already exists. Doing nothing."
	else
		wget -O  $script "https://raw.githubusercontent.com/Argon40Tech/Super-Rasptendo-Case-Power-Switch/master/halt_wake_non_gpiozero.py"
fi
#-----------------------------------------------------------

#Step 4) Enable Python script to run on start up------------
DIR=/etc/init.d/S99Rasptendo

if grep -q "python $script &" "$S99Rasptendo";
	then
		if [ -x $DIR];
			then 
				echo "Executable S99Rasptendo already configured. Doing nothing."
			else
				chmod +x $DIR
		fi
	else
		echo "python $script m&" >> $DIR
		chmod +x $DIR
		echo "Executable S99Rasptendo configured."
fi
#-----------------------------------------------------------

#Step 5) Reboot to apply changes----------------------------
echo "RASPTENDO SNES Switch installation done. Will now reboot after 3 seconds."
sleep 3
reboot
#-----------------------------------------------------------
