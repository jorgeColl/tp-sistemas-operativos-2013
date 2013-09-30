#!/bin/bash

#temporales, TODO: borrar luego
ACEPDIR="Acepdir"
PROCDIR="Procdir"
RECHDIR="Rechazados"
MAEDIR="Maestro"
SALAS="$MAEDIR/salas.mae"
OBRAS="$MAEDIR/obras.mae"
DISPONIBILIDAD="$PROCDIR/combos.dis"
RESERCONFIRM="$PROCDIR/reservas.ok"
RESERNOCONFIRM="$PROCDIR/reservas.nok"
ARCHLOG="$LOGDIR/Reservar_B.$LOGEXT"

#Escribe al log
#$1 = Texto a logear
Log () {
	echo "$1" #TODO: Reemplazar por llama a function correcta
}

#Logea el rechazo de un archivo y mueve el archivo a la carpeta de rechazados
#$1 = Texto a logear
Rechazar () {
	Log "$1"
	#Mover_B a $RECHDIR
}

#Comprueba que el archivo a procesar tenga formato valido y devuelve un bool
#$1 Ruta del archivo
#$2 Nombre del archivo
#Retorna 0 (true) si se rechazo el archivo y 1 (false) en caso contrario
Comprobar () {
	if [ -d "$1" ]
	then	
		Rechazar "Se rechaza $2 por ser DIRECTORIO"
		return 0
	fi
	if [ ! -s "$1" ]
	then	
		Rechazar "Se rechaza $2 por tener 0 BYTES"
		return 0
	fi
	if [ -e "$PROCDIR/$2" ]
	then	
		Rechazar "Se rechaza $2 por estar DUPLICADO"
		return 0
	fi
	#TODO: Validar formato de cada linea dentro del archivo
	return 	1
}

Log "Inicio de Reservar_B"
Log "Cantidad de archivos: $(ls $ACEPDIR/* -1 -d | wc -l)"
ls $ACEPDIR/* -1 -d | while read RUTARCH
do
	NOMBARCH=${RUTARCH#*/}
	Log "Archivo a procesar: $NOMBARCH"
	if Comprobar "$RUTARCH" "$NOMBARCH"
	then continue # Me salteo el archivo si fue rechazado
	fi
	
	#while read linea
	#do
	#	echo "Linea: $linea"	
	#done < "$RUTARCH"
done
#TODO: Cosas varias
Log "Fin de Reservar_B"
