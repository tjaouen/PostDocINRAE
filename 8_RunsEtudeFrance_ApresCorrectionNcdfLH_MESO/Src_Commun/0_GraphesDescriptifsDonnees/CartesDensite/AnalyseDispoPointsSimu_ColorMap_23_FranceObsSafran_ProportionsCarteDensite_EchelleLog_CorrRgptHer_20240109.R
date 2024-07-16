### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/4_RunsEtudeFrance_20230417/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_Points_IPCCcolors_1_SaveRds_20230910.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_11_SaveRds_20230831.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_12_SaveRds_CorrRgptHER_20230921.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_16_SaveRds_ChoseDensityMin_20231120.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_18_SaveRds_ChoseDensityMin_Pdf_20231211.R")
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

### Output forlder ###
# output_folder_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsObserves/DisponibiliteDonneesHydroDates/AnalyseDisponibiliteDonneesHydro_Graphes/Version1_20230425/Hybrides_sansStatSup2000/"
# output_folder_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230803/"
# output_folder_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidAnSecInterHum_2012_2022_20230919/"
# output_folder_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/"
output_folder_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/CartesDensite_20240109/"

### Study data ###
folder_input_ = folder_input_param_
folder_output_ = folder_output_param_
folder_onde_ = folder_onde_param_
nomSim_ = nomSim_param_


### Disponibilite des Stations par dates ### 
#tab_stations_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsObserves/DisponibiliteDonneesHydroDates/TablesDisponibiliteDonneesHydro/DisponibiliteTemporelle_VersionTJ_20230412/4_DisponibiliteDonnees_ProportionsHER_DatesEtMergeHER2hybrides/HER2_VersionES_2_20230417/4_Merge_DisponibiliteHydro_CorrespondanceHER2hybridesv2_Prop_4_20230427.csv", sep = ";", dec = ".", na.strings = NA, header = T)
# Version avec les surfaces plutot que les proportions
# tab_stations_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsObserves/DisponibiliteDonneesHydroDates/TablesDisponibiliteDonneesHydro/DisponibiliteTemporelle_VersionTJ_20230412/3_DisponibiliteDonnees_DatesEtMergeHER2hybrides/HER2_VersionES_2_20230417/3_Merge_DisponibiliteHydro_CorrespondanceHER2hybridesv2_3_20230420.csv", sep = ";", dec = ".", na.strings = NA, header = T)

# tab_stations_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/Stations_HYDRO_AvecCorrespondanceShp_VersionCorresDistanceBruteExp2_8_20230803.csv", sep = ";", dec = ".", na.strings = NA, header = T)
# tab_stations_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidAnSecInterHum_2012_2022_20230919/Stations_HYDRO_KGESUp0.00_DispSup-1.csv", dec = ".", na.strings = NA, header = T)
# tab_stations_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/Stations_HYDRO_AvecCorrespondanceShp_CorrDistExp2enKm_RattachNomParDefaut_11_20231003.csv", dec = ".", na.strings = NA, header = T)

# titre_tab_ = "CTRIP"
# titre_tab_ = "GRSD"
# titre_tab_ = "J2000"
# titre_tab_ = "ORCHIDEE"
titre_tab_ = "SMASH"

# tab_stations_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/TablesParModele_20231203/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_CTRIP_30_20231221.csv", dec = ".", na.strings = NA, header = T)
# tab_stations_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/TablesParModele_20231203/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_GRSD_30_20231203.csv", dec = ".", na.strings = NA, header = T)
# tab_stations_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/TablesParModele_20231203/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_J2000_32_20231204.csv", dec = ".", na.strings = NA, header = T)
# tab_stations_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/TablesParModele_20231203/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_ORCHIDEE_30_20231203.csv", dec = ".", na.strings = NA, header = T)
tab_stations_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/TablesParModele_20231203/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_SMASH_30_20231203.csv", dec = ".", na.strings = NA, header = T)
if (ncol(tab_stations_) == 1){
  # tab_stations_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidAnSecInterHum_2012_2022_20230919/Stations_HYDRO_KGESUp0.00_DispSup-1.csv", sep = ";", dec = ".", na.strings = NA, header = T)
  # tab_stations_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/Stations_HYDRO_AvecCorrespondanceShp_CorrDistExp2enKm_RattachNomParDefaut_11_20231003.csv", sep = ";", dec = ".", na.strings = NA, header = T)
  # tab_stations_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/TablesParModele_20231203/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_CTRIP_30_20231221.csv", sep = ";", dec = ".", na.strings = NA, header = T)
  # tab_stations_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/TablesParModele_20231203/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_GRSD_30_20231203.csv", sep = ";", dec = ".", na.strings = NA, header = T)
  # tab_stations_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/TablesParModele_20231203/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_J2000_32_20231204.csv", sep = ";", dec = ".", na.strings = NA, header = T)
  # tab_stations_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/TablesParModele_20231203/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_ORCHIDEE_30_20231203.csv", sep = ";", dec = ".", na.strings = NA, header = T)
  tab_stations_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/TablesParModele_20231203/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_SMASH_30_20231203.csv", sep = ";", dec = ".", na.strings = NA, header = T)
}
dim(tab_stations_) #1008 194
# tab_graph_ <- tab_stations_

tab_stations_[which(is.na(tab_stations_$SurfaceTopo)),]
# Surfaces non renseignees sur l'hydroportail : -

