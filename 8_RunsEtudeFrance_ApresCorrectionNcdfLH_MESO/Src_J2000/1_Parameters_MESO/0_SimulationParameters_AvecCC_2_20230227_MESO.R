### Libraries ###
# library(rgdal)

################################################################################
################################# FRANCE 2023 ##################################
################################################################################



### Folders ###
# folder_input_param_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/"
# folder_input_param_ = "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/"
folder_input_param_ = "~/scratch/Input/HYDRO/EtudeFrance/"
folder_output_param_ = "~/scratch/Output/ChangementClimatique2019/EtudeFrance/"
folder_input_DD_param_ = "~/scratch/Input/HYDRO/EtudeFrance/"
folder_input_PC_param_ = "~/scratch/Input/HYDRO/EtudeFrance/"


### ONDE ###
# folder_onde_param_ = paste0(folder_ONDE_DataDatesAjustees_,"ONDE_RMC_cmpUsuelles_2012_2022_20230316.csv")
folder_onde_param_ = paste0(folder_ONDE_DataDatesAjustees_,"ONDE_cmpUsuelles_2012_2022_20230607.csv")


### Nom simulation ###
#nomSim_param_ = "1_PresentMesures_HERh_TsKGE_TtesStat_2012_2022_20230417"
#nomSim_param_ = "2_PresentMesures_HERh_TsKGE_SansImpactFort_2012_2022_20230426"
#nomSim_param_ = "3_PresentMesures_HERh_TsKGE_AvecIF_TestDates_2012_2019_20230426"
#nomSim_param_ = "4_PresentMesures_HERh_TsKGE_ImpactNulFaible_2012_2022_20230427"
#nomSim_param_ = "5_PresentMesures_HERh_TsKGE_TtesStat_SensibiliteIntervalleJours_2012_2022_20230428"
#nomSim_param_ = "6_PresentMesures_HERh_TsKGE_TtesStat_TestPoisson_2012_2022_20230503"
#nomSim_param_ = "7_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_2012_2022_20230505"
#nomSim_param_ = "8_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantesSansImpactFort_2012_2022_20230505"
#nomSim_param_ = "9_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantesSansImpactFortEtCritereES_2012_2022_20230509"
#nomSim_param_ = "10_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_2012_2022_20230512"
#nomSim_param_ = "11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522"
#nomSim_param_ = "12_PresentMesures_HERh_TsKGE_TtesStat_SensiIntJoursV2_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230523"
#nomSim_param_ = "13_PresentMesures_HERh_TsKGE_TtesStat_FltOnde_JctHER_SansIFetExES_ValidParAnnees_2012_2022_20230524"
# nomSim_param_ = "15_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrImportOnde_2012_2022_20230607"
# nomSim_param_ = "15_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrImportOnde_ValidParAnnees_2012_2022_20230607"
# nomSim_param_ = "15_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrImportOnde_ValidParAnneesSecIntHum_2012_2022_20230612"
# nomSim_param_= "16_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_ValidParAnnees_SensiIntervJours_2012_2022_20230613"
# nomSim_param_ = "17_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrOubliHerJointes20212022etFonctionSeuilOnde_ModelesBruts_2012_2022_20230614"
# nomSim_param_ = "17_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrOubliHerJointes20212022etFonctionSeuilOnde_SensiIntervJours_2012_2022_20230614" #Etude de sensibilite de l'intervalle de temps a considerer pour calculer la FDC moyenne, test sur l'intervalle [J-10:J]
# nomSim_param_ = "17_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrOubliHerJointes20212022etFonctionSeuilOnde_ValidParAnnees_2012_2022_20230614" #Apprentissage sur toutes les annees sauf 1, validation sur cette annee. Moyenne des performances
# nomSim_param_ = "17_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrOubliHerJointes20212022etFonctionSeuilOnde_ValidParAnneesSecIntHum_2012_2022_20230614" #Apprentissage sur les annees seches+intermediaires. Validation sur annees humides. Puis switch

