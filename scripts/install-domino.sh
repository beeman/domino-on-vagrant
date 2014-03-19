# This script will try to automatically install and configure a IBM Domino server
# 
# Bram Borggreve (c) 2014
# Distributed under the Apache License

# Do some checks before running
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

# Install needed packages
sudo yum install -y glibc.i686 libgcc.i686 libstdc++.i686

# Set some OS limits
ulimit -n 60000 

echo "vagrant         soft    nofile          60000"  >> /etc/security/limits.conf 
echo "vagrant         hard    nofile          80000"  >> /etc/security/limits.conf 

# Run the installer
cd /vagrant/data/linux64/DominoEval/
sudo ./install -silent -options "/vagrant/data/response.dat"

# Configure the Domino server
# cd /opt/ibm/lotus/
# sudo ./server TODO "/vagrant/data/vagrant.pds"

# Copy and configure init script
cp -rv /vagrant/scripts/rc_domino /etc/init.d/rc_domino
chmod 755 /etc/init.d/rc_domino

cp -rv /vagrant/scripts/rc_domino_script /opt/ibm/lotus/rc_domino_script
chmod 755 /opt/ibm/lotus/rc_domino_script

# Enable the init script
chkconfig --add rc_domino 
