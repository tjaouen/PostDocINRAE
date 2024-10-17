# Classification Random Forest
# appliqu?e aux sites ONDE situ?s dans HER 97

rm(list=ls())

### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/9_PredictionParSiteONDE/Neural_Network/Prog_R/TristanSeul/4_Validation/1_ValidationPredictions_2_20240927.R")

folder_output_ <- folder_output_param_

T1 <- Sys.time()

library(plyr)
library(MASS)
library(randomForest)
library(pROC)
library(caret)
library(strex)
library(lubridate)

# list_year=c(2012, 2013, 2014, 2015, 2016)
list_year=c(2012:2022)
# list_param=c(27)
# list_ntree=c(500)

# list_ntree=c(10000)
# list_ntry=c(5,10,15,20,25,30)

# HER2 <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/HER/Hydroecoregion2_group.csv",sep=";",header=T,quote="")

test_piezo = TRUE
ntry = 20

HER_ <- c("2", "3", "5", "12", "13", "14", "17", "21", "22", "24", "25", "27", "28", "34", "35", "36",
          "38", "40", "41", "43", "44", "50", "51", "52", "53", "55", "56", "57", "58", "59", "61", 
          "62", "63", "64", "65", "66", "67", "68", "70", "71", "73", "74", "75", "76", "77", "78",
          "79", "81", "84", "85", "86", "87", "91", "93", "94", "97", "98", "99", "101", "103", "104",
          "105", "106", "107", "108", "112", "113", "117", "118", "120", "31033039", "37054", "69096",
          "89092", "49090")
models <- c("CTRIP", "GRSD", "J2000", "ORCHIDEE", "SMASH")

