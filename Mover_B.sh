#Procedimiento en bash para el movimiento de archivos.
#En caso de encontrar archivos duplicados se dejaran en el destino pero con una numeracion final.
#Ejmplo: nombrearchivo.N
#Parametros de ejecucion: ./mover ubicacionArchivoOrigen ubicacionArchivoDestino comandoSolicitante

#Bugs conocidos: Se puede llegar a pisar una secuencia existente.

# ----------------------------------
#!/bin/bash
#Chequeamos la cantidad de parametros

	if [ $# -lt 2 ]; then
		echo "Es necesario introducir, al menos, 2 parámetros: $0 archOrigen archDestino"
		#Aqui hay que empujar algo al log
		exit -1
	fi
	if [ $# -gt 3 ]; then
		echo "Demasiados argumentos, el maximo es de 3."
		exit -1
	fi
	if [ $1 = $2 ]; then
		#Esto puede ir al log.
		echo "Las rutas origen y destino son iguales, el archivo no se movera"
		exit 0
	fi
	if [ ! -f $1 ]; then
		#Si entro es porque NO existe el archivo
		#Hacer un dump al log
		echo "No existe el archivo origen"
		exit -1
	fi
	#Separo los parametros en nombre de arhivo y directorio
	archOrigen=`echo ${1##*/}`
	archDestino=`echo ${2##*/}`
	dirDestino=`echo ${2%/*}`
	#Reviso si ya existe el archivo
	repeticiones=`ls ${dirDestino} | grep ${archDestino} | wc -l`
	
	echo $archOrigen $archDestino
	echo $dirDestino
	echo $repeticiones
	
	if [ ! -f $2 ]; then
		#El archivo no existe en el destino.
		`mv ${1} ${2}`
	else
		#Hay repeticiones, modifico la ruta destino
		#let repeticiones=$repeticiones+1
		archDestino=`echo $2$repeticiones`
		`mv ${1} ${archDestino}`
	fi
	if [ $? -eq 0 ]; then
		#El mover fue ejecutado correctamente. Podemos escribir en el log
		exit 0
	fi
	#El mover presento errores
	echo "Error en el mover"
	#Escribir en el log
	exit -1