# tab_stations_[which((tab_stations_$SurfaceTopo >= 2000) | is.na(tab_stations_$SurfaceTopo)),]
# tab_graph_ <- tab_stations_[which((tab_stations_$SurfaceTopo >= 2000) | is.na(tab_stations_$SurfaceTopo)),]

tab_stations_ = tab_stations_[which(tab_stations_$SurfaceTopo < 2000),]
dim(tab_stations_) #1008 194
tab_graph_ <- tab_stations_


### Table globale ###
# titre_tab_ = "0_ToutesStations"
# titre_graphe_ = " - Tous points de simulation"
# titre_anglais_ = paste0("All simulation points:\n",nrow(tab_graph_)," points")
# dim(tab_graph_)

### CTRIP_diagnostic_20230321
# titre_tab_ = "CTRIP"
# tab_graph_ = tab_graph_[which(tab_graph_$CTRIP_ChoixDefinitifPointSimu == 1),]
# tab_stations_ = tab_stations_[which(tab_stations_$CTRIP_ChoixDefinitifPointSimu == 1),]
# titre_tab_ = "1_CTRIP_diagnostic_20230321"
# titre_anglais_ = paste0("CTRIP model:\n",nrow(tab_graph_)," simulation points")
# dim(tab_graph_)
# 
# tab_graph_ = tab_graph_[which(tab_graph_$EROS_ChoixDefinitifPointSimu == 1),]
# tab_stations_ = tab_stations_[which(tab_stations_$EROS_ChoixDefinitifPointSimu == 1),]
# titre_tab_ = "2_EROS_modele_20230320"
# titre_graphe_ = " - Points de simulation EROS"
# titre_anglais_ = paste0("EROS model:\n",nrow(tab_graph_)," simulation points")
# dim(tab_graph_)
# 
# titre_tab_ = "GRSD"
# tab_graph_ = tab_graph_[which(tab_graph_$GRSD_ChoixDefinitifPointSimu == 1),]
# tab_stations_ = tab_stations_[which(tab_stations_$GRSD_ChoixDefinitifPointSimu == 1),]
# titre_tab_ = "3_GRSD_20230618"
# titre_graphe_ = " - Points de simulation GRSD"
# titre_anglais_ = paste0("GRSD model:\n",nrow(tab_graph_)," simulation points")
# dim(tab_graph_)
# 
# titre_tab_ = "J2000"
# tab_graph_ = tab_graph_[which(tab_graph_$J2000_ChoixDefinitifPointSimu == 1),]
# tab_stations_ = tab_stations_[which(tab_stations_$J2000_ChoixDefinitifPointSimu == 1),]
# titre_tab_ = "4_J2000_20230308_safran_diagnostic"
# titre_graphe_ = " - Points de simulation J2000"
# titre_anglais_ = paste0("J2000 model:\n",nrow(tab_graph_)," simulation points")
# dim(tab_graph_)
# 
# tab_graph_ = tab_graph_[which(tab_graph_$MORDORSD_ChoixDefinitifPointSimu == 1),]
# tab_stations_ = tab_stations_[which(tab_stations_$MORDORSD_ChoixDefinitifPointSimu == 1),]
# titre_tab_ = "5_MORDOR-SD_20230428"
# titre_graphe_ = " - Points de simulation MORDOR-SD"
# titre_anglais_ = paste0("MORDOR-SD model:\n",nrow(tab_graph_)," simulation points")
# dim(tab_graph_)
# 
# tab_graph_ = tab_graph_[which(tab_graph_$MORDORTS_ChoixDefinitifPointSimu == 1),]
# tab_stations_ = tab_stations_[which(tab_stations_$MORDORTS_ChoixDefinitifPointSimu == 1),]
# titre_tab_ = "6_MORDOR-TS_19762017"
# titre_graphe_ = " - Points de simulation MORDOR-TS"
# titre_anglais_ = paste0("MORDOR-TS model:\n",nrow(tab_graph_)," simulation points")
# dim(tab_graph_)
# 
# titre_tab_ = "ORCHIDEE"
# tab_graph_ = tab_graph_[which(tab_graph_$ORCHID_ChoixDefinitifPointSimu == 1),]
# tab_stations_ = tab_stations_[which(tab_stations_$ORCHID_ChoixDefinitifPointSimu == 1),]
# titre_tab_ = "7_ORCHIDEE_extKWR-RZ1-RATIO-HUMCSTE-19760101_20191231"
# titre_graphe_ = " - Points de simulation ORCHIDEE"
# titre_anglais_ = paste0("ORCHIDEE model:\n",nrow(tab_graph_)," simulation points")
# dim(tab_graph_)
# 
# tab_graph_ = tab_graph_[which(tab_graph_$SIM2_ChoixDefinitifPointSimu == 1),]
# tab_stations_ = tab_stations_[which(tab_stations_$SIM2_ChoixDefinitifPointSimu == 1),]
# titre_tab_ = "8_SIM2_19580801_20210731_day_METADATA"
# titre_graphe_ = " - Points de simulation SIM2"
# titre_anglais_ = paste0("SIM2 model:\n",nrow(tab_graph_)," simulation points")
# dim(tab_graph_)
# 
# titre_tab_ = "SMASH"
# tab_graph_ = tab_graph_[which(tab_graph_$SMASH_ChoixDefinitifPointSimu == 1),]
# tab_stations_ = tab_stations_[which(tab_stations_$SMASH_ChoixDefinitifPointSimu == 1),]
# titre_tab_ = "9_SMASH_20230303"
# titre_graphe_ = " - Points de simulation SMASH"
# titre_anglais_ = paste0("SMASH model:\n",nrow(tab_graph_)," simulation points")
# dim(tab_graph_)

