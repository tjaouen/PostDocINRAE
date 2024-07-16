source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_CTRIP/PathsProgram/PathProgram_1_20230206.R")
source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_CTRIP/1_Parameters_MESO/0_SimulationParameters_AvecCC_2_20230227_MESO.R")

### Libraries ###
suppressMessages(library(strex))

### Functions ###
detect_date_format <- function(date) {
  if (grepl("^\\d{4}-\\d{2}-\\d{2}$", date)) {
    return("ymd")
  } else if (grepl("^\\d{2}-\\d{2}-\\d{4}$", date)) {
    return("dmy")
  } else {
    return(NA)
  }
}

### Run ###
# cl <- makePSOCKcluster(detectCores() - 4)
# registerDoParallel(cores=cl)

### Study data ###
folder_input_ = folder_input_param_
folder_input_PC_ = folder_input_PC_param_
folder_output_ = folder_output_param_
folder_onde_ = folder_onde_param_
nom_GCM_ = nom_GCM_param_
nom_selectStations_ = nom_selectStations_param_
nom_categorieSimu_ = nom_categorieSimu_param_
HER_ = HER_param_
HER_variable_ = HER_variable_param_
# climatScenarioModeleHydro_ = climatScenarioModeleHydro_param_

obsSim_ = obsSim_param_
nomSim_ = nomSim_param_
# annees_learn_ = annees_learnModels_param_
annees_inputMatrice_ = annees_inputMatrice_param_

# nbJoursIntervalle_ = 10

### Run ###
liste <- list.files(paste0(folder_input_PC_,
                           "StationsSelectionnees/SelectionCsv/",
                           nom_selectStations_,"/",
                           ifelse(nom_GCM_=="","TablesParModele_20231203/","TablesParModele_20231203/")),pattern="StationsHYDRO", full.names = T)
# il = liste[grepl(str_after_last(str_before_first(nom_GCM_,"_day"),"-"), liste)]
il = liste[grepl(str_before_first(nom_categorieSimu_,"_"), liste)]


output = data.frame()
#compteur = 0

# hydro = Recoupement Stations HYDRO - HER #
hydro = read.table(il, sep=";", dec=".", header = T, quote = "")
if (dim(hydro)[2] == 1){
  hydro = read.table(il, sep=",", dec=".", header = T, quote = "")
}
if (substr(colnames(hydro)[1],1,2) == "X."){
  hydro = read.table(il, sep=";", dec=".", header = T)
  if (dim(hydro)[2] == 1){
    hydro = read.table(il, sep=",", dec=".", header = T)
  }
}

### Gestion de la table des points de simulation ###
if ("Code10_ChoixDefinitifPointSimu" %in% colnames(hydro)){
  hydro$Code = hydro$Code10_ChoixDefinitifPointSimu
}

# print("Taille à verifier : CTRIP=--- \ EROS=--- \ GRSD=1008 \ J2000=343 \ MORDORSD=--- \ MORDORTS=--- \ ORCHIDEE=--- \ SIM2=--- \ SMASH=---")
# print("Taille à verifier : CTRIP=535 \ EROS=159 \ GRSD=608 \ J2000=235 \ MORDORSD=610 \ MORDORTS=113 \ ORCHIDEE=557 \ SIM2=848 \ SMASH=603")
dim(hydro)

# output <- foreach(annee = annees_inputMatrice_, .combine = "rbind", .verbose = T) %:% #, errorhandling='pass'
#   foreach(i = HER_, .combine = "rbind", .verbose = T) %dopar% { #, errorhandling='pass'

### Folders ###
liste_scenarios_ = list.files(paste0(folder_input_,"FlowDurationCurves_meanJm6Jj/",
                                     ifelse(obsSim_=="",nom_GCM_,
                                            paste0("FDC_",obsSim_,
                                                   ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                   ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),"/"))),
                              full.names = T)
# liste_scenarios_ = liste_scenarios_[1:2]
nFiles_to_use = length(liste_scenarios_)

# print(liste_scenarios_)

### Parallel MPI ###
post = function(x, ...) {
  print(paste0(formatC(as.character(rank),
                       width=3, flag=" "),
               "/", size-1, " > ", x), ...)
}

library(Rmpi)
rank = mpi.comm.rank(comm=0)
size = mpi.comm.size(comm=0)

# print("rank")
# print(rank)
# print("size")
# print(size)

