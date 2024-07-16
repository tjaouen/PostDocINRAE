source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/6_RunsEtudeFrance_CorrectionImportOnde_20230607/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunObs20122019.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/ToolBox/Graphes_HER2hybrides_VariableBreaks_1_20230608.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_2_20230621.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_3_20230621.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_4_20230801.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_5_20230802.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_7_SaveRds_20230821.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_9_SaveRds_20230829.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_10_SaveRds_20230829.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_11_SaveRds_20230831.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_12_SaveRds_CorrRgptHER_20230921.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_18_SaveRds_ChoseDensityMin_Pdf_20231211.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_31_NewColors_Svg_20240319.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")

folder_output_ = folder_output_param_
nomSim_ = nomSim_param_
jourMin_ = jourMin_param_
jourMax_ = jourMax_param_
nom_categorieSimu_ = nom_categorieSimu_param_
nom_apprentissage_ = nom_apprentissage_param_
nom_validation_ = nom_validation_param_
nom_GCM_ = nom_GCM_param_

nom_apprentissage_ = "ApprentissageParDeuxCategoriesParmiSechesInterHumides"
nom_validation_ = "Validation_3AnneesSechesInterHumides"

# filenames_ <- list.files(paste0(folder_output_,"15_ResultatsModeles_ValidationParAnnees_ParHer/",nomSim_,"/Validation_Globale/"), pattern = paste0("Jm",jourMin_,"Jj.*csv"), full.names = T)
# filename_ <- list.files(paste0(folder_output_,"15_ResultatsModeles_ValidationParAnnees_ParHer/",nomSim_,"/LeaveOneYearOut/Validation_Globale/"), pattern = paste0("Jm",jourMin_,"Jj.*csv"), full.names = T)

filenames_ <- list.files(paste0(folder_output_,
                                "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                                nomSim_,
                                ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                                ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                                "/TableGlobale/"), pattern = paste0("Jm",jourMin_,"Jj.*csv"), full.names = T)
if (nom_GCM_ != ""){
  filenames_ = filenames_[grepl(nom_GCM_,filenames_)]
}

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/"))
}


