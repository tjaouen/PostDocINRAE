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

test_piezo = FALSE
ntry = 20

HER_ <- c("2", "3", "5", "12", "13", "14", "17", "21", "22", "24", "25", "27", "28", "34", "35", "36",
          "38", "40", "41", "43", "44", "50", "51", "52", "53", "55", "56", "57", "58", "59", "61", 
          "62", "63", "64", "65", "66", "67", "68", "70", "71", "73", "74", "75", "76", "77", "78",
          "79", "81", "84", "85", "86", "87", "91", "93", "94", "97", "98", "99", "101", "103", "104",
          "105", "106", "107", "108", "112", "113", "117", "118", "120", "31033039", "37054", "69096",
          "89092", "49090")
models <- c("CTRIP", "GRSD", "J2000", "ORCHIDEE", "SMASH")

for (HERc in HER_[1]){
  
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
  
  data_ini <- donnees[select,which(!colnames(donnees) %in% c("Mod_ecoulement","Moy_FreqQ"))]
  date <- donnees$Date[select]
  data=data.frame()
  date_fin=data.frame()
  
  # On retire du jeu de donn?es les lignes o? un NA est pr?sent
  compteur=0
  # test_piezo=0
  
  nbStations_Total_ <- length(unique(data_ini$Code_Onde[which(!is.na(data_ini$PRCP_J))]))
  stationsManquantes_ <- unique(data_ini$Code_Onde[which(is.na(data_ini$PRCP_J))])
  data_ini <- data_ini[which(!is.na(data_ini$PRCP_J)),]
  
  
  for (simu in grep("debit_",colnames(data_ini))[1]){
    
    model_ <- models[sapply(models, function(m) grepl(m, colnames(data_ini)[simu]))]
    scaled <- read.table(paste0(folder_output_,"/23_PredictionParSiteONDE_PremierTest/Input/Data/InputTestClassif/3_InputPourAlgoEtScaled/",model_,"/",colnames(data_ini)[simu],"/Input_test_classif_HER_",HERc,"_30_jours_fin_caract_new_meteo_FINAL_AjoutProbaAssecParHER_scaled.csv"),
                         sep = ";", dec = ".", header = T)
    years_ <- unique(year(scaled$Date))
    sites_ <- unique(scaled$Code_Onde)
    # scaled <- scaled[,!grepl("Code_Onde",colnames(scaled))]

    frame_test <- data.frame()
    
    for (year_test in years_){
      # for (year_test in list_year){
      
      # check that no datapoint is missing,
      set.seed(year_test)
      # selection_train = sample(1:nrow(scaled),round(0.8*nrow(scaled)))
      train <- as.data.frame(scaled[selection_train,])
      test <- as.data.frame(scaled[-selection_train,])
      nbStations_Train_ <- length(unique(train$Code_Onde[which(!is.na(train$PRCP_J))]))
      nbStations_Test_ <- length(unique(test$Code_Onde[which(!is.na(test$PRCP_J))]))
      train <- train[,!grepl("Code_Onde",colnames(train))]
      test <- test[,!grepl("Code_Onde",colnames(test))]
      
      
      train <- train[,!grepl("Code_Onde",colnames(train))]
      test <- test[,!grepl("Code_Onde",colnames(test))]
      
      # train <- train[,c("Assec",
      #                   "PRCP_J","PRCP_J1","PRCP_J10","PRCP_J20","PRCP_J30",
      #                   "ETP_J","ETP_J1","ETP_J10","ETP_J20","ETP_J30",
      #                   "TA_J","TA_J1","TA_J10","TA_J20","TA_J30")]#,
      #                   "P_DRYING_M",
      #                   "ProbaAssecSafranParHER_Min","ProbaAssecSafranParHER_Q25","ProbaAssecSafranParHER_Median","ProbaAssecSafranParHER_Q75","ProbaAssecSafranParHER_Max",
      #                   "Altitude","AI","Aire","Pente","Month")]
      
      fit <- randomForest(Assec ~ ., data = train[,c("Assec",
                                                     "Prcp_Jj","Prcp_J1","Prcp_JjJ10","Prcp_JjJ20","Prcp_JjJ30",
                                                     "Etp_Jj","Etp_J1","Etp_JjJ10","Etp_JjJ20","Etp_JjJ30",
                                                     "Ta_Jj","Ta_J1","Ta_JjJ10","Ta_JjJ20","Ta_JjJ30",
                                                     "FreqQ_Jj","FreqQ_JjJ5","FreqQ_JjJ10",
                                                     "PourcentZeroCalage",
                                                     "ProbaAssecSafranParHER_debit_France_CNRM.CERFACS.CNRM.CM5_rcp26_r1i1p1_CNRM.ALADIN63_v3_MF.ADAMONT.SAFRAN.1980.2011_MF.ISBA.CTRIP_day_20050801.21000731",
                                                     "Rec_Hiv",
                                                     # "Gw_Monthm",
                                                     "Ai_JanvJuil",
                                                     "Altitude",
                                                     "Aire_BV",
                                                     "Pente")], ntree=500, na.action = na.omit) #
      
      fit <- randomForest(Assec ~ ., data = train, ntree=500, na.action = na.omit) #
      yhat <- data.frame(Prection = predict(fit, test[,2:ncol(test)], type="response"))
      y_train <- predict(fit, train, type="response")
      
      assec <- length(which(test$Assec==1))
      flow <- length(which(test$Assec==0))
      
      AUC<-NULL
      
      my_roc <- roc(train$Assec,y_train)
      AUC <- my_roc$auc
      
      # Brier score
      somme1 <- 0
      brier1 <- NULL
      
      for (b in 1:length(yhat)){
        somme1=somme1+(yhat[b]-test[b,1])^2
      }
      brier1=somme1/length(yhat)
      
      seuil = 0
      compt=0
      F1.score <- NULL
      precision <- NULL
      Recall <- NULL
      ligne=0
      frame_train<-data.frame()
      
      # On recherche le seuil optimal cale sur le F.scrore dans le jeu d'entrainement
      while (seuil <= 1){
        ligne=ligne+1
        compt=0
        
        yhat_seuil = ifelse(y_train > seuil,1,ifelse(y_train<seuil,0,y_train))
        TP_train = length(which(yhat_seuil==1 & train$Assec==1))
        FP_train = length(which(yhat_seuil==1 & train$Assec==0))
        FN_train = length(which(yhat_seuil==0 & train$Assec==1))
        TN_train = length(which(yhat_seuil==0 & train$Assec==0))
        
        if ((TP_train+FP_train) > 0 & (TP_train+FN_train) > 0 & (TN_train+FP_train) > 0){
          frame_train[ligne,1]<-year_test
          frame_train[ligne,2]<-seuil
          Precision <- TP_train/(TP_train+FP_train)
          Recall <- TP_train/(TP_train+FN_train)
          frame_train[ligne,3]<-(2*Precision*Recall)/(Precision+Recall) # F1 score
          frame_train[ligne,4]<-Precision # Precision
          frame_train[ligne,5]<-Recall # Recall
          frame_train[ligne,6]<-(TP_train+TN_train)/(TP_train+FN_train+TN_train+FP_train) # Accuracy
          frame_train[ligne,7]<-TP_train/(TP_train+FN_train) # Sensi
          frame_train[ligne,8]<-TN_train/(TN_train+FP_train) # Speci
          frame_train[ligne,9]<-FP_train/(FP_train+TP_train) # FAR
          frame_train[ligne,10]<-nbStations_Total_
          frame_train[ligne,11]<-nbStations_Train_
          frame_train[ligne,12]<-nbStations_Test_
          frame_train[ligne,13]<-paste(stationsManquantes_, collapse = ", ")
        } else {
          frame_train[ligne,1]<-year_test
          frame_train[ligne,2]<-seuil
          frame_train[ligne,3:13]<-NA
        }
        seuil=seuil+0.05
      }
      colnames(frame_train) <- c("YearTest","Seuil","F1.score","Precision","Recall","Accuracy","Sensitivity","Specificity","FalseAlarm")
      
      # On reprend le seuil optimal pour recalculer les scores dans le jeu test
      seuil_opti=frame_train$Seuil[which(frame_train$F1.score==max(frame_train$F1.score, na.rm=T))]
      
      if(length(seuil_opti)==0){
        seuil_opti=0.5
      }
      
      # yhat$Prediction_bin <- as.numeric(yhat$Prection > seuil_opti[round(length(seuil_opti)/2)])
      yhat$Prediction_bin <- as.numeric(yhat$Prection > median(seuil_opti))
      
      test <- cbind(test,yhat)
      valid_ <- validationPredictions(test = test, seuil = seuil)
      frame_test[year_test,1:ncol(valid_)] <- valid_
      frame_test[year_test,ncol(valid_)+1]<-nbStations_Total_
      frame_test[year_test,ncol(valid_)+2]<-nbStations_Train_
      frame_test[year_test,ncol(valid_)+3]<-nbStations_Test_
      frame_test[year_test,ncol(valid_)+4]<-paste(stationsManquantes_, collapse = ", ")
      
      colnames(frame_test) <- c(colnames(valid_),"nbStations_Total_","nbStations_Train_","nbStations_Test_","stationsManquantes_")
      
      compt2=compt2+1
      for (q in 1:length(fit$importance)){
        coefficient[q,compt2] <- fit$importance[q]
      }
    } # boucle random test
    
    if (!dir.exists(paste0(folder_output_,"/23_PredictionParSiteONDE_PremierTest/Random_Forest/4_ResultatsLocaux_France/",model_,"/",colnames(data_ini)[simu],"/"))){
      dir.create(paste0(folder_output_,"/23_PredictionParSiteONDE_PremierTest/Random_Forest/4_ResultatsLocaux_France/",model_,"/",colnames(data_ini)[simu],"/"))
    }
    if (!dir.exists(paste0(folder_output_,"/23_PredictionParSiteONDE_PremierTest/Random_Forest/4_ResultatsLocaux_France/",model_,"/",colnames(data_ini)[simu],"/CrossValidationSafran/"))){
      dir.create(paste0(folder_output_,"/23_PredictionParSiteONDE_PremierTest/Random_Forest/4_ResultatsLocaux_France/",model_,"/",colnames(data_ini)[simu],"/CrossValidationSafran/"))
    }
    
    # save(fit,frame_test,paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/23_PredictionParSiteONDE_PremierTest/Random_Forest/4_ResultatsLocaux_France/",colnames(data_ini)[simu],"/RandomForest_moyJ",j,"_HER",HERc,"_RandomFinal.RData"))
    write.table(frame_test,paste0(folder_output_,"/23_PredictionParSiteONDE_PremierTest/Random_Forest/4_ResultatsLocaux_France/",model_,"/",colnames(data_ini)[simu],"/CrossValidationSafran/CritereSeuilsOptiTest_2012_2022_Calibration_moyJ",j,"_HER",HERc,".csv"), sep=";", row.names = F, col.names = T)
    write.table(coefficient,paste0(folder_output_,"/23_PredictionParSiteONDE_PremierTest/Random_Forest/4_ResultatsLocaux_France/",model_,"/",colnames(data_ini)[simu],"/CrossValidationSafran/Coefficient_2012_2022_Calibration_moyJ",j,"_HER_",HERc,".csv"), sep=";", row.names = F, col.names = T)
  }
  
} # boucle HER



