source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_18_SaveRds_ChoseDensityMin_Pdf_20231211.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")

library(tidyverse)
library(ggplot2)

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
folder_input_ = folder_input_param_

# nom_apprentissage_ = "ApprentissageGlobalModelesBruts"
# nom_validation_ = "Validation_1ModelesBruts"

list_files_chroniquesProba_ <- list.files(paste0(folder_input_,"Tab_ChroniquesProba_LearnBrut_ByHer/",
                                                 ifelse(obsSim_param_=="",nom_GCM_param_,
                                                        paste0("FDC_",obsSim_param_,
                                                               ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                               ifelse(nom_categorieSimu_param_=="","",str_before_first(nom_categorieSimu_param_,"/")),"/"))),
                                          recursive = T,
                                          full.names = T)

list_files_chroniquesProba_ <- list_files_chroniquesProba_[grepl("rcp85/*ModA",list_files_chroniquesProba_)]

HER_h_ = 2
tab_allModels_ = data.frame()

for (l in 1:length(list_files_chroniquesProba_)){
# for (l in 1:5){
  tab_l_ <- read.table(list_files_chroniquesProba_[l], sep = ";", dec = ".", header = T)
  colnames(tab_l_) <- gsub("X","",colnames(tab_l_))
  tab_l_ <- tab_l_[,c("Date","Type",HER_h_)]
  colnames(tab_l_) <- c("Date","Type",str_after_last(str_before_last(list_files_chroniquesProba_[l],"/"),"/"))
  
  if (ncol(tab_allModels_) == 0){
    tab_allModels_ <- tab_l_
  }else{
    tab_allModels_ <- merge(tab_allModels_, tab_l_, by = c("Date","Type"))
  }
}

tab_allModels_$Date <- as.Date(tab_allModels_$Date)
tab_allModels_$Jour_annee <- format(tab_allModels_$Date, format = "%m-%d")

tab_allModels_2070_2100_ = tab_allModels_[which(year(tab_allModels_$Date) >= 2070),]









# Melt (convertir) le dataframe pour le rendre plus facile à utiliser dans ggplot2
df_melted <- tab_allModels_2070_2100_ %>%
  select(-Jour_annee) %>%
  pivot_longer(cols = -c(Date, Type), names_to = "Variable", values_to = "Value")

# Calculer la moyenne par jour de l'année
df_mean <- df_melted %>%
  mutate(Jour_annee = format(Date, "%m-%d")) %>%
  group_by(Type, Variable, Jour_annee) %>%
  summarise(Mean_Value = mean(Value))

