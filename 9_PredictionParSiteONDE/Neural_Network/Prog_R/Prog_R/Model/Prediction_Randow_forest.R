# Classification Ridge / LASSO / Elastic net
# appliquée aux sites ONDE situés dans HER 97

rm(list=ls())

T1<-Sys.time()
library(plyr)
library(MASS)
library(randomForest)
library(pROC)

# list_year=c(2012, 2013, 2014, 2015, 2016)
list_year=c("")

list_param=c(27)
ONDE <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/RHT/Stations_ONDES_snap_corr_match_hydro_test3_attrib.csv", header = T, sep = ";", row.names = NULL, quote="")
HER2 <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/HER/Hydroecoregion2_group.csv",sep=";",header=T,quote="")
j=30

for (HERc in HER2[,3]){ # 
  if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_Matrice/Input_test_classif_HER_",HERc,"_30_jours_fin_caract_new_meteo_FINAL.txt",sep=""))==T){
    donnees <- read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_Matrice/Input_test_classif_HER_",HERc,"_30_jours_fin_caract_new_meteo_FINAL.txt",sep=""), sep=";", header = T, quote="", stringsAsFactors=F)
    select <- which(donnees[,126]>=0)
    liste_st <- sort(unique(as.character(donnees[select,1]))) # liste les sites ONDE dans l'HER pour la reconstruction des assecs
    
    # test si aucun assec observé dans les données du train set
    if(length(unique(donnees[select,127]))==1 & unique(donnees[select,127])==0){
      for (code_ONDE in liste_st){
        if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Var_exp_station_NEW_30J_ALL/Input_",code_ONDE,".txt",sep=""))){
          
          # loading des input de la station à prédire:
          donnees_st<-read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Var_exp_station_NEW_30J_ALL/Input_",code_ONDE,".txt",sep=""), sep=";", header = T, quote="", stringsAsFactors=F)
          
          x.data_st <- cbind(donnees_st[,7:(7+j)],donnees_st[,38:(38+j)],donnees_st[,69:(69+j)],donnees_st[,100:(100+10)],donnees_st[,112:(112+10)])
          col_data=ncol(x.data_st)
          
          zerocal <- which(as.character(donnees[,1])==code_ONDE)
          
          # Calcul d'un %DRYING mensuel
          for (ligne in 1:nrow(x.data_st)){
            no_flow=which((as.numeric(donnees[zerocal,127])==1) & (format(as.Date(donnees[zerocal,3],"%d/%m/%Y"),"%m")==format(as.Date(donnees_st[ligne,3],"%d/%m/%Y"),"%m")))
            all_flow=which((as.numeric(donnees[zerocal,127])==0) & (format(as.Date(donnees[zerocal,3],"%d/%m/%Y"),"%m")==format(as.Date(donnees_st[ligne,3],"%d/%m/%Y"),"%m")))
            x.data_st[ligne,(col_data+1)] <- (length(no_flow)/(length(all_flow)+length(no_flow)))*100 # ZEROCAL mensuel
          }
          
          x.data_st[1:nrow(x.data_st),(col_data+2)] <- donnees[zerocal[1],2] # Alti
          x.data_st[,(col_data+3)] <- donnees_st[,5]
          x.data_st[,(col_data+4)] <- donnees_st[,6]
          
          ligne_ONDE=which(ONDE$F_CdSiteHy==code_ONDE)
          if  (length(ligne_ONDE)>0){
            x.data_st[1:nrow(x.data_st),(col_data+5)] <- ONDE$Surf_BV[ligne_ONDE] # Aire
            x.data_st[1:nrow(x.data_st),(col_data+6)] <-  ONDE$Pente[ligne_ONDE] # Pente
          } else {
            x.data_st[1:nrow(x.data_st),(col_data+5)] <- NA # Aire
            x.data_st[1:nrow(x.data_st),(col_data+6)] <-  NA # Pente
          }
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
              
              data_st[compteur,(19)] = (as.numeric(x.data_st[i,105])) # Freq au non depassement jour j
              data_st[compteur,(20)] = mean(as.numeric(x.data_st[i,105:110])) # Freq au non depassement moy j5
              data_st[compteur,(21)] = mean(as.numeric(x.data_st[i,105:115])) # Freq au non depassement moy j10
              
            }
          }
          if (nrow(data_st)>0){
            data_st <- data_st[,-c(22:115)] # on supprime les variables non utilisées
            colnames(data_st)=c("PRCP_J","PRCP_J1","PRCP_J10","PRCP_J20","PRCP_J30","ETP_J","ETP_J1","ETP_J10","ETP_J20","ETP_J30","TA_J","TA_J1","TA_J10","TA_J20","TA_J30","FreqQ_j","FreqQ_j5","FreqQ_j10","FreqGW_j","FreqGW_j5","FreqGW_j10","P_DRYING_M","Altitude","AI","REC_HIV","Aire","Pente")
            col_pred=28
            
            for (obs in 1:nrow(data_st)){
              data_st[obs,col_pred]=0
              data_st[obs,(col_pred+1)]<-donnees_st[obs,4]
              data_st[obs,(col_pred+2)]<-as.character(donnees_st[obs,3])
            }
            
            colnames(data_st)[col_pred:(col_pred+2)]<-c("Prediction","Q_obs","Date")
            write.table(data_st,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/ANN/J30_FRANCE_2012_2016/Output_ANN_",code_ONDE,".csv", sep=""), sep=";", row.names = F, col.names = T)
            
          } # Set data ONDE existe
        } # Boucle matrice input exist
      } # Boucle station ONDE
      
    } else {
      
      critere_full=data.frame()
      output<-data.frame()
      
      # 1. Preparing the dataset
      # 27 param
      data_ini <- cbind(donnees[select,127],donnees[select,7:(7+j)],donnees[select,38:(38+j)],donnees[select,69:(69+j)],donnees[select,100:(100+10)],donnees[select,112:(112+10)],donnees[select,126],donnees[select,2],donnees[select,5:6],donnees[select,128],donnees[select,130])
      date <- donnees[select,3]
      data=data.frame()
      date_fin=data.frame()
      
      # On retire du jeu de données les lignes où un NA est présent
      compteur=0
      test_piezo=0
      
      if(length(which(is.na(data_ini[,112])))==nrow(data_ini)){
        data_ini=cbind(donnees[select,127],donnees[select,7:(7+j)],donnees[select,38:(38+j)],donnees[select,69:(69+j)],donnees[select,100:(100+10)],donnees[select,126],donnees[select,2],donnees[select,5:6],donnees[select,128],donnees[select,130])
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
          data=data[,-c(23:116)] # on supprime les variables non utilisées
          colnames(data)=c("Assec","PRCP_J","PRCP_J1","PRCP_J10","PRCP_J20","PRCP_J30","ETP_J","ETP_J1","ETP_J10","ETP_J20","ETP_J30","TA_J","TA_J1","TA_J10","TA_J20","TA_J30","FreqQ_j","FreqQ_j5","FreqQ_j10","FreqGW_j","FreqGW_j5","FreqGW_j10","P_DRYING_M","Altitude","AI","REC_HIV","Aire","Pente")
        } else if (test_piezo==1){
          data=data[,-c(20:105)] # on supprime les variables non utilisées
          colnames(data)=c("Assec","PRCP_J","PRCP_J1","PRCP_J10","PRCP_J20","PRCP_J30","ETP_J","ETP_J1","ETP_J10","ETP_J20","ETP_J30","TA_J","TA_J1","TA_J10","TA_J20","TA_J30","FreqQ_j","FreqQ_j5","FreqQ_j10","P_DRYING_M","Altitude","AI","REC_HIV","Aire","Pente")
        }
        
        # We therefore scale and split the data before moving on:
        maxs <- apply(data, 2, max)
        mins <- apply(data, 2, min)
        scaled <- as.data.frame(scale(data, center = mins, scale = maxs - mins))
        
        # Si toutes les obs sont de même statut et de 0
        if (length(unique(data[,1]))==1 & data[1,1]==0){
          scaled[1:nrow(data),1]=0 # pour éviter de générer des NaN dans "scaled"
        }
        
        # Si toutes les P_Drying sont à 0
        if(test_piezo==0){
          if (length(unique(data[,1]))==1 & data[1,23]==0){
            scaled[1:nrow(data),23]=0
          }
        } else if (test_piezo==1){
          if (length(unique(data[,1]))==1 & data[1,20]==0){
            scaled[1:nrow(data),20]=0
          }
        }
        
        index <- sample(1:nrow(data),round(1*nrow(data)))
        train <- as.matrix(scaled[index,])
        
        y.train=scaled[index,1]
        
        
        fit <- randomForest(Assec ~ ., data = train, na.action = na.omit)
        yhat10 <- predict(fit, train[,2:ncol(train)], type = "response")
        
        # on détermine le seuil optimal pour ce calage
        seuil <- 0
        F1.score <- NULL
        precision <- NULL
        Recall <- NULL
        
        # Prédictions à partir du réseau ANN entrainé
        ligne=0
        frame_test <- data.frame()
        
        # On recherche le seuil optimal calé sur le F.scrore
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
        
        for (code_ONDE in liste_st){
          if(file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Var_exp_station_NEW_30J_ALL/Input_",code_ONDE,".txt",sep=""))){
            
            # loading des input de la station à prédire:
            donnees_st<-read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Var_exp_station_NEW_30J_ALL/Input_",code_ONDE,".txt",sep=""), sep=";", header = T, quote="", stringsAsFactors=F)
            
            if(test_piezo==0){
              x.data_st <- cbind(donnees_st[,7:(7+j)],donnees_st[,38:(38+j)],donnees_st[,69:(69+j)],donnees_st[,100:(100+10)],donnees_st[,112:(112+10)])
              col_data=ncol(x.data_st)
            } else if (test_piezo==1){
              x.data_st <- cbind(donnees_st[,7:(7+j)],donnees_st[,38:(38+j)],donnees_st[,69:(69+j)],donnees_st[,100:(100+10)])
              col_data=ncol(x.data_st)
            }
            
            zerocal <- which(as.character(donnees[,1])==code_ONDE)
            
            # Calcul d'un %DRYING mensuel
            for (ligne in 1:nrow(x.data_st)){
              no_flow=which((as.numeric(donnees[zerocal,127])==1) & (format(as.Date(donnees[zerocal,3],"%d/%m/%Y"),"%m")==format(as.Date(donnees_st[ligne,3],"%d/%m/%Y"),"%m")))
              all_flow=which((as.numeric(donnees[zerocal,127])==0) & (format(as.Date(donnees[zerocal,3],"%d/%m/%Y"),"%m")==format(as.Date(donnees_st[ligne,3],"%d/%m/%Y"),"%m")))
              x.data_st[ligne,(col_data+1)] <- (length(no_flow)/(length(all_flow)+length(no_flow)))*100 # ZEROCAL mensuel
            }
            
            x.data_st[1:nrow(x.data_st),(col_data+2)] <- donnees[zerocal[1],2] # Alti
            x.data_st[,(col_data+3)] <- donnees_st[,5]
            x.data_st[,(col_data+4)] <- donnees_st[,6]
            
            ligne_ONDE=which(ONDE$F_CdSiteHy==code_ONDE)
            if  (length(ligne_ONDE)>0){
              x.data_st[1:nrow(x.data_st),(col_data+5)] <- ONDE$Surf_BV[ligne_ONDE] # Aire
              x.data_st[1:nrow(x.data_st),(col_data+6)] <-  ONDE$Pente[ligne_ONDE] # Pente
            } else {
              x.data_st[1:nrow(x.data_st),(col_data+5)] <- NA # Aire
              x.data_st[1:nrow(x.data_st),(col_data+6)] <-  NA # Pente
            }
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
                
                if(test_piezo==0){
                  data_st[compteur,(19)] = (as.numeric(x.data_st[i,105])) # Freq au non depassement jour j
                  data_st[compteur,(20)] = mean(as.numeric(x.data_st[i,105:110])) # Freq au non depassement moy j5
                  data_st[compteur,(21)] = mean(as.numeric(x.data_st[i,105:115])) # Freq au non depassement moy j10
                }
              }
            }
            if (nrow(data_st)>0){
              if (test_piezo==0){
                data_st <- data_st[,-c(22:115)] # on supprime les variables non utilisées
                colnames(data_st)=c("PRCP_J","PRCP_J1","PRCP_J10","PRCP_J20","PRCP_J30","ETP_J","ETP_J1","ETP_J10","ETP_J20","ETP_J30","TA_J","TA_J1","TA_J10","TA_J20","TA_J30","FreqQ_j","FreqQ_j5","FreqQ_j10","FreqGW_j","FreqGW_j5","FreqGW_j10","P_DRYING_M","Altitude","AI","REC_HIV","Aire","Pente")
              } else if (test_piezo==1){
                data_st <- data_st[,-c(19:104)] # on supprime les variables non utilisées
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
              
              colnames(data_st)[col_pred]<-c("Prediction")
              write.table(data_st,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/Random_Forest/J30_FRANCE_2012_2016/Output_RF_",code_ONDE,".csv", sep=""), sep=";", row.names = F, col.names = T)
            }
          } # boucle liste param
        } # jour à prendre en compte
        T2 <- Sys.time()
        Tdiff = difftime(T2, T1)
        print(Tdiff)
      } # Test données existent
    } # Test présence d'assec ou non
  } # Test matrice exsite
} # Boucle HER
