print("GRSD - 8_Chroniques_ProjectionsAssecs_19752004_7local_20240229.R")
source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_GRSD/PathsProgram/PathProgram_1_20230206.R")
source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_GRSD/1_Parameters_MESO/0_SimulationParameters_AvecCC_2_20230227_MESO.R")
source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_Commun/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")
source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_GRSD/5_StatisticsAndGraphs/8_Chroniques_ProjectionsAssecs_TousHorizons_11_20240305.R")
source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_GRSD/5_StatisticsAndGraphs/8_Chroniques_ProjectionsAssecs_FonctionProj_11_20240305.R")

# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")

### Libraries ###
suppressMessages(library(doParallel))
suppressMessages(library(tidyverse))
suppressMessages(library(svglite))
suppressMessages(library(ggplot2))
suppressMessages(library(strex))
suppressMessages(library(latex2exp))
suppressMessages(library(lubridate))

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
    tab_1_ = NULL
    
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
    
    # grapheMoyMed_19752005(tab_allModels_ = tab_allModels_,
    #                       date_intervalle_ = c("1977-01-01","2004-12-31"),
    #                       HER_h_ = HER_h_,
    #                       pattern_rcp_ = pattern_rcp_,
    #                       list_files_chroniquesProba_ = list_files_chroniquesProba_,
    #                       folder_output_ = folder_output_,
    #                       nomSim_ = nomSim_,
    #                       nom_categorieSimu_ = nom_categorieSimu_)
    # 
    # grapheMoyMed_proj(tab_allModels_ = tab_allModels_,
    #                   date_intervalle_ = c("2021-01-01","2050-12-31"),
    #                   HER_h_ = HER_h_,
    #                   pattern_rcp_ = pattern_rcp_,
    #                   list_files_chroniquesProba_ = list_files_chroniquesProba_,
    #                   folder_output_ = folder_output_,
    #                   nomSim_ = nomSim_,
    #                   nom_categorieSimu_ = nom_categorieSimu_)
    
    grapheMoyMed_proj(tab_allModels_ = tab_allModels_,
                      date_intervalle_ = c("2041-01-01","2070-12-31"),
                      HER_h_ = HER_h_,
                      pattern_rcp_ = pattern_rcp_,
                      list_files_chroniquesProba_ = list_files_chroniquesProba_,
                      folder_output_ = folder_output_,
                      nomSim_ = nomSim_,
                      nom_categorieSimu_ = nom_categorieSimu_)
    
    grapheMoyMed_proj(tab_allModels_ = tab_allModels_,
                      date_intervalle_ = c("2071-01-01","2099-12-31"),
                      HER_h_ = HER_h_,
                      pattern_rcp_ = pattern_rcp_,
                      list_files_chroniquesProba_ = list_files_chroniquesProba_,
                      folder_output_ = folder_output_,
                      nomSim_ = nomSim_,
                      nom_categorieSimu_ = nom_categorieSimu_)

  }
}

### Parallel MPI ###
Sys.sleep(10)
mpi.finalize()
####################
