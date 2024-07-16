### Functions ###
post = function(x,...) {
  # print(rank)
  rank = Rmpi::mpi.recv(as.integer(0),
                         type=1,
                         source=0,
                         tag=1, comm=0)
  print(paste0(formatC(as.character(rank),
                       width=3, flag=" "),
               "/", size-1, " > ", x), ...)
}

# giveRank_ <- function(rank,size,nFiles_to_use){
# 
#   return(list(start,end,Rrank))
# }
