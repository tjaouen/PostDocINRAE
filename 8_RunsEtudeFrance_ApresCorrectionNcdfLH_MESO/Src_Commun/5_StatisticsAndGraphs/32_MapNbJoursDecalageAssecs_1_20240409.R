source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_31_NewColors_Svg_20240319.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_Commun/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")

### Parameters ###
folder_input_ <- folder_input_param_
folder_output_DD_ <- folder_output_DD_param_
nomSim_ <- nomSim_param_
nom_FDCfolder_ <- nom_FDCfolder_param_
ratio_epaisseurs_ <- 1.4

H0_ = "19762005"
H1_ = "20212050"
H2_ = "20412070"
H3_ = "20702099"
seuilAssec_ = 20

nom_categorieSimu_list_ = c(
  # "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26/",
  #                           "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45/",
  #                           "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/")#,
                            # "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26/",
                            # "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp45/",
                            # "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/",
                            # "J2000_20231128/ChroniquesCombinees_saf_hist_rcp26/",
                            # "J2000_20231128/ChroniquesCombinees_saf_hist_rcp45/",
                            # "J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/",
                            "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26/",
                            "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp45/",
                            "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/")#,
                            # "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26/",
                            # "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp45/",
                            # "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/")#,

HER_ <- c("2", "3", "5", "12", "13", "14", "17", "21", "22", "24", "25", "27", "28", "34", "35", "36",
          "38", "40", "41", "43", "44", "50", "51", "52", "53", "55", "56", "57", "58", "59", "61", 
          "62", "63", "64", "65", "66", "67", "68", "70", "71", "73", "74", "75", "76", "77", "78",
          "79", "81", "84", "85", "86", "87", "91", "93", "94", "97", "98", "99", "101", "103", "104",
          "105", "106", "107", "108", "112", "113", "117", "118", "120", "31033039", "37054", "69096",
          "89092", "49090")



