source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunObs20122019.R")

# Charger les bibliothèques
library(png)
library(grid)
library(strex)
library(ggplot2)
library(cowplot)
library(gridExtra)

nomSim_ <- nomSim_param_
nom_categorieSimu_ <- nom_categorieSimu_param_
# nom_apprentissage_ <- nom_apprentissage_param_
# nom_validation_ <- nom_validation_param_
nom_apprentissage_ <- "ApprentissageParDeuxCategoriesParmiSechesInterHumides"
nom_validation_ <- "Validation_3AnneesSechesInterHumides"
folder_output_ <- folder_output_param_
nom_GCM_ = nom_GCM_param_

graph_list_ = data.frame( variable = c("Intercept","ProbaAssecFDCnulle","Slope","PropDev","KGE",
                                       "Biais_General", "Biais_Max3",
                                       "ErrMoyAbs_General", "ErrMoyAbs_Max3",
                                       "RMSE_General", "RMSE_Max3",
                                       "Biais_Mois05", "Biais_Mois06", "Biais_Mois07", "Biais_Mois08", "Biais_Mois09",
                                       "ErrMoyAbs_Mois05", "ErrMoyAbs_Mois06", "ErrMoyAbs_Mois07", "ErrMoyAbs_Mois08", "ErrMoyAbs_Mois09",
                                       "RMSE_Mois05", "RMSE_Mois06", "RMSE_Mois07", "RMSE_Mois08", "RMSE_Mois09",
                                       "NSE_General"),
                          titre = c("Logistic regression intercept",
                                    "Predicted probability of drying state at a zero exceedance frequency",
                                    "Logistic regression slope",
                                    "Proportion of total deviance explained by non-exceedance frequency of discharge",
                                    "Kling-Gupta Efficiency (KGE)",
                                    
                                    "Prediction bias",
                                    "Prediction bias for the three highest values of dry probability",
                                    "Mean Absolute Error (MAE)",
                                    "Mean Absolute Error (MAE) for the three highest values of dry probability",
                                    "Root Mean Square Error (RMSE)",
                                    "Root Mean Square Error (RMSE) for the three highest values of dry probability",
                                    
                                    "Prediction bias in May",
                                    "Prediction bias in June",
                                    "Prediction bias in July",
                                    "Prediction bias in August",
                                    "Prediction bias in September",
                                    
                                    "Mean Absolute Error (MAE) in May",
                                    "Mean Absolute Error (MAE) in June",
                                    "Mean Absolute Error (MAE) in July",
                                    "Mean Absolute Error (MAE) in August",
                                    "Mean Absolute Error (MAE) in September",
                                    
                                    "Root Mean Square Error (RMSE) in May",
                                    "Root Mean Square Error (RMSE) in June",
                                    "Root Mean Square Error (RMSE) in July",
                                    "Root Mean Square Error (RMSE) in August",
                                    "Root Mean Square Error (RMSE) in September",
                                    
                                    "Nash Sutcliffe Efficiency\n(unitless)"),
                          axe = c("Intercept (sans unité)",
                                  "Proportion de la déviance (...)",
                                  "Pente (...)",
                                  "Proportion de la deviance (%)",
                                  "Kling-Gupta Efficiency (KGE, ....)",
                                  rep("Biais (...)",2),
                                  rep("Erreur Moyenne Absolue (...)",2),
                                  rep("Ecart Quadratique Moyen (...)",2),
                                  
                                  rep("Biais (...)",5),
                                  rep("Erreur Moyenne Absolue (...)",5),
                                  rep("Ecart Quadratique Moyen (...)",5),
                                  "NSE (...)"))

