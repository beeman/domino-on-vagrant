#
# This script installs, configure and starts a IBM Domino server
#
# Copyright 2014 Bram Borggreve
# Distributed under the Apache License

#
# Do some checks before running
#
if [ ! -d /vagrant/data/linux64 ]; then
	echo "Error: Domino installer not found in /vagrant/data/linux64"
	echo "Please download Domino for xSeries Linux 64bit and make sure it's in the right location"
	exit 1
fi
if [ ! -f /vagrant/data/response.dat ]; then
	echo "Error: response.dat not found in /vagrant/data"
	exit 1
fi
if [ ! -f /vagrant/data/vagrant.pds ]; then
	echo "Error: vagrant.pds not found in /vagrant/data"
	exit 1
fi

#
# Install needed packages
#
sudo yum install -y glibc.i686 libgcc.i686 libstdc++.i686

#
# Set some OS limits
#
sudo ulimit -n 60000

echo "vagrant         soft    nofile          60000"  | sudo tee -a /etc/security/limits.conf
echo "vagrant         hard    nofile          80000"  | sudo tee -a /etc/security/limits.conf

#
# Run the installer
#
cd /vagrant/data/linux64/DominoEval/
sudo ./install -silent -options "/vagrant/data/response.dat"

#
# Copy and configure init script
#
# For more information on these scripts check http://www.nashcom.de/nshweb/pages/startscript.htm
#
sudo cp -rv /vagrant/scripts/rc_domino /etc/init.d/rc_domino
sudo chmod 755 /etc/init.d/rc_domino

sudo cp -rv /vagrant/scripts/rc_domino_script /opt/ibm/lotus/rc_domino_script
sudo chmod 755 /opt/ibm/lotus/rc_domino_script

sudo cp -rv /vagrant/scripts/rc_domino_config_vagrant /etc/sysconfig/rc_domino_config_vagrant

#
# Enable the init script
#
sudo chkconfig --add rc_domino

#
# Configure the Domino server if there is no names.nsf
#
if [ ! -f /local/notesdata/names.nsf ]; then
	cd /local/notesdata/
	sudo -u vagrant /opt/ibm/lotus/bin/server -silent /vagrant/data/vagrant.pds
fi

#
# Start the Domino server
#
sudo /etc/init.d/rc_domino start

#
# Start the monitor
#
sudo /etc/init.d/rc_domino monitor
#
