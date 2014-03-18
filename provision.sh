# get root
sudo -s

# Pacakges
yum install -y unzip screen vim-enhanced

# Permissions
chown vagrant:vagrant /data/
chown vagrant:vagrant /opt/

# Disable services
chkconfig iptables off
chkconfig ip6tables off

/etc/init.d/iptables stop
/etc/init.d/ip6tables stop

# Server configuration

# ulimit
# and 
# stuff 
