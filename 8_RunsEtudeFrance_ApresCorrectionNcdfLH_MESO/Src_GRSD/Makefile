all: info
.PHONY: clean clean_hard run queue tail read info

clean: 
	rm ~/scratch/job.*

clean_hard:
	rm -rf results
	rm -rf tmp_* 

run:
	sbatch main.sh

queue:
	watch -n 1 squeue -u jaouent

tail:
	tail -s 0.1 -f ~/scratch/job*.out

read: 
	cat ~/scratch/job*.out
	cat ~/scratch/job*.err

info:
	sinfo -o "%10P %6D %11A %5c %20C"
