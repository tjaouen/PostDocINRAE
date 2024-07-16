source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunGraphe.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunObs20122019.R")

source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run3.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run4.R")

# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunObs20122019.R")

# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_12_SaveRds_CorrRgptHER_20230921.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_14_SaveRds_ChoseDensityMin_20231018.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_15_SaveRds_ChoseDensityMin_20231020.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_16_SaveRds_ChoseDensityMin_20231120.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_17_2_SaveRds_ChoseDensityMin_Pdf_20230104.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_18_SaveRds_ChoseDensityMin_Pdf_20231211.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")

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

nom_apprentissage_ = "ApprentissageGlobalModelesBruts"
nom_validation_ = "Validation_1ModelesBruts"

# nomSim_ = "17_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrOubliHerJointes20212022etFonctionSeuilOnde_SensiIntervJours_2012_2022_20230614"
# nom_categorieSimu_ = "LeaveOneYearOut"
# nom_apprentissage_ = ""
# nom_validation_ = ""

# filename_ <- list.files(paste0(folder_output_,
#                                "15_ResultatsModeles_ValidationParAnnees_ParHer/",
#                                nomSim_,
#                                "/LeaveOneYearOut/TableGlobale/"), pattern = paste0("Jm",jourMin_,"Jj.*csv"), full.names = T)


# filename_ <- list.files(paste0(folder_output_,
#                                "/2_ResultatsModeles_ParHer/",
#                                # "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
#                                nomSim_,
#                                ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
#                                ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
#                                ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
#                                ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
#                                "/TableGlobale/"), pattern = paste0("Jm",jourMin_,"Jj.*csv"), full.names = T)
# filename_ = filename_[grepl(paste(substr(annees_validModels_,3,4),collapse = "-"),filename_)]


### Folders ###
folders_GCM_ <- list.files(paste0(folder_output_,
                                  "2_ResultatsModeles_ParHer/",
                                  nomSim_,
                                  ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_))),
                           full.names = T)


