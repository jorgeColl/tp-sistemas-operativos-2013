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
LOGSIZE=1024
export LOGDIR
export LOGEXT
export LOGSIZE
#*******************************VARIABLES DE AMBIENTE**************************

# tiempo a dormir antes de ejecutar el proximo ciclo en segundos.
SLEEP=30

# archivo donde se guarda la cuenta de las ejecuciones.
COUNTFILE=$LOGDIR/count

# archivos de obras y salas
OBRAS="$MAEDIR/obras.mae"
SALAS="$MAEDIR/salas.mae"


#***************************** FUNCIONES **************************************


function Log {
	./Grabar_L.sh $0 "$1"	
}

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
	Log "Ciclo Nro $n"
}

# 2.chequear si hay archivos en el directorio




function EsDeInvitados {
	# caso archivos de invitados termina en .inv
	# tomo el retorno de la ejecucion de grep con -q
	# 0 si encontro algo, 1 si no encontro nada, 2 error
	# uso esto porque daba error cuando no encontraba nada.
	if `echo $1|grep -q ".*\.inv"`
	then 
		return 0

	fi
	return 1
}

function EsObraOSala {
	if `echo $1|grep -q "^[^-]*-[^-]*-.*"`
	then
		# el nombre del archivo tiene el formato:
		# id_obra_o_sala-correo-xxx
		IFS=-
		read -a array <<< "$1"
		IFS="
"
		if [ $(( ${array[0]} % 2 )) -eq 0 ]
		then 
			EsSala "${array[0]}" "${array[1]}" $1
			return $?
		else
			EsObra "${array[0]}" "${array[1]}" $1
			return $?
		fi 
	fi
	return 1
}

# $1: id
# $2: mail
# $3: nombre completo del archivo
# 0 si existe el id y el mail.
# != 0 si no se encuentra en el archivo.
function EsSala {
	# caso econtre sala y mail.
	if grep -q "^${1};[^;]*;[^;]*;[^;]*;[^;]*;${2}$" $SALAS
	then
		return 0
	# solo encontre el id, el mail no es correcto.	
	elif grep -q "^${1};[^;]*;[^;]*;[^;]*;[^;]*;[^;]*$" $SALAS
	then
		
		Log "El archivo $3 contiene un mail inexistente pero se ha encontrado el id."
		return 1
	# el id no existe pero si el mail
	elif grep -q "^[^;]*;[^;]*;[^;]*;[^;]*;[^;]*;${2}$" $SALAS
	then
		Log "El archivo $3 contiene un id inexistente pero se ha encontrado el mail."
		return 2
	fi
	return 3
}


# $1: id
# $2: mail
# $3: nombre completo del archivo
# 0 si existe el id y el mail.
# != 0 si no se encuentra en el archivo.
function EsObra {
	# caso encontre obra y mail de produccion general
	if grep -q "^${1};[^;]*;${2};.*$" $OBRAS 
	then
		return 0
	# caso	encontre obra y mail de produccion ejecutiva
	elif grep -q "^${1};[^;]*;[^;]*;${2}$" $OBRAS
	then 
		return 0
	# solo encontre el id, el mail no es correcto.	
	elif grep -q "^${1};[^;]*;[^;]*;[^;]*$" $OBRAS
	then
		Log "El archivo $3 contiene un mail inexistente pero se ha encontrado el id."
		return 1
	# el id no existe pero si el mail
	elif grep -q "^[^;]*;[^;]*;[^;]*;${2}$" $OBRAS
	then
		Log "El archivo $3 contiene un id inexistente pero se ha encontrado el mail."
		return 2
	elif grep -q "^[^;]*;[^;]*;${2};[^;]$" $OBRAS
	then
		Log "El archivo $3 contiene un id inexistente pero se ha encontrado el mail."
		return 2
	fi
	return 3
}


function ChequearArribos {
# recorro cada archivo en arribos
ls "$ARRIDIR"|while read archivo
do
	local origen=$ARRIDIR/$archivo
	local destino
	# si es un archivo (salteo los directorios)	
	if [ -f "$origen" ]
	then
		if EsDeInvitados $archivo
		then
			destino=$REPODIR/$archivo
		# caso archivos obras o salas
		elif EsObraOSala $archivo
		then
			destino=$ACEPDIR/$archivo
		else
			destino=$RECHDIR/$archivo
		fi
		Log "Se moverá el archivo desde $origen a $destino."
		./Mover_B.sh "$origen" "$destino" "$0"
		if [ $? -eq 0 ]
		then 
			Log "Se ha movido exitosamente el archivo $origen a $destino"
		else
			Log "Se ha producido un error al mover $origen a $destino"
		fi

	fi
done
			
}


# 3 y 4 chequear archivos en ACEPDIR e invocar a aceptar:


function ChequearAceptados {
	# si hay archivos: 
	if [ "$(ls $ACEPDIR)" ]
	then
		echo "hay aceptados"
		if [ ! ./EstaCorriendo.sh "Reservar_B.sh" ]
		then
			echo "`./Reservar_B.sh &`"
		fi
	fi
}

# RECIBIR

ActualizarCiclo
while true
do
	ChequearArribos
	ChequearAceptados
	sleep $SLEEP
done
