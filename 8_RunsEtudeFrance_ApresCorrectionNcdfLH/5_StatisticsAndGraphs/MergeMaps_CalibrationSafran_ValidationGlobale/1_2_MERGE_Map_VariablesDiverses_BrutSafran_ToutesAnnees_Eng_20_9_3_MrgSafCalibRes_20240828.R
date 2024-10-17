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
prepareSubgraph <- function(graph_, pos_, removeLegend = T, removeScale = T, scaleIndx, lastline_ = F){
  
  graph_nl_ <- graph_ + theme(
    plot.title = element_text(vjust = 0, color = "grey38", size = 16*ratio_epaisseurs_),
    # plot.margin = unit(c(-0.3,-0.3,-0.3,-0.3), 'cm'),
    plot.margin = unit(c(0,0,0,0), 'cm'),
    plot.subtitle = element_blank())
  graph_nl_$layers[[1]]$aes_params$size = 0.18
  
  if (removeLegend){
    graph_nl_ <- graph_nl_ + theme(legend.position = "none")
  }else{
    graph_nl_ <- graph_nl_ + theme(legend.key.height = unit(0.45*ratio_epaisseurs_, "cm"),
                                   legend.key.width = unit(0.3*ratio_epaisseurs_, "cm"),
                                   legend.text = element_text(size = 9*ratio_epaisseurs_, colour = "gray38"),
                                   legend.title = element_text(size = 9*ratio_epaisseurs_, colour = "gray38", hjust = 0.5),
                                   legend.spacing.x = unit(0.1,"cm"),
                                   legend.position = "right")
    # legend.position = c(0.92,0.5))
  }
  
  if (removeScale){
    graph_nl_$layers <- graph_nl_$layers[-scaleIndx]
    graph_nl_ <- graph_nl_ +
      annotation_scale(location = "br",width_hint = 0.25,pad_x = unit(0.5, "cm"),pad_y = unit(0.5, "cm"),
                       style = "ticks",line_col = "white",text_col = "white",bar_cols = c("white", "white")) +
      
      # Annotation de la flèche vers le nord
      annotation_north_arrow(location = "br",which_north = "true",pad_x = unit(0.5, "cm"),pad_y = unit(0.5, "cm"),
                             style = north_arrow_fancy_orienteering(text_col = "white",fill = c("white", "white"),line_col = "white"))
    graph_nl_$layers[[scaleIndx[1]]]$geom_params$pad_x = unit(+2,"cm")
    graph_nl_$layers[[scaleIndx[1]]]$geom_params$pad_y = unit(-1,"cm")
    graph_nl_$layers[[scaleIndx[2]]]$geom_params$pad_x = unit(1,"cm")
    graph_nl_$layers[[scaleIndx[2]]]$geom_params$pad_y = unit(-1,"cm")
  }else{
    graph_nl_$layers <- graph_nl_$layers[-scaleIndx]
    graph_nl_ <- graph_nl_ +
      annotation_scale(location = "br",width_hint = 0.25,style = "ticks",text = element_blank(),line_col = "gray38",
                       text_col = "gray38",bar_cols = c("gray38", "gray38")) +
      
      # Annotation de la flèche vers le nord
      annotation_north_arrow(height = unit(1, "cm"),width = unit(0.7, "cm"),location = "br",which_north = "true",
                             style = north_arrow_fancy_orienteering(text_col = "gray38",fill = c("gray38", "gray38"),line_col = "gray38"))
    graph_nl_$layers[[scaleIndx[1]]]$geom_params$pad_x = unit(+2,"cm")
    graph_nl_$layers[[scaleIndx[1]]]$geom_params$pad_y = unit(0,"cm")
    graph_nl_$layers[[scaleIndx[2]]]$geom_params$pad_x = unit(1,"cm")
    graph_nl_$layers[[scaleIndx[2]]]$geom_params$pad_y = unit(-0.1,"cm")
  }
  
  if (lastline_){
    graph_nl_ <- graph_nl_ + ylim(6000000,7110552)
  }
  
  # if (!lastline_){
  graph_nl_$layers <- graph_nl_$layers[-c(2,3)]
  # }
  
  return(graph_nl_)
}


nomSim_ <- nomSim_param_
nom_categorieSimu_ <- nom_categorieSimu_param_
nom_apprentissage_ <- "TableMediane"
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

