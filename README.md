# reverseSSH
Bash script to automate reverse SSH remote access device (RPi) to VPS configuration.

This script will prompt for user input, configure and copy keys, and create a cronjob to establish reverse callback at reboot..

Create a local copy of the script.

```wget https://raw.githubusercontent.com/Muppetpants/reverseSSH/main/setup.sh```

Make the script executable

```sudo chmod +x setup.sh```

# Important: Ensure the remote access device (RPi) is congfigured to automatically join the Internet (via LAN, WLAN). 

Run the script

```sudo ./setup.sh```

Add user input for ```Pi Username```
Add user input for ```Pi SSH Port```
Add user input for ```Pi SSH Reverse Port```
Add user input for ```VPS IPv4 Address```
Add user input for ```VPS SSH Port```
Add user input for ```VPS Username```

```Press enter if settings are correct. ```
