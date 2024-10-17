# Charger le package
library(QUALYPSO)
library(ggplot2)
library(strex)


saveGraph_ <- function(output_name_, functionGraph){
  pdf(paste0(output_name_,".pdf"),
      width = 18)
  functionGraph()
  dev.off()
  
  saveRDS(p, file = paste0(output_name_,".rds"))
  
  svg_device <- svglite(paste0(output_name_,".svg"), width = 18)#,
  functionGraph()
  dev.off()
  
  png(paste0(output_name_,".png"), width = 9*100)
  functionGraph()
  dev.off()
}



# Les projections de moyennes de température hivernale pour 20 simulations de 129 Years sont contenus dans Y sous la forme d'une matrice 20 x 129
list_files_ <- list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProba_LearnBrut_ByHer/FDC_Projections/",
                          pattern = "Tab_AnnualMean.txt", full.names = T, recursive = T, include.dirs = F)
# list_files_ <- list_files_[grepl("CTRIP",list_files_)]
list_files_ <- list_files_[grepl("ADAMONT",list_files_)]
list_files_ <- list_files_[grepl("rcp85",list_files_)]
list_files_ <- list_files_[!grepl("J2000_20231128_avecHERexclues",list_files_)]


Y = data.frame()
for (fl in list_files_){
  tab_ <- read.table(fl, header = T, sep = ";", dec = ".")
  # tab_ <- group_by()
  tab_ <- tab_[which(tab_$Year >= 1976 & tab_$Year <= 2099),]
  # tab_ <- tab_ %>%
  #   group_by(Year) %>%
  #   summarize(mean_PFI = mean(mean_PFI, na.rm = TRUE))
  colnames(tab_)[2] <- paste0(strsplit(fl,"/")[[1]][c(13,15)], collapse = "_")
  
  if (nrow(Y) == 0){
    Y = tab_
  }else{
    if (nrow(Y) != nrow(tab_)){
      print(tab_$Year)
      # stop("Error nb lines")
    }else{
      Y = merge(Y, tab_, by = "Year", all.x = T)
    }
  }
}

?Y
Y$Year
dim(Y) # 124 simulations

# Les Years correspondantes sont contenues dans le vecteur X_time_vec
X_time_vec <- Y$Year
Y <- Y[,which(colnames(Y) != "Year")]

# Les modèles GCM et RCM correspondants aux 20 simulations sont données dans scenAvail (data.frame avec deux colonnes "GCM" et "RCM" et 20 lignes correspondant aux 20 simulations). Ces 20 simulations correspondent à 4 GCMs descendus en échelle aveec 5 RCMs
pattern_HM_ <- c("CTRIP","GRSD","J2000","ORCHIDEE","SMASH")
# pattern_GCM_ <- c("CNRM-CM5","EC-EARTH","IPSL-CM5A","MOHC-HadGEM2","MPI-ESM-LR","NCC-NorESM1-M")
pattern_GCM_ <- c("CNRM-CERFACS-CNRM-CM5",
                  "ICHEC-EC-EARTH",
                  "IPSL-IPSL-CM5A-MR",
                  "MOHC-HadGEM2-ES",
                  "MPI-M-MPI-ESM-LR",
                  "NCC-NorESM1-M")
pattern_RCM_ <- c("CNRM-ALADIN6",
                  "MOHC-HadREM3-GA7-05",
                  "KNMI-RACMO22E",
                  "SMHI-RCA4",
                  "DMI-HIRHAM5",
                  "CLMcom-CCLM4-8-17",
                  "ICTP-RegCM4-6",
                  "MPI-CSC-REMO2009",
                  "GERICS-REMO2015",
                  "IPSL-WRF381P")

colnames(Y)

scenAvail <- data.frame(RCM = character(),
                        GCM = character(),
                        HM = character(),
                        stringsAsFactors = FALSE)

# Extraction des patterns
for (nom in colnames(Y)) {
  hm <- pattern_HM_[sapply(pattern_HM_, grepl, nom)]
  gcm <- pattern_GCM_[sapply(pattern_GCM_, grepl, nom)]
  rcm <- pattern_RCM_[sapply(pattern_RCM_, grepl, nom)]
  
  # Ajout des résultats dans le data frame
  scenAvail <- rbind(scenAvail, data.frame(GCM = gcm,
                                           RCM = rcm,
                                           HM = hm,
                                           stringsAsFactors = FALSE))
}
dim(scenAvail)
scenAvail
scenAvail$GCM_RCM <- paste0(scenAvail$GCM," + ",scenAvail$RCM)
scenAvail <- scenAvail[,c("GCM_RCM","HM")]
apply(scenAvail,2,unique)

