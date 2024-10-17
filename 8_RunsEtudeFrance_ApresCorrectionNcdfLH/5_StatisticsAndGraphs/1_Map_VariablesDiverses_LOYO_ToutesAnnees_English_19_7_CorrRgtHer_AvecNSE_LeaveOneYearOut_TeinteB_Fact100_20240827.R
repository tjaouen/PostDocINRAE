source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_12_SaveRds_CorrRgptHER_20230921.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_14_SaveRds_ChoseDensityMin_20231018.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_15_SaveRds_ChoseDensityMin_20231020.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_16_SaveRds_ChoseDensityMin_20231120.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_17_SaveRds_ChoseDensityMin_Pdf_20231206.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_18_SaveRds_ChoseDensityMin_Pdf_20231211.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_31_NewColors_Svg_20240319.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")

source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunObs20122019.R")


folder_output_ = folder_output_param_
nomSim_ = nomSim_param_
jourMin_ = jourMin_param_
jourMax_ = jourMax_param_
nom_categorieSimu_ = nom_categorieSimu_param_
nom_apprentissage_ = nom_apprentissage_param_
nom_validation_ = nom_validation_param_
annees_validModels_ = annees_validModels_param_
nom_GCM_ = nom_GCM_param_
breaks_NSE_ = breaks_NSE_param

nom_apprentissage_param_ = "ApprentissageLeaveOneYearOut"
nom_validation_param_ = "Validation_2LeaveOneYearOut"

# nomSim_ = "17_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrOubliHerJointes20212022etFonctionSeuilOnde_SensiIntervJours_2012_2022_20230614"
# nom_categorieSimu_ = "LeaveOneYearOut"
# nom_apprentissage_ = ""
# nom_validation_ = ""

# filename_ <- list.files(paste0(folder_output_,
#                                "15_ResultatsModeles_ValidationParAnnees_ParHer/",
#                                nomSim_,
#                                "/LeaveOneYearOut/TableGlobale/"), pattern = paste0("Jm",jourMin_,"Jj.*csv"), full.names = T)

nom_apprentissage_ = "ApprentissageLeaveOneYearOut"
nom_validation_ = "Validation_2LeaveOneYearOut"
filename_ <- list.files(paste0(folder_output_,
                               "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                               nomSim_,
                               ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                               ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                               ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                               ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                               "/TableGlobale/"), pattern = paste0("Jm",jourMin_,"Jj.*csv"), full.names = T)
# filename_ = filename_[grepl(paste(substr(annees_validModels_,3,4),collapse = "-"),filename_)]

########################################
### CHOIX DE LA SIMU ###################
########################################
if (nom_GCM_ != ""){
  filename_ = filename_[grepl(nom_GCM_,filename_)]
}else{
  filename_ = filename_[1]
}
########################################


tab_results_ = read.table(filename_, sep = ";", dec = ".", header = T)
if (ncol(tab_results_) == 1){
  tab_results_ = read.table(filename_, sep = ",", dec = ".", header = T)
}

### Jonction HER ###
tab_results_$HER[which(tab_results_$HER == 37054)] = "37+54"
tab_results_$HER[which(tab_results_$HER == 69096)] = "69+96"
tab_results_$HER[which(tab_results_$HER == 31033039)] = "31+33+39"
tab_results_$HER[which(tab_results_$HER == 49090)] = "49+90"
tab_results_$HER[which(tab_results_$HER == 89092)] = "89+92"


######### POUR MAP #########
if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/"))
}




### Intercept ###
if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/1_Map_Globale_Intercept_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/1_Map_Globale_Intercept_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/1_Map_Globale_Intercept_NonBoot/Intercept_NonBoot")
breaks_Intercept <- breaks_Intercept_param
# "/TableGlobale/Map_English/1_Map_Globale_Intercept_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"),"")
plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                 varname_ = "Intercept_general",
                                 vartitle_ = "Logistic regression\nintercept (unitless)",
                                 breaks_ = breaks_Intercept,
                                 output_name_ = output_name_,
                                 title_ = paste0("Leave One Year\nOut validation"),
                                 nomPalette_ = "misc_div_disc.txt",
                                 reverseColors_ = T,
                                 sansTexteHer_ = T,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = F,
                                 addValueUnder = -30,
                                 # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                 HER2_excluesDensity_ = NULL,
                                 annotation_txt_ = F,
                                 percentFormat = F,
                                 borderCol = "gray70")


