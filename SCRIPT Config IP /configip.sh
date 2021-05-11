rm /etc/network/interfaces

echo Quelle ip ?
read ip
echo Quelle Gateway ?
read gateway

echo source /etc/network/interfaces.d/* >> /etc/network/interfaces
echo auto lo >> /etc/network/interfaces
echo iface lo inet loopback >> /etc/network/interfaces
echo allow-hotplug enp0s3 >> /etc/network/interfaces
echo auto enp0s3 >> /etc/network/interfaces
echo iface enp0s3 inet static >> /etc/network/interfaces
echo address $ip >> /etc/network/interfaces
echo gateway $gateway >> /etc/network/interfaces