# Proceso en bash que devuelve 1 si el proceso solicitado esta corrirendo n veces o mas. 
# Retorna 0 de lo contrario.
# Invocacion: ./EstaCorriendo.sh procesoAConsultar cantidadDeVeces

# --------------------------------------- 
#!/bin/bash

function EstaCorriendo {
	comandoSolicitante=`echo "${1##*/}"`
	cantidadEjecuciones=`ps -e | grep "$comandoSolicitante$" | wc -l`
	if [ $cantidadEjecuciones -ge $2 ]; then
		#echo "Esta corriendo $2 o MAS vez/veces"
		return 1
	else
		#echo "Esta corriendo MENOS de $2 veces"
		return 0
	fi
	return 0
}
if [ $# -eq 2 ]; then
	veces=$2
else
	veces=0
fi
if [ $# -ge 1 ]; then
	EstaCorriendo $1 $veces
fi
