source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/6_RunsEtudeFrance_CorrectionImportOnde_20230607/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")

# Charger les bibliothèques
library(png)
library(grid)
library(ggplot2)
library(cowplot)
library(gridExtra)

### Stations Hydrometriques ###
chemin_hydro_points_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240405/Carte_PointsStationsHydro_sansEtiq_English_1_20240329.rds"
chemin_hydro_PropSurfaceEntiteParSurfaceHER2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240405/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_English_1_20240329_sansTxt_sansEt.rds"
chemin_hydro_NbStationsPour1000km2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/MapVersionExclusions_SurfacesStationsHydro_v20240405/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_tab7ToutesExclusions1_sansEtiq_English_1_20240329_sansTxt_sansEt.rds"

### Onde ###
chemin_onde_points_ <- "/home/tjaouen/Documents/Input/ONDE/Data_DatesAjustees/MapSitesOndeDisponibles/Version_20240405/Carte_PointsStationsOnde_sansEtiq_English_1_20240314.rds"
chemin_onde_PropSurfaceEntiteParSurfaceHER2_ <- "/home/tjaouen/Documents/Input/ONDE/Data_DatesAjustees/MapSitesOndeDisponibles/Version_20240405/Carte_RepartitionSitesONDEHER2hyb_SumSurfacePondSurfHER2_sansEtiq_English_1_20240314_sansTxt_sansEt.rds"
chemin_onde_NbStationsPour1000km2_ <- "/home/tjaouen/Documents/Input/ONDE/Data_DatesAjustees/MapSitesOndeDisponibles/Version_20240405/Carte_RepartitionSitesONDEHER2hyb_NbStationsOndeProp1000SurfHER2_sansEtiq_English_1_20240314_sansTxt_sansEt.rds"

### Modeles ###
chemin_1_CTRIP_points_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240405/Carte_PointsStations_CTRIP_sansEtiq_English_1_20240318.rds"
chemin_1_CTRIP_PropSurfaceEntiteParSurfaceHER2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240405/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_CTRIP_sansEtiq_English_1_20240318_sansTxt_sansEt.rds"
chemin_1_CTRIP_NbStationsPour1000km2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240405/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_CTRIP_sansEtiq_English_1_20240318_sansTxt_sansEt.rds"

chemin_3_GRSD_points_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240405/Carte_PointsStations_GRSD_sansEtiq_English_1_20240318.rds"
chemin_3_GRSD_PropSurfaceEntiteParSurfaceHER2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240405/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_GRSD_sansEtiq_English_1_20240318_sansTxt_sansEt.rds"
chemin_3_GRSD_NbStationsPour1000km2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240405/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_GRSD_sansEtiq_English_1_20240318_sansTxt_sansEt.rds"

chemin_4_J2000_points_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240405/Carte_PointsStations_J2000_sansEtiq_English_1_20240318.rds"
chemin_4_J2000_PropSurfaceEntiteParSurfaceHER2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240405/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_log_sansStatSup2000_J2000_sansEtiq_English_1_20240318_sansTxt_sansEt.rds"
chemin_4_J2000_NbStationsPour1000km2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240405/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_J2000_sansEtiq_English_1_20240318_sansTxt_sansEt.rds"

chemin_7_ORCHIDEE_points_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240405/Carte_PointsStations_ORCHIDEE_sansEtiq_English_1_20240318.rds"
chemin_7_ORCHIDEE_PropSurfaceEntiteParSurfaceHER2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240405/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_ORCHIDEE_sansEtiq_English_1_20240318_sansTxt_sansEt.rds"
chemin_7_ORCHIDEE_NbStationsPour1000km2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240405/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_ORCHIDEE_sansEtiq_English_1_20240318_sansTxt_sansEt.rds"

chemin_9_SMASH_points_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240405/Carte_PointsStations_SMASH_sansEtiq_English_1_20240318.rds"
chemin_9_SMASH_PropSurfaceEntiteParSurfaceHER2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240405/Carte_RepartitionStationsHydroHER2hyb_SumSurfacePondSurfHER2_sansStatSup2000_SMASH_sansEtiq_English_1_20240318_sansTxt_sansEt.rds"
chemin_9_SMASH_NbStationsPour1000km2_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240405/Carte_RepartitionStationsHydroHER2hyb_NbStationsProp1000SurfHER2_sansStatSup2000_SMASH_sansEtiq_English_1_20240318_sansTxt_sansEt.rds"