# nomSim_param_ = "19_ObservesReanalyseSafranComplet_HERh_FltOnde_JctHER_SansIFetExES_1_2012_2022_20230818" #Apprentissage sur les annees seches+intermediaires. Validation sur annees humides. Puis switch
# nomSim_param_ = "19_ObservesReanalyseSafranComplet_FDCFrom19760801_To20221231_1_20230818" #Apprentissage sur les annees seches+intermediaires. Validation sur annees humides. Puis switch
# nomSim_param_ = "19_ObservesReanalyseSafran_20230818" #Apprentissage sur les annees seches+intermediaires. Validation sur annees humides. Puis switch
# nomSim_param_ = "20_PresentMesure_20230823"
# nomSim_param_ = "21_ObservesReanalyseSafranJusqua2022_ProjectionsEnsuite"

# nomSim_param_ = "22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2022_20230919"
# nomSim_param_ = "26_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_20231201"
nomSim_param_ = "32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208"

### Liste des stations HYDRO selectionnees ###

# FiltreOndeManquantes = Filtrer les mois qui ont un nombre d'observation inferieur a 75% du max

logical_selectStationsAvailable_param_ = TRUE
#nom_selectStations_param_ = "1_PresentMesures_HERh_TsKGE_TtesStat_2012_2022_20230417"
#nom_selectStations_param_ = "2_PresentMesures_HERh_TsKGE_SansImpactFort_2012_2022_20230426"
#nom_selectStations_param_ = "4_PresentMesures_HERh_TsKGE_ImpactNulFaible_2012_2022_20230427"
#nom_selectStations_param_ = "9_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantesSansImpactFortEtCritereES_2012_2022_20230509"
#nom_selectStations_param_ = "10_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_2012_2022_20230512"
#~ nom_selectStations_param_ = "SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522" # Stations selectionnees pour les validations par HER 2 hybrides.
#nom_selectStations_param_ = "12_PresentMesures_HERh_TsKGE_TtesStat_SensiIntJoursV2_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230523"
#~11~nom_selectStations_param_ = "13_PresentMesures_HERh_TsKGE_TtesStat_FltOnde_JctHER_SansIFetExES_ValidParAnnees_2012_2022_20230524"
# nom_selectStations_param_ = "SelectionCsv_13_DebitsObsReanalyseSafran"
# nom_selectStations_param_ = "SelectionCsv_19_ObservesReanalyseSafran/debit_Rhone-Loire_SAFRAN-France-2022_INRAE-J2000_day"
# nom_selectStations_param_ = "SelectionCsv_19_ObservesReanalyseSafran/debit_France_SAFRAN-France-2022_MF-SIM2_day_19760801-20220731"
# nom_selectStations_param_ = "SelectionCsv_22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidAnSecInterHum_2012_2022_20230919"
# nom_selectStations_param_ = "SelectionCsv_26_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_20231201"
nom_selectStations_param_ = "SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221"

#list_debits_gcm_param_ = paste0(folder_input_param_,"Debits/Futur/DebitsTxt_Rhone_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v2_ADAMONT-France_INRAE-J2000_day_19750101-21001231_20230316/")
# list_debits_obs_param_ = paste0(folder_input_param_,"Debits/DebitsObserves/3_Reunion_TxtHorsRMC_RdataRMCetCorr/")
#list_debits_sim_param_ = paste0(folder_input_param_,"Debits/DebitsSimChroniques/DebitsTxt_J2000_SafranDiagnostic_20230315/")
#list_stationsHydro_correspondanceHER_param_ = paste0(folder_input_param_,"CorrespondanceHydroHer/HER2/VersionES_1_20230322/Liste_1667StationsHYDRO_snap_HER2_2_ESoutput_v2_20230322.csv")

# list_stationsHydro_correspondanceHER_param_ = NA
# list_stationsHydro_correspondanceHERhybrides_param_ = paste0(folder_input_param_,"CorrespondanceHydroHer/HER2hybrides/VersionES2023_2_20230420/PropSurfaceHER2hybrides_ToutesStationsFrance_TabDoubleEntree_1_20230420.csv")
# file_dispoHydro_param_ = paste0(folder_input_param_,"Debits/DebitsObserves/DisponibiliteDonneesHydroDates/TablesDisponibiliteDonneesHydro/DisponibiliteTemporelle_VersionTJ_20230403/3_DisponibiliteDonnees_DatesEtMergeHER2hybrides/HER2_VersionES_2_20230404/3_Merge_DisponibiliteHydro_CorrespondanceHER2hybridesv2_2_20230404.csv")


