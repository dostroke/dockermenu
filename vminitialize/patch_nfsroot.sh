#!/bin/bash

### Command by Sangjin Kim(sjkim5@humaxdigital.com)
### THIS COMMAND SHOULD RUN AFTER FINISH docker_envinit.sh

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

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