for (HERc in HER_){

  print(paste0("HER: ",HERc))
  
  list_filesInput_ <- list.files(path = paste0(folder_output_,"/23_PredictionParSiteONDE_PremierTest/Input/Data/InputTestClassif/2_AjoutProbaAssecParHER/"),
                                 pattern = "_30_jours_fin_caract_new_meteo_FINAL_AjoutProbaAssecParHER.csv", full.names = T)
  list_filesInput_ <- list_filesInput_[grepl(paste0("HER_",HERc,"_"),list_filesInput_)]
  # donnees <- read.table(list_filesInput_[1], sep = ";", dec = ".", header = T)
  donnees <- read.table(list_filesInput_, sep = ";", dec = ".", header = T)
  
  print(paste0("NA: ",length(which(is.na(donnees$PourcentZeroCalage)))))
  print(paste0("PourcentZeroCalage<0: ",length(which(!(donnees$PourcentZeroCalage>=0)))))
  select=which(donnees$PourcentZeroCalage>=0) # [,126]
  
  j=30
  param=27
  compt2=0
  critere_full=data.frame()
  coefficient=data.frame()
  
  data_ini <- donnees[select,which(!colnames(donnees) %in% c("Mod_ecoulement","Moy_FreqQ","CodeMasseEau"))]
  date <- donnees$Date[select]
  data=data.frame()

  # On retire du jeu de donn?es les lignes o? un NA est pr?sent
  nbStations_Total_ <- length(unique(data_ini$Code_Onde[which(!is.na(data_ini$PRCP_J))]))
  stationsManquantes_ <- unique(data_ini$Code_Onde[which(is.na(data_ini$PRCP_J))])
  data_ini <- data_ini[which(!is.na(data_ini$PRCP_J)),]
  
  data_ini$Prcp_Jj <- data_ini$PRCP_J
  data_ini$Prcp_J1 <- data_ini$PRCP_J.1
  data_ini$Prcp_JjJ10 <- rowSums(data_ini[,paste0("PRCP_J",c("",paste0(".",1:10)))])
  data_ini$Prcp_JjJ20 <- rowSums(data_ini[,paste0("PRCP_J",c("",paste0(".",1:20)))])
  data_ini$Prcp_JjJ30 <- rowSums(data_ini[,paste0("PRCP_J",c("",paste0(".",1:30)))])
  data_ini$Etp_Jj <- data_ini$ETP_J
  data_ini$Etp_J1 <- data_ini$ETP_J.1
  data_ini$Etp_JjJ10 <- rowSums(data_ini[,paste0("ETP_J",c("",paste0(".",1:10)))])
  data_ini$Etp_JjJ20 <- rowSums(data_ini[,paste0("ETP_J",c("",paste0(".",1:20)))])
  data_ini$Etp_JjJ30 <- rowSums(data_ini[,paste0("ETP_J",c("",paste0(".",1:30)))])
  data_ini$Ta_Jj <- data_ini$TA_J
  data_ini$Ta_J1 <- data_ini$TA_J.1
  data_ini$Ta_JjJ10 <- rowMeans(data_ini[,paste0("TA_J",c("",paste0(".",1:10)))])
  data_ini$Ta_JjJ20 <- rowMeans(data_ini[,paste0("TA_J",c("",paste0(".",1:20)))])
  data_ini$Ta_JjJ30 <- rowMeans(data_ini[,paste0("TA_J",c("",paste0(".",1:30)))])
  data_ini$FreqQ_Jj <- data_ini$FreqQ_J
  data_ini$FreqQ_JjJ5 <- rowMeans(data_ini[,paste0("FreqQ_J",c("",paste0(".",1:5)))])
  data_ini$FreqQ_JjJ10 <- rowMeans(data_ini[,paste0("FreqQ_J",c("",paste0(".",1:10)))])
  
  # for (simu in grep("debit_",colnames(data_ini))[1]){
  for (simu in grep("debit_",colnames(data_ini))){
  # for (simu in grep("J2000",colnames(data_ini))){
    
    model_ <- models[sapply(models, function(m) grepl(m, colnames(data_ini)[simu]))]
    
    if (ncol(data_ini)>0){
      if(test_piezo==TRUE){
        data <- data_ini[,c("Code_Onde","Date",
                            "Altitude","Aire_BV","Pente",
                            "Bin_Assec",
                            "PourcentZeroCalage",
                            colnames(data_ini)[simu],
                            "REC_HIV","GW_Mm","AI_JanvJuil",
                            "Prcp_Jj","Prcp_J1","Prcp_JjJ10","Prcp_JjJ20","Prcp_JjJ30",
                            "Etp_Jj","Etp_J1","Etp_JjJ10","Etp_JjJ20","Etp_JjJ30",
                            "Ta_Jj","Ta_J1","Ta_JjJ10","Ta_JjJ20","Ta_JjJ30",
                            "FreqQ_Jj","FreqQ_JjJ5","FreqQ_JjJ10")]
        colnames(data) <- c("Code_Onde","Date",
                            "Altitude","Aire_BV","Pente",
                            "Assec",
                            "PourcentZeroCalage",
                            paste0("ProbaAssecSafranParHER_",colnames(data_ini)[simu]),
                            "Rec_Hiv","Gw_Monthm","Ai_JanvJuil",
                            "Prcp_Jj","Prcp_J1","Prcp_JjJ10","Prcp_JjJ20","Prcp_JjJ30",
                            "Etp_Jj","Etp_J1","Etp_JjJ10","Etp_JjJ20","Etp_JjJ30",
                            "Ta_Jj","Ta_J1","Ta_JjJ10","Ta_JjJ20","Ta_JjJ30",
                            "FreqQ_Jj","FreqQ_JjJ5","FreqQ_JjJ10")
      } else if (test_piezo==FALSE){
        data <- data_ini[,c("Code_Onde","Date",
                            "Altitude","Aire_BV","Pente",
                            "Bin_Assec",
                            "PourcentZeroCalage",
                            colnames(data_ini)[simu],
                            "REC_HIV","AI_JanvJuil",
                            "Prcp_Jj","Prcp_J1","Prcp_JjJ10","Prcp_JjJ20","Prcp_JjJ30",
                            "Etp_Jj","Etp_J1","Etp_JjJ10","Etp_JjJ20","Etp_JjJ30",
                            "Ta_Jj","Ta_J1","Ta_JjJ10","Ta_JjJ20","Ta_JjJ30",
                            "FreqQ_Jj","FreqQ_JjJ5","FreqQ_JjJ10")]
        colnames(data) <- c("Code_Onde","Date",
                            "Altitude","Aire_BV","Pente",
                            "Assec",
                            "PourcentZeroCalage",
                            paste0("ProbaAssecSafranParHER_",colnames(data_ini)[simu]),
                            "Rec_Hiv","Ai_JanvJuil",
                            "Prcp_Jj","Prcp_J1","Prcp_JjJ10","Prcp_JjJ20","Prcp_JjJ30",
                            "Etp_Jj","Etp_J1","Etp_JjJ10","Etp_JjJ20","Etp_JjJ30",
                            "Ta_Jj","Ta_J1","Ta_JjJ10","Ta_JjJ20","Ta_JjJ30",
                            "FreqQ_Jj","FreqQ_JjJ5","FreqQ_JjJ10")
      }
      
      if (!dir.exists(paste0(folder_output_,"/23_PredictionParSiteONDE_PremierTest/Input/Data/InputTestClassif/3_InputPourAlgoEtScaled/",model_,"/"))){
        dir.create(paste0(folder_output_,"/23_PredictionParSiteONDE_PremierTest/Input/Data/InputTestClassif/3_InputPourAlgoEtScaled/",model_,"/"))
      }
      if (!dir.exists(paste0(folder_output_,"/23_PredictionParSiteONDE_PremierTest/Input/Data/InputTestClassif/3_InputPourAlgoEtScaled/",model_,"/",colnames(data_ini)[simu],"/"))){
        dir.create(paste0(folder_output_,"/23_PredictionParSiteONDE_PremierTest/Input/Data/InputTestClassif/3_InputPourAlgoEtScaled/",model_,"/",colnames(data_ini)[simu],"/"))
      }
      write.table(data,paste0(folder_output_,"/23_PredictionParSiteONDE_PremierTest/Input/Data/InputTestClassif/3_InputPourAlgoEtScaled/",model_,"/",colnames(data_ini)[simu],"/Input_test_classif_HER_",HERc,"_30_jours_fin_caract_new_meteo_FINAL_AjoutProbaAssecParHER.csv"),
                  sep = ";", dec = ".", row.names = F)
      
      removedLines_ <- which(is.na(data[paste0("ProbaAssecSafranParHER_",colnames(data_ini)[simu])]))
      print(paste0("Lines removed: ",paste(unique(paste0(year(data$Date[removedLines_]),"_",month(data$Date[removedLines_]))),collapse = ", ")))
      if (length(removedLines_)>0){
        data <- data[-removedLines_,]
      }
      
      # check that no datapoint is missing,
      print("Number of NA for each variable:")
      print(apply(data,2,function(x) sum(is.na(x))))
      
      # We therefore scale and split the data before moving on:
      maxs <- apply(data[,!grepl("Code_Onde|Date",colnames(data))], 2, max)
      mins <- apply(data[,!grepl("Code_Onde|Date",colnames(data))], 2, min)
      scaled <- as.data.frame(scale(data[,!grepl("Code_Onde|Date",colnames(data))], center = mins, scale = maxs - mins))
      print(paste0("Variables removed: ", paste(colnames(data)[which(!(apply(scaled,2,function(x) sum(is.na(x)))<nrow(scaled)))],collapse = ", ")))
      scaled <- scaled[,which(apply(scaled,2,function(x) sum(is.na(x)))<nrow(scaled))]
      scaled$Month <- format(as.Date(data$Date),"%B")
      scaled$Code_Onde <- data$Code_Onde
      scaled$Date <- as.Date(data$Date)

      scaled <- scaled[,c(ncol(scaled)-1,ncol(scaled),1:(ncol(scaled)-2))]

      # Si toutes les P_Drying sont ? 0
      if (length(unique(data$Assec))==1){
        scaled$Assec=0
      }

      write.table(scaled,paste0(folder_output_,"/23_PredictionParSiteONDE_PremierTest/Input/Data/InputTestClassif/3_InputPourAlgoEtScaled/",model_,"/",colnames(data_ini)[simu],"/Input_test_classif_HER_",HERc,"_30_jours_fin_caract_new_meteo_FINAL_AjoutProbaAssecParHER_scaled.csv"),
                  sep = ";", dec = ".", row.names = F)
      
    } # Test si donn?es existent
  }
  
} # boucle HER