titre_anglais_ = paste0(titre_tab_," model:\n",nrow(tab_graph_)," simulation points")



### Calcul de la surface par HER sachant les stations conservees ###
tab_graph_TransfoPropToSurfAbsolues <- tab_graph_[,grep(pattern = "eco0|eco1|eco3|eco4|eco6|eco8", colnames(tab_graph_))]
# tab_graph_TransfoPropToSurfAbsolues <- tab_graph_$SurfaceTopo * tab_graph_TransfoPropToSurfAbsolues
tab_graph_TransfoPropToSurfAbsolues <- tab_graph_$SurfaceTopo_ChoixDefinitifPointSimu * tab_graph_TransfoPropToSurfAbsolues
which(!(round(rowSums(tab_graph_TransfoPropToSurfAbsolues)) == round(tab_graph_$SurfaceTopo))) #664 : 696 et 697, OK
tab_graph_[,grep(pattern = "eco0|eco1|eco3|eco4|eco6|eco8", colnames(tab_graph_))] <- tab_graph_TransfoPropToSurfAbsolues
# write.table(tab_graph_, "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/Stations_HYDRO_AvecCorrespondanceShp_SurfacesAbsolues_6_20230726.csv", sep = ";", dec = ".", row.names = F)



# dim(tab_graph_)
# EROS_modele_20230320
# GRSD_20230618
# J2000_20230308_safran_diagnostic
# MORDOR-SD_20230428
# MORDOR-TS_19762017
# ORCHIDEE_extKWR-RZ1-RATIO-HUMCSTE-19760101_20191231
# SIM2_19580801_20210731_day_METADATA
# SMASH_20230303

# titre_tab_ = "tab1Initiale1"
# titre_tab_ = "tab2ExclFiltreSurface1"
# titre_tab_ = "tab3FiltreSurface20001"
# titre_tab_ = "tab4ExcES1"
# titre_tab_ = "tab5PostExcES1"
# titre_tab_ = "tab6IF1"
# titre_tab_ = "",titre_tab_,""

# titre_tab_ = "CTRIP"
# titre_tab_ = "J2000"
dispo_hydroOff_ = tab_graph_



### Regroupement HER2h ### #31 + 33 + 39, 37 + 54, 69 + 96
# tab_graph_$eco31033039 <- tab_graph_$eco031 + tab_graph_$eco033 + tab_graph_$eco039
# tab_graph_$eco37054 <- tab_graph_$eco037 + tab_graph_$eco054
# tab_graph_$eco69096 <- tab_graph_$eco069 + tab_graph_$eco096
# tab_graph_ <- tab_graph_[,which(!(colnames(tab_graph_) %in% c("eco031","eco033","eco039","eco037","eco054","eco069","eco096")))]






# # Croisement HER 2
# dispo_hydroOff_her2_ <- dispo_hydroOff_[,grep(pattern = "eco0|eco1", colnames(dispo_hydroOff_))]
dispo_hydroOff_her2_ <- dispo_hydroOff_[,grep(pattern = "eco0|eco1|eco3|eco4|eco6|eco8", colnames(dispo_hydroOff_))]
# 
# ### Stations ###
# stations_ <- dispo_hydroOff_
# stations_ = stations_ %>% mutate(BassinColor =
#                                    case_when(substr(Code_short,1,1) == "U" ~ "#31a354",
#                                              substr(Code_short,1,1) == "V" ~ "#313695",
#                                              substr(Code_short,1,1) == "W" ~ "#4575b4",
#                                              substr(Code_short,1,1) == "X" ~ "#fdae61",
#                                              substr(Code_short,1,1) == "Y" ~ "#a50026"))
# coordinates(stations_) <- c("XL93","YL93")
# proj4string(stations_) <- CRS("+init=epsg:2154")


### Caracteristiques HER 2 hybrides - Utilisation de l'aire des HER 2 ###
file_HER2off_desc_ = "/home/tjaouen/Documents/Input/HER/HER2hybrides/DescriptionHER2hybrides_R_1_20230405.xlsx"
tab_HER2off_desc_ = read_excel(file_HER2off_desc_)
tab_HER2off_desc_$Area_km2 = as.numeric(tab_HER2off_desc_$Area_km2)

# tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == )]
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


tab_sum_ = data.frame(AreaHydro = colSums(dispo_hydroOff_her2_))
tab_sum_bin_ = data.frame(NbStationsHydro = colSums(dispo_hydroOff_her2_>0))
rownames(tab_sum_) <- as.numeric(gsub("eco", "", rownames(tab_sum_bin_)))
rownames(tab_sum_bin_) <- as.numeric(gsub("eco", "", rownames(tab_sum_bin_)))

tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("31","33","39"))] = sum(tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("31","33","39"))])
tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("31","33","39"))] = sum(tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("31","33","39"))])
tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("37","54"))] = sum(tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("37","54"))])
tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("37","54"))] = sum(tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("37","54"))])
tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("69","96"))] = sum(tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("69","96"))])
tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("69","96"))] = sum(tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("69","96"))])
tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("49","90"))] = sum(tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("69","96"))])
tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("49","90"))] = sum(tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("69","96"))])
tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("89","92"))] = sum(tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("69","96"))])
tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("89","92"))] = sum(tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("69","96"))])
tab_sum_$HER2 = rownames(tab_sum_)
tab_sum_bin_$HER2 = rownames(tab_sum_bin_)

