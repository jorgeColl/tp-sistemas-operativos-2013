#!/bin/bash

grupo=`pwd|grep -o "^.*grupo8"`
estado="bien"

#Funcion para grabar al Log
function Log {
        ./Grabar_L.sh "$0" '-ins' "$1"
        echo "$1"
}



function ParametrosDefault {
readonly BINDIR="$grupo/bin"
readonly MAEDIR="$grupo/mae"
readonly ARRIDIR="$grupo/arribos"
readonly ACEPDIR="$grupo/aceptados"
readonly RECHDIR="$grupo/rechazados"
readonly REPODIR="$grupo/listados"
readonly PROCDIR="$grupo/procesados"
readonly LOGDIR="$grupo/log"
readonly LOGEXT="log"
readonly DATASIZE='100'
readonly LOGSIZE='400'
}

function ExportarVariables {
export BINDIR
export MAEDIR
export ARRIDIR
export RECHDIR
export ACEPDIR
export REPODIR
export PROCDIR
export LOGDIR
export DATASIZE
export LOGEXT
export DATASIZE
export LOGSIZE
}

#Log de comando
Inilog="$LOGDIR/Iniciar_B$LOGEXT"


#Funcion auxiliar para la carga de un Si-No
function FSiNo {
local var1
while [ "$var1" != "Si" ] && [ "$var1" != "No" ]
do 
	read var1
done #Hasta que no contesta si o no sale del bucle

if [ "$var1" = "Si" ]
then
	return "1"
else
	return "0"
fi
}

#INICIO DE EJECUCION-----------------------------------------------------------------
# Paso 1 Inicializar el archivo de log, si no estaba lo crea.

function InicioLog {
if [ -f "$Inilog" ];
then
        Log "Existe "$Inilog""
else
        touch "$Inilog" 
fi

Log "Comando Iniciar_B inicio de Ejecucion"
}

InicioLog



#Paso 2 Verificar que la instalación está completa

if [ -d "$CONFDIR" ]; then

	Log "Se ha efectuado la instalacion de Reservas_B"
	echo "Directorio de configuracion:"$CONFDIR"" #Muestro su path
	ls "$CONFDIR"
	Log "Comprobando si hay faltantes ... "
	
	if [ -d "$BINDIR" ];
	then
	echo  "Ejecutables: $BINDIR "
		if [ -f "$BINDIR/EstaInicializado.sh" -a -f "$BINDIR/Grabar_L.sh" -a -f "$BINDIR/Reservar_B.sh" -a -f "$BINDIR/Stop_D.sh" -a -f "$BINDIR/Start_D.sh" -a -f "$BINDIR/Imprimir_B.pl" -a -f "$BINDIR/Recibir_B.sh" -a -f "$BINDIR/Eliminar_B.sh" -a -f "$BINDIR/EstaCorriendo.sh" ]; #chequea q esten todas las funciones
		then
			Log "Se encuentran todos los ejecutables"
			ls "$BINDIR"
			#Pruebo si todos estos tienen permiso de ejecucion
			if [ -x "$BINDIR/EstaInicializado.sh" -a -x "$BINDIR/Grabar_L.sh" -a -x "$BINDIR/Reservar_B.sh" -a -x "$BINDIR/Stop_D.sh" -a -x "$BINDIR/Start_D.sh" -a -x "$BINDIR/Imprimir_B.pl" -a -x "$BINDIR/Recibir_B.sh" -a -x "$BINDIR/Eliminar_B.sh" -a -x "$BINDIR/EstaCorriendo.sh" ];
			then
			Log "Todos los ejecutables con permiso de ejecucion"
			else
			Log "Listado de ejecutables sin permiso de ejecucion"
			 if [ ! -x "$BINDIR/Grabar_L.sh" ]; #para imprimir cual falta
                        then
                                echo -e "Grabar_L.sh"
                        fi

                        if [ ! -x "$BINDIR/Reservar_B.sh" ];
                        then
                                echo -e "Reservar_B.sh"
                        fi

                        if [ ! -x "$BINDIR/Imprimir_B.pl" ];
                        then
                                echo -e "Imprimir_B.sh"
                        fi

                        if [ ! -x "$BINDIR/Stop_D.sh" ];
                        then
                                echo -e "Stop_D.sh"
                        fi

                        if [ ! -x "$BINDIR/Star_D.sh" ];
                        then
                                echo -e "Start_D.sh"
                        fi

                        if [ ! -x "$BINDIR/Eliminar_B.sh" ];
                        then
                                echo -e "Eliminar_B.sh"
                        fi

			if [ ! -x "$BINDIR/EstaCorriendo.sh" ];
                        then
                                echo -e "EstaCorriendo.sh"
                        fi

                        if [ ! -x "$BINDIR/EstaInicializado.sh" ];
                        then
                                echo -e "EstaInicializado.sh"
                        fi

                        if [ ! -x "$BINDIR/Recibir_B.sh" ];
                        then
                                echo -e "Recibir_B.sh"
                        fi

			$estado="mal"	
			fi
		else
		
			Log "Listado de componentes faltantes:"
			
			if [ ! -f "$BINDIR/Grabar_L.sh" ]; #para imprimir cual falta
                        then
                                echo -e "Grabar_L.sh"
                        fi
                       
                        if [ ! -f "$BINDIR/Reservar_B.sh" ];
                        then
                                echo -e "Reservar_B.sh"
                        fi
                       
                        if [ ! -f "$BINDIR/Imprimir_B.pl" ];
                        then
                                echo -e "Imprimir_B.sh"
                        fi

                        if [ ! -f "$BINDIR/Stop_D.sh" ];
                        then
                                echo -e "Stop_D.sh"
                        fi
                       
                        if [ ! -f "$BINDIR/Star_D.sh" ];
                        then
                                echo -e "Start_D.sh"
                        fi
                       
                        if [ ! -f "$BINDIR/Eliminar_B.sh" ];
                        then
                                echo -e "Eliminar_B.sh"
                        fi

			if [ ! -f "$BINDIR/EstaCorriendo.sh" ];
                        then
                                echo -e "EstaCorriendo.sh"
                        fi

			if [ ! -f "$BINDIR/EstaInicializado.sh" ];
                        then
                                echo -e "EstaInicializado.sh"
                        fi

			if [ ! -f "$BINDIR/Recibir_B.sh" ];
                        then
                                echo -e "Recibir_B.sh"
                        fi
		
		Log "Estado de la instalacion INCOMPLETO. Proceso de Inicializacion cancelado"
	$estado="mal"
	fi
