source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_J2000/PathsProgram/PathProgram_1_20230206.R")
source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_J2000/1_Parameters_MESO/0_SimulationParameters_AvecCC_2_20230227_MESO.R")
source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_Commun/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")

suppressMessages(library(doParallel))
suppressMessages(library(tidyverse))
suppressMessages(library(svglite))
suppressMessages(library(ggplot2))
suppressMessages(library(strex))

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

list_files_chroniquesProba_ <- list.files(paste0(folder_input_,"Tab_ChroniquesProba_LearnBrut_ByHer/",
                                                 ifelse(obsSim_param_=="",nom_GCM_param_,
                                                        paste0("FDC_",obsSim_param_,
                                                               ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                               ifelse(nom_categorieSimu_param_=="","",str_before_first(nom_categorieSimu_param_,"/")),"/"))),
                                          recursive = T,
                                          full.names = T)

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
      # for (l in 1:5){
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
    
    # tab_allModels_2070_2100_ = tab_allModels_[which(year(tab_allModels_$Date) >= 2070 & year(tab_allModels_$Date) <= 2100),] # Tout GRSD finit le 31-07-2099
    tab_allModels_2070_2100_ = tab_allModels_[which(year(tab_allModels_$Date) >= 2070 & year(tab_allModels_$Date) <= 2098),]
    
    
    # Melt (convertir) le dataframe pour le rendre plus facile à utiliser dans ggplot2
    df_melted <- tab_allModels_2070_2100_ %>%
      select(-Jour_annee) %>%
      pivot_longer(cols = -c(Date, Type), names_to = "Variable", values_to = "Value")
    
    # Calculer la moyenne par jour de l'année
    df_mean <- df_melted %>%
      mutate(Jour_annee = format(Date, "%m-%d")) %>%
      group_by(Type, Variable, Jour_annee) %>%
      # summarise(Mean_Value = mean(ValueLissee),
      #           Median_Value = median(ValueLissee))
      summarise(Mean_Value = mean(Value),
                Median_Value = median(Value),
                .groups = 'drop')
    
    df_mean <- df_mean %>%
      group_by(Type,Variable) %>%
      mutate(Mean_ValueLissee = (lag(Mean_Value, 2) + lag(Mean_Value, 1) + Mean_Value + lead(Mean_Value, 1) + lead(Mean_Value, 2)) / 5) %>%
      mutate(Median_ValueLissee = (lag(Median_Value, 2) + lag(Median_Value, 1) + Median_Value + lead(Median_Value, 1) + lead(Median_Value, 2)) / 5)
    
    ### Axe x ###
    first_days <- df_mean[which(substr(df_mean$Jour_annee,3,5) == "-01"),]
    first_days$Date <- as.Date(paste0("2022-",first_days$Jour_annee), format = "%Y-%m-%d")
    
    df_mean <- df_mean %>%
      mutate(Color = case_when(
        grepl("CNRM-CERFACS.*CNRM-ALADIN63_v3_LSCE-IPSL_CDFt", Variable) ~ "black",
        grepl("CNRM-CERFACS.*CNRM-ALADIN63_v3_MF-ADAMONT", Variable) ~ "#E5E840",
        grepl("CNRM-CERFACS.*MOHC-HadREM3-GA7-05_v3_LSCE-IPSL_CDFt", Variable) ~ "black",
        grepl("CNRM-CERFACS.*MOHC-HadREM3-GA7-05_v3_MF-ADAMONT", Variable) ~ "black",
        grepl("ICHEC-EC-EARTH.*KNMI-RACMO22E_v2_LSCE-IPSL_CDFt", Variable) ~ "black",
        grepl("ICHEC-EC-EARTH.*KNMI-RACMO22E_v2_MF-ADAMONT", Variable) ~ "black",
        grepl("ICHEC-EC-EARTH.*MOHC-HadREM3-GA7-05_v2_LSCE-IPSL_CDFt", Variable) ~ "black",
        grepl("ICHEC-EC-EARTH.*MOHC-HadREM3-GA7-05_v2_MF-ADAMONT", Variable) ~ "#E2A138",
        grepl("ICHEC-EC-EARTH.*SMHI-RCA4_v2_LSCE-IPSL_CDFt", Variable) ~ "black",
        grepl("ICHEC-EC-EARTH.*SMHI-RCA4_v2_MF-ADAMONT", Variable) ~ "black",
        grepl("IPSL-IPSL-CM5A-MR.*DMI-HIRHAM5_v2_LSCE-IPSL_CDFt", Variable) ~ "black",
        grepl("IPSL-IPSL-CM5A-MR.*DMI-HIRHAM5_v2_MF-ADAMONT", Variable) ~ "black",
        grepl("IPSL-IPSL-CM5A-MR.*SMHI-RCA4_v2_LSCE-IPSL_CDFt", Variable) ~ "black",
        grepl("IPSL-IPSL-CM5A-MR.*SMHI-RCA4_v2_MF-ADAMONT", Variable) ~ "black",
        grepl("MOHC-HadGEM2-ES.*CLMcom-CCLM4-8-17_v2_LSCE-IPSL_CDFt", Variable) ~ "black",
        grepl("MOHC-HadGEM2-ES.*CLMcom-CCLM4-8-17_v2_MF-ADAMONT", Variable) ~ "#70194E",
        grepl("MOHC-HadGEM2-ES.*CNRM-ALADIN63_v2_LSCE-IPSL_CDFt", Variable) ~ "black",
        grepl("MOHC-HadGEM2-ES.*CNRM-ALADIN63_v2_MF-ADAMONT", Variable) ~ "#447C57",
        grepl("MOHC-HadGEM2-ES.*ICTP-RegCM4-6_v2_LSCE-IPSL_CDFt", Variable) ~ "black",
        grepl("MOHC-HadGEM2-ES.*ICTP-RegCM4-6_v2_MF-ADAMONT", Variable) ~ "black",
        grepl("MOHC-HadGEM2-ES.*MOHC-HadREM3-GA7-05_v2_LSCE-IPSL_CDFt", Variable) ~ "black",
        grepl("MOHC-HadGEM2-ES.*MOHC-HadREM3-GA7-05_v2_MF-ADAMONT", Variable) ~ "black",
        grepl("MPI-M-MPI-ESM-LR.*CLMcom-CCLM4-8-17_v2_LSCE-IPSL_CDFt", Variable) ~ "black",
        grepl("MPI-M-MPI-ESM-LR.*CLMcom-CCLM4-8-17_v2_MF-ADAMONT", Variable) ~ "black",
        grepl("MPI-M-MPI-ESM-LR.*ICTP-RegCM4-6_v2_LSCE-IPSL_CDFt", Variable) ~ "black",
        grepl("MPI-M-MPI-ESM-LR.*ICTP-RegCM4-6_v2_MF-ADAMONT", Variable) ~ "black",
        grepl("MPI-M-MPI-ESM-LR.*MPI-CSC-REMO2009_v2_LSCE-IPSL_CDFt", Variable) ~ "black",
        grepl("MPI-M-MPI-ESM-LR.*MPI-CSC-REMO2009_v2_MF-ADAMONT", Variable) ~ "black",
        grepl("NCC-NorESM1-M.*DMI-HIRHAM5_v4_LSCE-IPSL_CDFt", Variable) ~ "black",
        grepl("NCC-NorESM1-M.*DMI-HIRHAM5_v4_MF-ADAMONT", Variable) ~ "black",
        grepl("NCC-NorESM1-M.*GERICS-REMO2015_v2_LSCE-IPSL_CDFt", Variable) ~ "black",
        grepl("NCC-NorESM1-M.*GERICS-REMO2015_v2_MF-ADAMONT", Variable) ~ "black",
        grepl("NCC-NorESM1-M.*IPSL-WRF381P_v2_LSCE-IPSL_CDFt", Variable) ~ "black",
        grepl("NCC-NorESM1-M.*IPSL-WRF381P_v2_MF-ADAMONT", Variable) ~ "black"))
    
    df_mean <- df_mean %>%
      mutate(Alpha = case_when(
        grepl("CNRM-CERFACS.*CNRM-ALADIN63_v3_LSCE-IPSL_CDFt", Variable) ~ 0.65,
        grepl("CNRM-CERFACS.*CNRM-ALADIN63_v3_MF-ADAMONT", Variable) ~ 1,
        grepl("CNRM-CERFACS.*MOHC-HadREM3-GA7-05_v3_LSCE-IPSL_CDFt", Variable) ~ 0.65,
        grepl("CNRM-CERFACS.*MOHC-HadREM3-GA7-05_v3_MF-ADAMONT", Variable) ~ 0.65,
        grepl("ICHEC-EC-EARTH.*KNMI-RACMO22E_v2_LSCE-IPSL_CDFt", Variable) ~ 0.65,
        grepl("ICHEC-EC-EARTH.*KNMI-RACMO22E_v2_MF-ADAMONT", Variable) ~ 0.65,
        grepl("ICHEC-EC-EARTH.*MOHC-HadREM3-GA7-05_v2_LSCE-IPSL_CDFt", Variable) ~ 0.65,
        grepl("ICHEC-EC-EARTH.*MOHC-HadREM3-GA7-05_v2_MF-ADAMONT", Variable) ~ 1,
        grepl("ICHEC-EC-EARTH.*SMHI-RCA4_v2_LSCE-IPSL_CDFt", Variable) ~ 0.65,
        grepl("ICHEC-EC-EARTH.*SMHI-RCA4_v2_MF-ADAMONT", Variable) ~ 0.65,
        grepl("IPSL-IPSL-CM5A-MR.*DMI-HIRHAM5_v2_LSCE-IPSL_CDFt", Variable) ~ 0.65,
        grepl("IPSL-IPSL-CM5A-MR.*DMI-HIRHAM5_v2_MF-ADAMONT", Variable) ~ 0.65,
        grepl("IPSL-IPSL-CM5A-MR.*SMHI-RCA4_v2_LSCE-IPSL_CDFt", Variable) ~ 0.65,
        grepl("IPSL-IPSL-CM5A-MR.*SMHI-RCA4_v2_MF-ADAMONT", Variable) ~ 0.65,
        grepl("MOHC-HadGEM2-ES.*CLMcom-CCLM4-8-17_v2_LSCE-IPSL_CDFt", Variable) ~ 0.65,
        grepl("MOHC-HadGEM2-ES.*CLMcom-CCLM4-8-17_v2_MF-ADAMONT", Variable) ~ 1,
        grepl("MOHC-HadGEM2-ES.*CNRM-ALADIN63_v2_LSCE-IPSL_CDFt", Variable) ~ 0.65,
        grepl("MOHC-HadGEM2-ES.*CNRM-ALADIN63_v2_MF-ADAMONT", Variable) ~ 1,
        grepl("MOHC-HadGEM2-ES.*ICTP-RegCM4-6_v2_LSCE-IPSL_CDFt", Variable) ~ 0.65,
        grepl("MOHC-HadGEM2-ES.*ICTP-RegCM4-6_v2_MF-ADAMONT", Variable) ~ 0.65,
        grepl("MOHC-HadGEM2-ES.*MOHC-HadREM3-GA7-05_v2_LSCE-IPSL_CDFt", Variable) ~ 0.65,
        grepl("MOHC-HadGEM2-ES.*MOHC-HadREM3-GA7-05_v2_MF-ADAMONT", Variable) ~ 0.65,
        grepl("MPI-M-MPI-ESM-LR.*CLMcom-CCLM4-8-17_v2_LSCE-IPSL_CDFt", Variable) ~ 0.65,
        grepl("MPI-M-MPI-ESM-LR.*CLMcom-CCLM4-8-17_v2_MF-ADAMONT", Variable) ~ 0.65,
        grepl("MPI-M-MPI-ESM-LR.*ICTP-RegCM4-6_v2_LSCE-IPSL_CDFt", Variable) ~ 0.65,
        grepl("MPI-M-MPI-ESM-LR.*ICTP-RegCM4-6_v2_MF-ADAMONT", Variable) ~ 0.65,
        grepl("MPI-M-MPI-ESM-LR.*MPI-CSC-REMO2009_v2_LSCE-IPSL_CDFt", Variable) ~ 0.65,
        grepl("MPI-M-MPI-ESM-LR.*MPI-CSC-REMO2009_v2_MF-ADAMONT", Variable) ~ 0.65,
        grepl("NCC-NorESM1-M.*DMI-HIRHAM5_v4_LSCE-IPSL_CDFt", Variable) ~ 0.65,
        grepl("NCC-NorESM1-M.*DMI-HIRHAM5_v4_MF-ADAMONT", Variable) ~ 0.65,
        grepl("NCC-NorESM1-M.*GERICS-REMO2015_v2_LSCE-IPSL_CDFt", Variable) ~ 0.65,
        grepl("NCC-NorESM1-M.*GERICS-REMO2015_v2_MF-ADAMONT", Variable) ~ 0.65,
        grepl("NCC-NorESM1-M.*IPSL-WRF381P_v2_LSCE-IPSL_CDFt", Variable) ~ 0.65,
        grepl("NCC-NorESM1-M.*IPSL-WRF381P_v2_MF-ADAMONT", Variable) ~ 0.65))
    
    df_mean <- df_mean %>%
      mutate(Legend = case_when(
        grepl("CNRM-CERFACS.*CNRM-ALADIN63_v3_LSCE-IPSL_CDFt", Variable) ~ "Autres modèles",
        grepl("CNRM-CERFACS.*CNRM-ALADIN63_v3_MF-ADAMONT", Variable) ~ "Modéré en réchauffement et\nen changement de précipitations",
        grepl("CNRM-CERFACS.*MOHC-HadREM3-GA7-05_v3_LSCE-IPSL_CDFt", Variable) ~ "Autres modèles",
        grepl("CNRM-CERFACS.*MOHC-HadREM3-GA7-05_v3_MF-ADAMONT", Variable) ~ "Autres modèles",
        grepl("ICHEC-EC-EARTH.*KNMI-RACMO22E_v2_LSCE-IPSL_CDFt", Variable) ~ "Autres modèles",
        grepl("ICHEC-EC-EARTH.*KNMI-RACMO22E_v2_MF-ADAMONT", Variable) ~ "Autres modèles",
        grepl("ICHEC-EC-EARTH.*MOHC-HadREM3-GA7-05_v2_LSCE-IPSL_CDFt", Variable) ~ "Autres modèles",
        grepl("ICHEC-EC-EARTH.*MOHC-HadREM3-GA7-05_v2_MF-ADAMONT", Variable) ~ "Sec toute l'année,\nrecharge moindre en hiver",
        grepl("ICHEC-EC-EARTH.*SMHI-RCA4_v2_LSCE-IPSL_CDFt", Variable) ~ "Autres modèles",
        grepl("ICHEC-EC-EARTH.*SMHI-RCA4_v2_MF-ADAMONT", Variable) ~ "Autres modèles",
        grepl("IPSL-IPSL-CM5A-MR.*DMI-HIRHAM5_v2_LSCE-IPSL_CDFt", Variable) ~ "Autres modèles",
        grepl("IPSL-IPSL-CM5A-MR.*DMI-HIRHAM5_v2_MF-ADAMONT", Variable) ~ "Autres modèles",
        grepl("IPSL-IPSL-CM5A-MR.*SMHI-RCA4_v2_LSCE-IPSL_CDFt", Variable) ~ "Autres modèles",
        grepl("IPSL-IPSL-CM5A-MR.*SMHI-RCA4_v2_MF-ADAMONT", Variable) ~ "Autres modèles",
        grepl("MOHC-HadGEM2-ES.*CLMcom-CCLM4-8-17_v2_LSCE-IPSL_CDFt", Variable) ~ "Autres modèles",
        grepl("MOHC-HadGEM2-ES.*CLMcom-CCLM4-8-17_v2_MF-ADAMONT", Variable) ~ "Fort réchauffement et\nfort assèchement en été",
        grepl("MOHC-HadGEM2-ES.*CNRM-ALADIN63_v2_LSCE-IPSL_CDFt", Variable) ~ "Autres modèles",
        grepl("MOHC-HadGEM2-ES.*CNRM-ALADIN63_v2_MF-ADAMONT", Variable) ~ "Chaud et humide\nà toutes les saisons",
        grepl("MOHC-HadGEM2-ES.*ICTP-RegCM4-6_v2_LSCE-IPSL_CDFt", Variable) ~ "Autres modèles",
        grepl("MOHC-HadGEM2-ES.*ICTP-RegCM4-6_v2_MF-ADAMONT", Variable) ~ "Autres modèles",
        grepl("MOHC-HadGEM2-ES.*MOHC-HadREM3-GA7-05_v2_LSCE-IPSL_CDFt", Variable) ~ "Autres modèles",
        grepl("MOHC-HadGEM2-ES.*MOHC-HadREM3-GA7-05_v2_MF-ADAMONT", Variable) ~ "Autres modèles",
        grepl("MPI-M-MPI-ESM-LR.*CLMcom-CCLM4-8-17_v2_LSCE-IPSL_CDFt", Variable) ~ "Autres modèles",
        grepl("MPI-M-MPI-ESM-LR.*CLMcom-CCLM4-8-17_v2_MF-ADAMONT", Variable) ~ "Autres modèles",
        grepl("MPI-M-MPI-ESM-LR.*ICTP-RegCM4-6_v2_LSCE-IPSL_CDFt", Variable) ~ "Autres modèles",
        grepl("MPI-M-MPI-ESM-LR.*ICTP-RegCM4-6_v2_MF-ADAMONT", Variable) ~ "Autres modèles",
        grepl("MPI-M-MPI-ESM-LR.*MPI-CSC-REMO2009_v2_LSCE-IPSL_CDFt", Variable) ~ "Autres modèles",
        grepl("MPI-M-MPI-ESM-LR.*MPI-CSC-REMO2009_v2_MF-ADAMONT", Variable) ~ "Autres modèles",
        grepl("NCC-NorESM1-M.*DMI-HIRHAM5_v4_LSCE-IPSL_CDFt", Variable) ~ "Autres modèles",
        grepl("NCC-NorESM1-M.*DMI-HIRHAM5_v4_MF-ADAMONT", Variable) ~ "Autres modèles",
        grepl("NCC-NorESM1-M.*GERICS-REMO2015_v2_LSCE-IPSL_CDFt", Variable) ~ "Autres modèles",
        grepl("NCC-NorESM1-M.*GERICS-REMO2015_v2_MF-ADAMONT", Variable) ~ "Autres modèles",
        grepl("NCC-NorESM1-M.*IPSL-WRF381P_v2_LSCE-IPSL_CDFt", Variable) ~ "Autres modèles",
        grepl("NCC-NorESM1-M.*IPSL-WRF381P_v2_MF-ADAMONT", Variable) ~ "Autres modèles"))
    
    ### Legende ###
    variables_a_afficher <- unique(df_mean$Legend[which(df_mean$Alpha == 1)])
    df_mean$AfficherDansLegende <- ifelse(df_mean$Legend %in% variables_a_afficher, as.character(df_mean$Legend), "")
    
    
    custom_colors <- data.frame(leg_ = c(unique(df_mean$Legend[which(df_mean$Color == "#E5E840")]),
                                         unique(df_mean$Legend[which(df_mean$Color == "#E2A138")]),
                                         unique(df_mean$Legend[which(df_mean$Color == "#70194E")]),
                                         unique(df_mean$Legend[which(df_mean$Color == "#447C57")]),
                                         ""),
                                col_ = c("#E5E840","#E2A138","#70194E","#447C57","black"))
    desired_order <- c(unique(df_mean$Legend[which(df_mean$Color == "#E5E840")]),
                       unique(df_mean$Legend[which(df_mean$Color == "#E2A138")]),
                       unique(df_mean$Legend[which(df_mean$Color == "#70194E")]),
                       unique(df_mean$Legend[which(df_mean$Color == "#447C57")]),
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
    # df_mean$AfficherDansLegende <- factor(df_mean$AfficherDansLegende, levels = desired_order)
    df_mean$Legend <- factor(df_mean$Legend, levels = desired_order)
    
    df_mean$Jour_annee <- as.Date(paste0("2022-",df_mean$Jour_annee))
    
    df_mean_overwriteColors <- df_mean[which(df_mean$Legend %in% c("Modéré en réchauffement et\nen changement de précipitations",
                                                                   "Sec toute l'année,\nrecharge moindre en hiver",
                                                                   "Fort réchauffement et\nfort assèchement en été",
                                                                   "Chaud et humide\nà toutes les saisons")),]
    
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
    
    # Créer le graphique en utilisant la nouvelle variable pour la légende
    # x11()
    # ggplot(df_mean, aes(x = Jour_annee, y = Median_ValueLissee, group = Variable, color = Variable)) +
    # ggplot(df_mean, aes(x = Jour_annee, y = Median_ValueLissee, group = Variable, color = AfficherDansLegende)) +
    p_mean <- ggplot() +
      geom_line(data = df_mean, aes(x = Jour_annee, y = Mean_ValueLissee, group = Variable, color = Legend, alpha = Alpha), lwd = 2) +
      scale_color_manual(values = c("#E5E840", "#E2A138", "#70194E", "#447C57","black"),
                         labels = desired_order)+
      
      geom_line(data = df_mean_overwriteColors, aes(x = Jour_annee, y = Mean_ValueLissee, group = Variable, color = Legend), alpha = 1, lwd = 2) +
      
      geom_point(data = first_days, aes(x = Date, y = Mean_ValueLissee), size = 0, alpha = 0) +
      scale_x_date(date_breaks = "1 month", date_labels = "%b") +
      # scale_color_manual(values = custom_color)+#, na.translate = FALSE,
      # labels = Legend) +
      # geom_point(data = first_days, aes(x = Date, y = 0), size = 0, alpha = 0) +
      labs(title = paste0("Moyenne des probabilités d'assecs lissées sur 5 jours (2070-2098) - HER ",HER_h_),
           x = "Date",
           y = "Moyenne des probabilités d'assecs") +
      theme_minimal() +
      ylim(0,85) +
      theme(strip.text.x = element_blank(),
            strip.background = element_blank(),
            axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
            legend.title = element_blank(),  # Supprimer le titre de la légende Alpha
            text = element_text(size = 20))+#,
      guides(alpha = FALSE,
             color = guide_legend(override.aes = list(lwd=2.5, alpha = c(1,1,1,1,0.65)),
                                  keyheight = 2.8))
    
    
    # svg_device <- svglite(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_20231221/GRSD_20231128/ChroniquesBrutes_rcp85/ModA_FaFa/ProbaMeanValue_rcp85_HER",HER_h_,"_1_20240205.svg"),
    svg_device <- svglite(paste0(folder_output_,
                                 "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                                 nomSim_,
                                 ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                 "/Chroniques/ProbaMeanValue_rcp85_20702100_HER",HER_h_,"_1_20240214.svg"),
                          width = 15)
    print(p_mean)
    dev.off()
    
    
    p_median <- ggplot() +
      geom_line(data = df_mean, aes(x = Jour_annee, y = Median_ValueLissee, group = Variable, color = Legend, alpha = Alpha), lwd = 2) +
      scale_color_manual(values = c("#E5E840", "#E2A138", "#70194E", "#447C57","black"),
                         labels = desired_order)+
      
      geom_line(data = df_mean_overwriteColors, aes(x = Jour_annee, y = Median_ValueLissee, group = Variable, color = Legend), alpha = 1, lwd = 2) +
      
      geom_point(data = first_days, aes(x = Date, y = Median_ValueLissee), size = 0, alpha = 0) +
      scale_x_date(date_breaks = "1 month", date_labels = "%b") +
      # scale_color_manual(values = custom_color)+#, na.translate = FALSE,
      # labels = Legend) +
      # geom_point(data = first_days, aes(x = Date, y = 0), size = 0, alpha = 0) +
      labs(title = paste0("Médianne des probabilités d'assecs lissées sur 5 jours (2070-2098) - HER ",HER_h_),
           x = "Date",
           y = "Médianne des probabilités d'assecs") +
      theme_minimal() +
      ylim(0,85) +
      theme(strip.text.x = element_blank(),
            strip.background = element_blank(),
            axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
            legend.title = element_blank(),  # Supprimer le titre de la légende Alpha
            text = element_text(size = 20))+#,
      guides(alpha = FALSE,
             color = guide_legend(override.aes = list(lwd=2.5, alpha = c(1,1,1,1,0.65)),
                                  keyheight = 2.8))
    
    # svg_device <- svglite(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_20231221/GRSD_20231128/ChroniquesBrutes_rcp85/ModA_FaFa/ProbaMedianValue20702100_rcp85_HER",HER_h_,"_1_20240205.svg"),
    # svg_device <- svglite(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/Chroniques/ProbaMedianValue20702100_rcp85_HER",HER_h_,"_1_20240214.svg"),
    #                       width = 15)
    svg_device <- svglite(paste0(folder_output_,
                                 "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                                 nomSim_,
                                 ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                 "/Chroniques/ProbaMedianValue_rcp85_20702100_HER",HER_h_,"_1_20240214.svg"),
                          width = 15)
    print(p_median)
    dev.off()
    
    # write.table(df_mean, paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/Tables/Table_ProbaMeanValue20702100_rcp85_HER",HER_h_,"_1_20240214.csv"),
    #             sep = ";", dec = ".", row.names = F)
    
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
    
    write.table(df_mean,paste0(folder_output_,
                               "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                               nomSim_,
                               ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                               "/Tables/Table_ProbaMeanValue_rcp85_20702100_HER",HER_h_,"_1_20240214.csv"),
                sep = ";", dec = ".", row.names = F)
    
    
  }
}

### Parallel MPI ###
Sys.sleep(10)
mpi.finalize()
####################