### Output file ###
output_name_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240405/Merge/Merge_tab7ToutesExclusions1_sansEtiq_English_1_20231121.rds"

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
image_3_GRSD_points_ <- readRDS(chemin_3_GRSD_points_)
image_3_GRSD_propSurfaceEntiteParSurfaceHER2_ <- readRDS(chemin_3_GRSD_PropSurfaceEntiteParSurfaceHER2_)
image_3_GRSD_NbStationsPour1000km2_ <- readRDS(chemin_3_GRSD_NbStationsPour1000km2_)
image_4_J2000_points_ <- readRDS(chemin_4_J2000_points_)
image_4_J2000_propSurfaceEntiteParSurfaceHER2_ <- readRDS(chemin_4_J2000_PropSurfaceEntiteParSurfaceHER2_)
image_4_J2000_NbStationsPour1000km2_ <- readRDS(chemin_4_J2000_NbStationsPour1000km2_)
image_7_ORCHIDEE_points_ <- readRDS(chemin_7_ORCHIDEE_points_)
image_7_ORCHIDEE_propSurfaceEntiteParSurfaceHER2_ <- readRDS(chemin_7_ORCHIDEE_PropSurfaceEntiteParSurfaceHER2_)
image_7_ORCHIDEE_NbStationsPour1000km2_ <- readRDS(chemin_7_ORCHIDEE_NbStationsPour1000km2_)
image_9_SMASH_points_ <- readRDS(chemin_9_SMASH_points_)
image_9_SMASH_propSurfaceEntiteParSurfaceHER2_ <- readRDS(chemin_9_SMASH_PropSurfaceEntiteParSurfaceHER2_)
image_9_SMASH_NbStationsPour1000km2_ <- readRDS(chemin_9_SMASH_NbStationsPour1000km2_)

# Function #
prepareSubgraph <- function(graph_, removeLegend = T, legend_position_ = "top", removeLayers = F){
  
  graph_$layers[[1]]$aes_params$size=0.1
  
  if (removeLayers){
    graph_$layers <- graph_$layers[-c(length(graph_$layers)-1,length(graph_$layers))]
  }
  
  graph_nl_ <- graph_ + theme(plot.title = element_blank(),
                              plot.margin = unit(c(-1.2,-0.3,-1.2,-0.3), 'cm'),
                              text = element_text(size = 12),
                              legend.text = element_text(size = 12),
                              
                              panel.grid = element_blank(),
                              panel.border = element_blank(),
                              # panel.grid = element_blank(),
                              
                              # axis.text.x = element_text(size = 11),
                              # axis.text.y = element_text(size = 11),
                              # axis.ticks.length = unit(0.2,"cm"),
                              # legend.position = "none",
                              plot.subtitle = element_blank(),
                              rect = element_blank())
  
  if (removeLegend){
    graph_nl_ <- graph_nl_ + theme(legend.position = "none")#,
    # plot.title = element_text(size = 15),
    # text = element_text(size = 12),
    # legend.text = element_text(size = 12),
    # plot.margin = unit(c(-0.3,-0.3,-0.3,-0.3), 'cm'))
  }else{
    graph_nl_ <- graph_nl_ + theme(legend.key.height = unit(0.7, "cm"),
                                   legend.key.width = unit(0.3, "cm"),
                                   legend.text = element_text(size = 12),
                                   legend.position = legend_position_)
  }
  
  return(graph_nl_)
}

### Echelle nord ###
scaleNorth_ = readRDS("/home/tjaouen/Documents/Input/FondsCartes/EchelleNord/EchelleNordGraph_1_20240308.rds")
scaleNorth_ <- scaleNorth_ + theme(plot.margin = unit(c(-0.3,-0.3,-0.3,-0.3), 'cm'))
scaleNorth_$layers[[2]]$aes_params$location = "br"
scaleNorth_$layers[[3]]$aes_params$location = "br"
scaleNorth_$layers[[2]]$geom_params$pad_x = unit(0.5,"cm")
scaleNorth_$layers[[2]]$geom_params$pad_y = unit(0.5,"cm")
scaleNorth_$layers[[3]]$geom_params$pad_x = unit(4,"cm")
scaleNorth_$layers[[3]]$geom_params$pad_y = unit(0.2,"cm")

