# Charger le package
library(QUALYPSO)
library(strex)


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

## ------------------------------------------------------------------------------------------------------
# Première représentation des simulations: superposition des différentes simulations avec une couleur par GCM
plot(-1,-1,xlim=range(X_time_vec),ylim=range(Y),xlab="Years",ylab="PFI (%)")
for(i in 1:nrow(Y)){
  lines(X_time_vec,Y[i,],col=i)
}

# La variabilité inter-annuelle est importante. On regarde souvent les moyennes sur 30 ans pour obtenir des statistiques du climat sur des fenêtres glissantes et gommer une partie de cette variabilité haute-fréquence
sizeWindow = 30
nYmean = ncol(Y)-30
# nYmean = 100
vecYmean = vector(length=nYmean)
plot(-1,-1,xlim=range(X_time_vec),ylim=range(Y),xlab="Years",ylab="PFI (%)")
for(i in 1:nrow(Y)){
  for(y in 1:nYmean){
    vecYmean[y] = mean(Y[i,y:(y+sizeWindow-1)])
  }
  lines(X_time_vec[1:nYmean]+sizeWindow/2,vecYmean,col=i)
}

#' ## Extraction des réponses climatiques
## ------------------------------------------------------------------------------------------------------
# illustration pour la première simulation: peut être modifié
iSimu=1
# sPar peut varier entre 0 et l'infini
vec_sPar = c(0.01,0.5,1)

plot(-1,-1,xlim=range(X_time_vec),ylim=range(Y[iSimu,]),xlab="Years",ylab="PFI (%)")
lines(X_time_vec,Y[iSimu,],col="black")
for(i in 1:3){
  ySmooth = smooth.spline(x = X_time_vec,y = Y[iSimu,], spar=vec_sPar[i])$y
  lines(X_time_vec,ySmooth,col="red",lty=i,lwd=2)
}
legend("bottomright",legend = vec_sPar,lty=1:3,col="red",title="spar")

## ------------------------------------------------------------------------------------------------------
# list of options
listOption = list(typeChangeVariable='abs',spar=1)

QUALYPSO.time = QUALYPSO(Y=Y,scenAvail=scenAvail,X=X_time_vec,
                         Xfut=Xfut_time,listOption=listOption)

## ------------------------------------------------------------------------------------------------------
phiStar = QUALYPSO.time$CLIMATERESPONSE$phiStar
plot(-1,-1,xlim=range(Xfut_time),ylim=range(phiStar),xlab="Years",ylab="PFI (%)")
for(i in 1:nrow(Y)){
  lines(Xfut_time,phiStar[i,],col=i)
}

# on peut essayer de produire une figure similaire avec une couleur par GCM
vecGCM = unique(scenAvail$GCM)
plot(-1,-1,xlim=range(Xfut_time),ylim=range(phiStar),xlab="Years",ylab="PFI (%)")
for(i in 1:nrow(Y)){
  lines(Xfut_time,phiStar[i,],col=which(scenAvail$GCM[i]==vecGCM))
}
legend("topleft",legend=vecGCM,col=1:4,lty=1)

## ------------------------------------------------------------------------------------------------------
# moyenne d'ensemble
plotQUALYPSOgrandmean(QUALYPSO.time)

# effet GCM: les projections obtenues avec le GCM HadGEM2-ES sont en moyenne 0.6°C plus chaudes que les autres projections
plotQUALYPSOeffect(QUALYPSO.time,nameEff = "GCM_RCM")

# effet HM: de manière similaire, quels sont les RCMs plus marqués que les autres sur une "hausse/baisse" de la PFI ?
plotQUALYPSOeffect(QUALYPSO.time,nameEff = "HM")

## ------------------------------------------------------------------------------------------------------
# la part des différentes sources d'incertitude est contenue dans QUALYPSO.time$DECOMPVAR
QUALYPSO.time$DECOMPVAR

# la fonction plotQUALYPSOTotalVarianceDecomposition permet d'illustrer cette décomposition
plotQUALYPSOTotalVarianceDecomposition(QUALYPSO.time)

# la variabilité des réponses au changement climatique (écart-type) correspond à la variance totale issue de l'ANOVA, sans la variabilité interne
phiStar = QUALYPSO.time$CLIMATERESPONSE$phiStar
apply(phiStar,2,sd)
sqrt(QUALYPSO.time$TOTALVAR*(1-QUALYPSO.time$DECOMPVAR[,4]))

## ------------------------------------------------------------------------------------------------------
plotQUALYPSOMeanChangeAndUncertainties(QUALYPSO.time)