source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/6_RunsEtudeFrance_CorrectionImportOnde_20230607/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")

# Charger les bibliothèques
library(png)
library(grid)
library(ggplot2)
library(cowplot)
library(gridExtra)

### Stations Hydrometriques ###
chemin_hydro_points_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240119/Carte_PointsStationsHydro_sansEtiq_English_1_20240119.rds"
chemin_hydro_PropSurfaceEntiteParSurfaceHER2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240119/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_English_1_20240119.rds"
chemin_hydro_NbStationsPour1000km2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240119/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_English_1_20240119.rds"

### Onde ###
chemin_onde_points_ <- "/home/tjaouen/Documents/Input/ONDE/Data_DatesAjustees/MapSitesOndeDisponibles/Version_20240119/Carte_PointsStationsOnde_sansEtiq_English_1_20240119.rds"
chemin_onde_PropSurfaceEntiteParSurfaceHER2_ <- "/home/tjaouen/Documents/Input/ONDE/Data_DatesAjustees/MapSitesOndeDisponibles/Version_20240119/Carte_RepartitionSitesONDEHER2hyb_SumSurfacePondSurfHER2_sansEtiq_English_1_20240119.rds"
chemin_onde_NbStationsPour1000km2_ <- "/home/tjaouen/Documents/Input/ONDE/Data_DatesAjustees/MapSitesOndeDisponibles/Version_20240119/Carte_RepartitionSitesONDEHER2hyb_NbStationsOndeProp1000SurfHER2_sansEtiq_English_1_20240119.rds"

### Modeles ###
chemin_1_CTRIP_points_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_PointsStations_CTRIP_sansEtiq_English_1_20240109.rds"
chemin_1_CTRIP_PropSurfaceEntiteParSurfaceHER2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_CTRIP_sansEtiq_English_1_20240109.rds"
chemin_1_CTRIP_NbStationsPour1000km2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_CTRIP_sansEtiq_English_1_20240109.rds"

# chemin_2_EROS_points_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_PointsStations_2_EROS_modele_20230320_sansEtiq_English_1_20230911.rds"
# chemin_2_EROS_PropSurfaceEntiteParSurfaceHER2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_2_EROS_modele_20230320_sansEtiq_English_1_20230911.rds"
# chemin_2_EROS_NbStationsPour1000km2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_2_EROS_modele_20230320_sansEtiq_English_1_20230911.rds"

chemin_3_GRSD_points_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_PointsStations_GRSD_sansEtiq_English_1_20240109.rds"
chemin_3_GRSD_PropSurfaceEntiteParSurfaceHER2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_GRSD_sansEtiq_English_1_20240109.rds"
chemin_3_GRSD_NbStationsPour1000km2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_GRSD_sansEtiq_English_1_20240109.rds"

chemin_4_J2000_points_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_PointsStations_J2000_sansEtiq_English_1_20240109.rds"
chemin_4_J2000_PropSurfaceEntiteParSurfaceHER2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_J2000_sansEtiq_English_1_20240109.rds"
chemin_4_J2000_NbStationsPour1000km2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_J2000_sansEtiq_English_1_20240109.rds"

# chemin_5_MORDORSD_points_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_PointsStations_5_MORDOR-SD_20230428_sansEtiq_English_1_20230911.rds"
# chemin_5_MORDORSD_PropSurfaceEntiteParSurfaceHER2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_5_MORDOR-SD_20230428_sansEtiq_English_1_20230911.rds"
# chemin_5_MORDORSD_NbStationsPour1000km2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_5_MORDOR-SD_20230428_sansEtiq_English_1_20230911.rds"
# 
# chemin_6_MORDORTS_points_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_PointsStations_6_MORDOR-TS_19762017_sansEtiq_English_1_20230911.rds"
# chemin_6_MORDORTS_PropSurfaceEntiteParSurfaceHER2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_6_MORDOR-TS_19762017_sansEtiq_English_1_20230911.rds"
# chemin_6_MORDORTS_NbStationsPour1000km2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_6_MORDOR-TS_19762017_sansEtiq_English_1_20230911.rds"

