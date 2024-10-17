

stats_19762005_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/StatistiquesPFI_PFIMoyennePondereeOctJuil_HistoricalRcp_JuilOct_19762005_1_20240522.csv", sep = ";", dec = ".", header = T)
stats_20212050_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/StatistiquesPFI_PFIMoyennePondereeOctJuil_HistoricalRcp_JuilOct_20212050_1_20240522.csv", sep = ";", dec = ".", header = T)
stats_20412070_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/StatistiquesPFI_PFIMoyennePondereeOctJuil_HistoricalRcp_JuilOct_20412070_1_20240522.csv", sep = ";", dec = ".", header = T)
stats_20702099_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/StatistiquesPFI_PFIMoyennePondereeOctJuil_HistoricalRcp_JuilOct_20702099_1_20240522.csv", sep = ";", dec = ".", header = T)


mean(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85 > 25)
mean(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85 > 25)
mean(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp85 > 25)
mean(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85 > 25)
mean(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85 > 25)



table(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85 > 25)
table(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85 > 25)
table(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp85 > 25)
table(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85 > 25)
table(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85 > 25)


table(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85 > 45)
table(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85 > 45)
table(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp85 > 45)
table(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85 > 45)
table(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85 > 45)


stats_19762005_[which.max(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85),]
stats_19762005_[which.max(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85),]
stats_19762005_[which.max(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp85),]
stats_19762005_[which.max(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85),]
stats_19762005_[which.max(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85),]





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



stats_19762005_ <- merge(stats_19762005_, tab_HER_Area, by.x = "HER", by.y = "CdHER2")
stats_19762005_pond_ <- stats_19762005_
stats_19762005_pond_J2000 <- stats_19762005_[which(!is.na(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp26)),]
stats_19762005_pond_[, 2:16] <- stats_19762005_pond_[, 2:16] * stats_19762005_pond_$Area_km2/sum(stats_19762005_pond_$Area_km2)
stats_19762005_pond_J2000[, 2:16] <- stats_19762005_pond_J2000[, 2:16] * stats_19762005_pond_J2000$Area_km2/sum(stats_19762005_pond_J2000$Area_km2)
  
sum(stats_19762005_pond_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp26) #18.93743
sum(stats_19762005_pond_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp45) #19.14284
sum(stats_19762005_pond_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85) #19.15471
sum(stats_19762005_pond_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp26) #15.08023
sum(stats_19762005_pond_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp45) #15.30298
sum(stats_19762005_pond_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85) #15.40199
sum(stats_19762005_pond_J2000$J2000_20231128_ChroniquesCombinees_saf_hist_rcp26) #15.713
sum(stats_19762005_pond_J2000$J2000_20231128_ChroniquesCombinees_saf_hist_rcp45) #15.763
sum(stats_19762005_pond_J2000$J2000_20231128_ChroniquesCombinees_saf_hist_rcp85) #15.9826
sum(stats_19762005_pond_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp26) #17.95299
sum(stats_19762005_pond_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp45) #17.90315
sum(stats_19762005_pond_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85) #17.90182
sum(stats_19762005_pond_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp26) #14.09141
sum(stats_19762005_pond_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp45) #14.34649
sum(stats_19762005_pond_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85) #14.43202

table(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp26 > 20) #26
table(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp45 > 20) #26
table(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85 > 20) #26
table(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp26 > 20) #19
table(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp45 > 20) #19
table(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85 > 20) #19
# table(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp26 > 30) #7
# table(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp45 > 30) #7
# table(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp85 > 30) #8
table(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp26 > 20) #23
table(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp45 > 20) #23
table(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85 > 20) #23
table(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp26 > 20) #17
table(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp45 > 20) #18
table(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85 > 20) #17

table(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp26 > 43) #0
table(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp45 > 43) #0
table(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85 > 43) #0
table(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp26 > 43) #0
table(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp45 > 43) #0
table(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85 > 43) #0
table(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp26 > 43) #0
table(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp45 > 43) #0
table(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp85 > 43) #0
table(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp26 > 43) #0
table(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp45 > 43) #0
table(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85 > 43) #0
table(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp26 > 43) #0
table(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp45 > 43) #0
table(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85 > 43) #0


stats_19762005_$HER[which.max(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp26)]
stats_19762005_$HER[which.max(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp45)]
stats_19762005_$HER[which.max(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85)]
stats_19762005_$HER[which.max(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp26)]
stats_19762005_$HER[which.max(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp45)]
stats_19762005_$HER[which.max(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85)]
stats_19762005_$HER[which.max(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp26)]
stats_19762005_$HER[which.max(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp45)]
stats_19762005_$HER[which.max(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp45)]
stats_19762005_$HER[which.max(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp26)]
stats_19762005_$HER[which.max(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp45)]
stats_19762005_$HER[which.max(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85)]
stats_19762005_$HER[which.max(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp26)]
stats_19762005_$HER[which.max(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp45)]
stats_19762005_$HER[which.max(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85)]








stats_20412070_ <- merge(stats_20412070_, tab_HER_Area, by.x = "HER", by.y = "CdHER2")
stats_20412070_pond_ <- stats_20412070_
stats_20412070_pond_[, 2:16] <- stats_20412070_pond_[, 2:16] * stats_20412070_pond_$Area_km2/sum(stats_20412070_pond_$Area_km2)

sum(stats_20412070_pond_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85) #23.57985
sum(stats_20412070_pond_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85) #21.43722
sum(stats_20412070_pond_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp85) #NA
sum(stats_20412070_pond_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85) #15.64004
sum(stats_20412070_pond_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85) #19.96619

