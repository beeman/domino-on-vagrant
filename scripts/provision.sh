#
# This script installs, configure and starts a IBM Domino server
#
# Copyright 2014 Bram Borggreve
# Distributed under the Apache License

#
# get root
#
sudo -s

#
# Pacakges
#
yum install -y unzip ntp

#
# Permissions
#
chown vagrant:vagrant /local/

#
# Disable firewall
#
chkconfig iptables off
/etc/init.d/iptables stop

chkconfig ip6tables off
/etc/init.d/ip6tables stop

#
# Configure NTP
#
ntpdate pool.ntp.org
chkconfig ntpd on
service ntpd start

#
# Install Domino
#
/vagrant/scripts/install-domino.sh
