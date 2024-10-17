library(lubridate)
library(readxl)
library(dplyr)
library(strex)

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

# results_ <- data.frame(nom_categorieSimu_ = nom_categorieSimu_list_,
#                        MedianPFIjuilletOct = NA)

dates_ = data.frame(date_debut = c(1976,2021,2041,2070),
                    date_fin = c(2005,2050,2070,2099))


list_ <- list.files(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/FDC_Projections/",nom_categorieSimu_list_[1]), full.names = T)
HER_list_ = str_before_first(str_after_first(str_after_first(list_,"HER"),"HER"),".txt")

results_ <- data.frame(HER = HER_list_,
                       CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp26 = NA,
                       CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp45 = NA,
                       CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85 = NA,
                       GRSD_20231128_ChroniquesCombinees_saf_hist_rcp26 = NA,
                       GRSD_20231128_ChroniquesCombinees_saf_hist_rcp45 = NA,
                       GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85 = NA,
                       J2000_20231128_ChroniquesCombinees_saf_hist_rcp26 = NA,
                       J2000_20231128_ChroniquesCombinees_saf_hist_rcp45 = NA,
                       J2000_20231128_ChroniquesCombinees_saf_hist_rcp85 = NA,
                       ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp26 = NA,
                       ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp45 = NA,
                       ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85 = NA,
                       SMASH_20231128_ChroniquesCombinees_saf_hist_rcp26 = NA,
                       SMASH_20231128_ChroniquesCombinees_saf_hist_rcp45 = NA,
                       SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85 = NA)

for (d in 1:nrow(dates_)){
  
  for (n in 1:length(nom_categorieSimu_list_)){
    
    list_ <- list.files(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/FDC_Projections/",nom_categorieSimu_list_[n]), full.names = T)
    medians_HER_ = c()
    for (f in 1:length(list_)){
      tab_ <- read.table(list_[f], header = T, sep = ";", dec = ".")
      tab_$Date <- as.Date(tab_$Date)
      tab_filtered <- tab_ %>%
        filter(year(Date) >= dates_$date_debut[d] & year(Date) <= dates_$date_fin[d] & 
                 month(Date) >= 7 & month(Date) <= 10 &
                 Type != "Safran") %>%
        select(contains("debit"))
      medians_HER_[f] <- median(unlist(tab_filtered), na.rm = TRUE)
      # colMeans(tab_filtered, na.rm = T)
    }
    
    df_medians_HER_ <- data.frame(HER = str_before_first(str_after_first(str_after_first(list_,"HER"),"HER"),".txt"),
                                  medians_HER_ = medians_HER_)
    results_ <- merge(results_, df_medians_HER_, by.x = "HER", by.y = "HER", all.x = T)
    results_[[gsub("/","_",nom_categorieSimu_list_[n])]] = results_$medians_HER_
    results_ <- results_ %>% select(-medians_HER_)
    # dim(df_merge_)
    
    # weighted_median_HER <- df_merge_ %>%
    #   summarize(weighted_median = sum(medians_HER_ * Area_km2) / sum(Area_km2))
    # weighted_median_HER
    
    # results_
    # results_$MedianPFIjuilletOct[n] <- length(which(medians_HER_>25))
    # print(results_)
    
    write.table(results_,
                paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/StatistiquesPFI_HistoricalRcp_JuilOct_",dates_$date_debut[d],dates_$date_fin[d],"_1_20240522.csv"),
                sep = ";", dec = ".", row.names = F)
    
  }
  
  write.table(results_,
              paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/StatistiquesPFI_HistoricalRcp_JuilOct_",dates_$date_debut[d],dates_$date_fin[d],"_1_20240522.csv"),
              sep = ";", dec = ".", row.names = F)
}





# nom_categorieSimu_ <- "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26"
# nom_categorieSimu_ <- "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45"
# nom_categorieSimu_ <- "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85"
# nom_categorieSimu_ <- "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26"
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
               month(Date) >= 7 & month(Date) <= 10 &
               Type == "Safran") %>%
      select(contains("debit"))
    medians_HER_[f] <- median(unlist(tab_filtered), na.rm = TRUE)
  }
  
  # df_medians_HER_ <- data.frame(HER = str_before_first(str_after_first(str_after_first(list_,"HER"),"HER"),".txt"),
  #                             medians_HER_ = medians_HER_)
  # df_merge_ <- merge(df_medians_HER_, tab_HER_Area, by.x = "HER", by.y = "CdHER2")
  # dim(df_merge_)
  
  # weighted_median_HER <- df_merge_ %>%
  #   summarize(weighted_median = sum(medians_HER_ * Area_km2) / sum(Area_km2))
  # weighted_median_HER
  
  results_$MedianPFIjuilletOct[n] <- length(which(medians_HER_>25))
  print(results_)
  
}
