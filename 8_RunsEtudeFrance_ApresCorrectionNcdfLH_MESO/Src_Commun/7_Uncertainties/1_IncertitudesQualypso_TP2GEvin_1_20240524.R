#' ---
#' title: "TP2 – Partition des sources d’incertitude dans un ensemble multimodèle de projections climatiques transitoires"
#' author: Guillaume Evin et Benoit Hingray
#' date: 08 juin, 2023
#' output: html_document
#' ---
#' 
## ----setup, include=FALSE------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

#' 
#' ## Contexte
#' 
#' Dans les MMEs issus de modèles régionaux, il n'y a souvent qu'une simulation disponible pour chaque combinaison de modèles climatiques. Afin de séparer le signal lié à la réponse climatique de la variabilité interne, une solution possible est de considérer que la réponse climatique d'une chaîne correspond à sa composante basse fréquence. Cette variation doit être graduelle et lisse, la variabilité à plus haute fréquence des séries temporelles correspondant à la variabilité interne. Cette hypothèse de quasi-ergodicité a conduit à la méthode QE-ANOVA proposée par Hingray et Saïd (2014). Dans ce TP, des signaux de basse-fréquence sont extraits à l'aide de splines cubiques.
#' 
#' De plus, la plupart des ensembles de projections climatiques explorent de manière incomplète les combinaisons possibles. Cela peut poser des problèmes pour la partition des incertitudes. Les estimations directes basées sur des moyennes directes par facteur sont par exemple généralement biaisés, en raison par exemple de modèles RCM/GCM sur-représentés. L'application d'un modèle linéaire (fonction *lm*) ne souffre pas de ces limitations. De manière alternative, l'approche décrite dans Evin et al. (2019) utilise des méthodes bayésiennes traitant explicitement les données manquantes (les données manquantes font partie de l'inférence, approche appelée *data augmentation*). Cela permet de plus de propager l'incertitude due aux projections absentes dans l'estimation des effets du modèle ANOVA.
#' 
#' ## Objectifs du TP 
#' Ce TP vise à appliquer les fonctionnalités du package *QUALYPSO* (disponible sur CRAN) pour appliquer, illustrer et discuter les étapes suivantes:
#' 
#' * Extraction de la réponse climatique.
#' * Calcul des différences absolues et relatives par rapport à un horizon de référence.
#' * Décomposition des incertitudes avec une méthode ANOVA.
#' 
#' Le package *QUALYPSO* permet également de présenter ces analyses en fonction de différents niveaux de réchauffement, au lieu d'horizons temporels (conf rapport spécial du GIEC sur les conséquences d'un réchauffement planétaire de 1,5 °C).
#' 
#' ## Lecture des données
#' 
#' Le package *QUALYPSO* contient un ensemble de projections climatiques de moyennes de température en hiver (DJF) pour une région couvrant la plus grand partie de l'Europe continentale (région SREX Central-Eastern Europe "CEU"). Cet ensemble contient des projections pour la période 1971-2099 (129 Years) pour 20 combinaisons de modèles GCMs (CMIP5) et RCMs, obtenues avec le scénario RCP8.5.
#' 
## ------------------------------------------------------------------------------------------------------
# Nettoyer l'espace de travail
rm(list=ls()) 

# Si ce n'est pas déjà fait, installer le package QUALYPSO (connection internet requise)
# install.packages("QUALYPSO")

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
# pattern_RCM_ <- c("CNRM-ALADIN63","MOHC-HadREM3","KNMI-RACMO22E","SMHI-RCA4_v2","DMI-HIRHAM5_v2","CLMcom-CCLM4-8-17_v2",
#                   "ICTP-RegCM4-6_v2","DMI-HIRHAM5_v4","MPI-CSC-REMO2009_v2","GERICS-REMO2015_v2","IPSL-WRF381P_v2")
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
  
  # # Handle special cases for RCM patterns with "_v2" or "_v3"
  # rcm <- rcm[order(nchar(rcm), decreasing = TRUE)][1]  # Get the longest match
  
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

#' 
#' ## Exploration des données
#' 
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

