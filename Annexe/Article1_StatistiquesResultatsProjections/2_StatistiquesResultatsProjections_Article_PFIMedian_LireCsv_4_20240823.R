

stats_19762005_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/StatistiquesPFI_HistoricalRcp_JuilOct_19762005_1_20240522.csv", sep = ";", dec = ".", header = T)
stats_20212050_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/StatistiquesPFI_HistoricalRcp_JuilOct_20212050_1_20240522.csv", sep = ";", dec = ".", header = T)
stats_20412070_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/StatistiquesPFI_HistoricalRcp_JuilOct_20412070_1_20240522.csv", sep = ";", dec = ".", header = T)
stats_20702099_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/StatistiquesPFI_HistoricalRcp_JuilOct_20702099_1_20240522.csv", sep = ";", dec = ".", header = T)

ncol(stats_19762005_)
median(unlist(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp26), na.rm = T) # 12.34124
median(unlist(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp45), na.rm = T) # 12.45496
median(unlist(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85), na.rm = T) # 12.44813
median(unlist(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp26), na.rm = T) # 10.4789
median(unlist(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp45), na.rm = T) # 10.28527
median(unlist(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85), na.rm = T) # 10.62175
median(unlist(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp26), na.rm = T) # 9.918757
median(unlist(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp45), na.rm = T) # 9.810113
median(unlist(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp85), na.rm = T) # 9.971463
median(unlist(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp26), na.rm = T) # 12.01279
median(unlist(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp45), na.rm = T) # 11.90837
median(unlist(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85), na.rm = T) # 12.02905
median(unlist(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp26), na.rm = T) # 10.12166
median(unlist(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp45), na.rm = T) # 10.13251
median(unlist(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85), na.rm = T) # 10.13622

sum(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85 > 20) # 20/75
sum(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85 > 20) # 16/75
sum(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp85 > 20, na.rm = T) # 9/37
sum(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85 > 20) # 16/75
sum(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85 > 20) # 12/75

sum(stats_19762005_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85 > 42) # 0
sum(stats_19762005_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85 > 42) # 0
sum(stats_19762005_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp85 > 42, na.rm = T) # 0
sum(stats_19762005_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85 > 42) # 0
sum(stats_19762005_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85 > 42) # 0


median(unlist(stats_19762005_[2:16]), na.rm = T) # 11.47881
median(unlist(stats_20212050_[2:16]), na.rm = T) # 13.72234
median(unlist(stats_20412070_[2:16]), na.rm = T) # 14.84473
median(unlist(stats_20702099_[2:16]), na.rm = T) # 16.26581






ncol(stats_20412070_)
median(unlist(stats_20412070_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp26), na.rm = T) # 14.81403
median(unlist(stats_20412070_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp45), na.rm = T) # 19.06229
median(unlist(stats_20412070_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp26), na.rm = T) # 13.31135
median(unlist(stats_20412070_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp45), na.rm = T) # 16.1299
median(unlist(stats_20412070_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp26), na.rm = T) # 10.54693
median(unlist(stats_20412070_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp45), na.rm = T) # 12.50812
median(unlist(stats_20412070_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp26), na.rm = T) # 12.51837
median(unlist(stats_20412070_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp45), na.rm = T) # 15.34425
median(unlist(stats_20412070_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp26), na.rm = T) # 11.83329
median(unlist(stats_20412070_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp45), na.rm = T) # 15.88443

median(unlist(stats_20412070_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85), na.rm = T) # 21.04356
median(unlist(stats_20412070_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85), na.rm = T) # 18.88416
median(unlist(stats_20412070_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp85), na.rm = T) # 12.88726
median(unlist(stats_20412070_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85), na.rm = T) # 14.24574
median(unlist(stats_20412070_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85), na.rm = T) # 16.80643


ncol(stats_20702099_)
median(unlist(stats_20702099_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp26), na.rm = T) # 13.03219
median(unlist(stats_20702099_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp45), na.rm = T) # 20.29854
median(unlist(stats_20702099_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp26), na.rm = T) # 11.28785
median(unlist(stats_20702099_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp45), na.rm = T) # 18.73757
median(unlist(stats_20702099_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp26), na.rm = T) # 9.223303
median(unlist(stats_20702099_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp45), na.rm = T) # 13.57062
median(unlist(stats_20702099_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp26), na.rm = T) # 11.57673
median(unlist(stats_20702099_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp45), na.rm = T) # 14.3329
median(unlist(stats_20702099_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp26), na.rm = T) # 10.91284
median(unlist(stats_20702099_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp45), na.rm = T) # 16.81518

median(unlist(stats_20702099_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85), na.rm = T) # 29.29918
median(unlist(stats_20702099_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85), na.rm = T) # 24.81842
median(unlist(stats_20702099_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp85), na.rm = T) # 17.56029
median(unlist(stats_20702099_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85), na.rm = T) # 15.86498
median(unlist(stats_20702099_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85), na.rm = T) # 23.92282 



sum(stats_20702099_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85 > 50) # 7
stats_20702099_[which(stats_20702099_$CTRIP_20231128_ChroniquesCombinees_saf_hist_rcp85>50),] # 108, 113, 117, 14, 17, 58, 70
sum(stats_20702099_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85 > 50) # 9
stats_20702099_[which(stats_20702099_$GRSD_20231128_ChroniquesCombinees_saf_hist_rcp85>50),] # 104, 108, 113, 14, 17, 58, 67, 78, 85
sum(stats_20702099_$J2000_20231128_ChroniquesCombinees_saf_hist_rcp85 > 50, na.rm = T) # 0
sum(stats_20702099_$ORCHIDEE_20231128_ChroniquesCombinees_saf_hist_rcp85 > 50) # 0
sum(stats_20702099_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85 > 50) # 5
stats_20702099_[which(stats_20702099_$SMASH_20231128_ChroniquesCombinees_saf_hist_rcp85>50),] # 108, 113, 14, 56, 78

#Sud est : 108, 113, 14, 17
#sud ouest 78
#nord ouest 58
