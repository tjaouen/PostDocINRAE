#-------------------------------------------------------------
# Calcul les proportions d'assecs prédites aux sites ONDE
# par les différents modèles LASSO/Knn/ANN/RF et compare 
# ces valeurs aux observations ONDE période entre 2012 et 2016
#-------------------------------------------------------------

library(pROC)

rm(list=ls())

nom_data <- paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Liste_station_4_HER_SELECT_NEW.csv",sep="")
liste_HYDRO <- read.table(file = nom_data, header = TRUE, sep = ";",  row.names = NULL, quote="")

output <- data.frame()
compteur <- 0
all_year=0
#c("LASSO","ANN", "Random_Forest")

methode="Random_Forest"

for (code_HYDRO in liste_HYDRO$Station){
  compteur=compteur+1
  HERc=liste_HYDRO$HER2[compteur]
  
  if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/",methode,"/J30_FRANCE_2012_2016_station_HYDRO/Output_RF_station_HYDRO_",code_HYDRO,"_HER2_",HERc,".csv",sep=""))){
    donnees <- read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/",methode,"/J30_FRANCE_2012_2016_station_HYDRO/Output_RF_station_HYDRO_",code_HYDRO,"_HER2_",HERc,".csv",sep=""), sep=";", header = T, quote="", stringsAsFactors=F)
    
    # On en prend pas en compte les NA
    select=which(!is.na(donnees[,(ncol(donnees)-1)]) & !is.na(donnees[,(ncol(donnees)-2)]))
    
    DryObs=which(donnees[select,(ncol(donnees)-1)]<=1)
    DryPred=which(donnees[select,(ncol(donnees)-2)]==1)
    
    liste_HYDRO[compteur,4]=length(DryObs)/length(select)*100
    liste_HYDRO[compteur,5]=length(DryPred)/length(select)*100
  } else {
    liste_HYDRO[compteur,4]=NA
    liste_HYDRO[compteur,5]=NA
  }
}

colnames(liste_HYDRO)[4:5] <- c("PropOBS","PropPRED")
write.table(liste_HYDRO,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/",methode,"/Scores_stations_HYDRO/Prop_assec_Obs_vs_PRED_RF_Station_new_HYDRO.csv", sep=""), sep=";", row.names = F, col.names = T)