chemin_7_ORCHIDEE_points_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_PointsStations_ORCHIDEE_sansEtiq_English_1_20240109.rds"
chemin_7_ORCHIDEE_PropSurfaceEntiteParSurfaceHER2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_ORCHIDEE_sansEtiq_English_1_20240109.rds"
chemin_7_ORCHIDEE_NbStationsPour1000km2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_ORCHIDEE_sansEtiq_English_1_20240109.rds"

# chemin_8_SIM2_points_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_PointsStations_8_SIM2_19580801_20210731_day_METADATA_sansEtiq_English_1_20230911.rds"
# chemin_8_SIM2_PropSurfaceEntiteParSurfaceHER2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_8_SIM2_19580801_20210731_day_METADATA_sansEtiq_English_1_20230911.rds"
# chemin_8_SIM2_NbStationsPour1000km2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_8_SIM2_19580801_20210731_day_METADATA_sansEtiq_English_1_20230911.rds"

chemin_9_SMASH_points_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_PointsStations_SMASH_sansEtiq_English_1_20240109.rds"
chemin_9_SMASH_PropSurfaceEntiteParSurfaceHER2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_SMASH_sansEtiq_English_1_20240109.rds"
chemin_9_SMASH_NbStationsPour1000km2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_SMASH_sansEtiq_English_1_20240109.rds"


### Output file ###
output_name_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Merge/Merge_tab7ToutesExclusions1_sansEtiq_English_1_20231121.rds"

# Importer les fichiers PNG
image_hydro_points_ <- readRDS(chemin_hydro_points_)
image_hydro_propSurfaceEntiteParSurfaceHER2_ <- readRDS(chemin_hydro_PropSurfaceEntiteParSurfaceHER2_)
image_hydro_NbStationsPour1000km2_ <- readRDS(chemin_hydro_NbStationsPour1000km2_)
image_onde_points_ <- readRDS(chemin_onde_points_)
image_onde_propSurfaceEntiteParSurfaceHER2_ <- readRDS(chemin_onde_PropSurfaceEntiteParSurfaceHER2_)
image_onde_NbStationsPour1000km2_ <- readRDS(chemin_onde_NbStationsPour1000km2_)

image_1_CTRIP_points_ <- readRDS(chemin_1_CTRIP_points_)
image_1_CTRIP_propSurfaceEntiteParSurfaceHER2_ <- readRDS(chemin_1_CTRIP_PropSurfaceEntiteParSurfaceHER2_)
image_1_CTRIP_NbStationsPour1000km2_ <- readRDS(chemin_1_CTRIP_NbStationsPour1000km2_)
# image_2_EROS_points_ <- readRDS(chemin_2_EROS_points_)
# image_2_EROS_propSurfaceEntiteParSurfaceHER2_ <- readRDS(chemin_2_EROS_PropSurfaceEntiteParSurfaceHER2_)
# image_2_EROS_NbStationsPour1000km2_ <- readRDS(chemin_2_EROS_NbStationsPour1000km2_)
image_3_GRSD_points_ <- readRDS(chemin_3_GRSD_points_)
image_3_GRSD_propSurfaceEntiteParSurfaceHER2_ <- readRDS(chemin_3_GRSD_PropSurfaceEntiteParSurfaceHER2_)
image_3_GRSD_NbStationsPour1000km2_ <- readRDS(chemin_3_GRSD_NbStationsPour1000km2_)
image_4_J2000_points_ <- readRDS(chemin_4_J2000_points_)
image_4_J2000_propSurfaceEntiteParSurfaceHER2_ <- readRDS(chemin_4_J2000_PropSurfaceEntiteParSurfaceHER2_)
image_4_J2000_NbStationsPour1000km2_ <- readRDS(chemin_4_J2000_NbStationsPour1000km2_)
# image_5_MORDORSD_points_ <- readRDS(chemin_5_MORDORSD_points_)
# image_5_MORDORSD_propSurfaceEntiteParSurfaceHER2_ <- readRDS(chemin_5_MORDORSD_PropSurfaceEntiteParSurfaceHER2_)
# image_5_MORDORSD_NbStationsPour1000km2_ <- readRDS(chemin_5_MORDORSD_NbStationsPour1000km2_)
# image_6_MORDORTS_points_ <- readRDS(chemin_6_MORDORTS_points_)
# image_6_MORDORTS_propSurfaceEntiteParSurfaceHER2_ <- readRDS(chemin_6_MORDORTS_PropSurfaceEntiteParSurfaceHER2_)
# image_6_MORDORTS_NbStationsPour1000km2_ <- readRDS(chemin_6_MORDORTS_NbStationsPour1000km2_)
image_7_ORCHIDEE_points_ <- readRDS(chemin_7_ORCHIDEE_points_)
image_7_ORCHIDEE_propSurfaceEntiteParSurfaceHER2_ <- readRDS(chemin_7_ORCHIDEE_PropSurfaceEntiteParSurfaceHER2_)
image_7_ORCHIDEE_NbStationsPour1000km2_ <- readRDS(chemin_7_ORCHIDEE_NbStationsPour1000km2_)
# image_8_SIM2_points_ <- readRDS(chemin_8_SIM2_points_)
# image_8_SIM2_propSurfaceEntiteParSurfaceHER2_ <- readRDS(chemin_8_SIM2_PropSurfaceEntiteParSurfaceHER2_)
# image_8_SIM2_NbStationsPour1000km2_ <- readRDS(chemin_8_SIM2_NbStationsPour1000km2_)
image_9_SMASH_points_ <- readRDS(chemin_9_SMASH_points_)
image_9_SMASH_propSurfaceEntiteParSurfaceHER2_ <- readRDS(chemin_9_SMASH_PropSurfaceEntiteParSurfaceHER2_)
image_9_SMASH_NbStationsPour1000km2_ <- readRDS(chemin_9_SMASH_NbStationsPour1000km2_)

