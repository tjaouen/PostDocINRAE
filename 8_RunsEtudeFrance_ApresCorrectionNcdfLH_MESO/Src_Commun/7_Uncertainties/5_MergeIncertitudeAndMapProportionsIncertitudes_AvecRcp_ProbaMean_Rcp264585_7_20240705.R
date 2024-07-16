library(grid)
library(ggplot2)
library(gridExtra)

# global_1_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/Global/ProbaMeanJuilOct/rcp45and85/1_ChroniquesPFI_rcp45and85_1_20240526.rds"
# global_1_ <- readRDS(global_1_)
7
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
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10),
    axis.ticks.length = unit(0.2,"cm"),
    # legend.position = "none",
    plot.subtitle = element_blank())
  # graph_nl_$layers <- graph_nl_$layers[-c(2,3)]
  graph_nl_$layers[[1]]$aes_params$size <- 0.7
  
  if (length(graph_nl_$layers) == 2){
    if ("linewidth" %in% names(graph_nl_$layers[[2]]$aes_params)){
      graph_nl_$layers[[2]]$aes_params$linewidth = 2.5
    }else{
      graph_nl_$layers[[2]]$aes_params = 1.5
    }
  }
  # graph_nl_$layers[[2]]$geom_params$height = 0
  # graph_nl_$layers[[3]]$geom_params$height = 0
  
  graph_nl_$theme$plot.margin = unit(c(0.3,0.3,0.3,0.3),"cm")
  
  if (removeLegend){
    graph_nl_ <- graph_nl_ + theme(legend.position = "none")
  }else{
    graph_nl_ <- graph_nl_ + theme(legend.text = element_text(size = 18),
                                   legend.title = element_text(size = 10, face = "bold")) +
      guides(color = guide_legend(keyheight = unit(1,"cm"),
                                  keywidth = unit(6,"cm"),
                                  ncol = 2,
                                  byrow = T))
  }
  
  return(graph_nl_)
}




global_GCM_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/Global/ProbaMeanJuilOct_SplitRCPGCM_Pondere_rcp264585/rcp26andrcp45and85/7_ChroniquesPFI_EffectGCM_rcp26andrcp45and85_1_20240526.rds"
global_RCM_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/Global/ProbaMeanJuilOct_SplitRCPGCM_Pondere_rcp264585/rcp26andrcp45and85/7_ChroniquesPFI_EffectRCM_rcp26andrcp45and85_1_20240526.rds"
global_HM_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/Global/ProbaMeanJuilOct_SplitRCPGCM_Pondere_rcp264585/rcp26andrcp45and85/8_ChroniquesPFI_EffectHM_rcp26andrcp45and85_1_20240526.rds"
global_RCP_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/Global/ProbaMeanJuilOct_SplitRCPGCM_Pondere_rcp264585/rcp26andrcp45and85/8_ChroniquesPFI_EffectRCP_rcp26andrcp45and85_1_20240526.rds"
global_MeanChangeAndUncertainties_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/Global/ProbaMeanJuilOct_SplitRCPGCM_Pondere_rcp264585/rcp26andrcp45and85/10_ChroniquesPFI_MeanChangeAndUncertainties_rcp26andrcp45and85_1_20240526.rds"
# global_MeanChangeAndUncertainties_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703_save/Global/ProbaMeanJuilOct/rcp45and85/10_ChroniquesPFI_MeanChangeAndUncertainties_rcp45and85_1_20240526.rds"


carte_GCM_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/MapIncertitude_GCM_1_20240619_sansTxt_sansEt.rds"
carte_RCM_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/MapIncertitude_RCM_1_20240619_sansTxt_sansEt.rds"
carte_HM_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/MapIncertitude_HM_1_20240619_sansTxt_sansEt.rds"
carte_RCP_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/MapIncertitude_RCP_1_20240619_sansTxt_sansEt.rds"
carte_InternalVar_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/MapIncertitude_InternalVar_1_20240619_sansTxt_sansEt.rds"
carte_ResidualVar_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/MapIncertitude_ResidualVar_1_20240619_sansTxt_sansEt.rds"



