#!/bin/bash

function ParametrosDefault {
readonly BINDIR="$grupo/bin"
readonly MAEDIR="$grupo/mae"
readonly ARRIDIR="$grupo/arribos"
readonly ACEPDIR="$grupo/aceptados"
readonly RECHDIR="$grupo/rechazados"
readonly REPODIR="$grupo/listados"
readonly PROCDIR="$grupo/procesados"
readonly LOGDIR="$grupo/log"
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

if [ $0 != "bash" ];
then
	echo 'WARNING: Recordar correr Iniciar_B.sh de la forma: . ./Iniciar_B.sh '
	echo 'Iniciar_B.sh Finaliza MAL'
else
	if ! ./EstaInicializado.sh
	then
		ParametrosDefault
		ExportarVariables
	else
		echo 'ambiente ya inicializado, si quiere reiniciar termine su sesión e ingrese nuevamente'
	fi
fi


