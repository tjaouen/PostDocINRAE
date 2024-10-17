library(ggplot2)
library(strex)

### Tab chroniques ###
name_file_ <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/23_PredictionParSiteONDE_PremierTest/Random_Forest/4_ResultatsLocaux_France/CTRIP/debit_France_CNRM.CERFACS.CNRM.CM5_rcp26_r1i1p1_CNRM.ALADIN63_v3_MF.ADAMONT.SAFRAN.1980.2011_MF.ISBA.CTRIP_day_20050801.21000731/CrossValidationSafran/Input_test_classif_HER_105_30_jours_fin_caract_new_meteo_FINAL_AjoutProbaAssecParHER_scaled.csv"
HER_ <- str_after_first(str_before_first(name_file_,"_30_jours"),"_HER_")
title_ <- str_after_last(str_before_last(str_before_last(name_file_,"/"),"/"),"/")

tab_ <- read.table(name_file_,
                   sep=";",dec=".",header = T)
tab_$Assec_Col <- ifelse(tab_$Assec == 1, "red", "blue")
tab_$Prediction_bin_Col <- ifelse(tab_$Prediction_bin == 1, "red", "blue")
tab_$Date_Format <- format(as.Date(tab_$Date),"%Y-%m")
tab_$Code_Onde_Numeric <- as.numeric(as.factor(tab_$Code_Onde))  # Conversion en numérique pour l'axe y

### Performance ###
tab_perf_ <- read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/23_PredictionParSiteONDE_PremierTest/Random_Forest/4_ResultatsLocaux_France/CTRIP/debit_France_CNRM.CERFACS.CNRM.CM5_rcp26_r1i1p1_CNRM.ALADIN63_v3_MF.ADAMONT.SAFRAN.1980.2011_MF.ISBA.CTRIP_day_20050801.21000731/CrossValidationSafran/CritereSeuilsOptiTest_2012_2022_Calibration_moyJ30_HER2.csv",
                   sep=";",dec=".",header = T)
Sensi <- round(sum(tab_perf_$TP_Test)/(sum(tab_perf_$TP_Test)+sum(tab_perf_$FN_Test))*100,2) # Sensi
Speci <- round(sum(tab_perf_$TN_Test)/(sum(tab_perf_$TN_Test)+sum(tab_perf_$FP_Test))*100,2) # Speci
FAR <- round(sum(tab_perf_$FP_Test)/(sum(tab_perf_$FP_Test)+sum(tab_perf_$TP_Test))*100,2) # FAR
Precision <- sum(tab_perf_$TP_Test)/(sum(tab_perf_$TP_Test)+sum(tab_perf_$FP_Test))
Recall <- sum(tab_perf_$TP_Test)/(sum(tab_perf_$TP_Test)+sum(tab_perf_$FN_Test))
F1score <- round((2*Precision*Recall)/(Precision+Recall)*100,2) # F1 score

# Création du sous-titre avec les indicateurs
subtitle <- paste("Sensitivity:", Sensi, "% | Specificity:", Speci, "% | FAR:", FAR, "% | F1 Score:", F1score)

# x11()
gg1 <- ggplot(tab_, aes(x = Date_Format, y = Code_Onde_Numeric)) + 
  # Points pour les Assec (observés)
  geom_point(aes(color = Assec_Col, shape = "Assec"), size = 3) +  
  # Points pour les Prediction_bin (prédictions) avec un décalage vertical de +0.2
  geom_point(aes(x = Date_Format, y = Code_Onde_Numeric + 0.4, color = Prediction_bin_Col, shape = "Prediction_bin"), size = 2, alpha = 0.7) +  
  # Attribution manuelle des couleurs
  scale_color_manual(name = "",
                     values = c("#b2abd2", "#b35806"),
                     labels = c("Flow","Dry")) +  # Utilise les couleurs définies dans les colonnes
  scale_shape_manual(name = "",
    values = c(16,17),
    labels = c("Observation","Prediction")) +
  labs(title = paste0("HER2: ",HER_,"\n",title_),
       subtitle = subtitle,  # Ajout du sous-titre ici
       x = "Date", 
       y = "ONDE site") + 
  scale_y_continuous(breaks = 1:length(unique(tab_$Code_Onde)), labels = unique(tab_$Code_Onde)) +  # Conserve les labels originaux des sites
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Incliner les dates pour mieux les lire



png(gsub(".csv",".png",name_file_), width = 10*100, height = 7*100)
print(gg1)
dev.off()
