#!/bin/bash

echo "Arquivo,Energia eletronica, Energia eletronica + ZPE, Energia eletronica + Térmica, Energia eletronica + entalpia, Energia eletrônica + energia livre" > energias.csv

for i in $@
do
	name=`ls $i | sed 's/.log//'`
	ee=`grep "SCF Done" $i | tail -1 | cut -f8 -d' '`
	ezpe=`grep "Sum of electronic and zero-point Energies" $i | cut -f2 -d'=' | sed 's/ //g'`
	et=`grep "Sum of electronic and thermal Energies" $i | cut -f2 -d'=' | sed 's/ //g'`
	eent=`grep "Sum of electronic and thermal Enthalpies" $i | cut -f2 -d'=' | sed 's/ //g'`
	egibbs=`grep "Sum of electronic and thermal Free Energies" $i | cut -f2 -d'=' | sed 's/ //g'`
	echo "$name,$ee,$ezpe,$et,$eent,$egibbs" >> energias.csv
done

