### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/4_RunsEtudeFrance_20230417/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_11_SaveRds_20230831.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_Points_IPCCcolors_1_SaveRds_20230910.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")

### Libraries ###
library(ggplot2)
library(readxl)
require(maptools)
library(rgdal)
library(maps)
library(mapdata)
library(dplyr)
library(rgeos)
library(RColorBrewer)
library(fields)
library(scales)

### Functions ###
effectifParHER2 = function(tab_graph_){
  ### Calcul de la surface par HER sachant les stations conservees ###
  tab_graph_TransfoPropToSurfAbsolues <- tab_graph_[,grep(pattern = "eco0|eco1|eco3|eco6", colnames(tab_graph_))]
  # tab_graph_TransfoPropToSurfAbsolues <- tab_graph_$SurfaceTopo * tab_graph_TransfoPropToSurfAbsolues
  tab_graph_TransfoPropToSurfAbsolues <- tab_graph_$SurfaceTopo_ChoixDefinitifPointSimu * tab_graph_TransfoPropToSurfAbsolues
  which(!(round(rowSums(tab_graph_TransfoPropToSurfAbsolues)) == round(tab_graph_$SurfaceTopo))) #664 : 696 et 697, OK
  tab_graph_[,grep(pattern = "eco0|eco1|eco3|eco6", colnames(tab_graph_))] <- tab_graph_TransfoPropToSurfAbsolues
  # write.table(tab_graph_, "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/Stations_HYDRO_AvecCorrespondanceShp_SurfacesAbsolues_6_20230726.csv", sep = ";", dec = ".", row.names = F)
  
  dispo_hydroOff_ = tab_graph_
  
  # # Croisement HER 2
  dispo_hydroOff_her2_ <- dispo_hydroOff_[,grep(pattern = "eco0|eco1|eco3|eco6", colnames(dispo_hydroOff_))]
  
  ### Caracteristiques HER 2 hybrides - Utilisation de l'aire des HER 2 ###
  file_HER2off_desc_ = "/home/tjaouen/Documents/Input/HER/HER2hybrides/DescriptionHER2hybrides_R_1_20230405.xlsx"
  tab_HER2off_desc_ = read_excel(file_HER2off_desc_)
  tab_HER2off_desc_$Area_km2 = as.numeric(tab_HER2off_desc_$Area_km2)
  
  # tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == )]
  tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 37)] = "37+55"
  tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 55)] = "37+55"
  tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "37+55")] = sum(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "37+55")])
  
  tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 69)] = "69+96"
  tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 96)] = "69+96"
  tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "69+96")] = sum(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "69+96")])
  
  tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 31)] = "31+33+39"
  tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 33)] = "31+33+39"
  tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 39)] = "31+33+39"
  tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "31+33+39")] = sum(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "31+33+39")])
  
  tab_sum_ = data.frame(AreaHydro = colSums(dispo_hydroOff_her2_))
  tab_sum_bin_ = data.frame(NbStationsHydro = colSums(dispo_hydroOff_her2_>0))
  rownames(tab_sum_) <- as.numeric(gsub("eco", "", rownames(tab_sum_bin_)))
  rownames(tab_sum_bin_) <- as.numeric(gsub("eco", "", rownames(tab_sum_bin_)))
  
  tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("31","33","39"))] = sum(tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("31","33","39"))])
  tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("31","33","39"))] = sum(tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("31","33","39"))])
  tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("37","55"))] = sum(tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("37","55"))])
  tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("37","55"))] = sum(tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("37","55"))])
  tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("69","96"))] = sum(tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("69","96"))])
  tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("69","96"))] = sum(tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("69","96"))])
  tab_sum_$HER2 = rownames(tab_sum_)
  tab_sum_bin_$HER2 = rownames(tab_sum_bin_)
  
  tab_sum_ = tab_sum_[which(!(rownames(tab_sum_) %in% c("33","39","55","96"))),]
  tab_sum_bin_ = tab_sum_bin_[which(!(rownames(tab_sum_bin_) %in% c("33","39","55","96"))),]
  
  rownames(tab_sum_)[which(rownames(tab_sum_) %in% c("31033039"))] = "31+33+39"
  rownames(tab_sum_)[which(rownames(tab_sum_) %in% c("37055"))] = "37+55"
  rownames(tab_sum_)[which(rownames(tab_sum_) %in% c("69096"))] = "69+96"
  tab_sum_$HER2 = rownames(tab_sum_)
  
  rownames(tab_sum_bin_)[which(rownames(tab_sum_bin_) %in% c("31033039"))] = "31+33+39"
  rownames(tab_sum_bin_)[which(rownames(tab_sum_bin_) %in% c("37055"))] = "37+55"
  rownames(tab_sum_bin_)[which(rownames(tab_sum_bin_) %in% c("69096"))] = "69+96"
  tab_sum_bin_$HER2 = rownames(tab_sum_bin_)
  
  tab_sum_$SurfaceHER2 = NA
  tab_sum_$SurfaceHydroPropSurfHER2 = NA
  tab_sum_bin_$SurfaceHER2 = NA
  tab_sum_bin_$SurfaceHydroPropSurfHER2_bin = NA
  tab_sum_bin_$SurfaceDivNbHydro_bin = NA
  
  for (i in 1:dim(tab_sum_)[1]){
    if (length(which(tab_HER2off_desc_$CdHER2 == rownames(tab_sum_)[i])) > 0){
      tab_sum_$SurfaceHER2[i] = tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == tab_sum_$HER2[i])]
      tab_sum_$SurfaceHydroPropSurfHER2[i] = ifelse(tab_sum_$AreaHydro[i]==0,NA,unique(tab_sum_$AreaHydro[i]/tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == tab_sum_$HER2[i])])) # Surface topographique des stations hydro de l'HER 2 hybrides / Surface de l'HER 2 hybrides 
      
      tab_sum_bin_$SurfaceHER2[i] = tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == tab_sum_$HER2[i])]
      tab_sum_bin_$SurfaceHydroPropSurfHER2_bin[i] = ifelse(tab_sum_bin_$NbStationsHydro[i]==0,NA,unique(tab_sum_bin_$NbStationsHydro[i]/tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == tab_sum_bin_$HER2[i])])*1000) # Nombre de stations par km2 de l'HER 2 hybride
      tab_sum_bin_$SurfaceDivNbHydro_bin[i] = unique(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == tab_sum_bin_$HER2[i])]/ifelse(tab_sum_bin_$NbStationsHydro[i] == 0,NA,tab_sum_bin_$NbStationsHydro[i])) # Surface de l'HER couverte par une station Hydro
    }
  }
  
  tab_sum_$SurfaceHydroPropSurfHER2_log <- log(tab_sum_$SurfaceHydroPropSurfHER2)
  tab_compil_sum_sumbin_ <- merge(tab_sum_bin_, tab_sum_, by = "HER2")
  tab_compil_sum_sumbin_ <- tab_compil_sum_sumbin_[order(as.numeric(tab_compil_sum_sumbin_$HER2)),]
  
  tab_sum_ = tab_sum_[which(!(tab_sum_$HER2 %in% c(0,10))),]
  tab_sum_bin_ = tab_sum_bin_[which(!(tab_sum_bin_$HER2 %in% c(0,10))),]
  
  return(list(tab_sum_,tab_sum_bin_))
  
}



