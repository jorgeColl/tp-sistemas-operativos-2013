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
	echo "$1" #TODO: Reemplazar por llamada a funcion correcta
}

#Logea el rechazo de un archivo y mueve el archivo a la carpeta de rechazados
#$1 = Texto a logear
#$2 = Ruta del archivo
RechazarArch () {
	Log "$1"
	#Mover_B a $RECHDIR
}

#Logea el rechazo de una reserva
#$1 Motivo de rechazo
#TODO: Determinar parametros y comportamiento
RechazarReserva () {
	echo "$1"
}

#Comprueba que el archivo a procesar tenga formato valido y devuelve un bool
#Retorna 0 (true) si se rechazo el archivo y 1 (false) en caso contrario
ComprobarFormato () {
	if [ ! -f "$rutaArchivo" ]
	then	
		RechazarArch "Se rechaza $nombreArchivo por no ser archivo comun"
		return 0
	fi
	if [ ! -s "$rutaArchivo" ]
	then	
		RechazarArch "Se rechaza $nombreArchivo por estar en blanco"
		return 0
	fi
	if [ -e "$PROCDIR/$nombreArchivo" ]
	then	
		RechazarArch "Se rechaza $nombreArchivo por estar duplicado"
		return 0
	fi
	#while read linea
	#do
	#	echo $linea
	#done
	return 	1
}

#Comprueba que la fecha tenga el formato de fecha correcto
#Ademas se fija que la reserva no sea de una fecha mala segun especificaction
#Retorna 0 (true) si se rechazo el archivo y 1 (false) en caso contrario
#Nota: La funcion toma en cuenta la hora actual para hacer los calculos.
ComprobarFecha () {
	# Paso al formato mm/dd/aaaa
	reordenada=$(echo "${camposLinea[1]}" | sed "s_\([0-9]*\)\/\([0-9]*\)\/\([0-9]*\)_\2/\1/\3_g")
	if [ ! $(date -d $reordenada 2>/dev/null) ]
	then 
		RechazarReserva "Fecha invalida"
		return 0
	# Si es para una funcion que ya paso
	elif [ $(date "+%s") -gt $(date "+%s" -d "$reordenada") ]
	then	
		RechazarReserva "Reserva vencida"
		return 0
	# Si es para una funcion de hoy o mañana
	elif [ $(date "+%s" -d "$reordenada") -lt $(date "+%s" -d "2 days") ]
	then 
		RechazarReserva "Reserva tardia"
		return 0
	# Si es con 30 dias de anticipacion
	elif [ $(date "+%s" -d "$reordenada") -gt $(date "+%s" -d "30 days") ]
	then
		RechazarReserva "Reserva anticipada"
		return 0
	fi
	return 1
}

#Comprueba que la hora tenga el formato de fecha correcto
#Retorna 0 (true) si se rechazo el archivo y 1 (false) en caso contrario
ComprobarHora () {
	if [ ! $(date -d "${camposLinea[2]}" 2>/dev/null) ]
	then 
		RechazarReserva "Hora invalida"
		return 0
	fi
	return 1
}

#Comprueba que el evento pedido efectivamente exista
#Retorna 0 (true) si se rechazo el archivo y 1 (false) en caso contrario
#combos.dis ID DEL COMBO	ID DE LA OBRA	FECHA DE FUNCIÓN	 HORA DE FUNCIÓN	ID DE LA SALA	BUTACAS HABILITADAS	BUTACAS DISPONIBLES	REQUISITOS ESPECIALES
ComprobarEvento () {
	# Si el ID es par, es 
	if [ $[ ${camposNombre[0]} % 2] -eq 0 ]
	then # Numero par, es sala
		regExp="^[^;]*;[^;]*;${camposLinea[1]};${camposLinea[2]};${camposNombre[0]};[^;]*;[^;]*;[^;]*$"
	else # Numero impar, es obra
		regExp="^[^;]*;${camposNombre[0]};${camposLinea[1]};${camposLinea[2]};[^;]*;[^;]*;[^;]*;[^;]*$"
	fi
	lineaCombo=$(grep "$regExp" "$PROCDIR/combos.dis")
	if [ -z "$lineaCombo" ]
	then
		RechazarReserva "No existe el evento solicitado"
		return 0
	fi
	IFS=";"
	read -a camposCombo <<< "$lineaCombo"
	IFS=$'\n'
	return 1
}

Log "Inicio de Reservar_B"
Log "Cantidad de archivos: $(ls $ACEPDIR/* -1 -d | wc -l)"
ls "$ACEPDIR"/* -1 -d | while read rutaArchivo
do
	nombreArchivo=${rutaArchivo#*/}
	Log "Archivo a procesar: $nombreArchivo"
	if ComprobarFormato
		then continue # Me salteo el archivo si fue rechazado
	fi
	IFS="-"
	read -a camposNombre <<< "$nombreArchivo"
	IFS=$'\n'
	while read linea
	do
		if [ -z "$linea" ]
			then continue #Ignoramos lineas vacias
		fi 
		IFS=";"
		read -a camposLinea <<< "$linea"
		IFS=$'\n'
		# Hago comprobaciones varias sobre las lineas
		if ComprobarFecha
			then continue
		elif ComprobarHora
			then continue
		elif ComprobarEvento
			then continue
		fi
	done < "$rutaArchivo"
done
#TODO: Cosas varias
Log "Fin de Reservar_B"
