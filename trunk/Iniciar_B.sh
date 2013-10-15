#!/bin/bash

grupo=`pwd|grep -o "^.*grupo8"`

#Funcion para grabar al Log
function Log {
        ./Grabar_L.sh "$0" '-ins' "$1"
        echo "$1"
}



function ParametrosDefault {
readonly BINDIR="$grupo/bin"
readonly MAEDIR="$grupo/mae"
readonly ARRIDIR="$grupo/arribos"
readonly ACEPDIR="$grupo/aceptados"
readonly RECHDIR="$grupo/rechazados"
readonly REPODIR="$grupo/listados"
readonly PROCDIR="$grupo/procesados"
readonly LOGDIR="$grupo/log"
readonly LOGEXT="log"
readonly DATASIZE='100'
readonly LOGSIZE='400'
}

function ExportarVariables {
export BINDIR
export MAEDIR
export ARRIDIR
export RECHDIR
export ACEPDIR
export REPODIR
export PROCDIR
export LOGDIR
export DATASIZE
export LOGEXT
export DATASIZE
export LOGSIZE
}

#Log de comando
Inilog="$LOGDIR/Iniciar_B$LOGEXT"


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

#INICIO DE EJECUCION-----------------------------------------------------------------
# Paso 1 Inicializar el archivo de log, si no estaba lo crea.

function InicioLog {
if [ -f "$Inilog" ];
then
        Log "Existe "$Inilog""
else
        touch "$Inilog" 
fi

Log "Comando Iniciar_B inicio de Ejecucion"
}

InicioLog



#Paso 2 Verificar que la instalación está completa
#[ FALTA HACER ]


#Paso casi 3 Compruebo que este siendo llamado de la forma: . ./Iniciar_B.sh
#Por cuestiones de compatibilidad solo despliego el warning y no realizo ninguna accion
if [ $0 != "bash" ];
then
	Log 'WARNING: Recordar correr Iniciar_B.sh de la forma: . ./Iniciar_B.sh '
	Log 'Iniciar_B.sh Finaliza MAL'
fi

#Paso 3 y 4 Verificar si el ambiente ya ha sido inicializado.
if ! ./EstaInicializado.sh
then	
	ParametrosDefault
	ExportarVariables
else
	Log 'Ambiente ya inicializado, si quiere reiniciar termine su sesión e ingrese nuevamente'
fi


#Paso 5 Ver si se desea arrancar Recibir_B
echo "Desea efectuar la activación de Recibir_B? Si – No"
if FSiNo
then
	Log "Si desea ejecutar Recibir_B en algun momento, hagalo de esta forma:"
	Log './Start_D.sh ./Recibir_B.sh '
	return 0
else
	if ./EstaCorriendo.sh "Recibir_B.sh" "1"
	then
		Log "iniciando Recibir_B..."
		./Start_D.sh ./Recibir_B.sh "Iniciar_B.sh"
		
	fi
	Log "Cuando quiera terminar la ejecución de Recibir_B hagalo de esta forma:"
	Log "./Stop_D.sh ./Recibir_B.sh"
	
fi