ligneTable_ = function(tab, tab_sum_, tab_sum_bin_){
  
  nombreHERcouvertes = paste0(length(which(tab_sum_$AreaHydro>0)),
                              "/",
                              length(tab_sum_$AreaHydro))
  
  tab_sum_ = tab_sum_[which(tab_sum_$AreaHydro>0),]
  tab_sum_bin_ = tab_sum_bin_[which(tab_sum_bin_$NbStationsHydro>0),]
  
  nombreSites = paste0(nrow(tab))
  
  nombreStationsParHER2 = paste0(median(tab_sum_bin_$NbStationsHydro),
                                 " (min-max per HER2: ",
                                 min(tab_sum_bin_$NbStationsHydro),
                                 "-",
                                 max(tab_sum_bin_$NbStationsHydro),
                                 ")")
  
  surfaceHydroPropSurHER2 = paste0(round(median(tab_sum_$SurfaceHydroPropSurfHER2),2),
                                   " (min-max per HER2: ",
                                   round(min(tab_sum_$SurfaceHydroPropSurfHER2),2),
                                   "-",
                                   round(max(tab_sum_$SurfaceHydroPropSurfHER2),2),
                                   ")")
  
  NbStation1000km2 = paste0(round(median(tab_sum_bin_$SurfaceHydroPropSurfHER2_bin),1),
                            " (min-max per HER2: ",
                            round(min(tab_sum_bin_$SurfaceHydroPropSurfHER2_bin),1),
                            "-",
                            round(max(tab_sum_bin_$SurfaceHydroPropSurfHER2_bin),1),
                            ")")
  
  return(data.frame(nombreSites = nombreSites,
                    nombreHERcouvertes = nombreHERcouvertes,
                    nombreStationsParHER2 = nombreStationsParHER2,
                    surfaceHydroPropSurHER2 = surfaceHydroPropSurHER2,
                    NbStation1000km2 = NbStation1000km2))
  
}

