# Script d'install docker et ajout de conteneurs
# Fonctionne sur Debian 10 ET 11 !

#by loris et dorian


if [ ! -e /etc/loris-utilitaires ]
then
	mkdir /etc/loris-utilitaires
fi

echo "Voulez-vous installer docker (1) ou créer un conteneur (2) ?"
read choix

case $choix in

        [1]* ) choix="1";;
        [2]* ) choix="2";;
        * ) echo "Erreur réponse, veuillez relancer le script...";;
esac


if [ $choix = "1" ]
	then 
	
	echo ""
	echo "Installation de docker !"
	echo ""
	
	# Mise à jour de la machine 
	apt update -y
	apt upgrade -y

	# Installation des services nécessaires

	apt install curl -y

	apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y

	curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add -

	add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"

	apt update -y

	apt install docker-ce -y

	# Activation docker

	systemctl enable docker

	echo "Quel est le login utilisateur à attribuer pour utiliser docker ?"
	read login

	addgroup $login docker

	echo "Veuillez vous reconnecter avec $login pour continuer à travailler avec docker"
	echo ""
	echo "Pour créer un conteneur, redémarrer la machine et lancer le script adéquat"
	echo ""
	echo ""


fi

if [ $choix = "2" ]
	then 
	
	# Téléchargement de l'image
	
	echo ""
	echo "Création d'un conteneur !"
	echo ""
	
	echo "Quel version d'image souhaitez vous ? :"
	echo "	- Debian (le plus récent) (1)"
	echo "	- Ubuntu (le plus récent) (2)"
	echo "	- Autre (Susceptible de ne pas fonctionner) (3)"
	echo "	- Je possède déjà mon image (4)"
	read "version"
	
	
	case $version in

        [1]* ) docker pull debian;;
        [2]* ) docker pull ubuntu;;
        [3]* ) echo "Entrer le nom de l'image à installer" && echo "" && read version2 && echo "" && docker pull $version2;;
		[4]* ) echo "" && echo "Entrer le nom de cette image" && read version2;;
		* ) echo "erreur réponse";;
	esac
	
	# Création du docker à partir de l'image

	echo "Quel nom attribuer au docker ?"
	read name
	
	echo "Quel port le docker doit il écouter ?"
	read port1
	
	echo "Quel port la machine doit renvoyer sur le docker ?"
	read port2
	

# Recupération du nom de l'interface ethernet
ip link | awk -F: '$0 !~ "lo|vir|^[^0-9]"{print $2a;getline}' >> /etc/loris-utilitaires/interfaces.txt
grep 'enp' /etc/loris-utilitaires/interfaces.txt >> /etc/loris-utilitaires/temp1.txt
nic=`cat /etc/loris-utilitaires/temp1.txt`

# Récupération de l'ip
ip -f inet -o addr show enp0s3 | cut -d\  -f 7 | cut -d/ -f 1 >> /etc/loris-utilitaires/temp2.txt
ip=`cat /etc/loris-utilitaires/temp2.txt`

rm /etc/loris-utilitaires/temp*
rm /etc/loris-utilitaires/interfaces.txt


	case $version in

        [1]* ) version2="debian";;
        [2]* ) version2="ubuntu";;
        [3]* ) echo "";;
		[4]* ) echo "";;
		* ) echo "";;
	esac
	
	docker run -d -p $ip:$port2:$port1 --name $name -it $version2 
	docker start  $name 
read -p "Voulez-vous prendre le docker en cli ?" on
    case $on in
        [Oo]* ) docker exec -it $name /bin/bash;;
        [Nn]* ) exit;;
        * ) echo "Par pitié Yes ou No";;
    esac
	
echo ""
echo "Le docker est créer bravo !"
echo ""
echo ""
echo ""

fi

# Merci 
