library(ggplot2)
library(strex)
library(dplyr)
library(tidyr)

### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/9_PredictionParSiteONDE/Neural_Network/Prog_R/TristanSeul/4_Validation/1_ValidationPredictions_2_20240927.R")

folder_output_ <- folder_output_param_

# HER_ = 2
# HER_ = 58 # Equivalent 1
# HER_ = 38 # Equivalent 2
HER_ = 85 # Equivalent 3
# HER_ = 105 # Equivalent 4

list_ <- list.files(path = paste0(folder_output_, "23_PredictionParSiteONDE_PremierTest/Random_Forest/4_ResultatsLocaux_France/"),
                    pattern = paste0("Input_test_classif_HER_",HER_,"_30_jours_fin_caract_new_meteo_FINAL_AjoutProbaAssecParHER_scaled.csv"),
                    recursive = T, full.names = T)
df_ = data.frame()
for (f in list_){
  f_ <- read.table(f, sep=";", dec=".", header = T)
  colnames(f_)[grepl("ProbaAssecSafranParHER",colnames(f_))] <- "ProbaAssecSafran"
  df_ <- rbind(df_,f_)
}
dim(df_)


# Ajout de la colonne Année-Mois à partir de la date
df_$Annee_Mois <- format(as.Date(df_$Date), "%Y-%m")

# Calculer le nombre total de Prediction_bin et le nombre de 1 par couple Codes_Onde et Annee_Mois
result <- df_ %>%
  group_by(Code_Onde, Annee_Mois) %>%
  summarise(Total = n(),  # Total d'occurrences par groupe
            Prediction_bin_1 = sum(Prediction_bin == 1)) %>%  # Total de Prediction_bin égaux à 1
  ungroup()

# Ajouter une colonne pour la proportion de Prediction_bin égaux à 1
result <- result %>%
  mutate(Proportion_1 = Prediction_bin_1 / Total)

# Attribuer 1 si la proportion est supérieure à 80%, sinon 0
result <- result %>%
  mutate(Decision = ifelse(Proportion_1 > 0.5, 1, 0))

f_$Annee_Mois <- format(as.Date(f_$Date), "%Y-%m")
result <- merge(f_, result, by = c("Code_Onde","Annee_Mois"))

result[,c("Code_Onde","Assec","Decision")]

proportions <- result %>%
  group_by(Code_Onde) %>%
  summarise(
    Assec_Proportion = mean(Assec == 1),
    Decision_Proportion = mean(Decision == 1)
  )

plot(proportions$Assec_Proportion,proportions$Decision_Proportion)


library(scales)
library(ggrepel)

# ggplot(proportions, aes(x = Assec_Proportion * 100, y = Decision_Proportion * 100)) +
#   geom_point(shape = 16, size = 3) +  # Points pleins
#   geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "blue") +  # Trait diagonal (0,0) à (100,100)
#   scale_x_continuous(limits = c(0, 100), labels = scales::percent_format(scale = 1)) +  # Echelle 0 à 100% pour l'axe X
#   scale_y_continuous(limits = c(0, 100), labels = scales::percent_format(scale = 1)) +  # Echelle 0 à 100% pour l'axe Y
#   labs(x = "Proportion de 1 dans Assec (%)", 
#        y = "Proportion de 1 dans Decision (%)", 
#        title = "Proportions Assec vs Decision") +
#   theme_minimal()  # Thème minimal

x11()
ggplot(proportions, aes(x = Assec_Proportion * 100, y = Decision_Proportion * 100, label = Code_Onde)) +
  geom_point(shape = 16, size = 3) +  # Points pleins
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "gray") +  # Trait diagonal (0,0) à (100,100)
  geom_text_repel(size = 5, nudge_y = 5, nudge_x = 5, box.padding = 0.5, 
                  point.padding = 0.5, force = 5, max.overlaps = Inf, color = "gray") +  # Force l'affichage des étiquettes
  scale_x_continuous(limits = c(0, 100), labels = scales::percent_format(scale = 1)) +  # Echelle 0 à 100% pour l'axe X
  scale_y_continuous(limits = c(0, 100), labels = scales::percent_format(scale = 1)) +  # Echelle 0 à 100% pour l'axe Y
  labs(x = "PFI observed (%)", 
       y = "PFI predicted (%)", 
       title = paste0("HER2: ",HER_)) +
  theme_minimal() +
  theme(
    axis.title = element_text(size = 14),  # Taille du texte des titres des axes
    axis.text = element_text(size = 12),   # Taille du texte des labels des axes
    plot.title = element_text(size = 16)   # Taille du titre du graphique
  )