Y <- t(Y)

ratio_epaisseurs_ = 1
## ------------------------------------------------------------------------------------------------------
# Première représentation des simulations: superposition des différentes simulations avec une couleur par GCM
x11()
plot(-1,-1,xlim=range(X_time_vec),ylim=range(Y),xlab="Years",ylab="PFI (%)",yaxt="n")
for(i in 1:nrow(Y)){
  lines(X_time_vec,Y[i,],col=i)
}
y_labels <- pretty(range(Y))
axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1)
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/1_ChroniquesPFI_rcp85_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/1_ChroniquesPFI_rcp85_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/1_ChroniquesPFI_rcp85_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/1_ChroniquesPFI_rcp85_1_20240526.rds")

# dev.off()

# La variabilité inter-annuelle est importante. On regarde souvent les moyennes sur 30 ans pour obtenir des statistiques du climat sur des fenêtres glissantes et gommer une partie de cette variabilité haute-fréquence
sizeWindow = 30
nYmean = ncol(Y)-30
# nYmean = 100
vecYmean = vector(length=nYmean)
x11()
plot(-1,-1,xlim=range(X_time_vec),ylim=range(Y),xlab="Years",ylab="PFI (%)",yaxt="n")
for(i in 1:nrow(Y)){
  for(y in 1:nYmean){
    vecYmean[y] = mean(Y[i,y:(y+sizeWindow-1)])
  }
  lines(X_time_vec[1:nYmean]+sizeWindow/2,vecYmean,col=i)
}
y_labels <- pretty(range(Y))
axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1)
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/2_ChroniquesPFI_MoySur30ans_rcp85_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/2_ChroniquesPFI_MoySur30ans_rcp85_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/2_ChroniquesPFI_MoySur30ans_rcp85_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/2_ChroniquesPFI_MoySur30ans_rcp85_1_20240526.rds")

#' ## Extraction des réponses climatiques
## ------------------------------------------------------------------------------------------------------
# illustration pour la première simulation: peut être modifié
iSimu=1
# sPar peut varier entre 0 et l'infini
vec_sPar = c(0.01,0.5,1)

x11()
plot(-1,-1,xlim=range(X_time_vec),ylim=range(Y[iSimu,]),xlab="Years",ylab="PFI (%)",yaxt="n")
lines(X_time_vec,Y[iSimu,],col="black")
for(i in 1:3){
  ySmooth = smooth.spline(x = X_time_vec,y = Y[iSimu,], spar=vec_sPar[i])$y
  lines(X_time_vec,ySmooth,col="red",lty=i,lwd=2)
}
legend("bottomright",legend = vec_sPar,lty=1:3,col="red",title="spar")
y_labels <- pretty(range(range(Y[iSimu,])))
axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1)
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/3_ChroniquesPFI_ExempleSimu_rcp85_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/3_ChroniquesPFI_ExempleSimu_rcp85_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/3_ChroniquesPFI_ExempleSimu_rcp85_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/3_ChroniquesPFI_ExempleSimu_rcp85_1_20240526.rds")



## ------------------------------------------------------------------------------------------------------
# list of options
listOption = list(typeChangeVariable='abs',spar=1)

QUALYPSO.time = QUALYPSO(Y=Y,scenAvail=scenAvail,X=X_time_vec,
                         Xfut=Xfut_time,listOption=listOption)

## ------------------------------------------------------------------------------------------------------
phiStar = QUALYPSO.time$CLIMATERESPONSE$phiStar
x11()
plot(-1,-1,xlim=range(Xfut_time),ylim=range(phiStar),xlab="Years",ylab="PFI (%)",yaxt="n")
for(i in 1:nrow(Y)){
  lines(Xfut_time,phiStar[i,],col=i)
}
y_labels <- pretty(range(range(phiStar)))
axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1)
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/4_ChroniquesPFI_ProjChgtValAbs_rcp85_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/4_ChroniquesPFI_ProjChgtValAbs_rcp85_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/4_ChroniquesPFI_ProjChgtValAbs_rcp85_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/4_ChroniquesPFI_ProjChgtValAbs_rcp85_1_20240526.rds")