### Images HYDRO ###
# image_hydro_points_ <- image_hydro_points_+ theme(legend.text = element_text(size = 12), plot.title = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank(), axis.title = element_blank(), legend.position = "top", text = element_text(size = 12))
# image_hydro_propSurfaceEntiteParSurfaceHER2_ <- image_hydro_propSurfaceEntiteParSurfaceHER2_ + theme(legend.text = element_text(size = 12), plot.title = element_text(size = 15), text = element_text(size = 12))
# image_hydro_NbStationsPour1000km2_ <- image_hydro_NbStationsPour1000km2_ + theme(legend.text = element_text(size = 12), plot.title = element_text(size = 15), text = element_text(size = 12))
image_hydro_points_ <- prepareSubgraph(image_hydro_points_, removeLegend = F, removeLayers = T)

# Ajouter une légende unique à partir d'un des graphiques
legend_hydro_points <- cowplot::get_legend(image_hydro_points_)

image_hydro_propSurfaceEntiteParSurfaceHER2_ <- prepareSubgraph(image_hydro_propSurfaceEntiteParSurfaceHER2_, removeLegend = F, legend_position_ = c(0.5,0.5))
# image_hydro_propSurfaceEntiteParSurfaceHER2_$theme$legend.title <- element_text(size = 12, vjust = 5, hjust = 0, colour = "#454547")
# image_hydro_propSurfaceEntiteParSurfaceHER2_$theme$legend.title.align <- 0.5
image_hydro_propSurfaceEntiteParSurfaceHER2_$theme$legend.position <- c(0.5,0.5)
legend_hydro_propSurfaceEntiteParSurfaceHER2 <- cowplot::get_legend(image_hydro_propSurfaceEntiteParSurfaceHER2_)
image_hydro_propSurfaceEntiteParSurfaceHER2_ <- prepareSubgraph(image_hydro_propSurfaceEntiteParSurfaceHER2_, removeLayers = T)

image_hydro_NbStationsPour1000km2_ <- prepareSubgraph(image_hydro_NbStationsPour1000km2_, removeLegend = F, legend_position_ = c(0.5,0.5))
# image_hydro_NbStationsPour1000km2_$theme$legend.title <- element_text(size = 12, vjust = 20, hjust = 0, colour = "#454547")
# image_hydro_NbStationsPour1000km2_$theme$legend.title.align <- 0.5
image_hydro_NbStationsPour1000km2_$theme$legend.position <- c(0.5,0.5)
legend_hydro_NbStationsPour1000km2 <- cowplot::get_legend(image_hydro_NbStationsPour1000km2_)
image_hydro_NbStationsPour1000km2_ <- prepareSubgraph(image_hydro_NbStationsPour1000km2_, removeLayers = T)

### Images ONDE ###
image_onde_points_ <- prepareSubgraph(image_onde_points_, removeLegend = F, removeLayers = T)
image_onde_propSurfaceEntiteParSurfaceHER2_ <- prepareSubgraph(image_onde_propSurfaceEntiteParSurfaceHER2_, removeLegend = F, legend_position_ = c(0.5,0.5))
legend_onde_propSurfaceEntiteParSurfaceHER2 <- cowplot::get_legend(image_onde_propSurfaceEntiteParSurfaceHER2_)
image_onde_propSurfaceEntiteParSurfaceHER2_ <- prepareSubgraph(image_onde_propSurfaceEntiteParSurfaceHER2_, removeLayers = T)

image_onde_NbStationsPour1000km2_ <- prepareSubgraph(image_onde_NbStationsPour1000km2_)
legend_onde_NbStationsPour1000km2 <- cowplot::get_legend(image_onde_NbStationsPour1000km2_)
image_onde_NbStationsPour1000km2_ <- prepareSubgraph(image_onde_NbStationsPour1000km2_, removeLayers = T)