df_mean <- df_mean %>%
  mutate(Color = case_when(
    grepl("CNRM-CERFACS.*CNRM-ALADIN63_v3_LSCE-IPSL_CDFt", Variable) ~ "#bdbdbd",
    grepl("CNRM-CERFACS.*CNRM-ALADIN63_v3_MF-ADAMONT", Variable) ~ "#E5E840",
    grepl("CNRM-CERFACS.*MOHC-HadREM3-GA7-05_v3_LSCE-IPSL_CDFt", Variable) ~ "#bdbdbd",
    grepl("CNRM-CERFACS.*MOHC-HadREM3-GA7-05_v3_MF-ADAMONT", Variable) ~ "#bdbdbd",
    grepl("ICHEC-EC-EARTH.*KNMI-RACMO22E_v2_LSCE-IPSL_CDFt", Variable) ~ "#bdbdbd",
    grepl("ICHEC-EC-EARTH.*KNMI-RACMO22E_v2_MF-ADAMONT", Variable) ~ "#bdbdbd",
    grepl("ICHEC-EC-EARTH.*MOHC-HadREM3-GA7-05_v2_LSCE-IPSL_CDFt", Variable) ~ "#bdbdbd",
    grepl("ICHEC-EC-EARTH.*MOHC-HadREM3-GA7-05_v2_MF-ADAMONT", Variable) ~ "#E2A138",
    grepl("ICHEC-EC-EARTH.*SMHI-RCA4_v2_LSCE-IPSL_CDFt", Variable) ~ "#bdbdbd",
    grepl("ICHEC-EC-EARTH.*SMHI-RCA4_v2_MF-ADAMONT", Variable) ~ "#bdbdbd",
    grepl("IPSL-IPSL-CM5A-MR.*DMI-HIRHAM5_v2_LSCE-IPSL_CDFt", Variable) ~ "#bdbdbd",
    grepl("IPSL-IPSL-CM5A-MR.*DMI-HIRHAM5_v2_MF-ADAMONT", Variable) ~ "#bdbdbd",
    grepl("IPSL-IPSL-CM5A-MR.*SMHI-RCA4_v2_LSCE-IPSL_CDFt", Variable) ~ "#bdbdbd",
    grepl("IPSL-IPSL-CM5A-MR.*SMHI-RCA4_v2_MF-ADAMONT", Variable) ~ "#bdbdbd",
    grepl("MOHC-HadGEM2-ES.*CLMcom-CCLM4-8-17_v2_LSCE-IPSL_CDFt", Variable) ~ "#bdbdbd",
    grepl("MOHC-HadGEM2-ES.*CLMcom-CCLM4-8-17_v2_MF-ADAMONT", Variable) ~ "#70194E",
    grepl("MOHC-HadGEM2-ES.*CNRM-ALADIN63_v2_LSCE-IPSL_CDFt", Variable) ~ "#bdbdbd",
    grepl("MOHC-HadGEM2-ES.*CNRM-ALADIN63_v2_MF-ADAMONT", Variable) ~ "#447C57",
    grepl("MOHC-HadGEM2-ES.*ICTP-RegCM4-6_v2_LSCE-IPSL_CDFt", Variable) ~ "#bdbdbd",
    grepl("MOHC-HadGEM2-ES.*ICTP-RegCM4-6_v2_MF-ADAMONT", Variable) ~ "#bdbdbd",
    grepl("MOHC-HadGEM2-ES.*MOHC-HadREM3-GA7-05_v2_LSCE-IPSL_CDFt", Variable) ~ "#bdbdbd",
    grepl("MOHC-HadGEM2-ES.*MOHC-HadREM3-GA7-05_v2_MF-ADAMONT", Variable) ~ "#bdbdbd",
    grepl("MPI-M-MPI-ESM-LR.*CLMcom-CCLM4-8-17_v2_LSCE-IPSL_CDFt", Variable) ~ "#bdbdbd",
    grepl("MPI-M-MPI-ESM-LR.*CLMcom-CCLM4-8-17_v2_MF-ADAMONT", Variable) ~ "#bdbdbd",
    grepl("MPI-M-MPI-ESM-LR.*ICTP-RegCM4-6_v2_LSCE-IPSL_CDFt", Variable) ~ "#bdbdbd",
    grepl("MPI-M-MPI-ESM-LR.*ICTP-RegCM4-6_v2_MF-ADAMONT", Variable) ~ "#bdbdbd",
    grepl("MPI-M-MPI-ESM-LR.*MPI-CSC-REMO2009_v2_LSCE-IPSL_CDFt", Variable) ~ "#bdbdbd",
    grepl("MPI-M-MPI-ESM-LR.*MPI-CSC-REMO2009_v2_MF-ADAMONT", Variable) ~ "#bdbdbd",
    grepl("NCC-NorESM1-M.*DMI-HIRHAM5_v4_LSCE-IPSL_CDFt", Variable) ~ "#bdbdbd",
    grepl("NCC-NorESM1-M.*DMI-HIRHAM5_v4_MF-ADAMONT", Variable) ~ "#bdbdbd",
    grepl("NCC-NorESM1-M.*GERICS-REMO2015_v2_LSCE-IPSL_CDFt", Variable) ~ "#bdbdbd",
    grepl("NCC-NorESM1-M.*GERICS-REMO2015_v2_MF-ADAMONT", Variable) ~ "#bdbdbd",
    grepl("NCC-NorESM1-M.*IPSL-WRF381P_v2_LSCE-IPSL_CDFt", Variable) ~ "#bdbdbd",
    grepl("NCC-NorESM1-M.*IPSL-WRF381P_v2_MF-ADAMONT", Variable) ~ "#bdbdbd"))

