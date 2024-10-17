# Permet de comparer les prédictions des outils statistiques LASSO/ANN/RF/Knn
# aux observations du réseau Poitou Charente sur les drains ou sont situés les sites ONDE

library(pROC)

rm(list=ls())

poc<-read.table("C:/Users/aurelien.beaufort/Documents/SIG/Poitou_Charentes_suivi_2011_2013/rezoref_obs.csv", header = T, sep = ";",  row.names = NULL, quote="")
onde_poc<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/ONDE_vs_POC.csv", header = T, sep = ";",  row.names = NULL, quote="")

date_poc=c("15/06/2012","01/07/2012","15/07/2012","01/08/2012","15/08/2012","01/09/2012","15/09/2012","30/09/2012","15/06/2013","01/07/2013","15/07/2013","01/08/2013","15/08/2013","01/09/2013","15/09/2013","30/09/2013")
col_date = c(16,9,10,11,12,13,14,15,29,30,31,32,33,34,35,36)

m=c("Knn","LASSO","Random_Forest","ANN")
nom=c("Knn","lasso","RF","ANN")
critere_full=data.frame()
output=data.frame()
compt=0

for (methode in m){
  compt=compt+1
  compteur=0
  for (s in 1:nrow(onde_poc)){
    code_ONDE=onde_poc[s,1]
    drain=onde_poc[s,2]
    rep=which(poc[,2]==drain)
    
    if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/",methode,"/J5/Output_",nom[compt],"_",code_ONDE,".csv",sep=""))){
      donnees_st<-read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/",methode,"/J5/Output_",nom[compt],"_",code_ONDE,".csv",sep=""), sep=";", header = T, stringsAsFactors=F)
      
      for (date in 1:length(date_poc)){
        compteur=compteur+1
        output[compteur,1]=code_ONDE
        output[compteur,2]=drain
        output[compteur,3]=date_poc[date]
        
        repere=which(donnees_st[,3]==date_poc[date])
        
        if (length(repere)>0){
          
          if (poc[rep,col_date[date]]=="r" | poc[rep,col_date[date]]=="a"){
            output[compteur,4]=1 # obs Poc
          } else if (poc[rep,col_date[date]]=="e" | poc[rep,col_date[date]]=="ef"){
            output[compteur,4]=0
          } else {
            output[compteur,4]=NA
          }
          
          output[compteur,(4+compt)]=donnees_st[repere,50] #pred
          
        } else {
          output[compteur,4] = NA # pred
          output[compteur,(4+compt)] = NA
        }
      }
    }
  }
  
  # On reprend le seuil optimal pour recalculer les scores
  AUC<-NULL
  TRH_ROC<-NULL
  my_roc <- roc(output[,(4+compt)], output[,4])
  AUC=my_roc$auc
  
  TP=0
  FP=0
  FN=0
  TN=0
  
  for (id in 1:nrow(output)){
    if (!is.na(output[id,(4+compt)]) & !is.na(output[id,4])){
      if(output[id,(4+compt)]==1 & output[id,4]==1){
        TP=TP+1
      } else if (output[id,(4+compt)]==1 & output[id,4]==0){
        FP=FP+1
      } else if (output[id,(4+compt)]==0 & output[id,4]==1){
        FN=FN+1
      } else if (output[id,(4+compt)]==0 & output[id,4]==0){
        TN=TN+1
      }
    }
  }
  
  F1.score <- NULL
  precision <- NULL
  Recall <- NULL
  POD <- NULL
  FAR <- NULL
  
  POD <- (TP/(TP+FN))*100
  FAR <- (FP/(FP+TP))*100
  precision <- TP/(TP+FP)
  Recall <- TP/(TP+FN)
  F1.score <- (2*precision*Recall)/(precision+Recall)
  critere = data.frame(cbind(POD,FAR,AUC,precision,Recall,F1.score))
  critere_full = data.frame(rbind(critere_full,critere))
}
colnames(critere_full) <- c("POD", "FAR","AUC","Precision","Recall","F1_score")
write.table(critere_full,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/critere_validation_POC_2012_2013_FULL_j5.csv", sep=""), sep=";", row.names = F, col.names = T)

colnames(output) <- c("Code_ONDE", "Drain_POC","Date","Obs_POC","Knn","LASSO","RF","ANN")
write.table(output,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/Matrice_validation_POC_2012_2013_FULL_j5.csv", sep=""), sep=";", row.names = F, col.names = T)
