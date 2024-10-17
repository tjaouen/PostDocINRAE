# Permet de sortir les fscore moyens par HER2 dans la France

rm(list=ls())
nb_paramter=27
# Random Forest
output<-data.frame()
HER2 <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/HER/Hydroecoregion2_group.csv",sep=";",header=T,quote="")

for (HERc in HER2[1:85,3]){
  if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Random_forest/Résultats_locaux_FRANCE/critere_seuils_opti_test_2012_2016_FULL_moy_j30_new_meteo_all_caract_HER_",HERc,"_RANDOM_FINAL.csv.csv",sep=""))==T){
    donnees <- read.table((paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Random_forest/Résultats_locaux_FRANCE/critere_seuils_opti_test_2012_2016_FULL_moy_j30_new_meteo_all_caract_HER_",HERc,"_RANDOM_FINAL.csv.csv",sep="")), sep=";", header = T, quote="", stringsAsFactors=F)
    # poids <- read.table((paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Random_forest/Résultats_locaux_FRANCE/Poids_seuils_opti_test_2012_2016_FULL_moy_j30_new_meteo_all_caract_NEW_decay",l,"_HER_",HERc,"_RANDOM_FINAL.csv",sep="")), sep=";", header = T, quote="", stringsAsFactors=F)
    critere <- apply(donnees,2,function(x) mean(x, na.rm = T))
    
    output=rbind(output,critere)
    output[nrow(output),(length(critere)+1)]<-HERc

  }
}
output<-output[,-9]
colnames(output)<-c("POD","FAR","AUC","Precision","Recall","Fscore","BrierScore","Seuil_opti","Nb_assec","Nb_flow","HER2")
write.table(output,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Random_forest/Scores_ALL_HER_RF_France.csv",sep=""), sep=";", col.names=T, row.names = F)

# LASSO 
output<-data.frame()
HER2 <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/HER/Hydroecoregion2_group.csv",sep=";",header=T,quote="")

for (HERc in HER2[1:85,3]){
  if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Ridge_Lasso_Elastic_net/Résultats_locaux_FRANCE/critere_2012_2016_FULL_moy_j30_new_meteo_all_caract_HER_",HERc,"_RANDOM_FINAL.csv",sep=""))==T){
    donnees <- read.table((paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Ridge_Lasso_Elastic_net/Résultats_locaux_FRANCE/critere_2012_2016_FULL_moy_j30_new_meteo_all_caract_HER_",HERc,"_RANDOM_FINAL.csv",sep="")), sep=";", header = T, quote="", stringsAsFactors=F)
    # poids <- read.table((paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Random_forest/Résultats_locaux_FRANCE/Poids_seuils_opti_test_2012_2016_FULL_moy_j30_new_meteo_all_caract_NEW_decay",l,"_HER_",HERc,"_RANDOM_FINAL.csv",sep="")), sep=";", header = T, quote="", stringsAsFactors=F)
    critere <- apply(donnees,2,function(x) mean(x, na.rm = T))
    output=rbind(output,critere)
    output[nrow(output),(length(critere)+1)]<-HERc
  }
}
output<-output[,-c(9,10)]
colnames(output)<-c("POD","FAR","AUC","Precision","Recall","Fscore","BrierScore","Seuil_opti","Nb_assec","Nb_flow","HER2")
write.table(output,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Ridge_Lasso_Elastic_net/Scores_ALL_HER_LASSO_France.csv",sep=""), sep=";", col.names=T, row.names = F)

# BENCHMARK MODEL
output<-data.frame()
HER2 <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/HER/Hydroecoregion2_group.csv",sep=";",header=T,quote="")

for (HERc in HER2[1:85,3]){
  if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Modèle_Benchmark/critere_2012_2016_FULL_Modele_benchmark_",HERc,".csv",sep=""))==T){
    donnees <- read.table((paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Modèle_Benchmark/critere_2012_2016_FULL_Modele_benchmark_",HERc,".csv",sep="")), sep=";", header = T, quote="", stringsAsFactors=F)
    # poids <- read.table((paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Random_forest/Résultats_locaux_FRANCE/Poids_seuils_opti_test_2012_2016_FULL_moy_j30_new_meteo_all_caract_NEW_decay",l,"_HER_",HERc,"_RANDOM_FINAL.csv",sep="")), sep=";", header = T, quote="", stringsAsFactors=F)
    critere <- apply(donnees,2,function(x) mean(x, na.rm = T))
    output=rbind(output,critere)
    output[nrow(output),(length(critere)+1)]<-HERc
  }
}
output<-output[,-c(7,8)]
colnames(output)<-c("POD","FAR","Accuracy","Precision","Recall","Fscore","HER2")
write.table(output,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Modèle_Benchmark/Scores_ALL_HER_BENCHMARK_MODEL_France.csv",sep=""), sep=";", col.names=T, row.names = F)
