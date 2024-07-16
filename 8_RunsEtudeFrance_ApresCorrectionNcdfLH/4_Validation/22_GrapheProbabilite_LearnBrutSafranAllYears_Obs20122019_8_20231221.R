source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunObs20122019.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunGraphe_Obs.R")

### Libraries ###
library(lubridate)

### Parameters ###
obsSim_ = obsSim_param_


chroniqueFDCbyHERweighted_obs_ = read.table(paste0(folder_input_DD_param_,"Tab_ChroniquesProba_LearnBrut_ByHer/",
                                                   ifelse(obsSim_=="",nom_GCM_param_,
                                                          paste0("FDC_",obsSim_param_,
                                                                 ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                                 ifelse(nom_categorieSimu_param_=="","",str_before_first(nom_categorieSimu_param_,"/")),"/",
                                                                 ifelse(nom_categorieSimu_param_=="","",paste0("Mod_",str_after_first(nom_categorieSimu_param_,"/"))),"/",
                                                                 ifelse(nom_GCM_param_=="","",paste0("Mod_",nom_GCM_param_)))),
                                                   "/Tab_ChroniquesProba_LearnBrut_ByHer.txt"), sep=";", header = T)
colnames(chroniqueFDCbyHERweighted_obs_)[!colnames(chroniqueFDCbyHERweighted_obs_) %in% c("Date", "Type")] <- gsub("X", "", colnames(chroniqueFDCbyHERweighted_obs_)[!colnames(chroniqueFDCbyHERweighted_obs_) %in% c("Date", "Type")])

### Table input ONDE ###
files_input_ <- list.files(paste0(folder_output_param_,
                                  "1_MatricesInputModeles_ParHERDates/",
                                  nomSim_param_,
                                  ifelse(nom_categorieSimu_param_=="","",paste0("/",nom_categorieSimu_param_)),
                                  ifelse(nom_GCM_param_=="","",paste0("/",nom_GCM_param_))), pattern = "MatInputModel_CampOndeExcl_ByHERDates_",
                           full.names = T)
tab_input_ <- read.table(files_input_, sep = ",", dec = ".", header = T)
if (ncol(tab_input_) == 1){
  tab_input_ <- read.table(files_input_, sep = ";", dec = ".", header = T)
}
tab_input_$Mois <- month(as.Date(tab_input_$Date))

### Projections ###
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunGraphe.R")

### Libraries ###
library(ggplot2)
library(ggrepel)
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

### Proba modele ###
chroniqueFDCbyHERweighted_ = read.table(paste0(folder_input_,"Tab_ChroniquesProba_LearnBrut_ByHer/",
                                               ifelse(obsSim_=="",nom_GCM_,
                                                      paste0("FDC_",obsSim_,
                                                             ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                             ifelse(nom_categorieSimu_=="","",str_before_first(nom_categorieSimu_,"/")),"/",
                                                             ifelse(nom_categorieSimu_=="","",paste0("Mod_",str_after_first(nom_categorieSimu_,"/"))),"/",
                                                             ifelse(nom_GCM_=="","",paste0("Mod_",nom_GCM_)))), #,"/ExtraitAnneesOnde20102023/"
                                               "/Tab_ChroniquesProba_LearnBrut_ByHer.txt"), sep=";", header = T)
colnames(chroniqueFDCbyHERweighted_)[!colnames(chroniqueFDCbyHERweighted_) %in% c("Date", "Type")] <- gsub("X", "", colnames(chroniqueFDCbyHERweighted_)[!colnames(chroniqueFDCbyHERweighted_) %in% c("Date", "Type")])
chroniqueFDCbyHERweighted_hist_ = chroniqueFDCbyHERweighted_[which(chroniqueFDCbyHERweighted_$Type == "Historical"),]
chroniqueFDCbyHERweighted_saf_ = chroniqueFDCbyHERweighted_[which(chroniqueFDCbyHERweighted_$Type == "Safran"),]
chroniqueFDCbyHERweighted_proj_ <- chroniqueFDCbyHERweighted_[which(grepl("rcp",chroniqueFDCbyHERweighted_$Type)),]


