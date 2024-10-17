library(grid)
library(ggplot2)
library(gridExtra)

# global_1_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/Global/NbJoursSup20/rcp45and85/1_ChroniquesPFI_rcp45and85_1_20240526.rds"
# global_1_ <- readRDS(global_1_)

prepareSubgraph <- function(graph_, pos_, removeLegend = T){
  
  pattern_rcp_replace_ = data.frame(aRemplacer = c(NA,"rcp85","rcp45","rcp26"),
                                    remplacement = c("Historical","RCP\n8.5","RCP\n4.5","RCP\n2.6"))
  graph_nl_ <- graph_ + theme(#plot.title = element_text(size = 11),
    
    plot.title = element_text(vjust = 0, color = "grey38", size = 16*ratio_epaisseurs_),
    panel.grid.major.y = element_line(color = "#dcdad9", size = 0.5),
    # panel.grid.minor.y = element_line(color = "#dcdad9", size = 0),
    # panel.grid.major.y = element_blank(),
    panel.grid.minor.y = element_blank(),
    
    
    # plot.margin = unit(c(-0.3,-0.3,-0.3,-0.3), 'cm'),
    axis.text.x = element_text(size = 11),
    axis.text.y = element_text(size = 11),
    axis.ticks.length = unit(0.2,"cm"),
    # legend.position = "none",
    plot.subtitle = element_blank())
  # graph_nl_$layers <- graph_nl_$layers[-c(2,3)]
  graph_nl_$layers[[1]]$aes_params$size <- 0.7
  # graph_nl_$layers[[1]]$aes_params$size = 0.18
  # graph_nl_$layers[[2]]$geom_params$height = 0
  # graph_nl_$layers[[3]]$geom_params$height = 0
  
  if (length(graph_nl_$layers) == 2){
    if ("linewidth" %in% names(graph_nl_$layers[[2]]$aes_params)){
      graph_nl_$layers[[2]]$aes_params$linewidth = 2.5
    }else{
      graph_nl_$layers[[2]]$aes_params = 1.5
    }
  }
  
  graph_nl_$theme$plot.margin = unit(c(0.3,0.3,0.3,0.3),"cm")
  
  if (removeLegend){
    graph_nl_ <- graph_nl_ + theme(legend.position = "none")
  }else{
    graph_nl_ <- graph_nl_ + theme(legend.text = element_text(size = 11),
                                   legend.title = element_text(size = 11, face = "bold")) +
      guides(color = guide_legend(keyheight = unit(1,"cm"),
                                  ncol = 2))
  }
  
  return(graph_nl_)
}


global_GCMRCM_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/Global/NbJoursSup20/rcp45and85/7_ChroniquesPFI_EffectGCMRCM_rcp45and85_1_20240526.rds"
global_HM_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/Global/NbJoursSup20/rcp45and85/8_ChroniquesPFI_EffectHM_rcp45and85_1_20240526.rds"
global_RCP_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/Global/NbJoursSup20/rcp45and85/8_ChroniquesPFI_EffectRCP_rcp45and85_1_20240526.rds"
global_MeanChangeAndUncertainties_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/Global/NbJoursSup20/rcp45and85/10_ChroniquesPFI_MeanChangeAndUncertainties_rcp45and85_1_20240526.rds"

HER13_GCMRCM_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER13/NbJoursSup20/rcp45and85_HER13/7_ChroniquesPFI_EffectGCMRCM_NbJoursSup20_rcp45and85_HER13_1_20240526.rds"
HER13_HM_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER13/NbJoursSup20/rcp45and85_HER13/8_ChroniquesPFI_EffectHM_NbJoursSup20_rcp45and85_HER13_1_20240526.rds"
HER13_RCP_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER13/NbJoursSup20/rcp45and85_HER13/8_ChroniquesPFI_EffectRCP_NbJoursSup20_rcp45and85_HER13_1_20240526.rds"
HER13_MeanChangeAndUncertainties_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER13/NbJoursSup20/rcp45and85_HER13/10_ChroniquesPFI_MeanChangeAndUncertainties_NbJoursSup20_rcp45and85_HER13_1_20240526.rds"

