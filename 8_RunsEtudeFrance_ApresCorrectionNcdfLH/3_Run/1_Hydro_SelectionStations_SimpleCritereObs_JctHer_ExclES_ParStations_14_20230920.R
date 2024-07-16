### Libraries ###
library(rgdal)
library(readxl)

### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
#source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/4_RunsEtudeFrance_20230417/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/5_RunsEtudeFrance_ParSiteOnde_20230525/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")

### Study data ###
folder_input_ = folder_input_param_
folder_onde_ = folder_onde_param_
nomSim_ = nomSim_param_

### Disponibilite des Stations par dates ### 
#tab_stations_ = read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsObserves/DisponibiliteDonneesHydroDates/TablesDisponibiliteDonneesHydro/DisponibiliteTemporelle_VersionTJ_20230412/1_DisponibiliteDonneesDates_ToutesStationsHydro/1_DisponibiliteDonneesDates_ToutesStationsHydro_All_1_20230417.csv", sep = ";", dec = ".", quote = "", na.strings = NA, header = T)
#tab_stations_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsObserves/DisponibiliteDonneesHydroDates/TablesDisponibiliteDonneesHydro/DisponibiliteTemporelle_VersionTJ_20230412/3_DisponibiliteDonnees_DatesEtMergeHER2hybrides/HER2_VersionES_2_20230417/3_Merge_DisponibiliteHydro_CorrespondanceHER2hybridesv2_3_20230420.csv", sep = ";", dec = ".", na.strings = NA, header = T)
tab_stations_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsObserves/DisponibiliteDonneesHydroDates/TablesDisponibiliteDonneesHydro/DisponibiliteTemporelle_VersionTJ_20230412/4_DisponibiliteDonnees_ProportionsHER_DatesEtMergeHER2hybrides/HER2_VersionES_2_20230417/4_Merge_DisponibiliteHydro_CorrespondanceHER2hybridesv2_Prop_4_20230427.csv", sep = ";", dec = ".", na.strings = NA, header = T)
dim(tab_stations_) #1250 134

tab_stations_[which(is.na(tab_stations_$SurfaceTopo)),]
# Surfaces non renseignees sur l'hydroportail : "H110200901", "H320000104", "O408101001", "O710060101", "Q110501001"

tab_stations_ = tab_stations_[which(tab_stations_$SurfaceTopo < 2000),]
dim(tab_stations_) #1094

### Impact ###
# table(tab_stations_$Impact_local)
# tab_stations_sansImpFort = tab_stations_[which(tab_stations_$Impact_local != "Influence forte en toute saison" | is.na(tab_stations_$Impact_local)),]
# dim(tab_stations_sansImpFort) #1025
# 
# #write.table(tab_stations_, "/home/tjaouen/Documents/Input/HYDRO/EtudeRMC/StationsSelectionnees/SelectionCsv/SelectionCsv_3_PresentMesures_HERhybrides_TousKGE_2012_2022_20230407/Stations_HYDRO_KGESUp0.00_DispSup-1.csv", sep = ";", dec = ".", row.names = F)
# write.table(tab_stations_sansImpFort, paste0(folder_input_,"/StationsSelectionnees/SelectionCsv/SelectionCsv_",nomSim_,"/Stations_HYDRO_KGESUp0.00_DispSup-1.csv"), sep = ";", dec = ".", row.names = F)
# 
# #tab_stations_[,which(grepl("eco", colnames(tab_stations_)) & !(grepl("Record",colnames(tab_stations_))))] = tab_stations_[,which(grepl("eco", colnames(tab_stations_)) & !(grepl("Record",colnames(tab_stations_))))]/rowSums(tab_stations_[,which(grepl("eco", colnames(tab_stations_)) & !(grepl("Record",colnames(tab_stations_))))])
# #rowSums(tab_stations_[,which(grepl("eco", colnames(tab_stations_)) & !(grepl("Record",colnames(tab_stations_))))])




### Impact ###
# table(tab_stations_$Impact_local)
# tab_stations_sansImpFort = tab_stations_[which(tab_stations_$Impact_local == "Influence nulle ou faible"),]
# dim(tab_stations_sansImpFort) #843

#write.table(tab_stations_, "/home/tjaouen/Documents/Input/HYDRO/EtudeRMC/StationsSelectionnees/SelectionCsv/SelectionCsv_3_PresentMesures_HERhybrides_TousKGE_2012_2022_20230407/Stations_HYDRO_KGESUp0.00_DispSup-1.csv", sep = ";", dec = ".", row.names = F)
#write.table(tab_stations_sansImpFort, paste0(folder_input_,"/StationsSelectionnees/SelectionCsv/SelectionCsv_",nomSim_,"/Stations_HYDRO_KGESUp0.00_DispSup-1.csv"), sep = ";", dec = ".", row.names = F)



