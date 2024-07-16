source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_25_NewColors_Svg_20240301.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_31_NewColors_Svg_20240319.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_Commun/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")

# Chargement du package nécessaire
library(data.table)

### Parameters ###
folder_input_ = folder_input_param_
folder_output_ = folder_output_param_
nomSim_ = nomSim_param_
obsSim_ = obsSim_param_
nom_GCM_ = nom_GCM_param_
folder_output_DD_ = folder_output_DD_param_
nom_FDCfolder_ = nom_FDCfolder_param_
vartitle_ = NULL
seuilAssec_ = 20

# nom_categorieSimu_ = "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26"
# nom_categorieSimu_ = "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45"
# nom_categorieSimu_ = "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85"
# nom_categorieSimu_ = "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26"
# nom_categorieSimu_ = "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp45"
# nom_categorieSimu_ = "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85"
# nom_categorieSimu_ = "J2000_20231128/ChroniquesCombinees_saf_hist_rcp26"
# nom_categorieSimu_ = "J2000_20231128/ChroniquesCombinees_saf_hist_rcp45"
# nom_categorieSimu_ = "J2000_20231128/ChroniquesCombinees_saf_hist_rcp85"
vect_ = c(
  # "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26",
  # "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45",
  # "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85",
  # "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26",
  # "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp45",
  # "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85",
  # "J2000_20231128/ChroniquesCombinees_saf_hist_rcp26/",
  # "J2000_20231128/ChroniquesCombinees_saf_hist_rcp45/",
  # "J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/",
  "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26")#,
  # "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp45",
  # "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85")#,
  # "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26",
  # "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp45",
  # "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85")
H0_ = "19762005"
H1_ = "20212050"
H2_ = "20412070"
H3_ = "20702099"
# pattern_ = "20212050"
# pattern_ = "20412070"
# pattern_ = "20712098"

table_rapport_ = data.frame(HER = c(rep(57,3),rep(81,3),rep(13,3),rep(105,3)),
                            Horizon = c(rep(c("H0","H2","H3"),4)),
                            PropMoyAssecJuilletOct_ProjMin = NA,
                            PropMoyAssecJuilletOct_ProjMedian = NA,
                            PropMoyAssecJuilletOct_ProjMax = NA,
                            NbMoyJoursParAnPropAssecSup10_ProjMin = NA,
                            NbMoyJoursParAnPropAssecSup10_ProjMedian = NA,
                            NbMoyJoursParAnPropAssecSup10_ProjMax = NA,
                            initDate_ProjMin = NA,
                            initDate_ProjMedian = NA,
                            initDate_ProjMax = NA,
                            finishDate_ProjMin = NA,
                            finishDate_ProjMedian = NA,
                            finishDate_ProjMax = NA)

