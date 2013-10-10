#!/bin/bash


for file in `ls grupo8/bin`
do 
	mv grupo8/bin/$file $file
done


mv grupo8/mae/obras.mae datos/obras.mae
mv grupo8/mae/salas.mae datos/salas.mae
mv grupo8/procesados/combos.dis datos/combos.dis


rm -r grupo8
