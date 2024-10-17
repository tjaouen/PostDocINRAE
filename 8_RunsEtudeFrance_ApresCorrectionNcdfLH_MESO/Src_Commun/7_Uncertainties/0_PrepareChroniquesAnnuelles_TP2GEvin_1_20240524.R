library(dplyr)
library(lubridate)
library(tidyr)



# Exemple pour une liste de fichiers
# list_chroniques <- list("path/to/chronique1.csv", "path/to/chronique2.csv", ..., "path/to/chronique170.csv")
# RCP_ <- "rcp85"
RCP_ <- "rcp45"
list_chroniques_ <- list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProba_LearnBrut_ByHer/FDC_Projections/",
                               pattern = "Tab_ChroniquesProba", full.names = T, recursive = T, include.dirs = F)
list_chroniques_ <- list_chroniques_[grepl(pattern = RCP_, list_chroniques_)]


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
  
  df_long <- data %>%
    pivot_longer(
      cols = -c(Date, Type, Year),
      names_to = "Y",
      values_to = "PFI"
    )
  
  df_mean <- df_long %>%
    group_by(Year) %>%
    summarize(mean_PFI = mean(PFI, na.rm = TRUE))
  
  write.table(df_mean,gsub("Tab_ChroniquesProba_LearnBrut_ByHer.txt",
                           "Tab_AnnualMeanPondere.txt",
                           file), sep = ";", dec = ".", row.names = F)
}