### FDC ###
# nom_categorieSimu_param_ = "" ### Observe
# nom_categorieSimu_param_ = "DebitsComplets_From20120101_To20221231" ### Observe
# nom_categorieSimu_param_ = "ObsFDCcalculeSansBornes_1_PresentMesures_HERh_TsKGE_PremierRun_2012_2022_20230417" ### Observe

# nom_categorieSimu_param_ = "DebitsComplets_DebitsParModelesHydro_FichierComplet"  ### Safran
# nom_categorieSimu_param_ = "DebitsComplets_DebitsParModelesHydro_From20120101_To20221231"  ### Safran
# nom_categorieSimu_param_ = "DebitsMerged_DebitsParModelesHydro_From20060101To21001231"  ### Safran
# nom_categorieSimu_param_ = "DebitsComplets_ParModelesHydro_NetcdfMerged_From19760801_To21001231"  ### Safran
# nom_categorieSimu_param_ = ""

logical_FDCAvailable_param_ = TRUE
# nom_FDCfolder_param_ = "1_PresentMesures_HERh_TsKGE_PremierRun_2012_2022_20230417"
# nom_FDCfolder_param_ = "20230726"
nom_FDCfolder_param_ = ""

FDC_dateBorneMin_param_ = "1900-01-01"
FDC_dateBorneMax_param_ = "2200-01-01"
# FDC_dateBorneMin_param_ = "2012-01-01"
# FDC_dateBorneMax_param_ = "2022-12-31"


### HER 2 hybrides ###
HER_variable_param_ = "HER2"

### TEMPORAIRE ###
# HER2_hybrides <- readOGR("/home/tjaouen/Documents/Input/HER/HER2hybrides/Shapefile/", "HER2_hybrides")
# proj4string(HER2_hybrides)=CRS("+init=epsg:4326") # définition de la projection WGS84
# HER2_hybrides.spdf <- spTransform(HER2_hybrides, CRS("+init=epsg:2154")) # trasnformation en Lambert93
##################


# HER_param_ = c(sort(HER2_hybrides.spdf$CdHER2), 031033039, 037055, 069096)
# HER_param_ = c(sort(HER2_hybrides.spdf$CdHER2), 031033039, 037054, 069096)
# HER_param_ = c(sort(HER2_hybrides.spdf$CdHER2)[61:80])
# Problemes HER : 18, 19, 20 (ind )
# HER_param_ = sort(HER2_hybrides.spdf$CdHER2)[12]
# HER_param_ = c(2,55,037054)
# HER_param_ = c(10,18,19,20,31,33,37,39,55,69,96) # HER2 non utilisees depuis la premiere etude

# HER_param_ = c(sort(HER2_hybrides.spdf$CdHER2)[which(!(sort(HER2_hybrides.spdf$CdHER2) %in% c(2,55,037054, 31, 33, 39, 37, 55, 69, 96)))], 031033039, 069096)

# HER_param_ = c(2)
# HER_param_ = c(18,19,20)
# HER_param_ = c(117)
# HER_param_ = c(18,19,20)
# HER_param_ = c(2,089092)
# HER_param_ = c(2,049090)

# HER_param_ = c(sort(HER2_hybrides.spdf$CdHER2)[which(!(sort(HER2_hybrides.spdf$CdHER2) %in% c(31, 33, 39, 37, 54, 69, 96)))], 031033039, 037054, 069096)

# HER_param_ = c(sort(HER2_hybrides.spdf$CdHER2)[which(!(sort(HER2_hybrides.spdf$CdHER2) %in% c(31, 33, 39, 37, 54, 69, 96, 89, 92, 49, 90)))], 031033039, 037054, 069096, 089092, 049090)

HER_param_ <- c(2, 3, 5, 10, 12, 13, 14, 17, 18, 19, 20, 21, 22, 24, 25, 27, 28, 34, 35, 36, 38, 40, 41, 43,
                44, 50, 51, 52, 53, 55, 56, 57, 58, 59, 61, 62, 63, 64, 65, 66, 67, 68, 70, 71, 73, 74, 75, 76,
                77, 78, 79, 81, 84, 85, 86, 87, 91, 93, 94, 97, 98, 99, 101, 103, 104, 105, 106, 107, 108, 112, 113, 117,
                118, 120, 31033039, 37054, 69096, 89092, 49090)

