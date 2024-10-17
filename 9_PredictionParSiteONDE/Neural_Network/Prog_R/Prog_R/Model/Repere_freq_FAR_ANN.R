# recherche les prédictions ANN et regarde 
# a quel Freq au non dépassement correspond le débit
# lorsqu'un assec est observé

rm(list=ls())

nom_data <- paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Liste_station_4_HER_SELECT_NEW.csv",sep="")
liste_HYDRO <- read.table(file = nom_data, header = TRUE, sep = ";",  row.names = NULL, quote="")

for (ind in 1:nrow(liste_HYDRO)){ # 1:nrow(liste_HYDRO)
  compt=0
  output<-data.frame()
  if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/ANN/J30_FRANCE_2012_2016_station_HYDRO/Output_ANN_station_HYDRO_",liste_HYDRO[ind,1],"_HER2_",liste_HYDRO[ind,2],".csv",sep=""))==T){
    donnees <- read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/ANN/J30_FRANCE_2012_2016_station_HYDRO/Output_ANN_station_HYDRO_",liste_HYDRO[ind,1],"_HER2_",liste_HYDRO[ind,2],".csv",sep=""), sep=";", header = T, stringsAsFactors=F)
    
    for (l in 1:nrow(donnees)){
      if (donnees$Prediction[l]==1 & (donnees$Q_obs[l]>1) & !is.na(donnees$Q_obs[l])){
        if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/QJHYDRO/FDC_2018/FDC_",liste_HYDRO[ind,1],".txt",sep=""))==T){
          flow<-read.table(paste("C:/Users/aurelien.beaufort/Documents/QJHYDRO/FDC_2018/FDC_",liste_HYDRO[ind,1],".txt",sep=""), sep=";", header = T, quote="", stringsAsFactors=F)
          repere=which(flow[,3]==donnees$Q_obs[l])
          compt=compt+1
          output[compt,1]=donnees$Date[l]
          output[compt,2]=donnees$Q_obs[l]
          output[compt,3]=flow[repere[1],2]
        }
      }
    }
  }
  if (nrow(output)>0){
    colnames(output)<-c("Date","Q_obs","FDC")
    write.table(output,paste("C:/Users/aurelien.beaufort/Documents/Article/Article 2/Figures/Results Pred Station HYDRO/Freq_FAR_ANN/Freq_NonDep_ANN_station_HYDRO_",liste_HYDRO[ind,1],"_HER2_",liste_HYDRO[ind,2],".csv", sep=""), sep=";", row.names = F, col.names = T)
  }
}