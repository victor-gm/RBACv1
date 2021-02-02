#!/bin/bash
#Lee los archivos de configuración y crea los grupos

for file in /etc/rbac/roles/*;do 
	groupname="$(basename "$file" | cut -f 1 -d '.')"
	groupadd $groupname
	echo "Added group:" $groupname 
done
