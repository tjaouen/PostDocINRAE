# test neural network
library(neuralnet)
library(plyr)
library(MASS)
library(pROC)
library(nnet)

rm(list=ls())

T1<-Sys.time()

year_test=c(2012, 2013, 2014, 2015, 2016)
list_param=c(27)

donnees <- read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Set_ONDE_HYDRO_Match_HER97_HYDRO_ONLY_MOY.txt", sep=";", header = T, quote="", stringsAsFactors=F)
select <- which(donnees[,114]>=0)

j=30

critere_full=data.frame()
output<-data.frame()

# 1. Preparing the dataset
# 27 param 
data_ini <- cbind(donnees[select,115],donnees[select,7:(7+j)],donnees[select,38:(38+j)],donnees[select,69:(69+j)],donnees[select,119:124],donnees[select,114],donnees[select,2],donnees[select,5:6],donnees[select,116],donnees[select,118]) #

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
    data[compteur,(18)] = (as.numeric(data_ini[i,96])) # Freq au non depassement jour j mean(as.numeric(data_ini[i,95:100])) # Freq au non depassement moy j5
    data[compteur,(19)] = (as.numeric(data_ini[i,97])) # Freq au non depassement jour j mean(as.numeric(data_ini[i,95:105])) # Freq au non depassement moy j10
  }
}

data=data[,-c(20:100)] # On supprime les variables non utilisées
colnames(data)=c("Assec","PRCP_J","PRCP_J1","PRCP_J10","PRCP_J20","PRCP_J30","ETP_J","ETP_J1","ETP_J10","ETP_J20","ETP_J30","TA_J","TA_J1","TA_J10","TA_J20","TA_J30","Freq_j","Freq_j5","Freq_j10","ZEROQUAL","Altitude","AI","REC_HIV","Aire","Pente")

# data=data[,-c(17:94)] # on supprime les variables non utilisées
# colnames(data)=c("Assec","PRCP_J","PRCP_J1","PRCP_J10","PRCP_J20","PRCP_J30","ETP_J","ETP_J1","ETP_J10","ETP_J20","ETP_J30","TA_J","TA_J1","TA_J10","TA_J20","TA_J30","Freq_j","Freq_j1","Freq_j2","Freq_j3","Freq_j4","Freq_j5","Freq_j6","Freq_j7","Freq_j8","Freq_j9","Freq_j10","ZEROQUAL","Altitude","AI","REC_HIV","Aire","Pente")

# check that no datapoint is missing,
apply(data,2,function(x) sum(is.na(x)))

# We therefore scale and split the data before moving on:
maxs <- apply(data, 2, max)
mins <- apply(data, 2, min)
scaled <- as.data.frame(scale(data, center = mins, scale = maxs - mins))

