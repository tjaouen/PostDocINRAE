#
# Prédictions des assecs faites avec des données hydro aux stations 
# les plus proches des stations ONDE
#

rm(list=ls())
date_input <- read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Var_exp_station_NEW_30J/Input_L1200002.txt", header = T, sep = ";", row.names = NULL)
onde <- read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Match_ONDE_HYDRO_HER_97.csv", header = T, sep = ";", row.names = NULL)
HER=97

for (id_station in 1:nrow(onde)){
  code_ONDE=onde[id_station,9]
  if (onde[id_station,18]==HER){
    if (!is.na(onde[id_station,20])){
      
      code_Hydro=onde[id_station,20]
      
      if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/QJHYDRO/FDC_2018/FDC_",code_Hydro,".txt",sep=""))==TRUE){
        debExtract<-read.table(paste("C:/Users/aurelien.beaufort/Documents/QJHYDRO/FDC_2018/FDC_",code_Hydro,".txt",sep=""), header = T, sep = ";", row.names = NULL, quote="")
        
        if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/ANN/J30_moy_new/Output_ANN_",code_ONDE,".csv",sep=""))){
          
          # loading des input de la station à prédire
          donnees_st<-read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/ANN/J30_moy_new/Output_ANN_",code_ONDE,".csv",sep=""), sep=";", header = T, stringsAsFactors=F)
          donnees_st<-donnees_st[,-25]
          
          for (date in 1:nrow(date_input)){
            
            date_onde=date_input[date,3]
            date_deb <-paste(substr(date_onde,7,10),substr(date_onde,4,5),substr(date_onde,1,2),sep = "")
            flow_cible <- which(debExtract[,1] == date_deb, arr.ind = TRUE)
            
            if (length(flow_cible)){
              donnees_st[date,25]=debExtract[flow_cible,2] # FDC
              donnees_st[date,26]=mean(debExtract[(flow_cible-2):(flow_cible+2),2],na.rm = T) # Moy débit 5 jours
              donnees_st[date,27]=mean(debExtract[(flow_cible-5):(flow_cible+5),2],na.rm = T) # Moy débit 10 jours
              donnees_st[date,28]=debExtract[flow_cible,3] # Débit
              donnees_st[date,29]=mean(debExtract[(flow_cible-2):(flow_cible+2),3],na.rm = T) # Moy débit 5 jours
              donnees_st[date,30]=mean(debExtract[(flow_cible-5):(flow_cible+5),3],na.rm = T) # Moy débit 10 jours
              donnees_st[date,31]=date_onde # date
            } else {
              donnees_st[date,25]=NA # FDC
              donnees_st[date,26]=NA # débit
              donnees_st[date,27]=NA # débit
              donnees_st[date,28]=NA # débit
              donnees_st[date,29]=NA # débit
              donnees_st[date,30]=NA # débit
              donnees_st[date,31]=date_onde # date
            }
          }
        } # condition fichier ONDE existe
      } # condition fichier HYDRO existe
    } # condition si station HYDRO matché
    
    colnames(donnees_st)[25:31]=c("FDC","FDC_5J","FDC_10J","QJO","QJO_5J","QJO_10J","Date")
    write.table(donnees_st,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Match_HYDRO/Input_Match_HYDRO_",code_ONDE,"_MOY.txt", sep=""), sep=";", row.names = F, col.names = T)
    
  } # condition HER
} # boucle station ONDE
