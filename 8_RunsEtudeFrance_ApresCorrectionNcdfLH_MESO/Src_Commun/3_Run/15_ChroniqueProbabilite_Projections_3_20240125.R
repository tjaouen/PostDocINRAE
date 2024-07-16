source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")

### Libraries ###
library(strex)

### Study data ###
folder_input_ = folder_input_param_
folder_input_PC_ = folder_input_PC_param_
folder_output_ = folder_output_param_
folder_onde_ = folder_onde_param_
nom_GCM_ = nom_GCM_param_
nom_selectStations_ = nom_selectStations_param_
nom_categorieSimu_ = nom_categorieSimu_param_
nom_apprentissage_ = nom_apprentissage_param_
nom_validation_ = nom_validation_param_
HER_ = HER_param_
HER_variable_ = HER_variable_param_
# climatScenarioModeleHydro_ = climatScenarioModeleHydro_param_
jourMin_ = jourMin_param_
jourMax_ = jourMax_param_

obsSim_ = obsSim_param_
nomSim_ = nomSim_param_
# annees_learn_ = annees_learnModels_param_
# annees_inputMatrice_ = annees_inputMatrice_param_

liste <- list.files(paste0(folder_input_PC_,
                           "StationsSelectionnees/SelectionCsv/",
                           nom_selectStations_,"/",
                           ifelse(nom_GCM_=="","","TablesParModele_20231203/")),pattern="StationsHYDRO", full.names = T)
il = liste[grepl(str_after_last(str_before_first(nom_GCM_,"_day"),"-"), liste)]


chroniqueFDCbyHERweighted_hist_ <- read.table(paste0(folder_input_,"FlowDurationCurves_HERweighted_meanJm6Jj/",
                                                     ifelse(obsSim_=="",nom_GCM_,
                                                            paste0("FDC_",obsSim_,
                                                                   ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                                   "GRSD_20231128/ChroniquesBrutes_historical/Modele_ChroniquesCombinees_saf_rcp85_CNRM-CM5_CNRM-ALADIN63/",
                                                                   ifelse(nom_GCM_=="","",nom_GCM_))), #,"/ExtraitAnneesOnde20102023/"
                                                     "/Tab_FDCchroniquesByHER2weigthedFDC.txt"), sep=";", header = T)

chroniqueFDCbyHERweighted_proj_ <- read.table(paste0(folder_input_,"FlowDurationCurves_HERweighted_meanJm6Jj/",
                                                     ifelse(obsSim_=="",nom_GCM_,
                                                            paste0("FDC_",obsSim_,
                                                                   ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                                   "GRSD_20231128/ChroniquesBrutes_rcp85/Modele_ChroniquesCombinees_saf_rcp85_CNRM-CM5_CNRM-ALADIN63/",
                                                                   ifelse(nom_GCM_=="","",nom_GCM_))), #,"/ExtraitAnneesOnde20102023/"
                                                     "/Tab_FDCchroniquesByHER2weigthedFDC.txt"), sep=";", header = T)

chroniqueFDCbyHERweighted_saf_ <- read.table(paste0(folder_input_,"FlowDurationCurves_HERweighted_meanJm6Jj/",
                                                    ifelse(obsSim_=="",nom_GCM_,
                                                           paste0("FDC_",obsSim_,
                                                                  ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                                  "GRSD_20231128/ChroniquesCombinees_saf_rcp85/",
                                                                  ifelse(nom_GCM_=="","",nom_GCM_))), #,"/ExtraitAnneesOnde20102023/"
                                                    "/Tab_FDCchroniquesByHER2weigthedFDC.txt"), sep=";", header = T)


# "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/FlowDurationCurves_HERweighted_meanJm6Jj/FDC_Projections/GRSD_20231128/ChroniquesBrutes_historical/Modele_ChroniquesCombinees_saf_rcp85_CNRM-CM5_CNRM-ALADIN63/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/"
# "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/FlowDurationCurves_HERweighted_meanJm6Jj/FDC_Projections/GRSD_20231128/ChroniquesBrutes_rcp85/Modele_ChroniquesCombinees_saf_rcp85_CNRM-CM5_CNRM-ALADIN63/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/"
# "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/FlowDurationCurves_HERweighted_meanJm6Jj/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/"