HER57_GCMRCM_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER57/NbJoursSup20/rcp45and85_HER57/7_ChroniquesPFI_EffectGCMRCM_NbJoursSup20_rcp45and85_HER57_1_20240526.rds"
HER57_HM_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER57/NbJoursSup20/rcp45and85_HER57/8_ChroniquesPFI_EffectHM_NbJoursSup20_rcp45and85_HER57_1_20240526.rds"
HER57_RCP_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER57/NbJoursSup20/rcp45and85_HER57/8_ChroniquesPFI_EffectRCP_NbJoursSup20_rcp45and85_HER57_1_20240526.rds"
HER57_MeanChangeAndUncertainties_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER57/NbJoursSup20/rcp45and85_HER57/10_ChroniquesPFI_MeanChangeAndUncertainties_NbJoursSup20_rcp45and85_HER57_1_20240526.rds"

HER81_GCMRCM_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER81/NbJoursSup20/rcp45and85_HER81/7_ChroniquesPFI_EffectGCMRCM_NbJoursSup20_rcp45and85_HER81_1_20240526.rds"
HER81_HM_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER81/NbJoursSup20/rcp45and85_HER81/8_ChroniquesPFI_EffectHM_NbJoursSup20_rcp45and85_HER81_1_20240526.rds"
HER81_RCP_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER81/NbJoursSup20/rcp45and85_HER81/8_ChroniquesPFI_EffectRCP_NbJoursSup20_rcp45and85_HER81_1_20240526.rds"
HER81_MeanChangeAndUncertainties_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER81/NbJoursSup20/rcp45and85_HER81/10_ChroniquesPFI_MeanChangeAndUncertainties_NbJoursSup20_rcp45and85_HER81_1_20240526.rds"

HER105_GCMRCM_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER105/NbJoursSup20/rcp45and85_HER105/7_ChroniquesPFI_EffectGCMRCM_NbJoursSup20_rcp45and85_HER105_1_20240526.rds"
HER105_HM_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER105/NbJoursSup20/rcp45and85_HER105/8_ChroniquesPFI_EffectHM_NbJoursSup20_rcp45and85_HER105_1_20240526.rds"
HER105_RCP_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER105/NbJoursSup20/rcp45and85_HER105/8_ChroniquesPFI_EffectRCP_NbJoursSup20_rcp45and85_HER105_1_20240526.rds"
HER105_MeanChangeAndUncertainties_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER105/NbJoursSup20/rcp45and85_HER105/10_ChroniquesPFI_MeanChangeAndUncertainties_NbJoursSup20_rcp45and85_HER105_1_20240526.rds"


global_GCMRCM_ <- readRDS(global_GCMRCM_)
global_HM_ <- readRDS(global_HM_)
global_RCP_ <- readRDS(global_RCP_)
global_MeanChangeAndUncertainties_ <- readRDS(global_MeanChangeAndUncertainties_)

HER13_GCMRCM_ <- readRDS(HER13_GCMRCM_)
HER13_HM_ <- readRDS(HER13_HM_)
HER13_RCP_ <- readRDS(HER13_RCP_)
HER13_MeanChangeAndUncertainties_ <- readRDS(HER13_MeanChangeAndUncertainties_)

HER57_GCMRCM_ <- readRDS(HER57_GCMRCM_)
HER57_HM_ <- readRDS(HER57_HM_)
HER57_RCP_ <- readRDS(HER57_RCP_)
HER57_MeanChangeAndUncertainties_ <- readRDS(HER57_MeanChangeAndUncertainties_)

HER81_GCMRCM_ <- readRDS(HER81_GCMRCM_)
HER81_HM_ <- readRDS(HER81_HM_)
HER81_RCP_ <- readRDS(HER81_RCP_)
HER81_MeanChangeAndUncertainties_ <- readRDS(HER81_MeanChangeAndUncertainties_)

HER105_GCMRCM_ <- readRDS(HER105_GCMRCM_)
HER105_HM_ <- readRDS(HER105_HM_)
HER105_RCP_ <- readRDS(HER105_RCP_)
HER105_MeanChangeAndUncertainties_ <- readRDS(HER105_MeanChangeAndUncertainties_)

### Prepare graphs ###
global_GCMRCM_ <- prepareSubgraph(global_GCMRCM_, pos_ = c(1,1), removeLegend = T)
global_HM_ <- prepareSubgraph(global_HM_, pos_ = c(2,1), removeLegend = T)
global_RCP_ <- prepareSubgraph(global_RCP_, pos_ = c(3,1), removeLegend = T)
global_MeanChangeAndUncertainties_ <- prepareSubgraph(global_MeanChangeAndUncertainties_, pos_ = c(4,1), removeLegend = T)

