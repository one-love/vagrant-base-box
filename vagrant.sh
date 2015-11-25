#!/bin/bash

SCRIPT_ROOT=$(dirname $0)
TEMP_PACKAGES="
    make
    linux-headers-3.16.0-4-all
"

cp $SCRIPT_ROOT/sources.list /etc/apt/
cp $SCRIPT_ROOT/virtualbox.list /etc/apt/sources.list.d
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add -
apt-get update
apt-get -y upgrade
apt-get install -y sudo
apt-get install -y $TEMP_PACKAGES
cp $SCRIPT_ROOT/sudoers /etc/
mkdir ~vagrant/.ssh
chmod 700 ~vagrant/.ssh
wget https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -O ~vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant ~vagrant/.ssh
chmod 600 ~vagrant/.ssh/authorized_keys
gpasswd -a vagrant sudo
apt-get clean
mount /dev/cdrom /mnt
/mnt/VBoxLinuxAdditions.run
umount /mnt
apt-get purge -y $TEMP_PACKAGES
apt-get autoremove -y --purge
