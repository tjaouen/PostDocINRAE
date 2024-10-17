# Lecture et analyse des prédictions faites
# par LASSO/Knn/ANN/RF

library(pROC)

rm(list=ls())

methode <- "Match_HYDRO" #"LASSO" "Knn" "Random_Forest" "ANN"
onde <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/RHT/Stations_ONDES_snap_corr_REGIME_hydro_HER2_group.csv", header = T, sep = ";", row.names = NULL, quote="")
donnees <- read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_test_classif_HER_97_30_jours_fin_caract_new_meteo.txt", sep=";", header = T, quote="", stringsAsFactors=F)

select <- which(donnees[,114]>=0)
liste_st <- sort(unique(as.character(donnees[,1])))
output <- data.frame()
compteur <- 0

for (code_ONDE in liste_st){
  compteur=compteur+1
  assec=0
  ev=0
  repere <- which(as.character(onde[,9])==code_ONDE)
  repere2 = which(as.character(donnees[,1])==code_ONDE)
  
  if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/",methode,"/Deb_jour_J/Output_Match_HYDRO_",code_ONDE,".txt",sep=""))){
    
    # loading des input de la station à prédire:
    donnees_st<-read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/",methode,"/Deb_jour_J/Output_Match_HYDRO_",code_ONDE,".txt",sep=""), sep=";", header = T, stringsAsFactors=F)
    # assec=which((donnees_st[,50])=="\"1\"")
    # ev=which(donnees_st[,50]=="\"0\"")
    assec=which((donnees_st[1:704,28])==1)
    ev=which(donnees_st[1:704,28]==0)
    
    output[compteur,1]=code_ONDE
    output[compteur,2]=onde[repere,13]
    output[compteur,3]=onde[repere,14]
    output[compteur,4]=(length(assec)/(length(assec)+length(ev)))*100
    output[compteur,5]=donnees[repere2[1],114]
  } else {
    output[compteur,1]=code_ONDE
    output[compteur,2]=onde[repere,13]
    output[compteur,3]=onde[repere,14]
    output[compteur,4]=NA
    output[compteur,5]=donnees[repere2[1],114]
  }
  # compt=0
  # for (annee in 2012:2016){
  #   compt=compt+1
  #   select=which(substr(donnees_st[,3],7,10)==as.character(annee))
  #   # assec_y=which((donnees_st[select,50])=="\"1\"") #pour Knn
  #   assec_y=which((donnees_st[select,52])==1) # pour les autres
  #   
  #   if (length(assec_y)> 0){
  #     output[compteur,5+compt]=length(assec_y)
  #   } else {
  #     output[compteur,5+compt]=0
  #   }
  # }
}

# colnames(output) <- c("Code_ONDE","x","y","Prop_pred","Prop_obs","NbJ_2012","NbJ_2013","NbJ_2014","NbJ_2015","NbJ_2016")
colnames(output) <- c("Code_ONDE","x","y","Prop_pred","Prop_obs")
write.table(output,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/Proportion_assec_",methode,"_Deb_jour_J.csv", sep=""), sep=";", row.names = F, col.names = T)
