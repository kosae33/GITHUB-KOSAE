rm /etc/resolv.conf

echo Quel domaine ?
read domain

echo retaper le domaine sans extension?
read domainsans

echo search $domain >> /etc/resolv.conf
echo nameserver 127.0.0.1 >> /etc/resolv.conf

rm /etc/hostname

echo Quel hostname ?
read hostname

echo $hostname >> /etc/hostname

rm /etc/network/interfaces

echo CONFIG IP

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

rm /etc/hosts

echo 127.0.0.1       localhost >> /etc/hosts
echo 127.0.1.1       $hostname.$domain $hostname >> /etc/hosts

echo ::1     localhost ip6-localhost ip6-loopback >> /etc/hosts
echo ff02::1 ip6-allnodes >> /etc/hosts
echo ff02::2 ip6-allrouters >> /etc/hosts

echo INSTALATION SAMBA

apt-get install samba winbind libnss-winbind krb5-user smbclient ldb-tools python3-crypto

domain=${domain^^}

echo [libdefaults] >> /etc/krb5.conf
echo default_realm = $domain >> /etc/krb5.conf
echo dns_lookup_kdc = true >> /etc/krb5.conf
echo dns_lookup_realm = false >> /etc/krb5.conf



rm -f /etc/samba/smb.conf

samba-tool domain provision --realm=$domain --domain ${domainsans^^} --server-role=dc

samba-tool user setpassword administrator

rm -f /var/lib/samba/private/krb5.conf
ln -s /etc/krb5.conf /var/lib/samba/private/krb5.conf

systemctl unmask samba-ad-dc
systemctl enable samba-ad-dc
systemctl disable samba winbind nmbd smbd
systemctl mask samba winbind nmbd smbd

kinit administrator


