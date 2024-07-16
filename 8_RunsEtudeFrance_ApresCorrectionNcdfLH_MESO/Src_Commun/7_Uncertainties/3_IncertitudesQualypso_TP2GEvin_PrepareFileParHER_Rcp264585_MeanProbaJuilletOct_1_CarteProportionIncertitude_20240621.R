# Charger le package
library(QUALYPSO)
library(ggplot2)
library(strex)

source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_Commun/7_Uncertainties/QUALYPSO/R/QUALYPSO.r")

### Functions ###
# saveGraph_ <- function(output_name_, functionGraph){
#   pdf(paste0(output_name_,".pdf"),
#       width = 18)
#   functionGraph()
#   dev.off()
#   
#   saveRDS(p, file = paste0(output_name_,".rds"))
#   
#   svg_device <- svglite(paste0(output_name_,".svg"), width = 18)#,
#   functionGraph()
#   dev.off()
#   
#   png(paste0(output_name_,".png"), width = 9*100)
#   functionGraph()
#   dev.off()
# }


plot_graph_1 <- function(X_time_vec,Y) {
  plot(-1, -1, xlim = range(X_time_vec), ylim = range(Y), xlab = "Years", ylab = "          PFI (%)", yaxt = "n", cex.lab = 1.5, cex.axis = 1.4)
  for (i in 1:nrow(Y)) {
    lines(X_time_vec, Y[i, ], col = i)
  }
  y_labels <- pretty(range(Y))
  axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1, cex.axis = 1.3)
}

plot_graph_2 <- function(X_time_vec,Y,sizeWindow,nYmean,vecYmean){
  plot(-1,-1,xlim=range(X_time_vec),ylim=range(Y),xlab="Years",ylab="          PFI (%)",yaxt="n",cex.lab=1.5,cex.axis=1.2)
  for(i in 1:nrow(Y)){
    for(y in 1:nYmean){
      vecYmean[y] = mean(Y[i,y:(y+sizeWindow-1)])
    }
    lines(X_time_vec[1:nYmean]+sizeWindow/2,vecYmean,col=i)
  }
  y_labels <- pretty(range(Y))
  axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1, cex.axis = 1.3)
}

plot_graph_3 <- function(X_time_vec,Y,vec_sPar,iSimu){
  plot(-1,-1,xlim=range(X_time_vec),ylim=range(Y[iSimu,]),xlab="Years",ylab="          PFI (%)",yaxt="n",cex.lab=1.5,cex.axis=1.2)
  lines(X_time_vec,Y[iSimu,],col="black")
  for(i in 1:3){
    ySmooth = smooth.spline(x = X_time_vec,y = Y[iSimu,], spar=vec_sPar[i])$y
    lines(X_time_vec,ySmooth,col="red",lty=i,lwd=2)
  }
  legend("bottomright",legend = vec_sPar,lty=1:3,col="red",title="spar")
  y_labels <- pretty(range(range(Y[iSimu,])))
  axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1, cex.axis = 1.3)
}

plot_graph_4 <- function(Xfut_time,Y,phiStar){
  plot(-1,-1,xlim=range(Xfut_time),ylim=range(phiStar),xlab="Years",ylab="          PFI (%)",yaxt="n",cex.lab=1.5,cex.axis=1.2)
  for(i in 1:nrow(Y)){
    lines(Xfut_time,phiStar[i,],col=i)
  }
  y_labels <- pretty(range(range(phiStar)))
  axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1, cex.axis = 1.3)
}

plot_graph_5 <- function(Xfut_time,Y,phiStar,scenAvail,vecGCM){
  plot(-1,-1,xlim=range(Xfut_time),ylim=range(phiStar),xlab="Years",ylab="          PFI (%)",yaxt="n",cex.lab=1.5,cex.axis=1.2)
  for(i in 1:nrow(Y)){
    lines(Xfut_time,phiStar[i,],col=which(scenAvail$GCM[i]==vecGCM))
  }
  legend("topleft",legend=vecGCM,col=1:4,lty=1)
  y_labels <- pretty(range(range(phiStar)))
  axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1, cex.axis = 1.3)
}

