#!/bin/bash

# Script para modificação dos inputs gerados no GaussView e adequação para rodar na Heimdall


# Pergunta ao usuário se ele quer salvar uma cópia do artigo
read -p "Digite 1 caso queira salvar uma cópia não modificada do arquivo " resposta
if [ $resposta -eq 1 ]; then
        cp $1 $1.old
fi


# Apaga Conectividade que vem ao final do arquivo
while tail -1 $1 | grep -v "[A-Z]"
do
        sed -i '$d' $1
done

# Adiciona linha em branco ao final do arquivo
sed -i '$a\

' $1

# Pergunta ao usuário quanto de memória e quantos processadores ele deseja e insere os comandos de link0 %mem e %nprocshared após o comando %chk
if grep '%mem' $1; then
	read -p "Quantos gigas de memória você deseja usar? " mem
	read -p "Quantos processadoradores você deseja? " proc
	GB=GB
	sed -i "/%mem/c%mem=$mem$GB" $1
	sed -i "/%nproc/c%nprocshared=$proc" $1
else
	read -p "Quantos gigas de memória você deseja usar?" mem
	read -p "Quantos processadoradores você deseja?" proc
	GB=GB
#precisa arrumar esse sed
	sed -i "/%chk*/a\
%mem=$mem$GB" $1
	sed -i "/%mem=*/a\
\%nprocshared=$proc" $1
fi


# Troca o route section padrão pelo route section fornecido (caso desejar adicione mais opções)
echo "
Selecione qual route section você deseja:

1. #p opt freq M06/Def2SVP SCRF=(SMD,Solvent=Generic,Read) scf=(tight,save) gfinput iop(6/7=3)
2. #p opt freq b3lyp scrf=(smd,solvent=thf) def2svp empiricaldispersion=gd3bj gfinput iop(6/7=3) scf=(tight,save)
3. #p opt=(TS,noeigentest,CalcFC) freq scrf=(smd,solvent=generic,read) def2svp gfinput iop(6/7=3) m06 scf=(tight,save)
4. #p opt=(TS,noeigentest,CalcFC) freq b3lyp scrf=(smd,solvent=thf) def2svp empiricaldispersion=gd3bj gfinput iop(6/7=3) scf=(tight,save)
5. #p M06/Def2SVP IRC=(Reverse,CalcFC,MaxPoints=40) SCRF=(SMD,Solvent=Generic,Read) scf=(tight,save) gfinput iop(6/7=3)
6. #p M06/Def2SVP IRC=(forward,CalcFC,MaxPoints=40) SCRF=(SMD,Solvent=Generic,Read) scf=(tight,save) gfinput iop(6/7=3)
7. #p scrf=(smd,solvent=generic,read) def2svp gfinput iop(6/7=3) m06 scf=(tight,save)
"
read -p "Selecione qual a opção desejada [1-7] > "

if [ $REPLY -eq 1 ]; then 
	sed -i '/#/c\
#p opt freq M06/Def2SVP SCRF=(SMD,Solvent=Generic,Read) scf=(tight,save) gfinput iop(6/7=3)' $1
elif [ $REPLY -eq 2 ]; then
        sed -i '/#/c\
#p opt freq b3lyp scrf=(smd,solvent=thf) def2svp empiricaldispersion=gd3bj gfinput iop(6/7=3) scf=(tight,save)' $1
elif [ $REPLY -eq 3 ]; then
        sed -i '/#/c\
#p opt=(TS,noeigentest,CalcFC) freq scrf=(smd,solvent=generic,read) def2svp gfinput iop(6/7=3) m06 scf=(tight,save)' $1
elif [ $REPLY -eq 4 ]; then
        sed -i '/#/c\
#p opt=(TS,noeigentest,CalcFC) freq b3lyp scrf=(smd,solvent=thf) def2svp empiricaldispersion=gd3bj gfinput iop(6/7=3) scf=(tight,save)' $1
elif [ $REPLY -eq 5 ]; then
        sed -i '/#/c\
#p M06/Def2SVP IRC=(Reverse,CalcFC,MaxPoints=40) SCRF=(SMD,Solvent=Generic,Read) scf=(tight,save) gfinput iop(6/7=3)' $1
elif [ $REPLY -eq 6 ]; then
        sed -i '/#/c\
#p M06/Def2SVP IRC=(forward,CalcFC,MaxPoints=40) SCRF=(SMD,Solvent=Generic,Read) scf=(tight,save) gfinput iop(6/7=3)' $1
elif [ $REPLY -eq 7 ]; then
	sed -i '/#/c\
#p scrf=(smd,solvent=generic,read) def2svp gfinput iop(6/7=3) m06 scf=(tight,save)' $1
else
	echo "opção inválida"
fi

# Pergunta ao usuário se quer adicionar a informação adicional para o efeito do solvente HFIP
read -p 'Você deseja adicionar os dados para parametrização do HFIP após as coordenadas do sistema? Digite "1" para sim ou "2" para não:'

if [ $REPLY -eq 1 ]; then
	# Insere ao final do arquivo as opções para o calculo SMD e deixa uma linha em branco ao final
	sed -i '$a\
Eps=16.70\
EpsInf=1.625\
HbondAcidity=1.96\
HbondBasicity=0.00\
SurfaceTensionAtInterface=23.17\
CarbonAromaticity=0.00\
ElectronegativeHalogenicity=0.60\

	' $1
fi
clear
