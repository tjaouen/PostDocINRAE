source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_SMASH/PathsProgram/PathProgram_1_20230206.R")
source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_SMASH/1_Parameters_MESO/0_SimulationParameters_AvecCC_2_20230227_MESO.R")

########### EN COURS DE MODIFICATION ##############

### Libraries ###
suppressMessages(library(strex))
suppressMessages(library(dplyr))

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
jourMin_ = jourMin_param_
jourMax_ = jourMax_param_
obsSim_ = obsSim_param_
nomSim_ = nomSim_param_
nom_apprentissage_ = "ApprentissageGlobalModelesBruts"
nom_validation_ = ""
annees_validModels_ = ""

### Chroniques ###
# folder_Aprojeter_ <- list.files(paste0(folder_input_,"FlowDurationCurves_HERweighted_meanJm6Jj/",
#                                        ifelse(obsSim_=="",nom_GCM_,
#                                               paste0("FDC_",obsSim_,
#                                                      ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
#                                                      nom_seqProjetee_,"/"))), full.names = T)

### Folders ###
liste_scenarios_ = list.files(paste0(folder_input_,"FlowDurationCurves_HERweighted_meanJm6Jj/",
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

print("liste_scenarios_")
print(liste_scenarios_)
# print("liste")
# print(liste)

if (! is.null(liste_scenarios_)){
  for (sc_ in liste_scenarios_){
    
    ### Table Modele ###
    tab_modeles_ = read.table(list.files(paste0(folder_output_,
                                                "2_ResultatsModeles_ParHer/",
                                                nomSim_,"/",
                                                ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                                ifelse(basename(sc_)=="","",paste0("/",basename(sc_))),
                                                ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),"/"),
                                         pattern = "logit", full.names = T),
                              dec = ".", sep = ";", header = T)
    

    chroniqueFDCbyHERweighted_ <- read.table(paste0(sc_,"/Tab_FDCchroniquesByHER2weigthedFDC.txt"), sep=";", header = T)
    
    chroniqueFDCbyHERweighted_hist_ <- chroniqueFDCbyHERweighted_[which(chroniqueFDCbyHERweighted_$Type == "Historical"),]
    chroniqueFDCbyHERweighted_proj_ <- chroniqueFDCbyHERweighted_[which(grepl("rcp",chroniqueFDCbyHERweighted_$Type)),]
    chroniqueFDCbyHERweighted_saf_ <- chroniqueFDCbyHERweighted_[which(chroniqueFDCbyHERweighted_$Type == "Safran"),]
    dim(chroniqueFDCbyHERweighted_hist_) # 19724
    dim(chroniqueFDCbyHERweighted_proj_) # CTRIP 34698, GRSD 34333
    dim(chroniqueFDCbyHERweighted_saf_) # CTRIP 16437, GRSD 15705
    
    chroniqueFDCbyHERweighted_hist_[, !colnames(chroniqueFDCbyHERweighted_hist_) %in% c("Date", "Type")]
    colnames(chroniqueFDCbyHERweighted_hist_)[!colnames(chroniqueFDCbyHERweighted_hist_) %in% c("Date", "Type")] <- gsub("X", "", colnames(chroniqueFDCbyHERweighted_hist_)[!colnames(chroniqueFDCbyHERweighted_hist_) %in% c("Date", "Type")])
    
    chroniqueFDCbyHERweighted_proj_[, !colnames(chroniqueFDCbyHERweighted_proj_) %in% c("Date", "Type")]
    colnames(chroniqueFDCbyHERweighted_proj_)[!colnames(chroniqueFDCbyHERweighted_proj_) %in% c("Date", "Type")] <- gsub("X", "", colnames(chroniqueFDCbyHERweighted_proj_)[!colnames(chroniqueFDCbyHERweighted_proj_) %in% c("Date", "Type")])
    
    chroniqueFDCbyHERweighted_saf_[, !colnames(chroniqueFDCbyHERweighted_saf_) %in% c("Date", "Type")]
    colnames(chroniqueFDCbyHERweighted_saf_)[!colnames(chroniqueFDCbyHERweighted_saf_) %in% c("Date", "Type")] <- gsub("X", "", colnames(chroniqueFDCbyHERweighted_saf_)[!colnames(chroniqueFDCbyHERweighted_saf_) %in% c("Date", "Type")])
    
    
    ### Probability ###
    for (i in colnames(chroniqueFDCbyHERweighted_hist_)[3:length(chroniqueFDCbyHERweighted_hist_)]){
      tab_modeles_HER_ <- tab_modeles_[which(tab_modeles_$HER == as.numeric(i)),]
      chroniqueFDCbyHERweighted_hist_[[as.character(i)]] = (exp(tab_modeles_HER_$Inter_logit_Learn+chroniqueFDCbyHERweighted_hist_[[as.character(i)]]*tab_modeles_HER_$Slope_logit_Learn)/
                                                              (1+exp(tab_modeles_HER_$Inter_logit_Learn+chroniqueFDCbyHERweighted_hist_[[as.character(i)]]*tab_modeles_HER_$Slope_logit_Learn)))*100
    }
    for (i in colnames(chroniqueFDCbyHERweighted_proj_)[3:length(chroniqueFDCbyHERweighted_proj_)]){
      tab_modeles_HER_ <- tab_modeles_[which(tab_modeles_$HER == i),]
      chroniqueFDCbyHERweighted_proj_[[as.character(i)]] = (exp(tab_modeles_HER_$Inter_logit_Learn+chroniqueFDCbyHERweighted_proj_[[as.character(i)]]*tab_modeles_HER_$Slope_logit_Learn)/
                                                              (1+exp(tab_modeles_HER_$Inter_logit_Learn+chroniqueFDCbyHERweighted_proj_[[as.character(i)]]*tab_modeles_HER_$Slope_logit_Learn)))*100
    }
    for (i in colnames(chroniqueFDCbyHERweighted_saf_)[3:length(chroniqueFDCbyHERweighted_saf_)]){
      tab_modeles_HER_ <- tab_modeles_[which(tab_modeles_$HER == i),]
      chroniqueFDCbyHERweighted_saf_[[as.character(i)]] = (exp(tab_modeles_HER_$Inter_logit_Learn+chroniqueFDCbyHERweighted_saf_[[as.character(i)]]*tab_modeles_HER_$Slope_logit_Learn)/
                                                             (1+exp(tab_modeles_HER_$Inter_logit_Learn+chroniqueFDCbyHERweighted_saf_[[as.character(i)]]*tab_modeles_HER_$Slope_logit_Learn)))*100
    }
    
    chroniqueFDCbyHERweighted_final_ = rbind(chroniqueFDCbyHERweighted_hist_,
                                             chroniqueFDCbyHERweighted_proj_,
                                             chroniqueFDCbyHERweighted_saf_)
    
    
    if (!(dir.exists(gsub("FlowDurationCurves_HERweighted_meanJm6Jj/","Tab_ChroniquesProba_LearnBrut_ByHer/",sc_)))){
      dir.create(gsub("FlowDurationCurves_HERweighted_meanJm6Jj/","Tab_ChroniquesProba_LearnBrut_ByHer/",sc_))}
    
    write.table(chroniqueFDCbyHERweighted_final_, paste0(gsub("FlowDurationCurves_HERweighted_meanJm6Jj/","Tab_ChroniquesProba_LearnBrut_ByHer/",sc_),
                                                         "/Tab_ChroniquesProba_LearnBrut_ByHer.txt"), sep=";", row.name=F, quote=F)
  }
}

### Parallel MPI ###
Sys.sleep(10)
mpi.finalize()
####################
