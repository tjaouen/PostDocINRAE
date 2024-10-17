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
# for (HERc in HER_){
  
  # print(aaaaaaa)
  # print(ENLEVER LA COLONNE CODE MASSE EAU)
  
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
  date_fin=data.frame()
  
  # On retire du jeu de donn?es les lignes o? un NA est pr?sent
  compteur=0
  # test_piezo=0
  
  nbStations_Total_ <- length(unique(data_ini$Code_Onde[which(!is.na(data_ini$PRCP_J))]))
  stationsManquantes_ <- unique(data_ini$Code_Onde[which(is.na(data_ini$PRCP_J))])
  data_ini <- data_ini[which(!is.na(data_ini$PRCP_J)),]
  
  
  # for (simu in grep("debit_",colnames(data_ini))[1]){
  for (simu in grep("debit_",colnames(data_ini))){
    
    model_ <- models[sapply(models, function(m) grepl(m, colnames(data_ini)[simu]))]
    
    # Si on garde les variables au jour
    for (i in 1:nrow(data_ini)){
      # if(!is.na(mean( as.numeric(data_ini[i,])))){
      compteur = compteur+1
      date_fin[compteur,1] = date[i]
      
      data[compteur,1] = data_ini$Bin_Assec[i]
      
      # Moyenne par jour
      data[compteur,2] = data_ini$PRCP_J[i]
      data[compteur,3] = data_ini$PRCP_J.1[i]
      data[compteur,4] = sum(data_ini[i,paste0("PRCP_J",c("",paste0(".",1:10)))]) # PRCP cumul 10 jours
      data[compteur,5] = sum(data_ini[i,paste0("PRCP_J",c("",paste0(".",1:20)))]) # PRCP cumul 20 jours
      data[compteur,6] = sum(data_ini[i,paste0("PRCP_J",c("",paste0(".",1:30)))]) # PRCP cumul 30 jours
      
      data[compteur,7] = data_ini$ETP_J[i] # ETP cumul jour j
      data[compteur,8] = data_ini$ETP_J.1[i] # ETP cumul jour j-1
      data[compteur,9] = sum(data_ini[i,paste0("ETP_J",c("",paste0(".",1:10)))]) # data_ini[i,(33:43)] ETP cumul 10 jours
      data[compteur,10] = sum(data_ini[i,paste0("ETP_J",c("",paste0(".",1:20)))]) # ETP cumul 20 jours
      data[compteur,11] = sum(data_ini[i,paste0("ETP_J",c("",paste0(".",1:30)))]) # ETP cumul 30 jours
      
      data[compteur,12] = data_ini$TA_J[i] # TA cumul jour j
      data[compteur,13] = data_ini$TA_J.1[i] # TA cumul jour j-1
      data[compteur,14] = mean(as.numeric(data_ini[i,paste0("TA_J",c("",paste0(".",1:10)))])) # TA cumul 10 jours
      data[compteur,15] = mean(as.numeric(data_ini[i,paste0("TA_J",c("",paste0(".",1:20)))])) # TA cumul 20 jours
      data[compteur,16] = mean(as.numeric(data_ini[i,paste0("TA_J",c("",paste0(".",1:30)))])) # TA cumul 30 jours
      
      data[compteur,17] = (as.numeric(data_ini$FreqQ_J[i])) # Freq au non depassement jour j
      data[compteur,18] = mean(as.numeric(data_ini[i,paste0("FreqQ_J",c("",paste0(".",1:5)))])) # Freq au non depassement moy j5
      data[compteur,19] = mean(as.numeric(data_ini[i,paste0("FreqQ_J",c("",paste0(".",1:10)))])) # Freq au non depassement moy j10
      
      if(test_piezo==TRUE){
        # data[compteur,20] = data_ini$FreqGW_J[i]
        # data[compteur,21] = mean(as.numeric(data_ini[i,paste0("FreqGW_J",c("",paste0(".",1:5)))])) # Freq au non depassement moy j5
        # data[compteur,22] = mean(as.numeric(data_ini[i,paste0("FreqGW_J",c("",paste0(".",1:10)))])) # Freq au non depassement moy j10
        data[compteur,20] = data_ini$PourcentZeroCalage[i]
        data[compteur,21] = data_ini[i,simu]
        # data[compteur,24] = min(as.numeric(data_ini[i,grepl("debit_",colnames(data_ini))]), na.rm = T)
        # data[compteur,25] = quantile(as.numeric(data_ini[i,grepl("debit_",colnames(data_ini))]), na.rm = T, probs = 0.25)
        # data[compteur,26] = median(as.numeric(data_ini[i,grepl("debit_",colnames(data_ini))]), na.rm = T)
        # data[compteur,27] = quantile(as.numeric(data_ini[i,grepl("debit_",colnames(data_ini))]), na.rm = T, probs = 0.75)
        # data[compteur,28] = max(as.numeric(data_ini[i,grepl("debit_",colnames(data_ini))]), na.rm = T)
        
        data[compteur,22] = data_ini$REC_HIV[i]
        data[compteur,23] = data_ini$GW_Mm[i]
        data[compteur,24] = data_ini$AI_JanvJuil[i]
        
        data[compteur,25] = data_ini$Altitude[i]
        data[compteur,26] = data_ini$Aire_BV[i]
        data[compteur,27] = data_ini$Pente[i]
        data[compteur,28] = data_ini$Code_Onde[i]
        data[compteur,29] = data_ini$Date[i]
      }else{
        data[compteur,20] = data_ini$PourcentZeroCalage[i]
        data[compteur,21] = data_ini[i,simu]
        # data[compteur,21] = min(as.numeric(data_ini[i,grepl("debit_",colnames(data_ini))]), na.rm = T)
        # data[compteur,22] = quantile(as.numeric(data_ini[i,grepl("debit_",colnames(data_ini))]), na.rm = T, probs = 0.25)
        # data[compteur,23] = median(as.numeric(data_ini[i,grepl("debit_",colnames(data_ini))]), na.rm = T)
        # data[compteur,24] = quantile(as.numeric(data_ini[i,grepl("debit_",colnames(data_ini))]), na.rm = T, probs = 0.75)
        # data[compteur,25] = max(as.numeric(data_ini[i,grepl("debit_",colnames(data_ini))]), na.rm = T)
        data[compteur,24] = data_ini$REC_HIV[i]
        data[compteur,23] = data_ini$AI_JanvJuil[i]
        
        data[compteur,22] = data_ini$Altitude[i]
        data[compteur,25] = data_ini$Aire_BV[i]
        data[compteur,26] = data_ini$Pente[i]
        data[compteur,27] = data_ini$Code_Onde[i]
        data[compteur,28] = data_ini$Date[i]
      }
      # }
    }
    
    if (ncol(data)>0){
      if(test_piezo==TRUE){
        # data=data[,-c(23:116)] # on supprime les variables non utilis?es
        colnames(data)=c("Assec",
                         "Prcp_Jj","Prcp_J1","Prcp_JjJ10","Prcp_JjJ20","Prcp_JjJ30",
                         "Etp_Jj","Etp_J1","Etp_JjJ10","Etp_JjJ20","Etp_JjJ30",
                         "Ta_Jj","Ta_J1","Ta_JjJ10","Ta_JjJ20","Ta_JjJ30",
                         "FreqQ_Jj","FreqQ_JjJ5","FreqQ_JjJ10",
                         
                         "PourcentZeroCalage",
                         paste0("ProbaAssecSafranParHER_",colnames(data_ini)[simu]),
                         
                         "Rec_Hiv",
                         "Gw_Monthm",
                         "Ai_JanvJuil",
                         
                         # "ProbaAssecSafranParHER_Min","ProbaAssecSafranParHER_Q25","ProbaAssecSafranParHER_Median","ProbaAssecSafranParHER_Q75","ProbaAssecSafranParHER_Max",
                         # "FreqGW_j","FreqGW_j5","FreqGW_j10",
                         "Altitude","Aire_BV","Pente","Code_Onde","Date")
      } else if (test_piezo==FALSE){
        # data=data[,-c(20:105)] # on supprime les variables non utilis?es
        colnames(data)=c("Assec",
                         "Prcp_Jj","Prcp_J1","Prcp_JjJ10","Prcp_JjJ20","Prcp_JjJ30",
                         "Etp_Jj","Etp_J1","Etp_JjJ10","Etp_JjJ20","Etp_JjJ30",
                         "Ta_Jj","Ta_J1","Ta_JjJ10","Ta_JjJ20","Ta_JjJ30",
                         "FreqQ_Jj","FreqQ_JjJ5","FreqQ_JjJ10",
                         
                         "PourcentZeroCalage",
                         paste0("ProbaAssecSafranParHER_",colnames(data_ini)[simu]),
                         
                         "Rec_Hiv",
                         "Ai_JanvJuil",
                         
                         # "ProbaAssecSafranParHER_Min","ProbaAssecSafranParHER_Q25","ProbaAssecSafranParHER_Median","ProbaAssecSafranParHER_Q75","ProbaAssecSafranParHER_Max",
                         # "FreqGW_j","FreqGW_j5","FreqGW_j10",
                         "Altitude","Aire_BV","Pente","Code_Onde","Date")
        # # "ProbaAssecSafranParHER_Min","ProbaAssecSafranParHER_Q25","ProbaAssecSafranParHER_Median","ProbaAssecSafranParHER_Q75","ProbaAssecSafranParHER_Max",
        # "Altitude","AI","REC_HIV","Aire","Pente","Code_Onde","Date")
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
      data <- data[-removedLines_,]
      
      # check that no datapoint is missing,
      print("Number of NA for each variable:")
      print(apply(data,2,function(x) sum(is.na(x))))
      
      # We therefore scale and split the data before moving on:
      maxs <- apply(data[,!grepl("Code_Onde|Date",colnames(data))], 2, max)
      mins <- apply(data[,!grepl("Code_Onde|Date",colnames(data))], 2, min)
      scaled <- as.data.frame(scale(data[,!grepl("Code_Onde|Date",colnames(data))], center = mins, scale = maxs - mins))
      print(paste0("Variables removed: ", paste(colnames(data)[which(!(apply(scaled,2,function(x) sum(is.na(x)))<nrow(scaled)))],collapse = ", ")))
      scaled <- scaled[,which(apply(scaled,2,function(x) sum(is.na(x)))<nrow(scaled))]
      scaled$Code_Onde <- data$Code_Onde
      scaled$Date <- as.Date(data$Date)
      scaled$Month <- format(as.Date(data$Date),"%B")
      
      # Si toutes les P_Drying sont ? 0
      if(test_piezo==FALSE){
        if (length(unique(data$Assec))==1){
          # if (length(unique(data[,1]))==1 & data$P_DRYING_M[1]==0){
          # scaled$P_DRYING_M[1:nrow(data)]=0
          scaled$Assec=0
        }
      } else if (test_piezo==TRUE){
        if (length(unique(data$Assec))==1){
          # if (length(unique(data[,1]))==1 & data$P_DRYING_M[1]==0){
          # scaled$P_DRYING_M[1:nrow(data)]=0
          scaled$Assec=0
        }
      }
      
      write.table(scaled,paste0(folder_output_,"/23_PredictionParSiteONDE_PremierTest/Input/Data/InputTestClassif/3_InputPourAlgoEtScaled/",model_,"/",colnames(data_ini)[simu],"/Input_test_classif_HER_",HERc,"_30_jours_fin_caract_new_meteo_FINAL_AjoutProbaAssecParHER_scaled.csv"),
                  sep = ";", dec = ".", row.names = F)
      
    } # Test si donn?es existent
  }
  
} # boucle HER



