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

# nomCarte_ = "Moyenne_Mean_Value"
# nomCarte_ = "MedianDay_FirstP10_Value"
# nomCarte_ = "MedianDay_DernierP10_Value"
# nomCarte_ = "Mediane_Mean_Value"
# nomCarte_ = "Mediane_Median_Value"

### Parameters ###
folder_output_DD_ = folder_output_DD_param_
nomSim_ = nomSim_param_
ratio_epaisseurs_ = 1
# nom_categorieSimu_ = nom_categorieSimu_param_
# nom_categorieSimu_ = "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26"
# nom_categorieSimu_ = "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45"
# nom_categorieSimu_ = "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85"
# nom_categorieSimu_ = "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26"
# nom_categorieSimu_ = "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp45"
# nom_categorieSimu_ = "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85"
# nom_categorieSimu_ = "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26"
# nom_categorieSimu_ = "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp45"
# nom_categorieSimu_ = "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85"
# nom_categorieSimu_ = "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26"
# nom_categorieSimu_ = "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp45"
# nom_categorieSimu_ = "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85"

nom_categorieSimu_list_ = c(
  # "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26/",
  #                           "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45/",
  #                           "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/",
  #                           "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26/",
  #                           "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp45/",
  #                           "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/",
  #                           "J2000_20231128/ChroniquesCombinees_saf_hist_rcp26/",
  #                           "J2000_20231128/ChroniquesCombinees_saf_hist_rcp45/",
  #                           "J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/",
                            "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26/",
                            "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp45/",
                            "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/")#,
                            # "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26/",
                            # "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp45/",
                            # "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/")

date_intervalle_H0_ = c("1976-01-01","2005-12-31")
# date_intervalle_H0_ = c("1977-01-01","2004-12-31")
# date_intervalle_H1_ = c("2021-01-01","2050-12-31")
date_intervalle_H2_ = c("2041-01-01","2070-12-31")
# date_intervalle_H3_ = c("2071-01-01","2098-12-31")
date_intervalle_H3_ = c("2070-01-01","2099-12-31")


# nomCarte_ = "nbMoyenJoursParAnSup10pct_ProjMediane"
# title_ = paste0("Nombre moyen de jours par an avec une proportion\nd'assec supérieure à 10% (projection médiane)")
# subtitle_ = paste0("Modèle hydrologique : ",str_before_first(nom_categorieSimu_,"_"), " - Corr. Biais : ADAMONT")

# nomCarte_ = "propAssecMoyenneJuilletOct_ProjMediane"
# title_ = paste0("Probabilités moyennes d'assecs\nen juillet-octobre (projection médiane)")
# subtitle_ = paste0("Modèle hydrologique : ",str_before_first(nom_categorieSimu_,"_"), " - Corr. Biais : ADAMONT")

# nomCarte_ = "dateMedianeDebutSup10pct_ProjMediane"
# title_ = paste0("Date médiane de la première proportion d'assec\nsupérieure à 10% (à partir d'avril, projection médiane)")
# subtitle_ = paste0("Modèle hydrologique : ",str_before_first(nom_categorieSimu_,"_"), " - Corr. Biais : ADAMONT")

# nomCarte_ = "dateMedianeFinSup10pct_ProjMediane"
# title_ = paste0("Date médiane de la dernière proportion d'assec\nsupérieure à 10% (à partir d'avril, projection médiane)")
# subtitle_ = paste0("Modèle hydrologique : ",str_before_first(nom_categorieSimu_,"_"), " - Corr. Biais : ADAMONT")

### Dimensions ###
# h_line1_ = 5
# h_line2_ = 6
# h_graph_ = 26
# h_line4_ = 3
# w_col1_ = 2
# w_col2_ = 26
# w_col3_ = 26
# w_col4_ = 26
# w_col5_ = 26
# w_col6_ = 3

h_line1_ = 8
h_lineScale_ = 6
h_line2_ = 5
h_graph_ = 26
h_line4_ = 3
w_col1_ = 2
w_col2_ = 26
w_col3_ = 26
w_col4_ = 26
w_col5_ = 26
w_col6_ = 3

