#!/bin/bash

#SBATCH --job-name=Explore2
#SBATCH --output=/home/herautl/scratch/job.%j.out
#SBATCH --error=/home/herautl/scratch/job.%j.err 
#SBATCH --mail-user=louis.heraut@inrae.fr
#SBATCH --mail-type=ALL

#SBATCH --partition=defq
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
module load R/4.3.1

mpirun -np $SLURM_NTASKS Rscript /home/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/3_Run/2_Hydro_CalculFrequenceNonDepassement_FromTxtFiles_ProjectionsParallel_9_20240206.R