runPlot <- function(Y,scenAvail,X_time_vec,Xfut_time,nomSimulation_,HER_,nomVariable_,ylim_,ylim_enveloppe_){
  
  # if (!dir.exists(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/"))){
  #   dir.create(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/"))
  # }
  # if (!dir.exists(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/"))){
  #   dir.create(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/"))
  # }
  
  # La variabilité inter-annuelle est importante. On regarde souvent les moyennes sur 30 ans pour obtenir des statistiques du climat sur des fenêtres glissantes et gommer une partie de cette variabilité haute-fréquence
  sizeWindow = 30
  nYmean = ncol(Y)-30
  vecYmean = vector(length=nYmean)
  
  #' ## Extraction des réponses climatiques
  ## ------------------------------------------------------------------------------------------------------
  # illustration pour la première simulation: peut être modifié
  iSimu=1
  # sPar peut varier entre 0 et l'infini
  vec_sPar = c(0.01,0.5,1)
  
  ## ------------------------------------------------------------------------------------------------------
  # list of options
  # listOption = list(typeChangeVariable='abs',spar=1)
  listOption = list(typeChangeVariable='rel',spar=1)
  
  QUALYPSO.time = QUALYPSO(Y=Y,scenAvail=scenAvail,X=X_time_vec,
                           Xfut=Xfut_time,listOption=listOption)

  ## ------------------------------------------------------------------------------------------------------
  phiStar = QUALYPSO.time$CLIMATERESPONSE$phiStar
  
  # on peut essayer de produire une figure similaire avec une couleur par GCM
  vecGCM = unique(scenAvail$GCM)
  
  ## ------------------------------------------------------------------------------------------------------
  # la part des différentes sources d'incertitude est contenue dans QUALYPSO.time$DECOMPVAR
  QUALYPSO.time$DECOMPVAR
  
  incertitudes_ <- exportQUALYPSOTotalVarianceDecomposition(QUALYPSOOUT = QUALYPSO.time,
                                                            cex.lab=1.5,
                                                            cex.axis=1.2,
                                                            ylim=ylim_enveloppe_,
                                                            outputName_ = NA)
  # incertitudes_ <- exportQUALYPSOTotalVarianceDecomposition(QUALYPSOOUT = QUALYPSO.time,
  #                                                           cex.lab=1.5,
  #                                                           cex.axis=1.2,
  #                                                           ylim=ylim_enveloppe_,
  #                                                           outputName_ = paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/9_ChroniquesPFI_TotalVarianceDecomposition_",nomVariable_,"_",nomSimulation_,"_1_20240526"))
  
  incertitudes_ <- data.frame(t(colMeans(incertitudes_)))
  rownames(incertitudes_) <- c(as.character(HER_))
  return(incertitudes_)
  
}


df_incertitudes_ <- data.frame()

HER_list_ <- c("2", "3", "5", "12", "13", "14", "17", "21", "22", "24", "25", "27", "28", "34", "35", "36",
               "38", "40", "41", "43", "44", "50", "51", "52", "53", "55", "56", "57", "58", "59", "61", 
               "62", "63", "64", "65", "66", "67", "68", "70", "71", "73", "74", "75", "76", "77", "78",
               "79", "81", "84", "85", "86", "87", "91", "93", "94", "97", "98", "99", "101", "103", "104",
               "105", "106", "107", "108", "112", "113", "117", "118", "120", "31033039", "37054", "69096",
               "89092", "49090")

# HER_eliminees_J2000 <- c("10", "21", "22", "24", "27", "34", "35", "36", "57", "59", "61", "65", "67", "68",
#                          "77", "78", "93", "94", "103", "108", "118", "0", "31033039", "69096",
#                          "66", "64", "117", "112", "56", "62", "38", "40", "105", "17", "25", "107",
#                          "55", "12", "53")

