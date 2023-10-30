#!/bin/bash

#Description: Run script on a pi to create a VPS (deb/ubuntu) callback through SSH

clear
# Checks to verify that the script is not running as root
if [[ $EUID -eq 0 ]]; then
   echo "THIS SCRIPT SHOULD NOT BE RUN AS ROOT."
   echo "EX:  ./setup.sh"
   exit 1
fi

read -p "Pi Username (case-sensitive): " piUser
read -p "Pi SSH Port: " piPort
read -p "Pi Reverse Port: " piRevPort
read -p "VPS IPv4 Address: " vpsIP
read -p "VPS SSH Port: " vpsPort
read -p "VPS Username: " vpsUser
echo ""
#Confirmation of input
echo "Pi Username: $piUser"
echo "Pi SSH Port:  $piPort" 
echo "Pi Reverse Port:  $piRevPort"
echo "VPS IPv4 Address: $vpsIP"
echo "VPS SSH Port:  $vpsPort"
echo "VPS Username:  $vpsUser"
echo ""
read -n 1 -r -s -p $'Press enter to continue if the values above are correct. Otherwise "Ctrl + c" to reenter...\n'


#Cleanup
rm /home/$piUser/.ssh/piTO$vpsIP 2> /dev/null
rm /home/$PiUser/.ssh/piTO$vpsIP.pub 2> /dev/null
sudo sh -c  "rm /etc/cron.d/revSSHcronjob"



#Keygen and distro
ssh-keygen -t ecdsa -b 384 -f /home/$piUser/.ssh/piTO$vpsIP -q -N ""
ssh-copy-id -i /home/$piUser/.ssh/piTO$vpsIP.pub -p $vpsPort $vpsUser@$vpsIP
# Will be prompted for VPS authentication 
sleep 1

#Create cronjob to start tunnel at reboot
sudo sh -c  "echo @reboot $piUser sleep 90 \&\& ssh -fN -R $piRevPort:localhost:$piPort $vpsUser@$vpsIP -p $vpsPort -i /home/$piUser/.ssh/piTO$vpsIP > /etc/cron.d/revSSHcronjob"
sudo sh -c "chmod 0644 /etc/cron.d/revSSHcronjob"


#Ensure new key works and provides remote access
echo "######################## Test cert and gain access ########################"
echo "[1] Test access. Run: ssh $vpsUser@$vpsIP -p $vpsPort -i /home/$piUser/.ssh/piTO$vpsIP"
echo "[2] Reboot pi. Run: sudo reboot"
echo "[3] Login to VPS, then access Pi. Run: ssh $piUser@localhost -p $piRevPort"
