#!/bin/bash

name=`ls $1 | sed 's/.log//'`

case $4 in
	"optfreq")
		route="#p opt freq M06/Def2SVP SCRF=(SMD,Solvent=2-methyl-1-propanol) scf=(tight,save) gfinput iop(6/7=3)"
		;;
	"ts")
		route="#p opt=(TS,noeigentest,CalcFC) freq scrf=(smd,solvent=2-methyl-1-propanol) def2svp gfinput iop(6/7=3) m06 scf=(tight,save)"
		;;
	"rirc")
		route="#p M06/Def2SVP IRC=(Reverse,CalcFC,MaxPoints=40) SCRF=(SMD,Solvent=2-methyl-1-propanol) scf=(tight,save) gfinput iop(6/7=3)"
		;;
	"firc")
		route="#p M06/Def2SVP IRC=(forward,CalcFC,MaxPoints=40) SCRF=(SMD,Solvent=2-methyl-1-propanol) scf=(tight,save) gfinput iop(6/7=3)"
		;;
	"sp")
		route="#p scrf=(smd,solvent=2-methyl-1-propanol) def2svp gfinput iop(6/7=3) m06 scf=(tight,save)"
		;;
esac

echo -e "%chk=t2_$name.chk\n%mem=$3"GB"\n%nprocshared=$2\n$route\n\ntitulo\n\n0 1" > t2_$name.com

elem=("" "H " "He" "Li" "Be" "B " "C " "N " "O " "F " "Ne" "Na" "Mg" "Al" "Si" "P " "S " "Cl" "Ar" "K " "Ca" "Sc" "Ti" "V " "Cr" "Mn" "Fe" "Co" "Ni" "Cu" "Zn" "Ga" "Ge" "As" "Se"  "Br" "Kr" "Rb" "Sr" "Y " "Zr" "Nb" "Mo" "Tc" "Ru" "Rh" "Pd" "Ag" "Cd" "In" "Sn" "Sb" "Te" "I " "Xe" "Cs" "Ba" "La" "Ce" "Pr" "Nd" "Pm" "Sm" "Eu" "Gd" "Tb" "Dy" "Ho" "Er" "Tm" "Yb" "Lu" "Hf" "Ta" "W " "Re" "Os" "Ir" "Pt" "Au" "Hg" "Tl" "Pb" "Bi" "Po" "At" "Rn" "Fr" "Ra" "Ac" "Th" "Pa" "U " "Np" "Pu" "Am" "Cm")

num_atoms=`grep "NAtoms=" $1 | head -1 | cut -f2 -d= | cut -f1 -dN | sed 's/ //g'`
#echo -e "$num_atoms\n" > $name.xyz
n_grep=$[$num_atoms+4]
grep -A$n_grep "Standard orientation" $1 | tail -$num_atoms | awk '{printf " %d\t%10f\t%10f\t%10f\n", $2, $4, $5, $6}' >> t2_$name.com

for ((i=0;i<=96;i++))
{
	sed -i "s/ $i\t/ ${elem[$i]}\t/g" t2_$name.com
}
echo -ne "\n" >> t2_$name.com