### Courbes ###
global_GCM_ <- readRDS(global_GCM_)
global_RCM_ <- readRDS(global_RCM_)
global_HM_ <- readRDS(global_HM_)
global_RCP_ <- readRDS(global_RCP_)
global_MeanChangeAndUncertainties_ <- readRDS(global_MeanChangeAndUncertainties_)

# ggsave(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/Merge/TestGCM",
#               ".tiff"),
#        global_GCM_,
#        width = 20, height = 12)
# ggsave(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/Merge/TestRCM",
#               ".tiff"),
#        global_RCM_,
#        width = 20, height = 12)
# ggsave(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/Merge/TestHM",
#               ".tiff"),
#        global_HM_,
#        width = 20, height = 12)



global_GCM_$theme$legend.text$size <- 10
global_RCM_$theme$legend.text$size <- 10
global_HM_$theme$legend.text$size <- 10
global_RCP_$theme$legend.text$size <- 10
global_MeanChangeAndUncertainties_$theme$legend.text$size <- 16
# global_MeanChangeAndUncertainties_$theme$axis.text.x$size <- 30
# global_MeanChangeAndUncertainties_$theme$axis.text.y$size <- 30

global_GCM_ <- global_GCM_ + guides(color = guide_legend(ncol = 1))
global_RCM_ <- global_RCM_ + guides(color = guide_legend(ncol = 2))
global_HM_ <- global_HM_ + guides(color = guide_legend(ncol = 2))
global_RCP_ <- global_RCP_ + guides(color = guide_legend(ncol = 2))
global_MeanChangeAndUncertainties_ <- global_MeanChangeAndUncertainties_ + 
  guides(fill = guide_legend(ncol = 2)) + 
  theme(legend.spacing.x = unit(1,"cm"))

legend_GCM_ <- cowplot::get_legend(global_GCM_)
legend_RCM_ <- cowplot::get_legend(global_RCM_)
legend_HM_ <- cowplot::get_legend(global_HM_)
legend_RCP_ <- cowplot::get_legend(global_RCP_)
legend_MeanChangeAndUncertainties_ <- cowplot::get_legend(global_MeanChangeAndUncertainties_)

### Cartes ###
carte_GCM_ <- readRDS(carte_GCM_)
carte_RCM_ <- readRDS(carte_RCM_)
carte_HM_ <- readRDS(carte_HM_)
carte_RCP_ <- readRDS(carte_RCP_)
# graph_nl_$layers <- graph_nl_$layers[-c(2,3)]
carte_InternalVar_ <- readRDS(carte_InternalVar_)
carte_ResidualVar_ <- readRDS(carte_ResidualVar_)

carte_GCM_$theme$legend.text$size <- 10
carte_RCM_$theme$legend.text$size <- 10
carte_HM_$theme$legend.text$size <- 10
carte_RCP_$theme$legend.text$size <- 10
carte_InternalVar_$theme$legend.text$size <- 10
carte_ResidualVar_$theme$legend.text$size <- 10


# ggsave(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/Merge/TestRCM",
#               ".tiff"),
#        global_RCM_,
#        width = 20, height = 12)


# guides(guide_legend(title = "Proportion of\nthe variance (%)"))
# legend_proportions <- cowplot::get_legend(carte_GCM_)

### Prepare ###
global_GCM_ <- prepareSubgraph(graph_ = global_GCM_, pos_ = c(1,1), removeLegend = T)
global_RCM_ <- prepareSubgraph(graph_ = global_RCM_, pos_ = c(2,1), removeLegend = T)
global_HM_ <- prepareSubgraph(global_HM_, pos_ = c(3,1), removeLegend = T)
global_RCP_ <- prepareSubgraph(global_RCP_, pos_ = c(4,1), removeLegend = T)
global_MeanChangeAndUncertainties_ <- prepareSubgraph(global_MeanChangeAndUncertainties_, pos_ = c(5,1), removeLegend = T)