tab_sum_ = tab_sum_[which(!(rownames(tab_sum_) %in% c("33","39","54","96"))),]
tab_sum_bin_ = tab_sum_bin_[which(!(rownames(tab_sum_bin_) %in% c("33","39","54","96"))),]

rownames(tab_sum_)[which(rownames(tab_sum_) %in% c("31033039"))] = "31+33+39"
rownames(tab_sum_)[which(rownames(tab_sum_) %in% c("37054"))] = "37+54"
rownames(tab_sum_)[which(rownames(tab_sum_) %in% c("69096"))] = "69+96"
rownames(tab_sum_)[which(rownames(tab_sum_) %in% c("49090"))] = "49+90"
rownames(tab_sum_)[which(rownames(tab_sum_) %in% c("89092"))] = "89+92"
tab_sum_$HER2 = rownames(tab_sum_)

rownames(tab_sum_bin_)[which(rownames(tab_sum_bin_) %in% c("31033039"))] = "31+33+39"
rownames(tab_sum_bin_)[which(rownames(tab_sum_bin_) %in% c("37054"))] = "37+54"
rownames(tab_sum_bin_)[which(rownames(tab_sum_bin_) %in% c("69096"))] = "69+96"
rownames(tab_sum_bin_)[which(rownames(tab_sum_bin_) %in% c("49090"))] = "49+90"
rownames(tab_sum_bin_)[which(rownames(tab_sum_bin_) %in% c("89092"))] = "89+92"
tab_sum_bin_$HER2 = rownames(tab_sum_bin_)



# tab_sum_$HER2 = as.numeric(rownames(tab_sum_))
# tab_sum_bin_$HER2 = as.numeric(rownames(tab_sum_))
tab_sum_$SurfaceHER2 = NA
tab_sum_$SurfaceHydroPropSurfHER2 = NA
tab_sum_bin_$SurfaceHER2 = NA
tab_sum_bin_$SurfaceHydroPropSurfHER2_bin = NA
tab_sum_bin_$SurfaceDivNbHydro_bin = NA

