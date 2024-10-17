#--------------------------------
# Comparaison Prédictions vs POC
#--------------------------------

rm(list=ls())

library(pROC)

methode = "Knn" # "ANN" "Random_Forest" "LASSO" "Knn"

POC_2012 <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/Poitou_Charentes_suivi_2011_2013/Onde_vs_POC_2012_Drain_1.csv", sep=";", header = T, stringsAsFactors = F)
POC_2013 <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/Poitou_Charentes_suivi_2011_2013/Onde_vs_POC_2013_Drain_1.csv", sep=";", header = T, stringsAsFactors = F)

liste_date1 <- c("01/07/2012","15/07/2012","01/08/2012","15/08/2012","01/09/2012","15/09/2012","30/09/2012","15/06/2012")
liste_date2 <- c("15/06/2013","01/07/2013","15/07/2013","01/08/2013","15/08/2013","01/09/2013","15/09/2013","30/09/2013")
output=data.frame()
compteur=0

for (l in 1 :nrow(POC_2012)){
  
  code_ONDE<-POC_2012[l,1]
  
  if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/",methode,"/J5_new_meteo/Output_Knn_",code_ONDE,".csv",sep=""))){
    pred=read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/",methode,"/J5_new_meteo/Output_Knn_",code_ONDE,".csv",sep=""),sep = ";", header = T, stringsAsFactors = F)
    
    for (d in 1:8){
      repere=which(as.character(pred[,3])==liste_date1[d])
      
      if (length(repere)>0){
        compteur=compteur+1
        output[compteur,1]=code_ONDE
        output[compteur,2]=liste_date1[d]
        output[compteur,3]=pred[repere,52]
        
        if(as.character(POC_2012[l,(6+d)])=="e" | as.character(POC_2012[l,(6+d)])=="ef"){
          
          output[compteur,4]=0
          
        } else if (as.character(POC_2012[l,(6+d)])=="r" | as.character(POC_2012[l,(6+d)])=="a"){
          output[compteur,4]=1
        } else if  (as.character(POC_2012[l,(6+d)])=="a"){
          output[compteur,4]=NA
        }
      }
    }
    
    for (d in 1:8){
      repere=which(as.character(pred[,3])==liste_date2[d])
      
      if (length(repere)>0){
        compteur=compteur+1
        output[compteur,1]=code_ONDE
        output[compteur,2]=liste_date2[d]
        output[compteur,3]=pred[repere,52]
        
        if(as.character(POC_2013[l,(6+d)])=="e" | as.character(POC_2013[l,(6+d)])=="ef"){
          output[compteur,4]=0
        } else if (as.character(POC_2013[l,(6+d)])=="r" | as.character(POC_2013[l,(6+d)])=="a"){
          output[compteur,4]=1
        } else if  (as.character(POC_2013[l,(6+d)])=="a"){
          output[compteur,4]=NA
        }
      }
    }
  } # file exist
} # ligne station

my_roc1 <- roc(output[,4], output[,3])
AUC1=my_roc1$auc

accuracy1 <- NULL
precision1 <- NULL
Recall1 <- NULL
valeur_seuillee1 <- NULL
POD1 <- NULL
FAR1 <- NULL

TP1=0
FP1=0
FN1=0
TN1=0

for (id in 1:nrow(output)){
  if(!is.na(output[id,4]) & !is.na(output[id,3])){
    if(output[id,3]==1 & output[id,4]==1){
      TP1=TP1+1
    } else if (output[id,3]==1 & output[id,4]==0){
      FP1=FP1+1
    } else if (output[id,3]==0 & output[id,4]==1){
      FN1=FN1+1
    } else if (output[id,3]==0 & output[id,4]==0){
      TN1=TN1+1
    }
  }
}

POD1 <- (TP1/(TP1+FN1))*100
FAR1 <- (FP1/(FP1+TP1))*100
accuracy1 <- ((TP1+TN1)/(TP1+TN1+FP1+FN1))*100
precision1 <- TP1/(TP1+FP1)
Recall1 <- TP1/(TP1+FN1)
F1.score1 <- (2*precision1*Recall1)/(precision1+Recall1)

critere = data.frame(rbind(cbind(POD1,FAR1,AUC1,precision1,Recall1,F1.score1)))
colnames(critere) <- c("POD", "FAR","AUC","Precision","Recall","F_score")
write.table(critere,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/",methode,"/J5_new_meteo/Critère_obs_2012_2016_J5_new_meteo_POC.csv", sep=""), sep=";", row.names = T, col.names = T)
