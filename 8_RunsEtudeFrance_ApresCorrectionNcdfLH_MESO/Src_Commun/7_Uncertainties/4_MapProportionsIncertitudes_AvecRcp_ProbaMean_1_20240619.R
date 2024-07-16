source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_25_NewColors_Svg_20240301.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_32_Surligner_NewColors_Svg_20240617.R")
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


# table_globale <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240619/TableProportionsIncertitudes_20702099_1_20240619.csv",
table_globale <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240619/TableProportionsIncertitudes_20702099_Rcp264585_1_20240621.csv",
                            sep = ";", dec = ".", header = T)
table_globale[,c(2:ncol(table_globale))] <- table_globale[,c(2:ncol(table_globale))]*100


### Jonction HER ###
table_globale$HER[which(table_globale$HER == 37054)] = "37+54"
table_globale$HER[which(table_globale$HER == 69096)] = "69+96"
table_globale$HER[which(table_globale$HER == 31033039)] = "31+33+39"
table_globale$HER[which(table_globale$HER == 89092)] = "89+92"
table_globale$HER[which(table_globale$HER == 49090)] = "49+90"

pattern_ <- "20702099"
breaks_ProbaAssecMoyenne_param <- c(0,2.5,5,10,15,20,30,50)

### GCM ###
title_ = paste0("GCM variability")
subtitle_ = paste0("Période : Juillet-Octobre ",
                   substr(pattern_,1,4),
                   "-",
                   substr(pattern_,5,8),
                   "\nModèle hydrologique ",
                   str_before_first(nom_categorieSimu_,"_"))
# output_name_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240619/MapIncertitude_GCM_1_20240619"
output_name_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/MapIncertitude_GCM_1_20240619"
breaks_ProbaAssecMoyenne = breaks_ProbaAssecMoyenne_param
plot_map_variable(tab_ = table_globale,
                  varname_ = "GCM",
                  vartitle_ = "GCM\nvariability (%)",
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
                                 varname_ = "GCM",
                                 vartitle_ = "Proportion of\nthe variability (%)              ",
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


### RCM ###
title_ = paste0("RCM variability")
subtitle_ = paste0("Période : Juillet-Octobre ",
                   substr(pattern_,1,4),
                   "-",
                   substr(pattern_,5,8),
                   "\nModèle hydrologique ",
                   str_before_first(nom_categorieSimu_,"_"))
# output_name_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240619/MapIncertitude_RCM_1_20240619"
output_name_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/MapIncertitude_RCM_1_20240619"
breaks_ProbaAssecMoyenne = breaks_ProbaAssecMoyenne_param
plot_map_variable(tab_ = table_globale,
                  varname_ = "RCM",
                  vartitle_ = "RCM\nvariability (%)",
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
                                 varname_ = "RCM",
                                 vartitle_ = "RCM\nvariability (%)",
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

### HM ###
title_ = paste0("HM variability")
subtitle_ = paste0("Période : Juillet-Octobre ",
                   substr(pattern_,1,4),
                   "-",
                   substr(pattern_,5,8),
                   "\nModèle hydrologique ",
                   str_before_first(nom_categorieSimu_,"_"))
# output_name_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240619/MapIncertitude_HM_1_20240619"
output_name_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/MapIncertitude_HM_1_20240619"
breaks_ProbaAssecMoyenne = breaks_ProbaAssecMoyenne_param
plot_map_variable(tab_ = table_globale,
                  varname_ = "HM",
                  vartitle_ = "HM\nvariability (%)",
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
                                 varname_ = "HM",
                                 vartitle_ = "HM\nvariability (%)",
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


### RCP ###
title_ = paste0("RCP variability")
subtitle_ = paste0("Période : Juillet-Octobre ",
                   substr(pattern_,1,4),
                   "-",
                   substr(pattern_,5,8),
                   "\nModèle hydrologique ",
                   str_before_first(nom_categorieSimu_,"_"))
# output_name_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240619/MapIncertitude_RCP_1_20240619"
output_name_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/MapIncertitude_RCP_1_20240619"
breaks_ProbaAssecMoyenne = breaks_ProbaAssecMoyenne_param
plot_map_variable(tab_ = table_globale,
                  varname_ = "RCP",
                  vartitle_ = "RCP\nvariability (%)",
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
                                 varname_ = "RCP",
                                 vartitle_ = "RCP\nvariability (%)",
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



### ResidualVar ###
title_ = paste0("Residual variability")
subtitle_ = paste0("Période : Juillet-Octobre ",
                   substr(pattern_,1,4),
                   "-",
                   substr(pattern_,5,8),
                   "\nModèle hydrologique ",
                   str_before_first(nom_categorieSimu_,"_"))
# output_name_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240619/MapIncertitude_ResidualVar_1_20240619"
output_name_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/MapIncertitude_ResidualVar_1_20240619"
breaks_ProbaAssecMoyenne = breaks_ProbaAssecMoyenne_param
plot_map_variable(tab_ = table_globale,
                  varname_ = "ResidualVar",
                  vartitle_ = "Residual\nvariability (%)",
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
                                 varname_ = "ResidualVar",
                                 vartitle_ = "Residual\nvariability (%)",
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


### InternalVar ###
title_ = paste0("Internal variability")
subtitle_ = paste0("Période : Juillet-Octobre ",
                   substr(pattern_,1,4),
                   "-",
                   substr(pattern_,5,8),
                   "\nModèle hydrologique ",
                   str_before_first(nom_categorieSimu_,"_"))
# output_name_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240619/MapIncertitude_InternalVar_1_20240619"
output_name_ <- "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240703/MapIncertitude_InternalVar_1_20240619"
breaks_ProbaAssecMoyenne = breaks_ProbaAssecMoyenne_param
plot_map_variable(tab_ = table_globale,
                  varname_ = "InternalVar",
                  vartitle_ = "Internal\nvariability (%)",
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
                                 varname_ = "InternalVar",
                                 vartitle_ = "Internal\nvariability (%)",
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

