#!/bin/bash

# Detecta la llegada de archivos al directorio ARRIDIR, valida el nombre del mismo
# y lo mueve al directorio que corresponda.

#**************************** MODO DE USO / PARAMETROS ************************

#**********************************BORRAR***************************************

ARRIDIR="arribos"
REPODIR="repodir"
ACEPDIR="acepdir"
RECHDIR="rechdir"
MAEDIR="mae"
LOGDIR="log"
LOGEXT="log"

export LOGDIR
export LOGEXT
#*******************************VARIABLES DE AMBIENTE**************************

# tiempo a dormir antes de ejecutar el proximo ciclo en segundos.
SLEEP=10

# archivo donde se guarda la cuenta de las ejecuciones.
COUNTFILE=$LOGDIR/count

# archivos de obras y salas
OBRAS="$MAEDIR/obras.mae"
SALAS="$MAEDIR/salas.mae"


#***************************** FUNCIONES **************************************

# 1.grabar en el log el numero de ciclo.
# Se utilizará un archivo oculto COUNTFILE el archivo solo tendrá
# una línea donde se guarda una variable que lleva la cuenta del 
# número de veces que se ha llamado al script.
function ActualizarCiclo {
	n=0
	touch $COUNTFILE # cambia la fecha de la ultima modificacion.
	# solo esta por si no existe el archivo, para que lo cree.
	. $COUNTFILE #ejecuta n=<# de ejecucion> 
	n=$(expr $n + 1)
	echo "n=$n" > $COUNTFILE
	./Grabar_L.sh $0 "Ciclo Nro $n"
}

# 2.chequear si hay archivos en el directorio
function LogMoverConExito {
	echo "LOG MOVER CON EXITO FALTA!!!"
}

function LogErrorAlMover {
	echo "LOG ERROR AL MOVER FALTA!!"
}

# $1: nombre de archivo 
# devuelve: 
# 0 Si el nombre del archivo corresponde a una obra o sala valida
# 1 en caso de error.
function EsObraOSala {
	# el nombre del archivo tiene el formato:
	# id_obra_o_sala-correo-xxx
	echo $1
	IFS=-
	read -a array <<< "$1"
	echo "id: ${array[0]}  mail: ${array[1]}"
	if grep -q "^${array[0]};[^;]*;[^;]*;[^;]*;[^;]*;${array[1]}$" "$SALAS" "$OBRAS"
	then
		return 0
	fi
	return 1
}
function ChequearArribos {
#while true
#do
	# archivos de invitados: 
	for archivo in `ls "$ARRIDIR"`
	do
	local origen=$ARRIDIR/$archivo
	local destino
	# si es un archivo (salteo los directorios)	
	if [ -f "$origen" ]
	then
		
		# caso archivos de invitados termina en .inv
		# tomo el retorno de la ejecucion de grep con -q
		# 0 si encontro algo, 1 si no encontro nada, 2 error
		# uso esto porque daba error cuando no encontraba nada.
		if `echo $archivo|grep -q ".*\.inv"` 
		then
			destino=$REPODIR/$archivo
		# caso archivos obras o salas
		elif `echo $archivo|grep -q "^[^-]*-[^-]*-*"`
		then
			if EsObraOSala $archivo
			then
				echo "Sala y Obra: $archivo"
				destino=$ACEPDIR/$archivo
			else
				destino=$RECHDIR/$archivo
			fi
		else
			destino=$RECHDIR/$archivo
		fi
		./Mover_B.sh "$origen" "$destino" $0
		if [ $? -eq 0 ]
		then 
			LogMoverConExito origen destino
		else
			LogErrorAlMover origen destino
		fi

	fi
	done
			
	#sleep $SLEEP 
#done
}







# RECIBIR

ActualizarCiclo
ChequearArribos
