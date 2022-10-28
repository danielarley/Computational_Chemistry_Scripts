#!/bin/bash

case $2 in
	"opt")
		exp="Standard orientation"
		;;
	"irc")
		exp="Input orientation"
		;;
esac

name=`ls $1 | sed 's/.log//'` # get the name of the file

elem=("" "H " "He" "Li" "Be" "B " "C " "N " "O " "F " "Ne" "Na" "Mg" "Al" "Si" "P " "S " "Cl" "Ar" "K " "Ca" "Sc" "Ti" "V " "Cr" "Mn" "Fe" "Co" "Ni" "Cu" "Zn" "Ga" "Ge" "As" "Se"  "Br" "Kr" "Rb" "Sr" "Y " "Zr" "Nb" "Mo" "Tc" "Ru" "Rh" "Pd" "Ag" "Cd" "In" "Sn" "Sb" "Te" "I " "Xe" "Cs" "Ba" "La" "Ce" "Pr" "Nd" "Pm" "Sm" "Eu" "Gd" "Tb" "Dy" "Ho" "Er" "Tm" "Yb" "Lu" "Hf" "Ta" "W " "Re" "Os" "Ir" "Pt" "Au" "Hg" "Tl" "Pb" "Bi" "Po" "At" "Rn" "Fr" "Ra" "Ac" "Th" "Pa" "U " "Np" "Pu" "Am" "Cm")

num_atoms=`grep "NAtoms=" $1 | head -1 | cut -f2 -d= | cut -f1 -dN | sed 's/ //g'` # get the number of atoms
echo -e "$num_atoms\n" > $name.xyz #write the number of atoms in xyz file
n_grep=$[$num_atoms+4]
grep -A$n_grep "$exp" $1 | tail -$num_atoms | awk '{printf " %d\t%10f\t%10f\t%10f\n", $2, $4, $5, $6}' >> $name.xyz

for ((i=0;i<=96;i++))
{
        sed -i "s/ $i\t/ ${elem[$i]}\t/g" $name.xyz
}
