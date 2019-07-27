#!/bin/sh

apt update
apt upgrade

# Assuming this is running on ubuntu server, as root
apt install -y \
	build-essential \
	make \
	git \
	neovim \
	zsh \
	mosh \
	docker.io

systemctl start docker
systemctl enable docker

adduser elm
usermod -aG sudo elm
chsh -s /bin/zsh elm

# setup rust

### ELM ###
su -u elm -c "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh && \
	cargo install lsd bat && \
	git clone https://github.com/ellmh/dotfiles && \
	cd dotfiles && ./install"


# finally add and pair krypton!

exit
###########

cp .ssh/authorized_keys /home/elm/.ssh
chown -R elm: /home/elm/.ssh/

apt-get install software-properties-common dirmngr apt-transport-https -y 
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C4A05888A1C4FA02E1566F859F2A29A569653940 
add-apt-repository "deb http://kryptco.github.io/deb kryptco main"
apt-get update 
apt-get install kr -y 

kr pair

# setup that firewall last thing
ufw allow 22
ufw allow 443
ufw allow 80
ufw allow 60000:61000/udp
ufw enable

reboot
