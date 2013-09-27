#Logger
#Procedimiento en bash para el registro de logs.
#Parametros de ejecucion: ./Grabar_L comandoSolicitante tipoDeMensaje mensaje
#El tipo de mensaje es opcional, por lo tanto, se puede invocar como: ./Grabar_L comandoSolicitante mensaje
#Opcion por defecto 'Informativo = I'
#Bugs conocidos:

# ----------------------------------
#!/bin/bash
#Chequeamos la cantidad de parametros, con este decidimos que es cada uno.
	comandoSolicitante=$1
	if [ $# -lt 2 -o $# -gt 3 ]; then
		echo -e "Invocacion incorrecta. Las correctas son: \n./Grabar_L comandoSolicitante tipoDeMensaje mensaje \n./Grabar_L comandoSolicitante mensaje "
		exit -1
	fi
	if [ $# -eq 2 ]; then
		mensaje=$2
		opcion="I"
	else
		opcion=$2
		mensaje=$3
	fi
	
	#Ahora debo crear la estructura de directorio
	archDestino="$LOGDIR$comandoSolicitante.$LOGEXT"
	
	#Recorto el mensaje de ser necesario
	if [ ${#mensaje} -gt 120 ]; then
		#Debo recortarlo.
		mensaje=`echo ${mensaje:0:120}`
	fi
	
	#Si es menor, lo pongo tal cual esta.
	
	#Calculo el tiempo
	tiempo=`date | sed 's/ ... [0-9]\{0,4\}$//' | sed "s/ /-/g"`
	mensajeFinal="$tiempo;$comandoSolicitante;$comandoSolicitante;$opcion;$mensaje;"
	
	#Ahora lo agrego al archivo.
	echo $mensajeFinal >> $archDestino
	#echo "$mensajeFinal en $archDestino"
	exit 0
