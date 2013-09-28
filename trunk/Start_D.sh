#START_D
#Procedimiento en bash para el iniciar procesos.
#Parametros de ejecucion: "Start_D comandoAEjecutar comandoSolicitante". El segundo parametro es opcional.
#Bugs conocidos:

# ----------------------------------
#!/bin/bash
#Chequeamos los parametros:
	if [ $# -lt 1 -o $# -gt 2 ]; then
		echo -e "Invocacion incorrecta. \n\tLa manera correcta es: \n\tStart_D comandoAEjecutar comandoSolicitante"
		#Invocar al Log
		exit -1
	fi
	exit 0
