#!/bin/bash
#Script que se encarga de la instalacion del TP.
# Ver el readme para mas informacion.
#	COMANDO: Instalar_TP.sh
#------------------------------------------------------------
grupo="./grupo8"
CONFDIR="$grupo/conf"
Instlog="$CONFDIR/Instalar_TP.log" #ruta a el log del script
declare -i DATASIZE

#Por defecto asumo estos directorios 
function ParametrosDefault {
BINDIR="$grupo/bin"
MAEDIR="$grupo/mae"
ARRIDIR="$grupo/arribos"
ACEPDIR="$grupo/aceptados"
RECHDIR="$grupo/rechazados"
REPODIR="$grupo/listados"
PROCDIR="$grupo/procesados"
LOGDIR="$grupo/log"
DATASIZE='100'
LOGSIZE='400'
}

#(Pasos 19 - )Funcion auxiliar que muestra el estado de la instalacion
function MostrarMensajeEstado {
clear
echo "TP SO7508 Segundo Cuatrimestre 2013. Tema B Copyright Grupo 08"
echo "Libreria del Sistema: $CONFDIR"
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
echo "Reportes de salida:$REPODIR"
ls "$REPODIR"
echo "Archivos procesados:$PROCDIR"
ls "$PROCDIR"
echo "Logs de aditoria del Sistema:$LOGDIR/<$COMANDO>.$LOGEXT"
ls "$LOGDIR"
echo "Estado de la instalacion:$1"

#FALTA GRABAR EN EL LOG LO MISMO [FALTA HACER]
}

#Funcion auxiliar para la carga de un Si-No
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

#(Paso1) Funcion que inicia el log. Lo crea si no estaba.
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

#(Paso 4) Funcion que se encarga de reinstalar/continuar la instalacion
function ReInstalar {

echo 'reinstalando....'

#[FALTA HACER]

}

