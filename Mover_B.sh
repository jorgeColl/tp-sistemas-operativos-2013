#Procedimiento en bash para el movimiento de archivos.
#En caso de encontrar archivos duplicados se dejaran en el destino pero con una numeracion final.
#Ejmplo: nombrearchivo.N
#Parametros de ejecucion: ./mover ubicacionArchivoOrigen ubicacionArchivoDestino comandoSolicitante -c(opcional)

#Bugs conocidos: Se puede llegar a pisar una secuencia existente.

# ----------------------------------
#!/bin/bash
#Chequeamos la cantidad de parametros

	if [ $# -lt 2 ]; then
		#echo "Es necesario introducir, al menos, 2 parámetros: $0 archOrigen archDestino"
		./Grabar_L.sh "$0" "-e" "Se llamo al mover con parametros erroneos." &> /dev/null
		exit -1
	fi
	if [ $# -gt 4 ]; then
		#echo "Demasiados argumentos, el maximo es de 4."
		./Grabar_L.sh "$0" "-e" "Se llamo al mover con parametros erroneos." &> /dev/null
		exit -1
	fi
	
	if [ "$1" = "$2" ]; then
		#Esto puede ir al log. (NO)
		#echo "Las rutas origen y destino son iguales, el archivo no se movera"
		exit 0
	fi
	
	if [ ! -f "$1" ]; then
		#Si entro es porque NO existe el archivo
		#Hacer un dump al log
		./Grabar_L.sh "$0" "-e" "Se llamo al mover con un archivo origen inexistente. $1" &> /dev/null
		#echo "No existe el archivo origen"
		exit -1
	fi
	
	#Inicializo el modo copia en falso
	copia=0 
	for param in "$@"
	do
		#Recorro todos los parametros y me fijo si existe la opción de copia.
		if [ "$param" = "-c" ]; then
			copia=1
		fi
		#echo -e "$param"
	done
	
	#Separo los parametros en nombre de arhivo y directorio
	archOrigen=`echo ${1##*/}`
	archDestino=`echo ${2##*/}`
	dirDestino=`echo ${2%/*}`
	#Reviso si ya existe el archivo
	repeticiones=`ls "${dirDestino}" | grep "${archDestino}" | wc -l`
	
	#echo $archOrigen $archDestino
	#echo $dirDestino
	#echo $repeticiones
	
	archDestino="$2"
	if [ -f "$2" ]; then
		#Hay repeticiones, modifico la ruta destino
		#let repeticiones=$repeticiones+1
		archDestino=`echo "$2"$repeticiones`
	fi
	
	archDestino=`echo "$archDestino" | sed -E "s/ /\\\ /g"` 	#Reemplazo los espacios por '\ ', luego quito los doble "\"
	#archDestino=`echo "$archDestino" | sed -E "s/\\\\/\\/g"`
	archInicio=`echo "$1" | sed -E "s/ /\\\ /g"`
	#archInicio=`echo "$archInicio" | sed -E "s/\\\\/\\/g"`
	
	echo "$archInicio"
	echo "$archDestino"
	if [ ${copia:-0} -eq 1 ]; then
		#Debo COPIAR, no mover
		`cp "${archInicio}" "${archDestino}" 2> /dev/null`
	else
		`mv "${archInicio}" "${archDestino}" 2> /dev/null`
	fi
	if [ $? -eq 0 ]; then
		./Grabar_L.sh "$0" "-i" "El mover fue ejecutado correctamente: $archOrigen -> $archDestino" &> /dev/null
		#El mover fue ejecutado correctamente. Podemos escribir en el log
		exit 0
	fi
	#El mover presento errores
	#echo "Error en el mover"
	./Grabar_L.sh "$0" "-e" "El mover tuvo errores! $archOrigen -> $archDestino" &> /dev/null
	#Escribir en el log
	exit -1
