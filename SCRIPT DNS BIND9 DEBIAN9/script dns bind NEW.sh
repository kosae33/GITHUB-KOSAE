rm /etc/resolv.conf

echo Quel domaine ? exemple : domaine.fr
read domain

echo domain $domain >> /etc/resolv.conf
echo search $domain >> /etc/resolv.conf

echo Combien de nameserver ?
read nbnameserver
for i in `seq 1 $nbnameserver`;
do
	echo Quelle ip nameserver ? exemple : 127.0.0.1 ou ip serv
	read ipnameserver
    
    echo nameserver $ipnameserver >> /etc/resolv.conf
done

rm /etc/hostname

echo Quel hostname ? exemple : hostname => hostname.domaine.fr
read hostname

echo $hostname >> /etc/hostname

apt install bind9

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
echo	"file "\"/var/cache/bind/$domain\""; }; " >> /etc/bind/named.conf.local


echo "$domain.  IN  SOA  $hostname.$domain. root.$domain. ( ">> /var/cache/bind/$domain
echo "                1   ; Serial ">> /var/cache/bind/$domain
echo "           604800   ; Refresh ">> /var/cache/bind/$domain
echo "            86400   ; Retry ">> /var/cache/bind/$domain
echo "         2419200   ; Expire ">> /var/cache/bind/$domain
echo  "          604800 ) ; Negative Cache TTL ">> /var/cache/bind/$domain

echo $domain.  IN  NS  $hostname.$domain. >> /var/cache/bind/$domain

echo www.$domain.         IN A         $gateway >> /var/cache/bind/$domain
echo $hostname.$domain.       IN A         $ip >> /var/cache/bind/$domain


/etc/init.d/bind9 start
/etc/init.d/bind9 restart

systemctl restart networking.service

reboot
