
### Parameters ###
ratio_epaisseurs_ = 1
nomVariable_ = "ProbaMeanJuilOct_SplitRCPGCM_Pondere_rcp264585"
ylim_param_ = c(-2.5,2.5)
ylim_enveloppe_param_ = c(-2.5,2.5)

###########################
######### RCP 8.5 #########
###########################

date_ref_ <- c(1976:2005)
date_finSiecle_ <- c(2070:2099)

HER_list_ <- c("2", "3", "5", "12", "13", "14", "17", "21", "22", "24", "25", "27", "28", "34", "35", "36",
               "38", "40", "41", "43", "44", "50", "51", "52", "53", "55", "56", "57", "58", "59", "61", 
               "62", "63", "64", "65", "66", "67", "68", "70", "71", "73", "74", "75", "76", "77", "78",
               "79", "81", "84", "85", "86", "87", "91", "93", "94", "97", "98", "99", "101", "103", "104",
               "105", "106", "107", "108", "112", "113", "117", "118", "120", "31033039", "37054", "69096",
               "89092", "49090")


### CTRIP, GRSD, ORCHIDEE, SMASH ###
df_ <- data.frame()

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
  list_files_ <- list_files_[!grepl("J2000",list_files_)]
  
  
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
  
  dim(Y_rcp85)
  length(X_time_vec)
  colnames(Y_rcp85) <- X_time_vec
  
  Y_rcp85_ref_ <- Y_rcp85[,which(colnames(Y_rcp85) %in% date_ref_)]
  Y_rcp85_ref_mean_ <- rowMeans(Y_rcp85_ref_)

  Y_rcp85_finSiecle_ <- Y_rcp85[,which(colnames(Y_rcp85) %in% date_finSiecle_)]
  Y_rcp85_finSiecle_mean_ <- rowMeans(Y_rcp85_finSiecle_)
  
  Y_comp_ <- data.frame(ifelse(Y_rcp85_ref_mean_<Y_rcp85_finSiecle_mean_, 1, ifelse(Y_rcp85_ref_mean_>Y_rcp85_finSiecle_mean_,-1,0)))
    
  if (nrow(df_) == 0){
    df_ <- Y_comp_
    colnames(df_) <- HER_
  }else{
    if (all(rownames(df_) == rownames(Y_comp_))){
      df_ <- cbind(df_, Y_comp_)
      colnames(df_) <- c(colnames(df_)[-length(colnames(df_))], HER_)
    }
  }
}
dim(df_)




### J2000 ###
df_J2000_ <- data.frame()

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
  list_files_ <- list_files_[grepl("J2000",list_files_)]
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
  
  if (nrow(Y)>0){
    
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
    
    dim(Y_rcp85)
    length(X_time_vec)
    colnames(Y_rcp85) <- X_time_vec
    
    Y_rcp85_ref_ <- Y_rcp85[,which(colnames(Y_rcp85) %in% date_ref_)]
    Y_rcp85_ref_mean_ <- rowMeans(Y_rcp85_ref_)
    
    Y_rcp85_finSiecle_ <- Y_rcp85[,which(colnames(Y_rcp85) %in% date_finSiecle_)]
    Y_rcp85_finSiecle_mean_ <- rowMeans(Y_rcp85_finSiecle_)
    
    Y_comp_ <- data.frame(ifelse(Y_rcp85_ref_mean_<Y_rcp85_finSiecle_mean_, 1, ifelse(Y_rcp85_ref_mean_>Y_rcp85_finSiecle_mean_,-1,0)))
    
    if (nrow(df_J2000_) == 0){
      df_J2000_ <- Y_comp_
      colnames(df_J2000_) <- HER_
    }else{
      if (all(rownames(df_J2000_) == rownames(Y_comp_))){
        df_J2000_ <- cbind(df_J2000_, Y_comp_)
        colnames(df_J2000_) <- c(colnames(df_J2000_)[-length(colnames(df_J2000_))], HER_)
      }
    }
  }
}
df_J2000_




dim(df_J2000_)
dim(df_)

head(df_J2000_)
head(df_)

colnames(df_J2000_)
colnames(df_)

for (i in 1:length(colnames(df_))){
  if (! colnames(df_)[i] %in% colnames(df_J2000_)){
    df_J2000_[[colnames(df_)[i]]] = NA
  }
}

