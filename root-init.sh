#!/bin/bash
USERNAME=$1
PASSWORD=$2
# Create user
adduser --disabled-password --gecos "" "$USERNAME"
echo "$USERNAME:$PASSWORD" | chpasswd
# Add to sudoers
usermod -aG sudo "$USERNAME"
# Do not require password for sudo
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
# Add authorized keys to user
mkdir /home/"$USERNAME"/.ssh
cp /root/.ssh/authorized_keys /home/"$USERNAME"/.ssh/authorized_keys
chown "$USERNAME":"$USERNAME" /home/"$USERNAME"/.ssh/authorized_keys