### Contexte ###
# presFut_param_ = "Present"
# obsSim_param_ = "Observes"
obsSim_param_ = "Projections"
# obsSim_param_ = "ObservesReanalyseSafran_DriasEau" # qj_hydro2 = Obs ### A CHANGER
# obsSim_param_ = "ObservesReanalyseSafranJusqua2022_ProjectionsEnsuite"
#~ obsSim_param_ = "ObsReanalyseSafranJusqua2022_ProjEnsuite"

### Parametres Chaines GCM RCM ###
nom_GCM_param_ = ""
#nom_GCM_param_ = "Rhone_CNRM-CERFACS-CNRM-CM5_historical_r1i1p1_CNRM-ALADIN63_v2_ADAMONT-France_INRAE-J2000_day_19750101-20051231"
#nom_GCM_param_ = "Rhone_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v2_ADAMONT-France_INRAE-J2000_day_19750101-21001231"
# nom_GCM_param_ = "debit_Rhone-Loire_SAFRAN-France-2022_INRAE-J2000_day_19760801-20221231"
# ~nom_GCM_param_ = "debit_France_SAFRAN-France-2022_MF-SIM2_day_19760801-20220731"

### CTRIP ###
# nom_categorieSimu_param_ = "CTRIP_20231128/ChroniquesCombinees_saf_rcp85/"  ### Safran
# nom_categorieSimu_param_ = "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/"  ### Safran
# nom_GCM_param_ = "debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-21000731"
# nom_GCM_param_ = "debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-21000731"
# nom_GCM_param_ = "debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-20990731"
# nom_GCM_param_ = "debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CNRM-ALADIN63_v2_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-20990731"

# nom_categorieSimu_param_ = "CTRIP_20231128/ChroniquesBrutes_rcp26/"  ### Safran

# nom_categorieSimu_param_ = "CTRIP_20231128/ChroniquesBrutes_rcp45/"  ### Safran

# nom_categorieSimu_param_ = "CTRIP_20231128/ChroniquesBrutes_historical/ModA_FaFa/"
# nom_categorieSimu_param_ = "CTRIP_20231128/ChroniquesBrutes_historical/ModB_ChSc/"
# nom_categorieSimu_param_ = "CTRIP_20231128/ChroniquesBrutes_historical/ModC_ChCnt/"
# nom_categorieSimu_param_ = "CTRIP_20231128/ChroniquesBrutes_historical/ModD_ChHm/"

# nom_categorieSimu_param_ = "CTRIP_20231128/ChroniquesBrutes_rcp26/ModA_FaFa/"
# nom_categorieSimu_param_ = "CTRIP_20231128/ChroniquesBrutes_rcp26/ModB_ChSc/"
# nom_categorieSimu_param_ = "CTRIP_20231128/ChroniquesBrutes_rcp26/ModC_ChCnt/"
# nom_categorieSimu_param_ = "CTRIP_20231128/ChroniquesBrutes_rcp26/ModD_ChHm/"

# nom_categorieSimu_param_ = "CTRIP_20231128/ChroniquesBrutes_rcp45/ModA_FaFa/"
# nom_categorieSimu_param_ = "CTRIP_20231128/ChroniquesBrutes_rcp45/ModB_ChSc/"
# nom_categorieSimu_param_ = "CTRIP_20231128/ChroniquesBrutes_rcp45/ModC_ChCnt/"
# nom_categorieSimu_param_ = "CTRIP_20231128/ChroniquesBrutes_rcp45/ModD_ChHm/"

# nom_categorieSimu_param_ = "CTRIP_20231128/ChroniquesBrutes_rcp85/ModA_FaFa/"
# nom_categorieSimu_param_ = "CTRIP_20231128/ChroniquesBrutes_rcp85/ModB_ChSc/"
# nom_categorieSimu_param_ = "CTRIP_20231128/ChroniquesBrutes_rcp85/ModC_ChCnt/"
# nom_categorieSimu_param_ = "CTRIP_20231128/ChroniquesBrutes_rcp85/ModD_ChHm/"