ligneTable_onde_ = function(df_, df_onde_){
  
  nombreHERcouvertes = paste0(length(which(df_onde_$AreaOnde>0)),
                              "/",
                              length(tab_sum_$AreaHydro))
  
  df_onde_ = df_onde_[which(df_onde_$AreaOnde>0),]
  
  nombreSites = paste0(nrow(df_))
  
  nombreStationsParHER2 = paste0(median(df_onde_$Count_Non_NA+df_onde_$Count_NA),
                                 " (min-max per HER2: ",
                                 min(df_onde_$Count_Non_NA+df_onde_$Count_NA),
                                 "-",
                                 max(df_onde_$Count_Non_NA+df_onde_$Count_NA),
                                 ")")
  
  surfaceHydroPropSurHER2 = paste0(round(median(tab_sum_$SurfaceHydroPropSurfHER2),2),
                                   " (min-max per HER2: ",
                                   round(min(tab_sum_$SurfaceHydroPropSurfHER2),2),
                                   "-",
                                   round(max(tab_sum_$SurfaceHydroPropSurfHER2),2),
                                   ")")
  
  NbStation1000km2 = paste0(round(median(tab_sum_bin_$SurfaceHydroPropSurfHER2_bin),1),
                            " (min-max per HER2: ",
                            round(min(tab_sum_bin_$SurfaceHydroPropSurfHER2_bin),1),
                            "-",
                            round(max(tab_sum_bin_$SurfaceHydroPropSurfHER2_bin),1),
                            ")")
  
  return(data.frame(nombreSites = nombreSites,
                    nombreHERcouvertes = nombreHERcouvertes,
                    nombreStationsParHER2 = nombreStationsParHER2,
                    surfaceHydroPropSurHER2 = surfaceHydroPropSurHER2,
                    NbStation1000km2 = NbStation1000km2))
  
}



### Output forlder ###
# output_folder_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsObserves/DisponibiliteDonneesHydroDates/AnalyseDisponibiliteDonneesHydro_Graphes/Version1_20230425/Hybrides_sansStatSup2000/"
output_folder_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230803/"

### Study data ###
folder_input_ = folder_input_param_
folder_output_ = folder_output_param_
folder_onde_ = folder_onde_param_
nomSim_ = nomSim_param_

### Disponibilite des Stations par dates ### 
tab_stations_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/Stations_HYDRO_AvecCorrespondanceShp_VersionCorresDistanceBruteExp2_8_20230803.csv", dec = ".", na.strings = NA, header = T)
dim(tab_stations_) #1008 194
tab_stations_[which(is.na(tab_stations_$SurfaceTopo)),]
tab_stations_ = tab_stations_[which(tab_stations_$SurfaceTopo < 2000),]
dim(tab_stations_) #1008 194
tab_graph_ <- tab_stations_

### Tab globale ###
tab_graph_globale_ = tab_graph_
tab_graph_globale_sum_ = effectifParHER2(tab = tab_graph_globale_)[[1]]
tab_graph_globale_sum_bin_ = effectifParHER2(tab = tab_graph_globale_)[[2]]

tab_graph_CTRIP_ = tab_graph_[which(tab_graph_$CTRIP_ChoixDefinitifPointSimu == 1),]
tab_graph_CTRIP_sum_ = effectifParHER2(tab = tab_graph_CTRIP_)[[1]]
tab_graph_CTRIP_sum_bin_ = effectifParHER2(tab = tab_graph_CTRIP_)[[2]]

