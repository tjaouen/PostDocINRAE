library(lubridate)
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
                       MedianPFIjuilletOct = NA)

for (n in 1:length(nom_categorieSimu_list_)){
  
  list_ <- list.files(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/FDC_Projections/",nom_categorieSimu_list_[n]), full.names = T)
  medians_HER_ = c()
  for (f in 1:length(list_)){
    tab_ <- read.table(list_[f], header = T, sep = ";", dec = ".")
    tab_$Date <- as.Date(tab_$Date)
    tab_filtered <- tab_ %>%
      filter(year(Date) >= 1976 & year(Date) <= 2005 & 
               month(Date) >= 7 & month(Date) <= 10) %>%
      select(contains("debit"))
    medians_HER_[f] <- length(which(tab_filtered > 50))
  }
  
  # df_medians_HER_ <- data.frame(HER = str_before_first(str_after_first(str_after_first(list_,"HER"),"HER"),".txt"),
  #                             medians_HER_ = medians_HER_)
  # df_merge_ <- merge(df_medians_HER_, tab_HER_Area, by.x = "HER", by.y = "CdHER2")
  # dim(df_merge_)
  
  # weighted_median_HER <- df_merge_ %>%
  #   summarize(weighted_median = sum(medians_HER_ * Area_km2) / sum(Area_km2))
  # weighted_median_HER
  
  results_$MedianPFIjuilletOct[n] <- sum(medians_HER_)
  print(results_)
  
}

# nom_categorieSimu_ MedianPFIjuilletOct
# 1     CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26              287781
# 2     CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45              266269
# 3     CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85              510179
# 4      GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26              404214
# 5      GRSD_20231128/ChroniquesCombinees_saf_hist_rcp45              394864
# 6      GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85              757921
# 7     J2000_20231128/ChroniquesCombinees_saf_hist_rcp26              175171
# 8     J2000_20231128/ChroniquesCombinees_saf_hist_rcp45              166668
# 9     J2000_20231128/ChroniquesCombinees_saf_hist_rcp85              322688
# 10 ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26              201677
# 11 ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp45              182772
# 12 ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85              347921
# 13    SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26              328621
# 14    SMASH_20231128/ChroniquesCombinees_saf_hist_rcp45              328507
# 15    SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85              628244