df_mean <- df_mean %>%
  mutate(Alpha = case_when(
    grepl("CNRM-CERFACS.*CNRM-ALADIN63_v3_LSCE-IPSL_CDFt", Variable) ~ 0.2,
    grepl("CNRM-CERFACS.*CNRM-ALADIN63_v3_MF-ADAMONT", Variable) ~ 1,
    grepl("CNRM-CERFACS.*MOHC-HadREM3-GA7-05_v3_LSCE-IPSL_CDFt", Variable) ~ 0.2,
    grepl("CNRM-CERFACS.*MOHC-HadREM3-GA7-05_v3_MF-ADAMONT", Variable) ~ 0.2,
    grepl("ICHEC-EC-EARTH.*KNMI-RACMO22E_v2_LSCE-IPSL_CDFt", Variable) ~ 0.2,
    grepl("ICHEC-EC-EARTH.*KNMI-RACMO22E_v2_MF-ADAMONT", Variable) ~ 0.2,
    grepl("ICHEC-EC-EARTH.*MOHC-HadREM3-GA7-05_v2_LSCE-IPSL_CDFt", Variable) ~ 0.2,
    grepl("ICHEC-EC-EARTH.*MOHC-HadREM3-GA7-05_v2_MF-ADAMONT", Variable) ~ 1,
    grepl("ICHEC-EC-EARTH.*SMHI-RCA4_v2_LSCE-IPSL_CDFt", Variable) ~ 0.2,
    grepl("ICHEC-EC-EARTH.*SMHI-RCA4_v2_MF-ADAMONT", Variable) ~ 0.2,
    grepl("IPSL-IPSL-CM5A-MR.*DMI-HIRHAM5_v2_LSCE-IPSL_CDFt", Variable) ~ 0.2,
    grepl("IPSL-IPSL-CM5A-MR.*DMI-HIRHAM5_v2_MF-ADAMONT", Variable) ~ 0.2,
    grepl("IPSL-IPSL-CM5A-MR.*SMHI-RCA4_v2_LSCE-IPSL_CDFt", Variable) ~ 0.2,
    grepl("IPSL-IPSL-CM5A-MR.*SMHI-RCA4_v2_MF-ADAMONT", Variable) ~ 0.2,
    grepl("MOHC-HadGEM2-ES.*CLMcom-CCLM4-8-17_v2_LSCE-IPSL_CDFt", Variable) ~ 0.2,
    grepl("MOHC-HadGEM2-ES.*CLMcom-CCLM4-8-17_v2_MF-ADAMONT", Variable) ~ 1,
    grepl("MOHC-HadGEM2-ES.*CNRM-ALADIN63_v2_LSCE-IPSL_CDFt", Variable) ~ 0.2,
    grepl("MOHC-HadGEM2-ES.*CNRM-ALADIN63_v2_MF-ADAMONT", Variable) ~ 1,
    grepl("MOHC-HadGEM2-ES.*ICTP-RegCM4-6_v2_LSCE-IPSL_CDFt", Variable) ~ 0.2,
    grepl("MOHC-HadGEM2-ES.*ICTP-RegCM4-6_v2_MF-ADAMONT", Variable) ~ 0.2,
    grepl("MOHC-HadGEM2-ES.*MOHC-HadREM3-GA7-05_v2_LSCE-IPSL_CDFt", Variable) ~ 0.2,
    grepl("MOHC-HadGEM2-ES.*MOHC-HadREM3-GA7-05_v2_MF-ADAMONT", Variable) ~ 0.2,
    grepl("MPI-M-MPI-ESM-LR.*CLMcom-CCLM4-8-17_v2_LSCE-IPSL_CDFt", Variable) ~ 0.2,
    grepl("MPI-M-MPI-ESM-LR.*CLMcom-CCLM4-8-17_v2_MF-ADAMONT", Variable) ~ 0.2,
    grepl("MPI-M-MPI-ESM-LR.*ICTP-RegCM4-6_v2_LSCE-IPSL_CDFt", Variable) ~ 0.2,
    grepl("MPI-M-MPI-ESM-LR.*ICTP-RegCM4-6_v2_MF-ADAMONT", Variable) ~ 0.2,
    grepl("MPI-M-MPI-ESM-LR.*MPI-CSC-REMO2009_v2_LSCE-IPSL_CDFt", Variable) ~ 0.2,
    grepl("MPI-M-MPI-ESM-LR.*MPI-CSC-REMO2009_v2_MF-ADAMONT", Variable) ~ 0.2,
    grepl("NCC-NorESM1-M.*DMI-HIRHAM5_v4_LSCE-IPSL_CDFt", Variable) ~ 0.2,
    grepl("NCC-NorESM1-M.*DMI-HIRHAM5_v4_MF-ADAMONT", Variable) ~ 0.2,
    grepl("NCC-NorESM1-M.*GERICS-REMO2015_v2_LSCE-IPSL_CDFt", Variable) ~ 0.2,
    grepl("NCC-NorESM1-M.*GERICS-REMO2015_v2_MF-ADAMONT", Variable) ~ 0.2,
    grepl("NCC-NorESM1-M.*IPSL-WRF381P_v2_LSCE-IPSL_CDFt", Variable) ~ 0.2,
    grepl("NCC-NorESM1-M.*IPSL-WRF381P_v2_MF-ADAMONT", Variable) ~ 0.2))

