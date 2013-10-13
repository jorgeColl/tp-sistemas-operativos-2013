#Logger
#Procedimiento en bash para el registro de logs.
#Parametros de ejecucion: ./Grabar_L comandoSolicitante tipoDeMensaje mensaje
#El tipo de mensaje es opcional, por lo tanto, se puede invocar como: ./Grabar_L comandoSolicitante mensaje
#Opcion por defecto 'Informativo = I'
#LOGSIZE debe estar ingresado en Bytes
#Bugs conocidos:

# ----------------------------------
#!/bin/bash
#Chequeamos la cantidad de parametros, con este decidimos que es cada uno.
	comandoSolicitante=`echo ${1##*/}`
	
	if ! ./EstaInicializado.sh
	then
		#No esta inicializado, no puedo usar el log
		exit -1
	fi
	if [ $# -lt 2 -o $# -gt 3 ]; then
		echo -e "Invocacion incorrecta. Las correctas son: \n./Grabar_L comandoSolicitante tipoDeMensaje mensaje \n./Grabar_L comandoSolicitante mensaje "
		exit -1
	fi
	if [ $# -eq 2 ]; then
		mensaje=$2
		opcion="-i"
	else
		mensaje=$3
		opcion=$2
	fi
	case $opcion in
	-i ) 
		opcion="Informativo";;
	-e )
		opcion="Error";;
	-fe )
		opcion="Fatal Error";;
	-ins ) 
		;;
	* )
		opcion="Warning" ;;
	esac
	
	#Ahora debo crear la estructura de directorio
	if [ $opcion = "-ins" ]; then
		archDestino="${CONFIGDIR}instalacion.log"
		#echo $archDestino
	else
		archDestino="${LOGDIR}/${comandoSolicitante}.${LOGEXT}"
	fi
	#Recorto el mensaje de ser necesario
	if [ ${#mensaje} -gt 120 ]; then
		#Debo recortarlo.
		mensaje=`echo "${mensaje:0:120}"`
	fi
	
	#Si es menor, lo pongo tal cual esta.
	
	#Calculo el tiempo
	tiempo=`date | sed 's/ ... [0-9]\{0,4\}$//' | sed "s/ /-/g"`
	mensajeFinal="$tiempo;$comandoSolicitante;$comandoSolicitante;$opcion;$mensaje;"
	
	#Ahora lo agrego al archivo.
	echo "$mensajeFinal" >> "$archDestino"
	#echo "$mensajeFinal en $archDestino"
	
	#Obtengo el tamanio del archivo.
	tamanio=0
	if [ ! opcion = "-ins" ]; then
		tamanio=`ls -l | grep "$comandoSolicitante.$LOGEXT" | sed -E 's/^[^ ]* [^ ]* [^ ]* [^ ]* //g'`
		tamanio=`echo $tamanio | sed -E 's/ .*//'` 
		#tamanio=`expr $tamanio + 0`
	fi
	if [ ${tamanio:-0} -gt "$LOGSIZE" ]; then
		`sed -E "1,50 d" "$archDestino" > "$archDestino"`
		echo "$tiempo;Se ha recortado el archivo de Log;" >> "$archDestino"
	fi
	exit 0
