source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")

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
  
  graph_nl_ <- graph_ + theme(plot.title = element_blank(),
                              plot.margin = unit(c(0.5,0.5,0.5,0.5), 'cm'),
                              axis.text.x = element_text(size = 11, color = "grey38"),
                              axis.text.y = element_text(size = 11, color = "grey38"),
                              axis.ticks.length = unit(0.2,"cm"),
                              legend.spacing.x = unit(0.6,"cm"),
                              legend.spacing.y = unit(0,"cm"),
                              legend.text = element_text(hjust = 0, margin = margin(r = 30, unit = "pt")),
                              plot.subtitle = element_blank()) #+
  # scale_x_date(labels = c("","J","","F","","M","","A","","M","","J","","J","","A","","S","","O","","N","","D",""))
  
  if (removeLegend){
    graph_nl_ <- graph_nl_ + theme(legend.position = "none")
  }else{
    graph_nl_ <- graph_nl_ + theme(legend.text = element_text(size = 11*ratio_epaisseurs_, color = "grey38"),
                                   legend.title = element_text(size = 11*ratio_epaisseurs_, face = "bold", color = "grey38")) +
      guides(color = guide_legend(keyheight = unit(1.4,"cm"),
                                  ncol = 2))
  }
  
  # graph_nl_$layers[[1]]$linewidth = 0.5
  graph_nl_$layers[[1]]$aes_params$linewidth = 0.5
  if (length(graph_nl_$layers) > 1){
    
    # graph_nl_$layers[[2]]$linewidth = 0.5
    # graph_nl_$layers[[3]]$linewidth = 0.4
    
    # graph_nl_$layers[[2]]$linewidth = 1.2
    # graph_nl_$layers[[3]]$linewidth = 1
    
    graph_nl_$layers[[2]]$aes_params$linewidth = 1.2
    
    if (length(graph_nl_$layers) > 2){
      graph_nl_$layers[[3]]$aes_params$linewidth = 1
    }
  }
  
  return(graph_nl_)
}

### Parameters ###
folder_output_DD_ = folder_output_DD_param_
nomSim_ = nomSim_param_
nom_categorieSimu_ = nom_categorieSimu_param_
ratio_epaisseurs_ = 1.4

date_intervalle_H0_ = c("1976-01-01","2005-12-31")
# date_intervalle_H0_ = c("1977-01-01","2004-12-31")
date_intervalle_H1_ = c("2021-01-01","2050-12-31")
date_intervalle_H2_ = c("2041-01-01","2070-12-31")
date_intervalle_H3_ = c("2071-01-01","2098-12-31")

## Dates visees dans version definitive ##
# date_intervalle_H0_ = c("1976-01-01","2005-12-31")
# date_intervalle_H1_ = c("2021-01-01","2050-12-31")
# date_intervalle_H2_ = c("2041-01-01","2070-12-31")
# date_intervalle_H3_ = c("2071-01-01","2100-12-31")

### Dimensions ###
h_line1_ = 8
h_line2_ = 2
h_graph_ = 20
h_line4_ = 3
w_col1_ = 1
w_col2_ = 20
w_col3_ = 0.1
w_col4_ = 20
w_col5_ = 20

pattern_rcp_replace_ = data.frame(aRemplacer = c(NA,"rcp85","rcp45","rcp26"),
                                  remplacement = c("Historical","RCP 8.5","RCP 4.5","RCP 2.6"))

# HER_h_ = 2
HER_ <- c("2", "3", "5", "12", "13", "14", "17", "21", "22", "24", "25", "27", "28", "34", "35", "36",
          "38", "40", "41", "43", "44", "50", "51", "52", "53", "55", "56", "57", "58", "59", "61",
          "62", "63", "64", "65", "66", "67", "68", "70", "71", "73", "74", "75", "76", "77", "78",
          "79", "81", "84", "85", "86", "87", "91", "93", "94", "97", "98", "99", "101", "103", "104",
          "105", "106", "107", "108", "112", "113", "117", "118", "120", "31033039", "37054", "69096",
          "89092", "49090")

