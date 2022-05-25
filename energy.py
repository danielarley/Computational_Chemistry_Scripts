import glob
import os

file_names=os.path.join('*.log') 
files=glob.glob(file_names)
data_file=open('energies.csv','w+') # Creates the .csv file where the values of free energy and electronic energy will be stored
data_file.write('Intermediates,Electronic Energy,Free Energy\n')

# File Parsing
for f in files:
# Setting the first column (intermediates column) as the name of the files
    file=os.path.basename(f) # Get the name of each file
    split_file=file.split('.')
    intermediate_name=split_file[0]
# Reading files:
    output=open(f,'r')
    data=output.readlines()
    output.close()
# Getting the values of electronic energy and free energy
    for line in data:
        if 'SCF Done' in line:
            electronic_energy_line=line
            split1=electronic_energy_line.split()
            electronic_energy=float(split1[4])
        if 'Sum of electronic and thermal Free Energies' in line:
            free_energy_line=line
            split5=free_energy_line.split()
            free_energy=float(split5[7])
# writing the values in energies.csv file
    data_file.write(F'{intermediate_name},{electronic_energy},{free_energy}\n')
data_file.close()