source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
library(lubridate)
library(ggplot2)
library(ggrepel)
library(strex)
library(dplyr)

### Observe ###
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunObs20122019.R")
chroniqueFDCbyHERweighted_obs_ = read.table(paste0(folder_input_DD_param_,"Tab_ChroniquesProba_LearnBrut_ByHer/",
                                                   ifelse(obsSim_param_=="",nom_GCM_param_,
                                                          paste0("FDC_",obsSim_param_,
                                                                 ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                                 ifelse(nom_categorieSimu_param_=="","",str_before_first(nom_categorieSimu_param_,"/")),"/",
                                                                 ifelse(nom_categorieSimu_param_=="","",paste0("Mod_",str_after_first(nom_categorieSimu_param_,"/"))),"/",
                                                                 ifelse(nom_GCM_param_=="","",paste0("Mod_",nom_GCM_param_)))),
                                                   "/Tab_ChroniquesProba_LearnBrut_ByHer.txt"), sep=";", header = T)
colnames(chroniqueFDCbyHERweighted_obs_)[!colnames(chroniqueFDCbyHERweighted_obs_) %in% c("Date", "Type")] <- gsub("X", "", colnames(chroniqueFDCbyHERweighted_obs_)[!colnames(chroniqueFDCbyHERweighted_obs_) %in% c("Date", "Type")])
tab_obs_ = chroniqueFDCbyHERweighted_obs_

### Modele run ###
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R") # Un seul suffit

HER_ = HER_param_
folder_output_ = folder_output_param_
nomSim_ = nomSim_param_
nom_categorieSimu_ = nom_categorieSimu_param_
nom_GCM_ = nom_GCM_param_
nom_apprentissage_ = nom_apprentissage_param_

date_min_past = "2012-01-01"
date_max_past = "2022-12-31"
# date_min_ = "2012-01-01"
# date_max_ = "2019-12-31"
date_min_fut = "2012-01-01"
date_max_fut = "2022-12-31"

data.frame(type = c("Obs","Safran","Hist","rcp85"),
           data_min = c(date_min_past))

### Table input ONDE ###
files_input_ <- list.files(paste0(folder_output_,
                                  "1_MatricesInputModeles_ParHERDates/",
                                  nomSim_param_,
                                  ifelse(nom_categorieSimu_param_=="","",paste0("/",nom_categorieSimu_param_)),
                                  ifelse(nom_GCM_param_=="","",paste0("/",nom_GCM_param_))), pattern = "MatInputModel_CampOndeExcl_ByHERDates_",
                           full.names = T)
tab_input_ <- read.table(files_input_, sep = ";", dec = ".", header = T)
tab_input_$Mois <- month(as.Date(tab_input_$Date))

### Table Output ###
files_output_ <- list.files(paste0(folder_output_,
                                   "2_ResultatsModeles_ParHer/",
                                   nomSim_param_,
                                   ifelse(nom_categorieSimu_param_=="","",paste0("/",nom_categorieSimu_param_)),
                                   ifelse(nom_GCM_param_=="","",paste0("/",nom_GCM_param_)),
                                   "/ApprentissageGlobalModelesBruts/"), pattern = "logit",
                            full.names = T)
tab_output_ <- read.table(files_output_, sep = ";", dec = ".", header = T)


### Projections ###
list_HM_saf_hist_rcp85_ = list.files(paste0(folder_input_param_,"Tab_ChroniquesProba_LearnBrut_ByHer/",
                                            ifelse(obsSim_param_=="",nom_GCM_param_,
                                                   paste0("FDC_",obsSim_param_,
                                                          ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                          ifelse(nom_categorieSimu_param_=="","",str_before_first(nom_categorieSimu_param_,"/")),"/Mod_ChroniquesCombinees_saf_hist_rcp85/"))), recursive = T, full.names = T)
list_HM_saf_rcp85_ = list.files(paste0(folder_input_param_,"Tab_ChroniquesProba_LearnBrut_ByHer/",
                                       ifelse(obsSim_param_=="",nom_GCM_param_,
                                              paste0("FDC_",obsSim_param_,
                                                     ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                     ifelse(nom_categorieSimu_param_=="","",str_before_first(nom_categorieSimu_param_,"/")),"/Mod_ChroniquesCombinees_saf_rcp85/"))), recursive = T, full.names = T)


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
                                      "Mod_HadGEM2_ALADIN63_saf_rcp85__Data_HadGEM2_ALADIN63"))