# on peut essayer de produire une figure similaire avec une couleur par GCM
vecGCM = unique(scenAvail$GCM)
x11()
plot(-1,-1,xlim=range(Xfut_time),ylim=range(phiStar),xlab="Years",ylab="PFI (%)",yaxt="n")
for(i in 1:nrow(Y)){
  lines(Xfut_time,phiStar[i,],col=which(scenAvail$GCM[i]==vecGCM))
}
legend("topleft",legend=vecGCM,col=1:4,lty=1)
y_labels <- pretty(range(range(phiStar)))
axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1)
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/5_ChroniquesPFI_EffectTotal_rcp85_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/5_ChroniquesPFI_EffectTotal_rcp85_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/5_ChroniquesPFI_EffectTotal_rcp85_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/5_ChroniquesPFI_EffectTotal_rcp85_1_20240526.rds")

## ------------------------------------------------------------------------------------------------------
# moyenne d'ensemble
x11()
plotQUALYPSOgrandmean(QUALYPSO.time)
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/6_ChroniquesPFI_GrandMean_rcp85_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/6_ChroniquesPFI_GrandMean_rcp85_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/6_ChroniquesPFI_GrandMean_rcp85_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/6_ChroniquesPFI_GrandMean_rcp85_1_20240526.rds")


# effet GCM: les projections obtenues avec le GCM HadGEM2-ES sont en moyenne 0.6°C plus chaudes que les autres projections
x11()
plotQUALYPSOeffect(QUALYPSO.time,nameEff = "GCM_RCM")
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/7_ChroniquesPFI_EffectGCMRCM_rcp85_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/7_ChroniquesPFI_EffectGCMRCM_rcp85_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/7_ChroniquesPFI_EffectGCMRCM_rcp85_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/7_ChroniquesPFI_EffectGCMRCM_rcp85_1_20240526.rds")


# effet HM: de manière similaire, quels sont les RCMs plus marqués que les autres sur une "hausse/baisse" de la PFI ?
x11()
plotQUALYPSOeffect(QUALYPSO.time,nameEff = "HM")
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/8_ChroniquesPFI_EffectHM_rcp85_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/8_ChroniquesPFI_EffectHM_rcp85_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/8_ChroniquesPFI_EffectHM_rcp85_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/8_ChroniquesPFI_EffectHM_rcp85_1_20240526.rds")

## ------------------------------------------------------------------------------------------------------
# la part des différentes sources d'incertitude est contenue dans QUALYPSO.time$DECOMPVAR
QUALYPSO.time$DECOMPVAR

# la fonction plotQUALYPSOTotalVarianceDecomposition permet d'illustrer cette décomposition
x11()
plotQUALYPSOTotalVarianceDecomposition(QUALYPSO.time)
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/9_ChroniquesPFI_TotalVarianceDecomposition_rcp85_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/9_ChroniquesPFI_TotalVarianceDecomposition_rcp85_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/9_ChroniquesPFI_TotalVarianceDecomposition_rcp85_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/9_ChroniquesPFI_TotalVarianceDecomposition_rcp85_1_20240526.rds")


# la variabilité des réponses au changement climatique (écart-type) correspond à la variance totale issue de l'ANOVA, sans la variabilité interne
phiStar = QUALYPSO.time$CLIMATERESPONSE$phiStar
apply(phiStar,2,sd)
sqrt(QUALYPSO.time$TOTALVAR*(1-QUALYPSO.time$DECOMPVAR[,4]))

## ------------------------------------------------------------------------------------------------------
x11()
plotQUALYPSOMeanChangeAndUncertainties(QUALYPSO.time)
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/10_ChroniquesPFI_MeanChangeAndUncertainties_rcp85_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/10_ChroniquesPFI_MeanChangeAndUncertainties_rcp85_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/10_ChroniquesPFI_MeanChangeAndUncertainties_rcp85_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/10_ChroniquesPFI_MeanChangeAndUncertainties_rcp85_1_20240526.rds")


Y_rcp85 <- Y
scenAvail_rcp85 <- scenAvail
X_rcp85 <- X_time_vec
Xfut_rcp85 <- Xfut_time
listOption_rcp85 <- listOption






