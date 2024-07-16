### Librairies ###
library(ggplot2)
library(RColorBrewer)

### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")



liste <- c(list.files(paste0(outputDir_matricesHERdates_,"Thirel_Sim_20230220/"),pattern="Matrice_SIM_2012_2018_KG",full.names = T),list.files(pattern="Matrice_OBS_2012_2018_KG",full.names = T))
NSE <- c()
colNSE <- c()

onde = read.table(liste[1], header = T, sep = ";", row.names = NULL, quote="")
onde = onde[which((!is.na(onde[,c("Freq_j")])) & !is.na(onde[,c("Freq_j.5.1")])),]
liste_Her=sort(unique(onde[,1]))


onde$Means_j_jm5_ = rowMeans(onde[,(10:15)]) #Moyenne de j a j-5

x11()
boxplot(format(as.Date(onde$Date),"%m"), onde$Means_j_jm5_)

x11()
png()
boxplot(onde$Means_j_jm5_ ~ format(as.Date(onde$Date),"%m"))


paletteExtension = colorRampPalette(brewer.pal(9, "Set1"))(22)

x11()
png(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/Annexe_EffetMois/EffetMois_AllHER_ThirelSim_Matrice_SIM_2012_2018_KGESUp0.20_DispSup5_stations_Hydro_weight_",format(Sys.time(),"%H%M"),".png"),
    width = 1600, height = 1600, 
    units = "px", pointsize = 12)
boxplot(onde$X._Assec ~ format(as.Date(onde$Date),"%m"),
        xlab = "Mois",
        ylab = "Probabilite d'Assec dans tous les HER confondus",
        cex.lab = 3)
dev.off()


x11()
png(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/Annexe_EffetMois/EffetMois_Passec_HERsepares_ThirelSim_Matrice_SIM_2012_2018_KGESUp0.20_DispSup5_stations_Hydro_weight_",format(Sys.time(),"%H%M"),".png"),
    width = 1200, height = 700, 
    units = "px", pointsize = 12)
ggplot(onde, aes(x=format(as.Date(Date),"%m"), y=X._Assec, fill = factor(HER1))) + 
  xlab("Mois")+
  ylab("Proportion d'assecs dans l'HER")+
  scale_fill_manual(values = paletteExtension)+ #"Set2")+
  guides(fill=guide_legend(title="HER 1"))+
  theme_minimal()+
  geom_boxplot()
dev.off()


x11()
png(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/Annexe_EffetMois/EffetMois_FDC_HERsepares_ThirelSim_Matrice_SIM_2012_2018_KGESUp0.20_DispSup5_stations_Hydro_weight_",format(Sys.time(),"%H%M"),".png"),
    width = 1200, height = 700,
    units = "px", pointsize = 12)
ggplot(onde, aes(x=format(as.Date(Date),"%m"), y=Means_j_jm5_, fill = factor(HER1))) + 
  xlab("Mois")+
  ylab("Moyenne de la fréquence de non dépassement à [j-5;j]")+
  scale_fill_manual(values = paletteExtension)+ #"Set2")+
  guides(fill=guide_legend(title="HER 1"))+
  theme_minimal()+
  geom_boxplot()
dev.off()




