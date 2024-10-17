#-------------------------------------------------------------------------------
# Bottet Quentin - Irstea - 12/09/2019 - Version 1
# Script permettant d'extraire le % d'assec, les Frequence au non depassement et frequences au
# non depassement moyen par hydroecoregion de niveau 2 et en fonction du regime hydrologique
# des cours d'eau sur lesquels sont localisees les stations HYDRO et ONDE

# changer "OBS" en "SIM" dans les repertoires et fichiers de sortie pour les valeurs Safran
#print("2023.02.20. Pour le moment, FDC faits a partir des fichiers Simulations disponibles dans le dossier Thirel. Donnees dispos jusqu a 2018.")
#-------------------------------------------------------------------------------


### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")

### Librairies ###
library(doParallel)
library(lubridate)
library(ggplot2)
library(stringr)
library(dplyr)
library(tidyr)
library(ggrepel)

### Functions ###
detect_date_format <- function(date) {
  if (grepl("^\\d{4}-\\d{2}-\\d{2}$", date)) {
    return("ymd")
  } else if (grepl("^\\d{2}-\\d{2}-\\d{4}$", date)) {
    return("dmy")
  } else {
    return(NA)
  }
}

### Study data ###
folder_input_ = folder_input_param_
folder_output_ = folder_output_param_
folder_onde_ = folder_onde_param_
nom_GCM_ = nom_GCM_param_
nom_selectStations_ = nom_selectStations_param_
nom_categorieSimu_ = nom_categorieSimu_param_
HER_ = HER_param_
HER_variable_ = HER_variable_param_
# climatScenarioModeleHydro_ = climatScenarioModeleHydro_param_
climatScenarioModeleHydro_ = nom_GCM_param_

color_stationsHydrometriques = color_stationsHydrometriques_param
color_pointsSimu = color_pointsSimu_param
color_sitesOnde = color_sitesOnde_param

breaks_SurfaceTopo_ = breaks_SurfaceTopo_param
breaks_altitude_ = breaks_altitude_param
breaks_pente_ = breaks_pente_param

obsSim_ = obsSim_param_
nomSim_ = nomSim_param_
annees_learn_ = annees_learnModels_param_

nbJoursIntervalle_ = 10

### Points HYDRO ###
nom_selectStations_ = "SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522"
liste <- list.files(paste0(folder_input_,"StationsSelectionnees/SelectionCsv/",nom_selectStations_),pattern="Stations_HYDRO", full.names = T)
il = liste[1]
output = data.frame()

# hydro = Recoupement Stations HYDRO - HER #
# hydro = read.table(il, sep=";", dec=".", header = T)
hydro = read.table(il, sep=";", dec=".", header = T, quote = "")
if (dim(hydro)[2] == 1){
  hydro = read.table(il, sep=",", dec=".", header = T, quote = "")
}
if (substr(colnames(hydro)[1],1,2) == "X."){
  hydro = read.table(il, sep=";", dec=".", header = T)
  if (dim(hydro)[2] == 1){
    hydro = read.table(il, sep=",", dec=".", header = T)
  }
}

####################################################
### Gestion de la table des points de simulation ###
####################################################
if ("Code10_ChoixDefinitifPointSimu" %in% colnames(hydro)){
  hydro$Code = hydro$Code10_ChoixDefinitifPointSimu
}

print("Taille à verifier : CTRIP=--- \ EROS=--- \ GRSD=--- \ J2000=343 \ MORDORSD=--- \ MORDORTS=--- \ ORCHIDEE=--- \ SIM2=--- \ SMASH=---")
# print("Taille à verifier : CTRIP=535 \ EROS=159 \ GRSD=608 \ J2000=235 \ MORDORSD=610 \ MORDORTS=113 \ ORCHIDEE=557 \ SIM2=848 \ SMASH=603")
dim(hydro)

# hydro$SurfaceTopo_cut <- cut(as.numeric(hydro$SurfaceTopo), breaks = breaks_SurfaceTopo_)
# table(hydro$SurfaceTopo_cut, useNA = "always") #OK
# median(na.omit(hydro$SurfaceTopo)) #173
# quantile(na.omit(hydro$SurfaceTopo), probs = 0.25) #85
# quantile(na.omit(hydro$SurfaceTopo), probs = 0.75) #396
# 
# hydro$altitude_cut <- cut(as.numeric(hydro$Altitude), breaks = breaks_altitude_)
# table(hydro$altitude_cut, useNA = "always")
# median(na.omit(hydro$Altitude)) #170
# quantile(na.omit(hydro$Altitude), probs = 0.25) #65
# quantile(na.omit(hydro$Altitude), probs = 0.75) #305
# 
# length(which(is.na(hydro$Altitude))) #28 NA