df_merge_ <- rbind(df_,
                   df_J2000_)

df_merge_$Chaines <- rownames(df_merge_)
df_merge_ <- df_merge_[, c("Chaines", setdiff(names(df_merge_), "Chaines"))]

write.table(df_merge_, "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/MIA/IndexMIAparHER_1_20240625.csv",
            sep = ";", dec = ".", row.names = F)

# Y_rcp85[Y_rcp85]
# date_ref_[1]



col_means_CTRIP <- colSums(df_merge_[grepl("CTRIP",df_merge_$Chaines),c(2:ncol(df_merge_))])/nrow(df_merge_[grepl("CTRIP",df_merge_$Chaines),])*100
col_means_GRSD <- colSums(df_merge_[grepl("GRSD",df_merge_$Chaines),c(2:ncol(df_merge_))])/nrow(df_merge_[grepl("GRSD",df_merge_$Chaines),])*100
col_means_J2000 <- colSums(df_merge_[grepl("J2000",df_merge_$Chaines),c(2:ncol(df_merge_))])/nrow(df_merge_[grepl("J2000",df_merge_$Chaines),])*100
col_means_ORCHIDEE <- colSums(df_merge_[grepl("ORCHIDEE",df_merge_$Chaines),c(2:ncol(df_merge_))])/nrow(df_merge_[grepl("ORCHIDEE",df_merge_$Chaines),])*100
col_means_SMASH <- colSums(df_merge_[grepl("SMASH",df_merge_$Chaines),c(2:ncol(df_merge_))])/nrow(df_merge_[grepl("SMASH",df_merge_$Chaines),])*100
col_means_Total <- colSums(df_merge_[,c(2:ncol(df_merge_))], na.rm = T)/nrow(df_merge_)*100

# Convertir le résultat en dataframe
col_means_CTRIP <- as.data.frame(t(t(col_means_CTRIP)))
colnames(col_means_CTRIP) <- "CTRIP"
col_means_GRSD <- as.data.frame(t(t(col_means_GRSD)))
colnames(col_means_GRSD) <- "GRSD"
col_means_J2000 <- as.data.frame(t(t(col_means_J2000)))
colnames(col_means_J2000) <- "J2000"
col_means_ORCHIDEE <- as.data.frame(t(t(col_means_ORCHIDEE)))
colnames(col_means_ORCHIDEE) <- "ORCHIDEE"
col_means_SMASH <- as.data.frame(t(t(col_means_SMASH)))
colnames(col_means_SMASH) <- "SMASH"
col_means_Total <- as.data.frame(t(t(col_means_Total)))
colnames(col_means_Total) <- "Total"

col_means_merge <- cbind(col_means_Total,
                         col_means_CTRIP,
                         col_means_GRSD,
                         col_means_J2000,
                         col_means_ORCHIDEE,
                         col_means_SMASH)
col_means_merge$HER <- rownames(col_means_merge)
col_means_merge$CdHER2 <- rownames(col_means_merge)
col_means_merge$CdHER2[which(col_means_merge$CdHER2 %in% c("31033039","37054","69096","89092","49090"))] <- gsub("0","+",col_means_merge$CdHER2[which(col_means_merge$CdHER2 %in% c("31033039","37054","69096","89092","49090"))])
col_means_merge$CdHER2[which(col_means_merge$CdHER2 %in% c("49+9+"))] <- "49+90"
col_means_merge$HER[which(col_means_merge$HER %in% c("31033039","37054","69096","89092","49090"))] <- gsub("0","+",col_means_merge$HER[which(col_means_merge$HER %in% c("31033039","37054","69096","89092","49090"))])
col_means_merge$HER[which(col_means_merge$HER %in% c("49+9+"))] <- "49+90"



# Exporter le résultat en colonne dans un fichier CSV
write.csv(col_means_merge,
          "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/MIA/IndexMIAparHER_Total_1_20240625.csv",
          row.names = FALSE)


source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_31_NewColors_Svg_20240319.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_32_Surligner_NewColors_Svg_20240617.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")

