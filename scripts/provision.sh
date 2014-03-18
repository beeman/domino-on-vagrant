# get root
sudo -s

# Pacakges
yum install -y unzip ntp

# Permissions
chown vagrant:vagrant /data/
chown vagrant:vagrant /opt/

# Disable services
chkconfig iptables off
chkconfig ip6tables off

/etc/init.d/iptables stop
/etc/init.d/ip6tables stop

# Server configuration


# NTP
ntpdate pool.ntp.org
chkconfig ntpd on
service ntpd start


# rpm -ivH http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm 


# Set limits
ulimit -n 20000 

echo "vagrant         soft    nofile          65535"  >> /etc/security/limits.conf 
echo "vagrant         hard    nofile          65535 "  >> /etc/security/limits.conf 

# Install Domino 
cd /vagrant/scripts/
./install-domino.sh