### GRSD ###
# nom_categorieSimu_param_ = "GRSD_20231128/ChroniquesCombinees_saf_rcp85/"  ### Safran
# nom_categorieSimu_param_ = "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/"  ### Safran

# nom_categorieSimu_param_ = "GRSD_20231128/ChroniquesBrutes_rcp85/Modele_ChroniquesCombinees_saf_rcp85_CNRM-CM5_CNRM-ALADIN63/"  ### Safran
# nom_categorieSimu_param_ = "GRSD_20231128/ChroniquesBrutes_historical/Modele_ChroniquesCombinees_saf_rcp85_CNRM-CM5_CNRM-ALADIN63/"  ### Safran
# nom_GCM_param_ = "debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731" # CNRM_Aladin
# nom_GCM_param_ = "debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731" # ECEarth_HadREM
# nom_GCM_param_ = "debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-20990731" # HadGEM_CCLM
# nom_GCM_param_ = "debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CNRM-ALADIN63_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-20990731" # HadGEM_Aladin

# nom_categorieSimu_param_ = "GRSD_20231128/ChroniquesBrutes_historical/ModA_FaFa/"  ### Safran
# nom_categorieSimu_param_ = "GRSD_20231128/ChroniquesBrutes_historical/ModB_ChSc/"  ### Safran
# nom_categorieSimu_param_ = "GRSD_20231128/ChroniquesBrutes_historical/ModC_ChCnt/"  ### Safran
# nom_categorieSimu_param_ = "GRSD_20231128/ChroniquesBrutes_historical/ModD_ChHm/"  ### Safran
# nom_GCM_param_ = "debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731" # CNRM_Aladin
# nom_GCM_param_ = "debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731" # ECEarth_HadREM
# nom_GCM_param_ = "debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-20990731" # HadGEM_CCLM
# nom_GCM_param_ = "debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CNRM-ALADIN63_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-20990731" # HadGEM_Aladin

# nom_categorieSimu_param_ = "GRSD_20231128/ChroniquesBrutes_rcp26/ModA_FaFa/"  ### Safran
# nom_categorieSimu_param_ = "GRSD_20231128/ChroniquesBrutes_rcp26/ModB_ChSc/"  ### Safran
# nom_categorieSimu_param_ = "GRSD_20231128/ChroniquesBrutes_rcp26/ModC_ChCnt/"  ### Safran
# nom_categorieSimu_param_ = "GRSD_20231128/ChroniquesBrutes_rcp26/ModD_ChHm/"  ### Safran
# nom_GCM_param_ = "debit_France_CNRM-CERFACS-CNRM-CM5_rcp26_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731" # CNRM_Aladin
# nom_GCM_param_ = "debit_France_ICHEC-EC-EARTH_rcp26_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731" # ECEarth_HadREM

# nom_categorieSimu_param_ = "GRSD_20231128/ChroniquesBrutes_rcp45/ModA_FaFa/"  ### Safran
# nom_categorieSimu_param_ = "GRSD_20231128/ChroniquesBrutes_rcp45/ModB_ChSc/"  ### Safran
# nom_categorieSimu_param_ = "GRSD_20231128/ChroniquesBrutes_rcp45/ModC_ChCnt/"  ### Safran
# nom_categorieSimu_param_ = "GRSD_20231128/ChroniquesBrutes_rcp45/ModD_ChHm/"  ### Safran
# nom_GCM_param_ = "debit_France_CNRM-CERFACS-CNRM-CM5_rcp45_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731" # CNRM_Aladin
# nom_GCM_param_ = "debit_France_MOHC-HadGEM2-ES_rcp45_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-20990731" # HadGEM_CCLM

# nom_categorieSimu_param_ = "GRSD_20231128/ChroniquesBrutes_rcp85/ModA_FaFa/"  ### Safran
# nom_categorieSimu_param_ = "GRSD_20231128/ChroniquesBrutes_rcp85/ModB_ChSc/"  ### Safran
# nom_categorieSimu_param_ = "GRSD_20231128/ChroniquesBrutes_rcp85/ModC_ChCnt/"  ### Safran
# nom_categorieSimu_param_ = "GRSD_20231128/ChroniquesBrutes_rcp85/ModD_ChHm/"  ### Safran
# nom_GCM_param_ = "debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731" # CNRM_Aladin
# nom_GCM_param_ = "debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731" # ECEarth_HadREM
# nom_GCM_param_ = "debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-20990731" # HadGEM_CCLM
# nom_GCM_param_ = "debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CNRM-ALADIN63_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-20990731" # HadGEM_Aladin

