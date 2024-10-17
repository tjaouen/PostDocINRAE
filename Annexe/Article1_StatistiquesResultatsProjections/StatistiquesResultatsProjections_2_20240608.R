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

### Debut de siecle 1976-2005 Historical + RCP ###
results_ <- data.frame(nom_categorieSimu_ = nom_categorieSimu_list_,
                       MeanPFIjuilletOct = NA)
for (n in 1:length(nom_categorieSimu_list_)){
  
  list_ <- list.files(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/FDC_Projections/",nom_categorieSimu_list_[n]), full.names = T)
  means_HER_ = c()
  for (f in 1:length(list_)){
    tab_ <- read.table(list_[f], header = T, sep = ";", dec = ".")
    tab_$Date <- as.Date(tab_$Date)
    tab_filtered <- tab_ %>%
      filter(year(Date) >= 1976 & year(Date) <= 2005 & 
               month(Date) >= 7 & month(Date) <= 10 &
               Type != "Safran") %>%
      select(contains("debit"))
    debit_means <- colMeans(tab_filtered, na.rm = TRUE)
    means_HER_[f] <- mean(debit_means)
  }
  
  df_means_HER_ <- data.frame(HER = str_before_first(str_after_first(str_after_first(list_,"HER"),"HER"),".txt"),
                              means_HER_ = means_HER_)
  
  df_merge_ <- merge(df_means_HER_, tab_HER_Area, by.x = "HER", by.y = "CdHER2")
  dim(df_merge_)
  
  weighted_mean_HER <- df_merge_ %>%
    summarize(weighted_mean = sum(means_HER_ * Area_km2) / sum(Area_km2))
  # weighted_mean_HER
  
  results_$MeanPFIjuilletOct[n] <- weighted_mean_HER
  print(results_)
  
}
# nom_categorieSimu_ MeanPFIjuilletOct
# 1     CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26          18.93743
# 2     CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45          19.14284
# 3     CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85          19.15471
# 4      GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26          15.08023
# 5      GRSD_20231128/ChroniquesCombinees_saf_hist_rcp45          15.30298
# 6      GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85          15.40199
# 7     J2000_20231128/ChroniquesCombinees_saf_hist_rcp26          15.71344
# 8     J2000_20231128/ChroniquesCombinees_saf_hist_rcp45          15.76308
# 9     J2000_20231128/ChroniquesCombinees_saf_hist_rcp85           15.9826
# 10 ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26          17.95299
# 11 ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp45          17.90315
# 12 ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85          17.90182
# 13    SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26          14.09141
# 14    SMASH_20231128/ChroniquesCombinees_saf_hist_rcp45          14.34649
# 15    SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85          14.43202


#RCP 8.5
mean(c(19.15471,15.40199,15.9826,17.90182,14.43202)) #16.57463
mean(c(19.15471,15.40199,17.90182,14.43202)) # 16.72264 = Valeur Eric

#Sans J2000
mean(c(18.93743,19.14284,19.15471, # CTRIP
       15.08023,15.30298,15.40199, # GRSD
       17.95299,17.90315,17.90182, # ORCHIDEE
       14.09141,14.34649,14.43202)) # SMASH
# 16.63734

#Par modele
mean(c(18.93743,19.14284,19.15471)) #CTRIP 19.07833
mean(c(15.08023,15.30298,15.40199)) #GRSD 15.26173
mean(c(15.71344,15.76308,15.9826)) #J2000 15.81971
mean(c(17.95299,17.90315,17.90182)) #ORCHIDEE 17.91932
mean(c(14.09141,14.34649,14.43202)) #SMASH 14.28997



### Debut de siecle 1976-2005 Safran ###
results_ <- data.frame(nom_categorieSimu_ = nom_categorieSimu_list_,
                       MeanPFIjuilletOct = NA)
for (n in 1:length(nom_categorieSimu_list_)){
  
  list_ <- list.files(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/FDC_Projections/",nom_categorieSimu_list_[n]), full.names = T)
  means_HER_ = c()
  for (f in 1:length(list_)){
    tab_ <- read.table(list_[f], header = T, sep = ";", dec = ".")
    tab_$Date <- as.Date(tab_$Date)
    tab_filtered <- tab_ %>%
      filter(year(Date) >= 1976 & year(Date) <= 2005 & 
               month(Date) >= 7 & month(Date) <= 10 &
               Type == "Safran") %>%
      select(contains("debit"))
    debit_means <- colMeans(tab_filtered, na.rm = TRUE)
    means_HER_[f] <- mean(debit_means)
  }
  
  df_means_HER_ <- data.frame(HER = str_before_first(str_after_first(str_after_first(list_,"HER"),"HER"),".txt"),
                              means_HER_ = means_HER_)
  
  df_merge_ <- merge(df_means_HER_, tab_HER_Area, by.x = "HER", by.y = "CdHER2")
  dim(df_merge_)
  
  weighted_mean_HER <- df_merge_ %>%
    summarize(weighted_mean = sum(means_HER_ * Area_km2) / sum(Area_km2))
  # weighted_mean_HER
  
  results_$MeanPFIjuilletOct[n] <- weighted_mean_HER
  print(results_)
  
}
# nom_categorieSimu_ MeanPFIjuilletOct
# 1     CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26          15.05527
# 2     CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45          15.07416
# 3     CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85          15.08144
# 4      GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26          14.55277
# 5      GRSD_20231128/ChroniquesCombinees_saf_hist_rcp45           14.5944
# 6      GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85          14.61955
# 7     J2000_20231128/ChroniquesCombinees_saf_hist_rcp26          14.85901
# 8     J2000_20231128/ChroniquesCombinees_saf_hist_rcp45          14.84897
# 9     J2000_20231128/ChroniquesCombinees_saf_hist_rcp85          14.83943
# 10 ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26          14.95788
# 11 ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp45          14.99303
# 12 ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85          14.96103
# 13    SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26          13.92199
# 14    SMASH_20231128/ChroniquesCombinees_saf_hist_rcp45          13.97134
# 15    SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85          13.99359

#RCP 8.5
mean(c(15.08144,14.61955,14.83943,14.96103,13.99359)) # 14.69901
mean(c(15.08144,14.61955,14.96103,13.99359)) # 14.6639

#Sans J2000
mean(c(15.05527,15.07416,15.08144, #CTRIP
       14.55277,14.5944,14.61955, #GRSD
       14.95788,14.99303,14.96103, #ORCHIDEE
       13.92199,13.97134,13.99359)) #SMASH
# 14.64804

#Par modele
mean(c(15.05527,15.07416,15.08144)) #CTRIP 15.07029
mean(c(14.55277,14.5944,14.61955)) #GRSD 14.58891
mean(c(14.85901,14.84897,14.83943)) #J2000 14.84914
mean(c(14.95788,14.99303,14.96103)) #ORCHIDEE 14.97065
mean(c(13.92199,13.97134,13.99359)) #SMASH 13.96231



### Safran + Historical + rcp confondus ###
# nom_categorieSimu_ MeanPFIjuilletOct
# 1     CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26          16.99477
# 2     CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45          17.10684
# 3     CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85          17.11641
# 4      GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26          14.81761
# 5      GRSD_20231128/ChroniquesCombinees_saf_hist_rcp45          14.95018
# 6      GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85          15.01242
# 7     J2000_20231128/ChroniquesCombinees_saf_hist_rcp26          15.28589
# 8     J2000_20231128/ChroniquesCombinees_saf_hist_rcp45          15.30565
# 9     J2000_20231128/ChroniquesCombinees_saf_hist_rcp85          15.41054
# 10 ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26          16.46176
# 11 ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp45          16.45423
# 12 ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85          16.43764
# 13    SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26          14.00606
# 14    SMASH_20231128/ChroniquesCombinees_saf_hist_rcp45          14.15749
# 15    SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85          14.21114

#RCP 8.5
mean(c(17.11641,15.01242,15.41054,16.43764,14.21114)) #15.63763
mean(c(17.11641,15.01242,16.43764,14.21114)) #15.6944

#Sans J2000
mean(c(16.99477,17.10684,17.11641, #CTRIP
       14.81761,14.95018,15.01242, #GRSD
       16.46176,16.45423,16.43764, #ORCHIDEE
       14.00606,14.15749,14.21114)) #SMASH
# 15.64388

#Par modele
mean(c(16.99477,17.10684,17.11641)) #CTRIP 17.07267
mean(c(14.81761,14.95018,15.01242)) #GRSD 14.92674
mean(c(15.28589,15.30565,15.41054)) #J2000 15.33403
mean(c(16.46176,16.45423,16.43764)) #ORCHIDEE 16.45121
mean(c(14.00606,14.15749,14.21114)) #SMASH 14.1249





### H1 2021-2050 ###
results_ <- data.frame(nom_categorieSimu_ = nom_categorieSimu_list_,
                       MeanPFIjuilletOct = NA)
for (n in 1:length(nom_categorieSimu_list_)){
  
  list_ <- list.files(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/FDC_Projections/",nom_categorieSimu_list_[n]), full.names = T)
  means_HER_ = c()
  for (f in 1:length(list_)){
    tab_ <- read.table(list_[f], header = T, sep = ";", dec = ".")
    tab_$Date <- as.Date(tab_$Date)
    tab_filtered <- tab_ %>%
      filter(year(Date) >= 2021 & year(Date) <= 2050 & 
               month(Date) >= 7 & month(Date) <= 10) %>%
      select(contains("debit"))
    debit_means <- colMeans(tab_filtered, na.rm = TRUE)
    means_HER_[f] <- mean(debit_means)
  }
  
  df_means_HER_ <- data.frame(HER = str_before_first(str_after_first(str_after_first(list_,"HER"),"HER"),".txt"),
                              means_HER_ = means_HER_)
  
  df_merge_ <- merge(df_means_HER_, tab_HER_Area, by.x = "HER", by.y = "CdHER2")
  dim(df_merge_)
  
  weighted_mean_HER <- df_merge_ %>%
    summarize(weighted_mean = sum(means_HER_ * Area_km2) / sum(Area_km2))
  # weighted_mean_HER
  
  results_$MeanPFIjuilletOct[n] <- weighted_mean_HER
  print(results_)
  
}

# nom_categorieSimu_ MeanPFIjuilletOct
# 1     CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26          20.95519
# 2     CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45          22.29265
# 3     CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85          22.74588
# 4      GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26          16.83535
# 5      GRSD_20231128/ChroniquesCombinees_saf_hist_rcp45          18.89123
# 6      GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85          19.14076
# 7     J2000_20231128/ChroniquesCombinees_saf_hist_rcp26          16.59523
# 8     J2000_20231128/ChroniquesCombinees_saf_hist_rcp45          17.82568
# 9     J2000_20231128/ChroniquesCombinees_saf_hist_rcp85          17.79427
# 10 ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26          18.40631
# 11 ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp45          18.62035
# 12 ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85          18.77329
# 13    SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26          15.90421
# 14    SMASH_20231128/ChroniquesCombinees_saf_hist_rcp45          17.96772
# 15    SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85          18.09425


#RCP 8.5
mean(c(22.74588,19.14076,17.79427,18.77329,18.09425)) # 19.30969
mean(c(22.74588,19.14076,18.77329,18.09425)) # 19.68854

#Sans J2000
mean(c(20.95519,22.29265,22.74588, #CTRIP
       16.83535,18.89123,19.14076, #GRSD
       18.40631,18.62035,18.77329, #ORCHIDEE
       15.90421,17.96772,18.09425)) #SMASH
# 19.05227

#Par modele
mean(c(20.95519,22.29265,22.74588)) #CTRIP 21.99791
mean(c(16.83535,18.89123,19.14076)) #GRSD 18.28911
mean(c(16.59523,17.82568,17.79427)) #J2000 17.40506
mean(c(18.40631,18.62035,18.77329)) #ORCHIDEE 18.59998
mean(c(15.90421,17.96772,18.09425)) #SMASH 17.32206




### H2 2041-2070 ###
results_ <- data.frame(nom_categorieSimu_ = nom_categorieSimu_list_,
                       MeanPFIjuilletOct = NA)
for (n in 1:length(nom_categorieSimu_list_)){
  
  list_ <- list.files(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/FDC_Projections/",nom_categorieSimu_list_[n]), full.names = T)
  means_HER_ = c()
  for (f in 1:length(list_)){
    tab_ <- read.table(list_[f], header = T, sep = ";", dec = ".")
    tab_$Date <- as.Date(tab_$Date)
    tab_filtered <- tab_ %>%
      filter(year(Date) >= 2041 & year(Date) <= 2070 & 
               month(Date) >= 7 & month(Date) <= 10) %>%
      select(contains("debit"))
    debit_means <- colMeans(tab_filtered, na.rm = TRUE)
    means_HER_[f] <- mean(debit_means)
  }
  
  df_means_HER_ <- data.frame(HER = str_before_first(str_after_first(str_after_first(list_,"HER"),"HER"),".txt"),
                              means_HER_ = means_HER_)
  
  df_merge_ <- merge(df_means_HER_, tab_HER_Area, by.x = "HER", by.y = "CdHER2")
  dim(df_merge_)
  
  weighted_mean_HER <- df_merge_ %>%
    summarize(weighted_mean = sum(means_HER_ * Area_km2) / sum(Area_km2))
  # weighted_mean_HER
  
  results_$MeanPFIjuilletOct[n] <- weighted_mean_HER
  print(results_)
  
}

# nom_categorieSimu_ MeanPFIjuilletOct
# 1     CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26          21.04238
# 2     CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45          24.27147
# 3     CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85          25.47667
# 4      GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26          16.63419
# 5      GRSD_20231128/ChroniquesCombinees_saf_hist_rcp45          21.06597
# 6      GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85          22.20215
# 7     J2000_20231128/ChroniquesCombinees_saf_hist_rcp26          16.46626
# 8     J2000_20231128/ChroniquesCombinees_saf_hist_rcp45          18.92942
# 9     J2000_20231128/ChroniquesCombinees_saf_hist_rcp85           19.2214
# 10 ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26          18.48257
# 11 ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp45          19.86258
# 12 ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85          18.81858
# 13    SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26          15.78051
# 14    SMASH_20231128/ChroniquesCombinees_saf_hist_rcp45          19.94981
# 15    SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85          20.96408


#RCP 8.5
mean(c(25.47667,22.20215,19.2214,18.81858,20.96408)) # 21.33658
mean(c(25.47667,22.20215,18.81858,20.96408)) # 21.86537 = 22%, valeur d'Eric

#Sans J2000
mean(c(21.04238,24.27147,25.47667, #CTRIP
       16.63419,21.06597,22.20215, #GRSD
       18.48257,19.86258,18.81858, #ORCHIDEE
       15.78051,19.94981,20.96408)) #SMASH
# 20.37925

#Par modele
mean(c(21.04238,24.27147,25.47667)) #CTRIP 23.59684 
mean(c(16.63419,21.06597,22.20215)) #GRSD 19.96744
mean(c(16.46626,18.92942,19.2214)) #J2000 18.20569
mean(c(18.48257,19.86258,18.81858)) #ORCHIDEE 19.05458
mean(c(15.78051,19.94981,20.96408)) #SMASH 18.89813



### H3 2070-2099 ###
results_ <- data.frame(nom_categorieSimu_ = nom_categorieSimu_list_,
                       MeanPFIjuilletOct = NA)
for (n in 1:length(nom_categorieSimu_list_)){
  
  list_ <- list.files(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/FDC_Projections/",nom_categorieSimu_list_[n]), full.names = T)
  means_HER_ = c()
  for (f in 1:length(list_)){
    tab_ <- read.table(list_[f], header = T, sep = ";", dec = ".")
    tab_$Date <- as.Date(tab_$Date)
    tab_filtered <- tab_ %>%
      filter(year(Date) >= 2070 & year(Date) <= 2099 & 
               month(Date) >= 7 & month(Date) <= 10) %>%
      select(contains("debit"))
    debit_means <- colMeans(tab_filtered, na.rm = TRUE)
    means_HER_[f] <- mean(debit_means)
  }
  
  df_means_HER_ <- data.frame(HER = str_before_first(str_after_first(str_after_first(list_,"HER"),"HER"),".txt"),
                              means_HER_ = means_HER_)
  
  df_merge_ <- merge(df_means_HER_, tab_HER_Area, by.x = "HER", by.y = "CdHER2")
  dim(df_merge_)
  
  weighted_mean_HER <- df_merge_ %>%
    summarize(weighted_mean = sum(means_HER_ * Area_km2) / sum(Area_km2))
  # weighted_mean_HER
  
  results_$MeanPFIjuilletOct[n] <- weighted_mean_HER
  print(results_)
  
}

# nom_categorieSimu_ MeanPFIjuilletOct
# 1     CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26          19.18476
# 2     CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45          24.17865
# 3     CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85          31.10736
# 4      GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26          15.59435
# 5      GRSD_20231128/ChroniquesCombinees_saf_hist_rcp45           21.8585
# 6      GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85          27.76531
# 7     J2000_20231128/ChroniquesCombinees_saf_hist_rcp26            15.535
# 8     J2000_20231128/ChroniquesCombinees_saf_hist_rcp45          19.13208
# 9     J2000_20231128/ChroniquesCombinees_saf_hist_rcp85          22.73182
# 10 ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26          16.93539
# 11 ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp45          18.38264
# 12 ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85          20.35752
# 13    SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26          14.79535
# 14    SMASH_20231128/ChroniquesCombinees_saf_hist_rcp45           20.6968
# 15    SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85          26.03824

#RCP 8.5
mean(c(31.10736,27.76531,22.73182,20.35752,26.03824)) # 25.60005
mean(c(31.10736,27.76531,20.35752,26.03824)) # 26.31711

#Sans J2000
mean(c(19.18476,24.17865,31.10736, #CTRIP
       15.59435,21.8585,27.76531, #GRSD
       16.93539,18.38264,20.35752, #ORCHIDEE
       14.79535,20.6968,26.03824)) #SMASH
#21.40791

#Par modele
mean(c(19.18476,24.17865,31.10736)) #CTRIP 24.82359
mean(c(15.59435,21.8585,27.76531)) #GRSD 21.73939
mean(c(15.535,19.13208,22.73182)) #J2000 19.13297
mean(c(16.93539,18.38264,20.35752)) #ORCHIDEE 18.55852
mean(c(14.79535,20.6968,26.03824)) #SMASH 20.51013