# print(graph_list_$variable[g])
print(paste0(folder_output_,"/15_ResultatsModeles_ValidationParAnnees_ParHer/",nomSim_,"/TableMediane/Map_English/"))
# print(paste0("_Boxplot_Globale_",graph_list_$variable[g],"_NonBoot_"))

### A remettre ###
chemin_KGE_CTRIP <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/CTRIP_20231128/TableMediane/Map_English/4_Map_Globale_KGE_NonBoot/KGE_NonBoot_sansEt.rds"
chemin_KGE_GRSD <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/TableMediane/Map_English/4_Map_Globale_KGE_NonBoot/KGE_NonBoot_sansEt.rds"
chemin_KGE_J2000 <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/TableMediane/Map_English/4_Map_Globale_KGE_NonBoot/KGE_NonBoot_sansEt.rds"
chemin_KGE_ORCHIDEE <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/ORCHIDEE_20231128/TableMediane/Map_English/4_Map_Globale_KGE_NonBoot/KGE_NonBoot_sansEt.rds"
chemin_KGE_SMASH <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/TableMediane/Map_English/4_Map_Globale_KGE_NonBoot/KGE_NonBoot_sansEt.rds"
chemin_Bias_CTRIP <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/CTRIP_20231128/TableMediane/Map_English/5_Map_Globale_Biais_General_NonBoot/Biais_General_NonBoot_sansEt.rds"
chemin_Bias_GRSD <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/TableMediane/Map_English/5_Map_Globale_Biais_General_NonBoot/Biais_General_NonBoot_sansEt.rds"
chemin_Bias_J2000 <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/TableMediane/Map_English/5_Map_Globale_Biais_General_NonBoot/Biais_General_NonBoot_sansEt.rds"
chemin_Bias_ORCHIDEE <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/ORCHIDEE_20231128/TableMediane/Map_English/5_Map_Globale_Biais_General_NonBoot/Biais_General_NonBoot_sansEt.rds"
chemin_Bias_SMASH <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/TableMediane/Map_English/5_Map_Globale_Biais_General_NonBoot/Biais_General_NonBoot_sansEt.rds"

# Importer les fichiers PNG
# print(output_boxplot_)
image_KGE_CTRIP <- readRDS(chemin_KGE_CTRIP)
image_KGE_GRSD <- readRDS(chemin_KGE_GRSD)
image_KGE_J2000 <- readRDS(chemin_KGE_J2000)
image_KGE_ORCHIDEE <- readRDS(chemin_KGE_ORCHIDEE)
image_KGE_SMASH <- readRDS(chemin_KGE_SMASH)
image_Bias_CTRIP <- readRDS(chemin_Bias_CTRIP)
image_Bias_GRSD <- readRDS(chemin_Bias_GRSD)
image_Bias_J2000 <- readRDS(chemin_Bias_J2000)
image_Bias_ORCHIDEE <- readRDS(chemin_Bias_ORCHIDEE)
image_Bias_SMASH <- readRDS(chemin_Bias_SMASH)

graph_legend_ <- image_KGE_CTRIP

graph_legend_ <- graph_legend_ + theme(legend.position =  "bottom",
                                       # legend.justification = "left",
                                       legend.text = element_text(colour = "grey38", size = 10*ratio_epaisseurs_, margin = margin(t = 2, unit = "pt")),
                                       legend.title = element_blank(),
                                       legend.direction = "horizontal",
                                       legend.margin = margin(0, 0, 0, 0), # Réduire les marges de la légende
                                       legend.spacing.y = unit(0, 'cm'),
                                       # legend.spacing.x = unit(-0.4, 'cm'),
                                       legend.key.width = unit(1.3, 'cm'),
                                       legend.key.height = unit(0.5, 'cm')) # Ajuster la marge interne à droite)+
# }
graph_legend_ <- graph_legend_ + guides(fill = guide_legend(nrow = 1,
                                                            override.aes = list(linewidth = 0),
                                                            label.vjust = 5,
                                                            label.hjust = 0.5))# Réduire l'espacement interne de la légende
graph_legend_

parameters_annotationscale_ <- graph_legend_$layers[[2]]$geom_params
graph_legend_$theme$legend.text$vjust = -2
graph_legend_$theme$legend.text$hjust = -2
graph_legend_$theme$legend.text$size = 11