# Avec 9 NA d'Altitude
hydro$SurfaceTopo_cut <- cut(as.numeric(hydro$SurfaceTopo), breaks = breaks_SurfaceTopo_)
table(hydro$SurfaceTopo_cut, useNA = "always") #OK
median(na.omit(hydro$SurfaceTopo)) #173
quantile(na.omit(hydro$SurfaceTopo), probs = 0.25) #85
quantile(na.omit(hydro$SurfaceTopo), probs = 0.75) #396

hydro$altitude_cut <- cut(as.numeric(hydro$Altitude), breaks = breaks_altitude_)
table(hydro$altitude_cut, useNA = "always")
median(na.omit(hydro$Altitude)) #165
quantile(na.omit(hydro$Altitude), probs = 0.25) #63.5
quantile(na.omit(hydro$Altitude), probs = 0.75) #300

length(which(is.na(hydro$Altitude))) #9 NA

###################
### Points simu ###
###################

### CTRIP ###
# df_pointsSimu = read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/Stations_HYDRO_AvecCorrespondanceShp_VersionCorresDistanceBruteExp2_8_20230803.csv", sep = ";", dec = ".", header = T)
# df_pointsSimu = read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/Stations_HYDRO_AvecCorrespondanceShp_VersionCorresDistanceBruteExp2_8_20230803.csv", sep = ",", dec = ".", header = T, quote = "")
df_pointsSimu_CTRIP = read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_31_ObservesReanalyseSafran_LienPointsSafranClimat/TablesParModele_20240816/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_CTRIP_30_20240816.csv", sep = ";", dec = ".", header = T)

df_pointsSimu_CTRIP$SurfaceTopo_ChoixDefinitifPointSimu_cut <- cut(as.numeric(df_pointsSimu_CTRIP$SurfaceTopo_ChoixDefinitifPointSimu), breaks = c(0,10,25,50,100,500,1000,8000))
table(df_pointsSimu_CTRIP$SurfaceTopo_ChoixDefinitifPointSimu_cut, useNA = "always")
median(na.omit(df_pointsSimu_CTRIP$SurfaceTopo_ChoixDefinitifPointSimu))
quantile(na.omit(df_pointsSimu_CTRIP$SurfaceTopo_ChoixDefinitifPointSimu), probs = 0.25)
quantile(na.omit(df_pointsSimu_CTRIP$SurfaceTopo_ChoixDefinitifPointSimu), probs = 0.75)

metadonees_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/ListeStations/ListeMetadata/00_sta_metadata_1_20230414_RemoveVirgules.csv", header = T, sep = ";", dec = ".")
# metadonees_ = read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/ListeStations/ListeMetadata/00_sta_metadata_1_20230414.csv", header = T, sep = ";", dec = ".")

df_pointsSimu_CTRIP = merge(df_pointsSimu_CTRIP, metadonees_, by.x = "Code10_ChoixDefinitifPointSimu", by.y = "code", all.x = T)

length(df_pointsSimu_CTRIP$Code10[which(is.na(df_pointsSimu_CTRIP$Altitude))])
df_pointsSimu_CTRIP$Altitude[which(is.na(df_pointsSimu_CTRIP$Altitude))] = round(df_pointsSimu_CTRIP$altitude_staff_gauge[which(is.na(df_pointsSimu_CTRIP$Altitude))]/1000)
df_pointsSimu_CTRIP$Code10[which(is.na(df_pointsSimu_CTRIP$Altitude))]
length(df_pointsSimu_CTRIP$Code10[which(is.na(df_pointsSimu_CTRIP$Altitude))])

df_pointsSimu_CTRIP$Altitude_cut <- cut(as.numeric(df_pointsSimu_CTRIP$Altitude), breaks = breaks_altitude_)
table(df_pointsSimu_CTRIP$Altitude_cut, useNA = "always")
mean(na.omit(df_pointsSimu_CTRIP$Altitude))
median(na.omit(df_pointsSimu_CTRIP$Altitude))
quantile(na.omit(df_pointsSimu_CTRIP$Altitude), probs = 0.25)
quantile(na.omit(df_pointsSimu_CTRIP$Altitude), probs = 0.75)

df_pointsSimu_CTRIP$Code10
metadonees_$code

### GRSD ###
df_pointsSimu_GRSD = read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_31_ObservesReanalyseSafran_LienPointsSafranClimat/TablesParModele_20240816/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_GRSD_30_20240816.csv", sep = ";", dec = ".", header = T)

