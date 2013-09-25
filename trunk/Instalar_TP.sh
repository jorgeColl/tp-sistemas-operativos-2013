#!/bin/bash
#Script que se encarga de la instalacion del TP.
# Ver el readme para mas informacion.
#	COMANDO: Instalar_TP.sh
#------------------------------------------------------------

#Variables globales de mi script
usuario='whoami'
ruta_usuario="/home/$usuario"
grupo="./grupo8"#deberia ser el directorio creado para el grupo8 a manopla
CONFDIR="$grupo/conf"#seteo la variable confdir
Instlog="$CONFDIR/Instalar_TP.log"#ruta a el .log del script

#Por defecto asumo estos directorios 

BINDIR="$grupo/bin"
MAEDIR="$grupo/mae"
ARRIDIR="$grupo/arri"
ACEPDIR="$grupo/acep"
RECHDIR="$grupo/rech"
REPODIR="$grupo/repo"



## Funcion que verifica si existe la carpeta grupo8/conf en el sistema

function estaConf(){

if [ -d $CONFDIR ]
then
return 1
else return 0
fi
}

# Funcion que crear CONFDIR si no esta creada en el sistema
function crearDir{

if [estaConf = 0]
then

	mkdir "$CONFDIR"

fi

}


# Funcion que inicia el log , paso 1,2 y 3 (debe llamarse si
# no fue creada la isntalacion de ante mano ( si no existe la carpeta conf)

function InicioLogInstalacion(){

touch $Instlog

echo "Inicio de Ejecución" 
echo "Log del comando Instalar_TP:$Instlog"
echo "DIrectorio de configuracion:$CONFDIR"
# aca se debe grabar en el log tambien, con la funcion grabar
}




