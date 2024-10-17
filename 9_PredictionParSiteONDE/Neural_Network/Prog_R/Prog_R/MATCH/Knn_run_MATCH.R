# Classification Knn
# appliquée aux sites ONDE situés dans HER 97

rm(list=ls())

T1<-Sys.time()

library(plyr)
library(MASS)
library(class)
library(gmodels)

list_year=c(2012, 2013, 2014, 2015, 2016)
list_param=c(27)

list_k=c(10)

donnees <- read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Set_ONDE_HYDRO_Match_HER97_HYDRO_ONLY_MOY.txt", sep=";", header = T, quote="", stringsAsFactors=F)
select=which(donnees[,114]>=0)

for (j in 30){
  for (k in list_k){
    critere_full=data.frame()
    # for (year_test in list_year){
      for (year_test in 1:20){
      for (param in list_param){
        
        # 1. Preparing the dataset
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
        
        # check that no datapoint is missing,
        apply(data,2,function(x) sum(is.na(x)))
        
        # We therefore scale and split the data before moving on:
        maxs <- apply(data, 2, max)
        mins <- apply(data, 2, min)
        scaled <- as.data.frame(scale(data, center = mins, scale = maxs - mins))
        
        # selection_train = which(format(as.Date(date_fin[,1], "%d/%m/%Y"),"%Y")!=as.numeric(year_test))
        # selection_test = which(format(as.Date(date_fin[,1], "%d/%m/%Y"),"%Y")==as.numeric(year_test))
        # train <- as.matrix(scaled[selection_train,])
        # test <- as.matrix(scaled[selection_test,])
        
        selection_train = sample(1:nrow(scaled),round(0.8*nrow(scaled)))
        train <- as.matrix(scaled[selection_train,])
        test <- as.matrix(scaled[-selection_train,])
        
        yhat <- knn(train = train[,2:ncol(train)], test = test[,2:ncol(test)], cl = train[,1],  k=k)
        
        assec <- length(which(test[,1]==1))
        flow <- length(which(test[,1]==0))
        
        TP=0
        FP=0
        FN=0
        TN=0
        for (id in 1:length(yhat)){
          if(yhat[id]==1 & test[id]==1){
            TP=TP+1
          } else if (yhat[id]==1 & test[id]==0){
            FP=FP+1
          } else if (yhat[id]==0 & test[id]==1){
            FN=FN+1
          } else if (yhat[id]==0 & test[id]==0){
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
        
        critere = data.frame(cbind(POD,FAR,accuracy,precision,Recall,F1.score,year_test,assec,flow))
        critere_full = data.frame(rbind(critere_full,critere))

      } # boucle liste param
    } # boucle année test
    
    colnames(critere_full) <- c("POD", "FAR","Accuracy","Precision","Recall","F1_score","year_test","Assec","Flow")
    write.table(critere_full,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Knn/Résultats_locaux_HER_97/critere_2012_2016_FULL_j",j,"_k_",k,"_new_meteo_all_caract_RANDOM_MATCH.csv", sep=""), sep=";", row.names = F, col.names = T)
  } # boucle k voisin
} # boucle j

T2<-Sys.time()
Tdiff = difftime(T2, T1)
print(Tdiff)
