

stats_19762005_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/StatistiquesPFI_HistoricalRcp_JuilOct_19762005_1_20240522.csv", sep = ";", dec = ".", header = T)
stats_20212050_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/StatistiquesPFI_HistoricalRcp_JuilOct_20212050_1_20240522.csv", sep = ";", dec = ".", header = T)
stats_20412070_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/StatistiquesPFI_HistoricalRcp_JuilOct_20412070_1_20240522.csv", sep = ";", dec = ".", header = T)
stats_20702099_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/StatistiquesPFI_HistoricalRcp_JuilOct_20702099_1_20240522.csv", sep = ";", dec = ".", header = T)


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



table(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp26 > 20) #21
table(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp45 > 20) #21
table(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85 > 20) #20
table(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp26 > 20) #15
table(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp45 > 20) #15
table(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85 > 20) #16
# table(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp26 > 20) #9
# table(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp45 > 20) #9
# table(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp85 > 20) #9
table(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp26 > 20) #17
table(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp45 > 20) #17
table(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85 > 20) #16
table(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp26 > 20) #12
table(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp45 > 20) #11
table(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85 > 20) #12

table(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp26 > 20)[[2]]/length(which(!is.na(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp26))) #0.346667
table(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp45 > 20)[[2]]/length(which(!is.na(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp45))) #0.346667
table(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85 > 20)[[2]]/length(which(!is.na(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85))) #0.36
table(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp26 > 20)[[2]]/length(which(!is.na(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp26))) #0.2533
table(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp45 > 20)[[2]]/length(which(!is.na(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp45))) #0.2533
table(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85 > 20)[[2]]/length(which(!is.na(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85))) #0.2533
table(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp26 > 20)[[2]]/length(which(!is.na(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp26))) #0.3158
table(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp45 > 20)[[2]]/length(which(!is.na(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp45))) #0.3158
table(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp85 > 20)[[2]]/length(which(!is.na(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp85))) #0.3158
table(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp26 > 20)[[2]]/length(which(!is.na(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp26))) #0.30667
table(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp45 > 20)[[2]]/length(which(!is.na(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp45))) #0.30667
table(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85 > 20)[[2]]/length(which(!is.na(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85))) #0.30667
table(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp26 > 20)[[2]]/length(which(!is.na(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp26))) #0.22667
table(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp45 > 20)[[2]]/length(which(!is.na(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp45))) #0.24
table(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85 > 20)[[2]]/length(which(!is.na(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85))) #0.22667

table(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp26 > 43) #0
table(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp45 > 43)
table(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85 > 43)
table(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp26 > 43)
table(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp45 > 43)
table(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85 > 43)
table(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp26 > 43)
table(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp45 > 43)
table(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp85 > 43)
table(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp26 > 43)
table(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp45 > 43)
table(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85 > 43)
table(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp26 > 43)
table(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp45 > 43)
table(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85 > 43)




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
stats_19762005_pond_[, 2:16] <- stats_19762005_pond_[, 2:16] * stats_19762005_pond_$Area_km2/sum(stats_19762005_pond_$Area_km2)

sum(stats_19762005_pond_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp26)
sum(stats_19762005_pond_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp45)
sum(stats_19762005_pond_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85)
sum(stats_19762005_pond_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp26)
sum(stats_19762005_pond_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp45)
sum(stats_19762005_pond_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85)
sum(stats_19762005_pond_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp26)
sum(stats_19762005_pond_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp45)
sum(stats_19762005_pond_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp85)
sum(stats_19762005_pond_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp26)
sum(stats_19762005_pond_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp45)
sum(stats_19762005_pond_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85)
sum(stats_19762005_pond_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp26)
sum(stats_19762005_pond_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp45)
sum(stats_19762005_pond_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85)






table(stats_20702099_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85 > 40) #20
stats_20702099_$HER[which(stats_20702099_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85 > 40)] # 104 105 108 112 113 117  14  17  27  28   5  51  58  62  66  67  70  85  97  99
table(stats_20702099_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85 > 40) #18
stats_20702099_$HER[which(stats_20702099_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85 > 40)] # 104 105 108 112 113 117  13  14  17  28  56  58  66  67  68  78  85  97
# table(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp85 > 40) #9
table(stats_20702099_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85 > 40) #2
stats_20702099_$HER[which(stats_20702099_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85 > 40)] # 108  17
table(stats_20702099_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85 > 40) #17
stats_20702099_$HER[which(stats_20702099_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85 > 40)] # 104 105 108 113 117  13  14  17  28  56  58  66  67  68  78  85  97

table(stats_20702099_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85 > 50) #7
stats_20702099_$HER[which(stats_20702099_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85 > 50)] #108 113 117  14  17  58  70
table(stats_20702099_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85 > 50) #9
stats_20702099_$HER[which(stats_20702099_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85 > 50)] # 104 108 113  14  17  58  67  78  85
# table(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp85 > 50) #0
table(stats_20702099_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85 > 50) #0
stats_20702099_$HER[which(stats_20702099_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85 > 50)] # 0
table(stats_20702099_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85 > 50) #5
stats_20702099_$HER[which(stats_20702099_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85 > 50)] # 108 113  14  56  78

# 104OK 108OK 113OK 117OK  14OK  17OK  56OK  58OK  67OK  70OK  78OK  85


stats_ratio_ <- stats_20702099_
stats_ratio_[,2:ncol(stats_ratio_)] <- stats_20702099_[,2:ncol(stats_20702099_)]/stats_19762005_[,2:ncol(stats_19762005_)]
stats_ratio_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85
stats_ratio_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85
stats_ratio_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85

stats_ratio_[which(stats_ratio_$HER == 97),]
#CTRIP 1.53
#GRSD 1.764118
#J2000 1.257776
#ORCHIDEE 0.9352902
#SMASH 1.874902

stats_ratio_[which(stats_ratio_$HER == 105),]
#CTRIP 1.870391
#GRSD 1.914318
#J2000 NA
#ORCHIDEE 1.307096
#SMASH 2.030432


