library(lubridate)
library(readxl)
library(dplyr)
library(tidyr)


tab_HER_ <- read_excel("/home/tjaouen/Documents/Input/HER/HER2hybrides/DescriptionHER2hybrides_R_1_20230405.xlsx")
tab_HER_$Area_km2 <- as.numeric(tab_HER_$Area_km2)
tab_HER_Area <- tab_HER_[,c("CdHER2","Area_km2")]
tab_HER_Area$Area_km2[which(tab_HER_Area$CdHER2 == 37)] = tab_HER_Area$Area_km2[which(tab_HER_Area$CdHER2 == 37)]+tab_HER_Area$Area_km2[which(tab_HER_Area$CdHER2 == 54)]
tab_HER_Area$Area_km2[which(tab_HER_Area$CdHER2 == 69)] = tab_HER_Area$Area_km2[which(tab_HER_Area$CdHER2 == 69)]+tab_HER_Area$Area_km2[which(tab_HER_Area$CdHER2 == 96)]
tab_HER_Area$Area_km2[which(tab_HER_Area$CdHER2 == 31)] = tab_HER_Area$Area_km2[which(tab_HER_Area$CdHER2 == 31)]+tab_HER_Area$Area_km2[which(tab_HER_Area$CdHER2 == 33)]+tab_HER_Area$Area_km2[which(tab_HER_Area$CdHER2 == 39)]
tab_HER_Area$Area_km2[which(tab_HER_Area$CdHER2 == 89)] = tab_HER_Area$Area_km2[which(tab_HER_Area$CdHER2 == 89)]+tab_HER_Area$Area_km2[which(tab_HER_Area$CdHER2 == 92)]
tab_HER_Area$Area_km2[which(tab_HER_Area$CdHER2 == 49)] = tab_HER_Area$Area_km2[which(tab_HER_Area$CdHER2 == 49)]+tab_HER_Area$Area_km2[which(tab_HER_Area$CdHER2 == 90)]

tab_HER_Area$CdHER2[which(tab_HER_Area$CdHER2 == 37)] = "37054"
tab_HER_Area$CdHER2[which(tab_HER_Area$CdHER2 == 69)] = "69096"
tab_HER_Area$CdHER2[which(tab_HER_Area$CdHER2 == 31)] = "31033039"
tab_HER_Area$CdHER2[which(tab_HER_Area$CdHER2 == 89)] = "89092"
tab_HER_Area$CdHER2[which(tab_HER_Area$CdHER2 == 49)] = "49090"

# tab_HER_Area <- tab_HER_Area %>%
#   filter(!CdHER2 %in% c(54, 96, 33, 39, 92, 90))
tab_HER_Area <- tab_HER_Area %>%
  filter(!CdHER2 %in% c(10, 18, 19, 20, 54, 96, 33, 39, 92, 90))


# Exemple pour une liste de fichiers
# list_chroniques <- list("path/to/chronique1.csv", "path/to/chronique2.csv", ..., "path/to/chronique170.csv")
# RCP_ <- "rcp85"
# RCP_ <- "rcp45"
RCP_ <- "rcp26"
list_chroniques_ <- list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProba_LearnBrut_ByHer/FDC_Projections/",
                               pattern = "Tab_ChroniquesProba", full.names = T, recursive = T, include.dirs = F)
list_chroniques_ <- list_chroniques_[grepl(pattern = RCP_, list_chroniques_)]
# list_chroniques_ <- list_chroniques_[grepl("SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26/debit_France_MPI-M-MPI-ESM-LR_rcp26_r1i1p1_CLMcom-CCLM4-8-17_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-SMASH_day_20050801-21000731",list_chroniques_)]
# list_chroniques_ <- list_chroniques_[grepl("SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26/debit_France_MPI-M-MPI-ESM-LR_rcp26_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_20060101-21001231",list_chroniques_)]
# list_chroniques_ <- list_chroniques_[grepl("GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26/debit_France_MPI-M-MPI-ESM-LR_rcp26_r1i1p1_CLMcom-CCLM4-8-17_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_20050801-21000731",list_chroniques_)]
list_chroniques_ <- list_chroniques_[grepl("GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26/debit_France_MPI-M-MPI-ESM-LR_rcp26_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731",list_chroniques_)]


# Initialiser une liste pour stocker les data frames annuelles
list_annual_means <- list()
years <- c()


tab_HER_Area