labels_name_ <- graph_legend_$scales$scales[[1]]$breaks
labels_name_annotation_ <- paste0(c(substr(str_before_first(labels_name_[1],","),2,nchar(str_before_first(labels_name_[1],","))),
                                    str_before_first(str_after_first(labels_name_,","),"]")),
                                  "%")

image_KGE_CTRIP <- prepareSubgraph(image_KGE_CTRIP, pos_ = c(1,1), removeLegend = T, removeScale = T, scaleIndx = c(4,5), lastline_ = F)
image_KGE_GRSD <- prepareSubgraph(image_KGE_GRSD, pos_ = c(1,2), removeLegend = T, removeScale = T, scaleIndx = c(4,5), lastline_ = F)
image_KGE_J2000 <- prepareSubgraph(image_KGE_J2000, pos_ = c(1,3), removeLegend = T, removeScale = T, scaleIndx = c(4,5), lastline_ = F)
image_KGE_ORCHIDEE <- prepareSubgraph(image_KGE_ORCHIDEE, pos_ = c(1,4), removeLegend = T, removeScale = T, scaleIndx = c(4,5), lastline_ = F)
image_KGE_SMASH <- prepareSubgraph(image_KGE_SMASH, pos_ = c(1,5), removeLegend = T, removeScale = T, scaleIndx = c(4,5), lastline_ = F)
image_Bias_CTRIP <- prepareSubgraph(image_Bias_CTRIP, pos_ = c(2,1), removeLegend = T, removeScale = T, scaleIndx = c(4,5), lastline_ = T)
image_Bias_GRSD <- prepareSubgraph(image_Bias_GRSD, pos_ = c(2,2), removeLegend = T, removeScale = T, scaleIndx = c(4,5), lastline_ = T)
image_Bias_J2000 <- prepareSubgraph(image_Bias_J2000, pos_ = c(2,3), removeLegend = T, removeScale = T, scaleIndx = c(4,5), lastline_ = T)
image_Bias_ORCHIDEE <- prepareSubgraph(image_Bias_ORCHIDEE, pos_ = c(2,4), removeLegend = T, removeScale = T, scaleIndx = c(4,5), lastline_ = T)
image_Bias_SMASH <- prepareSubgraph(image_Bias_SMASH, pos_ = c(2,5), removeLegend = T, removeScale = F, scaleIndx = c(4,5), lastline_ = T)

# image_KGE_CTRIP$layers <- image_KGE_CTRIP$layers[-c(2,3)]
# image_KGE_GRSD$layers <- image_KGE_GRSD$layers[-c(2,3)]
# image_KGE_J2000$layers <- image_KGE_J2000$layers[-c(2,3)]
# image_KGE_ORCHIDEE$layers <- image_KGE_ORCHIDEE$layers[-c(2,3)]
# image_KGE_SMASH$layers <- image_KGE_SMASH$layers[-c(2,3)]
# image_Bias_CTRIP$layers <- image_Bias_CTRIP$layers[-c(2,3)]
# image_Bias_GRSD$layers <- image_Bias_GRSD$layers[-c(2,3)]
# image_Bias_J2000$layers <- image_Bias_J2000$layers[-c(2,3)]
# image_Bias_ORCHIDEE$layers <- image_Bias_ORCHIDEE$layers[-c(2,3)]
# image_Bias_SMASH$layers <- image_Bias_SMASH$layers[-c(2,3)]

# grid_legendAndNorth_ <- grid.arrange(
#   arrangeGrob(
#     cowplot::get_legend(graph_legend_),
#     ncol = 1,
#     widths = c(w_col5_),
#     padding = unit(0, "cm")),
#   nrow = 1#,
# )

# grid_scale_ <- grid.arrange(
#   
#   # Ligne 5
#   arrangeGrob(
#     # grid_legendAndNorth_,
#     nullGrob(),
#     nullGrob(),
#     nullGrob(),
#     nullGrob(),
#     nullGrob(),
#     # ggplotGrob(scaleNorth_),
#     ggplotGrob(scaleNorth_ +
#                  ylim(max(layer_scales(scaleNorth_)$y$get_limits())-(max(layer_scales(scaleNorth_)$y$get_limits())-min(layer_scales(scaleNorth_)$y$get_limits()))*h_lineScale_/h_graph_,
#                       max(layer_scales(scaleNorth_)$y$get_limits()))),
#     ncol = 6,
#     widths = c(w_col2_/2,w_col2_,w_col2_,w_col2_,w_col2_,w_col2_),
#     # widths = c(w_col2_/2,w_col2_,w_col2_,w_col2_,w_col2_*(1-h_lineScale_/h_graph_),w_col2_*h_lineScale_/h_graph_),
#     padding = unit(0, "cm"))
# )

