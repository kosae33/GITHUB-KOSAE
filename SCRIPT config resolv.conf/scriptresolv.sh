rm /etc/resolv.conf

echo Quel domaine ?
read domain

echo domain $domain >> /etc/resolv.conf
echo search $domain >> /etc/resolv.conf

echo Combien de nameserver ?
read nbnameserver
for i in `seq 1 $nbnameserver`;
do
	echo Quelle ip nameserver ?
	read ipnameserver
    
    echo nameserver $ipnameserver >> /etc/resolv.conf
done