HER13_GCMRCM_ <- prepareSubgraph(HER13_GCMRCM_, pos_ = c(1,2), removeLegend = T)
HER13_HM_ <- prepareSubgraph(HER13_HM_, pos_ = c(2,2), removeLegend = T)
HER13_RCP_ <- prepareSubgraph(HER13_RCP_, pos_ = c(3,2), removeLegend = T)
HER13_MeanChangeAndUncertainties_ <- prepareSubgraph(HER13_MeanChangeAndUncertainties_, pos_ = c(4,2), removeLegend = T)

HER57_GCMRCM_ <- prepareSubgraph(HER57_GCMRCM_, pos_ = c(1,3), removeLegend = T)
HER57_HM_ <- prepareSubgraph(HER57_HM_, pos_ = c(2,3), removeLegend = T)
HER57_RCP_ <- prepareSubgraph(HER57_RCP_, pos_ = c(3,3), removeLegend = T)
HER57_MeanChangeAndUncertainties_ <- prepareSubgraph(HER57_MeanChangeAndUncertainties_, pos_ = c(4,3), removeLegend = T)

HER81_GCMRCM_ <- prepareSubgraph(HER81_GCMRCM_, pos_ = c(1,4), removeLegend = T)
HER81_HM_ <- prepareSubgraph(HER81_HM_, pos_ = c(2,4), removeLegend = T)
HER81_RCP_ <- prepareSubgraph(HER81_RCP_, pos_ = c(3,4), removeLegend = T)
HER81_MeanChangeAndUncertainties_ <- prepareSubgraph(HER81_MeanChangeAndUncertainties_, pos_ = c(4,4), removeLegend = T)

HER105_GCMRCM_ <- prepareSubgraph(HER105_GCMRCM_, pos_ = c(1,5), removeLegend = T)
HER105_HM_ <- prepareSubgraph(HER105_HM_, pos_ = c(2,5), removeLegend = T)
HER105_RCP_ <- prepareSubgraph(HER105_RCP_, pos_ = c(3,5), removeLegend = T)
HER105_MeanChangeAndUncertainties_ <- prepareSubgraph(HER105_MeanChangeAndUncertainties_, pos_ = c(4,5), removeLegend = T)


# global_GCMRCM_grob <- grid::rasterGrob(global_GCMRCM_, interpolate = TRUE)
# global_HM_grob <- grid::rasterGrob(global_HM_, interpolate = TRUE)
# global_MeanChangeAndUncertainties_grob <- grid::rasterGrob(global_MeanChangeAndUncertainties_, interpolate = TRUE)
# 
# HER13_GCMRCM_grob <- grid::rasterGrob(HER13_GCMRCM_, interpolate = TRUE)
# HER13_HM_grob <- grid::rasterGrob(HER13_HM_, interpolate = TRUE)
# HER13_MeanChangeAndUncertainties_grob <- grid::rasterGrob(HER13_MeanChangeAndUncertainties_, interpolate = TRUE)
# 
# HER57_GCMRCM_grob <- grid::rasterGrob(HER57_GCMRCM_, interpolate = TRUE)
# HER57_HM_grob <- grid::rasterGrob(HER57_HM_, interpolate = TRUE)
# HER57_MeanChangeAndUncertainties_grob <- grid::rasterGrob(HER57_MeanChangeAndUncertainties_, interpolate = TRUE)
# 
# HER81_GCMRCM_grob <- grid::rasterGrob(HER81_GCMRCM_, interpolate = TRUE)
# HER81_HM_grob <- grid::rasterGrob(HER81_HM_, interpolate = TRUE)
# HER81_MeanChangeAndUncertainties_grob <- grid::rasterGrob(HER81_MeanChangeAndUncertainties_, interpolate = TRUE)
# 
# HER105_GCMRCM_grob <- grid::rasterGrob(HER105_GCMRCM_, interpolate = TRUE)
# HER105_HM_grob <- grid::rasterGrob(HER105_HM_, interpolate = TRUE)
# HER105_MeanChangeAndUncertainties_grob <- grid::rasterGrob(HER105_MeanChangeAndUncertainties_, interpolate = TRUE)


