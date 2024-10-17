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

# Restructurer la table en format large avec Codes_Onde en ligne et Annee_Mois en colonne
# final_table <- result %>%
#   select(Code_Onde, Annee_Mois, Decision) %>%
#   pivot_wider(names_from = Annee_Mois, values_from = Decision, values_fill = 0)  # Remplacer NA par 0

# Affichage du résultat final
# print(final_table)

f_$Annee_Mois <- format(as.Date(f_$Date), "%Y-%m")
result <- merge(f_, result, by = c("Code_Onde","Annee_Mois"))



### Tab chroniques ###
# name_file_ <- 
# HER_ <- str_after_first(str_before_first(name_file_,"_30_jours"),"_HER_")
# title_ <- str_after_last(str_before_last(str_before_last(name_file_,"/"),"/"),"/")

# tab_ <- read.table(name_file_,
#                    sep=";",dec=".",header = T)
# tab_$Assec_Col <- ifelse(tab_$Assec == 1, "red", "blue")
# tab_$Prediction_bin_Col <- ifelse(tab_$Prediction_bin == 1, "red", "blue")
# tab_$Date_Format <- format(as.Date(tab_$Date),"%Y-%m")
result$Code_Onde_Numeric <- as.numeric(as.factor(result$Code_Onde))  # Conversion en numérique pour l'axe y

TP_ <- length(which(result$Assec == 1 & result$Decision == 1))
FN_ <- length(which(result$Assec == 1 & result$Decision == 0))
TN_ <- length(which(result$Assec == 0 & result$Decision == 0))
FP_ <- length(which(result$Assec == 0 & result$Decision == 1))
Sensi <- round(TP_/(TP_+FN_)*100,2)
Speci <- round(TN_/(TN_+FP_)*100,2)
FAR <- round(FP_/(FP_+TP_)*100,2) # FAR
Precision <- TP_/(TP_+FP_)
Recall <- TP_/(TP_+FN_)
F1score <- round((2*Precision*Recall)/(Precision+Recall)*100,2) # F1 score



### Performance ###
# tab_perf_ <- read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/23_PredictionParSiteONDE_PremierTest/Random_Forest/4_ResultatsLocaux_France/CTRIP/debit_France_CNRM.CERFACS.CNRM.CM5_rcp26_r1i1p1_CNRM.ALADIN63_v3_MF.ADAMONT.SAFRAN.1980.2011_MF.ISBA.CTRIP_day_20050801.21000731/CrossValidationSafran/CritereSeuilsOptiTest_2012_2022_Calibration_moyJ30_HER2.csv",
#                         sep=";",dec=".",header = T)
# Sensi <- round(sum(tab_perf_$TP_Test)/(sum(tab_perf_$TP_Test)+sum(tab_perf_$FN_Test))*100,2) # Sensi
# Speci <- round(sum(tab_perf_$TN_Test)/(sum(tab_perf_$TN_Test)+sum(tab_perf_$FP_Test))*100,2) # Speci
# FAR <- round(sum(tab_perf_$FP_Test)/(sum(tab_perf_$FP_Test)+sum(tab_perf_$TP_Test))*100,2) # FAR
# Precision <- sum(tab_perf_$TP_Test)/(sum(tab_perf_$TP_Test)+sum(tab_perf_$FP_Test))
# Recall <- sum(tab_perf_$TP_Test)/(sum(tab_perf_$TP_Test)+sum(tab_perf_$FN_Test))
# F1score <- round((2*Precision*Recall)/(Precision+Recall)*100,2) # F1 score

# Création du sous-titre avec les indicateurs
subtitle <- paste("Sensitivity:", Sensi, "% | Specificity:", Speci, "% | FAR:", FAR, "% | F1 Score:", F1score)
result$Assec <- as.factor(result$Assec)  # Convertir Assec en facteur
result$Decision <- as.factor(result$Decision)  # Convertir Decision en facteur

x11()
gg1 <- ggplot(result, aes(x = Annee_Mois, y = Code_Onde_Numeric)) + 
  # Points pour les Assec (observés)
  geom_point(aes(color = Assec, shape = "Assec"), size = 3) +  
  # Points pour les Prediction_bin (prédictions) avec un décalage vertical de +0.2
  geom_point(aes(x = Annee_Mois, y = Code_Onde_Numeric + 0.4, color = Decision, shape = "Decision"), size = 2, alpha = 0.7) +  
  # Attribution manuelle des couleurs
  
  scale_color_manual(name = "",
                     values = c("#b2abd2", "#b35806"),
                     labels = c("Flow","Dry")) +  # Utilise les couleurs définies dans les colonnes
  scale_shape_manual(name = "",
                     values = c(16,17),
                     labels = c("Observation","Prediction")) +
  labs(title = paste0("HER2: ",HER_),
       subtitle = subtitle,  # Ajout du sous-titre ici
       x = "Date", 
       y = "ONDE site") + 
  scale_y_continuous(breaks = 1:length(unique(df_$Code_Onde)), labels = unique(df_$Code_Onde)) +  # Conserve les labels originaux des sites
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Incliner les dates pour mieux les lire



# png(gsub(".csv",".png",name_file_), width = 10*100, height = 7*100)
print(gg1)
# dev.off()
