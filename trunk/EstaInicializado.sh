#!/bin/bash
#Funcion que se encarga de verificar si Iniciar.sh fue ejecutado con anterioridad, devuelve 1 si NO esta inicializado y 0 si SI lo esta

#Esto viene joya para cuando una persona quiere hacer:
#if ./EstaInicializad.sh
#fi

function EstaInicializado {
if [ "$BINDIR" = "" ]||[ "$MAEDIR" = "" ] || [ "$ARRIDIR" = "" ] || [ "$ACEPDIR" = "" ] || [ "$RECHDIR" = "" ] || [ "$REPODIR" = "" ] || [ "$PROCDIR" = "" ] || [ "$LOGDIR" = "" ] || [ "$DATASIZE" = "" ] || [ "$LOGSIZE" = "" ];
then 
	echo "No esta inicializado"
	return "1"
else 
	echo "EL ambiente esta inicializado"
	return "0"
fi
}
EstaInicializado