# for (i in 1:dim(tab_sum_)[1]){
#   # if (length(which(tab_HER2off_desc_$CdHER2 == as.numeric(rownames(tab_sum_)[i]))) > 0){
#   if (length(which(tab_HER2off_desc_$CdHER2 == rownames(tab_sum_)[i])) > 0){
#     tab_sum_$SurfaceHER2[i] = tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == tab_sum_$HER2[i])]
#     tab_sum_$SurfaceHydroPropSurfHER2[i] = unique(tab_sum_$AreaHydro[i]/tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == tab_sum_$HER2[i])]) # Surface topographique des stations hydro de l'HER 2 hybrides / Surface de l'HER 2 hybrides 
#     tab_sum_bin_$SurfaceHydroPropSurfHER2_bin[i] = unique(tab_sum_bin_$NbStationsHydro[i]/tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == tab_sum_bin_$HER2[i])]) # Nombre de stations par km2 de l'HER 2 hybride
#     tab_sum_bin_$SurfaceDivNbHydro_bin[i] = unique(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == tab_sum_bin_$HER2[i])]/ifelse(tab_sum_bin_$NbStationsHydro[i] == 0,NA,tab_sum_bin_$NbStationsHydro[i])) # Surface de l'HER couverte par une station Hydro
#   }
# }
for (i in 1:dim(tab_sum_)[1]){
  # if (length(which(tab_HER2off_desc_$CdHER2 == as.numeric(rownames(tab_sum_)[i]))) > 0){
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
# write.table(tab_compil_sum_sumbin_,
#             "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/MapVersionExclusions_SurfacesStationsHydro_v20230608/Stations_HYDRO_ExclESSurf2000_DescriptionTopo_1_20230612.csv",
#             sep = ";", dec = ".", row.names = F)

####################################################################################################################################################################################################################
##################################################################################################     Graphe     ##################################################################################################
####################################################################################################################################################################################################################


breaks_SurfaceEntitesHydroPropSurfHER2 = breaks_SurfaceEntitesHydroPropSurfHER2_param
breaks_SurfaceEntitesHydroPropSurfHER2_log = breaks_SurfaceEntitesHydroPropSurfHER2_log_param
breaks_NbEntitesHydroProp1000SurfHER2 = breaks_NbEntitesHydroProp1000SurfHER2_param
breaks_SurfHER2ParEntiteHydro = breaks_SurfHER2ParEntiteHydro_param
color_pointsSimu = color_pointsSimu_param


### SURFACE HYDRO / SURFACE HER2 ###
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_",titre_tab_,"_1_20230911.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230925/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_",titre_tab_,"_1_20230925.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231016/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_",titre_tab_,"_1_20231016.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231121/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_",titre_tab_,"_1_20231121.png")
output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_",titre_tab_,"_1_20240109.pdf")
plot_map_variable(tab_ = tab_sum_,
                  varname_ = "SurfaceHydroPropSurfHER2",
                  # vartitle_ = "Ratio entre les surfaces\ntopographiques des stations\nHYDRO interceptées et les\nsurfaces des HER 2 hybrides",
                  vartitle_ = "Ratio (sans unité)",
                  breaks_ = breaks_SurfaceEntitesHydroPropSurfHER2,
                  output_name_ = output_name_,
                  # title_ = "Densité de stations HYDRO",
                  title_ = "",
                  reverseColors_ = F,
                  reverseLegend_ = T,
                  labels_name_ = F,
                  nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt") #nomPalette_ = "misc_div_disc.txt")
# nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt") #nomPalette_ = "misc_div_disc.txt")

# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_",titre_tab_,"_English_1_20230911.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230925/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_",titre_tab_,"_English_1_20230925.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231016/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_",titre_tab_,"_English_1_20231016.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231121/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_",titre_tab_,"_English_1_20231121.png")
output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_",titre_tab_,"_1_20240109.pdf")
plot_map_variable(tab_ = tab_sum_,
                  varname_ = "SurfaceHydroPropSurfHER2",
                  vartitle_ = "Ratio (unitless)",
                  # vartitle_ = "Ratio between the topographic surfaces of HYDRO intercept stations and the surfaces of HER 2 hybrid areas",
                  breaks_ = breaks_SurfaceEntitesHydroPropSurfHER2,
                  output_name_ = output_name_,
                  # title_ = "Density of HYDRO stations",
                  title_ = "",
                  reverseColors_ = F,
                  reverseLegend_ = T,
                  labels_name_ = F,
                  nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt") #nomPalette_ = "misc_div_disc.txt")
# nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt") #nomPalette_ = "misc_div_disc.txt")

# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_",titre_tab_,"_sansEtiq_1_20230911.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230925/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_",titre_tab_,"_sansEtiq_1_20230925.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231016/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_",titre_tab_,"_sansEtiq_1_20231016.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231121/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_",titre_tab_,"_sansEtiq_1_20231121.png")
output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_",titre_tab_,"_sansEtiq_1_20240109.pdf")
plot_map_variable_sansEtiquettes(tab_ = tab_sum_,
                                 varname_ = "SurfaceHydroPropSurfHER2",
                                 # vartitle_ = "Ratio entre les surfaces\ntopographiques des stations\nHYDRO interceptées et les\nsurfaces des HER 2 hybrides",
                                 vartitle_ = "Ratio (sans unité)",
                                 breaks_ = breaks_SurfaceEntitesHydroPropSurfHER2,
                                 output_name_ = output_name_,
                                 # title_ = "Densité de stations HYDRO",
                                 title_ = "",
                                 reverseColors_ = F,
                                 reverseLegend_ = T,
                                 labels_name_ = F,
                                 nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", #nomPalette_ = "misc_div_disc.txt")
                                 # nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt", #nomPalette_ = "misc_div_disc.txt")
                                 sansTexteHer_ = T)

# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_",titre_tab_,"_sansEtiq_English_1_20230911.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230925/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_",titre_tab_,"_sansEtiq_English_1_20230925.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231016/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_",titre_tab_,"_sansEtiq_English_1_20231016.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231121/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_",titre_tab_,"_sansEtiq_English_1_20231121.png")
output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_",titre_tab_,"_sansEtiq_English_1_20240109.pdf")
plot_map_variable_sansEtiquettes(tab_ = tab_sum_,
                                 varname_ = "SurfaceHydroPropSurfHER2",
                                 vartitle_ = "Ratio (unitless)",
                                 # vartitle_ = "Ratio between the topographic surfaces of HYDRO intercept stations and the surfaces of HER 2 hybrid areas",
                                 breaks_ = breaks_SurfaceEntitesHydroPropSurfHER2,
                                 output_name_ = output_name_,
                                 # title_ = "Density of HYDRO stations",
                                 title_ = "",
                                 reverseColors_ = F,
                                 reverseLegend_ = T,
                                 labels_name_ = F,
                                 nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", #nomPalette_ = "misc_div_disc.txt")
                                 # nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt", #nomPalette_ = "misc_div_disc.txt")
                                 sansTexteHer_ = T)



### LOG SURFACE HYDRO / SURFACE HER2 ###
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_",titre_tab_,"_1_20230911.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230925/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_",titre_tab_,"_1_20230925.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231016/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_",titre_tab_,"_1_20231016.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231121/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_",titre_tab_,"_1_20231121.png")
output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_",titre_tab_,"_1_20240109.pdf")
plot_map_variable(tab_ = tab_sum_,
                  varname_ = "SurfaceHydroPropSurfHER2_log",
                  vartitle_ = "Log-ratio (sans unité)",
                  breaks_ = breaks_SurfaceEntitesHydroPropSurfHER2_log,
                  output_name_ = output_name_,
                  title_ = "",
                  reverseColors_ = F,
                  labels_name_ = F,
                  nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt") #nomPalette_ = "misc_div_disc.txt")
# nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt") #nomPalette_ = "misc_div_disc.txt")

# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_",titre_tab_,"_English_1_20230911.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230925/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_",titre_tab_,"_English_1_20230925.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231016/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_",titre_tab_,"_English_1_20231016.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231121/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_",titre_tab_,"_English_1_20231121.png")
output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_",titre_tab_,"_English_1_20240109.pdf")
plot_map_variable(tab_ = tab_sum_,
                  varname_ = "SurfaceHydroPropSurfHER2_log",
                  vartitle_ = "Log-ratio (unitless)",
                  breaks_ = breaks_SurfaceEntitesHydroPropSurfHER2_log,
                  output_name_ = output_name_,
                  title_ = "",
                  reverseColors_ = F,
                  reverseLegend_ = T,
                  labels_name_ = F,
                  nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt") #nomPalette_ = "misc_div_disc.txt")
# nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt") #nomPalette_ = "misc_div_disc.txt")

# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_",titre_tab_,"_sansEtiq_1_20230911.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230925/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_",titre_tab_,"_sansEtiq_1_20230925.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231016/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_",titre_tab_,"_sansEtiq_1_20231016.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231121/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_",titre_tab_,"_sansEtiq_1_20231121.png")
output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_",titre_tab_,"_sansEtiq_1_20240109.pdf")
plot_map_variable_sansEtiquettes(tab_ = tab_sum_,
                                 varname_ = "SurfaceHydroPropSurfHER2_log",
                                 vartitle_ = "Log-ratio (sans unité)",
                                 breaks_ = breaks_SurfaceEntitesHydroPropSurfHER2_log,
                                 output_name_ = output_name_,
                                 title_ = "",
                                 reverseColors_ = F,
                                 labels_name_ = F,
                                 nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", #nomPalette_ = "misc_div_disc.txt")
                                 # nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt", #nomPalette_ = "misc_div_disc.txt")
                                 sansTexteHer_ = T)

# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_",titre_tab_,"_sansEtiq_English_1_20230911.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231016/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_",titre_tab_,"_sansEtiq_English_1_20231016.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231121/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_",titre_tab_,"_sansEtiq_English_1_20231121.png")
output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_",titre_tab_,"_sansEtiq_English_1_20240109.pdf")
plot_map_variable_sansEtiquettes(tab_ = tab_sum_,
                                 varname_ = "SurfaceHydroPropSurfHER2_log",
                                 vartitle_ = "Log-ratio (unitless)",
                                 breaks_ = breaks_SurfaceEntitesHydroPropSurfHER2_log,
                                 output_name_ = output_name_,
                                 title_ = "",
                                 reverseColors_ = F,
                                 reverseLegend_ = T,
                                 labels_name_ = F,
                                 nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", #nomPalette_ = "misc_div_disc.txt")
                                 # nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt", #nomPalette_ = "misc_div_disc.txt")
                                 sansTexteHer_ = T)

### NOMBRE STATIONS HYDRO / 1000 KM 2 HER2 ###
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_",titre_tab_,"_1_20230911.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230925/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_",titre_tab_,"_1_20230925.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231016/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_",titre_tab_,"_1_20231016.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231121/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_",titre_tab_,"_1_20231121.png")
output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_",titre_tab_,"_1_20240109.pdf")
plot_map_variable(tab_ = tab_sum_bin_,
                  varname_ = "SurfaceHydroPropSurfHER2_bin",
                  vartitle_ = bquote(atop("Nombre de stations pour", "1000 " ~ km^2 ~ "d'HER2")),
                  breaks_ = breaks_NbEntitesHydroProp1000SurfHER2,
                  output_name_ = output_name_,
                  title_ = "",
                  reverseColors_ = F,
                  reverseLegend_ = T,
                  labels_name_ = F,
                  nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt") #nomPalette_ = "misc_div_disc.txt")
# nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt") #nomPalette_ = "misc_div_disc.txt")

# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_",titre_tab_,"_English_1_20230911.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230925/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_",titre_tab_,"_English_1_20230925.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231016/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_",titre_tab_,"_English_1_20231016.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231121/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_",titre_tab_,"_English_1_20231121.png")
output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_",titre_tab_,"_English_1_20240109.pdf")
plot_map_variable(tab_ = tab_sum_bin_,
                  varname_ = "SurfaceHydroPropSurfHER2_bin",
                  vartitle_ = bquote(atop("Number of stations per", "1000 " ~ km^2 ~ "of HER2")),
                  breaks_ = breaks_NbEntitesHydroProp1000SurfHER2,
                  output_name_ = output_name_,
                  title_ = "",
                  reverseColors_ = F,
                  reverseLegend_ = T,
                  labels_name_ = F,
                  nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt") #nomPalette_ = "misc_div_disc.txt")
# nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt") #nomPalette_ = "misc_div_disc.txt")

# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_",titre_tab_,"_sansEtiq_1_20230911.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230925/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_",titre_tab_,"_sansEtiq_1_20230925.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231016/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_",titre_tab_,"_sansEtiq_1_20231016.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231121/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_",titre_tab_,"_sansEtiq_1_20231121.png")
output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_",titre_tab_,"_sansEtiq_1_20240109.pdf")
plot_map_variable_sansEtiquettes(tab_ = tab_sum_bin_,
                                 varname_ = "SurfaceHydroPropSurfHER2_bin",
                                 vartitle_ = bquote(atop("Nombre de stations pour", "1000 " ~ km^2 ~ "d'HER2")),
                                 breaks_ = breaks_NbEntitesHydroProp1000SurfHER2,
                                 output_name_ = output_name_,
                                 title_ = "",
                                 reverseColors_ = F,
                                 reverseLegend_ = T,
                                 labels_name_ = F,
                                 nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", #nomPalette_ = "misc_div_disc.txt")
                                 # nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt", #nomPalette_ = "misc_div_disc.txt")
                                 sansTexteHer_ = T)

# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_",titre_tab_,"_sansEtiq_English_1_20230911.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230925/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_",titre_tab_,"_sansEtiq_English_1_20230925.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231016/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_",titre_tab_,"_sansEtiq_English_1_20231016.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231121/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_",titre_tab_,"_sansEtiq_English_1_20231121.png")
output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_",titre_tab_,"_sansEtiq_English_1_20240109.pdf")
plot_map_variable_sansEtiquettes(tab_ = tab_sum_bin_,
                                 varname_ = "SurfaceHydroPropSurfHER2_bin",
                                 vartitle_ = bquote(atop("Number of stations per", "1000 " ~ km^2 ~ "of HER2")),
                                 breaks_ = breaks_NbEntitesHydroProp1000SurfHER2,
                                 output_name_ = output_name_,
                                 title_ = "",
                                 reverseColors_ = F,
                                 reverseLegend_ = T,
                                 labels_name_ = F,
                                 nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", #nomPalette_ = "misc_div_disc.txt")
                                 # nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt", #nomPalette_ = "misc_div_disc.txt")
                                 sansTexteHer_ = T)



### Surface HER2 par station Hydro ###
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_",titre_tab_,"_1_20230911.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230925/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_",titre_tab_,"_1_20230925.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231016/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_",titre_tab_,"_1_20231016.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231121/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_",titre_tab_,"_1_20231121.png")
output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_",titre_tab_,"_1_20240109.pdf")
plot_map_variable(tab_ = tab_sum_bin_,
                  varname_ = "SurfaceDivNbHydro_bin",
                  vartitle_ = bquote(atop("Surface moyenne d'HER2 (en " ~ km^2 ~ ")", "couverte par une station")),
                  breaks_ = breaks_SurfHER2ParEntiteHydro_param,
                  output_name_ = output_name_,
                  title_ = "",
                  reverseColors_ = T,
                  reverseLegend_ = T,
                  labels_name_ = F,
                  nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt") #nomPalette_ = "misc_div_disc.txt")
# nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt") #nomPalette_ = "misc_div_disc.txt")

# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_",titre_tab_,"_English_1_20230911.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230925/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_",titre_tab_,"_English_1_20230925.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231016/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_",titre_tab_,"_English_1_20231016.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231121/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_",titre_tab_,"_English_1_20231121.png")
output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_",titre_tab_,"_English_1_20240109.pdf")
plot_map_variable(tab_ = tab_sum_bin_,
                  varname_ = "SurfaceDivNbHydro_bin",
                  vartitle_ = bquote(atop("Average HER2 area (in " ~ km^2 ~ ")", "covered by a station")),
                  breaks_ = breaks_SurfHER2ParEntiteHydro_param,
                  output_name_ = output_name_,
                  title_ = "",
                  reverseColors_ = T,
                  reverseLegend_ = T,
                  labels_name_ = F,
                  nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt") #nomPalette_ = "misc_div_disc.txt")
# nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt") #nomPalette_ = "misc_div_disc.txt")

# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_",titre_tab_,"_sansEtiq_1_20230911.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230925/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_",titre_tab_,"_sansEtiq_1_20230925.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231016/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_",titre_tab_,"_sansEtiq_1_20231016.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231121/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_",titre_tab_,"_sansEtiq_1_20231121.png")
output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_",titre_tab_,"_sansEtiq_1_20240109.pdf")
plot_map_variable_sansEtiquettes(tab_ = tab_sum_bin_,
                                 varname_ = "SurfaceDivNbHydro_bin",
                                 vartitle_ = bquote(atop("Surface moyenne d'HER2 (en " ~ km^2 ~ ")", "couverte par une station")),
                                 breaks_ = breaks_SurfHER2ParEntiteHydro_param,
                                 output_name_ = output_name_,
                                 title_ = "",
                                 reverseColors_ = T,
                                 reverseLegend_ = T,
                                 labels_name_ = F,
                                 nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", #nomPalette_ = "misc_div_disc.txt")
                                 # nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt", #nomPalette_ = "misc_div_disc.txt")
                                 sansTexteHer_ = T)

# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_",titre_tab_,"_sansEtiq_English_1_20230911.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230925/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_",titre_tab_,"_sansEtiq_English_1_20230925.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231016/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_",titre_tab_,"_sansEtiq_English_1_20231016.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231121/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_",titre_tab_,"_sansEtiq_English_1_20231121.png")
output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_",titre_tab_,"_sansEtiq_English_1_20240109.pdf")
plot_map_variable_sansEtiquettes(tab_ = tab_sum_bin_,
                                 varname_ = "SurfaceDivNbHydro_bin",
                                 vartitle_ = bquote(atop("Average HER2 area (in " ~ km^2 ~ ")", "covered by a station")),
                                 breaks_ = breaks_SurfHER2ParEntiteHydro_param,
                                 output_name_ = output_name_,
                                 title_ = "",
                                 reverseColors_ = T,
                                 reverseLegend_ = T,
                                 labels_name_ = F,
                                 nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", #nomPalette_ = "misc_div_disc.txt")
                                 # nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt", #nomPalette_ = "misc_div_disc.txt")
                                 sansTexteHer_ = T)

### Plot points ###
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_PointsStations_",titre_tab_,"_sansEtiq_English_1_20230911.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230925/Carte_PointsStations_",titre_tab_,"_sansEtiq_English_1_20230925.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231016/Carte_PointsStations_",titre_tab_,"_sansEtiq_English_1_20231016.png")
# output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/1_MapParModele_SurfacesStationsHydro_20231121/Carte_PointsStations_",titre_tab_,"_sansEtiq_English_1_20231121.png")
output_name_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_PointsStations_",titre_tab_,"_sansEtiq_English_1_20240109.png")
plot_map_variable_points(tab_ = tab_graph_,
                         vartitle_ = titre_anglais_,
                         output_name_ = output_name_,
                         title_ = "",
                         nomX = "XL93",
                         nomY = "YL93",
                         color = color_pointsSimu)



# write.table(tab_sum_,
#             paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/TableDensiteParModele_20231016/TableDensiteParModele_",titre_tab_,"_20231016.csv"),
#             sep = ";", dec = ".", row.names = F)
# write.table(tab_sum_bin_,
#             paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_23_ObservesReanalyseSafran_DriasEau_20231002/TableDensiteParModele_20231016/TableDensiteParModele_",titre_tab_,"_bin_20231016.csv"),
#             sep = ";", dec = ".", row.names = F)




### Aires HER2 ###
# Avec l'HER2 10
# hist(tab_sum_$SurfaceHER2)
# length(which(tab_sum_$SurfaceHER2<10000))/length(which(!(is.na(tab_sum_$SurfaceHER2)))) # 78.2%
# median(tab_sum_$SurfaceHER2, na.rm = T) # 4587.745
# quantile(tab_sum_$SurfaceHER2, na.rm = T, probs = 0.25) # 2615.296
# quantile(tab_sum_$SurfaceHER2, na.rm = T, probs = 0.75) # 9338.128

tab_sum_ = tab_sum_[which(tab_sum_$HER2 != "0"),]
tab_sum_ = tab_sum_[which(tab_sum_$HER2 != "10"),]
hist(tab_sum_$SurfaceHER2)
length(which(tab_sum_$SurfaceHER2<10000))/length(which(!(is.na(tab_sum_$SurfaceHER2)))) # 77.9
median(tab_sum_$SurfaceHER2, na.rm = T) # 4614.968
quantile(tab_sum_$SurfaceHER2, na.rm = T, probs = 0.25) # 2885.09
quantile(tab_sum_$SurfaceHER2, na.rm = T, probs = 0.75) # 9557.127

length(which(tab_sum_$SurfaceHER2 > 10000))
length(tab_sum_$SurfaceHER2 > 10000)
length(which(tab_sum_$SurfaceHER2 > 10000))/length(tab_sum_$SurfaceHER2 > 10000)

### Aires stations Hydro par HER2 ###
# hist(tab_sum_$AreaHydro) # 
# median(tab_sum_$AreaHydro, na.rm = T) # 3122
# quantile(tab_sum_$AreaHydro, na.rm = T, probs = 0.25) # 1515.5
# quantile(tab_sum_$AreaHydro, na.rm = T, probs = 0.75) # 6155.3

# Sans HER2 10
tab_sum_ = tab_sum_[which(tab_sum_$HER2 != "10"),]
hist(tab_sum_$AreaHydro) #
median(tab_sum_$AreaHydro, na.rm = T) # 3127
quantile(tab_sum_$AreaHydro, na.rm = T, probs = 0.25) # 1556.2
quantile(tab_sum_$AreaHydro, na.rm = T, probs = 0.75) # 6175


### Proportion surface Hydro / surface HER2 ###
# hist(tab_sum_$SurfaceHydroPropSurfHER2) # 
# mean(tab_sum_$SurfaceHydroPropSurfHER2, na.rm = T) #0.787
# median(tab_sum_$SurfaceHydroPropSurfHER2, na.rm = T) #0.577
# quantile(tab_sum_$SurfaceHydroPropSurfHER2, na.rm = T, probs = 0.25) #0.357
# quantile(tab_sum_$SurfaceHydroPropSurfHER2, na.rm = T, probs = 0.75) #1.028

# Sans HER2 10 -> Pas de changement car NA
tab_sum_ = tab_sum_[which(tab_sum_$HER2 != "10"),]
hist(tab_sum_$SurfaceHydroPropSurfHER2) # 
mean(tab_sum_$SurfaceHydroPropSurfHER2, na.rm = T) #0.787
median(tab_sum_$SurfaceHydroPropSurfHER2, na.rm = T) #0.577
quantile(tab_sum_$SurfaceHydroPropSurfHER2, na.rm = T, probs = 0.25) #0.357
quantile(tab_sum_$SurfaceHydroPropSurfHER2, na.rm = T, probs = 0.75) #1.028

### Nombre station Hydro / surface HER2 * 1000 ###
# median(tab_sum_bin_$SurfaceHydroPropSurfHER2_bin, na.rm = T) #3.445
# quantile(tab_sum_bin_$SurfaceHydroPropSurfHER2_bin, na.rm = T, probs = 0.25) #1.950
# quantile(tab_sum_bin_$SurfaceHydroPropSurfHER2_bin, na.rm = T, probs = 0.75) #5.682

tab_sum_bin_ = tab_sum_bin_[which(tab_sum_bin_$HER2 != "10"),]
median(tab_sum_bin_$SurfaceHydroPropSurfHER2_bin, na.rm = T) #3.445
quantile(tab_sum_bin_$SurfaceHydroPropSurfHER2_bin, na.rm = T, probs = 0.25) #1.950
quantile(tab_sum_bin_$SurfaceHydroPropSurfHER2_bin, na.rm = T, probs = 0.75) #5.682




table(tab_sum_$AreaHydro>0,tab_sum_$HER2 != 0)
# Tous poins simu : 77/77
# CTRIP : 
# EROS : 
# GRSD : 
# J2000 : 
# MORDOR-SD : 
# MORDOR-TS : 
# ORCHIDEE : 
# SIM2 : 
# SMASH : 



write.table(tab_sum_bin_, "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/TableDensiteJ2000_20240109.csv",sep = ";", dec = ".", row.names = F)
