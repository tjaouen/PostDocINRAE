print("ORCHIDEE - 29_ChroniquesParHERpourIndicateurs_ToutesDates_2_20240325.R")
source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_ORCHIDEE/PathsProgram/PathProgram_1_20230206.R")
source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_ORCHIDEE/1_Parameters_MESO/0_SimulationParameters_AvecCC_2_20230227_MESO.R")
source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_Commun/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")

# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")
# source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")
# source("/home/tjaouen/Documents/Input/FondsCartes/LHcolors/color.R")

### Libraries ###
suppressMessages(library(doParallel))
suppressMessages(library(tidyverse))
suppressMessages(library(svglite))
suppressMessages(library(ggplot2))
suppressMessages(library(strex))
suppressMessages(library(latex2exp))
suppressMessages(library(lubridate))
suppressMessages(library(readxl))

### Parameters ###
folder_output_ = folder_output_param_
nomSim_ = nomSim_param_
jourMin_ = jourMin_param_
jourMax_ = jourMax_param_
nom_categorieSimu_ = nom_categorieSimu_param_
nom_apprentissage_ = nom_apprentissage_param_
nom_validation_ = nom_validation_param_
annees_validModels_ = annees_validModels_param_
nom_GCM_ = nom_GCM_param_
breaks_NSE_ = breaks_NSE_param
folder_input_ = folder_input_param_
HER_ = HER_param_

# date_intervalle_ = c("1977-01-01","2004-12-31")
date_intervalle_ = c("1976-01-01","2005-12-31")
pattern_rcp_ = str_before_last(str_after_last(nom_categorieSimu_,"_"),"/")

### Files ###
print(paste0(folder_input_,"Tab_ChroniquesProba_LearnBrut_ByHer/",
             ifelse(obsSim_param_=="",nom_GCM_param_,
                    paste0("FDC_",obsSim_param_,
                           ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                           ifelse(nom_categorieSimu_=="","",nom_categorieSimu_)))))

list_files_chroniquesProba_ <- list.files(paste0(folder_input_,"Tab_ChroniquesProba_LearnBrut_ByHer/",
                                                 ifelse(obsSim_param_=="",nom_GCM_param_,
                                                        paste0("FDC_",obsSim_param_,
                                                               ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                               ifelse(nom_categorieSimu_param_=="","",nom_categorieSimu_param_),"/"))),
                                          recursive = T,
                                          full.names = T)
# list_files_chroniquesProba_ <- list_files_chroniquesProba_[1:2]

nFiles_to_use = length(HER_)

### Description HER ###
descriptionHER_ = read_excel(paste0(folder_HER_DataDescription_,"../HER2officielles/DescriptionHER2_3_20240313.xlsx"))

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
  HER_ = NULL
} else {
  HER_ = HER_[start[Rrank+1]:end[Rrank+1]]
}
####################


