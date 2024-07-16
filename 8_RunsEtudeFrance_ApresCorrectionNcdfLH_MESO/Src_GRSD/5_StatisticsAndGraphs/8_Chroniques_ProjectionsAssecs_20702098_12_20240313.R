print("GRSD - 8_Chroniques_ProjectionsAssecs_20702098_7local_20240229.R")
source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_GRSD/PathsProgram/PathProgram_1_20230206.R")
source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_GRSD/1_Parameters_MESO/0_SimulationParameters_AvecCC_2_20230227_MESO.R")
source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_Commun/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")

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

# date_intervalle_ = c("2071-01-01","2099-12-31")
date_intervalle_ = c("2071-01-01","2098-12-31")
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
    
    tab_allModels_$Date <- as.Date(tab_allModels_$Date)
    tab_allModels_$Jour_annee <- format(tab_allModels_$Date, format = "%m-%d")
    
    ### Selectionner periode ###
    # tab_allModels_2070_2100_ = tab_allModels_[which(tab_allModels_$Date >= as.Date(date_intervalle_[1]) & tab_allModels_$Date <= as.Date(date_intervalle_[2])),]
    # if (!(nrow(tab_allModels_2070_2100_[which(tab_allModels_2070_2100_$Type == "Historical"),]) %in% c(as.Date(date_intervalle_[2])-as.Date(date_intervalle_[1])+1,0))){
    #   stop(paste0("Error with Historical content. File :", list_files_chroniquesProba_[l], " - HER : ", HER_h_))
    # }
    # if (!(nrow(tab_allModels_2070_2100_[which(tab_allModels_2070_2100_$Type == "Safran"),]) %in% c(as.Date(date_intervalle_[2])-as.Date(date_intervalle_[1])+1,0))){
    #   stop(paste0("Error with Safran content. File :", list_files_chroniquesProba_[l], " - HER : ", HER_h_))
    # }
    # if (!(nrow(tab_allModels_2070_2100_[grepl("rcp",tab_allModels_2070_2100_$Type),]) %in% c(as.Date(date_intervalle_[2])-as.Date(date_intervalle_[1])+1,0))){
    #   stop(paste0("Error with rcp content. File :", list_files_chroniquesProba_[l], " - HER : ", HER_h_))
    # }
    tab_allModels_2070_2100_ = tab_allModels_[which(tab_allModels_$Date >= as.Date(date_intervalle_[1]) & tab_allModels_$Date <= as.Date(date_intervalle_[2])),]
    tab_allModels_2070_2100_$Type[grep("rcp",tab_allModels_2070_2100_$Type)] = "Historical"
    if (!((nrow(tab_allModels_2070_2100_[which(tab_allModels_2070_2100_$Type == "Historical"),]) > as.Date(date_intervalle_[2])-as.Date(date_intervalle_[1])+1-366) | (nrow(tab_allModels_2070_2100_[which(tab_allModels_2070_2100_$Type == "Historical"),]) %in% c(as.Date(date_intervalle_[2])-as.Date(date_intervalle_[1])+1,0)))){
      stop(paste0("Error with Historical content. File :", list_files_chroniquesProba_[l], " - HER : ", HER_h_))
    }
    if (!((nrow(tab_allModels_2070_2100_[which(tab_allModels_2070_2100_$Type == "Safran"),]) > as.Date(date_intervalle_[2])-as.Date(date_intervalle_[1])+1-366) | (nrow(tab_allModels_2070_2100_[which(tab_allModels_2070_2100_$Type == "Safran"),]) %in% c(as.Date(date_intervalle_[2])-as.Date(date_intervalle_[1])+1,0)))){
      stop(paste0("Error with Safran content. File :", list_files_chroniquesProba_[l], " - HER : ", HER_h_))
    }
    
    # Melt (convertir) le dataframe pour le rendre plus facile à utiliser dans ggplot2
    df_melted <- tab_allModels_2070_2100_ %>%
      select(-Jour_annee) %>%
      pivot_longer(cols = -c(Date, Type), names_to = "Variable", values_to = "Value")
    
    # Calculer la moyenne par jour de l'année
    df_mean <- df_melted %>%
      mutate(Jour_annee = format(Date, "%m-%d")) %>%
      group_by(Type, Variable, Jour_annee) %>%
      summarise(Mean_Value = mean(na.omit(Value)),
                Median_Value = median(na.omit(Value)),
                .groups = 'drop')
    
    df_mean <- df_mean %>%
      mutate(Color = case_when(
        grepl("CNRM-CERFACS.*CNRM-ALADIN63.*CDFt", Variable) ~ "black",
        grepl("CNRM-CERFACS.*CNRM-ALADIN63.*ADAMONT", Variable) ~ "#E5E840",
        grepl("CNRM-CERFACS.*MOHC-HadREM3.*CDFt", Variable) ~ "black",
        grepl("CNRM-CERFACS.*MOHC-HadREM3.*ADAMONT", Variable) ~ "black",
        grepl("ICHEC-EC-EARTH.*KNMI-RACMO22E.*CDFt", Variable) ~ "black",
        grepl("ICHEC-EC-EARTH.*KNMI-RACMO22E.*ADAMONT", Variable) ~ "black",
        grepl("ICHEC-EC-EARTH.*MOHC-HadREM3.*CDFt", Variable) ~ "black",
        grepl("ICHEC-EC-EARTH.*MOHC-HadREM3.*ADAMONT", Variable) ~ "#E2A138",
        grepl("ICHEC-EC-EARTH.*SMHI-RCA4_v2.*CDFt", Variable) ~ "black",
        grepl("ICHEC-EC-EARTH.*SMHI-RCA4_v2.*ADAMONT", Variable) ~ "black",
        grepl("IPSL-IPSL-CM5A-MR.*DMI-HIRHAM5.*CDFt", Variable) ~ "black",
        grepl("IPSL-IPSL-CM5A-MR.*DMI-HIRHAM5.*ADAMONT", Variable) ~ "black",
        grepl("IPSL-IPSL-CM5A-MR.*SMHI-RCA4_v2.*CDFt", Variable) ~ "black",
        grepl("IPSL-IPSL-CM5A-MR.*SMHI-RCA4_v2.*ADAMONT", Variable) ~ "black",
        grepl("MOHC-HadGEM2-ES.*CLMcom-CCLM4.*CDFt", Variable) ~ "black",
        grepl("MOHC-HadGEM2-ES.*CLMcom-CCLM4.*ADAMONT", Variable) ~ "#70194E",
        grepl("MOHC-HadGEM2-ES.*CNRM-ALADIN63.*CDFt", Variable) ~ "black",
        grepl("MOHC-HadGEM2-ES.*CNRM-ALADIN63.*ADAMONT", Variable) ~ "#447C57",
        grepl("MOHC-HadGEM2-ES.*ICTP-RegCM4-6.*CDFt", Variable) ~ "black",
        grepl("MOHC-HadGEM2-ES.*ICTP-RegCM4-6.*ADAMONT", Variable) ~ "black",
        grepl("MOHC-HadGEM2-ES.*MOHC-HadREM3-GA7.*CDFt", Variable) ~ "black",
        grepl("MOHC-HadGEM2-ES.*MOHC-HadREM3-GA7.*ADAMONT", Variable) ~ "black",
        grepl("MPI-M-MPI-ESM-LR.*CLMcom-CCLM4.*CDFt", Variable) ~ "black",
        grepl("MPI-M-MPI-ESM-LR.*CLMcom-CCLM4.*ADAMONT", Variable) ~ "black",
        grepl("MPI-M-MPI-ESM-LR.*ICTP-RegCM4-6.*CDFt", Variable) ~ "black",
        grepl("MPI-M-MPI-ESM-LR.*ICTP-RegCM4-6.*ADAMONT", Variable) ~ "black",
        grepl("MPI-M-MPI-ESM-LR.*MPI-CSC-REMO2009.*CDFt", Variable) ~ "black",
        grepl("MPI-M-MPI-ESM-LR.*MPI-CSC-REMO2009.*ADAMONT", Variable) ~ "black",
        grepl("NCC-NorESM1-M.*DMI-HIRHAM5.*CDFt", Variable) ~ "black",
        grepl("NCC-NorESM1-M.*DMI-HIRHAM5.*ADAMONT", Variable) ~ "black",
        grepl("NCC-NorESM1-M.*GERICS-REMO2015.*CDFt", Variable) ~ "black",
        grepl("NCC-NorESM1-M.*GERICS-REMO2015.*ADAMONT", Variable) ~ "black",
        grepl("NCC-NorESM1-M.*IPSL-WRF381P.*CDFt", Variable) ~ "black",
        grepl("NCC-NorESM1-M.*IPSL-WRF381P.*ADAMONT", Variable) ~ "black",
        grepl("Safran", Variable) ~ "#253494"))
    
    df_mean <- df_mean %>%
      mutate(Alpha = case_when(
        grepl("CNRM-CERFACS.*CNRM-ALADIN63.*CDFt", Variable) ~ 0.15,
        grepl("CNRM-CERFACS.*CNRM-ALADIN63.*ADAMONT", Variable) ~ 1,
        grepl("CNRM-CERFACS.*MOHC-HadREM3.*CDFt", Variable) ~ 0.15,
        grepl("CNRM-CERFACS.*MOHC-HadREM3.*ADAMONT", Variable) ~ 0.15,
        grepl("ICHEC-EC-EARTH.*KNMI-RACMO22E.*CDFt", Variable) ~ 0.15,
        grepl("ICHEC-EC-EARTH.*KNMI-RACMO22E.*ADAMONT", Variable) ~ 0.15,
        grepl("ICHEC-EC-EARTH.*MOHC-HadREM3.*CDFt", Variable) ~ 0.15,
        grepl("ICHEC-EC-EARTH.*MOHC-HadREM3.*ADAMONT", Variable) ~ 1,
        grepl("ICHEC-EC-EARTH.*SMHI-RCA4_v2.*CDFt", Variable) ~ 0.15,
        grepl("ICHEC-EC-EARTH.*SMHI-RCA4_v2.*ADAMONT", Variable) ~ 0.15,
        grepl("IPSL-IPSL-CM5A-MR.*DMI-HIRHAM5.*CDFt", Variable) ~ 0.15,
        grepl("IPSL-IPSL-CM5A-MR.*DMI-HIRHAM5.*ADAMONT", Variable) ~ 0.15,
        grepl("IPSL-IPSL-CM5A-MR.*SMHI-RCA4_v2.*CDFt", Variable) ~ 0.15,
        grepl("IPSL-IPSL-CM5A-MR.*SMHI-RCA4_v2.*ADAMONT", Variable) ~ 0.15,
        grepl("MOHC-HadGEM2-ES.*CLMcom-CCLM4.*CDFt", Variable) ~ 0.15,
        grepl("MOHC-HadGEM2-ES.*CLMcom-CCLM4.*ADAMONT", Variable) ~ 1,
        grepl("MOHC-HadGEM2-ES.*CNRM-ALADIN63.*CDFt", Variable) ~ 0.15,
        grepl("MOHC-HadGEM2-ES.*CNRM-ALADIN63.*ADAMONT", Variable) ~ 1,
        grepl("MOHC-HadGEM2-ES.*ICTP-RegCM4-6.*CDFt", Variable) ~ 0.15,
        grepl("MOHC-HadGEM2-ES.*ICTP-RegCM4-6.*ADAMONT", Variable) ~ 0.15,
        grepl("MOHC-HadGEM2-ES.*MOHC-HadREM3-GA7.*CDFt", Variable) ~ 0.15,
        grepl("MOHC-HadGEM2-ES.*MOHC-HadREM3-GA7.*ADAMONT", Variable) ~ 0.15,
        grepl("MPI-M-MPI-ESM-LR.*CLMcom-CCLM4.*CDFt", Variable) ~ 0.15,
        grepl("MPI-M-MPI-ESM-LR.*CLMcom-CCLM4.*ADAMONT", Variable) ~ 0.15,
        grepl("MPI-M-MPI-ESM-LR.*ICTP-RegCM4-6.*CDFt", Variable) ~ 0.15,
        grepl("MPI-M-MPI-ESM-LR.*ICTP-RegCM4-6.*ADAMONT", Variable) ~ 0.15,
        grepl("MPI-M-MPI-ESM-LR.*MPI-CSC-REMO2009.*CDFt", Variable) ~ 0.15,
        grepl("MPI-M-MPI-ESM-LR.*MPI-CSC-REMO2009.*ADAMONT", Variable) ~ 0.15,
        grepl("NCC-NorESM1-M.*DMI-HIRHAM5.*CDFt", Variable) ~ 0.15,
        grepl("NCC-NorESM1-M.*DMI-HIRHAM5.*ADAMONT", Variable) ~ 0.15,
        grepl("NCC-NorESM1-M.*GERICS-REMO2015.*CDFt", Variable) ~ 0.15,
        grepl("NCC-NorESM1-M.*GERICS-REMO2015.*ADAMONT", Variable) ~ 0.15,
        grepl("NCC-NorESM1-M.*IPSL-WRF381P.*CDFt", Variable) ~ 0.15,
        grepl("NCC-NorESM1-M.*IPSL-WRF381P.*ADAMONT", Variable) ~ 0.15,
        grepl("Safran", Variable) ~ 1))
    
    df_mean <- df_mean %>%
      mutate(Legend = case_when(
        grepl("CNRM-CERFACS.*CNRM-ALADIN63.*CDFt", Variable) ~ "Autres modèles",
        grepl("CNRM-CERFACS.*CNRM-ALADIN63.*ADAMONT", Variable) ~ "Modéré en réchauffement et\nen changement de précipitations",
        grepl("CNRM-CERFACS.*MOHC-HadREM3.*CDFt", Variable) ~ "Autres modèles",
        grepl("CNRM-CERFACS.*MOHC-HadREM3.*ADAMONT", Variable) ~ "Autres modèles",
        grepl("ICHEC-EC-EARTH.*KNMI-RACMO22E.*CDFt", Variable) ~ "Autres modèles",
        grepl("ICHEC-EC-EARTH.*KNMI-RACMO22E.*ADAMONT", Variable) ~ "Autres modèles",
        grepl("ICHEC-EC-EARTH.*MOHC-HadREM3.*CDFt", Variable) ~ "Autres modèles",
        grepl("ICHEC-EC-EARTH.*MOHC-HadREM3.*ADAMONT", Variable) ~ "Sec toute l'année,\nrecharge moindre en hiver",
        grepl("ICHEC-EC-EARTH.*SMHI-RCA4_v2.*CDFt", Variable) ~ "Autres modèles",
        grepl("ICHEC-EC-EARTH.*SMHI-RCA4_v2.*ADAMONT", Variable) ~ "Autres modèles",
        grepl("IPSL-IPSL-CM5A-MR.*DMI-HIRHAM5.*CDFt", Variable) ~ "Autres modèles",
        grepl("IPSL-IPSL-CM5A-MR.*DMI-HIRHAM5.*ADAMONT", Variable) ~ "Autres modèles",
        grepl("IPSL-IPSL-CM5A-MR.*SMHI-RCA4_v2.*CDFt", Variable) ~ "Autres modèles",
        grepl("IPSL-IPSL-CM5A-MR.*SMHI-RCA4_v2.*ADAMONT", Variable) ~ "Autres modèles",
        grepl("MOHC-HadGEM2-ES.*CLMcom-CCLM4.*CDFt", Variable) ~ "Autres modèles",
        grepl("MOHC-HadGEM2-ES.*CLMcom-CCLM4.*ADAMONT", Variable) ~ "Fort réchauffement et\nfort assèchement en été",
        grepl("MOHC-HadGEM2-ES.*CNRM-ALADIN63.*CDFt", Variable) ~ "Autres modèles",
        grepl("MOHC-HadGEM2-ES.*CNRM-ALADIN63.*ADAMONT", Variable) ~ "Chaud et humide\nà toutes les saisons",
        grepl("MOHC-HadGEM2-ES.*ICTP-RegCM4-6.*CDFt", Variable) ~ "Autres modèles",
        grepl("MOHC-HadGEM2-ES.*ICTP-RegCM4-6.*ADAMONT", Variable) ~ "Autres modèles",
        grepl("MOHC-HadGEM2-ES.*MOHC-HadREM3-GA7.*CDFt", Variable) ~ "Autres modèles",
        grepl("MOHC-HadGEM2-ES.*MOHC-HadREM3-GA7.*ADAMONT", Variable) ~ "Autres modèles",
        grepl("MPI-M-MPI-ESM-LR.*CLMcom-CCLM4.*CDFt", Variable) ~ "Autres modèles",
        grepl("MPI-M-MPI-ESM-LR.*CLMcom-CCLM4.*ADAMONT", Variable) ~ "Autres modèles",
        grepl("MPI-M-MPI-ESM-LR.*ICTP-RegCM4-6.*CDFt", Variable) ~ "Autres modèles",
        grepl("MPI-M-MPI-ESM-LR.*ICTP-RegCM4-6.*ADAMONT", Variable) ~ "Autres modèles",
        grepl("MPI-M-MPI-ESM-LR.*MPI-CSC-REMO2009.*CDFt", Variable) ~ "Autres modèles",
        grepl("MPI-M-MPI-ESM-LR.*MPI-CSC-REMO2009.*ADAMONT", Variable) ~ "Autres modèles",
        grepl("NCC-NorESM1-M.*DMI-HIRHAM5.*CDFt", Variable) ~ "Autres modèles",
        grepl("NCC-NorESM1-M.*DMI-HIRHAM5.*ADAMONT", Variable) ~ "Autres modèles",
        grepl("NCC-NorESM1-M.*GERICS-REMO2015.*CDFt", Variable) ~ "Autres modèles",
        grepl("NCC-NorESM1-M.*GERICS-REMO2015.*ADAMONT", Variable) ~ "Autres modèles",
        grepl("NCC-NorESM1-M.*IPSL-WRF381P.*CDFt", Variable) ~ "Autres modèles",
        grepl("NCC-NorESM1-M.*IPSL-WRF381P.*ADAMONT", Variable) ~ "Autres modèles",
        grepl("Safran", Variable) ~ "Safran"))
    
    translation_dict <- c("Modéré en réchauffement et\nen changement de précipitations" = "Moderate warming and\nprecipitation change",
                          "Sec toute l'année,\nrecharge moindre en hiver" = "Dry all year round,\nreduced winter recharge",
                          "Fort réchauffement et\nfort assèchement en été" = "Strong warming and\nsummer drying",
                          "Chaud et humide\nà toutes les saisons" = "Hot and humid\nall seasons",
                          "Autres modèles" = "Other models",
                          "Safran" = "Safran")
    df_mean <- df_mean %>%
      mutate(Legend_English = translation_dict[Legend])
    
    ### Legende ###
    variables_a_afficher <- unique(df_mean$Legend[which(df_mean$Alpha == 1)])
    df_mean$AfficherDansLegende <- ifelse(df_mean$Legend %in% variables_a_afficher, as.character(df_mean$Legend), "")
    
    desired_order <- c(unique(df_mean$Legend[which(df_mean$Color == "#E5E840")]),
                       unique(df_mean$Legend[which(df_mean$Color == "#E2A138")]),
                       unique(df_mean$Legend[which(df_mean$Color == "#70194E")]),
                       unique(df_mean$Legend[which(df_mean$Color == "#447C57")]),
                       unique(df_mean$Legend[which(df_mean$Color == "#253494")]),
                       "")
    
    df_mean$AfficherDansLegende <- factor(df_mean$AfficherDansLegende, levels = c(desired_order))
    
    custom_colors <- c("Modéré en réchauffement et\nen changement de précipitations" = "#E5E840",
                       "Sec toute l'année,\nrecharge moindre en hiver" = "#E2A138",
                       "Fort réchauffement et\nfort assèchement en été" = "#70194E",
                       "Chaud et humide\nà toutes les saisons" = "#447C57",
                       "Autres modèles" = "black")
    desired_order <- c("Modéré en réchauffement et\nen changement de précipitations",
                       "Sec toute l'année,\nrecharge moindre en hiver",
                       "Fort réchauffement et\nfort assèchement en été",
                       "Chaud et humide\nà toutes les saisons",
                       "Autres modèles")
    desired_order_english <- c("Moderate warming and\nprecipitation change",
                               "Dry all year round,\nreduced winter recharge",
                               "Strong warming and\nsummer drying",
                               "Hot and humid\nall seasons",
                               "Other models")
    
    desired_order_lty <- c(pattern_rcp_)
    
    df_mean$Color <- factor(df_mean$Color, levels = intersect(c("#E5E840", "#E2A138", "#70194E", "#447C57","#253494","black"), levels(factor(df_mean$Color))))
    df_mean$Legend <- factor(df_mean$Legend, levels = desired_order)
    df_mean$Legend_English <- factor(df_mean$Legend_English, levels = desired_order_english)
    df_mean$Jour_annee <- as.Date(paste0("2022-",df_mean$Jour_annee))
    
    ### Lissage ###
    df_mean <- df_mean %>%
      group_by(Type,Variable) %>%
      mutate(Mean_ValueLissee = (lag(Mean_Value, 2) + lag(Mean_Value, 1) + Mean_Value + lead(Mean_Value, 1) + lead(Mean_Value, 2)) / 5) %>%
      mutate(Median_ValueLissee = (lag(Median_Value, 2) + lag(Median_Value, 1) + Median_Value + lead(Median_Value, 1) + lead(Median_Value, 2)) / 5)
    
    df_mean_overwriteColors_ <- df_mean[which(df_mean$Legend %in% c("Modéré en réchauffement et\nen changement de précipitations",
                                                                    "Sec toute l'année,\nrecharge moindre en hiver",
                                                                    "Fort réchauffement et\nfort assèchement en été",
                                                                    "Chaud et humide\nà toutes les saisons",
                                                                    "Safran")),]
    
    ### Axe x ###
    first_days <- df_mean[which(day(as.Date(df_mean$Jour_annee)) == 15),]
    # year_labels <- rep(c('Janv.','Févr.','Mars','Avril','Mai','Juin','Juil.','Août','Sept.','Oct.','Nov.','Déc.'))
    year_labels <- rep(c('J','F','M','A','M','J','J','A','S','O','N','D'))
    year_labels <- c("", as.vector(rbind(year_labels, rep("", length(year_labels)))))
    # year_labels_eng <- rep(c('Jan.','Feb.','Mar.','Apr.','May','Jun.','Jul.','Aug.','Sep.','Oct.','Nov.','Dec.'))
    year_labels_eng <- rep(c('J','F','M','A','M','J','J','A','S','O','N','D'))
    year_labels_eng <- c("", as.vector(rbind(year_labels_eng, rep("", length(year_labels_eng)))))
    breaks_dates_ <- sort(c(seq(as.Date("2022-01-01"), 
                                as.Date("2022-12-01"), by="months"),
                            "2022-01-15","2022-02-14","2022-03-16","2022-04-15","2022-05-16","2022-06-15","2022-07-16","2022-08-16","2022-09-15","2022-10-16","2022-11-15","2022-12-16",
                            "2022-12-31"))
    
    ### Rcp ###
    # df_mean_rcp_ = df_mean[which(df_mean$Type == pattern_rcp_),]
    # df_mean_overwriteColors_rcp_ = df_mean_overwriteColors_[which(df_mean_overwriteColors_$Type == pattern_rcp_),]
    
    p_mean <- ggplot() +
      geom_line(data = df_mean, aes(x = Jour_annee, y = Mean_ValueLissee, group = Variable, color = Legend, lineend = "round"), alpha = 0.15, lwd = 1) + # linetype = Type, 
      geom_line(data = df_mean_overwriteColors_, aes(x = Jour_annee, y = Mean_ValueLissee, group = Variable), color = "white", alpha = 1, lwd = 3.4, lineend = "round") +
      geom_line(data = df_mean_overwriteColors_, aes(x = Jour_annee, y = Mean_ValueLissee, group = Variable, color = Legend), alpha = 1, lwd = 2, lineend = "round") +
      
      scale_color_manual(name = "Modèles GCM-RCM",
                         labels = levels(df_mean$Legend),
                         values = levels(df_mean$Color))+
      # scale_linetype_manual(values = as.factor(c("solid","longdash")),
      #                       name = "Données climatiques d'entrée",
      #                       labels = c("Historique GCM-RCM","Safran"))+
      
      # Axes #
      scale_x_date("Date",
                   breaks = breaks_dates_,
                   labels = year_labels,
                   expand = c(0,0),
                   minor_breaks=c(seq(from=as.Date("2022-01-01"),to=as.Date("2022-12-01"),by="month"),"2022-12-31")) +
      scale_y_continuous(expand = expansion(mult = c(0, 0.05)),
                         limits = c(0,80),
                         labels = function(x) paste0(x, "%")) + # Supprimer l'espace entre l'axe des abscisses et la première valeur de y
      
      labs(title = "Moyenne des probabilités d'assecs lissées sur 5 jours",
           subtitle = paste0("Modèle hydrologique : ",str_before_first(nom_categorieSimu_,"_"),
                             " - RCP ",paste0(str_extract_all(pattern_rcp_, "[0-9]")[[1]][1],".",str_extract_all(pattern_rcp_, "[0-9]")[[1]][2]),
                             " - Période : ",year(date_intervalle_[1]),"-",year(date_intervalle_[2]),
                             " - HER : ",HER_h_),
           x = "Date",
           y = "Moyenne des probabilités d'assecs") +
      
      theme_minimal() +
      theme(plot.title = element_text(color = "#060403", size = 30, face = "bold"),
            plot.subtitle = element_text(color = "#2f2f32", size = 18),
            plot.margin = margin(20, 20, 20, 20),
            
            axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            axis.text.x = element_text(color = "#2f2f32", vjust = 0, hjust=0.5), # angle = 90
            axis.text.y = element_text(color = "#2f2f32"),
            axis.line.x = element_line(color = "#bebdbb", size = 1), # Trait des abscisses plus épais, IPCCgrey75
            axis.line.y = element_blank(), # Remove y-axis line
            axis.ticks.x=element_line(colour=c("#bebdbb",rep(c(NA, "#bebdbb"), t=12))),
            axis.ticks.length  = unit(0.35, "cm"),
            
            panel.grid.major.x = element_blank(), # Lighter horizontal grid lines
            panel.grid.minor.x = element_blank(), # Lighter horizontal grid lines
            panel.grid.major.y = element_line(color = "#dcdad9", size = 0.5), # Traits horizontaux plus clairs
            panel.grid.minor.y = element_line(color = "#dcdad9", size = 0.5), # Traits horizontaux plus clairs
            
            text = element_text(size = 20),
            
            strip.text.x = element_blank(),
            strip.background = element_blank(),
            
            legend.title = element_text(color = "#2f2f32", size = 18, face = "bold"),
            legend.text = element_text(color = "#2f2f32", size = 18)) +
      
      guides(alpha = FALSE,
             color = guide_legend(
               override.aes = list(lwd = 2.5, alpha = c(rep(1,length(levels(df_mean$Color))-1),0.15)),
               keyheight = 3.2,
               keywidth = unit(2,"cm")),
             linetype = guide_legend(keyheight = 1.8,
                                     keywidth = unit(2,"cm"),
                                     override.aes = list(linetype = c("solid", "dotdash"))))

    if (!(dir.exists(paste0(folder_output_,
                            "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                            nomSim_,
                            ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                            "/Chroniques/")))){
      dir.create(paste0(folder_output_,
                        "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        "/Chroniques/"))}
    if (!(dir.exists(paste0(folder_output_,
                            "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                            nomSim_,
                            ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                            "/Chroniques/",year(date_intervalle_[1]),year(date_intervalle_[2]),"/")))){
      dir.create(paste0(folder_output_,
                        "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        "/Chroniques/",year(date_intervalle_[1]),year(date_intervalle_[2]),"/"))}
    if (!(dir.exists(paste0(folder_output_,
                            "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                            nomSim_,
                            ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                            "/Chroniques/",year(date_intervalle_[1]),year(date_intervalle_[2]),"/Eng/")))){
      dir.create(paste0(folder_output_,
                        "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        "/Chroniques/",year(date_intervalle_[1]),year(date_intervalle_[2]),"/Eng/"))}
    
    ### Svg ###
    svg_device <- svglite(paste0(folder_output_,
                                 "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                                 nomSim_,
                                 ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                 "/Chroniques/",year(date_intervalle_[1]),year(date_intervalle_[2]),"/ProbaMeanValue_",pattern_rcp_,"_",year(date_intervalle_[1]),year(date_intervalle_[2]),"_HER",HER_h_,"_1_20240227.svg"),
                          width = 15)
    print(p_mean)
    dev.off()
    saveRDS(p_mean, file = paste0(folder_output_,
                                  "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                                  nomSim_,
                                  ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                  "/Chroniques/",year(date_intervalle_[1]),year(date_intervalle_[2]),"/ProbaMeanValue_",pattern_rcp_,"_",year(date_intervalle_[1]),year(date_intervalle_[2]),"_HER",HER_h_,"_1_20240227.rds"))
    
    
    ### Mean - English ###
    p_mean <- ggplot() +
      geom_line(data = df_mean, aes(x = Jour_annee, y = Mean_ValueLissee, group = Variable, color = Legend_English, lineend = "round"), alpha = 0.15, lwd = 1) + # linetype = Type, 
      geom_line(data = df_mean_overwriteColors_, aes(x = Jour_annee, y = Mean_ValueLissee, group = Variable), color = "white", alpha = 1, lwd = 3.4, lineend = "round") +
      geom_line(data = df_mean_overwriteColors_, aes(x = Jour_annee, y = Mean_ValueLissee, group = Variable, color = Legend_English), alpha = 1, lwd = 2, lineend = "round") +
      
      scale_color_manual(name = "GCM-RCM Models",
                         values = levels(df_mean$Color))+
      scale_linetype_manual(values = as.factor(c("solid","longdash")),
                            name = "Input Climate Data",
                            labels = c("Historical GCM-RCM","Safran"))+
      
      # Axes #
      scale_x_date("Date",
                   breaks = breaks_dates_,
                   labels = year_labels_eng,
                   expand = c(0,0),
                   minor_breaks=c(seq(from=as.Date("2022-01-01"),to=as.Date("2022-12-01"),by="month"),"2022-12-31")) +
      scale_y_continuous(expand = expansion(mult = c(0, 0.05)),
                         limits = c(0,80),
                         labels = function(x) paste0(x, "%")) + # Remove the space between the x-axis and the first y-value
      
      labs(title = "Average smoothed probabilities of drought over 5 days",
           subtitle = paste0("Hydrological Model: ",str_before_first(nom_categorieSimu_,"_"),
                             " - RCP ",paste0(str_extract_all(pattern_rcp_, "[0-9]")[[1]][1],".",str_extract_all(pattern_rcp_, "[0-9]")[[1]][2]),
                             " - Period: ",year(date_intervalle_[1]),"-",year(date_intervalle_[2]),
                             " - HER: ",HER_h_),
           x = "Date",
           y = "Average probabilities of drought") +
      
      theme_minimal() +
      theme(plot.title = element_text(color = "#060403", size = 30, face = "bold"),
            plot.subtitle = element_text(color = "#2f2f32", size = 18),
            plot.margin = margin(20, 20, 20, 20),
            
            axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            axis.text.x = element_text(color = "#2f2f32", vjust = 0, hjust=0.5), # angle = 90
            axis.text.y = element_text(color = "#2f2f32"),
            axis.line.x = element_line(color = "#bebdbb", size = 1), # Trait des abscisses plus épais, IPCCgrey75
            axis.line.y = element_blank(), # Remove y-axis line
            axis.ticks.x=element_line(colour=c("#bebdbb",rep(c(NA, "#bebdbb"), t=12))),
            axis.ticks.length  = unit(0.35, "cm"),
            
            panel.grid.major.x = element_blank(), # Lighter horizontal grid lines
            panel.grid.minor.x = element_blank(), # Lighter horizontal grid lines
            panel.grid.major.y = element_line(color = "#dcdad9", size = 0.5), # Traits horizontaux plus clairs
            panel.grid.minor.y = element_line(color = "#dcdad9", size = 0.5), # Traits horizontaux plus clairs
            
            text = element_text(size = 20),
            
            strip.text.x = element_blank(),
            strip.background = element_blank(),
            
            legend.title = element_text(color = "#2f2f32", size = 18, face = "bold"),
            legend.text = element_text(color = "#2f2f32", size = 18)) +
      
      guides(alpha = FALSE,
             color = guide_legend(
               override.aes = list(lwd = 2.5, alpha = c(rep(1,length(levels(df_mean$Color))-1),0.15)),
               keyheight = 3.2,
               keywidth = unit(2,"cm")),
             linetype = guide_legend(keyheight = 1.8,
                                     keywidth = unit(2,"cm"),
                                     override.aes = list(linetype = c("solid", "dotdash"))))
    
    svg_device <- svglite(paste0(folder_output_,
                                 "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                                 nomSim_,
                                 ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                 "/Chroniques/",year(date_intervalle_[1]),year(date_intervalle_[2]),"/Eng/ProbaMeanValue_",pattern_rcp_,"_",year(date_intervalle_[1]),year(date_intervalle_[2]),"_HER",HER_h_,"_Eng_1_20240227.svg"),
                          width = 15)
    print(p_mean)
    dev.off()
    saveRDS(p_mean, file = paste0(folder_output_,
                                  "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                                  nomSim_,
                                  ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                  "/Chroniques/",year(date_intervalle_[1]),year(date_intervalle_[2]),"/Eng/ProbaMeanValue_",pattern_rcp_,"_",year(date_intervalle_[1]),year(date_intervalle_[2]),"_HER",HER_h_,"_Eng_1_20240227.rds"))
    
    
    
    
    ### Median - French ###
    p_median <- ggplot() +
      geom_line(data = df_mean, aes(x = Jour_annee, y = Median_ValueLissee, group = Variable, color = Legend, lineend = "round"), alpha = 0.15, lwd = 1) + # linetype = Type, 
      geom_line(data = df_mean_overwriteColors_, aes(x = Jour_annee, y = Median_ValueLissee, group = Variable), color = "white", alpha = 1, lwd = 3.4, lineend = "round") +
      geom_line(data = df_mean_overwriteColors_, aes(x = Jour_annee, y = Median_ValueLissee, group = Variable, color = Legend), alpha = 1, lwd = 2, lineend = "round") +
      
      scale_color_manual(name = "Modèles GCM-RCM",
                         values = levels(df_mean$Color))+
      scale_linetype_manual(values = as.factor(c("solid","longdash")),
                            name = "Données climatiques d'entrée",
                            labels = c("Historique GCM-RCM","Safran"))+
      
      # Axes #
      scale_x_date("Date",
                   breaks = breaks_dates_,
                   labels = year_labels,
                   expand = c(0,0),
                   minor_breaks=c(seq(from=as.Date("2022-01-01"),to=as.Date("2022-12-01"),by="month"),"2022-12-31")) +
      scale_y_continuous(expand = expansion(mult = c(0, 0.05)),
                         limits = c(0,80),
                         labels = function(x) paste0(x, "%")) + # Supprimer l'espace entre l'axe des abscisses et la première valeur de y
      
      labs(title = "Médiane des probabilités d'assecs lissées sur 5 jours",
           subtitle = paste0("Modèle hydrologique : ",str_before_first(nom_categorieSimu_,"_"),
                             " - RCP ",paste0(str_extract_all(pattern_rcp_, "[0-9]")[[1]][1],".",str_extract_all(pattern_rcp_, "[0-9]")[[1]][2]),
                             " - Période : ",year(date_intervalle_[1]),"-",year(date_intervalle_[2]),
                             " - HER : ",HER_h_),
           x = "Date",
           y = "Moyenne des probabilités d'assecs") +
      
      theme_minimal() +
      theme(plot.title = element_text(color = "#060403", size = 30, face = "bold"),
            plot.subtitle = element_text(color = "#2f2f32", size = 18),
            plot.margin = margin(20, 20, 20, 20),
            
            axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            axis.text.x = element_text(color = "#2f2f32", vjust = 0, hjust=0.5), # angle = 90
            axis.text.y = element_text(color = "#2f2f32"),
            axis.line.x = element_line(color = "#bebdbb", size = 1), # Trait des abscisses plus épais, IPCCgrey75
            axis.line.y = element_blank(), # Remove y-axis line
            axis.ticks.x=element_line(colour=c("#bebdbb",rep(c(NA, "#bebdbb"), t=12))),
            axis.ticks.length  = unit(0.35, "cm"),
            
            panel.grid.major.x = element_blank(), # Lighter horizontal grid lines
            panel.grid.minor.x = element_blank(), # Lighter horizontal grid lines
            panel.grid.major.y = element_line(color = "#dcdad9", size = 0.5), # Traits horizontaux plus clairs
            panel.grid.minor.y = element_line(color = "#dcdad9", size = 0.5), # Traits horizontaux plus clairs
            
            text = element_text(size = 20),
            
            strip.text.x = element_blank(),
            strip.background = element_blank(),
            
            legend.title = element_text(color = "#2f2f32", size = 18, face = "bold"),
            legend.text = element_text(color = "#2f2f32", size = 18)) +
      
      guides(alpha = FALSE,
             color = guide_legend(
               override.aes = list(lwd = 2.5, alpha = c(rep(1,length(levels(df_mean$Color))-1),0.15)),
               keyheight = 3.2,
               keywidth = unit(2,"cm")),
             linetype = guide_legend(keyheight = 1.8,
                                     keywidth = unit(2,"cm"),
                                     override.aes = list(linetype = c("solid", "dotdash"))))
    
    svg_device <- svglite(paste0(folder_output_,
                                 "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                                 nomSim_,
                                 ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                 "/Chroniques/",year(date_intervalle_[1]),year(date_intervalle_[2]),"/ProbaMedianValue_",pattern_rcp_,"_",year(date_intervalle_[1]),year(date_intervalle_[2]),"_HER",HER_h_,"_1_20240227.svg"),
                          width = 15)
    print(p_median)
    dev.off()
    saveRDS(p_median, file = paste0(folder_output_,
                                  "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                                  nomSim_,
                                  ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                  "/Chroniques/",year(date_intervalle_[1]),year(date_intervalle_[2]),"/ProbaMedianValue_",pattern_rcp_,"_",year(date_intervalle_[1]),year(date_intervalle_[2]),"_HER",HER_h_,"_1_20240227.rds"))
    
    
    ### Median - English ###
    p_median <- ggplot() +
      geom_line(data = df_mean, aes(x = Jour_annee, y = Median_ValueLissee, group = Variable, color = Legend_English, lineend = "round"), alpha = 0.15, lwd = 1) + # linetype = Type, 
      geom_line(data = df_mean_overwriteColors_, aes(x = Jour_annee, y = Median_ValueLissee, group = Variable), color = "white", alpha = 1, lwd = 3.4, lineend = "round") +
      geom_line(data = df_mean_overwriteColors_, aes(x = Jour_annee, y = Median_ValueLissee, group = Variable, color = Legend_English), alpha = 1, lwd = 2, lineend = "round") +
      
      scale_color_manual(name = "GCM-RCM Models",
                         values = levels(df_mean$Color))+
      scale_linetype_manual(values = as.factor(c("solid","longdash")),
                            name = "Input Climatic Data",
                            labels = c("Historical GCM-RCM","Safran"))+
      
      # Axes #
      scale_x_date("Date",
                   breaks = breaks_dates_,
                   labels = year_labels_eng,
                   expand = c(0,0),
                   minor_breaks=c(seq(from=as.Date("2022-01-01"),to=as.Date("2022-12-01"),by="month"),"2022-12-31")) +
      scale_y_continuous(expand = expansion(mult = c(0, 0.05)),
                         limits = c(0,80),
                         labels = function(x) paste0(x, "%")) + # Remove the space between the x-axis and the first y-value
      
      labs(title = "Median of smoothed 5-day exceedance probabilities",
           subtitle = paste0("Hydrological model: ",str_before_first(nom_categorieSimu_,"_"),
                             " - RCP ",paste0(str_extract_all(pattern_rcp_, "[0-9]")[[1]][1],".",str_extract_all(pattern_rcp_, "[0-9]")[[1]][2]),
                             " - Period: ",year(date_intervalle_[1]),"-",year(date_intervalle_[2]),
                             " - HER: ",HER_h_),
           x = "Date",
           y = "Mean of exceedance probabilities") +
      
      theme_minimal() +
      theme(plot.title = element_text(color = "#060403", size = 30, face = "bold"),
            plot.subtitle = element_text(color = "#2f2f32", size = 18),
            plot.margin = margin(20, 20, 20, 20),
            
            axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            axis.text.x = element_text(color = "#2f2f32", vjust = 0, hjust=0.5), # angle = 90
            axis.text.y = element_text(color = "#2f2f32"),
            axis.line.x = element_line(color = "#bebdbb", size = 1), # Trait des abscisses plus épais, IPCCgrey75
            axis.line.y = element_blank(), # Remove y-axis line
            axis.ticks.x=element_line(colour=c("#bebdbb",rep(c(NA, "#bebdbb"), t=12))),
            axis.ticks.length  = unit(0.35, "cm"),
            
            panel.grid.major.x = element_blank(), # Lighter horizontal grid lines
            panel.grid.minor.x = element_blank(), # Lighter horizontal grid lines
            panel.grid.major.y = element_line(color = "#dcdad9", size = 0.5), # Traits horizontaux plus clairs
            panel.grid.minor.y = element_line(color = "#dcdad9", size = 0.5), # Traits horizontaux plus clairs
            
            text = element_text(size = 20),
            
            strip.text.x = element_blank(),
            strip.background = element_blank(),
            
            legend.title = element_text(color = "#2f2f32", size = 18, face = "bold"),
            legend.text = element_text(color = "#2f2f32", size = 18)) +
      
      guides(alpha = FALSE,
             color = guide_legend(
               override.aes = list(lwd = 2.5, alpha = c(rep(1,length(levels(df_mean$Color))-1),0.15)),
               keyheight = 3.2,
               keywidth = unit(2,"cm")),
             linetype = guide_legend(keyheight = 1.8,
                                     keywidth = unit(2,"cm"),
                                     override.aes = list(linetype = c("solid", "dotdash"))))
    
    svg_device <- svglite(paste0(folder_output_,
                                 "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                                 nomSim_,
                                 ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                 "/Chroniques/",year(date_intervalle_[1]),year(date_intervalle_[2]),"/Eng/ProbaMedianValue_",pattern_rcp_,"_",year(date_intervalle_[1]),year(date_intervalle_[2]),"_HER",HER_h_,"_Eng_1_20240227.svg"),
                          width = 15)
    print(p_median)
    dev.off()
    saveRDS(p_median, file = paste0(folder_output_,
                                  "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                                  nomSim_,
                                  ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                  "/Chroniques/",year(date_intervalle_[1]),year(date_intervalle_[2]),"/Eng/ProbaMedianValue_",pattern_rcp_,"_",year(date_intervalle_[1]),year(date_intervalle_[2]),"_HER",HER_h_,"_Eng_1_20240227.rds"))
    
    

    
    
    
    
    
    
    
    
    ### Rcp ###
    # df_mean_rcp_ = df_mean[which(df_mean$Type == pattern_rcp_),]
    # df_mean_overwriteColors_rcp_ = df_mean_overwriteColors_[which(df_mean_overwriteColors_$Type == pattern_rcp_),]
    
    p_mean <- ggplot() +
      geom_line(data = df_mean, aes(x = Jour_annee, y = Mean_ValueLissee, group = Variable, lineend = "round"), color = "black", alpha = 0.15, lwd = 1) + # linetype = Type, 
      # geom_line(data = df_mean_overwriteColors_, aes(x = Jour_annee, y = Mean_ValueLissee, group = Variable), color = "white", alpha = 1, lwd = 3.4, lineend = "round") +
      # geom_line(data = df_mean_overwriteColors_, aes(x = Jour_annee, y = Mean_ValueLissee, group = Variable, color = Legend), alpha = 1, lwd = 2, lineend = "round") +
      
      scale_color_manual(name = "Modèles GCM-RCM",
                         labels = levels(df_mean$Legend),
                         values = levels(df_mean$Color))+
      # scale_linetype_manual(values = as.factor(c("solid","longdash")),
      #                       name = "Données climatiques d'entrée",
      #                       labels = c("Historique GCM-RCM","Safran"))+
      
      # Axes #
      scale_x_date("Date",
                   breaks = breaks_dates_,
                   labels = year_labels,
                   expand = c(0,0),
                   minor_breaks=c(seq(from=as.Date("2022-01-01"),to=as.Date("2022-12-01"),by="month"),"2022-12-31")) +
      scale_y_continuous(expand = expansion(mult = c(0, 0.05)),
                         limits = c(0,80),
                         labels = function(x) paste0(x, "%")) + # Supprimer l'espace entre l'axe des abscisses et la première valeur de y
      
      labs(title = "Moyenne des probabilités d'assecs lissées sur 5 jours",
           subtitle = paste0("Modèle hydrologique : ",str_before_first(nom_categorieSimu_,"_"),
                             " - RCP ",paste0(str_extract_all(pattern_rcp_, "[0-9]")[[1]][1],".",str_extract_all(pattern_rcp_, "[0-9]")[[1]][2]),
                             " - Période : ",year(date_intervalle_[1]),"-",year(date_intervalle_[2]),
                             " - HER : ",HER_h_),
           x = "Date",
           y = "Moyenne des probabilités d'assecs") +
      
      theme_minimal() +
      theme(plot.title = element_text(color = "#060403", size = 30, face = "bold"),
            plot.subtitle = element_text(color = "#2f2f32", size = 18),
            plot.margin = margin(20, 20, 20, 20),
            
            axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            axis.text.x = element_text(color = "#2f2f32", vjust = 0, hjust=0.5), # angle = 90
            axis.text.y = element_text(color = "#2f2f32"),
            axis.line.x = element_line(color = "#bebdbb", size = 1), # Trait des abscisses plus épais, IPCCgrey75
            axis.line.y = element_blank(), # Remove y-axis line
            axis.ticks.x=element_line(colour=c("#bebdbb",rep(c(NA, "#bebdbb"), t=12))),
            axis.ticks.length  = unit(0.35, "cm"),
            
            panel.grid.major.x = element_blank(), # Lighter horizontal grid lines
            panel.grid.minor.x = element_blank(), # Lighter horizontal grid lines
            panel.grid.major.y = element_line(color = "#dcdad9", size = 0.5), # Traits horizontaux plus clairs
            panel.grid.minor.y = element_line(color = "#dcdad9", size = 0.5), # Traits horizontaux plus clairs
            
            text = element_text(size = 20),
            
            strip.text.x = element_blank(),
            strip.background = element_blank(),
            
            legend.title = element_text(color = "#2f2f32", size = 18, face = "bold"),
            legend.text = element_text(color = "#2f2f32", size = 18)) +
      
      guides(alpha = FALSE,
             color = guide_legend(
               override.aes = list(lwd = 2.5, alpha = c(rep(1,length(levels(df_mean$Color))-1),0.15)),
               keyheight = 3.2,
               keywidth = unit(2,"cm")),
             linetype = guide_legend(keyheight = 1.8,
                                     keywidth = unit(2,"cm"),
                                     override.aes = list(linetype = c("solid", "dotdash"))))

    if (!(dir.exists(paste0(folder_output_,
                            "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                            nomSim_,
                            ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                            "/Chroniques/")))){
      dir.create(paste0(folder_output_,
                        "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        "/Chroniques/"))}
    if (!(dir.exists(paste0(folder_output_,
                            "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                            nomSim_,
                            ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                            "/Chroniques/",year(date_intervalle_[1]),year(date_intervalle_[2]),"/")))){
      dir.create(paste0(folder_output_,
                        "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        "/Chroniques/",year(date_intervalle_[1]),year(date_intervalle_[2]),"/"))}
    if (!(dir.exists(paste0(folder_output_,
                            "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                            nomSim_,
                            ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                            "/Chroniques/",year(date_intervalle_[1]),year(date_intervalle_[2]),"/Eng/")))){
      dir.create(paste0(folder_output_,
                        "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        "/Chroniques/",year(date_intervalle_[1]),year(date_intervalle_[2]),"/Eng/"))}
    
    ### Svg ###
    svg_device <- svglite(paste0(folder_output_,
                                 "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                                 nomSim_,
                                 ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                 "/Chroniques/",year(date_intervalle_[1]),year(date_intervalle_[2]),"/ProbaMeanValue_",pattern_rcp_,"_",year(date_intervalle_[1]),year(date_intervalle_[2]),"_HER",HER_h_,"_bk_1_20240227.svg"),
                          width = 15)
    print(p_mean)
    dev.off()
    saveRDS(p_mean, file = paste0(folder_output_,
                                  "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                                  nomSim_,
                                  ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                  "/Chroniques/",year(date_intervalle_[1]),year(date_intervalle_[2]),"/ProbaMeanValue_",pattern_rcp_,"_",year(date_intervalle_[1]),year(date_intervalle_[2]),"_HER",HER_h_,"_bk_1_20240227.rds"))
    
    
    ### Mean - English ###
    p_mean <- ggplot() +
      geom_line(data = df_mean, aes(x = Jour_annee, y = Mean_ValueLissee, group = Variable, lineend = "round"), color = "black", alpha = 0.15, lwd = 1) + # linetype = Type, 
      # geom_line(data = df_mean_overwriteColors_, aes(x = Jour_annee, y = Mean_ValueLissee, group = Variable), color = "white", alpha = 1, lwd = 3.4, lineend = "round") +
      # geom_line(data = df_mean_overwriteColors_, aes(x = Jour_annee, y = Mean_ValueLissee, group = Variable, color = Legend_English), alpha = 1, lwd = 2, lineend = "round") +
      
      scale_color_manual(name = "GCM-RCM Models",
                         values = levels(df_mean$Color))+
      scale_linetype_manual(values = as.factor(c("solid","longdash")),
                            name = "Input Climate Data",
                            labels = c("Historical GCM-RCM","Safran"))+
      
      # Axes #
      scale_x_date("Date",
                   breaks = breaks_dates_,
                   labels = year_labels_eng,
                   expand = c(0,0),
                   minor_breaks=c(seq(from=as.Date("2022-01-01"),to=as.Date("2022-12-01"),by="month"),"2022-12-31")) +
      scale_y_continuous(expand = expansion(mult = c(0, 0.05)),
                         limits = c(0,80),
                         labels = function(x) paste0(x, "%")) + # Remove the space between the x-axis and the first y-value
      
      labs(title = "Average smoothed probabilities of drought over 5 days",
           subtitle = paste0("Hydrological Model: ",str_before_first(nom_categorieSimu_,"_"),
                             " - RCP ",paste0(str_extract_all(pattern_rcp_, "[0-9]")[[1]][1],".",str_extract_all(pattern_rcp_, "[0-9]")[[1]][2]),
                             " - Period: ",year(date_intervalle_[1]),"-",year(date_intervalle_[2]),
                             " - HER: ",HER_h_),
           x = "Date",
           y = "Average probabilities of drought") +
      
      theme_minimal() +
      theme(plot.title = element_text(color = "#060403", size = 30, face = "bold"),
            plot.subtitle = element_text(color = "#2f2f32", size = 18),
            plot.margin = margin(20, 20, 20, 20),
            
            axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            axis.text.x = element_text(color = "#2f2f32", vjust = 0, hjust=0.5), # angle = 90
            axis.text.y = element_text(color = "#2f2f32"),
            axis.line.x = element_line(color = "#bebdbb", size = 1), # Trait des abscisses plus épais, IPCCgrey75
            axis.line.y = element_blank(), # Remove y-axis line
            axis.ticks.x=element_line(colour=c("#bebdbb",rep(c(NA, "#bebdbb"), t=12))),
            axis.ticks.length  = unit(0.35, "cm"),
            
            panel.grid.major.x = element_blank(), # Lighter horizontal grid lines
            panel.grid.minor.x = element_blank(), # Lighter horizontal grid lines
            panel.grid.major.y = element_line(color = "#dcdad9", size = 0.5), # Traits horizontaux plus clairs
            panel.grid.minor.y = element_line(color = "#dcdad9", size = 0.5), # Traits horizontaux plus clairs
            
            text = element_text(size = 20),
            
            strip.text.x = element_blank(),
            strip.background = element_blank(),
            
            legend.title = element_text(color = "#2f2f32", size = 18, face = "bold"),
            legend.text = element_text(color = "#2f2f32", size = 18)) +
      
      guides(alpha = FALSE,
             color = guide_legend(
               override.aes = list(lwd = 2.5, alpha = c(rep(1,length(levels(df_mean$Color))-1),0.15)),
               keyheight = 3.2,
               keywidth = unit(2,"cm")),
             linetype = guide_legend(keyheight = 1.8,
                                     keywidth = unit(2,"cm"),
                                     override.aes = list(linetype = c("solid", "dotdash"))))
    
    svg_device <- svglite(paste0(folder_output_,
                                 "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                                 nomSim_,
                                 ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                 "/Chroniques/",year(date_intervalle_[1]),year(date_intervalle_[2]),"/Eng/ProbaMeanValue_",pattern_rcp_,"_",year(date_intervalle_[1]),year(date_intervalle_[2]),"_HER",HER_h_,"_bk_Eng_1_20240227.svg"),
                          width = 15)
    print(p_mean)
    dev.off()
    saveRDS(p_mean, file = paste0(folder_output_,
                                  "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                                  nomSim_,
                                  ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                  "/Chroniques/",year(date_intervalle_[1]),year(date_intervalle_[2]),"/Eng/ProbaMeanValue_",pattern_rcp_,"_",year(date_intervalle_[1]),year(date_intervalle_[2]),"_HER",HER_h_,"_bk_Eng_1_20240227.rds"))
    
    
    
    
    ### Median - French ###
    p_median <- ggplot() +
      geom_line(data = df_mean, aes(x = Jour_annee, y = Median_ValueLissee, group = Variable, lineend = "round"), color = "black", alpha = 0.15, lwd = 1) + # linetype = Type, 
      # geom_line(data = df_mean_overwriteColors_, aes(x = Jour_annee, y = Median_ValueLissee, group = Variable), color = "white", alpha = 1, lwd = 3.4, lineend = "round") +
      # geom_line(data = df_mean_overwriteColors_, aes(x = Jour_annee, y = Median_ValueLissee, group = Variable, color = Legend), alpha = 1, lwd = 2, lineend = "round") +
      
      scale_color_manual(name = "Modèles GCM-RCM",
                         values = levels(df_mean$Color))+
      scale_linetype_manual(values = as.factor(c("solid","longdash")),
                            name = "Données climatiques d'entrée",
                            labels = c("Historique GCM-RCM","Safran"))+
      
      # Axes #
      scale_x_date("Date",
                   breaks = breaks_dates_,
                   labels = year_labels,
                   expand = c(0,0),
                   minor_breaks=c(seq(from=as.Date("2022-01-01"),to=as.Date("2022-12-01"),by="month"),"2022-12-31")) +
      scale_y_continuous(expand = expansion(mult = c(0, 0.05)),
                         limits = c(0,80),
                         labels = function(x) paste0(x, "%")) + # Supprimer l'espace entre l'axe des abscisses et la première valeur de y
      
      labs(title = "Médiane des probabilités d'assecs lissées sur 5 jours",
           subtitle = paste0("Modèle hydrologique : ",str_before_first(nom_categorieSimu_,"_"),
                             " - RCP ",paste0(str_extract_all(pattern_rcp_, "[0-9]")[[1]][1],".",str_extract_all(pattern_rcp_, "[0-9]")[[1]][2]),
                             " - Période : ",year(date_intervalle_[1]),"-",year(date_intervalle_[2]),
                             " - HER : ",HER_h_),
           x = "Date",
           y = "Moyenne des probabilités d'assecs") +
      
      theme_minimal() +
      theme(plot.title = element_text(color = "#060403", size = 30, face = "bold"),
            plot.subtitle = element_text(color = "#2f2f32", size = 18),
            plot.margin = margin(20, 20, 20, 20),
            
            axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            axis.text.x = element_text(color = "#2f2f32", vjust = 0, hjust=0.5), # angle = 90
            axis.text.y = element_text(color = "#2f2f32"),
            axis.line.x = element_line(color = "#bebdbb", size = 1), # Trait des abscisses plus épais, IPCCgrey75
            axis.line.y = element_blank(), # Remove y-axis line
            axis.ticks.x=element_line(colour=c("#bebdbb",rep(c(NA, "#bebdbb"), t=12))),
            axis.ticks.length  = unit(0.35, "cm"),
            
            panel.grid.major.x = element_blank(), # Lighter horizontal grid lines
            panel.grid.minor.x = element_blank(), # Lighter horizontal grid lines
            panel.grid.major.y = element_line(color = "#dcdad9", size = 0.5), # Traits horizontaux plus clairs
            panel.grid.minor.y = element_line(color = "#dcdad9", size = 0.5), # Traits horizontaux plus clairs
            
            text = element_text(size = 20),
            
            strip.text.x = element_blank(),
            strip.background = element_blank(),
            
            legend.title = element_text(color = "#2f2f32", size = 18, face = "bold"),
            legend.text = element_text(color = "#2f2f32", size = 18)) +
      
      guides(alpha = FALSE,
             color = guide_legend(
               override.aes = list(lwd = 2.5, alpha = c(rep(1,length(levels(df_mean$Color))-1),0.15)),
               keyheight = 3.2,
               keywidth = unit(2,"cm")),
             linetype = guide_legend(keyheight = 1.8,
                                     keywidth = unit(2,"cm"),
                                     override.aes = list(linetype = c("solid", "dotdash"))))
    
    svg_device <- svglite(paste0(folder_output_,
                                 "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                                 nomSim_,
                                 ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                 "/Chroniques/",year(date_intervalle_[1]),year(date_intervalle_[2]),"/ProbaMedianValue_",pattern_rcp_,"_",year(date_intervalle_[1]),year(date_intervalle_[2]),"_HER",HER_h_,"_bk_1_20240227.svg"),
                          width = 15)
    print(p_median)
    dev.off()
    saveRDS(p_median, file = paste0(folder_output_,
                                  "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                                  nomSim_,
                                  ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                  "/Chroniques/",year(date_intervalle_[1]),year(date_intervalle_[2]),"/ProbaMedianValue_",pattern_rcp_,"_",year(date_intervalle_[1]),year(date_intervalle_[2]),"_HER",HER_h_,"_bk_1_20240227.rds"))
    
    
    ### Median - English ###
    p_median <- ggplot() +
      geom_line(data = df_mean, aes(x = Jour_annee, y = Median_ValueLissee, group = Variable, lineend = "round"), color = "black", alpha = 0.15, lwd = 1) + # linetype = Type, 
      # geom_line(data = df_mean_overwriteColors_, aes(x = Jour_annee, y = Median_ValueLissee, group = Variable), color = "white", alpha = 1, lwd = 3.4, lineend = "round") +
      # geom_line(data = df_mean_overwriteColors_, aes(x = Jour_annee, y = Median_ValueLissee, group = Variable, color = Legend_English), alpha = 1, lwd = 2, lineend = "round") +
      
      scale_color_manual(name = "GCM-RCM Models",
                         values = levels(df_mean$Color))+
      scale_linetype_manual(values = as.factor(c("solid","longdash")),
                            name = "Input Climatic Data",
                            labels = c("Historical GCM-RCM","Safran"))+
      
      # Axes #
      scale_x_date("Date",
                   breaks = breaks_dates_,
                   labels = year_labels_eng,
                   expand = c(0,0),
                   minor_breaks=c(seq(from=as.Date("2022-01-01"),to=as.Date("2022-12-01"),by="month"),"2022-12-31")) +
      scale_y_continuous(expand = expansion(mult = c(0, 0.05)),
                         limits = c(0,80),
                         labels = function(x) paste0(x, "%")) + # Remove the space between the x-axis and the first y-value
      
      labs(title = "Median of smoothed 5-day exceedance probabilities",
           subtitle = paste0("Hydrological model: ",str_before_first(nom_categorieSimu_,"_"),
                             " - RCP ",paste0(str_extract_all(pattern_rcp_, "[0-9]")[[1]][1],".",str_extract_all(pattern_rcp_, "[0-9]")[[1]][2]),
                             " - Period: ",year(date_intervalle_[1]),"-",year(date_intervalle_[2]),
                             " - HER: ",HER_h_),
           x = "Date",
           y = "Mean of exceedance probabilities") +
      
      theme_minimal() +
      theme(plot.title = element_text(color = "#060403", size = 30, face = "bold"),
            plot.subtitle = element_text(color = "#2f2f32", size = 18),
            plot.margin = margin(20, 20, 20, 20),
            
            axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            axis.text.x = element_text(color = "#2f2f32", vjust = 0, hjust=0.5), # angle = 90
            axis.text.y = element_text(color = "#2f2f32"),
            axis.line.x = element_line(color = "#bebdbb", size = 1), # Trait des abscisses plus épais, IPCCgrey75
            axis.line.y = element_blank(), # Remove y-axis line
            axis.ticks.x=element_line(colour=c("#bebdbb",rep(c(NA, "#bebdbb"), t=12))),
            axis.ticks.length  = unit(0.35, "cm"),
            
            panel.grid.major.x = element_blank(), # Lighter horizontal grid lines
            panel.grid.minor.x = element_blank(), # Lighter horizontal grid lines
            panel.grid.major.y = element_line(color = "#dcdad9", size = 0.5), # Traits horizontaux plus clairs
            panel.grid.minor.y = element_line(color = "#dcdad9", size = 0.5), # Traits horizontaux plus clairs
            
            text = element_text(size = 20),
            
            strip.text.x = element_blank(),
            strip.background = element_blank(),
            
            legend.title = element_text(color = "#2f2f32", size = 18, face = "bold"),
            legend.text = element_text(color = "#2f2f32", size = 18)) +
      
      guides(alpha = FALSE,
             color = guide_legend(
               override.aes = list(lwd = 2.5, alpha = c(rep(1,length(levels(df_mean$Color))-1),0.15)),
               keyheight = 3.2,
               keywidth = unit(2,"cm")),
             linetype = guide_legend(keyheight = 1.8,
                                     keywidth = unit(2,"cm"),
                                     override.aes = list(linetype = c("solid", "dotdash"))))
    
    svg_device <- svglite(paste0(folder_output_,
                                 "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                                 nomSim_,
                                 ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                 "/Chroniques/",year(date_intervalle_[1]),year(date_intervalle_[2]),"/Eng/ProbaMedianValue_",pattern_rcp_,"_",year(date_intervalle_[1]),year(date_intervalle_[2]),"_HER",HER_h_,"_bk_Eng_1_20240227.svg"),
                          width = 15)
    print(p_median)
    dev.off()
    saveRDS(p_median, file = paste0(folder_output_,
                                  "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                                  nomSim_,
                                  ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                  "/Chroniques/",year(date_intervalle_[1]),year(date_intervalle_[2]),"/Eng/ProbaMedianValue_",pattern_rcp_,"_",year(date_intervalle_[1]),year(date_intervalle_[2]),"_HER",HER_h_,"_bk_Eng_1_20240227.rds"))
    
    
    if (!(dir.exists(paste0(folder_output_,
                            "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                            nomSim_,
                            ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                            "/Tables/")))){
      dir.create(paste0(folder_output_,
                        "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        "/Tables/"))}
    if (!(dir.exists(paste0(folder_output_,
                            "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                            nomSim_,
                            ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                            "/Tables/",year(date_intervalle_[1]),year(date_intervalle_[2]))))){
      dir.create(paste0(folder_output_,
                        "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        "/Tables/",year(date_intervalle_[1]),year(date_intervalle_[2])))}
    
    write.table(df_mean,paste0(folder_output_,
                               "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                               nomSim_,
                               ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                               "/Tables/",year(date_intervalle_[1]),year(date_intervalle_[2]),"/Table_ProbaMeanValue_",pattern_rcp_,"_",year(date_intervalle_[1]),year(date_intervalle_[2]),"_HER",HER_h_,"_1_20240214.csv"),
                sep = ";", dec = ".", row.names = F)
    
    
    
    
    
  }
}

### Parallel MPI ###
Sys.sleep(10)
mpi.finalize()
####################