# Appliquer la fonction à chaque fichier et stocker les résultats
for (file in list_chroniques_) {
  
  # Lire le fichier
  data <- read.csv(file, sep = ";", dec = ".", header = T)
  data <- data %>% filter(Type != "Safran")
  
  # S'assurer que la première colonne est de type Date
  data$Date <- as.Date(data$Date)
  
  # Ajouter une colonne année
  data$Year <- year(data[[1]])
  colnames(data) <- gsub("X","",colnames(data))
  
  # df_long <- data %>%
  #   pivot_longer(
  #     cols = -c(Date, Type, Year),
  #     names_to = "Y",
  #     values_to = "PFI"
  #   )
  
  # df_long <- df_long %>%
  #   left_join(tab_HER_Area, by = c("Y" = "CdHER2"))
  
  # df_weighted_mean <- df_long %>%
  #   group_by(Year) %>%
  #   summarize(weighted_mean_PFI = sum(PFI * Area_km2, na.rm = TRUE) / sum(Area_km2, na.rm = TRUE))

  mean_per_year <- data %>%
    group_by(Year) %>%
    summarize(across(3:(ncol(data)-1), ~ mean(.x, na.rm = TRUE)))
  
  weighted_mean_per_year <- mean_per_year %>%
    rowwise() %>%
    mutate(weighted_mean = {
      # Sélectionner les colonnes à pondérer
      cols_to_weight <- select(cur_data(), -Year)
      
      # Filtrer les aires correspondantes
      areas <- tab_HER_Area %>% filter(CdHER2 %in% names(cols_to_weight))
      
      # Calculer la somme des produits des valeurs et des aires, puis diviser par la somme des aires
      sum(cols_to_weight * areas$Area_km2[match(names(cols_to_weight), areas$CdHER2)], na.rm = TRUE) /
        sum(areas$Area_km2, na.rm = TRUE)
    })
  
  ### Verification ###
  # col_order <- colnames(mean_per_year)[-1]  # Exclure "Year"
  # 
  # # Trier tab_HER_Area selon col_order
  # sorted_tab_HER_Area <- tab_HER_Area %>%
  #   filter(CdHER2 %in% col_order) %>%
  #   arrange(factor(CdHER2, levels = col_order))
  # 
  # val_ <- c(13.4183441,23.026941,27.529553,24.165847,21.279300,35.855325,30.802317,13.029613,10.782814,1.53965079,22.219848,37.99650,
  #   59.10115,4.5744373,23.157551,45.78622,51.77211,36.566571,34.71253,10.559586,10.2751821,11.0369726,47.52045,20.162811,
  #   31.415960,7.279503,18.55788,21.172104,28.45388,5.270915,26.401591,31.569220,6.4626483,25.533911,18.926945,31.522721,13.435122,
  #   15.477042,14.989500,16.301023,8.8878875,6.350481,19.161344,5.61888076,9.105557,25.557446,10.7144180,24.602026,25.101515,33.23507,
  #   14.210258,20.716427,20.1244761,18.123936,14.378845,36.802473,26.246626,45.058981,10.3769469,13.727229,33.159611,22.571593,
  #   13.422701,8.907801,35.608788,18.691888,30.894094,30.39429,9.208004,7.455818,16.564682,21.999783,9.776585,23.907129,5.3477837)
  # area_ <- c(5113.2418,2525.3652,2381.0434,3061.9291,4614.9679,4442.4600,1219.2056,12873.9144,8681.1291,2026.8764,10506.3001,
  #            1936.0093,5868.3467,1625.5925,662.3261,18222.3437,27142.5921,7878.1237,21296.6208,1084.8818,964.5241,6052.9717,
  #            3858.8739,7211.3855,20312.5649,13354.1343,4126.3914,23278.4812,17739.7553,13361.2859,1307.7450,3377.0098,3482.4775,
  #            7202.3409,3593.2588,15059.6733,1347.7030,9953.9280,1013.6324,4998.1803,1079.2441,3998.2368,2885.0905,1780.2721,
  #            9557.1273,9641.0011,2919.7233,4332.6126,5483.5396,4989.6825,5190.8139,6124.1379,5964.8508,12225.0585,2376.7729,
  #            19981.9325,3971.5999,2358.4564,5651.9971,3916.7468,3601.3056,17517.6841,3334.3080,5612.2413,2136.4972,5192.2562,
  #            3513.1514,12368.6424,4770.9115,1655.9497,4560.5225,24714.2008,7779.6811,23831.0473,5751.5290)
  # 24.479706    
  
  
  weighted_mean_per_year <- weighted_mean_per_year[,c("Year","weighted_mean")]
  colnames(weighted_mean_per_year) <- c("Year","mean_PFI")

  write.table(weighted_mean_per_year,gsub("Tab_ChroniquesProba_LearnBrut_ByHer.txt",
                                          "Tab_AnnualMeanPondere.txt",
                                          file), sep = ";", dec = ".", row.names = F)
}