global_MeanChangeAndUncertainties_ <- global_MeanChangeAndUncertainties_ + 
  theme(axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16))

# ggsave(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/Merge/TestRCM",
#               ".tiff"),
#        global_RCM_,
#        width = 20, height = 12)


# global_GCM_$theme$axis.text.y$size = 0
global_GCM_ <- global_GCM_ + theme(axis.text.y = element_blank())
global_RCM_ <- global_RCM_ + theme(axis.text.y = element_blank())
global_HM_ <- global_HM_ + theme(axis.text.y = element_blank())
# global_MeanChangeAndUncertainties_ <- global_MeanChangeAndUncertainties_ + theme(axis.text.y = element_blank())
# global_MeanChangeAndUncertainties_ <- global_MeanChangeAndUncertainties_ + 
#   ggtitle("PFI change") +
#   theme(
#     plot.title = element_text(
#       vjust = 0,
#       color = "grey38",
#       size = 16 * ratio_epaisseurs_
#     )
#   )

# ggsave(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/Merge/TestRCM",
#               ".tiff"),
#        global_RCM_,
#        width = 20, height = 12)


carte_GCM_ <- carte_GCM_ + theme(legend.position =  "bottom",
                                 legend.text = element_text(colour = "grey38", size = 14*ratio_epaisseurs_),
                                 # legend.title = element_blank(),
                                 legend.title = element_text(colour = "grey38",
                                                             size = 20*ratio_epaisseurs_),
                                 # size = 12*ratio_epaisseurs_),
                                 legend.direction = "horizontal",
                                 legend.margin = margin(0, 0, 0, 0), # Réduire les marges de la légende
                                 # legend.margin = margin(15, 15, 15, 15), # Réduire les marges de la légende
                                 legend.spacing.y = unit(0, 'cm'),
                                 legend.spacing.x = unit(-0.8, 'cm'),
                                 # legend.spacing.x = unit(-0.52, 'cm'),
                                 # legend.key = element_rect(colour = NULL),
                                 legend.key.width = unit(2, 'cm'),
                                 # legend.key.width = unit(1.3, 'cm'),
                                 legend.key.height = unit(0.5, 'cm'))+
  guides(fill = guide_legend(nrow = 1,
                             override.aes = list(linewidth = 0),
                             label.vjust = 5,
                             label.hjust = 0.5))# Réduire l'espacement interne de la légende
legend_proportions <- cowplot::get_legend(carte_GCM_)

graph_legend_ <- carte_GCM_
carte_GCM_ <- carte_GCM_ + theme(legend.position = "none")
carte_RCM_ <- carte_RCM_ + theme(legend.position = "none")
carte_HM_ <- carte_HM_ + theme(legend.position = "none")
carte_RCP_ <- carte_RCP_ + theme(legend.position = "none")
carte_InternalVar_ <- carte_InternalVar_ + theme(legend.position = "none")
carte_ResidualVar_ <- carte_ResidualVar_ + theme(legend.position = "none")

carte_GCM_$layers <- carte_GCM_$layers[1:2]
carte_RCM_$layers <- carte_RCM_$layers[1:2]
carte_HM_$layers <- carte_HM_$layers[1:2]
carte_RCP_$layers <- carte_RCP_$layers[1:2]
carte_InternalVar_$layers <- carte_InternalVar_$layers[1:2]
carte_ResidualVar_$layers <- carte_ResidualVar_$layers[1:2]




h_line1_ <- 0.7
h_line2_ <- 10
h_lineScale_ <- 3
h_line3_ <- 10
h_line4_ <- 5
h_line5_ <- 10
h_line6_ <- 10
w_col1_ = 0.7
w_col2_ = 15
w_col3_ = 15
w_col4_ = 15
w_col5_ = 15
w_col6_ = 15
w_col7_ = 15
w_col8_ = 15
w_coldroite_ = 0.7




