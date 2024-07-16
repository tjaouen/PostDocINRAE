


### Nombre de campagnes ONDE incompletes ###
sum(sum(tab_annees_2012$NbMoisExclusONDE_CValid),
    sum(tab_annees_2013$NbMoisExclusONDE_CValid),
    sum(tab_annees_2014$NbMoisExclusONDE_CValid),
    sum(tab_annees_2015$NbMoisExclusONDE_CValid),
    sum(tab_annees_2016$NbMoisExclusONDE_CValid),
    sum(tab_annees_2017$NbMoisExclusONDE_CValid),
    sum(tab_annees_2018$NbMoisExclusONDE_CValid),
    sum(tab_annees_2019$NbMoisExclusONDE_CValid),
    sum(tab_annees_2020$NbMoisExclusONDE_CValid),
    sum(tab_annees_2021$NbMoisExclusONDE_CValid),
    sum(tab_annees_2022$NbMoisExclusONDE_CValid)) # Gerees en amont desormais

tab_annees_2012$HER[which(tab_annees_2012$NbMoisExclusONDE_CValid > 0)]
tab_annees_2013$HER[which(tab_annees_2013$NbMoisExclusONDE_CValid > 0)]
tab_annees_2014$HER[which(tab_annees_2014$NbMoisExclusONDE_CValid > 0)]
tab_annees_2015$HER[which(tab_annees_2015$NbMoisExclusONDE_CValid > 0)]
tab_annees_2016$HER[which(tab_annees_2016$NbMoisExclusONDE_CValid > 0)]
tab_annees_2017$HER[which(tab_annees_2017$NbMoisExclusONDE_CValid > 0)]
tab_annees_2018$HER[which(tab_annees_2018$NbMoisExclusONDE_CValid > 0)]
tab_annees_2019$HER[which(tab_annees_2019$NbMoisExclusONDE_CValid > 0)]
tab_annees_2020$HER[which(tab_annees_2020$NbMoisExclusONDE_CValid > 0)]
tab_annees_2021$HER[which(tab_annees_2021$NbMoisExclusONDE_CValid > 0)]
tab_annees_2022$HER[which(tab_annees_2022$NbMoisExclusONDE_CValid > 0)]

sum(sum(tab_annees_2012$NbMoisSelectionnesONDE_CValid),
    sum(tab_annees_2013$NbMoisSelectionnesONDE_CValid),
    sum(tab_annees_2014$NbMoisSelectionnesONDE_CValid),
    sum(tab_annees_2015$NbMoisSelectionnesONDE_CValid),
    sum(tab_annees_2016$NbMoisSelectionnesONDE_CValid),
    sum(tab_annees_2017$NbMoisSelectionnesONDE_CValid),
    sum(tab_annees_2018$NbMoisSelectionnesONDE_CValid),
    sum(tab_annees_2019$NbMoisSelectionnesONDE_CValid),
    sum(tab_annees_2020$NbMoisSelectionnesONDE_CValid),
    sum(tab_annees_2021$NbMoisSelectionnesONDE_CValid),
    sum(tab_annees_2022$NbMoisSelectionnesONDE_CValid))