#(Paso 5) (Aceptacion de terminos) Retorna 1 si acepto los terminos, 0 si no.
function AceptaTerminos {

echo "TP SO7508 Segundo Cuatrimestre 2013. Tema B Copyright Grupo 08"
echo " ATENCION: Al instalar el TP SO7508 Segundo Cuatrimestre 2013 UD. expresa aceptar los terminos y condiciones del ACERDO DE LICENCIA DE SOFTWARE incluido en este paquete."
echo "¿Acepta? Si - No "
FSiNo

}
#(Paso 6) Funcion que Chequea que Perl esté instalado
function PerlInstalado {
#-x /usr/bin/perl otra forma de buscar ejecutable de perl
if [ `which "perl"` ];
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


#(Paso 7) Funcion que define el directorio de instalación de los ejecutables
function DefinirEjecutables {
local direct
echo "Defina el directorio de instalacion de los archivos ejecutables ($BINDIR)"
echo "Desea conservar el directorio por defecto?: Si - No"
if FSiNo;
then
	echo "Proponga su directorio para los ejecutables"
	read direct
	direct=`echo "$direct" | sed  's#^/\(.*\)#\1#'` #saca la primer / si es que tiene
	BINDIR="$grupo/$direct"
fi
}

#(Paso 8) Funcion que define el directorio de instalación de los archivos maestros
function DefinirMaestros {
local direct
echo "Defina el directorio de instalacion de los archivos maestros ($MAEDIR)"
echo "Desea conservar el directorio por defecto?: Si - No"
if FSiNo;
then
	echo "Proponga su directorio para los archivos maestros"
	read direct
	direct=`echo "$direct" | sed  's#^/\(.*\)#\1#'` #saca la primer / si es que tiene
	MAEDIR="$grupo/$direct"
fi
}

#(Paso 9) Funcion que define el directorio de arribo de archivos externos
function DefinirExternos {
local direct
echo "Defina el directorio de instalacion de los archivos externos ($grupo/arribos)"
echo "Desea conservar el directorio por defecto?: Si - No"
if FSiNo;
then
	echo "Proponga su directorio para los archivos maestros"
	read direct
	direct=`echo "$direct" | sed  's#^/\(.*\)#\1#'` #saca la primer / si es que tiene
	ARRIDIR="$grupo/$direct" #Si supongo que me dan del estilo tp/arribos
fi
}

#(Paso 10) Funcion que define el espacio mínimo libre para el arribo de archivos externos
function EspacioMinimoArribos {
local cantidad
echo "Defina el espacio minimo libre para el arribo de archivos externos en MBYtes ($DATASIZE):"
echo "Desea conservar el Tamaño por defecto?: Si - No"
if FSiNo;
then
	while [[ $cantidad != [0-9]* ]] #leve comprovacion de que se ingresa un entero
	do
		read cantidad
	done
	DATASIZE="$cantidad"
fi
}

#(Paso 11) Funcion que verifica el espacio en disco
function ComprobarEspacio {
mkdir -p $ARRIDIR #parche auxiliar !!!!!!!!!!!!!!!

local espa=`df "$ARRIDIR"`
declare -i local taman=` echo $espa | sed 's#.* \([^ ]*\) [^ ]* [^ ]*$#\1#' `

if [ "$taman" -lt "$DATASIZE" ];
then
	echo "ESPACIO INSUFICIENTE POR FAVOR LIBERE ESPACIO Y VUELVA A INSTALAR"
	echo "Se necesitan $DATASIZE y se tiene $taman"
	FIN
fi
}

#(Paso 12) Funcion que define el directorio de grabación de los archivos aceptados
function DefinirAceptados {
local direct
echo "Defina el directorio de instalacion de los archivos maestros ($ACEPDIR)"
echo "Desea conservar el directorio por defecto?: Si - No"
if FSiNo;
then
	echo "Proponga su directorio para los archivos maestros"
	read direct
	direct=`echo "$direct" | sed  's#^/\(.*\)#\1#'` #saca la primer / si es que tiene
	ACEPDIR="$grupo/$direct" #Si supongo que me dan del estilo tp/aceptados
fi
}

#(Paso 13) Funcion que define el directorio de grabación de los archivos rechazados
function DefinirRechazados {
local direct
echo "Defina el directorio de instalacion de los archivos rechazados ($RECHDIR)"
echo "Desea conservar el directorio por defecto?: Si - No"
if FSiNo;
then
	echo "Proponga su directorio para los archivos rechazados"
	read direct
	direct=`echo "$direct" | sed  's#^/\(.*\)#\1#'` #saca la primer / si es que tiene
	RECHDIR="$grupo/$direct" #Si supongo que me dan del estilo tp/recha
fi
}

#(Paso 14) Funcion que define el directorio de grabación de los LISTADOS de salida
function DefinirSalida {
local direct
echo "Defina el directorio de instalacion de los listados de salida($REPODIR)"
echo "Desea conservar el directorio por defecto?: Si - No"
if FSiNo;
then
	echo "Proponga su directorio para los archivos de salida"
	read direct
	direct=`echo "$direct" | sed  's#^/\(.*\)#\1#'` #saca la primer / si es que tiene
	REPODIR="$grupo/$direct" #Si supongo que me dan del estilo tp/lista
fi
}

#(Paso 15) Funcion que define el directorio de trabajo principal del proceso Reservar_B
function DefinirProcesados {
local direct
echo "Defina el directorio de grabación de los archivos procesados ($PROCDIR):"
echo "Desea conservar el directorio por defecto?: Si - No"
if FSiNo;
then
	echo "Proponga su directorio para los archivos de salida"
	read direct
	direct=`echo "$direct" | sed  's#^/\(.*\)#\1#'` #saca la primer / si es que tiene
	PROCDIR="$grupo/$direct" #Si supongo que me dan del estilo tp/lista
fi
}

#(Paso 16) Funcion que define el directorio de logs para los comandos
function DefinirLogs {
local direct
echo "Defina el directorio de logs ($LOGDIR):"
echo "Desea conservar el directorio por defecto?: Si - No"
if FSiNo;
then
	echo "Proponga su directorio para los archivos de salida"
	read direct
	direct=`echo "$direct" | sed  's#^/\(.*\)#\1#'` #saca la primer / si es que tiene
	LOGDIR="$grupo/$direct" #Si supongo que me dan del estilo tp/lista
fi
}

#(Paso 18) Funcion que define el tamaño máximo para los archivos de log
function EspacioMaxLogs {
local cantidad
echo "Defina el tamaño máximo para los archivos $LOGEXT en Kbytes ($LOGSIZE):"
echo "Desea conservar el Tamaño por defecto?: Si - No"
if FSiNo;
then
	while [[ $cantidad != [0-9]* ]] #leve comprovacion de que se ingresa un entero
	do
		read cantidad
	done
	LOGSIZE="$cantidad"
fi

}

#(Paso 17) Funcion que define la extension de los archivos de log
function LogExtension {
echo "Ingrese la extension para los archivos de log: (.log)"
read extension
LOGEXT=$extension
}

#(Paso 21.1) Funcion que crea los directorios
function InstalacionDirectorios {
echo "Creando Estructuras de directorio ..."
mkdir -p "$BINDIR"
mkdir -p "$MAEDIR"
mkdir -p "$ARRIDIR"
mkdir -p "$RECHDIR"
mkdir -p "$ACEPDIR"
mkdir -p "$REPODIR"
mkdir -p "$PROCDIR"
mkdir -p "$LOGDIR"
}

#(Paso 21.2) Funcion que mueve los archivos maestros al directorio MAEDIR
function MoverMaestros {
echo "Instalando Archivos Maestros"
#[FALTA HACER]
}

#(Paso 21.3) Funcion que mueve el archivo de disponibilidad al directorio PROCDIR
function MoverDisponibilidad {
echo "Instalando Archivo de Disponibilidad"
#[FALTA HACER]
}

#(Paso 21.4) Funcion que mueve los ejecutables y funciones  al directorio BINDIR
function MoverProgramasFunciones{
echo "Instalando Programas y Funciones"
#[FALTA HACER]
}

#(Paso 21.5) Funcion que Actualiza el archivo de configuración
function ActualizarArchivos{
echo "Actualizando la configuración del sistema"
#[FALTA HACER]
}

#INICIO DE EJECUCION-----------------------------------------------------------
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

#Cargo a las variables los parametros default
ParametrosDefault

#NOTA: se que queda medio sucio poner esta funcion aca pero creo que se ve mas "secuencial" la instalacion si la dejo aca
function Definiciones {
#Paso7: Definir el directorio de instalación de los ejecutables
DefinirEjecutables

#Paso 8: Definir el directorio de instalación de los archivos maestros
DefinirMaestros

#Paso 9: Definir el directorio de arribo de archivos externos
DefinirExternos

#Paso 10: Definir el espacio mínimo libre para el arribo de archivos externos
EspacioMinimoArribos

#Paso 11: Verificar espacio en disco 
ComprobarEspacio

#Paso 12: Definir el directorio de grabación de los archivos aceptados
DefinirAceptados

#Paso 13: Definir el directorio de grabación de los archivos rechazados
DefinirRechazados

#Paso 14: Definir el directorio de grabación de los LISTADOS de salida
DefinirSalida

#Paso 15: Definir el directorio de trabajo principal del proceso Reservar_B
DefinirProcesados

#Paso 16: Definir el directorio de logs para los comandos
DefinirLogs

#Paso 17: Definir la extensión para los archivos de log
LogExtension

#Paso 18: Definir el tamaño máximo para los archivos de log
EspacioMaxLogs

#Paso 19: Mostrar estructura de directorios resultante y valores de parámetros configurados
MostrarMensajeEstado ' LISTO'

echo "Desea continuar con la instalacion?: Si - No"
if FSiNo;
then
	clear
	Definiciones
fi
}

Definiciones

#Paso 20: Confirmar Inicio de Instalación
echo "Iniciando Instalación. Esta Ud. seguro? (Si-No)"
if FSiNo;
then
	FIN
fi

#Paso 21: Instalacion
InstalacionDirectorios
MoverMaestros #[FALTA HACER]
MoverDisponibilidad #[FALTA HACER]
MoverProgramasFunciones #[FALTA HACER]

#Paso 22: Borrar archivos temporarios, si los hubiese generado
#[FALTA HACER] ?¿

#Paso 23: Mostrar mensaje de fin de instalación
echo "Instalación CONCLUIDA"

#Paso 24: FIN
#the fuking end yeahh !!!

