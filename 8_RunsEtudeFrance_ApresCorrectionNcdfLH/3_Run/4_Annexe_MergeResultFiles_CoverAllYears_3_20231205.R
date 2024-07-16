### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run3.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")

source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run4.R")

# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunObs20122019.R")

# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Option0SafranCompletSeul_Run2.R")

### Libraries ###
library(dplyr)
library(stringr)
library(lubridate)

### Functions ###
detect_date_format <- function(date) {
  if (grepl("^\\d{4}-\\d{2}-\\d{2}$", date)) {
    return("ymd")
  } else if (grepl("^\\d{2}-\\d{2}-\\d{4}$", date)) {
    return("dmy")
  } else {
    return(NA)
  }
}

### Study data ###
folder_input_ = folder_input_param_
folder_output_ = folder_output_param_
folder_onde_ = folder_onde_param_
nom_GCM_ = nom_GCM_param_
nom_selectStations_ = nom_selectStations_param_
nom_categorieSimu_ = nom_categorieSimu_param_
HER_ = HER_param_
HER_variable_ = HER_variable_param_

obsSim_ = obsSim_param_
nomSim_ = nomSim_param_
# annees_learn_ = annees_learnModels_param_
annees_inputMatrice_ = annees_inputMatrice_param_

### Folders ###
files_ <-   list.files(paste0(folder_output_,
                              "1_MatricesInputModeles_ParHERDates/",
                              nomSim_,
                              ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                              ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                              "/tmp/"), full.names = T)
results_ <- data.frame()

for (f in files_){
  results_ <- rbind(results_, read.table(f, sep = ";", dec = ".", header = T))
}

# Gerer format de Date
date_formats <- sapply(results_$Date, detect_date_format)  # Appliquer la fonction pour détecter le format de chaque date
parsed_dates <- mapply(parse_date_time, results_$Date, date_formats, SIMPLIFY = FALSE)  # Convertir les dates en objets de type date en utilisant les formats détectés
formatted_dates <- lapply(parsed_dates, function(date) {  # Convertir toutes les dates au format "%Y-%m-%d"
  format(date, format = "%d-%m-%Y")
})
results_$Date <- unlist(formatted_dates)
results_$Date <- as.Date(results_$Date, format = "%d-%m-%Y")
results_ <- results_ %>%
  arrange(HER2, Date)
results_$Date <- format(results_$Date, "%Y-%m-%d")


# write.table(results_, paste0(folder_output_,"1_MatricesInputModeles_ParHERDates/",nomSim_,ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),"/MatInputModel_ByHERDates_",nom_GCM_,"_",as.character(min(annees_learn_)),"_",as.character(max(annees_learn_)),"_",str_replace_all(basename(il), 'Stations_HYDRO_|.csv', ''),"_",obsSim_,"_Weight_merge.csv"), sep=";", row.name=F, quote=F)
write.table(results_, paste0(folder_output_,
                             "1_MatricesInputModeles_ParHERDates/",
                             nomSim_,
                             ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                             ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                             "/MatInputModel_ByHERDates_",
                             # nom_GCM_,"_",as.character(min(annees_learn_)),"_",as.character(max(annees_learn_)),"_",obsSim_,"_Weight_merge.csv"), sep=";", row.name=F, quote=F)
                             as.character(min(annees_inputMatrice_)),"_",as.character(max(annees_inputMatrice_)),"_",obsSim_,"_Weight_merge.csv"), sep=";", row.name=F, quote=F)





# # orchi_ = read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/17_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrOubliHerJointes20212022etFonctionSeuilOnde_ValidParAnneesSecIntHum_2012_2022_20230614/MatInputModel_ByHERDates_2012_2022_Obs_Weight_20230614.csv",
# #                     sep = ",", dec = ".", header = T)
# # orchi_ = read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/23_ObservesReanalyseSafran_DriasEau_20231002/DebitsComplets_DebitsParModelesHydro_From20120101_To20221231/MatInputModel_ByHERDates_debit_Rhone-Loire_SAFRAN-France-2022_INRAE-J2000_day_19760801-20221231_2012_2022_ObservesReanalyseSafran_DriasEau_Weight_merge.csv",
# #                     sep = ";", dec = ".", header = T)
# orchi_ = read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/23_ObservesReanalyseSafran_DriasEau_20231002/DebitsComplets_DebitsParModelesHydro_From20120101_To20221231/MatInputModel_ByHERDates_debit_France_SAFRAN-France-2022_IPSL-ORCHIDEE_day_19760801-20190731_2012_2022_ObservesReanalyseSafran_DriasEau_Weight_merge.csv",
#                     sep = ";", dec = ".", header = T)
# combinations_out = paste0(orchi_$HER2,"_",year(orchi_$Date),"_",month(orchi_$Date))
# 
# # combinations_ONDE = paste0(ONDE$Annee,"_",ONDE$DtRealObservation)
# 
# 
# combinations = c()
# for (param in HER_param_[which(!(HER_param_ %in% c(18,19,20)))]) {
#   for (year in 2012:2022) {
#     for (number in 5:9) {
#       combinations <- c(combinations, paste0(param, "_", year, "_", number))
#     }
#   }
# }
# 
# combinations_out[which(!(combinations_out %in% combinations))] #38_2013_10 -> 1 campagne en trop qui sera retiree au filtre des campagnes incompletes
# combinations[which(!(combinations %in% combinations_out))] #22_2013_9, 22_2016_5, 22_2018_6, 24_2013_5 -> 4 campagnes sans donnees
# 
# unique(str_before_first(combinations[which(!(combinations %in% combinations_out))], "_")) #22_2013_9, 22_2016_5, 22_2018_6, 24_2013_5 -> 4 campagnes sans donnees