#' 
#' ## Extraction des réponses climatiques
#' La figure précédent montre clairement les différences importantes des températures projetées, même pour la période historique, de l'ordre de plusieurs degrés, sans que cela semble être une conséquence de la variabilité interne. L'extraction de la réponse climatique avec un modèle statistique permet de séparer le signal climatique de la variabilité interne et de travailler avec des différences relatives ou absolues par rapport à une période de référence. On suppose donc qu'on peut interpréter les évolutions simulées par les modèles de climat, et pas leurs valeurs absolues.
#' 
#' La fonction *smooth.spline* permet d'ajuster des splines cubiques à une série de données afin d'interpoler ou de lisser ces données. Cette approche est une alternative puissance à l'application polynomiale puisqu'on ne suppose pas *a priori* la forme de l'évolution et qu'on peut choisir facilement le degré de lissage à l'aide l'argument **spar** dans *R*. Pour *spar*=0.01, on a presque un interpolateur exact de la série alors que pour *spar*=1, on s'approche de l'ajustement d'une régression linéaire.
#' 
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

#' 
#' ## Prise en main du package QUALYPSO
#' La fonction principale du package \textit{QUALYPSO} porte le même nom et effectue les traitements d'extraction de la réponse climatique, de calcul des différences absolues ou relatives par rapport à un horizon de référence et la décomposition des incertitudes avec une méthode ANOVA. Les deux seuls arguments requis sont:
#' 
#' * **Y**: la matrice nS x nY des projections climatiques.
#' * **scenAvail**: *data.frame* nS x nEff avec les *nEff* caractéristiques (par ex. le type de GCM) pour chacune des *nS* simulations.
#' 
#' Les autres arguments sont:
#' 
#' * **X**: prédicteurs correspondants aux simulations, sous forme d'un vecteur ou de matrice. Ici, *X_time_vec* est le prédicteur temporel.
#' * **Xfut**: valeur du prédicteur pour lequel on veut obtenir la décomposition ANOVA. Dans le package, un vecteur *Xfut_time* est fourni à titre d'exemple. La première valeur défini l'horizon de référence.
#' * **listOption**: liste d'options supplémentaires. Par exemple *spar* peut être spécifié ici. Le choix d'avoir des différences absolues ou relative est spécifié avec *typeChangeVariable* qui peut valoir "abs" ou "rel" respectivement.
#' * **ANOVAmethod**: par défaut, un modèle linéaire *lm* est appliqué pour obtenir la décomposition ANOVA.
#' 
## ------------------------------------------------------------------------------------------------------
# list of options
listOption = list(typeChangeVariable='abs',spar=1)

# call QUALYPSO
# ind_ <- grep("GERICS-REMO2015_v2|IPSL-WRF381P_v2",scenAvail$RCM)
# Y <- Y[-ind_,]
# scenAvail <- scenAvail[-ind_,]

QUALYPSO.time = QUALYPSO(Y=Y,scenAvail=scenAvail,X=X_time_vec,
                         Xfut=Xfut_time,listOption=listOption)
# QUALYPSO.time = QUALYPSO(Y=Y,scenAvail=scenAvail,X=X_time_vec,
#                          Xfut=Xfut_time,listOption=listOption)

#' 
#' L'objet retourné par la fonction *QUALYPSO* est une liste contenant toutes les estimations et les informations sur la décomposition des incertitudes. Nous pouvons par exemple obtenir les informations sur les réponses au changement climatique (en différence absolue) extraites des projections dans `QUALYPSO.time$CLIMATEESPONSE$phiStar`.
#' 
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

#' 
#' On peut supposer un effect GCM, les projections obtenues avec le GCM HadGEM2-ES semble par exemple être plus "chaudes" et celles obtenues avec le GCM MPI-ESM-LR plus "froides". La décomposition ANOVA permet de quantifier ces effets.
#' 
#' La somme des effets étant pour chaque année, par construction, nulle, on peut interpréter les comportements des GCMs (ou des RCMs) relativement aux autres.
#' 
## ------------------------------------------------------------------------------------------------------
# moyenne d'ensemble
plotQUALYPSOgrandmean(QUALYPSO.time)

# effet GCM: les projections obtenues avec le GCM HadGEM2-ES sont en moyenne 0.6°C plus chaudes que les autres projections
plotQUALYPSOeffect(QUALYPSO.time,nameEff = "GCM_RCM")

# effet HM: de manière similaire, quels sont les RCMs plus marqués que les autres sur une "hausse/baisse" de la PFI ?
plotQUALYPSOeffect(QUALYPSO.time,nameEff = "HM")

#' 
#' Un des objectifs principaux de ces méthodes de décomposition d'incertitudes est de pouvoir apprécier l'importance de chacune des sources d'incertitude. La figure suivante montre la part relative de chacune de ces sources dans l'incertitude (variance) totale.
#' 
#' Quelle est la part due aux modèles climatiques? A la variabilité interne? A la variabilité résiduelle (limite du modèle ANOVA additif, non prise en compte des interactions)?
#' 
## ------------------------------------------------------------------------------------------------------
# la part des différentes sources d'incertitude est contenue dans QUALYPSO.time$DECOMPVAR
QUALYPSO.time$DECOMPVAR

