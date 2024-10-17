liste=read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/Liste_station_HER_97.csv", sep=";", row.names=NULL)
matrice=read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/Matrice_3_modalites_obs_usuelles_ONDE_2012_2016.csv", sep=";", row.names=NULL)
output=data.frame()

for (id in 1:nrow(liste)){
  
  repere=which(as.character(matrice[,1])==as.character(liste[id,1]))
  
  if (length(repere)>0){
    output=rbind(output,matrice[repere,])
  }
}

write.table(output,"C:/Users/aurelien.beaufort/Documents/Neural_Network/Matrice_Station_ONDE_2_modalités_HER_97.csv", sep=";", row.names = F, col.names = F)