plot_map_variable_sansEtiquettes <- function(tab_, varname_, vartitle_, breaks_, output_name_, title_, reverseColors_, nomPalette_, labels_name_ = FALSE, sansTexteHer_ = FALSE, reverseLegend_ = FALSE, echelleAttenuee_ = FALSE, addValueUnder = NULL, HER2_excluesDensity_ = NULL, subtitle_ = NULL, annotation_txt_ = TRUE, percentFormat = T, borderCol = "#454547", doubleLegend_ = T, taillePalette = NULL, retenuPalette = NULL, reverseFinal = F, reverseFinal_bis = F){
  
  if (!(is.null(addValueUnder))){
    if (is.Date(tab_[[varname_]])){
      breaks_ <- c(as.Date(addValueUnder),as.Date(breaks_, origin = "1970-01-01"))
    }else{
      breaks_ <- c(addValueUnder,breaks_)
    }
  }
  
  labels_ <- paste0(ifelse(breaks_[-length(breaks_)] == min(breaks_[-length(breaks_)]), "[", "("),
                    breaks_[-length(breaks_)],",", breaks_[-1],"]")
  
  if (labels_name_ == FALSE){
    labels_name_ <- paste0(ifelse(breaks_[-length(breaks_)] == min(breaks_[-length(breaks_)]), "[", "("),
                           breaks_[-length(breaks_)],",", breaks_[-1],"]")
    labels_name_check_ <- FALSE
  }else{
    labels_name_ <- labels_name_
    labels_name_check_ <- TRUE
  }
  # else{
  #   labels_name_ <- paste0(ifelse(labels_name_[-length(labels_name_)] == min(labels_name_[-length(labels_name_)]), "[", "("),
  #                          labels_name_[-length(labels_name_)],",", labels_name_[-1],"]")
  # }
  
  ### Import HER2 ###
  fr.spdf <- readOGR("/home/tjaouen/Documents/Input/HER/HER2hybrides/Shapefile/","HER2_hybrides")
  proj4string(fr.spdf)=CRS("+proj=longlat +ellps=WGS84")
  fr.prj <- spTransform(fr.spdf, CRS("+init=epsg:2154")) # trasnformation en Lambert93
  
  ### Jonction ###
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 37)] = "37+54"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 54)] = "37+54"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 69)] = "69+96"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 96)] = "69+96"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 31)] = "31+33+39"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 33)] = "31+33+39"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 39)] = "31+33+39"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 89)] = "89+92"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 92)] = "89+92"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 49)] = "49+90"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 90)] = "49+90"
  
  fr.prj[[varname_]] = NA
  if (paste0(varname_,"_IC95inf") %in% colnames(tab_)){
    fr.prj[[paste0(varname_,"_IC95inf")]] = NA
    fr.prj[[paste0(varname_,"_IC95sup")]] = NA
  }  
  
  for (i in 1:length(fr.prj$CdHER2)){
    if (length(which(tab_$HER == fr.prj$CdHER2[i])) > 0){
      fr.prj[[varname_]][i] = tab_[which(tab_$HER == fr.prj$CdHER2[i]),varname_]
    }else{
      fr.prj[[varname_]][i] = NA
    }
    if (paste0(varname_,"_IC95inf") %in% colnames(tab_)){
      if (length(which(tab_$HER == fr.prj$CdHER2[i])) > 0){
        fr.prj[[paste0(varname_,"_IC95inf")]][i] = tab_[which(tab_$HER == fr.prj$CdHER2[i]),paste0(varname_,"_IC95inf")]
        fr.prj[[paste0(varname_,"_IC95sup")]][i] = tab_[which(tab_$HER == fr.prj$CdHER2[i]),paste0(varname_,"_IC95sup")]
      }else{
        fr.prj[[paste0(varname_,"_IC95inf")]][i] = NA
        fr.prj[[paste0(varname_,"_IC95sup")]][i] = NA
      }
    }
  }
  
  if (is.Date(tab_[[varname_]])){
    fr.prj[[varname_]] <- as.Date(fr.prj[[varname_]], origin = "1970-01-01")
    fr.prj$var_cut_ <- cut(fr.prj[[varname_]],
                           breaks=as.Date(breaks_),
                           include.lowest = T,
                           label = labels_,
                           na.rm = T)
  }else{
    fr.prj$var_cut_ <- cut(fr.prj[[varname_]],
                           breaks=breaks_,
                           include.lowest = T,
                           label = labels_)
  }
  
  # Legende des HER 2
  # Extraire les coordonnées des centres de chaque polygone d'hydroécorégion de niveau 2
  her2_centers <- coordinates(gCentroid(fr.prj, byid=TRUE))
  
  # Extraire l'attribut "NUM_HER2" de chaque polygone d'hydroécorégion de niveau 2
  her2_attrib <- fr.prj$CdHER2
  
  # Convertir fr.prj en un dataframe utilisable dans ggplot2
  fr.df <- fortify(fr.prj)
  fr.df <- merge(fr.df, as.data.frame(fr.prj@data), by.x = "id", by.y = "row.names", all = TRUE)
  
  if (! is.null(HER2_excluesDensity_)){
    palette_col_ = as.factor(c(palette_col_, "#ffffff")) # "#737373", #1d91c0
    labels_ = as.factor(c(labels_, "Low data density"))
    labels_name_ = as.factor(c(labels_name_, "Low data density"))
    breaks_ = as.factor(c(breaks_, "Low data density"))
  }
  
  # Zoom RMC
  bbox <- c(xmin = 340000, xmax = 1300000, ymin = 6050000, ymax = 6800000)
  
  # Créer la palette de couleurs SurfaceHydroPropSurfHER2
  txt_ = read_lines(paste0(IPCCcolors_folder_,nomPalette_))
  length_color_ = max(as.numeric(str_after_last(grep("_", txt_, value = TRUE),"_")))
  
  if (doubleLegend_ == T){
    if (reverseColors_ == T){
      if (echelleAttenuee_ == TRUE){
        if (is.null(taillePalette)){
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_)*2+1,5),28)))
          palette_col_ <- palette_col_[round(length(palette_col_)/2):length(palette_col_)]
        }else{
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5),28)))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette):length(palette_col_)]
        }
      }else{
        if (is.null(taillePalette)){
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_)*2,5),28)))
          palette_col_ <- palette_col_[round(length(palette_col_)/2):length(palette_col_)]
        }else{
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5),28)))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette+2):length(palette_col_)]
        }
      }
    }else{
      if (echelleAttenuee_ == TRUE){
        if (is.null(taillePalette)){
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max((length(breaks_)-1)*2,5), 28))
          palette_col_ <- palette_col_[round(length(palette_col_)/2):length(palette_col_)]
        }else{
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5), 28))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette):length(palette_col_)]
        }
      }else{
        if (is.null(taillePalette)){
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max((length(breaks_)-1)*2,5), 28))
          palette_col_ <- palette_col_[round(length(palette_col_)/2):length(palette_col_)]
        }else{
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5), 28))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette+2):length(palette_col_)]
        }
      }
    }
  }else{
    if (reverseColors_ == T){
      if (echelleAttenuee_ == TRUE){
        if (is.null(taillePalette)){
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_)-5,5),28)))
        }else{
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5),28)))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette):length(palette_col_)]
        }
      }else{
        if (is.null(taillePalette)){
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_) - 1,5),28)))
        }else{
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5),28)))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette+2):length(palette_col_)]
        }
      }
    }else{
      if (echelleAttenuee_ == TRUE){
        if (is.null(taillePalette)){
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max((length(breaks_)-5),5), 28))
        }else{
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5), 28))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette):length(palette_col_)]
        }
      }else{
        if (is.null(taillePalette)){
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max((length(breaks_)-1),5), 28))
        }else{
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5), 28))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette+2):length(palette_col_)]
        }
      }
    }
  }
  if (reverseFinal == T){
    palette_col_ <- rev(palette_col_)
  }
  # [1] "#003C30" "#18655B" "#308E86" "#64AEA8" "#9FCCC8" "#DBEAE8" "#F0E6DA" "#DEC29C" "#CD9E5E" "#B57929"
  # [11] "#845417" "#543005"
  # [1] "#003C30" "#18655B" "#308E86" "#64AEA8" "#9FCCC8" "#DBEAE8" "#F0E6DA" "#DEC29C" "#CD9E5E" "#B57929"
  # [11] "#845417" "#543005"
  # [1] "#003C30" "#1A695F" "#35978F" "#76B7B2" "#B7D8D5" "#F8F8F7" "#E5D1B4" "#D2A971" "#BF812C" "#895819"
  # [11] "#543005"
  
  
  # Ajustement de la palette
  if (length(breaks_)-1 > length_color_){
    stop("Message personnel : Erreur, pas assez de couleurs disponibles dans ce fichier txt de couleurs")
  }else{
    if (is.null(addValueUnder)){
      if (echelleAttenuee_ == TRUE){
        palette_col_ <- palette_col_[1:(length(breaks_))]
        # palette_col_ <- palette_col_[2:(length(breaks_))]
      }else{
        palette_col_ <- palette_col_[1:(length(breaks_)-1)]
      }
    }else{
      # palette_col_ <- palette_col_[1:(length(breaks_)-2)]
      # palette_col_ <- palette_col_[1:(length(breaks_))]
      # palette_col_ <- palette_col_[3:(length(breaks_))]
      palette_col_ <- c("white",palette_col_)
    }
  }
  # [1] "#003C30" "#125C51" "#257D73" "#3E9B94" "#6DB3AD" "#9BCAC6" "#CAE1DF" "#F8F8F7" "#EBDCC8" "#DDBF97"
  # [11] "#CFA367" "#C18636" "#A06921" "#7A4C13" "#543005"
  
  if (reverseFinal_bis == T){
    palette_col_ <- c("white",palette_col_[(length(palette_col_)-(length(labels_name_)-2)):length(palette_col_)])
    # palette_col_ <- rev(palette_col_)
    # temp <- palette_col_[1]
    # palette_col_[1] <- palette_col_[length(palette_col_)]
    # palette_col_[length(palette_col_)] <- temp
  }
  
  
  # df_color_ = setNames(palette_col_,labels_name_)
  df_color_ = setNames(palette_col_,labels_)
  if (! is.null(HER2_excluesDensity_)){
    df_color_["Low data density"] = "white" # "#737373", #1d91c0
      # df_color_["Low data density"] = "#ffffff" # "#737373", #1d91c0
  }
  
  fr.df$var_cut_ <- factor(fr.df$var_cut_, levels=labels_)
  
  if (! is.null(HER2_excluesDensity_)){
    fr.df$var_cut_[which(fr.df$CdHER2 %in% HER2_excluesDensity_)] = "Low data density"
  }
  
  if (labels_name_check_ != TRUE){
    labels_name_annotation_ <- paste0(c(substr(str_before_first(labels_name_[1],","),2,nchar(str_before_first(labels_name_[1],","))),
                                        str_before_first(str_after_first(labels_name_,","),"]")))
  }else{
    if (is.null(addValueUnder)){
      labels_name_annotation_ <- labels_name_
    }else{
      labels_name_annotation_ <- c("",labels_name_)
    }
  }
  
  if (percentFormat == T){
    labels_name_annotation_ <- paste0(labels_name_annotation_,"%")
  }
  if (is.Date(tab_[[varname_]])){
    labels_name_annotation_ <- format(as.Date(labels_name_annotation_, origin = "1970-01-01"),"%d/%m")
  }
  
  unit_x_ = max(fr.df$long) - min(fr.df$long)
  unit_y_ = max(fr.df$lat) - min(fr.df$lat)
  origin_x_ = min(fr.df$long)
  origin_y_ = min(fr.df$lat)
  
  if (!is.null(addValueUnder)){
    fr.df$var_cut_[which(is.na(fr.df$var_cut_))] = levels(fr.df$var_cut_)[1]
  }
  
  if (grepl("J2000",output_name_)){
    fr.df.surligne <- fr.df[which(fr.df$CdHER2 %in% c("81")),]
  }else{
    fr.df.surligne <- fr.df[which(fr.df$CdHER2 %in% c("12","57","81","105")),]
  }
  
  p <- ggplot() +
    geom_polygon(data=fr.df, aes(x=long, y=lat, group=group, fill=var_cut_), 
                 color=borderCol, size = 0.3) +
    scale_fill_manual(values=df_color_,
                      name=vartitle_,
                      breaks=labels_,
                      labels=labels_name_annotation_[2:length(labels_name_annotation_)],
                      drop = F) +
    geom_polygon(data=fr.df.surligne, aes(x=long, y=lat, group=group), fill = NA, color = "#800080", linewidth = 1)
  if (sansTexteHer_ == FALSE){
    p <- p + geom_text(data = data.frame(x = her2_centers[,1], y = her2_centers[,2], label = her2_attrib),
                       aes(x = x, y = y, label = label),
                       color = "#2f2f32", size = 4, segment.alpha = 0.3,
                       force = 10)
  }
  p <- p + 
    theme(plot.title = element_text(color = "#060403", size = 30, face = "bold", hjust = 0.5),
          plot.subtitle = element_text(color = "#2f2f32", size = 18),
          
          axis.title = element_blank(),
          axis.text = element_blank(),
          axis.line = element_blank(),
          axis.ticks = element_blank(),
          
          panel.background = element_blank(),
          panel.grid = element_blank(),
          panel.border = element_blank(),
          
          text = element_text(size = 26),
          
          legend.position = c(1.15,0.45),
          # legend.position = c(1.1,0.5),
          # legend.title = element_blank(),
          legend.title = element_text(color = "#454547", size = 18, vjust = 5, hjust = 0),
          # legend.title.align = 0.5,
          legend.text = element_text(color = "#454547", size = 18, vjust = 1.3, hjust = 0),
          legend.background = element_blank(),
          legend.key.height = unit(1.3, 'cm'),
          legend.spacing.y = unit(0, 'cm'),
          legend.margin = margin(0, 0, 0, 0), # Réduire les marges de la légende
          legend.box.spacing = unit(0, "cm"))+ # Réduire l'espacement interne de la légende
    
    guides(fill = guide_legend(reverse = reverseLegend_,
                               override.aes = list(linewidth = 0)))+
    coord_fixed(ratio = 1)
  
  if (annotation_txt_){
    
    # Texte legend
    # p <- p + annotate("text",
    #                   x = origin_x_ + 0.97 * unit_x_,
    #                   y = generer_positions(origin_y_ + 0.502 * unit_y_, 55500, length(labels_name_annotation_)),
    #                   label = TeX(labels_name_annotation_),
    #                   size = 18*25.4/72.27,
    #                   hjust = 0)
    
    # Titre
    p <- p + annotate("text",
                      x = origin_x_ - 0.15 * unit_x_,
                      # x = origin_x_ + 0 * unit_x_,
                      y = origin_y_ + 0.97 * unit_y_,
                      label = title_,
                      fontface = "bold",
                      # bold = T,
                      size = 30*25.4/72.27,
                      color = "#2f2f32",
                      hjust = 0,
                      vjust = 0.5)
    p <- p + annotate("text",
                      # x = origin_x_ + 1 * unit_x_,
                      x = origin_x_ + 1.1 * unit_x_,
                      y = origin_y_ + 0.97 * unit_y_,
                      label = subtitle_,
                      size = 18*25.4/72.27,
                      color = "#454547",
                      hjust = "right",
                      vjust = 0.5)
  }
  
  # Echelle
  p <- p + annotation_scale(location = "bl",
                            line_width = .8,
                            text_cex = 0.7,
                            pad_x = unit(0.05, "npc"),
                            pad_y = unit(0.05, "npc"),
                            style = 'ticks',
                            bar_cols = "#454547",
                            text = element_blank())
  if (annotation_txt_){
    p <- p + annotation_north_arrow(location = "bl",
                                    style = north_arrow_fancy_orienteering(text_col = "#454547",
                                                                           line_col = "#454547",
                                                                           fill = "#454547"),
                                    which_north = "true",
                                    pad_x = unit(0.05, "npc"),
                                    pad_y = unit(0.08, "npc"),
                                    height = unit(0.9, "cm"),
                                    width = unit(0.7, "cm"))
  }else{
    p <- p + annotation_north_arrow(location = "tr",
                                    style = north_arrow_fancy_orienteering(text_col = "#454547",
                                                                           line_col = "#454547",
                                                                           fill = "#454547"),
                                    which_north = "true",
                                    # pad_x = unit(0.05, "npc"),
                                    # pad_y = unit(0.08, "npc"),
                                    height = unit(0.9, "cm"),
                                    width = unit(0.7, "cm"))
  }
  
  # Save
  if (annotation_txt_){
    pdf(paste0(output_name_,
               "_sansEt.pdf"),
        width = 18)
    print(p)
    dev.off()
    
    saveRDS(p, file = paste0(output_name_,"_sansEt.rds"))
    
    svg_device <- svglite(paste0(output_name_,"_sansEt.svg"), width = 18)#,
    print(p)
    dev.off()
    
    png(paste0(output_name_,"_sansEt.png"), width = 9*100)
    print(p)
    dev.off()
  }else{
    pdf(paste0(output_name_,
               "_sansTxt_sansEt.pdf"),
        width = 18)
    print(p)
    dev.off()
    
    saveRDS(p, file = paste0(output_name_,"_sansTxt_sansEt.rds"))
    
    svg_device <- svglite(paste0(output_name_,"_sansTxt_sansEt.svg"), width = 18)#,
    print(p)
    dev.off()
    
    png(paste0(output_name_,"_sansTxt_sansEt.png"), width = 9*100)
    print(p)
    dev.off()
  }
  
}