df_mean <- df_mean %>%
  mutate(Legend = case_when(
    grepl("CNRM-CERFACS.*CNRM-ALADIN63_v3_LSCE-IPSL_CDFt", Variable) ~ "",
    grepl("CNRM-CERFACS.*CNRM-ALADIN63_v3_MF-ADAMONT", Variable) ~ "Modéré en réchauffement et changement de précipitations",
    grepl("CNRM-CERFACS.*MOHC-HadREM3-GA7-05_v3_LSCE-IPSL_CDFt", Variable) ~ "",
    grepl("CNRM-CERFACS.*MOHC-HadREM3-GA7-05_v3_MF-ADAMONT", Variable) ~ "",
    grepl("ICHEC-EC-EARTH.*KNMI-RACMO22E_v2_LSCE-IPSL_CDFt", Variable) ~ "",
    grepl("ICHEC-EC-EARTH.*KNMI-RACMO22E_v2_MF-ADAMONT", Variable) ~ "",
    grepl("ICHEC-EC-EARTH.*MOHC-HadREM3-GA7-05_v2_LSCE-IPSL_CDFt", Variable) ~ "",
    grepl("ICHEC-EC-EARTH.*MOHC-HadREM3-GA7-05_v2_MF-ADAMONT", Variable) ~ "Sec toute l'année, recharge moindre en hiver",
    grepl("ICHEC-EC-EARTH.*SMHI-RCA4_v2_LSCE-IPSL_CDFt", Variable) ~ "",
    grepl("ICHEC-EC-EARTH.*SMHI-RCA4_v2_MF-ADAMONT", Variable) ~ "",
    grepl("IPSL-IPSL-CM5A-MR.*DMI-HIRHAM5_v2_LSCE-IPSL_CDFt", Variable) ~ "",
    grepl("IPSL-IPSL-CM5A-MR.*DMI-HIRHAM5_v2_MF-ADAMONT", Variable) ~ "",
    grepl("IPSL-IPSL-CM5A-MR.*SMHI-RCA4_v2_LSCE-IPSL_CDFt", Variable) ~ "",
    grepl("IPSL-IPSL-CM5A-MR.*SMHI-RCA4_v2_MF-ADAMONT", Variable) ~ "",
    grepl("MOHC-HadGEM2-ES.*CLMcom-CCLM4-8-17_v2_LSCE-IPSL_CDFt", Variable) ~ "",
    grepl("MOHC-HadGEM2-ES.*CLMcom-CCLM4-8-17_v2_MF-ADAMONT", Variable) ~ "Fort réchauffement et fort assèchement en été",
    grepl("MOHC-HadGEM2-ES.*CNRM-ALADIN63_v2_LSCE-IPSL_CDFt", Variable) ~ "",
    grepl("MOHC-HadGEM2-ES.*CNRM-ALADIN63_v2_MF-ADAMONT", Variable) ~ "Chaud et humide à toutes les saisons",
    grepl("MOHC-HadGEM2-ES.*ICTP-RegCM4-6_v2_LSCE-IPSL_CDFt", Variable) ~ "",
    grepl("MOHC-HadGEM2-ES.*ICTP-RegCM4-6_v2_MF-ADAMONT", Variable) ~ "",
    grepl("MOHC-HadGEM2-ES.*MOHC-HadREM3-GA7-05_v2_LSCE-IPSL_CDFt", Variable) ~ "",
    grepl("MOHC-HadGEM2-ES.*MOHC-HadREM3-GA7-05_v2_MF-ADAMONT", Variable) ~ "",
    grepl("MPI-M-MPI-ESM-LR.*CLMcom-CCLM4-8-17_v2_LSCE-IPSL_CDFt", Variable) ~ "",
    grepl("MPI-M-MPI-ESM-LR.*CLMcom-CCLM4-8-17_v2_MF-ADAMONT", Variable) ~ "",
    grepl("MPI-M-MPI-ESM-LR.*ICTP-RegCM4-6_v2_LSCE-IPSL_CDFt", Variable) ~ "",
    grepl("MPI-M-MPI-ESM-LR.*ICTP-RegCM4-6_v2_MF-ADAMONT", Variable) ~ "",
    grepl("MPI-M-MPI-ESM-LR.*MPI-CSC-REMO2009_v2_LSCE-IPSL_CDFt", Variable) ~ "",
    grepl("MPI-M-MPI-ESM-LR.*MPI-CSC-REMO2009_v2_MF-ADAMONT", Variable) ~ "",
    grepl("NCC-NorESM1-M.*DMI-HIRHAM5_v4_LSCE-IPSL_CDFt", Variable) ~ "",
    grepl("NCC-NorESM1-M.*DMI-HIRHAM5_v4_MF-ADAMONT", Variable) ~ "",
    grepl("NCC-NorESM1-M.*GERICS-REMO2015_v2_LSCE-IPSL_CDFt", Variable) ~ "",
    grepl("NCC-NorESM1-M.*GERICS-REMO2015_v2_MF-ADAMONT", Variable) ~ "",
    grepl("NCC-NorESM1-M.*IPSL-WRF381P_v2_LSCE-IPSL_CDFt", Variable) ~ "",
    grepl("NCC-NorESM1-M.*IPSL-WRF381P_v2_MF-ADAMONT", Variable) ~ ""))


custom_colors <- data.frame(leg_ = c(unique(df_mean$Legend[which(df_mean$Color == "#E5E840")]),
                                     unique(df_mean$Legend[which(df_mean$Color == "#E2A138")]),
                                     unique(df_mean$Legend[which(df_mean$Color == "#70194E")]),
                                     unique(df_mean$Legend[which(df_mean$Color == "#447C57")])),
                            col_ = c("#E5E840","#E2A138","#70194E","#447C57"))
desired_order <- c(unique(df_mean$Legend[which(df_mean$Color == "#E5E840")]),
                   unique(df_mean$Legend[which(df_mean$Color == "#E2A138")]),
                   unique(df_mean$Legend[which(df_mean$Color == "#70194E")]),
                   unique(df_mean$Legend[which(df_mean$Color == "#447C57")]))

