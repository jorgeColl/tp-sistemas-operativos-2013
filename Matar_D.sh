#Matar_B
#Procedimiento en bash para la finalizacion brusa de un proceso
#Parametros de ejecucion: ./Matar_B nombreProceso o ./Matar_B idProceso

#Bugs conocidos: 
#Porque tantos sed sed '/^$/d'? Porque cada vez que paso a una variable se me mueren los fines de linea y tengo que arrancar de nuevo.

# ----------------------------------
#!/bin/bash

#Chequeamos la cantidad de parametros
	if [ $# -ne 1 ]; then
		echo "Parametros de ejecucion: ./Matar_B nombreProceso o ./Matar_B idProceso"
		exit -1
	fi
	cantidad=`ps -e | grep -E "$1$"`
	#echo ${cantidad}
	cantidadEncontrada=`echo $cantidad | sed '/^$/d' | wc -l`
	#echo ${cantidadEncontrada:-0}
	if [ ${cantidadEncontrada:-0} -eq 0 ]; then
		#No se esta ejecutando ese proceso
		echo "El proceso: $1 no se esta ejecutando" #Escribir en log
	else 
		#Saco el resto de la linea
		ps -e | grep -E "$1" | sed '/^$/d' > archivoAuxiliarMatar_D.tmp
		while read linea
		do
			p_id=`echo ${linea% *}`
			p_id=`echo ${p_id% *}`
			p_id=`echo ${p_id% *}`	
			#Se necesitan los 3, NO es un error.

			#echo $cantidad
			kill ${p_id:-0}
			#Escribir en log
			echo "El proceso: $1 ha finalizado" #Escribir en log
		done < archivoAuxiliarMatar_D.tmp
		rm archivoAuxiliarMatar_D.tmp
	fi
	exit 0