### Proba assec a FDC nulle ###
if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/1_Map_Globale_ProbaAssecFDCnulle_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/1_Map_Globale_ProbaAssecFDCnulle_NonBoot/"))
}
tab_results_$ProbaAssecFDCnulle_general = exp(tab_results_$Intercept_general)/(1+exp(tab_results_$Intercept_general))*100
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/1_Map_Globale_ProbaAssecFDCnulle_NonBoot/ProbaAssecFDCnulle_NonBoot")
# "/TableGlobale/Map_English/1_Map_Globale_ProbaAssecFDCnulle_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"),"")
breaks_ProbaAssecFDCnulle <- breaks_ProbaAssecFDCnulle_param
plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                 varname_ = "ProbaAssecFDCnulle_general",
                                 # vartitle_ = "Probability of drying\nstate at a zero\nexceedance frequency (%)",
                                 vartitle_ = "Probability (%)",
                                 breaks_ = breaks_ProbaAssecFDCnulle,
                                 # breaks_ = c(0,10,20,30,40,50,60,70),
                                 output_name_ = output_name_,
                                 title_ = paste0("Leave One Year\nOut validation"),
                                 # nomPalette_ = "cryo_div_disc.txt",
                                 nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                 reverseColors_ = T,
                                 sansTexteHer_ = T,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = T,
                                 addValueUnder = -30,
                                 # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                 HER2_excluesDensity_ = NULL,
                                 annotation_txt_ = F,
                                 percentFormat = T,
                                 borderCol = "gray70")

### Proba assec moyenne a predire ###
if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/1_Map_Globale_ProbaAssecMoyenApredire_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/1_Map_Globale_ProbaAssecMoyenApredire_NonBoot/"))
}
tab_results_$ProbaAssecFDCnulle_general = exp(tab_results_$Intercept_general)/(1+exp(tab_results_$Intercept_general))*100
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/1_Map_Globale_ProbaAssecMoyenApredire_NonBoot/ProbaAssecMoyenApredire_NonBoot")
# "/TableGlobale/Map_English/1_Map_Globale_ProbaAssecFDCnulle_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"),"")
plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                 varname_ = "P_assecs_HER_MoyenneGlobale_Predit_general",
                                 # vartitle_ = "Probability of drying\nstate at a zero\nexceedance frequency (%)",
                                 vartitle_ = "Probability (%)",
                                 # breaks_ = breaks_ProbaAssecMoyenne,
                                 # breaks_ = c(0,10,20,30,40,50,60,70),
                                 breaks_ = c(0,5,10,15,20,30,40),
                                 output_name_ = output_name_,
                                 title_ = paste0("Leave One Year\nOut validation"),
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
                                 annotation_txt_ = F,
                                 percentFormat = T,
                                 borderCol = "gray70",
                                 taillePalette = 10,
                                 retenuPalette = 6)



### Proba assec moyenne predite ###
if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/1_Map_Globale_ProbaAssecMoyenPredite_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/1_Map_Globale_ProbaAssecMoyenPredite_NonBoot/"))
}
tab_results_$ProbaAssecFDCnulle_general = exp(tab_results_$Intercept_general)/(1+exp(tab_results_$Intercept_general))*100
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/1_Map_Globale_ProbaAssecMoyenPredite_NonBoot/ProbaAssecMoyenPredite_NonBoot")
# "/TableGlobale/Map_English/1_Map_Globale_ProbaAssecFDCnulle_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"),"")
plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                 varname_ = "P_assecs_HER_MoyenneGlobale_Predit_general",
                                 # vartitle_ = "Probability of drying\nstate at a zero\nexceedance frequency (%)",
                                 vartitle_ = "Probability (%)",
                                 # breaks_ = breaks_ProbaAssecMoyenne,
                                 # breaks_ = c(0,10,20,30,40,50,60,70),
                                 breaks_ = c(0,5,10,15,20,30,40),
                                 output_name_ = output_name_,
                                 title_ = paste0("Leave One Year\nOut validation"),
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
                                 annotation_txt_ = F,
                                 percentFormat = T,
                                 borderCol = "gray70",
                                 taillePalette = length(c(0,5,10,15,20,30,40))+3,
                                 retenuPalette = length(c(0,5,10,15,20,30,40))+1)

