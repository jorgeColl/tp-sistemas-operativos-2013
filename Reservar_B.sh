#!/bin/bash

# Parametros esperados por el comando: Ninguno, solo variables de entorno seteadas
# Notas: Los calculos de horarios toman la hora actual como referencia, no las 00:00

#temporales, TODO: borrar luego
#ACEPDIR="Acepdir"
#PROCDIR="Procdir"
#RECHDIR="Rechazados"
#MAEDIR="Maestro"
#LOGDIR="Log"
#LOGEXT="txt"
#LOGSIZE="1000"
#Variables utiles
SALAS="$MAEDIR/salas.mae"
OBRAS="$MAEDIR/obras.mae"
DISPONIBILIDAD="$PROCDIR/combos.dis"
RESERCONFIRM="$PROCDIR/reservas.ok"
RESERNOCONFIRM="$PROCDIR/reservas.nok"

#Escribe al log
#$1 = Texto a logear
Log () {
	./Grabar_L.sh "$0" "$1"
}

#Logea el rechazo de un archivo y mueve el archivo a la carpeta de rechazados
#$1 = Texto a logear
RechazarArch () {
	Log "$1"
	./Mover_B.sh "$rutaArchivo" "$RECHDIR/$nombreArchivo" "$0"
}

#Logea el rechazo de una reserva
#$1 Motivo de rechazo
RechazarReserva () {
	aRegIDSala="Falta sala"
	aRegIDObra="Falta obra"
	if [ $[${camposNombre[0]} % 2] -eq 0 ]
	then # Numero par, es sala
		aRegIDSala="${camposNombre[0]}";
	else # Numero impar, es obra
		aRegIDObra="${camposNombre[0]}";
	fi
	aRegistrar="${camposLinea[0]};${camposLinea[1]};${camposLinea[2]};${camposLinea[3]};"
	aRegistrar+="${camposLinea[4]};${camposLinea[5]};${camposLinea[6]};$1;$aRegIDSala;"
	aRegistrar+="$aRegIDObra;${camposNombre[1]};$(date);$USER"
	echo "$aRegistrar" >> "$RESERNOCONFIRM"
	registrosNOK=$[$registrosNOK + 1]
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
	while read linea
	do
		formato=$(echo "$linea" | grep "^[^;]*;[0-9/]*;[0-9:]*;[^;]*;[^;]*;[0-9]*;[^;]*$")
		if [ -z "$formato" ]
		then	
			RechazarArch "Se rechaza $nombreArchivo por formato interno incorrecto"
		return 0
		fi
	done < "$rutaArchivo"
	return 	1
}

#Comprueba que la fecha tenga el formato de fecha correcto
#Ademas se fija que la reserva no sea de una fecha mala segun especificaction
#Retorna 0 (true) si se rechazo el archivo y 1 (false) en caso contrario
#Nota: La funcion toma en cuenta la hora actual para hacer los calculos, no las 00:00
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
ComprobarEvento () {
	# Si el ID es par, es 
	if [ $[${camposNombre[0]} % 2] -eq 0 ]
	then # Numero par, es sala
		regExp="^[^;]*;[^;]*;${camposLinea[1]};${camposLinea[2]};${camposNombre[0]};[^;]*;[^;]*;[^;]*$"
	else # Numero impar, es obra
		regExp="^[^;]*;${camposNombre[0]};${camposLinea[1]};${camposLinea[2]};[^;]*;[^;]*;[^;]*;[^;]*$"
	fi
	lineaCombo=$(grep "$regExp" "$DISPONIBILIDAD")
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

#Actualiza la disponibilidad en el archivo $DISPONIBILIDAD
ActualizarDisponibilidad () {
	if [ ! -z "$disponibles" ] # Si el string no esta vacio
	then
		lineaComboReemplazo=$(echo "$lineaCombo" | sed "s_;[^;]*_;""$disponibles""_6")
		sed -i "s_""$lineaCombo""_""$lineaComboReemplazo""_" "$DISPONIBILIDAD"
	fi	
}

#Registra en el archivo de reservas.ok 
RegistrarReserva()
{
	nombreObra=$(grep "^${camposCombo[1]};" "$OBRAS" | cut -d";" -f"2")
	nombreSala=$(grep "^${camposCombo[4]};" "$SALAS" | cut -d";" -f"2")
	aRegistrar="${camposCombo[1]};$nombreObra;${camposLinea[1]};${camposLinea[2]};"
	aRegistrar+="${camposCombo[4]};$nombreSala;${camposLinea[5]};${camposCombo[0]};"
	aRegistrar+="${camposLinea[0]};${camposLinea[5]};${camposNombre[1]};$(date);$USER"
	echo "$aRegistrar" >> "$RESERCONFIRM"
	registrosOK=$[$registrosOK + 1]
}

#Comprueba que haya disponibilidad y hace calculos pertinentes
#Retorna 0 (true) si se rechazo el archivo y 1 (false) en caso contrario
ComprobarDisponibilidad () {
	if [ -z "$disponibles" ]
	then # Si no esta en ram la cargamos del archivo de combos
		disponibles="${camposCombo[6]}"
	fi
	if [ "$disponibles" -lt "${camposLinea[5]}" ] # Falta disponibilidad
	then
		RechazarReserva "Falta de disponibilidad"
		return 0
	fi
	disponibles="$[$disponibles-${camposLinea[5]}]"
	return 1
}

#Main
Log "Inicio de Reservar_B"
Log "Cantidad de archivos: $(ls $ACEPDIR -1 | wc -l)"
ls "$ACEPDIR" -1 | while read nombreArchivo
do
	rutaArchivo="$ACEPDIR/$nombreArchivo"
	Log "Archivo a procesar: $nombreArchivo"
	if ComprobarFormato
		then continue # Me salteo el archivo si fue rechazado
	fi
	IFS="-"
	read -a camposNombre <<< "$nombreArchivo"
	IFS=$'\n'
	disponibles= #Vacio para chequeos
	registrosOK=0
	registrosNOK=0
	while read linea
	do
		if [ -z "$linea" ]
			then continue #Ignoramos lineas vacias
		fi 
		IFS=";"
		read -a camposLinea <<< "$linea"
		IFS=$'\n'
		camposCombo= #Vacio para chequeos
		# Hago comprobaciones varias sobre las lineas
		if ComprobarFecha
			then continue
		elif ComprobarHora
			then continue
		elif ComprobarEvento
			then continue
		elif ComprobarDisponibilidad
			then continue
		fi
		RegistrarReserva
	done < "$rutaArchivo"
	ActualizarDisponibilidad
	Log "Actualización del archivo de disponibilidad"
	./Mover_B.sh "$rutaArchivo" "$PROCDIR/$nombreArchivo" "$0"
	Log "Registros grabados OK: $registrosOK"
	Log "Registros grabados NOK: $registrosNOK"
done
Log "Fin de Reservar_B"
