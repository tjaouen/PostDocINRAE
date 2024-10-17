library(Rmpi)
rank = mpi.comm.rank(comm=0)
size = mpi.comm.size(comm=0)

if (size > 1) {
  if (rank == 0) {
    Rrank_sample = sample(0:(size-1))
    for (root in 1:(size-1)) {
      Rmpi::mpi.send(as.integer(Rrank_sample[root+1]),
                     type=1, dest=root,
                     tag=1, comm=0)
    }
    Rrank = Rrank_sample[1]
  } else {
    Rrank = Rmpi::mpi.recv(as.integer(0),
                           type=1,
                           source=0,
                           tag=1, comm=0)
  }
} else {
  Rrank = 0
}
post(paste0("Random rank attributed : ", Rrank))



### Paralleliser sur fichiers ###
start = ceiling(seq(1, nFiles_to_use,
                    by=(nFiles_to_use/size)))
if (any(diff(start) == 0)) {
  start = 1:nFiles_to_use
  end = start
} else {
  end = c(start[-1]-1, nFiles_to_use)
}

if (rank == 0) {
  post(paste0(paste0("rank ", 0:(size-1), " get ",
                     end-start+1, " files"),
              collapse="    "))
}

if (Rrank+1 > nFiles_to_use) {
  Files = NULL
} else {
  Files = files_to_use[start[Rrank+1]:end[Rrank+1]]
}

