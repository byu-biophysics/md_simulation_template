#!/bin/bash

#SBATCH --time=12:00:00   # walltime
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
module load your_gromacs_module

# TODO --> Use this line if you are doing constant velocity pulling, otherwise remove the -px and -pf options
gmx mdrun -cpi md -deffnm md -ntmpi 4 -px md_pullx -pf md_pullf