df_pointsSimu_GRSD$SurfaceTopo_ChoixDefinitifPointSimu_cut <- cut(as.numeric(df_pointsSimu_GRSD$SurfaceTopo_ChoixDefinitifPointSimu), breaks = c(0,10,25,50,100,500,1000,8000))
table(df_pointsSimu_GRSD$SurfaceTopo_ChoixDefinitifPointSimu_cut, useNA = "always")
median(na.omit(df_pointsSimu_GRSD$SurfaceTopo_ChoixDefinitifPointSimu))
quantile(na.omit(df_pointsSimu_GRSD$SurfaceTopo_ChoixDefinitifPointSimu), probs = 0.25)
quantile(na.omit(df_pointsSimu_GRSD$SurfaceTopo_ChoixDefinitifPointSimu), probs = 0.75)

metadonees_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/ListeStations/ListeMetadata/00_sta_metadata_1_20230414_RemoveVirgules.csv", header = T, sep = ";", dec = ".")
# metadonees_ = read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/ListeStations/ListeMetadata/00_sta_metadata_1_20230414.csv", header = T, sep = ";", dec = ".")

df_pointsSimu_GRSD = merge(df_pointsSimu_GRSD, metadonees_, by.x = "Code10_ChoixDefinitifPointSimu", by.y = "code", all.x = T)

length(df_pointsSimu_GRSD$Code10[which(is.na(df_pointsSimu_GRSD$Altitude))])
df_pointsSimu_GRSD$Altitude[which(is.na(df_pointsSimu_GRSD$Altitude))] = round(df_pointsSimu_GRSD$altitude_staff_gauge[which(is.na(df_pointsSimu_GRSD$Altitude))]/1000)
df_pointsSimu_GRSD$Code10[which(is.na(df_pointsSimu_GRSD$Altitude))]
length(df_pointsSimu_GRSD$Code10[which(is.na(df_pointsSimu_GRSD$Altitude))])

df_pointsSimu_GRSD$Altitude_cut <- cut(as.numeric(df_pointsSimu_GRSD$Altitude), breaks = breaks_altitude_)
table(df_pointsSimu_GRSD$Altitude_cut, useNA = "always")
mean(na.omit(df_pointsSimu_GRSD$Altitude))
median(na.omit(df_pointsSimu_GRSD$Altitude))
quantile(na.omit(df_pointsSimu_GRSD$Altitude), probs = 0.25)
quantile(na.omit(df_pointsSimu_GRSD$Altitude), probs = 0.75)

df_pointsSimu_GRSD$Code10
metadonees_$code

### J2000 ###
df_pointsSimu_J2000 = read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_31_ObservesReanalyseSafran_LienPointsSafranClimat/TablesParModele_20240816/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_J2000_30_20240816.csv", sep = ";", dec = ".", header = T)

df_pointsSimu_J2000$SurfaceTopo_ChoixDefinitifPointSimu_cut <- cut(as.numeric(df_pointsSimu_J2000$SurfaceTopo_ChoixDefinitifPointSimu), breaks = c(0,10,25,50,100,500,1000,8000))
table(df_pointsSimu_J2000$SurfaceTopo_ChoixDefinitifPointSimu_cut, useNA = "always")
median(na.omit(df_pointsSimu_J2000$SurfaceTopo_ChoixDefinitifPointSimu))
quantile(na.omit(df_pointsSimu_J2000$SurfaceTopo_ChoixDefinitifPointSimu), probs = 0.25)
quantile(na.omit(df_pointsSimu_J2000$SurfaceTopo_ChoixDefinitifPointSimu), probs = 0.75)

metadonees_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/ListeStations/ListeMetadata/00_sta_metadata_1_20230414_RemoveVirgules.csv", header = T, sep = ";", dec = ".")
# metadonees_ = read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/ListeStations/ListeMetadata/00_sta_metadata_1_20230414.csv", header = T, sep = ";", dec = ".")

df_pointsSimu_J2000 = merge(df_pointsSimu_J2000, metadonees_, by.x = "Code10_ChoixDefinitifPointSimu", by.y = "code", all.x = T)

length(df_pointsSimu_J2000$Code10[which(is.na(df_pointsSimu_J2000$Altitude))])
df_pointsSimu_J2000$Altitude[which(is.na(df_pointsSimu_J2000$Altitude))] = round(df_pointsSimu_J2000$altitude_staff_gauge[which(is.na(df_pointsSimu_J2000$Altitude))]/1000)
df_pointsSimu_J2000$Code10[which(is.na(df_pointsSimu_J2000$Altitude))]
length(df_pointsSimu_J2000$Code10[which(is.na(df_pointsSimu_J2000$Altitude))])