# HER_ = 57 #Haute Normandie Picardie (57)
# HER_ = 81 #Plaine de Bourgogne (81)
# HER_ = 13 #Dévoluy Vercors sud (13)
# HER_ = 105 #Plaine méditerranéenne (105)

for (HER_ in HER_list_){
  
  ### Parameters ###
  ratio_epaisseurs_ = 1
  
  # nomVariable_ = "NbJoursSup20"
  nomVariable_ = "rcp26and45and85_CtripGrsdJ2000OrchideeSmash"
  ylim_param_ = c(-2.5,2.5)
  ylim_enveloppe_param_ = c(-2.5,2.5)
  
  ###########################
  ######### RCP 8.5 #########
  ###########################
  
  # Les projections de moyennes de température hivernale pour 20 simulations de 129 Years sont contenus dans Y sous la forme d'une matrice 20 x 129
  # list_files_ <- list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProba_LearnBrut_ByHer/FDC_Projections/",
  list_files_ <- list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/FDC_Projections/",
                            pattern = paste0("Tab_AnnualMean_",HER_,".txt"), full.names = T, recursive = T, include.dirs = F)
  # list_files_ <- list_files_[grepl("CTRIP",list_files_)]
  # list_files_ <- list_files_[grepl("ADAMONT",list_files_)]
  list_files_ <- list_files_[grepl("rcp85",list_files_)]
  list_files_ <- list_files_[!grepl("J2000_20231128_avecHERexclues",list_files_)]
  
  
  Y = data.frame()
  noms_chaines_ = c()
  
  for (fl in list_files_){
    tab_ <- read.table(fl, header = T, sep = ";", dec = ".")
    tab_ <- tab_[which(tab_$Year >= 1976 & tab_$Year <= 2099),]
    colnames(tab_)[2:ncol(tab_)] <- paste0(strsplit(fl,"/")[[1]][13],"_",colnames(tab_)[2:ncol(tab_)])
    # colnames(tab_)[2] <- paste0(strsplit(fl,"/")[[1]][c(13,15)], collapse = "_")
    
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
  dim(Y) # 124 annees, 136 simu
  
  # Les Years correspondantes sont contenues dans le vecteur X_time_vec
  X_time_vec <- Y$Year
  Y <- Y[,which(colnames(Y) != "Year")]
  colnames(Y) <- gsub("\\.", "_", colnames(Y))
  Y <- Y[,grepl("ADAMONT",colnames(Y))]
  
  
  # Les modèles GCM et RCM correspondants aux 20 simulations sont données dans scenAvail (data.frame avec deux colonnes "GCM" et "RCM" et 20 lignes correspondant aux 20 simulations). Ces 20 simulations correspondent à 4 GCMs descendus en échelle aveec 5 RCMs
  pattern_HM_ <- c("CTRIP","GRSD","J2000","ORCHIDEE","SMASH")
  pattern_GCM_ <- c("CNRM_CERFACS_CNRM_CM5",
                    "ICHEC_EC_EARTH",
                    "IPSL_IPSL_CM5A_MR",
                    "MOHC_HadGEM2_ES",
                    "MPI_M_MPI_ESM_LR",
                    "NCC_NorESM1_M")
  pattern_RCM_ <- c("CNRM_ALADIN6",
                    "MOHC_HadREM3_GA7_05",
                    "KNMI_RACMO22E",
                    "SMHI_RCA4",
                    "DMI_HIRHAM5",
                    "CLMcom_CCLM4_8_17",
                    "ICTP_RegCM4_6",
                    "MPI_CSC_REMO2009",
                    "GERICS_REMO2015",
                    "IPSL_WRF381P")
  
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
  table(scenAvail$GCM)
  table(scenAvail$RCM)
  table(scenAvail$HM)
  # scenAvail$GCM_RCM <- paste0(scenAvail$GCM," + ",scenAvail$RCM)
  # scenAvail <- scenAvail[,c("GCM_RCM","HM")]
  # apply(scenAvail,2,unique)
  
  Y <- t(Y)
  Y_rcp85 <- Y
  scenAvail_rcp85 <- scenAvail
  
  
  ###########################
  ######### RCP 4.5 #########
  ###########################
  
  
  # Les projections de moyennes de température hivernale pour 20 simulations de 129 Years sont contenus dans Y sous la forme d'une matrice 20 x 129
  list_files_ <- list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/FDC_Projections/",
                            pattern = paste0("Tab_AnnualMean_",HER_,".txt"), full.names = T, recursive = T, include.dirs = F)
  
  # list_files_ <- list_files_[grepl("CTRIP",list_files_)]
  # list_files_ <- list_files_[grepl("ADAMONT",list_files_)]
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
    colnames(tab_)[2:ncol(tab_)] <- paste0(strsplit(fl,"/")[[1]][13],"_",colnames(tab_)[2:ncol(tab_)])
    # colnames(tab_)[2] <- paste0(strsplit(fl,"/")[[1]][c(13,15)], collapse = "_")
    
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
  colnames(Y) <- gsub("\\.", "_", colnames(Y))
  Y <- Y[,grepl("ADAMONT",colnames(Y))]
  
  # Les modèles GCM et RCM correspondants aux 20 simulations sont données dans scenAvail (data.frame avec deux colonnes "GCM" et "RCM" et 20 lignes correspondant aux 20 simulations). Ces 20 simulations correspondent à 4 GCMs descendus en échelle aveec 5 RCMs
  pattern_HM_ <- c("CTRIP","GRSD","J2000","ORCHIDEE","SMASH")
  # pattern_GCM_ <- c("CNRM-CM5","EC-EARTH","IPSL-CM5A","MOHC-HadGEM2","MPI-ESM-LR","NCC-NorESM1-M")
  pattern_GCM_ <- c("CNRM_CERFACS_CNRM_CM5",
                    "ICHEC_EC_EARTH",
                    "IPSL_IPSL_CM5A_MR",
                    "MOHC_HadGEM2_ES",
                    "MPI_M_MPI_ESM_LR",
                    "NCC_NorESM1_M")
  pattern_RCM_ <- c("CNRM_ALADIN6",
                    "MOHC_HadREM3_GA7_05",
                    "KNMI_RACMO22E",
                    "SMHI_RCA4",
                    "DMI_HIRHAM5",
                    "CLMcom_CCLM4_8_17",
                    "ICTP_RegCM4_6",
                    "MPI_CSC_REMO2009",
                    "GERICS_REMO2015",
                    "IPSL_WRF381P")

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
  # scenAvail$GCM_RCM <- paste0(scenAvail$GCM," + ",scenAvail$RCM)
  # scenAvail <- scenAvail[,c("GCM_RCM","HM")]
  # apply(scenAvail,2,unique)
  
  Y <- t(Y)
  Y_rcp45 <- Y
  scenAvail_rcp45 <- scenAvail
  
  
  
  
  
  
  ###########################
  ######### RCP 2.6 #########
  ###########################
  
  
  # Les projections de moyennes de température hivernale pour 20 simulations de 129 Years sont contenus dans Y sous la forme d'une matrice 20 x 129
  list_files_ <- list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/FDC_Projections/",
                            pattern = paste0("Tab_AnnualMean_",HER_,".txt"), full.names = T, recursive = T, include.dirs = F)
  
  # list_files_ <- list_files_[grepl("CTRIP",list_files_)]
  # list_files_ <- list_files_[grepl("ADAMONT",list_files_)]
  list_files_ <- list_files_[grepl("rcp26",list_files_)]
  list_files_ <- list_files_[!grepl("J2000_20231128_avecHERexclues",list_files_)]
  list_files_ <- list_files_[!grepl("saveAvantAjout2projOubliees202305",list_files_)]
  list_files_ <- list_files_[!grepl("saveAvant20240513",list_files_)]
  
  Y = data.frame()
  for (fl in list_files_){
    tab_ <- read.table(fl, header = T, sep = ";", dec = ".")
    # tab_ <- group_by()
    tab_ <- tab_[which(tab_$Year >= 1976 & tab_$Year <= 2099),]
    # tab_ <- tab_ %>%
    #   group_by(Year) %>%
    #   summarize(mean_PFI = mean(mean_PFI, na.rm = TRUE))
    colnames(tab_)[2:ncol(tab_)] <- paste0(strsplit(fl,"/")[[1]][13],"_",colnames(tab_)[2:ncol(tab_)])
    # colnames(tab_)[2] <- paste0(strsplit(fl,"/")[[1]][c(13,15)], collapse = "_")
    
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
  colnames(Y) <- gsub("\\.", "_", colnames(Y))
  Y <- Y[,grepl("ADAMONT",colnames(Y))]
  
  # Les modèles GCM et RCM correspondants aux 20 simulations sont données dans scenAvail (data.frame avec deux colonnes "GCM" et "RCM" et 20 lignes correspondant aux 20 simulations). Ces 20 simulations correspondent à 4 GCMs descendus en échelle aveec 5 RCMs
  pattern_HM_ <- c("CTRIP","GRSD","J2000","ORCHIDEE","SMASH")
  # pattern_GCM_ <- c("CNRM-CM5","EC-EARTH","IPSL-CM5A","MOHC-HadGEM2","MPI-ESM-LR","NCC-NorESM1-M")
  pattern_GCM_ <- c("CNRM_CERFACS_CNRM_CM5",
                    "ICHEC_EC_EARTH",
                    "IPSL_IPSL_CM5A_MR",
                    "MOHC_HadGEM2_ES",
                    "MPI_M_MPI_ESM_LR",
                    "NCC_NorESM1_M")
  pattern_RCM_ <- c("CNRM_ALADIN6",
                    "MOHC_HadREM3_GA7_05",
                    "KNMI_RACMO22E",
                    "SMHI_RCA4",
                    "DMI_HIRHAM5",
                    "CLMcom_CCLM4_8_17",
                    "ICTP_RegCM4_6",
                    "MPI_CSC_REMO2009",
                    "GERICS_REMO2015",
                    "IPSL_WRF381P")

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
  # scenAvail$GCM_RCM <- paste0(scenAvail$GCM," + ",scenAvail$RCM)
  # scenAvail <- scenAvail[,c("GCM_RCM","HM")]
  # apply(scenAvail,2,unique)
  
  Y <- t(Y)
  Y_rcp26 <- Y
  scenAvail_rcp26 <- scenAvail
  
  
  
  
  ############################################
  ######### RCP 26 + RCP 45 + RCP 85 #########
  ############################################
  
  Y_rcp26and45and85 <- rbind(Y_rcp26,Y_rcp45,Y_rcp85)
  scenAvail_rcp26$RCP <- "RCP 2.6"
  scenAvail_rcp45$RCP <- "RCP 4.5"
  scenAvail_rcp85$RCP <- "RCP 8.5"
  scenAvail_rcp26and45and85 <- rbind(scenAvail_rcp26,scenAvail_rcp45,scenAvail_rcp85)
  Y <- Y_rcp26and45and85
  
  # #### Rcp 45+85 sans J2000 ###
  ind_ <- which(scenAvail_rcp26and45and85$HM %in% c("CTRIP","GRSD","J2000","ORCHIDEE","SMASH"))
  scenAvail_rcp26and45and85 <- scenAvail_rcp26and45and85[ind_,]
  Y <- Y_rcp26and45and85[ind_,]
  line_ <- runPlot(Y = Y,
                   # scenAvail = scenAvail_rcp45and85_sansJ2000Orchidee[,c("GCM_RCM","HM")],
                   scenAvail = scenAvail_rcp26and45and85,
                   X_time_vec = X_time_vec,
                   # Xfut_time = Xfut_time,
                   Xfut_time = c(seq(1990,2090,by =10),2099),
                   HER_ = HER_,
                   nomVariable_ = "rcp26and45and85_CtripGrsdJ2000OrchideeSmash",
                   ylim_ = ylim_param_,
                   ylim_enveloppe_ = ylim_enveloppe_param_)

  if (nrow(df_incertitudes_) == 0){
    df_incertitudes_ <- line_
  }else{
    df_incertitudes_ <- rbind(df_incertitudes_, line_)
  }
}