### ORCHIDEE ###
# nom_categorieSimu_param_ = "ORCHIDEE_20231128/ChroniquesCombinees_saf_rcp85/"  ### Safran
# nom_categorieSimu_param_ = "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/"  ### Safran
# nom_GCM_param_ = "debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_20050801-21000731"
# nom_GCM_param_ = "debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_20050801-21000731"
# nom_GCM_param_ = "debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_20050801-20990731"
# nom_GCM_param_ = "debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CNRM-ALADIN63_v2_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_20050801-20990731"

# nom_categorieSimu_param_ = "ORCHIDEE_20231128/ChroniquesBrutes_rcp26/"

# nom_categorieSimu_param_ = "ORCHIDEE_20231128/ChroniquesBrutes_rcp45/"

# nom_categorieSimu_param_ = "ORCHIDEE_20231128/ChroniquesBrutes_historical/ModA_FaFa/"
# nom_categorieSimu_param_ = "ORCHIDEE_20231128/ChroniquesBrutes_historical/ModB_ChSc/"
# nom_categorieSimu_param_ = "ORCHIDEE_20231128/ChroniquesBrutes_historical/ModC_ChCnt/"
# nom_categorieSimu_param_ = "ORCHIDEE_20231128/ChroniquesBrutes_historical/ModD_ChHm/"

# nom_categorieSimu_param_ = "ORCHIDEE_20231128/ChroniquesBrutes_rcp26/ModA_FaFa/"
# nom_categorieSimu_param_ = "ORCHIDEE_20231128/ChroniquesBrutes_rcp26/ModB_ChSc/"
# nom_categorieSimu_param_ = "ORCHIDEE_20231128/ChroniquesBrutes_rcp26/ModC_ChCnt/"
# nom_categorieSimu_param_ = "ORCHIDEE_20231128/ChroniquesBrutes_rcp26/ModD_ChHm/"

# nom_categorieSimu_param_ = "ORCHIDEE_20231128/ChroniquesBrutes_rcp45/ModA_FaFa/"
# nom_categorieSimu_param_ = "ORCHIDEE_20231128/ChroniquesBrutes_rcp45/ModB_ChSc/"
# nom_categorieSimu_param_ = "ORCHIDEE_20231128/ChroniquesBrutes_rcp45/ModC_ChCnt/"
# nom_categorieSimu_param_ = "ORCHIDEE_20231128/ChroniquesBrutes_rcp45/ModD_ChHm/"

# nom_categorieSimu_param_ = "ORCHIDEE_20231128/ChroniquesBrutes_rcp85/ModA_FaFa/"
# nom_categorieSimu_param_ = "ORCHIDEE_20231128/ChroniquesBrutes_rcp85/ModB_ChSc/"
# nom_categorieSimu_param_ = "ORCHIDEE_20231128/ChroniquesBrutes_rcp85/ModC_ChCnt/"
# nom_categorieSimu_param_ = "ORCHIDEE_20231128/ChroniquesBrutes_rcp85/ModD_ChHm/"


### J2000 ###
# nom_categorieSimu_param_ = "J2000_20231128/ChroniquesCombinees_saf_rcp85/"  ### Safran
# nom_categorieSimu_param_ = "J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/"  ### Safran
# nom_categorieSimu_param_ = "J2000_20231128/ChroniquesCombinees_saf_hist_rcp45/"  ### Safran
nom_categorieSimu_param_ = "J2000_20231128/ChroniquesCombinees_saf_hist_rcp26/"  ### Safran

# nom_GCM_param_ = "debit_Rhone-Loire_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-21000731" # CNRM_Aladin
# nom_GCM_param_ = "debit_Rhone-Loire_ICHEC-EC-EARTH_rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-21000731" # ECEarth_HadREM
# nom_GCM_param_ = "debit_Rhone-Loire_MOHC-HadGEM2-ES_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-20990731" # HadGEM_CCLM
# nom_GCM_param_ = "debit_Rhone-Loire_MOHC-HadGEM2-ES_rcp85_r1i1p1_CNRM-ALADIN63_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-20990731" # HadGEM_Aladin