plot_map_variable_sansEtiquettes(tab_ = col_means_merge,
                                 varname_ = "CTRIP",
                                 # vartitle_ = "Probability of drying\nstate at a zero\nexceedance frequency (%)",
                                 vartitle_ = "MIA (%)",
                                 # breaks_ = breaks_ProbaAssecMoyenne,
                                 breaks_ = c(-100,-80,-60,-40,-20,0,20,40,60,80,100),
                                 output_name_ = "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/MIA/Map/IndexMIAparHER_CTRIP_Rcp85_1_20240625",
                                 title_ = paste0("MIA"),
                                 # nomPalette_ = "cryo_div_disc.txt",
                                 # nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                 # nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                 # nomPalette_ = "misc_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                 nomPalette_ = "prec_div_disc.txt",
                                 reverseColors_ = T,
                                 sansTexteHer_ = T,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = T,
                                 addValueUnder = -130,
                                 doubleLegend_ = F,
                                 # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                 HER2_excluesDensity_ = NULL,
                                 annotation_txt_ = F,
                                 percentFormat = T,
                                 borderCol = "gray60")

tab_ = col_means_merge
varname_ = "CTRIP"
# vartitle_ = "Probability of drying\nstate at a zero\nexceedance frequency (%)",
vartitle_ = "Probability (%)"
# breaks_ = breaks_ProbaAssecMoyenne,
breaks_ = c(-100,-80,-60,-40,-20,0,20,40,60,80,100)
output_name_ = "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/MIA/Map/IndexMIAparHER_CTRIP_Rcp85_1_20240625"
title_ = paste0("MIA")
# nomPalette_ = "cryo_div_disc.txt",
# nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
# nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
nomPalette_ = "prec_div_disc.txt" # "sequence_vertRouge_personnelle_div_disc.txt"
reverseColors_ = T
sansTexteHer_ = T
reverseLegend_ = T
echelleAttenuee_ = T
addValueUnder = -130
# HER2_excluesDensity_ = HER2_excluesDensity_bin_)
HER2_excluesDensity_ = NULL
annotation_txt_ = F
percentFormat = T
borderCol = "gray60"
  
