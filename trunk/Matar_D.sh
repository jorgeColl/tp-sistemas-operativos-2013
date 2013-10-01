#Matar_B
#Procedimiento en bash para la finalizacion brusa de un proceso
#Parametros de ejecucion: ./Matar_B nombreProceso o ./Matar_B idProceso

#Bugs conocidos:

# ----------------------------------
#!/bin/bash

#Chequeamos la cantidad de parametros
	if [ $# -ne 1 ]; then
		echo "Parametros de ejecucion: ./Matar_B nombreProceso o ./Matar_B idProceso"
		exit -1
	fi
	cantidad=`ps | grep -E "$1"`
	#echo ${cantidad:-0}
	cantidadEncontrada=`echo $cantidad | sed '/./!d' | wc -l`
	#echo ${cantidadEncontrada:-0}
	if [ ${cantidadEncontrada:-0} -eq 0 ]; then
		#No se esta ejecutando ese proceso
		echo "El proceso: $1 no se esta ejecutando" #Escribir en log
	else 
		#Saco el resto de la linea
		cantidad=`echo ${cantidad% *}`
		cantidad=`echo ${cantidad% *}`
		cantidad=`echo ${cantidad% *}`
		#Se necesitan los 3, NO es un error.
		
		#echo $cantidad
		kill ${cantidad:-0}
		#Escribir en log
		echo "El proceso: $1 ha finalizado" #Escribir en log
	fi
	exit 0
