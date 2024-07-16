### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/4_RunsEtudeFrance_20230417/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_11_SaveRds_20230831.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_29_NewColors_Svg_20240315.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_31_NewColors_Svg_20240319.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_32_Surligner_NewColors_Svg_20240617.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_Points_IPCCcolors_3_SaveRds_20240315.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_Points_IPCCcolors_4_SaveRds_20240618.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")

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
output_folder_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsObserves/DisponibiliteDonneesHydroDates/AnalyseDisponibiliteDonneesHydro_Graphes/Version1_20230425/Hybrides_sansStatSup2000/"

### Study data ###
folder_input_ = folder_input_param_
folder_output_ = folder_output_param_
folder_onde_ = folder_onde_param_
nomSim_ = nomSim_param_


### Disponibilite des Stations par dates ### 
#tab_stations_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsObserves/DisponibiliteDonneesHydroDates/TablesDisponibiliteDonneesHydro/DisponibiliteTemporelle_VersionTJ_20230412/4_DisponibiliteDonnees_ProportionsHER_DatesEtMergeHER2hybrides/HER2_VersionES_2_20230417/4_Merge_DisponibiliteHydro_CorrespondanceHER2hybridesv2_Prop_4_20230427.csv", sep = ";", dec = ".", na.strings = NA, header = T)
# Version avec les surfaces plutot que les proportions
tab_stations_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsObserves/DisponibiliteDonneesHydroDates/TablesDisponibiliteDonneesHydro/DisponibiliteTemporelle_VersionTJ_20230412/3_DisponibiliteDonnees_DatesEtMergeHER2hybrides/HER2_VersionES_2_20230417/3_Merge_DisponibiliteHydro_CorrespondanceHER2hybridesv2_3_20230420.csv", sep = ";", dec = ".", na.strings = NA, header = T)
dim(tab_stations_) #1250 134
# tab_graph_ <- tab_stations_

tab_stations_[which(is.na(tab_stations_$SurfaceTopo)),]
# Surfaces non renseignees sur l'hydroportail : "H110200901", "H320000104", "O408101001", "O710060101", "Q110501001"

# tab_stations_[which((tab_stations_$SurfaceTopo >= 2000) | is.na(tab_stations_$SurfaceTopo)),]
# tab_graph_ <- tab_stations_[which((tab_stations_$SurfaceTopo >= 2000) | is.na(tab_stations_$SurfaceTopo)),]

tab_stations_ = tab_stations_[which(tab_stations_$SurfaceTopo < 2000),]
dim(tab_stations_) #1094
# tab_graph_ <- tab_stations_

######################################################################################################################################################################################################################################################################################

################## PREMIERE CARTE 

### Exclusion ES ###
file_exclusions_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsObserves/DisponibiliteDonneesHydroDates/DiagnosticQualiteEtImpactStations/2_SelectionES_BaseSurCalibrageModeles_20230512/ClasseurStationAExclure_TraitementTJ_20230522.xlsx"
tab_exclusions_ <- read_xlsx(file_exclusions_)
dim(tab_exclusions_) # 71
# tab_graph_ <- tab_stations_[which(tab_stations_$Code_short %in% tab_exclusions_$Code_short),]

tab_stations_critereES_ <- tab_stations_[which(!(tab_stations_$Code_short %in% tab_exclusions_$Code_short)),]
dim(tab_stations_critereES_) # 1061
# tab_graph_ <- tab_stations_critereES_

table(tab_stations_critereES_$Impact_local, useNA = "always") # 53
# tab_graph_ <- tab_stations_critereES_[which((tab_stations_critereES_$Impact_local == "Influence forte en toute saison") | is.na(tab_stations_critereES_$Impact_local)),]
tab_stations_critereES_ <- tab_stations_critereES_[which(!(tab_stations_critereES_$Impact_local == "Influence forte en toute saison") | is.na(tab_stations_critereES_$Impact_local)),]
dim(tab_stations_critereES_) #1008
tab_graph_ <- tab_stations_critereES_


dim(tab_graph_)
# titre_tab_ = "tab1Initiale1"
# titre_tab_ = "tab2ExclFiltreSurface1"
# titre_tab_ = "tab3FiltreSurface20001"
# titre_tab_ = "tab4ExcES1"
# titre_tab_ = "tab5PostExcES1"
# titre_tab_ = "tab6IF1"
titre_tab_ = "tab7ToutesExclusions1"
dispo_hydroOff_ = tab_graph_