df_pointsSimu_J2000$Altitude_cut <- cut(as.numeric(df_pointsSimu_J2000$Altitude), breaks = breaks_altitude_)
table(df_pointsSimu_J2000$Altitude_cut, useNA = "always")
mean(na.omit(df_pointsSimu_J2000$Altitude))
median(na.omit(df_pointsSimu_J2000$Altitude))
quantile(na.omit(df_pointsSimu_J2000$Altitude), probs = 0.25)
quantile(na.omit(df_pointsSimu_J2000$Altitude), probs = 0.75)

df_pointsSimu_J2000$Code10
metadonees_$code

### ORCHIDEE ###
df_pointsSimu_ORCHIDEE = read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_31_ObservesReanalyseSafran_LienPointsSafranClimat/TablesParModele_20240816/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_ORCHIDEE_30_20240816.csv", sep = ";", dec = ".", header = T)

df_pointsSimu_ORCHIDEE$SurfaceTopo_ChoixDefinitifPointSimu_cut <- cut(as.numeric(df_pointsSimu_ORCHIDEE$SurfaceTopo_ChoixDefinitifPointSimu), breaks = c(0,10,25,50,100,500,1000,8000))
table(df_pointsSimu_ORCHIDEE$SurfaceTopo_ChoixDefinitifPointSimu_cut, useNA = "always") #OK
median(na.omit(df_pointsSimu_ORCHIDEE$SurfaceTopo_ChoixDefinitifPointSimu)) #191.5
quantile(na.omit(df_pointsSimu_ORCHIDEE$SurfaceTopo_ChoixDefinitifPointSimu), probs = 0.25) #109.6
quantile(na.omit(df_pointsSimu_ORCHIDEE$SurfaceTopo_ChoixDefinitifPointSimu), probs = 0.75) #417

metadonees_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/ListeStations/ListeMetadata/00_sta_metadata_1_20230414_RemoveVirgules.csv", header = T, sep = ";", dec = ".")
# metadonees_ = read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/ListeStations/ListeMetadata/00_sta_metadata_1_20230414.csv", header = T, sep = ";", dec = ".")

df_pointsSimu_ORCHIDEE = merge(df_pointsSimu_ORCHIDEE, metadonees_, by.x = "Code10_ChoixDefinitifPointSimu", by.y = "code", all.x = T)

length(df_pointsSimu_ORCHIDEE$Code10[which(is.na(df_pointsSimu_ORCHIDEE$Altitude))]) #24 NA
df_pointsSimu_ORCHIDEE$Altitude[which(is.na(df_pointsSimu_ORCHIDEE$Altitude))] = round(df_pointsSimu_ORCHIDEE$altitude_staff_gauge[which(is.na(df_pointsSimu_ORCHIDEE$Altitude))]/1000)
df_pointsSimu_ORCHIDEE$Code10[which(is.na(df_pointsSimu_ORCHIDEE$Altitude))]
length(df_pointsSimu_ORCHIDEE$Code10[which(is.na(df_pointsSimu_ORCHIDEE$Altitude))]) #8 NA

df_pointsSimu_ORCHIDEE$Altitude_cut <- cut(as.numeric(df_pointsSimu_ORCHIDEE$Altitude), breaks = breaks_altitude_)
table(df_pointsSimu_ORCHIDEE$Altitude_cut, useNA = "always")
mean(na.omit(df_pointsSimu_ORCHIDEE$Altitude)) #223.9735
median(na.omit(df_pointsSimu_ORCHIDEE$Altitude)) #165
quantile(na.omit(df_pointsSimu_ORCHIDEE$Altitude), probs = 0.25) #63.5
quantile(na.omit(df_pointsSimu_ORCHIDEE$Altitude), probs = 0.75) #297

df_pointsSimu_ORCHIDEE$Code10
metadonees_$code

### SMASH ###
df_pointsSimu_SMASH = read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_31_ObservesReanalyseSafran_LienPointsSafranClimat/TablesParModele_20240816/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_SMASH_30_20240816.csv", sep = ";", dec = ".", header = T)

