#!/bin/bash

function ParametrosDefault {
BINDIR="$grupo/bin"
MAEDIR="$grupo/mae"
ARRIDIR="$grupo/arribos"
ACEPDIR="$grupo/aceptados"
RECHDIR="$grupo/rechazados"
REPODIR="$grupo/listados"
PROCDIR="$grupo/procesados"
LOGDIR="$grupo/log"
DATASIZE='100'
LOGSIZE='400'
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

echo "WARNING: Recordar correr INICIAR.sh de la forma: . ./Iniciar_B.sh "
ParametrosDefault
ExportarVariables