df_mean$Variable <- factor(df_mean$Variable, levels = unique(df_mean$Variable))
df_mean$Color <- factor(df_mean$Color, levels = unique(df_mean$Color))
custom_color <- c("#bdbdbd","#E5E840","#bdbdbd","#bdbdbd","#bdbdbd","#bdbdbd","#bdbdbd","#E2A138","#bdbdbd","#bdbdbd","#bdbdbd","#bdbdbd","#bdbdbd","#bdbdbd","#bdbdbd","#70194E","#bdbdbd","#447C57","#bdbdbd","#bdbdbd","#bdbdbd","#bdbdbd","#bdbdbd",
                           "#bdbdbd","#bdbdbd","#bdbdbd","#bdbdbd","#bdbdbd","#bdbdbd","#bdbdbd","#bdbdbd","#bdbdbd","#bdbdbd","#bdbdbd")

### Legende ###
variables_a_afficher <- unique(df_mean$Variable[which(df_mean$Alpha == 1)])
df_mean$AfficherDansLegende <- ifelse(df_mean$Variable %in% variables_a_afficher, as.character(df_mean$Variable), "")

### Axe x ###
first_days <- df_mean[which(substr(df_mean$Jour_annee,3,5) == "-01"),]
first_days$Date <- as.Date(paste0("2022-",first_days$Jour_annee), format = "%Y-%m-%d")