image_hydro_points_ <- image_hydro_points_+ theme(legend.text = element_text(size = 12), plot.title = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank(), axis.title = element_blank(), legend.position = "top", text = element_text(size = 12))
image_hydro_propSurfaceEntiteParSurfaceHER2_ <- image_hydro_propSurfaceEntiteParSurfaceHER2_ + theme(legend.text = element_text(size = 12), plot.title = element_text(size = 15), text = element_text(size = 12))
image_hydro_NbStationsPour1000km2_ <- image_hydro_NbStationsPour1000km2_ + theme(legend.text = element_text(size = 12), plot.title = element_text(size = 15), text = element_text(size = 12))

# Ajouter une légende unique à partir d'un des graphiques
legend_hydro_points <- cowplot::get_legend(image_hydro_points_)
legend_hydro_propSurfaceEntiteParSurfaceHER2 <- cowplot::get_legend(image_hydro_propSurfaceEntiteParSurfaceHER2_)
legend_hydro_NbStationsPour1000km2 <- cowplot::get_legend(image_hydro_NbStationsPour1000km2_)
legend_onde_points <- cowplot::get_legend(image_onde_points_)
legend_onde_propSurfaceEntiteParSurfaceHER2 <- cowplot::get_legend(image_onde_propSurfaceEntiteParSurfaceHER2_)
legend_onde_NbStationsPour1000km2 <- cowplot::get_legend(image_onde_NbStationsPour1000km2_)

image_hydro_propSurfaceEntiteParSurfaceHER2_ <- image_hydro_propSurfaceEntiteParSurfaceHER2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12), legend.text = element_text(size = 12))
image_hydro_NbStationsPour1000km2_ <- image_hydro_NbStationsPour1000km2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))
image_onde_points_ <- image_onde_points_+ theme(plot.title = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank(), axis.title = element_blank(), legend.position = "top", text = element_text(size = 12))
image_onde_propSurfaceEntiteParSurfaceHER2_ <- image_onde_propSurfaceEntiteParSurfaceHER2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))
image_onde_NbStationsPour1000km2_ <- image_onde_NbStationsPour1000km2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))

