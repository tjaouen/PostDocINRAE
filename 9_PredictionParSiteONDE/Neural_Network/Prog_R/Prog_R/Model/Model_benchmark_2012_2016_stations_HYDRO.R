#---------------------------------------------
# Modèle benchmark de prédiction des assecs
#---------------------------------------------

rm(list=ls())

list_year=c(2012, 2013, 2014, 2015, 2016)
list_mois=c("05", "06", "07", "08", "09")
param=c(27)

liste_HYDRO <- read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Liste_station_4_HER_SELECT_NEW.csv",sep=";",header=T,quote="")
compteur=0

for (code_HYDRO in liste_HYDRO[,1]){
  
  compteur=compteur+1
  HERc=liste_HYDRO[compteur,2]
  
  if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Var_exp_station_NEW_30J_STATION_HYDRO_NEW/2012_2016/Input_Station_HYDRO_",code_HYDRO,"_HER2_",HERc,".txt",sep=""))){

      donnees_st<-read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Var_exp_station_NEW_30J_STATION_HYDRO_NEW/2012_2016/Input_Station_HYDRO_",code_HYDRO,"_HER2_",HERc,".txt",sep=""), sep=";", header = T, quote="", stringsAsFactors=F)
      
      # on garde : code_station/date/obs
      data<- data.frame(cbind(donnees_st[,1],donnees_st[,3],donnees_st[,4]))
      
      critere_full=data.frame()
      
      for (year_test in list_year){
        compt=0
        for (mois in list_mois){
          compt=compt+1

          # Selection des jeux de données d'entrainement et de validation par année
          selection_train = which((format(as.Date(data[,2], "%d/%m/%Y"),"%Y")!=as.numeric(year_test)) & (format(as.Date(data[,2], "%d/%m/%Y"),"%m%d")==paste(mois,"25",sep="")))
          
          assec=which(as.numeric(data[selection_train,3])<=1)
          flow=which(as.numeric(data[selection_train,3])>1)
          
          if (length(assec)>=length(flow)){
            statut=1
          } else {
            statut=0
          }
          
          repere=which(as.Date(data[,2], "%d/%m/%Y")==paste("25/",mois,"/",year_test,sep=""))
          
          if(mois=="05"){
            repereDeb=which(as.Date(data[,2], "%d/%m/%Y")==paste(year_test,"-",mois,"-01",sep=""))
            repereFin=which(as.Date(data[,2], "%d/%m/%Y")==paste(year_test,"-",list_mois[compt+1],"-10",sep=""))
          } else if (mois =="09"){
            repereDeb=which(as.Date(data[,2], "%d/%m/%Y")==paste(year_test,"-",mois,"-11",sep=""))
            repereFin=which(as.Date(data[,2], "%d/%m/%Y")==paste(year_test,"-",mois,"-30",sep=""))
          } else {
            repereDeb=which(as.Date(data[,2], "%d/%m/%Y")==paste(year_test,"-",mois,"-11",sep=""))
            repereFin=which(as.Date(data[,2], "%d/%m/%Y")==paste(year_test,"-",list_mois[compt+1],"-10",sep=""))
          }
          
          # Affectation du statut d'écoulement en fonction des observations sur les années additionnelles
          data[repereDeb:repereFin,4]=statut
        }
      }
      
      TP=0
      FP=0
      FN=0
      TN=0
      
      # si toutes les données disponibles
      for (id in 1:nrow(data)){
        if (!is.na(data[id,3])){
          if(as.numeric(data[id,4])==1 & as.numeric(data[id,3])<=1){
            TP=TP+1
          } else if (as.numeric(data[id,4])==1 & as.numeric(data[id,3])>1){
            FP=FP+1
          } else if (as.numeric(data[id,4])==0 & as.numeric(data[id,3])<=1){
            FN=FN+1
          } else if (as.numeric(data[id,4])==0 & as.numeric(data[id,3])>1){
            TN=TN+1
          }
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
      accuracy <- ((TP+TN)/(TP+TN+FP+FN))*100
      precision <- TP/(TP+FP)
      Recall <- TP/(TP+FN)
      F1.score <- (2*precision*Recall)/(precision+Recall)
      critere = data.frame(cbind(POD,FAR,accuracy,precision,Recall,F1.score,year_test,param))
      critere_full = data.frame(rbind(critere_full,critere))
      
      colnames(data)=c("Code_HYDRO","Date","OBS","PRED")
      write.table(data,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/BENCHMARK_MODEL/France_Stations_HYDRO/Output_BM_station_HYDRO_",code_HYDRO,".csv", sep=""), sep=";", row.names = F, col.names = T)
      
      colnames(critere_full) <- c("POD", "FAR","Accuracy","Precision","Recall","F1_score","year_test","Nb_param")
      write.table(critere_full,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/BENCHMARK_MODEL/France_Stations_HYDRO/critere_2012_2016_FULL_Modele_benchmark_",code_HYDRO,".csv", sep=""), sep=";", row.names = F, col.names = T)
  }
}