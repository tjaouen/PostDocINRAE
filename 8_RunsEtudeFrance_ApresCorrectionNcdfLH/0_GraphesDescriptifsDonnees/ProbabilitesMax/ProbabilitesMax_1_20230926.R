



tab_input_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2022_20230919/DebitsComplets_From20120101_To20221231/MatInputModel_CampOndeExcl_ByHERDates__2012_2022_Observes_Weight_merge.csv"

dat_input_ = read.table(tab_input_, sep = ";", dec = ".", header = T)

data.frame(dat_input_$HER2,dat_input_$X._Assec)

result <- aggregate(X._Assec ~ HER2, data = dat_input_, FUN = max)


output_name_ <- paste0("/home/tjaouen/Documents/Input/ONDE/Data_DatesAjustees/MapSitesOndeDisponibles/Version_20230910/MaxProbabilitesObserveesONDE_sansEtiq_1_20230926.png")
# "/TableGlobale/Map_English/6_Map_Globale_ErrMoyAbs_Mois09_NonBoot/",str_before_first(basename(filename_),pattern = ".csv"),"_sansEtiq.png")
plot_map_variable_sansEtiquettes(tab_ = result,
                                 varname_ = "X._Assec",
                                 # vartitle_ = "Mean Absolute Error\nbetween predictions\nand observations of\ndrying state at ONDE sites\n(unitless)",
                                 vartitle_ = "Probabilité max observée ONDE",
                                 breaks_ = breaks_ProbaAssecFDCnulle,
                                 output_name_ = output_name_,
                                 title_ = paste0("Leave One Year Out validation"),
                                 nomPalette_ = "cryo_div_disc.txt",
                                 reverseColors_ = T,
                                 sansTexteHer_ = T,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = T)


result


fich_moisAnnees_2012_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2022_20230919/DebitsComplets_From20120101_To20221231/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_Valid_12_Jm6Jj_logit.csv"
fich_moisAnnees_2013_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2022_20230919/DebitsComplets_From20120101_To20221231/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_Valid_13_Jm6Jj_logit.csv"
fich_moisAnnees_2014_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2022_20230919/DebitsComplets_From20120101_To20221231/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_Valid_14_Jm6Jj_logit.csv"
fich_moisAnnees_2015_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2022_20230919/DebitsComplets_From20120101_To20221231/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_Valid_15_Jm6Jj_logit.csv"
fich_moisAnnees_2016_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2022_20230919/DebitsComplets_From20120101_To20221231/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_Valid_16_Jm6Jj_logit.csv"
fich_moisAnnees_2017_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2022_20230919/DebitsComplets_From20120101_To20221231/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_Valid_17_Jm6Jj_logit.csv"
fich_moisAnnees_2018_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2022_20230919/DebitsComplets_From20120101_To20221231/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_Valid_18_Jm6Jj_logit.csv"
fich_moisAnnees_2019_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2022_20230919/DebitsComplets_From20120101_To20221231/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_Valid_19_Jm6Jj_logit.csv"
fich_moisAnnees_2020_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2022_20230919/DebitsComplets_From20120101_To20221231/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_Valid_20_Jm6Jj_logit.csv"
fich_moisAnnees_2021_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2022_20230919/DebitsComplets_From20120101_To20221231/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_Valid_21_Jm6Jj_logit.csv"
fich_moisAnnees_2022_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2022_20230919/DebitsComplets_From20120101_To20221231/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_Valid_22_Jm6Jj_logit.csv"

