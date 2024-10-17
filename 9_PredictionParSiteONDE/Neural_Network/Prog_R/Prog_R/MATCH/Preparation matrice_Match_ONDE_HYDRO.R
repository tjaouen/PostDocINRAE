
#---------------------------------------------------------------
# Permet de rajouter les débits et les FDC pour les dates
# des observations ONDE pour les stations qui ont été matchées
# avec une station HYDRO
#---------------------------------------------------------------

rm(list=ls())

donnees <- read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_test_classif_HER_97_30_jours_fin_caract_new_meteo_HYDRO_ONLY.txt", sep=";", header = T, quote="", stringsAsFactors=F)

# 1. Preparing the dataset
liste_st <- sort(unique(as.character(donnees[,1])))

for (ligne in 1:nrow(donnees)){
  
  station=donnees[ligne,1]
  
  if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Match_HYDRO/Input_Match_HYDRO_",station,"_MOY.txt",sep=""))){
    
    donnees_st<-read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Match_HYDRO/Input_Match_HYDRO_",station,"_MOY.txt",sep=""), sep=";", header = T, stringsAsFactors=F)
    rep_dat=which(donnees_st[,31]==donnees[ligne,3])
    
    if(length(rep_dat)>0){
      donnees[ligne,119]<-donnees_st[rep_dat,25] # FDC
      donnees[ligne,120]<-donnees_st[rep_dat,26] # Moy débit 5 jours
      donnees[ligne,121]<-donnees_st[rep_dat,27] # Moy débit 10 jours
      donnees[ligne,122]<-donnees_st[rep_dat,28] # Débit
      donnees[ligne,123]<-donnees_st[rep_dat,29] # Moy débit 5 jours
      donnees[ligne,124]<-donnees_st[rep_dat,30] # Moy débit 10 jours
    } else {
      donnees[ligne,119]<-NA # FDC
      donnees[ligne,120]<-NA # FDC
      donnees[ligne,121]<-NA # FDC
      donnees[ligne,122]<-NA # Débit
      donnees[ligne,123]<-NA # Débit
      donnees[ligne,124]<-NA # Débit
    }
  } else {
    donnees[ligne,119]<-NA # FDC
    donnees[ligne,120]<-NA # FDC
    donnees[ligne,121]<-NA # FDC
    donnees[ligne,122]<-NA # Débit
    donnees[ligne,123]<-NA # Débit
    donnees[ligne,124]<-NA # Débit
  }
}

colnames(donnees)[119:124] = c("FDC","FDC_5J","FDC_10J","QJO","QJO_5J","QJO_10J")
write.table(donnees,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Set_ONDE_HYDRO_Match_HER97_HYDRO_ONLY_MOY.txt",sep=""),sep=";", row.name=F,quote=F)