tab_graph_EROS_ = tab_graph_[which(tab_graph_$EROS_ChoixDefinitifPointSimu == 1),]
tab_graph_EROS_sum_ = effectifParHER2(tab = tab_graph_EROS_)[[1]]
tab_graph_EROS_sum_bin_ = effectifParHER2(tab = tab_graph_EROS_)[[2]]

tab_graph_GRSD_ = tab_graph_[which(tab_graph_$GRSD_ChoixDefinitifPointSimu == 1),]
tab_graph_GRSD_sum_ = effectifParHER2(tab = tab_graph_GRSD_)[[1]]
tab_graph_GRSD_sum_bin_ = effectifParHER2(tab = tab_graph_GRSD_)[[2]]

tab_graph_J2000_ = tab_graph_[which(tab_graph_$J2000_ChoixDefinitifPointSimu == 1),]
tab_graph_J2000_sum_ = effectifParHER2(tab = tab_graph_J2000_)[[1]]
tab_graph_J2000_sum_bin_ = effectifParHER2(tab = tab_graph_J2000_)[[2]]

tab_graph_MORDORSD_ = tab_graph_[which(tab_graph_$MORDORSD_ChoixDefinitifPointSimu == 1),]
tab_graph_MORDORSD_sum_ = effectifParHER2(tab = tab_graph_MORDORSD_)[[1]]
tab_graph_MORDORSD_sum_bin_ = effectifParHER2(tab = tab_graph_MORDORSD_)[[2]]

tab_graph_MORDORTS_ = tab_graph_[which(tab_graph_$MORDORTS_ChoixDefinitifPointSimu == 1),]
tab_graph_MORDORTS_sum_ = effectifParHER2(tab = tab_graph_MORDORTS_)[[1]]
tab_graph_MORDORTS_sum_bin_ = effectifParHER2(tab = tab_graph_MORDORTS_)[[2]]

tab_graph_ORCHIDEE_ = tab_graph_[which(tab_graph_$ORCHID_ChoixDefinitifPointSimu == 1),]
tab_graph_ORCHIDEE_sum_ = effectifParHER2(tab = tab_graph_ORCHIDEE_)[[1]]
tab_graph_ORCHIDEE_sum_bin_ = effectifParHER2(tab = tab_graph_ORCHIDEE_)[[2]]

tab_graph_SIM2_ = tab_graph_[which(tab_graph_$SIM2_ChoixDefinitifPointSimu == 1),]
tab_graph_SIM2_sum_ = effectifParHER2(tab = tab_graph_SIM2_)[[1]]
tab_graph_SIM2_sum_bin_ = effectifParHER2(tab = tab_graph_SIM2_)[[2]]

tab_graph_SMASH_ = tab_graph_[which(tab_graph_$SMASH_ChoixDefinitifPointSimu == 1),]
tab_graph_SMASH_sum_ = effectifParHER2(tab = tab_graph_SMASH_)[[1]]
tab_graph_SMASH_sum_bin_ = effectifParHER2(tab = tab_graph_SMASH_)[[2]]


tab_finale_pointsSimu_ = rbind(ligneTable_(tab_graph_globale_, tab_graph_globale_sum_, tab_graph_SMASH_sum_bin_),
                               ligneTable_(tab_graph_CTRIP_, tab_graph_CTRIP_sum_, tab_graph_CTRIP_sum_bin_),
                               ligneTable_(tab_graph_EROS_, tab_graph_EROS_sum_, tab_graph_EROS_sum_bin_),
                               ligneTable_(tab_graph_GRSD_, tab_graph_GRSD_sum_, tab_graph_GRSD_sum_bin_),
                               ligneTable_(tab_graph_J2000_, tab_graph_J2000_sum_, tab_graph_J2000_sum_bin_),
                               ligneTable_(tab_graph_MORDORSD_, tab_graph_MORDORSD_sum_, tab_graph_MORDORSD_sum_bin_),
                               ligneTable_(tab_graph_MORDORTS_, tab_graph_MORDORTS_sum_, tab_graph_MORDORTS_sum_bin_),
                               ligneTable_(tab_graph_ORCHIDEE_, tab_graph_ORCHIDEE_sum_, tab_graph_ORCHIDEE_sum_bin_),
                               ligneTable_(tab_graph_SIM2_, tab_graph_SIM2_sum_, tab_graph_SIM2_sum_bin_),
                               ligneTable_(tab_graph_SMASH_, tab_graph_SMASH_sum_, tab_graph_SMASH_sum_bin_))