# fich_moisAnnees_2012_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/17_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrOubliHerJointes20212022etFonctionSeuilOnde_SensiIntervJours_2012_2022_20230614/LeaveOneYearOut/Validation_ParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_2012_2022_Obs_Weight_20230614_Valid_2012_Jm6Jj_logit_kge.csv"
# fich_moisAnnees_2013_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/17_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrOubliHerJointes20212022etFonctionSeuilOnde_SensiIntervJours_2012_2022_20230614/LeaveOneYearOut/Validation_ParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_2012_2022_Obs_Weight_20230614_Valid_2013_Jm6Jj_logit_kge.csv"
# fich_moisAnnees_2014_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/17_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrOubliHerJointes20212022etFonctionSeuilOnde_SensiIntervJours_2012_2022_20230614/LeaveOneYearOut/Validation_ParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_2012_2022_Obs_Weight_20230614_Valid_2014_Jm6Jj_logit_kge.csv"
# fich_moisAnnees_2015_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/17_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrOubliHerJointes20212022etFonctionSeuilOnde_SensiIntervJours_2012_2022_20230614/LeaveOneYearOut/Validation_ParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_2012_2022_Obs_Weight_20230614_Valid_2015_Jm6Jj_logit_kge.csv"
# fich_moisAnnees_2016_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/17_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrOubliHerJointes20212022etFonctionSeuilOnde_SensiIntervJours_2012_2022_20230614/LeaveOneYearOut/Validation_ParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_2012_2022_Obs_Weight_20230614_Valid_2016_Jm6Jj_logit_kge.csv"
# fich_moisAnnees_2017_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/17_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrOubliHerJointes20212022etFonctionSeuilOnde_SensiIntervJours_2012_2022_20230614/LeaveOneYearOut/Validation_ParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_2012_2022_Obs_Weight_20230614_Valid_2017_Jm6Jj_logit_kge.csv"
# fich_moisAnnees_2018_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/17_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrOubliHerJointes20212022etFonctionSeuilOnde_SensiIntervJours_2012_2022_20230614/LeaveOneYearOut/Validation_ParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_2012_2022_Obs_Weight_20230614_Valid_2018_Jm6Jj_logit_kge.csv"
# fich_moisAnnees_2019_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/17_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrOubliHerJointes20212022etFonctionSeuilOnde_SensiIntervJours_2012_2022_20230614/LeaveOneYearOut/Validation_ParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_2012_2022_Obs_Weight_20230614_Valid_2019_Jm6Jj_logit_kge.csv"
# fich_moisAnnees_2020_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/17_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrOubliHerJointes20212022etFonctionSeuilOnde_SensiIntervJours_2012_2022_20230614/LeaveOneYearOut/Validation_ParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_2012_2022_Obs_Weight_20230614_Valid_2020_Jm6Jj_logit_kge.csv"
# fich_moisAnnees_2021_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/17_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrOubliHerJointes20212022etFonctionSeuilOnde_SensiIntervJours_2012_2022_20230614/LeaveOneYearOut/Validation_ParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_2012_2022_Obs_Weight_20230614_Valid_2021_Jm6Jj_logit_kge.csv"
# fich_moisAnnees_2022_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/17_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrOubliHerJointes20212022etFonctionSeuilOnde_SensiIntervJours_2012_2022_20230614/LeaveOneYearOut/Validation_ParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_2012_2022_Obs_Weight_20230614_Valid_2022_Jm6Jj_logit_kge.csv"

fich_moisAnnees_2012_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/LeaveOneYearOut/Validation_ParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_2012_2022_Obs_Weight_20230614_Valid_2012_Jm6Jj_logit_kge.csv"
fich_moisAnnees_2013_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/LeaveOneYearOut/Validation_ParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_2012_2022_Obs_Weight_20230614_Valid_2013_Jm6Jj_logit_kge.csv"
fich_moisAnnees_2014_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/LeaveOneYearOut/Validation_ParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_2012_2022_Obs_Weight_20230614_Valid_2014_Jm6Jj_logit_kge.csv"
fich_moisAnnees_2015_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/LeaveOneYearOut/Validation_ParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_2012_2022_Obs_Weight_20230614_Valid_2015_Jm6Jj_logit_kge.csv"
fich_moisAnnees_2016_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/LeaveOneYearOut/Validation_ParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_2012_2022_Obs_Weight_20230614_Valid_2016_Jm6Jj_logit_kge.csv"
fich_moisAnnees_2017_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/LeaveOneYearOut/Validation_ParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_2012_2022_Obs_Weight_20230614_Valid_2017_Jm6Jj_logit_kge.csv"
fich_moisAnnees_2018_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/LeaveOneYearOut/Validation_ParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_2012_2022_Obs_Weight_20230614_Valid_2018_Jm6Jj_logit_kge.csv"
fich_moisAnnees_2019_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/LeaveOneYearOut/Validation_ParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_2012_2022_Obs_Weight_20230614_Valid_2019_Jm6Jj_logit_kge.csv"
fich_moisAnnees_2020_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/LeaveOneYearOut/Validation_ParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_2012_2022_Obs_Weight_20230614_Valid_2020_Jm6Jj_logit_kge.csv"
fich_moisAnnees_2021_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/LeaveOneYearOut/Validation_ParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_2012_2022_Obs_Weight_20230614_Valid_2021_Jm6Jj_logit_kge.csv"
fich_moisAnnees_2022_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/LeaveOneYearOut/Validation_ParMoisAnnees/Results_Jm6Jj/ModelResults_ParDate_2012_2022_Obs_Weight_20230614_Valid_2022_Jm6Jj_logit_kge.csv"

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

