###########################
######### RCP 4.5 #########
###########################


# Les projections de moyennes de température hivernale pour 20 simulations de 129 Years sont contenus dans Y sous la forme d'une matrice 20 x 129
list_files_ <- list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProba_LearnBrut_ByHer/FDC_Projections/",
                          pattern = "Tab_AnnualMean.txt", full.names = T, recursive = T, include.dirs = F)
# list_files_ <- list_files_[grepl("CTRIP",list_files_)]
list_files_ <- list_files_[grepl("ADAMONT",list_files_)]
list_files_ <- list_files_[grepl("rcp45",list_files_)]
list_files_ <- list_files_[!grepl("J2000_20231128_avecHERexclues",list_files_)]


Y = data.frame()
for (fl in list_files_){
  tab_ <- read.table(fl, header = T, sep = ";", dec = ".")
  # tab_ <- group_by()
  tab_ <- tab_[which(tab_$Year >= 1976 & tab_$Year <= 2099),]
  # tab_ <- tab_ %>%
  #   group_by(Year) %>%
  #   summarize(mean_PFI = mean(mean_PFI, na.rm = TRUE))
  colnames(tab_)[2] <- paste0(strsplit(fl,"/")[[1]][c(13,15)], collapse = "_")
  
  if (nrow(Y) == 0){
    Y = tab_
  }else{
    if (nrow(Y) != nrow(tab_)){
      print(tab_$Year)
      # stop("Error nb lines")
    }else{
      Y = merge(Y, tab_, by = "Year", all.x = T)
    }
  }
}

?Y
Y$Year
dim(Y) # 124 simulations

# Les Years correspondantes sont contenues dans le vecteur X_time_vec
X_time_vec <- Y$Year
Y <- Y[,which(colnames(Y) != "Year")]

# Les modèles GCM et RCM correspondants aux 20 simulations sont données dans scenAvail (data.frame avec deux colonnes "GCM" et "RCM" et 20 lignes correspondant aux 20 simulations). Ces 20 simulations correspondent à 4 GCMs descendus en échelle aveec 5 RCMs
pattern_HM_ <- c("CTRIP","GRSD","J2000","ORCHIDEE","SMASH")
# pattern_GCM_ <- c("CNRM-CM5","EC-EARTH","IPSL-CM5A","MOHC-HadGEM2","MPI-ESM-LR","NCC-NorESM1-M")
pattern_GCM_ <- c("CNRM-CERFACS-CNRM-CM5",
                  "ICHEC-EC-EARTH",
                  "IPSL-IPSL-CM5A-MR",
                  "MOHC-HadGEM2-ES",
                  "MPI-M-MPI-ESM-LR",
                  "NCC-NorESM1-M")
pattern_RCM_ <- c("CNRM-ALADIN6",
                  "MOHC-HadREM3-GA7-05",
                  "KNMI-RACMO22E",
                  "SMHI-RCA4",
                  "DMI-HIRHAM5",
                  "CLMcom-CCLM4-8-17",
                  "ICTP-RegCM4-6",
                  "MPI-CSC-REMO2009",
                  "GERICS-REMO2015",
                  "IPSL-WRF381P")

colnames(Y)

scenAvail <- data.frame(RCM = character(),
                        GCM = character(),
                        HM = character(),
                        stringsAsFactors = FALSE)

# Extraction des patterns
for (nom in colnames(Y)) {
  hm <- pattern_HM_[sapply(pattern_HM_, grepl, nom)]
  gcm <- pattern_GCM_[sapply(pattern_GCM_, grepl, nom)]
  rcm <- pattern_RCM_[sapply(pattern_RCM_, grepl, nom)]
  
  # Ajout des résultats dans le data frame
  scenAvail <- rbind(scenAvail, data.frame(GCM = gcm,
                                           RCM = rcm,
                                           HM = hm,
                                           stringsAsFactors = FALSE))
}
dim(scenAvail)
scenAvail
scenAvail$GCM_RCM <- paste0(scenAvail$GCM," + ",scenAvail$RCM)
scenAvail <- scenAvail[,c("GCM_RCM","HM")]
apply(scenAvail,2,unique)

Y <- t(Y)