chroniqueFDCbyHERweighted_hist_[, !colnames(chroniqueFDCbyHERweighted_hist_) %in% c("Date", "Type")]
colnames(chroniqueFDCbyHERweighted_hist_)[!colnames(chroniqueFDCbyHERweighted_hist_) %in% c("Date", "Type")] <- gsub("X", "", colnames(chroniqueFDCbyHERweighted_hist_)[!colnames(chroniqueFDCbyHERweighted_hist_) %in% c("Date", "Type")])

chroniqueFDCbyHERweighted_proj_[, !colnames(chroniqueFDCbyHERweighted_proj_) %in% c("Date", "Type")]
colnames(chroniqueFDCbyHERweighted_proj_)[!colnames(chroniqueFDCbyHERweighted_proj_) %in% c("Date", "Type")] <- gsub("X", "", colnames(chroniqueFDCbyHERweighted_proj_)[!colnames(chroniqueFDCbyHERweighted_proj_) %in% c("Date", "Type")])

chroniqueFDCbyHERweighted_saf_[, !colnames(chroniqueFDCbyHERweighted_saf_) %in% c("Date", "Type")]
colnames(chroniqueFDCbyHERweighted_saf_)[!colnames(chroniqueFDCbyHERweighted_saf_) %in% c("Date", "Type")] <- gsub("X", "", colnames(chroniqueFDCbyHERweighted_saf_)[!colnames(chroniqueFDCbyHERweighted_saf_) %in% c("Date", "Type")])

# read.table(paste0(folder_output_,
#                   "15_ResultatsModeles_ValidationParAnnees_ParHer/",
#                   nomSim_,
#                   ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
#                   ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
#                   ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
#                   ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
#                   "/TableGlobale/ModelResults_ParDate_",str_after_nth(str_before_last(basename(il), "\\."),"\\_",2),"_ValidGlobale_",
#                   "_J",ifelse(jourMin_ == 0,"j",paste0("m",jourMin_)),"J",ifelse(jourMax_ == 0,"j",paste0("m",jourMax_)),"_logit.csv"),
#             dec = ".", sep=";", row.name=F) #Pourquoi s'appelle validation ?

liste <- c(list.files(paste0(folder_output_,
                             "1_MatricesInputModeles_ParHERDates/",
                             nomSim_,
                             ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                             ifelse(nom_GCM_=="","",paste0("/",nom_GCM_))),
                      pattern="MatInputModel_CampOndeExcl", full.names = T))

if (nom_GCM_ != ""){
  il = liste[grepl(nom_GCM_,liste)]
}else{
  il = liste[1]
}

nom_apprentissage_ = "ApprentissageLeaveOneYearOut"
nom_validation_ = "Validation_2LeaveOneYearOut"
annees_validModels_ = ""
tab_modeles_ = read.table(paste0(folder_output_,
                                 "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                                 nomSim_,
                                 ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                 ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                                 ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                                 ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                                 "/TableGlobale/ModelResults_ParDate_",str_after_nth(str_before_last(basename(il), "\\."),"\\_",2),"_ValidGlobale_",paste(substr(annees_validModels_,3,4),collapse = "-"),
                                 "_J",ifelse(jourMin_ == 0,"j",paste0("m",jourMin_)),"J",ifelse(jourMax_ == 0,"j",paste0("m",jourMax_)),"_logit.csv"),
                          dec = ".", sep=";", header=T) #Pourquoi s'appelle validation ?



