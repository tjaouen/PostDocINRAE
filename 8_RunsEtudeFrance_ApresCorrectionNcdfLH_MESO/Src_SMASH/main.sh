#!/bin/bash

#SBATCH --job-name=Explore2
#SBATCH --output=/home/jaouent/scratch/job.%j.out
#SBATCH --error=/home/jaouent/scratch/job.%j.err 
#SBATCH --mail-user=tristan.jaouen@inrae.fr
#SBATCH --mail-type=ALL

#SBATCH --partition=defq
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=28
#SBATCH --cpus-per-task=1
#SBATCH -t 72:00:00

module purge
module load cv-standard
module load python
module load proj
module load R/4.0.2
module load gcc/7.5.0
module load hwloc/1.11.2
module load openmpi/psm2/gcc75/3.1.6

# mpirun -np $SLURM_NTASKS Rscript ./3_Run/2_Hydro_CalculFrequenceNonDepassement_FromTxtFiles_ProjectionsParallel_MPI_9_20240207.R
# mpirun -np $SLURM_NTASKS Rscript ./3_Run/2_2_CalculFDCmoyenne6jours_FromTxtFiles_Parallel_MPI_3_20240208.R
# mpirun -np $SLURM_NTASKS Rscript ./3_Run/3_OndeHydro_MatriceInput_Parallele_JonctionHERcriteresES_10jours_GestionErreurs_FDCmeanJm6Jj_MPI_26_20240209.R
# mpirun -np $SLURM_NTASKS Rscript ./4_Validation/20_ChroniqueAssec_Projections_MPI_5_20240213.R
# mpirun -np $SLURM_NTASKS Rscript ./4_Validation/21_ChroniqueProbabilites_Projections_MPI_6_20240214.R
# mpirun -np $SLURM_NTASKS Rscript ./5_StatisticsAndGraphs/8_Chroniques_RunAllPrograms_1_20240304.R
mpirun -np $SLURM_NTASKS Rscript ./5_StatisticsAndGraphs/29_ChroniquesParHERpourIndicateurs_ToutesDates_2_20240325.R
