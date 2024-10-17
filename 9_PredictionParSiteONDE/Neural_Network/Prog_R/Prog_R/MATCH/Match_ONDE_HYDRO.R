#------------------------------------------------------------------------------------
# Permet de trouver une station HYDRO à proximié d'une station ONDE en parcourant
# l'arborescence du réseau RHT vers l'aval
#------------------------------------------------------------------------------------

rm(list=ls())

# Chargement des données banque hydro snappées
hydro <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/Banque Hydro/Stations_Hydro_2016_non_influencees_sans_source_Regime_Hydro_HER2_1667_stations_group_new_RH.csv", header = T, sep = ";", row.names = NULL, quote="")

# Chargement des données ONDES
onde <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/RHT/Stations_ONDES_snap_corr_REGIME_hydro_HER2_group.csv", header = T, sep = ";", row.names = NULL, quote="")
ref_nowak <- read.table("C:/Users/aurelien.beaufort/Documents/Onde/Referentiel_ONDE_NOWAK.csv", header = TRUE, sep = ";",  row.names = NULL, quote="")

id_station <- 0

fenetre <- 37500 # fenetre de recherche en x et y à définir en mètre

HER=97

select=which(onde[,18]==HER)

for(id_station in 1:nrow(onde)) {
  
  if (onde[id_station,18]==HER){
    
    repere = which(as.character(ref_nowak[,2])==as.character(onde[id_station,9]))
    aire_onde=ref_nowak[repere,26]
    HR_ONDE=onde[id_station,17]
    
    x_onde <- onde[id_station,15]
    y_onde <- onde[id_station,16]
    
    hydro_select <- which(as.numeric(hydro[,12]) < (x_onde+fenetre) & as.numeric(hydro[,12])>(x_onde-fenetre) & as.numeric(hydro[,13]) < (y_onde+fenetre) & as.numeric(hydro[,13]) > (y_onde-fenetre))
    
    if(length(hydro_select > 1)){
      rapport_ini <- 999999 # Rapport entre l'aire de la station HYDRO et la station ONDE
      dist_ini=999999 # Distance entre la station HYDRO et le site ONDE
      
      for (i in 1:length(hydro_select)){
        
        # Calcul de la distance entre la station HYDRO et le site ONDE
        dist=sqrt((hydro[hydro_select[i],12]-x_onde)^2+(hydro[hydro_select[i],13]-y_onde)^2)
        
        # Test si l'aire de drainage du BV n'est pas trop supérieur à celui de la station ONDE
        if(((hydro[hydro_select[i],21]/aire_onde) < rapport_ini) & (!is.na(hydro[hydro_select[i],21]/aire_onde)) & (dist < dist_ini) & ((hydro[hydro_select[i],26]>=(HR_ONDE-1))|(hydro[hydro_select[i],26]<=(HR_ONDE+1))))
        {
          dist_ini=dist
          rapport_ini=(hydro[hydro_select[i],21]/aire_onde)
          
          onde[id_station,20] <- as.character(hydro[hydro_select[i],2]) # Code HYDRO
          onde[id_station,21] <- rapport_ini # Ratio aire station HYDRO/site ONDE
          onde[id_station,22] <- hydro[hydro_select[i],27] # HER2
          onde[id_station,23] <- hydro[hydro_select[i],29] # HR
        }
      }
    }
  } else {
    onde[id_station,20] <- NA
    onde[id_station,21] <- NA
    onde[id_station,22] <- NA
    onde[id_station,23] <- NA
  }
}
colnames(onde)[20:23]=c("Code_HYDRO","Ratio_aire","HER2","HR")
write.table(onde,"C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Match_ONDE_HYDRO_HER_97_v2.csv",sep=";",row.names=F)

nrow(onde)-sum(onde[,20]%in%NA)
# hist(onde[,29],labels = TRUE, xlim = c(0,100), ylim = c(0,1000), xlab = "Longueur entre station ONDE et stations HYDRO", main=NULL)