######################################################################################################################################################################################################################################################################################

### Regroupement HER2h ###
#31 + 33 + 39
#37 + 54
#69 + 96
tab_stations_$eco31033039 <- tab_stations_$eco031 + tab_stations_$eco033 + tab_stations_$eco039
tab_stations_$eco37054 <- tab_stations_$eco037 + tab_stations_$eco054
tab_stations_$eco69096 <- tab_stations_$eco069 + tab_stations_$eco096
tab_stations_ <- tab_stations_[,which(!(colnames(tab_stations_) %in% c("eco031","eco033","eco039","eco037","eco054","eco069","eco096")))]

#write.table(tab_stations_, "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_10_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_2012_2022_20230512/Stations_HYDRO_KGESUp0.00_DispSup-1.csv", sep = ";", dec = ".", row.names = F)


### Modification fichier ONDE ###
# tab_onde_ = read.csv("/home/tjaouen/Documents/Input/ONDE/Data_Description/CorrespondanceOndeHer/HER2hybrides/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_3_20230331.csv", sep = ",", dec = ".", na.strings = NA, header = T)
# dim(tab_onde_) #3302 22
# 
# tab_onde_$CdHER2[which(tab_onde_$CdHER2 == 31)] = 31033039
# tab_onde_$CdHER2[which(tab_onde_$CdHER2 == 33)] = 31033039
# tab_onde_$CdHER2[which(tab_onde_$CdHER2 == 39)] = 31033039
# tab_onde_$CdHER2[which(tab_onde_$CdHER2 == 37)] = 37054
# tab_onde_$CdHER2[which(tab_onde_$CdHER2 == 54)] = 37054
# tab_onde_$CdHER2[which(tab_onde_$CdHER2 == 69)] = 69096
# tab_onde_$CdHER2[which(tab_onde_$CdHER2 == 96)] = 69096

#~write.table(tab_onde_, "/home/tjaouen/Documents/Input/ONDE/Data_Description/CorrespondanceOndeHer/HER2hybrides_Jonction/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_JonctionHER_4_20230512.csv", sep = ",", dec = ".", row.names = F)

######################################################################################################################################################################################################################################################################################

### Exclusion ES ###

file_exclusions_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsObserves/DisponibiliteDonneesHydroDates/DiagnosticQualiteEtImpactStations/2_SelectionES_BaseSurCalibrageModeles_20230512/ClasseurStationAExclure_TraitementTJ_20230522.xlsx"
tab_exclusions_ <- read_xlsx(file_exclusions_)
dim(tab_exclusions_) # 71

dim(tab_stations_) # 1094
tab_stations_critereES_ <- tab_stations_[which(!(tab_stations_$Code_short %in% tab_exclusions_$Code_short)),]
dim(tab_stations_critereES_) # 1061
table(tab_stations_critereES_$Impact_local, useNA = "always") # 53
tab_stations_critereES_ <- tab_stations_critereES_[which(!(tab_stations_critereES_$Impact_local == "Influence forte en toute saison") | is.na(tab_stations_critereES_$Impact_local)),]
dim(tab_stations_critereES_) #1008

table(tab_stations_critereES_$Impact_local, useNA = "always")

# write.table(tab_stations_critereES_, "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansExclusionsES_2012_2022_20230522/Stations_HYDRO_KGESUp0.00_DispSup-1.csv", sep = ";", dec = ".", row.names = F)
write.table(tab_stations_critereES_, "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidAnSecInterHum_2012_2022_20230919/Stations_HYDRO_KGESUp0.00_DispSup-1.csv", sep = ";", dec = ".", row.names = F)



tab_stations_critereES_bis_ <- tab_stations_critereES_
rownames(tab_stations_critereES_bis_) <- tab_stations_critereES_bis_$Code_short
tab_eco_ <- tab_stations_critereES_bis_[which(tab_stations_critereES_bis_$Impact_local == "Influence forte en toute saison"),grep("eco0|eco1|eco3|eco6",colnames(tab_stations_critereES_bis_))]>0

indices <- which(tab_eco_, arr.ind = TRUE)

associations <- data.frame(
  Ligne = rownames(tab_eco_)[indices[, 1]],
  Colonne = colnames(tab_eco_)[indices[, 2]]
)

# Afficher le résultat
print(associations)

write.table(associations, "/home/tjaouen/Documents/tab_associations.csv", sep = ";", dec = ".", row.names = F)





