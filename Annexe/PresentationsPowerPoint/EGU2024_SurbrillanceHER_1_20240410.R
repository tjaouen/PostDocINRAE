# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunObs20122019.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_31_NewColors_Svg_20240319.R")

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


nom_apprentissage_ = "ApprentissageLeaveOneYearOut"
nom_validation_ = "Validation_2LeaveOneYearOut"
filename_ <- list.files(paste0(folder_output_,
                               "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                               nomSim_,
                               ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                               ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                               ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                               "/TableParMoisAnnees/Results_Jm6Jj/"), pattern = "_19_", full.names = T)

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

tab_results_ = tab_results_[which(month(tab_results_$Date) == 7 & year(tab_results_$Date) == 2019),]

tab_results_$HerChoisies = -1
# tab_results_$HerChoisies[which(tab_results_$HER %in% c(105,97,25))] = 1
# tab_results_$HerChoisies[which(tab_results_$HER %in% c(105,97))] = 1
tab_results_$HerChoisies[which(tab_results_$HER %in% c(105,36,12))] = 1




### SELECTIONNER DES HER ###
if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/1_Map_SelectHER2/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/1_Map_SelectHER2/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/1_Map_SelectHER2/",str_before_first(basename(filename_),pattern = ".csv"),"_sansEtiq.png")
plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                 varname_ = "HerChoisies",
                                 # vartitle_ = "Probability of drying\nstate at a zero\nexceedance frequency (%)",
                                 vartitle_ = "Probability (%)",
                                 breaks_ = c(-1,0,1),
                                 output_name_ = output_name_,
                                 title_ = paste0("Leave One Year Out validation"),
                                 nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt",
                                 reverseColors_ = T,
                                 sansTexteHer_ = T,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = T,
                                 HER2_excluesDensity_ = NULL)