# la fonction plotQUALYPSOTotalVarianceDecomposition permet d'illustrer cette décomposition
plotQUALYPSOTotalVarianceDecomposition(QUALYPSO.time)

# la variabilité des réponses au changement climatique (écart-type) correspond à la variance totale issue de l'ANOVA, sans la variabilité interne
phiStar = QUALYPSO.time$CLIMATERESPONSE$phiStar
apply(phiStar,2,sd)
sqrt(QUALYPSO.time$TOTALVAR*(1-QUALYPSO.time$DECOMPVAR[,4]))

#' 
#' On peut également représenter la tendance moyenne et l'incertitude totale associée, sous l'hypothèse que la variable de changement $Y^*(t)$ suit une loi normale de moyenne $\mu(t)$ (effet moyen global) et d'écart-type $\sqrt{Var(Y^*(t))}$ (incertitude totale).
#' 
#' Par défaut la fonction *plotQUALYPSOMeanChangeAndUncertainties* montre des intervalles à 90\% (option  *probCI* dans *listOption*). La part des différentes sources d'incertitudes dans l'épaisseur totale de la bande colorée correspond à la part dans la variance totale (voir figure précédente).
#' 
## ------------------------------------------------------------------------------------------------------
plotQUALYPSOMeanChangeAndUncertainties(QUALYPSO.time)

#' 
#' ## Analyse en fonction du niveau de réchauffement
#' La possibilité de considérer et de caractériser les changements attendus pour un futur correspondant à un certain réchauffement global suscite un intérêt croissant pour les scientifiques et les décideurs. Classiquement, les analyses d’incertitude sont effectuées pour différents horizons temporels. Pouvoir partitionner et quantifier les incertitudes pour un horizon de « réchauffement » donné (par exemple un horizon +2°C) permet d’apporter une plus-value importante aux multiples travaux réalisés actuellement sur cette question.  Actuellement, l’approche proposée pour ce type d’analyse consiste à échantillonner les réponses climatiques pour un réchauffement global de 1.5°C et d’autres niveaux de réchauffement (Seneviratne et al. 2018; Verfaillie et al. 2018). Le package QUALYPSO propose un cadre statistique pour ce type d’analyse.
#' 
#' L'approche proposée ici est d'associer des niveaux de températures globales à chacune des projections à partir des températures moyennes annuelles obtenues à l'échelle planétaire avec chacun des GCM. La matrice `X_globaltas` contient ces données pour chacune des projections. Si des projections régionales obtenues avec le même GCM, les niveaux de réchauffement sont donc identiques. On prend une unique température planétaire de référence `Xref=13` par simplicité mais on peut également associer une température de référence différente pour chaque GCM, si on veut qu'elle correspond à une période/année particulière (par ex. la période pré-industrielle).
#' 
## ------------------------------------------------------------------------------------------------------
range(X_globaltas)
dim(X_globaltas)
plot(-1,-1,xlim=range(X_time_vec),ylim=range(X_globaltas),xlab="Years",ylab="Température (°C)")
for(i in 1:nrow(X_globaltas)){
  lines(X_time_vec,X_globaltas[i,],col=i)
}

# list of options
listOption = list(typeChangeVariable='abs')

# call QUALYPSO
QUALYPSO.globaltas = QUALYPSO(Y=Y,scenAvail=scenAvail,X=X_globaltas,
                              Xfut=Xfut_globaltas,listOption=listOption)

# grand mean effect
plotQUALYPSOgrandmean(QUALYPSO.globaltas,xlab="Temperature globale (Celsius)")

# main GCM effects
plotQUALYPSOeffect(QUALYPSO.globaltas,nameEff="GCM",xlab="Temperature globale (Celsius)")

# main RCM effects
plotQUALYPSOeffect(QUALYPSO.globaltas,nameEff="RCM",xlab="Temperature globale (Celsius)")

# mean change and associated uncertainties
plotQUALYPSOMeanChangeAndUncertainties(QUALYPSO.globaltas,xlab="Temperature globale (Celsius)")

# variance decomposition
plotQUALYPSOTotalVarianceDecomposition(QUALYPSO.globaltas,xlab="Temperature globale (Celsius)")

#' 
#' ```
#' knitr::purl(input="./TP2.Rmd", output="./TP2.r", documentation = 2)
#' ```
