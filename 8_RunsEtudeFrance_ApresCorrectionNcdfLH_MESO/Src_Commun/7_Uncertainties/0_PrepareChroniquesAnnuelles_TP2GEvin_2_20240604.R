library(dplyr)
library(lubridate)
library(tidyr)



# Exemple pour une liste de fichiers
# list_chroniques <- list("path/to/chronique1.csv", "path/to/chronique2.csv", ..., "path/to/chronique170.csv")
# RCP_ <- "rcp85"
RCP_ <- "rcp45"
# list_chroniques_ <- list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/CTRIP_20231128/",
#                                pattern = "Tab_Indicateurs_NbJoursSup20", full.names = T, recursive = T, include.dirs = F)
# list_chroniques_ <- list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/GRSD_20231128/",
#                                pattern = "Tab_Indicateurs_NbJoursSup20", full.names = T, recursive = T, include.dirs = F)
# list_chroniques_ <- list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/J2000_20231128/",
#                                pattern = "Tab_Indicateurs_NbJoursSup20", full.names = T, recursive = T, include.dirs = F)
# list_chroniques_ <- list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/ORCHIDEE_20231128/",
#                                pattern = "Tab_Indicateurs_NbJoursSup20", full.names = T, recursive = T, include.dirs = F)
list_chroniques_ <- list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/SMASH_20231128/",
                               pattern = "Tab_Indicateurs_NbJoursSup20", full.names = T, recursive = T, include.dirs = F)
list_chroniques_ <- list_chroniques_[grepl(pattern = RCP_, list_chroniques_)]
list_chroniques_ <- list_chroniques_[!grepl(pattern = "_France_", list_chroniques_)]
length(list_chroniques_) # 75

# Initialiser une liste pour stocker les data frames annuelles
# list_annual_means <- list()
# years <- c()


# Appliquer la fonction à chaque fichier et stocker les résultats
tab_globale_ = data.frame()

for (file in list_chroniques_) {
  
  # Lire le fichier
  data <- read.csv(file, sep = ";", dec = ".", header = T)
  
  if (length(tab_globale_) == 0){
    tab_globale_ <- data
  }else{
    if (colnames(data) == colnames(tab_globale_)){
      tab_globale_ <- rbind(tab_globale_,data)
    }else{
      stop('Error, not the same columns.')
    }
  }
}

tab_globale_ <- aggregate(tab_globale_, by = list(tab_globale_$Year), FUN = mean)
tab_globale_ <- tab_globale_[,!colnames(tab_globale_) %in% c("Group.1")]
tab_globale_[,2:ncol(tab_globale_)] <- round(tab_globale_[,2:ncol(tab_globale_)],2)

write.table(tab_globale_,gsub(paste0("Tab_Indicateurs_NbJoursSup20_HER99_ADAMONT_Historical",RCP_,".txt"),
                              paste0("Tab_Indicateurs_NbJoursSup20_France_ADAMONT_Historical",RCP_,".txt"),
                              file), sep = ";", dec = ".", row.names = F)


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
# 
# write.table(df_mean,gsub("Tab_ChroniquesProba_LearnBrut_ByHer.txt",
#                          "Tab_AnnualMean.txt",
#                          file), sep = ";", dec = ".", row.names = F)

