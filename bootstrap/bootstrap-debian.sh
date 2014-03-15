export PWD=`pwd`

# set up DNS (#smh @ Debian)
echo "nameserver 8.8.8.8
domain us-west-1.compute.internal
search us-west-1.compute.internal" | tee /etc/resolv.conf

# update packages
apt-get -y update

# install server software
apt-get -y install openvpn git nginx python-setuptools

# get python in order
easy_install pip

# pull WH software
git clone https://github.com/sbma44/wormhole.git $PWD/wormhole
git clone https://github.com/sbma44/terok_nor.git $PWD/terok_nor

# install python packages
pip install -r $PWD/terok_nor/requirements.txt

# install openvpn server config
# (should already be configured to autostart)
mkdir /etc/openvpn/easy-rsa
cp $PWD/wormhole/openvpn/* /etc/openvpn/easy-rsa
cp $PWD/wormhole/openvpn/client.conf /etc/openvpn/client.conf # for debugging
cp $PWD/terok_nor/bootstrap/openvpn/server.conf /etc/openvpn/server.conf

# IP forwarding
echo 1 | tee /proc/sys/net/ipv4/ip_forward
echo "net.ipv4.ip_forward=1" | tee -a /etc/sysctl.conf

# iptables
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
iptables-save | tee /etc/iptables.up.rules
cp $PWD/bootstrap/iptables /etc/network/if-pre-up.d/iptables
chmod +x /etc/network/if-pre-up.d/iptables

# give it all a kick
service openvpn stop
service openvpn start

