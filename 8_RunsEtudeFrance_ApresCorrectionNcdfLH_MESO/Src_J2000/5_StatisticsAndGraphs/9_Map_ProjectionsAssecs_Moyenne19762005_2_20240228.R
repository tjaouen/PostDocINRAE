# Chargement du package nécessaire
library(data.table)

# Création d'une liste pour stocker les résultats
resultats <- list()

# Parcours des fichiers
files <- list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/Tables/19762005/", full.names = TRUE)
# files <- list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/Tables/20202050/", full.names = TRUE)
# files <- list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/Tables/20702099/", full.names = TRUE)


vartitle_ = "Probabilité moyenne d'assec juillet-octobre 1976-2005"
# vartitle_ = "Probabilité moyenne d'assec juillet-octobre 2020-2050"
# vartitle_ = "Probabilité moyenne d'assec juillet-octobre 2070-2099"
output_name_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/Map/Map_19762005_1_20240227_"
# output_name_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/Map/Map_20202050_1_20240227_"
# output_name_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/Map/Map_20702100_1_20240227_"
title_ = paste0("Proba moyenne assec juillet-octobre 1976-2005")
# title_ = paste0("Proba moyenne assec juillet-octobre 2020-2050")
# title_ = paste0("Proba moyenne assec juillet-octobre 2070-2099")



for(file in files) {
  # Extraire le numéro HER du nom de fichier
  her <- sub('.*HER([0-9]+).*', '\\1', file)
  
  # Lire le fichier CSV
  data <- read.table(file, sep =";", dec =".", header = T)
  
  # Convertir la colonne de dates au format Date
  data$Date <- as.Date(data$Jour_annee)
  
  # Filtrer les données pour garder uniquement les dates du 1er juillet au 31 octobre
  # data <- data[format(data$Date, "%m-%d") >= "05-01" & format(data$Date, "%m-%d") <= "09-30", ]
  data <- data[format(data$Date, "%m-%d") >= "07-01" & format(data$Date, "%m-%d") <= "10-31", ]
  # data <- data[which(data$Type == "Historical"),]
  
  # Calculer la moyenne de la colonne Mean_Value
  moyenne <- mean(na.omit(data$Mean_Value))
  
  # Stocker le résultat dans la liste
  resultats[[her]] <- moyenne
}

# Convertir la liste en un data.frame
table_globale <- data.frame(HER = as.numeric(names(resultats)), Moyenne_Mean_Value = unlist(resultats))

# Afficher la table globale
print(table_globale)


source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_21_NewColors_Svg_20240228.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")


### Jonction HER ###
table_globale$HER[which(table_globale$HER == 37054)] = "37+54"
table_globale$HER[which(table_globale$HER == 69096)] = "69+96"
table_globale$HER[which(table_globale$HER == 31033039)] = "31+33+39"
table_globale$HER[which(table_globale$HER == 89092)] = "89+92"
table_globale$HER[which(table_globale$HER == 49090)] = "49+90"


# "/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProba_LearnBrut_ByHer/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_20050801-21000731/Tab_ChroniquesProba_LearnBrut_ByHer.txt"




plot_map_variable(tab_ = table_globale,
                  varname_ = "Moyenne_Mean_Value",
                  vartitle_ = vartitle_,
                  breaks_ = c(0:30),
                  output_name_ = output_name_,
                  title_ = title_,
                  nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt",
                  reverseColors_ = T,
                  reverseLegend_ = T,
                  echelleAttenuee_ = F,
                  HER2_excluesDensity_ = NULL,
                  limits_ = c(0,70))

plot_map_variable_sansEtiquettes(tab_ = table_globale,
                                 varname_ = "Moyenne_Mean_Value",
                                 vartitle_ = vartitle_,
                                 breaks_ = c(0:30),
                                 output_name_ = output_name_,
                                 title_ = title_,
                                 nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt",
                                 sansTexteHer_ = T,
                                 reverseColors_ = T,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = F,
                                 HER2_excluesDensity_ = NULL,
                                 limits_ = c(0,70))


# cols <- brewer_pal("div")(11)
# gradient_palette <- gradient_n_pal(cols)(seq(0, 1, length.out = 31))
# rgb_values <- col2rgb(gradient_palette)
# rgb_values <- t(rgb_values)
# write.table(rgb_values, "/home/tjaouen/Documents/Input/FondsCartes/IpccColors/col.txt", sep= " ", row.names = F)