image_1_CTRIP_points_ <- image_1_CTRIP_points_+ theme(plot.title = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank(), axis.title = element_blank(), legend.position = "top", text = element_text(size = 12))
image_1_CTRIP_propSurfaceEntiteParSurfaceHER2_ <- image_1_CTRIP_propSurfaceEntiteParSurfaceHER2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))
image_1_CTRIP_NbStationsPour1000km2_ <- image_1_CTRIP_NbStationsPour1000km2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))
# image_2_EROS_points_ <- image_2_EROS_points_+ theme(plot.title = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank(), axis.title = element_blank(), legend.position = "top", text = element_text(size = 12))
# image_2_EROS_propSurfaceEntiteParSurfaceHER2_ <- image_2_EROS_propSurfaceEntiteParSurfaceHER2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))
# image_2_EROS_NbStationsPour1000km2_ <- image_2_EROS_NbStationsPour1000km2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))
image_3_GRSD_points_ <- image_3_GRSD_points_+ theme(plot.title = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank(), axis.title = element_blank(), legend.position = "top", text = element_text(size = 12))
image_3_GRSD_propSurfaceEntiteParSurfaceHER2_ <- image_3_GRSD_propSurfaceEntiteParSurfaceHER2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))
image_3_GRSD_NbStationsPour1000km2_ <- image_3_GRSD_NbStationsPour1000km2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))
image_4_J2000_points_ <- image_4_J2000_points_+ theme(plot.title = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank(), axis.title = element_blank(), legend.position = "top", text = element_text(size = 12))
image_4_J2000_propSurfaceEntiteParSurfaceHER2_ <- image_4_J2000_propSurfaceEntiteParSurfaceHER2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))
image_4_J2000_NbStationsPour1000km2_ <- image_4_J2000_NbStationsPour1000km2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))
# image_5_MORDORSD_points_ <- image_5_MORDORSD_points_+ theme(plot.title = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank(), axis.title = element_blank(), legend.position = "top", text = element_text(size = 12))
# image_5_MORDORSD_propSurfaceEntiteParSurfaceHER2_ <- image_5_MORDORSD_propSurfaceEntiteParSurfaceHER2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))
# image_5_MORDORSD_NbStationsPour1000km2_ <- image_5_MORDORSD_NbStationsPour1000km2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))
# image_6_MORDORTS_points_ <- image_6_MORDORTS_points_+ theme(plot.title = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank(), axis.title = element_blank(), legend.position = "top", text = element_text(size = 12))
# image_6_MORDORTS_propSurfaceEntiteParSurfaceHER2_ <- image_6_MORDORTS_propSurfaceEntiteParSurfaceHER2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))
# image_6_MORDORTS_NbStationsPour1000km2_ <- image_6_MORDORTS_NbStationsPour1000km2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))
image_7_ORCHIDEE_points_ <- image_7_ORCHIDEE_points_+ theme(plot.title = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank(), axis.title = element_blank(), legend.position = "top", text = element_text(size = 12))
image_7_ORCHIDEE_propSurfaceEntiteParSurfaceHER2_ <- image_7_ORCHIDEE_propSurfaceEntiteParSurfaceHER2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))
image_7_ORCHIDEE_NbStationsPour1000km2_ <- image_7_ORCHIDEE_NbStationsPour1000km2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))
# image_8_SIM2_points_ <- image_8_SIM2_points_+ theme(plot.title = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank(), axis.title = element_blank(), legend.position = "top", text = element_text(size = 12))
# image_8_SIM2_propSurfaceEntiteParSurfaceHER2_ <- image_8_SIM2_propSurfaceEntiteParSurfaceHER2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))
# image_8_SIM2_NbStationsPour1000km2_ <- image_8_SIM2_NbStationsPour1000km2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))
image_9_SMASH_points_ <- image_9_SMASH_points_+ theme(plot.title = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank(), axis.title = element_blank(), legend.position = "top", text = element_text(size = 12))
image_9_SMASH_propSurfaceEntiteParSurfaceHER2_ <- image_9_SMASH_propSurfaceEntiteParSurfaceHER2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))
image_9_SMASH_NbStationsPour1000km2_ <- image_9_SMASH_NbStationsPour1000km2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))

