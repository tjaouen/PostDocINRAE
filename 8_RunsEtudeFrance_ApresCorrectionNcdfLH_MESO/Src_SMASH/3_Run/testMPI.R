

library(Rmpi)
rank = mpi.comm.rank(comm=0)
size = mpi.comm.size(comm=0)


if (rank == 0){
  a = c()
  for (i in 1:1){
    a = cbind(a,c(0))
    write.table(a, "/lustre/jaouent/Input/Doc_a.txt", sep = ";", dec = ".")
  }
}

if (rank == 1){
  b = c()
  for (i in 1:10000){
    b = cbind(b,c(1))
    write.table(b, "/lustre/jaouent/Input/Doc_b.txt", sep = ";", dec = ".")
  }
}

### Parallel MPI ###
Sys.sleep(10)
mpi.finalize()
####################