# nom_categorieSimu_param_ = "J2000_20231128/ChroniquesBrutes_historical/ModA_FaFa/"
# nom_categorieSimu_param_ = "J2000_20231128/ChroniquesBrutes_historical/ModB_ChSc/"
# nom_categorieSimu_param_ = "J2000_20231128/ChroniquesBrutes_historical/ModC_ChCnt/"
# nom_categorieSimu_param_ = "J2000_20231128/ChroniquesBrutes_historical/ModD_ChHm/"

# nom_categorieSimu_param_ = "J2000_20231128/ChroniquesBrutes_rcp26/ModA_FaFa/"
# nom_categorieSimu_param_ = "J2000_20231128/ChroniquesBrutes_rcp26/ModB_ChSc/"
# nom_categorieSimu_param_ = "J2000_20231128/ChroniquesBrutes_rcp26/ModC_ChCnt/"
# nom_categorieSimu_param_ = "J2000_20231128/ChroniquesBrutes_rcp26/ModD_ChHm/"

# nom_categorieSimu_param_ = "J2000_20231128/ChroniquesBrutes_rcp45/ModA_FaFa/"
# nom_categorieSimu_param_ = "J2000_20231128/ChroniquesBrutes_rcp45/ModB_ChSc/"
# nom_categorieSimu_param_ = "J2000_20231128/ChroniquesBrutes_rcp45/ModC_ChCnt/"
# nom_categorieSimu_param_ = "J2000_20231128/ChroniquesBrutes_rcp45/ModD_ChHm/"

# nom_categorieSimu_param_ = "J2000_20231128/ChroniquesBrutes_rcp85/ModA_FaFa/"
# nom_categorieSimu_param_ = "J2000_20231128/ChroniquesBrutes_rcp85/ModB_ChSc/"
# nom_categorieSimu_param_ = "J2000_20231128/ChroniquesBrutes_rcp85/ModC_ChCnt/"
# nom_categorieSimu_param_ = "J2000_20231128/ChroniquesBrutes_rcp85/ModD_ChHm/"


### SMASH ###
# nom_categorieSimu_param_ = "SMASH_20231128/ChroniquesCombinees_saf_rcp85/"  ### Safran
# nom_categorieSimu_param_ = "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/"  ### Safran

# nom_GCM_param_ = "debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_20060101-21001231" # CNRM_Aladin
# nom_GCM_param_ = "debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_20060101-21001231" # ECEarth_HadREM
# nom_GCM_param_ = "debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_20060101-20991231" # HadGEM_CCLM
# nom_GCM_param_ = "debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CNRM-ALADIN63_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_20060101-20991231" # HadGEM_Aladin

# nom_categorieSimu_param_ = "SMASH_20231128/ChroniquesBrutes_rcp26/"

# nom_categorieSimu_param_ = "SMASH_20231128/ChroniquesBrutes_rcp45/"





iDisp_param_ = c(-1)
surfaceMaxStations_param_ = 2000
#seuilKGE_param_ = c(0,0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7)
seuilKGE_param_ = c(0)

### Climat / Scenario / Modeles Hydro ###
# climatScenarioModeleHydro_param_ = "CTRIP_diagnostic_20230321"
# climatScenarioModeleHydro_param_ = "EROS_modele_20230320"
# climatScenarioModeleHydro_param_ = "GRSD_20230618"
# climatScenarioModeleHydro_param_ = "J2000_20230308_safran_diagnostic"
# climatScenarioModeleHydro_param_ = "MORDOR-SD_20230428"
# climatScenarioModeleHydro_param_ = "MORDOR-TS_19762017"
# climatScenarioModeleHydro_param_ = "ORCHIDEE_extKWR-RZ1-RATIO-HUMCSTE-19760101_20191231"
# climatScenarioModeleHydro_param_ = "SIM2_19580801_20210731_day_METADATA"
# climatScenarioModeleHydro_param_ = "SMASH_20230303"