labels_name_ = FALSE
subtitle_ = NULL
doubleLegend_ = F
taillePalette = NULL
retenuPalette = NULL
reverseFinal = F
reverseFinal_bis = F






plot_map_variable_sansEtiquettes(tab_ = col_means_merge,
                                 varname_ = "GRSD",
                                 # vartitle_ = "Probability of drying\nstate at a zero\nexceedance frequency (%)",
                                 vartitle_ = "MIA (%)",
                                 # breaks_ = breaks_ProbaAssecMoyenne,
                                 breaks_ = c(-100,-80,-60,-40,-20,0,20,40,60,80,100),
                                 output_name_ = "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/MIA/Map/IndexMIAparHER_GRSD_Rcp85_1_20240625",
                                 title_ = paste0("MIA"),
                                 # nomPalette_ = "cryo_div_disc.txt",
                                 # nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                 # nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                 # nomPalette_ = "misc_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                 nomPalette_ = "prec_div_disc.txt",
                                 reverseColors_ = T,
                                 sansTexteHer_ = T,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = T,
                                 addValueUnder = -130,
                                 # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                 doubleLegend_ = F,
                                 HER2_excluesDensity_ = NULL,
                                 annotation_txt_ = F,
                                 percentFormat = T,
                                 borderCol = "gray60")

