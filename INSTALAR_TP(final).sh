#!/bin/bash
#Script que se encarga de la instalacion del TP.
# Ver el readme para mas informacion.
#	COMANDO: Instalar_TP.sh
#------------------------------------------------------------
grupo="./grupo8"
CONFDIR="$grupo/conf"
Instlog="$CONFDIR/Instalar_TP.log" #ruta a el log del script

#Por defecto asumo estos directorios 
function DirectoriosDefault {

BINDIR="$grupo/bin"
MAEDIR="$grupo/mae"
ARRIDIR="$grupo/arribos"
ACEPDIR="$grupo/aceptados"
RECHDIR="$grupo/rechazados"
REPODIR="$grupo/listados"
PROCDIR="$grupo/procesados"
LOGDIR="$grupo/log"

}

# Funcion que inicia el log. Lo crea si no estaba.
function InicioLogInstalacion {
if [ -f "$Instlog" ];
then
	echo "Existe "$Instlog""
else
	touch "$Instlog" #aca hay que darle permisos de escritura??VER
fi

echo "Inicio de Ejecución" 
echo "Log del comando Instalar_TP:$Instlog"
echo "Directorio de configuracion:$CONFDIR"

# [FALTA HACER]
# aca se debe grabar en el log tambien, con la funcion grabar
}

function ReInstalar {

echo 'reinstalando....'

#[FALTA HACER]

}
function FSiNo {
local var1
while [ "$var1" != "Si" ] && [ "$var1" != "No" ]
do 
	read var1
done #Hasta que no contesta si o no sale del bucle

if [ "$var1" = "Si" ]
then
	return "1"
else
	return "0"
fi
}

#Auxiliar de Paso 5 (Aceptacion de terminos) Retorna 1 si acepto los terminos, 0 si no.
function AceptaTerminos {

echo "TP SO7508 Segundo Cuatrimestre 2013. Tema B Copyright Grupo 08"
echo " A T E N C I O N: Al instalar el TP SO7508 Segundo Cuatrimestre 2013 UD. expresa aceptar los terminos y condiciones del ACERDO DE LICENCIA DE SOFTWARE incluido en este paquete."
echo "¿Acepta? Si - No "
FSiNo

}

function PerlInstalado {

if [ -x /usr/bin/perl ];
then
	return "1"
else
	return "0"
fi
}

#Para finalizar el script , guarda informacion en Instalar_TP.conf y en Instalar_TP.log
function FIN {

#[FALTA HACER]
# guardar informacion en Instalar_TP.conf y en Instalar_TP.log	
exit

}



#INICIO DE EJECUCION

# Paso 1, 2 y 3
mkdir -p "$CONFDIR"
InicioLogInstalacion

#Paso 4.
if [ -f $CONFDIR/Instalar_TP.conf ];
then echo "instalacion incompleta o ya hecha"
	ReInstalar
else echo "PRIMERA VEZ"
fi

#Paso 5
if AceptaTerminos;
then 
	echo "USUARIO RECHAZO TERMINOS"
	FIN
else 
	echo "USUARIO ACEPTO TERMINOS"
fi

#Paso 6
if PerlInstalado;
then
	echo "TP SO7508 Segundo Cuatrimestre 2013. Tema B Copyright © Grupo 8"
	echo "Para instalar el TP es necesario contar con  Perl 5 o superior instalado. Efectúe su instalación e inténtelo nuevamente. "
	echo "Proceso de Instalación Cancelado "
	FIN
else
	echo "Perl Si esta instalado"
fi

DirectoriosDefault

#Paso 7
function DefinirEjecutables {
local direct
echo "Defina el directorio de instalacion de los archivos ejecutables ($BINDIR)"
echo "Desea conservar el directorio por defecto?: Si - No"
if FSiNo;
then
	echo "Proponga su directorio para los ejecutables"
	read direct
	BINDIR="$grupo/$direct"
fi
}

DefinirEjecutables

#Paso 8
function DefinirMaestros {
local direct
echo "Defina el directorio de instalacion de los archivos maestros ($MAEDIR)"
echo "Desea conservar el directorio por defecto?: Si - No"
if FSiNo;
then
	echo "Proponga su directorio para los archivos maestros"
	read direct
	MAEDIR="$grupo/$direct"
fi
}

DefinirMaestros

#Paso 9
function DefinirExternos {
local direct
echo "Defina el directorio de instalacion de los archivos externos ($grupo/arribos)"
echo "Desea conservar el directorio por defecto?: Si - No"
if FSiNo;
then
	echo "Proponga su directorio para los archivos maestros"
	read direct
	ARRIDIR="$grupo/$direct" #Si supongo que me dan del estilo tp/arribos
fi
}

DefinirExternos

#Paso 10. Pedido al usuario  espacio para directorio ARRIDIR
function EspacioMinimoArribos {
local direct
echo "Defina el espacio minimo libre para el arribo de archivos externos en MBYtes (100):"
read cantidad	#espero la orden del teclado
DATASIZE="$cantidad"	#guardo en la variable datasize la cantidad pasada
}

EspacioMinimoArribos

#Paso 11 Verificar espacio en disco
#[FALTA HACER]

#Paso 12
function DefinirAceptados {
local direct
echo "Defina el directorio de instalacion de los archivos maestros ($grupo/aceptados)"
echo "Desea conservar el directorio por defecto?: Si - No"
if FSiNo;
then
	echo "Proponga su directorio para los archivos maestros"
	read direct
	ACEPDIR="$grupo/$direct" #Si supongo que me dan del estilo tp/aceptados
fi
}

DefinirAceptados

#Paso 13
function DefinirRechazados {
local direct
echo "Defina el directorio de instalacion de los archivos rechazados ($grupo/rechazados)"
echo "Desea conservar el directorio por defecto?: Si - No"
if FSiNo;
then
	echo "Proponga su directorio para los archivos rechazados"
	read direct
	RECHDIR="$grupo/$direct" #Si supongo que me dan del estilo tp/recha
fi
}

DefinirRechazados

# Funcion para definir el directorio de los listados de salida
function DefinirRepo {
local direct
echo "Defina el directorio de instalacion de los listados de salida($grupo/listados)"
echo "Desea conservar el directorio por defecto?: Si - No"
if FSiNo;
then
	echo "Proponga su directorio para los archivos de salida"
	read direct
	REPODIR="$grupo/$direct" #Si supongo que me dan del estilo tp/lista
fi
}

DefinirRepo

# Paso 17
# Define la extension de los archivos de log

function LogExtension {
echo "Ingrese la extension para los archivos de log: (.log)"
read extension
LOGEXT=$extension
}

LogExtension

#PARO ACA E IMPRIMO ESTADO
echo "$BINDIR"
echo "$MAEDIR"
echo "$ARRIDIR"
echo "$RECHDIR"
echo "$ACEPDIR"
echo "$REPODIR"
echo "$PROCDIR"
echo "$LOGDIR"

# Paso 21.1
#Instalacion de los directorios

function InstalacionDirectorios {
echo "Creando Estructuras de directorio ..."
mkdir "$BINDIR"
mkdir "$MAEDIR"
mkdir "$ARRIDIR"
mkdir "$RECHDIR"
mkdir "$ACEPDIR"
mkdir "$REPODIR"
mkdir "$PROCDIR"
mkdir "$LOGDIR"

}