for (nom_categorieSimu_ in vect_){
  
  print(nom_categorieSimu_)
  
  for (pattern_ in c(H0_,H2_,H3_)){
    
    print(pattern_)
    
    file_ <- list.files(paste0(folder_input_,"Tab_Indicateurs/",
                               ifelse(obsSim_=="",nom_GCM_,
                                      paste0("FDC_",obsSim_,
                                             ifelse(nom_FDCfolder_=="","",paste0("_",nom_FDCfolder_)),"/",
                                             ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),"/"))),
                        pattern = paste(c("Tab_Indicateurs_ADAMONT_",pattern_,"txt"),collapse = ".*"), full.names = T)
    
    table_globale <- read.table(file_, sep = ";", header = T)
    # "Tab_Indicateurs_ADAMONT_",pattern_,"_",str_before_first(str_after_last(nom_categorieSimu_,"_"),"/"),".txt"), sep = ";", header = T)
    
    ### Jonction HER ###
    table_globale$HER[which(table_globale$HER == 37054)] = "37+54"
    table_globale$HER[which(table_globale$HER == 69096)] = "69+96"
    table_globale$HER[which(table_globale$HER == 31033039)] = "31+33+39"
    table_globale$HER[which(table_globale$HER == 89092)] = "89+92"
    table_globale$HER[which(table_globale$HER == 49090)] = "49+90"
    
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
    
    
    ### Title ###
    title_ = paste0("\nProportion moyenne\nd'assec : projection\nmédiane")
    subtitle_ = paste0("Période : Juillet-Octobre ",
                       substr(pattern_,1,4),
                       "-",
                       substr(pattern_,5,8),
                       "\nModèle hydrologique ",
                       str_before_first(nom_categorieSimu_,"_"))
    output_name_ <- paste0(folder_output_DD_,
                           "/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                           nomSim_,
                           ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                           "/Map/Map_propAssecMoyenneJuilletOct_ProjMediane_",pattern_,"_1_20240327")
    breaks_ProbaAssecMoyenne = breaks_ProbaAssecMoyenne_param
    plot_map_variable(tab_ = table_globale,
                      varname_ = "propAssecMoyenneJuilletOct_ModeleMedian_",
                      vartitle_ = "Probability (%)",
                      breaks_ = breaks_ProbaAssecMoyenne,
                      output_name_ = output_name_,
                      title_ = title_,
                      subtitle_ = subtitle_,
                      nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                      reverseColors_ = T,
                      reverseLegend_ = T,
                      echelleAttenuee_ = F,
                      addValueUnder = -30,
                      HER2_excluesDensity_ = NULL,
                      annotation_txt_ = T,
                      percentFormat = T,
                      borderCol = "gray70",
                      taillePalette = length(breaks_ProbaAssecMoyenne)+3,
                      retenuPalette = length(breaks_ProbaAssecMoyenne))

    plot_map_variable_sansEtiquettes(tab_ = table_globale,
                                     varname_ = "propAssecMoyenneJuilletOct_ModeleMedian_",
                                     vartitle_ = "Probability (%)",
                                     breaks_ = breaks_ProbaAssecMoyenne,
                                     output_name_ = output_name_,
                                     title_ = title_,
                                     nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                     reverseColors_ = T,
                                     sansTexteHer_ = T,
                                     reverseLegend_ = T,
                                     echelleAttenuee_ = F,
                                     addValueUnder = -30,
                                     HER2_excluesDensity_ = NULL,
                                     annotation_txt_ = F,
                                     percentFormat = T,
                                     borderCol = "gray70",
                                     taillePalette = length(breaks_ProbaAssecMoyenne)+3,
                                     retenuPalette = length(breaks_ProbaAssecMoyenne))
    
    ### Title ###
    title_ = paste0("\nNombre moyen de jours\npar an avec une proportion\nd'assec >",seuilAssec_,"% :\n projection\nmédiane")
    subtitle_ = paste0("Période : Janvier-Décembre ",
                       substr(pattern_,1,4),
                       "-",
                       substr(pattern_,5,8),
                       "\nModèle hydrologique ",
                       str_before_first(nom_categorieSimu_,"_"))
    output_name_ <- paste0(folder_output_DD_,
                           "/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                           nomSim_,
                           ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                           "/Map/Map_nbMoyenJoursParAnSup",seuilAssec_,"pct_ProjMediane_",pattern_,"_1_20240327")
    # "/Map/Map_nbMoyenJoursParAnSup10pct_ProjMediane_",pattern_,"_1_20240327")
    breaks_nbJoursAssecsAn = breaks_nbJoursAssecsAn_param
    plot_map_variable(tab_ = table_globale,
                      varname_ = paste0("nbMoyenJoursParAnSup",seuilAssec_,"pct_ModeleMedian_"),
                      vartitle_ = "Probability (%)",
                      breaks_ = breaks_nbJoursAssecsAn,
                      output_name_ = output_name_,
                      title_ = title_,
                      subtitle_ = subtitle_,
                      nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                      reverseColors_ = T,
                      reverseLegend_ = T,
                      echelleAttenuee_ = F,
                      addValueUnder = -30,
                      HER2_excluesDensity_ = NULL,
                      annotation_txt_ = T,
                      percentFormat = F,
                      doubleLegend_ = T,
                      borderCol = "gray70",
                      taillePalette = length(breaks_nbJoursAssecsAn)+3,
                      retenuPalette = length(breaks_nbJoursAssecsAn)
    )
    
    plot_map_variable_sansEtiquettes(tab_ = table_globale,
                                     varname_ = paste0("nbMoyenJoursParAnSup",seuilAssec_,"pct_ModeleMedian_"),
                                     vartitle_ = "Probability (%)",
                                     breaks_ = breaks_nbJoursAssecsAn,
                                     output_name_ = output_name_,
                                     title_ = title_,
                                     nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                     reverseColors_ = T,
                                     sansTexteHer_ = T,
                                     reverseLegend_ = T,
                                     echelleAttenuee_ = F,
                                     addValueUnder = -30,
                                     HER2_excluesDensity_ = NULL,
                                     annotation_txt_ = F,
                                     percentFormat = F,
                                     doubleLegend_ = T,
                                     borderCol = "gray70",
                                     taillePalette = length(breaks_nbJoursAssecsAn)+3,
                                     retenuPalette = length(breaks_nbJoursAssecsAn)
    )
    
    
    ### Date mediane debut ###
    # title_ = paste0("\nNombre moyen de jours\npar an avec une proportion\nd'assec >10% :\n projection\nmédiane")
    title_ = paste0("Date médiane de la première proportion\nd'assec supérieure à ",seuilAssec_,"%")
    # subtitle_ = paste0("Modèle hydrologique : ",str_before_first(nom_categorieSimu_,"_"))
    subtitle_ = paste0("Période : Avril-Décembre ",
                       substr(pattern_,1,4),
                       "-",
                       substr(pattern_,5,8),
                       "\nModèle hydrologique ",
                       str_before_first(nom_categorieSimu_,"_"))
    output_name_ <- paste0(folder_output_DD_,
                           "/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                           nomSim_,
                           ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                           "/Map/Map_dateMedianeDebutSup",seuilAssec_,"pct_ProjMediane_",pattern_,"_1_20240327")
    breaks_dateMediane_start = as.Date(breaks_dateMediane_start_param)
    table_globale$initDate_median_ <- as.Date(table_globale$initDate_median_)
    # table_globale$initDate_median_ <- as.Date(paste0("2020-",table_globale$initDate_median_))
    plot_map_variable(tab_ = table_globale,
                      varname_ = "initDate_median_",
                      vartitle_ = "",
                      breaks_ = breaks_dateMediane_start,
                      output_name_ = output_name_,
                      title_ = title_,
                      subtitle_ = subtitle_,
                      nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                      reverseColors_ = F,
                      reverseLegend_ = T,
                      echelleAttenuee_ = F,
                      addValueUnder = "2020-01-01",
                      HER2_excluesDensity_ = NULL,
                      annotation_txt_ = T,
                      percentFormat = F,
                      doubleLegend_ = T,
                      reverseFinal = T,
                      borderCol = "gray70",
    )
    
    
    # tab_ = table_globale
    # varname_ = "initDate_median_"
    # vartitle_ = "Probability (%)"
    # breaks_ = as.Date(breaks_dateMediane)
    # output_name_ = output_name_
    # title_ = title_
    # subtitle_ = subtitle_
    # nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt" # "sequence_vertRouge_personnelle_div_disc.txt"
    # reverseColors_ = T
    # reverseLegend_ = T
    # echelleAttenuee_ = F
    # addValueUnder = "2022-01-01"
    # HER2_excluesDensity_ = NULL
    # annotation_txt_ = T
    # percentFormat = F
    # doubleLegend_ = T
    # borderCol = "gray70"
    
    
    
    plot_map_variable_sansEtiquettes(tab_ = table_globale,
                                     varname_ = "initDate_median_",
                                     vartitle_ = "",
                                     breaks_ = breaks_dateMediane_start,
                                     output_name_ = output_name_,
                                     title_ = title_,
                                     subtitle_ = subtitle_,
                                     nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                     reverseColors_ = F,
                                     sansTexteHer_ = T,
                                     reverseLegend_ = T,
                                     echelleAttenuee_ = F,
                                     addValueUnder = "2020-01-01",
                                     HER2_excluesDensity_ = NULL,
                                     annotation_txt_ = F,
                                     percentFormat = F,
                                     doubleLegend_ = T,
                                     reverseFinal = T,
                                     borderCol = "gray70")
    
    
    ### Date mediane fin ###
    # title_ = paste0("\nNombre moyen de jours\npar an avec une proportion\nd'assec >10% :\n projection\nmédiane")
    title_ = paste0("Date médiane de la dernière proportion\nd'assec supérieure à ",seuilAssec_,"%")
    # subtitle_ = paste0("Modèle hydrologique : ",str_before_first(nom_categorieSimu_,"_"))
    subtitle_ = paste0("Période : Avril-Décembre ",
                       substr(pattern_,1,4),
                       "-",
                       substr(pattern_,5,8),
                       "\nModèle hydrologique ",
                       str_before_first(nom_categorieSimu_,"_"))
    output_name_ <- paste0(folder_output_DD_,
                           "/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                           nomSim_,
                           ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                           "/Map/Map_dateMedianeFinSup",seuilAssec_,"pct_ProjMediane_",pattern_,"_1_20240327")
    breaks_dateMediane_end = as.Date(breaks_dateMediane_end_param)
    table_globale$finishDate_median_ <- as.Date(table_globale$finishDate_median_)
    # table_globale$finishDate_median_ <- as.Date(paste0("2022-",table_globale$finishDate_median_))
    plot_map_variable(tab_ = table_globale,
                      varname_ = "finishDate_median_",
                      vartitle_ = "",
                      breaks_ = breaks_dateMediane_end,
                      output_name_ = output_name_,
                      title_ = title_,
                      subtitle_ = subtitle_,
                      nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                      reverseColors_ = F,
                      reverseLegend_ = T,
                      echelleAttenuee_ = F,
                      addValueUnder = "2020-01-01",
                      HER2_excluesDensity_ = NULL,
                      annotation_txt_ = T,
                      percentFormat = F,
                      doubleLegend_ = T,
                      borderCol = "gray70",
                      taillePalette = length(breaks_dateMediane_end)+3,
                      retenuPalette = length(breaks_dateMediane_end)
    )
    
    plot_map_variable_sansEtiquettes(tab_ = table_globale,
                                     varname_ = "finishDate_median_",
                                     vartitle_ = "",
                                     breaks_ = breaks_dateMediane_end,
                                     output_name_ = output_name_,
                                     title_ = title_,
                                     subtitle_ = subtitle_,
                                     nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                     reverseColors_ = F,
                                     sansTexteHer_ = T,
                                     reverseLegend_ = T,
                                     echelleAttenuee_ = F,
                                     addValueUnder = "2020-01-01",
                                     HER2_excluesDensity_ = NULL,
                                     annotation_txt_ = F,
                                     percentFormat = F,
                                     doubleLegend_ = T,
                                     borderCol = "gray70",
                                     taillePalette = length(breaks_dateMediane_end)+3,
                                     retenuPalette = length(breaks_dateMediane_end)
    )
    
    
    
    
    if (pattern_ == H0_){
      for (HER_i_ in c(57,81,13,105)){
        if (HER_i_ %in% table_globale$HER){
          table_rapport_[which(table_rapport_$HER == HER_i_ & table_rapport_$Horizon == "H0"),c("PropMoyAssecJuilletOct_ProjMin","PropMoyAssecJuilletOct_ProjMedian","PropMoyAssecJuilletOct_ProjMax")] = table_globale[which(table_globale$HER == HER_i_),c("propAssecMoyenneJuilletOct_ModeleMin_","propAssecMoyenneJuilletOct_ModeleMedian_","propAssecMoyenneJuilletOct_ModeleMax_")]
          table_rapport_[which(table_rapport_$HER == HER_i_ & table_rapport_$Horizon == "H0"),c("NbMoyJoursParAnPropAssecSup10_ProjMin","NbMoyJoursParAnPropAssecSup10_ProjMedian","NbMoyJoursParAnPropAssecSup10_ProjMax")] = table_globale[which(table_globale$HER == HER_i_),c(paste0("nbMoyenJoursParAnSup",seuilAssec_,"pct_ModeleMin_"),paste0("nbMoyenJoursParAnSup",seuilAssec_,"pct_ModeleMedian_"),paste0("nbMoyenJoursParAnSup",seuilAssec_,"pct_ModeleMax_"))]
          table_rapport_[which(table_rapport_$HER == HER_i_ & table_rapport_$Horizon == "H0"),c("initDate_ProjMin","initDate_ProjMedian","initDate_ProjMax")] = table_globale[which(table_globale$HER == HER_i_),c("initDate_min_","initDate_median_","initDate_max_")]
          table_rapport_[which(table_rapport_$HER == HER_i_ & table_rapport_$Horizon == "H0"),c("finishDate_ProjMin","finishDate_ProjMedian","finishDate_ProjMax")] = table_globale[which(table_globale$HER == HER_i_),c("finishDate_min_","finishDate_median_","finishDate_max_")]
        }
      }
    }else if (pattern_ == H1_){
      for (HER_i_ in c(57,81,13,105)){
        if (HER_i_ %in% table_globale$HER){
          table_rapport_[which(table_rapport_$HER == HER_i_ & table_rapport_$Horizon == "H1"),c("PropMoyAssecJuilletOct_ProjMin","PropMoyAssecJuilletOct_ProjMedian","PropMoyAssecJuilletOct_ProjMax")] = table_globale[which(table_globale$HER == HER_i_),c("propAssecMoyenneJuilletOct_ModeleMin_","propAssecMoyenneJuilletOct_ModeleMedian_","propAssecMoyenneJuilletOct_ModeleMax_")]
          table_rapport_[which(table_rapport_$HER == HER_i_ & table_rapport_$Horizon == "H1"),c("NbMoyJoursParAnPropAssecSup10_ProjMin","NbMoyJoursParAnPropAssecSup10_ProjMedian","NbMoyJoursParAnPropAssecSup10_ProjMax")] = table_globale[which(table_globale$HER == HER_i_),c(paste0("nbMoyenJoursParAnSup",seuilAssec_,"pct_ModeleMin_"),paste0("nbMoyenJoursParAnSup",seuilAssec_,"pct_ModeleMedian_"),paste0("nbMoyenJoursParAnSup",seuilAssec_,"pct_ModeleMax_"))]
          table_rapport_[which(table_rapport_$HER == HER_i_ & table_rapport_$Horizon == "H1"),c("initDate_ProjMin","initDate_ProjMedian","initDate_ProjMax")] = table_globale[which(table_globale$HER == HER_i_),c("initDate_min_","initDate_median_","initDate_max_")]
          table_rapport_[which(table_rapport_$HER == HER_i_ & table_rapport_$Horizon == "H1"),c("finishDate_ProjMin","finishDate_ProjMedian","finishDate_ProjMax")] = table_globale[which(table_globale$HER == HER_i_),c("finishDate_min_","finishDate_median_","finishDate_max_")]
        }
      }
    }else if (pattern_ == H2_){
      for (HER_i_ in c(57,81,13,105)){
        if (HER_i_ %in% table_globale$HER){
          table_rapport_[which(table_rapport_$HER == HER_i_ & table_rapport_$Horizon == "H2"),c("PropMoyAssecJuilletOct_ProjMin","PropMoyAssecJuilletOct_ProjMedian","PropMoyAssecJuilletOct_ProjMax")] = table_globale[which(table_globale$HER == HER_i_),c("propAssecMoyenneJuilletOct_ModeleMin_","propAssecMoyenneJuilletOct_ModeleMedian_","propAssecMoyenneJuilletOct_ModeleMax_")]
          table_rapport_[which(table_rapport_$HER == HER_i_ & table_rapport_$Horizon == "H2"),c("NbMoyJoursParAnPropAssecSup10_ProjMin","NbMoyJoursParAnPropAssecSup10_ProjMedian","NbMoyJoursParAnPropAssecSup10_ProjMax")] = table_globale[which(table_globale$HER == HER_i_),c(paste0("nbMoyenJoursParAnSup",seuilAssec_,"pct_ModeleMin_"),paste0("nbMoyenJoursParAnSup",seuilAssec_,"pct_ModeleMedian_"),paste0("nbMoyenJoursParAnSup",seuilAssec_,"pct_ModeleMax_"))]
          table_rapport_[which(table_rapport_$HER == HER_i_ & table_rapport_$Horizon == "H2"),c("initDate_ProjMin","initDate_ProjMedian","initDate_ProjMax")] = table_globale[which(table_globale$HER == HER_i_),c("initDate_min_","initDate_median_","initDate_max_")]
          table_rapport_[which(table_rapport_$HER == HER_i_ & table_rapport_$Horizon == "H2"),c("finishDate_ProjMin","finishDate_ProjMedian","finishDate_ProjMax")] = table_globale[which(table_globale$HER == HER_i_),c("finishDate_min_","finishDate_median_","finishDate_max_")]
        }
      }
    }else if (pattern_ == H3_){
      for (HER_i_ in c(57,81,13,105)){
        if (HER_i_ %in% table_globale$HER){
          table_rapport_[which(table_rapport_$HER == HER_i_ & table_rapport_$Horizon == "H3"),c("PropMoyAssecJuilletOct_ProjMin","PropMoyAssecJuilletOct_ProjMedian","PropMoyAssecJuilletOct_ProjMax")] = table_globale[which(table_globale$HER == HER_i_),c("propAssecMoyenneJuilletOct_ModeleMin_","propAssecMoyenneJuilletOct_ModeleMedian_","propAssecMoyenneJuilletOct_ModeleMax_")]
          table_rapport_[which(table_rapport_$HER == HER_i_ & table_rapport_$Horizon == "H3"),c("NbMoyJoursParAnPropAssecSup10_ProjMin","NbMoyJoursParAnPropAssecSup10_ProjMedian","NbMoyJoursParAnPropAssecSup10_ProjMax")] = table_globale[which(table_globale$HER == HER_i_),c(paste0("nbMoyenJoursParAnSup",seuilAssec_,"pct_ModeleMin_"),paste0("nbMoyenJoursParAnSup",seuilAssec_,"pct_ModeleMedian_"),paste0("nbMoyenJoursParAnSup",seuilAssec_,"pct_ModeleMax_"))]
          table_rapport_[which(table_rapport_$HER == HER_i_ & table_rapport_$Horizon == "H3"),c("initDate_ProjMin","initDate_ProjMedian","initDate_ProjMax")] = table_globale[which(table_globale$HER == HER_i_),c("initDate_min_","initDate_median_","initDate_max_")]
          table_rapport_[which(table_rapport_$HER == HER_i_ & table_rapport_$Horizon == "H3"),c("finishDate_ProjMin","finishDate_ProjMedian","finishDate_ProjMax")] = table_globale[which(table_globale$HER == HER_i_),c("finishDate_min_","finishDate_median_","finishDate_max_")]
        }
      }
    }
  }
}