h_line1_ <- 2
h_line2_ <- 10
h_line3_ <- 10
h_line4_ <- 10
h_line5_ <- 10
w_col1_ = 2
w_col2_ = 10
w_col3_ = 10
w_col4_ = 10
w_col5_ = 10
w_col6_ = 10

grid_1_ <- grid.arrange(
  
  arrangeGrob(
    nullGrob(),
    textGrob("France",
             gp = gpar(fontsize = 15,
                       # fontface = "bold",
                       col = "grey38"), vjust = 0.5),
    textGrob("HER 13",
             gp = gpar(fontsize = 15,
                       # fontface = "bold",
                       col = "grey38"), vjust = 0.5),
    textGrob("HER 57",
             gp = gpar(fontsize = 15,
                       # fontface = "bold",
                       col = "grey38"), vjust = 0.5),
    textGrob("HER 81",
             gp = gpar(fontsize = 15,
                       # fontface = "bold",
                       col = "grey38"), vjust = 0.5),
    textGrob("HER 105",
             gp = gpar(fontsize = 15,
                       # fontface = "bold",
                       col = "grey38"), vjust = 0.5),
    ncol = 6,
    widths = c(w_col1_,
               w_col2_,
               w_col3_,
               w_col4_,
               w_col5_,
               w_col6_),
    padding = unit(0, "cm")),
  
  arrangeGrob(
    textGrob("GCM+RCM effects",vjust = 1, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_), rot = 90),
    ggplotGrob(global_GCMRCM_),
    ggplotGrob(HER13_GCMRCM_),
    ggplotGrob(HER57_GCMRCM_),
    ggplotGrob(HER81_GCMRCM_),
    ggplotGrob(HER105_GCMRCM_),
    ncol = 6,
    widths = c(w_col1_,
               w_col2_,
               w_col3_,
               w_col4_,
               w_col5_,
               w_col6_),
    padding = unit(0, "cm")),
  
  arrangeGrob(
    textGrob("RCP effects",vjust = 1, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_), rot = 90),
    ggplotGrob(global_RCP_),
    ggplotGrob(HER13_RCP_),
    ggplotGrob(HER57_RCP_),
    ggplotGrob(HER81_RCP_),
    ggplotGrob(HER105_RCP_),
    ncol = 6,
    widths = c(w_col1_,
               w_col2_,
               w_col3_,
               w_col4_,
               w_col5_,
               w_col6_),
    padding = unit(0, "cm")),
  
  arrangeGrob(
    textGrob("HM effects",vjust = 1, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_), rot = 90),
    ggplotGrob(global_HM_),
    ggplotGrob(HER13_HM_),
    ggplotGrob(HER57_HM_),
    ggplotGrob(HER81_HM_),
    ggplotGrob(HER105_HM_),
    ncol = 6,
    widths = c(w_col1_,
               w_col2_,
               w_col3_,
               w_col4_,
               w_col5_,
               w_col6_),
    padding = unit(0, "cm")),
  
  arrangeGrob(
    textGrob("ND20 change",vjust = 1, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_), rot = 90),
    ggplotGrob(global_MeanChangeAndUncertainties_),
    ggplotGrob(HER13_MeanChangeAndUncertainties_),
    ggplotGrob(HER57_MeanChangeAndUncertainties_),
    ggplotGrob(HER81_MeanChangeAndUncertainties_),
    ggplotGrob(HER105_MeanChangeAndUncertainties_),
    ncol = 6,
    widths = c(w_col1_,
               w_col2_,
               w_col3_,
               w_col4_,
               w_col5_,
               w_col6_),
    padding = unit(0, "cm")),
  
  nrow = 5,
  heights = c(h_line1_,h_line2_,h_line3_,h_line4_,h_line5_),
  padding = unit(0.3, "cm")  # ajuster la marge
  
)


ggsave(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/Merge/Merge_NbJoursSup20_1_20240601",
              ".tiff"),
       grid_1_,
       width = 20, height = 12)

ggsave(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/Merge/Merge_NbJoursSup20_1_20240601",
              ".png"),
       grid_1_,
       width = 20, height = 12)

ggsave(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/Merge/Merge_NbJoursSup20_1_20240601",
              ".svg"),
       grid_1_,
       width = 20, height = 12)

ggsave(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/Merge/Merge_NbJoursSup20_1_20240601",
              ".pdf"),
       grid_1_,
       width = 20, height = 12)



