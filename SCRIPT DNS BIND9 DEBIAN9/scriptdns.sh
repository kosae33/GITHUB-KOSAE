rm /etc/resolv.conf

echo Quel domain ?
read domain

echo domain $domain >> /etc/resolv.conf

echo Quel search ?
read search

echo search $search >> /etc/resolv.conf

echo Combien de nameserver ?
read nbnameserver
for i in `seq 1 $nbnameserver`;
do
	echo Quelle ip nameserver ?
	read ipnameserver
    
    echo nameserver $ipnameserver >> /etc/resolv.conf
done

rm /etc/hostname

echo Quel hostname ?
read hostname

echo $hostname >> /etc/hostname

rm /etc/hosts

echo 127.0.0.1       localhost >> /etc/hosts
echo 127.0.1.1       $hostname.$domain $hostname >> /etc/hosts

echo ::1     localhost ip6-localhost ip6-loopback >> /etc/hosts
echo ff02::1 ip6-allnodes >> /etc/hosts
echo ff02::2 ip6-allrouters >> /etc/hosts

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

apt install bind9

rm /etc/bind/named.conf.local

echo "zone "\"$domain\"" { " >> /etc/bind/named.conf.local
echo	"type master; " >> /etc/bind/named.conf.local
echo	"file "\"/etc/bind/$domain\""; }; " >> /etc/bind/named.conf.local


echo "$domain.  IN  SOA  $hostname.$domain. root.$domain. ( ">> /etc/bind/$domain
echo "                1   ; Serial ">> /etc/bind/$domain
echo "           604800   ; Refresh ">> /etc/bind/$domain
echo "            86400   ; Retry ">> /etc/bind/$domain
echo "         2419200   ; Expire ">> /etc/bind/$domain
echo  "          604800 ) ; Negative Cache TTL ">> /etc/bind/$domain

echo $domain.  IN  NS  $hostname.$domain. >> /etc/bind/$domain

echo www.$domain.         IN A         $gateway >> /etc/bind/$domain
echo $hostname.$domain.       IN A         $ip >> /etc/bind/$domain


/etc/init.d/bind9 start
/etc/init.d/bind9 restart

systemctl restart networking.service

reboot