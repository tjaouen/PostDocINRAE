# Classification Ridge / LASSO / Elastic net
# appliqu?e aux sites ONDE situ?s dans HER 97

# rm(list=ls())

source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
#source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/4_RunsEtudeFrance_20230417/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/5_RunsEtudeFrance_ParSiteOnde_20230525/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")


T1<-Sys.time()
library(plyr)
library(MASS)
library(randomForest)
library(pROC)
library(lubridate)

list_param=c(27)
list_year=c("")

# HER = c(38,85,97,105,58)
# HER = c(38,85,97,105,58)
type = "_FINAL"

# nom_data <- paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Liste_station_4_HER_SELECT_NEW.csv",sep="")
# liste_HYDRO <- read.table(file = nom_data, header = TRUE, sep = ";",  row.names = NULL, quote="")

nom_data <- paste("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/9_PredictionParSiteONDE/Neural_Network/Data/Liste_station_HER_FRANCE_2.csv",sep="")
liste_HYDRO <- read.table(file = nom_data, header = TRUE, sep = ";", dec = ".")
liste_HYDRO$Code_short <- liste_HYDRO$CODE
# nom_data <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidAnSecInterHum_2012_2022_20230919/Stations_HYDRO_KGESUp0.00_DispSup-1.csv"
# liste_HYDRO <- read.table(file = nom_data, header = TRUE, sep = ";", dec = ".")

# HER=unique(liste_HYDRO[,2])
HER=HER_param_

# hydro <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/Banque Hydro/Stations_Hydro_2016_non_influencees_sans_source_Regime_Hydro_HER2_1667_stations_group_new_RH.csv", header = T, sep = ";", row.names = NULL, quote="")
hydro <- read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsObserves/DisponibiliteDonneesHydroDates/TablesDisponibiliteDonneesHydro/DisponibiliteTemporelle_VersionTJ_20230412/4_DisponibiliteDonnees_ProportionsHER_DatesEtMergeHER2hybrides/HER2_VersionES_2_20230417/4_Merge_DisponibiliteHydro_CorrespondanceHER2hybridesv2_Prop_4_20230427.csv", header = T, sep = ";", dec = ".")
# hydro = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsObserves/DisponibiliteDonneesHydroDates/TablesDisponibiliteDonneesHydro/DisponibiliteTemporelle_VersionTJ_20230412/4_DisponibiliteDonnees_ProportionsHER_DatesEtMergeHER2hybrides/HER2_VersionES_2_20230417/4_Merge_DisponibiliteHydro_CorrespondanceHER2hybridesv2_Prop_4_20230427.csv", sep = ";", dec = ".", na.strings = NA, header = T)
# hydro = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidAnSecInterHum_2012_2022_20230919/Stations_HYDRO_KGESUp0.00_DispSup-1.csv", sep = ";", dec = ".", na.strings = NA, header = T)
# dim(hydro) #1008 130
j=30

# list_year=c(2012, 2013, 2014, 2015, 2016)