for (i in colnames(chroniqueFDCbyHERweighted_hist_)[3:length(chroniqueFDCbyHERweighted_hist_)]){
  tab_modeles_HER_ <- tab_modeles_[which(tab_modeles_$HER == i),]
  chroniqueFDCbyHERweighted_hist_[[as.character(i)]] = (exp(tab_modeles_HER_$Intercept_general+chroniqueFDCbyHERweighted_hist_[[as.character(i)]]*tab_modeles_HER_$Slope_general)/
                                                          (1+exp(tab_modeles_HER_$Intercept_general+chroniqueFDCbyHERweighted_hist_[[as.character(i)]]*tab_modeles_HER_$Slope_general)))*100
}
for (i in colnames(chroniqueFDCbyHERweighted_proj_)[3:length(chroniqueFDCbyHERweighted_proj_)]){
  tab_modeles_HER_ <- tab_modeles_[which(tab_modeles_$HER == i),]
  chroniqueFDCbyHERweighted_proj_[[as.character(i)]] = (exp(tab_modeles_HER_$Intercept_general+chroniqueFDCbyHERweighted_proj_[[as.character(i)]]*tab_modeles_HER_$Slope_general)/
                                                          (1+exp(tab_modeles_HER_$Intercept_general+chroniqueFDCbyHERweighted_proj_[[as.character(i)]]*tab_modeles_HER_$Slope_general)))*100
}
for (i in colnames(chroniqueFDCbyHERweighted_saf_)[3:length(chroniqueFDCbyHERweighted_saf_)]){
  tab_modeles_HER_ <- tab_modeles_[which(tab_modeles_$HER == i),]
  chroniqueFDCbyHERweighted_saf_[[as.character(i)]] = (exp(tab_modeles_HER_$Intercept_general+chroniqueFDCbyHERweighted_saf_[[as.character(i)]]*tab_modeles_HER_$Slope_general)/
                                                         (1+exp(tab_modeles_HER_$Intercept_general+chroniqueFDCbyHERweighted_saf_[[as.character(i)]]*tab_modeles_HER_$Slope_general)))*100
}



if (!(dir.exists(paste0(folder_input_,"Tab_ChroniquesProba_ByHer/",
                        ifelse(obsSim_=="",nom_GCM_,
                               paste0("FDC_",obsSim_,
                                      ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                      "ChroniquesBrutes_rcp85/Modele_ChroniquesCombinees_saf_rcp85_CNRM-CM5_CNRM-ALADIN63/",
                                      ifelse(nom_GCM_=="","",nom_GCM_))))))){
  dir.create(paste0(folder_input_,"Tab_ChroniquesProba_ByHer/",
                    ifelse(obsSim_=="",nom_GCM_,
                           paste0("FDC_",obsSim_,
                                  ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                  "ChroniquesBrutes_rcp85/Modele_ChroniquesCombinees_saf_rcp85_CNRM-CM5_CNRM-ALADIN63/",
                                  ifelse(nom_GCM_=="","",nom_GCM_)))))}

write.table(chroniqueFDCbyHERweighted_, paste0(folder_input_,"Tab_ChroniquesProba_ByHer/",
                                               ifelse(obsSim_=="",nom_GCM_,
                                                      paste0("FDC_",obsSim_,
                                                             ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                             "ChroniquesBrutes_rcp85/Modele_ChroniquesCombinees_saf_rcp85_CNRM-CM5_CNRM-ALADIN63/",
                                                             ifelse(nom_GCM_=="","",nom_GCM_))), #,"/ExtraitAnneesOnde20102023/"
                                               "/Tab_ChroniquesProba_ByHer.txt"), sep=";", row.name=F, quote=F)

library(ggplot2)
library(dplyr)


chro_safran_1976_2005_ = chroniqueFDCbyHERweighted_saf_[which(chroniqueFDCbyHERweighted_saf_$Date >= "1976-01-01" & chroniqueFDCbyHERweighted_saf_$Date <= "2005-12-31" & chroniqueFDCbyHERweighted_saf_$Type == "Safran"),]
chro_rcp85_1976_2005_ = chroniqueFDCbyHERweighted_hist_[which(chroniqueFDCbyHERweighted_hist_$Date >= "1976-01-01" & chroniqueFDCbyHERweighted_hist_$Date <= "2005-12-31" & chroniqueFDCbyHERweighted_hist_$Type == "Historical"),]
chro_rcp85_2071_2100_ = chroniqueFDCbyHERweighted_proj_[which(chroniqueFDCbyHERweighted_proj_$Date >= "2071-01-01" & chroniqueFDCbyHERweighted_proj_$Date <= "2100-12-31" & chroniqueFDCbyHERweighted_proj_$Type == "rcp85"),]

chro_safran_1976_2005_ <- chro_safran_1976_2005_[,c("Date","59")]
chro_rcp85_1976_2005_ <- chro_rcp85_1976_2005_[,c("Date","59")]
chro_rcp85_2071_2100_ <- chro_rcp85_2071_2100_[,c("Date","59")]
# chro_safran_1976_2005_ <- chro_safran_1976_2005_[,c("Date","2")]
# chro_rcp85_1976_2005_ <- chro_rcp85_1976_2005_[,c("Date","2")]
# chro_rcp85_2071_2100_ <- chro_rcp85_2071_2100_[,c("Date","2")]

