#!/bin/bash

OUTPUT="caminoFeliz.out"


function FSiNo {
local var1
while [ "$var1" != "s" ] && [ "$var1" != "n" ]
do 
	read var1
done #Hasta que no contesta si o no sale del bucle

if [ "$var1" = "s" ]
then
	return "1"
else
	return "0"
fi
}

function Abortar {
	echo "test Abortado. Se borraran directorios."
	./revertInstall.sh
	#exit 0
} 
echo -e "Prueba del camino FELIZ :) \n La salida de los comandos se encuentra en $OUTPUT"
echo -e "*************INSTALACION**************\nComenzar instalación?"
if FSiNo 
then 
	Abortar
fi
#instalo
echo -e "**************INSTALACION************\n\n" > $OUTPUT
cat archivo_in_instalar.txt|./Instalar_TP.sh >> $OUTPUT
#problema en instalacion:
if [ $? -ne 0 ]
then
	echo "Se produjo un error en la instalacion"
	Abortar
fi
# chequeo algunos archivos y directorios.
if [ ! -d grupo8/bin ] || [ ! -f grupo8/procesados/combos.dis ] || [ ! -f grupo8/mae/salas.mae ] || [ ! -f grupo8/bin/Iniciar_B.sh ]
then
	echo "No se han creado los directorios correctamente."
	Abortar 
fi
echo -e "Instalacion Concluida con exito.\n\n*************INICIAR**************\nDesea Inicializar el ambiente de trabajo?"
if FSiNo
then
	Abortar
fi
echo -e "\n\n**************INICIAR************\n\n" >> $OUTPUT
echo "Inicializando el ambiente"
TP="`pwd`"
cd grupo8/bin
echo "No" >> aux
source Iniciar_B.sh < aux >>"../../$OUTPUT"
rm aux
if [ $? -ne 0 ]
then
	echo "Error al inicializar el ambiente."
	Abortar
fi
echo "arribos: $ARRIDIR"

cd $TP
echo -e  "**************FIN DEL TEST************\n\n" 
#./revertInstall.sh

