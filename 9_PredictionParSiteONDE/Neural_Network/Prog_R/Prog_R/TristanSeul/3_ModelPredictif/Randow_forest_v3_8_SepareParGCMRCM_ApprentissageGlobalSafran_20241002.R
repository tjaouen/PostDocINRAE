# Classification Random Forest
# appliqu?e aux sites ONDE situ?s dans HER 97

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

for (HERc in HER_[1]){

  # print(aaaaaaa)
  # print(ENLEVER LA COLONNE CODE MASSE EAU)
  
  print(paste0("HER: ",HERc))
  
  # list_filesInput_ <- list.files(path = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/23_PredictionParSiteONDE_PremierTest/Input/Data/InputTestClassif/AjoutProbaAssecParHER_1_20240927/",
  list_filesInput_ <- list.files(path = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/23_PredictionParSiteONDE_PremierTest/Input/Data/InputTestClassif/2_AjoutProbaAssecParHER/",
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
  
  
  for (simu in grep("debit_",colnames(data_ini))[1]){
    
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
      
      # check that no datapoint is missing,
      print("Number of NA for each variable:")
      print(apply(data,2,function(x) sum(is.na(x))))
      
      # We therefore scale and split the data before moving on:
      maxs <- apply(data[,!grepl("Code_Onde|Date",colnames(data))], 2, max)
      mins <- apply(data[,!grepl("Code_Onde|Date",colnames(data))], 2, min)
      scaled <- as.data.frame(scale(data[,!grepl("Code_Onde|Date",colnames(data))], center = mins, scale = maxs - mins))
      scaled <- scaled[,which(apply(scaled,2,function(x) sum(is.na(x)))<nrow(scaled))]
      scaled$Code_Onde <- data$Code_Onde
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
      frame_test <- data.frame()
      
      # for (year_test in 1:ntry){
        # for (year_test in list_year){
        
      # check that no datapoint is missing,
      # set.seed(year_test)
      # selection_train = sample(1:nrow(scaled),round(0.8*nrow(scaled)))
      train <- as.data.frame(scaled)
      # train <- as.data.frame(scaled[selection_train,])
      # test <- as.data.frame(scaled[-selection_train,])
      nbStations_Train_ <- length(unique(train$Code_Onde[which(!is.na(train$PRCP_J))]))
      # nbStations_Test_ <- length(unique(test$Code_Onde[which(!is.na(test$PRCP_J))]))
      train <- train[,!grepl("Code_Onde",colnames(train))]
      # test <- test[,!grepl("Code_Onde",colnames(test))]
      
      # train <- train[,c("Assec",
      #                   "PRCP_J","PRCP_J1","PRCP_J10","PRCP_J20","PRCP_J30",
      #                   "ETP_J","ETP_J1","ETP_J10","ETP_J20","ETP_J30",
      #                   "TA_J","TA_J1","TA_J10","TA_J20","TA_J30")]#,
      #                   "P_DRYING_M",
      #                   "ProbaAssecSafranParHER_Min","ProbaAssecSafranParHER_Q25","ProbaAssecSafranParHER_Median","ProbaAssecSafranParHER_Q75","ProbaAssecSafranParHER_Max",
      #                   "Altitude","AI","Aire","Pente","Month")]
      
      fit <- randomForest(Assec ~ ., data = train, ntree=500, na.action = na.omit) #
      # yhat <- data.frame(Prection = predict(fit, test[,2:ncol(test)], type="response"))
      y_train <- predict(fit, train, type="response")
      
      # assec <- length(which(test$Assec==1))
      # flow <- length(which(test$Assec==0))
      
      AUC<-NULL
      
      my_roc <- roc(train$Assec,y_train)
      AUC <- my_roc$auc
      
      # Brier score
      somme1 <- 0
      brier1 <- NULL
      
      # for (b in 1:length(yhat)){
      #   somme1=somme1+(yhat[b]-test[b,1])^2
      # }
      # brier1=somme1/length(yhat)
      
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
        y <- train$Assec
        y_pred <- yhat_seuil
        TP_train = length(which(yhat_seuil==1 & train$Assec==1))
        FP_train = length(which(yhat_seuil==1 & train$Assec==0))
        FN_train = length(which(yhat_seuil==0 & train$Assec==1))
        TN_train = length(which(yhat_seuil==0 & train$Assec==0))
        
        if ((TP_train+FP_train) > 0 & (TP_train+FN_train) > 0 & (TN_train+FP_train) > 0){
          frame_train[ligne,1]<-"CalibrationAllSafran"
          frame_train[ligne,2]<-seuil
          frame_train[ligne,3]<-TP_train
          frame_train[ligne,4]<-FP_train
          frame_train[ligne,5]<-TN_train
          frame_train[ligne,6]<-FN_train
          Precision <- TP_train/(TP_train+FP_train)
          Recall <- TP_train/(TP_train+FN_train)
          frame_train[ligne,7]<-round((2*Precision*Recall)/(Precision+Recall),4) # F1 score
          frame_train[ligne,8]<-Precision # Precision
          frame_train[ligne,9]<-Recall # Recall
          frame_train[ligne,10]<-(TP_train+TN_train)/(TP_train+FN_train+TN_train+FP_train) # Accuracy
          frame_train[ligne,11]<-round(my_roc$auc,4)
          frame_train[ligne,12]<-TP_train/(TP_train+FN_train) # Sensi
          frame_train[ligne,13]<-TN_train/(TN_train+FP_train) # Speci
          frame_train[ligne,14]<-FP_train/(FP_train+TP_train) # FAR
          frame_train[ligne,15] = length(which(train$Assec>0)) #Nombre d'observation superieures a 0
          frame_train[ligne,16] = round(mean(y),4) #Moyenne observee
          frame_train[ligne,17] = round(mean(y_pred)/100,4)
          
          moy_obs = mean(y*100)
          # moy_obs = sum(onde$NbOutputONDEAssecs)/sum(onde$NbOutputONDE)
          frame_train[ligne,18] = round(1 - sum((y_pred-(y*100))**2) / sum((moy_obs-(y*100))**2),4) # NASH = 1 - SCE_residuelle / SCE_Aexpliquer = SCE_expliquee par modele
          r = cor(y*100,y_pred) #Coeff de correlation entre donnees observees et donnees predites
          beta = mean(y_pred)/mean(y*100)
          alpha = mean(y*100)/mean(y_pred)*sd(y_pred)/sd(y*100)
          frame_train[ligne,19] = round(1-sqrt((1-r)**2+(1-beta)**2+(1-alpha)**2),4) #KGE
          frame_train[ligne,20] = round(sd(y)/mean(y),4) #CV => Indicateur litigieux car mean(y) n'est pas pondere au nombre de donnees ONDE utilisees pour obtenir y
          
          frame_train[ligne,21] <- round(sqrt(1/length(y) * sum((y*100-y_pred*100)^2)),4) # RMSE
          frame_train[ligne,22] <- round(sum(y_pred*100-y*100)/length(y),4) # Biais
          frame_train[ligne,23] <- round(sum(abs(y_pred*100-y*100))/length(y),4) # EMA
          
          frame_train[ligne,24]<-nbStations_Total_
          frame_train[ligne,25]<-nbStations_Train_
          frame_train[ligne,26]<-paste(stationsManquantes_, collapse = ", ")
        } else {
          frame_train[ligne,1]<-"CalibrationAllSafran"
          frame_train[ligne,2]<-seuil
          frame_train[ligne,3:26]<-NA
        }
        seuil=seuil+0.05
      }
      colnames(frame_train) <- c("YearTest","Seuil",
                                 "TP","FP","TN","FN",
                                 "F1.score","Precision","Recall",
                                 "Accuracy","AUC","Sensitivity","Specificity","FalseAlarm",
                                 "NbAssecONDE_Test",
                                 "P_assecs_HER_MoyenMois_Apredire_Test",
                                 "P_assecs_HER_MoyenMois_Predite_Test",
                                 "NASH_Test","KGE_Test","CV_Test",
                                 "RMSE_Test","Biais_Test","EMA_Test",
                                 "nbStations_Total_","nbStations_Train_","stationsManquantes_")

      # On reprend le seuil optimal pour recalculer les scores dans le jeu test
      seuil_opti=frame_train$Seuil[which(frame_train$F1.score==max(frame_train$F1.score, na.rm=T))]
      
      if(length(seuil_opti)==0){
        seuil_opti=0.5
      }
      
      # # yhat$Prediction_bin <- as.numeric(yhat$Prection > seuil_opti[round(length(seuil_opti)/2)])
      # yhat$Prediction_bin <- as.numeric(yhat$Prection > median(seuil_opti))
      # 
      # # test <- cbind(test,yhat)
      # # valid_ <- validationPredictions(test = test, seuil = seuil)
      # frame_test[year_test,1:ncol(valid_)] <- valid_
      # frame_test[year_test,ncol(valid_)+1]<-nbStations_Total_
      # frame_test[year_test,ncol(valid_)+2]<-nbStations_Train_
      # # frame_test[year_test,ncol(valid_)+3]<-nbStations_Test_
      # frame_test[year_test,ncol(valid_)+4]<-paste(stationsManquantes_, collapse = ", ")
      # 
      # colnames(frame_test) <- c(colnames(valid_),
      #                           "nbStations_Total_",
      #                           "nbStations_Train_",
      #                           # "nbStations_Test_",
      #                           "stationsManquantes_")
      
      compt2=compt2+1
      for (q in 1:length(fit$importance)){
        coefficient[q,compt2] <- fit$importance[q]
      }
      # } # boucle random test
      
      if (!dir.exists(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/23_PredictionParSiteONDE_PremierTest/Random_Forest/4_ResultatsLocaux_France/",colnames(data_ini)[simu],"/"))){
        dir.create(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/23_PredictionParSiteONDE_PremierTest/Random_Forest/4_ResultatsLocaux_France/",colnames(data_ini)[simu],"/"))
      }
      if (!dir.exists(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/23_PredictionParSiteONDE_PremierTest/Random_Forest/4_ResultatsLocaux_France/",colnames(data_ini)[simu],"/TrainSafranGlobal/"))){
        dir.create(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/23_PredictionParSiteONDE_PremierTest/Random_Forest/4_ResultatsLocaux_France/",colnames(data_ini)[simu],"/TrainSafranGlobal/"))
      }
      
      save(fit,file=paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/23_PredictionParSiteONDE_PremierTest/Random_Forest/4_ResultatsLocaux_France/",colnames(data_ini)[simu],"/TrainSafranGlobal/RandomForest_moyJ",j,"_HER",HERc,"_RandomFinal.RData"))
      write.table(frame_train,paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/23_PredictionParSiteONDE_PremierTest/Random_Forest/4_ResultatsLocaux_France/",colnames(data_ini)[simu],"/TrainSafranGlobal/CritereSeuilsOptiTrainSafranGlobal_2012_2022_Calibration_moyJ",j,"_HER",HERc,".csv"), sep=";", row.names = F, col.names = T)
      write.table(coefficient,paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/23_PredictionParSiteONDE_PremierTest/Random_Forest/4_ResultatsLocaux_France/",colnames(data_ini)[simu],"/TrainSafranGlobal/Coefficient_2012_2022_Calibration_moyJ",j,"_HER_",HERc,".csv"), sep=";", row.names = F, col.names = T)
      
    } # Test si donn?es existent
  }
  
} # boucle HER



