library(lubridate)
library(readr)
library(dplyr)
library(ggplot2)
library(purrr)

# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
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

tab_results_$HerChoisies = NA
# tab_results_$HerChoisies[which(tab_results_$HER %in% c(105,97,25))] = 1
tab_results_$HerChoisies[which(tab_results_$HER %in% c(105,97))] = 1


### Proba assec moyenne a predire ###
if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/1_Map_ParMoisAnnees_ProbaApredire/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/1_Map_ParMoisAnnees_ProbaApredire/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/1_Map_ParMoisAnnees_ProbaApredire/",str_before_first(basename(filename_),pattern = ".csv"),".png")
tab_results_$ProbaAssec_HERMoisAnnee_Apredire_CValid <- tab_results_$ProbaAssec_HERMoisAnnee_Apredire_CValid * 100
plot_map_variable(tab_ = tab_results_,
                  varname_ = "ProbaAssec_HERMoisAnnee_Apredire_CValid",
                  vartitle_ = "Probability (%)",
                  # vartitle_ = "Probability of drying\nstate at a zero\nexceedance frequency (%)",
                  breaks_ = breaks_ProbaAssecMoyenne,
                  output_name_ = output_name_,
                  title_ = paste0("Leave One Year Out validation"),
                  # nomPalette_ = "prec_div_disc.txt",
                  # nomPalette_ = "cryo_div_disc.txt",
                  # nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt",
                  nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt",
                  reverseColors_ = T,
                  reverseLegend_ = T,
                  echelleAttenuee_ = T,
                  # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                  HER2_excluesDensity_ = NULL)

output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/1_Map_ParMoisAnnees_ProbaApredire/",str_before_first(basename(filename_),pattern = ".csv"),"_sansEtiq.png")
plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                 varname_ = "ProbaAssec_HERMoisAnnee_Apredire_CValid",
                                 # vartitle_ = "Probability of drying\nstate at a zero\nexceedance frequency (%)",
                                 vartitle_ = "Probability (%)",
                                 breaks_ = breaks_ProbaAssecMoyenne,
                                 output_name_ = output_name_,
                                 title_ = paste0("Leave One Year Out validation"),
                                 # nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt",
                                 nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt",
                                 reverseColors_ = T,
                                 sansTexteHer_ = T,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = T,
                                 HER2_excluesDensity_ = NULL)

### Proba assec moyenne a predire ###
if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/1_Map_ParMoisAnnees_ProbaPredite/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/1_Map_ParMoisAnnees_ProbaPredite/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/1_Map_ParMoisAnnees_ProbaPredite/",str_before_first(basename(filename_),pattern = ".csv"),".png")
tab_results_$ProbaAssec_HERMoisAnnee_Predite_CValid <- tab_results_$ProbaAssec_HERMoisAnnee_Predite_CValid * 100
plot_map_variable(tab_ = tab_results_,
                  varname_ = "ProbaAssec_HERMoisAnnee_Predite_CValid",
                  vartitle_ = "Probability (%)",
                  # vartitle_ = "Probability of drying\nstate at a zero\nexceedance frequency (%)",
                  breaks_ = breaks_ProbaAssecMoyenne,
                  output_name_ = output_name_,
                  title_ = paste0("Leave One Year Out validation"),
                  # nomPalette_ = "prec_div_disc.txt",
                  # nomPalette_ = "cryo_div_disc.txt",
                  # nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt",
                  nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt",
                  reverseColors_ = T,
                  reverseLegend_ = T,
                  echelleAttenuee_ = T,
                  # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                  HER2_excluesDensity_ = NULL)

output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/1_Map_ParMoisAnnees_ProbaPredite/",str_before_first(basename(filename_),pattern = ".csv"),"_sansEtiq.png")
plot_map_variable_sansEtiquettes(tab_ = tab_results_,
                                 varname_ = "ProbaAssec_HERMoisAnnee_Predite_CValid",
                                 # vartitle_ = "Probability of drying\nstate at a zero\nexceedance frequency (%)",
                                 vartitle_ = "Probability (%)",
                                 breaks_ = breaks_ProbaAssecMoyenne,
                                 output_name_ = output_name_,
                                 title_ = paste0("Leave One Year Out validation"),
                                 # nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt",
                                 nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt",
                                 reverseColors_ = T,
                                 sansTexteHer_ = T,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = T,
                                 HER2_excluesDensity_ = NULL)






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
                                 breaks_ = breaks_ProbaAssecMoyenne,
                                 output_name_ = output_name_,
                                 title_ = paste0("Leave One Year Out validation"),
                                 nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt",
                                 reverseColors_ = T,
                                 sansTexteHer_ = T,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = T,
                                 HER2_excluesDensity_ = NULL)

