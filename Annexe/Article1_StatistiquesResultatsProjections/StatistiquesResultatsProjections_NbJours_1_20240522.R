library(readxl)
library(dplyr)

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

tab_HER_Area <- tab_HER_Area %>%
  filter(!CdHER2 %in% c(54, 96, 33, 39, 92, 90))


nom_categorieSimu_list_ = c("CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26",
                            "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45",
                            "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85",
                            "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26",
                            "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp45",
                            "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85",
                            "J2000_20231128/ChroniquesCombinees_saf_hist_rcp26",
                            "J2000_20231128/ChroniquesCombinees_saf_hist_rcp45",
                            "J2000_20231128/ChroniquesCombinees_saf_hist_rcp85",
                            "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26",
                            "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp45",
                            "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85",
                            "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26",
                            "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp45",
                            "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85")

results_ <- data.frame(nom_categorieSimu_ = nom_categorieSimu_list_,
                       MeanNbJoursSup20 = NA)

for (n in 1:length(nom_categorieSimu_list_)){
  
  list_ <- list.files(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/",nom_categorieSimu_), full.names = T)
  list_ <- list_[grepl("NbJoursSup20",list_)]
  
  means_HER_ = c()
  for (f in 1:length(list_)){
    tab_ <- read.table(list_[f], header = T, sep = ";", dec = ".")
    tab_$Date <- as.Date(tab_$Date)
    tab_filtered <- tab_ %>%
      filter(year(Date) >= 1976 & year(Date) <= 2005) %>%
      select(contains("debit"))
    debit_means <- colMeans(tab_filtered, na.rm = TRUE)
    means_HER_[f] <- mean(debit_means)
  }
  
  df_means_HER_ <- data.frame(HER = str_before_first(str_after_first(str_after_first(list_,"HER"),"HER"),".txt"),
                              means_HER_ = means_HER_)
  
  # mean(8.676587,17.401192,33.605924,26.678614,9.742103,5.179176,44.066655,24.771308,33.993834,44.482720,12.806345,18.386526,7.437792,22.841926,
  #      44.063191,37.879467,11.862256,13.856579,16.715690,2.620785,17.528186,35.952187,43.216086,17.254959,15.337680,29.049212,16.480769,28.161379,
  #      21.418859,29.453848,25.168951,26.265406,10.535757,8.541998,6.917704,26.469730,10.417023,35.212260,16.712192,18.145183,15.684933,25.454522,
  #      13.619880,42.793025,8.604541,30.394181,32.833394,8.668918,22.498657,18.335383,27.020958,21.818145,17.324406,17.223752,25.328119,22.645262,
  #      10.380918,7.147027,18.231972,5.228074,9.191657,17.086402,11.785329,22.161001,23.557014,31.134630,12.485311,16.849758,23.569424,15.535231,
  #      19.153193,13.264341,36.540378,21.897972,35.126386)
  
  df_merge_ <- merge(df_means_HER_, tab_HER_Area, by.x = "HER", by.y = "CdHER2")
  dim(df_merge_)
  
  weighted_mean_HER <- df_merge_ %>%
    summarize(weighted_mean = sum(means_HER_ * Area_km2) / sum(Area_km2))
  # weighted_mean_HER
  
  results_$MeanNbJoursSup20[n] <- weighted_mean_HER
  print(results_)
  
  # nom_categorieSimu_ <- "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26" # 18.07732
  # nom_categorieSimu_ <- "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45" # 17.63551
  # nom_categorieSimu_ <- "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85" # 22.30573
  # nom_categorieSimu_ <- "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26" # 
  # nom_categorieSimu_ <- "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp45"
  # nom_categorieSimu_ <- "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85"
  # nom_categorieSimu_ <- "J2000_20231128/ChroniquesCombinees_saf_hist_rcp26"
  # nom_categorieSimu_ <- "J2000_20231128/ChroniquesCombinees_saf_hist_rcp45"
  # nom_categorieSimu_ <- "J2000_20231128/ChroniquesCombinees_saf_hist_rcp85"
  # nom_categorieSimu_ <- "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26"
  # nom_categorieSimu_ <- "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp45"
  # nom_categorieSimu_ <- "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85"
  # nom_categorieSimu_ <- "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26"
  # nom_categorieSimu_ <- "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp45"
  # nom_categorieSimu_ <- "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85"
  
}
  
