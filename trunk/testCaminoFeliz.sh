#!/bin/bash

OUTPUT="caminoFeliz.out"

TP="`pwd`"

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
	cd $TP
	echo "test Abortado. Se borraran directorios."
	./revertInstall.sh
	read var
	exit 0
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
#copio el log de la instalacion:
echo "Copiando el log de la instalacion." 
echo -e "\n\n**************LOG INSTALACION************\n\n" >> $OUTPUT
cat instalacion.log >> $OUTPUT
echo "Copiando Instalar_TP.conf ."
echo -e "\n\n**************ARCHIVO CONFIGURACION************\n\n" >> $OUTPUT
cat grupo8/conf/Instalar_TP.conf >> $OUTPUT
echo -e "Instalacion Concluida con exito.\n\n*************INICIAR**************\nDesea Inicializar el ambiente de trabajo?"
if FSiNo
then
	Abortar
fi
echo -e "\n\n**************INICIAR************\n\n" >> $OUTPUT
echo "Inicializando el ambiente"
cd grupo8/bin
echo "Si" >> aux
source Iniciar_B.sh < aux >>"../../$OUTPUT"
if [ $? -ne 0 ]
then
	echo "Error al inicializar el ambiente."
	Abortar
fi
rm aux
cd $TP
echo "Copiando el log de iniciar."
echo -e "\n\n**************LOG INICIAR************\n\n" >> $OUTPUT
cat "grupo8/conf/Iniciar_B.sh.$LOGEXT" >> $OUTPUT
echo -e "\n\n**************RECIBIR+RESERVAR************\n\n" >> $OUTPUT
echo "Se moveran algunos archivos a la carpeta de arribos."
for archivo in `ls ../../datos`
do
	cp "../../datos/$archivo" "$ARRIDIR/$archivo"
done



echo -e  "**************FIN DEL TEST************\n\n" 
#./revertInstall.sh

