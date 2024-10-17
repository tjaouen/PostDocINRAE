#-------------------------------------------------------------------
# Trace une courbe de densité pour chaque modalité d'écoulement
# en fonction de la fréquence de dépassement ou du débit spécifique
#-------------------------------------------------------------------

rm(list=ls())

# chargement des données en assec
# input<-read.table("C:/Users/aurelien.beaufort/Documents/Onde/Données site/Test_1/ONDE_vs_Hydro_2012_2016_test1_fdc.txt", header = TRUE, sep = ";",  row.names = NULL, quote="")
input<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/ONDE_vs_Hydro_2012_2016_test4_50km_Safran_HER_105.txt", header = T, sep = ";",  row.names = NULL, quote="")
liste<-read.table("C:/Users/aurelien.beaufort/Documents/Onde/Données site/Liste_station_Assec.csv", header = F, sep = ";",  row.names = NULL, quote="")

i=0
compteur=0
tab=data.frame()

# On ne sélectionne que les données présentes pour les stations avec assecs recensés
while(i<nrow(input)){
  
  i = i+1
  test = which(as.character(liste[,1])==as.character(input[i,1]))
  
  if (length(test)>0 & is.na(input[i,12])==0){
    compteur=compteur+1
    tab[compteur,1]=input[i,4]
    tab[compteur,2]=as.numeric(input[i,12])
    tab[compteur,3]=input[i,1]
  }
}

# on sélectionne les données Ecoulement visible et assec
select<-which(is.na(tab[,2])==F & (tab[,1]=="Ecoulement visible" | tab[,1]=="Assec" | tab[,1]=="Ecoulement visible acceptable" | tab[,1]=="Ecoulement non visible" | tab[,1]=="Ecoulement visible faible")) # 
Assec<-which(is.na(tab[,2])==F & (tab[,1]=="Assec" | tab[,1]=="Ecoulement non visible" | tab[,1]=="Ecoulement visible faible"))
Evisible<-which(is.na(tab[,2])==F & (tab[,1]=="Ecoulement visible"| tab[,1]=="Ecoulement visible acceptable" )) # 

# traçage de l'histogramme avec les courbes de densité
png(filename =paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Figure_densité/Density_freq_non_depassement_select_Dist_Regime_Hydro_5modalites_100km_assec_naturels_ter.png",sep=""),width=18 ,height=12, units="cm",res = 200)
x=hist(tab[select,2], ylab="Density", probability=T, ylim=c(0,4), main="Distribution des fréquences au non dépassement", xlab="Fréquence au non dépassement (%)")
# x=hist(tab[select,2], ylab="Density", probability=T, Xlim=c(-20,20), ylim=c(0,0.5), main="Distribution des Fréquences au non dépassement", xlab="Fréquence de non dépassement (%)")

#courbe Densité des assecs
lines(density(tab[Assec,2]),col="red",lwd=2)

#courbe Densité des ecoulements visibles
lines(density(tab[Evisible,2]),col="blue",lwd=2)

legend(x="topright",legend=c("densité assec","densité Ec visible"),col=c("red","blue"),cex=0.6,lwd=2)

dev.off()
