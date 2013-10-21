#!/bin/bash

grupo=`pwd|grep -o "^.*grupo8"`

estado="bien"
#Funcion para grabar al Log
function Log {
        ./Grabar_L.sh "Iniciar_B.sh" "$1"
        echo "$1"
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

function Reiniciar {
export BINDIR=""
export MAEDIR=""
export ARRIDIR=""
export RECHDIR=""
export ACEPDIR=""
export REPODIR=""
export PROCDIR=""
export LOGDIR=""
export DATASIZE=""
export LOGEXT=""
export DATASIZE=""
export LOGSIZE=""
}

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


function CargarDelConf {
miArreglo1=()
miArreglo2=()

let a=0
IFS='='
while read -r -a nombre      
do
	miArreglo1[a]=$nombre
	miArreglo2[a]=${nombre[1]}
	let a+=1
done < "$Instconf"
unset IFS
export grupo="${miArreglo2[0]}"
export CONFDIR="${miArreglo2[1]}"
export BINDIR="${miArreglo2[2]}"
export MAEDIR="${miArreglo2[3]}"
export ARRIDIR="${miArreglo2[4]}"
export ACEPDIR="${miArreglo2[5]}"
export RECHDIR="${miArreglo2[6]}"
export REPODIR="${miArreglo2[7]}"
export PROCDIR="${miArreglo2[8]}"
export LOGDIR="${miArreglo2[9]}"
export LOGEXT="${miArreglo2[10]}"
export DATASIZE="${miArreglo2[11]}"
export LOGSIZE="${miArreglo2[12]}"
}

function VerPermisos {

 #Pruebo si todos estos tienen permiso de ejecucion
if [ -x "$BINDIR/EstaInicializado.sh" -a -x "$BINDIR/Grabar_L.sh" -a -x "$BINDIR/Reservar_B.sh" -a -x "$BINDIR/Stop_D.sh" -a -x "$BINDIR/Start_D.sh" -a -x "$BINDIR/Imprimir_B.pl" -a -x "$BINDIR/Recibir_B.sh" -a -x "$BINDIR/EstaCorriendo.sh" -a -x "$BINDIR/Mover_B.sh" ];
	 then
   	 Log "Todos los ejecutables con permiso de ejecucion"
else
     	  Log "Listado de ejecutables sin permiso de ejecucion"
          if [ ! -x "$BINDIR/Grabar_L.sh" ]; #para imprimir cual falta
          then
          Log   "Grabar_L.sh"
	  	chmod +x "$BINDIR/Grabar_L.sh"
          fi

          if [ ! -x "$BINDIR/Reservar_B.sh" ];
          then
          Log   "Reservar_B.sh"
		chmod +x "$BINDIR/Reservar_B.sh"
          fi

         if [ ! -x "$BINDIR/Imprimir_B.pl" ];
         then
         Log   "Imprimir_B.sh"
		chmod +x "$BINDIR/Imprimir_B.sh"
         fi

	 if [ ! -x "$BINDIR/Stop_D.sh" ];
         then
         Log   "Stop_D.sh"
		chmod +x "$BINDIR/Stop_D.sh"
	 fi

         if [ ! -x "$BINDIR/Start_D.sh" ];
         then
         Log   "Start_D.sh"
		chmod +x "$BINDIR/Start_D.sh"
         fi

        if [ ! -x "$BINDIR/EstaCorriendo.sh" ]; 
        then
        Log   "EstaCorriendo.sh"
	      chmod +x "$BINDIR/EstaCorriendo.sh"
        fi

        if [ ! -x "$BINDIR/EstaInicializado.sh" ];
        then
        Log   "EstaInicializado.sh"
	chmod +x "$BINDIR/EstaInicializado.sh"
        fi

        if [ ! -x "$BINDIR/Recibir_B.sh" ];
        then
        Log   "Recibir_B.sh"
	chmod +x "$BINDIR/Recibir_B.sh"
        fi
	Log "Se dieron los permisos necesarios de el/los archivos sin permisos"
fi
}


#INICIO DE EJECUCION-----------------------------------------------------------------

#Paso 3 y 4 Verificar si el ambiente ya ha sido inicializado.
./EstaInicializado.sh >> /dev/null
if [ $? -eq 0 ]
then	
	Log 'Ambiente ya inicializado, si quiere reiniciar termine su sesión e ingrese nuevamente'
	return 1
fi

	

#Paso 2 Verificar que la instalación está completa

if [ -f "$grupo/conf/Instalar_TP.conf" ]; then
	Instconf="$grupo/conf/Instalar_TP.conf"
	CargarDelConf
	
	if [ ! -f "$BINDIR/Grabar_L.sh" ]; then
	echo "No se encuentra la funcion Grabar_L"
	echo "Proceso de inicializacion cancelado."
	Reiniciar
	return 1
	fi
	
	Log "Se ha efectuado la instalacion de Reservas_B"
	echo "directorio de conf: $Instconf"
	echo""
	Log "Directorio de configuracion: $CONFDIR"
	ls "$CONFDIR"
	echo""
	Log "Comprobando si hay faltantes ... "
	echo ""
	if [ -d "$BINDIR" ];
	then
		Log  "Ejecutables: $BINDIR "
		if [ -f "$BINDIR/EstaInicializado.sh" -a -f "$BINDIR/Grabar_L.sh" -a -f "$BINDIR/Reservar_B.sh" -a -f "$BINDIR/Stop_D.sh" -a -f "$BINDIR/Start_D.sh" -a -f "$BINDIR/Imprimir_B.pl" -a -f "$BINDIR/Recibir_B.sh" -a -f "$BINDIR/EstaCorriendo.sh" -a -f "$BINDIR/Mover_B.sh" ]; #chequea q esten todas las funciones
		then
			Log "Se encuentran todos los ejecutables"
			ls "$BINDIR"
		else
				
			Log "Listado de componentes faltantes:"
			
			if [ ! -f "$BINDIR/Grabar_L.sh" ]; #para imprimir cual falta
                        then
                                 Log   "Grabar_L.sh"
                        fi
                       
                        if [ ! -f "$BINDIR/Reservar_B.sh" ];
                        then
                                 Log   "Reservar_B.sh"
                        fi
                       
                        if [ ! -f "$BINDIR/Imprimir_B.pl" ];
                        then
                                 Log   "Imprimir_B.sh"
                        fi

                        if [ ! -f "$BINDIR/Stop_D.sh" ];
                        then
                                 Log   "Stop_D.sh"
                        fi
                       
                        if [ ! -f "$BINDIR/Start_D.sh" ];
                        then
                                 Log   "Start_D.sh"
                        fi
                       
                       	if [ ! -f "$BINDIR/EstaCorriendo.sh" ];
                        then
                                 Log   "EstaCorriendo.sh"
                        fi

			if [ ! -f "$BINDIR/EstaInicializado.sh" ];
                        then
                                 Log   "EstaInicializado.sh"
                        fi

			if [ ! -f "$BINDIR/Recibir_B.sh" ];
                        then
                                 Log   "Recibir_B.sh"
                        fi
			
			if [ ! -f "$BINDIR/Mover_B.sh" ];
                        then
                                 Log   "Mover_B.sh"
                        fi
			
			
		
		Log "Estado de la instalacion INCOMPLETO"
		estado="mal"
	fi
fi #salgo de los ejecutables
echo ""
	Log "Viendo archivos Maestros:"
	if [ -d "$MAEDIR" ];
	then
		Log "Ruta de los maestros:"
		Log "$MAEDIR"
		if [ -f "$MAEDIR/obras.mae" -a -f "$MAEDIR/salas.mae" ];
		then
			ls "$MAEDIR"
		else
			if [ ! -f "$MAEDIR/obras.mae" ];
        		then
                		Log   "Falta: obras.mae"
        		fi
			if [ ! -f "$MAEDIR/salas.mae" ];
			then
			         Log   "Falta: salas.mae"
			fi
		Log "Faltan algun/os archivos maestros"
		estado="mal"
		fi
	else
	Log "Falta carpeta entera de archivos Maestros"
	estado="mal"
	fi

	echo""
	Log "Viendo archivo de disponibilidad"
	if [ -d "$PROCDIR" ];
	then
		Log "$PROCDIR"
		if [ -f "$PROCDIR/combos.dis" ];
		then
			ls "$PROCDIR"
		else
			Log "Falta archivo de disponibilidades:"
			Log "combos.dis"
			estado="mal"
		fi
	else
	Log "Falta carpeta entera de archivo de Disponibilidades"
	estado="mal"
	fi

	if [ ! -d "$ARRIDIR" ]
	then
	Log "Falta el directorio para el arribo de archivos"
	estado="mal"
	fi
	
	if [ ! -d "$RECHDIR" ]
	then
	Log "Falta el directorio para los archivos rechazados"
	estado="mal"
	fi

	if [ ! -d "$REPODIR" ]
	then
	Log "Falta el directorio para los archivos de listado de salida"
	estado="mal"
	fi

	if [ ! -d "$LOGDIR" ]
	then
	Log "Falta el directorio para el log"
	estado="mal"
	fi

	if [ ! -d "$ACEPDIR" ]
	then
	Log "Falta el directorio para los archivos aceptados"
	estado="mal"
	fi
	
	# Verifico si quedo bien el estado		
	if [ "$estado" = "bien" ];
	then
		echo""
		Log "Proceso de comprobacion realizado exitosamente"
		echo""
	else
		Log "Hay errores en la comprobacion de la Instalacion"
		Log "Debe proceder a ejecutar el comando ./Instalar_TP.sh y/o seguir las indicaciones del Readme correspondiente"
		Reiniciar
		return 1
	fi
else
	Log "Proceso de instalacion erroneo. No se encuentra el archivo de configuracion de la Instalacion (Instalar_TP.conf)"
	Log "Debe proceder a ejecutar el comando ./Instalar_TP.sh y/o seguir las indicaciones del Readme correspondiente"
	return 1
fi

#Paso casi 3 Compruebo que este siendo llamado de la forma: . ./Iniciar_B.sh
#Por cuestiones de compatibilidad solo despliego el warning y no realizo ninguna accion
if [ "$0" != "bash" ];
then
	Log 'WARNING: Recordar correr Iniciar_B.sh de la forma: . ./Iniciar_B.sh '

fi
echo ""

VerPermisos
echo ""
#Agrego al final del path a mis binarios

export PATH="$PATH:$BINDIR"
Log "Se seteo la ruta: "$BINDIR" en la variable PATH"
echo""

#Paso 5 Ver si se desea arrancar Recibir_B
Log "Desea efectuar la activación de Recibir_B? Si – No"
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

