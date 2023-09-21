#!/bin/bash

#Description: Run script on a pi to create a VPS (deb/ubuntu) callback through SSH

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
rm /home/$piUser/jumpbox.sh 2> /dev/null
rm /home/$piUser/.ssh/piTO$vpsIP 2> /dev/null
rm /home/$PiUser/.ssh/piTO$vpsIP.pub 2> /dev/null



#Keygen and distro
ssh-keygen -t ecdsa -b 384 -f /home/$piUser/.ssh/piTO$vpsIP -q -N ""
ssh-copy-id -i /home/$piUser/.ssh/piTO$vpsIP.pub -p $vpsPort $vpsUser@$vpsIP
# Will be prompted for VPS authentication 

sleep 1

#Create startup script with RevSSH vars
echo "ssh -fN -R $piRevPort:localhost:$piPort $vpsUser@$vpsIP -p $vpsPort -i /home/$piUser/.ssh/piTO$vpsIP">> /home/$piUser/jumpbox.sh
chmod +x /home/$piUser/jumpbox.sh

#Create cronjob to start tunnel at reboot
sudo sh -c  "echo @reboot $piUser sleep 90 \&\& bash /home/$piUser/jumpbox.sh > /etc/cron.d/cronjob"
sudo sh -c "chmod 0644 /etc/cron.d/cronjob"


#Ensure new key works and provides remote access
echo "######################## Test cert and gain access ########################"
echo "[1] Test access: ssh $vpsUser@$vpsIP -p $vpsPort -i /home/$piUser/.ssh/piTO$vpsIP"
echo "[2] Reboot pi: sudo reboot"
echo "[3] From VPS, run: ssh $piUser@localhost -p $piRevPort  #Use $piUser password."
