#!/bin/bash
sudo apt-get update -yq
sudo apt-get install vagrant -yq

# Add virtualbox.list to /etc/apt/sources.list.d
sudo touch /etc/apt/sources.list.d/virtualbox.list
echo 'deb http://download.virtualbox.org/virtualbox/debian stretch contrib' | sudo tee -a /etc/apt/sources.list.d/virtualbox.list > /dev/null

# Add Oracle PubKey
wget https://www.virtualbox.org/download/oracle_vbox_2016.asc
sudo apt-key add oracle_vbox_2016.asc
sudo apt-get update -yq
sudo apt-get install virtualbox-5.2 -yq

# Download and setup xud-box
sudo apt-get install git -yq
git clone https://github.com/ExchangeUnion/xud-box.git ~/xud-box
cd ~/xud-box || exit 1

# Create a VM inside a VM
./xud-box-up.sh