# plot_map_variable(tab_ = tab_results_,
#                   varname_ = "HerChoisies",
#                   vartitle_ = "Probability (%)",
#                   # vartitle_ = "Probability of drying\nstate at a zero\nexceedance frequency (%)",
#                   breaks_ = breaks_ProbaAssecMoyenne,
#                   output_name_ = output_name_,
#                   title_ = paste0("Leave One Year Out validation"),
#                   # nomPalette_ = "prec_div_disc.txt",
#                   # nomPalette_ = "cryo_div_disc.txt",
#                   nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt",
#                   reverseColors_ = T,
#                   reverseLegend_ = T,
#                   echelleAttenuee_ = T,
#                   # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
#                   HER2_excluesDensity_ = NULL)










chemins_obs = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2022_20230919/DebitsComplets_From20120101_To20221231/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Results_Jm6Jj/", full.names = T)
chemins_safran = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/23_ObservesReanalyseSafran_DriasEau_20231002/DebitsComplets_DebitsParModelesHydro_FichierComplet/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Results_Jm6Jj/", full.names = T, include.dirs = F)


# donnees <- c(chemins_obs,chemins_safran) %>%
#   map_dfr(~ read.csv(.x, sep =";", dec = ".") %>% filter(HER2 == 105) %>%
#             mutate(NomFichier = basename(.x)))

donnees <- c(chemins_obs,chemins_safran) %>%
  map_dfr(~ read.csv(.x, sep =";", dec = ".") %>% filter(HER2 == 97) %>%
            mutate(NomFichier = basename(.x)))

# donnees <- c(chemins_obs,chemins_safran) %>%
#   map_dfr(~ read.csv(.x, sep =";", dec = ".") %>% filter(HER2 == 25) %>%
#             mutate(NomFichier = basename(.x)))

donnees = donnees[which(year(donnees$Date) == 2017),]
donnees$NomFichier

donnees <- donnees %>% 
  mutate(NomFichier = case_when(
    str_detect(NomFichier, "ORCHIDEE") ~ "ORCHIDEE-Safran",
    str_detect(NomFichier, "SMASH") ~ "SMASH-Safran",
    str_detect(NomFichier, "J2000") ~ "J2000-Safran",
    str_detect(NomFichier, "CTRIP") ~ "CTRIP-Safran",
    str_detect(NomFichier, "GRSD") ~ "GRSD-Safran",
    str_detect(NomFichier, "Observes") ~ "Gauging stations-Measured",
    TRUE ~ NomFichier
  ))

# donnees[,c("Date", "ProbaAssec_HERMoisAnnee_Apredire_CValid", "ProbaAssec_HERMoisAnnee_Predite_CValid", "NomFichier")]

donnees$ProbaAssec_HERMoisAnnee_Apredire_CValid = donnees$ProbaAssec_HERMoisAnnee_Apredire_CValid*100
donnees$ProbaAssec_HERMoisAnnee_Predite_CValid = donnees$ProbaAssec_HERMoisAnnee_Predite_CValid*100
donnees$Date <- as.Date(donnees$Date)

extract_ = donnees[which(donnees$NomFichier == "Gauging stations-Measured"),]
extract_$NomFichier = "Ground truth"
extract_$ProbaAssec_HERMoisAnnee_Predite_CValid = extract_$ProbaAssec_HERMoisAnnee_Apredire_CValid
donnees <- rbind(donnees, extract_)

# donnees$NomFichier[which(donnees$NomFichier == "Observes")] = "Gauging stations-Measured"
# donnees$NomFichier[which(donnees$NomFichier == "Apredire")] = "Ground truth"
donnees$NomFichier <- factor(donnees$NomFichier, levels = unique(donnees$NomFichier))

donnees$Size = NA
donnees$Size[which(donnees$NomFichier == "Ground truth")] = 1

donnees$TypeLigne <- ifelse(donnees$NomFichier %in% c("Apredire","Observes"), "continuous", "continuous")


mes_couleurs <- c("#082158", "#2498C0", "#D6EFB2", "#FEE187", "#FC5A2D", "#800026")

# Utilisation de la palette de couleurs dans le graphique

