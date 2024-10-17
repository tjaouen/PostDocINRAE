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

# list_chroniquesProba_ <- list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProba_LearnBrut_ByHer/FDC_Projections/", pattern = "Tab_ChroniquesProba_LearnBrut_ByHer.txt", full.names = T, recursive = T)

for (HERc in HER_){
  
  print(paste0("HER: ",HERc))
  
  input_ <- read.table(paste0(folder_output_,"/23_PredictionParSiteONDE_PremierTest/Input/Data/InputTestClassif/1_InputDetail_ParAnneeEtMerge/Input_test_classif_HER_",HERc,"_30_jours_fin_caract_new_meteo_FINAL.csv"),sep=";",dec=".",header=T)
  
  list_files_ <- list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/FDC_Projections/",pattern=paste0("Tab_ChroniquesProba_LearnBrut_HER",HERc,".txt"),
                            full.names = T, recursive = T)
  list_files_ <- list_files_[which(!grepl("save|HERexclues",list_files_))]
  
  for (l in list_files_){
    chroProba_ <- read.table(l,sep=";",dec=".",header=T)
    chroProba_dates_ <- chroProba_[which(chroProba_$Type == "Safran"),which(!grepl("Jour_annee|Type|.CDFt.",colnames(chroProba_)))]
    input_ <- merge(input_, chroProba_dates_, by = "Date", all.x = TRUE)
  }

  input_ <- input_[order(input_$Code_Onde,input_$Date),]
  write.table(input_,
              paste0(folder_output_,"/23_PredictionParSiteONDE_PremierTest/Input/Data/InputTestClassif/2_AjoutProbaAssecParHER/Input_test_classif_HER_",HERc,"_30_jours_fin_caract_new_meteo_FINAL_AjoutProbaAssecParHER.csv"),
              sep=";",dec=".",row.names = F)
}



