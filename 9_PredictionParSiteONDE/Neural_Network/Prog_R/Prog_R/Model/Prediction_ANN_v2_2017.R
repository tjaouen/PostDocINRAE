# test neural network
library(neuralnet)
library(plyr)
library(MASS)
library(pROC)
library(nnet)

rm(list=ls())

T1<-Sys.time()

type = "_FINAL"
# year_test=c(2012, 2013, 2014, 2015, 2016)
year_test=c("")

liste_lambda<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/Scores_ALL_HER_Lambda_best.csv", header = T, sep = ";", row.names = NULL, quote="")

ONDE <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/RHT/Stations_ONDES_snap_corr_match_hydro_test3_attrib.csv", header = T, sep = ";", row.names = NULL, quote="")
HER2 <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/HER/Hydroecoregion2_group.csv",sep=";",header=T,quote="")
j=30
critere_full=data.frame()

for (HERc in HER2[,3]){ #
  critere=data.frame()
  if (HERc == 38){
  if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_Matrice/Input_test_classif_HER_",HERc,"_30_jours_fin_caract_new_meteo_FINAL.txt",sep=""))==T){
    donnees <- read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_Matrice/Input_test_classif_HER_",HERc,"_30_jours_fin_caract_new_meteo_FINAL.txt",sep=""), sep=";", header = T, quote="", stringsAsFactors=F)
    select <- which(donnees[,126]>=0)
    liste_st <- sort(unique(as.character(donnees[select,1]))) # liste les sites ONDE dans l'HER pour la reconstruction des assecs
    
    # test si aucun assec observé dans les données du train set
    if(length(unique(donnees[select,127]))==1 & unique(donnees[select,127])==0){
      if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_Matrice_2017/Input_test_classif_HER_",HERc,"_30_jours_fin_caract_new_meteo_FINAL.txt",sep=""))){
        
        # loading des input de la station à prédire:
        donnees_st<-read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_Matrice_2017/Input_test_classif_HER_",HERc,"_30_jours_fin_caract_new_meteo_FINAL.txt",sep=""), sep=";", header = T, quote="", stringsAsFactors=F)
        
        #  On va rechercher les PDrying dans les valeurs d'entrainement calculées entre 2012 et 2016
        for (r in 1:nrow(donnees_st)){
          cod=which(donnees[,1]==donnees_st[r,1] & format(as.Date(donnees[,3], "%d/%m/%Y"),"%m")==format(as.Date(donnees_st[r,3], "%Y-%m-%d"),"%m"))
          if(length(cod)>0){
            donnees_st[r,126]=donnees[cod[1],126]
          } else {
            donnees_st[r,126]=NA
          }
        }
        
        select_st <- which(donnees_st[,126]>=0)
        x.data_st <- cbind(donnees_st[select_st,127],donnees_st[select_st,7:(7+j)],donnees_st[select_st,38:(38+j)],donnees_st[select_st,69:(69+j)],donnees_st[select_st,100:(100+10)],donnees_st[select_st,112:(112+10)],donnees_st[select_st,126],donnees_st[select_st,2],donnees_st[select_st,5:6],donnees_st[select_st,128],donnees_st[select_st,130])
        
        # On retire du jeu de données les lignes où un NA est présent
        compteur=0
        data_st=data.frame()
        # Si on garde les variables au jour
        for (i in 1:nrow(x.data_st)){
          if(!is.na(mean(as.numeric(x.data_st[i,])))){
            compteur = compteur+1
            data_st = rbind(data_st,x.data_st[i,])
            date_fin[compteur,1] = date[i]
            
            # Moyenne par jour 
            data_st[compteur,(4)] = sum(x.data_st[i,(2:12)]) # PRCP cumul 10 jours
            data_st[compteur,(5)] = sum(x.data_st[i,(2:22)]) # PRCP cumul 20 jours
            data_st[compteur,(6)] = sum(x.data_st[i,(2:32)]) # PRCP cumul 30 jours
            data_st[compteur,(7)] = x.data_st[i,33] # ETP cumul jour j
            data_st[compteur,(8)] = x.data_st[i,34] # ETP cumul jour j-1
            data_st[compteur,(9)] = sum(x.data_st[i,(33:43)]) # ETP cumul 10 jours
            data_st[compteur,(10)] = sum(x.data_st[i,(33:53)]) # ETP cumul 20 jours
            data_st[compteur,(11)] = sum(x.data_st[i,(33:63)]) # ETP cumul 30 jours
            data_st[compteur,(12)] = x.data_st[i,64] # TA cumul jour j
            data_st[compteur,(13)] = x.data_st[i,65] # TA cumul jour j-1
            
            data_st[compteur,(14)] = mean(as.numeric(x.data_st[i,(64:74)])) # TA cumul 10 jours
            data_st[compteur,(15)] = mean(as.numeric(x.data_st[i,(64:84)])) # TA cumul 20 jours
            data_st[compteur,(16)] = mean(as.numeric(x.data_st[i,(64:94)])) # TA cumul 30 jours
            
            data_st[compteur,(17)] = (as.numeric(x.data_st[i,95])) # Freq au non depassement jour j
            data_st[compteur,(18)] = mean(as.numeric(x.data_st[i,95:100])) # Freq au non depassement moy j5
            data_st[compteur,(19)] = mean(as.numeric(x.data_st[i,95:105])) # Freq au non depassement moy j10
            
            data_st[compteur,(20)] = (as.numeric(x.data_st[i,106])) # Freq au non depassement jour j
            data_st[compteur,(21)] = mean(as.numeric(x.data_st[i,106:111])) # Freq au non depassement moy j5
            data_st[compteur,(22)] = mean(as.numeric(x.data_st[i,106:116])) # Freq au non depassement moy j10
          }
        }
        
        if (nrow(data_st)>0){
          data_st=data_st[,-c(23:116)] # on supprime les variables non utilisées
          colnames(data_st)=c("Assec","PRCP_J","PRCP_J1","PRCP_J10","PRCP_J20","PRCP_J30","ETP_J","ETP_J1","ETP_J10","ETP_J20","ETP_J30","TA_J","TA_J1","TA_J10","TA_J20","TA_J30","FreqQ_j","FreqQ_j5","FreqQ_j10","FreqGW_j","FreqGW_j5","FreqGW_j10","P_DRYING_M","Altitude","AI","REC_HIV","Aire","Pente")
          
          col_pred=29
          
          for (obs in 1:nrow(data_st)){
            data_st[obs,col_pred]=0
            data_st[obs,(col_pred+1)]<-donnees_st[obs,4]
            data_st[obs,(col_pred+2)]<-as.character(donnees_st[obs,3])
          }
          
          colnames(data_st)[col_pred:(col_pred+2)]<-c("Prediction","Q_obs","Date")
          write.table(data_st,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/ANN/J30_FRANCE_2017/Output_ANN_",HERc,"_2017.csv", sep=""), sep=";", row.names = F, col.names = T)
          
        } # Set data ONDE existe
      } # Boucle matrice input exist
      
    } else {
      
      rep_lambda=which(liste_lambda[,1]==HERc)
      lambda_opti=(liste_lambda[rep_lambda,3])
      
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
        
        index <- sample(1:nrow(data),round(0.8*nrow(data)))
        train.cv <- scaled[index,]
        train.cv$Assec.C2 <- 1-train.cv$Assec
        test.cv <- scaled[-index,]
        test.cv$Assec.C2 <- 1-test.cv$Assec
        
        assec <- length(which(test.cv[,1]==1))
        flow <- length(which(test.cv[,1]==0))
        
        min.val<-Inf
        nn.min <- NULL
        rep=NULL
        rep.min.val=NULL
        
        n <- names(train.cv)
        # f <- as.formula(paste("Assec ~", paste(n[!n %in% "Assec"], collapse = " + ")))
        
        if (test_piezo==0){
          f <- (cbind(Assec,Assec.C2) ~ PRCP_J + PRCP_J1 + PRCP_J10 + PRCP_J20 + PRCP_J30 + ETP_J + 
                  ETP_J1 + ETP_J10 + ETP_J20 + ETP_J30 + TA_J + TA_J1 + TA_J10 + 
                  TA_J20 + TA_J30 + FreqQ_j + FreqQ_j5 + FreqQ_j10 + FreqGW_j + FreqGW_j5 + FreqGW_j10 + P_DRYING_M + 
                  Altitude + AI + REC_HIV + Aire + Pente)
        } else if (test_piezo==1){
          f <- (cbind(Assec,Assec.C2) ~ PRCP_J + PRCP_J1 + PRCP_J10 + PRCP_J20 + PRCP_J30 + ETP_J + 
                  ETP_J1 + ETP_J10 + ETP_J20 + ETP_J30 + TA_J + TA_J1 + TA_J10 + 
                  TA_J20 + TA_J30 + FreqQ_j + FreqQ_j5 + FreqQ_j10 + P_DRYING_M + 
                  Altitude + AI + REC_HIV + Aire + Pente)
        }
        
        # Fonction qui va lancer le réseau de neurones n fois 
        # + sélection du modèle ayant le % d'erreur la plus faible 
        nn.start <- function(nstart,d.train,nnode,f.nn,maxit=1000,lambda=0){
          min.val=Inf
          nn.min=NULL
          for (a in 1:nstart){
            nn <- nnet(f.nn,data=d.train,size=nnode, softmax=T, maxit=maxit, skip=T,trace=F,decay=lambda)
            
            if (nn$value< min.val){
              min.val=nn$value
              nn.min=nn
            }
          }
          nn.min
        }
        
        # for (try in 1:20){
        # print(try)
        nfold<-5 # Nombre de plis à prendre dans le set 'train'
        huc <- c(0,1,2,3,4,5,6,8) # Nombre d'unité cachée à tester
        nuc <- length(huc)
        m <- nrow(train.cv)
        
        lfold <- floor(m/nfold)
        cat("Performing cross-validation with ", nfold, " folds of approximate size ",lfold, "\n")
        
        rid <- sample(m,m) # shuffle data
        
        negloglike <- matrix(nrow=nfold, ncol=nuc)
        nstart=20
        
        for (k in 1:nfold){
          print(paste("N_pli = ", k, sep=""))
          if (k < nfold){
            ridk <- rid[(1+(k-1)*lfold):(k*lfold)]
          } else {
            ridk <- rid[(1+(k-1)*lfold):max(k*lfold,m)]
          }
          
          for (nr in 1:nuc){
            
            print(huc[nr])
            
            # Modèle entrainé sur les obs non select dans le pli
            # Modèle testé 'n' fois pour 'nuc' nombre d'unité cachée
            nn <- nn.start(nstart,train.cv[-ridk,],huc[nr],f,lambda=lambda_opti) # decay LASSO -> 0.0001304285
            
            # on teste le modèle sur le pli sélectionné
            pr.nn2 <- predict(nn, train.cv[ridk,c(-1,-ncol(train.cv))], type="raw")
            
            # Evaluation of cost fcts for each model neg-log-like
            # Calcul du % de déviance
            nlls.nr <- -sum(train.cv$Assec[ridk]*log(pr.nn2[,1]+10^(-9))+train.cv$Assec.C2[ridk]*log(pr.nn2[,2]+10^(-9)))
            # Matrice resultats
            # ligne = pli / col = unité cachée
            negloglike[k,nr] <- nlls.nr
            
          }  # nuc loop
        } # nfold loop
        
        values<-apply(negloglike,2,sum)
        output=rbind(output,values)
        mean(negloglike,na.omit=T)
        # plot(huc,apply(negloglike,2,sum))
        # }
        
        # on repère l'unité cachée qui permet d'obtenir le meilleur score
        rep=which(apply(negloglike,2,mean,na.rm=T)==min(apply(negloglike,2,mean,na.rm=T)))
        
        # Faire une boucle permettant de déterminer le seuil optimal
        nstart2=30
        nn_opti <- nn.start(nstart2,train.cv,huc[rep],f,lambda=lambda_opti)
        y_test <- predict(nn_opti, train.cv[,c(-1,-ncol(train.cv))], type="raw")
        
        yhat <- predict(nn_opti, test.cv[,c(-1,-ncol(train.cv))], type="raw")
        
        # Faire une boucle permettant de calculer le F score sur le jeu test
        
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
          ligne = ligne+1
          compt = 0
          yhat_seuil = vector()
          TP = 0
          FP = 0
          FN = 0
          TN = 0
          
          for (id in 1:nrow(y_test)){
            if (y_test[id,1] > seuil){
              yhat_seuil[id]=1
              compt=compt+1
            } else if (y_test[id,1] < seuil){
              yhat_seuil[id]=0
              compt=compt+1
            } else {
              yhat_seuil[id]=y_test[id,1]
            }
            
            if(yhat_seuil[id]==1 & train.cv[id,1]==1){
              TP=TP+1
            } else if (yhat_seuil[id]==1 & train.cv[id,1]==0){
              FP=FP+1
            } else if (yhat_seuil[id]==0 & train.cv[id,1]==1){
              FN=FN+1
            } else if (yhat_seuil[id]==0 & train.cv[id,1]==0){
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
        
        # for (code_ONDE in liste_st){
        if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_Matrice_2017/Input_test_classif_HER_",HERc,"_30_jours_fin_caract_new_meteo_FINAL.txt",sep=""))){
          
          # loading des input de la station à prédire:
          donnees_st<-read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_Matrice_2017/Input_test_classif_HER_",HERc,"_30_jours_fin_caract_new_meteo_FINAL.txt",sep=""), sep=";", header = T, quote="", stringsAsFactors=F)
          
          #  On va rechercher les PDrying dans les valeurs d'entrainement calculées entre 2012 et 2016
          for (r in 1:nrow(donnees_st)){
            cod=which(donnees[,1]==donnees_st[r,1] & format(as.Date(donnees[,3], "%d/%m/%Y"),"%m")==format(as.Date(donnees_st[r,3], "%Y-%m-%d"),"%m"))
            if(length(cod)>0){
              donnees_st[r,126]=donnees[cod[1],126]
            } else {
              donnees_st[r,126]=NA
            }
          }
          
          select_st <- which(donnees_st[,126]>=0)
          
          if(test_piezo==0){
            x.data_st <- cbind(donnees_st[select_st,127],donnees_st[select_st,7:(7+j)],donnees_st[select_st,38:(38+j)],donnees_st[select_st,69:(69+j)],donnees_st[select_st,100:(100+10)],donnees_st[select_st,112:(112+10)],donnees_st[select_st,126],donnees_st[select_st,2],donnees_st[select_st,5:6],donnees_st[select_st,128],donnees_st[select_st,130])
            col_data=ncol(x.data_st)
          } else if (test_piezo==1){
            x.data_st=cbind(donnees_st[select_st,127],donnees_st[select_st,7:(7+j)],donnees_st[select_st,38:(38+j)],donnees_st[select_st,69:(69+j)],donnees_st[select_st,100:(100+10)],donnees_st[select_st,126],donnees_st[select_st,2],donnees_st[select_st,5:6],donnees_st[select_st,128],donnees_st[select_st,130])
            col_data=ncol(x.data_st)
          }
          
          # On retire du jeu de données les lignes où un NA est présent
          compteur=0
          data_st=data.frame()
          
          # Si on garde les variables au jour
          for (i in 1:nrow(x.data_st)){
            if(!is.na(mean(as.numeric(x.data_st[i,])))){
              compteur = compteur+1
              data_st = rbind(data_st,x.data_st[i,])
              date_fin[compteur,1] = date[i]
              
              # Moyenne par jour 
              data_st[compteur,(4)] = sum(x.data_st[i,(2:12)]) # PRCP cumul 10 jours
              data_st[compteur,(5)] = sum(x.data_st[i,(2:22)]) # PRCP cumul 20 jours
              data_st[compteur,(6)] = sum(x.data_st[i,(2:32)]) # PRCP cumul 30 jours
              data_st[compteur,(7)] = x.data_st[i,33] # ETP cumul jour j
              data_st[compteur,(8)] = x.data_st[i,34] # ETP cumul jour j-1
              data_st[compteur,(9)] = sum(x.data_st[i,(33:43)]) # ETP cumul 10 jours
              data_st[compteur,(10)] = sum(x.data_st[i,(33:53)]) # ETP cumul 20 jours
              data_st[compteur,(11)] = sum(x.data_st[i,(33:63)]) # ETP cumul 30 jours
              data_st[compteur,(12)] = x.data_st[i,64] # TA cumul jour j
              data_st[compteur,(13)] = x.data_st[i,65] # TA cumul jour j-1
              
              data_st[compteur,(14)] = mean(as.numeric(x.data_st[i,(64:74)])) # TA cumul 10 jours
              data_st[compteur,(15)] = mean(as.numeric(x.data_st[i,(64:84)])) # TA cumul 20 jours
              data_st[compteur,(16)] = mean(as.numeric(x.data_st[i,(64:94)])) # TA cumul 30 jours
              
              data_st[compteur,(17)] = (as.numeric(x.data_st[i,95])) # Freq au non depassement jour j
              data_st[compteur,(18)] = mean(as.numeric(x.data_st[i,95:100])) # Freq au non depassement moy j5
              data_st[compteur,(19)] = mean(as.numeric(x.data_st[i,95:105])) # Freq au non depassement moy j10
              
              if(test_piezo==0){
                data_st[compteur,(20)] = (as.numeric(x.data_st[i,106])) # Freq au non depassement jour j
                data_st[compteur,(21)] = mean(as.numeric(x.data_st[i,106:111])) # Freq au non depassement moy j5
                data_st[compteur,(22)] = mean(as.numeric(x.data_st[i,106:116])) # Freq au non depassement moy j10
              }
            }
          }
          
          if (nrow(data_st)>0){
            if(test_piezo==0){
              data_st=data_st[,-c(23:116)] # on supprime les variables non utilisées
              colnames(data_st)=c("Assec","PRCP_J","PRCP_J1","PRCP_J10","PRCP_J20","PRCP_J30","ETP_J","ETP_J1","ETP_J10","ETP_J20","ETP_J30","TA_J","TA_J1","TA_J10","TA_J20","TA_J30","FreqQ_j","FreqQ_j5","FreqQ_j10","FreqGW_j","FreqGW_j5","FreqGW_j10","P_DRYING_M","Altitude","AI","REC_HIV","Aire","Pente")
            } else if (test_piezo==1){
              data_st=data_st[,-c(20:105)] # on supprime les variables non utilisées
              colnames(data_st)=c("Assec","PRCP_J","PRCP_J1","PRCP_J10","PRCP_J20","PRCP_J30","ETP_J","ETP_J1","ETP_J10","ETP_J20","ETP_J30","TA_J","TA_J1","TA_J10","TA_J20","TA_J30","FreqQ_j","FreqQ_j5","FreqQ_j10","P_DRYING_M","Altitude","AI","REC_HIV","Aire","Pente")
            }
            
            scaled_bis <- as.data.frame(scale(data_st, center = mins, scale = maxs - mins))
            
            # Si toutes les obs sont de même statut et de 0
            if (length(unique(data_st[,1]))==1 & data_st[1,1]==0){
              scaled_bis[1:nrow(data_st),1]=0 # pour éviter de générer des NaN dans "scaled"
            }
            
            # Si toutes les P_Drying sont à 0
            if(test_piezo==0){
              if (length(unique(data_st[,1]))==1 & data_st[1,23]==0){
                scaled_bis[1:nrow(data_st),23]=0
              }
            } else if (test_piezo==1){
              if (length(unique(data_st[,1]))==1 & data_st[1,20]==0){
                scaled_bis[1:nrow(data_st),20]=0
              }
            }
            
            scaled_bis=scaled_bis[,-1]
            scaled.prd <- as.matrix(scaled_bis)
            yhat <- predict(nn_opti, scaled.prd, type="raw")
            
            seuil = seuil_opti
            
            if(test_piezo==0){
              col_pred=29
            } else if (test_piezo==1){
              col_pred=26
            }
            
            # On reprend le seuil optimal pour recalculer les scores
            TP=0
            FP=0
            FN=0
            TN=0
            
            for (id in 1:nrow(yhat)){
              if (yhat[id,1] > seuil){
                data_st[id,col_pred]=1
              } else if (yhat[id,1] <= seuil){
                data_st[id,col_pred]=0
              } else {
                data_st[id,col_pred]=NA
              }
              if(data_st[id,col_pred]==1 & data_st[id,1]==1){
                TP=TP+1
              } else if (data_st[id,col_pred]==1 & data_st[id,1]==0){
                FP=FP+1
              } else if (data_st[id,col_pred]==0 & data_st[id,1]==1){
                FN=FN+1
              } else if (data_st[id,col_pred]==0 & data_st[id,1]==0){
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
            accuracy <- ((TP+TN)/nrow(yhat))*100
            precision <- TP/(TP+FP)
            Recall <- TP/(TP+FN)
            F1.score <- (2*precision*Recall)/(precision+Recall)
            
            critere = data.frame(cbind(HERc,POD,FAR,precision,Recall,F1.score,seuil_opti[1]))
            
            for (obs in 1:nrow(data_st)){
              data_st[obs,(col_pred+1)]<-donnees_st[obs,4]
              data_st[obs,(col_pred+2)]<-as.character(donnees_st[obs,3])
            }
            
            colnames(data_st)[col_pred:(col_pred+2)]<-c("Prediction","Q_obs","Date")
            write.table(data_st,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/ANN/J30_FRANCE_2017/Output_ANN_",HERc,"_2017_v2.csv", sep=""), sep=";", row.names = F, col.names = T)
          } # Set data ONDE existe
          critere_full = data.frame(rbind(critere_full,critere))
        } # Boucle matrice input exist
        # } # Boucle station ONDE
        
        T2 <- Sys.time()
        Tdiff <- difftime(T2, T1)
        print(Tdiff)
      } # test si matrice data a des valeurs
    } # test présence d'assec observés
  } # test si matrice input existe
  }
} # Boucle HER

colnames(critere_full)=c("HERc","POD", "FAR","Precision","Recall","F1_score","seuil_opti")
write.table(critere_full,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/ANN/J30_FRANCE_2017/Criteres_ANN_",HERc,"_2017_v2.csv", sep=""), sep=";", row.names = F, col.names = T)