# Pour obtenir les data et comparer les legendes #
image_hydro_points_build_ = ggplot_build(image_hydro_points_)
image_hydro_propSurfaceEntiteParSurfaceHER2_build_ = ggplot_build(image_hydro_propSurfaceEntiteParSurfaceHER2_)
image_hydro_NbStationsPour1000km2_build_ = ggplot_build(image_hydro_NbStationsPour1000km2_)
image_onde_points_build_ = ggplot_build(image_onde_points_)
image_onde_propSurfaceEntiteParSurfaceHER2_build_ = ggplot_build(image_onde_propSurfaceEntiteParSurfaceHER2_)
image_onde_NbStationsPour1000km2_build_ = ggplot_build(image_onde_NbStationsPour1000km2_)

image_1_CTRIP_points_build_ = ggplot_build(image_onde_points_)
image_1_CTRIP_propSurfaceEntiteParSurfaceHER2_build_ = ggplot_build(image_onde_propSurfaceEntiteParSurfaceHER2_)
image_1_CTRIP_NbStationsPour1000km2_build_ = ggplot_build(image_onde_NbStationsPour1000km2_)
# image_2_EROS_points_build_ = ggplot_build(image_onde_points_)
# image_2_EROS_propSurfaceEntiteParSurfaceHER2_build_ = ggplot_build(image_onde_propSurfaceEntiteParSurfaceHER2_)
# image_2_EROS_NbStationsPour1000km2_build_ = ggplot_build(image_onde_NbStationsPour1000km2_)
image_3_GRSD_points_build_ = ggplot_build(image_onde_points_)
image_3_GRSD_propSurfaceEntiteParSurfaceHER2_build_ = ggplot_build(image_onde_propSurfaceEntiteParSurfaceHER2_)
image_3_GRSD_NbStationsPour1000km2_build_ = ggplot_build(image_onde_NbStationsPour1000km2_)
image_4_J2000_points_build_ = ggplot_build(image_onde_points_)
image_4_J2000_propSurfaceEntiteParSurfaceHER2_build_ = ggplot_build(image_onde_propSurfaceEntiteParSurfaceHER2_)
image_4_J2000_NbStationsPour1000km2_build_ = ggplot_build(image_onde_NbStationsPour1000km2_)
# image_5_MORDORSD_points_build_ = ggplot_build(image_onde_points_)
# image_5_MORDORSD_propSurfaceEntiteParSurfaceHER2_build_ = ggplot_build(image_onde_propSurfaceEntiteParSurfaceHER2_)
# image_5_MORDORSD_NbStationsPour1000km2_build_ = ggplot_build(image_onde_NbStationsPour1000km2_)
# image_6_MORDORTS_points_build_ = ggplot_build(image_onde_points_)
# image_6_MORDORTS_propSurfaceEntiteParSurfaceHER2_build_ = ggplot_build(image_onde_propSurfaceEntiteParSurfaceHER2_)
# image_6_MORDORTS_NbStationsPour1000km2_build_ = ggplot_build(image_onde_NbStationsPour1000km2_)
image_7_ORCHIDEE_points_build_ = ggplot_build(image_onde_points_)
image_7_ORCHIDEE_propSurfaceEntiteParSurfaceHER2_build_ = ggplot_build(image_onde_propSurfaceEntiteParSurfaceHER2_)
image_7_ORCHIDEE_NbStationsPour1000km2_build_ = ggplot_build(image_onde_NbStationsPour1000km2_)
# image_8_SIM2_points_build_ = ggplot_build(image_onde_points_)
# image_8_SIM2_propSurfaceEntiteParSurfaceHER2_build_ = ggplot_build(image_onde_propSurfaceEntiteParSurfaceHER2_)
# image_8_SIM2_NbStationsPour1000km2_build_ = ggplot_build(image_onde_NbStationsPour1000km2_)
image_9_SMASH_points_build_ = ggplot_build(image_onde_points_)
image_9_SMASH_propSurfaceEntiteParSurfaceHER2_build_ = ggplot_build(image_onde_propSurfaceEntiteParSurfaceHER2_)
image_9_SMASH_NbStationsPour1000km2_build_ = ggplot_build(image_onde_NbStationsPour1000km2_)