for (nom_categorieSimu_ in nom_categorieSimu_list_){
  
  print(nom_categorieSimu_)
  
  file_ref_ <- list.files(paste0(folder_input_,"Tab_Indicateurs/",
                                 ifelse(obsSim_=="",nom_GCM_,
                                        paste0("FDC_",obsSim_,
                                               ifelse(nom_FDCfolder_=="","",paste0("_",nom_FDCfolder_)),"/",
                                               ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),"/"))),
                          pattern = paste(c("Tab_Indicateurs_ADAMONT_19762005",".txt"),collapse = ".*"), full.names = T)
  tab_ref_ <- read.table(file_ref_, sep = ";", dec = ".", header = T)
  
  for (pattern_ in c(H2_,H3_)){
    
    print(pattern_)
    
    file_test_ <- list.files(paste0(folder_input_,"Tab_Indicateurs/",
                                    ifelse(obsSim_=="",nom_GCM_,
                                           paste0("FDC_",obsSim_,
                                                  ifelse(nom_FDCfolder_=="","",paste0("_",nom_FDCfolder_)),"/",
                                                  ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),"/"))),
                             pattern = paste(c("Tab_Indicateurs_ADAMONT_",pattern_,".txt"),collapse = ".*"), full.names = T)
    
    tab_test_ <- read.table(file_test_, sep = ";", dec = ".", header = T)
    
    # tab_ref_[,c("HER","initDate_median_")]
    # tab_test_[,c("HER","initDate_median_")]
    
    merged_data <- merge(tab_ref_, tab_test_, by = "HER", suffixes = c("ref", "test"))
    # merged_data[,c("HER","initDate_median_ref","initDate_median_test")]
    # merged_data[,c("HER","finishDate_median_ref","finishDate_median_test")]

    # Calculer la différence entre les dates
    merged_data$difference_init <- as.Date(merged_data$initDate_median_ref) - as.Date(merged_data$initDate_median_test)
    merged_data$difference_finish <- as.Date(merged_data$finishDate_median_test) - as.Date(merged_data$finishDate_median_ref)

    # merged_data[,c("HER","initDate_median_ref","initDate_median_test","difference_init")]
    # merged_data[,c("HER","finishDate_median_ref","finishDate_median_test","difference_finish")]
    
    
    # file_ <- list.files(paste0(folder_input_,"Tab_Indicateurs/",
    #                            ifelse(obsSim_=="",nom_GCM_,
    #                                   paste0("FDC_",obsSim_,
    #                                          ifelse(nom_FDCfolder_=="","",paste0("_",nom_FDCfolder_)),"/",
    #                                          ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),"/"))),
    #                     pattern = paste(c("Tab_Indicateurs_ADAMONT_",pattern_,"txt"),collapse = ".*"), full.names = T)
    
    table_globale <- merged_data
    # "Tab_Indicateurs_ADAMONT_",pattern_,"_",str_before_first(str_after_last(nom_categorieSimu_,"_"),"/"),".txt"), sep = ";", header = T)
    
    ### Jonction HER ###
    table_globale$HER[which(table_globale$HER == 37054)] = "37+54"
    table_globale$HER[which(table_globale$HER == 69096)] = "69+96"
    table_globale$HER[which(table_globale$HER == 31033039)] = "31+33+39"
    table_globale$HER[which(table_globale$HER == 89092)] = "89+92"
    table_globale$HER[which(table_globale$HER == 49090)] = "49+90"
    
    table_globale_test_ = table_globale
    table_globale_test_$difference_init[which(is.na(table_globale_test_$difference_init))] = 0
    table_globale_test_$difference_finish[which(is.na(table_globale_test_$difference_finish))] = 0
    mean(table_globale$difference_init, na.rm = T)
    mean(table_globale$difference_finish, na.rm = T)
    mean(table_globale_test_$difference_init)
    mean(table_globale_test_$difference_finish)

    
    if (!(dir.exists(paste0(folder_output_DD_,
                            "/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                            nomSim_,
                            ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                            "/Map/")))){
      dir.create(paste0(folder_output_DD_,
                        "/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        "/Map/"))}
    
    
    ### Date mediane debut ###
    # title_ = paste0("\nNombre moyen de jours\npar an avec une proportion\nd'assec >10% :\n projection\nmédiane")
    # title_ = paste0("Date médiane de la première proportion\nd'assec supérieure à ",seuilAssec_,"%")
    title_ = paste0("\nNumber of days in advance of the first\nday with over ",seuilAssec_,"% of sites drying: median projection")
    # subtitle_ = paste0("Modèle hydrologique : ",str_before_first(nom_categorieSimu_,"_"))
    subtitle_ = paste0("Période : April-December ",
                       substr(pattern_,1,4),
                       "-",
                       substr(pattern_,5,8),
                       "\nHydrological model ",
                       str_before_first(nom_categorieSimu_,"_"))
    output_name_ <- paste0(folder_output_DD_,
                           "/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                           nomSim_,
                           ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                           "/Map/Map_delaiMedianDebutSup",seuilAssec_,"pct_ProjMediane_",pattern_,"_1_20240327")
    breaks_nbJoursDelai <- breaks_nbJoursDelai_param
    table_globale$difference_init <- as.numeric(table_globale$difference_init)/7
    # table_globale$initDate_median_ <- as.Date(paste0("2020-",table_globale$initDate_median_))
    plot_map_variable(tab_ = table_globale,
                      varname_ = "difference_init",
                      vartitle_ = "Number of weeks",
                      breaks_ = breaks_nbJoursDelai,
                      output_name_ = output_name_,
                      title_ = title_,
                      subtitle_ = subtitle_,
                      nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                      reverseColors_ = T,
                      reverseLegend_ = T,
                      echelleAttenuee_ = F,
                      addValueUnder = -50,
                      HER2_excluesDensity_ = NULL,
                      annotation_txt_ = T,
                      percentFormat = F,
                      doubleLegend_ = T,
                      borderCol = "gray40",
                      taillePalette = length(breaks_nbJoursDelai)+5,
                      retenuPalette = length(breaks_nbJoursDelai))
    
      plot_map_variable_sansEtiquettes(tab_ = table_globale,
                                     varname_ = "difference_init",
                                     vartitle_ = "Number of weeks",
                                     breaks_ = breaks_nbJoursDelai,
                                     output_name_ = output_name_,
                                     title_ = title_,
                                     subtitle_ = subtitle_,
                                     nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                     reverseColors_ = T,
                                     sansTexteHer_ = T,
                                     reverseLegend_ = T,
                                     echelleAttenuee_ = F,
                                     addValueUnder = -50,
                                     HER2_excluesDensity_ = NULL,
                                     annotation_txt_ = F,
                                     percentFormat = F,
                                     doubleLegend_ = T,
                                     borderCol = "gray40",
                                     taillePalette = length(breaks_nbJoursDelai)+5,
                                     retenuPalette = length(breaks_nbJoursDelai))
    
    
    # title_ = paste0("\nNombre moyen de jours\npar an avec une proportion\nd'assec >10% :\n projection\nmédiane")
    title_ = paste0("\nNumber of days delayed for the last day\nwith over ",seuilAssec_,"% of sites drying: median projection")
    # subtitle_ = paste0("Modèle hydrologique : ",str_before_first(nom_categorieSimu_,"_"))
    subtitle_ = paste0("Période : April-December ",
                       substr(pattern_,1,4),
                       "-",
                       substr(pattern_,5,8),
                       "\nHydrological model ",
                       str_before_first(nom_categorieSimu_,"_"))
    output_name_ <- paste0(folder_output_DD_,
                           "/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                           nomSim_,
                           ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                           "/Map/Map_delaiMedianFinSup",seuilAssec_,"pct_ProjMediane_",pattern_,"_1_20240327")
    table_globale$difference_finish <- as.numeric(table_globale$difference_finish)/7
    plot_map_variable(tab_ = table_globale,
                      varname_ = "difference_finish",
                      vartitle_ = "Number of weeks",
                      breaks_ = breaks_nbJoursDelai,
                      output_name_ = output_name_,
                      title_ = title_,
                      subtitle_ = subtitle_,
                      nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                      reverseColors_ = T,
                      reverseLegend_ = T,
                      echelleAttenuee_ = F,
                      addValueUnder = -50,
                      HER2_excluesDensity_ = NULL,
                      annotation_txt_ = T,
                      percentFormat = F,
                      doubleLegend_ = T,
                      borderCol = "gray40",
                      taillePalette = length(breaks_nbJoursDelai)+5,
                      retenuPalette = length(breaks_nbJoursDelai))
    
    plot_map_variable_sansEtiquettes(tab_ = table_globale,
                                     varname_ = "difference_finish",
                                     vartitle_ = "Number of weeks",
                                     breaks_ = breaks_nbJoursDelai,
                                     output_name_ = output_name_,
                                     title_ = title_,
                                     subtitle_ = subtitle_,
                                     nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                     reverseColors_ = T,
                                     sansTexteHer_ = T,
                                     reverseLegend_ = T,
                                     echelleAttenuee_ = F,
                                     addValueUnder = -50,
                                     HER2_excluesDensity_ = NULL,
                                     annotation_txt_ = F,
                                     percentFormat = F,
                                     doubleLegend_ = T,
                                     borderCol = "gray40",
                                     taillePalette = length(breaks_nbJoursDelai)+5,
                                     retenuPalette = length(breaks_nbJoursDelai))

  }
}