tab_finale_pointsSimu_$Modeles <- c("All simulation points",
                                    "CTRIP",
                                    "EROS",
                                    "GRSD",
                                    "J2000",
                                    "MORDOR-SD",
                                    "MORDOR-TS",
                                    "ORCHIDEE",
                                    "SIM2",
                                    "SMASH")







################################################################################
###                                   HYDRO                                  ###
################################################################################

### Output forlder ###
output_folder_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsObserves/DisponibiliteDonneesHydroDates/AnalyseDisponibiliteDonneesHydro_Graphes/Version1_20230425/Hybrides_sansStatSup2000/"

### Study data ###
folder_input_ = folder_input_param_
folder_output_ = folder_output_param_
folder_onde_ = folder_onde_param_
nomSim_ = nomSim_param_

### Disponibilite des Stations par dates ### 
tab_stations_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsObserves/DisponibiliteDonneesHydroDates/TablesDisponibiliteDonneesHydro/DisponibiliteTemporelle_VersionTJ_20230412/3_DisponibiliteDonnees_DatesEtMergeHER2hybrides/HER2_VersionES_2_20230417/3_Merge_DisponibiliteHydro_CorrespondanceHER2hybridesv2_3_20230420.csv", sep = ";", dec = ".", na.strings = NA, header = T)
dim(tab_stations_) #1250 134
tab_stations_[which(is.na(tab_stations_$SurfaceTopo)),]
tab_stations_ = tab_stations_[which(tab_stations_$SurfaceTopo < 2000),]
dim(tab_stations_) #1094

### Exclusion ES ###
file_exclusions_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsObserves/DisponibiliteDonneesHydroDates/DiagnosticQualiteEtImpactStations/2_SelectionES_BaseSurCalibrageModeles_20230512/ClasseurStationAExclure_TraitementTJ_20230522.xlsx"
tab_exclusions_ <- read_xlsx(file_exclusions_)
dim(tab_exclusions_) # 71

tab_stations_critereES_ <- tab_stations_[which(!(tab_stations_$Code_short %in% tab_exclusions_$Code_short)),]
dim(tab_stations_critereES_) # 1061

table(tab_stations_critereES_$Impact_local, useNA = "always") # 53
tab_stations_critereES_ <- tab_stations_critereES_[which(!(tab_stations_critereES_$Impact_local == "Influence forte en toute saison") | is.na(tab_stations_critereES_$Impact_local)),]
dim(tab_stations_critereES_) #1008
tab_graph_ <- tab_stations_critereES_

dim(tab_graph_)
titre_tab_ = "tab7ToutesExclusions1"
dispo_hydroOff_ = tab_graph_

### Regroupement HER2h ### #31 + 33 + 39, 37 + 55, 69 + 96
tab_graph_$eco31033039 <- tab_graph_$eco031 + tab_graph_$eco033 + tab_graph_$eco039
tab_graph_$eco37055 <- tab_graph_$eco037 + tab_graph_$eco055
tab_graph_$eco69096 <- tab_graph_$eco069 + tab_graph_$eco096
tab_graph_ <- tab_graph_[,which(!(colnames(tab_graph_) %in% c("eco031","eco033","eco039","eco037","eco055","eco069","eco096")))]

# Croisement HER 2
dispo_hydroOff_her2_ <- dispo_hydroOff_[,grep(pattern = "eco0|eco1|eco3|eco6", colnames(dispo_hydroOff_))]

### Stations ###
stations_ <- dispo_hydroOff_
stations_ = stations_ %>% mutate(BassinColor =
                                   case_when(substr(Code_short,1,1) == "U" ~ "#31a354",
                                             substr(Code_short,1,1) == "V" ~ "#313695",
                                             substr(Code_short,1,1) == "W" ~ "#4575b4",
                                             substr(Code_short,1,1) == "X" ~ "#fdae61",
                                             substr(Code_short,1,1) == "Y" ~ "#a50026"))
