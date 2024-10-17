source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunGraphe.R")

### Libraries ###
library(ggplot2)
library(strex)
library(dplyr)

### Study data ###
folder_input_ = folder_input_param_
folder_input_PC_ = folder_input_PC_param_
folder_output_ = folder_output_param_
folder_onde_ = folder_onde_param_
nom_GCM_ = nom_GCM_param_
nom_selectStations_ = nom_selectStations_param_
nom_categorieSimu_ = nom_categorieSimu_param_
HER_ = HER_param_
HER_variable_ = HER_variable_param_
jourMin_ = jourMin_param_
jourMax_ = jourMax_param_
obsSim_ = obsSim_param_
nomSim_ = nomSim_param_
nom_apprentissage_ = "ApprentissageGlobalModelesBruts"
nom_validation_ = ""
annees_validModels_ = ""

# liste <- list.files(paste0(folder_input_PC_,
#                            "StationsSelectionnees/SelectionCsv/",
#                            nom_selectStations_,"/",
#                            ifelse(nom_GCM_=="","","TablesParModele_20231203/")),pattern="StationsHYDRO", full.names = T)
# il = liste[grepl(str_after_last(str_before_first(nom_GCM_,"_day"),"-"), liste)]

### Chroniques ###
chroniqueFDCbyHERweighted_ <- read.table(paste0(folder_input_,"FlowDurationCurves_HERweighted_meanJm6Jj/",
                                                ifelse(obsSim_=="",nom_GCM_,
                                                       paste0("FDC_",obsSim_,
                                                              ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                              ifelse(nom_categorieSimu_param_=="","",str_before_first(nom_categorieSimu_param_,"/")),"/",
                                                              "ChroniquesCombinees_saf_hist_rcp85/",
                                                              ifelse(nom_GCM_=="","",nom_GCM_))), #,"/ExtraitAnneesOnde20102023/"
                                                "/Tab_FDCchroniquesByHER2weigthedFDC.txt"), sep=";", header = T)

chroniqueFDCbyHERweighted_hist_ <- chroniqueFDCbyHERweighted_[which(chroniqueFDCbyHERweighted_$Type == "Historical"),]
chroniqueFDCbyHERweighted_proj_ <- chroniqueFDCbyHERweighted_[which(grepl("rcp",chroniqueFDCbyHERweighted_$Type)),]
chroniqueFDCbyHERweighted_saf_ <- chroniqueFDCbyHERweighted_[which(chroniqueFDCbyHERweighted_$Type == "Safran"),]
dim(chroniqueFDCbyHERweighted_hist_) # 19724
dim(chroniqueFDCbyHERweighted_proj_) # 34698
dim(chroniqueFDCbyHERweighted_saf_) # 16437

chroniqueFDCbyHERweighted_hist_[, !colnames(chroniqueFDCbyHERweighted_hist_) %in% c("Date", "Type")]
colnames(chroniqueFDCbyHERweighted_hist_)[!colnames(chroniqueFDCbyHERweighted_hist_) %in% c("Date", "Type")] <- gsub("X", "", colnames(chroniqueFDCbyHERweighted_hist_)[!colnames(chroniqueFDCbyHERweighted_hist_) %in% c("Date", "Type")])

chroniqueFDCbyHERweighted_proj_[, !colnames(chroniqueFDCbyHERweighted_proj_) %in% c("Date", "Type")]
colnames(chroniqueFDCbyHERweighted_proj_)[!colnames(chroniqueFDCbyHERweighted_proj_) %in% c("Date", "Type")] <- gsub("X", "", colnames(chroniqueFDCbyHERweighted_proj_)[!colnames(chroniqueFDCbyHERweighted_proj_) %in% c("Date", "Type")])

chroniqueFDCbyHERweighted_saf_[, !colnames(chroniqueFDCbyHERweighted_saf_) %in% c("Date", "Type")]
colnames(chroniqueFDCbyHERweighted_saf_)[!colnames(chroniqueFDCbyHERweighted_saf_) %in% c("Date", "Type")] <- gsub("X", "", colnames(chroniqueFDCbyHERweighted_saf_)[!colnames(chroniqueFDCbyHERweighted_saf_) %in% c("Date", "Type")])

