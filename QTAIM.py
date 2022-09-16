#!/bin/python3
import glob
import os
import argparse

#This script simultaneously analyze all '.txt' files in current directory and extract  AIM data for each critical point

# Storing all '.txt' files in the "files" variable
files=os.path.join('*.txt') 
files=glob.glob(files) 

# Crieates and open for writing the .csv file where the data will be stored
data_file=open('qtaim_results.csv','w+') 

#File Parsing
for f in files:
# Getting the name of each file
    file_name=os.path.basename(f) # Get the name of each file
    split_file_name=file_name.split('.') #split file name to one list with two components, the first is the name, and the second is the file extension '.txt'
    system_name=split_file_name[0] # Store the name of file (without the .txt extension) in the "system_name" variable
    
# open the first .txt file and store each line of the file in the "data" list
    output=open(f,'r')
    data=output.readlines()
    output.close()

# Create the lists where the data will be stored and used for write the .csv file

    CP_numbers=['CP Number']
    CP_types=['CP type']
    c_as=['Connected atoms']
    rhos=['Electron density']
    laplacian_of_rhos=['Laplaqcian of electron density']
    Gs=['Lagrangian kinetic energy']
    Ks=['Hamiltonian kinetic energy']
    Vs=['Potential energy density']
    Hs=['Energy density']
    ells=['Ellipticity of electron density']
    
# Getting the values of QTAIM descriptors    
    for line in data:
        if 'Type' in line:
            line_split1=line.split() 
            CP_number=line_split1[2]
            CP_number=str(CP_number.translate(str.maketrans(","," "))) #remove the comma that is joined with the CP number
            CP_type=str(line_split1[4])
            CP_numbers.append(CP_number)
            CP_types.append(CP_type)
        if 'Density of all electrons:' in line:
            line_split2=line.split()
            rho=str(line_split2[4])
            rhos.append(rho)
        if 'Lagrangian kinetic energy' in line:
            line_split3=line.split()
            G=str(line_split3[4])
            Gs.append(G)
        if 'Hamiltonian kinetic energy' in line:
            line_split4=line.split()
            K=str(line_split4[4])
            Ks.append(K)
        if 'Potential energy density' in line:
            line_split5=line.split()
            V=str(line_split5[4])
            Vs.append(V)
        if 'Energy density' in line:
            line_split6=line.split()
            H=str(line_split6[5])
            Hs.append(H)
        if 'Laplacian of electron density' in line:
            line_split7=line.split()
            laplacian_of_rho=str(line_split7[4])
            laplacian_of_rhos.append(laplacian_of_rho)
        if 'Ellipticity of electron density' in line:
            line_split8=line.split()
            ell=str(line_split8[4])
            ells.append(ell)
        if 'Corresponding nucleus:' in line or 'Connected atoms:' in line:
            line_split9=line.split()
            c_a=line_split9[2:]
            c_a=str(' '.join(c_a))
            c_as.append(c_a)

# join all elements of each list in just only one string
    c_as=";".join(c_as)
    CP_numbers=";".join(CP_numbers)
    CP_types=";".join(CP_types)
    rhos=";".join(rhos)
    laplacian_of_rhos=";".join(laplacian_of_rhos)
    Gs=";".join(Gs)
    Ks=";".join(Ks)
    Vs=";".join(Vs)
    Hs=";".join(Hs)
    ells=";".join(ells)

# writing the values in qtaim_results.csv file    
    data_file.write(F'Sistema: {system_name}\n{CP_numbers}\n{CP_types}\n{c_as}\n{rhos}\n{laplacian_of_rhos}\n{Gs}\n{Ks}\n{Vs}\n{Hs}\n{ells}\n\n')
data_file.close()
    