coordinates(stations_) <- c("XL93","YL93")
proj4string(stations_) <- CRS("+init=epsg:2154")

### Caracteristiques HER 2 hybrides - Utilisation de l'aire des HER 2 ###
file_HER2off_desc_ = "/home/tjaouen/Documents/Input/HER/HER2hybrides/DescriptionHER2hybrides_R_1_20230405.xlsx"
tab_HER2off_desc_ = read_excel(file_HER2off_desc_)
tab_HER2off_desc_$Area_km2 = as.numeric(tab_HER2off_desc_$Area_km2)

# tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == )]
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 37)] = "37+55"
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 55)] = "37+55"
tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "37+55")] = sum(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "37+55")])

tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 69)] = "69+96"
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 96)] = "69+96"
tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "69+96")] = sum(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "69+96")])

tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 31)] = "31+33+39"
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 33)] = "31+33+39"
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 39)] = "31+33+39"
tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "31+33+39")] = sum(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "31+33+39")])

tab_sum_ = data.frame(AreaHydro = colSums(dispo_hydroOff_her2_)) ### OK ON PARLE BIEN EN SURFACES ET NON EN PROPORTION
tab_sum_bin_ = data.frame(NbStationsHydro = colSums(dispo_hydroOff_her2_>0))
rownames(tab_sum_) <- as.numeric(gsub("eco", "", rownames(tab_sum_bin_)))
rownames(tab_sum_bin_) <- as.numeric(gsub("eco", "", rownames(tab_sum_bin_)))

tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("31","33","39"))] = sum(tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("31","33","39"))])
tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("31","33","39"))] = sum(tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("31","33","39"))])
tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("37","55"))] = sum(tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("37","55"))])
tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("37","55"))] = sum(tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("37","55"))])
tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("69","96"))] = sum(tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("69","96"))])
tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("69","96"))] = sum(tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("69","96"))])
tab_sum_$HER2 = rownames(tab_sum_)
tab_sum_bin_$HER2 = rownames(tab_sum_bin_)

tab_sum_ = tab_sum_[which(!(rownames(tab_sum_) %in% c("33","39","55","96"))),]
tab_sum_bin_ = tab_sum_bin_[which(!(rownames(tab_sum_bin_) %in% c("33","39","55","96"))),]

rownames(tab_sum_)[which(rownames(tab_sum_) %in% c("31"))] = "31+33+39"
rownames(tab_sum_)[which(rownames(tab_sum_) %in% c("37"))] = "37+55"
rownames(tab_sum_)[which(rownames(tab_sum_) %in% c("69"))] = "69+96"
tab_sum_$HER2 = rownames(tab_sum_)

rownames(tab_sum_bin_)[which(rownames(tab_sum_bin_) %in% c("31"))] = "31+33+39"
rownames(tab_sum_bin_)[which(rownames(tab_sum_bin_) %in% c("37"))] = "37+55"
rownames(tab_sum_bin_)[which(rownames(tab_sum_bin_) %in% c("69"))] = "69+96"
tab_sum_bin_$HER2 = rownames(tab_sum_bin_)

# tab_sum_$HER2 = as.numeric(rownames(tab_sum_))
# tab_sum_bin_$HER2 = as.numeric(rownames(tab_sum_))
tab_sum_$SurfaceHER2 = NA
tab_sum_$SurfaceHydroPropSurfHER2 = NA
tab_sum_bin_$SurfaceHER2 = NA
tab_sum_bin_$SurfaceHydroPropSurfHER2_bin = NA
tab_sum_bin_$SurfaceDivNbHydro_bin = NA

