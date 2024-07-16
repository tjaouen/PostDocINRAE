

list_ <- list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/",
                    pattern = "Tab_Indicateurs_ProbaMeanJuilOct", full.names = T)

HER_ <- c("2", "3", "5", "12", "13", "14", "17", "21", "22", "24", "25", "27", "28", "34", "35", "36",
          "38", "40", "41", "43", "44", "50", "51", "52", "53", "55", "56", "57", "58", "59", "61", 
          "62", "63", "64", "65", "66", "67", "68", "70", "71", "73", "74", "75", "76", "77", "78",
          "79", "81", "84", "85", "86", "87", "91", "93", "94", "97", "98", "99", "101", "103", "104",
          "105", "106", "107", "108", "112", "113", "117", "118", "120", "31033039", "37054", "69096",
          "89092", "49090")

tab_CNRM.CERFACS.CNRM.ALADIN63.ADAMONT = data.frame(HER = HER_, mean_ = NA)
tab_ICHEC.EC.EARTH.MOHC.HadREM3.ADAMONT = data.frame(HER = HER_, mean_ = NA)
tab_MOHC.HadGEM2.ES.CLMcom.CCLM4.ADAMONT = data.frame(HER = HER_, mean_ = NA)
tab_MOHC.HadGEM2.ES.CNRM.ALADIN63.ADAMONT = data.frame(HER = HER_, mean_ = NA)

for (HER_h_ in HER_){
  
  filename_ <- list_[grepl(paste0("HER",HER_h_,"_"),list_)]
  tab_ <- read.table(filename_, sep = ";", dec = ".", header = T)
  tab_ <- tab_[which(tab_$Year >= 2071 & tab_$Year <= 2100),]
  
  tab_CNRM.CERFACS.CNRM.ALADIN63.ADAMONT$mean_[which(tab_CNRM.CERFACS.CNRM.ALADIN63.ADAMONT$HER == HER_h_)] = mean(tab_$debit_France_CNRM.CERFACS.CNRM.CM5_rcp85_r1i1p1_CNRM.ALADIN63_v3_MF.ADAMONT.SAFRAN.1980.2011_INRAE.GRSD_day_20050801.21000731)
  tab_ICHEC.EC.EARTH.MOHC.HadREM3.ADAMONT$mean_[which(tab_ICHEC.EC.EARTH.MOHC.HadREM3.ADAMONT$HER == HER_h_)] = mean(tab_$debit_France_ICHEC.EC.EARTH_rcp85_r12i1p1_MOHC.HadREM3.GA7.05_v2_MF.ADAMONT.SAFRAN.1980.2011_INRAE.GRSD_day_20050801.21000731)
  tab_MOHC.HadGEM2.ES.CLMcom.CCLM4.ADAMONT$mean_[which(tab_MOHC.HadGEM2.ES.CLMcom.CCLM4.ADAMONT$HER == HER_h_)] = mean(tab_$debit_France_MOHC.HadGEM2.ES_rcp85_r1i1p1_CLMcom.CCLM4.8.17_v2_MF.ADAMONT.SAFRAN.1980.2011_INRAE.GRSD_day_20050801.20990731)
  tab_MOHC.HadGEM2.ES.CNRM.ALADIN63.ADAMONT$mean_[which(tab_MOHC.HadGEM2.ES.CNRM.ALADIN63.ADAMONT$HER == HER_h_)] = mean(tab_$debit_France_MOHC.HadGEM2.ES_rcp85_r1i1p1_CNRM.ALADIN63_v2_MF.ADAMONT.SAFRAN.1980.2011_INRAE.GRSD_day_20050801.20990731)
  
}


title_ = paste0("\nProportion moyenne\nd'assec : projection CNRM.CERFACS.CNRM.ALADIN63.ADAMONT")
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
                       "/Map/Map_propAssecMoyenneJuilletOct_ProjMediane_CNRM_CERFACS_CNRM_ALADIN63_ADAMONT_",pattern_,"_1_20240412")