## ------------------------------------------------------------------------------------------------------
# Première représentation des simulations: superposition des différentes simulations avec une couleur par GCM
x11()
plot(-1,-1,xlim=range(X_time_vec),ylim=range(Y),xlab="Years",ylab="PFI (%)",yaxt="n")
for(i in 1:nrow(Y)){
  lines(X_time_vec,Y[i,],col=i)
}
y_labels <- pretty(range(Y))
axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1)
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/1_ChroniquesPFI_rcp45_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/1_ChroniquesPFI_rcp45_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/1_ChroniquesPFI_rcp45_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/1_ChroniquesPFI_rcp45_1_20240526.rds")


# La variabilité inter-annuelle est importante. On regarde souvent les moyennes sur 30 ans pour obtenir des statistiques du climat sur des fenêtres glissantes et gommer une partie de cette variabilité haute-fréquence
sizeWindow = 30
nYmean = ncol(Y)-30
# nYmean = 100
vecYmean = vector(length=nYmean)
x11()
plot(-1,-1,xlim=range(X_time_vec),ylim=range(Y),xlab="Years",ylab="PFI (%)",yaxt="n")
for(i in 1:nrow(Y)){
  for(y in 1:nYmean){
    vecYmean[y] = mean(Y[i,y:(y+sizeWindow-1)])
  }
  lines(X_time_vec[1:nYmean]+sizeWindow/2,vecYmean,col=i)
}
y_labels <- pretty(range(Y))
axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1)
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/2_ChroniquesPFI_MoySur30ans_rcp45_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/2_ChroniquesPFI_MoySur30ans_rcp45_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/2_ChroniquesPFI_MoySur30ans_rcp45_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/2_ChroniquesPFI_MoySur30ans_rcp45_1_20240526.rds")


#' ## Extraction des réponses climatiques
## ------------------------------------------------------------------------------------------------------
# illustration pour la première simulation: peut être modifié
iSimu=1
# sPar peut varier entre 0 et l'infini
vec_sPar = c(0.01,0.5,1)

x11()
plot(-1,-1,xlim=range(X_time_vec),ylim=range(Y[iSimu,]),xlab="Years",ylab="PFI (%)",yaxt="n")
lines(X_time_vec,Y[iSimu,],col="black")
for(i in 1:3){
  ySmooth = smooth.spline(x = X_time_vec,y = Y[iSimu,], spar=vec_sPar[i])$y
  lines(X_time_vec,ySmooth,col="red",lty=i,lwd=2)
}
legend("bottomright",legend = vec_sPar,lty=1:3,col="red",title="spar")
y_labels <- pretty(range(Y))
axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1)
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/3_ChroniquesPFI_ExempleSimu_rcp45_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/3_ChroniquesPFI_ExempleSimu_rcp45_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/3_ChroniquesPFI_ExempleSimu_rcp45_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/3_ChroniquesPFI_ExempleSimu_rcp45_1_20240526.rds")


## ------------------------------------------------------------------------------------------------------
# list of options
listOption = list(typeChangeVariable='abs',spar=1)

QUALYPSO.time = QUALYPSO(Y=Y,scenAvail=scenAvail,X=X_time_vec,
                         Xfut=Xfut_time,listOption=listOption)

## ------------------------------------------------------------------------------------------------------
phiStar = QUALYPSO.time$CLIMATERESPONSE$phiStar
x11()
plot(-1,-1,xlim=range(Xfut_time),ylim=range(phiStar),xlab="Years",ylab="PFI (%)",yaxt="n")
for(i in 1:nrow(Y)){
  lines(Xfut_time,phiStar[i,],col=i)
}
y_labels <- pretty(range(phiStar))
axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1)
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/4_ChroniquesPFI_ProjChgtValAbs_rcp45_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/4_ChroniquesPFI_ProjChgtValAbs_rcp45_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/4_ChroniquesPFI_ProjChgtValAbs_rcp45_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/4_ChroniquesPFI_ProjChgtValAbs_rcp45_1_20240526.rds")