for (i in 1:dim(tab_sum_)[1]){
  # if (length(which(tab_HER2off_desc_$CdHER2 == as.numeric(rownames(tab_sum_)[i]))) > 0){
  if (length(which(tab_HER2off_desc_$CdHER2 == rownames(tab_sum_)[i])) > 0){
    tab_sum_$SurfaceHER2[i] = tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == tab_sum_$HER2[i])]
    tab_sum_$SurfaceHydroPropSurfHER2[i] = unique(tab_sum_$AreaHydro[i]/tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == tab_sum_$HER2[i])]) # Surface topographique des stations hydro de l'HER 2 hybrides / Surface de l'HER 2 hybrides 
    
    tab_sum_bin_$SurfaceHER2[i] = tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == tab_sum_$HER2[i])]
    tab_sum_bin_$SurfaceHydroPropSurfHER2_bin[i] = ifelse(tab_sum_bin_$NbStationsHydro[i]==0,NA,unique(tab_sum_bin_$NbStationsHydro[i]/tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == tab_sum_bin_$HER2[i])])*1000) # Nombre de stations par km2 de l'HER 2 hybride
    tab_sum_bin_$SurfaceDivNbHydro_bin[i] = unique(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == tab_sum_bin_$HER2[i])]/ifelse(tab_sum_bin_$NbStationsHydro[i] == 0,NA,tab_sum_bin_$NbStationsHydro[i])) # Surface de l'HER couverte par une station Hydro
  }
}

tab_sum_$SurfaceHydroPropSurfHER2_log <- log(tab_sum_$SurfaceHydroPropSurfHER2)

tab_compil_sum_sumbin_ <- merge(tab_sum_bin_, tab_sum_, by = "HER2")
tab_compil_sum_sumbin_ <- tab_compil_sum_sumbin_[order(as.numeric(tab_compil_sum_sumbin_$HER2)),]
# write.table(tab_compil_sum_sumbin_,
#             "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/MapVersionExclusions_SurfacesStationsHydro_v20230608/Stations_HYDRO_ExclESSurf2000_DescriptionTopo_1_20230612.csv",
#             sep = ";", dec = ".", row.names = F)

tab_sum_ = tab_sum_[which(!(tab_sum_$HER2 %in% c(0,10))),]
tab_sum_bin_ = tab_sum_bin_[which(!(tab_sum_bin_$HER2 %in% c(0,10))),]

tab_finale_globale_ = ligneTable_(tab_graph_, tab_sum_, tab_sum_bin_)
tab_finale_globale_$Modeles = "Gauging stations"



################################################################################
###                                   ONDE                                   ###
################################################################################

### Output forlder ###
output_folder_ = "/home/tjaouen/Documents/Input/ONDE/Data_DatesAjustees/MapSitesOndeDisponibles/"

### Study data ###
folder_input_ = folder_input_param_
folder_output_ = folder_output_param_
folder_onde_ = folder_onde_param_
nomSim_ = nomSim_param_
HER_variable_ = "HER2"

df_ <- read.table("/home/tjaouen/Documents/Input/ONDE/Data_Description/DescriptionSites/Surf_ONDE_2_20230525.csv", header = T, sep = ",", row.names = NULL, quote="")
annees_ = c(2012:2017)
# onde = read.table(paste0(folder_ONDE_CorrespondanceHER_,"HER2hybrides_Jonction/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_JonctionHER_4_20230512.csv"), header = T, sep = ";", row.names = NULL, quote="")
onde = read.table(paste0(folder_ONDE_CorrespondanceHER_,"HER2hybrides_Jonction/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_JonctionHER_6_20231221.csv"), header = T, sep = ";", row.names = NULL)
if (dim(onde)[2] == 1){
  onde = read.table(paste0(folder_ONDE_CorrespondanceHER_,"HER2hybrides_Jonction/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_JonctionHER_6_20231221.csv"), sep=",", dec=".", header = T)
}
onde = onde[,c("Code","X_Lambert93","Y_Lambert93",paste0("Cd",HER_variable_))]
colnames(onde) = c("Code","X_Lambert93","Y_Lambert93",paste0("Cd",HER_variable_))
print("Taille à verifier : 3302")
dim(onde)

df_ = merge(df_, onde, by.x = "F_CdSiteHy", by.y = "Code")

# Utilisez la fonction aggregate avec des fonctions personnalisées pour calculer la somme, le nombre de non-NA et le nombre de NA
result <- aggregate(df_$Surf_BV, by=list(df_$CdHER2), FUN=function(x) c(
  Somme_Surf_BV = sum(x, na.rm = TRUE),
  Count_Non_NA = sum(!is.na(x)),
  Count_NA = sum(is.na(x))
))
df_onde_ = data.frame(HER2 = result[[1]],
                      AreaOnde = result$x[,1],
                      Count_Non_NA = result$x[,2],
                      Count_NA = result$x[,3],
                      Count_Total = result$x[,2] + result$x[,3])