# tab_res_ = read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2022_20230919/DebitsComplets_From20120101_To20221231/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableGlobale/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_ValidGlobale__Jm6Jj_logit.csv", sep =";", dec = ".", header = T)
# plot(tab_res_$P_assecs_HER_MoyenneGlobale_Predit_general ~ tab_res_$P_assecs_HER_MoyenneGlobale_Apredire_general)

### Slope ###
if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/2_Map_Globale_Slope_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/2_Map_Globale_Slope_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/2_Map_Globale_Slope_NonBoot/Slope_NonBoot")
# "/TableGlobale/Map_English/2_Map_Globale_Slope_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"),"")
breaks_Slope <- breaks_Slope_param
plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                 varname_ = "Slope_general",
                                 vartitle_ = bquote("Slope (%"^{-1}~")"),  # Utilisation de expression pour mettre le -1 en exposant
                                 # vartitle_ = "Pente\n(%)",
                                 breaks_ = breaks_Slope,
                                 output_name_ = output_name_,
                                 title_ = paste0("Leave One Year\nOut validation"),
                                 # nomPalette_ = "misc_div_disc.txt",
                                 nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt",
                                 reverseColors_ = F,
                                 sansTexteHer_ = T,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = F,
                                 addValueUnder = -30,
                                 # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                 HER2_excluesDensity_ = NULL,
                                 annotation_txt_ = F,
                                 percentFormat = F,
                                 borderCol = "gray70")

### Proportion deviance ###
if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/3_Map_Globale_PropDev_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/3_Map_Globale_PropDev_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/3_Map_Globale_PropDev_NonBoot/PropDev_NonBoot")
# "/TableGlobale/Map_English/3_Map_Globale_PropDev_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"),"")
breaks_propDev <- breaks_propDev_param
plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                 varname_ = "PropParameterDeviance_logit_Learn_general",
                                 vartitle_ = "Proportion of\ndeviance (%)",
                                 breaks_ = breaks_propDev,
                                 output_name_ = output_name_,
                                 title_ = paste0("Leave One Year\nOut validation"),
                                 # nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                 nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                 reverseColors_ = T,
                                 sansTexteHer_ = T,
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

### KGE ###
if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/4_Map_Globale_KGE_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/4_Map_Globale_KGE_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/4_Map_Globale_KGE_NonBoot/KGE_NonBoot")
# "/TableGlobale/Map_English/4_Map_Globale_KGE_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"),"")
breaks_KGE <- breaks_KGE_param
plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                 varname_ = "KGE_HER_AnneeValid_logit_CValid_general",
                                 vartitle_ = "KGE\n(unitless)",
                                 # breaks_ = breaks_KGE,
                                 breaks_ = c(-20,breaks_KGE),
                                 output_name_ = output_name_,
                                 title_ = paste0("Leave One Year\nOut validation"),
                                 # nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                 nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                 reverseColors_ = F,
                                 sansTexteHer_ = T,
                                 reverseLegend_ = T,
                                 reverseFinal_bis = T,
                                 echelleAttenuee_ = T,
                                 addValueUnder = -30,
                                 # labels_name_ = F,
                                 labels_name_ = c("","0  ","0.5","0.6","0.7","0.8","0.85","0.9","0.95","  1"),
                                 # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                 HER2_excluesDensity_ = NULL,
                                 annotation_txt_ = T,
                                 percentFormat = F,
                                 doubleLegend_ = F,
                                 borderCol = "gray70",
                                 taillePalette = length(breaks_KGE)+2,
                                 retenuPalette = length(breaks_KGE)+1,
                                 labels_direct = c("<0","0","0.5","0.6","0.7","0.8","0.85","0.9","0.95","1"))