vect_ = c(paste0(tab_moisAnnees_2012$HER2,"_",month(as.Date(tab_moisAnnees_2012$Date)),"_",year(as.Date(tab_moisAnnees_2012$Date))),
          paste0(tab_moisAnnees_2013$HER2,"_",month(as.Date(tab_moisAnnees_2013$Date)),"_",year(as.Date(tab_moisAnnees_2013$Date))),
          paste0(tab_moisAnnees_2014$HER2,"_",month(as.Date(tab_moisAnnees_2014$Date)),"_",year(as.Date(tab_moisAnnees_2014$Date))),
          paste0(tab_moisAnnees_2015$HER2,"_",month(as.Date(tab_moisAnnees_2015$Date)),"_",year(as.Date(tab_moisAnnees_2015$Date))),
          paste0(tab_moisAnnees_2016$HER2,"_",month(as.Date(tab_moisAnnees_2016$Date)),"_",year(as.Date(tab_moisAnnees_2016$Date))),
          paste0(tab_moisAnnees_2017$HER2,"_",month(as.Date(tab_moisAnnees_2017$Date)),"_",year(as.Date(tab_moisAnnees_2017$Date))),
          paste0(tab_moisAnnees_2018$HER2,"_",month(as.Date(tab_moisAnnees_2018$Date)),"_",year(as.Date(tab_moisAnnees_2018$Date))),
          paste0(tab_moisAnnees_2019$HER2,"_",month(as.Date(tab_moisAnnees_2019$Date)),"_",year(as.Date(tab_moisAnnees_2019$Date))),
          paste0(tab_moisAnnees_2020$HER2,"_",month(as.Date(tab_moisAnnees_2020$Date)),"_",year(as.Date(tab_moisAnnees_2020$Date))),
          paste0(tab_moisAnnees_2021$HER2,"_",month(as.Date(tab_moisAnnees_2021$Date)),"_",year(as.Date(tab_moisAnnees_2021$Date))),
          paste0(tab_moisAnnees_2022$HER2,"_",month(as.Date(tab_moisAnnees_2022$Date)),"_",year(as.Date(tab_moisAnnees_2022$Date))))


# Créez un dataframe avec toutes les combinaisons possibles
combinations <- expand.grid(
  HER2 = unique(tab_moisAnnees_2012$HER2),
  X1 = 5:9,
  X2 = 2012:2022
)

# Utilisez paste0 pour créer un vecteur de combinaisons sous forme de chaînes de caractères
result_vector <- with(combinations, paste0(HER2, "_", X1, "_", X2))

result_vector[which(!(result_vector %in% vect_))]



