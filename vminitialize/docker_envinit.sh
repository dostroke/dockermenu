#!/bin/bash

### Command by Sangjin Kim(sjkim5@humaxdigital.com)
### PATCH VER: v1.1 (2017.2.22)

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

### INSTALL PYTHON
#su humax
sudo apt-get update ; sudo apt-get install -y python

### INSTALL DOCKER ENGINE
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main' -y
sudo apt-get update
sudo apt-get install -y docker-engine
sudo usermod -aG docker humax

### NOPASSWD SETTING
sudo sed -i '26a\\%sudo\tALL=(ALL:ALL) NOPASSWD:ALL' /etc/sudoers
sudo sed -i '26d' /etc/sudoers

### CONFIGURE DOCKER DAEMON
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo touch /etc/systemd/system/docker.service.d/docker.conf
sudo bash -c 'echo -e "[Service]" >> /etc/systemd/system/docker.service.d/docker.conf'
sudo bash -c 'echo -e "ExecStart=" >> /etc/systemd/system/docker.service.d/docker.conf'
sudo bash -c 'echo -e "ExecStart=/usr/bin/docker daemon -H fd:// --insecure-registry 10.0.218.195:5000" >> /etc/systemd/system/docker.service.d/docker.conf'

### RESTART DAEMON
sudo systemctl daemon-reload
sudo systemctl restart docker

### CONSOLE MENU DOWNLOAD
mkdir ~/docker
cd ~/docker
git clone https://github.com/dostroke/dockermenu.git .

### SETUP PROFILE
sudo bash -c 'echo "/home/humax/docker/consolemenu/vminteract.py" >> /etc/profile'

### MAKE OUTPUT DIR
sudo mkdir /nfsroot
sudo mkdir /tftpboot
sudo chmod 777 /nfsroot
sudo chmod 777 /tftpboot

### COPY TOOLCHAINS
while readline
do
	wget http://10.0.14.206/files/cis/compilers/$line
done < toolchains.txt

### INSTALL SAMBA
sudo apt-get update
sudo apt-get install -y samba samba-common python-glade2 system-config-samba

### INSTALL NFS/TFTP
echo -e "${GREEN} ### INSTALL NFSROOT ${NC}"
sudo apt-get update ; sudo apt-get install -y nfs-common nfs-kernel-server portmap

echo -e "${GREEN} ### ADD CONFIGURATION OF NFS ${NC}"
sudo echo -e "/nfsroot\t*(rw,no_root_squash,async,no_subtree_check)" >> /etc/exports

echo -e "${GREEN} ### RESTART NFS KERNEL SERVER ${NC}"
sudo /etc/init.d/nfs-kernel-server restart

echo -e "${GREEN} ### INSTALL TFTP ${NC}"
sudo apt-get install -y tftp tftpd xinetd

echo -e "${GREEN} ### ADD CONFIGURATION OF TFTP ${NC}"
sudo mkdir -p /etc/xinetd.d
sudo touch /etc/xinetd.d/tftp
sudo bash -c 'echo -e "service tftp" >> /etc/xinetd.d/tftp'
sudo bash -c 'echo -e "{" >> /etc/xinetd.d/tftp'
sudo bash -c 'echo -e "protocol\t= udp" >> /etc/xinetd.d/tftp'
sudo bash -c 'echo -e "port\t\t= 69" >> /etc/xinetd.d/tftp'
sudo bash -c 'echo -e "socket_type\t= dgram" >> /etc/xinetd.d/tftp'
sudo bash -c 'echo -e "wait\t\t= yes" >> /etc/xinetd.d/tftp'
sudo bash -c 'echo -e "user\t\t= nobody" >> /etc/xinetd.d/tftp'
sudo bash -c 'echo -e "server\t\t= /usr/sbin/in.tftpd" >> /etc/xinetd.d/tftp'
sudo bash -c 'echo -e "server_args\t= /tftpboot" >> /etc/xinetd.d/tftp'
sudo bash -c 'echo -e "disable\t\t= no" >> /etc/xinetd.d/tftp'
sudo bash -c 'echo -e "}" >> /etc/xinetd.d/tftp'

echo -e "${GREEN} RESTART XINET DAEMON ${NC}"
sudo service xinetd restart

echo -e "DOCKER ENV INITIALIZE COMPLETE !"