fi #salgo de los ejecutables

		Log "Viendo archivos Maestros:"
		if [ -d "$MAEDIR" ];
		then
			echo "$MAEDIR"

			if [ -f "$MAEDIR/obras.mae" -a -f "$MAEDIR/salas.mae" ];			then
			ls "$MAEDIR"

			else
			if [ ! -f "$MAEDIR/obras.mae" ];
                        then
                                echo -e "obras.mae"
                        fi
			if [ ! -f "$MAEDIR/salas.mae" ];
                        then
                                echo -e "salas.mae"
                        fi
			Log "Faltan algun/os archivos maestros"
			$estado="mal"
			fi
			
		fi

		Log "Viendo archivo de disponibilidad"
		if [ -d "$PROCDIR" ];
		then
			echo "$PROCDIR"
			if [ -f "$PROCDIR/combos.dis" ];
			then
			ls "$PROCDIR"
			else
			Log "Falta archivo de disponibilidades:"
			Log "combos.dis"
			$estado="mal"
			fi
		fi
	
	# Verifico si quedo bien el estado		
	if [ $estado="bien" ];
	then
	Log "Proceso de inicializacion comprobado exitosamente"
	else
	Log "Proceso de Inicializacion cancelado"
	exit
	fi
else
	Log "Proceso de instalacion nunca empezado"
	Log "Debe proceder a ejecutar el comando ./Instalar_TP.sh y seguir las indicaciones"
	rm "$Inilog" 
	exit
fi

#Paso casi 3 Compruebo que este siendo llamado de la forma: . ./Iniciar_B.sh
#Por cuestiones de compatibilidad solo despliego el warning y no realizo ninguna accion
if [ $0 != "bash" ];
then
	Log 'WARNING: Recordar correr Iniciar_B.sh de la forma: . ./Iniciar_B.sh '
	Log 'Iniciar_B.sh Finaliza MAL'
fi

#Paso 3 y 4 Verificar si el ambiente ya ha sido inicializado.
if ! ./EstaInicializado.sh
then	
	ParametrosDefault
	ExportarVariables
else
	Log 'Ambiente ya inicializado, si quiere reiniciar termine su sesión e ingrese nuevamente'
fi


#Paso 5 Ver si se desea arrancar Recibir_B
echo "Desea efectuar la activación de Recibir_B? Si – No"
if FSiNo
then
	Log "Si desea ejecutar Recibir_B en algun momento, hagalo de esta forma:"
	Log './Start_D.sh ./Recibir_B.sh '
	return 0
else
	if ./EstaCorriendo.sh "Recibir_B.sh" "1"
	then
		Log "iniciando Recibir_B..."
		./Start_D.sh ./Recibir_B.sh "Iniciar_B.sh"
		
	fi
	Log "Cuando quiera terminar la ejecución de Recibir_B hagalo de esta forma:"
	Log "./Stop_D.sh ./Recibir_B.sh"
	
fi

