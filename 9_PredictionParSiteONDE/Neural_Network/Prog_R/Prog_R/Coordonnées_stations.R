# -----------------------------------------------
# Permet de sélectionner les sites ONDE
# et d'aller chercher leurs coordonnées lat lon
# -----------------------------------------------

onde <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/RHT/Stations_ONDES_snap_corr_REGIME_hydro_HER2_group.csv", header = T, sep = ";", row.names = NULL, quote="")
input <- read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_test_classif_HER_97_fin.txt",sep=";", header = T,row.names = NULL, quote="")

liste=sort(unique(input[,1]))
output=data.frame()

for (i in 1:length(liste)){
  repere=which(as.character(onde[,9])==as.character(liste[i]))
  repere2=which(as.character(input[,1])==as.character(liste[i]))
  
  output[i,1]=as.character(onde[repere,9])
  output[i,2]=(onde[repere,13])
  output[i,3]=(onde[repere,14])
  output[i,4]=(input[repere2[1],32])
  output[i,5]=(onde[repere,18])
}

write.table(output,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Coord_classif_HER_97_fin.txt",sep=""),sep=";", row.name=F,quote=F)