# donnees <- donnees[which(donnees$NomFichier %in% c("Gauging stations-Measured",
#                                                    "Ground truth",
#                                                    "ORCHIDEE-Safran")),]
# donnees <- donnees[which(donnees$NomFichier %in% c("Gauging stations-Measured",
#                                                    "Ground truth",
#                                                    "SMASH-Safran")),]
# donnees <- donnees[which(donnees$NomFichier %in% c("Gauging stations-Measured",
#                                                    "Ground truth",
#                                                    "J2000-Safran")),]
# donnees <- donnees[which(donnees$NomFichier %in% c("Gauging stations-Measured",
#                                                    "Ground truth",
#                                                    "CTRIP-Safran")),]
donnees <- donnees[which(donnees$NomFichier %in% c("Gauging stations-Measured",
                                                   "Ground truth",
                                                   "GRSD-Safran")),]

# png("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/23_ObservesReanalyseSafran_DriasEau_20231002/DebitsComplets_DebitsParModelesHydro_FichierComplet/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Chroniques/Chroniques_AllPoints_105_Orchidee_2019_1_20231121.png",
# png("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/23_ObservesReanalyseSafran_DriasEau_20231002/DebitsComplets_DebitsParModelesHydro_FichierComplet/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Chroniques/Chroniques_AllPoints_105_Smash_2019_1_20231121.png",
# png("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/23_ObservesReanalyseSafran_DriasEau_20231002/DebitsComplets_DebitsParModelesHydro_FichierComplet/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Chroniques/Chroniques_AllPoints_105_J2000_2019_1_20231121.png",
# png("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/23_ObservesReanalyseSafran_DriasEau_20231002/DebitsComplets_DebitsParModelesHydro_FichierComplet/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Chroniques/Chroniques_AllPoints_105_CTRIP_2019_1_20231121.png",
# png("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/23_ObservesReanalyseSafran_DriasEau_20231002/DebitsComplets_DebitsParModelesHydro_FichierComplet/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Chroniques/Chroniques_AllPoints_105_GRSD_2017_1_20231121.png",
# png("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/23_ObservesReanalyseSafran_DriasEau_20231002/DebitsComplets_DebitsParModelesHydro_FichierComplet/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Chroniques/Chroniques_AllPoints_97_Orchidee_2019_1_20231121.png",
# png("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/23_ObservesReanalyseSafran_DriasEau_20231002/DebitsComplets_DebitsParModelesHydro_FichierComplet/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Chroniques/Chroniques_AllPoints_97_Smash_2019_1_20231121.png",
# png("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/23_ObservesReanalyseSafran_DriasEau_20231002/DebitsComplets_DebitsParModelesHydro_FichierComplet/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Chroniques/Chroniques_AllPoints_97_J2000_2019_1_20231121.png",
# png("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/23_ObservesReanalyseSafran_DriasEau_20231002/DebitsComplets_DebitsParModelesHydro_FichierComplet/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Chroniques/Chroniques_AllPoints_97_CTRIP_2019_1_20231121.png",
png("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/23_ObservesReanalyseSafran_DriasEau_20231002/DebitsComplets_DebitsParModelesHydro_FichierComplet/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Chroniques/Chroniques_AllPoints_97_GRSD_2017_1_20231121.png",
    # png("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/23_ObservesReanalyseSafran_DriasEau_20231002/DebitsComplets_DebitsParModelesHydro_FichierComplet/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Chroniques/Chroniques_AllPoints_25_Orchidee_2019_1_20231121.png",
    # png("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/23_ObservesReanalyseSafran_DriasEau_20231002/DebitsComplets_DebitsParModelesHydro_FichierComplet/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Chroniques/Chroniques_AllPoints_25_Smash_2019_1_20231121.png",
    # png("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/23_ObservesReanalyseSafran_DriasEau_20231002/DebitsComplets_DebitsParModelesHydro_FichierComplet/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Chroniques/Chroniques_AllPoints_25_J2000_2019_1_20231121.png",
    # png("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/23_ObservesReanalyseSafran_DriasEau_20231002/DebitsComplets_DebitsParModelesHydro_FichierComplet/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Chroniques/Chroniques_AllPoints_25_CTRIP_2019_1_20231121.png",
    # png("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/23_ObservesReanalyseSafran_DriasEau_20231002/DebitsComplets_DebitsParModelesHydro_FichierComplet/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Chroniques/Chroniques_AllPoints_25_GRSD_2019_1_20231121.png",
    width = 1200, height = 750,
    units = "px", pointsize = 12)