# image_1_CTRIP_points_ <- image_1_CTRIP_points_ + theme(plot.title = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank(), axis.title = element_blank(), legend.position = "top", text = element_text(size = 12), plot.margin = unit(c(-0.3,-0.3,-0.3,-0.3), 'cm'))
# image_1_CTRIP_propSurfaceEntiteParSurfaceHER2_ <- image_1_CTRIP_propSurfaceEntiteParSurfaceHER2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12), plot.margin = unit(c(-0.3,-0.3,-0.3,-0.3), 'cm'))
# image_1_CTRIP_NbStationsPour1000km2_ <- image_1_CTRIP_NbStationsPour1000km2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))
# image_3_GRSD_points_ <- image_3_GRSD_points_+ theme(plot.title = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank(), axis.title = element_blank(), legend.position = "top", text = element_text(size = 12))
# image_3_GRSD_propSurfaceEntiteParSurfaceHER2_ <- image_3_GRSD_propSurfaceEntiteParSurfaceHER2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))
# image_3_GRSD_NbStationsPour1000km2_ <- image_3_GRSD_NbStationsPour1000km2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))
# image_4_J2000_points_ <- image_4_J2000_points_+ theme(plot.title = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank(), axis.title = element_blank(), legend.position = "top", text = element_text(size = 12))
# image_4_J2000_propSurfaceEntiteParSurfaceHER2_ <- image_4_J2000_propSurfaceEntiteParSurfaceHER2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))
# image_4_J2000_NbStationsPour1000km2_ <- image_4_J2000_NbStationsPour1000km2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))
# image_7_ORCHIDEE_points_ <- image_7_ORCHIDEE_points_+ theme(plot.title = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank(), axis.title = element_blank(), legend.position = "top", text = element_text(size = 12))
# image_7_ORCHIDEE_propSurfaceEntiteParSurfaceHER2_ <- image_7_ORCHIDEE_propSurfaceEntiteParSurfaceHER2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))
# image_7_ORCHIDEE_NbStationsPour1000km2_ <- image_7_ORCHIDEE_NbStationsPour1000km2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))
# image_9_SMASH_points_ <- image_9_SMASH_points_+ theme(plot.title = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank(), axis.title = element_blank(), legend.position = "top", text = element_text(size = 12))
# image_9_SMASH_propSurfaceEntiteParSurfaceHER2_ <- image_9_SMASH_propSurfaceEntiteParSurfaceHER2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))
# image_9_SMASH_NbStationsPour1000km2_ <- image_9_SMASH_NbStationsPour1000km2_ + theme(legend.position = "none", plot.title = element_text(size = 15), text = element_text(size = 12))
image_1_CTRIP_points_ <- prepareSubgraph(image_1_CTRIP_points_, removeLegend = F, removeLayers = T)
image_1_CTRIP_propSurfaceEntiteParSurfaceHER2_ <- prepareSubgraph(image_1_CTRIP_propSurfaceEntiteParSurfaceHER2_, removeLayers = T)
image_1_CTRIP_NbStationsPour1000km2_ <- prepareSubgraph(image_1_CTRIP_NbStationsPour1000km2_, removeLayers = T)
image_3_GRSD_points_ <- prepareSubgraph(image_3_GRSD_points_, removeLegend = F, removeLayers = T)
image_3_GRSD_propSurfaceEntiteParSurfaceHER2_ <- prepareSubgraph(image_3_GRSD_propSurfaceEntiteParSurfaceHER2_, removeLayers = T)
image_3_GRSD_NbStationsPour1000km2_ <- prepareSubgraph(image_3_GRSD_NbStationsPour1000km2_, removeLayers = T)
image_4_J2000_points_ <- prepareSubgraph(image_4_J2000_points_, removeLegend = F, removeLayers = T)
image_4_J2000_propSurfaceEntiteParSurfaceHER2_ <- prepareSubgraph(image_4_J2000_propSurfaceEntiteParSurfaceHER2_, removeLayers = T)
image_4_J2000_NbStationsPour1000km2_ <- prepareSubgraph(image_4_J2000_NbStationsPour1000km2_, removeLayers = T)
image_7_ORCHIDEE_points_ <- prepareSubgraph(image_7_ORCHIDEE_points_, removeLegend = F, removeLayers = T)
image_7_ORCHIDEE_propSurfaceEntiteParSurfaceHER2_ <- prepareSubgraph(image_7_ORCHIDEE_propSurfaceEntiteParSurfaceHER2_, removeLayers = T)
image_7_ORCHIDEE_NbStationsPour1000km2_ <- prepareSubgraph(image_7_ORCHIDEE_NbStationsPour1000km2_, removeLayers = T)
image_9_SMASH_points_ <- prepareSubgraph(image_9_SMASH_points_, removeLegend = F, removeLayers = T)
image_9_SMASH_propSurfaceEntiteParSurfaceHER2_ <- prepareSubgraph(image_9_SMASH_propSurfaceEntiteParSurfaceHER2_, removeLayers = T)
image_9_SMASH_NbStationsPour1000km2_ <- prepareSubgraph(image_9_SMASH_NbStationsPour1000km2_, removeLayers = T)

