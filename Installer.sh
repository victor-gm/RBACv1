#!/bin/bash

#Fichero encargado de copiar y crear todas las estructuras necesarias de rbac
#También inicializa el montaje del disco

if [ "$EUID" -ne 0 ]
  then echo "Necesitas ejecutar este script con privilegios root."
  exit
fi

echo "Bienvenido a RBAC. Introduce el path donde se encuentran los scripts"
echo "Recuerda que todo archivo existente será sobrescrito"
read path
cd $path

#Procedemos a copiar todos los archivos

echo "Instalando todos los elementos necesarios...."

rm /var/lib/dpkg/lock
rm /var/cache/apt/archives/lock
#apt-get update 
#apt-get upgrade 
apt-get -qq --force-yes install ssmtp &>/dev/null
apt-get -qq --force-yes install sharutils &>/dev/null
apt-get -qq --force-yes install build-essential > /dev/null 2>&1
apt-get -qq --force-yes install default-jre python valgrind > /dev/null 2>&1

yes | cp -r etc/* /etc
yes | cp -r usr/bin/* /usr/bin
yes | cp -r  usr/sbin/* /usr/sbin


echo "Montando disco..."
bash /etc/fstabCreator.sh

echo "Leyendo las diferentes configuraciones de grupos y creando los grupos acordes.."
bash /etc/rbac/createGroups.sh
echo "Arrancando background..."
bash /etc/runBackground.sh
echo ">Arrancado<"
echo "Instalando softwrare necesario para el funcionamiento de rbac"
chmod 755 /etc/rbac/userEnvironment.sh

systemctl restart ssh
systemctl restart sshd