# HER_h_ = 2
HER_ <- c("2", "3", "5", "12", "13", "14", "17", "21", "22", "24", "25", "27", "28", "34", "35", "36",
          "38", "40", "41", "43", "44", "50", "51", "52", "53", "55", "56", "57", "58", "59", "61", 
          "62", "63", "64", "65", "66", "67", "68", "70", "71", "73", "74", "75", "76", "77", "78",
          "79", "81", "84", "85", "86", "87", "91", "93", "94", "97", "98", "99", "101", "103", "104",
          "105", "106", "107", "108", "112", "113", "117", "118", "120", "31033039", "37054", "69096",
          "89092", "49090")


### Run ###
for (nom_categorieSimu_ in nom_categorieSimu_list_){
  
  print(nom_categorieSimu_)
  
  data_frame_graphes_ <- data.frame(nomCarte_ = c(#"nbMoyenJoursParAnSup10pct_ProjMediane",
    # "nbMoyenJoursParAnSup20pct_ProjMediane",
    "propAssecMoyenneJuilletOct_ProjMediane"),#,
    #"dateMedianeDebutSup10pct_ProjMediane",
    # "dateMedianeDebutSup20pct_ProjMediane",
    # "dateMedianeFinSup20pct_ProjMediane",
    # "delaiMedianDebutSup20pct_ProjMediane",
    # "delaiMedianFinSup20pct_ProjMediane"),
    #"dateMedianeFinSup10pct_ProjMediane"),
    title_ = c(#"Average number of days per year with a proportion\nof dryness exceeding 10% (median projection)",
      # "Average number of days per year with a proportion\nof zero flows exceeding 20% (median projection)",
      "Average proportion of zero flows\nin July-October (median projection)"),
      #"Median date of the first proportion of dryness\nexceeding 10% (from April, median projection)",
      # "Median date of the first proportion of zero flows\nexceeding 20% (from April, median projection)",
      # "Median date of the last proportion of zero flows\nexceeding 20% (from April, median projection)",
      # "\nNumber of weeks in advance of the first\nday with over 20% of zero flows (median projection)",
      # "\nNumber of weeks delayed for the last day\nwith over 20% of zero flows (median projection)"),
    #"Median date of the last proportion of dryness\nexceeding 10% (from April, median projection)"),
    subtitle_ =   c(#paste0("Hydrological model: ", str_before_first(nom_categorieSimu_, "_"), " - Bias Correction: ADAMONT"),
      # paste0("Hydrological model: ", str_before_first(nom_categorieSimu_, "_"), " - Bias Correction: ADAMONT"),
      # paste0("Hydrological model: ", str_before_first(nom_categorieSimu_, "_"), " - Bias Correction: ADAMONT"),
      paste0("Hydrological model: ", str_before_first(nom_categorieSimu_, "_"), " - Bias Correction: ADAMONT")))#,
      # paste0("Hydrological model: ", str_before_first(nom_categorieSimu_, "_"), " - Bias Correction: ADAMONT"),
      # paste0("Hydrological model: ", str_before_first(nom_categorieSimu_, "_"), " - Bias Correction: ADAMONT"),
      # paste0("Hydrological model: ", str_before_first(nom_categorieSimu_, "_"), " - Bias Correction: ADAMONT"),
      # paste0("Hydrological model: ", str_before_first(nom_categorieSimu_, "_"), " - Bias Correction: ADAMONT")))
  
  # c("","","","","","")
  
  
  for (df_line_ in 1:nrow(data_frame_graphes_)){
    nomCarte_ = data_frame_graphes_$nomCarte_[df_line_]
    title_ = data_frame_graphes_$title_[df_line_]
    subtitle_ = data_frame_graphes_$subtitle_[df_line_]
    
    print(nomCarte_)
    
    ### Import chronicles ###
    map_HER_h_ = NULL # readRDS(paste0("/home/tjaouen/Documents/Input/HER/HER2hybrides/MapsIndividuelles/MapHER_",HER_h_,"_sansEt_1_20240305.rds"))
    print("Map OK")
    
    if (file.exists(paste0(folder_output_DD_,
                           "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                           nomSim_,
                           ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                           "/ChroniquesCombinees_saf_hist_rcp85/Map/",
                           "/Map_",nomCarte_,"_",year(date_intervalle_H0_[1]),year(date_intervalle_H0_[2]),"_1_20240327_sansTxt_sansEt.rds"))){
      rcp85_H0_ = readRDS(paste0(folder_output_DD_,
                                 "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                                 nomSim_,
                                 ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                                 "/ChroniquesCombinees_saf_hist_rcp85/Map/",
                                 "/Map_",nomCarte_,"_",year(date_intervalle_H0_[1]),year(date_intervalle_H0_[2]),"_1_20240327_sansTxt_sansEt.rds"))
    }else{
      rcp85_H0_ = readRDS(paste0(folder_output_DD_,
                                 "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                                 nomSim_,
                                 ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                                 # "/ChroniquesCombinees_saf_hist_rcp85/Map_saveAnciennesCouleurs/",
                                 "/ChroniquesCombinees_saf_hist_rcp85/Map/",
                                 "/Map_dateMedianeDebutSup20pct_ProjMediane_",year(date_intervalle_H0_[1]),year(date_intervalle_H0_[2]),"_1_20240327_sansTxt_sansEt.rds"))
    }
    print("rcp85_H0_ OK")
    
    # rcp85_H1_ = readRDS(paste0(folder_output_DD_,
    #                            "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
    #                            nomSim_,
    #                            ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
    #                            "/ChroniquesCombinees_saf_hist_rcp85/Map/",
    #                            "/Map_",nomCarte_,"_",year(date_intervalle_H1_[1]),year(date_intervalle_H1_[2]),"_1_20240327_sansTxt_sansEt.rds"))
    # print("rcp85_H1_ OK")
    
    rcp85_H2_ = readRDS(paste0(folder_output_DD_,
                               "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                               nomSim_,
                               ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                               "/ChroniquesCombinees_saf_hist_rcp85/Map/",
                               "/Map_",nomCarte_,"_",year(date_intervalle_H2_[1]),year(date_intervalle_H2_[2]),"_1_20240327_sansTxt_sansEt.rds"))
    print("rcp85_H2_ OK")
    
    rcp85_H3_ = readRDS(paste0(folder_output_DD_,
                               "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                               nomSim_,
                               ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                               "/ChroniquesCombinees_saf_hist_rcp85/Map/",
                               "/Map_",nomCarte_,"_",year(date_intervalle_H3_[1]),year(date_intervalle_H3_[2]),"_1_20240327_sansTxt_sansEt.rds"))
    print("rcp85_H3_ OK")
    
    
    if (file.exists(paste0(folder_output_DD_,
                           "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                           nomSim_,
                           ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                           "/ChroniquesCombinees_saf_hist_rcp45/Map/",
                           "/Map_",nomCarte_,"_",year(date_intervalle_H0_[1]),year(date_intervalle_H0_[2]),"_1_20240327_sansTxt_sansEt.rds"))){
      rcp45_H0_ = readRDS(paste0(folder_output_DD_,
                                 "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                                 nomSim_,
                                 ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                                 "/ChroniquesCombinees_saf_hist_rcp45/Map/",
                                 "/Map_",nomCarte_,"_",year(date_intervalle_H0_[1]),year(date_intervalle_H0_[2]),"_1_20240327_sansTxt_sansEt.rds"))
    }else{
      rcp45_H0_ = readRDS(paste0(folder_output_DD_,
                                 "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                                 nomSim_,
                                 ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                                 "/ChroniquesCombinees_saf_hist_rcp45/Map/",
                                 # "/ChroniquesCombinees_saf_hist_rcp45/Map_saveAnciennesCouleurs/",
                                 "/Map_dateMedianeDebutSup20pct_ProjMediane_",year(date_intervalle_H0_[1]),year(date_intervalle_H0_[2]),"_1_20240327_sansTxt_sansEt.rds"))
      graph_legend_ <- rcp85_H3_
    }
    print("rcp45_H0_ OK")
    
    # rcp45_H1_ = readRDS(paste0(folder_output_DD_,
    #                            "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
    #                            nomSim_,
    #                            ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
    #                            "/ChroniquesCombinees_saf_hist_rcp45/Map/",
    #                            "/Map_",nomCarte_,"_",year(date_intervalle_H1_[1]),year(date_intervalle_H1_[2]),"_1_20240327_sansTxt_sansEt.rds"))
    # print("rcp45_H1_ OK")
    
    rcp45_H2_ = readRDS(paste0(folder_output_DD_,
                               "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                               nomSim_,
                               ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                               "/ChroniquesCombinees_saf_hist_rcp45/Map/",
                               "/Map_",nomCarte_,"_",year(date_intervalle_H2_[1]),year(date_intervalle_H2_[2]),"_1_20240327_sansTxt_sansEt.rds"))
    print("rcp45_H2_ OK")
    
    rcp45_H3_ = readRDS(paste0(folder_output_DD_,
                               "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                               nomSim_,
                               ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                               "/ChroniquesCombinees_saf_hist_rcp45/Map/",
                               "/Map_",nomCarte_,"_",year(date_intervalle_H3_[1]),year(date_intervalle_H3_[2]),"_1_20240327_sansTxt_sansEt.rds"))
    print("rcp45_H3_ OK")
    
    if (file.exists(paste0(folder_output_DD_,
                           "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                           nomSim_,
                           ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                           "/ChroniquesCombinees_saf_hist_rcp26/Map/",
                           "/Map_",nomCarte_,"_",year(date_intervalle_H0_[1]),year(date_intervalle_H0_[2]),"_1_20240327_sansTxt_sansEt.rds"))){
      rcp26_H0_ = readRDS(paste0(folder_output_DD_,
                                 "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                                 nomSim_,
                                 ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                                 "/ChroniquesCombinees_saf_hist_rcp26/Map/",
                                 # "/ChroniquesCombinees_saf_hist_rcp26/Map_saveAnciennesCouleurs/",
                                 "/Map_",nomCarte_,"_",year(date_intervalle_H0_[1]),year(date_intervalle_H0_[2]),"_1_20240327_sansTxt_sansEt.rds"))
      graph_legend_ <- rcp26_H0_
    }else{
      rcp26_H0_ = readRDS(paste0(folder_output_DD_,
                                 "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                                 nomSim_,
                                 ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                                 "/ChroniquesCombinees_saf_hist_rcp26/Map/",
                                 "/Map_dateMedianeDebutSup20pct_ProjMediane_",year(date_intervalle_H0_[1]),year(date_intervalle_H0_[2]),"_1_20240327_sansTxt_sansEt.rds"))
    }
    print("rcp26_H0_ OK")
    
    # rcp26_H1_ = readRDS(paste0(folder_output_DD_,
    #                            "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
    #                            nomSim_,
    #                            ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
    #                            "/ChroniquesCombinees_saf_hist_rcp26/Map/",
    #                            "/Map_",nomCarte_,"_",year(date_intervalle_H1_[1]),year(date_intervalle_H1_[2]),"_1_20240327_sansTxt_sansEt.rds"))
    # print("rcp26_H1_ OK")
    
    rcp26_H2_ = readRDS(paste0(folder_output_DD_,
                               "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                               nomSim_,
                               ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                               "/ChroniquesCombinees_saf_hist_rcp26/Map/",
                               "/Map_",nomCarte_,"_",year(date_intervalle_H2_[1]),year(date_intervalle_H2_[2]),"_1_20240327_sansTxt_sansEt.rds"))
    print("rcp26_H2_ OK")
    
    rcp26_H3_ = readRDS(paste0(folder_output_DD_,
                               "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                               nomSim_,
                               ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                               # "/ChroniquesCombinees_saf_hist_rcp26/Map_saveAnciennesCouleurs/",
                               "/ChroniquesCombinees_saf_hist_rcp26/Map/",
                               "/Map_",nomCarte_,"_",year(date_intervalle_H3_[1]),year(date_intervalle_H3_[2]),"_1_20240327_sansTxt_sansEt.rds"))
    print("rcp26_H3_ OK")
    
    scaleNorth_ = readRDS("/home/tjaouen/Documents/Input/FondsCartes/EchelleNord/EchelleNordGraph_1_20240308.rds")
    scaleNorth_ <- scaleNorth_ + theme(plot.margin = unit(c(-0.3,-0.3,-0.3,-0.3), 'cm'))
    
    rcp26_H0_nl_ <- prepareSubgraph(rcp26_H0_, pos_ = c(1,1))
    # rcp26_H1_nl_ <- prepareSubgraph(rcp26_H1_, pos_ = c(1,1))
    rcp26_H2_nl_ <- prepareSubgraph(rcp26_H2_, pos_ = c(1,2))
    rcp26_H3_nl_ <- prepareSubgraph(rcp26_H3_, pos_ = c(1,3))
    rcp45_H0_nl_ <- prepareSubgraph(rcp45_H0_, pos_ = c(2,1))
    # rcp45_H1_nl_ <- prepareSubgraph(rcp45_H1_, pos_ = c(2,1))
    rcp45_H2_nl_ <- prepareSubgraph(rcp45_H2_, pos_ = c(2,2))
    rcp45_H3_nl_ <- prepareSubgraph(rcp45_H3_, pos_ = c(2,3))
    rcp85_H0_nl_ <- prepareSubgraph(rcp85_H0_, pos_ = c(1,1))
    rcp85_H0_l_ <- prepareSubgraph(rcp85_H0_, pos_ = c(1,1), removeLegend = F)
    # rcp85_H1_nl_ <- prepareSubgraph(rcp85_H1_, pos_ = c(3,1))
    rcp85_H2_nl_ <- prepareSubgraph(rcp85_H2_, pos_ = c(3,2))
    rcp85_H3_nl_ <- prepareSubgraph(rcp85_H3_, pos_ = c(3,3))
    
    graph_legend_ <- graph_legend_ + theme(legend.position =  "bottom",
                                           legend.text = element_text(colour = "grey38", size = 14*ratio_epaisseurs_),
                                           legend.title = element_blank(),
                                           legend.direction = "horizontal",
                                           legend.margin = margin(0, 0, 0, 0), # Réduire les marges de la légende
                                           legend.spacing.y = unit(0, 'cm'),
                                           legend.spacing.x = unit(-0.55, 'cm'),
                                           # legend.key = element_rect(colour = NULL),
                                           legend.key.width = unit(1.3, 'cm'),
                                           legend.key.height = unit(0.5, 'cm'))+
      guides(fill = guide_legend(nrow = 1,
                                 override.aes = list(linewidth = 0),
                                 label.vjust = 5,
                                 label.hjust = 0.5))# Réduire l'espacement interne de la légende
    
    parameters_annotationscale_ <- graph_legend_$layers[[2]]$geom_params
    # graph_legend_$theme$legend.text$vjust = unit(-5,"cm")
    graph_legend_$theme$legend.text$vjust = unit(5,"cm")
    graph_legend_$theme$legend.text$hjust = unit(-2,"cm")
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
    
    
    # layer_scales(scaleNorth_)$x$get_limits()
    
    
    # graphics.off()
    # x11()
    
    scaleNorth_$layers[[2]]$geom_params$pad_x = unit(0,"cm")
    scaleNorth_$layers[[2]]$geom_params$pad_y = unit(0.5,"cm")
    # scaleNorth_$layers[[2]]$geom_params$pad_y = unit(0,"cm")
    
    # scaleNorth_$layers[[3]]$geom_params$pad_x = unit(2,"cm")
    # scaleNorth_$layers[[3]]$geom_params$pad_y = unit(0.8,"cm")
    
    # scaleNorth_$layers[[3]]$geom_params$pad_x = unit(0,"cm")
    # scaleNorth_$layers[[3]]$geom_params$pad_y = unit(0,"cm")
    
    scaleNorth_$layers[[3]]$aes_params$location = "tl"
    scaleNorth_$layers[[3]]$geom_params$pad_x = unit(3.5,"cm")
    scaleNorth_$layers[[3]]$geom_params$pad_y = unit(0.2,"cm")
    
    # scaleNorth_$layers <- scaleNorth_$layers[-c(3)]
    
    
    
    
    grid_legendAndNorth_ <- grid.arrange(
      arrangeGrob(
        cowplot::get_legend(graph_legend_),
        #   ylim(max(layer_scales(rcp26_H0_)$y$get_limits())*0.99,
        #        max(layer_scales(rcp26_H0_)$y$get_limits())) +
        # xlim(max(layer_scales(rcp26_H0_)$x$get_limits())*0.99,
        #      max(layer_scales(rcp26_H0_)$x$get_limits())))),
        ncol = 1,
        widths = c(w_col5_),
        # widths = c(w_col5_*5/10,w_col5_*5/10),
        padding = unit(0, "cm")),
      nrow = 1#,
      # heights = c(h_line1_/2,h_line1_/2)
    )
    
    
    # grid_legend_scale_ <- grid.arrange(
    #   arrangeGrob(
    #     grid_legendAndNorth_,
    #     ggplotGrob(scaleNorth_ +
    #                  ylim(max(layer_scales(scaleNorth_)$y$get_limits())-(max(layer_scales(scaleNorth_)$y$get_limits())-min(layer_scales(scaleNorth_)$y$get_limits()))*(h_line1_/4)/h_graph_,
    #                       max(layer_scales(scaleNorth_)$y$get_limits()))),
    #     ncol = 1,
    #     widths = c(w_col5_),
    #     padding = unit(0, "cm")),
    #   nrow = 2,
    #   heights = c(h_line1_*3/4,h_line1_/4),
    #   padding = unit(3, "cm")
    #   
    # )
    
    
    grid_head_ <- grid.arrange(
      
      # Ligne 5
      arrangeGrob(
        nullGrob(),
        textGrob(title_,
                 gp = gpar(fontsize = 20,
                           fontface = "bold",
                           col = "grey38"), vjust = 0.5),
        # col = "#060403"), vjust = 0.5),
        # textGrob("RCP 2.6",vjust = 1, gp = gpar(col = "black", fontsize = 13), rot = 90),
        nullGrob(),
        grid_legendAndNorth_,
        # ggplotGrob(scaleNorth_ +
        #              ylim(max(layer_scales(scaleNorth_)$y$get_limits())-(max(layer_scales(scaleNorth_)$y$get_limits())-min(layer_scales(scaleNorth_)$y$get_limits()))*h_line1_/h_graph_,
        #                   max(layer_scales(scaleNorth_)$y$get_limits()))),
        # coord_fixed(ratio = 10/26)),
        
        # rasterGrob(readJPEG("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/tlogoExplore2/Logo_Explore2-1-900x400.jpg")), # Remplacer nullGrob() par rasterGrob() avec votre image
        # rasterGrob(readJPEG("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/tlogoExplore2/AgenceEau_RhoneMediteraneeCorse.jpg")), # Remplacer nullGrob() par rasterGrob() avec votre image
        
        rasterGrob(readJPEG("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/tlogoExplore2/Explore2_AgenceEau_2.jpg")), # Remplacer nullGrob() par rasterGrob() avec votre image
        # ggplotGrob(scaleNorth_ + theme(plot.margin = unit(c(2.76,0,0,0), 'cm'))),
        
        ncol = 5,
        widths = c(w_col1_/2,
                   w_col2_+w_col3_/2,
                   w_col1_/2,
                   w_col3_/2,
                   w_col4_),
        # widths = c(w_col1_/2,w_col2_+w_col3_,w_col4_/8*2,w_col4_/8*3,w_col4_/8,w_col5_,w_col4_/8*2+w_col1_/2,w_col4_/8*2+w_col1_/2),
        # widths = c(w_col1_,w_col2_+w_col3_/2,w_col3_/2+w_col4_/2,w_col4_/2+w_col5_/2,w_col5_/2),
        # widths = unit(c(w_col1_,w_col2_+w_col3_/2,w_col3_/2+w_col4_/2,w_col4_/2+w_col5_/2,w_col5_/2),'cm'),
        padding = unit(0, "cm"))
    )
    
    grid_scale_ <- grid.arrange(
      
      # Ligne 5
      arrangeGrob(
        nullGrob(),
        textGrob(subtitle_,
                 gp = gpar(fontsize = 15,
                           # fontface = "bold",
                           col = "grey38"), vjust = 0.5),
        ggplotGrob(scaleNorth_ +
                     ylim(max(layer_scales(scaleNorth_)$y$get_limits())-(max(layer_scales(scaleNorth_)$y$get_limits())-min(layer_scales(scaleNorth_)$y$get_limits()))*h_lineScale_/h_graph_,
                          max(layer_scales(scaleNorth_)$y$get_limits()))),
        nullGrob(),
        nullGrob(),
        # ggplotGrob(legend_north_ +
        #              xlim(max(layer_scales(rcp26_H0_)$x$get_limits())-(max(layer_scales(rcp26_H0_)$x$get_limits())-min(layer_scales(rcp26_H0_)$x$get_limits()))*0.05,
        #                   max(layer_scales(rcp26_H0_)$x$get_limits())) + 
        #              ylim(max(layer_scales(rcp26_H0_)$y$get_limits())-(max(layer_scales(rcp26_H0_)$y$get_limits())-min(layer_scales(rcp26_H0_)$y$get_limits()))*0.05,
        #                   max(layer_scales(rcp26_H0_)$y$get_limits()))),
        
        ncol = 5,
        widths = c(w_col1_/2,
                   w_col2_+w_col3_/2,
                   w_col3_,
                   w_col1_/2,
                   w_col4_/2),
        
        padding = unit(0, "cm"))
    )
    
    
    grid_1_ <- grid.arrange(
      
      # Ligne 5
      arrangeGrob(
        grid_head_),
      
      # Ligne
      arrangeGrob(
        grid_scale_),
      
      
      # nullGrob(),
      # textGrob(title_,
      #          gp = gpar(fontsize = 20,
      #                    fontface = "bold",
      #                    col = "grey38"), vjust = 0.5),
      # # col = "#060403"), vjust = 0.5),
      # # textGrob("RCP 2.6",vjust = 1, gp = gpar(col = "black", fontsize = 13), rot = 90),
      # nullGrob(),
      # grid_legend_scale_,
      # nullGrob(),
      # # ggplotGrob(scaleNorth_ +
      # #              ylim(max(layer_scales(scaleNorth_)$y$get_limits())-(max(layer_scales(scaleNorth_)$y$get_limits())-min(layer_scales(scaleNorth_)$y$get_limits()))*h_line1_/h_graph_,
      # #                   max(layer_scales(scaleNorth_)$y$get_limits()))),
      # # coord_fixed(ratio = 10/26)),
      # 
      # 
      # rasterGrob(readJPEG("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/tlogoExplore2/Logo_Explore2-1-900x400.jpg")), # Remplacer nullGrob() par rasterGrob() avec votre image
      # rasterGrob(readJPEG("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/tlogoExplore2/AgenceEau_RhoneMediteraneeCorse.jpg")), # Remplacer nullGrob() par rasterGrob() avec votre image
      # # ggplotGrob(scaleNorth_ + theme(plot.margin = unit(c(2.76,0,0,0), 'cm'))),
      # 
      # ncol = 7,
      # widths = c(w_col1_/2,w_col2_+w_col3_,w_col4_/8*2,w_col5_,w_col4_/8*2,w_col4_,w_col4_),
      # # widths = c(w_col1_/2,w_col2_+w_col3_,w_col4_/8*2,w_col4_/8*3,w_col4_/8,w_col5_,w_col4_/8*2+w_col1_/2,w_col4_/8*2+w_col1_/2),
      # # widths = c(w_col1_,w_col2_+w_col3_/2,w_col3_/2+w_col4_/2,w_col4_/2+w_col5_/2,w_col5_/2),
      # # widths = unit(c(w_col1_,w_col2_+w_col3_/2,w_col3_/2+w_col4_/2,w_col4_/2+w_col5_/2,w_col5_/2),'cm'),
      # padding = unit(0, "cm")),
      
      # Ligne 4
      arrangeGrob(
        nullGrob(),
        textGrob("Historic runs\n(1976-2005)", vjust = 0, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_)),
        # textGrob("Reference emission scenario\n(1976-2005)", vjust = 0, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_)),
        # textGrob("Near-term Horizon (2021-2050)", vjust = 2, gp = gpar(col = "grey38", fontsize = 13)),
        textGrob("Mid-term horizon\n(2041-2070)", vjust = 0, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_)),
        textGrob("Long-term horizon\n(2071-2100)", vjust = 0, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_)),
        # textGrob("Scénarios d’émissions Référence (1976-2005)", vjust = 2, gp = gpar(col = "grey38", fontsize = 13)),
        # # textGrob("Horizon proche (2021-2050)", vjust = 2, gp = gpar(col = "grey38", fontsize = 13)),
        # textGrob("Horizon moyen (2041-2070)", vjust = 2, gp = gpar(col = "grey38", fontsize = 13)),
        # textGrob("Horizon lointain (2071-2100)", vjust = 2, gp = gpar(col = "grey38", fontsize = 13)),
        ncol = 4,
        # ncol = 5,
        widths = c(w_col1_,w_col2_,w_col4_,w_col5_),
        # widths = c(w_col1_,w_col2_,w_col3_,w_col4_,w_col5_),
        # widths = unit(c(w_col1_,w_col2_,w_col3_,w_col4_,w_col5_),'cm'),
        padding = unit(0, "cm")),
      
      # Ligne 5
      arrangeGrob(
        textGrob("RCP 2.6",vjust = 1, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_), rot = 90),
        ggplotGrob(rcp26_H0_nl_),
        # ggplotGrob(rcp26_H1_nl_),
        ggplotGrob(rcp26_H2_nl_),
        ggplotGrob(rcp26_H3_nl_),
        
        ncol = 4,
        # ncol = 5,
        widths = c(w_col1_,w_col2_,w_col4_,w_col5_),
        # widths = c(w_col1_,w_col2_,w_col3_,w_col4_,w_col5_),
        # widths = unit(c(w_col1_,w_col2_,w_col3_,w_col4_,w_col5_),'cm'),
        padding = unit(0, "cm")),
      
      # Ligne 6
      arrangeGrob(
        textGrob("RCP 4.5",vjust = 1, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_), rot = 90),
        ggplotGrob(rcp45_H0_nl_),
        # ggplotGrob(rcp45_H1_nl_),
        ggplotGrob(rcp45_H2_nl_),
        ggplotGrob(rcp45_H3_nl_),
        ncol = 4,
        # ncol = 5,
        widths = c(w_col1_,w_col2_,w_col4_,w_col5_),
        # widths = c(w_col1_,w_col2_,w_col3_,w_col4_,w_col5_),
        # widths = unit(c(w_col1_,w_col2_,w_col3_,w_col4_,w_col5_),'cm'),
        padding = unit(0, "cm")),
      
      # Ligne 7
      arrangeGrob(
        textGrob("RCP 8.5",vjust = 1, gp = gpar(col = "grey38", fontsize = 16*ratio_epaisseurs_), rot = 90),
        ggplotGrob(rcp85_H0_nl_),
        # ggplotGrob(rcp85_H1_nl_),
        ggplotGrob(rcp85_H2_nl_),
        ggplotGrob(rcp85_H3_nl_),
        ncol = 4,
        # ncol = 5,
        widths = c(w_col1_,w_col2_,w_col4_,w_col5_),
        # widths = c(w_col1_,w_col2_,w_col3_,w_col4_,w_col5_),
        # widths = unit(c(w_col1_,w_col2_,w_col3_,w_col4_,w_col5_),'cm'),
        padding = unit(0, "cm")),
      
      nrow = 6,
      heights = c(h_line1_,h_line2_,h_lineScale_,h_graph_,h_graph_,h_graph_),
      # heights = unit(c(h_line1_,h_line2_,h_graph_,h_graph_,h_graph_),'cm'),
      # heights = c(h_line1_,h_line2_,h_graph_,h_graph_,h_graph_),
      padding = unit(0, "cm")  # ajuster la marge
      
    )
    
    ggsave(paste0(folder_output_DD_,
                  "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                  nomSim_,
                  ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                  "/PanneauMap/Mean_English/ProbaBoard_",
                  ifelse(nom_categorieSimu_=="","",str_before_first(nom_categorieSimu_,"/")),"_",
                  nomCarte_,"_English_1_20240330.svg"),
           plot = grid_1_) # width=15
    
    ggsave(paste0(folder_output_DD_,
                  "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                  nomSim_,
                  ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                  "/PanneauMap/Mean_English/ProbaBoard_",
                  ifelse(nom_categorieSimu_=="","",str_before_first(nom_categorieSimu_,"/")),"_",
                  nomCarte_,"_English_1_20240330.png"),
           plot = grid_1_)
    
    ggsave(paste0(folder_output_DD_,
                  "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                  nomSim_,
                  ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                  "/PanneauMap/Mean_English/ProbaBoard_",
                  ifelse(nom_categorieSimu_=="","",str_before_first(nom_categorieSimu_,"/")),"_",
                  nomCarte_,"_English_1_20240330.pdf"),
           plot = grid_1_) # width=15
    
  }
}