scaleNorth_ = readRDS("/home/tjaouen/Documents/Input/FondsCartes/EchelleNord/EchelleNordGraph_1_20240308.rds")
scaleNorth_ <- scaleNorth_ + theme(plot.margin = unit(c(-0.3,-0.3,-0.3,-0.3), 'cm'))

# parameters_annotationscale_ <- graph_legend_$layers[[2]]$geom_params
# graph_legend_$theme$legend.text$vjust = -2
# graph_legend_$theme$legend.text$hjust = -2

labels_name_ <- graph_legend_$scales$scales[[1]]$breaks
labels_name_annotation_ <- paste0(c(substr(str_before_first(labels_name_[1],","),2,nchar(str_before_first(labels_name_[1],","))),
                                    str_before_first(str_after_first(labels_name_,","),"]")),
                                  "%")


legend_north_ <- graph_legend_
legend_north_$layers <- graph_legend_$layers[-c(1,2)]
legend_north_$layers[[1]]$geom_params$pad_x = unit(0,"cm")
legend_north_$layers[[1]]$geom_params$pad_y = unit(0,"cm")
legend_north_$layers[[1]]$geom_params$height = unit(0.9,"cm")
legend_north_$layers[[1]]$geom_params$width = unit(0.7,"cm")
legend_north_$layers[[1]]$aes_params$location = "tl"

scaleNorth_$layers[[2]]$aes_params$location = "tl"
scaleNorth_$layers[[2]]$geom_params$pad_x = unit(0,"cm")
scaleNorth_$layers[[2]]$geom_params$pad_y = unit(0.5,"cm")
scaleNorth_$layers[[3]]$aes_params$location = "tl"
scaleNorth_$layers[[3]]$geom_params$pad_x = unit(3.5,"cm")
scaleNorth_$layers[[3]]$geom_params$pad_y = unit(0.2,"cm")


carte_GCM_$layers <- carte_GCM_$layers[-c(2)]
carte_RCM_$layers <- carte_RCM_$layers[-c(2)]
carte_HM_$layers <- carte_HM_$layers[-c(2)]
carte_RCP_$layers <- carte_RCP_$layers[-c(2)]
carte_ResidualVar_$layers <- carte_ResidualVar_$layers[-c(2)]

# ggsave(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/Merge/TestGCM",
#               ".tiff"),
#        global_GCM_,
#        width = 20, height = 12)
# ggsave(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/Merge/TestRCM",
#               ".tiff"),
#        global_RCM_,
#        width = 20, height = 12)
# ggsave(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/Merge/TestHM",
#               ".tiff"),
#        global_HM_,
#        width = 20, height = 12)




grid_legendAndNorth_ <- grid.arrange(
  arrangeGrob(
    cowplot::get_legend(graph_legend_),
    ncol = 1,
    widths = c(w_col5_),
    padding = unit(0, "cm")),
  nrow = 1#,
)


grid_scale_ <- grid.arrange(
  
  # Ligne 5
  arrangeGrob(
    nullGrob(),
    nullGrob(),
    # textGrob(subtitle_,
    #          gp = gpar(fontsize = 15,
    #                    # fontface = "bold",
    #                    col = "grey38"), vjust = 0.5),
    ggplotGrob(scaleNorth_ +
                 ylim(max(layer_scales(scaleNorth_)$y$get_limits())-(max(layer_scales(scaleNorth_)$y$get_limits())-min(layer_scales(scaleNorth_)$y$get_limits()))*h_lineScale_/h_line2_,
                      max(layer_scales(scaleNorth_)$y$get_limits()))),
    nullGrob(),
    nullGrob(),
    
    ncol = 5,
    widths = c(w_col1_/2,
               w_col2_+w_col3_/2,
               w_col3_,
               w_col1_/2,
               w_col4_/2),
    
    padding = unit(0, "cm"))
)


# global_GCM_$labels$



# global_MeanChangeAndUncertainties_
# ggsave(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/Merge/Test",
#               ".tiff"),
#        global_RCM_,
#        width = 20, height = 12)