### Table input ###
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
tab_input_ = read.table(il, dec = ".", sep = ";", header = T)
tab_input_$Mois <- format(as.Date(tab_input_$Date), "%m")

### Table Modele ###
tab_modeles_ = read.table(list.files(paste0(folder_output_,
                                            "2_ResultatsModeles_ParHer/",
                                            nomSim_,
                                            ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                            ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                                            ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                                            ifelse(nom_validation_=="","",paste0("/",nom_validation_))),
                                     pattern = "logit", full.names = T),
                          dec = ".", sep = ";", header = T)

### Probability ###
for (i in colnames(chroniqueFDCbyHERweighted_hist_)[3:length(chroniqueFDCbyHERweighted_hist_)]){
  tab_modeles_HER_ <- tab_modeles_[which(tab_modeles_$HER == as.numeric(i)),]
  chroniqueFDCbyHERweighted_hist_[[as.character(i)]] = (exp(tab_modeles_HER_$Inter_logit_Learn+chroniqueFDCbyHERweighted_hist_[[as.character(i)]]*tab_modeles_HER_$Slope_logit_Learn)/
                                                          (1+exp(tab_modeles_HER_$Inter_logit_Learn+chroniqueFDCbyHERweighted_hist_[[as.character(i)]]*tab_modeles_HER_$Slope_logit_Learn)))*100
  # chroniqueFDCbyHERweighted_hist_[[as.character(i)]] = (exp(tab_modeles_HER_$Inter_logit_Learn+chroniqueFDCbyHERweighted_hist_[[as.character(i)]]*tab_modeles_HER_$Slope_logit_Learn)/
  #                                                         (1+exp(tab_modeles_HER_$Inter_logit_Learn+chroniqueFDCbyHERweighted_hist_[[as.character(i)]]*tab_modeles_HER_$Slope_logit_Learn)))*100
}
for (i in colnames(chroniqueFDCbyHERweighted_proj_)[3:length(chroniqueFDCbyHERweighted_proj_)]){
  tab_modeles_HER_ <- tab_modeles_[which(tab_modeles_$HER == i),]
  chroniqueFDCbyHERweighted_proj_[[as.character(i)]] = (exp(tab_modeles_HER_$Inter_logit_Learn+chroniqueFDCbyHERweighted_proj_[[as.character(i)]]*tab_modeles_HER_$Slope_logit_Learn)/
                                                          (1+exp(tab_modeles_HER_$Inter_logit_Learn+chroniqueFDCbyHERweighted_proj_[[as.character(i)]]*tab_modeles_HER_$Slope_logit_Learn)))*100
}
for (i in colnames(chroniqueFDCbyHERweighted_saf_)[3:length(chroniqueFDCbyHERweighted_saf_)]){
  tab_modeles_HER_ <- tab_modeles_[which(tab_modeles_$HER == i),]
  chroniqueFDCbyHERweighted_saf_[[as.character(i)]] = (exp(tab_modeles_HER_$Inter_logit_Learn+chroniqueFDCbyHERweighted_saf_[[as.character(i)]]*tab_modeles_HER_$Slope_logit_Learn)/
                                                         (1+exp(tab_modeles_HER_$Inter_logit_Learn+chroniqueFDCbyHERweighted_saf_[[as.character(i)]]*tab_modeles_HER_$Slope_logit_Learn)))*100
}