df_pointsSimu_SMASH$SurfaceTopo_ChoixDefinitifPointSimu_cut <- cut(as.numeric(df_pointsSimu_SMASH$SurfaceTopo_ChoixDefinitifPointSimu), breaks = c(0,10,25,50,100,500,1000,8000))
table(df_pointsSimu_SMASH$SurfaceTopo_ChoixDefinitifPointSimu_cut, useNA = "always") #OK
median(na.omit(df_pointsSimu_SMASH$SurfaceTopo_ChoixDefinitifPointSimu)) #191.5
quantile(na.omit(df_pointsSimu_SMASH$SurfaceTopo_ChoixDefinitifPointSimu), probs = 0.25) #109.6
quantile(na.omit(df_pointsSimu_SMASH$SurfaceTopo_ChoixDefinitifPointSimu), probs = 0.75) #417

metadonees_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/ListeStations/ListeMetadata/00_sta_metadata_1_20230414_RemoveVirgules.csv", header = T, sep = ";", dec = ".")
# metadonees_ = read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/ListeStations/ListeMetadata/00_sta_metadata_1_20230414.csv", header = T, sep = ";", dec = ".")

df_pointsSimu_SMASH = merge(df_pointsSimu_SMASH, metadonees_, by.x = "Code10_ChoixDefinitifPointSimu", by.y = "code", all.x = T)

length(df_pointsSimu_SMASH$Code10[which(is.na(df_pointsSimu_SMASH$Altitude))]) #24 NA
df_pointsSimu_SMASH$Altitude[which(is.na(df_pointsSimu_SMASH$Altitude))] = round(df_pointsSimu_SMASH$altitude_staff_gauge[which(is.na(df_pointsSimu_SMASH$Altitude))]/1000)
df_pointsSimu_SMASH$Code10[which(is.na(df_pointsSimu_SMASH$Altitude))]
length(df_pointsSimu_SMASH$Code10[which(is.na(df_pointsSimu_SMASH$Altitude))]) #8 NA

df_pointsSimu_SMASH$Altitude_cut <- cut(as.numeric(df_pointsSimu_SMASH$Altitude), breaks = breaks_altitude_)
table(df_pointsSimu_SMASH$Altitude_cut, useNA = "always")
mean(na.omit(df_pointsSimu_SMASH$Altitude)) #223.9735
median(na.omit(df_pointsSimu_SMASH$Altitude)) #165
quantile(na.omit(df_pointsSimu_SMASH$Altitude), probs = 0.25) #63.5
quantile(na.omit(df_pointsSimu_SMASH$Altitude), probs = 0.75) #297

df_pointsSimu_SMASH$Code10
metadonees_$code


############
### Onde ###
############
#data.frame(table(df_descriptionStations_2012_2017_$Surf_BV_cut, useNA = "always")))
df_ancien <- read.table("/home/tjaouen/Documents/Input/ONDE/Data_Description/DescriptionSites/Surf_ONDE_2_20230525.csv", header = T, sep = ",", row.names = NULL, quote="")
df_new <- read.table("/home/tjaouen/Documents/Input/ONDE/Data_Description/DescriptionSites/Attributs_RHT_pour_stations_hors_liste_LV_20231004.txt", header = T, sep = ";", dec = ",", row.names = NULL, quote="")
annees_ = c(2012:2017)

dim(df_new) # 44 stations
df_ancien[which(df_ancien$F_CdSiteHy %in% df_new$cd_site_hy),c("F_CdSiteHy","sfbvu")] # 6 stations dans les 3302
df_new[which(df_new$cd_site_hy %in% df_ancien$F_CdSiteHy),c("cd_site_hy","sfbvu","surf_bv","altitude","STRAHLER","strahler_1","pente")]
df_new[,c("cd_site_hy","sfbvu")]
df_ancien$F_CdSiteHy[which(is.na(df_ancien$sfbvu))]
df_new$cd_site_hy

# df_ancien[which(df_ancien$F_CdSiteHy %in% df_new$cd_site_hy),] # 6 stations

# Table de tous les enregistrements ONDE #
folder_onde_ = folder_onde_param_
ONDE <- read.table(folder_onde_, sep = ";", dec = ".", header = T)
if (dim(ONDE)[2] == 1){
  ONDE = read.table(folder_onde_, sep = ",", dec = ".", header = T, quote = "")
}
print("Taille à verifier apres correction ONDE 2023.06.07 : 175 972")
dim(ONDE)
length(unique(ONDE$CdSiteHydro)) #3409

for (d in 1:nrow(df_new)){
  if (length(which(df_ancien$F_CdSiteHy %in% df_new$cd_site_hy[d])) > 0){
    df_ancien$altitude[which(df_ancien$F_CdSiteHy %in% df_new$cd_site_hy[d])] = df_new$altitude[d]
    df_ancien$Surf_BV[which(df_ancien$F_CdSiteHy %in% df_new$cd_site_hy[d])] = df_new$surf_bv[d]
    df_ancien$Pente[which(df_ancien$F_CdSiteHy %in% df_new$cd_site_hy[d])] = df_new$pente[d]
    df_ancien$Strahler[which(df_ancien$F_CdSiteHy %in% df_new$cd_site_hy[d])] = df_new$STRAHLER[d]
  }
}
df_ = df_ancien