# on peut essayer de produire une figure similaire avec une couleur par GCM
vecGCM = unique(scenAvail$GCM)
x11()
plot(-1,-1,xlim=range(Xfut_time),ylim=range(phiStar),xlab="Years",ylab="PFI (%)",yaxt="n")
for(i in 1:nrow(Y)){
  lines(Xfut_time,phiStar[i,],col=which(scenAvail$GCM[i]==vecGCM))
}
y_labels <- pretty(range(phiStar))
axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1)
legend("topleft",legend=vecGCM,col=1:4,lty=1)
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/5_ChroniquesPFI_EffectTotal_rcp45_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/5_ChroniquesPFI_EffectTotal_rcp45_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/5_ChroniquesPFI_EffectTotal_rcp45_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/5_ChroniquesPFI_EffectTotal_rcp45_1_20240526.rds")

## ------------------------------------------------------------------------------------------------------
# moyenne d'ensemble
x11()
plotQUALYPSOgrandmean(QUALYPSO.time)
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/6_ChroniquesPFI_GrandMean_rcp45_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/6_ChroniquesPFI_GrandMean_rcp45_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/6_ChroniquesPFI_GrandMean_rcp45_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/6_ChroniquesPFI_GrandMean_rcp45_1_20240526.rds")

# effet GCM: les projections obtenues avec le GCM HadGEM2-ES sont en moyenne 0.6°C plus chaudes que les autres projections
x11()
plotQUALYPSOeffect(QUALYPSO.time,nameEff = "GCM_RCM")
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/7_ChroniquesPFI_EffectGCMRCM_rcp45_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/7_ChroniquesPFI_EffectGCMRCM_rcp45_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/7_ChroniquesPFI_EffectGCMRCM_rcp45_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/7_ChroniquesPFI_EffectGCMRCM_rcp45_1_20240526.rds")

# effet HM: de manière similaire, quels sont les RCMs plus marqués que les autres sur une "hausse/baisse" de la PFI ?
x11()
plotQUALYPSOeffect(QUALYPSO.time,nameEff = "HM")
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/8_ChroniquesPFI_EffectHM_rcp45_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/8_ChroniquesPFI_EffectHM_rcp45_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/8_ChroniquesPFI_EffectHM_rcp45_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/8_ChroniquesPFI_EffectHM_rcp45_1_20240526.rds")


## ------------------------------------------------------------------------------------------------------
# la part des différentes sources d'incertitude est contenue dans QUALYPSO.time$DECOMPVAR
QUALYPSO.time$DECOMPVAR

# la fonction plotQUALYPSOTotalVarianceDecomposition permet d'illustrer cette décomposition
x11()
plotQUALYPSOTotalVarianceDecomposition(QUALYPSO.time)
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/9_ChroniquesPFI_TotalVarianceDecomposition_rcp45_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/9_ChroniquesPFI_TotalVarianceDecomposition_rcp45_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/9_ChroniquesPFI_TotalVarianceDecomposition_rcp45_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/9_ChroniquesPFI_TotalVarianceDecomposition_rcp45_1_20240526.rds")


# la variabilité des réponses au changement climatique (écart-type) correspond à la variance totale issue de l'ANOVA, sans la variabilité interne
phiStar = QUALYPSO.time$CLIMATERESPONSE$phiStar
apply(phiStar,2,sd)
sqrt(QUALYPSO.time$TOTALVAR*(1-QUALYPSO.time$DECOMPVAR[,4]))

## ------------------------------------------------------------------------------------------------------
x11()
plotQUALYPSOMeanChangeAndUncertainties(QUALYPSO.time)
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/10_ChroniquesPFI_MeanChangeAndUncertainties_rcp45_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/10_ChroniquesPFI_MeanChangeAndUncertainties_rcp45_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/10_ChroniquesPFI_MeanChangeAndUncertainties_rcp45_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/10_ChroniquesPFI_MeanChangeAndUncertainties_rcp45_1_20240526.rds")

Y_rcp45 <- Y
scenAvail_rcp45 <- scenAvail
X_rcp45 <- X_time_vec
Xfut_rcp45 <- Xfut_time
listOption_rcp45 <- listOption



###################################
######### RCP 45 + RCP 85 #########
###################################

Y_rpc45and85 <- rbind(Y_rcp45,Y_rcp85)
scenAvail_rcp45$RCP <- "rcp45"
scenAvail_rcp85$RCP <- "rcp85"
scenAvail <- rbind(scenAvail_rcp45,scenAvail_rcp85)
Y <- Y_rpc45and85