df_HER_nbObsMois_ = data.frame(HER2 = c(tab_moisAnnees_2012$HER2,
                                        tab_moisAnnees_2013$HER2,
                                        tab_moisAnnees_2014$HER2,
                                        tab_moisAnnees_2015$HER2,
                                        tab_moisAnnees_2016$HER2,
                                        tab_moisAnnees_2017$HER2,
                                        tab_moisAnnees_2018$HER2,
                                        tab_moisAnnees_2019$HER2,
                                        tab_moisAnnees_2020$HER2,
                                        tab_moisAnnees_2021$HER2,
                                        tab_moisAnnees_2022$HER2),
                               NbStationsObservesONDE_CValid = c(tab_moisAnnees_2012$NbStationsObservesONDE_CValid,
                                                                 tab_moisAnnees_2013$NbStationsObservesONDE_CValid,
                                                                 tab_moisAnnees_2014$NbStationsObservesONDE_CValid,
                                                                 tab_moisAnnees_2015$NbStationsObservesONDE_CValid,
                                                                 tab_moisAnnees_2016$NbStationsObservesONDE_CValid,
                                                                 tab_moisAnnees_2017$NbStationsObservesONDE_CValid,
                                                                 tab_moisAnnees_2018$NbStationsObservesONDE_CValid,
                                                                 tab_moisAnnees_2019$NbStationsObservesONDE_CValid,
                                                                 tab_moisAnnees_2020$NbStationsObservesONDE_CValid,
                                                                 tab_moisAnnees_2021$NbStationsObservesONDE_CValid,
                                                                 tab_moisAnnees_2022$NbStationsObservesONDE_CValid),
                               Id = c(paste0(tab_moisAnnees_2012$HER2,"_",month(as.Date(tab_moisAnnees_2012$Date)),"_",year(as.Date(tab_moisAnnees_2012$Date))),
                                      paste0(tab_moisAnnees_2013$HER2,"_",month(as.Date(tab_moisAnnees_2013$Date)),"_",year(as.Date(tab_moisAnnees_2013$Date))),
                                      paste0(tab_moisAnnees_2014$HER2,"_",month(as.Date(tab_moisAnnees_2014$Date)),"_",year(as.Date(tab_moisAnnees_2014$Date))),
                                      paste0(tab_moisAnnees_2015$HER2,"_",month(as.Date(tab_moisAnnees_2015$Date)),"_",year(as.Date(tab_moisAnnees_2015$Date))),
                                      paste0(tab_moisAnnees_2016$HER2,"_",month(as.Date(tab_moisAnnees_2016$Date)),"_",year(as.Date(tab_moisAnnees_2016$Date))),
                                      paste0(tab_moisAnnees_2017$HER2,"_",month(as.Date(tab_moisAnnees_2017$Date)),"_",year(as.Date(tab_moisAnnees_2017$Date))),
                                      paste0(tab_moisAnnees_2018$HER2,"_",month(as.Date(tab_moisAnnees_2018$Date)),"_",year(as.Date(tab_moisAnnees_2018$Date))),
                                      paste0(tab_moisAnnees_2019$HER2,"_",month(as.Date(tab_moisAnnees_2019$Date)),"_",year(as.Date(tab_moisAnnees_2019$Date))),
                                      paste0(tab_moisAnnees_2020$HER2,"_",month(as.Date(tab_moisAnnees_2020$Date)),"_",year(as.Date(tab_moisAnnees_2020$Date))),
                                      paste0(tab_moisAnnees_2021$HER2,"_",month(as.Date(tab_moisAnnees_2021$Date)),"_",year(as.Date(tab_moisAnnees_2021$Date))),
                                      paste0(tab_moisAnnees_2022$HER2,"_",month(as.Date(tab_moisAnnees_2022$Date)),"_",year(as.Date(tab_moisAnnees_2022$Date)))))

result_vector[which(!(result_vector %in% df_HER_nbObsMois_$Id))] # 4 campagnes sans observation : "24_5_2013" "22_9_2013" "22_5_2016" "22_6_2018"

resultat <- aggregate(NbStationsObservesONDE_CValid ~ HER2, data = df_HER_nbObsMois_, FUN = max)

merged_data <- merge(df_HER_nbObsMois_, resultat, by = "HER2", suffixes = c("", "_max"))

# Créez la colonne binaire
# merged_data$ColonneBinaire <- ifelse(merged_data$NbStationsObservesONDE_CValid <= 0.75 * merged_data$NbStationsObservesONDE_CValid_max, 1, 0) # Il faut qu'elles aient plus de 75% de leurs sites max de l'annee qui soient observes. Peut etre pas meme resultat avec validation par annees seches, humides, etc

