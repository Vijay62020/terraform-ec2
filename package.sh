#! /bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt install nfs-kernel-server git -y
sudo useradd -s /bin/bash -d /home/sendserv/ -m -G sudo sendserv

sudo usermod -aG admin sendserv

sudo mkdir /home/sendserv/public_html
sudo chown sendserv.sendserv /home/sendserv/public_html
sudo chmod 2775 /home/sendserv/public_html

sudo mkdir /home/sendserv/logs
sudo chown sendserv.sendserv home/sendserv/logs
sudo chmod 2775 home/sendserv/logs

echo "172.22.7.168: /
 /home/sendserv/public_html nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 0" >> /etc/fstab
sudo mount -a

sudo apt-get install software-properties-common python-software-properties -y
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get update -y

sudo apt-get install php7.2 php7.2-cli php7.2-common -y
sudo apt-get install php7.2-imagick php7.2-mailparse php7.2-sqlite php7.2-gearman php7.2-tidy php7.2-xmlrpc php7.2-soap php7.2-mongodb php7.2-imap php7.2-bz2 php7.2-bcmath php7.2-curl php7.2-gd php7.2-json php7.2-mbstring php7.2-intl php7.2-mysql php7.2-xml php7.2-zip -y

sudo apt install supervisor -y