# climatScenarioModeleHydro_param_ = ""
# climatScenarioModeleHydro_param_ = "debit_France_SAFRAN-France-2019_INRAE-SMASH_day_19760801-20190731"
climatScenarioModeleHydro_param_ = "debit_Rhone-Loire_SAFRAN-France-2022_INRAE-J2000_day_19760801-20221231"
# climatScenarioModeleHydro_param_ = "debit_France_SAFRAN-France-2022_MF-SIM2_day_19760801-20220731"
# climatScenarioModeleHydro_param_ = "debit_France_SAFRAN-France-2022_INRAE-GRSD_day_19760801-20190731"
# climatScenarioModeleHydro_param_ = "debit_France_SAFRAN-France-2022_IPSL-ORCHIDEE_day_19760801-20190731"
# climatScenarioModeleHydro_param_ = "debit_France_SAFRAN-France-2022_MF-ISBA-CTRIP_day_19760101-20201231"


nom_apprentissage_param_ = ""

### Intervalle temps ###
jourMin_param_ = 6
jourMax_param_ = 0

### Toutes annees, modeles bruts ###
nom_apprentissage_param_ = "ApprentissageGlobalModelesBruts"
nom_validation_param_ = "Validation_1ModelesBruts"
annees_inputMatrice_param_ = c(2012:2022)
# annees_inputMatrice_param_ = c(2012:2022)
annees_learnModels_param_ = c(2012:2022)
annees_validModels_param_ = c(2012:2022)


### Annees ###
# nom_apprentissage_param_ = "ApprentissageLeaveOneYearOut"
# nom_validation_param_ = "Validation_2LeaveOneYearOut"

# annees_learnModels_param_ = c(2013:2022)
# annees_validModels_param_ = c(2012)

# annees_learnModels_param_ = c(2012,2014:2022)
# annees_validModels_param_ = c(2013)

# annees_learnModels_param_ = c(2012:2013,2015:2022)
# annees_validModels_param_ = c(2014)

# annees_learnModels_param_ = c(2012:2014,2016:2022)
# annees_validModels_param_ = c(2015)

# annees_learnModels_param_ = c(2012:2015,2017:2022)
# annees_validModels_param_ = c(2016)

# annees_learnModels_param_ = c(2012:2016,2018:2022)
# annees_validModels_param_ = c(2017)

# annees_learnModels_param_ = c(2012:2017,2019:2022)
# annees_validModels_param_ = c(2018)

# annees_learnModels_param_ = c(2012:2018,2020:2022)
# annees_validModels_param_ = c(2019)

# annees_learnModels_param_ = c(2012:2019,2021:2022)
# annees_validModels_param_ = c(2020)

# annees_learnModels_param_ = c(2012:2020,2022)
# annees_validModels_param_ = c(2021)

# annees_learnModels_param_ = c(2012:2021)
# annees_validModels_param_ = c(2022)


### Validations annees seches, intermediaires, humides - Apres decoupage par Precip / ETP ###
# - 2022, 2019, 2017 (Ratio < 1)
# - 2015, 2012, 2020, 2021 (1 <= Ratio < 1.4)
# - 2018, 2016, 2014, 2013 (1.4 <= Ratio).

# nom_apprentissage_param_ = "ApprentissageParDeuxCategoriesParmiSechesInterHumides"
# nom_validation_param_ = "Validation_3AnneesSechesInterHumides"

# annees_learnModels_param_ = c(2012,2015,2017,2019:2022)
# annees_validModels_param_ = c(2013:2014,2016,2018) # Annees humides

# annees_learnModels_param_ = c(2013,2014,2016:2019,2022)
# annees_validModels_param_ = c(2012,2015,2020,2021) # Annees intermediaires

# annees_learnModels_param_ = c(2012:2016,2018,2020:2021)
# annees_validModels_param_ = c(2017,2019,2022) # Annees seches

annees_predict_PST_param_ = c(as.Date("1975-01-01"),as.Date("2022-09-30"))
annees_predict_MI_param_ = c(as.Date("2022-10-01"),as.Date("2071-07-31"))
annees_predict_FIN_param_ = c(as.Date("2081-01-02"),as.Date("2100-12-31"))
annees_predict_param_ = c(as.Date("1975-01-01"),as.Date("2100-12-31"))