if (!(identical(levels(image_hydro_propSurfaceEntiteParSurfaceHER2_build_$plot$layers[[1]]$data$var_cut_),
                levels(image_onde_propSurfaceEntiteParSurfaceHER2_build_$plot$layers[[1]]$data$var_cut_)) &
      identical(levels(image_hydro_NbStationsPour1000km2_build_$plot$layers[[1]]$data$var_cut_),
                levels(image_onde_NbStationsPour1000km2_build_$plot$layers[[1]]$data$var_cut_)))){
  stop("Les légendes des graphes que vous essayez de réunir ne sont pas identiques entre elles.")
}
if (!(identical(levels(image_hydro_propSurfaceEntiteParSurfaceHER2_build_$plot$layers[[1]]$data$var_cut_),
                levels(image_1_CTRIP_propSurfaceEntiteParSurfaceHER2_build_$plot$layers[[1]]$data$var_cut_)) &
      identical(levels(image_hydro_NbStationsPour1000km2_build_$plot$layers[[1]]$data$var_cut_),
                levels(image_1_CTRIP_NbStationsPour1000km2_build_$plot$layers[[1]]$data$var_cut_)))){
  stop("Les légendes des graphes que vous essayez de réunir ne sont pas identiques entre elles.")
}
# if (!(identical(levels(image_hydro_propSurfaceEntiteParSurfaceHER2_build_$plot$layers[[1]]$data$var_cut_),
#                 levels(image_2_EROS_propSurfaceEntiteParSurfaceHER2_build_$plot$layers[[1]]$data$var_cut_)) &
#       identical(levels(image_hydro_NbStationsPour1000km2_build_$plot$layers[[1]]$data$var_cut_),
#                 levels(image_2_EROS_NbStationsPour1000km2_build_$plot$layers[[1]]$data$var_cut_)))){
#   stop("Les légendes des graphes que vous essayez de réunir ne sont pas identiques entre elles.")
# }
if (!(identical(levels(image_hydro_propSurfaceEntiteParSurfaceHER2_build_$plot$layers[[1]]$data$var_cut_),
                levels(image_3_GRSD_propSurfaceEntiteParSurfaceHER2_build_$plot$layers[[1]]$data$var_cut_)) &
      identical(levels(image_hydro_NbStationsPour1000km2_build_$plot$layers[[1]]$data$var_cut_),
                levels(image_3_GRSD_NbStationsPour1000km2_build_$plot$layers[[1]]$data$var_cut_)))){
  stop("Les légendes des graphes que vous essayez de réunir ne sont pas identiques entre elles.")
}
if (!(identical(levels(image_hydro_propSurfaceEntiteParSurfaceHER2_build_$plot$layers[[1]]$data$var_cut_),
                levels(image_4_J2000_propSurfaceEntiteParSurfaceHER2_build_$plot$layers[[1]]$data$var_cut_)) &
      identical(levels(image_hydro_NbStationsPour1000km2_build_$plot$layers[[1]]$data$var_cut_),
                levels(image_4_J2000_NbStationsPour1000km2_build_$plot$layers[[1]]$data$var_cut_)))){
  stop("Les légendes des graphes que vous essayez de réunir ne sont pas identiques entre elles.")
}
# if (!(identical(levels(image_hydro_propSurfaceEntiteParSurfaceHER2_build_$plot$layers[[1]]$data$var_cut_),
#                 levels(image_5_MORDORSD_propSurfaceEntiteParSurfaceHER2_build_$plot$layers[[1]]$data$var_cut_)) &
#       identical(levels(image_hydro_NbStationsPour1000km2_build_$plot$layers[[1]]$data$var_cut_),
#                 levels(image_5_MORDORSD_NbStationsPour1000km2_build_$plot$layers[[1]]$data$var_cut_)))){
#   stop("Les légendes des graphes que vous essayez de réunir ne sont pas identiques entre elles.")
# }
# if (!(identical(levels(image_hydro_propSurfaceEntiteParSurfaceHER2_build_$plot$layers[[1]]$data$var_cut_),
#                 levels(image_6_MORDORTS_propSurfaceEntiteParSurfaceHER2_build_$plot$layers[[1]]$data$var_cut_)) &
#       identical(levels(image_hydro_NbStationsPour1000km2_build_$plot$layers[[1]]$data$var_cut_),
#                 levels(image_6_MORDORTS_NbStationsPour1000km2_build_$plot$layers[[1]]$data$var_cut_)))){
#   stop("Les légendes des graphes que vous essayez de réunir ne sont pas identiques entre elles.")
# }
if (!(identical(levels(image_hydro_propSurfaceEntiteParSurfaceHER2_build_$plot$layers[[1]]$data$var_cut_),
                levels(image_7_ORCHIDEE_propSurfaceEntiteParSurfaceHER2_build_$plot$layers[[1]]$data$var_cut_)) &
      identical(levels(image_hydro_NbStationsPour1000km2_build_$plot$layers[[1]]$data$var_cut_),
                levels(image_7_ORCHIDEE_NbStationsPour1000km2_build_$plot$layers[[1]]$data$var_cut_)))){
  stop("Les légendes des graphes que vous essayez de réunir ne sont pas identiques entre elles.")
}
# if (!(identical(levels(image_hydro_propSurfaceEntiteParSurfaceHER2_build_$plot$layers[[1]]$data$var_cut_),
#                 levels(image_8_SIM2_propSurfaceEntiteParSurfaceHER2_build_$plot$layers[[1]]$data$var_cut_)) &
#       identical(levels(image_hydro_NbStationsPour1000km2_build_$plot$layers[[1]]$data$var_cut_),
#                 levels(image_8_SIM2_NbStationsPour1000km2_build_$plot$layers[[1]]$data$var_cut_)))){
#   stop("Les légendes des graphes que vous essayez de réunir ne sont pas identiques entre elles.")
# }
if (!(identical(levels(image_hydro_propSurfaceEntiteParSurfaceHER2_build_$plot$layers[[1]]$data$var_cut_),
                levels(image_9_SMASH_propSurfaceEntiteParSurfaceHER2_build_$plot$layers[[1]]$data$var_cut_)) &
      identical(levels(image_hydro_NbStationsPour1000km2_build_$plot$layers[[1]]$data$var_cut_),
                levels(image_9_SMASH_NbStationsPour1000km2_build_$plot$layers[[1]]$data$var_cut_)))){
  stop("Les légendes des graphes que vous essayez de réunir ne sont pas identiques entre elles.")
}

