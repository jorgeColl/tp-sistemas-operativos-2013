#!/bin/bash
#Script que se encarga de la instalacion del TP.
# Ver el readme para mas informacion.
#	COMANDO: Instalar_TP.sh
#------------------------------------------------------------

#Variables globales de mi script
usuario='whoami'
ruta_usuario="/home/$usuario"
grupo="./grupo8" #deberia ser el directorio creado para el grupo8 a manopla
CONFDIR="$grupo/conf" #seteo la variable confdir
Instlog="$CONFDIR/Instalar_TP.log" #ruta a el .log del script
estado="COMPLETO" #variable para controlar el estado de la instalacion


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

if [estaConf=0]
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

# Paso 4.1. Muestra el estado del sistema por pantalla y en el log
function MostrarMensajeInicial(){

echo "TP SO7508 Segundo Cuatrimestre 2013. Tema B Copyright Grupo 08"
echo "Libreria del Sistema: $CONFDIR /n"
ls "$CONFDIR"
echo "Ejecutables:$BINDIR"
ls "$BINDIR"
echo "Archivos Maestros: $MAEDIR"
ls "$MAEDIR"
echo "Directorio de arribo de archivos externos: $ARRIDIR"
ls "$ARRIDIR"
echo "Archivos externos aceptados: $ACEPDIR"
ls "$ACEPDIR"
echo "Archivos externos rechazados: $RECHDIR"
ls "$RECHDIR"
echo " Reportes de salida:$REPODIR"
ls "$REPODIR"
echo "Archivos procesados:$PROCDIR"
ls "$PROCDIR"
echo "Logs de aditoria del Sistema:" #falta aca
#ls
echo "Estado de la instalacion:$estado"
echo" Proceso de Instalacion Cancelado"

#FALTA GRABAR EN EL LOG LO MISMO
}




#Funcion para ver si esta instalado PERL, paso 4.3.3 y 6
function estaPerl(){

versionmin=5
versioninst=`perl -v | sed -n 's/.*v\([0-9]*\)\.[0-9]*.*/1\/p'`
#busco en la primera linea v(5.14.xx)

	if ["$versioninst" -lt "$versionmin"]
	then 
		echo "Para instalar el TP es necesario contar con Perl 5 o superior instaldo. Efectue su instalacion e intentelo nuevamente.
Proceso de instalacion Cancelado"
	fi
	exit 1;
	else
	echo "Perl Version:$versioninst"
	fi

#FALTA GRABAR EN EL LOG LO MISMO
}




