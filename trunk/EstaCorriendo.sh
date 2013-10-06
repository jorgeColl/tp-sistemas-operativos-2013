# Proceso en bas que devuelve 0 si el proceso solicitado esta corrirendo 1 o 0 veces. 
# Retorna 1 si el proceso se esta ejcutando mas de una vez
# Invocacion: ./EstaCorriendo.sh procesoAConsultar cantidadDeVeces

# --------------------------------------- 
#!/bin/bash
function EstaCorriendo {
	comandoSolicitante=`echo ${1##*/}`
	cantidadEjecuciones=`ps -e | grep "$comandoSolicitante$" | wc -l`
	if [ $cantidadEjecuciones -gt $2 ]; then
		echo "Esta corriendo MAS de $2 vez/veces"
		return 1
	else
		echo "Esta corriendo $2 o MENOS de $2 veces"
		return 0
	fi
	return 0
}
EstaCorriendo $1 $2
