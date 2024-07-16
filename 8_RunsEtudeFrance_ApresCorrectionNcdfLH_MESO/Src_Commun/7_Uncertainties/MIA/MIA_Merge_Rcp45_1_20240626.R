source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")

### Libraries ###
library(grid)
library(jpeg)
library(strex)
library(ggplot2)
library(svglite)
library(gridExtra)
library(lubridate)


### Functions ###
prepareSubgraph <- function(graph_, pos_, removeLegend = T){
  
  pattern_rcp_replace_ = data.frame(aRemplacer = c(NA,"rcp85","rcp45","rcp26"),
                                    remplacement = c("Historical","RCP\n8.5","RCP\n4.5","RCP\n2.6"))
  graph_nl_ <- graph_ + theme(plot.title = element_blank(),
                              plot.margin = unit(c(-0.3,-0.3,-0.3,-0.3), 'cm'),
                              # axis.text.x = element_text(size = 11),
                              # axis.text.y = element_text(size = 11),
                              # axis.ticks.length = unit(0.2,"cm"),
                              legend.position = "none",
                              plot.subtitle = element_blank())
  graph_nl_$layers <- graph_nl_$layers[-c(2,3)]
  graph_nl_$layers[[1]]$aes_params$size = 0.18
  # graph_nl_$layers[[2]]$geom_params$height = 0
  # graph_nl_$layers[[3]]$geom_params$height = 0
  
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

### Dimensions ###
h_line1_ = 8
h_lineScale_ = 6
h_line2_ = 2
h_graph_ = 26
h_line4_ = 3
w_col1_ = 2
w_col2_ = 26
w_col3_ = 26
w_col4_ = 26
w_col5_ = 26
w_col6_ = 3



map_CTRIP_rcp45_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/MIA/Map/IndexMIAparHER_CTRIP_Rcp45_1_20240625_sansTxt_sansEt.rds"
map_GRSD_rcp45_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/MIA/Map/IndexMIAparHER_GRSD_Rcp45_1_20240625_sansTxt_sansEt.rds"
map_J2000_rcp45_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/MIA/Map/IndexMIAparHER_J2000_Rcp45_1_20240625_sansTxt_sansEt.rds"
map_ORCHIDEE_rcp45_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/MIA/Map/IndexMIAparHER_ORCHIDEE_Rcp45_1_20240625_sansTxt_sansEt.rds"
map_SMASH_rcp45_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/MIA/Map/IndexMIAparHER_SMASH_Rcp45_1_20240625_sansTxt_sansEt.rds"
map_Total_rcp45_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/MIA/Map/IndexMIAparHER_Total_Rcp45_1_20240625_sansTxt_sansEt.rds"

map_CTRIP_rcp45_ <- readRDS(map_CTRIP_rcp45_)
map_GRSD_rcp45_ <- readRDS(map_GRSD_rcp45_)
map_J2000_rcp45_ <- readRDS(map_J2000_rcp45_)
map_ORCHIDEE_rcp45_ <- readRDS(map_ORCHIDEE_rcp45_)
map_SMASH_rcp45_ <- readRDS(map_SMASH_rcp45_)
map_Total_rcp45_ <- readRDS(map_Total_rcp45_)




scaleNorth_ = readRDS("/home/tjaouen/Documents/Input/FondsCartes/EchelleNord/EchelleNordGraph_1_20240308.rds")
scaleNorth_ <- scaleNorth_ + theme(plot.margin = unit(c(-0.3,-0.3,-0.3,-0.3), 'cm'))

graph_legend_ <- map_CTRIP_rcp45_

graph_legend_ <- graph_legend_ + theme(legend.position =  "bottom",
                                       # legend.justification = "left",
                                       # legend.text = element_text(colour = "grey38", size = 10*ratio_epaisseurs_, margin = margin(t = 2, unit = "pt")),
                                       legend.text = element_text(colour = "grey38", size = 20*ratio_epaisseurs_, margin = margin(t = 2, unit = "pt")),
                                       legend.title = element_blank(),
                                       legend.direction = "horizontal",
                                       legend.margin = margin(0, 0, 0, 0), # Réduire les marges de la légende
                                       legend.spacing.y = unit(0, 'cm'),
                                       # legend.spacing.x = unit(-0.5, 'cm'),
                                       legend.spacing.x = unit(-1, 'cm'),
                                       # legend.key.width = unit(1.3, 'cm'),
                                       legend.key.width = unit(2.5, 'cm'),
                                       legend.key.height = unit(0.5, 'cm')) # Ajuster la marge interne à droite)+

graph_legend_ <- graph_legend_ + guides(fill = guide_legend(nrow = 1,
                                                            override.aes = list(linewidth = 0),
                                                            label.vjust = 6,
                                                            label.hjust = 0.5))# Réduire l'espacement interne de la légende
graph_legend_

parameters_annotationscale_ <- graph_legend_$layers[[2]]$geom_params
graph_legend_$theme$legend.text$vjust = -2
graph_legend_$theme$legend.text$hjust = -2

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
legend_north_$layers[[1]]$aes_params$location = "bl"

scaleNorth_$layers[[2]]$aes_params$location = "bl"

scaleNorth_$layers[[2]]$geom_params$pad_x = unit(8,"cm")
scaleNorth_$layers[[2]]$geom_params$pad_y = unit(1.5,"cm")
scaleNorth_$layers[[3]]$aes_params$location = "bl"
scaleNorth_$layers[[3]]$geom_params$pad_x = unit(6.5,"cm")
scaleNorth_$layers[[3]]$geom_params$pad_y = unit(1.2,"cm")

image1 <- prepareSubgraph(map_CTRIP_rcp45_, pos_ = c(1,1), removeLegend = T)
image2 <- prepareSubgraph(map_GRSD_rcp45_, pos_ = c(1,2), removeLegend = T)
image3 <- prepareSubgraph(map_J2000_rcp45_, pos_ = c(1,3), removeLegend = T)
image4 <- prepareSubgraph(map_ORCHIDEE_rcp45_, pos_ = c(2,1), removeLegend = T)
image5 <- prepareSubgraph(map_SMASH_rcp45_, pos_ = c(2,2), removeLegend = T)
image6 <- prepareSubgraph(map_Total_rcp45_, pos_ = c(2,3), removeLegend = T)
image1$layers <- image1$layers[-c(2,3)]
image2$layers <- image2$layers[-c(2,3)]
image3$layers <- image3$layers[-c(2,3)]
image4$layers <- image4$layers[-c(2,3)]
image5$layers <- image5$layers[-c(2,3)]
image6$layers <- image6$layers[-c(2,3)]

grid_legendAndNorth_ <- grid.arrange(
  arrangeGrob(
    cowplot::get_legend(graph_legend_),
    ncol = 1,
    widths = c(w_col5_),
    padding = unit(-3, "cm")),
  nrow = 1#,
)

# grid_head_ <- grid.arrange(
#   
#   # Ligne 5
#   arrangeGrob(
#     # nullGrob(),
#     textGrob(graph_list_$titre[g],# title_,
#              gp = gpar(fontsize = 20,
#                        fontface = "bold",
#                        col = "grey38"), vjust = 0.5),
#     # nullGrob(),
#     
#     # nullGrob(),
#     # rasterGrob(readJPEG("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/tlogoExplore2/Explore2_AgenceEau_2.jpg")), # Remplacer nullGrob() par rasterGrob() avec votre image
#     
#     ncol = 1,
#     widths = c(#w_col1_/2,
#       w_col2_*2),#+w_col3_/2,
#     #w_col1_/2,
#     #w_col3_/2,
#     # w_col4_),
#     padding = unit(0, "cm"))
# )

grid_scale_ <- grid.arrange(
  
  # Ligne 5
  arrangeGrob(
    # nullGrob(),
    
    # nullGrob(),
    textGrob("MIA (%)",
             gp = gpar(fontsize = 20,
                       col = "grey38"),
             vjust = 0.5,
             hjust = -0.5),
    grid_legendAndNorth_,
    
    ggplotGrob(scaleNorth_ +
                 ylim(max(layer_scales(scaleNorth_)$y$get_limits())-(max(layer_scales(scaleNorth_)$y$get_limits())-min(layer_scales(scaleNorth_)$y$get_limits()))*h_lineScale_/h_graph_,
                      max(layer_scales(scaleNorth_)$y$get_limits()))),
    # nullGrob(),
    # nullGrob(),
    
    ncol = 3,
    widths = c(#w_col1_/2,
      w_col4_/4,
      w_col4_+w_col4_*3/4,#+w_col3_/2,
      #w_col3_,
      #w_col1_/2,
      w_col4_),#/2),
    
    padding = unit(-3, "cm"))
)


grid_1_ <- grid.arrange(
  
  # Ligne 5
  arrangeGrob(
    textGrob("CTRIP",gp = gpar(fontsize = 20,col = "grey38"), vjust = 0.5),
    textGrob("GRSD",gp = gpar(fontsize = 20,col = "grey38"), vjust = 0.5),
    textGrob("J2000",gp = gpar(fontsize = 20,col = "grey38"), vjust = 0.5),
    ncol=3,
    widths = c(w_col4_,w_col4_,w_col4_),
    padding = unit(-3,"cm")),
  
  arrangeGrob(
    ggplotGrob(image1),
    ggplotGrob(image2),
    ggplotGrob(image3),
    ncol = 3,
    widths = c(w_col4_,w_col4_,w_col4_),
    padding = unit(-3, "cm")),
  
  arrangeGrob(
    textGrob("ORCHIDEE",gp = gpar(fontsize = 20,col = "grey38"), vjust = 0.5),
    textGrob("SMASH",gp = gpar(fontsize = 20,col = "grey38"), vjust = 0.5),
    textGrob("Inter-models",gp = gpar(fontsize = 20,col = "grey38"), vjust = 0.5),
    ncol=3,
    widths = c(w_col4_,w_col4_,w_col4_),
    padding = unit(-3,"cm")),
  
  # Ligne 6
  arrangeGrob(
    ggplotGrob(image4),
    ggplotGrob(image5),
    ggplotGrob(image6),
    ncol = 3,
    widths = c(w_col4_,w_col4_,w_col4_),
    padding = unit(-3, "cm")),
  
  # Ligne 5
  arrangeGrob(
    nullGrob(),
    ncol = 1,
    widths = c(w_col2_*2),
    padding = unit(-3, "cm")),
  
  # Ligne
  arrangeGrob(
    grid_scale_),
  
  
  nrow = 6,
  heights = c(h_line2_,h_graph_,h_line2_,h_graph_,h_line2_,h_lineScale_), #h_line1_
  padding = unit(-3, "cm")  # ajuster la marge
  
)


ggsave(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/MIA/Map/Merge_Rcp45_FinSiecleVsRefHist_1_20240705.tiff"),
       grid_1_,
       width = 20, height = 12)

ggsave(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/MIA/Map/Merge_Rcp45_FinSiecleVsRefHist_1_20240705.png"),
       grid_1_,
       width = 20, height = 12)

ggsave(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/MIA/Map/Merge_Rcp45_FinSiecleVsRefHist_1_20240705.svg"),
       grid_1_,
       width = 20, height = 12)

ggsave(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/MIA/Map/Merge_Rcp45_FinSiecleVsRefHist_1_20240705.pdf"),
       grid_1_,
       width = 20, height = 12)