merged_data$Seuil = round(0.75 * merged_data$NbStationsObservesONDE_CValid_max)
merged_data$ColonneBinaire = ifelse(merged_data$NbStationsObservesONDE_CValid <= merged_data$Seuil, 1, 0)

merged_data$Annee =substr(merged_data$Id,nchar(merged_data$Id)-3,nchar(merged_data$Id))
merged_data$Mois =substr(merged_data$Id,nchar(merged_data$Id)-5,nchar(merged_data$Id)-5)

merged_data_excl = merged_data[which(merged_data$ColonneBinaire == 1),]
dim(merged_data_excl)

table(merged_data_excl$Annee)

merged_data_excl[which(merged_data_excl$Annee =="2012"),]

# Erreur pour 2014, 2016, 2017
merged_data_excl[which(merged_data_excl$Annee =="2014"),]

tab_106 = merged_data[which(merged_data$HER2 == 106),]
tab_106[order(tab_106$Annee,tab_106$Mois),]



#2016 = 16 au lieu de 14
#2017 = 14 au lieu de 11
merged_data[which(merged_data$Annee == 2016 & merged_data$ColonneBinaire == 1),]

# max 102 contre un max reel 105 pour la 54 en 2016


result_vector[which(!(result_vector %in% merged_data$Id))]


tab_24 = merged_data[which(merged_data$HER2 == 24),]
tab_24[order(tab_24$Annee,tab_24$Mois),]

which(duplicated(merged_data_excl$Id))







folder_onde_ = folder_onde_param_
ONDE <- read.table(folder_onde_, sep = ";", dec = ".", header = T)
if (dim(ONDE)[2] == 1){
  ONDE = read.table(folder_onde_, sep = ",", dec = ".", header = T, quote = "")
}
print("Taille à verifier apres correction ONDE 2023.06.07 : 175 972")
dim(ONDE)

ONDE$Annee
ONDE$Month = month(as.Date(ONDE$DtRealObservation))

# onde = Recoupement Stations ONDE - HER #
onde = read.table(paste0(folder_ONDE_CorrespondanceHER_,"HER2hybrides_Jonction/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_JonctionHER_4_20230512_AncienneVersionJonction3755.csv"), header = T, sep = ";", row.names = NULL, quote="")
# onde = read.table(paste0(folder_ONDE_CorrespondanceHER_,"HER2hybrides_Jonction/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_JonctionHER_4_20230512.csv"), header = T, sep = ";", row.names = NULL, quote="")
#onde = read.table(paste0(folder_ONDE_CorrespondanceHER_,"HER2hybrides/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_3_20230331.csv"), header = T, sep = ";", row.names = NULL, quote="")
if (dim(onde)[2] == 1){
  onde = read.table(paste0(folder_ONDE_CorrespondanceHER_,"HER2hybrides_Jonction/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_JonctionHER_4_20230512_AncienneVersionJonction3755.csv"), sep=",", dec=".", header = T)
  #onde = read.table(paste0(folder_ONDE_CorrespondanceHER_,"HER2hybrides/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_3_20230331.csv"), sep=",", dec=".", header = T)
}
onde = onde[,c("Code","X_Lambert93","Y_Lambert93",paste0("Cd",HER_variable_))]
colnames(onde) = c("Code","X_Lambert93","Y_Lambert93",paste0("Cd",HER_variable_))
print("Taille à verifier : 3302")
dim(onde)

code_HER24_ = onde$Code[which(onde$CdHER2 == 24)]
code_HER22_ = onde$Code[which(onde$CdHER2 == 22)]



ONDE[which(ONDE$Annee == 2012 & ONDE$Month == 9 & ONDE$CdSiteHydro %in% code_HER22_),] #Test
ONDE[which(ONDE$Annee == 2012 & ONDE$Month == 9 & ONDE$CdSiteHydro %in% code_HER24_),] #Test

ONDE[which(ONDE$Annee == 2013 & ONDE$Month == 5 & ONDE$CdSiteHydro %in% code_HER24_),] #24_2013_5
ONDE[which(ONDE$Annee == 2013 & ONDE$Month == 5 & ONDE$CdSiteHydro %in% code_HER22_),]

