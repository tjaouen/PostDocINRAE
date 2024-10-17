# test neural network
library(neuralnet)
library(plyr)
library(MASS)
library(pROC)
library(nnet)

rm(list=ls())

T1<-Sys.time()
list_year=c(2012)#, 2013, 2014, 2015, 2016)
list_param=c(27)

donnees <- read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_test_classif_HER_97_30_jours_fin_caract_new_meteo.txt", sep=";", header = T, quote="", stringsAsFactors=F)
select <- which(donnees[,114]>=0)
list_node <- c(2,3,4,5,6,7,8)

for (j in 30){
  
  critere_full=data.frame()
  
  # for (year_test in 1:15){
  for (year_test in list_year){ 
    print(year_test)
    
    for (param in list_param){
      
      # 1. Preparing the dataset
      # 27 param 
      data_ini <- cbind(donnees[select,115],donnees[select,7:(7+j)],donnees[select,38:(38+j)],donnees[select,69:(69+j)],donnees[select,100:(100+10)],donnees[select,114],donnees[select,2],donnees[select,5:6],donnees[select,116],donnees[select,118]) #
      
      date <- donnees[select,3]
      data=data.frame()
      date_fin=data.frame()
      
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
          
        }
      }
      
      data=data[,-c(20:105)] # on supprime les variables non utilisées
      colnames(data)=c("Assec","PRCP_J","PRCP_J1","PRCP_J10","PRCP_J20","PRCP_J30","ETP_J","ETP_J1","ETP_J10","ETP_J20","ETP_J30","TA_J","TA_J1","TA_J10","TA_J20","TA_J30","Freq_j","Freq_j5","Freq_j10","ZEROQUAL","Altitude","AI","REC_HIV","Aire","Pente")
      
      # data=data[,-c(17:94)] # on supprime les variables non utilisées
      # colnames(data)=c("Assec","PRCP_J","PRCP_J1","PRCP_J10","PRCP_J20","PRCP_J30","ETP_J","ETP_J1","ETP_J10","ETP_J20","ETP_J30","TA_J","TA_J1","TA_J10","TA_J20","TA_J30","Freq_j","Freq_j1","Freq_j2","Freq_j3","Freq_j4","Freq_j5","Freq_j6","Freq_j7","Freq_j8","Freq_j9","Freq_j10","ZEROQUAL","Altitude","AI","REC_HIV","Aire","Pente")
      
      # check that no datapoint is missing,
      apply(data,2,function(x) sum(is.na(x)))
      
      # We therefore scale and split the data before moving on:
      maxs <- apply(data, 2, max)
      mins <- apply(data, 2, min)
      scaled <- as.data.frame(scale(data, center = mins, scale = maxs - mins))
      
      # On test plusieurs nombre de nodes pour chaque subset test
      compt2=0
      F1.score <- NULL
      accuracy <- NULL
      precision <- NULL
      Recall <- NULL
      valeur_seuillee <- NULL
      POD <- NULL
      FAR <- NULL
      AUC <- NULL
      brier1 <- NULL
      
      for (nbnode in list_node){

        # index <- sample(1:nrow(data),round(0.8*nrow(data)))
        # train.cv <- scaled[index,]
        # test.cv <- scaled[-index,]
        
        selection_train = which(format(as.Date(date_fin[,1], "%d/%m/%Y"),"%Y")!=as.numeric(year_test))
        selection_test = which(format(as.Date(date_fin[,1], "%d/%m/%Y"),"%Y")==as.numeric(year_test))
        
        
        selection_train = which(format(as.Date(date_fin[,1], "%d/%m/%Y"),"%Y")!=2013)
        selection_test = which(format(as.Date(date_fin[,1], "%d/%m/%Y"),"%Y")==2013)
        
        train.cv <- scaled[selection_train,]
        test.cv <- scaled[selection_test,]
        
        n <- names(train.cv)
        f <- as.formula(paste("Assec ~", paste(n[!n %in% "Assec"], collapse = " + ")))
        # nn <- neuralnet(f,data=train.cv,hidden=c(nbnode),linear.output=T,stepmax = 1e+06)
        
        nn <- nnet(f,data=train.cv,size=8,linout=T, maxit=1000)
        nn <- nnet(f,data=train.cv,size=0,linout=T, maxit=1000, skip=T)
        # if(is.null(nn$weights)==FALSE){
          
          # pr.nn <- compute(nn,test.cv[,2:ncol(test.cv)])
          pr.nn2 <- predict(nn, test.cv[,-1], type="raw")
          
          # pr.nn <- pr.nn$net.result*(max(data$Assec)-min(data$Assec))+min(data$Assec) # /!\ biais dans l'analyse avec un calcul de min et max sur tte la chronique
          pr.nn <- pr.nn*(max(data$Assec)-min(data$Assec))+min(data$Assec) # /!\ biais dans l'analyse avec un calcul de min et max sur tte la chronique
          test.cv.r <- (test.cv$Assec)*(max(data$Assec)-min(data$Assec))+min(data$Assec) # /!\ biais dans l'analyse avec un calcul de min et max sur tte la chronique
          
          compt2 = compt2+1
          my_roc <- roc(test.cv.r, pr.nn[,1])
          AUC[compt2]=my_roc$auc
          
          # Brier score
          somme1 <- 0
          for (b in 1:length(test.cv.r)){
            somme1=somme1+(pr.nn[b,1]-test.cv.r[b])^2
          }
          brier1[compt2]=somme1/length(test.cv.r)
          
          seuil = 0
          F1.score[compt2] <- 0
          precision[compt2] <- 0
          Recall[compt2] <- 0
          ligne=0
          frame_test <- data.frame()
          
          # On recherche le seuil optimal calé sur le F.scrore
          while (seuil <= 1){
            ligne=ligne+1
            compt = 0
            TP = 0
            FP = 0
            FN = 0
            TN = 0
            yhat_seuil = vector()
            
            for (id in 1:length(pr.nn)){
              if (pr.nn[id] > seuil){
                yhat_seuil[id]=1
                compt=compt+1
              } else if (pr.nn[id] < seuil){
                yhat_seuil[id]=0
                compt=compt+1
              } else {
                yhat_seuil[id]=pr.nn[id]
              }
              
              if(yhat_seuil[id]==1 & test.cv.r[id]==1){
                TP=TP+1
              } else if (yhat_seuil[id]==1 & test.cv.r[id]==0){
                FP=FP+1
              } else if (yhat_seuil[id]==0 & test.cv.r[id]==1){
                FN=FN+1
              } else if (yhat_seuil[id]==0 & test.cv.r[id]==0){
                TN=TN+1
              }
            }
            seuil=seuil+0.05
            if ((TP+FP) > 0 & (TP+FN) > 0){
              precision[compt2] <- TP/(TP+FP)
              Recall[compt2] <- TP/(TP+FN)
              F1.score[compt2] <- (2*precision[compt2]*Recall[compt2])/(precision[compt2]+Recall[compt2])
            } else {
              F1.score[compt2] <- NA
            }
            frame_test[ligne,1]<-seuil
            frame_test[ligne,2]<-F1.score[compt2]
            
          } # boucle while
          
          # On reprend le seuil optimal pour recalculer les scores
          compt=0
          TP=0
          FP=0
          FN=0
          TN=0
          seuil_opti = frame_test[which(frame_test[,2]==max(frame_test[,2], na.rm=T)),1]
          predict_th=vector()
          
          for (id in 1:length(pr.nn)){
            if (pr.nn[id] > seuil_opti){
              predict_th[id]=1
              compt=compt+1
            } else if (pr.nn[id] < seuil_opti){
              predict_th[id]=0
              compt=compt+1
            } else {
              predict_th[id]=pr.nn[id]
            }
            
            if(predict_th[id]==1 & test.cv.r[id]==1){
              TP=TP+1
            } else if (predict_th[id]==1 & test.cv.r[id]==0){
              FP=FP+1
            } else if (predict_th[id]==0 & test.cv.r[id]==1){
              FN=FN+1
            } else if (predict_th[id]==0 & test.cv.r[id]==0){
              TN=TN+1
            }
          }
          
          POD[compt2]=(TP/(TP+FN))*100
          FAR[compt2]=(FP/(FP+TP))*100
          valeur_seuillee[compt2]=round((compt/length(test.cv.r))*100,2)
          # accuracy[compt2] = ((TP+TN)/length(test.cv.r))*100
          precision[compt2] <- TP/(TP+FP)
          Recall[compt2] <- TP/(TP+FN)
          F1.score[compt2] <- (2*precision[compt2]*Recall[compt2])/(precision[compt2]+Recall[compt2])
          # pbar$step()
          # critere1 = data.frame(cbind(POD,FAR,accuracy,precision,Recall,F1.score,year_test,param))
          
          # }
        # } # Si ANN ne converge pas
      }
      
      # selection_best_fit <- sbf
      sbf <- which(F1.score==max(F1.score, na.rm = T))
      critere = data.frame(cbind(POD[sbf],FAR[sbf],AUC[sbf],precision[sbf],Recall[sbf],F1.score[sbf],brier1[sbf],seuil_opti,year_test,list_node[sbf]))
      colnames(critere) <- c("POD", "FAR","AUC","Precision","Recall","F1_score","Brier","seuil_opti","year_test","NB_Nodes")
      # write.table(critere,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/Résultats_locaux_HER_97/critere_2_layer_5_nodes_",param,"var_seuils_",sub("0.","0_",as.character(seuil_max)),"_",sub("0.","0_",as.character(seuil_min)),"_test_",year_test,"_FNoF_only_sans_FQGW.csv", sep=""), sep=";", row.names = F, col.names = F)
      critere_full = data.frame(rbind(critere_full,critere))
      
      # png(file = paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/Résultats_locaux_HER_97/Results_2_layer_5_nodes_",param,"var_seuils_",sub("0.","0_",as.character(seuil_max)),"_",sub("0.","0_",as.character(seuil_min)),"_test_",year_test,"_FNoF_only_sans_FQGW.png", sep=""), width = 20, height = 10, units="cm", res=500)
      # par(mfrow = c(2,2))
      # # title(paste("Nombre de valeur prédites seuillées = ", round(mean(valeur_seuillee),2)))
      # boxplot(F1.score, xlab='F1 score', col='cyan', border='blue', ylim=c(0,1), names='F1 score', main='F1 score', horizontal=TRUE)
      # boxplot(accuracy, xlab='Accuracy', col='cyan', border='blue', ylim=c(0,100), names='Accuracy (%)', main='Accuracy(%)', horizontal=TRUE)
      # boxplot(POD, xlab='POD', col='cyan', border='blue', ylim=c(0,100), names='POD', main='POD', horizontal=TRUE)
      # boxplot(FAR, xlab='FAR', col='cyan', border='blue', ylim=c(0,100), names='FAR', main='FAR', horizontal=TRUE)
      # 
      # title(main = paste("Nombre de valeur prédites seuillées = ", round(mean(valeur_seuillee),2)), outer=TRUE, line=-1)
      # dev.off()
      # }
      
      # library(gmodels)
      # CrossTable(x=predict_th,y=test.cv.r,prop.chisq=FALSE)
    } # boucle liste param
  } # boucle année test
  
  colnames(critere_full) <- c("POD", "FAR","AUC","Precision","Recall","F1_score","Brier","seuil_opti","year_test","NB_Nodes")
  write.table(critere_full,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/Résultats_locaux_HER_97/critere_ANN_1layer_2012_2016_moy_j",j,"_new_meteo_all_caract_nnet.csv", sep=""), sep=";", row.names = F, col.names = T)
  T2 <- Sys.time()
  Tdiff = difftime(T2, T1)
  print(Tdiff)
}