x11()
grid_1_ <- grid.arrange(
  
  # Ligne
  arrangeGrob(
    nullGrob(),
    textGrob("CTRIP", vjust = 0.5, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_)),
    textGrob("GRSD", vjust = 0.5, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_)),
    textGrob("J2000", vjust = 0.5, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_)),
    textGrob("ORCHIDEE", vjust = 0.5, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_)),
    textGrob("SMASH", vjust = 0.5, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_)),
    ncol = 6,
    widths = c(w_col2_/2,w_col2_,w_col2_,w_col2_,w_col2_,w_col2_),
    padding = unit(0.3, "cm")),
  
  # Ligne
  arrangeGrob(
    # ggplotGrob(image6),
    # textGrob("KGE (unitless)", vjust = 0, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_), rot = 90),
    cowplot::get_legend(graph_legend_KGE_),
    ggplotGrob(image_KGE_CTRIP),
    ggplotGrob(image_KGE_GRSD),
    ggplotGrob(image_KGE_J2000),
    ggplotGrob(image_KGE_ORCHIDEE),
    ggplotGrob(image_KGE_SMASH),
    ncol = 6,
    widths = c(w_col2_/2,w_col2_,w_col2_,w_col2_,w_col2_,w_col2_),
    padding = unit(0.3, "cm")),
  
  # Ligne
  arrangeGrob(
    # textGrob("Absolute bias (unitless)", vjust = 0, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_), rot = 90),
    cowplot::get_legend(graph_legend_Bias_),
    ggplotGrob(image_Bias_CTRIP),
    ggplotGrob(image_Bias_GRSD),
    ggplotGrob(image_Bias_J2000),
    ggplotGrob(image_Bias_ORCHIDEE),
    ggplotGrob(image_Bias_SMASH),
    ncol = 6,
    widths = c(w_col2_/2,w_col2_,w_col2_,w_col2_,w_col2_,w_col2_),
    padding = unit(0.3, "cm")),
  
  # Ligne
  # arrangeGrob(
  #   grid_scale_),
  
  nrow = 3,
  heights = c(h_line2_,h_graph_,h_graph_),
  # nrow = 4,
  # heights = c(h_line2_,h_graph_,h_graph_,h_lineScale_),
  padding = unit(0.5, "cm")  # ajuster la marge
  
)


if (!(dir.exists(paste0(folder_output_,
                        "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                        nomSim_,
                        "/TableGlobaleMerge/Map_English/")))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    "/TableGlobaleMerge/Map_English/"))
}

ggsave(paste0(folder_output_,
              "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
              nomSim_,
              "/TableGlobaleMerge/Map_English/MergeValidSafran_",
              gsub(".rds",".tiff",str_after_first(basename(chemin_KGE_CTRIP),"_"))),
       grid_1_,
       width = 13.5, height = 5.5)

ggsave(paste0(folder_output_,
              "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
              nomSim_,
              "/TableGlobaleMerge/Map_English/MergeValidSafran_",
              gsub(".rds",".png",str_after_first(basename(chemin_KGE_CTRIP),"_"))),
       grid_1_,
       width = 13.5, height = 5.5)

ggsave(paste0(folder_output_,
              "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
              nomSim_,
              "/TableGlobaleMerge/Map_English/MergeValidSafran_",
              gsub(".rds",".svg",str_after_first(basename(chemin_KGE_CTRIP),"_"))),
       grid_1_,
       width = 13.5, height = 5.5)

ggsave(paste0(folder_output_,
              "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
              nomSim_,
              "/TableGlobaleMerge/Map_English/MergeValidSafran_",
              gsub(".rds",".pdf",str_after_first(basename(chemin_KGE_CTRIP),"_"))),
       grid_1_,
       width = 13.5, height = 5.5)
# width = 900, height = 750,
# width = 1200, height = 750,
# units = "px", pointsize = 12)
# width = ,
# height = )