df_incertitudes_$HER <- rownames(df_incertitudes_)
df_incertitudes_ <- df_incertitudes_[,c("HER","GCM","RCM","HM","RCP","ResidualVar","InternalVar")]

write.table(df_incertitudes_,
            # "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240619/TableProportionsIncertitudes_20702099_1_20240619.csv",
            "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240619/TableProportionsIncertitudes_20702099_Rcp264585_1_20240621.csv",
            sep = ";", dec = ".", row.names = F)

  
  # Y = Y_rcp26and45and85
  # scenAvail = scenAvail_rcp26and45and85
  # X_time_vec = X_time_vec
  # # Xfut_time = Xfut_time,
  # Xfut_time = c(seq(1990,2090,by =10),2099)
  # nomSimulation_ = "rcp26andrcp45and85"
  # ylim_ = ylim_param_
  # ylim_enveloppe_ = ylim_enveloppe_param_
  
  
  # #### Rcp 45 sans J2000 et ORCHIDEE ###
  # ind_ <- which(scenAvail_rcp45$HM %in% c("CTRIP","GRSD","SMASH"))
  # scenAvail_rcp45_sansJ2000Orchidee <- scenAvail_rcp45[ind_,]
  # Y <- Y_rcp45[ind_,]
  # runPlot(Y = Y,
  #         scenAvail = scenAvail_rcp45_sansJ2000Orchidee[,c("GCM_RCM","HM")],
  #         X_time_vec = X_time_vec,
  #         # Xfut_time = Xfut_time,
  #         Xfut_time = c(seq(1990,2090,by =10),2099),
  #         nomSimulation_ = "rcp45_CtripGrsdSmash",
  #         ylim_ = ylim_param_,
  #         ylim_enveloppe_ = ylim_enveloppe_param_)
  # 
  # #### Rcp 85 sans J2000 et ORCHIDEE ###
  # ind_ <- which(scenAvail_rcp85$HM %in% c("CTRIP","GRSD","SMASH"))
  # scenAvail_rcp85_sansJ2000Orchidee <- scenAvail_rcp85[ind_,]
  # Y <- Y_rcp85[ind_,]
  # runPlot(Y = Y,
  #         scenAvail = scenAvail_rcp85_sansJ2000Orchidee[,c("GCM_RCM","HM")],
  #         X_time_vec = X_time_vec,
  #         # Xfut_time = Xfut_time,
  #         Xfut_time = c(seq(1990,2090,by =10),2099),
  #         nomSimulation_ = "rcp85_CtripGrsdSmash",
  #         ylim_ = ylim_param_,
  #         ylim_enveloppe_ = ylim_enveloppe_param_)
  # 
  # #### Rcp 45+85 sans J2000 et ORCHIDEE ###
  # ind_ <- which(scenAvail_rcp26and45and85$HM %in% c("CTRIP","GRSD","SMASH"))
  # scenAvail_rcp26and45and85_sansJ2000Orchidee <- scenAvail_rcp26and45and85[ind_,]
  # Y <- Y_rcp26and45and85[ind_,]
  # runPlot(Y = Y,
  #         # scenAvail = scenAvail_rcp45and85_sansJ2000Orchidee[,c("GCM_RCM","HM")],
  #         scenAvail = scenAvail_rcp26and45and85_sansJ2000Orchidee,
  #         X_time_vec = X_time_vec,
  #         # Xfut_time = Xfut_time,
  #         Xfut_time = c(seq(1990,2090,by =10),2099),
  #         nomSimulation_ = "rcp45and85_CtripGrsdSmash",
  #         ylim_ = ylim_param_,
  #         ylim_enveloppe_ = ylim_enveloppe_param_)
  # 
  # 
  # 
  # 
  # 
  # #### Rcp 45+85 sans J2000 ###
  # ind_ <- which(scenAvail_rcp45and85$HM %in% c("CTRIP","GRSD","ORCHIDEE","SMASH"))
  # scenAvail_rcp26andrcp45and85_sansJ2000 <- scenAvail_rcp26andrcp45and85[ind_,]
  # Y <- Y_rcp26and45and85[ind_,]
  # runPlot(Y = Y,
  #         # scenAvail = scenAvail_rcp45and85_sansJ2000Orchidee[,c("GCM_RCM","HM")],
  #         scenAvail = scenAvail_rcp26andrcp45and85_sansJ2000,
  #         X_time_vec = X_time_vec,
  #         # Xfut_time = Xfut_time,
  #         Xfut_time = c(seq(1990,2090,by =10),2099),
  #         nomSimulation_ = "rcp45and85_CtripGrsdOrchideeSmash",
  #         ylim_ = ylim_param_,
  #         ylim_enveloppe_ = ylim_enveloppe_param_)
  # 
  # 
  # 
  
  
  
  
