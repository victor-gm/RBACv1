#Hacemos un bucle infinito para que no pare de ejecutarse

puerto=`sed -n '2p' < /etc/rbac/network.conf`
if [ "$EUID" -ne 0 ]
then
	echo "Necesitas permisos de root"
	exit
fi

nc -kl $puerto | while read line; do

	usuario=`echo $line | awk -F' ' '{print $2}'`
	comando=`echo $line | awk -F' ' '{print $1}'`
	rol=`echo $line | awk -F' ' '{print $3}'`

	case $comando in 
		"cleanEnvironment")
			sudo rm -rf /users/$rol/$usuario
   			sudo pkill -u $usuario
			;;
			
		"resetEnvironment")
			#Guardamos la home en una carpeta auxiliar
			mv /users/$rol/$usuario/home/$usuario /tmp/$usuario
			#Eliminamos el entorno
			sudo rm -rf /users/$rol/$usuario
			#Lo volvemos a crear
			sudo bash /etc/rbac/userEnvironment.sh $usuario
			#Recuperamos la home
			sudo cp -rf /tmp/$usuario /users/$rol/$usuario/home
			sudo rm -rf /tmp/$usuario
			sudo pkill -u $usuario
			;;
		
		"reqCommand")
			mensaje=`echo $line | awk -F' ' '{print $4}'`
			bash /etc/rbac/mail $mensaje
			;;
	esac
done