# Affichez le résultat
print(df_onde_)
df_onde_$HER2[which(df_onde_$HER2 == "37054")] = "37+54"
df_onde_$HER2[which(df_onde_$HER2 == "69096")] = "69+96"
df_onde_$HER2[which(df_onde_$HER2 == "31033039")] = "31+33+39"
df_onde_$HER2[which(df_onde_$HER2 == "49090")] = "49+90"
df_onde_$HER2[which(df_onde_$HER2 == "89092")] = "89+92"

### Caracteristiques HER 2 hybrides - Utilisation de l'aire des HER 2 ###
file_HER2off_desc_ = "/home/tjaouen/Documents/Input/HER/HER2hybrides/DescriptionHER2hybrides_R_1_20230405.xlsx"
tab_HER2off_desc_ = read_excel(file_HER2off_desc_)
tab_HER2off_desc_$Area_km2 = as.numeric(tab_HER2off_desc_$Area_km2)

tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 37)] = "37+54"
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 54)] = "37+54"
tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "37+54")] = sum(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "37+54")])

tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 69)] = "69+96"
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 96)] = "69+96"
tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "69+96")] = sum(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "69+96")])

tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 31)] = "31+33+39"
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 33)] = "31+33+39"
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 39)] = "31+33+39"
tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "31+33+39")] = sum(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "31+33+39")])

tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 49)] = "49+90"
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 90)] = "49+90"
tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "49+90")] = sum(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "49+90")])

tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 89)] = "89+92"
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 92)] = "89+92"
tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "89+92")] = sum(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "89+92")])

df_onde_$SurfaceHER2 = NA
df_onde_$SurfaceOndePropSurfHER2 = NA
df_onde_$SurfaceOndePropSurfHER2_log = NA
df_onde_$NbStationsOndeProp1000SurfHER2 = NA
df_onde_$SurfHER2ParStationsOnde = NA

for (i in 1:nrow(df_onde_)){
  if (length(which(tab_HER2off_desc_$CdHER2 == df_onde_$HER2[i])) > 0){
    df_onde_$SurfaceHER2[i] = tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == df_onde_$HER2[i])]
    
    df_onde_$SurfaceOndePropSurfHER2[i] = unique(df_onde_$AreaOnde[i]/tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == df_onde_$HER2[i])]) # Surface topographique des stations hydro de l'HER 2 hybrides / Surface de l'HER 2 hybrides 
    df_onde_$SurfaceOndePropSurfHER2_log[i] = log(unique(df_onde_$AreaOnde[i]/tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == df_onde_$HER2[i])])) # Surface topographique des stations hydro de l'HER 2 hybrides / Surface de l'HER 2 hybrides 
    
    df_onde_$NbStationsOndeProp1000SurfHER2[i] = ifelse(df_onde_$Count_Total[i]==0,NA,unique(df_onde_$Count_Total[i]/tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == df_onde_$HER2[i])])*1000) # Nombre de stations par km2 de l'HER 2 hybride
    df_onde_$SurfHER2ParStationsOnde[i] = unique(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == df_onde_$HER2[i])]/ifelse(df_onde_$Count_Total[i] == 0,NA,df_onde_$Count_Total[i])) # Surface de l'HER couverte par une station Hydro
  }
}

tab_finale_onde_ = ligneTable_onde_(df_, df_onde_)
tab_finale_onde_$Modeles = "ONDE sites"

tab_finale_ = rbind(tab_finale_onde_,
                    tab_finale_globale_,
                    tab_finale_pointsSimu_)

tab_finale_ = tab_finale_[,c(ncol(tab_finale_),1:(ncol(tab_finale_)-1))]
tab_finale_

write.table(tab_finale_, "/home/tjaouen/Documents/Input/ONDE/Data_Description/CorrespondanceOndeHer/HER2hybrides_Jonction/Table_densite_2_20240109.csv",
            sep = ";", dec = ".", row.names = F)