plot_map_variable_sansEtiquettes(tab_ = col_means_merge,
                                 varname_ = "J2000",
                                 # vartitle_ = "Probability of drying\nstate at a zero\nexceedance frequency (%)",
                                 vartitle_ = "MIA (%)",
                                 # breaks_ = breaks_ProbaAssecMoyenne,
                                 breaks_ = c(-100,-80,-60,-40,-20,0,20,40,60,80,100),
                                 output_name_ = "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/MIA/Map/IndexMIAparHER_J2000_Rcp85_1_20240625",
                                 title_ = paste0("MIA"),
                                 # nomPalette_ = "cryo_div_disc.txt",
                                 # nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                 # nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                 # nomPalette_ = "misc_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                 nomPalette_ = "prec_div_disc.txt",
                                 reverseColors_ = T,
                                 sansTexteHer_ = T,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = T,
                                 addValueUnder = -130,
                                 # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                 doubleLegend_ = F,
                                 HER2_excluesDensity_ = NULL,
                                 annotation_txt_ = F,
                                 percentFormat = T,
                                 borderCol = "gray60")

plot_map_variable_sansEtiquettes(tab_ = col_means_merge,
                                 varname_ = "ORCHIDEE",
                                 # vartitle_ = "Probability of drying\nstate at a zero\nexceedance frequency (%)",
                                 vartitle_ = "MIA (%)",
                                 # breaks_ = breaks_ProbaAssecMoyenne,
                                 breaks_ = c(-100,-80,-60,-40,-20,0,20,40,60,80,100),
                                 output_name_ = "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/MIA/Map/IndexMIAparHER_ORCHIDEE_Rcp85_1_20240625",
                                 title_ = paste0("MIA"),
                                 # nomPalette_ = "cryo_div_disc.txt",
                                 # nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                 # nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                 # nomPalette_ = "misc_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                 nomPalette_ = "prec_div_disc.txt",
                                 reverseColors_ = T,
                                 sansTexteHer_ = T,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = T,
                                 addValueUnder = -30,
                                 # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                 doubleLegend_ = F,
                                 HER2_excluesDensity_ = NULL,
                                 annotation_txt_ = F,
                                 percentFormat = T,
                                 borderCol = "gray60")