### Regroupement HER2h ### #31 + 33 + 39, 37 + 54, 69 + 96
tab_graph_$eco31033039 <- tab_graph_$eco031 + tab_graph_$eco033 + tab_graph_$eco039
tab_graph_$eco37054 <- tab_graph_$eco037 + tab_graph_$eco054
tab_graph_$eco69096 <- tab_graph_$eco069 + tab_graph_$eco096
tab_graph_$eco89092 <- tab_graph_$eco089 + tab_graph_$eco092
tab_graph_$eco49090 <- tab_graph_$eco049 + tab_graph_$eco090
tab_graph_ <- tab_graph_[,which(!(colnames(tab_graph_) %in% c("eco031","eco033","eco039",
                                                              "eco037","eco054",
                                                              "eco069","eco096",
                                                              "eco089","eco092",
                                                              "eco049","eco090")))]






# Croisement HER 2
# dispo_hydroOff_her2_ <- dispo_hydroOff_[,grep(pattern = "eco0|eco1", colnames(dispo_hydroOff_))]
dispo_hydroOff_her2_ <- dispo_hydroOff_[,grep(pattern = "eco0|eco1|eco3|eco4|eco6|eco8", colnames(dispo_hydroOff_))]

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

tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 89)] = "89+92"
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 92)] = "89+92"
tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "89+92")] = sum(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "89+92")])

tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 49)] = "49+90"
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 90)] = "49+90"
tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "49+90")] = sum(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "49+90")])


tab_sum_ = data.frame(AreaHydro = colSums(dispo_hydroOff_her2_)) ### OK ON PARLE BIEN EN SURFACES ET NON EN PROPORTION
tab_sum_bin_ = data.frame(NbStationsHydro = colSums(dispo_hydroOff_her2_>0))
rownames(tab_sum_) <- as.numeric(gsub("eco", "", rownames(tab_sum_bin_)))
rownames(tab_sum_bin_) <- as.numeric(gsub("eco", "", rownames(tab_sum_bin_)))

tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("31","33","39"))] = sum(tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("31","33","39"))])
tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("31","33","39"))] = sum(tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("31","33","39"))])
tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("37","54"))] = sum(tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("37","54"))])
tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("37","54"))] = sum(tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("37","54"))])
tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("69","96"))] = sum(tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("69","96"))])
tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("69","96"))] = sum(tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("69","96"))])
tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("49","90"))] = sum(tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("49","90"))])
tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("49","90"))] = sum(tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("49","90"))])
tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("89","92"))] = sum(tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("89","92"))])
tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("89","92"))] = sum(tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("89","92"))])
tab_sum_$HER2 = rownames(tab_sum_)
tab_sum_bin_$HER2 = rownames(tab_sum_bin_)

tab_sum_ = tab_sum_[which(!(rownames(tab_sum_) %in% c("33","39","54","96","90","92"))),]
tab_sum_bin_ = tab_sum_bin_[which(!(rownames(tab_sum_bin_) %in% c("33","39","54","96","90","92"))),]

rownames(tab_sum_)[which(rownames(tab_sum_) %in% c("31"))] = "31+33+39"
rownames(tab_sum_)[which(rownames(tab_sum_) %in% c("37"))] = "37+54"
rownames(tab_sum_)[which(rownames(tab_sum_) %in% c("69"))] = "69+96"
rownames(tab_sum_)[which(rownames(tab_sum_) %in% c("49"))] = "49+90"
rownames(tab_sum_)[which(rownames(tab_sum_) %in% c("89"))] = "89+92"
tab_sum_$HER2 = rownames(tab_sum_)

rownames(tab_sum_bin_)[which(rownames(tab_sum_bin_) %in% c("31"))] = "31+33+39"
rownames(tab_sum_bin_)[which(rownames(tab_sum_bin_) %in% c("37"))] = "37+54"
rownames(tab_sum_bin_)[which(rownames(tab_sum_bin_) %in% c("69"))] = "69+96"
rownames(tab_sum_bin_)[which(rownames(tab_sum_bin_) %in% c("49"))] = "49+90"
rownames(tab_sum_bin_)[which(rownames(tab_sum_bin_) %in% c("89"))] = "89+92"
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

####################################################################################################################################################################################################################
##################################################################################################     Graphe     ##################################################################################################
####################################################################################################################################################################################################################