p <- ggplot(donnees, aes(x = Date)) +
  geom_vline(xintercept = as.Date(donnees_simple$Date), linetype = "longdash", color = "#EAEAEA") + # Ajouter les lignes verticales
  # geom_line(aes(y = ProbaAssec_HERMoisAnnee_Predite_CValid, color = NomFichier, size = Size)) +
  geom_point(aes(y = ProbaAssec_HERMoisAnnee_Predite_CValid, color = NomFichier), size = 5) +
  labs(x = "Date", y = "Probabilities of drying") +
  scale_color_manual(name = "Flows", values = mes_couleurs) + # Utilisation de la palette de couleurs définie
  theme_minimal() +
  theme(legend.title = element_blank(),
        text = element_text(size = 20)) +  # Modifier la taille de tous les textes dans le graphique) +
  scale_linetype_manual(values = c("continuous" = "solid", "dashed" = "dashed"), guide = "none") +
  scale_size(range = c(0.8, 1.2)) # Ajuster la taille des lignes si nécessaire
print(p)
dev.off()


donnees_simple = donnees[which(donnees$NomFichier %in% c("Ground truth","Gauging stations-Measured")),]


# Utilisation de la palette de couleurs dans le graphique
png("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/23_ObservesReanalyseSafran_DriasEau_20231002/DebitsComplets_DebitsParModelesHydro_FichierComplet/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Chroniques/Chroniques_RefObs_1_20231121.png",
    width = 1200, height = 750,
    units = "px", pointsize = 12)
p <- ggplot(donnees_simple, aes(x = Date)) +
  # geom_line(aes(y = ProbaAssec_HERMoisAnnee_Predite_CValid, color = NomFichier, linetype = TypeLigne, size = Size)) +
  geom_vline(xintercept = as.Date(donnees_simple$Date), linetype = "longdash", color = "#EAEAEA") + # Ajouter les lignes verticales
  geom_point(aes(y = ProbaAssec_HERMoisAnnee_Predite_CValid, color = NomFichier), size = 5) +
  labs(x = "Date", y = "Probabilities of drying",
       color = c("Predictions\nfrom obs","Dry Probability")) +
  scale_color_manual(name = "Flows",values = mes_couleurs) + # Utilisation de la palette de couleurs définie
  theme_minimal() +
  theme(legend.title = element_blank(),
        text = element_text(size = 20)) +  # Modifier la taille de tous les textes dans le graphique) +
  scale_linetype_manual(values = c("continuous" = "solid", "dashed" = "dashed"), guide = "none") +
  scale_size(range = c(0.8, 1.2)) # Ajuster la taille des lignes si nécessaire
print(p)
dev.off()





ggplot(donnees, aes(x = Date)) +
  geom_line(aes(y = ProbaAssec_HERMoisAnnee_Predite_CValid, color = NomFichier, linetype = TypeLigne, size = Size)) +
  geom_vline(xintercept = as.Date(donnees_simple$Date), linetype = "longdash", color = "#EAEAEA") + # Ajouter les lignes verticales
  geom_point(aes(y = ProbaAssec_HERMoisAnnee_Predite_CValid, color = NomFichier), size = 5) +
  labs(x = "Date", y = "Probabilities") +
  scale_color_manual(values = mes_couleurs) + # Utilisation de la palette de couleurs définie
  theme_minimal() +
  theme(legend.title = element_blank()) +
  scale_linetype_manual(values = c("continuous" = "solid", "dashed" = "dashed"), guide = "none") +
  scale_size(range = c(0.8, 1.2)) # Ajuster la taille des lignes si nécessaire









dates <- seq(as.Date("2012-01-01"), as.Date("2022-12-31"), by = "month")
donnees_simple <- data.frame(Date = dates, 
                             ProbaAssec_HERMoisAnnee_Predite_CValid = runif(length(dates)),
                             NomFichier = sample(c("A", "B"), length(dates), replace = TRUE))

# Création d'une palette de couleurs avec des valeurs RGB données (à titre d'exemple)
mes_couleurs <- c("#082158", "#2498C0")

