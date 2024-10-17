# Classification Ridge / LASSO / Elastic net
# appliquée aux sites ONDE situés dans HER 97

rm(list=ls())

T1<-Sys.time()

library(plyr)
library(MASS)
library(glmnet)
library(pROC)
library(scoring)

list_year=c(2012, 2013, 2014, 2015, 2016)
list_param=c(27)

# exclu_HER=c(33,35,39,43,79,89,94,73,44,76,69,49,37,101)
exclu_HER=c(101)
HER2 <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/HER/Hydroecoregion2_group.csv",sep=";",header=T,quote="")
list_lambda=c(100)

for (HERc in exclu_HER){
  test_HER=which(exclu_HER==HERc)
  # if (length(test_HER)==0){
    if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_Matrice/Input_test_classif_HER_",HERc,"_30_jours_fin_caract_new_meteo_FINAL.txt",sep=""))==T){
      donnees <- read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_Matrice/Input_test_classif_HER_",HERc,"_30_jours_fin_caract_new_meteo_FINAL.txt",sep=""), sep=";", header = T, quote="", stringsAsFactors=F)
      select <- which(donnees[,126]>=0)
      
      coefficient=data.frame()
      compt2=0
      critere_full=data.frame()
      nblambda=100
      j=30
      param=27
      
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
          data=data[,-c(23:116)] # on supprime les variables non utilisées
          colnames(data)=c("Assec","PRCP_J","PRCP_J1","PRCP_J10","PRCP_J20","PRCP_J30","ETP_J","ETP_J1","ETP_J10","ETP_J20","ETP_J30","TA_J","TA_J1","TA_J10","TA_J20","TA_J30","FreqQ_j","FreqQ_j5","FreqQ_j10","FreqGW_j","FreqGW_j5","FreqGW_j10","P_DRYING_M","Altitude","AI","REC_HIV","Aire","Pente")
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
        
        # for (year_test in list_year){
        for (year_test in 1:20){
          
          ## Selection des jeux de données d'entrainement et de validation par année
          # selection_train = which(format(as.Date(date_fin[,1], "%d/%m/%Y"),"%Y")!=as.numeric(year_test))
          # selection_test = which(format(as.Date(date_fin[,1], "%d/%m/%Y"),"%Y")==as.numeric(year_test))
          # x.train <- as.matrix(scaled[selection_train,2:ncol(scaled)])
          # x.test <- as.matrix(scaled[selection_test,2:ncol(scaled)])
          # y.train <- scaled[selection_train,1]
          # y.test <- scaled[selection_test,1]
          
          ## Selection des jeux de données d'entrainement et de validation aléatoirement
          # selection_train <- sample(1:nrow(scaled),round(0.8*nrow(scaled)))
          x.train <- as.matrix(scaled[,2:ncol(scaled)])
          x.test <- as.matrix(scaled[,2:ncol(scaled)])
          y.train <- scaled[,1]
          y.test <- scaled[,1]
          
          assec <- length(which(y.test==1))
          flow <- length(which(y.test==0))
          
          # fit0 <- cv.glmnet(x.train, y.train, type.measure="mse", nlambda=nblambda, alpha=0, family="binomial") # RIDGE
          # fit5 <- cv.glmnet(x.train, y.train, type.measure="mse", nlambda=nblambda, alpha=.5, family="binomial") # E-NET
          fit10 <- cv.glmnet(x.train, y.train, type.measure="mse", nlambda=nblambda, alpha=1, family="binomial") # LASSO
          # y_test0 <- predict(fit0, s=fit0$lambda.min, newx=x.train, type="response")
          # y_test5 <- predict(fit5, s=fit5$lambda.min, newx=x.train, type="response")
          y_test10 <- predict(fit10, s=fit10$lambda.min, newx=x.train, type="response")
          
          numero_du_best_model=which(fit10$lambda==fit10$lambda.min)
          fit10$glmnet.fit$beta[,numero_du_best_model]
          
          # yhat0 <- predict(fit0, s=fit0$lambda.1se, newx=x.test, type="response")
          # yhat5 <- predict(fit5, s=fit5$lambda.1se, newx=x.test, type="response")
          # yhat10 <- predict(fit10, s=fit10$lambda.1se, newx=x.test, type="response")
          
          # Prediction sur le set test
          # yhat0 <- predict(fit0, s=fit0$lambda.min, newx=x.test, type="response")
          # yhat5 <- predict(fit5, s=fit5$lambda.min, newx=x.test, type="response")
          yhat10 <- predict(fit10, s=fit10$lambda.min, newx=x.test, type="response")
          
          # AUC1<-NULL
          # TRH_ROC1<-NULL
          # AUC2<-NULL
          # TRH_ROC2<-NULL
          AUC3<-NULL
          
          # my_roc1 <- roc(y.test, yhat0)
          # my_roc2 <- roc(y.test, yhat5)
          if (length(unique(y.test)==1)){
            my_roc3 <- NA
            AUC3 <-NA
          } else {
            my_roc3 <- roc(y.test, yhat10)
            AUC3=my_roc3$auc
          }
          # AUC1=my_roc1$auc
          # AUC2=my_roc2$auc
          
          
          
          # Brier score
          # somme1=0
          # somme2=0
          somme3=0
          
          for (b in 1:length(yhat10)){
            # somme1=somme1+(yhat0[b]-y.test[b])^2
            # somme2=somme2+(yhat5[b]-y.test[b])^2
            somme3=somme3+(yhat10[b]-y.test[b])^2
          }
          
          # brier1=somme1/length(yhat0)
          # brier2=somme2/length(yhat5)
          brier3=somme3/length(yhat10)
          
          
          seuil = 0 # 0.45
          # F1.score1 <- NULL
          # precision1 <- NULL
          # Recall1 <- NULL
          # F1.score2 <- NULL
          # precision2 <- NULL
          # Recall2 <- NULL
          F1.score3 <- NULL
          precision3 <- NULL
          Recall3 <- NULL
          ligne=0
          frame_test<-data.frame()
          
          # On recherche le seuil optimal calé sur le F.scrore calculé sur le set d'entrainement
          while (seuil <= 1){
            ligne=ligne+1
            compt=0
            # yhat0_seuil=vector()
            # yhat5_seuil=vector()
            yhat10_seuil=vector()
            # TP1=0
            # FP1=0
            # FN1=0
            # TN1=0
            # TP2=0
            # FP2=0
            # FN2=0
            # TN2=0
            TP3=0
            FP3=0
            FN3=0
            TN3=0
            
            for (id in 1:length(y_test10)){
              
              # if (y_test0[id] > seuil){
              #   yhat0_seuil[id]=1
              #   compt=compt+1
              # } else if (y_test0[id] < seuil){
              #   yhat0_seuil[id]=0
              #   compt=compt+1
              # } else {
              #   yhat0_seuil[id]=y_test0[id]
              # }
              # 
              # if(yhat0_seuil[id]==1 & y.train[id]==1){
              #   TP1=TP1+1
              # } else if (yhat0_seuil[id]==1 & y.train[id]==0){
              #   FP1=FP1+1
              # } else if (yhat0_seuil[id]==0 & y.train[id]==1){
              #   FN1=FN1+1
              # } else if (yhat0_seuil[id]==0 & y.train[id]==0){
              #   TN1=TN1+1
              # }
              # 
              # if (y_test5[id] > seuil){
              #   yhat5_seuil[id]=1
              #   compt=compt+1
              # } else if (y_test5[id] < seuil){
              #   yhat5_seuil[id]=0
              #   compt=compt+1
              # } else {
              #   yhat5_seuil[id]=y_test5[id]
              # }
              # 
              # if(yhat5_seuil[id]==1 & y.train[id]==1){
              #   TP2=TP2+1
              # } else if (yhat5_seuil[id]==1 & y.train[id]==0){
              #   FP2=FP2+1
              # } else if (yhat5_seuil[id]==0 & y.train[id]==1){
              #   FN2=FN2+1
              # } else if (yhat5_seuil[id]==0 & y.train[id]==0){
              #   TN2=TN2+1
              # }
              
              if (y_test10[id] > seuil){
                yhat10_seuil[id]=1
                compt=compt+1
              } else if (y_test10[id] < seuil){
                yhat10_seuil[id]=0
                compt=compt+1
              } else {
                yhat10_seuil[id]=y_test10[id]
              }
              
              if(yhat10_seuil[id]==1 & y.train[id]==1){
                TP3=TP3+1
              } else if (yhat10_seuil[id]==1 & y.train[id]==0){
                FP3=FP3+1
              } else if (yhat10_seuil[id]==0 & y.train[id]==1){
                FN3=FN3+1
              } else if (yhat10_seuil[id]==0 & y.train[id]==0){
                TN3=TN3+1
              }
            }
            
            # if ((TP1+FP1) > 0 & (TP1+FN1) > 0){
            #   precision1 <- TP1/(TP1+FP1)
            #   Recall1 <- TP1/(TP1+FN1)
            #   F1.score1 <- (2*precision1*Recall1)/(precision1+Recall1)
            # } else {
            #   F1.score1 <- NA
            # }
            # if ((TP2+FP2) > 0 & (TP2+FN2) > 0){
            #   precision2 <- TP2/(TP2+FP2)
            #   Recall2 <- TP2/(TP2+FN2)
            #   F1.score2 <- (2*precision2*Recall2)/(precision2+Recall2)
            # } else {
            #   F1.score2 <- NA
            # }
            if ((TP3+FP3) > 0 & (TP3+FN3) > 0){
              precision3 <- TP3/(TP3+FP3)
              Recall3 <- TP3/(TP3+FN3)
              F1.score3 <- (2*precision3*Recall3)/(precision3+Recall3)
            } else {
              F1.score3 <- NA
            }
            
            frame_test[ligne,1]<-seuil
            # frame_test[ligne,2]<-F1.score1
            # frame_test[ligne,3]<-F1.score2
            frame_test[ligne,2]<-0
            frame_test[ligne,3]<-0
            frame_test[ligne,4]<-F1.score3
            frame_test[ligne,5]<-mean(as.numeric(frame_test[ligne,4]))
            seuil=seuil+0.05
          }
          
          # On reprend le seuil optimal pour recalculer les scores sur les prédictions
          seuil_opti = frame_test[which(frame_test[,5]==max(frame_test[,5], na.rm=T)),1]
          
          compt=0
          # TP1=0
          # FP1=0
          # FN1=0
          # TN1=0
          # TP2=0
          # FP2=0
          # FN2=0
          # TN2=0
          TP3=0
          FP3=0
          FN3=0
          TN3=0
          
          for (id in 1:length(yhat10)){
            # if (yhat0[id] > seuil_opti){
            #   yhat0[id]=1
            #   compt=compt+1
            # } else if (yhat0[id] < seuil_opti){
            #   yhat0[id]=0
            #   compt=compt+1
            # } else {
            #   yhat0[id]=yhat0[id]
            # }
            # 
            # if(yhat0[id]==1 & y.test[id]==1){
            #   TP1=TP1+1
            # } else if (yhat0[id]==1 & y.test[id]==0){
            #   FP1=FP1+1
            # } else if (yhat0[id]==0 & y.test[id]==1){
            #   FN1=FN1+1
            # } else if (yhat0[id]==0 & y.test[id]==0){
            #   TN1=TN1+1
            # }
            # 
            # if (yhat5[id] > seuil_opti){
            #   yhat5[id]=1
            #   compt=compt+1
            # } else if (yhat5[id] < seuil_opti){
            #   yhat5[id]=0
            #   compt=compt+1
            # } else {
            #   yhat5[id]=yhat5[id]
            # }
            # 
            # if(yhat5[id]==1 & y.test[id]==1){
            #   TP2=TP2+1
            # } else if (yhat5[id]==1 & y.test[id]==0){
            #   FP2=FP2+1
            # } else if (yhat5[id]==0 & y.test[id]==1){
            #   FN2=FN2+1
            # } else if (yhat5[id]==0 & y.test[id]==0){
            #   TN2=TN2+1
            # }
            
            if (yhat10[id] > seuil_opti[1]){
              yhat10[id]=1
              compt=compt+1
            } else if (yhat10[id] < seuil_opti[1]){
              yhat10[id]=0
              compt=compt+1
            } else {
              yhat10[id]=yhat10[id]
            }
            
            if(yhat10[id]==1 & y.test[id]==1){
              TP3=TP3+1
            } else if (yhat10[id]==1 & y.test[id]==0){
              FP3=FP3+1
            } else if (yhat10[id]==0 & y.test[id]==1){
              FN3=FN3+1
            } else if (yhat10[id]==0 & y.test[id]==0){
              TN3=TN3+1
            }
          }
          
          # accuracy1 <- NULL
          # precision1 <- NULL
          # Recall1 <- NULL
          # valeur_seuillee1 <- NULL
          # POD1 <- NULL
          # FAR1 <- NULL
          # 
          # F1.score2 <- NULL
          # accuracy2 <- NULL
          # precision2 <- NULL
          # Recall2 <- NULL
          # valeur_seuillee2 <- NULL
          # POD2 <- NULL
          # FAR2 <- NULL
          
          F1.score3 <- NULL
          accuracy3 <- NULL
          precision3 <- NULL
          Recall3 <- NULL
          valeur_seuillee3 <- NULL
          POD3 <- NULL
          FAR3 <- NULL
          
          # POD1 <- (TP1/(TP1+FN1))*100
          # FAR1 <- (FP1/(FP1+TP1))*100
          # valeur_seuillee1 <- round((compt/length(yhat0))*100,2)
          # accuracy1 <- ((TP1+TN1)/nrow(yhat0))*100
          # precision1 <- TP1/(TP1+FP1)
          # Recall1 <- TP1/(TP1+FN1)
          # F1.score1 <- (2*precision1*Recall1)/(precision1+Recall1)
          # 
          # POD2 <- (TP2/(TP2+FN2))*100
          # FAR2 <- (FP2/(FP2+TP2))*100
          # valeur_seuillee2 <- round((compt/length(yhat5))*100,2)
          # accuracy2 <- ((TP2+TN2)/nrow(yhat0))*100
          # precision2 <- TP2/(TP2+FP2)
          # Recall2 <- TP2/(TP2+FN2)
          # F1.score2 <- (2*precision2*Recall2)/(precision2+Recall2)
          
          POD3 <- (TP3/(TP3+FN3))*100
          FAR3 <- (FP3/(FP3+TP3))*100
          valeur_seuillee3 <- round((compt/length(yhat10))*100,2)
          accuracy3 <- ((TP3+TN3)/nrow(yhat10))*100
          precision3 <- TP3/(TP3+FP3)
          Recall3 <- TP3/(TP3+FN3)
          F1.score3 <- (2*precision3*Recall3)/(precision3+Recall3)
          
          # critere = data.frame(rbind(cbind(POD1,FAR1,AUC1,precision1,Recall1,F1.score1,brier1,seuil_opti,year_test,param,assec,flow),cbind(POD2,FAR2,AUC2,precision2,Recall2,F1.score2,brier2,seuil_opti,year_test,param,assec,flow),cbind(POD3,FAR3,AUC3,precision3,Recall3,F1.score3,brier3,seuil_opti,year_test,param,assec,flow)))
          critere = data.frame(cbind(POD3,FAR3,AUC3,precision3,Recall3,F1.score3,brier3,seuil_opti[1],year_test,param,assec,flow))
          
          # rownames(critere) <- c("Ridge","Elastic_net","LASSO")
          colnames(critere) <- c("POD", "FAR","AUC","Precision","Recall","F1_score","Brier_score","seuil_opti","year_test","Nb_param","Nb_Assec","Nb_Flow")
          critere_full = data.frame(rbind(critere_full,critere))
          
          for (q in 1:length(coef(fit10))){
            coefficient[q,(1+compt2)] <- coef(fit10)[q]
          }
          compt2=compt2+1
          # write.table(critere,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Ridge_Lasso_Elastic_net/Résultats_locaux_HER_97/critere_",param,"var_seuils_",sub("0.","0_",as.character(seuil_max)),"_",sub("0.","0_",as.character(seuil_min)),"_test_",year_test,"_j",j,".csv", sep=""), sep=";", row.names = T, col.names = T)
          
          # png(file = paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Ridge_Lasso_Elastic_net/Résultats_locaux_HER_97/Results_1_layer_3_nodes_27var_seuils_",sub("0.","0_",as.character(seuil_max)),"_",sub("0.","0_",as.character(seuil_min)),"_test_",year_test,".png", sep=""), width = 20, height = 10, units="cm", res=500)
          # par(mfrow = c(2,2))
          # # title(paste("Nombre de valeur prédites seuillées = ", round(mean(valeur_seuillee),2)))
          # boxplot(F1.score, xlab='F1 score', col='cyan', border='blue', ylim=c(0,1), names='F1 score', main='F1 score', horizontal=TRUE)
          # boxplot(accuracy, xlab='Accuracy', col='cyan', border='blue', ylim=c(0,100), names='Accuracy (%)', main='Accuracy(%)', horizontal=TRUE)
          # boxplot(POD, xlab='POD', col='cyan', border='blue', ylim=c(0,100), names='POD', main='POD', horizontal=TRUE)
          # boxplot(FAR, xlab='FAR', col='cyan', border='blue', ylim=c(0,100), names='FAR', main='FAR', horizontal=TRUE)
          # 
          # title(main = paste("Nombre de valeur prédites seuillées = ", round(mean(valeur_seuillee),2)), outer=TRUE, line=-1)
          # dev.off()
          
        } # boucle années test
        
        
        colnames(critere_full) <- c("POD", "FAR","AUC","Precision","Recall","F1_score","Brier_score","seuil_opti","year_test","Nb_Assec","Nb_Flow")
        write.table(critere_full,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Ridge_Lasso_Elastic_net/Résultats_locaux_FRANCE/critere_2012_2016_FULL_moy_j",j,"_new_meteo_all_caract_HER_",HERc,"_RANDOM_FINAL.csv", sep=""), sep=";", row.names = F, col.names = T)
        colnames(coefficient) <- c("2012","2013","2014","2015","2016")
        write.table(coefficient,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Ridge_Lasso_Elastic_net/Résultats_locaux_FRANCE/Coefficient_2012_2016_FULL_moy_j",j,"_new_meteo_all_caract_HER_",HERc,"_RANDOM_FINAL.csv", sep=""), sep=";", row.names = F, col.names = T)
        
        T2 <- Sys.time()
        Tdiff = difftime(T2, T1)
        print(Tdiff)
        
      } # Test données dispo
    } # Test matrice données existent
  # }
} # Boucle HER2