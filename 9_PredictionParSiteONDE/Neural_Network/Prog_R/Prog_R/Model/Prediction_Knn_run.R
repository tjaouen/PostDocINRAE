# Classification Knn
# appliquée aux sites ONDE situés dans HER 97

rm(list=ls())

T1<-Sys.time()

library(plyr)
library(MASS)
library(class)
library(gmodels)

# list_year=c(2012, 2013, 2014, 2015, 2016)
list_year=c("")
list_param=c(27)

k=10

donnees <- read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_test_classif_HER_97_30_jours_fin_caract_new_meteo_HYDRO_ONLY.txt", sep=";", header = T, quote="", stringsAsFactors=F)

select=which(donnees[,114]>=0)
liste_st<-sort(unique(as.character(donnees[,1])))

for (code_ONDE in liste_st){
  for (year_test in list_year){
    
    if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Var_exp_station_NEW_30J_HYDRO_ONLY/Input_",code_ONDE,"_HYDRO_ONLY.txt",sep=""))){
      
      for (j in 30){
        
        for (param in list_param){
          
          # 1. Preparing the dataset
          data_ini <- cbind(donnees[select,115],donnees[select,7:(7+j)],donnees[select,38:(38+j)],donnees[select,69:(69+j)],donnees[select,100:(100+10)],donnees[select,114],donnees[select,2],donnees[select,5:6],donnees[select,116],donnees[select,118])#
          
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
              
              # data[compteur,(2+j+d+1)] = sum(data_ini[i,((2+j+1):(2+j+d+1))]) # ETP
              # data[compteur,(2+j*2+d+2)] = mean(as.numeric(data_ini[i,((2+j*2+2):(2+j*2+d+2))])) # TA
            }
          }
          # data=data[,-c(17:94)] # on supprime les variables non utilisées
          data=data[,-c(20:105)] # on supprime les variables non utilisées
          # colnames(data)=c("Assec","PRCP_J","PRCP_J1","PRCP_J10","PRCP_J20","PRCP_J30","ETP_J","ETP_J1","ETP_J10","ETP_J20","ETP_J30","TA_J","TA_J1","TA_J10","TA_J20","TA_J30","Freq_j","Freq_j1","Freq_j2","Freq_j3","Freq_j4","Freq_j5","Freq_j6","Freq_j7","Freq_j8","Freq_j9","Freq_j10","ZEROQUAL","Altitude","AI","REC_HIV","Aire","Pente")
          colnames(data)=c("Assec","PRCP_J","PRCP_J1","PRCP_J10","PRCP_J20","PRCP_J30","ETP_J","ETP_J1","ETP_J10","ETP_J20","ETP_J30","TA_J","TA_J1","TA_J10","TA_J20","TA_J30","Freq_j","Freq_j5","Freq_j10","ZEROQUAL","Altitude","AI","REC_HIV","Aire","Pente")
          
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
          
          # loading des input de la station à prédire:
          donnees_st<-read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Var_exp_station_NEW_30J_HYDRO_ONLY/Input_",code_ONDE,"_HYDRO_ONLY.txt",sep=""), sep=";", header = T, quote="", stringsAsFactors=F)
          
          x.data_st <- cbind(donnees_st[,7:(7+j)],donnees_st[,38:(38+j)],donnees_st[,69:(69+j)],donnees_st[,100:(100+10)])
          # x.data_st<-cbind(donnees_st[,7:(7+j)],donnees_st[,18:(18+j)],donnees_st[,29:(29+j)],donnees_st[,40:(40+j)])
          
          zerocal <- which(as.character(donnees[,1])==code_ONDE)
          x.data_st[1:nrow(x.data_st),105] <- donnees[zerocal[1],114]#ZEROCAL
          x.data_st[1:nrow(x.data_st),106] <- donnees[zerocal[1],2]#ALTI
          
          for (annee in 2012:2016){
            AI <- which(as.character(donnees[,1])==code_ONDE & substr(as.character(donnees[,3]),7,10)==annee)
            repere <- which(substr(as.character(donnees_st[,3]),7,10)==annee)
            
            for (i in 1:length(repere)){
              x.data_st[repere[i],107] <- donnees[AI[1],5]
              x.data_st[repere[i],108] <- donnees[AI[1],6]
            }
          }
          x.data_st[1:nrow(x.data_st),109] <- donnees[zerocal[1],116] # Aire
          x.data_st[1:nrow(x.data_st),110] <- donnees[zerocal[1],118] # Pente
          # x.data_st[1:nrow(x.data_st),31] <- donnees[zerocal[1],58]
          
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
            }
          }
          
          data_st <- data_st[,-c(19:104)] # on supprime les variables non utilisées
          
          if (nrow(data_st)>0){
            
            # colnames(data_st)=c("PRCP_J","PRCP_J1","PRCP_J2","PRCP_J3","PRCP_J4","PRCP_J5","ETP_J","ETP_J1","ETP_J2","ETP_J3","ETP_J4","ETP_J5","TA_J","TA_J1","TA_J2","TA_J3","TA_J4","TA_J5","Freq_j","Freq_j1","Freq_j2","Freq_j3","Freq_j4","Freq_j5","ZeroCal")
            colnames(data_st)=c("PRCP_J","PRCP_J1","PRCP_J10","PRCP_J20","PRCP_J30","ETP_J","ETP_J1","ETP_J10","ETP_J20","ETP_J30","TA_J","TA_J1","TA_J10","TA_J20","TA_J30","Freq_j","Freq_j5","Freq_j10","ZEROQUAL","Altitude","AI","REC_HIV","Aire","Pente")
            
            # We therefore scale and split the data before moving on :
            # maxs <- apply(data_st, 2, max)
            # mins <- apply(data_st, 2, min)
            
            scaled_bis <- as.data.frame(scale(data_st, center = mins[2:length(maxs)], scale = maxs[2:length(maxs)] - mins[2:length(maxs)]))
            scaled.prd <- as.matrix(scaled_bis)
            # scaled <- scaled[,-1]
            # colnames(scaled)[25] <- "ZeroCal"
            yhat <- knn(train = train[,2:ncol(train)], test = scaled.prd, cl = train[,1],  k=k)
            
            for (id in 1:length(yhat)){
              data_st[id,25] <- yhat[id]
            }
            colnames(data_st)[25] <- c("Prediction")
            # write.table(donnees_st,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/Knn/J5_",year_test,"/Output_Knn_",code_ONDE,"_",year_test,".csv", sep=""), sep=";", row.names = F, col.names = T)
            write.table(data_st,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/Knn/J30_moy_HYDRO_ONLY/Output_Knn_",code_ONDE,".csv", sep=""), sep=";", row.names = F, col.names = T)
          }
        } # boucle liste param
      } # boucle j
      T2<-Sys.time()
      Tdiff = difftime(T2, T1)
      print(Tdiff)
    } # boucle file exist
  } # boucle list year
} # boucle stations ONDE
