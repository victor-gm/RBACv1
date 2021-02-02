# Administración y Diseño de Sistemas
# RBAC - FASE 1
# Jaime Parra - jaime.parra
# Víctor Garrido - victor.garrido

# Puesta a punto
1. Crear un disco virtual nuevo en la máquina virtual
2. Ejecutar el script Installer.sh mediante el comando `sudo bash Installer.sh`
3. Darle a Y, para que se monte el disco creado, o a N si ya está montado

# Explicación de scripts

* `Installer.sh`: copia los archivos del ZIP dentro del servidor, instala algunos paquetes necesarios, monta el nuevo disco añadido y añade los grupos de los roles.
* `createGroups.sh`: se encarga de crear los grupos para cada rol.
* `delete.sh`: script simple, que sirve para eliminar directorios enteros.
* `keyGenerator.sh`: Genera las llaves SSH, almacena la pública en el servidor y envía la privada al usuario por mail.
* `userEnvironment.sh`: Crea el entorno del usuario en el directorio /users, y programa la eliminación de su entorno y/o home en el caso de que sea necesario. Este script se ejecuta al realizar ssh.
* `mail`: script que se encarga de enviar un mail al servidor, correspondiente al comando `rbac --request-command`.
* `fstabCreator.sh`: monta el disco y crea el archivo fstab para que sea permanente.
* `runBackground.sh`: ejecuta el deamon que escucha en el puerto indicado las peticiones del comando environment
* `rootCommands.sh`: gestiona las peticiones del usuario al servidor, realizadas con el comando environment.