# Créer la palette de couleurs SurfaceHydroPropSurfHER2
# if (max(na.omit(tab_sum_$SurfaceHydroPropSurfHER2)) > 4){
#   breaks_col_SurfaceHydroPropSurfHER2 <- seq(0, 18, by = 2)
# }else if (max(na.omit(tab_sum_$SurfaceHydroPropSurfHER2)) > 3){
#   breaks_col_SurfaceHydroPropSurfHER2 <- seq(0, 4, by = 0.5)
# }else {
#   breaks_col_SurfaceHydroPropSurfHER2 <- c(0,0.1,0.2,0.3,0.4,0.5,1,2,3)
#   # breaks_col_SurfaceHydroPropSurfHER2 <- log(c(0.00001,0.1,0.2,0.3,0.4,0.5,1,2,3))
# }

breaks_SurfaceEntitesHydroPropSurfHER2 = breaks_SurfaceEntitesHydroPropSurfHER2_param
breaks_SurfaceEntitesHydroPropSurfHER2_log = breaks_SurfaceEntitesHydroPropSurfHER2_log_param
breaks_NbEntitesHydroProp1000SurfHER2 = breaks_NbEntitesHydroProp1000SurfHER2_param
breaks_SurfHER2ParEntiteHydro = breaks_SurfHER2ParEntiteHydro_param
color_stationsHydrometriques = color_stationsHydrometriques_param

### SURFACE HYDRO / SURFACE HER2 ###
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/MapVersionExclusions_SurfacesStationsHydro_v20230910/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_tab7ToutesExclusions1_1_20230910.png"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240318/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_tab7ToutesExclusions1_1_20240119.pdf"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240329/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_tab7ToutesExclusions1_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240405/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_tab7ToutesExclusions1_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240411/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_tab7ToutesExclusions1_1_20240329"
output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240624/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_tab7ToutesExclusions1_1_20240624"
plot_map_variable(tab_ = tab_sum_,
                  varname_ = "SurfaceHydroPropSurfHER2",
                  vartitle_ = "Ratio\n(sans unité)",
                  breaks_ = round(breaks_SurfaceEntitesHydroPropSurfHER2,1),
                  output_name_ = output_name_,
                  title_ = "",
                  nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt",
                  reverseColors_ = F,
                  reverseLegend_ = T,
                  echelleAttenuee_ = F,
                  addValueUnder = -10,
                  HER2_excluesDensity_ = NULL,
                  # subtitle_ = subtitle_,
                  annotation_txt_ = F,
                  percentFormat = F,
                  borderCol = "gray40")


# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/MapVersionExclusions_SurfacesStationsHydro_v20230910/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_tab7ToutesExclusions1_English_1_20230910.png"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240318/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_tab7ToutesExclusions1_English_1_20240119.pdf"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240329/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_tab7ToutesExclusions1_English_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240405/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_tab7ToutesExclusions1_English_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240411/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_tab7ToutesExclusions1_English_1_20240329"
output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240624/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_tab7ToutesExclusions1_English_1_20240624"
plot_map_variable(tab_ = tab_sum_,
                  varname_ = "SurfaceHydroPropSurfHER2",
                  vartitle_ = "Ratio\n(unitless)",
                  breaks_ = round(breaks_SurfaceEntitesHydroPropSurfHER2,1),
                  output_name_ = output_name_,
                  title_ = "",
                  nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt",
                  reverseColors_ = F,
                  reverseLegend_ = T,
                  echelleAttenuee_ = F,
                  addValueUnder = -10,
                  HER2_excluesDensity_ = NULL,
                  # subtitle_ = subtitle_,
                  annotation_txt_ = F,
                  percentFormat = F,
                  borderCol = "gray40")


# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/MapVersionExclusions_SurfacesStationsHydro_v20230910/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_1_20230910.png"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240318/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_tab7ToutesExclusions1_English_1_20240119.pdf"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240329/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_tab7ToutesExclusions1_English_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240405/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_tab7ToutesExclusions1_English_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240411/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_tab7ToutesExclusions1_English_1_20240329"
output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240624/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_tab7ToutesExclusions1_English_1_20240624"
plot_map_variable_sansEtiquettes(tab_ = tab_sum_,
                                 varname_ = "SurfaceHydroPropSurfHER2",
                                 vartitle_ = "Ratio\n(sans unité)",
                                 breaks_ = round(breaks_SurfaceEntitesHydroPropSurfHER2,1),
                                 output_name_ = output_name_,
                                 title_ = "",
                                 nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt",
                                 reverseColors_ = F,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = F,
                                 addValueUnder = -10,
                                 HER2_excluesDensity_ = NULL,
                                 # subtitle_ = subtitle_,
                                 annotation_txt_ = F,
                                 percentFormat = F,
                                 sansTexteHer_ = T,
                                 borderCol = "gray40")


# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/MapVersionExclusions_SurfacesStationsHydro_v20230910/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_English_1_20230910.png"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240318/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_English_1_20240119.pdf"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240329/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_English_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240405/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_English_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240411/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_English_1_20240329"
output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240624/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_English_1_20240624"
plot_map_variable_sansEtiquettes(tab_ = tab_sum_,
                                 varname_ = "SurfaceHydroPropSurfHER2",
                                 vartitle_ = "Ratio\n(unitless)",
                                 breaks_ = round(breaks_SurfaceEntitesHydroPropSurfHER2,1),
                                 output_name_ = output_name_,
                                 title_ = "",
                                 nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt",
                                 reverseColors_ = F,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = F,
                                 addValueUnder = -10,
                                 HER2_excluesDensity_ = NULL,
                                 # subtitle_ = subtitle_,
                                 annotation_txt_ = F,
                                 percentFormat = F,
                                 sansTexteHer_ = T,
                                 borderCol = "gray40")



### LOG SURFACE HYDRO / SURFACE HER2 ###
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/MapVersionExclusions_SurfacesStationsHydro_v20230910/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_tab7ToutesExclusions1_1_20230910.png"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240318/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_tab7ToutesExclusions1_1_20240119.pdf"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240329/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_tab7ToutesExclusions1_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240405/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_tab7ToutesExclusions1_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240411/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_tab7ToutesExclusions1_1_20240329"
output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240624/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_tab7ToutesExclusions1_1_20240624"
plot_map_variable(tab_ = tab_sum_,
                  varname_ = "SurfaceHydroPropSurfHER2_log",
                  vartitle_ = "Log-ratio\n(sans unité)",
                  breaks_ = round(breaks_SurfaceEntitesHydroPropSurfHER2_log,1),
                  output_name_ = output_name_,
                  title_ = "",
                  nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt",
                  reverseColors_ = F,
                  reverseLegend_ = T,
                  echelleAttenuee_ = F,
                  addValueUnder = -10,
                  HER2_excluesDensity_ = NULL,
                  # subtitle_ = subtitle_,
                  annotation_txt_ = F,
                  percentFormat = F,
                  borderCol = "gray40")


# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/MapVersionExclusions_SurfacesStationsHydro_v20230910/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_tab7ToutesExclusions1_English_1_20230910.png"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240318/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_tab7ToutesExclusions1_English_1_20240119.pdf"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240329/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_tab7ToutesExclusions1_English_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240405/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_tab7ToutesExclusions1_English_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240411/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_tab7ToutesExclusions1_English_1_20240329"
output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240624/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_tab7ToutesExclusions1_English_1_20240624"
plot_map_variable(tab_ = tab_sum_,
                  varname_ = "SurfaceHydroPropSurfHER2_log",
                  vartitle_ = "Log-ratio\n(unitless)",
                  breaks_ = round(breaks_SurfaceEntitesHydroPropSurfHER2_log,1),
                  output_name_ = output_name_,
                  title_ = "",
                  nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt",
                  reverseColors_ = F,
                  reverseLegend_ = T,
                  echelleAttenuee_ = F,
                  addValueUnder = -10,
                  HER2_excluesDensity_ = NULL,
                  # subtitle_ = subtitle_,
                  annotation_txt_ = F,
                  percentFormat = F,
                  borderCol = "gray40")

# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/MapVersionExclusions_SurfacesStationsHydro_v20230910/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_1_20230910.png"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240318/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_1_20240119.pdf"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240329/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240405/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240411/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_1_20240329"
output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240624/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_1_20240624"
plot_map_variable_sansEtiquettes(tab_ = tab_sum_,
                                 varname_ = "SurfaceHydroPropSurfHER2_log",
                                 vartitle_ = "Log-ratio\n(sans unité)",
                                 breaks_ = round(breaks_SurfaceEntitesHydroPropSurfHER2_log,1),
                                 output_name_ = output_name_,
                                 title_ = "",
                                 nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt",
                                 reverseColors_ = F,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = F,
                                 addValueUnder = -10,
                                 HER2_excluesDensity_ = NULL,
                                 # subtitle_ = subtitle_,
                                 annotation_txt_ = F,
                                 percentFormat = F,
                                 sansTexteHer_ = T,
                                 borderCol = "gray40")


# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/MapVersionExclusions_SurfacesStationsHydro_v20230910/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_English_1_20230910.png"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240318/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_English_1_20240119.pdf"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240329/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_English_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240405/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_English_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240411/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_English_1_20240329"
output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240624/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_English_1_20240624"
plot_map_variable_sansEtiquettes(tab_ = tab_sum_,
                                 varname_ = "SurfaceHydroPropSurfHER2_log",
                                 vartitle_ = "Log-ratio\n(unitless)",
                                 breaks_ = round(breaks_SurfaceEntitesHydroPropSurfHER2_log,1),
                                 output_name_ = output_name_,
                                 title_ = "",
                                 nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt",
                                 reverseColors_ = F,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = F,
                                 addValueUnder = -10,
                                 HER2_excluesDensity_ = NULL,
                                 # subtitle_ = subtitle_,
                                 annotation_txt_ = F,
                                 percentFormat = F,
                                 sansTexteHer_ = T,
                                 borderCol = "gray40")

### NOMBRE STATIONS HYDRO / 1000 KM 2 HER2 ###
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/MapVersionExclusions_SurfacesStationsHydro_v20230910/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_tab7ToutesExclusions1_1_20230910.png"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240318/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_tab7ToutesExclusions1_1_20240119.pdf"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240329/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_tab7ToutesExclusions1_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240405/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_tab7ToutesExclusions1_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240411/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_tab7ToutesExclusions1_1_20240329"
output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240624/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_tab7ToutesExclusions1_1_20240624"
plot_map_variable(tab_ = tab_sum_bin_,
                  varname_ = "SurfaceHydroPropSurfHER2_bin",
                  # vartitle_ = bquote(atop("Nombre de stations", "pour 1000" ~km^2 ~ "d'HER2")),
                  vartitle_ = expression("Nombre de stations\npour 1000" ~km^2 ~ "d'HER2"),
                  breaks_ = breaks_NbEntitesHydroProp1000SurfHER2,
                  output_name_ = output_name_,
                  title_ = "",
                  nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt",
                  reverseColors_ = F,
                  reverseLegend_ = T,
                  echelleAttenuee_ = F,
                  addValueUnder = -10,
                  HER2_excluesDensity_ = NULL,
                  # subtitle_ = subtitle_,
                  annotation_txt_ = F,
                  percentFormat = F,
                  borderCol = "gray40",
                  taillePalette = length(breaks_NbEntitesHydroProp1000SurfHER2)+5,
                  retenuPalette = length(breaks_NbEntitesHydroProp1000SurfHER2))

# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/MapVersionExclusions_SurfacesStationsHydro_v20230910/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_tab7ToutesExclusions1_English_1_20230910.png"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240318/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_tab7ToutesExclusions1_English_1_20240119.pdf"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240329/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_tab7ToutesExclusions1_English_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240405/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_tab7ToutesExclusions1_English_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240411/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_tab7ToutesExclusions1_English_1_20240329"
output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240624/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_tab7ToutesExclusions1_English_1_20240624"
plot_map_variable(tab_ = tab_sum_bin_,
                  varname_ = "SurfaceHydroPropSurfHER2_bin",
                  # vartitle_ = bquote(atop("Number of stations"," per 1000" ~km^2 ~ "of HER2")),
                  vartitle_ = expression("Number of stations\nper 1000" ~km^2 ~ "of HER2"),
                  breaks_ = breaks_NbEntitesHydroProp1000SurfHER2,
                  output_name_ = output_name_,
                  title_ = "",
                  nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt",
                  reverseColors_ = F,
                  reverseLegend_ = T,
                  echelleAttenuee_ = F,
                  addValueUnder = -10,
                  HER2_excluesDensity_ = NULL,
                  # subtitle_ = subtitle_,
                  annotation_txt_ = F,
                  percentFormat = F,
                  borderCol = "gray40",
                  taillePalette = length(breaks_NbEntitesHydroProp1000SurfHER2)+5,
                  retenuPalette = length(breaks_NbEntitesHydroProp1000SurfHER2))

# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/MapVersionExclusions_SurfacesStationsHydro_v20230910/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_1_20230910.png"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240318/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_1_20240119.pdf"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240329/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240405/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240411/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_1_20240329"
output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240624/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_1_20240624"
plot_map_variable_sansEtiquettes(tab_ = tab_sum_bin_,
                                 varname_ = "SurfaceHydroPropSurfHER2_bin",
                                 # vartitle_ = bquote(atop("Nombre de stations","pour 1000" ~km^2 ~ "d'HER2")),
                                 vartitle_ = expression("Nombre de stations", "pour 1000" ~km^2 ~ "d'HER2"),
                                 breaks_ = breaks_NbEntitesHydroProp1000SurfHER2,
                                 output_name_ = output_name_,
                                 title_ = "",
                                 nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt",
                                 reverseColors_ = F,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = F,
                                 addValueUnder = -10,
                                 HER2_excluesDensity_ = NULL,
                                 # subtitle_ = subtitle_,
                                 annotation_txt_ = F,
                                 percentFormat = F,
                                 sansTexteHer_ = T,
                                 borderCol = "gray40",
                                 taillePalette = length(breaks_NbEntitesHydroProp1000SurfHER2)+5,
                                 retenuPalette = length(breaks_NbEntitesHydroProp1000SurfHER2))

# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/MapVersionExclusions_SurfacesStationsHydro_v20230910/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_English_1_20230910.png"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240318/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_English_1_20240119.pdf"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240329/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_English_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240405/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_English_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240411/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_English_1_20240329"
output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240624/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_English_1_20240624"
plot_map_variable_sansEtiquettes(tab_ = tab_sum_bin_,
                                 varname_ = "SurfaceHydroPropSurfHER2_bin",
                                 # vartitle_ = bquote(atop("Number of stations","per 1000" ~km^2 ~ "of HER2")),
                                 vartitle_ = expression("Number of stations", "per 1000" ~km^2 ~ "of HER2"),
                                 breaks_ = breaks_NbEntitesHydroProp1000SurfHER2,
                                 output_name_ = output_name_,
                                 title_ = "",
                                 nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt",
                                 reverseColors_ = F,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = F,
                                 addValueUnder = -10,
                                 HER2_excluesDensity_ = NULL,
                                 # subtitle_ = subtitle_,
                                 annotation_txt_ = F,
                                 percentFormat = F,
                                 sansTexteHer_ = T,
                                 borderCol = "gray40",
                                 taillePalette = length(breaks_NbEntitesHydroProp1000SurfHER2)+5,
                                 retenuPalette = length(breaks_NbEntitesHydroProp1000SurfHER2))



### Surface HER2 par station Hydro ###
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/MapVersionExclusions_SurfacesStationsHydro_v20230910/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_tab7ToutesExclusions1_1_20230910.png"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240318/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_tab7ToutesExclusions1_1_20240119.pdf"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240329/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_tab7ToutesExclusions1_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240405/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_tab7ToutesExclusions1_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240411/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_tab7ToutesExclusions1_1_20240329"
output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240624/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_tab7ToutesExclusions1_1_20240624"
plot_map_variable(tab_ = tab_sum_bin_,
                  varname_ = "SurfaceDivNbHydro_bin",
                  # vartitle_ = bquote(atop("Surface moyenne d'HER2 (en" ~km^2 ~ ")", "couverte par une station")),
                  vartitle_ = expression("Surface moyenne d'HER2 (en" ~km^2 ~ ")", "couverte par une station"),
                  breaks_ = round(breaks_SurfHER2ParEntiteHydro_param,1),
                  output_name_ = output_name_,
                  title_ = "",
                  nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt",
                  reverseColors_ = F,
                  reverseLegend_ = T,
                  echelleAttenuee_ = F,
                  addValueUnder = -10,
                  HER2_excluesDensity_ = NULL,
                  # subtitle_ = subtitle_,
                  annotation_txt_ = F,
                  percentFormat = F,
                  borderCol = "gray40")

# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/MapVersionExclusions_SurfacesStationsHydro_v20230910/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_tab7ToutesExclusions1_English_1_20230910.png"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240318/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_tab7ToutesExclusions1_English_1_20240119.pdf"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240329/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_tab7ToutesExclusions1_English_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240405/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_tab7ToutesExclusions1_English_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240411/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_tab7ToutesExclusions1_English_1_20240329"
output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240624/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_tab7ToutesExclusions1_English_1_20240624"
plot_map_variable(tab_ = tab_sum_bin_,
                  varname_ = "SurfaceDivNbHydro_bin",
                  # vartitle_ = bquote(atop("Average HER2 area (in" ~km^2 ~ ")", "covered by a station")),
                  vartitle_ = expression("Average HER2 area (in" ~km^2 ~ ")", "covered by a station"),
                  breaks_ = round(breaks_SurfHER2ParEntiteHydro_param,1),
                  output_name_ = output_name_,
                  title_ = "",
                  nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt",
                  reverseColors_ = F,
                  reverseLegend_ = T,
                  echelleAttenuee_ = F,
                  addValueUnder = -10,
                  HER2_excluesDensity_ = NULL,
                  # subtitle_ = subtitle_,
                  annotation_txt_ = F,
                  percentFormat = F,
                  borderCol = "gray40")

# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/MapVersionExclusions_SurfacesStationsHydro_v20230910/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_1_20230910.png"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240318/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_1_20240119.pdf"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240329/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240405/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240411/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_1_20240329"
output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240624/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_1_20240624"
plot_map_variable_sansEtiquettes(tab_ = tab_sum_bin_,
                                 varname_ = "SurfaceDivNbHydro_bin",
                                 # vartitle_ = bquote(atop("Surface moyenne d'HER2 (en" ~km^2 ~ ")", "couverte par une station")),
                                 vartitle_ = expression("Surface moyenne d'HER2 (en" ~km^2 ~ ")", "couverte par une station"),
                                 # expression(atop(Median~Nitrate-Nitrogen~(NO[3]^{textstyle("-")}-N), "Concentration"~(mg~L^{textstyle("-")})~phantom (1000000)~phantom (1000000)))))
                                 breaks_ = round(breaks_SurfHER2ParEntiteHydro_param,1),
                                 output_name_ = output_name_,
                                 title_ = "",
                                 nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt",
                                 reverseColors_ = F,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = F,
                                 addValueUnder = -10,
                                 HER2_excluesDensity_ = NULL,
                                 # subtitle_ = subtitle_,
                                 annotation_txt_ = F,
                                 percentFormat = F,
                                 sansTexteHer_ = T,
                                 borderCol = "gray40")


# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/MapVersionExclusions_SurfacesStationsHydro_v20230910/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_English_1_20230910.png"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240318/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_English_1_20240119.pdf"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240329/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_English_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240405/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_English_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240411/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_English_1_20240329"
output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240624/Carte_RepartitionStationsHydroHER2hyb_SurfaceHER2ParStations_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_English_1_20240624"
plot_map_variable_sansEtiquettes(tab_ = tab_sum_bin_,
                                 varname_ = "SurfaceDivNbHydro_bin",
                                 # vartitle_ = bquote(atop("Average HER2 area (in" ~km^2 ~ ")", "covered by a station")),
                                 vartitle_ = expression("Average HER2 area (in" ~km^2 ~ ")", "covered by a station"),
                                 breaks_ = round(breaks_SurfHER2ParEntiteHydro_param,1),
                                 output_name_ = output_name_,
                                 title_ = "",
                                 nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt",
                                 reverseColors_ = F,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = F,
                                 addValueUnder = -10,
                                 HER2_excluesDensity_ = NULL,
                                 # subtitle_ = subtitle_,
                                 annotation_txt_ = F,
                                 percentFormat = F,
                                 sansTexteHer_ = T,
                                 borderCol = "gray40")



# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/MapVersionExclusions_SurfacesStationsHydro_v20230910/Carte_PointsStationsHydro_sansEtiq_English_1_20230910.png"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240318/Carte_PointsStationsHydro_sansEtiq_English_1_20240119.png"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240329/Carte_PointsStationsHydro_sansEtiq_English_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240405/Carte_PointsStationsHydro_sansEtiq_English_1_20240329"
# output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240411/Carte_PointsStationsHydro_sansEtiq_English_1_20240329"
output_name_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240624/Carte_PointsStationsHydro_sansEtiq_English_1_20240624"
plot_map_variable_points(tab_ <- tab_graph_,
                         vartitle_ <- paste0("Gauging stations\n(",nrow(tab_graph_),")"),
                         # vartitle_ <- paste0(nrow(tab_graph_)," gauging stations"),
                         output_name_ <- output_name_,
                         title_ <- "",
                         nomX <- "XL93",
                         nomY <- "YL93",
                         color <- color_stationsHydrometriques,
                         annotation_txt_ = F)




tab_sum_$HER2

### Aires HER2 ###
# Avec l'HER2 10
# hist(tab_sum_$SurfaceHER2)
# length(which(tab_sum_$SurfaceHER2<10000))/length(which(!(is.na(tab_sum_$SurfaceHER2)))) # 78.2%
# median(tab_sum_$SurfaceHER2, na.rm = T) # 4587.745
# quantile(tab_sum_$SurfaceHER2, na.rm = T, probs = 0.25) # 2615.296
# quantile(tab_sum_$SurfaceHER2, na.rm = T, probs = 0.75) # 9338.128

