source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunObs20122019.R")

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
  
  pattern_rcp_replace_ = data.frame(aRemplacer = c(NA,"rcp85","rcp45","rcp26"),
                                    remplacement = c("Historical","RCP\n8.5","RCP\n4.5","RCP\n2.6"))
  graph_nl_ <- graph_ + theme(#plot.title = element_text(size = 11),
                              
                              plot.title = element_text(vjust = 0, color = "grey38", size = 16*ratio_epaisseurs_),
                              
                              
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


nomSim_ <- nomSim_param_
nom_categorieSimu_ <- nom_categorieSimu_param_
# nom_apprentissage_ <- nom_apprentissage_param_
# nom_validation_ <- nom_validation_param_
nom_apprentissage_ <- "ApprentissageParDeuxCategoriesParmiSechesInterHumides"
nom_validation_ <- "Validation_3AnneesSechesInterHumides"
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


graph_list_ = data.frame( variable = c("Intercept","ProbaAssecFDCnulle","Slope","PropDev","KGE",
                                       "Biais_General", #"Biais_Max3",
                                       "ErrMoyAbs_General", #"ErrMoyAbs_Max3",
                                       "RMSE_General", #"RMSE_Max3",
                                       # "Biais_Mois05", "Biais_Mois06", "Biais_Mois07", "Biais_Mois08", "Biais_Mois09",
                                       # "ErrMoyAbs_Mois05", "ErrMoyAbs_Mois06", "ErrMoyAbs_Mois07", "ErrMoyAbs_Mois08", "ErrMoyAbs_Mois09",
                                       # "RMSE_Mois05", "RMSE_Mois06", "RMSE_Mois07", "RMSE_Mois08", "RMSE_Mois09",
                                       "NSE_General",
                                       "ProbaAssecMoyenApredire"),
                          titre = c("Logistic regression intercept (unitless)",
                                    "Predicted probability of drying state at a zero exceedance frequency",
                                    "Logistic regression slope (unitless)",
                                    "Proportion of total deviance explained by non-exceedance frequency of discharge",
                                    "KGE (unitless)",
                                    
                                    "Bias (unitless)",
                                    # "Bias for the three highest values of dry probability (unitless)",
                                    "MAE (unitless)",
                                    # "MAE for the three highest values of dry probability (unitless)",
                                    "RMSE (unitless)",
                                    # "RMSE for the three highest values of dry probability (unitless)",
                                    
                                    # "Bias in May (unitless)",
                                    # "Bias in June (unitless)",
                                    # "Bias in July (unitless)",
                                    # "Bias in August (unitless)",
                                    # "Bias in September (unitless)",
                                    
                                    # "MAE in May (unitless)",
                                    # "MAE in June (unitless)",
                                    # "MAE in July (unitless)",
                                    # "MAE in August (unitless)",
                                    # "MAE in September (unitless)",
                                    
                                    # "RMSE in May (unitless)",
                                    # "RMSE in June (unitless)",
                                    # "RMSE in July (unitless)",
                                    # "RMSE in August (unitless)",
                                    # "RMSE in September (unitless)",
                                    
                                    "NSE (unitless)",
                                    
                                    "Mean observed PFI (%)"),
                          axe = c("Intercept (sans unité)",
                                  "Proportion de la déviance (...)",
                                  "Pente (...)",
                                  "Proportion de la deviance (%)",
                                  "Kling-Gupta Efficiency (KGE, ....)",
                                  "Biais (...)", # rep("Biais (...)",2),
                                  "Erreur Moyenne Absolue (...)", # rep("Erreur Moyenne Absolue (...)",2),
                                  "Ecart Quadratique Moyen (...)", # rep("Ecart Quadratique Moyen (...)",2),
                                  
                                  # rep("Biais (...)",5),
                                  # rep("Erreur Moyenne Absolue (...)",5),
                                  # rep("Ecart Quadratique Moyen (...)",5),
                                  "NSE (...)",
                                  
                                  "Mean observed PFI (%)"))

for (g in 1:nrow(graph_list_)){
  
  print(graph_list_$variable[g])
  print(paste0(folder_output_,"/15_ResultatsModeles_ValidationParAnnees_ParHer/",nomSim_,"/TableGlobale/Map_English/"))
  print(paste0("_Boxplot_Globale_",graph_list_$variable[g],"_NonBoot_"))
  
  # output_boxplot_ <- list.files(list.files(path = paste0(folder_output_,
  #                                                        "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
  #                                                        nomSim_,
  #                                                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
  #                                                        ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
  #                                                        ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
  #                                                        "/TableGlobale/Map_English/"), pattern = paste0("_Boxplot_Globale_",graph_list_$variable[g],"_NonBoot"), full.names = T, include.dirs = T), pattern = ".rds", full.names = T)
  # if (nom_GCM_ != ""){
  #   output_boxplot_ = output_boxplot_[grepl(nom_GCM_,output_boxplot_)]
  # }
  
  ### A remettre ###
  # output_name_Global_1 <- list.files(list.files(path = paste0(folder_output_,
  #                                                  "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
  #                                                  nomSim_,
  #                                                  ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
  #                                                  ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
  #                                                  ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
  #                                                  "/TableGlobale/Map_English/"), pattern = paste0("_Map_Globale_",graph_list_[g],"_NonBoot"), full.names = T), pattern = "sansEtiq.rds", full.names = T)
  # output_name_Global_ <- output_name_Global_1
  
  output_name_Global_1 <- list.files(list.files(path = paste0(folder_output_,
                                                              "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                                                              nomSim_,
                                                              ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                                              "/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableGlobale/Map_English/"), pattern = paste0("_Map_Globale_",graph_list_$variable[g],"_NonBoot"), full.names = T, include.dirs = T),
                                     pattern = ".rds", full.names = T)
  if (nom_GCM_ != ""){
    output_name_Global_1 = output_name_Global_1[grepl(nom_GCM_,output_name_Global_1)]
  }
  
  # output_name_Global_2 <- list.files(list.files(path = paste0(folder_output_,
  #                                                             "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
  #                                                             nomSim_,
  #                                                             ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
  #                                                             "/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableGlobale/Map_English/"), pattern = paste0("_Map_Globale_",graph_list_$variable[g],"_NonBoot"), full.names = T, include.dirs = T),
  #                                    pattern = "sansEtiq", full.names = T)
  output_name_Global_2 <- list.files(list.files(path = paste0(folder_output_,
                                                              "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                                                              nomSim_,
                                                              ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                                              "/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableGlobale/Map_English/"), pattern = paste0("_Map_Globale_",graph_list_$variable[g],"_NonBoot"), full.names = T, include.dirs = T),
                                     pattern = "sansEt.rds", full.names = T)
  
  if (nom_GCM_ != ""){
    output_name_Global_2 = output_name_Global_2[grepl(nom_GCM_,output_name_Global_2)]
  }
  
  output_name_Global_ <- intersect(output_name_Global_1, output_name_Global_2)
  output_name_Global_ <- output_name_Global_[grepl(".rds",output_name_Global_)]
  
  output_name_1 <- list.files(list.files(path = paste0(folder_output_,
                                                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                                                       nomSim_,
                                                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                                                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                                                       "/TableGlobale/Map_English/"), pattern = paste0("_Map_Globale_",graph_list_$variable[g],"_NonBoot"), full.names = T), pattern = "sansEt.rds", full.names = T)
  if (nom_GCM_ != ""){
    output_name_1 = output_name_1[grepl(nom_GCM_,output_name_1)]
  }
  
  output_name_ <- output_name_1
  
  # Chemins vers les fichiers PNG (vous devrez les adapter selon leur emplacement)
  # chemin_boxplot <- output_boxplot_
  chemin_fichier1 <- output_name_Global_
  chemin_inter <- output_name_[1]
  chemin_humi <- output_name_[2]
  chemin_sech <- output_name_[3]
  
  # Importer les fichiers PNG
  # print(output_boxplot_)
  # imagebox <- readRDS(output_boxplot_)
  image1 <- readRDS(chemin_fichier1)
  image2 <- readRDS(chemin_humi)
  image3 <- readRDS(chemin_inter)
  image4 <- readRDS(chemin_sech)
  image1 <- image1 + ggtitle("Leave One Year\nOut Validation")
  image2 <- image2 + ggtitle("Validation during wet years\n(2013, 2014, 2016, 2018)")
  image3 <- image3 + ggtitle("Validation during intermediate\n(2012, 2015, 2020, 2021)")
  image4 <- image4 + ggtitle("Validation during dry years\n(2017, 2019, 2022)")
  
  
  scaleNorth_ = readRDS("/home/tjaouen/Documents/Input/FondsCartes/EchelleNord/EchelleNordGraph_1_20240308.rds")
  scaleNorth_ <- scaleNorth_ + theme(plot.margin = unit(c(-0.3,-0.3,-0.3,-0.3), 'cm'))
  
  graph_legend_ <- image1
  
  if (grepl("Biais",graph_list_$variable[g])){
    graph_legend_ <- graph_legend_ + theme(legend.position =  "bottom",
                                           # legend.justification = "left",
                                           legend.text = element_text(colour = "grey38", size = 10*ratio_epaisseurs_, margin = margin(t = 2, unit = "pt")),
                                           legend.title = element_blank(),
                                           legend.direction = "horizontal",
                                           legend.margin = margin(0, 0, 0, 0), # Réduire les marges de la légende
                                           legend.spacing.y = unit(0, 'cm'),
                                           legend.spacing.x = unit(-0.7, 'cm'),
                                           legend.key.width = unit(1.8, 'cm'),
                                           legend.key.height = unit(0.5, 'cm')) # Ajuster la marge interne à droite)+
  }else{
    graph_legend_ <- graph_legend_ + theme(legend.position =  "bottom",
                                           # legend.justification = "left",
                                           legend.text = element_text(colour = "grey38", size = 10*ratio_epaisseurs_, margin = margin(t = 2, unit = "pt")),
                                           legend.title = element_blank(),
                                           legend.direction = "horizontal",
                                           legend.margin = margin(0, 0, 0, 0), # Réduire les marges de la légende
                                           legend.spacing.y = unit(0, 'cm'),
                                           legend.spacing.x = unit(-0.4, 'cm'),
                                           legend.key.width = unit(1.3, 'cm'),
                                           legend.key.height = unit(0.5, 'cm')) # Ajuster la marge interne à droite)+
  }
  graph_legend_ <- graph_legend_ + guides(fill = guide_legend(nrow = 1,
                                                              override.aes = list(linewidth = 0),
                                                              label.vjust = 5,
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
  
  image1 <- prepareSubgraph(image1, pos_ = c(1,1), removeLegend = T)
  image2 <- prepareSubgraph(image2, pos_ = c(1,2), removeLegend = T)
  image3 <- prepareSubgraph(image3, pos_ = c(2,1), removeLegend = T)
  image4 <- prepareSubgraph(image4, pos_ = c(2,2), removeLegend = T)
  image1$layers <- image1$layers[-c(2,3)]
  image2$layers <- image2$layers[-c(2,3)]
  image3$layers <- image3$layers[-c(2,3)]
  image4$layers <- image4$layers[-c(2,3)]
  
  grid_legendAndNorth_ <- grid.arrange(
    arrangeGrob(
      cowplot::get_legend(graph_legend_),
      ncol = 1,
      widths = c(w_col5_),
      padding = unit(0, "cm")),
    nrow = 1#,
  )
  
  grid_head_ <- grid.arrange(
    
    # Ligne 5
    arrangeGrob(
      # nullGrob(),
      textGrob(graph_list_$titre[g],# title_,
               gp = gpar(fontsize = 20,
                         fontface = "bold",
                         col = "grey38"), vjust = 0.5),
      # nullGrob(),

      # nullGrob(),
      # rasterGrob(readJPEG("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/tlogoExplore2/Explore2_AgenceEau_2.jpg")), # Remplacer nullGrob() par rasterGrob() avec votre image
      
      ncol = 1,
      widths = c(#w_col1_/2,
                 w_col2_*2),#+w_col3_/2,
                 #w_col1_/2,
                 #w_col3_/2,
                 # w_col4_),
      padding = unit(0, "cm"))
  )
  
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
  
  
  grid_1_ <- grid.arrange(
    
    # Ligne 5
    arrangeGrob(
      grid_head_),
    
    # Ligne
    arrangeGrob(
      grid_scale_),
    
    # Ligne 5
    arrangeGrob(
      nullGrob(),
      ncol = 1,
      widths = c(w_col2_*2),
      padding = unit(0, "cm")),
    
    # Ligne 4
    # arrangeGrob(
    #   nullGrob(),
    #   textGrob("Historic runs\n(1976-2005)", vjust = 0, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_)),
    #   textGrob("Mid-term horizon\n(2041-2070)", vjust = 0, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_)),
    #   textGrob("Long-term horizon\n(2071-2100)", vjust = 0, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_)),
    #   ncol = 4,
    #   widths = c(w_col1_,w_col2_,w_col4_,w_col5_),
    #   padding = unit(0, "cm")),
    
    # Ligne 5
    arrangeGrob(
      ggplotGrob(image1),
      ggplotGrob(image2),
      ncol = 2,
      widths = c(w_col2_,w_col4_),
      padding = unit(0, "cm")),
    
    # Ligne 6
    arrangeGrob(
      ggplotGrob(image3),
      ggplotGrob(image4),
      ncol = 2,
      widths = c(w_col2_,w_col4_),
      padding = unit(0, "cm")),
    
    # Ligne 7
    # arrangeGrob(
    #   nullGrob(),
    #   nullGrob(),
    #   ncol = 2,
    #   widths = c(w_col2_,w_col4_),
    #   padding = unit(0, "cm")),
    
    nrow = 5,
    heights = c(h_line1_,h_lineScale_,h_line2_,h_graph_,h_graph_),
    padding = unit(0.3, "cm")  # ajuster la marge
    
  )
  
  
  if (!(dir.exists(paste0(folder_output_,
                          "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                          nomSim_,
                          ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                          ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                          ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                          "/TableGlobale/Map_English/Merge/")))){
    dir.create(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/Merge/"))
  }
  
  ggsave(paste0(folder_output_,
                "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                nomSim_,
                ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                "/TableGlobale/Map_English/Merge/",
                str_split(output_name_Global_1,"/")[[1]][17],
                ".tiff"),
         grid_1_,
         width = 20, height = 12)
  
  ggsave(paste0(folder_output_,
                "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                nomSim_,
                ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                "/TableGlobale/Map_English/Merge/",
                str_split(output_name_Global_1,"/")[[1]][17],
                ".png"),
         grid_1_,
         width = 20, height = 12)
  
  ggsave(paste0(folder_output_,
                "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                nomSim_,
                ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                "/TableGlobale/Map_English/Merge/",
                str_split(output_name_Global_1,"/")[[1]][17],
                ".svg"),
         grid_1_,
         width = 20, height = 12)
  
  ggsave(paste0(folder_output_,
                "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                nomSim_,
                ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                "/TableGlobale/Map_English/Merge/",
                str_split(output_name_Global_1,"/")[[1]][17],
                ".pdf"),
         grid_1_,
         width = 20, height = 12)
  # width = 900, height = 750,
  # width = 1200, height = 750,
  # units = "px", pointsize = 12)
  # width = ,
  # height = )
  
}

