rm(list=ls())

### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/9_PredictionParSiteONDE/Neural_Network/Prog_R/TristanSeul/4_Validation/1_ValidationPredictions_2_20240927.R")

T1 <- Sys.time()

library(plyr)
library(MASS)
library(randomForest)
library(pROC)
library(caret)
library(strex)

HER_ <- c("2", "3", "5", "12", "13", "14", "17", "21", "22", "24", "25", "27", "28", "34", "35", "36",
          "38", "40", "41", "43", "44", "50", "51", "52", "53", "55", "56", "57", "58", "59", "61", 
          "62", "63", "64", "65", "66", "67", "68", "70", "71", "73", "74", "75", "76", "77", "78",
          "79", "81", "84", "85", "86", "87", "91", "93", "94", "97", "98", "99", "101", "103", "104",
          "105", "106", "107", "108", "112", "113", "117", "118", "120", "31033039", "37054", "69096",
          "89092", "49090")

list_chroniquesProba_ <- list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProba_LearnBrut_ByHer/FDC_Projections/", pattern = "Tab_ChroniquesProba_LearnBrut_ByHer.txt", full.names = T, recursive = T)

for (HERc in HER_[1]){
  input_ <- read.table(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/23_PredictionParSiteONDE_PremierTest/Input/Data/InputTestClassif/Input_test_classif_HER_",HERc,"_30_jours_fin_caract_new_meteo_FINAL.csv"),sep=";",dec=".",header=T)
  
  # chroProba_ <- read.table(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_ChroniquesProba_LearnBrut_HER",HERc,".txt"),
  #                          sep=";",dec=".",header=T)
  # chroProba_dates_ <- chroProba_[which(chroProba_$Date %in% input_$Date & chroProba_$Type == "Safran"),]
  # 
  # result <- merge(input_, chroProba_dates_, by = "Date", all.x = TRUE)
    
  for (l in list_chroniquesProba_){
    chroProba_ <- read.table(l,sep=";",dec=".",header = T)
    colnames(chroProba_) <- gsub("X","",colnames(chroProba_))
    
    input_[[str_before_first(str_after_first(l,"FDC_Projections//"),"/Tab_ChroniquesProba_LearnBrut_ByHer.txt")]] = NA
    
    for (d in 1:nrow(input_)){
      input_[d,str_before_first(str_after_first(l,"FDC_Projections//"),"/Tab_ChroniquesProba_LearnBrut_ByHer.txt")] = ifelse(length(which(chroProba_$Date == input_$Date[d] & chroProba_$Type == "Safran"))==0,
                                                                                                                             chroProba_[which(chroProba_$Date == input_$Date[d] & chroProba_$Type == "Safran"),as.character(HERc)],NA)
    }
  }
  
  write.table(input_,
              paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/23_PredictionParSiteONDE_PremierTest/Input/Data/InputTestClassif/AjoutProbaAssecParHER_1_20240927/Input_test_classif_HER_",HERc,"_30_jours_fin_caract_new_meteo_FINAL_AjoutProbaAssecParHER.csv"),
              sep=";",dec=".",row.names = F)
}