for (filename_ in filenames_){
  
  tab_results_ = read.table(filename_, sep = ";", dec = ".", header = T)
  if (ncol(tab_results_) == 1){
    tab_results_ = read.table(filename_, sep = ",", dec = ".", header = T)
  }
  
  ### Jonction HER ###
  tab_results_$HER[which(tab_results_$HER == 37054)] = "37+54"
  tab_results_$HER[which(tab_results_$HER == 69096)] = "69+96"
  tab_results_$HER[which(tab_results_$HER == 31033039)] = "31+33+39"
  tab_results_$HER[which(tab_results_$HER == 89092)] = "89+92"
  tab_results_$HER[which(tab_results_$HER == 49090)] = "49+90"
  
  
  
  annees_fichier_ = str_extract_all(str_after_first(filename_,"ValidGlobale"), "\\d{2}")[[1]]
  annees_fichier_ = paste0("20",annees_fichier_)
  
  # [J-6;J]
  if (length(setdiff(annees_fichier_, as.character(c(2013:2014,2016,2018)))) == 0){
    nomAnneeTest_ = "humides"
  }else if (length(setdiff(annees_fichier_, as.character(c(2012,2015,2020,2021)))) == 0){
    nomAnneeTest_ = "intermédiaires"
  }else if (length(setdiff(annees_fichier_, as.character(c(2017,2019,2022)))) == 0){
    nomAnneeTest_ = "sèches"
  }
  
  ### Intercept ###
  breaks_Intercept = breaks_Intercept_param
  if (!(dir.exists(paste0(folder_output_,
                          "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                          nomSim_,
                          ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                          ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                          ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                          "/TableGlobale/Map_English/1_Map_Globale_Intercept_NonBoot/")))){
    dir.create(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/1_Map_Globale_Intercept_NonBoot/"))
  }
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         "/TableGlobale/Map_English/1_Map_Globale_Intercept_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"))
  # "/TableGlobale/Map_English/1_Map_Globale_Intercept_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"),"_sansEtiq.pdf")
  plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                   varname_ = "Intercept_general",
                                   vartitle_ = "Logistic regression\nintercept (unitless)",
                                   breaks_ = breaks_Intercept,
                                   output_name_ = output_name_,
                                   title_ = paste0("Validation during ",ifelse(nomAnneeTest_=="sèches","dry",
                                                                               ifelse(nomAnneeTest_=="intermédiaires","intermediate",
                                                                                      ifelse(nomAnneeTest_=="humides","wet","")))," years\n(",paste(annees_fichier_, collapse = ", "),")"),
                                   nomPalette_ = "misc_div_disc.txt",
                                   reverseColors_ = T,
                                   sansTexteHer_ = T,
                                   reverseLegend_ = T,
                                   echelleAttenuee_ = F,
                                   addValueUnder = -30,
                                   # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                   HER2_excluesDensity_ = NULL,
                                   annotation_txt_ = T,
                                   percentFormat = F,
                                   borderCol = "gray70")
  
  
  ### Proba assec a FDC nulle ###
  tab_results_$ProbaAssecFDCnulle_boot = exp(tab_results_$Intercept_boot)/(1+exp(tab_results_$Intercept_boot))*100
  if (!(dir.exists(paste0(folder_output_,
                          "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                          nomSim_,
                          ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                          ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                          ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                          "/TableGlobale/Map_English/1_Map_Globale_ProbaAssecFDCnulle_NonBoot/")))){
    dir.create(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/1_Map_Globale_ProbaAssecFDCnulle_NonBoot/"))
  }
  tab_results_$ProbaAssecFDCnulle_general = exp(tab_results_$Intercept_general)/(1+exp(tab_results_$Intercept_general))*100
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         # "/TableGlobale/Map_English/1_Map_Globale_ProbaAssecFDCnulle_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"),"_sansEtiq.pdf")
  "/TableGlobale/Map_English/1_Map_Globale_ProbaAssecFDCnulle_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"))
  plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                   varname_ = "ProbaAssecFDCnulle_general",
                                   vartitle_ = "Probability of drying\nstate at a zero\nexceedance frequency (%)",
                                   # breaks_ = breaks_ProbaAssecFDCnulle,
                                   breaks_ = c(0,10,20,30,40,50,60,70),
                                   output_name_ = output_name_,
                                   title_ = paste0("Validation during ",ifelse(nomAnneeTest_=="sèches","dry",
                                                                               ifelse(nomAnneeTest_=="intermédiaires","intermediate",
                                                                                      ifelse(nomAnneeTest_=="humides","wet","")))," years\n(",paste(annees_fichier_, collapse = ", "),")"),
                                   # nomPalette_ = "prec_div_disc.txt",
                                   # nomPalette_ = "cryo_div_disc.txt",
                                   nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt",
                                   reverseColors_ = T,
                                   sansTexteHer_ = T,
                                   reverseLegend_ = T,
                                   echelleAttenuee_ = T,
                                   addValueUnder = -30,
                                   # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                   HER2_excluesDensity_ = NULL,
                                   annotation_txt_ = T,
                                   percentFormat = T,
                                   borderCol = "gray70")
  
  
  
  ### Proba assec moyen a predire ###
  tab_results_$P_assecs_HER_MoyenneGlobale_Apredire_boot
  if (!(dir.exists(paste0(folder_output_,
                          "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                          nomSim_,
                          ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                          ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                          ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                          "/TableGlobale/Map_English/1_Map_Globale_ProbaAssecMoyenApredire_NonBoot/")))){
    dir.create(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/1_Map_Globale_ProbaAssecMoyenApredire_NonBoot/"))
  }
  tab_results_$ProbaAssecFDCnulle_general = exp(tab_results_$Intercept_general)/(1+exp(tab_results_$Intercept_general))*100
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         "/TableGlobale/Map_English/1_Map_Globale_ProbaAssecMoyenApredire_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"))
  # "/TableGlobale/Map_English/1_Map_Globale_ProbaAssecMoyenApredire_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"),"_sansEtiq.pdf")
  plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                   varname_ = "P_assecs_HER_MoyenneGlobale_Apredire_general",
                                   vartitle_ = "Mean probability of drying to be predicted",
                                   # breaks_ = breaks_ProbaAssecFDCnulle,
                                   breaks_ = c(0,10,20,30,40,50,60,70),
                                   output_name_ = output_name_,
                                   title_ = paste0("Validation during ",ifelse(nomAnneeTest_=="sèches","dry",
                                                                               ifelse(nomAnneeTest_=="intermédiaires","intermediate",
                                                                                      ifelse(nomAnneeTest_=="humides","wet","")))," years\n(",paste(annees_fichier_, collapse = ", "),")"),
                                   # nomPalette_ = "prec_div_disc.txt",
                                   # nomPalette_ = "cryo_div_disc.txt",
                                   # nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                   nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                   reverseColors_ = T,
                                   sansTexteHer_ = T,
                                   reverseLegend_ = T,
                                   echelleAttenuee_ = T,
                                   addValueUnder = -30,
                                   # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                   HER2_excluesDensity_ = NULL,
                                   annotation_txt_ = T,
                                   percentFormat = T,
                                   borderCol = "gray70")
  
  
  
  ### Proba assec moyen predit ###
  if (!(dir.exists(paste0(folder_output_,
                          "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                          nomSim_,
                          ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                          ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                          ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                          "/TableGlobale/Map_English/1_Map_Globale_ProbaAssecMoyenPredite_NonBoot/")))){
    dir.create(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/1_Map_Globale_ProbaAssecMoyenPredite_NonBoot/"))
  }
  tab_results_$ProbaAssecFDCnulle_general = exp(tab_results_$Intercept_general)/(1+exp(tab_results_$Intercept_general))*100
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         "/TableGlobale/Map_English/1_Map_Globale_ProbaAssecMoyenPredite_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"))
  # "/TableGlobale/Map_English/1_Map_Globale_ProbaAssecMoyenPredite_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"),"_sansEtiq.pdf")
  plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                   varname_ = "P_assecs_HER_MoyenneGlobale_Predit_general",
                                   vartitle_ = "Predicted mean probability of drying",
                                   # breaks_ = breaks_ProbaAssecFDCnulle,
                                   breaks_ = c(0,10,20,30,40,50,60,70),
                                   output_name_ = output_name_,
                                   title_ = paste0("Validation during ",ifelse(nomAnneeTest_=="sèches","dry",
                                                                               ifelse(nomAnneeTest_=="intermédiaires","intermediate",
                                                                                      ifelse(nomAnneeTest_=="humides","wet","")))," years\n(",paste(annees_fichier_, collapse = ", "),")"),
                                   # nomPalette_ = "prec_div_disc.txt",
                                   # nomPalette_ = "cryo_div_disc.txt",
                                   # nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                   nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                   reverseColors_ = T,
                                   sansTexteHer_ = T,
                                   reverseLegend_ = T,
                                   echelleAttenuee_ = T,
                                   addValueUnder = -30,
                                   # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                   HER2_excluesDensity_ = NULL,
                                   annotation_txt_ = T,
                                   percentFormat = T,
                                   borderCol = "gray70")
  
  
  
  ### Slope ###
  if (!(dir.exists(paste0(folder_output_,
                          "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                          nomSim_,
                          ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                          ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                          ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                          "/TableGlobale/Map_English/2_Map_Globale_Slope_NonBoot/")))){
    dir.create(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/2_Map_Globale_Slope_NonBoot/"))
  }
  breaks_Slope <- breaks_Slope_param
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         "/TableGlobale/Map_English/2_Map_Globale_Slope_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"))
  # "/TableGlobale/Map_English/2_Map_Globale_Slope_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"),"_sansEtiq.pdf")
  plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                   varname_ = "Slope_general",
                                   vartitle_ = bquote("Slope (%"^{-1}~")"),  # Utilisation de expression pour mettre le -1 en exposant
                                   breaks_ = breaks_Slope,
                                   output_name_ = output_name_,
                                   title_ = paste0("Validation during ",ifelse(nomAnneeTest_=="sèches","dry",
                                                                               ifelse(nomAnneeTest_=="intermédiaires","intermediate",
                                                                                      ifelse(nomAnneeTest_=="humides","wet","")))," years\n(",paste(annees_fichier_, collapse = ", "),")"),
                                   # nomPalette_ = "misc_div_disc.txt",
                                   nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt",
                                   reverseColors_ = F,
                                   sansTexteHer_ = T,
                                   reverseLegend_ = T,
                                   echelleAttenuee_ = F,
                                   addValueUnder = -30,
                                   # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                   HER2_excluesDensity_ = NULL,
                                   annotation_txt_ = T,
                                   percentFormat = F,
                                   borderCol = "gray70")
  
  ### Proportion deviance ###
  if (!(dir.exists(paste0(folder_output_,
                          "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                          nomSim_,
                          ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                          ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                          ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                          "/TableGlobale/Map_English/3_Map_Globale_PropDev_NonBoot/")))){
    dir.create(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/3_Map_Globale_PropDev_NonBoot/"))
  }
  breaks_propDev <- breaks_propDev_param
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         "/TableGlobale/Map_English/3_Map_Globale_PropDev_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"))
  # "/TableGlobale/Map_English/3_Map_Globale_PropDev_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"),"_sansEtiq.pdf")
  plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                   varname_ = "PropParameterDeviance_logit_Learn_general",
                                   vartitle_ = "Proportion of deviance (%)",
                                   breaks_ = breaks_propDev,
                                   output_name_ = output_name_,
                                   title_ = paste0("Validation during ",ifelse(nomAnneeTest_=="sèches","dry",
                                                                               ifelse(nomAnneeTest_=="intermédiaires","intermediate",
                                                                                      ifelse(nomAnneeTest_=="humides","wet","")))," years\n(",paste(annees_fichier_, collapse = ", "),")"),
                                   # nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt",
                                   nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt",
                                   sansTexteHer_ = F,
                                   reverseColors_ = T,
                                   reverseLegend_ = T,
                                   echelleAttenuee_ = T,
                                   addValueUnder = -30,
                                   # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                   HER2_excluesDensity_ = NULL,
                                   annotation_txt_ = F,
                                   percentFormat = T,
                                   doubleLegend_ = F,
                                   borderCol = "gray70",
                                   taillePalette = length(breaks_propDev)+1,
                                   retenuPalette = length(breaks_propDev))
  # 
  # tab_ = tab_results_
  # varname_ = "PropParameterDeviance_logit_Learn_general"
  # vartitle_ = "Proportion of deviance (%)"
  # breaks_ = breaks_propDev
  # output_name_ = output_name_
  # title_ = paste0("Validation during ",ifelse(nomAnneeTest_=="sèches","dry",
  #                                             ifelse(nomAnneeTest_=="intermédiaires","intermediate",
  #                                                    ifelse(nomAnneeTest_=="humides","wet","")))," years\n(",paste(annees_fichier_, collapse = ", "),")")
  # nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt"
  # sansTexteHer_ = F
  # reverseColors_ = T
  # reverseLegend_ = T
  # echelleAttenuee_ = F
  # addValueUnder = -30
  # HER2_excluesDensity_ = NULL
  # annotation_txt_ = F
  # percentFormat = F
  # doubleLegend_ = T
  # borderCol = "gray70"
  # taillePalette = length(breaks_propDev)+1
  # retenuPalette = length(breaks_propDev)
  
  ### KGE ###
  breaks_KGE = breaks_KGE_param
  if (!(dir.exists(paste0(folder_output_,
                          "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                          nomSim_,
                          ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                          ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                          ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                          "/TableGlobale/Map_English/4_Map_Globale_KGE_NonBoot/")))){
    dir.create(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/4_Map_Globale_KGE_NonBoot/"))
  }
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         "/TableGlobale/Map_English/4_Map_Globale_KGE_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"))
  # "/TableGlobale/Map_English/4_Map_Globale_KGE_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"),"_sansEtiq.pdf")
  plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                   varname_ = "KGE_HER_AnneeValid_logit_CValid_general",
                                   vartitle_ = "KGE (unitless)",
                                   # breaks_ = breaks_KGE,
                                   breaks_ = c(-20,breaks_KGE),
                                   output_name_ = output_name_,
                                   title_ = paste0("Validation during ",ifelse(nomAnneeTest_=="sèches","dry",
                                                                               ifelse(nomAnneeTest_=="intermédiaires","intermediate",
                                                                                      ifelse(nomAnneeTest_=="humides","wet","")))," years\n(",paste(annees_fichier_, collapse = ", "),")"),
                                   # nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt",
                                   nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt",
                                   reverseColors_ = F,
                                   sansTexteHer_ = T,
                                   reverseLegend_ = T,
                                   reverseFinal_bis = T,
                                   echelleAttenuee_ = T,
                                   addValueUnder = -30,
                                   labels_name_ = c("","0","0.5","0.6","0.7","0.8","0.85","0.9","0.95","1"),
                                   # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                   HER2_excluesDensity_ = NULL,
                                   annotation_txt_ = T,
                                   percentFormat = F,
                                   doubleLegend_ = F,
                                   borderCol = "gray70",
                                   taillePalette = length(breaks_KGE)+2,
                                   retenuPalette = length(breaks_KGE)+1)
  
  # tab_ = tab_results_
  # varname_ = "KGE_HER_AnneeValid_logit_CValid_general"
  # vartitle_ = "KGE (unitless)"
  # breaks_ = c(-20,breaks_KGE)
  # output_name_ = output_name_
  # title_ = paste0("Validation during ",ifelse(nomAnneeTest_=="sèches","dry",
  #                                             ifelse(nomAnneeTest_=="intermédiaires","intermediate",
  #                                                    ifelse(nomAnneeTest_=="humides","wet","")))," years\n(",paste(annees_fichier_, collapse = ", "),")")
  # nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt"
  # reverseColors_ = F
  # sansTexteHer_ = T
  # reverseLegend_ = T
  # echelleAttenuee_ = T
  # addValueUnder = -30
  # labels_name_ = c("","0","0.5","0.6","0.7","0.8","0.85","0.9","0.95","1")
  # HER2_excluesDensity_ = NULL
  # annotation_txt_ = T
  # percentFormat = F
  # doubleLegend_ = F
  # borderCol = "gray70"
  # taillePalette = length(breaks_KGE)+2
  # retenuPalette = length(breaks_KGE)+1
  
  # taillePalette = length(breaks_KGE)+1,
  #                                  retenuPalette = length(breaks_KGE))
  
  ### Biais ###
  breaks_Biais = breaks_Biais_param
  if (!(dir.exists(paste0(folder_output_,
                          "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                          nomSim_,
                          ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                          ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                          ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                          "/TableGlobale/Map_English/5_Map_Globale_Biais_General_NonBoot/")))){
    dir.create(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/5_Map_Globale_Biais_General_NonBoot/"))
  }
  tab_results_$Biais_general = as.numeric(tab_results_$Biais_general)
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         "/TableGlobale/Map_English/5_Map_Globale_Biais_General_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"))
  # "/TableGlobale/Map_English/5_Map_Globale_Biais_General_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"),"_sansEtiq.pdf")
  plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                   varname_ = "Biais_general",
                                   vartitle_ = "Bias (unitless)",
                                   breaks_ = breaks_Biais,
                                   output_name_ = output_name_,
                                   title_ = paste0("Validation during ",ifelse(nomAnneeTest_=="sèches","dry",
                                                                               ifelse(nomAnneeTest_=="intermédiaires","intermediate",
                                                                                      ifelse(nomAnneeTest_=="humides","wet","")))," years\n(",paste(annees_fichier_, collapse = ", "),")"),
                                   nomPalette_ = "cryo_div_disc.txt",
                                   # nomPalette_ = "misc_div_disc.txt",
                                   reverseColors_ = F,
                                   sansTexteHer_ = T,
                                   reverseLegend_ = T,
                                   echelleAttenuee_ = F,
                                   addValueUnder = -30,
                                   # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                   HER2_excluesDensity_ = NULL,
                                   annotation_txt_ = T,
                                   percentFormat = F,
                                   doubleLegend_ = F,
                                   borderCol = "gray70")
  
  ### Erreur Moyenne Absolue ###
  if (!(dir.exists(paste0(folder_output_,
                          "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                          nomSim_,
                          ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                          ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                          ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                          "/TableGlobale/Map_English/6_Map_Globale_ErrMoyAbs_General_NonBoot/")))){
    dir.create(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/6_Map_Globale_ErrMoyAbs_General_NonBoot/"))
  }
  breaks_ErrMoyAbs <- breaks_ErrMoyAbs_param
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         "/TableGlobale/Map_English/6_Map_Globale_ErrMoyAbs_General_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"))
  # "/TableGlobale/Map_English/6_Map_Globale_ErrMoyAbs_General_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"),"_sansEtiq.pdf")
  plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                   varname_ = "ErreurMoyenneAbsolue_general",
                                   # vartitle_ = "Mean Absolute Error\nbetween predictions\nand observations of\ndrying state at ONDE sites",                     
                                   vartitle_ = "Mean Absolute Error\n(unitless)",
                                   breaks_ = breaks_ErrMoyAbs,
                                   output_name_ = output_name_,
                                   title_ = paste0("Validation during ",ifelse(nomAnneeTest_=="sèches","dry",
                                                                               ifelse(nomAnneeTest_=="intermédiaires","intermediate",
                                                                                      ifelse(nomAnneeTest_=="humides","wet","")))," years\n(",paste(annees_fichier_, collapse = ", "),")"),
                                   # nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt",
                                   nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt",
                                   reverseColors_ = F,
                                   sansTexteHer_ = T,
                                   reverseLegend_ = T,
                                   reverseFinal = T,
                                   echelleAttenuee_ = F,
                                   addValueUnder = -30,
                                   # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                   HER2_excluesDensity_ = NULL,
                                   annotation_txt_ = T,
                                   percentFormat = F,
                                   doubleLegend_ = F,
                                   borderCol = "gray70",
                                   taillePalette = length(breaks_ErrMoyAbs)+1,
                                   retenuPalette = length(breaks_ErrMoyAbs))
  
  ### RMSE ###
  if (!(dir.exists(paste0(folder_output_,
                          "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                          nomSim_,
                          ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                          ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                          ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                          "/TableGlobale/Map_English/7_Map_Globale_RMSE_General_NonBoot/")))){
    dir.create(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/7_Map_Globale_RMSE_General_NonBoot/"))
  }
  breaks_RMSE <- breaks_RMSE_param
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         "/TableGlobale/Map_English/7_Map_Globale_RMSE_General_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"))
  # "/TableGlobale/Map_English/7_Map_Globale_RMSE_General_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"),"_sansEtiq.pdf")
  plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                   varname_ = "RMSE_general",
                                   vartitle_ = "RMSE\n(unitless)",
                                   breaks_ = breaks_RMSE,
                                   output_name_ = output_name_,
                                   title_ = paste0("Validation during ",ifelse(nomAnneeTest_=="sèches","dry",
                                                                               ifelse(nomAnneeTest_=="intermédiaires","intermediate",
                                                                                      ifelse(nomAnneeTest_=="humides","wet","")))," years\n(",paste(annees_fichier_, collapse = ", "),")"),
                                   # nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt",
                                   nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt",
                                   reverseColors_ = F,
                                   sansTexteHer_ = T,
                                   reverseLegend_ = T,
                                   reverseFinal = T,
                                   echelleAttenuee_ = F,
                                   addValueUnder = -1,
                                   # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                   HER2_excluesDensity_ = NULL,
                                   annotation_txt_ = F,
                                   percentFormat = F,
                                   doubleLegend_ = F,
                                   borderCol = "gray70",
                                   taillePalette = length(breaks_RMSE)+1,
                                   retenuPalette = length(breaks_RMSE))
  
  ### NSE ###
  breaks_NSE_ <- breaks_NSE_param
  if (!(dir.exists(paste0(folder_output_,
                          "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                          nomSim_,
                          ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                          ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                          ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                          "/TableGlobale/Map_English/8_Map_Globale_NSE_General_NonBoot/")))){
    dir.create(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/8_Map_Globale_NSE_General_NonBoot/"))
  }
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         "/TableGlobale/Map_English/8_Map_Globale_NSE_General_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"))
  # "/TableGlobale/Map_English/8_Map_Globale_NSE_General_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"),"_sansEtiq.pdf")
  plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                   varname_ = "NASH_HER_AnneeValid_logit_CValid_general",
                                   vartitle_ = "NSE\n(unitless)",
                                   # vartitle_ = "Nash Sutcliffe Efficiency\n(unitless)",
                                   # breaks_ = breaks_NSE_,
                                   breaks_ = c(-20,breaks_NSE_),
                                   output_name_ = output_name_,
                                   title_ = paste0("Validation during ",ifelse(nomAnneeTest_=="sèches","dry",
                                                                               ifelse(nomAnneeTest_=="intermédiaires","intermediate",
                                                                                      ifelse(nomAnneeTest_=="humides","wet","")))," years\n(",paste(annees_fichier_, collapse = ", "),")"),
                                   # nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt",
                                   nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt",
                                   reverseColors_ = F,
                                   sansTexteHer_ = T,
                                   reverseLegend_ = T,
                                   reverseFinal_bis = T,
                                   echelleAttenuee_ = T,
                                   addValueUnder = -30,
                                   labels_name_ = c("","0","0.5","0.6","0.7","0.8","0.85","0.9","0.95","1"),
                                   # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                   HER2_excluesDensity_ = NULL,
                                   annotation_txt_ = F,
                                   percentFormat = F,
                                   doubleLegend_ = F,
                                   borderCol = "gray70",
                                   taillePalette = length(breaks_NSE_)+2,
                                   retenuPalette = length(breaks_NSE_)+1)

}