write.table(table_rapport_,
            paste0(folder_output_DD_,
                   "/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                   nomSim_,
                   ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                   "/Map/Table_valeursHERrapport_",seuilAssec_,"pct_20240516.csv"),
            sep = ";", dec = ".", row.names = F)


# 
# tab_ = table_globale
# varname_ = "MedianDay_FirstP10_Value"
# vartitle_ = vartitle_
# breaks_ = c("2022-04-01","2022-05-01","2022-06-01","2022-07-01","2022-08-01","2022-09-01","2022-10-01")
# output_name_ = output_name_
# title_ = title_
# nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt"
# reverseColors_ = T
# reverseLegend_ = T
# echelleAttenuee_ = F
# addValueUnder = NULL
# HER2_excluesDensity_ = NULL
# subtitle_ = subtitle_
# annotation_txt_ = T
# 
# 
# 
# pattern_ = "19762005"
# # 
# tab_ = table_globale
# varname_ = "MedianDay_FirstP10_Value"
# vartitle_ = vartitle_
# breaks_ = c("2022-04-01","2022-05-01","2022-06-01","2022-07-01","2022-08-01","2022-09-01","2022-10-01")
# output_name_ = output_name_
# title_ = title_
# nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt"
# sansTexteHer_ = T
# reverseColors_ = T
# reverseLegend_ = T
# echelleAttenuee_ = F
# addValueUnder = -10
# HER2_excluesDensity_ = NULL
# subtitle_ = subtitle_
# annotation_txt_ = T
# addValueUnder = NULL
# labels_name_ = FALSE






