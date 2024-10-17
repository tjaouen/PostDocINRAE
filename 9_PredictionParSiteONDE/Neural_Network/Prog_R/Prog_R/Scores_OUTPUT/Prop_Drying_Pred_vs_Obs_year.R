#-------------------------------------------------------------
# Calcul les proportions d'assecs prédites aux sites ONDE
# par les différents modèles LASSO/Knn/ANN/RF et compare 
# ces valeurs aux observations ONDE 
# Par annnée entre 2012 et 2016
#-------------------------------------------------------------

library(pROC)

rm(list=ls())

methode="Random_Forest" #"LASSO" "Knn" "Random_Forest" "ANN"
onde <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/RHT/Stations_ONDES_snap_corr_REGIME_hydro_HER2_group.csv", header = T, sep = ";", row.names = NULL, quote="")
donnees <- read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_test_classif_HER_97_10_jours_fin_caract_new_meteo.txt", sep=";", header = T, quote="", stringsAsFactors=F)
list_year=c(2012, 2013, 2014, 2015, 2016)

liste_st<-sort(unique(as.character(donnees[,1])))

for (year_test in list_year){
  output = data.frame()
  compteur = 0
  for (code_ONDE in liste_st){
    compteur = compteur+1
    assec=0
    ev=0
    repere <- which(as.character(onde[,9])==code_ONDE)
    repere2 = which(as.character(donnees[,1])==code_ONDE)
    
    if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/",methode,"/J5_",year_test,"/Output_RF_",code_ONDE,"_",year_test,".csv",sep=""))){
      
      # loading des input de la station à prédire:
      donnees_st<-read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/",methode,"/J5_",year_test,"/Output_RF_",code_ONDE,"_",year_test,".csv",sep=""), sep=";", header = T, stringsAsFactors=F)
      # assec=which((donnees_st[,50])=="\"1\"")
      # ev=which(donnees_st[,50]=="\"0\"")
      select=which(format(as.Date(donnees_st[,3], "%d/%m/%Y"),"%Y")!=as.numeric(year_test)) # Jacknife 1
      # select=which(format(as.Date(donnees_st[,3], "%d/%m/%Y"),"%Y")!=999) # Jacknife 2
      
      # calcul de proportion d'assec obs sur ONDE en enlevant une année du set
      repere3 = which(format(as.Date(donnees[repere2,3], "%d/%m/%Y"),"%Y")!=as.numeric(year_test)) # Jacknife 1
      # repere3 = which(format(as.Date(donnees[repere2,3], "%d/%m/%Y"),"%Y")!=999) # Jacknife 2
      no_flow = which(as.character(donnees[repere2[repere3],4])=="Ecoulement non visible" | as.character(donnees[repere2[repere3],4])=="Assec")
      flow = which(as.character(donnees[repere2[repere3],4])=="Ecoulement visible")
      
      # calcul de proportion d'assec prédite en enlevant une année du set
      assec = which((donnees_st[select,52])==1)
      ev = which(donnees_st[select,52]==0)
      
      output[compteur,1]=code_ONDE
      output[compteur,2]=onde[repere,13]
      output[compteur,3]=onde[repere,14]
      output[compteur,4]=(length(assec)/(length(assec)+length(ev)))*100
      # output[compteur,5]=donnees[repere2[1],52]
      output[compteur,5]=(length(no_flow)/(length(flow)+length(no_flow)))*100
    } else {
      output[compteur,1]=code_ONDE
      output[compteur,2]=onde[repere,13]
      output[compteur,3]=onde[repere,14]
      output[compteur,4]=NA
      output[compteur,5]=(length(no_flow)/(length(flow)+length(no_flow)))*100
      # output[compteur,5]=donnees[repere2[1],52]
    }
    compt=0
    for (annee in 2012:2016){
      compt=compt+1
      select2=which(substr(donnees_st[,3],7,10)==as.character(annee))
      # assec_y=which((donnees_st[select2,50])=="\"1\"") #pour Knn
      assec_y=which((donnees_st[select2,52])==1) # pour les autres
      
      if (length(assec_y)> 0){
        output[compteur,5+compt]=length(assec_y)
      } else {
        output[compteur,5+compt]=0
      }
    }
    output[compteur,11]=donnees[repere2[1],52]
  }
  
  colnames(output) <- c("Code_ONDE","x","y","Prop_pred","Prop_obs","NbJ_2012","NbJ_2013","NbJ_2014","NbJ_2015","NbJ_2016","ZeroCal")
  write.table(output,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/Proportion_assec_",methode,"_J5","_",year_test,".csv", sep=""), sep=";", row.names = F, col.names = T)
  
  for (a in 1:nrow(donnees)){
    
    code=as.character(donnees[a,1])
    
    if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/",methode,"/J5_",year_test,"/Output_RF_",code,"_",year_test,".csv",sep=""))){
      
      donnees_st<-read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/",methode,"/J5_",year_test,"/Output_RF_",code,"_",year_test,".csv",sep=""), sep=";", header = T, stringsAsFactors=F)
      date=which(donnees_st[,3]==as.character(donnees[a,3]))
      
      if (length(date)>0){
        donnees[a,54]=donnees_st[date,52]
      }
    }
  }
  
  TP1=0
  FP1=0
  FN1=0
  TN1=0
  accuracy1 <- NULL
  precision1 <- NULL
  Recall1 <- NULL
  valeur_seuillee1 <- NULL
  POD1 <- NULL
  FAR1 <- NULL
  
  compt=0
  
  for (id in 1:nrow(donnees)){
    if(donnees[id,53]==1 & donnees[id,54]==1 & !is.na(donnees[id,54])){
      compt=compt+1
      TP1=TP1+1
    } else if (donnees[id,54]==1 & donnees[id,53]==0 & !is.na(donnees[id,54])){
      compt=compt+1
      FP1=FP1+1
    } else if (donnees[id,54]==0 & donnees[id,53]==1 & !is.na(donnees[id,54])){
      compt=compt+1
      FN1=FN1+1
    } else if (donnees[id,54]==0 & donnees[id,53]==0 & !is.na(donnees[id,54])){
      compt=compt+1
      TN1=TN1+1
    }
  }
  
  #On retire les na pour calculer AUC
  obs1=(donnees[,53])
  pred1=(donnees[,54])
  obs=obs1[!is.na(obs1) & !is.na(pred1)]
  pred=pred1[!is.na(obs1) & !is.na(pred1)]
  
  my_roc <- roc(obs, pred)
  AUC=my_roc$auc
  
  POD1 <- (TP1/(TP1+FN1))*100
  FAR1 <- (FP1/(FP1+TP1))*100
  accuracy1 <- ((TP1+TN1)/compt)*100
  precision1 <- TP1/(TP1+FP1)
  Recall1 <- TP1/(TP1+FN1)
  F1.score1 <- (2*precision1*Recall1)/(precision1+Recall1)
  critere = data.frame(cbind(POD1,FAR1,AUC,precision1,Recall1,F1.score1))
  colnames(critere) <- c("POD", "FAR","AUC","Precision","Recall","F1_score")
  write.table(critere,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/",methode,"/J5_",year_test,"/Critère_obs_2012_2016_J5","_",year_test,".csv", sep=""), sep=";", row.names = F, col.names = T)
}