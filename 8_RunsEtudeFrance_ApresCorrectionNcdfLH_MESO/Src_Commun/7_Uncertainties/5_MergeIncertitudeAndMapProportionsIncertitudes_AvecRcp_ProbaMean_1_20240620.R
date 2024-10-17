library(grid)
library(ggplot2)
library(gridExtra)

# global_1_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/Global/ProbaMeanJuilOct/rcp45and85/1_ChroniquesPFI_rcp45and85_1_20240526.rds"
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
    graph_nl_ <- graph_nl_ + theme(legend.text = element_text(size = 11),
                                   legend.title = element_text(size = 11, face = "bold")) +
      guides(color = guide_legend(keyheight = unit(1,"cm"),
                                  ncol = 2))
  }
  
  return(graph_nl_)
}




global_GCM_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/Global/ProbaMeanJuilOct_SplitRCPGCM/rcp45and85/7_ChroniquesPFI_EffectGCM_rcp45and85_1_20240526.rds"
global_RCM_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/Global/ProbaMeanJuilOct_SplitRCPGCM/rcp45and85/7_ChroniquesPFI_EffectRCM_rcp45and85_1_20240526.rds"
global_HM_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/Global/ProbaMeanJuilOct_SplitRCPGCM/rcp45and85/8_ChroniquesPFI_EffectHM_rcp45and85_1_20240526.rds"
global_RCP_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/Global/ProbaMeanJuilOct_SplitRCPGCM/rcp45and85/8_ChroniquesPFI_EffectRCP_rcp45and85_1_20240526.rds"
global_MeanChangeAndUncertainties_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/Global/ProbaMeanJuilOct_SplitRCPGCM/rcp45and85/10_ChroniquesPFI_MeanChangeAndUncertainties_rcp45and85_1_20240526.rds"


carte_GCM_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240619/MapIncertitude_GCM_1_20240619_sansTxt_sansEt.rds"
carte_RCM_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240619/MapIncertitude_RCM_1_20240619_sansTxt_sansEt.rds"
carte_HM_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240619/MapIncertitude_HM_1_20240619_sansTxt_sansEt.rds"
carte_RCP_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240619/MapIncertitude_RCP_1_20240619_sansTxt_sansEt.rds"
carte_InternalVar_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240619/MapIncertitude_InternalVar_1_20240619_sansTxt_sansEt.rds"
carte_ResidualVar_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240619/MapIncertitude_ResidualVar_1_20240619_sansTxt_sansEt.rds"



### Courbes ###
global_GCM_ <- readRDS(global_GCM_)
global_RCM_ <- readRDS(global_RCM_)
global_HM_ <- readRDS(global_HM_)
global_RCP_ <- readRDS(global_RCP_)
global_MeanChangeAndUncertainties_ <- readRDS(global_MeanChangeAndUncertainties_)

global_GCM_$theme$legend.text$size <- 8
global_RCM_$theme$legend.text$size <- 8
global_HM_$theme$legend.text$size <- 8
global_RCP_$theme$legend.text$size <- 8
global_MeanChangeAndUncertainties_$theme$legend.text$size <- 8

global_GCM_ <- global_GCM_ + guides(color = guide_legend(ncol = 2))
global_RCM_ <- global_RCM_ + guides(color = guide_legend(ncol = 2))
global_HM_ <- global_HM_ + guides(color = guide_legend(ncol = 2))
global_RCP_ <- global_RCP_ + guides(color = guide_legend(ncol = 2))
global_MeanChangeAndUncertainties_ <- global_MeanChangeAndUncertainties_ + guides(fill = guide_legend(ncol = 2))

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
carte_InternalVar_ <- readRDS(carte_InternalVar_)
carte_ResidualVar_ <- readRDS(carte_ResidualVar_)

carte_GCM_$theme$legend.text$size <- 8
carte_RCM_$theme$legend.text$size <- 8
carte_HM_$theme$legend.text$size <- 8
carte_RCP_$theme$legend.text$size <- 8
carte_InternalVar_$theme$legend.text$size <- 8
carte_ResidualVar_$theme$legend.text$size <- 8

carte_GCM_$theme$legend.position = c(0.5,0.5)
legend_proportions <- cowplot::get_legend(carte_GCM_)


