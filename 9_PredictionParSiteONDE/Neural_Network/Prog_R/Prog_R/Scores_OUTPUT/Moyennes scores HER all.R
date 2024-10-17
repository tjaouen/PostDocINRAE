#
# Script permet de calculer les scores des prédictions 
# de toutes les HER et de trouver les meilleurs lambda 
# à utiliser pour les prédictions

rm(list=ls())
nb_paramter=27

lambda=c("_0_2","_0_0001","_0_1","_0_01","_0_001")
# lambda=c("_0_2","_0_0001")
HER2 <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/HER/Hydroecoregion2_group.csv",sep=";",header=T,quote="")
for (l in lambda){
  output<-data.frame()
  for (HERc in HER2[1:85,3]){
    if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/Lambda",l,"/critere_seuils_opti_FULL_moy_j30_new_meteo_all_caract_NEW_decay",l,"_HER_",HERc,"_RANDOM_FINAL.csv",sep=""))==T){
      donnees <- read.table((paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/Lambda",l,"/critere_seuils_opti_FULL_moy_j30_new_meteo_all_caract_NEW_decay",l,"_HER_",HERc,"_RANDOM_FINAL.csv",sep="")), sep=";", header = T, quote="", stringsAsFactors=F)
      poids <- read.table((paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/Lambda",l,"/Poids_seuils_opti_test_2012_2016_FULL_moy_j30_new_meteo_all_caract_NEW_decay",l,"_HER_",HERc,"_RANDOM_FINAL.csv",sep="")), sep=";", header = T, quote="", stringsAsFactors=F)
      critere<-apply(donnees,2,function(x) mean(x, na.rm = T))
      
      output=rbind(output,critere)
      output[nrow(output),(length(critere)+1)]<-HERc
      if (nrow(poids)==56){
        output[nrow(output),(length(critere)+2)]<-0
      } else if (nrow(poids)==86){
        output[nrow(output),(length(critere)+2)]<-1
      } else if (nrow(poids)==116){
        output[nrow(output),(length(critere)+2)]<-2
      } else if (nrow(poids)==176){
        output[nrow(output),(length(critere)+2)]<-4
      } else if (nrow(poids)==236){
        output[nrow(output),(length(critere)+2)]<-6
      } else if (nrow(poids)==296){
        output[nrow(output),(length(critere)+2)]<-8
      }
    }
  }
  output<-output[,-9]
  colnames(output)<-c("POD","FAR","AUC","Precision","Recall","Fscore","BrierScore","Seuil_opti","Nb_assec","Nb_flow","HER2","UC")
  write.table(output,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/Scores_ALL_HER_Lambda",l,".csv",sep=""), sep=";", col.names=T, row.names = F)
}

output2<-data.frame()
lambda=c("_0_2","_0_0001","_0_1","_0_01","_0_001")
lambda_num=c(0.2,0.0001,0.1,0.01,0.001)

for (l in 1:length(lambda)){
  donnees2 <- read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/Scores_ALL_HER_Lambda",lambda[l],".csv",sep=""), sep=";", header = T, quote="", stringsAsFactors=F)
  
  for (i in 1:nrow(donnees2)){
    if (lambda[l]=="_0_2"){
      output2[i,1]<-donnees2[i,11]
      output2[i,2]<-donnees2[i,6]
      output2[i,3]<-lambda_num[l]
    } else if (is.na(output2[i,2])){
      output2[i,2]<-donnees2[i,6]
      output2[i,3]<-lambda_num[l]
    } else {
      if (!is.na(donnees2[i,6]) & donnees2[i,6] > output2[i,2]){
        output2[i,2]<-donnees2[i,6]
        output2[i,3]<-lambda_num[l]
      }
    }
  }
}

write.table(output2,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/Scores_ALL_HER_Lambda_best.csv",sep=""), sep=";", col.names=T, row.names = F)