scaleNorth_$layers[[2]]$geom_params$pad_x = unit(0,"cm")
scaleNorth_$layers[[2]]$geom_params$pad_y = unit(1.65,"cm")
scaleNorth_$layers[[3]]$geom_params$pad_x = unit(8,"cm")
scaleNorth_$layers[[3]]$geom_params$pad_y = unit(1.2,"cm")


h_line1_ = 2
h_line2_ = 26
h_lineScale_ = 9

grid_1_ <- grid.arrange(
  
  arrangeGrob(
    textGrob("RCP", vjust = 0.5, gp = gpar(col = "#2f2f32", fontsize = 20 * ratio_epaisseurs_), rot = 0),
    textGrob("GCM", vjust = 0.5, gp = gpar(col = "#2f2f32", fontsize = 20 * ratio_epaisseurs_), rot = 0),
    textGrob("RCM", vjust = 0.5, gp = gpar(col = "#2f2f32", fontsize = 20 * ratio_epaisseurs_), rot = 0),
    
    ncol = 3,
    widths = c(w_col2_, w_col3_, w_col4_),
    padding = unit(-3, "cm")),
  
  arrangeGrob(
    ggplotGrob(carte_RCP_),
    ggplotGrob(carte_GCM_),
    ggplotGrob(carte_RCM_),
    ncol = 3,
    widths = c(w_col2_, w_col3_, w_col4_),
    padding = unit(-3, "cm")),
  
  arrangeGrob(
    # nullGrob(),
    textGrob("HM", vjust = 0.5, gp = gpar(col = "#2f2f32", fontsize = 20 * ratio_epaisseurs_), rot = 0),
    textGrob("Residual variability", vjust = 0.5, gp = gpar(col = "#2f2f32", fontsize = 20 * ratio_epaisseurs_), rot = 0),
    textGrob("PFI change", vjust = 0.5, gp = gpar(col = "#2f2f32", fontsize = 20 * ratio_epaisseurs_), rot = 0),
    
    ncol = 3,
    widths = c(w_col2_, w_col3_, w_col4_),
    padding = unit(-3, "cm")),
  
  arrangeGrob(
    ggplotGrob(carte_HM_),
    ggplotGrob(carte_ResidualVar_),
    ggplotGrob(global_MeanChangeAndUncertainties_),
    ncol = 3,
    widths = c(w_col2_, w_col3_, w_col4_),
    padding = unit(-3, "cm")),
  
  arrangeGrob(
    legend_proportions,
    ggplotGrob(scaleNorth_ +
                 ylim(max(layer_scales(scaleNorth_)$y$get_limits())-(max(layer_scales(scaleNorth_)$y$get_limits())-min(layer_scales(scaleNorth_)$y$get_limits()))*h_lineScale_/h_line2_,
                      max(layer_scales(scaleNorth_)$y$get_limits()))),
    legend_MeanChangeAndUncertainties_,

    ncol = 3,
    widths = c(w_col2_+w_col4_/2,w_col3_,w_col4_/2),
    padding = unit(-3, "cm")),
  
  nrow = 5,
  heights = c(h_line1_, h_line2_, h_line1_, h_line2_, h_lineScale_),
  # heights = c(h_line1_, h_line2_, h_lineScale_, h_line3_, h_line4_),
  padding = unit(-3, "cm")
)
plot(grid_1_)

ggsave(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/Merge/Merge_ProbaMeanJuilOct_Cadran6_1_20240705",
              ".tiff"),
       grid_1_,
       width = 16, height = 12)

ggsave(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/Merge/Merge_ProbaMeanJuilOct_Cadran6_1_20240705",
              ".png"),
       grid_1_,
       width = 16, height = 10)

ggsave(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/Merge/Merge_ProbaMeanJuilOct_Cadran6_1_20240705",
              ".svg"),
       grid_1_,
       width = 16, height = 12)

ggsave(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/Merge/Merge_ProbaMeanJuilOct_Cadran6_1_20240705",
              ".pdf"),
       grid_1_,
       width = 16, height = 12)