# Changer les tailles des points
image_onde_points_$layers[[2]]$aes_params$size = 0.3
image_hydro_points_$layers[[2]]$aes_params$size = 0.3
image_1_CTRIP_points_$layers[[2]]$aes_params$size = 0.3
image_3_GRSD_points_$layers[[2]]$aes_params$size = 0.3
image_4_J2000_points_$layers[[2]]$aes_params$size = 0.3
image_7_ORCHIDEE_points_$layers[[2]]$aes_params$size = 0.3
image_9_SMASH_points_$layers[[2]]$aes_params$size = 0.3

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
image_3_GRSD_points_build_ = ggplot_build(image_onde_points_)
image_3_GRSD_propSurfaceEntiteParSurfaceHER2_build_ = ggplot_build(image_onde_propSurfaceEntiteParSurfaceHER2_)
image_3_GRSD_NbStationsPour1000km2_build_ = ggplot_build(image_onde_NbStationsPour1000km2_)
image_4_J2000_points_build_ = ggplot_build(image_onde_points_)
image_4_J2000_propSurfaceEntiteParSurfaceHER2_build_ = ggplot_build(image_onde_propSurfaceEntiteParSurfaceHER2_)
image_4_J2000_NbStationsPour1000km2_build_ = ggplot_build(image_onde_NbStationsPour1000km2_)
image_7_ORCHIDEE_points_build_ = ggplot_build(image_onde_points_)
image_7_ORCHIDEE_propSurfaceEntiteParSurfaceHER2_build_ = ggplot_build(image_onde_propSurfaceEntiteParSurfaceHER2_)
image_7_ORCHIDEE_NbStationsPour1000km2_build_ = ggplot_build(image_onde_NbStationsPour1000km2_)
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
if (!(identical(levels(image_hydro_propSurfaceEntiteParSurfaceHER2_build_$plot$layers[[1]]$data$var_cut_),
                levels(image_7_ORCHIDEE_propSurfaceEntiteParSurfaceHER2_build_$plot$layers[[1]]$data$var_cut_)) &
      identical(levels(image_hydro_NbStationsPour1000km2_build_$plot$layers[[1]]$data$var_cut_),
                levels(image_7_ORCHIDEE_NbStationsPour1000km2_build_$plot$layers[[1]]$data$var_cut_)))){
  stop("Les légendes des graphes que vous essayez de réunir ne sont pas identiques entre elles.")
}
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

h_line1_ = 7
h_line2_ = 6
h_graph_ = 26
h_line4_ = 3
h_lineScale_ = 4
w_col1_ = 14
w_col2_ = 26
w_col3_ = 26
w_col4_ = 26
w_col5_ = 26
w_col6_ = 26
w_col7_ = 26
w_col8_ = 26

# h_line1_ = 8
# h_lineScale_ = 6
# h_line2_ = 5
# h_graph_ = 26
# h_line4_ = 3
# w_col1_ = 2
# w_col2_ = 26
# w_col3_ = 26
# w_col4_ = 26
# w_col5_ = 26
# w_col6_ = 3



grid_txt_ratio_ <- grid.arrange(
  textGrob("Ratio"),
  textGrob("(unitless)"),
  
  nrow = 2,
  heights = c(h_graph_/20,
              h_graph_/20),
  padding = unit(2,"cm")
  
)

grid_legend_prop_ <- grid.arrange(
  grid_txt_ratio_,
  legend_hydro_propSurfaceEntiteParSurfaceHER2,
  
  nrow = 2,
  heights = c(h_graph_*2/20,h_graph_*18/20),
  padding = unit(0, "cm")  # ajuster la marge
)

grid_txt_nb_ <- grid.arrange(
  textGrob("Number of stations"),
  textGrob(expression("per 1000" ~km^2)),
  textGrob(expression("of HER2 (unitless)")),
  
  nrow = 3,
  heights = c(h_graph_/20,
              h_graph_/20,
              h_graph_/20),
  padding = unit(2,"cm")
  
)

grid_legend_nb_ <- grid.arrange(
  grid_txt_nb_,
  legend_hydro_NbStationsPour1000km2,
  
  nrow = 2,
  heights = c(h_graph_*3/20,
              h_graph_*17/20),
  padding = unit(0, "cm")  # ajuster la marge
)