breaks_ProbaAssecMoyenne = breaks_ProbaAssecMoyenne_param
plot_map_variable(tab_ = tab_CNRM.CERFACS.CNRM.ALADIN63.ADAMONT,
                  varname_ = "mean_",
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
                  borderCol = "gray40",
                  taillePalette = length(breaks_ProbaAssecMoyenne)+3,
                  retenuPalette = length(breaks_ProbaAssecMoyenne))

plot_map_variable_sansEtiquettes(tab_ = tab_CNRM.CERFACS.CNRM.ALADIN63.ADAMONT,
                                 varname_ = "mean_",
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
                                 borderCol = "gray40",
                                 taillePalette = length(breaks_ProbaAssecMoyenne)+3,
                                 retenuPalette = length(breaks_ProbaAssecMoyenne))






title_ = paste0("\nProportion moyenne\nd'assec : projection ICHEC.EC.EARTH.MOHC.HadREM3.ADAMONT")
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
                       "/Map/Map_propAssecMoyenneJuilletOct_ProjMediane_ICHEC_EC_EARTH_MOHC_HadREM3_ADAMONT_",pattern_,"_1_20240412")
breaks_ProbaAssecMoyenne = breaks_ProbaAssecMoyenne_param
plot_map_variable(tab_ = tab_ICHEC.EC.EARTH.MOHC.HadREM3.ADAMONT,
                  varname_ = "mean_",
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
                  borderCol = "gray40",
                  taillePalette = length(breaks_ProbaAssecMoyenne)+3,
                  retenuPalette = length(breaks_ProbaAssecMoyenne))

plot_map_variable_sansEtiquettes(tab_ = tab_ICHEC.EC.EARTH.MOHC.HadREM3.ADAMONT,
                                 varname_ = "mean_",
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
                                 borderCol = "gray40",
                                 taillePalette = length(breaks_ProbaAssecMoyenne)+3,
                                 retenuPalette = length(breaks_ProbaAssecMoyenne))






title_ = paste0("\nProportion moyenne\nd'assec : projection MOHC.HadGEM2.ES.CLMcom.CCLM4.ADAMONT")
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
                       "/Map/Map_propAssecMoyenneJuilletOct_ProjMediane_MOHC_HadGEM2_ES_CLMcom_CCLM4_ADAMONT_",pattern_,"_1_20240412")
breaks_ProbaAssecMoyenne = breaks_ProbaAssecMoyenne_param
plot_map_variable(tab_ = tab_MOHC.HadGEM2.ES.CLMcom.CCLM4.ADAMONT,
                  varname_ = "mean_",
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
                  borderCol = "gray40",
                  taillePalette = length(breaks_ProbaAssecMoyenne)+3,
                  retenuPalette = length(breaks_ProbaAssecMoyenne))

plot_map_variable_sansEtiquettes(tab_ = tab_MOHC.HadGEM2.ES.CLMcom.CCLM4.ADAMONT,
                                 varname_ = "mean_",
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
                                 borderCol = "gray40",
                                 taillePalette = length(breaks_ProbaAssecMoyenne)+3,
                                 retenuPalette = length(breaks_ProbaAssecMoyenne))









title_ = paste0("\nProportion moyenne\nd'assec : projection MOHC.HadGEM2.ES.CNRM.ALADIN63.ADAMONT")
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
                       "/Map/Map_propAssecMoyenneJuilletOct_MOHC_HadGEM2_ES_CNRM_ALADIN63_ADAMONT_",pattern_,"_1_20240412")
breaks_ProbaAssecMoyenne = breaks_ProbaAssecMoyenne_param
plot_map_variable(tab_ = tab_MOHC.HadGEM2.ES.CNRM.ALADIN63.ADAMONT,
                  varname_ = "mean_",
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
                  borderCol = "gray40",
                  taillePalette = length(breaks_ProbaAssecMoyenne)+3,
                  retenuPalette = length(breaks_ProbaAssecMoyenne))

plot_map_variable_sansEtiquettes(tab_ = tab_MOHC.HadGEM2.ES.CNRM.ALADIN63.ADAMONT,
                                 varname_ = "mean_",
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
                                 borderCol = "gray40",
                                 taillePalette = length(breaks_ProbaAssecMoyenne)+3,
                                 retenuPalette = length(breaks_ProbaAssecMoyenne))
