#!/bin/sh

apt update
apt upgrade

# Assuming this is running on ubuntu server, as root
apt install \
	build-essential \
	git \
	nvim \
	zsh \
	docker.io

systemctl start docker
systemctl enable docker

adduser elm
usermod -aG sudo elm
chsh -s /bin/zsh elm

su elm

git clone https://github.com/ellmh/dotfiles

cd dotfiles

make

# finally add and pair krypton!

exit

apt-get install software-properties-common dirmngr apt-transport-https -y 
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C4A05888A1C4FA02E1566F859F2A29A569653940 
add-apt-repository "deb http://kryptco.github.io/deb kryptco main"
apt-get update 
apt-get install kr -y 

reboot
