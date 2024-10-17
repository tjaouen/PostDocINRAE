### Import ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")

library(dplyr)
library(lubridate)
library(tidyr)



# Exemple pour une liste de fichiers
# list_chroniques <- list("path/to/chronique1.csv", "path/to/chronique2.csv", ..., "path/to/chronique170.csv")
# RCP_ <- "rcp85"
# RCP_ <- "rcp45"
RCP_ <- "rcp26"
# HER_ = "2"
HER_param_ = c(sort(HER2_hybrides.spdf$CdHER2)[which(!(sort(HER2_hybrides.spdf$CdHER2) %in% c(31, 33, 39, 37, 54, 69, 96, 89, 92, 49, 90)))], 031033039, 037054, 069096, 089092, 049090)


for (HER_ in HER_param_){
  
  # list_chroniques_ <- list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProba_LearnBrut_ByHer/FDC_Projections/",
  list_chroniques_ <- list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/FDC_Projections/",
                                 pattern = "Tab_ChroniquesProba", full.names = T, recursive = T, include.dirs = F)
  list_chroniques_ <- list_chroniques_[grepl(pattern = RCP_, list_chroniques_)]
  list_chroniques_ <- list_chroniques_[grepl(pattern = paste0("HER",HER_,".txt"), list_chroniques_)]
  
  
  # Initialiser une liste pour stocker les data frames annuelles
  list_annual_means <- list()
  years <- c()
  
  
  # Appliquer la fonction à chaque fichier et stocker les résultats
  for (file in list_chroniques_) {
    
    # Lire le fichier
    data <- read.csv(file, sep = ";", dec = ".", header = T)
    data <- data %>% filter(Type != "Safran")
    
    # S'assurer que la première colonne est de type Date
    data$Date <- as.Date(data$Date)
    
    # Ajouter une colonne année
    data$Year <- year(data[[1]])
    
    data <- data[,which(!(colnames(data) %in% c("Jour_annee")))]
    
    data <- data[which(month(data$Date)>=7 & month(data$Date)<=10),]
    
    # df_long <- data %>%
    #   pivot_longer(
    #     cols = -c(Date, Type, Year),
    #     names_to = "Y",
    #     values_to = "PFI"
    #   )
    # 
    # df_mean <- df_long %>%
    #   group_by(Year) %>%
    #   summarize(mean_PFI = mean(PFI, na.rm = TRUE))
    
    numeric_cols <- data %>%
      select(3:ncol(data)) %>%
      select(-Year) %>%
      select(where(is.numeric)) %>%
      colnames()
    
    # Appliquer le group_by et summarize avec across sur les colonnes numériques
    df_mean <- data %>%
      group_by(Year) %>%
      summarize(across(all_of(numeric_cols), ~ mean(.x, na.rm = TRUE), .names = "{col}"))
    
    write.table(df_mean,gsub(paste0("Tab_ChroniquesProba_LearnBrut_HER",HER_,".txt"),
                             paste0("Tab_AnnualMean_",HER_,".txt"),
                             file), sep = ";", dec = ".", row.names = F)
    # write.table(df_mean,gsub("Tab_ChroniquesProba_LearnBrut_ByHer.txt",
    #                          "Tab_AnnualMean.txt",
    #                          file), sep = ";", dec = ".", row.names = F)
  }
}