### Prepare ###
global_GCM_ <- prepareSubgraph(graph_ = global_GCM_, pos_ = c(1,1), removeLegend = T)
global_RCM_ <- prepareSubgraph(graph_ = global_RCM_, pos_ = c(2,1), removeLegend = T)
global_HM_ <- prepareSubgraph(global_HM_, pos_ = c(3,1), removeLegend = T)
global_RCP_ <- prepareSubgraph(global_RCP_, pos_ = c(4,1), removeLegend = T)
global_MeanChangeAndUncertainties_ <- prepareSubgraph(global_MeanChangeAndUncertainties_, pos_ = c(5,1), removeLegend = T)

# global_GCM_$theme$axis.text.y$size = 0
global_RCM_$theme$axis.text.y$size = 0
global_HM_$theme$axis.text.y$size = 0
global_RCP_$theme$axis.text.y$size = 0
global_MeanChangeAndUncertainties_$theme$axis.text.y$size = 0
global_MeanChangeAndUncertainties_ <- global_MeanChangeAndUncertainties_ + 
  ggtitle("PFI change") +
  theme(
    plot.title = element_text(
      vjust = 0,
      color = "grey38",
      size = 16 * ratio_epaisseurs_
    )
  )
global_MeanChangeAndUncertainties_ <- global_MeanChangeAndUncertainties_ + theme(plot.title = element_text("PFI change", vjust = 0, color = "grey38", size = 16*ratio_epaisseurs_))

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

# grid_1_ <- grid.arrange(
#   
#   arrangeGrob(
#     nullGrob(),
#     textGrob("France",
#              gp = gpar(fontsize = 15,
#                        # fontface = "bold",
#                        col = "#2f2f32"), vjust = 0.5),
#     textGrob("Map",
#              gp = gpar(fontsize = 15,
#                        # fontface = "bold",
#                        col = "#2f2f32"), vjust = 0.5),
#     ncol = 3,
#     widths = c(w_col1_,
#                w_col2_,
#                w_col3_),
#     padding = unit(3, "cm")),
#   
#   arrangeGrob(
#     textGrob("GCM effects",vjust = 1, gp = gpar(col = "#2f2f32", fontsize = 16*ratio_epaisseurs_), rot = 90),
#     ggplotGrob(global_GCM_),
#     ggplotGrob(carte_GCM_),
#     ncol = 3,
#     widths = c(w_col1_,
#                w_col2_,
#                w_col3_),
#     padding = unit(3, "cm")),
#   
#   arrangeGrob(
#     textGrob("RCM effects",vjust = 1, gp = gpar(col = "#2f2f32", fontsize = 16*ratio_epaisseurs_), rot = 90),
#     ggplotGrob(global_RCM_),
#     ggplotGrob(carte_RCM_),
#     ncol = 3,
#     widths = c(w_col1_,
#                w_col2_,
#                w_col3_),
#     padding = unit(3, "cm")),
#   
#   arrangeGrob(
#     textGrob("RCP effects",vjust = 1, gp = gpar(col = "#2f2f32", fontsize = 16*ratio_epaisseurs_), rot = 90),
#     ggplotGrob(global_RCP_),
#     ggplotGrob(carte_RCP_),
#     ncol = 3,
#     widths = c(w_col1_,
#                w_col2_,
#                w_col3_),
#     padding = unit(3, "cm")),
#   
#   arrangeGrob(
#     textGrob("HM effects",vjust = 1, gp = gpar(col = "#2f2f32", fontsize = 16*ratio_epaisseurs_), rot = 90),
#     ggplotGrob(global_HM_),
#     ggplotGrob(carte_HM_),
#     ncol = 3,
#     widths = c(w_col1_,
#                w_col2_,
#                w_col3_),
#     padding = unit(3, "cm")),
#   
#   arrangeGrob(
#     textGrob("PFI change",vjust = 1, gp = gpar(col = "#2f2f32", fontsize = 16*ratio_epaisseurs_), rot = 90),
#     ggplotGrob(global_MeanChangeAndUncertainties_),
#     ggplotGrob(carte_ResidualVar_),
#     ncol = 3,
#     widths = c(w_col1_,
#                w_col2_,
#                w_col3_),
#     padding = unit(3, "cm")),
#   
#   nrow = 6,
#   heights = c(h_line1_,h_line2_,h_line3_,h_line4_,h_line5_,h_line6_),
#   # padding = unit(0.3, "cm")  # ajuster la marge
#   padding = unit(3, "cm")  # ajuster la marge
#   
# )



