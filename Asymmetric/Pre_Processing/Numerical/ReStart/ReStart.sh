#!/bin/bash
#SBATCH -J A6  
#SBATCH --mail-type=END
#SBATCH -a 99
#SBATCH -e %x.%a.log.err.txt
#SBATCH -o %x.%a.log.out.txt
#SBATCH --mem-per-cpu=8000
#SBATCH -t 7-
#SBATCH -n 1
#SBATCH -c 96
#SBATCH -C "avx512&mem1536g"   
echo "This is Job $SLURM_JOB_ID"
module purge
module load matlab
matlab -r 'Restart_A('$SLURM_ARRAY_TASK_ID')'

