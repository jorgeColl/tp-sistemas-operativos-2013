#Procedimiento en bash para elminar archivos.
#Parametros de ejecucion: ./Eliminar_B ubicacionArchivoOrigen

# ----------------------------------
#!/bin/bash
#Chequeamos la cantidad de parametros

	if [ $# -ne 1 ]; then
		./Grabar_L.sh "$0" "-e" "Se llamo al Eliminar_B con parametros erroneos."
		exit -1
	fi
	
	if [ ! -f $1 ]; then
		#Si entro es porque NO existe el archivo
		#Hacer un dump al log
		./Grabar_L.sh "$0" "-w" "Se llamo al Eliminar_B con un archivo inexistente."
		#echo "No existe el archivo origen"
		exit -1
	fi
	
	rm $1 > /dev/null 2> /dev/null
	./Grabar_L.sh "$0" "-i" "Se elimino el archivo: \"$1\" ."
	exit 0
