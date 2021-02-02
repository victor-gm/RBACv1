#!/bin/bash

#Archivo que crea el entorno del usuario, añadiendo los programas que le corresponden


function deleteHome()
{
	#obtenemos la fecha de eliminicacion
	date=`date --date=" +$home day" +"%d-%m"`
	day=`echo $date | awk -F [-] '{print $1}'`
	month=`echo $date | awk -F [-] '{print $2}'`

	#progamamos la eliminiación de la home
	crontab -l | { cat; echo "0 0 $day $month * /etc/rbac/delete.sh $enviroment/home" ; } | crontab -

}

function deleteEnvironment()
{
	#obtenemos la fecha de eliminicacion
	date=`date --date="+ "$entorno" day" +"%d-%m"`
	day=`echo $date | awk -F '-' '{print $1}'`
	month=`echo $date | awk -F '-' '{print $2}'`
	#progamamos la eliminiación de la home
	crontab -l | { cat; echo "0 0 $day $month * /etc/rbac/delete.sh $enviroment" ; } | crontab -

}
user="$PAM_USER"

if [ -z $user ]
then
	user=$1
fi
echo "Creando entorno.."

#Miramos el grupo al que pertenece
#rol=$(echo `groups | awk -F " " '{print $1}'`)
#cho "rol = $rol"
rol=$(echo `groups "$user"` | awk -F " "  '{print $3}')
#rol=$(echo $aux | sed 's/ //g')

#Definimos el entorno
enviroment="/users/${rol}/${user}"

#Leemos el archivo de configuracion
FILE=/etc/rbac/roles/$rol.conf
comandos=$(sed -n '2p' < "$FILE" | awk -F [-] '{print $2}')

# Obtenemos la persistencia de los datos
home=$(sed -n '3p' < "$FILE" | awk -F [-] '{print $2}')
entorno=$(sed -n '4p' < "$FILE" | awk -F [-] '{print $2}')
#Si no son persistentes, programar su eliminación
if [ "$home" != 'P' ];then
	deleteHome
fi 

if [ "$entorno" != 'P' ];then
	deleteEnvironment
fi 

#Creamos los directorios necesarios
sudo mkdir -p ${enviroment}/{lib,bin,sbin,lib64,dev,proc,etc,usr} ${enviroment}/usr/{bin,sbin,lib}

#Creamos su carpeta Home y lo añadimos en el grupo
sudo mkdir -p $enviroment/home/$user
sudo cp -r /etc/skel/. "$enviroment/home/$user"
sudo chown -R "$user" "$enviroment/home/${user}"
sudo chgrp -R $rol "$enviroment/home/${user}"
sudo gpasswd -A "$user" $rol
#Copiamos archivo necesario para el prompt
sudo cp /etc/nsswitch.conf $enviroment/etc
#copiamos las librerias
sudo cp -r /usr/lib $enviroment/usr/
sudo cp -r /lib $enviroment
sudo cp -r /lib64 $enviroment
# Instalamos cada uno de los programas
# Si no se encuentra en el sistema procedemos a instalar

for item in $comandos
do
	echo "Installing $item ...."
	sudo apt-get install $item
	file=/bin/${item}
	if [ -f "$file" ];then 
		sudo cp /bin/${item} $enviroment/bin
	else
		file=/sbin/${item}
		if [ -f "$file" ];then 
			sudo cp /sbin/${item} $enviroment/sbin
		else
			file=/usr/bin/${item}
			if [ -f "$file" ];then 
				sudo cp /usr/bin/${item} $enviroment/sbin
			fi
		fi
	fi
done