### Run ###
for (HER_h_ in HER_){
  
  print(HER_h_)
  
  tab_allModels_ = data.frame()
  tab_1_ <- read.table(list_files_chroniquesProba_[1], sep = ";", dec = ".", header = T)
  colnames(tab_1_) <- gsub("X","",colnames(tab_1_))
  
  if (HER_h_ %in% colnames(tab_1_)){
    
    for (l in 1:length(list_files_chroniquesProba_)){
      tab_l_ <- read.table(list_files_chroniquesProba_[l], sep = ";", dec = ".", header = T)
      colnames(tab_l_) <- gsub("X","",colnames(tab_l_))
      tab_l_ <- tab_l_[,c("Date","Type",HER_h_)]
      colnames(tab_l_) <- c("Date","Type",str_after_last(str_before_last(list_files_chroniquesProba_[l],"/"),"/"))
      
      if (ncol(tab_allModels_) == 0){
        tab_allModels_ <- tab_l_
      }else{
        tab_allModels_ <- merge(tab_allModels_, tab_l_, by = c("Date","Type"))
      }
    }
    
    ### Formater ###
    tab_allModels_$Date <- as.Date(tab_allModels_$Date)
    tab_allModels_$Jour_annee <- format(tab_allModels_$Date, format = "%m-%d")
    
    ### Aves les periodes ###
    # tab_allModels_2070_2100_ = tab_allModels_[which(tab_allModels_$Date >= as.Date(date_intervalle_[1]) & tab_allModels_$Date <= as.Date(date_intervalle_[2])),]
    # tab_allModels_2070_2100_$Type <- factor(tab_allModels_2070_2100_$Type, levels = c("Safran", unique(tab_allModels_2070_2100_$Type)[which(unique(tab_allModels_2070_2100_$Type) != "Safran")]))
    # tab_allModels_2070_2100_ <- arrange(tab_allModels_2070_2100_, Type, Date)

    ### Export Table ###
    # if (!(dir.exists(paste0(folder_input_,"Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/",
    #                         ifelse(obsSim_param_=="",nom_GCM_param_,
    #                                paste0("FDC_",obsSim_param_,
    #                                       ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
    #                                       ifelse(nom_categorieSimu_=="","",nom_categorieSimu_))))))){
    #   dir.create(paste0(folder_input_,"Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/",
    #                     ifelse(obsSim_param_=="",nom_GCM_param_,
    #                            paste0("FDC_",obsSim_param_,
    #                                   ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
    #                                   ifelse(nom_categorieSimu_=="","",nom_categorieSimu_)))))}
    # write.table(tab_allModels_2070_2100_,paste0(folder_input_,"Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/",
    #                                             ifelse(obsSim_param_=="",nom_GCM_param_,
    #                                                    paste0("FDC_",obsSim_param_,
    #                                                           ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
    #                                                           ifelse(nom_categorieSimu_=="","",nom_categorieSimu_))),
    #                                             "/Tab_ChroniquesProba_LearnBrut_",year(date_intervalle_[1]),year(date_intervalle_[2]),"_HER",HER_h_,".txt"),
    #             sep = ";", dec = ".", row.names = F)
    
    ### Quality control ###
    # tab_allModels_2070_2100_$Type[grep("rcp",tab_allModels_2070_2100_$Type)] = "Historical"
    # if (!(((nrow(tab_allModels_2070_2100_[which(tab_allModels_2070_2100_$Type == "Historical"),]) < as.Date(date_intervalle_[2])-as.Date(date_intervalle_[1])+366) & (nrow(tab_allModels_2070_2100_[which(tab_allModels_2070_2100_$Type == "Historical"),]) > as.Date(date_intervalle_[2])-as.Date(date_intervalle_[1])+1-366)) | (nrow(tab_allModels_2070_2100_[which(tab_allModels_2070_2100_$Type == "Historical"),]) %in% c(as.Date(date_intervalle_[2])-as.Date(date_intervalle_[1])+1,0)))){
    #   stop(paste0("Error with Historical content. File :", list_files_chroniquesProba_[l], " - HER : ", HER_h_))
    # }
    # if (!(((nrow(tab_allModels_2070_2100_[which(tab_allModels_2070_2100_$Type == "Safran"),]) < as.Date(date_intervalle_[2])-as.Date(date_intervalle_[1])+366) & (nrow(tab_allModels_2070_2100_[which(tab_allModels_2070_2100_$Type == "Safran"),]) > as.Date(date_intervalle_[2])-as.Date(date_intervalle_[1])+1-366)) | (nrow(tab_allModels_2070_2100_[which(tab_allModels_2070_2100_$Type == "Safran"),]) %in% c(as.Date(date_intervalle_[2])-as.Date(date_intervalle_[1])+1,0)))){
    #   stop(paste0("Error with Safran content. File :", list_files_chroniquesProba_[l], " - HER : ", HER_h_))
    # }
    # if (!(nrow(tab_allModels_2070_2100_[grepl("rcp",tab_allModels_2070_2100_$Type),]) %in% c(as.Date(date_intervalle_[2])-as.Date(date_intervalle_[1])+1,0))){
    #   stop(paste0("Error with rcp content. File :", list_files_chroniquesProba_[l], " - HER : ", HER_h_))
    # }
    
    
    ### Sans les periodes ###
    tab_allModels_$Type <- factor(tab_allModels_$Type, levels = c("Safran", unique(tab_allModels_$Type)[which(unique(tab_allModels_$Type) != "Safran")]))
    tab_allModels_ <- arrange(tab_allModels_, Type, Date)
    
    ### Export Table ###
    if (!(dir.exists(paste0(folder_input_,"Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/",
                            ifelse(obsSim_param_=="",nom_GCM_param_,
                                   paste0("FDC_",obsSim_param_,
                                          ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                          ifelse(nom_categorieSimu_=="","",nom_categorieSimu_))))))){
      dir.create(paste0(folder_input_,"Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/",
                        ifelse(obsSim_param_=="",nom_GCM_param_,
                               paste0("FDC_",obsSim_param_,
                                      ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                      ifelse(nom_categorieSimu_=="","",nom_categorieSimu_)))))}
    write.table(tab_allModels_,paste0(folder_input_,"Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/",
                                                ifelse(obsSim_param_=="",nom_GCM_param_,
                                                       paste0("FDC_",obsSim_param_,
                                                              ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                              ifelse(nom_categorieSimu_=="","",nom_categorieSimu_))),
                                                "/Tab_ChroniquesProba_LearnBrut_HER",HER_h_,".txt"),
                sep = ";", dec = ".", row.names = F)
    
  }
}

### Parallel MPI ###
# Sys.sleep(10)
# mpi.finalize()
####################