if (size > 1) {
  if (rank == 0) {
    # print("option1")
    Rrank_sample = sample(0:(size-1))
    for (root in 1:(size-1)) {
      Rmpi::mpi.send(as.integer(Rrank_sample[root+1]),
                     type=1, dest=root,
                     tag=1, comm=0)
    }
    Rrank = Rrank_sample[1]
    # print(Rrank)
  } else {
    # print("option2")
    Rrank = Rmpi::mpi.recv(as.integer(0),
                           type=1,
                           source=0,
                           tag=1, comm=0)
    # print(Rrank)
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

# print("Rrank")
# print(Rrank)

if (Rrank+1 > nFiles_to_use) {
  liste_scenarios_ = NULL
} else {
  liste_scenarios_ = liste_scenarios_[start[Rrank+1]:end[Rrank+1]]
}
####################

# print("liste_scenarios_")
# print(liste_scenarios_)
# print("liste")
# print(liste)

if (! is.null(liste_scenarios_)){

  for (sc_ in liste_scenarios_){
    tab_HER2_ = data.frame()
    
    for (i in HER_){
      # for (i in HER_[1:2]){
      
      print("i")
      print(i)
      
      output_parAnneeParHer_toutesDates = data.frame()
      
      if (paste0("eco",sprintf("%03d", i)) %in% colnames(hydro)){
        
        print("ok1")
        
        Select_hydro = hydro$Code[which(as.numeric(as.vector(hydro[,paste0("eco",sprintf("%03d", i))]))>0)]
        Weight_hydro <- as.numeric(as.vector(hydro[which(as.numeric(as.vector(hydro[,paste0("eco",sprintf("%03d", i))]))>0),paste0("eco",sprintf("%03d", i))]))
        
        if(length(Select_hydro) > 0 ){
          
          output_hydro = data.frame()
          compt = 0
          weightcompt = 0
          cmpt_hydro_ = 0
          cmpt_NA_ = 0
          FDCweighted_ = data.frame()
          
          for (st in 1:length(Select_hydro)){
            
            print("st")
            print(st)
            
            if (dir.exists(sc_)){ #,"/ExtraitAnneesOnde20102023/"
              if (file.exists(paste0(sc_,
                                     "/FDC_",sub("\\..*", "", Select_hydro[st]),".txt"))){
                
                st_hydro = read.table(paste0(sc_, #,"/ExtraitAnneesOnde20102023/"
                                             "/FDC_",sub("\\..*", "", Select_hydro[st]),".txt"),
                                      header = T, sep = ";", row.names = NULL, quote="")
                
                if (length(FDCweighted_) == 0){
                  FDCweighted_ = data.frame(Date = st_hydro$Date,
                                            Type = st_hydro$Type)
                }
                if ((length(which(!(FDCweighted_$Date == st_hydro$Date))) == 0) & (length(which(!(FDCweighted_$Type == st_hydro$Type))) == 0)){
                  FDCweighted_ = cbind(FDCweighted_,
                                       st_hydro$Moyenne_6jours * Weight_hydro[st])
                  colnames(FDCweighted_)[length(colnames(FDCweighted_))] = st
                }else{
                  print(st)
                  stop("Erreur 1")
                }
              }else{
                print(st)
                stop("Erreur 2")
              }
            }else{
              print(st)
              stop("FDC folder not found.")
            }
          }
          
          print("ok2")
          
          if (ncol(FDCweighted_) > 3){
            FDCweighted_$FDCmeanWeighted = rowSums(FDCweighted_[, !colnames(FDCweighted_) %in% c("Date", "Type")], ) / sum(Weight_hydro)
          }else{
            FDCweighted_$FDCmeanWeighted = FDCweighted_$'1'
          }
          
          print("ok3")
          
          if (length(tab_HER2_)==0){
            tab_HER2_ = data.frame(Date = FDCweighted_$Date,
                                   Type = FDCweighted_$Type)
          }
          if ((length(which(!(tab_HER2_$Date == FDCweighted_$Date))) == 0) & (length(which(!(tab_HER2_$Type == FDCweighted_$Type))) == 0)){
            tab_HER2_ = cbind(tab_HER2_,
                              FDCweighted_$FDCmeanWeighted)
            colnames(tab_HER2_)[length(colnames(tab_HER2_))] = i
          }else{
            print(i)
            print("Erreur 3")
          }
          print("ok4")
        }
      }
      
      print("sc_")
      print(sc_)
      print("sc gsub")
      print(gsub(sc_, "FlowDurationCurves_HERweighted_meanJm6Jj/", "FlowDurationCurves_meanJm6Jj/"))
      
      if (!(dir.exists(gsub("FlowDurationCurves_meanJm6Jj/", "FlowDurationCurves_HERweighted_meanJm6Jj/", sc_)))){
        dir.create(gsub("FlowDurationCurves_meanJm6Jj/", "FlowDurationCurves_HERweighted_meanJm6Jj/", sc_))}
      
      write.table(tab_HER2_, paste0(gsub("FlowDurationCurves_meanJm6Jj/", "FlowDurationCurves_HERweighted_meanJm6Jj/", sc_), #,"/ExtraitAnneesOnde20102023/"
                                    "/Tab_FDCchroniquesByHER2weigthedFDC.txt"), sep=";", row.name=F, quote=F)
      
    }
    
    if (!(dir.exists(gsub("FlowDurationCurves_meanJm6Jj/", "FlowDurationCurves_HERweighted_meanJm6Jj/", sc_)))){
      dir.create(gsub("FlowDurationCurves_meanJm6Jj/", "FlowDurationCurves_HERweighted_meanJm6Jj/", sc_))}
    
    write.table(tab_HER2_, paste0(gsub("FlowDurationCurves_meanJm6Jj/", "FlowDurationCurves_HERweighted_meanJm6Jj/", sc_), #,"/ExtraitAnneesOnde20102023/"
                                  "/Tab_FDCchroniquesByHER2weigthedFDC.txt"), sep=";", row.name=F, quote=F)
    
  }
}

### Parallel MPI ###
Sys.sleep(10)
mpi.finalize()
####################