colnames(chro_safran_1976_2005_) = c("Date","Proba")
colnames(chro_rcp85_1976_2005_) = c("Date","Proba")
colnames(chro_rcp85_2071_2100_) = c("Date","Proba")



chro_safran_1976_2005_$Date <- as.Date(chro_safran_1976_2005_$Date)
chro_safran_1976_2005_$Jour_annee <- format(chro_safran_1976_2005_$Date, format = "%m-%d")
debit_moyen_par_jour_safran_1976_2005_ <- chro_safran_1976_2005_ %>%
  group_by(Jour_annee) %>%
  summarize(Debit_moyen = mean(Proba, na.rm = TRUE))

chro_rcp85_1976_2005_$Date <- as.Date(chro_rcp85_1976_2005_$Date)
chro_rcp85_1976_2005_$Jour_annee <- format(chro_rcp85_1976_2005_$Date, format = "%m-%d")
debit_moyen_par_jour_rcp85_1976_2005_ <- chro_rcp85_1976_2005_ %>%
  group_by(Jour_annee) %>%
  summarize(Debit_moyen = mean(Proba, na.rm = TRUE))

chro_rcp85_2071_2100_$Date <- as.Date(chro_rcp85_2071_2100_$Date)
chro_rcp85_2071_2100_$Jour_annee <- format(chro_rcp85_2071_2100_$Date, format = "%m-%d")
debit_moyen_par_jour_rcp85_2071_2100_ <- chro_rcp85_2071_2100_ %>%
  group_by(Jour_annee) %>%
  summarize(Debit_moyen = mean(Proba, na.rm = TRUE))


# Ajouter une colonne "Période" à chaque table
debit_moyen_par_jour_safran_1976_2005_$Periode <- "Safran 1976 à 2005"
debit_moyen_par_jour_rcp85_1976_2005_$Periode <- "RCP85 1976 à 2005"
debit_moyen_par_jour_rcp85_2071_2100_$Periode <- "RCP85 2071 à 2100"

# Fusionner les trois tables en une seule
combined_data <- rbind(debit_moyen_par_jour_safran_1976_2005_,
                       debit_moyen_par_jour_rcp85_1976_2005_,
                       debit_moyen_par_jour_rcp85_2071_2100_)



# Remplacer les valeurs manquantes par des zéros
combined_data[is.na(combined_data)] <- 0


library(ggplot2)
library(dplyr)

# # Créer une colonne pour le mois
# combined_data <- combined_data %>%
#   mutate(Mois = format(Jour_annee, "%m"))

# Supposons que "combined_data" est votre jeu de données avec une colonne "Jour_annee" au format "MM-DD" et une colonne "Debit_moyen"

# Convertir Jour_annee au format de date en ajoutant une année fixe (par exemple, 2022)
combined_data$Jour_annee <- as.Date(paste0("2022-", combined_data$Jour_annee), format = "%Y-%m-%d")

# Création d'une colonne pour extraire le jour de chaque date
combined_data$Jour <- as.numeric(format(combined_data$Jour_annee, "%d"))

# Filtrer les données pour obtenir uniquement le premier jour de chaque mois
first_days <- combined_data %>% filter(Jour == 1)

# Création du graphique avec deux facettes : une pour tous les jours et une autre pour le premier jour de chaque mois
x11()

p <- ggplot() +
  geom_line(data = combined_data, aes(x = Jour_annee, y = Debit_moyen, color = Periode, group = Periode)) +
  geom_point(data = first_days, aes(x = Jour_annee, y = Debit_moyen, color = Periode, group = Periode), size = 0) +
  scale_x_date(date_breaks = "1 month", date_labels = "%d-%b") +
  # facet_grid(. ~ Jour) +
  theme(strip.text.x = element_blank(), strip.background = element_blank()) +
  labs(x = "Date", y = "Valeurs", color = "Période", title = "Courbes pour chaque jour avec légende pour le 1er de chaque mois")
# ggsave(p, "/home/tjaouen/Documents/GrapheChro_1_20231208.pdf")
ggsave("/home/tjaouen/Documents/GrapheChro_1_20231208.pdf", plot = p, width = 6, height = 4)