for (HERc in HER){
  # if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_Matrice/Input_test_classif_HER_",HERc,"_30_jours_fin_caract_new_meteo_FINAL.txt",sep=""))==T){
  if (file.exists(paste("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/9_PredictionParSiteONDE/Neural_Network/Data/Input_Matrice/Input_test_classif_HER_",HERc,"_30_jours_fin_caract_new_meteo_FINAL.txt",sep=""))){
    # donnees <- read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_Matrice/Input_test_classif_HER_",HERc,"_30_jours_fin_caract_new_meteo_FINAL.txt",sep=""), sep=";", header = T, quote="", stringsAsFactors=F)
    donnees <- read.table(paste("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/9_PredictionParSiteONDE/Neural_Network/Data/Input_Matrice/Input_test_classif_HER_",HERc,"_30_jours_fin_caract_new_meteo_FINAL.txt",sep=""), sep=";", header = T, quote="", stringsAsFactors=F)
    colnames_modifies <- gsub("X.", "Pct_", colnames(donnees))
    colnames_modifies <- gsub("\\.", "", colnames_modifies)
    colnames(donnees) <- colnames_modifies
    # select <- which(donnees[,126]>=0)
    select <- which(donnees$Pct_ZeroCalage>=0)
    
    critere_full=data.frame()
    output<-data.frame()
    
    # 1. Preparing the dataset
    # 27 param
    # data_ini <- cbind(donnees[select,127],donnees[select,7:(7+j)],donnees[select,38:(38+j)],donnees[select,69:(69+j)],donnees[select,100:(100+10)],donnees[select,112:(112+10)],donnees[select,126],donnees[select,2],donnees[select,5:6],donnees[select,128],donnees[select,130])
    data_ini <- donnees[select,c("Bin_Assec", #"P_DryingMens",
                                 "PRCP_J",paste0("PRCP_J",1:30), #7
                                 "ETP_J",paste0("ETP_J",1:30), #38
                                 "TA_J",paste0("TA_J",1:30), #69
                                 "FreqQ_J",paste0("FreqQ_J",1:10), #100
                                 "FreqGW_J",paste0("FreqGW_J",1:10), #112
                                 "Pct_ZeroCalage",
                                 "Altitude",
                                 "AI","REC_HIV",
                                 "Aire_BV", #"Bin_Assec",
                                 "Pente")] # "PK_amont")]
    date <- donnees[select,3]
    data=data.frame()
    date_fin=data.frame()
    
    # On retire du jeu de donn?es les lignes o? un NA est pr?sent
    compteur=0
    test_piezo=0
    
    # if(length(which(is.na(data_ini[,112])))==nrow(data_ini)){
    if(length(which(is.na(data_ini$FreqGW_J6)))==nrow(data_ini)){
      # data_ini=cbind(donnees[select,127],donnees[select,7:(7+j)],donnees[select,38:(38+j)],donnees[select,69:(69+j)],donnees[select,100:(100+10)],donnees[select,126],donnees[select,2],donnees[select,5:6],donnees[select,128],donnees[select,130])
      data_ini <- donnees[select,c("Bin_Assec", #"P_DryingMens",
                                   "PRCP_J",paste0("PRCP_J",1:30), #7
                                   "ETP_J",paste0("ETP_J",1:30), #38
                                   "TA_J",paste0("TA_J",1:30), #69
                                   "FreqQ_J",paste0("FreqQ_J",1:10), #100
                                   "Pct_ZeroCalage",
                                   "Altitude",
                                   "AI","REC_HIV",
                                   "Aire_BV", #"Bin_Assec",
                                   "Pente")] # "PK_amont")]
      test_piezo=1
    }
    
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
        
        if(test_piezo==0){
          data[compteur,(20)] = (as.numeric(data_ini[i,106])) # Freq au non depassement jour j
          data[compteur,(21)] = mean(as.numeric(data_ini[i,106:111])) # Freq au non depassement moy j5
          data[compteur,(22)] = mean(as.numeric(data_ini[i,106:116])) # Freq au non depassement moy j10
        }
      }
    }
    
    if (ncol(data)>0){
      if(test_piezo==0){
        data=data[,-c(23:116)] # on supprime les variables non utilis?es
        colnames(data)=c("Assec",
                         "PRCP_J","PRCP_J1","PRCP_J10","PRCP_J20","PRCP_J30",
                         "ETP_J","ETP_J1","ETP_J10","ETP_J20","ETP_J30",
                         "TA_J","TA_J1","TA_J10","TA_J20","TA_J30",
                         "FreqQ_j","FreqQ_j5","FreqQ_j10",
                         "FreqGW_j","FreqGW_j5","FreqGW_j10",
                         "P_DRYING_M",
                         "Altitude",
                         "AI",
                         "REC_HIV",
                         "Aire",
                         "Pente")
      } else if (test_piezo==1){
        data=data[,-c(20:105)] # on supprime les variables non utilisees
        colnames(data)=c("Assec",
                         "PRCP_J","PRCP_J1","PRCP_J10","PRCP_J20","PRCP_J30",
                         "ETP_J","ETP_J1","ETP_J10","ETP_J20","ETP_J30",
                         "TA_J","TA_J1","TA_J10","TA_J20","TA_J30",
                         "FreqQ_j","FreqQ_j5","FreqQ_j10",
                         "P_DRYING_M",
                         "Altitude",
                         "AI",
                         "REC_HIV",
                         "Aire",
                         "Pente")
      }
      
      # We therefore scale and split the data before moving on:
      maxs <- apply(data, 2, max)
      mins <- apply(data, 2, min)
      scaled <- as.data.frame(scale(data, center = mins, scale = maxs - mins))
      
      # Si toutes les obs sont de m?me statut et de 0
      if (length(unique(data[,1]))==1 & data[1,1]==0){
        scaled[1:nrow(data),1]=0 # pour ?viter de g?n?rer des NaN dans "scaled"
      }
      
      # Si toutes les P_Drying sont ? 0
      if(test_piezo==0){
        if (length(unique(data[,1]))==1 & data[1,23]==0){
          scaled[1:nrow(data),23]=0
        }
      } else if (test_piezo==1){
        if (length(unique(data[,1]))==1 & data[1,20]==0){
          scaled[1:nrow(data),20]=0
        }
      }
      
      set.seed(12)
      index <- sample(1:nrow(data),round(1*nrow(data)))
      train <- as.matrix(scaled[index,])
      
      fit <- randomForest(Assec ~ ., data = train, na.action = na.omit)
      yhat10 <- predict(fit, train[,2:ncol(train)], type = "response")
      
      # on d?termine le seuil optimal pour ce calage
      seuil <- 0
      F1.score <- NULL
      precision <- NULL
      Recall <- NULL
      
      # Pr?dictions ? partir du r?seau ANN entrain?
      ligne=0
      frame_test <- data.frame()
      
      # On recherche le seuil optimal cal? sur le F.scrore
      while (seuil <= 1){
        ligne=ligne+1
        compt=0
        yhat10_seuil=vector()
        TP=0
        FP=0
        FN=0
        TN=0
        
        for (id in 1:length(yhat10)){
          
          if (yhat10[id] > seuil){
            yhat10_seuil[id]=1
            compt=compt+1
          } else if (yhat10[id] < seuil){
            yhat10_seuil[id]=0
            compt=compt+1
          } else {
            yhat10_seuil[id]=yhat10[id]
          }
          
          if(yhat10_seuil[id]==1 & train[id,1]==1){
            TP=TP+1
          } else if (yhat10_seuil[id]==1 & train[id,1]==0){
            FP=FP+1
          } else if (yhat10_seuil[id]==0 & train[id,1]==1){
            FN=FN+1
          } else if (yhat10_seuil[id]==0 & train[id,1]==0){
            TN=TN+1
          }
        }
        seuil=seuil+0.05
        
        if ((TP+FP) > 0 & (TP+FN) > 0){
          precision <- TP/(TP+FP)
          Recall <- TP/(TP+FN)
          F1.score <- (2*precision*Recall)/(precision+Recall)
        } else {
          F1.score <- NA
        }
        
        frame_test[ligne,1]<-seuil
        frame_test[ligne,2]<-F1.score
      }
      
      seuil_opti = frame_test[which(frame_test[,2]==max(frame_test[,2], na.rm=T)),1]
      score=data.frame()
      ligne_score=0
      
      for (ind in 1:nrow(liste_HYDRO)){ #
        
        # code_HYDRO=liste_HYDRO[ind,1]
        code_HYDRO=liste_HYDRO$Code_short[ind]
        
        # if(liste_HYDRO[which(liste_HYDRO$Code_short == code_HYDRO), paste0("eco",sprintf("%03d", HERc))] > 0){
        if(liste_HYDRO[ind,2]==HERc){
          # if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Var_exp_station_NEW_30J_STATION_HYDRO_NEW/2012_2016/Input_Station_HYDRO_",code_HYDRO,"_HER2_",HERc,".txt",sep=""))){
          # if (file.exists(paste("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/9_PredictionParSiteONDE/Neural_Network/Data/Var_exp_station_NEW_30J_STATION_HYDRO_NEW/2012_2016/Input_Station_HYDRO_",substr(code_HYDRO,1,nchar(code_HYDRO)-2),"_HER2_",HERc,".txt",sep=""))){
          if (file.exists(paste("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/9_PredictionParSiteONDE/Neural_Network/Data/Var_exp_station_NEW_30J_STATION_HYDRO_NEW/2012_2016/Input_Station_HYDRO_",substr(code_HYDRO,1,8),"_HER2_",HERc,".txt",sep=""))){
            
            # if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/QJHYDRO/Export_2018/",code_HYDRO,".txt",sep=""))){
            # if (file.exists(paste("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsObserves/DebitsRdata_StationsHydro_20230412/4_Reunion_TxtRCMetHorsRMC/",code_HYDRO,"01_HYDRO_QJM.txt",sep=""))){
            pattern <- paste0("^", code_HYDRO, "[0-9]{2}_HYDRO_QJM\\.txt$")
            fichiers <- list.files(path = paste("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsObserves/DebitsRdata_StationsHydro_20230412/4_Reunion_TxtRCMetHorsRMC/"),
                                   pattern = pattern,
                                   full.names = T)
            if (length(fichiers) > 0){
              
              # loading des input de la station ? pr?dire :
              # flow <- read.table(paste("C:/Users/aurelien.beaufort/Documents/QJHYDRO/Export_2018/",code_HYDRO,".txt",sep=""),sep=";",skip=3,fill=T,colClasses="character",quote="")
              flow <- read.table(fichiers,sep=";",skip=3,fill=T,colClasses="character",quote="", header = T)
              flow$Date <- as.Date(flow$Date, format = "%Y%m%d")
              flow$Year <- year(flow$Date)
              flow$Month <- month(flow$Date)
              DebSelect <- which(flow$Year>2011 & 
                                   flow$Year < 2017 & 
                                   flow[,4] != "" &
                                   flow$Month>4 &
                                   flow$Month<10) # AVEC 0
              
              # loading des input de la station ? pr?dire:
              # donnees_st<-read.table(paste("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/9_PredictionParSiteONDE/Neural_Network/Data/Var_exp_station_NEW_30J_STATION_HYDRO_NEW/2012_2016/Input_Station_HYDRO_",code_HYDRO,"_HER2_",HERc,".txt",sep=""), sep=";", header = T, quote="", stringsAsFactors=F)
              donnees_st <- donnees
              
              if(test_piezo==0){
                # x.data_st <- cbind(donnees_st[,7:(7+j)],donnees_st[,38:(38+j)],donnees_st[,69:(69+j)],donnees_st[,100:(100+10)],donnees_st[,112:(112+10)])
                x.data_st <- donnees[,c("PRCP_J",paste0("PRCP_J",1:30), #7
                                        "ETP_J",paste0("ETP_J",1:30), #38
                                        "TA_J",paste0("TA_J",1:30), #69
                                        "FreqQ_J",paste0("FreqQ_J",1:10), #100
                                        "FreqGW_J",paste0("FreqGW_J",1:10))] # "PK_amont" #112
                col_data=ncol(x.data_st)
              } else if (test_piezo==1){
                x.data_st <- cbind(donnees_st[,7:(7+j)],donnees_st[,38:(38+j)],donnees_st[,69:(69+j)],donnees_st[,100:(100+10)])
                col_data=ncol(x.data_st)
              }
              
              for (ligne in 1:nrow(x.data_st)){
                mois=format(as.Date(donnees_st[ligne,3],"%d/%m/%Y"),"%m")
                no_flow=which((as.numeric(flow[DebSelect,4]) <= 1) & substr(flow[DebSelect,3],5,8)==paste(mois,"25",sep=""))
                all_flow=which((as.numeric(flow[DebSelect,4])>=0) & substr(flow[DebSelect,3],5,8)==paste(mois,"25",sep=""))
                # no_flow=which((as.numeric(flow[DebSelect,4]) <= 1) & (format(as.Date(flow[DebSelect,3],"%Y%m%d"),"%m")==format(as.Date(donnees_st[ligne,3],"%d/%m/%Y"),"%m")))
                # all_flow=which((as.numeric(flow[DebSelect,4])>=0) & (format(as.Date(flow[DebSelect,3],"%Y%m%d"),"%m")==format(as.Date(donnees_st[ligne,3],"%d/%m/%Y"),"%m")))
                x.data_st[ligne,(col_data+1)] <- (length(no_flow)/(length(all_flow)))*100 # ZEROCAL mensuel
              }
              
              # ligne_hydro=which(as.character(hydro[,2]) == code_HYDRO)
              ligne_hydro=which(as.character(substr(hydro$Code_short,1,6)) == substr(code_HYDRO,1,6))[1]

              # x.data_st[1:nrow(x.data_st),(col_data+2)] <- hydro$altitude[ligne_hydro] # Alti
              # x.data_st[,(col_data+3)] <- donnees_st[,5]
              # x.data_st[,(col_data+4)] <- donnees_st[,6]
              x.data_st[1:nrow(x.data_st),(col_data+2)] <- hydro$Altitude[ligne_hydro] # Alti
              x.data_st[,(col_data+3)] <- donnees_st$AI
              x.data_st[,(col_data+4)] <- donnees_st$REC_HIV
              
              if  (length(ligne_hydro)>0){
                # x.data_st[1:nrow(x.data_st),(col_data+5)] <- hydro$Surf_BV[ligne_hydro] # Aire
                # x.data_st[1:nrow(x.data_st),(col_data+6)] <-   hydro$Pente[ligne_hydro] # Pente
                x.data_st[1:nrow(x.data_st),(col_data+5)] <- hydro$SurfaceTotale[ligne_hydro] # Aire
                
                # x.data_st[1:nrow(x.data_st),(col_data+6)] <-   hydro$Pente[ligne_hydro] # Pente
              } else {
                x.data_st[1:nrow(x.data_st),(col_data+5)] <- NA # Aire
                x.data_st[1:nrow(x.data_st),(col_data+6)] <-  NA # Pente
              }
              
              # On retire du jeu de donn?es les lignes o? un NA est pr?sent
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
                  
                  data_st[compteur,11] = x.data_st[i,63]-273.15 # TA cumul jour j
                  data_st[compteur,12] = x.data_st[i,64]-273.15 # TA cumul jour j-1
                  data_st[compteur,13] = mean(as.numeric(x.data_st[i,(63:73)]))-273.15 # TA cumul 10 jours
                  data_st[compteur,14] = mean(as.numeric(x.data_st[i,(63:83)]))-273.15 # TA cumul 20 jours
                  data_st[compteur,15] = mean(as.numeric(x.data_st[i,(63:93)]))-273.15 # TA cumul 30 jours
                  
                  data_st[compteur,16] = (as.numeric(x.data_st[i,94])) # Freq au non depassement jour j
                  data_st[compteur,17] = mean(as.numeric(x.data_st[i,94:99])) # Freq au non depassement moy j5
                  data_st[compteur,18] = mean(as.numeric(x.data_st[i,94:104])) # Freq au non depassement moy j10
                  
                  if(test_piezo==0){
                    data_st[compteur,(19)] = (as.numeric(x.data_st[i,105])) # Freq au non depassement jour j
                    data_st[compteur,(20)] = mean(as.numeric(x.data_st[i,105:110])) # Freq au non depassement moy j5
                    data_st[compteur,(21)] = mean(as.numeric(x.data_st[i,105:115])) # Freq au non depassement moy j10
                  }
                }
              }
              
              if (nrow(data_st)>0){
                if (test_piezo==0){
                  data_st <- data_st[,-c(22:115)] # on supprime les variables non utilis?es
                  colnames(data_st)=c("PRCP_J","PRCP_J1","PRCP_J10","PRCP_J20","PRCP_J30","ETP_J","ETP_J1","ETP_J10","ETP_J20","ETP_J30","TA_J","TA_J1","TA_J10","TA_J20","TA_J30","FreqQ_j","FreqQ_j5","FreqQ_j10","FreqGW_j","FreqGW_j5","FreqGW_j10","P_DRYING_M","Altitude","AI","REC_HIV","Aire","Pente")
                } else if (test_piezo==1){
                  data_st <- data_st[,-c(19:104)] # on supprime les variables non utilis?es
                  colnames(data_st)=c("PRCP_J","PRCP_J1","PRCP_J10","PRCP_J20","PRCP_J30","ETP_J","ETP_J1","ETP_J10","ETP_J20","ETP_J30","TA_J","TA_J1","TA_J10","TA_J20","TA_J30","FreqQ_j","FreqQ_j5","FreqQ_j10","P_DRYING_M","Altitude","AI","REC_HIV","Aire","Pente")
                }
                
                scaled_bis <- as.data.frame(scale(data_st, center = mins[2:length(maxs)], scale = maxs[2:length(maxs)] - mins[2:length(maxs)]))
                scaled.prd <- as.matrix(scaled_bis)
                yhat <- predict(fit, scaled.prd, type="response")
                
                seuil = seuil_opti
                
                if(test_piezo==0){
                  col_pred=28
                } else if (test_piezo==1){
                  col_pred=25
                }
                for (id in 1:length(yhat)){
                  if (yhat[id] > seuil){
                    data_st[id,col_pred]=1
                  } else if (yhat[id] <= seuil){
                    data_st[id,col_pred]=0
                  } else {
                    data_st[id,col_pred]=NA
                  }
                }
                
                for (obs in 1:nrow(data_st)){
                  data_st[obs,(col_pred+1)]<-donnees_st[obs,4]
                  data_st[obs,(col_pred+2)]<-as.character(donnees_st[obs,3])
                }
                
                colnames(data_st)[col_pred:(col_pred+2)]<-c("Prediction","Q_obs","Date")
                write.table(data_st,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/Random_Forest/J30_FRANCE_2012_2016_station_HYDRO/Output_RF_station_HYDRO_",code_HYDRO,"_HER2_",HERc,".csv", sep=""), sep=";", row.names = F, col.names = T)
                
                
                #-------------------------------------
                # Calcul du score sur les pr?dictions
                #-------------------------------------
                
                #--------------------------------------------------------------------------
                # Boucle permettant de calculer le F score sur les stations hydro
                #--------------------------------------------------------------------------
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
                  if(data_st[id,col_pred]==1 & data_st[id,(col_pred+1)]<=1 & !is.na(data_st[id,(col_pred+1)])){
                    TP=TP+1
                  } else if (data_st[id,col_pred]==1 & data_st[id,(col_pred+1)]>1 & !is.na(data_st[id,(col_pred+1)])){
                    FP=FP+1
                  } else if (data_st[id,col_pred]==0 & data_st[id,(col_pred+1)]<=1 & !is.na(data_st[id,(col_pred+1)])){
                    FN=FN+1
                  } else if (data_st[id,col_pred]==0 & data_st[id,(col_pred+1)]>1 & !is.na(data_st[id,(col_pred+1)])){
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
                score[ligne_score,1]<-code_HYDRO
                score[ligne_score,2]<-POD
                score[ligne_score,3]<-FAR
                score[ligne_score,4]<-precision
                score[ligne_score,5]<-Recall
                score[ligne_score,6]<-F1.score
              }
            } # Test si d?bit existe
          } # Test si matrice station existe
        } # Test bonne HER
      } # Boucle station
      
      colnames(score)=c("Code_Hydro","POD","FAR","Precision","Recall","F_scrore")
      write.table(score,paste("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/23_PredictionParSiteONDE_PremierTest/Random_Forest/Scores_stations_HYDRO/Score_RF_station_HYDRO_HER2_",HERc,".csv", sep=""), sep=";", row.names = F, col.names = T)
      # write.table(score,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/Random_Forest/Scores_stations_HYDRO/Score_RF_station_HYDRO_HER2_",HERc,".csv", sep=""), sep=";", row.names = F, col.names = T)
      T2 <- Sys.time()
      Tdiff = difftime(T2, T1)
      print(Tdiff)
      
    } # Test donn?es dispo dans matrice
  }
} # Boucle HER