for (fold_ in folders_GCM_){
  
  ### Run ###
  filename_ <- list.files(paste0(fold_,
                                 ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_))),
                          pattern = "logit", full.names = T)
  
  
  # if (nom_GCM_ != ""){
  #   filename_ = filename_[grepl(nom_GCM_,filename_)]
  # }else{
  #   filename_ = filename_[1]
  # }
  ########################################
  
  
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
  
  
  ######### POUR MAP #########
  if(!dir.exists(paste0(folder_output_,
                        "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        ifelse(basename(fold_)=="","",paste0("/",basename(fold_)))))){
    dir.create(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(basename(fold_)=="","",paste0("/",basename(fold_)))))
  }
  if(!dir.exists(paste0(folder_output_,
                        "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                        ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_))))){
    dir.create(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_))))
  }
  if(!dir.exists(paste0(folder_output_,
                        "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                        ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                        ifelse(nom_validation_=="","",paste0("/",nom_validation_))))){
    dir.create(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_))))
  }
  if(!dir.exists(paste0(folder_output_,
                        "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                        ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                        ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                        "/TableGlobale/"))){
    dir.create(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/"))
  }
  if(!dir.exists(paste0(folder_output_,
                        "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                        ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                        ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                        "/TableGlobale/Map_English/"))){
    dir.create(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/"))
  }
  
  
  
  
  ### Intercept ###
  if(!dir.exists(paste0(folder_output_,
                        "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                        ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                        ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                        "/TableGlobale/Map_English/1_Map_Gbl_Int_Brt/"))){
    dir.create(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/1_Map_Gbl_Int_Brt/"))
  }
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         # "/TableGlobale/Map_English/1_Map_Gbl_Int_Brt/",str_before_first(basename(filename_),pattern = ".csv"),".pdf")
                         # "/TableGlobale/Map_English/1_Map_Gbl_Int_Brt/Intercept_B")
                         "/TableGlobale/Map_English/1_Map_Gbl_Int_Brt/Int_B")
  # "/TableGlobale/Map_English/1_Map_Gbl_Int_Brt/",str_before_first(basename(filename_),pattern = ".csv"),".pdf")
  breaks_Intercept = breaks_Intercept_param
  plot_map_variable(tab_ = tab_results_,
                    varname_ = "Inter_logit_Learn",
                    vartitle_ = "Logistic regression\nintercept (unitless)",
                    breaks_ = breaks_Intercept,
                    output_name_ = output_name_,
                    title_ = paste0("Logistic regression intercept"),
                    nomPalette_ = "misc_div_disc.txt",
                    reverseColors_ = F,
                    reverseLegend_ = T,
                    echelleAttenuee_ = F,
                    # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                    HER2_excluesDensity_ = NULL)
  
  names(tab_results_)
  
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         # "/TableGlobale/Map_English/1_Map_Gbl_Int_Brt/",str_before_first(basename(filename_),pattern = ".csv"),"_sansEtiq.pdf")
                         # "/TableGlobale/Map_English/1_Map_Gbl_Int_Brt/Intercept_BsE")
                         "/TableGlobale/Map_English/1_Map_Gbl_Int_Brt/Int_BsE")
  # "/TableGlobale/Map_English/1_Map_Gbl_Int_Brt/",str_before_first(basename(filename_),pattern = ".csv"),"_sansEtiq.pdf")
  plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                   varname_ = "Inter_logit_Learn",
                                   vartitle_ = "Logistic regression\nintercept (unitless)",
                                   breaks_ = breaks_Intercept,
                                   output_name_ = output_name_,
                                   title_ = paste0("Logistic regression intercept"),
                                   nomPalette_ = "misc_div_disc.txt",
                                   reverseColors_ = F,
                                   sansTexteHer_ = T,
                                   reverseLegend_ = T,
                                   echelleAttenuee_ = F,
                                   # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                   HER2_excluesDensity_ = NULL)
  
  
  ### Proba assec a FDC nulle ###
  if(!dir.exists(paste0(folder_output_,
                        "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                        ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                        ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                        "/TableGlobale/Map_English/1_Map_Gbl_PFDC0_Brt/"))){
    dir.create(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/1_Map_Gbl_PFDC0_Brt/"))
  }
  tab_results_$PFDC0_boot = exp(tab_results_$Inter_logit_Learn)/(1+exp(tab_results_$Inter_logit_Learn))*100
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         # "/TableGlobale/Map_English/1_Map_Gbl_PFDC0_Brt/ProbaAssecFDC0_B")
                         "/TableGlobale/Map_English/1_Map_Gbl_PFDC0_Brt/PFDC0_B")
  # "/TableGlobale/Map_English/1_Map_Gbl_PFDC0_Brt/",str_before_first(basename(filename_),pattern = ".csv"),".pdf")
  # breaks_ProbaAssecFDCnulle = c(0,0.2,0.4,0.6,0.8,1)
  # breaks_ProbaAssecFDCnulle = c(0,20,40,60,80,100)
  breaks_ProbaAssecFDCnulle = breaks_ProbaAssecFDCnulle_param
  plot_map_variable(tab_ = tab_results_,
                    varname_ = "PFDC0_boot",
                    vartitle_ = "Probability (%)",
                    # vartitle_ = "Probability of drying\nstate at a zero\nexceedance frequency (%)",
                    breaks_ = breaks_ProbaAssecFDCnulle,
                    output_name_ = output_name_,
                    title_ = paste0("Probability of drying\nstate at a zero\nexceedance frequency (%)"),
                    # nomPalette_ = "prec_div_disc.txt",
                    nomPalette_ = "cryo_div_disc.txt",
                    reverseColors_ = T,
                    reverseLegend_ = T,
                    echelleAttenuee_ = T,
                    # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                    HER2_excluesDensity_ = NULL)
  
  
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         # "/TableGlobale/Map_English/1_Map_Gbl_PFDC0_Brt/ProbaAssecFDC0_BsE")
                         "/TableGlobale/Map_English/1_Map_Gbl_PFDC0_Brt/PFDC0_BsE")
  # "/TableGlobale/Map_English/1_Map_Gbl_PFDC0_Brt/",str_before_first(basename(filename_),pattern = ".csv"),"_sansEtiq.pdf")
  plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                   varname_ = "PFDC0_boot",
                                   # vartitle_ = "Probability of drying\nstate at a zero\nexceedance frequency (%)",
                                   vartitle_ = "Probability (%)",
                                   breaks_ = breaks_ProbaAssecFDCnulle,
                                   output_name_ = output_name_,
                                   title_ = paste0("Probability of drying\nstate at a zero\nexceedance frequency (%)"),
                                   nomPalette_ = "cryo_div_disc.txt",
                                   reverseColors_ = T,
                                   sansTexteHer_ = T,
                                   reverseLegend_ = T,
                                   echelleAttenuee_ = T,
                                   # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                   HER2_excluesDensity_ = NULL)
  
  ### Proba assec moyenne a predire ###
  tab_results_$P_assecs_HER_MoyenMois_Apredire_Learn = tab_results_$P_assecs_HER_MoyenMois_Apredire_Learn*100
  if(!dir.exists(paste0(folder_output_,
                        "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                        ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                        ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                        "/TableGlobale/Map_English/6_Map_Gbl_PMoyApred_Brt/"))){
    dir.create(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/6_Map_Gbl_PMoyApred_Brt/"))
  }
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         # "/TableGlobale/Map_English/6_Map_Gbl_ProbaMoyApredire_Brt/ProbaAssecMoyenApredire_B")
                         "/TableGlobale/Map_English/6_Map_Gbl_PMoyApred_Brt/P_B")
  # "/TableGlobale/Map_English/1_Map_Gbl_PFDC0_Brt/",str_before_first(basename(filename_),pattern = ".csv"),".pdf")
  # breaks_ProbaAssecFDCnulle = c(0,0.2,0.4,0.6,0.8,1)
  # breaks_ProbaAssecFDCnulle = c(0,20,40,60,80,100)
  breaks_ProbaAssecMoyenne = breaks_ProbaAssecMoyenne_param
  plot_map_variable(tab_ = tab_results_,
                    varname_ = "P_assecs_HER_MoyenMois_Apredire_Learn",
                    vartitle_ = "Probability (%)",
                    # vartitle_ = "Probability of drying\nstate at a zero\nexceedance frequency (%)",
                    breaks_ = breaks_ProbaAssecMoyenne,
                    output_name_ = output_name_,
                    title_ = paste0("Mean probability of drying to predict"),
                    # nomPalette_ = "prec_div_disc.txt",
                    # nomPalette_ = "cryo_div_disc.txt",
                    nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                    reverseColors_ = T,
                    reverseLegend_ = T,
                    echelleAttenuee_ = T,
                    # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                    HER2_excluesDensity_ = NULL)
  
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         # "/TableGlobale/Map_English/1_Map_Globale_ProbaAssecMoyenApredire_Brt/ProbaAssecMoyenApredire_BsE")
                         "/TableGlobale/Map_English/6_Map_Gbl_PMoyApred_Brt/P_BsE")
  # "/TableGlobale/Map_English/1_Map_Gbl_PFDC0_Brt/",str_before_first(basename(filename_),pattern = ".csv"),"_sansEtiq.pdf")
  plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                   varname_ = "P_assecs_HER_MoyenMois_Apredire_Learn",
                                   # vartitle_ = "Probability of drying\nstate at a zero\nexceedance frequency (%)",
                                   vartitle_ = "Probability (%)",
                                   breaks_ = breaks_ProbaAssecMoyenne,
                                   output_name_ = output_name_,
                                   title_ = paste0("Mean probability of drying to predict"),
                                   # nomPalette_ = "cryo_div_disc.txt",
                                   nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                   reverseColors_ = T,
                                   sansTexteHer_ = T,
                                   reverseLegend_ = T,
                                   echelleAttenuee_ = T,
                                   # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                   HER2_excluesDensity_ = NULL)
  
  
  ### Slope ###
  if(!dir.exists(paste0(folder_output_,
                        "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                        ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                        ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                        "/TableGlobale/Map_English/2_Map_Gbl_Slp_Brt/"))){
    dir.create(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/2_Map_Gbl_Slp_Brt/"))
  }
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         # "/TableGlobale/Map_English/2_Map_Gbl_Slp_Brt/Slope_B")
                         "/TableGlobale/Map_English/2_Map_Gbl_Slp_Brt/Sl_B")
  # "/TableGlobale/Map_English/2_Map_Gbl_Slp_Brt/",str_before_first(basename(filename_),pattern = ".csv"),".pdf")
  # breaks_Slope = c(-100,-20,-15,-12,-10,-8,-6,-4,-2,0)
  breaks_Slope = breaks_Slope_param
  plot_map_variable(tab_ = tab_results_,
                    varname_ = "Slope_logit_Learn",
                    vartitle_ = bquote("Slope (%"^{-1}~")"),  # Utilisation de expression pour mettre le -1 en exposant
                    # vartitle_ = "Pente\n(%)",
                    breaks_ = breaks_Slope,
                    output_name_ = output_name_,
                    title_ = paste0("Logistic regression slope"),
                    nomPalette_ = "misc_div_disc.txt",
                    reverseColors_ = F,
                    reverseLegend_ = T,
                    echelleAttenuee_ = F,
                    # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                    HER2_excluesDensity_ = NULL)
  
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         # "/TableGlobale/Map_English/2_Map_Gbl_Slp_Brt/Slope_BsE")
                         "/TableGlobale/Map_English/2_Map_Gbl_Slp_Brt/Sl_BsE")
  # "/TableGlobale/Map_English/2_Map_Gbl_Slp_Brt/",str_before_first(basename(filename_),pattern = ".csv"),"_sansEtiq.pdf")
  plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                   varname_ = "Slope_logit_Learn",
                                   vartitle_ = bquote("Slope (%"^{-1}~")"),  # Utilisation de expression pour mettre le -1 en exposant
                                   # vartitle_ = "Pente\n(%)",
                                   breaks_ = breaks_Slope,
                                   output_name_ = output_name_,
                                   title_ = paste0("Logistic regression slope"),
                                   nomPalette_ = "misc_div_disc.txt",
                                   reverseColors_ = F,
                                   sansTexteHer_ = T,
                                   reverseLegend_ = T,
                                   echelleAttenuee_ = F,
                                   # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                   HER2_excluesDensity_ = NULL)
  
  ### Proportion deviance ###
  if(!dir.exists(paste0(folder_output_,
                        "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                        ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                        ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                        "/TableGlobale/Map_English/3_Map_Gbl_PpDev_Brt/"))){
    dir.create(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/3_Map_Gbl_PpDev_Brt/"))
  }
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         # "/TableGlobale/Map_English/3_Map_Gbl_PpDev_Brt/PropDev_B")
                         "/TableGlobale/Map_English/3_Map_Gbl_PpDev_Brt/PrD_B")
  # "/TableGlobale/Map_English/3_Map_Gbl_PpDev_Brt/",str_before_first(basename(filename_),pattern = ".csv"),".pdf")
  # breaks_propDev = c(0,50,60,70,80,85,90,95,100)
  breaks_propDev = breaks_propDev_param
  plot_map_variable(tab_ = tab_results_,
                    varname_ = "PropParameterDeviance_logit_Learn",
                    vartitle_ = "Proportion of\ndeviance (%)",
                    breaks_ = breaks_propDev,
                    output_name_ = output_name_,
                    title_ = paste0("Proportion of\ndeviance (%)"),
                    nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                    reverseColors_ = F,
                    reverseLegend_ = T,
                    echelleAttenuee_ = T,
                    # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                    HER2_excluesDensity_ = NULL)
  
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         # "/TableGlobale/Map_English/3_Map_Gbl_PpDev_Brt/PropDev_BsE")
                         "/TableGlobale/Map_English/3_Map_Gbl_PpDev_Brt/PrD_BsE")
  # "/TableGlobale/Map_English/3_Map_Gbl_PpDev_Brt/",str_before_first(basename(filename_),pattern = ".csv"),"_sansEtiq.pdf")
  plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                   varname_ = "PropParameterDeviance_logit_Learn",
                                   vartitle_ = "Proportion of\ndeviance (%)",
                                   breaks_ = breaks_propDev,
                                   output_name_ = output_name_,
                                   title_ = paste0("Proportion of\ndeviance (%)"),
                                   nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                   reverseColors_ = F,
                                   sansTexteHer_ = T,
                                   reverseLegend_ = T,
                                   echelleAttenuee_ = T,
                                   # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                   HER2_excluesDensity_ = NULL)
  
  ### KGE ###
  if(!dir.exists(paste0(folder_output_,
                        "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                        ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                        ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                        "/TableGlobale/Map_English/4_Map_Gbl_KGE_Brt/"))){
    dir.create(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/4_Map_Gbl_KGE_Brt/"))
  }
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         "/TableGlobale/Map_English/4_Map_Gbl_KGE_Brt/KGE_B")
  # "/TableGlobale/Map_English/4_Map_Gbl_KGE_Brt/",str_before_first(basename(filename_),pattern = ".csv"),".pdf")
  # breaks_KGE = c(0,0.4,0.6,0.7,0.8,0.85,0.9,0.95,1)
  # breaks_KGE = c(0,0.5,0.6,0.7,0.8,0.85,0.9,0.95,1)
  breaks_KGE = breaks_KGE_param
  plot_map_variable(tab_ = tab_results_,
                    varname_ = "KGE_logit_Learn",
                    vartitle_ = "KGE (unitless)",
                    breaks_ = breaks_KGE,
                    output_name_ = output_name_,
                    title_ = paste0("Kling-Gupta Efficiency"),
                    nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                    reverseColors_ = F,
                    reverseLegend_ = T,
                    echelleAttenuee_ = T,
                    addValueUnder = -10, #-3
                    labels_name_ = c("<0",paste0("[", breaks_KGE[-length(breaks_KGE)], ";", breaks_KGE[-1], "]")),
                    # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                    HER2_excluesDensity_ = NULL)
  
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         "/TableGlobale/Map_English/4_Map_Gbl_KGE_Brt/KGE_BsE")
  # "/TableGlobale/Map_English/4_Map_Gbl_KGE_Brt/",str_before_first(basename(filename_),pattern = ".csv"),"_sansEtiq.pdf")
  plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                   varname_ = "KGE_logit_Learn",
                                   vartitle_ = "KGE (unitless)",
                                   breaks_ = breaks_KGE,
                                   output_name_ = output_name_,
                                   title_ = paste0("Kling-Gupta Efficiency"),
                                   nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                   reverseColors_ = F,
                                   sansTexteHer_ = T,
                                   reverseLegend_ = T,
                                   echelleAttenuee_ = T,
                                   addValueUnder = -10, # -3)
                                   labels_name_ = c("<0",paste0("[", breaks_KGE[-length(breaks_KGE)], ";", breaks_KGE[-1], "]")),
                                   # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                   HER2_excluesDensity_ = NULL)
  
  
  ### NSE ###
  if(!dir.exists(paste0(folder_output_,
                        "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                        ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                        ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                        "/TableGlobale/Map_English/8_Map_Gbl_NSE_Grl_Brt/"))){
    dir.create(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/8_Map_Gbl_NSE_Grl_Brt/"))
  }
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         # "/TableGlobale/Map_English/8_Map_Gbl_NSE_Grl_Brt/NSE_General_NBsE")
                         "/TableGlobale/Map_English/8_Map_Gbl_NSE_Grl_Brt/NSE_B")
  # "/TableGlobale/Map_English/6_Map_Globale_ErrMoyAbs_Mois09_Brt/",str_before_first(basename(filename_),pattern = ".csv"),"_sansEtiq.pdf")
  plot_map_variable(tab_ = tab_results_,
                    varname_ = "NASH_logit_Learn",
                    # vartitle_ = "Mean Absolute Error\nbetween predictions\nand observations of\ndrying state at ONDE sites\n(unitless)",
                    vartitle_ = "Nash Sutcliffe Efficiency\n(unitless)",
                    breaks_ = breaks_NSE_,
                    output_name_ = output_name_,
                    title_ = paste0("Nash Sutcliffe Efficiency"),
                    nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                    reverseColors_ = F,
                    reverseLegend_ = T,
                    echelleAttenuee_ = F,
                    # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                    HER2_excluesDensity_ = NULL)
  
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         # "/TableGlobale/Map_English/8_Map_Gbl_NSE_Grl_Brt/NSE_General_NonBoot_sansEtiq.pdf")
                         "/TableGlobale/Map_English/8_Map_Gbl_NSE_Grl_Brt/NSE_BsE")
  # "/TableGlobale/Map_English/6_Map_Globale_ErrMoyAbs_Mois09_Brt/",str_before_first(basename(filename_),pattern = ".csv"),"_sansEtiq.pdf")
  plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                   varname_ = "NASH_logit_Learn",
                                   # vartitle_ = "Mean Absolute Error\nbetween predictions\nand observations of\ndrying state at ONDE sites\n(unitless)",
                                   vartitle_ = "Nash Sutcliffe Efficiency\n(unitless)",
                                   breaks_ = breaks_NSE_,
                                   output_name_ = output_name_,
                                   title_ = paste0("Nash Sutcliffe Efficiency"),
                                   nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                   reverseColors_ = F,
                                   sansTexteHer_ = T,
                                   reverseLegend_ = T,
                                   echelleAttenuee_ = F,
                                   # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                   HER2_excluesDensity_ = NULL)
  
  
  #  [5] TotalDeviance_logit_Learn", "ParameterDeviance_logit_Learn", "CV_logit_Learn"
  
  
  
  
  ### P-value ###
  if(!dir.exists(paste0(folder_output_,
                        "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                        ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                        ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                        "/TableGlobale/Map_English/5_Map_Gbl_PvSlp_Brt/"))){
    dir.create(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/5_Map_Gbl_PvSlp_Brt/"))
  }
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         "/TableGlobale/Map_English/5_Map_Gbl_PvSlp_Brt/PvSl_B")
  # "/TableGlobale/Map_English/4_Map_Gbl_KGE_Brt/",str_before_first(basename(filename_),pattern = ".csv"),".pdf")
  # breaks_KGE = c(0,0.4,0.6,0.7,0.8,0.85,0.9,0.95,1)
  # breaks_KGE = c(0,0.5,0.6,0.7,0.8,0.85,0.9,0.95,1)
  breaks_pvalue = breaks_pvalue_param
  plot_map_variable(tab_ = tab_results_,
                    varname_ = "Slope_pv_logit_Learn",
                    vartitle_ = "P-value (unitless)",
                    breaks_ = breaks_pvalue,
                    output_name_ = output_name_,
                    title_ = paste0("P-value of logistic regression slope"),
                    # nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                    nomPalette_ = "temp_div_disc.txt",
                    reverseColors_ = F,
                    reverseLegend_ = T,
                    echelleAttenuee_ = T,
                    # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                    HER2_excluesDensity_ = NULL)
  
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         "/TableGlobale/Map_English/5_Map_Gbl_PvSlp_Brt/PvSl_BsE")
  # "/TableGlobale/Map_English/4_Map_Gbl_KGE_Brt/",str_before_first(basename(filename_),pattern = ".csv"),"_sansEtiq.pdf")
  plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                   varname_ = "Slope_pv_logit_Learn",
                                   vartitle_ = "P-value (unitless)",
                                   breaks_ = breaks_pvalue,
                                   output_name_ = output_name_,
                                   title_ = paste0("P-value of logistic regression slope"),
                                   # nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                   nomPalette_ = "temp_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                   reverseColors_ = F,
                                   sansTexteHer_ = T,
                                   reverseLegend_ = T,
                                   echelleAttenuee_ = T,
                                   # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                   HER2_excluesDensity_ = NULL)
  
  
  
  ### Probabilite moyenne predite -> A FAIRE ###
  if(!dir.exists(paste0(folder_output_,
                        "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                        ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                        ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                        "/TableGlobale/Map_English/6_Map_Gbl_PMoyPred_Brt/"))){
    dir.create(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/6_Map_Gbl_PMoyPred_Brt/"))
  }
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         "/TableGlobale/Map_English/6_Map_Gbl_PMoyPred_Brt/Pp_B")
  # "/TableGlobale/Map_English/4_Map_Gbl_KGE_Brt/",str_before_first(basename(filename_),pattern = ".csv"),".pdf")
  # breaks_KGE = c(0,0.4,0.6,0.7,0.8,0.85,0.9,0.95,1)
  # breaks_KGE = c(0,0.5,0.6,0.7,0.8,0.85,0.9,0.95,1)
  tab_results_$P_assecs_HER_MoyenMois_Predite_Learn = tab_results_$P_assecs_HER_MoyenMois_Predite_Learn*100
  breaks_ProbaAssecMoyenne = breaks_ProbaAssecMoyenne_param
  plot_map_variable(tab_ = tab_results_,
                    varname_ = "P_assecs_HER_MoyenMois_Predite_Learn",
                    vartitle_ = "Probability (%)",
                    # vartitle_ = "Probability of drying\nstate at a zero\nexceedance frequency (%)",
                    breaks_ = breaks_ProbaAssecMoyenne,
                    output_name_ = output_name_,
                    title_ = paste0("Mean probability of drying predicted"),
                    # nomPalette_ = "prec_div_disc.txt",
                    # nomPalette_ = "cryo_div_disc.txt",
                    nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                    reverseColors_ = T,
                    reverseLegend_ = T,
                    echelleAttenuee_ = T,
                    # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                    HER2_excluesDensity_ = NULL)
  
  output_name_ <- paste0(folder_output_,
                         "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                         nomSim_,
                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                         ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                         # "/TableGlobale/Map_English/1_Map_Globale_ProbaAssecMoyenApredire_Brt/ProbaAssecMoyenApredire_BsE")
                         "/TableGlobale/Map_English/6_Map_Gbl_PMoyPred_Brt/Pp_BsE")
  # "/TableGlobale/Map_English/1_Map_Gbl_PFDC0_Brt/",str_before_first(basename(filename_),pattern = ".csv"),"_sansEtiq.pdf")
  plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                   varname_ = "P_assecs_HER_MoyenMois_Predite_Learn",
                                   # vartitle_ = "Probability of drying\nstate at a zero\nexceedance frequency (%)",
                                   vartitle_ = "Probability (%)",
                                   breaks_ = breaks_ProbaAssecMoyenne,
                                   output_name_ = output_name_,
                                   title_ = paste0("Mean probability of drying predicted"),
                                   # nomPalette_ = "cryo_div_disc.txt",
                                   nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                   reverseColors_ = T,
                                   sansTexteHer_ = T,
                                   reverseLegend_ = T,
                                   echelleAttenuee_ = T,
                                   # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                   HER2_excluesDensity_ = NULL)
}