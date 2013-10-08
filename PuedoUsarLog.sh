#!/bin/bash
#Funcion que se encarga de verificar si existen las variables de entorno para ejecutar el log en una instalacion

#Esto viene joya para cuando una persona quiere hacer:
#if ./PuedoUsarLog.sh
#then echo "wiiii"
#else echo "buuuu"
#fi

function Puedo {
if [ "$BINDIR" = "" ] || [ "$LOGDIR" = "" ] || [ "$CONFDIR" = "" ] || [ "$LOGSIZE" = "" ] || [ "$LOGEXT" = "" ]; then 
	echo "No esta inicializado"
	return "1"
else 
	echo "Esta inicializado"
	return "0"
fi
}
Puedo
