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
    legend.position = "none",
    plot.subtitle = element_blank())
  graph_nl_$layers <- graph_nl_$layers[-c(2,3)]
  graph_nl_$layers[[1]]$aes_params$size = 0.18
  # graph_nl_$layers[[2]]$geom_params$height = 0
  # graph_nl_$layers[[3]]$geom_params$height = 0
  
  if (removeLegend){
    graph_nl_ <- graph_nl_ + theme(legend.position = "none")
  }else{
    graph_nl_ <- graph_nl_ + theme(legend.key.height = unit(0.45*ratio_epaisseurs_, "cm"),
                                   legend.key.width = unit(0.3*ratio_epaisseurs_, "cm"),
                                   legend.text = element_text(size = 9*ratio_epaisseurs_),
                                   legend.title = element_text(size = 9*ratio_epaisseurs_),
                                   legend.position = "left")
    # graph_nl_ <- graph_nl_ + theme(legend.position = "left",
    #                                legend.text = element_text(size = 16),
    #                                legend.title = element_text(size = 16)) +
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

# print(graph_list_$variable[g])
print(paste0(folder_output_,"/15_ResultatsModeles_ValidationParAnnees_ParHer/",nomSim_,"/TableMediane/Map_English/"))
# print(paste0("_Boxplot_Globale_",graph_list_$variable[g],"_NonBoot_"))

### A remettre ###
chemin_KGE_Obs <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableGlobale/Map_English/4_Map_Globale_KGE_NonBoot/KGE_NonBoot_sansEt.rds"
chemin_KGE_Wet <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/ApprentissageParDeuxCategoriesParmiSechesInterHumides/Validation_3AnneesSechesInterHumides/TableGlobale/Map_English/4_Map_Globale_KGE_NonBoot/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_ValidGlobale_13-14-16-18_Jm6Jj_logit_sansEt.rds"
chemin_KGE_Inter <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/ApprentissageParDeuxCategoriesParmiSechesInterHumides/Validation_3AnneesSechesInterHumides/TableGlobale/Map_English/4_Map_Globale_KGE_NonBoot/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_ValidGlobale_12-15-20-21_Jm6Jj_logit_sansEt.rds"
chemin_KGE_Dry <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/ApprentissageParDeuxCategoriesParmiSechesInterHumides/Validation_3AnneesSechesInterHumides/TableGlobale/Map_English/4_Map_Globale_KGE_NonBoot/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_ValidGlobale_17-19-22_Jm6Jj_logit_sansEt.rds"
chemin_NSE_Obs <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableGlobale/Map_English/8_Map_Globale_NSE_General_NonBoot/NSE_General_NonBoot_sansTxt_sansEt.rds"
chemin_NSE_Wet <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/ApprentissageParDeuxCategoriesParmiSechesInterHumides/Validation_3AnneesSechesInterHumides/TableGlobale/Map_English/8_Map_Globale_NSE_General_NonBoot/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_ValidGlobale_13-14-16-18_Jm6Jj_logit_sansTxt_sansEt.rds"
chemin_NSE_Inter <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/ApprentissageParDeuxCategoriesParmiSechesInterHumides/Validation_3AnneesSechesInterHumides/TableGlobale/Map_English/8_Map_Globale_NSE_General_NonBoot/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_ValidGlobale_12-15-20-21_Jm6Jj_logit_sansTxt_sansEt.rds"
chemin_NSE_Dry <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/ApprentissageParDeuxCategoriesParmiSechesInterHumides/Validation_3AnneesSechesInterHumides/TableGlobale/Map_English/8_Map_Globale_NSE_General_NonBoot/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_ValidGlobale_17-19-22_Jm6Jj_logit_sansTxt_sansEt.rds"
chemin_Bias_Obs <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableGlobale/Map_English/5_Map_Globale_Biais_General_NonBoot/Biais_General_NonBoot_sansEt.rds"
chemin_Bias_Wet <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/ApprentissageParDeuxCategoriesParmiSechesInterHumides/Validation_3AnneesSechesInterHumides/TableGlobale/Map_English/5_Map_Globale_Biais_General_NonBoot/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_ValidGlobale_13-14-16-18_Jm6Jj_logit_sansEt.rds"
chemin_Bias_Inter <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/ApprentissageParDeuxCategoriesParmiSechesInterHumides/Validation_3AnneesSechesInterHumides/TableGlobale/Map_English/5_Map_Globale_Biais_General_NonBoot/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_ValidGlobale_12-15-20-21_Jm6Jj_logit_sansEt.rds"
chemin_Bias_Dry <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/ApprentissageParDeuxCategoriesParmiSechesInterHumides/Validation_3AnneesSechesInterHumides/TableGlobale/Map_English/5_Map_Globale_Biais_General_NonBoot/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_ValidGlobale_17-19-22_Jm6Jj_logit_sansEt.rds"
chemin_ErrMoyAbs_Obs <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableGlobale/Map_English/6_Map_Globale_ErrMoyAbs_General_NonBoot/ErrMoyAbs_General_NonBoot_sansEt.rds"
chemin_ErrMoyAbs_Wet <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/ApprentissageParDeuxCategoriesParmiSechesInterHumides/Validation_3AnneesSechesInterHumides/TableGlobale/Map_English/6_Map_Globale_ErrMoyAbs_General_NonBoot/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_ValidGlobale_13-14-16-18_Jm6Jj_logit_sansEt.rds"
chemin_ErrMoyAbs_Inter <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/ApprentissageParDeuxCategoriesParmiSechesInterHumides/Validation_3AnneesSechesInterHumides/TableGlobale/Map_English/6_Map_Globale_ErrMoyAbs_General_NonBoot/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_ValidGlobale_12-15-20-21_Jm6Jj_logit_sansEt.rds"
chemin_ErrMoyAbs_Dry <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/ApprentissageParDeuxCategoriesParmiSechesInterHumides/Validation_3AnneesSechesInterHumides/TableGlobale/Map_English/6_Map_Globale_ErrMoyAbs_General_NonBoot/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_ValidGlobale_17-19-22_Jm6Jj_logit_sansEt.rds"
chemin_RMSE_Obs <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableGlobale/Map_English/7_Map_Globale_RMSE_General_NonBoot/RMSE_General_NonBoot_sansTxt_sansEt.rds"
chemin_RMSE_Wet <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/ApprentissageParDeuxCategoriesParmiSechesInterHumides/Validation_3AnneesSechesInterHumides/TableGlobale/Map_English/7_Map_Globale_RMSE_General_NonBoot/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_ValidGlobale_13-14-16-18_Jm6Jj_logit_sansTxt_sansEt.rds"
chemin_RMSE_Inter <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/ApprentissageParDeuxCategoriesParmiSechesInterHumides/Validation_3AnneesSechesInterHumides/TableGlobale/Map_English/7_Map_Globale_RMSE_General_NonBoot/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_ValidGlobale_12-15-20-21_Jm6Jj_logit_sansTxt_sansEt.rds"
chemin_RMSE_Dry <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/ApprentissageParDeuxCategoriesParmiSechesInterHumides/Validation_3AnneesSechesInterHumides/TableGlobale/Map_English/7_Map_Globale_RMSE_General_NonBoot/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_ValidGlobale_17-19-22_Jm6Jj_logit_sansTxt_sansEt.rds"

# Importer les fichiers PNG
# print(output_boxplot_)
image_KGE_Obs <- readRDS(chemin_KGE_Obs)
image_KGE_Wet <- readRDS(chemin_KGE_Wet)
image_KGE_Inter <- readRDS(chemin_KGE_Inter)
image_KGE_Dry <- readRDS(chemin_KGE_Dry)
image_NSE_Obs <- readRDS(chemin_NSE_Obs)
image_NSE_Wet <- readRDS(chemin_NSE_Wet)
image_NSE_Inter <- readRDS(chemin_NSE_Inter)
image_NSE_Dry <- readRDS(chemin_NSE_Dry)
image_Bias_Obs <- readRDS(chemin_Bias_Obs)
image_Bias_Wet <- readRDS(chemin_Bias_Wet)
image_Bias_Inter <- readRDS(chemin_Bias_Inter)
image_Bias_Dry <- readRDS(chemin_Bias_Dry)
image_ErrMoyAbs_Obs <- readRDS(chemin_ErrMoyAbs_Obs)
image_ErrMoyAbs_Wet <- readRDS(chemin_ErrMoyAbs_Wet)
image_ErrMoyAbs_Inter <- readRDS(chemin_ErrMoyAbs_Inter)
image_ErrMoyAbs_Dry <- readRDS(chemin_ErrMoyAbs_Dry)
image_RMSE_Obs <- readRDS(chemin_RMSE_Obs)
image_RMSE_Wet <- readRDS(chemin_RMSE_Wet)
image_RMSE_Inter <- readRDS(chemin_RMSE_Inter)
image_RMSE_Dry <- readRDS(chemin_RMSE_Dry)

scaleNorth_ = readRDS("/home/tjaouen/Documents/Input/FondsCartes/EchelleNord/EchelleNordGraph_1_20240308.rds")
scaleNorth_ <- scaleNorth_ + theme(plot.margin = unit(c(-0.3,-0.3,-0.3,-0.3), 'cm'))

graph_legend_ <- image_KGE_Obs

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

image_KGE_Obs <- prepareSubgraph(image_KGE_Obs, pos_ = c(1,1), removeLegend = F)
image_KGE_Wet <- prepareSubgraph(image_KGE_Wet, pos_ = c(1,2), removeLegend = T)
image_KGE_Inter <- prepareSubgraph(image_KGE_Inter, pos_ = c(1,3), removeLegend = T)
image_KGE_Dry <- prepareSubgraph(image_KGE_Dry, pos_ = c(1,4), removeLegend = T)
image_NSE_Obs <- prepareSubgraph(image_NSE_Obs, pos_ = c(2,1), removeLegend = F)
image_NSE_Wet <- prepareSubgraph(image_NSE_Wet, pos_ = c(2,2), removeLegend = T)
image_NSE_Inter <- prepareSubgraph(image_NSE_Inter, pos_ = c(2,3), removeLegend = T)
image_NSE_Dry <- prepareSubgraph(image_NSE_Dry, pos_ = c(2,4), removeLegend = T)
image_Bias_Obs <- prepareSubgraph(image_Bias_Obs, pos_ = c(3,1), removeLegend = F)
image_Bias_Wet <- prepareSubgraph(image_Bias_Wet, pos_ = c(3,2), removeLegend = T)
image_Bias_Inter <- prepareSubgraph(image_Bias_Inter, pos_ = c(3,3), removeLegend = T)
image_Bias_Dry <- prepareSubgraph(image_Bias_Dry, pos_ = c(3,4), removeLegend = T)
image_ErrMoyAbs_Obs <- prepareSubgraph(image_ErrMoyAbs_Obs, pos_ = c(4,1), removeLegend = F)
image_ErrMoyAbs_Wet <- prepareSubgraph(image_ErrMoyAbs_Wet, pos_ = c(4,2), removeLegend = T)
image_ErrMoyAbs_Inter <- prepareSubgraph(image_ErrMoyAbs_Inter, pos_ = c(4,3), removeLegend = T)
image_ErrMoyAbs_Dry <- prepareSubgraph(image_ErrMoyAbs_Dry, pos_ = c(4,4), removeLegend = T)
image_RMSE_Obs <- prepareSubgraph(image_RMSE_Obs, pos_ = c(5,1), removeLegend = F)
image_RMSE_Wet <- prepareSubgraph(image_RMSE_Wet, pos_ = c(5,2), removeLegend = T)
image_RMSE_Inter <- prepareSubgraph(image_RMSE_Inter, pos_ = c(5,3), removeLegend = T)
image_RMSE_Dry <- prepareSubgraph(image_RMSE_Dry, pos_ = c(5,4), removeLegend = T)

image_KGE_Obs$layers <- image_KGE_Obs$layers[-c(2,3)]
image_KGE_Wet$layers <- image_KGE_Wet$layers[-c(2,3)]
image_KGE_Inter$layers <- image_KGE_Inter$layers[-c(2,3)]
image_NSE_Dry$layers <- image_KGE_Dry$layers[-c(2,3)]
image_NSE_Obs$layers <- image_NSE_Obs$layers[-c(2,3)]
image_NSE_Wet$layers <- image_NSE_Wet$layers[-c(2,3)]
image_NSE_Inter$layers <- image_NSE_Inter$layers[-c(2,3)]
image_NSE_Dry$layers <- image_NSE_Dry$layers[-c(2,3)]
image_Bias_Obs$layers <- image_Bias_Obs$layers[-c(2,3)]
image_Bias_Wet$layers <- image_Bias_Wet$layers[-c(2,3)]
image_Bias_Inter$layers <- image_Bias_Inter$layers[-c(2,3)]
image_Bias_Dry$layers <- image_Bias_Dry$layers[-c(2,3)]
image_ErrMoyAbs_Obs$layers <- image_ErrMoyAbs_Obs$layers[-c(2,3)]
image_ErrMoyAbs_Wet$layers <- image_ErrMoyAbs_Wet$layers[-c(2,3)]
image_ErrMoyAbs_Inter$layers <- image_ErrMoyAbs_Inter$layers[-c(2,3)]
image_ErrMoyAbs_Dry$layers <- image_ErrMoyAbs_Dry$layers[-c(2,3)]
image_RMSE_Obs$layers <- image_RMSE_Obs$layers[-c(2,3)]
image_RMSE_Wet$layers <- image_RMSE_Wet$layers[-c(2,3)]
image_RMSE_Inter$layers <- image_RMSE_Inter$layers[-c(2,3)]
image_RMSE_Dry$layers <- image_RMSE_Dry$layers[-c(2,3)]

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
    nullGrob(),
    nullGrob(),
    ggplotGrob(scaleNorth_ +
                 ylim(max(layer_scales(scaleNorth_)$y$get_limits())-(max(layer_scales(scaleNorth_)$y$get_limits())-min(layer_scales(scaleNorth_)$y$get_limits()))*h_lineScale_/h_graph_,
                      max(layer_scales(scaleNorth_)$y$get_limits()))),
    ncol = 5,
    widths = c(2,w_col2_,w_col2_,w_col2_,w_col2_),
    padding = unit(0, "cm"))
  
)