if (!(dir.exists(paste0(folder_input_,"Tab_ChroniquesProba_LearnBrut_ByHer/",
                        ifelse(obsSim_=="",nom_GCM_,
                               paste0("FDC_",obsSim_,
                                      ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                      ifelse(nom_categorieSimu_=="","",str_before_first(nom_categorieSimu_,"/")),"/",
                                      ifelse(nom_categorieSimu_=="","",paste0("Mod_",str_after_first(nom_categorieSimu_,"/"))),"/",
                                      ifelse(nom_GCM_=="","",paste0("Mod_",nom_GCM_)),"/")))))){
  dir.create(paste0(folder_input_,"Tab_ChroniquesProba_LearnBrut_ByHer/",
                    ifelse(obsSim_=="",nom_GCM_,
                           paste0("FDC_",obsSim_,
                                  ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                  ifelse(nom_categorieSimu_=="","",str_before_first(nom_categorieSimu_,"/")),"/",
                                  ifelse(nom_categorieSimu_=="","",paste0("Mod_",str_after_first(nom_categorieSimu_,"/"))),"/",
                                  ifelse(nom_GCM_=="","",paste0("Mod_",nom_GCM_)),"/"))))}

write.table(chroniqueFDCbyHERweighted_, paste0(folder_input_,"Tab_ChroniquesProba_LearnBrut_ByHer/",
                                               ifelse(obsSim_=="",nom_GCM_,
                                                      paste0("FDC_",obsSim_,
                                                             ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                             ifelse(nom_categorieSimu_=="","",str_before_first(nom_categorieSimu_,"/")),"/",
                                                             ifelse(nom_categorieSimu_=="","",paste0("Mod_",str_after_first(nom_categorieSimu_,"/"))),"/",
                                                             ifelse(nom_GCM_=="","",paste0("Mod_",nom_GCM_)))), #,"/ExtraitAnneesOnde20102023/"
                                               "/Tab_ChroniquesProba_LearnBrut_ByHer.txt"), sep=";", row.name=F, quote=F)


### Delimiter chroniques ###
HER_h_ = 59

tab_input_h_ = tab_input_[which(tab_input_$HER2 == HER_h_),]
tab_input_h_[,c('Date','X._Assec')]

# Calculer la moyenne pour chaque mois
moyennes_mois <- tab_input_h_ %>%
  group_by(Mois) %>%
  summarise(Moyenne_X_Assec = mean(X._Assec))
moyennes_mois$Date = as.Date(paste0("2022-",moyennes_mois$Mois,"-25"))

chro_safran_1976_2005_ = chroniqueFDCbyHERweighted_saf_[which(chroniqueFDCbyHERweighted_saf_$Date >= "1976-01-01" & chroniqueFDCbyHERweighted_saf_$Date <= "2005-12-31" & chroniqueFDCbyHERweighted_saf_$Type == "Safran"),]
chro_rcp85_1976_2005_ = chroniqueFDCbyHERweighted_hist_[which(chroniqueFDCbyHERweighted_hist_$Date >= "1976-01-01" & chroniqueFDCbyHERweighted_hist_$Date <= "2005-12-31" & chroniqueFDCbyHERweighted_hist_$Type == "Historical"),]
chro_rcp85_2071_2100_ = chroniqueFDCbyHERweighted_proj_[which(chroniqueFDCbyHERweighted_proj_$Date >= "2071-01-01" & chroniqueFDCbyHERweighted_proj_$Date <= "2100-12-31" & chroniqueFDCbyHERweighted_proj_$Type == "rcp85"),]

chro_safran_1976_2005_ <- chro_safran_1976_2005_[,c("Date",as.character(HER_h_))]
chro_rcp85_1976_2005_ <- chro_rcp85_1976_2005_[,c("Date",as.character(HER_h_))]
chro_rcp85_2071_2100_ <- chro_rcp85_2071_2100_[,c("Date",as.character(HER_h_))]
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
  geom_point(data = moyennes_mois, aes(x = Date, y = Moyenne_X_Assec), color = "red", size = 3, shape = 16) +
  # facet_grid(. ~ Jour) +
  theme(strip.text.x = element_blank(), strip.background = element_blank()) +
  labs(x = "Date", y = "Valeurs", color = "Période", title = "Courbes pour chaque jour avec légende pour le 1er de chaque mois")
p
# ggsave(p, "/home/tjaouen/Documents/GrapheChro_1_20231208.pdf")
ggsave("/home/tjaouen/Documents/GrapheChro_1_20231208.pdf", plot = p, width = 6, height = 4)