### Biais ###
if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/5_Map_Globale_Biais_General_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/5_Map_Globale_Biais_General_NonBoot/"))
}
tab_results_$Biais_general = as.numeric(tab_results_$Biais_general)
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/5_Map_Globale_Biais_General_NonBoot/Biais_General_NonBoot")
# "/TableGlobale/Map_English/5_Map_Globale_Biais_General_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"),"")
breaks_Biais <- breaks_Biais_param
# breaks_Biais <- breaks_Biais_param * 100
# tab_results_$Biais_general <- tab_results_$Biais_general * 100
plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                 varname_ = "Biais_general",
                                 vartitle_ = "Bias\n(unitless)",
                                 # breaks_ = breaks_Biais,
                                 breaks_ = c(-50.0,-5.0,-1.0,-0.1,-0.05,0.05,0.1,1.0,5.0,50.0),
                                 output_name_ = output_name_,
                                 title_ = paste0("Leave One Year\nOut validation"),
                                 nomPalette_ = "cryo_div_disc.txt",
                                 # nomPalette_ = "misc_div_disc.txt",
                                 # nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt",
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
                                 borderCol = "gray70",
                                 taillePalette = 11,
                                 retenuPalette = 11,
                                 labels_direct = c("<(-5)","-5","-1","-0.1","-0.05","0.05","0.1","1","5",">5"))
# labels_direct = c("<(-5)","-5","-1","-0.1","0.1","1","5",">5"))

### Erreur Moyenne Absolue ###
if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/6_Map_Globale_ErrMoyAbs_General_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/6_Map_Globale_ErrMoyAbs_General_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/6_Map_Globale_ErrMoyAbs_General_NonBoot/ErrMoyAbs_General_NonBoot")
# "/TableGlobale/Map_English/6_Map_Globale_ErrMoyAbs_General_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"),"")
breaks_ErrMoyAbs <- breaks_ErrMoyAbs_param
# breaks_ErrMoyAbs <- breaks_ErrMoyAbs_param * 100
# tab_results_$ErreurMoyenneAbsolue_general * 100
plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                 varname_ = "ErreurMoyenneAbsolue_general",
                                 # vartitle_ = "Mean Absolute Error\nbetween predictions\nand observations of\ndrying state at ONDE sites\n(unitless)",
                                 vartitle_ = "MAE\n(unitless)",
                                 breaks_ = breaks_ErrMoyAbs,
                                 output_name_ = output_name_,
                                 title_ = paste0("Leave One Year\nOut validation"),
                                 # nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
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
                                 retenuPalette = length(breaks_ErrMoyAbs),
                                 labels_direct = c("0","2","4","6","8","10","15",">15"))

### RMSE ###
if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/7_Map_Globale_RMSE_General_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/7_Map_Globale_RMSE_General_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/7_Map_Globale_RMSE_General_NonBoot/RMSE_General_NonBoot")
# "/TableGlobale/Map_English/7_Map_Globale_RMSE_General_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"),"")
breaks_RMSE <- breaks_RMSE_param
# breaks_RMSE <- breaks_RMSE_param * 100
# tab_results_$RMSE_general <- tab_results_$RMSE_general * 100
plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                 varname_ = "RMSE_general",
                                 vartitle_ = "RMSE\n(unitless)",
                                 breaks_ = breaks_RMSE,
                                 output_name_ = output_name_,
                                 title_ = paste0("Leave One Year\nOut validation"),
                                 # nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
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
                                 retenuPalette = length(breaks_RMSE),
                                 labels_direct = c("0","2","4","6","8","10","15","20",">20"))

# ### RMSE, EMA et Biais par mois ###
if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/8_Map_Globale_NSE_General_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/8_Map_Globale_NSE_General_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/8_Map_Globale_NSE_General_NonBoot/NSE_General_NonBoot")
# "/TableGlobale/Map_English/6_Map_Globale_ErrMoyAbs_Mois09_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"),"")
breaks_NSE_ <- breaks_NSE_param
plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                 varname_ = "NASH_HER_AnneeValid_logit_CValid_general",
                                 # vartitle_ = "Mean Absolute Error\nbetween predictions\nand observations of\ndrying state at ONDE sites\n(unitless)",
                                 # vartitle_ = "Nash Sutcliffe Efficiency\n(unitless)",
                                 vartitle_ = "NSE\n(unitless)",
                                 # breaks_ = breaks_NSE_,
                                 # breaks_ = breaks_KGE,
                                 breaks_ = c(-20,breaks_NSE_),
                                 output_name_ = output_name_,
                                 title_ = paste0("Leave One Year\nOut validation"),
                                 # nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                 nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                 reverseColors_ = F,
                                 reverseLegend_ = T,
                                 reverseFinal_bis = T,
                                 sansTexteHer_ = T,
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
                                 retenuPalette = length(breaks_NSE_)+1,
                                 labels_direct = c("<0","0","0.5","0.6","0.7","0.8","0.85","0.9","0.95","1"))



