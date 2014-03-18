# Install needed packages
# sudo yum install glibc.i686 libgcc.i686 libstdc++.i686

# Run the installer
cd /data/linux64/DominoEval/
sudo ./install -silent # -options "/data/response.dat" -silent 

# Copy and configure init script
cp -rv /vagrant/scripts/domino-init-script /etc/init.d/domino
chmod +x /etc/init.d/domino
ln -sv /etc/init.d/domino /etc/rc0.d/K10domino 
ln -sv /etc/init.d/domino /etc/rc2.d/S99domino 
ln -sv /etc/init.d/domino /etc/rc3.d/S99domino 