# Combinaison des graphiques avec cowplot
# combined_plots <- cowplot::plot_grid("",image_onde_points_,image_hydro_points_,
#                                      image_1_CTRIP_points_,image_2_EROS_points_,image_3_GRSD_points_,image_4_J2000_points_,
#                                      
#                                      legend_hydro_propSurfaceEntiteParSurfaceHER2,image_onde_propSurfaceEntiteParSurfaceHER2_,image_hydro_propSurfaceEntiteParSurfaceHER2_,
#                                      image_1_CTRIP_propSurfaceEntiteParSurfaceHER2_,image_2_EROS_propSurfaceEntiteParSurfaceHER2_,image_3_GRSD_propSurfaceEntiteParSurfaceHER2_,image_4_J2000_propSurfaceEntiteParSurfaceHER2_,
#                                      
#                                      legend_hydro_NbStationsPour1000km2,image_onde_NbStationsPour1000km2_,image_hydro_NbStationsPour1000km2_,
#                                      image_1_CTRIP_NbStationsPour1000km2_,image_2_EROS_NbStationsPour1000km2_,image_3_GRSD_NbStationsPour1000km2_,image_4_J2000_NbStationsPour1000km2_,
#                                      
#                                      nrow = 3, align = "hv", rel_widths = c(1,2,2,2,2,2,2)) + theme_void()


# combined_plots <- cowplot::plot_grid("",
#                                      image_5_MORDORSD_points_,image_6_MORDORTS_points_,image_7_ORCHIDEE_points_,image_8_SIM2_points_,image_9_SMASH_points_,
# 
#                                      legend_hydro_propSurfaceEntiteParSurfaceHER2,
#                                      image_5_MORDORSD_propSurfaceEntiteParSurfaceHER2_,image_6_MORDORTS_propSurfaceEntiteParSurfaceHER2_,image_7_ORCHIDEE_propSurfaceEntiteParSurfaceHER2_,image_8_SIM2_propSurfaceEntiteParSurfaceHER2_,image_9_SMASH_propSurfaceEntiteParSurfaceHER2_,
# 
#                                      legend_hydro_NbStationsPour1000km2,
#                                      image_5_MORDORSD_NbStationsPour1000km2_,image_6_MORDORTS_NbStationsPour1000km2_,image_7_ORCHIDEE_NbStationsPour1000km2_,image_8_SIM2_NbStationsPour1000km2_,image_9_SMASH_NbStationsPour1000km2_,
# 
#                                      nrow = 3, align = "hv", rel_widths = c(1,2,2,2,2,2)) + theme_void()

