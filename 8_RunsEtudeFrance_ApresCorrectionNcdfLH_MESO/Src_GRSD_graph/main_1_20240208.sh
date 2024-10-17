#!/bin/bash

#SBATCH --job-name=Explore2
#SBATCH --output=/home/jaouent/scratch/job.%j.out
#SBATCH --error=/home/jaouent/scratch/job.%j.err 
#SBATCH --mail-user=tristan.jaouen@inrae.fr
#SBATCH --mail-type=ALL

#SBATCH --partition=inrae
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=28
#SBATCH --cpus-per-task=1
#SBATCH -t 48:00:00

module purge
module load cv-standard
module load openmpi
module load python
module load proj
module load gcc/8.5.0
module load R/4.0.2

mpirun -np $SLURM_NTASKS Rscript ./3_Run/2_Hydro_CalculFrequenceNonDepassement_FromTxtFiles_ProjectionsParallel_MPItest_9_20240207.R