### Import ONDE data ###
#Avant recoupement Aurelien Beaufort : 3417 2012-2023 / 3332 2012-2017
#Apres recoupement Aurelien Beaufort : 3302 2012-2023 / 3302 2012-2017

df_descriptionStations_2012_2017_ = df_[!duplicated(df_[,"F_CdSiteHy"]),]
dim(df_descriptionStations_2012_2017_) #3302
# table(df_descriptionStations_2012_2017_$Strahler, useNA = "always")

df_descriptionStations_2012_2017_$Surf_BV_cut <- cut(as.numeric(df_descriptionStations_2012_2017_$Surf_BV), breaks = breaks_SurfaceTopo_)
table(df_descriptionStations_2012_2017_$Surf_BV_cut, useNA = "always") #OK
median(na.omit(df_descriptionStations_2012_2017_$Surf_BV)) #24
quantile(na.omit(df_descriptionStations_2012_2017_$Surf_BV), probs = 0.25) #12
quantile(na.omit(df_descriptionStations_2012_2017_$Surf_BV), probs = 0.75) #50

df_descriptionStations_2012_2017_$altitude_cut <- cut(as.numeric(df_descriptionStations_2012_2017_$altitude), breaks = breaks_altitude_)
table(df_descriptionStations_2012_2017_$altitude_cut, useNA = "always") #OK
median(na.omit(df_descriptionStations_2012_2017_$altitude)) #158.4
quantile(na.omit(df_descriptionStations_2012_2017_$altitude), probs = 0.25) #81.15
quantile(na.omit(df_descriptionStations_2012_2017_$altitude), probs = 0.75) #302.75



df_descriptionStations_2012_2017_[which(is.na(df_descriptionStations_2012_2017_$altitude)),]
length(which(is.na(df_descriptionStations_2012_2017_$altitude))) # 101

dim(df_pointsSimu_CTRIP)
length(which(is.na(df_pointsSimu_CTRIP$Altitude)))
dim(df_pointsSimu_GRSD)
length(which(is.na(df_pointsSimu_GRSD$Altitude)))
dim(df_pointsSimu_J2000)
length(which(is.na(df_pointsSimu_J2000$Altitude)))
dim(df_pointsSimu_ORCHIDEE)
length(which(is.na(df_pointsSimu_ORCHIDEE$Altitude)))
dim(df_pointsSimu_SMASH)
length(which(is.na(df_pointsSimu_SMASH$Altitude)))

hydro$Valeur <- "Gauging stations"
df_descriptionStations_2012_2017_$Valeur <- "ONDE sites"
df_pointsSimu_CTRIP$Valeur <- "Simulation points CTRIP"
df_pointsSimu_GRSD$Valeur <- "Simulation points GRSD"
df_pointsSimu_J2000$Valeur <- "Simulation points J2000"
df_pointsSimu_ORCHIDEE$Valeur <- "Simulation points ORCHIDEE"
df_pointsSimu_SMASH$Valeur <- "Simulation points SMASH"

hydro_3col_ <- hydro[,c("Code","SurfaceTopo_cut","altitude_cut","Valeur")]
colnames(hydro_3col_) <- c("Code","Surface_cut","Altitude_cut","Valeur")
df_descriptionStations_2012_2017_3col_ <- df_descriptionStations_2012_2017_[,c("F_CdSiteHy","Surf_BV_cut","altitude_cut","Valeur")]
colnames(df_descriptionStations_2012_2017_3col_) <- c("Code","Surface_cut","Altitude_cut","Valeur")
df_pointsSimu_CTRIP_3col_ <- df_pointsSimu_CTRIP[,c("Code10_ChoixDefinitifPointSimu","SurfaceTopo_ChoixDefinitifPointSimu_cut","Altitude_cut","Valeur")]
colnames(df_pointsSimu_CTRIP_3col_) <- c("Code","Surface_cut","Altitude_cut","Valeur")
df_pointsSimu_GRSD_3col_ <- df_pointsSimu_GRSD[,c("Code10_ChoixDefinitifPointSimu","SurfaceTopo_ChoixDefinitifPointSimu_cut","Altitude_cut","Valeur")]
colnames(df_pointsSimu_GRSD_3col_) <- c("Code","Surface_cut","Altitude_cut","Valeur")
df_pointsSimu_J2000_3col_ <- df_pointsSimu_J2000[,c("Code10_ChoixDefinitifPointSimu","SurfaceTopo_ChoixDefinitifPointSimu_cut","Altitude_cut","Valeur")]
colnames(df_pointsSimu_J2000_3col_) <- c("Code","Surface_cut","Altitude_cut","Valeur")
df_pointsSimu_ORCHIDEE_3col_ <- df_pointsSimu_ORCHIDEE[,c("Code10_ChoixDefinitifPointSimu","SurfaceTopo_ChoixDefinitifPointSimu_cut","Altitude_cut","Valeur")]
colnames(df_pointsSimu_ORCHIDEE_3col_) <- c("Code","Surface_cut","Altitude_cut","Valeur")
df_pointsSimu_SMASH_3col_ <- df_pointsSimu_SMASH[,c("Code10_ChoixDefinitifPointSimu","SurfaceTopo_ChoixDefinitifPointSimu_cut","Altitude_cut","Valeur")]
colnames(df_pointsSimu_SMASH_3col_) <- c("Code","Surface_cut","Altitude_cut","Valeur")

