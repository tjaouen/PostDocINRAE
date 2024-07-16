source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_31_NewColors_Svg_20240319.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_Commun/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")

library(lubridate)


filename_input_ <- list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/",
                        recursive = T, include.dirs = F, full.names = T, pattern = c("CampOndeExcl",".csv"))
filename_input_ <- filename_input_[!grepl("CDFt",filename_input_)]

# Créer une liste pour stocker les dataframes
list_of_data_input_ <- list()

# Charger les fichiers CSV dans la liste
for (file_input_ in filename_input_) {
  data_input_ <- read.table(file_input_, sep = ";", dec = ".", header = T)
  data_input_ <- data_input_[which(year(data_input_$Date) == 2018 & month(data_input_$Date) == 8),]
  list_of_data_input_[[file_input_]] <- data_input_
}

# Fusionner tous les dataframes en un seul
merged_data_input_ <- bind_rows(list_of_data_input_, .id = "source_file")

# Calculer la médiane pour chaque case de la table
medians_input_ <- merged_data_input_ %>%
  group_by(HER2) %>%
  summarize(across(everything(), median))

# Afficher les médianes
print(medians_input_)

tab_results_input_ <- as.data.frame(medians_input_)

table(tab_results_input_$KGE_logit_Learn > 0.8) # 43/(43+32)
table(tab_results_input_$KGE_logit_Learn > 0.75) # 53/(53+22)

### Jonction HER ###
tab_results_input_$HER[which(tab_results_input_$HER == 37054)] = "37+54"
tab_results_input_$HER[which(tab_results_input_$HER == 69096)] = "69+96"
tab_results_input_$HER[which(tab_results_input_$HER == 31033039)] = "31+33+39"
tab_results_input_$HER[which(tab_results_input_$HER == 49090)] = "49+90"
tab_results_input_$HER[which(tab_results_input_$HER == 89092)] = "89+92"












filename_logit_ <- list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/2_ResultatsModeles_ParHer/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/",
                        recursive = T, include.dirs = F, full.names = T, pattern = c("logit",".csv"))

# Créer une liste pour stocker les dataframes
list_of_data_logit_ <- list()

# Charger les fichiers CSV dans la liste
for (file_logit_ in filename_logit_) {
  data_logit_ <- read.table(file_logit_, sep = ";", dec = ".", header = T)
  list_of_data_logit_[[file_logit_]] <- data_logit_
}

# Fusionner tous les dataframes en un seul
merged_data_logit_ <- bind_rows(list_of_data_logit_, .id = "source_file")

# Calculer la médiane pour chaque case de la table
medians_logit_ <- merged_data_logit_ %>%
  group_by(HER) %>%
  summarize(across(everything(), median))

# Afficher les médianes
print(medians_logit_)

table(medians_logit_$HER == medians_input_$HER2)

medians_input_$X._Assec_Predit <- exp(medians_logit_$Inter_logit_Learn + medians_logit_$Slope_logit_Learn * medians_input_$Freq_Jm6Jj)/(1+exp(medians_logit_$Inter_logit_Learn + medians_logit_$Slope_logit_Learn * medians_input_$Freq_Jm6Jj))*100
medians_input_$HER <- medians_input_$HER2
medians_input_ <- as.data.frame(medians_input_)

medians_input_$HER[which(medians_input_$HER == 37054)] = "37+54"
medians_input_$HER[which(medians_input_$HER == 69096)] = "69+96"
medians_input_$HER[which(medians_input_$HER == 31033039)] = "31+33+39"
medians_input_$HER[which(medians_input_$HER == 49090)] = "49+90"
medians_input_$HER[which(medians_input_$HER == 89092)] = "89+92"

medians_input_[,c("HER","X._Assec")]
breaks_ <- c(-0.1,5,10,15,20,25,30,40,50,75,100)

output_name_ <- "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/ProbaApredire_Aout2018_GRSD_Adamont_1_20240411"
plot_map_variable_sansEtiquettes(tab_ = medians_input_,
                                 varname_ = "X._Assec",
                                 # vartitle_ = "Probability of drying\nstate at a zero\nexceedance frequency (%)",
                                 vartitle_ = "Probability (%)",
                                 breaks_ = breaks_,
                                 output_name_ = output_name_,
                                 title_ = paste0("Leave One Year\nOut validation"),
                                 # nomPalette_ = "cryo_div_disc.txt",
                                 nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                 reverseColors_ = T,
                                 sansTexteHer_ = T,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = F,
                                 addValueUnder = -30,
                                 # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                 HER2_excluesDensity_ = NULL,
                                 annotation_txt_ = F,
                                 percentFormat = F,
                                 doubleLegend_ = T,
                                 borderCol = "gray40",
                                 taillePalette = length(breaks_)+7, 
                                 retenuPalette = length(breaks_))




output_name_ <- "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/ProbaPredite_Aout2018_GRSD_Adamont_1_20240411"
plot_map_variable_sansEtiquettes(tab_ = medians_input_,
                                 varname_ = "X._Assec_Predit",
                                 # vartitle_ = "Probability of drying\nstate at a zero\nexceedance frequency (%)",
                                 vartitle_ = "Probability (%)",
                                 breaks_ = breaks_,
                                 output_name_ = output_name_,
                                 title_ = paste0("Leave One Year\nOut validation"),
                                 # nomPalette_ = "cryo_div_disc.txt",
                                 nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                 reverseColors_ = T,
                                 sansTexteHer_ = T,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = F,
                                 addValueUnder = -30,
                                 # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                 HER2_excluesDensity_ = NULL,
                                 annotation_txt_ = F,
                                 percentFormat = F,
                                 doubleLegend_ = T,
                                 borderCol = "gray40",
                                 taillePalette = length(breaks_)+7, 
                                 retenuPalette = length(breaks_))
