#-------------------------------------------------------------------------------
# Calcul les frequences de non depassement pour les stations HYDRO
# Bottet Quentin - Irstea - 10/09/2019 - Version 1
#-------------------------------------------------------------------------------

### Librairies ###
suppressMessages(library(doParallel))
suppressMessages(library(lubridate))
suppressMessages(library(hydroTSM))
suppressMessages(library(strex))
# library(rgdal)

### Programmes ###
source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/PathsProgram/PathProgram_1_20230206.R")
source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/1_Parameters_MESO/0_SimulationParameters_AvecCC_2_20230227_MESO.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/1_Parameters_MESO/0_SimulationParameters_AvecCC_2_20230227_MESO.R")

### Study data ###
folder_input_ = folder_input_param_
obsSim_ = obsSim_param_
nomSim_ = nomSim_param_
date_variable_name_ = "Date"
FDC_dateBorneMin_ = FDC_dateBorneMin_param_
FDC_dateBorneMax_ = FDC_dateBorneMax_param_
nom_categorieSimu_ = nom_categorieSimu_param_

### Functions ###
post = function(x, ...) {
  print(paste0(formatC(as.character(rank),
                       width=3, flag=" "),
               "/", size-1, " > ", x), ...)
}

### List ###
liste_GCM_ = list.files(paste0(folder_input_,"/Debits/Debits",
                               ifelse(obsSim_=="","",obsSim_),"/",
                               "NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/",
                               ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),"/"), full.names = T)
# liste_GCM_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T)

# print(liste_GCM_)

nFiles_to_use = length(liste_GCM_)

### Choose Files to use ###
# install.packages(
#   "Rmpi", 
#   configure.args = c(
#     "--with-Rmpi-include=/trinity/shared/apps/cv-standard/openmpi/psm2/gcc75/3.1.6/include/", # This is where LAM's mpi.h is located
#     "--with-Rmpi-libpath=/trinity/shared/apps/cv-standard/openmpi/psm2/gcc75/3.1.6/bin/",     # This is where liblam.so is located (actually as I type it mine was located in /usr/lib64/liblam.so.0, so maybe this is not needed at all)
#     "--with-Rmpi-type=OPENMPI"               # This says that the type is OPENMPI (there is also LAM and MPICH)
#   ))

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

# Choisir le fichier
if (Rrank+1 > nFiles_to_use) {
  liste_GCM_ = NULL
} else {
  liste_GCM_ = liste_GCM_[start[Rrank+1]:end[Rrank+1]]
}



### Run ###
# cl <- makePSOCKcluster(detectCores()/2-1)
# cl <- makePSOCKcluster(2)
# registerDoParallel(cores=cl)

# output <- foreach(folder_GCM_ = liste_GCM_) %dopar% { #, errorhandling='pass'
for (folder_GCM_ in liste_GCM_){

  debExtract = folder_GCM_
  
  if (!(dir.exists(paste0(folder_input_,
                          "FlowDurationCurves/",
                          ifelse(obsSim_=="","",paste0("FDC_",obsSim_,"/")),
                          ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),
                          str_after_last(folder_GCM_,"/"),"/")))){
    dir.create(paste0(folder_input_,
                      "FlowDurationCurves/",
                      ifelse(obsSim_=="","",paste0("FDC_",obsSim_,"/")),
                      ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),
                      str_after_last(folder_GCM_,"/"),"/"))
  }
  
  write.table(debExtract, paste0(folder_input_,
                                 "FlowDurationCurves/",
                                 ifelse(obsSim_=="","",paste0("FDC_",obsSim_,"/")),
                                 ifelse(nom_categorieSimu_=="","",paste0(nom_categorieSimu_,"/")),
                                 str_after_last(folder_GCM_,"/"),
                                 "/FDC_",str_after_last(folder_GCM_,"/"),".txt"), sep=";", row.name=F, quote=F)

}

Sys.sleep(10)
mpi.finalize()

# Arreter le cluster doParallel
# stopCluster(cl)
# beep(1)