# Version 2024.06.09
# > sum(stats_20412070_pond_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85)
# [1] 25.47667
# > sum(stats_20412070_pond_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85)
# [1] 22.20215
# > sum(stats_20412070_pond_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp85)
# [1] NA
# > sum(stats_20412070_pond_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85)
# [1] 18.81858
# > sum(stats_20412070_pond_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85)
# [1] 20.96408

sum(stats_20412070_pond_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp45) #22.12069
sum(stats_20412070_pond_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp45) #19.82789
sum(stats_20412070_pond_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp45) #NA
sum(stats_20412070_pond_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp45) #16.9204
sum(stats_20412070_pond_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp45) #18.48387
# Version 2024.06.09
# > sum(stats_20412070_pond_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp45)
# [1] 24.27147
# > sum(stats_20412070_pond_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp45)
# [1] 21.06597
# > sum(stats_20412070_pond_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp45) #NA
# [1] NA
# > sum(stats_20412070_pond_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp45)
# [1] 19.86258
# > sum(stats_20412070_pond_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp45)
# [1] 19.94981


stats_20702099_ <- merge(stats_20702099_, tab_HER_Area, by.x = "HER", by.y = "CdHER2")
stats_20702099_pond_ <- stats_20702099_
stats_20702099_pond_[, 2:16] <- stats_20702099_pond_[, 2:16] * stats_20702099_pond_$Area_km2/sum(stats_20702099_pond_$Area_km2)

sum(stats_20702099_pond_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85) #30.84113
sum(stats_20702099_pond_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85) #29.04286
sum(stats_20702099_pond_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp85) #NA
sum(stats_20702099_pond_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85) #16.81481
sum(stats_20702099_pond_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85) #27.0109
# Version 2024.06.09
# > sum(stats_20702099_pond_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85)
# [1] 31.10736
# > sum(stats_20702099_pond_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85)
# [1] 27.76531
# > sum(stats_20702099_pond_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp85) #NA
# [1] NA
# > sum(stats_20702099_pond_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85)
# [1] 20.35752
# > sum(stats_20702099_pond_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85)
# [1] 26.03824


sum(stats_20702099_pond_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp45) #22.44622
sum(stats_20702099_pond_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp45) #21.18935
sum(stats_20702099_pond_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp45) #NA
sum(stats_20702099_pond_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp45) #15.70626
sum(stats_20702099_pond_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp45) #19.80791
# Version 2024.06.09
# > sum(stats_20702099_pond_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp45)
# [1] 24.17865
# > sum(stats_20702099_pond_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp45)
# [1] 21.8585
# > sum(stats_20702099_pond_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp45) #NA
# [1] NA
# > sum(stats_20702099_pond_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp45)
# [1] 18.38264
# > sum(stats_20702099_pond_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp45)
# [1] 20.6968


table(stats_20702099_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp26 > 20) #28
table(stats_20702099_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp45 > 20) #43
table(stats_20702099_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85 > 20) #58
table(stats_20702099_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp26 > 20) #0
table(stats_20702099_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp45 > 20) #0
table(stats_20702099_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85 > 20) #3
table(stats_20702099_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp26 > 20) #0
table(stats_20702099_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp45 > 20) #0
table(stats_20702099_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp85 > 20) #0
table(stats_20702099_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp26 > 20) #0
table(stats_20702099_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp45 > 20) #0
table(stats_20702099_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85 > 20) #1
table(stats_20702099_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp26 > 20) #0
table(stats_20702099_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp45 > 20) #0
table(stats_20702099_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85 > 20) #3


table(stats_20702099_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp26 > 50) #0
table(stats_20702099_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp45 > 50) #0
table(stats_20702099_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85 > 50) #4
table(stats_20702099_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp26 > 50) #0
table(stats_20702099_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp45 > 50) #0
table(stats_20702099_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85 > 50) #3
table(stats_20702099_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp26 > 50) #0
table(stats_20702099_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp45 > 50) #0
table(stats_20702099_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp85 > 50) #0
table(stats_20702099_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp26 > 50) #0
table(stats_20702099_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp45 > 50) #0
table(stats_20702099_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85 > 50) #1
table(stats_20702099_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp26 > 50) #0
table(stats_20702099_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp45 > 50) #0
table(stats_20702099_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85 > 50) #3



stats_ratio_ <- stats_20702099_
stats_ratio_[,2:ncol(stats_ratio_)] <- stats_20702099_[,2:ncol(stats_20702099_)]/stats_19762005_[,2:ncol(stats_19762005_)]
stats_ratio_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85
stats_ratio_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85
stats_ratio_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85

stats_ratio_[which(stats_ratio_$HER == 97),]
# RCP 4.5
#CTRIP 1.12055
#GRSD 1.312278
#J2000 0.9958336
#ORCHIDEE 0.9132762
#SMASH 1.349767

# RCP 8.5
#CTRIP 1.364121
#GRSD 1.547116
#J2000 1.205023
#ORCHIDEE 1.009009
#SMASH 1.614143

stats_ratio_[which(stats_ratio_$HER == 105),]
# RCP 4.5
#CTRIP 1.271297
#GRSD 1.318458
#J2000 NA
#ORCHIDEE 1.087918
#SMASH 1.336259

#CTRIP 1.641012
#GRSD 1.658956
#J2000 NA
#ORCHIDEE 1.352014
#SMASH 1.666565


stats_ratio_[which(stats_ratio_$HER == 14),]
# RCP 4.5
#CTRIP 1.375391
#GRSD 1.387676
#J2000 1.260039
#ORCHIDEE 1.091845
#SMASH 1.435662

# RCP 8.5
#CTRIP 1.801278
#GRSD 1.772305
#J2000 1.53302
#ORCHIDEE 1.394652
#SMASH 1.839979