mg_surface_long <- rbind(df_descriptionStations_2012_2017_3col_,
                         hydro_3col_,
                         df_pointsSimu_CTRIP_3col_,
                         df_pointsSimu_GRSD_3col_,
                         df_pointsSimu_J2000_3col_,
                         df_pointsSimu_ORCHIDEE_3col_,
                         df_pointsSimu_SMASH_3col_)


color_ptsSimu_CTRIP = "#d0d1e6"
color_ptsSimu_GRSD = "#a6bddb"
color_ptsSimu_J2000 = "#74a9cf"
color_ptsSimu_ORCHIDEE = "#3690c0"
color_ptsSimu_SMASH = "#0570b0"
color_stationsHydrometriques <- "#034e7b"
color_ONDE <- "#fe9929"

mg_surface_long$Color <- NA
mg_surface_long$Color[which(mg_surface_long$Valeur == "ONDE sites")] = color_ONDE
mg_surface_long$Color[which(mg_surface_long$Valeur == "Gauging stations")] = color_stationsHydrometriques
mg_surface_long$Color[which(mg_surface_long$Valeur == "Simulation points CTRIP")] = color_ptsSimu_CTRIP
mg_surface_long$Color[which(mg_surface_long$Valeur == "Simulation points GRSD")] = color_ptsSimu_GRSD
mg_surface_long$Color[which(mg_surface_long$Valeur == "Simulation points J2000")] = color_ptsSimu_J2000
mg_surface_long$Color[which(mg_surface_long$Valeur == "Simulation points ORCHIDEE")] = color_ptsSimu_ORCHIDEE
mg_surface_long$Color[which(mg_surface_long$Valeur == "Simulation points SMASH")] = color_ptsSimu_SMASH
mg_surface_long$Color <- factor(mg_surface_long$Color, levels = c(color_ONDE,
                                                                  color_stationsHydrometriques,
                                                                  color_ptsSimu_CTRIP,
                                                                  color_ptsSimu_GRSD,
                                                                  color_ptsSimu_J2000,
                                                                  color_ptsSimu_ORCHIDEE,
                                                                  color_ptsSimu_SMASH))

mg_surface_long$Valeur <- factor(mg_surface_long$Valeur, levels = c("ONDE sites",
                                                                    "Gauging stations",
                                                                    "Simulation points CTRIP",
                                                                    "Simulation points GRSD",
                                                                    "Simulation points J2000",
                                                                    "Simulation points ORCHIDEE",
                                                                    "Simulation points SMASH"))

mg_surface_long

data_summary <- mg_surface_long %>%
  group_by(Surface_cut, Color) %>%
  summarise(n_sites = n()) %>%
  ungroup()

data_summary <- mg_surface_long %>%
  group_by(Surface_cut, Color) %>%
  summarise(n_sites = n()) %>%
  ungroup() %>%
  complete(Surface_cut, Color, fill = list(n_sites = 0))  # Remplir les valeurs manquantes avec 0

# Créer le barplot avec ggplot
png("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_31_ObservesReanalyseSafran_LienPointsSafranClimat/Barplots_20240829/Surface_English_1_20240829.png",
    width = 1200, height = 750,
    units = "px", pointsize = 12)