# Créer le graphique en utilisant la nouvelle variable pour la légende
ggplot(df_mean, aes(x = Jour_annee, y = Mean_Value, group = Variable, color = AfficherDansLegende)) +
  geom_line() +
  scale_color_manual(values = custom_color, na.translate = FALSE,
                     labels = custom_color$Legend) +
  # geom_point(data = first_days, aes(x = Date, y = 0), size = 0, alpha = 0) +
  labs(title = "Titre du graphique",
       x = "Jour de l'année",
       y = "Mean Value") +
  theme_minimal() +
  theme(strip.text.x = element_blank(),
        strip.background = element_blank(),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+#,
  guides(color = guide_legend(override.aes = list(lwd=2.5)))
  

ggplot(df_mean, aes(x = Jour_annee, y = Mean_Value, group = Variable, color = AfficherDansLegende)) +
  geom_line() +
  scale_color_manual(values = custom_color, na.translate = FALSE) +
  labs(title = "Titre du graphique",
       x = "Jour de l'année",
       y = "Mean Value") +
  theme_minimal()

ggplot(df_mean, aes(x = Jour_annee, y = Mean_Value, group = Variable, color = Variable)) +
  geom_line() +
  scale_color_manual(values = custom_color) +
  labs(title = "Titre du graphique",
       x = "Jour de l'année",
       y = "Mean Value") +
  theme_minimal()



# Fusionner les couleurs avec le jeu de données principal
# df_mean <- left_join(df_mean, modele_colors, by = "Variable")

# Tracer le ggplot avec les couleurs spécifiées
ggplot(df_mean, aes(x = as.Date(Jour_annee, format = "%m-%d"), y = Mean_Value, group = Variable, color = Color, alpha = Alpha)) +
  geom_line() +
  scale_color_manual(values = df_mean$Color) +
  facet_wrap(~Type, scales = "free_y") +
  labs(title = "Moyenne des valeurs par jour de l'année (2070-2100)",
       x = "Date",
       y = "Moyenne des valeurs") +
  theme_minimal()

# # Tracer le ggplot avec les couleurs spécifiées
# ggplot(df_mean, aes(x = as.Date(Jour_annee, format = "%m-%d"), y = Mean_Value, color = Color)) +
#   geom_line() +
#   facet_wrap(~Type, scales = "free_y") +
#   labs(title = "Moyenne des valeurs par jour de l'année (2070-2100)",
#        x = "Date",
#        y = "Moyenne des valeurs") +
#   theme_minimal()


# tab_allModels_$Date <- as.Date(tab_allModels_$Date)
# tab_allModels_$Jour_annee <- format(tab_allModels_$Date, format = "%m-%d")
# proba_CERFACS_ALADIN63_saf_rcp85_Safran20122019 <- tab_allModels_ %>%
#   group_by(Jour_annee) %>%
#   summarize(Proba_moyen = mean(Proba, na.rm = TRUE),
#             Proba_median = median(Proba, na.rm = TRUE),
#             Proba_Q5 = quantile(Proba, probs = 0.05, na.rm = TRUE),
#             Proba_Q95 = quantile(Proba, probs = 0.95, na.rm = TRUE))



# HadGEM CCLM Adamont : #70194E
# EC Earth HadREM3 Adamont #E2A138
# CNRM CM5 Aladin Adamont #E5E840
# HadGEM2 Aladin Adamont #447C57

# Tracer le ggplot
x11()
ggplot(df_mean, aes(x = as.Date(Jour_annee, format = "%m-%d"), y = Mean_Value, color = Variable)) +
  geom_line() +
  facet_wrap(~Type, scales = "free_y") +
  labs(title = "Moyenne des valeurs par jour de l'année (2070-2100)",
       x = "Date",
       y = "Moyenne des valeurs") +
  theme_minimal()


unique(df_mean$Variable)


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
tab_results_$HER[which(tab_results_$HER == 89092)] = "89+92"
tab_results_$HER[which(tab_results_$HER == 49090)] = "49+90"





source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")



HER_ = HER_param_
folder_output_ = folder_output_param_
nomSim_ = nomSim_param_
obsSim_ = obsSim_param_
nom_categorieSimu_ = nom_categorieSimu_param_
nom_GCM_ = nom_GCM_param_
nom_apprentissage_ = nom_apprentissage_param_
folder_input_ = folder_input_param_
nom_FDCfolder_ = nom_FDCfolder_param_

date_min_past = "1976-01-01"
date_max_past = "2005-12-31"
date_min_fut = "2070-01-01"
date_max_fut = "2100-12-31"

data.frame(type = c("Obs","Safran","Hist","rcp85"),
           data_min = c(date_min_past))


### Projections ###
list_HM_saf_hist_rcp85_ = list.files(paste0(folder_input_DD_param_,"Tab_ChroniquesProba_LearnBrut_ByHer/",
                                            ifelse(obsSim_=="",nom_GCM_,
                                                   paste0("FDC_",obsSim_,
                                                          ifelse(nom_FDCfolder_=="","",paste0("_",nom_FDCfolder_)),"/",
                                                          ifelse(nom_categorieSimu_=="","",str_before_first(nom_categorieSimu_,"/")),"/Mod_ChroniquesCombinees_saf_hist_rcp85/"))), recursive = T, full.names = T)
list_HM_saf_rcp85_ = list.files(paste0(folder_input_DD_param_,"Tab_ChroniquesProba_LearnBrut_ByHer/",
                                       ifelse(obsSim_=="",nom_GCM_,
                                              paste0("FDC_",obsSim_,
                                                     ifelse(nom_FDCfolder_=="","",paste0("_",nom_FDCfolder_)),"/",
                                                     ifelse(nom_categorieSimu_=="","",str_before_first(nom_categorieSimu_,"/")),"/Mod_ChroniquesCombinees_saf_rcp85/"))), recursive = T, full.names = T)


list_modelsRL_ = c(list_HM_saf_hist_rcp85_, list_HM_saf_rcp85_)
dat_modelsRL_ = data.frame(liste_fichiers = list_modelsRL_,
                           model = c("Mod_CERFACS_ALADIN63_saf_hist_rcp85",
                                     "Mod_ECEARTH_HadREM3_saf_hist_rcp85",
                                     "Mod_HadGEM2_CCLM4_saf_hist_rcp85",
                                     "Mod_HadGEM2_ALADIN63_saf_hist_rcp85",
                                     "Mod_CERFACS_ALADIN63_saf_rcp85",
                                     "Mod_ECEARTH_HadREM3_saf_rcp85",
                                     "Mod_HadGEM2_CCLM4_saf_rcp85",
                                     "Mod_HadGEM2_ALADIN63_saf_rcp85"),
                           names_ = c("Mod_CERFACS_ALADIN63_saf_hist_rcp85__Data_CERFACS_ALADIN63",
                                      "Mod_ECEARTH_HadREM3_saf_hist_rcp85__Data_ECEARTH_HadREM3",
                                      "Mod_HadGEM2_CCLM4_saf_hist_rcp85__Data_HadGEM2_CCLM4",
                                      "Mod_HadGEM2_ALADIN63_saf_hist_rcp85__Data_HadGEM2_ALADIN63",
                                      "Mod_CERFACS_ALADIN63_saf_rcp85__Data_CERFACS_ALADIN63",
                                      "Mod_ECEARTH_HadREM3_saf_rcp85__Data_ECEARTH_HadREM3",
                                      "Mod_HadGEM2_CCLM4_saf_rcp85__Data_HadGEM2_CCLM4",
                                      "Mod_HadGEM2_ALADIN63_saf_rcp85__Data_HadGEM2_ALADIN63"))#,

model_ = dat_modelsRL_$liste_fichiers[which(grepl(str_after_first(nom_categorieSimu_,"/"), dat_modelsRL_$liste_fichiers) &
                                              grepl(nom_GCM_, dat_modelsRL_$liste_fichiers))]
tab_ = read.table(model_, sep=";", header = T)
colnames(tab_) <- sub("^X", "", colnames(tab_))

tab_saf_19752005 = tab_[which(tab_$Type == "Safran" & tab_$Date >= date_min_past & tab_$Date <= date_max_past),]
tab_hist_19752005 = tab_[which(tab_$Type == "Historical" & tab_$Date >= date_min_past & tab_$Date <= date_max_past),]
tab_rcp_20702100 = tab_[which(tab_$Type == "rcp85" & tab_$Date >= date_min_fut & tab_$Date <= date_max_fut),]

tab_rcp26_20702100 = NULL
tab_rcp45_20702100 = NULL

### Delimiter chroniques ###
for (HER_h_ in HER_){
  
  print(HER_h_)

  if (HER_h_ %in% colnames(tab_)){
    
    tab_input_h_ = tab_input_[which(tab_input_$HER2 == HER_h_),]  ### Attention, tab_input va de 2012 à 2022

    # Calculer la moyenne pour chaque mois
    moyennes_mois <- tab_input_h_ %>%
      group_by(Mois) %>%
      summarise(Moyenne_X_Assec = mean(X._Assec),
                Median_X_Assec = median(X._Assec))
    moyennes_mois$Date = as.Date(paste0("2022-",moyennes_mois$Mois,"-25"))
    all_dates = tab_input_h_
    all_dates$Date_2022 = as.Date(format(as.Date(all_dates$Date), "2022-%m-%d"))
    
    chro_saf_19752005 <- tab_saf_19752005[,c("Date",as.character(HER_h_))]
    chro_hist_19752005 <- tab_hist_19752005[,c("Date",as.character(HER_h_))]
    chro_rcp_20702100 <- tab_rcp_20702100[,c("Date",as.character(HER_h_))]
    
    colnames(chro_saf_19752005) = c("Date","Proba")
    colnames(chro_hist_19752005) = c("Date","Proba")
    colnames(chro_rcp_20702100) = c("Date","Proba")
    
    chro_saf_19752005$Date <- as.Date(chro_saf_19752005$Date)
    chro_saf_19752005$Jour_annee <- format(chro_saf_19752005$Date, format = "%m-%d")
    proba_saf_19752005 <- chro_saf_19752005 %>%
      group_by(Jour_annee) %>%
      summarize(Proba_moyen = mean(Proba, na.rm = TRUE),
                Proba_median = median(Proba, na.rm = TRUE),
                Proba_Q5 = quantile(Proba, probs = 0.05, na.rm = TRUE),
                Proba_Q95 = quantile(Proba, probs = 0.95, na.rm = TRUE))
    
    chro_hist_19752005$Date <- as.Date(chro_hist_19752005$Date)
    chro_hist_19752005$Jour_annee <- format(chro_hist_19752005$Date, format = "%m-%d")
    proba_hist_19752005 <- chro_hist_19752005 %>%
      group_by(Jour_annee) %>%
      summarize(Proba_moyen = mean(Proba, na.rm = TRUE),
                Proba_median = median(Proba, na.rm = TRUE),
                Proba_Q5 = quantile(Proba, probs = 0.05, na.rm = TRUE),
                Proba_Q95 = quantile(Proba, probs = 0.95, na.rm = TRUE))
    
    chro_rcp_20702100$Date <- as.Date(chro_rcp_20702100$Date)
    chro_rcp_20702100$Jour_annee <- format(chro_rcp_20702100$Date, format = "%m-%d")
    proba_rcp_20702100 <- chro_rcp_20702100 %>%
      group_by(Jour_annee) %>%
      summarize(Proba_moyen = mean(Proba, na.rm = TRUE),
                Proba_median = median(Proba, na.rm = TRUE),
                Proba_Q5 = quantile(Proba, probs = 0.05, na.rm = TRUE),
                Proba_Q95 = quantile(Proba, probs = 0.95, na.rm = TRUE))
    
    # Ajouter une colonne "Période" à chaque table
    proba_saf_19752005$Periode <- paste0("Safran_19702005")
    proba_hist_19752005$Periode <- paste0("Hist_19702005")
    proba_rcp_20702100$Periode <- paste0("Rcp85_20702100")

    # Fusionner les trois tables en une seule
    combined_data <- rbind(proba_saf_19752005,
                           proba_hist_19752005,
                           proba_rcp_20702100)
    
    if (!is.null(tab_rcp26_20702100)){
      chro_rcp26_20702100 <- tab_rcp26_20702100[,c("Date",as.character(HER_h_))]
      colnames(chro_rcp26_20702100) = c("Date","Proba")
      chro_rcp26_20702100$Date <- as.Date(chro_rcp26_20702100$Date)
      chro_rcp26_20702100$Jour_annee <- format(chro_rcp26_20702100$Date, format = "%m-%d")
      proba_rcp26_20702100 <- chro_rcp26_20702100 %>%
        group_by(Jour_annee) %>%
        summarize(Proba_moyen = mean(Proba, na.rm = TRUE),
                  Proba_median = median(Proba, na.rm = TRUE),
                  Proba_Q5 = quantile(Proba, probs = 0.05, na.rm = TRUE),
                  Proba_Q95 = quantile(Proba, probs = 0.95, na.rm = TRUE))
      proba_rcp26_20702100$Periode <- paste0("Rcp26_20702100")
      combined_data <- rbind(combined_data,
                             proba_rcp26_20702100)
    }
    if (!is.null(tab_rcp45_20702100)){
      chro_rcp45_20702100 <- tab_rcp45_20702100[,c("Date",as.character(HER_h_))]
      colnames(chro_rcp45_20702100) = c("Date","Proba")
      chro_rcp45_20702100$Date <- as.Date(chro_rcp45_20702100$Date)
      chro_rcp45_20702100$Jour_annee <- format(chro_rcp45_20702100$Date, format = "%m-%d")
      proba_rcp45_20702100 <- chro_rcp45_20702100 %>%
        group_by(Jour_annee) %>%
        summarize(Proba_moyen = mean(Proba, na.rm = TRUE),
                  Proba_median = median(Proba, na.rm = TRUE),
                  Proba_Q5 = quantile(Proba, probs = 0.05, na.rm = TRUE),
                  Proba_Q95 = quantile(Proba, probs = 0.95, na.rm = TRUE))
      proba_rcp45_20702100$Periode <- paste0("Rcp45_20702100")
      combined_data <- rbind(combined_data,
                             proba_rcp45_20702100)
    }
    
    
    combined_data[which(is.na(combined_data$Proba_moyen)),]

    combined_data_min_max_ <- combined_data[which(combined_data$Jour_annee %in% c("05-25","06-25","07-25","08-25","09-25")),]
    combined_data_min_max_$Date <- as.Date(paste0("2022-",combined_data_min_max_$Jour_annee))
    tab_input_h_[,c("HER2","Date","Mois","X._Assec")]
    tab_input_h_min_max_ <- tab_input_h_ %>%
      group_by(Mois) %>%
      summarize(Max_X_Assec = max(X._Assec),
                Min_X_Assec = min(X._Assec))
    tab_input_h_min_max_$Date = as.Date(paste0("2022-",tab_input_h_min_max_$Mois,"-25"))
    
    # Convertir Jour_annee au format de date en ajoutant une année fixe (par exemple, 2022)
    combined_data$Jour_annee <- as.Date(paste0("2022-", combined_data$Jour_annee), format = "%Y-%m-%d")
    
    # Création d'une colonne pour extraire le jour de chaque date
    combined_data$Jour <- as.numeric(format(combined_data$Jour_annee, "%d"))
    
    combined_data <- combined_data %>%
      group_by(Periode) %>%
      mutate(ProbaLissee = (lag(Proba_median, 2) + lag(Proba_median, 1) + Proba_median + lead(Proba_median, 1) + lead(Proba_median, 2)) / 5)
    
    # Filtrer les données pour obtenir uniquement le premier jour de chaque mois
    first_days <- combined_data %>% filter(Jour == 1)
    
    custom_colors <- c("Safran_19702005" = "#084594",
                       "Hist_19702005" = "#238443",
                       "Rcp85_20702100" = "#990000")
    desired_order <- c("Safran_19702005",
                       "Hist_19702005",
                       "Rcp85_20702100")
    labels_ <- c(paste0("Safran ",year(min(tab_saf_19752005$Date)),"/",year(max(tab_saf_19752005$Date))),
                 paste0("Historical ",year(min(tab_hist_19752005$Date)),"/",year(max(tab_hist_19752005$Date))),
                 paste0("RCP 8.5 ",year(min(tab_rcp_20702100$Date)),"/",year(max(tab_rcp_20702100$Date))))
    
    combined_data$Periode <- factor(combined_data$Periode, levels = desired_order)
    
    if (!dir.exists(paste0(folder_output_,
                           "19_GrapheChroniqueProbabilite_OneModel_AllTypesOSHR_ComparaisonMedianePeriodes/",
                           nomSim_,
                           ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                           ifelse(nom_GCM_=="","",paste0("/",nom_GCM_))))){
      dir.create(paste0(folder_output_,
                        "19_GrapheChroniqueProbabilite_OneModel_AllTypesOSHR_ComparaisonMedianePeriodes/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        ifelse(nom_GCM_=="","",paste0("/",nom_GCM_))))
    }
    if (!dir.exists(paste0(folder_output_,
                           "19_GrapheChroniqueProbabilite_OneModel_AllTypesOSHR_ComparaisonMedianePeriodes/",
                           nomSim_,
                           ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                           ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                           ifelse(nom_apprentissage_param_=="","",paste0("/",nom_apprentissage_param_))))){
      dir.create(paste0(folder_output_,
                        "19_GrapheChroniqueProbabilite_OneModel_AllTypesOSHR_ComparaisonMedianePeriodes/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                        ifelse(nom_apprentissage_param_=="","",paste0("/",nom_apprentissage_param_))))
    }
    
    
    output_name_ <- paste0(folder_output_,
                           "19_GrapheChroniqueProbabilite_OneModel_AllTypesOSHR_ComparaisonMedianePeriodes/",
                           nomSim_,
                           ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                           # ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                           ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                           ifelse(nom_apprentissage_param_=="","",paste0("/",nom_apprentissage_param_)),
                           "/ChroniquesProbaPerONDE_HER",HER_h_,"_logit.pdf")
    
    pdf(output_name_,
        width = 12)
    print(p)
    dev.off()
    
    saveRDS(p, file = paste0(str_before_first(output_name_, ".pdf"),".rds"))
    
  }
}


















### Intercept ###
if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/1_Map_Gbl_Int_Brt/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/1_Map_Gbl_Int_Brt/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
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
                       ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
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