#   ###################################
#   ######### RCP 45 + RCP 85 #########
#   ###################################
#   
#   Y_rpc45and85 <- rbind(Y_rcp45,Y_rcp85)
#   scenAvail_rcp45$RCP <- "rcp45"
#   scenAvail_rcp85$RCP <- "rcp85"
#   scenAvail_rpc45and85 <- rbind(scenAvail_rcp45,scenAvail_rcp85)
#   Y <- Y_rpc45and85
#   
#   line_ <- runPlot(Y = Y_rpc45and85,
#                    scenAvail = scenAvail_rpc45and85,
#                    X_time_vec = X_time_vec,
#                    # Xfut_time = Xfut_time,
#                    Xfut_time = c(seq(1990,2090,by =10),2099),
#                    nomSimulation_ = paste0("rcp45and85_HER",HER_),
#                    HER_ = HER_,
#                    nomVariable_ = nomVariable_,
#                    ylim_ = ylim_param_,
#                    ylim_enveloppe_ = ylim_enveloppe_param_)
#   
#   
#   if (nrow(df_incertitudes_) == 0){
#     df_incertitudes_ <- line_
#   }else{
#     df_incertitudes_ <- rbind(df_incertitudes_, line_)
#   }
#   
#   # GCM       RCM         HM      RCP ResidualVar InternalVar
#   # 13 0.07354784 0.1701444 0.05908209 0.086623  0.05957753   0.5510251
#   # 57 0.169949 0.1803736 0.07266383 0.002190806  0.08781374   0.4870091
#   # 81 0.1327336 0.1950446 0.09928366 0.009986121  0.05229923   0.5106528
#   # 105 0.1803949 0.1914382 0.01407187 0.05884238    0.106335   0.4489177
#   
# }
# 
# df_incertitudes_$HER <- rownames(df_incertitudes_)
# df_incertitudes_ <- df_incertitudes_[,c("HER","GCM","RCM","HM","RCP","ResidualVar","InternalVar")]
# 
# write.table(df_incertitudes_,
#             "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240619/TableProportionsIncertitudes_20702099_1_20240619.csv",
#             sep = ";", dec = ".", row.names = F)

