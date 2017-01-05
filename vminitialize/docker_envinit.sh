#!/bin/bash

### INSTALL PYTHON
su humax
sudo apt-get update ; sudo apt-get install python

### INSTALL DOCKER ENGINE
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main' -y
sudo apt-get update
sudo apt-get install docker-engine
sudo usermod -aG docker humax

### NOPASSWD SETTING
sudo sed -i '26d' /etc/sudoers
sudo sed -i '25a\\%sudo\tALL=(ALL:ALL) NOPASSWD:ALL' /etc/sudoers

### CONFIGURE DOCKER DAEMON
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo touch /etc/systemd/system/docker.service.d/docker.conf
echo -e "[Service]" >> /etc/systemd/system/docker.service.d/docker.conf
echo -e "ExecStart=" >> /etc/systemd/system/docker.service.d/docker.conf
echo -e "ExecStart=/usr/bin/docker daemon -H fd:// --insecure-registry 10.0.218.196:5000" >> /etc/systemd/system/docker.service.d/docker.conf

### RESTART DAEMON
sudo systemctl daemon-reload
sudo systemctl restart docker

### CONSOLE MENU DOWNLOAD
mkdir ~/docker
cd ~/docker
git clone https://github.com/dostroke/dockermenu.git .

### SETUP PROFILE
sudo echo "/home/humax/docker/consolemenu/vminteract.py" >> /etc/profile

### MAKE OUTPUT DIR
sudo mkdir /nfsroot
sudo mkdir /tftpboot
sudo chmod 777 /nfsroot
sudo chmod 777 /tftpboot

### COPY TOOLCHAINS
sudo apt-get update ; sudo apt-get install -y sshpass
sudo mkdir -p /opt/toolchains
sudo chmod 777 /opt/toolchains
cd /opt/toolchains
sshpass -p "humax12@!" scp -r humax@10.0.218.196:/opt/toolchains/* .

### INSTALL SAMBA
sudo apt-get update
sudo apt-get install -y samba samba-common python-glade2 system-config-samba

echo -e "DOCKER ENV INITIALIZE COMPLETE !"
