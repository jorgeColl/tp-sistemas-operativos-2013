#!/bin/bash

# Detecta la llegada de archivos al directorio ARRIDIR, valida el nombre del mismo
# y lo mueve al directorio que corresponda.

# uso un directorio auxiliar para probar...
#BORRAR
ARRIDIR="arribos"
REPODIR="repodir"
SLEEP=10

# Parámetros..



# 1.grabar en el log el numero de ciclo.
function GrabarLog {
	echo "FALTA HACER LOG"
}

# 2.chequear si hay archivos en el directorio
function LogMoverConExito {
	echo "LOG MOVER CON EXITO FALTA!!!"
}

function LogErrorAlMover {
	echo "LOG ERROR AL MOVER FALTA!!"
}

function ChequearArribos {
#while true
#do
	# archivos de invitados: 
	for archivo in `ls $ARRIDIR | grep ".*\.inv"`
	do
	# si es un archivo (salteo los directorios)
	if [ -f "${ARRIDIR}/${archivo}" ]
	then
		# caso archivos de invitados termina en .inv
		if [ `echo $archivo|grep ".*\.inv"` != "" ]
		then
			local origen=$ARRIDIR/$archivo
			local destino=$REPODIR/$archivo
			./Mover_B.sh $origen $destino $0
			if [ $? -eq 0 ]
			then 
				LogMoverConExito origen destino
			else
				LogErrorAlMover origen destino
			fi
		# caso archivos obras o salas
		elif [ `echo $archivo|grep "^[^-]*-[^-]*-*"` != "" ]
		then
			echo "OBRAS O SALAS"
		fi
	fi
	done
			
	#sleep $SLEEP 
#done
}







# RECIBIR

GrabarLog
ChequearArribos