plot_map_variable_sansEtiquettes(tab_ = col_means_merge,
                                 varname_ = "SMASH",
                                 # vartitle_ = "Probability of drying\nstate at a zero\nexceedance frequency (%)",
                                 vartitle_ = "MIA (%)",
                                 # breaks_ = breaks_ProbaAssecMoyenne,
                                 breaks_ = c(-100,-80,-60,-40,-20,0,20,40,60,80,100),
                                 output_name_ = "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/MIA/Map/IndexMIAparHER_SMASH_Rcp85_1_20240625",
                                 title_ = paste0("MIA"),
                                 # nomPalette_ = "cryo_div_disc.txt",
                                 # nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                 # nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                 # nomPalette_ = "misc_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                 nomPalette_ = "prec_div_disc.txt",
                                 reverseColors_ = T,
                                 sansTexteHer_ = T,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = T,
                                 addValueUnder = -30,
                                 # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                 doubleLegend_ = F,
                                 HER2_excluesDensity_ = NULL,
                                 annotation_txt_ = F,
                                 percentFormat = T,
                                 borderCol = "gray60")


plot_map_variable_sansEtiquettes(tab_ = col_means_merge,
                                 varname_ = "Total",
                                 # vartitle_ = "Probability of drying\nstate at a zero\nexceedance frequency (%)",
                                 vartitle_ = "MIA (%)",
                                 # breaks_ = breaks_ProbaAssecMoyenne,
                                 breaks_ = c(-100,-80,-60,-40,-20,0,20,40,60,80,100),
                                 output_name_ = "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/MIA/Map/IndexMIAparHER_Total_Rcp85_1_20240625",
                                 title_ = paste0("MIA"),
                                 # nomPalette_ = "cryo_div_disc.txt",
                                 # nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                 # nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                 # nomPalette_ = "misc_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                 nomPalette_ = "prec_div_disc.txt",
                                 reverseColors_ = T,
                                 sansTexteHer_ = T,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = T,
                                 addValueUnder = -30,
                                 # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                 doubleLegend_ = F,
                                 HER2_excluesDensity_ = NULL,
                                 annotation_txt_ = F,
                                 percentFormat = T,
                                 borderCol = "gray60")

