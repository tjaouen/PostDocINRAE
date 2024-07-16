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
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")

# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Option0SafranCompletSeul.R")

### Librairies ###
library(doParallel)
library(lubridate)
library(stringr)
library(dplyr)
library(strex)

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
folder_input_PC_ = folder_input_PC_param_
folder_output_ = folder_output_param_
folder_onde_ = folder_onde_param_
nom_GCM_ = nom_GCM_param_
nom_selectStations_ = nom_selectStations_param_
nom_categorieSimu_ = nom_categorieSimu_param_
HER_ = HER_param_
HER_variable_ = HER_variable_param_
# climatScenarioModeleHydro_ = climatScenarioModeleHydro_param_

obsSim_ = obsSim_param_
nomSim_ = nomSim_param_
# annees_learn_ = annees_learnModels_param_
annees_inputMatrice_ = annees_inputMatrice_param_

nbJoursIntervalle_ = 10

### Run ###
# onde = Recoupement Stations ONDE - HER #
# onde = read.table(paste0(folder_ONDE_CorrespondanceHER_,"HER2hybrides_Jonction/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_JonctionHER_5_20230920.csv"), header = T, sep = ";", row.names = NULL, quote="")
onde = read.table(paste0(folder_ONDE_CorrespondanceHER_,"HER2hybrides_Jonction/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_JonctionHER_6_20231221.csv"), header = T, sep = ";", row.names = NULL)
if (dim(onde)[2] == 1){
  # onde = read.table(paste0(folder_ONDE_CorrespondanceHER_,"HER2hybrides_Jonction/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_JonctionHER_5_20230920.csv"), sep=",", dec=".", header = T)
  onde = read.table(paste0(folder_ONDE_CorrespondanceHER_,"HER2hybrides_Jonction/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_JonctionHER_6_20231221.csv"), sep=",", dec=".", header = T)
}
onde = onde[,c("Code","X_Lambert93","Y_Lambert93",paste0("Cd",HER_variable_))]
colnames(onde) = c("Code","X_Lambert93","Y_Lambert93",paste0("Cd",HER_variable_))
print("Taille à verifier : 3302")
dim(onde)
  
# Observations ONDE #
ONDE <- read.table(folder_onde_, sep = ";", dec = ".", header = T)
if (dim(ONDE)[2] == 1){
  ONDE = read.table(folder_onde_, sep = ",", dec = ".", header = T, quote = "")
}
print("Taille à verifier apres correction ONDE 2023.06.07 : 175 972")
dim(ONDE)

# ONDE_us <- ONDE[which(ONDE$TypeCampObservations == "usuelle" & ONDE$Annee == annee),c("CdSiteHydro","Annee","TypeCampObservations","DtRealObservation","LbRsObservationDpt")]
ONDE_us <- ONDE[which(ONDE$TypeCampObservations == "usuelle"),c("CdSiteHydro","Annee","TypeCampObservations","DtRealObservation","LbRsObservationDpt")]
colnames(ONDE_us) = c("Code","Annee","Type","Date","Observation")
          
# Selection des stations ONDE (possible en 1 seul temps)
# Select_onde = onde$Code[which(onde[[paste0("Cd",HER_variable_)]] == i)]
# Obs_onde = ONDE_us[which(ONDE_us$Code %in% Select_onde),]
  
# if(nrow(Obs_onde) > 0){
Obs_onde <- ONDE_us
liste_mois <- sort(unique(format(as.Date(Obs_onde$Date),"%m")))

Obs_onde <- Obs_onde[order(Obs_onde$Code,Obs_onde$Date),]
Obs_onde$MoisAnnee <- paste0(year(Obs_onde$Date),"-",format(as.Date(Obs_onde$Date),"%m"))
Obs_onde$ObservationBinaire <- ifelse(Obs_onde$Observation %in% c("Assec","Ecoulement non visible"),1,0)

Obs_onde <- merge(Obs_onde, onde, by.x = "Code", by.y = "Code")
Obs_onde <- Obs_onde[order(Obs_onde$CdHER2,Obs_onde$Code,Obs_onde$Date),]

Obs_onde <- Obs_onde[,c("Code","X_Lambert93","Y_Lambert93","CdHER2",
                        "Annee","Date","MoisAnnee","ObservationBinaire","Observation","Type")]

table(Obs_onde$MoisAnnee)
Obs_onde[which(month(Obs_onde$Date) == 10),]
dim(Obs_onde) #174100
Obs_onde <- Obs_onde[which(month(Obs_onde$Date) != 10),]
dim(Obs_onde) #174099

write.table(Obs_onde, "/home/tjaouen/Documents/Input/ONDE/Data_Versions/Data_VersionParSites/DonneesOnde_VersionParSites_TJ01_20240617.csv",
            sep = ";", dec = ".", row.names = F)