for (g in 1:nrow(graph_list_)){
  
  print(graph_list_$variable[g])
  print(paste0(folder_output_,"/15_ResultatsModeles_ValidationParAnnees_ParHer/",nomSim_,"/TableGlobale/Map_English/"))
  print(paste0("_Boxplot_Globale_",graph_list_$variable[g],"_NonBoot_"))
  
  output_boxplot_ <- list.files(list.files(path = paste0(folder_output_,
                                                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                                                         nomSim_,
                                                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                                                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                                                         "/TableGlobale/Map_English/"), pattern = paste0("_Boxplot_Globale_",graph_list_$variable[g],"_NonBoot"), full.names = T, include.dirs = T), pattern = ".rds", full.names = T)
  if (nom_GCM_ != ""){
    output_boxplot_ = output_boxplot_[grepl(nom_GCM_,output_boxplot_)]
  }
  
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
  
  output_name_Global_2 <- list.files(list.files(path = paste0(folder_output_,
                                                              "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                                                              nomSim_,
                                                              ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                                              "/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableGlobale/Map_English/"), pattern = paste0("_Map_Globale_",graph_list_$variable[g],"_NonBoot"), full.names = T, include.dirs = T),
                                     pattern = "sansEtiq", full.names = T)
  if (nom_GCM_ != ""){
    output_name_Global_2 = output_name_Global_2[grepl(nom_GCM_,output_name_Global_2)]
  }
  
  output_name_Global_ <- intersect(output_name_Global_1, output_name_Global_2)
  output_name_Global_ <- output_name_Global_[grepl(".rds",output_name_Global_)]
  
  
  # output_name_Global_2 <- list.files(list.files(path = paste0(folder_output_,
  #                                                  "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
  #                                                  "17_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrOubliHerJointes20212022etFonctionSeuilOnde_SensiIntervJours_2012_2022_20230614/",
  #                                                  # nomSim_,
  #                                                  ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
  #                                                  ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
  #                                                  ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
  #                                                  "/TableGlobale/Map_English/"), pattern = paste0("_Map_Globale_",graph_list_[g],"_NonBoot"), full.names = T), pattern = "sansEtiq", full.names = T)
  #   
  # output_name_Global_ <- intersect(output_name_Global_1, output_name_Global_2)
  
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
  
  # output_name_2 <- list.files(list.files(path = paste0(folder_output_,
  #                                           "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
  #                                           nomSim_,
  #                                           ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
  #                                           ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
  #                                           ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
  #                                           "/TableGlobale/Map_English/"), pattern = paste0("_Map_Globale_",graph_list_[g],"_NonBoot"), full.names = T), pattern = "sansEtiq", full.names = T)
  # output_name_ <- intersect(output_name_1, output_name_2)
  # output_name_ <- output_name_[grepl(".rds",output_name_)]
  output_name_ <- output_name_1
  
  # Chemins vers les fichiers PNG (vous devrez les adapter selon leur emplacement)
  chemin_boxplot <- output_boxplot_
  chemin_fichier1 <- output_name_Global_
  chemin_inter <- output_name_[1]
  chemin_humi <- output_name_[2]
  chemin_sech <- output_name_[3]
  
  # Importer les fichiers PNG
  print(output_boxplot_)
  imagebox <- readRDS(output_boxplot_)
  image1 <- readRDS(chemin_fichier1)
  image2 <- readRDS(chemin_humi)
  image3 <- readRDS(chemin_inter)
  image4 <- readRDS(chemin_sech)
  
  # Ajouter une légende unique à partir d'un des graphiques
  legend_for_combined <- cowplot::get_legend(image1)
  # legend_for_combined <- legend_for_combined + theme(legend.title = element_text(text = graph_list_$axe[g]))
  # class(legend_for_combined)
  # legend_for_combined <- legend_for_combined + theme(legend.title = element_text(size = 12))
  
  image1_build_ = ggplot_build(image1)
  image2_build_ = ggplot_build(image2)
  image3_build_ = ggplot_build(image3)
  image4_build_ = ggplot_build(image4)
  
  if (!(identical(levels(image1_build_$plot$layers[[1]]$data$var_cut_), levels(image2_build_$plot$layers[[1]]$data$var_cut_)) & identical(levels(image1_build_$plot$layers[[1]]$data$var_cut_), levels(image3_build_$plot$layers[[1]]$data$var_cut_)) & identical(levels(image1_build_$plot$layers[[1]]$data$var_cut_), levels(image4_build_$plot$layers[[1]]$data$var_cut_)))){
    stop("Les légendes des graphes que vous essayez de réunir ne sont pas identiques entre elles.")
  }
  
  imagebox <- imagebox + theme(plot.title = element_blank(),
                               axis.text.x = element_text(size = 10),
                               axis.text.y = element_text(size = 10),
                               axis.title = element_text(size = 10))
  image1 <- image1 + theme(legend.position = "none", plot.title = element_text(size = 15))
  image2 <- image2 + theme(legend.position = "none", plot.title = element_text(size = 15))
  image3 <- image3 + theme(legend.position = "none", plot.title = element_text(size = 15))
  image4 <- image4 + theme(legend.position = "none", plot.title = element_text(size = 15))
  
  # image1 <- image1 + theme(legend.position = "none") + labs(title = NULL)
  # image2 <- image2 + theme(legend.position = "none") + labs(title = NULL)
  # image3 <- image3 + theme(legend.position = "none") + labs(title = NULL)
  # image4 <- image4 + theme(legend.position = "none") + labs(title = NULL)
  
  # Combinaison des graphiques avec cowplot
  combined_plots <- cowplot::plot_grid(image1, image2, image3, image4, ncol = 2, align = "hv")
  # combined_plots <- cowplot::plot_grid(image1, image2, image3, image4, ncol = 2, align = "hv")
  
  # Combinaison du graphique combiné et de la légende
  # final_plot <- cowplot::plot_grid(legend_for_combined, combined_plots, ncol = 1, rel_heights = c(0.2, 1))
  # final_plot <- cowplot::plot_grid(combined_plots, legend_for_combined, ncol = 2, rel_heights = c(1, 0.2), rel_widths = c(2,0.5))
  final_plot <- cowplot::plot_grid(imagebox, combined_plots, legend_for_combined, ncol = 3, rel_heights = c(2,8,2), rel_widths = c(5,15,5))
  
  # Ajouter un titre général au-dessus des graphes combinés
  title <- ggdraw() + draw_label(graph_list_$titre[g], fontface = "bold", x = 0.5, hjust = 0.5, size = 30)
  
  # Combinaison du titre et du graphique
  final_plot_with_title <- cowplot::plot_grid(final_plot, ncol = 1, rel_heights = c(0.1, 1)) +
    # final_plot_with_title <- cowplot::plot_grid(title, final_plot, ncol = 1, rel_heights = c(0.1, 1)) +
    theme_void()
  
  # Afficher le graphique combiné avec la légende commune et le titre
  # x11()
  # print(final_plot_with_title)
  
  # Assurez-vous de remplacer imagebox, image1, image2, image3 et image4 par vos objets ggplot. Assurez-vous également que la légende commune a été extraite correctement de l'un des graphiques et stockée dans legend_for_combined. Vous devrez peut-être ajuster les hauteurs relatives (rel_heights) pour l'agencement du titre et du graphique en fonction de vos préférences.
  # Ce code devrait organiser vos graphiques avec une légende commune et un titre général en utilisant cowplot.
  
  
  # Optionnel : Sauvegarder le graphique combiné au format PDF
  # ggsave("combined_plot.pdf", combined_plots, width = 10, height = 12)
  
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
                sub("Boxplot","GrapheMerge",str_before_first(str_after_first(output_boxplot_,"/Map_English//"),"/ModelRes")),
                "_",
                str_after_last(str_before_first(basename(output_boxplot_),"_day"),"-"),
                ".pdf"),
         final_plot_with_title,
         width = 20, height = 12)
  # width = 900, height = 750,
  # width = 1200, height = 750,
  # units = "px", pointsize = 12)
  # width = ,
  # height = )
  
}