ONDE[which(ONDE$Annee == 2013 & ONDE$Month == 9 & ONDE$CdSiteHydro %in% code_HER22_),] #22_2013_9
ONDE[which(ONDE$Annee == 2013 & ONDE$Month == 9 & ONDE$CdSiteHydro %in% code_HER24_),]

ONDE[which(ONDE$Annee == 2016 & ONDE$Month == 5 & ONDE$CdSiteHydro %in% code_HER22_),] # 22_2016_5
ONDE[which(ONDE$Annee == 2016 & ONDE$Month == 5 & ONDE$CdSiteHydro %in% code_HER24_),]

ONDE[which(ONDE$Annee == 2018 & ONDE$Month == 6 & ONDE$CdSiteHydro %in% code_HER22_),] # 22_2018_6
ONDE[which(ONDE$Annee == 2018 & ONDE$Month == 6 & ONDE$CdSiteHydro %in% code_HER24_),]

# 4 campagnes exclues pour abseence totale d'observations dans toute une HER

dim(merged_data_excl) # 75 exclusions selon les fichiers de resultats (dont 1 pour une campagne octobre)


merged_data_excl$Id
merged_data$Id

merged_data$Id[which(merged_data$ColonneBinaire == 0 & merged_data$Id %in% merged_data_excl$Id)]
merged_data_excl$Id[which(merged_data_excl$Id %in% merged_data$Id[which(merged_data$ColonneBinaire == 0)])]

table(merged_data$Mois)
merged_data[which(merged_data$Mois == 0),]

### Exclusions de campagnes ONDE ###
#Theoriquement 11 ans * 5 mois * 77 HER = 11*5*77 = 4235 campagnes
#4 campagnes sans aucun releve dans toute HER
#75 campagnes qui n'avaient pas plus de 75% des sites avec des observations dim(merged_data_excl) = 4156
#Mais une des campagnes exclues etait d'octobre. Donc elle ne doit pas etre retranchee a 4235.
#4235 - 4 - 74 = 4157 = Nombre de campagnes restantes

dim(merged_data)
sum(merged_data$ColonneBinaire == 0)
# 4232 (manque 4 campagnes sans releve, avec 1 campagne d'octobre en trop, devait etre complementaire)
# Ce devrait etre 4231 avant Exclusion
# Puis exclusion de 74 campagnes
# Sans les exclusions: dim(merged_data[which(merged_data$ColonneBinaire == 0),]) = 4157 = 4232-75. 
#La campagne d'octobre a saute automatiquement, dans les 75 exclusions

78/4157







### VERSION APRES FUSION 37 + 54 au lieu de 37 + 55 ###
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

vect_ = c(paste0(tab_moisAnnees_2012$HER2,"_",month(as.Date(tab_moisAnnees_2012$Date)),"_",year(as.Date(tab_moisAnnees_2012$Date))),
          paste0(tab_moisAnnees_2013$HER2,"_",month(as.Date(tab_moisAnnees_2013$Date)),"_",year(as.Date(tab_moisAnnees_2013$Date))),
          paste0(tab_moisAnnees_2014$HER2,"_",month(as.Date(tab_moisAnnees_2014$Date)),"_",year(as.Date(tab_moisAnnees_2014$Date))),
          paste0(tab_moisAnnees_2015$HER2,"_",month(as.Date(tab_moisAnnees_2015$Date)),"_",year(as.Date(tab_moisAnnees_2015$Date))),
          paste0(tab_moisAnnees_2016$HER2,"_",month(as.Date(tab_moisAnnees_2016$Date)),"_",year(as.Date(tab_moisAnnees_2016$Date))),
          paste0(tab_moisAnnees_2017$HER2,"_",month(as.Date(tab_moisAnnees_2017$Date)),"_",year(as.Date(tab_moisAnnees_2017$Date))),
          paste0(tab_moisAnnees_2018$HER2,"_",month(as.Date(tab_moisAnnees_2018$Date)),"_",year(as.Date(tab_moisAnnees_2018$Date))),
          paste0(tab_moisAnnees_2019$HER2,"_",month(as.Date(tab_moisAnnees_2019$Date)),"_",year(as.Date(tab_moisAnnees_2019$Date))),
          paste0(tab_moisAnnees_2020$HER2,"_",month(as.Date(tab_moisAnnees_2020$Date)),"_",year(as.Date(tab_moisAnnees_2020$Date))),
          paste0(tab_moisAnnees_2021$HER2,"_",month(as.Date(tab_moisAnnees_2021$Date)),"_",year(as.Date(tab_moisAnnees_2021$Date))),
          paste0(tab_moisAnnees_2022$HER2,"_",month(as.Date(tab_moisAnnees_2022$Date)),"_",year(as.Date(tab_moisAnnees_2022$Date))))


