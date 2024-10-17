source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunObs20122019.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")

# Charger les bibliothèques
library(png)
library(jpeg)
library(grid)
library(strex)
library(ggplot2)
library(cowplot)
library(gridExtra)

### Functions ###
prepareSubgraph <- function(graph_, pos_, removeLegend = T){
  
  # pattern_rcp_replace_ = data.frame(aRemplacer = c(NA,"rcp85","rcp45","rcp26"),
  #                                   remplacement = c("Historical","RCP\n8.5","RCP\n4.5","RCP\n2.6"))
  graph_nl_ <- graph_ + theme(#plot.title = element_text(size = 11),
    
    plot.title = element_text(vjust = 0, color = "grey38", size = 16*ratio_epaisseurs_),
    
    
    plot.margin = unit(c(-0.3,-0.3,-0.3,-0.3), 'cm'),
    # axis.text.x = element_text(size = 11),
    # axis.text.y = element_text(size = 11),
    # axis.ticks.length = unit(0.2,"cm"),
    # legend.position = "none",
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


nomSim_ <- nomSim_param_
nom_categorieSimu_ <- nom_categorieSimu_param_
# nom_apprentissage_ <- nom_apprentissage_param_
# nom_validation_ <- nom_validation_param_
nom_apprentissage_ <- "TableMediane"
# nom_validation_ <- "Validation_3AnneesSechesInterHumides"
folder_output_ <- folder_output_param_
nom_GCM_ = nom_GCM_param_

ratio_epaisseurs_ = 1
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



chemin_1 <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableGlobale/Map_English/1_Map_Globale_ProbaAssecMoyenApredire_NonBoot/ProbaAssecMoyenApredire_NonBoot_sansTxt_sansEt.rds"
chemin_2 <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableGlobale/Map_English/4_Map_Globale_KGE_NonBoot/KGE_NonBoot_sansEt.rds"
chemin_3 <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableGlobale/Map_English/5_Map_Globale_Biais_General_NonBoot/Biais_General_NonBoot_sansEt.rds"


  
# Importer les fichiers PNG
# print(output_boxplot_)
image1 <- readRDS(chemin_1)
image2 <- readRDS(chemin_2)
image3 <- readRDS(chemin_3)
image1 <- image1 + ggtitle("Observed mean PFI (%)")
image2 <- image2 + ggtitle("KGE (unitless)")
image3 <- image3 + ggtitle("Absolute bias (unitless)")

scaleNorth_ = readRDS("/home/tjaouen/Documents/Input/FondsCartes/EchelleNord/EchelleNordGraph_1_20240308.rds")
scaleNorth_ <- scaleNorth_ + theme(plot.margin = unit(c(-0.3,-0.3,-0.3,-0.3), 'cm'))


parameters_annotationscale_ <- graph_legend_$layers[[2]]$geom_params
graph_legend_$theme$legend.text$vjust = -2
graph_legend_$theme$legend.text$hjust = -2
graph_legend_$theme$legend.text$size = 11

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

image1 <- prepareSubgraph(image1, pos_ = c(1,1), removeLegend = F)
image2 <- prepareSubgraph(image2, pos_ = c(1,2), removeLegend = F)
image3 <- prepareSubgraph(image3, pos_ = c(1,3), removeLegend = F)
image1$layers <- image1$layers[-c(2,3)]
image2$layers <- image2$layers[-c(2,3)]
image3$layers <- image3$layers[-c(2,3)]

image1 <- image1 + theme(legend.title = element_blank())
image2 <- image2 + theme(legend.title = element_blank())
image3 <- image3 + theme(legend.title = element_blank())

grid_legendAndNorth_ <- grid.arrange(
  arrangeGrob(
    nullGrob(),
    # cowplot::get_legend(graph_legend_),
    ncol = 1,
    widths = c(w_col5_),
    padding = unit(0, "cm")),
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
    grid_legendAndNorth_,
    # textGrob(subtitle_,
    #          gp = gpar(fontsize = 15,
    #                    col = "grey38"), vjust = 0.5),
    
    ggplotGrob(scaleNorth_ +
                 ylim(max(layer_scales(scaleNorth_)$y$get_limits())-(max(layer_scales(scaleNorth_)$y$get_limits())-min(layer_scales(scaleNorth_)$y$get_limits()))*h_lineScale_/h_graph_,
                      max(layer_scales(scaleNorth_)$y$get_limits()))),
    # nullGrob(),
    # nullGrob(),
    
    ncol = 2,
    widths = c(#w_col1_/2,
      w_col2_,#+w_col3_/2,
      #w_col3_,
      #w_col1_/2,
      w_col4_),#/2),
    
    padding = unit(0, "cm"))
)

x11()
grid_1_ <- grid.arrange(
  
  # Ligne
  arrangeGrob(
    ggplotGrob(image1),
    ggplotGrob(image2),
    ggplotGrob(image3),
    ncol = 3,
    widths = c(w_col2_,w_col2_,w_col4_),
    padding = unit(0, "cm")),
  
  # Ligne
  arrangeGrob(
    nullGrob(),
    ncol = 1,
    widths = c(w_col2_*2),
    padding = unit(0, "cm")),
  
  # Ligne
  arrangeGrob(
    grid_scale_),
  
  nrow = 3,
  heights = c(h_graph_,h_line2_,h_lineScale_),
  padding = unit(0.3, "cm")  # ajuster la marge
  
)
  