## ------------------------------------------------------------------------------------------------------
# Première représentation des simulations: superposition des différentes simulations avec une couleur par GCM
x11()
plot(-1,-1,xlim=range(X_time_vec),ylim=range(Y),xlab="Years",ylab="PFI (%)",yaxt="n")
for(i in 1:nrow(Y)){
  lines(X_time_vec,Y[i,],col=i)
}
y_labels <- pretty(range(Y))
axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1)
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/1_ChroniquesPFI_rcp45and85_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/1_ChroniquesPFI_rcp45and85_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/1_ChroniquesPFI_rcp45and85_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/1_ChroniquesPFI_rcp45and85_1_20240526.rds")


# La variabilité inter-annuelle est importante. On regarde souvent les moyennes sur 30 ans pour obtenir des statistiques du climat sur des fenêtres glissantes et gommer une partie de cette variabilité haute-fréquence
sizeWindow = 30
nYmean = ncol(Y)-30
# nYmean = 100
vecYmean = vector(length=nYmean)
x11()
plot(-1,-1,xlim=range(X_time_vec),ylim=range(Y),xlab="Years",ylab="PFI (%)",yaxt="n")
for(i in 1:nrow(Y)){
  for(y in 1:nYmean){
    vecYmean[y] = mean(Y[i,y:(y+sizeWindow-1)])
  }
  lines(X_time_vec[1:nYmean]+sizeWindow/2,vecYmean,col=i)
}
y_labels <- pretty(range(Y))
axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1)
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/2_ChroniquesPFI_MoySur30ans_rcp45and85_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/2_ChroniquesPFI_MoySur30ans_rcp45and85_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/2_ChroniquesPFI_MoySur30ans_rcp45and85_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/2_ChroniquesPFI_MoySur30ans_rcp45and85_1_20240526.rds")

#' ## Extraction des réponses climatiques
## ------------------------------------------------------------------------------------------------------
# illustration pour la première simulation: peut être modifié
iSimu=1
# sPar peut varier entre 0 et l'infini
vec_sPar = c(0.01,0.5,1)

x11()
plot(-1,-1,xlim=range(X_time_vec),ylim=range(Y[iSimu,]),xlab="Years",ylab="PFI (%)",yaxt="n")
lines(X_time_vec,Y[iSimu,],col="black")
for(i in 1:3){
  ySmooth = smooth.spline(x = X_time_vec,y = Y[iSimu,], spar=vec_sPar[i])$y
  lines(X_time_vec,ySmooth,col="red",lty=i,lwd=2)
}
y_labels <- pretty(range(Y[iSimu,]))
axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1)
legend("bottomright",legend = vec_sPar,lty=1:3,col="red",title="spar")
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/3_ChroniquesPFI_ExempleSimu_rcp45and85_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/3_ChroniquesPFI_ExempleSimu_rcp45and85_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/3_ChroniquesPFI_ExempleSimu_rcp45and85_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/3_ChroniquesPFI_ExempleSimu_rcp45and85_1_20240526.rds")

## ------------------------------------------------------------------------------------------------------
# list of options
listOption = list(typeChangeVariable='abs',spar=1)

QUALYPSO.time = QUALYPSO(Y=Y,scenAvail=scenAvail,X=X_time_vec,
                         Xfut=Xfut_time,listOption=listOption)

## ------------------------------------------------------------------------------------------------------
phiStar = QUALYPSO.time$CLIMATERESPONSE$phiStar
x11()
plot(-1,-1,xlim=range(Xfut_time),ylim=range(phiStar),xlab="Years",ylab="PFI (%)",yaxt="n")
for(i in 1:nrow(Y)){
  lines(Xfut_time,phiStar[i,],col=i)
}
y_labels <- pretty(range(phiStar))
axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1)
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/4_ChroniquesPFI_ProjChgtValAbs_rcp45and85_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/4_ChroniquesPFI_ProjChgtValAbs_rcp45and85_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/4_ChroniquesPFI_ProjChgtValAbs_rcp45and85_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/4_ChroniquesPFI_ProjChgtValAbs_rcp45and85_1_20240526.rds")