# Créez un dataframe avec toutes les combinaisons possibles
combinations <- expand.grid(
  HER2 = unique(tab_moisAnnees_2012$HER2),
  X1 = 5:9,
  X2 = 2012:2022
)

# Utilisez paste0 pour créer un vecteur de combinaisons sous forme de chaînes de caractères
result_vector <- with(combinations, paste0(HER2, "_", X1, "_", X2))
excl_inventaire = result_vector[which(!(result_vector %in% vect_))]
length(result_vector[which(!(result_vector %in% vect_))]) #79

df_HER_nbObsMois_ = data.frame(HER2 = c(tab_moisAnnees_2012$HER2,
                                        tab_moisAnnees_2013$HER2,
                                        tab_moisAnnees_2014$HER2,
                                        tab_moisAnnees_2015$HER2,
                                        tab_moisAnnees_2016$HER2,
                                        tab_moisAnnees_2017$HER2,
                                        tab_moisAnnees_2018$HER2,
                                        tab_moisAnnees_2019$HER2,
                                        tab_moisAnnees_2020$HER2,
                                        tab_moisAnnees_2021$HER2,
                                        tab_moisAnnees_2022$HER2),
                               NbStationsObservesONDE_CValid = c(tab_moisAnnees_2012$NbStationsObservesONDE_CValid,
                                                                 tab_moisAnnees_2013$NbStationsObservesONDE_CValid,
                                                                 tab_moisAnnees_2014$NbStationsObservesONDE_CValid,
                                                                 tab_moisAnnees_2015$NbStationsObservesONDE_CValid,
                                                                 tab_moisAnnees_2016$NbStationsObservesONDE_CValid,
                                                                 tab_moisAnnees_2017$NbStationsObservesONDE_CValid,
                                                                 tab_moisAnnees_2018$NbStationsObservesONDE_CValid,
                                                                 tab_moisAnnees_2019$NbStationsObservesONDE_CValid,
                                                                 tab_moisAnnees_2020$NbStationsObservesONDE_CValid,
                                                                 tab_moisAnnees_2021$NbStationsObservesONDE_CValid,
                                                                 tab_moisAnnees_2022$NbStationsObservesONDE_CValid),
                               Id = c(paste0(tab_moisAnnees_2012$HER2,"_",month(as.Date(tab_moisAnnees_2012$Date)),"_",year(as.Date(tab_moisAnnees_2012$Date))),
                                      paste0(tab_moisAnnees_2013$HER2,"_",month(as.Date(tab_moisAnnees_2013$Date)),"_",year(as.Date(tab_moisAnnees_2013$Date))),
                                      paste0(tab_moisAnnees_2014$HER2,"_",month(as.Date(tab_moisAnnees_2014$Date)),"_",year(as.Date(tab_moisAnnees_2014$Date))),
                                      paste0(tab_moisAnnees_2015$HER2,"_",month(as.Date(tab_moisAnnees_2015$Date)),"_",year(as.Date(tab_moisAnnees_2015$Date))),
                                      paste0(tab_moisAnnees_2016$HER2,"_",month(as.Date(tab_moisAnnees_2016$Date)),"_",year(as.Date(tab_moisAnnees_2016$Date))),
                                      paste0(tab_moisAnnees_2017$HER2,"_",month(as.Date(tab_moisAnnees_2017$Date)),"_",year(as.Date(tab_moisAnnees_2017$Date))),
                                      paste0(tab_moisAnnees_2018$HER2,"_",month(as.Date(tab_moisAnnees_2018$Date)),"_",year(as.Date(tab_moisAnnees_2018$Date))),
                                      paste0(tab_moisAnnees_2019$HER2,"_",month(as.Date(tab_moisAnnees_2019$Date)),"_",year(as.Date(tab_moisAnnees_2019$Date))),
                                      paste0(tab_moisAnnees_2020$HER2,"_",month(as.Date(tab_moisAnnees_2020$Date)),"_",year(as.Date(tab_moisAnnees_2020$Date))),
                                      paste0(tab_moisAnnees_2021$HER2,"_",month(as.Date(tab_moisAnnees_2021$Date)),"_",year(as.Date(tab_moisAnnees_2021$Date))),
                                      paste0(tab_moisAnnees_2022$HER2,"_",month(as.Date(tab_moisAnnees_2022$Date)),"_",year(as.Date(tab_moisAnnees_2022$Date)))))

