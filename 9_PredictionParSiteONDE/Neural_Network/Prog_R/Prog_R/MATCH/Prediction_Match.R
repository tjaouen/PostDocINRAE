#-----------------------------------------------------------------------
# Prédiction des assecs en tenant compte des débits des stations HYDRO 
# matchées avec des sites ONDE
#-----------------------------------------------------------------------

rm(list=ls())

donnees <- read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Set_ONDE_HYDRO_Match_HER97_HYDRO_ONLY.txt", sep=";", header = T, quote="", stringsAsFactors=F)
liste_st=sort(unique(donnees[,1]))

seuil_fin=data.frame()
compteur=0

# On détermine le seuil à partir duquel on trouve des assecs
for (station in liste_st[1]){
  
  select=(which(donnees[,1]==station & donnees$Bin_Assec == 1))
  
  if(length(select)>0){
    seuil=max(as.numeric(donnees[select,120]),na.rm=T)
    if(seuil>0){
      compteur=compteur+1
      
      seuil_fin[compteur,1]=station
      seuil_fin[compteur,2]=seuil
      
      if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Match_HYDRO/Input_Match_HYDRO_",station,".txt",sep=""))){
        
        donnees_st<-read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Match_HYDRO/Input_Match_HYDRO_",station,".txt",sep=""), sep=";", header = T, stringsAsFactors=F)
        rep_flow=which(as.numeric(donnees_st[,26])>seuil_fin[compteur,2])
        rep_drying=which(as.numeric(donnees_st[,26])<seuil_fin[compteur,2])
        
        if(length(rep_flow)!=0){
          donnees_st[rep_flow,28]=0
        }
        if(length(rep_drying)!=0){
          donnees_st[rep_drying,28]=1
        }
        colnames(donnees_st)[28]=c("Prediction")
        write.table(donnees_st,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/Match_HYDRO/Output_Match_HYDRO_",station,".txt", sep=""), sep=";", row.names = F, col.names = T)
      }
    }
  } else {
    
    if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Match_HYDRO/Input_Match_HYDRO_",station,".txt",sep=""))){
      donnees_st<-read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Match_HYDRO/Input_Match_HYDRO_",station,".txt",sep=""), sep=";", header = T, stringsAsFactors=F)
      donnees_st[,28]=0
      colnames(donnees_st)[28]=c("Prediction")
      write.table(donnees_st,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/Match_HYDRO/Output_Match_HYDRO_",station,".txt", sep=""), sep=";", row.names = F, col.names = T)
    }
  }
}

for (id in 1:nrow(donnees)){
  rep_station=which(seuil_fin[,1]==donnees[id,1])
  if(length(rep_station)>0){
    if(!is.na(as.numeric(donnees[id,120])) & !is.na(as.numeric(seuil_fin[rep_station,2]))){
      if(as.numeric(donnees[id,120]) > as.numeric(seuil_fin[rep_station,2])){
        donnees[id,121]=0
      } else if (as.numeric(donnees[id,120]) <= as.numeric(seuil_fin[rep_station,2])){
        donnees[id,121]=1
      } else {
        donnees[id,121]=NA
      }
    } else {
      donnees[id,121]=NA
    }
  } else {
    donnees[id,121]=NA
  }
}

write.table(donnees,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/Match_HYDRO/Set_ONDE_HYDRO_Match_HER97_HYDRO_ONLY.txt",sep=""),sep=";", row.name=F,quote=F)

TP = 0
FP = 0
FN = 0
TN = 0
F.score <- NULL
accuracy <- NULL
precision <- NULL
Recall <- NULL
POD <- NULL
FAR <- NULL

for (id in 1:nrow(donnees)){
  if(!is.na(donnees[id,121])&!is.na(donnees$Bin_Assec[id])){
    if(donnees[id,121]==1 & donnees$Bin_Assec[id]==1){
      TP=TP+1
    } else if (donnees[id,121]==1 & donnees$Bin_Assec[id]==0){
      FP=FP+1
    } else if (donnees[id,121]==0 & donnees$Bin_Assec[id]==1){
      FN=FN+1
    } else if (donnees[id,121]==0 & donnees$Bin_Assec[id]==0){
      TN=TN+1
    }
  }
}

POD <- (TP/(TP+FN))*100
FAR <- (FP/(FP+TP))*100
accuracy <- ((TP+TN)/(TP+FP+FN+TN))*100

if ((TP+FP) > 0 & (TP+FN) > 0){
  precision <- TP/(TP+FP)
  Recall <- TP/(TP+FN)
  F.score <- (2*precision*Recall)/(precision+Recall)
} else {
  F.score <- NA
}

critere = data.frame(cbind(POD,FAR,accuracy,precision,Recall,F.score))
write.table(critere,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/Match_HYDRO/Critere_Match_HER97_Jour_J.csv", sep=""), sep=";", row.names = F, col.names = T)
