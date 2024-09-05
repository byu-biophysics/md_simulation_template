#!/bin/bash

#SBATCH --time=72:00:00   # walltime
#SBATCH --ntasks=24  # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --gres=gpu:4
#SBATCH --mem-per-cpu=5G   # memory per CPU core
#SBATCH -J "your_job_name"   # job name

# Set the max number of threads to use for programs using OpenMP. Should be <= ppn. Does nothing if the program doesn't use OpenMP.

# Needs to be (# of cores / # of GPUs)
export OMP_NUM_THREADS=6

export GMX_MAXCONSTRWARN=10000

module purge

## TODO --> Load module for current version of gromacs that is gpu-enabled
module load your_gromacs_module

echo "Prepping File" 
## TODO --> Add your file to the parent directory of this directory
gmx pdb2gmx -f ../your_pdb_file.pdb -o system.pdb -water spce -p system.top -ignh -ff charmm27
gmx editconf -f system.pdb -o box.pdb -bt cubic -d 3 
gmx solvate -cp box.pdb -p system.top -o system_solv.pdb
gmx grompp -f ions.mdp -c system_solv.pdb -p system.top -o ions.tpr 
echo SOL | gmx genion -s ions.tpr -o system_ions.pdb -p system.top -pname NA -nname CL -neutral 

## TODO --> Uncomment to select the chain for the section you want to put an external force on 
#echo "Creating Index File" 
#gmx make_ndx -f system_ions.pdb -o system.ndx<<EOF
#case
#chain A 
#name 17 accel_group
#q
#EOF

##TODO --> If you don't want to accelerate, uncomment this section to create the index file instead
#echo q | gmx make_ndx -f system_ions.pdb -o system.ndx

echo "Start Minimization"
gmx grompp -f em.mdp -c system_ions.pdb -p system.top -o em.tpr -n system.ndx
gmx mdrun -s em.tpr -v -ntmpi 4 -c em.pdb -o em.trr

echo "Start Equilibration"
gmx grompp -f eq.mdp -c em.pdb -p system.top -o eq.tpr -n system.ndx -maxwarn 1
gmx mdrun -s eq.tpr -v -ntmpi 4 -c eq.pdb -o eq.trr

echo "Start Production"
gmx grompp -f md.mdp -c eq.pdb -p system.top -o md.tpr -n system.ndx
gmx mdrun -deffnm md -v -ntmpi 4