grid_1_ <- grid.arrange(
  
  arrangeGrob(
    nullGrob(),
    textGrob("GCM", vjust = 1, gp = gpar(col = "#2f2f32", fontsize = 16 * ratio_epaisseurs_), rot = 0),
    textGrob("RCM", vjust = 1, gp = gpar(col = "#2f2f32", fontsize = 16 * ratio_epaisseurs_), rot = 0),
    textGrob("RCP", vjust = 1, gp = gpar(col = "#2f2f32", fontsize = 16 * ratio_epaisseurs_), rot = 0),
    textGrob("HM", vjust = 1, gp = gpar(col = "#2f2f32", fontsize = 16 * ratio_epaisseurs_), rot = 0),
    textGrob("Residual\nvariability", vjust = 1, gp = gpar(col = "#2f2f32", fontsize = 16 * ratio_epaisseurs_), rot = 0),
    # textGrob("Internal\nvariability", vjust = 1, gp = gpar(col = "#2f2f32", fontsize = 16 * ratio_epaisseurs_), rot = 0),
    nullGrob(),
    # textGrob("PFI change", vjust = 1, gp = gpar(col = "#2f2f32", fontsize = 16 * ratio_epaisseurs_), rot = 0),
    ncol = 7,
    widths = c(w_col1_, w_col2_, w_col3_, w_col4_, w_col5_, w_col6_, w_col7_),
    padding = unit(3, "cm")),
  
  arrangeGrob(
    textGrob("A", gp = gpar(fontsize = 15, col = "#2f2f32"), vjust = 0.5),
    ggplotGrob(carte_GCM_),
    ggplotGrob(carte_RCM_),
    ggplotGrob(carte_RCP_),
    ggplotGrob(carte_HM_),
    ggplotGrob(carte_ResidualVar_),
    # ggplotGrob(carte_InternalVar_),
    # legend_proportions,
    grobTree(legend_proportions, vp = viewport(width = 0.2, height = 0.2)),
    ncol = 7,
    widths = c(w_col1_, w_col2_, w_col3_, w_col4_, w_col5_, w_col6_, w_col7_),
    padding = unit(3, "cm")),
  
  arrangeGrob(
    textGrob("B", gp = gpar(fontsize = 15, col = "#2f2f32"), vjust = 0.5),
    ggplotGrob(global_GCM_),
    ggplotGrob(global_RCM_),
    ggplotGrob(global_RCP_),
    ggplotGrob(global_HM_),
    nullGrob(),
    # nullGrob(),
    ggplotGrob(global_MeanChangeAndUncertainties_),
    ncol = 7,
    widths = c(w_col1_, w_col2_, w_col3_, w_col4_, w_col5_, w_col6_, w_col7_),
    padding = unit(3, "cm")),
  
  arrangeGrob(
    nullGrob(),
    legend_GCM_,
    legend_RCM_,
    legend_RCP_,
    legend_HM_,
    nullGrob(),
    # nullGrob(),
    legend_MeanChangeAndUncertainties_,
    ncol = 7,
    widths = c(w_col1_, w_col2_, w_col3_, w_col4_, w_col5_, w_col6_, w_col7_),
    padding = unit(3, "cm")),

  
  nrow = 4,
  heights = c(h_line1_, h_line2_, h_line3_, h_line4_),
  padding = unit(3, "cm")
)
plot(grid_1_)

ggsave(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240619/Merge/Merge_ProbaMeanJuilOct_1_20240620",
              ".tiff"),
       grid_1_,
       width = 20, height = 12)

ggsave(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240619/Merge/Merge_ProbaMeanJuilOct_1_20240620",
              ".png"),
       grid_1_,
       width = 20, height = 12)

ggsave(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240619/Merge/Merge_ProbaMeanJuilOct_1_20240620",
              ".svg"),
       grid_1_,
       width = 20, height = 12)

ggsave(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240619/Merge/Merge_ProbaMeanJuilOct_1_20240620",
              ".pdf"),
       grid_1_,
       width = 20, height = 12)


