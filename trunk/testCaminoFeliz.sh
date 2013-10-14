#!/bin/bash

OUTPUT="caminoFeliz.out"

TP="`pwd`"

function fSiNo {
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
	echo "test Abortado."
	read var
	exit 1
} 
echo -e "Prueba del camino FELIZ :) \n La salida de los comandos se encuentra en $OUTPUT"
echo -e "*************INSTALACION**************\nComenzar instalación?"
if fSiNo 
then 
	Abortar
fi
#instalo
echo -e "**************INSTALACION************\n\n" > $OUTPUT
cat archivo_in_instalar.txt|./Instalar_TP.sh >> $OUTPUT
#problema en instalacion:
if [ $? -ne 0 ]
then
	echo "Se produjo un error en la instalacion."
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
echo -e "Instalacion Concluida con éxito."

# INICIALIZAR EL AMBIENTE

echo -e "\n\n*************INICIAR**************\nDesea Inicializar el ambiente de trabajo?"
if fSiNo
then
	Abortar
fi
echo -e "\n\n**************INICIAR************\n\n" >> $OUTPUT
echo "Inicializando el ambiente"
cd grupo8/bin
echo "No" >> aux
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

# RECIBIR Y RESERVAR. COPIO ARCHIVOS DE ENTRADA.

echo -e "\n\n*************RECIBIR+RESERVAR**************\nCopiar archivos de entrada?"
if fSiNo
then
	Abortar
fi
echo -e "\n\n**************RECIBIR+RESERVAR************\n\n" >> $OUTPUT
echo "Moviendo archivos de entrada a la carpeta de arribos."
for archivo in `ls datos`
do
	cp "datos/$archivo" "$ARRIDIR/$archivo"
done

# INICIO RECIBIR
echo -e "Iniciar recibir?"
if fSiNo
then
	Abortar
fi
echo "Iniciando Recibir_B.sh"
cd $BINDIR
./Start_D.sh Recibir_B.sh >> /dev/null
sleep 15
echo "Copiando el log de Recibir."
cd $TP
echo -e "\n\n*************LOG RECIBIR************\n\n" >> $OUTPUT
cat $LOGDIR/Recibir_B.sh.$LOGEXT >> $OUTPUT
echo "Copiando el log de Reservar."
echo -e "\n\n**************LOG RESERVAR************\n\n" >> $OUTPUT
cat $LOGDIR/Reservar_B.sh.$LOGEXT >> $OUTPUT
echo "Copiando archivos en PROCDIR"
echo -e "\n\n**************ARCHIVOS EN PROCDIR************\n\n" >> $OUTPUT
for archivo in `ls $PROCDIR`
do
	echo "ARCHIVO: $archivo" >> $OUTPUT
	cat $PROCDIR/$archivo >> $OUTPUT
	echo -e "\n\n" >> $OUTPUT
done
cd $BINDIR
./Matar_D.sh Recibir_B.sh >> /dev/null


# IMPRIMIR

echo -e "\n\n*************IMPRIMIR**************\n\nIniciar Imprimir?"
if fSiNo
then
	Abortar
fi
echo -e "\n\n**************IMPRIMIR************\n\n" >> ../../$OUTPUT

echo "Probando evento con lista de invitados."
echo "6" | ./Imprimir_B.pl -i -w >> /dev/null
echo -e "\n************RESERVA CON LISTA DE INVITADOS\n" >> ../../$OUTPUT
cat "$REPODIR/C00010023.inv" >> ../../$OUTPUT

echo "Probando evento sin lista de invitados."
echo "1" | ./Imprimir_B.pl -i -w >> /dev/null
echo -e "\n************RESERVA SIN LISTA DE INVITADOS\n" >> ../../$OUTPUT
cat "$REPODIR/C00010018.inv" >> ../../$OUTPUT

echo "Probando disponibilidad de obras."
echo -e "\n**********DISPONIBILIDAD DE LA OBRA CON ID: 1\n" >> ../../$OUTPUT
echo -e "-o\n1"| ./Imprimir_B.pl -d >> ../../$OUTPUT

echo "Probando disponibilidad de salas."
echo -e "\n**********DISPONIBILIDAD DE LA SALA CON ID: 12\n">> ../../$OUTPUT
echo -e "-s\n12"| ./Imprimir_B.pl -d >> ../../$OUTPUT

echo "Probando ranking de reservas."
echo -e "\n**********RANKING DE RESERVAS \n" >> ../../$OUTPUT
./Imprimir_B.pl -r >> ../../$OUTPUT

echo "Probando impresión de ticket."
echo -e "\n**********GENERANDO TICKET DE RESERVAS CONFIRMADAS \n" >> ../../$OUTPUT
echo "C00010026"|./Imprimir_B.pl -t >> ../../$OUTPUT


echo -e  "**************FIN DEL TEST************\n\n" 

cd $TP