# on peut essayer de produire une figure similaire avec une couleur par GCM
vecGCM = unique(scenAvail$GCM)
x11()
plot(-1,-1,xlim=range(Xfut_time),ylim=range(phiStar),xlab="Years",ylab="PFI (%)",yaxt="n")
for(i in 1:nrow(Y)){
  lines(Xfut_time,phiStar[i,],col=which(scenAvail$GCM[i]==vecGCM))
}
axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1)
# legend("bottomright",legend = vec_sPar,lty=1:3,col="red",title="spar")
legend("topleft",legend=vecGCM,col=1:4,lty=1)
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/5_ChroniquesPFI_EffectTotal_rcp45and85_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/5_ChroniquesPFI_EffectTotal_rcp45and85_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/5_ChroniquesPFI_EffectTotal_rcp45and85_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/5_ChroniquesPFI_EffectTotal_rcp45and85_1_20240526.rds")


## ------------------------------------------------------------------------------------------------------
# moyenne d'ensemble
x11()
plotQUALYPSOgrandmean(QUALYPSO.time)
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/6_ChroniquesPFI_GrandMean_rcp45and85_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/6_ChroniquesPFI_GrandMean_rcp45and85_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/6_ChroniquesPFI_GrandMean_rcp45and85_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/6_ChroniquesPFI_GrandMean_rcp45and85_1_20240526.rds")


# effet GCM: les projections obtenues avec le GCM HadGEM2-ES sont en moyenne 0.6°C plus chaudes que les autres projections
x11()
plotQUALYPSOeffect(QUALYPSO.time,nameEff = "GCM_RCM")
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/7_ChroniquesPFI_EffectGCMRCM_rcp45and85_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/7_ChroniquesPFI_EffectGCMRCM_rcp45and85_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/7_ChroniquesPFI_EffectGCMRCM_rcp45and85_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/7_ChroniquesPFI_EffectGCMRCM_rcp45and85_1_20240526.rds")


# effet HM: de manière similaire, quels sont les RCMs plus marqués que les autres sur une "hausse/baisse" de la PFI ?
x11()
plotQUALYPSOeffect(QUALYPSO.time,nameEff = "HM")
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/8_ChroniquesPFI_EffectHM_rcp45and85_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/8_ChroniquesPFI_EffectHM_rcp45and85_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/8_ChroniquesPFI_EffectHM_rcp45and85_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/8_ChroniquesPFI_EffectHM_rcp45and85_1_20240526.rds")


## ------------------------------------------------------------------------------------------------------
# la part des différentes sources d'incertitude est contenue dans QUALYPSO.time$DECOMPVAR
QUALYPSO.time$DECOMPVAR

# la fonction plotQUALYPSOTotalVarianceDecomposition permet d'illustrer cette décomposition
x11()
plotQUALYPSOTotalVarianceDecomposition(QUALYPSO.time)
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/9_ChroniquesPFI_TotalVarianceDecomposition_rcp45and85_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/9_ChroniquesPFI_TotalVarianceDecomposition_rcp45and85_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/9_ChroniquesPFI_TotalVarianceDecomposition_rcp45and85_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/9_ChroniquesPFI_TotalVarianceDecomposition_rcp45and85_1_20240526.rds")


# la variabilité des réponses au changement climatique (écart-type) correspond à la variance totale issue de l'ANOVA, sans la variabilité interne
phiStar = QUALYPSO.time$CLIMATERESPONSE$phiStar
apply(phiStar,2,sd)
sqrt(QUALYPSO.time$TOTALVAR*(1-QUALYPSO.time$DECOMPVAR[,4]))

## ------------------------------------------------------------------------------------------------------
x11()
plotQUALYPSOMeanChangeAndUncertainties(QUALYPSO.time)
recorded_plot <- recordPlot()

png("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/10_ChroniquesPFI_MeanChangeAndUncertainties_rcp45and85_1_20240526.png",
    width = 800, height = 600)
recorded_plot
dev.off()

svg("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/10_ChroniquesPFI_MeanChangeAndUncertainties_rcp45and85_1_20240526.svg",
    width = 16, height = 12)
recorded_plot
dev.off()

pdf("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/10_ChroniquesPFI_MeanChangeAndUncertainties_rcp45and85_1_20240526.pdf",
    width = 16, height = 12)
recorded_plot
dev.off()

saveRDS(recorded_plot, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/10_ChroniquesPFI_MeanChangeAndUncertainties_rcp45and85_1_20240526.rds")















### Sans J2000 et ORCHIDEE ###



### Par HER ###