# for (annee in year_test){
for (annee in 1:20){
  
  print(annee)

  # selection_train = which(format(as.Date(date_fin[,1], "%d/%m/%Y"),"%Y")!=annee)
  # selection_test = which(format(as.Date(date_fin[,1], "%d/%m/%Y"),"%Y")==annee)
  # train.cv <- scaled[selection_train,]
  # test.cv <- scaled[selection_test,]
  # train.cv$Assec.C2 <- 1-train.cv$Assec
  # test.cv$Assec.C2 <- 1-test.cv$Assec

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
  
  f <- (cbind(Assec,Assec.C2) ~ PRCP_J + PRCP_J1 + PRCP_J10 + PRCP_J20 + PRCP_J30 + ETP_J + 
          ETP_J1 + ETP_J10 + ETP_J20 + ETP_J30 + TA_J + TA_J1 + TA_J10 + 
          TA_J20 + TA_J30 + Freq_j + Freq_j5 + Freq_j10 + ZEROQUAL + 
          Altitude + AI + REC_HIV + Aire + Pente)
  
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
  
  # rep=NULL
  # rep.min.val=NULL
  # nn.min<-nn.start(5,train.cv,4,f,lambda=0.01)
  # 
  # rep <- cbind(rep,fitted(nn.min)[,1])
  # rep.min.val<- cbind(rep.min.val,nn.min$value)
  # plot(rep[,1],rep[,2])
  # 
  # plot(train.cv$Assec, rep[,4])
  # plot(rep[,4])
  # points(which(train.cv$Assec==1),rep[train.cv$Assec==1,4],col="red")
  
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
      nn <- nn.start(nstart,train.cv[-ridk,],huc[nr],f,lambda=0.001) # decay LASSO -> 0.0001304285
      
      # on teste le modèle sur le pli sélectionné
      pr.nn2 <- predict(nn, train.cv[ridk,c(-1,-26)], type="raw")
      
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
  nn_opti <- nn.start(nstart2,train.cv,huc[rep],f,lambda=0.001)
  y_test <- predict(nn_opti, train.cv[,c(-1,-26)], type="raw")
  
  yhat <- predict(nn_opti, test.cv[,c(-1,-26)], type="raw")
  
  # Faire une boucle permettant de calculer le F score sur le jeu test
  AUC<-NULL
  TRH_ROC<-NULL
  my_roc <- roc(test.cv[,1], yhat[,1])
  AUC = my_roc$auc
  
  # Brier score
  somme1 <- 0
  brier1 <- NULL
  
  for (b in 1:nrow(yhat)){
    somme1=somme1+(yhat[b,1]-test.cv[b,1])^2
  }
  brier1=somme1/nrow(yhat)
  
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
  
  # On recherche le seuil optimal calé sur le F.score
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
  
  for (id in 1:nrow(yhat)){
    if (yhat[id,1] > seuil_opti){
      yhat[id,1]=1
    } else if (yhat[id,1] < seuil_opti){
      yhat[id,1]=0
    } else {
      yhat[id,1]=yhat[id,1]
    }
    if(yhat[id,1]==1 & test.cv[id,1]==1){
      TP=TP+1
    } else if (yhat[id,1]==1 & test.cv[id,1]==0){
      FP=FP+1
    } else if (yhat[id,1]==0 & test.cv[id,1]==1){
      FN=FN+1
    } else if (yhat[id,1]==0 & test.cv[id,1]==0){
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
  
  critere = data.frame(cbind(POD,FAR,AUC,precision,Recall,F1.score,brier1,seuil_opti,annee,assec,flow)) #,mod$bestTune
  # colnames(critere) <- c("POD", "FAR","Accuracy","Precision","Recall","F1_score")
  # write.table(critere,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Random_forest/Résultats_locaux_HER_97/critere_",param,"var_test_",year_test,"_bis.csv", sep=""), sep=";", row.names = F, col.names = T)
  # colnames(critere) <- c("POD", "FAR","Accuracy","Precision","Recall","F1_score","year_test","Nb_param")
  critere_full = data.frame(rbind(critere_full,critere))
  
  # compt2=compt2+1
  # for (q in 1:length(fit$importance)){
  #   coefficient[q,compt2] <- fit$importance[q]
  # }
  
  # Faire une boucle globale permettant de faire varier lambda
  
} # Boucle annee test

# colnames(output)=c("0","1","2","3","4","5","6","8")
# write.table(output,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/Résultats_locaux_HER_97/Test_stabilite_ANN_Deviance_Random_decay_0_1.csv", sep=""), sep=";", row.names = F, col.names = T)

colnames(critere_full) <- c("POD", "FAR","AUC","Precision","Recall","F1_score","Brier","seuil_opti","year_test","Nb_Assec","Nb_Flow") #
write.table(critere_full,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/Résultats_locaux_HER_97/critere_seuils_opti_test_2012_2016_FULL_moy_j",j,"_new_meteo_all_caract_NEW_decay_0_01_RANDOM_MATCH.csv", sep=""), sep=";", row.names = F, col.names = T)

write.table(nn_opti$wts,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/Résultats_locaux_HER_97/Poids_seuils_opti_test_2012_2016_FULL_moy_j",j,"_new_meteo_all_caract_NEW_decay_0_01_RANDOM_MATCH.csv", sep=""), sep=";", row.names = F)

# colnames(coefficient) <- c("2012","2013","2014","2015","2016")
# write.table(coefficient,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Random_forest/Résultats_locaux_HER_97/Coefficient_2012_2016_FULL_moy_j",j,"_new_meteo_all_caract_test1_random.csv", sep=""), sep=";", row.names = F, col.names = T)

T2 <- Sys.time()
Tdiff <- difftime(T2, T1)
print(Tdiff)
# } # boucle année test