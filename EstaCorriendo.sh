# Proceso en bas que devuelve 0 si el proceso solicitado esta corrirendo 1 o 0 veces. 
# Retorna 1 si el proceso se esta ejcutando mas de una vez
# Invocacion: ./EstaCorriendo.sh procesoAConsultar

# --------------------------------------- 
#!/bin/bash
	cantidadEjecuciones=`ps -e | grep "$1$" | wc -l`
	if [ $cantidadEjecuciones -gt 1 ]; then
		echo "Esta corriendo MAS de una vez"
		exit 1
	else
		echo "Esta corriendo una o MENOS veces"
		exit 0
	fi
	exit 0