p <- ggplot(data_summary, aes(x = Surface_cut, y = n_sites, fill = Color)) +
  # geom_bar(stat = "identity", position = "dodge", width = 0.7) +
  # geom_text(aes(label = n_sites), position = position_dodge(width = 1), size = 4, angle = 90, hjust = -0.4) +
  geom_bar(stat = "identity", position = position_dodge2(preserve = "single", width = 0.7), width = 0.7) +
  geom_text(aes(label = n_sites), position = position_dodge2(width = 0.7, preserve = "single"), size = 4, angle = 90, hjust = -0.4, color = "gray38") +  # geom_text(aes(label = n_sites), position = position_dodge(width = 0.7), vjust = -0.5, size = 4, hjust = 0.5, angle = 90) +
  scale_x_discrete(labels = c(expression(""<=10), "]10;25]", "]25;50]", "]50;100]","]100;500]","]500;1000]",">1000","NA")) +
  scale_fill_identity(
    name = "",  # Titre de la légende
    labels = c("ONDE sites",
               "Gauging stations",
               "CTRIP simulation points",
               "GRSD simulation points",
               "J2000 simulation points",
               "ORCHIDEE simulation points",
               "SMASH simulation points"),
    guide = "legend"  # Ajouter la légende
  ) +  # Utiliser les couleurs définies dans la colonne 'Color'
  labs(title = bquote(''),
       x = bquote('Catchment area ('~km^2~')'),
       y = "Number") +
  theme(text = element_text(size = 20),
        axis.line.x = element_line(color = "gray38", size = 1),
        axis.line.y = element_line(color = "gray38", size = 1),
        axis.text.x = element_text(angle = 35, hjust = 1, vjust = 1,colour = "gray38"),
        panel.background = element_blank(),
        panel.border = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank(),
        legend.text = element_text(colour = "gray38"),
        axis.title = element_text(colour = "gray38"),
        legend.spacing.y = unit(0.5, "cm"),  # Ajustez ces valeurs selon vos besoins
        legend.key.size = unit(1, "cm")) +  # Ajustez cette valeur selon vos besoins
  labs(fill = "Entités hydrologiques") + # Changer le titre de la légende
  guides(fill = guide_legend(byrow = TRUE))
print(p)
dev.off()




data_summary <- mg_surface_long %>%
  group_by(Altitude_cut, Color) %>%
  summarise(n_sites = n()) %>%
  ungroup() %>%
  complete(Altitude_cut, Color, fill = list(n_sites = 0))  # Remplir les valeurs manquantes avec 0

# Créer le barplot avec ggplot
png("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_31_ObservesReanalyseSafran_LienPointsSafranClimat/Barplots_20240829/Altitude_English_1_20240829.png",
    width = 1200, height = 750,
    units = "px", pointsize = 12)
p <- ggplot(data_summary, aes(x = Altitude_cut, y = n_sites, fill = Color)) +
  geom_bar(stat = "identity", position = position_dodge2(preserve = "single", width = 0.7), width = 0.7) +
  geom_text(aes(label = n_sites), position = position_dodge2(width = 0.7, preserve = "single"), size = 4, angle = 90, hjust = -0.4, color = "gray38") +  # geom_text(aes(label = n_sites), position = position_dodge(width = 0.7), vjust = -0.5, size = 4, hjust = 0.5, angle = 90) +
  scale_x_discrete(labels = c("[0;25]", "]25;50]", "]50;100]","]100;200]","]200;300]","]300;500]","]500;1000]",">1000","NA")) +
  scale_fill_identity(
    name = "",  # Titre de la légende
    labels = c("ONDE sites",
               "Gauging stations",
               "CTRIP simulation points",
               "GRSD simulation points",
               "J2000 simulation points",
               "ORCHIDEE simulation points",
               "SMASH simulation points"),
    guide = "legend"  # Ajouter la légende
  ) +  # Utiliser les couleurs définies dans la colonne 'Color'
  labs(title = bquote(''),
       x = bquote('Elevation ('~m~')'),
       y = "Number") +
  theme(text = element_text(size = 20),
        axis.line.x = element_line(color = "gray38", size = 1),
        axis.line.y = element_line(color = "gray38", size = 1),
        axis.text.x = element_text(angle = 35, hjust = 1, vjust = 1,colour = "gray38"),
        panel.background = element_blank(),
        panel.border = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank(),
        legend.text = element_text(colour = "gray38"),
        axis.title = element_text(colour = "gray38"),
        legend.spacing.y = unit(0.5, "cm"),  # Ajustez ces valeurs selon vos besoins
        legend.key.size = unit(1, "cm")) +  # Ajustez cette valeur selon vos besoins
  labs(fill = "Entités hydrologiques") + # Changer le titre de la légende
  guides(fill = guide_legend(byrow = TRUE))
print(p)
dev.off()