tab_moisAnnees_2012 = read.table(fich_moisAnnees_2012_, sep = ";", dec = ".", header = T)
tab_moisAnnees_2013 = read.table(fich_moisAnnees_2013_, sep = ";", dec = ".", header = T)
tab_moisAnnees_2014 = read.table(fich_moisAnnees_2014_, sep = ";", dec = ".", header = T)
tab_moisAnnees_2015 = read.table(fich_moisAnnees_2015_, sep = ";", dec = ".", header = T)
tab_moisAnnees_2016 = read.table(fich_moisAnnees_2016_, sep = ";", dec = ".", header = T)
tab_moisAnnees_2017 = read.table(fich_moisAnnees_2017_, sep = ";", dec = ".", header = T)
tab_moisAnnees_2018 = read.table(fich_moisAnnees_2018_, sep = ";", dec = ".", header = T)
tab_moisAnnees_2019 = read.table(fich_moisAnnees_2019_, sep = ";", dec = ".", header = T)
tab_moisAnnees_2020 = read.table(fich_moisAnnees_2020_, sep = ";", dec = ".", header = T)
tab_moisAnnees_2021 = read.table(fich_moisAnnees_2021_, sep = ";", dec = ".", header = T)
tab_moisAnnees_2022 = read.table(fich_moisAnnees_2022_, sep = ";", dec = ".", header = T)


tab_moisAnnees_ = rbind(tab_moisAnnees_2012,
                        tab_moisAnnees_2013,
                        tab_moisAnnees_2014,
                        tab_moisAnnees_2015,
                        tab_moisAnnees_2016,
                        tab_moisAnnees_2017,
                        tab_moisAnnees_2018,
                        tab_moisAnnees_2019,
                        tab_moisAnnees_2020,
                        tab_moisAnnees_2021,
                        tab_moisAnnees_2022)

result_predit <- aggregate(ProbaAssec_HERMoisAnnee_Predite_CValid ~ HER2, data = tab_moisAnnees_, FUN = max)
result_aPredire <- aggregate(ProbaAssec_HERMoisAnnee_Apredire_CValid ~ HER2, data = tab_moisAnnees_, FUN = max)

result_predit$ProbaAssec_HERMoisAnnee_Predite_CValid > result_aPredire$ProbaAssec_HERMoisAnnee_Apredire_CValid



tab_globaleLOYO_ <- read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2022_20230919/DebitsComplets_From20120101_To20221231/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableGlobale/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_ValidGlobale__Jm6Jj_logit.csv", sep = ";", dec = ".", header = T)

tab_globaleLOYO_$ProbaAssecNul = exp(tab_globaleLOYO_$Intercept_general)/(1+exp(tab_globaleLOYO_$Intercept_general))*100

result$X._Assec < tab_globaleLOYO_$ProbaAssecNul

result$HER2 == tab_globaleLOYO_$HER

data <- data.frame(
  HER2 = result$HER2,
  Observations = result$X._Assec,
  Predictions = tab_globaleLOYO_$ProbaAssecNul
)



ggplot(data, aes(x = HER2)) +
  geom_bar(aes(y = Observations, fill = "Observations"), stat = "identity", position = "dodge") +
  geom_bar(aes(y = Predictions, fill = "Prédictions"), stat = "identity", position = "dodge") +
  labs(
    x = "HER2",
    y = "Valeurs d'assèchement",
    title = "Comparaison des valeurs observées et prédites par région HER2"
  ) +
  scale_fill_manual(
    values = c("Observations" = "blue", "Prédictions" = "red"),
    labels = c("Observations", "Prédictions")
  ) +
  theme_minimal()



library(tidyr)
data_long <- gather(data, "Type", "Valeur", -HER2)

# Créez le graphique en barres groupées
ggplot(data_long, aes(x = HER2, y = Valeur, fill = Type)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    x = "HER2",
    y = "Valeurs d'assèchement",
    title = "Comparaison des valeurs observées et prédites par région HER2"
  ) +
  scale_fill_manual(
    values = c("Observations" = "blue", "Prédictions" = "red"),
    labels = c("Observations", "Prédictions")
  ) +
  theme_minimal()

barplot(
  height = t(data[, -1]),  # Sélectionnez les colonnes de valeurs
  beside = TRUE,           # Pour créer des barres côte à côte
  col = c("blue", "red"),  # Couleurs des barres
  names.arg = data$HER2,   # Étiquettes des régions HER2 sur l'axe x
  legend.text = TRUE,      # Afficher la légende
  args.legend = list(x = "topright"),  # Position de la légende
  main = "Comparaison des valeurs observées et prédites par région HER2",  # Titre
  xlab = "HER2",           # Légende de l'axe x
  ylab = "Valeurs d'assèchement"    # Légende de l'axe y
)