x11()
grid_1_ <- grid.arrange(
  
  # Ligne
  arrangeGrob(
    nullGrob(),
    textGrob("Leave One Year\nOut Validation", vjust = 0, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_)),
    textGrob("Validation during wet years\n(2013, 2014, 2016, 2018)", vjust = 0, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_)),
    textGrob("Validation during intermediate years\n(2012, 2015, 2020, 2021)", vjust = 0, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_)),
    textGrob("Validation during dry years\n(2017, 2019, 2022)", vjust = 0, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_)),
    ncol = 5,
    widths = c(2,w_col2_,w_col2_,w_col2_,w_col2_),
    padding = unit(0, "cm")),
  
  # Ligne
  arrangeGrob(
    # ggplotGrob(image6),
    textGrob("KGE (unitless)", vjust = 0, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_), rot = 90),
    ggplotGrob(image_KGE_Obs),
    ggplotGrob(image_KGE_Wet),
    ggplotGrob(image_KGE_Inter),
    ggplotGrob(image_KGE_Dry),
    ncol = 5,
    widths = c(2,w_col2_,w_col2_,w_col2_,w_col2_),
    padding = unit(0, "cm")),
  
  # Ligne
  arrangeGrob(
    # ggplotGrob(image6),
    textGrob("NSE (unitless)", vjust = 0, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_), rot = 90),
    ggplotGrob(image_NSE_Obs),
    ggplotGrob(image_NSE_Wet),
    ggplotGrob(image_NSE_Inter),
    ggplotGrob(image_NSE_Dry),
    ncol = 5,
    widths = c(2,w_col2_,w_col2_,w_col2_,w_col2_),
    padding = unit(0, "cm")),
  
  # Ligne
  arrangeGrob(
    # ggplotGrob(image6),
    textGrob("Bias (unitless)", vjust = 0, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_), rot = 90),
    ggplotGrob(image_Bias_Obs),
    ggplotGrob(image_Bias_Wet),
    ggplotGrob(image_Bias_Inter),
    ggplotGrob(image_Bias_Dry),
    ncol = 5,
    widths = c(2,w_col2_,w_col2_,w_col2_,w_col2_),
    padding = unit(0, "cm")),

  # Ligne
  arrangeGrob(
    # ggplotGrob(image6),
    textGrob("MAE (unitless)", vjust = 0, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_), rot = 90),
    ggplotGrob(image_ErrMoyAbs_Obs),
    ggplotGrob(image_ErrMoyAbs_Wet),
    ggplotGrob(image_ErrMoyAbs_Inter),
    ggplotGrob(image_ErrMoyAbs_Dry),
    ncol = 5,
    widths = c(2,w_col2_,w_col2_,w_col2_,w_col2_),
    padding = unit(0, "cm")),
  
  # Ligne
  arrangeGrob(
    textGrob("RMSE (unitless)", vjust = 0, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_), rot = 90),
    ggplotGrob(image_RMSE_Obs),
    ggplotGrob(image_RMSE_Wet),
    ggplotGrob(image_RMSE_Inter),
    ggplotGrob(image_RMSE_Dry),
    ncol = 5,
    widths = c(2,w_col2_,w_col2_,w_col2_,w_col2_),
    padding = unit(0, "cm")),
  
  # Ligne
  arrangeGrob(
    grid_scale_),

  nrow = 7,
  heights = c(h_line2_,h_graph_,h_graph_,h_graph_,h_graph_,h_graph_,h_lineScale_),
  padding = unit(0.3, "cm")  # ajuster la marge
  
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

# ggsave(paste0(folder_output_,
#               "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
#               nomSim_,
#               "/TableGlobaleMerge/Map_English/MergeModels_",
#               gsub(".rds",".tiff",basename(chemin_1))),
#        grid_1_,
#        width = 20, height = 12)
# 
# ggsave(paste0(folder_output_,
#               "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
#               nomSim_,
#               "/TableGlobaleMerge/Map_English/MergeModels_",
#               gsub(".rds",".png",basename(chemin_1))),
#        grid_1_,
#        width = 20, height = 12)
# 
# ggsave(paste0(folder_output_,
#               "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
#               nomSim_,
#               "/TableGlobaleMerge/Map_English/MergeModels_",
#               gsub(".rds",".svg",basename(chemin_1))),
#        grid_1_,
#        width = 20, height = 12)
# 
# ggsave(paste0(folder_output_,
#               "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
#               nomSim_,
#               "/TableGlobaleMerge/Map_English/MergeModels_",
#               gsub(".rds",".pdf",basename(chemin_1))),
#        grid_1_,
#        width = 20, height = 12)
# # width = 900, height = 750,
# # width = 1200, height = 750,
# # units = "px", pointsize = 12)
# # width = ,
# # height = )


