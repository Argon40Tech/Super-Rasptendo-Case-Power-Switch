# RASPTENDO Case with SNES inspired Power and Reset Buttons

**RASPTENDO Case** is an SNES inspired enclosure for your Raspberry Pi 3. Esthetically, the case seamlessly aligns with the retro themed RetroPie game station OS. The **RASPTENDO case** includes a built-in ***POWER*** and ***RESET*** buttons, and a ***Status LED*** to signal power status. The section below provides a step by step guide on how to make it work.


## Getting Started

The **RASPTENDO POWER button** safely switches off your Raspberry Pi 3 to avoid corrupting your SD card when you cut off the power supply. The button is programmed to be held for a second before executing the *shutdown* command to prevent accidental power off.

The jumper wires of the **RASPTENDO POWER button** must be connected to *GPIO03 or Pin 5* to "wake" the Raspberry Pi 3 when in halt/shutdown state<a href="#note1"><sup>[1]</sup></a>.

**There are two options to configure the Rasptendo SNES case:**
1. *OPTION 1:* Executing a one line bash script in the terminal
2. *OPTION 2:* Editing configuration files and running a python script on startup in the terminal

**Option 1** is the simplest way to install necessary software for your Rasptendo case. The script automatically configures your RetroPie for the **RASPTENDO POWER button** to work.

The **RASPTENDO RESET button** works by forcing a restart of your Raspberry pi 3 at any given time. The jumper wires of the **RASPTENDO RESET button** is to be soldered to the *P6 Pins*, which is labeled *RUN* on your Raspberry pi 3 Board, to issue a hardware reset<a href="#note2"><sup>[2]</sup></a>.

Incidentally it can also be used to "wake" the Pi from halt/shutdown state. The **RASPTENDO RESET button** should only be used when really necessary (e.g. *your pi freezed*), as it may corrupt your SD card if the OS is writing on it when you trigger the button.

<table>
<tr><th>POWER Button</th><th>RESET Button</th></tr>
<tr><td>
      
| Current State | Action             | Function               | 
|---------------|--------------------|------------------------|
| ON            | long press         | soft shutdown          |
| ON            | short press (<1 s) | nothing                |
| SLEEP         | short/long press   | wakes Pi               |

</td><td>

| Current State | Action             | Function               |
|---------------|--------------------|------------------------|
| ON            | short/long press   | hard reboot            |
| SLEEP         | short/long press   | wakes Pi               |

</td></tr> </table>


## Prerequisites
1. RetroPie

      To install Retropie you may download the image for [Raspberry Pi 3](https://github.com/RetroPie/RetroPie-Setup/releases/download/4.2/retropie-4.2-rpi2_rpi3.img.gz "RetroPie for version RPi 2/3") and follow installation instruction at the [Argon40 website](https://www.argon40.com/resources/install-retropie-in-raspberry-pi-3-and-play-your-first-retro-game/ "RetroPie installation instructions").

2. Internet connection

      To set up your internet via WiFi, you can follow instructions [here](https://www.argon40.com/resources/how-to-enable-your-raspberry-pi-3-wifi-via-terminal/ "RetroPie WiFi Setup").

3. Keyboard and screen, or any computer/laptop (via SSH)

      To access your Pi via SSH, you can also follow instructions [here](https://www.argon40.com/resources/how-to-enable-ssh-in-your-raspberry-pi-3/ "Raspberry Pi SSH Setup").

4. Rasptendo SNES Case

      You may purchase from the link [here](https://www.argon40.com "Rasptendo SNES Case").

## Installation
(**NOTE**: This assumes that you have already connected the jumper wires to the correct PINS and ports.
It's very important to follow the right pin configuration to prevent damage to your Pi.
If you haven't, you can follow the instructions [here.](http://www.argon40.com/resources/setting-up-your-rasptendo-case/))

This instruction is a *step-by-step guide* to install necessary software for your **RASPTENDO Case**.
You can setup this via SSH or using the command line interface in your RetroPie. To enter the command line interface of RetroPie, *PRESS* ***F4*** just after booting up.

----------
### Option 1: via Bash
Open your terminal and type the one-line installation command below:
```bash
$ wget -O - "https://raw.githubusercontent.com/Argon40Tech/Super-Rasptendo-Case-Power-Switch/master/install.sh" | sudo bash
```
The script will automatically install pertinent files and configure your Raspberry Pi to enable **RASPTENDO POWER Button.**
Installation will automatically reboot once all processes are completed.

### Testing the buttons
After rebooting, your **RASPTENDO Case Buttons** are now fully functional. To test if your buttons work, try holding the **POWER button**. The status LED should start blinking and if you held the button for a second, your Raspberry Pi should shutdown. To "wake" it up, you can press the **POWER button** again.

----------

### Option 2: Installing manually
Open your terminal and follow instructions below.

#### Step 1 - Enabling UART
The **Status LED** should be connected to the GPIO 14 or PIN 8 serial port so make sure it is enabled.
In your terminal, type:

```bash
$ sudo nano /boot/config.txt
```
Check if UART is already enabled by searching for a line at the ```config.txt``` with
```
enable_uart=1
```
if it's not, add that line at the bottom. Save the file by typing CTRL + X, hit Y, then Enter.

#### Step 2 - Update your repository
Type
```bash
$ sudo apt-get update
```
to make sure your list of packages and PPA's is up to date.

#### Step 3 - Install the GPIOZero module
In order for the **POWER button** to work, you have to install GPIOZero.
```bash
$ sudo apt-get install python3-gpiozero
```
If you want to know more about GPIOZero, you can read the [official documentation](https://gpiozero.readthedocs.io/en/stable/ "gpiozero documentation").

#### Step 4 - Set up the python script
Change to the ```/opt/``` directory
```bash
$ cd /opt/
```
and create a directory for the script,
```bash
$ sudo mkdir Rasptendo
```
Change to the newly created directory and download the python script using ```wget```.
```bash
$ cd /opt/Rasptendo
$ wget "https://raw.githubusercontent.com/Argon40Tech/Super-Rasptendo-Case-Power-Switch/master/halt_wake.py"
```

#### Step 5 - Enable the python script to run on background every start up
In order for the script to run on every boot up, you have to add a command in ```/etc/rc.local```.
```bash
$ sudo nano /etc/rc.local
```
Before the line,
```
exit 0
```
add the following command,
```
sudo python3 /opt/Rasptendo/halt_wake.py
```
Save the file by typing CTRL + X, hit Y, then Enter.

#### Step 6 - Reboot to apply changes
```bash
$ sudo reboot
```

### Testing the buttons
After rebooting, your **RASPTENDO Case Buttons** are now fully functional. To test if your buttons work, try holding the **POWER button**. The status LED should start blinking and if you held the button for a second, your Raspberry Pi should shutdown. To "wake" it up, you can press the **POWER button** again.

## Notes
<a id="note1" href="#note1">[1]</a>: [Wake from halt](https://www.raspberrypi.org/forums/viewtopic.php?f=29&t=24682 "raspberrypi.org")

<a id="note2" href="#note2">[2]</a>: [P6 Pinout - RPi Low Level Peripherals](http://elinux.org/RPi_Low-level_peripherals#P6_header "elinux.org")

