# get root
sudo -s

# Pacakges
yum install -y unzip ntp

# Permissions
chown vagrant:vagrant /local/

# Disable services
chkconfig iptables off
chkconfig ip6tables off

/etc/init.d/iptables stop
/etc/init.d/ip6tables stop

# Configure NTP
ntpdate pool.ntp.org
chkconfig ntpd on
service ntpd start

# Install Domino
# /vagrant/scripts/install-domino.sh