### Delimiter chroniques ###
for (HER_h_ in HER_){
  
  print(HER_h_)
  # HER_h_ = 59
  # HER_h_ = 40
  
  if (HER_h_ %in% colnames(chroniqueFDCbyHERweighted_saf_)){
    
    tab_input_h_ = tab_input_[which(tab_input_$HER2 == HER_h_),]
    # tab_input_h_[,c('Date','X._Assec')]
    
    # Calculer la moyenne pour chaque mois
    moyennes_mois <- tab_input_h_ %>%
      group_by(Mois) %>%
      summarise(Moyenne_X_Assec = mean(X._Assec))
    moyennes_mois$Date = as.Date(paste0("2022-",moyennes_mois$Mois,"-25"))
    all_dates = tab_input_h_
    all_dates$Date_2022 = as.Date(format(as.Date(all_dates$Date), "2022-%m-%d"))
    
    chro_safran_1976_2005_ = chroniqueFDCbyHERweighted_saf_[which(chroniqueFDCbyHERweighted_saf_$Date >= "1976-01-01" & chroniqueFDCbyHERweighted_saf_$Date <= "2005-12-31" & chroniqueFDCbyHERweighted_saf_$Type == "Safran"),]
    chro_rcp85_1976_2005_ = chroniqueFDCbyHERweighted_hist_[which(chroniqueFDCbyHERweighted_hist_$Date >= "1976-01-01" & chroniqueFDCbyHERweighted_hist_$Date <= "2005-12-31" & chroniqueFDCbyHERweighted_hist_$Type == "Historical"),]
    chro_rcp85_2071_2100_ = chroniqueFDCbyHERweighted_proj_[which(chroniqueFDCbyHERweighted_proj_$Date >= "2071-01-01" & chroniqueFDCbyHERweighted_proj_$Date <= "2100-12-31" & chroniqueFDCbyHERweighted_proj_$Type == "rcp85"),]
    chro_obs_2012_2022_ = chroniqueFDCbyHERweighted_obs_
    
    chro_safran_1976_2005_ <- chro_safran_1976_2005_[,c("Date",as.character(HER_h_))]
    chro_rcp85_1976_2005_ <- chro_rcp85_1976_2005_[,c("Date",as.character(HER_h_))]
    chro_rcp85_2071_2100_ <- chro_rcp85_2071_2100_[,c("Date",as.character(HER_h_))]
    chro_obs_2012_2022_ <- chro_obs_2012_2022_[,c("Date",as.character(HER_h_))]
    # chro_safran_1976_2005_ <- chro_safran_1976_2005_[,c("Date","2")]
    # chro_rcp85_1976_2005_ <- chro_rcp85_1976_2005_[,c("Date","2")]
    # chro_rcp85_2071_2100_ <- chro_rcp85_2071_2100_[,c("Date","2")]
    
    colnames(chro_safran_1976_2005_) = c("Date","Proba")
    colnames(chro_rcp85_1976_2005_) = c("Date","Proba")
    colnames(chro_rcp85_2071_2100_) = c("Date","Proba")
    colnames(chro_obs_2012_2022_) = c("Date","Proba")
    
    chro_safran_1976_2005_$Date <- as.Date(chro_safran_1976_2005_$Date)
    chro_safran_1976_2005_$Jour_annee <- format(chro_safran_1976_2005_$Date, format = "%m-%d")
    debit_moyen_par_jour_safran_1976_2005_ <- chro_safran_1976_2005_ %>%
      group_by(Jour_annee) %>%
      summarize(Proba_moyen = mean(Proba, na.rm = TRUE),
                Proba_Q5 = quantile(Proba, probs = 0.05, na.rm = TRUE),
                Proba_Q95 = quantile(Proba, probs = 0.95, na.rm = TRUE))
    
    chro_rcp85_1976_2005_$Date <- as.Date(chro_rcp85_1976_2005_$Date)
    chro_rcp85_1976_2005_$Jour_annee <- format(chro_rcp85_1976_2005_$Date, format = "%m-%d")
    debit_moyen_par_jour_rcp85_1976_2005_ <- chro_rcp85_1976_2005_ %>%
      group_by(Jour_annee) %>%
      summarize(Proba_moyen = mean(Proba, na.rm = TRUE),
                Proba_Q5 = quantile(Proba, probs = 0.05, na.rm = TRUE),
                Proba_Q95 = quantile(Proba, probs = 0.95, na.rm = TRUE))
    
    chro_rcp85_2071_2100_$Date <- as.Date(chro_rcp85_2071_2100_$Date)
    chro_rcp85_2071_2100_$Jour_annee <- format(chro_rcp85_2071_2100_$Date, format = "%m-%d")
    debit_moyen_par_jour_rcp85_2071_2100_ <- chro_rcp85_2071_2100_ %>%
      group_by(Jour_annee) %>%
      summarize(Proba_moyen = mean(Proba, na.rm = TRUE),
                Proba_Q5 = quantile(Proba, probs = 0.05, na.rm = TRUE),
                Proba_Q95 = quantile(Proba, probs = 0.95, na.rm = TRUE))
    
    chro_obs_2012_2022_$Date <- as.Date(chro_obs_2012_2022_$Date)
    chro_obs_2012_2022_$Jour_annee <- format(chro_obs_2012_2022_$Date, format = "%m-%d")
    debit_moyen_par_jour_obs_2012_2022_ <- chro_obs_2012_2022_ %>%
      group_by(Jour_annee) %>%
      summarize(Proba_moyen = mean(Proba, na.rm = TRUE),
                Proba_Q5 = quantile(Proba, probs = 0.05, na.rm = TRUE),
                Proba_Q95 = quantile(Proba, probs = 0.95, na.rm = TRUE))
    
    
    # Ajouter une colonne "Période" à chaque table
    debit_moyen_par_jour_safran_1976_2005_$Periode <- "Safran 1976 à 2005"
    debit_moyen_par_jour_rcp85_1976_2005_$Periode <- "RCP85 1976 à 2005"
    debit_moyen_par_jour_rcp85_2071_2100_$Periode <- "RCP85 2071 à 2100"
    debit_moyen_par_jour_obs_2012_2022_$Periode <- "Observé 2012 à 2022"
    
    # Fusionner les trois tables en une seule
    combined_data <- rbind(debit_moyen_par_jour_safran_1976_2005_,
                           debit_moyen_par_jour_rcp85_1976_2005_,
                           debit_moyen_par_jour_rcp85_2071_2100_,
                           debit_moyen_par_jour_obs_2012_2022_)
    
    
    combined_data[which(is.na(combined_data$Proba_moyen)),]
    # Remplacer les valeurs manquantes par des zéros
    # combined_data[is.na(combined_data)] <- 0
    
    combined_data_min_max_ <- combined_data[which(combined_data$Jour_annee %in% c("05-25","06-25","07-25","08-25","09-25")),]
    combined_data_min_max_$Date <- as.Date(paste0("2022-",combined_data_min_max_$Jour_annee))
    
    tab_input_h_[,c("HER2","Date","Mois","X._Assec")]
    tab_input_h_min_max_ <- tab_input_h_ %>%
      group_by(Mois) %>%
      summarize(Max_X_Assec = max(X._Assec),
                Min_X_Assec = min(X._Assec))
    tab_input_h_min_max_$Date = as.Date(paste0("2022-",tab_input_h_min_max_$Mois,"-25"))
    
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
    # x11()
    
    custom_colors <- c("Safran 1976 à 2005" = "#3182bd",
                       "RCP85 1976 à 2005" = "#fc9272",
                       "RCP85 2071 à 2100" = "#de2d26",
                       "Observé 2012 à 2022" = "#31a354")
    desired_order <- c("Observé 2012 à 2022", "Safran 1976 à 2005", "RCP85 1976 à 2005", "RCP85 2071 à 2100")
    combined_data$Periode <- factor(combined_data$Periode, levels = desired_order)
    
    p <- ggplot() +
      
      geom_line(data = combined_data, aes(x = Jour_annee, y = Proba_moyen, color = Periode, group = Periode), size = 1.5) +
      geom_point(data = combined_data_min_max_, aes(x = Date, y = Proba_Q5, color = Periode, group = Periode), size = 2, shape = 3) +
      geom_point(data = combined_data_min_max_, aes(x = Date, y = Proba_Q95, color = Periode, group = Periode), size = 2, shape = 3) +
      
      scale_color_manual(values = custom_colors) +  # Utilisation de la palette de couleurs personnalisée
      
      geom_point(data = first_days, aes(x = Jour_annee, y = Proba_moyen, color = Periode, group = Periode), size = 0) +
      scale_x_date(date_breaks = "1 month", date_labels = "%d-%b") +
      
      geom_point(data = moyennes_mois, aes(x = Date, y = Moyenne_X_Assec), color = "#252525", size = 3, shape = 16) +
      geom_point(data = tab_input_h_min_max_, aes(x = Date, y = Min_X_Assec), color = "#969696", size = 3, shape = 16) +
      geom_point(data = tab_input_h_min_max_, aes(x = Date, y = Max_X_Assec), color = "#969696", size = 3, shape = 16) +
      # geom_point(data = all_dates, aes(x = Date_2022, y = X._Assec), color = "blue", size = 3, shape = 16) +
      # geom_text_repel(data = all_dates, aes(label = format(as.Date(Date), "%m-%Y"), x = Date_2022, y = X._Assec), vjust = -1, hjust = 0, size = 3) +
      
      ylim(0,50) +
      theme_minimal() +
      theme(strip.text.x = element_blank(),
            strip.background = element_blank()) +
      labs(x = "Date", y = "Probabilité d'assec", color = "Période", title = paste0("HER ",HER_h_))
    # p
    
    if (!dir.exists(paste0(folder_output_,
                           "16_ChroniquesProbabilites_MoyennePeriodes/",
                           "27_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2019_20231221/",
                           # nomSim_,
                           ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                           ifelse(nom_GCM_=="","",paste0("/",nom_GCM_))))){
      dir.create(paste0(folder_output_,
                        "16_ChroniquesProbabilites_MoyennePeriodes/",
                        "27_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2019_20231221/",
                        # nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        ifelse(nom_GCM_=="","",paste0("/",nom_GCM_))))
    }
    if (!dir.exists(paste0(folder_output_,
                           "16_ChroniquesProbabilites_MoyennePeriodes/",
                           "27_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2019_20231221/",
                           # nomSim_,
                           ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                           ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                           ifelse(nom_apprentissage_param_=="","",paste0("/",nom_apprentissage_param_))))){
      dir.create(paste0(folder_output_,
                        "16_ChroniquesProbabilites_MoyennePeriodes/",
                        "27_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2019_20231221/",
                        # nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                        ifelse(nom_apprentissage_param_=="","",paste0("/",nom_apprentissage_param_))))
    }
    
    
    output_name_ <- paste0(folder_output_,
                           "16_ChroniquesProbabilites_MoyennePeriodes/",
                           "27_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2019_20231221/",
                           # nomSim_,
                           ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                           ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                           ifelse(nom_apprentissage_param_=="","",paste0("/",nom_apprentissage_param_)),
                           "/ChroniquesProba_HER",HER_h_,"_logit.pdf")
    
    pdf(output_name_,
        width = 8)
    print(p)
    dev.off()
    
    saveRDS(p, file = paste0(str_before_first(output_name_, ".pdf"),".rds"))
    
  }
}



# Une HER Nord, ouest, sud ouest, sud est, alpes, est
#Courbes avec d'autres indicateurs, courbes enveloppe, 

# Recoupement HER : quantifier le temps

# Voir le pourcentage de bassins versants sur lesquels approximation a partir des stations HYDRO d'origine