tab_sum_ = tab_sum_[which(tab_sum_$HER2 != "10"),]
hist(tab_sum_$SurfaceHER2)
length(which(tab_sum_$SurfaceHER2<10000))/length(which(!(is.na(tab_sum_$SurfaceHER2))))
#75HER2 2024.01.19: 77.3
#77HER2 2023.11: 77.9
median(tab_sum_$SurfaceHER2, na.rm = T)
#75HER2 2024.01.19: 4989.682
#77HER2 2023.11: 4614.968
quantile(tab_sum_$SurfaceHER2, na.rm = T, probs = 0.25)
#75HER2 2024.01.19: 2902.407
#77HER2 2023.11: 2885.09
quantile(tab_sum_$SurfaceHER2, na.rm = T, probs = 0.75)
#75HER2 2024.01.19: 9599.064
#77HER2 2023.11: 9557.127


### Aires stations Hydro par HER2 ###
# Avec l'HER2 10
# hist(tab_sum_$AreaHydro) # 
# median(tab_sum_$AreaHydro, na.rm = T) # 2679
# quantile(tab_sum_$AreaHydro, na.rm = T, probs = 0.25) # 1207
# quantile(tab_sum_$AreaHydro, na.rm = T, probs = 0.75) # 5864

# Sans l'HER2 10
tab_sum_ = tab_sum_[which(tab_sum_$HER2 != "10"),]
hist(tab_sum_$AreaHydro) # 
median(tab_sum_$AreaHydro, na.rm = T) # 2946.5
quantile(tab_sum_$AreaHydro, na.rm = T, probs = 0.25) # 1216.25
quantile(tab_sum_$AreaHydro, na.rm = T, probs = 0.75) # 5872

### Proportion surface Hydro / surface HER2 ###
# hist(tab_sum_$SurfaceHydroPropSurfHER2) # 
# mean(tab_sum_$SurfaceHydroPropSurfHER2, na.rm = T) #0.71
# median(tab_sum_$SurfaceHydroPropSurfHER2, na.rm = T) #0.532
# quantile(tab_sum_$SurfaceHydroPropSurfHER2, na.rm = T, probs = 0.25) #0.309
# quantile(tab_sum_$SurfaceHydroPropSurfHER2, na.rm = T, probs = 0.75) #0.940

tab_sum_ = tab_sum_[which(tab_sum_$HER2 != "10"),]
hist(tab_sum_$SurfaceHydroPropSurfHER2) #
mean(tab_sum_$SurfaceHydroPropSurfHER2, na.rm = T) #0.715
median(tab_sum_$SurfaceHydroPropSurfHER2, na.rm = T)
#75HER2 2024.01.19: 0.535
#77HER2 2023.11: 0.5369079
quantile(tab_sum_$SurfaceHydroPropSurfHER2, na.rm = T, probs = 0.25)
#75HER2 2024.01.19: 
#77HER2 2023.11: 0.323
quantile(tab_sum_$SurfaceHydroPropSurfHER2, na.rm = T, probs = 0.75) #
#75HER2 2024.01.19: 0.937
#77HER2 2023.11: 0.943

### Nombre station Hydro / surface HER2 * 1000 ###
median(tab_sum_bin_$SurfaceHydroPropSurfHER2_bin, na.rm = T)
#75HER2 2024.01.19: 3.60
#77HER2 2023.11: 3.476
quantile(tab_sum_bin_$SurfaceHydroPropSurfHER2_bin, na.rm = T, probs = 0.25)
#75HER2 2024.01.19: 1.89615
#77HER2 2023.11: 1.950
quantile(tab_sum_bin_$SurfaceHydroPropSurfHER2_bin, na.rm = T, probs = 0.75)
#75HER2 2024.01.19: 5.606
#77HER2 2023.11: 5.682

tab_sum_bin_ = tab_sum_bin_[which(tab_sum_bin_$HER2 != "10"),] # Identique car la valeur etait en NA
median(tab_sum_bin_$SurfaceHydroPropSurfHER2_bin, na.rm = T) #3.476
quantile(tab_sum_bin_$SurfaceHydroPropSurfHER2_bin, na.rm = T, probs = 0.25) #1.950
quantile(tab_sum_bin_$SurfaceHydroPropSurfHER2_bin, na.rm = T, probs = 0.75) #5.682



table(tab_sum_$AreaHydro>0,tab_sum_$HER2 != 0) #77/77




