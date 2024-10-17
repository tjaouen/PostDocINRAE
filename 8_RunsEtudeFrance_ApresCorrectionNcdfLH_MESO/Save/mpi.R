## INSTALLATION ______________________________________________________
# Le plus merdique, installer Rmpi
# L'idée est de loader les bon modules déjà en ligne de commande donc
# normalement ça marchera avec ta version de R
# $ module purge
# $ module load cv-standard
# $ module load gcc/7.5.0
# $ $module load openmpi/psm2/gcc75/3.1.6
# À partir de là tu peux regarder la variable d'environnement en
# ligne de commande '$MPI_HOME' et c'est là où est installé openmpi
# dans le calculateur. Et normalement la on a toutes les infos pour
# installer Rmpi dans R avec la ligne plus bas
# Déjà loader R (je crois que c'est la version que tu avais)
# $ module load R/4.0.2 
# et arpès dans R

install.packages(
  "Rmpi", 
  configure.args = c(
   "--with-Rmpi-include=/trinity/shared/apps/cv-standard/openmpi/psm2/gcc75/3.1.6/include/", # This is where LAM's mpi.h is located
   "--with-Rmpi-libpath=/trinity/shared/apps/cv-standard/openmpi/psm2/gcc75/3.1.6/bin/",     # This is where liblam.so is located (actually as I type it mine was located in /usr/lib64/liblam.so.0, so maybe this is not needed at all)
   "--with-Rmpi-type=OPENMPI"               # This says that the type is OPENMPI (there is also LAM and MPICH)
  ))

# et la si ça marche bah c'est vraiment le plus dur qui est fait mdr
# je te promet



## PARALLELISATION ___________________________________________________
# En gros j'ai deux type de parallélisation pour Explore2 par code ou
# pas fichier donc j'ai une variable pour le préciser.
MPI =
    # ""
    "file"
    # "code"

# A mettre plus ou moins au début en tous cas avant toutes
# parallélisation. L'objectif est d'attribué un nouveau rank à chaque
# coeur pour qu'ils soient plus ou moins répartis de manière homogène
# entre les noeuds.
if (MPI != "") {
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
    
} else {
    rank = 0
    size = 1
    Rrank = 0
} 


# Parallélisation sur les fichier
if (MPI == "file") {            
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
    
} else {
    Files = files_to_use
}

# Parallélisation sur les codes, je bidouille pour créer une liste
# de paquet de code que après je me réparti entre mes coeurs
Subsets = list()
for (i in 1:length(IdCode)) {
    Id = IdCode[i]
    if (i == 1) {
        id = 1    
    } else {
        id = IdCode[i-1] + 1
    }
    names(id) = NULL
    name = names(Id)
    names(Id) = NULL
    n = 1
    while (id+nCode4RAM-1 < Id) {
        Subsets = append(Subsets, list(c(id, id+nCode4RAM-1)))
        names(Subsets)[length(Subsets)] = paste0(name, n)
        id = id+nCode4RAM
        n = n+1
    }
    Subsets = append(Subsets, list(c(id, Id)))
    names(Subsets)[length(Subsets)] = paste0(name, n)
}
nSubsets = length(Subsets)
# ...
Subsets_save = Subsets
nSubsets_save = nSubsets
if (MPI == "code") {
    Subsets = Subsets[rank+1]
    Subsets = Subsets[!is.na(names(Subsets))]
    nSubsets = length(Subsets)

    if (nSubsets == 0) {
        Rmpi::mpi.send(as.integer(1), type=1, dest=0, tag=1, comm=0) # normalement ça ça ne te sert a rien du coup
        post(paste0("End signal from rank ", rank)) 
    }
}


# typiquement une erreur à éviter
if (!(file.exists(tmppath)) & rank == 0) {
    dir.create(tmppath, recursive=TRUE)
}
# bien faire la création de dossier par un seul coeur 


# et tout à la fin pour arrêter les processus j'ai
if (MPI != "") {
    Sys.sleep(10)
    mpi.finalize()
}
# ce qui est plus ou moins important (par pour l'idiot
# de MESO en tous cas)
