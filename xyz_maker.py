import os
import argparse

## Get the arguments.
parser = argparse.ArgumentParser(description="This script analyzes a user given log file and write a new xyz file with optimized coordinates.")
parser.add_argument("log_file", help="The filepath for the log file to analyze.")
args = parser.parse_args()

file=os.path.join(args.log_file)
file_name=os.path.basename(file)
split_file=file.split('.')
name=str(split_file[0])
name=name+'.xyz'
xyz_file=open(name,'w+') 

# Reading files:
output=open(file,'r')
data=output.readlines()
output.close()

#Getting the optimized coordinates
for i, line in enumerate(data):
    if 'Standard orientation:' in line:
        beginning=i+5 # line where coordinates begin

line_num=[]
for j, line in enumerate(data):
    if 'Rotational constants (GHZ):' in line:
        line_num.append(j) # Make a list with all the numbers of the lines where the expression appears
end=line_num[-2]-1 # line where coordinates end

coordinates=data[beginning:end] # #All coordinates are stored in the "coordinates" list
num_atoms=len(coordinates)
xyz_file.write(F'{num_atoms}\n\n') # writes to the xyz file the number of atoms in the system

for i in range(0,num_atoms):
# slicing to get only the atomic numbers and coordinates of the system
    x=coordinates[i].split()
    y=[x[1],'\t\t',x[3],'\t',x[4],'\t',x[5]]
    y[0]=int(y[0])
# replacing atomic numbers with element symbols
    atomic_number=[1,3,5,6,7,8,9,11,14,15,16,17,19,25,27,28,29,30,35,46,47,53,77,79]
    element_symbol=['H','Li','B','C','N','O','F','Na','Si','P','S','Cl','K','Mn','Co','Ni','Cu','Zn','Br','Pd','Ag','I','Ir','Au']
    for i in range(0,24):
        if y[0] == atomic_number[i]:
            y[0]=element_symbol[i]
    z=''.join(y)
    print(z)
    xyz_file.write(F'{z}\n')
xyz_file.close()