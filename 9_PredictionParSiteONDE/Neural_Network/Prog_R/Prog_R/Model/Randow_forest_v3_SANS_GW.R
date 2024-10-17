# Classification Random Forest
# appliquée aux sites ONDE situés dans HER 97

rm(list=ls())

T1<-Sys.time()

library(plyr)
library(MASS)
library(randomForest)
library(pROC)
library(caret)

list_year=c(2012, 2013, 2014, 2015, 2016)
list_param=c(27)
list_ntree=c(500)

# list_ntree=c(10000)
# list_ntry=c(5,10,15,20,25,30)

HER2 <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/HER/Hydroecoregion2_group.csv",sep=";",header=T,quote="")

for (HERc in 58){
  
  if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_Matrice/Input_test_classif_HER_",HERc,"_30_jours_fin_caract_new_meteo_FINAL.txt",sep=""))==T){
    donnees <- read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_Matrice/Input_test_classif_HER_",HERc,"_30_jours_fin_caract_new_meteo_FINAL.txt",sep=""), sep=";", header = T, quote="", stringsAsFactors=F)
    select=which(donnees[,126]>=0)
    
    j=30
    param=27
    compt2=0
    critere_full=data.frame()
    coefficient=data.frame()
    
    # 1. Preparing the dataset
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
        data=data[,-c(20:116)] # on supprime les variables non utilisées
        colnames(data)=c("Assec","PRCP_J","PRCP_J1","PRCP_J10","PRCP_J20","PRCP_J30","ETP_J","ETP_J1","ETP_J10","ETP_J20","ETP_J30","TA_J","TA_J1","TA_J10","TA_J20","TA_J30","FreqQ_j","FreqQ_j5","FreqQ_j10","P_DRYING_M","Altitude","AI","REC_HIV","Aire","Pente")
      } else if (test_piezo==1){
        data=data[,-c(20:105)] # on supprime les variables non utilisées
        colnames(data)=c("Assec","PRCP_J","PRCP_J1","PRCP_J10","PRCP_J20","PRCP_J30","ETP_J","ETP_J1","ETP_J10","ETP_J20","ETP_J30","TA_J","TA_J1","TA_J10","TA_J20","TA_J30","FreqQ_j","FreqQ_j5","FreqQ_j10","P_DRYING_M","Altitude","AI","REC_HIV","Aire","Pente")
      }
      
      # check that no datapoint is missing,
      apply(data,2,function(x) sum(is.na(x)))
      
      # We therefore scale and split the data before moving on:
      maxs <- apply(data, 2, max)
      mins <- apply(data, 2, min)
      scaled <- as.data.frame(scale(data, center = mins, scale = maxs - mins))
      
      # Si toutes les P_Drying sont à 0
      if(test_piezo==0){
        if (length(unique(data[,1]))==1 & data[1,23]==0){
          scaled[1:nrow(data),23]=0
          scaled[1:nrow(data),1]=0
        }
      } else if (test_piezo==1){
        if (length(unique(data[,1]))==1 & data[1,20]==0){
          scaled[1:nrow(data),20]=0
          scaled[1:nrow(data),1]=0
        }
      }
      for (year_test in 1:20){
        # for (year_test in list_year){
        
        # check that no datapoint is missing,
        apply(data,2,function(x) sum(is.na(x)))
        
        # We therefore scale and split the data before moving on:
        maxs <- apply(data, 2, max)
        mins <- apply(data, 2, min)
        scaled <- as.data.frame(scale(data, center = mins, scale = maxs - mins))
        
        selection_train = sample(1:nrow(scaled),round(0.8*nrow(scaled)))
        train <- as.matrix(scaled[selection_train,])
        test <- as.matrix(scaled[-selection_train,])
        
        # selection_train = which(format(as.Date(date_fin[,1], "%d/%m/%Y"),"%Y")!=as.numeric(year_test))
        # selection_test = which(format(as.Date(date_fin[,1], "%d/%m/%Y"),"%Y")==as.numeric(year_test))
        # train <- as.matrix(scaled[selection_train,])
        # test <- as.matrix(scaled[selection_test,])
        
        fit <- randomForest(Assec ~ ., data = train, ntree=500, na.action = na.omit) #
        yhat <- predict(fit, test[,2:ncol(train)], type="response")
        y_test <- predict(fit, train, type="response")
        
        assec <- length(which(test[,1]==1))
        flow <- length(which(test[,1]==0))
        
        # bestmtry <- tuneRF(train[,2:25], train[,1], stepFactor=1.5, improve=1e-5, ntree=500)
        # Pour visioner l'importance des variables dans la classif Mean Decrease Gini
        # fit$importance[order(fit$importance[, 1], decreasing = TRUE),]
        # mod <- train(Assec ~ ., data = train, method = "rf")
        # varImpPlot(mod$finalModel)
        
        AUC<-NULL
        
        if (length(unique(test[,1])==1)){
          my_roc <- NA
          AUC <-NA
        } else {
          my_roc <- roc(y.test, yhat10)
          AUC=my_roc$auc
        }
        
        # Brier score
        somme1 <- 0
        brier1 <- NULL
        
        for (b in 1:length(yhat)){
          somme1=somme1+(yhat[b]-test[b,1])^2
        }
        brier1=somme1/length(yhat)
        
        TP=0
        FP=0
        FN=0
        TN=0
        seuil = 0
        compt=0
        
        F1.score <- NULL
        precision <- NULL
        Recall <- NULL
        ligne=0
        frame_test<-data.frame()
        
        # On recherche le seuil optimal calé sur le F.scrore
        while (seuil <= 1){
          ligne=ligne+1
          compt=0
          yhat_seuil=vector()
          TP=0
          FP=0
          FN=0
          TN=0
          
          for (id in 1:length(y_test)){
            if (y_test[id] > seuil){
              yhat_seuil[id]=1
              compt=compt+1
            } else if (y_test[id] < seuil){
              yhat_seuil[id]=0
              compt=compt+1
            } else {
              yhat_seuil[id]=y_test[id]
            }
            
            if(yhat_seuil[id]==1 & train[id,1]==1){
              TP=TP+1
            } else if (yhat_seuil[id]==1 & train[id,1]==0){
              FP=FP+1
            } else if (yhat_seuil[id]==0 & train[id,1]==1){
              FN=FN+1
            } else if (yhat_seuil[id]==0 & train[id,1]==0){
              TN=TN+1
            }
          }
          
          if ((TP+FP) > 0 & (TP+FN) > 0){
            precision <- TP/(TP+FP)
            Recall <- TP/(TP+FN)
            F1.score <- (2*precision*Recall)/(precision+Recall)
          } else {
            F1.score <- NA
          }
          
          frame_test[ligne,1]<-seuil
          frame_test[ligne,2]<-F1.score
          
          seuil=seuil+0.05
        }
        
        # On reprend le seuil optimal pour recalculer les scores
        TP=0
        FP=0
        FN=0
        TN=0
        seuil_opti=frame_test[which(frame_test[,2]==max(frame_test[,2], na.rm=T)),1]
        
        if(length(seuil_opti)==0){
          seuil_opti=0.5
        }
        
        for (id in 1:length(yhat)){
          
          if (yhat[id] > seuil_opti[1]){
            yhat[id]=1
          } else if (yhat[id] < seuil_opti[1]){
            yhat[id]=0
          } else {
            yhat[id]=yhat[id]
          }
          if(yhat[id]==1 & test[id,1]==1){
            TP=TP+1
          } else if (yhat[id]==1 & test[id,1]==0){
            FP=FP+1
          } else if (yhat[id]==0 & test[id,1]==1){
            FN=FN+1
          } else if (yhat[id]==0 & test[id,1]==0){
            TN=TN+1
          }
        }
        
        F1.score <- NULL
        accuracy <- NULL
        precision <- NULL
        Recall <- NULL
        POD <- NULL
        FAR <- NULL
        
        POD <- (TP/(TP+FN))*100
        FAR <- (FP/(FP+TP))*100
        accuracy <- ((TP+TN)/length(yhat))*100
        precision <- TP/(TP+FP)
        Recall <- TP/(TP+FN)
        F1.score <- (2*precision*Recall)/(precision+Recall)
        
        critere = data.frame(cbind(POD,FAR,AUC,precision,Recall,F1.score,brier1,seuil_opti[1],year_test,assec,flow)) #,mod$bestTune
        # colnames(critere) <- c("POD", "FAR","Accuracy","Precision","Recall","F1_score")
        # write.table(critere,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Random_forest/Résultats_locaux_HER_97/critere_",param,"var_test_",year_test,"_bis.csv", sep=""), sep=";", row.names = F, col.names = T)
        # colnames(critere) <- c("POD", "FAR","Accuracy","Precision","Recall","F1_score","year_test","Nb_param")
        critere_full = data.frame(rbind(critere_full,critere))
        
        compt2=compt2+1
        for (q in 1:length(fit$importance)){
          coefficient[q,compt2] <- fit$importance[q]
        }
        
        # png(file = paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Ridge_Lasso_Elastic_net/Résultats_locaux_HER_97/Results_1_layer_3_nodes_27var_seuils_",sub("0.","0_",as.character(seuil_max)),"_",sub("0.","0_",as.character(seuil_min)),"_test_",year_test,".png", sep=""), width = 20, height = 10, units="cm", res=500)
        # par(mfrow = c(2,2))
        # # title(paste("Nombre de valeur prédites seuillées = ", round(mean(valeur_seuillee),2)))
        # boxplot(F1.score, xlab='F1 score', col='cyan', border='blue', ylim=c(0,1), names='F1 score', main='F1 score', horizontal=TRUE)
        # boxplot(accuracy, xlab='Accuracy', col='cyan', border='blue', ylim=c(0,100), names='Accuracy (%)', main='Accuracy(%)', horizontal=TRUE)
        # boxplot(POD, xlab='POD', col='cyan', border='blue', ylim=c(0,100), names='POD', main='POD', horizontal=TRUE)
        # boxplot(FAR, xlab='FAR', col='cyan', border='blue', ylim=c(0,100), names='FAR', main='FAR', horizontal=TRUE)
        
        # title(main = paste("Nombre de valeur prédites seuillées = ", round(mean(valeur_seuillee),2)), outer=TRUE, line=-1)
        # dev.off()
        
      } # boucle random test
      
      colnames(critere_full) <- c("POD", "FAR","AUC","Precision","Recall","F1_score","Brier","seuil_opti","year_test","Nb_Assec","Nb_Flow") #
      write.table(critere_full,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Random_forest/Résultats_locaux_FRANCE/critere_seuils_opti_test_2012_2016_FULL_moy_j",j,"_new_meteo_all_caract_HER_",HERc,"_SANS_GW.csv", sep=""), sep=";", row.names = F, col.names = T)
      colnames(coefficient) <- c("2012","2013","2014","2015","2016")
      write.table(coefficient,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Random_forest/Résultats_locaux_FRANCE/Coefficient_2012_2016_FULL_moy_j",j,"_new_meteo_all_caract_HER_",HERc,"_SANS_GW.csv", sep=""), sep=";", row.names = F, col.names = T)
      
      T2 <- Sys.time()
      Tdiff <- difftime(T2, T1)
      print(Tdiff)
    } # Test si données existent
  } # Test matrice existe
} # boucle HER