# ind_ = 1
# HER_h_=3

for (ind_ in 1:8){
  
  tab_ = read.table(dat_modelsRL_$liste_fichiers[ind_], sep=";", header = T)
  colnames(tab_) <- sub("^X", "", colnames(tab_))
  
  tab_saf_ = tab_[which(tab_$Type == "Safran" & tab_$Date >= date_min_past & tab_$Date <= date_max_past),]
  tab_hist_ = tab_[which(tab_$Type == "Historical" & tab_$Date >= min(tab_saf_$Date) & tab_$Date <= max(tab_saf_$Date)),]
  tab_rcp_ = tab_[which(tab_$Type == "rcp85" & tab_$Date >= min(tab_saf_$Date) & tab_$Date <= max(tab_saf_$Date)),]
  tab_obs_ = tab_obs_[which(tab_obs_$Type == "Observes" & tab_obs_$Date >= min(tab_saf_$Date) & tab_obs_$Date <= max(tab_saf_$Date)),]
  tab_input_ = tab_input_[which(tab_input_$Date >= min(tab_saf_$Date) & tab_input_$Date <= max(tab_saf_$Date)),]
  
  for (HER_h_ in HER_){
    if (HER_h_ %in% colnames(tab_saf_)){

      chro_obs_ <- tab_obs_[,c("Date",as.character(HER_h_))]
      chro_saf_ <- tab_saf_[,c("Date",as.character(HER_h_))]
      # chro_hist_ <- tab_hist_[,c("Date",as.character(HER_h_))]
      chro_rcp_ <- tab_rcp_[,c("Date",as.character(HER_h_))]
    
      tab_input_h_ = tab_input_[which(tab_input_$HER2 == HER_h_),]
        
      colnames(chro_obs_) = c("Date","Proba")
      colnames(chro_saf_) = c("Date","Proba")
      colnames(chro_rcp_) = c("Date","Proba")
      
      chro_obs_$Periode <- "Observes"
      chro_saf_$Periode <- "Safran"
      # chro_hist_$Periode <- "Historical"
      chro_rcp_$Periode <- "rcp85"
      
      combined_data = rbind(chro_obs_,
                            chro_saf_,
                            # chro_hist_,
                            chro_rcp_)
      
      combined_data <- combined_data %>%
        group_by(Periode) %>%
        mutate(ProbaLissee = (lag(Proba, 2) + lag(Proba, 1) + Proba + lead(Proba, 1) + lead(Proba, 2)) / 5)
      
      custom_colors <- c("Observes" = "#2ca25f",
                         "Safran" = "#2b8cbe",
                         # "Historical" = "#fc9272",
                         "rcp85" = "#cb181d")
      desired_order <- c("Observes",
                         "Safran",
                         # "Historical",
                         "rcp85")
      labels_ <- c(paste0("Observed ",year(min(chro_obs_$Date)),"/",year(max(chro_obs_$Date))),
                   paste0("Safran ",year(min(chro_saf_$Date)),"/",year(max(chro_saf_$Date))),
                   paste0("RCP 8.5 ",year(min(chro_rcp_$Date)),"/",year(max(chro_rcp_$Date))))
      combined_data$Periode <- factor(combined_data$Periode, levels = desired_order)
      
      combined_data$Jour <- as.numeric(format(as.Date(combined_data$Date), "%d"))
      first_days <- combined_data %>% filter(Jour == 1)
      
      combined_data$Date <- as.Date(combined_data$Date, format = "%Y-%m-%d")
      first_days$Date <- as.Date(first_days$Date, format = "%Y-%m-%d")
      tab_input_h_$Date <- as.Date(tab_input_h_$Date, format = "%Y-%m-%d")
      
      p <- ggplot() +
        
        # geom_smooth(data = combined_data, aes(x = Date, y = Proba, color = Periode, group = Periode), size = 1, method = "loess", span = 0.0001) +  # Ajouter la courbe lissée
        geom_line(data = combined_data, aes(x = Date, y = ProbaLissee, color = Periode, group = Periode), size = 0.3) +
        # geom_line(data = combined_data, aes(x = Date, y = Proba, color = Periode, group = Periode), size = 0.3) +
        scale_color_manual(values = custom_colors,
                           labels = labels_) +  # Utilisation de la palette de couleurs personnalisée
        
        geom_point(data = first_days, aes(x = Date, y = ProbaLissee, color = Periode, group = Periode), size = 0, ahpha = 0) +
        # geom_point(data = first_days, aes(x = Date, y = Proba, color = Periode, group = Periode), size = 0) +
        scale_x_date(date_breaks = "1 month", date_labels = "%b-%Y") +
        
        geom_point(data = tab_input_h_, aes(x = Date, y = X._Assec), color = "#252525", size = 3, shape = 16) +
        ylim(0,max(na.omit(combined_data$Proba))*1.05) +
        theme_minimal() +
        theme(strip.text.x = element_blank(),
              strip.background = element_blank(),
              axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+#,
        guides(color = guide_legend(override.aes = list(lwd=2.5))) +
              # legend.position = "bottom",
              # legend.box = "horizontal",
              # legend.direction = "horizontal") +
        # guides(color = guide_legend(legend.position = "bottom",  # Position de la légende
        #                             legend.box = "horizontal",   # Disposition horizontale (en deux colonnes)
        #                             legend.direction = "horizontal",  # Direction horizontale
        #                             ncol = 2, byrow = TRUE))+
        
        # labs(x = "Date", y = "Drying probability (%)", color = "Data", title = paste0("Hydrological model: ",str_before_first(nom_categorieSimu_,"_"),
        #                                                                               "\nFDC concatenation: ", str_before_first(str_after_first(nom_categorieSimu_,"/"),"/"),
        #                                                                               "\nModel: ",nom_GCM_,
        #                                                                               "\nHER ",HER_h_))

      labs(x = "Date", y = "Drying probability (%)", color = "Data", title = paste0("Hydrological model: ",str_before_first(nom_categorieSimu_,"_"),
                                                                                    "\nFDC concatenation: ", gsub(pattern = "Mod_", replacement = "", str_after_last(str_before_first(dat_modelsRL_$liste_fichiers[ind_],"//"),"/")),
                                                                                    "\nModel: ", gsub(pattern = "Mod_", replacement = "", str_after_last(str_before_last(dat_modelsRL_$liste_fichiers[ind_], "/"),"/")),
                                                                                    "\nHER ",HER_h_))
      
      
      
      
      # p
      # colors <- c("#2ca25f", "#2b8cbe", "#fc9272", "#cb181d")
      
      
      # tab_HER_filtered <- tab_HER_ %>%
      #   filter(Date >= as.Date("2012-01-01") & Date <= as.Date("2019-12-31"))
      
      # Créer le graphique ggplot
      # x11()
      # p <- ggplot(tab_HER_filtered, aes(x = Date, y = Proba, color = Type, group = Type)) +
      #   geom_line() +
      #   scale_color_manual(values = custom_colors) +  # Utilisation de la palette de couleurs personnalisée
      #   
      #   labs(title = "Courbes pour les chroniques de types différents",
      #        x = "Date",
      #        y = "Valeur") +
      #   theme_minimal()
      
      # if (!dir.exists(paste0(folder_output_,
      #                        "21_GrapheChroniqueProbabilite_Onemodel_ComparaisonTypesOSHR_Complete/",
      #                        nomSim_,
      #                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
      #                        ifelse(nom_GCM_=="","",paste0("/",nom_GCM_))))){
      #   dir.create(paste0(folder_output_,
      #                     "21_GrapheChroniqueProbabilite_Onemodel_ComparaisonTypesOSHR_Complete/",
      #                     nomSim_,
      #                     ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
      #                     ifelse(nom_GCM_=="","",paste0("/",nom_GCM_))))
      # }
      if (!dir.exists(paste0(folder_output_,
                             "21_GrapheChroniqueProbabilite_Onemodel_ComparaisonTypesOSHR_Complete/",
                             nomSim_,
                             ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                             # ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                             "/",dat_modelsRL_$names_[ind_]))){
        dir.create(paste0(folder_output_,
                          "21_GrapheChroniqueProbabilite_Onemodel_ComparaisonTypesOSHR_Complete/",
                          nomSim_,
                          ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                          # ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                          "/",dat_modelsRL_$names_[ind_]))
      }

      output_name_ <- paste0(folder_output_,
                             "21_GrapheChroniqueProbabilite_Onemodel_ComparaisonTypesOSHR_Complete/",
                             nomSim_,
                             ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
                             # ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                             "/",dat_modelsRL_$names_[ind_],
                             "/ChroProba_OneMod_Cplt_HER",HER_h_,"_logit.pdf")
      
      pdf(output_name_,
          width = 18)
      print(p)
      dev.off()
    }
  }
}




