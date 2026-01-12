#!/bin/bash
#SBATCH -J A4
#SBATCH --mail-type=END
#SBATCH -a 50
#SBATCH -e %x.%a.log.err.txt
#SBATCH -o %x.%a.log.out.txt
#SBATCH --mem-per-cpu=3600
#SBATCH -t 7-
#SBATCH -n 1
#SBATCH -c 96
#SBATCH -C avx512
echo "This is Job $SLURM_JOB_ID"
module purge
module load matlab
matlab -r 'MainA_16_10($SLURM_ARRAY_TASK_ID)'