ggplot(donnees_simple, aes(x = Date)) +
  geom_vline(xintercept = as.Date(paste0(c("2012", rep(2013:2021, each = 12), "2022"), "-05-01")), 
             linetype = "longdash", color = "#EAEAEA") + # Ajouter les lignes verticales avec un gris plus clair
  geom_point(aes(y = ProbaAssec_HERMoisAnnee_Predite_CValid, color = NomFichier), size = 5) +
  labs(x = "Date", y = "Probabilities") +
  scale_color_manual(values = mes_couleurs) +
  theme_minimal() +
  theme(legend.title = element_blank()) +
  scale_x_date(date_breaks = "1 month", date_labels = "%m/%y", 
               limits = as.Date(c("2012-05-01", "2022-09-30")))





dates <- seq(as.Date("2012-01-01"), as.Date("2022-12-31"), by = "month")
donnees_simple <- data.frame(Date = dates, 
                             ProbaAssec_HERMoisAnnee_Predite_CValid = runif(length(dates)),
                             NomFichier = sample(c("A", "B"), length(dates), replace = TRUE))

# Création d'une palette de couleurs avec des valeurs RGB données (à titre d'exemple)
mes_couleurs <- c("#082158", "#2498C0")

ggplot(donnees_simple, aes(x = Date)) +
  geom_vline(xintercept = as.Date(paste0(c("2012", rep(2013:2021, each = 12), "2022"), "-05-01")), 
             linetype = "longdash", color = "#EAEAEA") + # Ajouter les lignes verticales avec un gris plus clair
  geom_point(aes(y = ProbaAssec_HERMoisAnnee_Predite_CValid, color = NomFichier), size = 5) +
  labs(x = "Date", y = "Probabilities") +
  scale_color_manual(values = mes_couleurs) +
  theme_minimal() +
  theme(legend.title = element_blank(),
        axis.text.x = element_text(hjust = 0.5, vjust = 0.5, size = 8, 
                                   label = label_wrap(breaks = scales::date_breaks("2 years"), width = 10))) +
  scale_x_date(date_breaks = "2 years", date_labels = "%m/%y", 
               limits = as.Date(c("2012-05-01", "2022-09-30")))








ggplot(donnees, aes(x = Date)) +
  geom_line(aes(y = ProbaAssec_HERMoisAnnee_Predite_CValid, color = NomFichier, linetype = TypeLigne, size = Size)) +
  labs(x = "Date", y = "Probabilities") +
  theme_minimal() +
  theme(legend.title = element_blank()) +
  scale_linetype_manual(values = c("continuous" = "solid", "dashed" = "dashed"), guide = "none") +
  scale_size(range = c(0.8, 1.2)) # Ajuster la taille des lignes si nécessaire


ggplot(donnees, aes(x = Date)) +
  geom_line(aes(y = ProbaAssec_HERMoisAnnee_Predite_CValid, color = NomFichier, linetype = TypeLigne, size = Size)) +
  labs(x = "Date", y = "Probabilities") +
  theme_minimal() +
  theme(legend.title = element_blank()) +
  scale_linetype_manual(values = c("continuous", "dashed"), guide = FALSE) +
  scale_size(range = c(0.1, 2)) # Ajuster la taille des lignes si nécessaire

# Créer le graphique
ggplot(donnees, aes(x = Date)) +
  # geom_point(aes(y = ProbaAssec_HERMoisAnnee_Apredire_CValid, color = "ProbaAssec_HERMoisAnnee_Apredire_CValid"), size = 2) +
  geom_line(aes(y = ProbaAssec_HERMoisAnnee_Predite_CValid, color = NomFichier, size = Size)) +
  # scale_color_manual(values = c("orange", "blue", "green"), labels = c("Observes" = "Observes", "ORCHIDEE" = "ORCHIDEE", "SMASH" = "SMASH")) +
  labs(x = "Date", y = "Probabilities") +
  theme_minimal() +
  theme(legend.title = element_blank())

ggplot(donnees, aes(x = Date)) +
  geom_line(aes(y = ProbaAssec_HERMoisAnnee_Predite_CValid, color = NomFichier, size = Size)) +
  labs(x = "Date", y = "Probabilities") +
  theme_minimal() +
  theme(legend.title = element_blank()) +
  scale_size(range = c(0.5, 2)) # Ajustez la plage d'épaisseur selon votre préférence





# Tracer le graphe
x11()
ggplot(donnees, aes(x = Date)) +
  geom_point(aes(y = ProbaAssec_HERMoisAnnee_Apredire_CValid), color = "orange") +
  geom_point(aes(y = ProbaAssec_HERMoisAnnee_Predite_CValid), color = "grey") +
  labs(x = "Date", y = "Valeurs de ProbaAssec") +
  theme_minimal()