result_vector[which(!(result_vector %in% df_HER_nbObsMois_$Id))] # 4 campagnes sans observation : "24_5_2013" "22_9_2013" "22_5_2016" "22_6_2018"
resultat <- aggregate(NbStationsObservesONDE_CValid ~ HER2, data = df_HER_nbObsMois_, FUN = max)
merged_data <- merge(df_HER_nbObsMois_, resultat, by = "HER2", suffixes = c("", "_max"))

# Créez la colonne binaire
merged_data$Seuil = round(0.75 * merged_data$NbStationsObservesONDE_CValid_max)
merged_data$ColonneBinaire = ifelse(merged_data$NbStationsObservesONDE_CValid <= merged_data$Seuil, 1, 0)

merged_data$Annee =substr(merged_data$Id,nchar(merged_data$Id)-3,nchar(merged_data$Id))
merged_data$Mois =substr(merged_data$Id,nchar(merged_data$Id)-5,nchar(merged_data$Id)-5)

merged_data_excl = merged_data[which(merged_data$ColonneBinaire == 1),]
dim(merged_data_excl)


### Exclusions de campagnes ONDE ###
#Theoriquement 11 ans * 5 mois * 77 HER = 11*5*77 = 4235 campagnes
#4 campagnes sans aucun releve dans toute HER
#Pas de campagne octobre a enlever, elle n'est plus dedans de base. Le nombre de depart est 4231.
#75 campagnes qui n'avaient pas plus de 75% des sites avec des observations dim(merged_data_excl) = 4156
# Donc 1 campagne de plus de supprimee par rapport a avant.

dim(merged_data)

# 4232 (manque 4 campagnes sans releve, avec 1 campagne d'octobre en trop, devait etre complementaire)
# Sans les exclusions: dim(merged_data[which(merged_data$ColonneBinaire == 0),]) = 4157 = 4232-75. 
#La campagne d'octobre a saute automatiquement, dans les 75 exclusions

# Nouvelle version pour les HER2 55 et 37+54 : 6 exclusions
# "55_8_2013"
# "55_6_2016"
# "37054_6_2016"
# "55_7_2016"
# "37054_7_2016"
# "37054_8_2016"

# Ancienne version les HER2 54 et 37+55 : 5 exclusins
# "54_9_2016"      
# "54_8_2016"       
# "37055_8_2013"   
# "37055_7_2016"
# "37055_6_2016"

# 79 mais - 4 campagnes vides = 75 exclusions. 1 de plus a cause du groupement 55 37_54

excl_inventaire[which(!(excl_inventaire %in% excluRef_format))] #"24_5_2013" "22_9_2013" "22_5_2016" "22_6_2018"
excluRef_format[which(!(excluRef_format %in% excl_inventaire))] #38_10_2013