combined_plots <- cowplot::plot_grid("",image_onde_points_,image_hydro_points_,
                                     image_1_CTRIP_points_,
                                     # image_2_EROS_points_,
                                     image_3_GRSD_points_,
                                     image_4_J2000_points_,
                                     image_7_ORCHIDEE_points_,
                                     image_9_SMASH_points_,
                                     
                                     legend_hydro_propSurfaceEntiteParSurfaceHER2,image_onde_propSurfaceEntiteParSurfaceHER2_,image_hydro_propSurfaceEntiteParSurfaceHER2_,
                                     image_1_CTRIP_propSurfaceEntiteParSurfaceHER2_,
                                     # image_2_EROS_propSurfaceEntiteParSurfaceHER2_,
                                     image_3_GRSD_propSurfaceEntiteParSurfaceHER2_,
                                     image_4_J2000_propSurfaceEntiteParSurfaceHER2_,
                                     image_7_ORCHIDEE_propSurfaceEntiteParSurfaceHER2_,
                                     image_9_SMASH_propSurfaceEntiteParSurfaceHER2_,
                                     
                                     legend_hydro_NbStationsPour1000km2,image_onde_NbStationsPour1000km2_,image_hydro_NbStationsPour1000km2_,
                                     image_1_CTRIP_NbStationsPour1000km2_,
                                     # image_2_EROS_NbStationsPour1000km2_,
                                     image_3_GRSD_NbStationsPour1000km2_,
                                     image_4_J2000_NbStationsPour1000km2_,
                                     image_7_ORCHIDEE_NbStationsPour1000km2_,
                                     image_9_SMASH_NbStationsPour1000km2_,
                                     
                                     nrow = 3, align = "hv", rel_widths = c(1,
                                                                            1.5,
                                                                            1.5,
                                                                            1.5,
                                                                            1.5,
                                                                            1.5,
                                                                            1.5,
                                                                            1.5)) + theme_void()
# nrow = 3, align = "hv", rel_widths = c(1,2,2,2,2,2,2,2)) + theme_void()



# Ajouter un titre général au-dessus des graphes combinés
title <- ggdraw() + draw_label("Data description", fontface = "bold", x = 0.5, hjust = 0.5, size = 30)

# Combinaison du titre et du graphique
# final_plot_with_title <- cowplot::plot_grid(title, final_plot, ncol = 1, rel_heights = c(0.1, 1)) +

# Afficher le graphique combiné avec la légende commune et le titre
# x11()
# png("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230926/Cartes_MergeDonneesEntree_Part1_1_20230926.png",
png("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Merge/Cartes_MergeDonneesEntree_Part1_1_20240124.png",
    width = 1600,
    height = 800,
    units = "px", pointsize = 12)
# png("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Cartes_MergeDonneesEntree_Part2_1_20230914.png",
#     width = 1600, height = 800,
#     units = "px", pointsize = 12)
print(combined_plots)
dev.off()

# pdf("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230926/Cartes_MergeDonneesEntree_Part1_1_20230926.pdf",
#     width = 20, height = 14)
# pdf("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Cartes_MergeDonneesEntree_Part2_1_20230914.pdf",
#     width = 20, height = 14)
# pdf("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20231121/Cartes_MergeDonneesEntree_Part1_1_20231121.pdf",
pdf("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240109/Merge/Cartes_MergeDonneesEntree_Part1_2_20240124.pdf",
    width = 20, height = 14)
print(combined_plots)
dev.off()


# Optionnel : Sauvegarder le graphique combiné au format PDF
# ggsave("combined_plot.pdf", combined_plots, width = 10, height = 12)
