# Classification Knn
# appliquée aux sites ONDE situés dans HER 97

rm(list=ls())

T1 <- Sys.time()

library(plyr)
library(MASS)
library(class)
library(gmodels)

# list_year=c(2012, 2013, 2014, 2015, 2016)
year_test=""
HER="97"
type = "_FINAL"
k=10

donnees <- read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_test_classif_HER_",HER,"_30_jours_fin_caract_new_meteo",type,".txt",sep=""), sep=";", header = T, quote="", stringsAsFactors=F)
select=which(donnees[,126]>=0)

hydro <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/Banque Hydro/Stations_Hydro_2016_non_influencees_sans_source_Regime_Hydro_HER2_1667_stations_group_new_RH.csv", header = T, sep = ";", row.names = NULL, quote="")

nom_data <- paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Liste_station_HER_",HER,".csv",sep="")
liste_HYDRO <- read.table(file = nom_data, header = TRUE, sep = ";",  row.names = NULL, quote="")

ligne_score=0
score=data.frame()
for (code_HYDRO in liste_HYDRO[,1]){
  
  for (j in 30){
    
    # 1. Preparing the dataset
    data_ini <- cbind(donnees[select,128],donnees[select,7:(7+j)],donnees[select,38:(38+j)],donnees[select,69:(69+j)],donnees[select,100:(100+10)],donnees[select,112:(112+10)],donnees[select,127],donnees[select,2],donnees[select,5:6],donnees[select,129],donnees[select,131])
    # colnames(data_ini)=c("Assec","PRCP_J","PRCP_J1","PRCP_J2","PRCP_J3","PRCP_J4","PRCP_J5","ETP_J","ETP_J1","ETP_J2","ETP_J3","ETP_J4","ETP_J5","TA_J","TA_J1","TA_J2","TA_J3","TA_J4","TA_J5","Freq_j","Freq_j1","Freq_j2","Freq_j3","Freq_j4","Freq_j5","ZeroCal")

    date <- donnees[select,3]
    data <- data.frame()
    date_fin <- data.frame()
    
    # On retire du jeu de données les lignes où un NA est présent
    compteur=0
    
    # Si on garde les variables au jour
    for (i in 1:nrow(data_ini)){
      if(!is.na(mean(as.numeric(data_ini[i,])))){
        compteur = compteur+1
        data = rbind(data,data_ini[i,])
        date_fin[compteur,1] = date[i]
        
        # Moyenne par jour 
        data[compteur,(4)] = sum(data_ini[i,(2:12)]) # PRCP cumul 10 jours
        data[compteur,(5)] = sum(data_ini[i,(2:22)]) # PRCP cumul 20 jours
        data[compteur,(6)] = sum(data_ini[i,(2:32)]) # PRCP cumul 30 jours
        
        data[compteur,(7)] = data_ini[i,33] # ETP cumul jour j
        data[compteur,(8)] = data_ini[i,34] # ETP cumul jour j-1
        data[compteur,(9)] = sum(data_ini[i,(33:43)]) # ETP cumul 10 jours
        data[compteur,(10)] = sum(data_ini[i,(33:53)]) # ETP cumul 20 jours
        data[compteur,(11)] = sum(data_ini[i,(33:63)]) # ETP cumul 30 jours
        
        data[compteur,(12)] = data_ini[i,64] # TA cumul jour j
        data[compteur,(13)] = data_ini[i,65] # TA cumul jour j-1
        data[compteur,(14)] = mean(as.numeric(data_ini[i,(64:74)])) # TA cumul 10 jours
        data[compteur,(15)] = mean(as.numeric(data_ini[i,(64:84)])) # TA cumul 20 jours
        data[compteur,(16)] = mean(as.numeric(data_ini[i,(64:94)])) # TA cumul 30 jours
        
        data[compteur,(17)] = (as.numeric(data_ini[i,95])) # Freq au non depassement jour j
        data[compteur,(18)] = mean(as.numeric(data_ini[i,95:100])) # Freq au non depassement moy j5
        data[compteur,(19)] = mean(as.numeric(data_ini[i,95:105])) # Freq au non depassement moy j10
        
        data[compteur,(20)] = (as.numeric(data_ini[i,106])) # Freq au non depassement jour j
        data[compteur,(21)] = mean(as.numeric(data_ini[i,106:111])) # Freq au non depassement moy j5
        data[compteur,(22)] = mean(as.numeric(data_ini[i,106:116])) # Freq au non depassement moy j10
      }
    }
    
    data=data[,-c(23:116)] # on supprime les variables non utilisées
    colnames(data)=c("Assec","PRCP_J","PRCP_J1","PRCP_J10","PRCP_J20","PRCP_J30","ETP_J","ETP_J1","ETP_J10","ETP_J20","ETP_J30","TA_J","TA_J1","TA_J10","TA_J20","TA_J30","FreqQ_j","FreqQ_j5","FreqQ_j10","FreqGW_j","FreqGW_j5","FreqGW_j10","P_DRYING_M","Altitude","AI","REC_HIV","Aire","Pente")
    
    # check that no datapoint is missing,
    apply(data,2,function(x) sum(is.na(x)))
    
    # We therefore scale and split the data before moving on:
    maxs <- apply(data, 2, max)
    mins <- apply(data, 2, min)
    scaled <- as.data.frame(scale(data, center = mins, scale = maxs - mins))
    
    selection_train = which(format(as.Date(date_fin[,1], "%d/%m/%Y"),"%Y")!=year_test)
    # selection_test = which(format(as.Date(date_fin[,1], "%d/%m/%Y"),"%Y")==as.numeric(year_test))
    
    train <- as.matrix(scaled[selection_train,])
    # train <- as.matrix(scaled)
    # test <- as.matrix(scaled[selection_test,])
    
    colnames(train)[1]=c("Assec")
    colnames(train)[ncol(train)]=c("ZeroCal")
    # colnames(test)[1]=c("Assec")
    # colnames(test)[ncol(test)]=c("ZeroCal")
    
    ligne_hydro=which(as.character(hydro[,2]) == code_HYDRO)
    
    # loading des input de la station à prédire :
    donnees_st<-read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Var_exp_station_NEW_30J/Input_Station_HYDRO_N4120010_HER2_97_FINAL.txt",sep=""), sep=";", header = T, quote="", stringsAsFactors=F)
    flow <- read.table(paste("C:/Users/aurelien.beaufort/Documents/QJHYDRO/Export_2018/",code_HYDRO,".txt",sep=""),sep=";",skip=3,fill=T,colClasses="character",quote="")
    DebSelect <- which(as.numeric(substr(flow[,3],1,4))>2011 & as.numeric(substr(flow[,3],1,4)) < 2017 & flow[,1] == "QJO" & flow[,4] != "" & as.numeric(substr(flow[,3],5,6))>4 & as.numeric(substr(flow[,3],5,6)) < 10 ) # AVEC 0
    
    x.data_st <- cbind(donnees_st[,7:(7+j)],donnees_st[,38:(38+j)],donnees_st[,69:(69+j)],donnees_st[,100:(100+10)],donnees_st[,112:(112+10)])
    
    # Calcul d'un %DRYING mensuel
    for (ligne in 1:nrow(x.data_st)){
      no_flow=which((as.numeric(flow[DebSelect,4]) <= 1) & (format(as.Date(flow[DebSelect,3],"%Y%m%d"),"%m")==format(as.Date(donnees_st[ligne,3],"%d/%m/%Y"),"%m")))
      all_flow=which((as.numeric(flow[DebSelect,4])>=0) & (format(as.Date(flow[DebSelect,3],"%Y%m%d"),"%m")==format(as.Date(donnees_st[ligne,3],"%d/%m/%Y"),"%m")))
      x.data_st[ligne,116] <- (length(no_flow)/(length(all_flow)))*100 # ZEROCAL mensuel
    }

    x.data_st[1:nrow(x.data_st),117] <- hydro$altitude[ligne_hydro] # Alti
    x.data_st[,118] <- donnees_st[,5]
    x.data_st[,119] <- donnees_st[,6]
    x.data_st[1:nrow(x.data_st),120] <- hydro$Surf_BV[ligne_hydro] # Aire
    # x.data_st[1:nrow(x.data_st),30] <- 20 # PK
    x.data_st[1:nrow(x.data_st),121] <-  hydro$Pente[ligne_hydro] # Pente
    
    # On retire du jeu de données les lignes où un NA est présent
    compteur=0
    data_st=data.frame()
    for (i in 1:nrow(x.data_st)){
      if(!is.na(mean(as.numeric(x.data_st[i,])))){
        compteur=compteur+1
        data_st=rbind(data_st,x.data_st[i,])
        
        # Moyenne par jour 
        data_st[compteur,3] = sum(x.data_st[i,(1:11)]) # PRCP cumul 10 jours
        data_st[compteur,4] = sum(x.data_st[i,(1:21)]) # PRCP cumul 20 jours
        data_st[compteur,5] = sum(x.data_st[i,(1:31)]) # PRCP cumul 30 jours
        
        data_st[compteur,6] = x.data_st[i,32] # ETP cumul jour j
        data_st[compteur,7] = x.data_st[i,33] # ETP cumul jour j-1
        data_st[compteur,8] = sum(x.data_st[i,(32:42)]) # ETP cumul 10 jours
        data_st[compteur,9] = sum(x.data_st[i,(32:52)]) # ETP cumul 20 jours
        data_st[compteur,10] = sum(x.data_st[i,(32:62)]) # ETP cumul 30 jours
        
        data_st[compteur,11] = x.data_st[i,63] # TA cumul jour j
        data_st[compteur,12] = x.data_st[i,64] # TA cumul jour j-1
        data_st[compteur,13] = mean(as.numeric(x.data_st[i,(63:73)])) # TA cumul 10 jours
        data_st[compteur,14] = mean(as.numeric(x.data_st[i,(63:83)])) # TA cumul 20 jours
        data_st[compteur,15] = mean(as.numeric(x.data_st[i,(63:93)])) # TA cumul 30 jours
        
        data_st[compteur,16] = (as.numeric(x.data_st[i,94])) # Freq au non depassement jour j
        data_st[compteur,17] = mean(as.numeric(x.data_st[i,94:99])) # Freq au non depassement moy j5
        data_st[compteur,18] = mean(as.numeric(x.data_st[i,94:104])) # Freq au non depassement moy j10
        
        data_st[compteur,19] = (as.numeric(x.data_st[i,105])) # Freq au non depassement jour j
        data_st[compteur,20] = mean(as.numeric(x.data_st[i,105:110])) # Freq au non depassement moy j5
        data_st[compteur,21] = mean(as.numeric(x.data_st[i,105:115])) # Freq au non depassement moy j10
      }
    }
    
    data_st <- data_st[,-c(22:115)] # on supprime les variables non utilisées
    
    if (nrow(data_st)>0){
      # colnames(data_st)=c("PRCP_J","PRCP_J1","PRCP_J2","PRCP_J3","PRCP_J4","PRCP_J5","ETP_J","ETP_J1","ETP_J2","ETP_J3","ETP_J4","ETP_J5","TA_J","TA_J1","TA_J2","TA_J3","TA_J4","TA_J5","Freq_j","Freq_j1","Freq_j2","Freq_j3","Freq_j4","Freq_j5","ZeroCal","Alti","AI","REC","AIRE","PK","Pente")
      colnames(data_st)=c("PRCP_J","PRCP_J1","PRCP_J10","PRCP_J20","PRCP_J30","ETP_J","ETP_J1","ETP_J10","ETP_J20","ETP_J30","TA_J","TA_J1","TA_J10","TA_J20","TA_J30","FreqQ_j","FreqQ_j5","FreqQ_j10","FreqGW_j","FreqGW_j5","FreqGW_j10","P_DRYING_M","Altitude","AI","REC_HIV","Aire","Pente")
      
      # We therefore scale and split the data before moving on :
      # maxs <- apply(data_st, 2, max)
      # mins <- apply(data_st, 2, min)
      scaled_bis <- as.data.frame(scale(data_st, center = mins[2:length(maxs)], scale = maxs[2:length(maxs)] - mins[2:length(maxs)]))
      
      scaled.prd <- as.matrix(scaled_bis)
      # scaled <- scaled[,-1]
      # colnames(scaled)[25] <- "ZeroCal"
      yhat <- knn(train = train[,2:ncol(train)], test = scaled.prd, cl = train[,1],  k=k)
      
      for (id in 1:length(yhat)){
        data_st[id,28]=yhat[id]
      }
      
      for (obs in 1:nrow(data_st)){
        data_st[obs,29]<-donnees_st[obs,4]
        data_st[obs,30]<-as.character(donnees_st[obs,3])
      }
      
      colnames(data_st)[28:30]<-c("Prediction","Q_obs","Date")

      # write.table(donnees_st,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/Knn/J5_",year_test,"/Output_Knn_",code_ONDE,"_",year_test,".csv", sep=""), sep=";", row.names = F, col.names = T)
      write.table(data_st,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/Knn/J30_moy_HYDRO_ONLY/Output_Knn_station_HYDRO_N4120010_FINAL.csv", sep=""), sep=";", row.names = F, col.names = T)
    }
    
    #-------------------------------------
    # Calcul du score sur les prédictions
    #-------------------------------------
    
    #-----------------------------------------------------------------
    # Boucle permettant de calculer le F score sur les stations hydro
    #-----------------------------------------------------------------
    TP=0
    FP=0
    FN=0
    TN=0
    seuil = 0
    compt=0
    F1.score <- NULL
    precision <- NULL
    Recall <- NULL
    
    for (id in 1:nrow(data_st)){
      if(data_st[id,28]==1 & data_st[id,29]<=1 & !is.na(data_st[id,29])){
        TP=TP+1
      } else if (data_st[id,28]==1 & data_st[id,29]>=1 & !is.na(data_st[id,29])){
        FP=FP+1
      } else if (data_st[id,28]==0 & data_st[id,29]<=1 & !is.na(data_st[id,29])){
        FN=FN+1
      } else if (data_st[id,28]==0 & data_st[id,29]>=1 & !is.na(data_st[id,29])){
        TN=TN+1
      }
    }
    
    if ((TP+FP) > 0 & (TP+FN) > 0){
      POD <- (TP/(TP+FN))*100
      FAR <- (FP/(FP+TP))*100
      precision <- TP/(TP+FP)
      Recall <- TP/(TP+FN)
      F1.score <- (2*precision*Recall)/(precision+Recall)
    } else {
      POD <- NA
      FAR <- NA
      precision <- NA
      Recall <- NA
      F1.score <- NA
    }
    
    ligne_score=ligne_score+1
    score[ligne_score,1]<-"N4120010"
    score[ligne_score,2]<-POD
    score[ligne_score,3]<-FAR
    score[ligne_score,4]<-precision
    score[ligne_score,5]<-Recall
    score[ligne_score,6]<-F1.score
    
  } # boucle j
  
  colnames(score)=c("Code_Hydro","POD","FAR","Precision","Recall","F_scrore")
  write.table(score,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/Knn/Score_Knn_station_HYDRO_HER2_97_FINAL.csv", sep=""), sep=";", row.names = F, col.names = T)
  
  T2 <- Sys.time()
  Tdiff = difftime(T2, T1)
  print(Tdiff)
  
} # boucle site ONDE