HER_eliminees_J2000 <- c("10", "21", "22", "24", "27", "34", "35", "36", "57", "59", "61", "65", "67", "68",
                         "77", "78", "93", "94", "103", "108", "118", "0", "31033039", "69096",
                         "66", "64", "117", "112", "56", "62", "38", "40", "105", "17", "25", "107",
                         "55", "12", "53")

if (str_before_first(nom_categorieSimu_,"_") == "J2000"){
  HER_ <- HER_[which(!(HER_ %in% HER_eliminees_J2000))]
}



for (HER_h_ in HER_){
  
  print(paste0("HER : ",HER_h_))
  ### Import chronicles ###
  map_HER_h_ = readRDS(paste0("/home/tjaouen/Documents/Input/HER/HER2hybrides/MapsIndividuelles/MapHER_",HER_h_,"_sansEt_1_20240305.rds"))
  map_HER_h_$layers[[2]]$aes_params$size = 0.25
  print("Map OK")
  
  rcp85_H0_ = readRDS(paste0(folder_output_DD_,
                             "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                             nomSim_,
                             ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                             "/ChroniquesCombinees_saf_hist_rcp85/Chroniques/",
                             year(date_intervalle_H0_[1]),year(date_intervalle_H0_[2]),"/Eng/ProbaMeanValue_rcp85_",year(date_intervalle_H0_[1]),year(date_intervalle_H0_[2]),"_HER",HER_h_,"_Eng_1_20240227.rds"))
  print("rcp85_H0_ OK")
  
  rcp85_H1_ = readRDS(paste0(folder_output_DD_,
                             "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                             nomSim_,
                             ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                             "/ChroniquesCombinees_saf_hist_rcp85/Chroniques/",
                             year(date_intervalle_H1_[1]),year(date_intervalle_H1_[2]),"/Eng/ProbaMeanValue_rcp85_",year(date_intervalle_H1_[1]),year(date_intervalle_H1_[2]),"_HER",HER_h_,"_Eng_1_20240227.rds"))
  print("rcp85_H1_ OK")
  
  rcp85_H2_ = readRDS(paste0(folder_output_DD_,
                             "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                             nomSim_,
                             ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                             "/ChroniquesCombinees_saf_hist_rcp85/Chroniques/",
                             year(date_intervalle_H2_[1]),year(date_intervalle_H2_[2]),"/Eng/ProbaMeanValue_rcp85_",year(date_intervalle_H2_[1]),year(date_intervalle_H2_[2]),"_HER",HER_h_,"_Eng_1_20240227.rds"))
  print("rcp85_H2_ OK")
  
  rcp85_H3_ = readRDS(paste0(folder_output_DD_,
                             "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                             nomSim_,
                             ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                             "/ChroniquesCombinees_saf_hist_rcp85/Chroniques/",
                             year(date_intervalle_H3_[1]),year(date_intervalle_H3_[2]),"/Eng/ProbaMeanValue_rcp85_",year(date_intervalle_H3_[1]),year(date_intervalle_H3_[2]),"_HER",HER_h_,"_Eng_1_20240227.rds"))
  print("rcp85_H3_ OK")
  
  
  rcp45_H0_ = readRDS(paste0(folder_output_DD_,
                             "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                             nomSim_,
                             ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                             "/ChroniquesCombinees_saf_hist_rcp45/Chroniques/",
                             year(date_intervalle_H0_[1]),year(date_intervalle_H0_[2]),"/Eng/ProbaMeanValue_rcp45_",year(date_intervalle_H0_[1]),year(date_intervalle_H0_[2]),"_HER",HER_h_,"_bk_Eng_1_20240227.rds"))
  print("rcp45_H0_ OK")
  
  rcp45_H1_ = readRDS(paste0(folder_output_DD_,
                             "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                             nomSim_,
                             ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                             "/ChroniquesCombinees_saf_hist_rcp45/Chroniques/",
                             year(date_intervalle_H1_[1]),year(date_intervalle_H1_[2]),"/Eng/ProbaMeanValue_rcp45_",year(date_intervalle_H1_[1]),year(date_intervalle_H1_[2]),"_HER",HER_h_,"_bk_Eng_1_20240227.rds"))
  print("rcp45_H1_ OK")
  
  rcp45_H2_ = readRDS(paste0(folder_output_DD_,
                             "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                             nomSim_,
                             ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                             "/ChroniquesCombinees_saf_hist_rcp45/Chroniques/",
                             year(date_intervalle_H2_[1]),year(date_intervalle_H2_[2]),"/Eng/ProbaMeanValue_rcp45_",year(date_intervalle_H2_[1]),year(date_intervalle_H2_[2]),"_HER",HER_h_,"_bk_Eng_1_20240227.rds"))
  print("rcp45_H2_ OK")
  
  rcp45_H3_ = readRDS(paste0(folder_output_DD_,
                             "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                             nomSim_,
                             ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                             "/ChroniquesCombinees_saf_hist_rcp45/Chroniques/",
                             year(date_intervalle_H3_[1]),year(date_intervalle_H3_[2]),"/Eng/ProbaMeanValue_rcp45_",year(date_intervalle_H3_[1]),year(date_intervalle_H3_[2]),"_HER",HER_h_,"_bk_Eng_1_20240227.rds"))
  print("rcp45_H3_ OK")
  
  
  rcp26_H0_ = readRDS(paste0(folder_output_DD_,
                             "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                             nomSim_,
                             ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                             "/ChroniquesCombinees_saf_hist_rcp26/Chroniques/",
                             year(date_intervalle_H0_[1]),year(date_intervalle_H0_[2]),"/Eng/ProbaMeanValue_rcp26_",year(date_intervalle_H0_[1]),year(date_intervalle_H0_[2]),"_HER",HER_h_,"_bk_Eng_1_20240227.rds"))
  print("rcp26_H0_ OK")
  
  rcp26_H1_ = readRDS(paste0(folder_output_DD_,
                             "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                             nomSim_,
                             ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                             "/ChroniquesCombinees_saf_hist_rcp26/Chroniques/",
                             year(date_intervalle_H1_[1]),year(date_intervalle_H1_[2]),"/Eng/ProbaMeanValue_rcp26_",year(date_intervalle_H1_[1]),year(date_intervalle_H1_[2]),"_HER",HER_h_,"_bk_Eng_1_20240227.rds"))
  print("rcp26_H1_ OK")
  
  rcp26_H2_ = readRDS(paste0(folder_output_DD_,
                             "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                             nomSim_,
                             ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                             "/ChroniquesCombinees_saf_hist_rcp26/Chroniques/",
                             year(date_intervalle_H2_[1]),year(date_intervalle_H2_[2]),"/Eng/ProbaMeanValue_rcp26_",year(date_intervalle_H2_[1]),year(date_intervalle_H2_[2]),"_HER",HER_h_,"_bk_Eng_1_20240227.rds"))
  print("rcp26_H2_ OK")
  
  rcp26_H3_ = readRDS(paste0(folder_output_DD_,
                             "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                             nomSim_,
                             ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                             "/ChroniquesCombinees_saf_hist_rcp26/Chroniques/",
                             year(date_intervalle_H3_[1]),year(date_intervalle_H3_[2]),"/Eng/ProbaMeanValue_rcp26_",year(date_intervalle_H3_[1]),year(date_intervalle_H3_[2]),"_HER",HER_h_,"_bk_Eng_1_20240227.rds"))
  print("rcp26_H3_ OK")
  
  liste = c("31033039", "37054", "69096", "89092", "49090")
  if (sum(HER_h_ %in% liste)>0){
    if (HER_h_ != "49090"){
      HER_h_ = gsub("0","+",HER_h_)
    }else{
      HER_h_ = "49+90"
    }
  }
  
  rcp85_H0_nl_ <- prepareSubgraph(rcp85_H0_, pos_ = c(1,1), removeLegend = T)
  rcp85_H0_l_ <- prepareSubgraph(rcp85_H0_, pos_ = c(1,1), removeLegend = F)
  rcp26_H1_nl_ <- prepareSubgraph(rcp26_H1_, pos_ = c(1,1), removeLegend = T)
  rcp26_H2_nl_ <- prepareSubgraph(rcp26_H2_, pos_ = c(1,2), removeLegend = T)
  rcp26_H3_nl_ <- prepareSubgraph(rcp26_H3_, pos_ = c(1,3), removeLegend = T)
  rcp45_H1_nl_ <- prepareSubgraph(rcp45_H1_, pos_ = c(2,1), removeLegend = T)
  rcp45_H2_nl_ <- prepareSubgraph(rcp45_H2_, pos_ = c(2,2), removeLegend = T)
  rcp45_H3_nl_ <- prepareSubgraph(rcp45_H3_, pos_ = c(2,3), removeLegend = T)
  rcp85_H1_nl_ <- prepareSubgraph(rcp85_H1_, pos_ = c(3,1), removeLegend = T)
  rcp85_H2_nl_ <- prepareSubgraph(rcp85_H2_, pos_ = c(3,2), removeLegend = T)
  rcp85_H3_nl_ <- prepareSubgraph(rcp85_H3_, pos_ = c(3,3), removeLegend = T)
  
  rcp85_H0_l_$guides$alpha$keyheight = unit(2,"lines")
  
  grid_1_ <- grid.arrange(
    
    # # Ligne 1
    arrangeGrob(
      nullGrob(),
      # textGrob(rcp26_H1_nl_$labels$title,
      textGrob(paste0("Average proportion of zero flows smoothed over 5 days\nHydrological model: ",str_before_first(nom_categorieSimu_,"_")," - HER ",HER_h_),
               gp = gpar(fontsize = 15*ratio_epaisseurs_,
                         fontface = "bold",
                         col = "grey38"), vjust = 0.5),
      nullGrob(),
      rasterGrob(readJPEG("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/tlogoExplore2/Logo_Explore2-1-900x400.jpg")), # Remplacer nullGrob() par rasterGrob() avec votre image
      ncol = 4,
      widths = c(w_col1_,w_col2_+w_col4_/3*2,w_col3_,w_col4_/3),
      padding = unit(0.1, "cm")),
    
    # Ligne 2
    arrangeGrob(
      nullGrob(),
      textGrob("Historic runs (1976-2005)", vjust = 1, gp = gpar(col = "grey38", fontsize = 11*ratio_epaisseurs_)),
      nullGrob(),
      nullGrob(),
      ncol = 4,
      widths = c(w_col1_,w_col2_,w_col3_,w_col4_),
      padding = unit(0.1, "cm")),
    
    # Ligne 3
    arrangeGrob(
      # textGrob("Historical climate", vjust = 1, gp = gpar(col = "grey38", fontsize = 11*ratio_epaisseurs_), rot = 90),
      nullGrob(),
      ggplotGrob(rcp85_H0_nl_),
      nullGrob(),
      cowplot::get_legend(rcp85_H0_l_),
      ncol = 4,
      widths = c(w_col1_,w_col2_,w_col3_,w_col4_),
      padding = unit(0.1, "cm")),
    
    nrow = 3,
    heights = c(h_line1_,h_line2_,h_graph_),
    padding = unit(0.1, "cm")  # ajuster la marge
    
  )
  
  grid_2_ <- grid.arrange(
    grid_1_,
    ggplotGrob(map_HER_h_),
    ncol = 2,
    widths = c(w_col1_+w_col2_+w_col3_+w_col4_,w_col5_)
  )
  
  grid_graph_ <- grid.arrange(
    
    # Ligne 4
    arrangeGrob(
      nullGrob(),
      # textGrob(paste0("Pér",str_before_first(str_after_first(rcp26_H1_nl_$labels$subtitle," - Pér")," - HER")), vjust = 2, gp = gpar(col = "black", fontsize = 11)),
      textGrob("Near-term Horizon (2021-2050)", vjust = 2, gp = gpar(col = "grey38", fontsize = 11*ratio_epaisseurs_)),
      nullGrob(),
      textGrob("Medium-term Horizon (2041-2070)", vjust = 2, gp = gpar(col = "grey38", fontsize = 11*ratio_epaisseurs_)),
      textGrob("Long-term Horizon (2071-2100)", vjust = 2, gp = gpar(col = "grey38", fontsize = 11*ratio_epaisseurs_)),
      ncol = 5,
      widths = c(w_col1_,w_col2_,w_col3_,w_col4_,w_col5_),
      padding = unit(0.1, "cm")),
    
    # Ligne 5
    arrangeGrob(
      textGrob("RCP 2.6",vjust = 1, gp = gpar(col = "grey38", fontsize = 11*ratio_epaisseurs_), rot = 90),
      # textGrob(pattern_rcp_replace_$remplacement[grepl(str_before_first(str_after_first(rcp26_H1_nl_$labels$subtitle,"RCP ")," - Période"),pattern_rcp_replace_$aRemplacer)],vjust = 1, gp = gpar(col = "black", fontsize = 11), rot = 90),
      ggplotGrob(rcp26_H1_nl_),
      nullGrob(),
      ggplotGrob(rcp26_H2_nl_),
      ggplotGrob(rcp26_H3_nl_),
      ncol = 5,
      widths = c(w_col1_,w_col2_,w_col3_,w_col4_,w_col5_),
      padding = unit(0.1, "cm")),
    
    # Ligne 6
    arrangeGrob(
      textGrob("RCP 4.5",vjust = 1, gp = gpar(col = "grey38", fontsize = 11*ratio_epaisseurs_), rot = 90),
      # textGrob(pattern_rcp_replace_$remplacement[grepl(str_before_first(str_after_first(rcp45_H1_nl_$labels$subtitle,"RCP ")," - Période"),pattern_rcp_replace_$aRemplacer)],vjust = 1, gp = gpar(col = "black", fontsize = 11), rot = 90),
      ggplotGrob(rcp45_H1_nl_),
      nullGrob(),
      ggplotGrob(rcp45_H2_nl_),
      ggplotGrob(rcp45_H3_nl_),
      ncol = 5,
      widths = c(w_col1_,w_col2_,w_col3_,w_col4_,w_col5_),
      padding = unit(0.1, "cm")),
    
    # Ligne 7
    arrangeGrob(
      textGrob("RCP 8.5",vjust = 1, gp = gpar(col = "grey38", fontsize = 11*ratio_epaisseurs_), rot = 90),
      # textGrob(pattern_rcp_replace_$remplacement[grepl(str_before_first(str_after_first(rcp85_H1_nl_$labels$subtitle,"RCP ")," - Période"),pattern_rcp_replace_$aRemplacer)],vjust = 1, gp = gpar(col = "black", fontsize = 11), rot = 90),
      ggplotGrob(rcp85_H1_nl_),
      nullGrob(),
      ggplotGrob(rcp85_H2_nl_),
      ggplotGrob(rcp85_H3_nl_),
      ncol = 5,
      widths = c(w_col1_,w_col2_,w_col3_,w_col4_,w_col5_),
      padding = unit(0.1, "cm")),
    
    nrow = 4,
    heights = c(h_line4_,h_graph_,h_graph_,h_graph_),
    padding = unit(0.1, "cm")  # ajuster la marge
    
  )
  
  grid_totale_ <- grid.arrange(
    grid_2_,
    grid_graph_,
    heights = c(h_line1_+h_line2_+h_graph_,h_line4_+h_graph_*3))
  
  # x11()
  # plot(grid_totale_)
  
  ggsave(paste0(folder_output_DD_,
                "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                nomSim_,
                ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                "/PanneauChroniquesCombinees_ParHER/Mean_English/ProbaBoard_MeanEnglish_HER",HER_h_,"_1_20240411.svg"),
         plot = grid_totale_) # , width=15
  
  ggsave(paste0(folder_output_DD_,
                "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                nomSim_,
                ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                "/PanneauChroniquesCombinees_ParHER/Mean_English/ProbaBoard_MeanEnglish_HER",HER_h_,"_1_20240411.pdf"),
         plot = grid_totale_) # , width=15
  
  ggsave(paste0(folder_output_DD_,
                "22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                nomSim_,
                ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                "/PanneauChroniquesCombinees_ParHER/Mean_English/ProbaBoard_MeanEnglish_HER",HER_h_,"_1_20240411.png"),
         plot = grid_totale_, width=20)
  
}

# x11()