grid_1_ <- grid.arrange(
  
  # Ligne 5
  arrangeGrob(
    nullGrob(),
    image_onde_points_,
    image_hydro_points_,
    image_1_CTRIP_points_,
    image_3_GRSD_points_,
    image_4_J2000_points_,
    image_7_ORCHIDEE_points_,
    image_9_SMASH_points_,
    
    ncol = 8,
    widths = c(w_col1_,w_col2_,w_col3_,w_col4_,w_col5_,w_col6_,w_col7_,w_col8_),
    padding = unit(0, "cm")),
  
  # Ligne 4
  arrangeGrob(
    grid_legend_prop_,
    image_onde_propSurfaceEntiteParSurfaceHER2_,
    image_hydro_propSurfaceEntiteParSurfaceHER2_,
    image_1_CTRIP_propSurfaceEntiteParSurfaceHER2_,
    image_3_GRSD_propSurfaceEntiteParSurfaceHER2_,
    image_4_J2000_propSurfaceEntiteParSurfaceHER2_,
    image_7_ORCHIDEE_propSurfaceEntiteParSurfaceHER2_,
    image_9_SMASH_propSurfaceEntiteParSurfaceHER2_,
    
    ncol = 8,
    widths = c(w_col1_,w_col2_,w_col3_,w_col4_,w_col5_,w_col6_,w_col7_,w_col8_),
    padding = unit(0, "cm")),
  
  # Ligne 5
  arrangeGrob(
    grid_legend_nb_,
    image_onde_NbStationsPour1000km2_,
    image_hydro_NbStationsPour1000km2_,
    image_1_CTRIP_NbStationsPour1000km2_,
    image_3_GRSD_NbStationsPour1000km2_,
    image_4_J2000_NbStationsPour1000km2_,
    image_7_ORCHIDEE_NbStationsPour1000km2_,
    image_9_SMASH_NbStationsPour1000km2_,
    
    ncol = 8,
    widths = c(w_col1_,w_col2_,w_col3_,w_col4_,w_col5_,w_col6_,w_col7_,w_col8_),
    padding = unit(0, "cm")),
  
  
  arrangeGrob(
    nullGrob(),
    nullGrob(),
    nullGrob(),
    nullGrob(),
    nullGrob(),
    nullGrob(),
    nullGrob(),
    # scaleNorth_,
    ggplotGrob(scaleNorth_ +
                 ylim(max(layer_scales(scaleNorth_)$y$get_limits())-(max(layer_scales(scaleNorth_)$y$get_limits())-min(layer_scales(scaleNorth_)$y$get_limits()))*h_lineScale_/h_graph_,
                      max(layer_scales(scaleNorth_)$y$get_limits()))),
    # ############ A CHANGER ICI ############
    ncol = 8,
    widths = c(w_col1_,w_col2_,w_col3_,w_col4_,w_col5_,w_col6_,w_col7_,w_col8_),
    padding = unit(0, "cm")),
  
  # nrow = 1,
  # nrow = 3,
  nrow = 4,
  # heights = c(h_graph_),
  # heights = c(h_graph_,h_graph_,h_graph_),
  heights = c(h_graph_,h_graph_,h_graph_,h_lineScale_),
  padding = unit(0, "cm")  # ajuster la marge
)

# Afficher le graphique combiné avec la légende commune et le titre
# x11()
# png("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230926/Cartes_MergeDonneesEntree_Part1_1_20230926.png",
# png("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240318/Merge/Cartes_MergeDonneesEntree_Part1_1_20240124.png",
# png("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240318/Merge/Cartes_MergeDonneesEntree_Part1_1_20240328.png",
png("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240405/Merge/Cartes_MergeDonneesEntree_Part1_1_20240405.png",
    width = 1600,
    height = 800,
    units = "px", pointsize = 12)
grid.draw(grid_1_)
dev.off()

# pdf("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230926/Cartes_MergeDonneesEntree_Part1_1_20230926.pdf",
#     width = 20, height = 14)
# pdf("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20230911/Cartes_MergeDonneesEntree_Part2_1_20230914.pdf",
#     width = 20, height = 14)
# pdf("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/1_MapParModele_SurfacesStationsHydro_20231121/Cartes_MergeDonneesEntree_Part1_1_20231121.pdf",
# pdf("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240318/Merge/Cartes_MergeDonneesEntree_Part1_2_20240124.pdf",
# pdf("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240318/Merge/Cartes_MergeDonneesEntree_Part1_2_20240328.pdf",
pdf("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/1_MapParModele_SurfacesStationsHydro_20240405/Merge/Cartes_MergeDonneesEntree_Part1_2_20240405.pdf",
    width = 20, height = 14)
print(grid_1_)
dev.off()

