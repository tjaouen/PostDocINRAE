

tab_ = read.table("/home/tjaouen/Documents/Input/ONDE/Data_DatesAjustees/ONDE_RMC_cmpUsuelles_2012_2022_20230316.csv",
                  sep = ";", dec = ".", header = T)

# table(tab_$Annee,month(tab_$DtRealObservation))


dat_ <- table(onde$HER2,paste0(year(onde$Date),"-",month(onde$Date)))

indices_zero <- which(dat_ == 0, arr.ind = TRUE)


indices_zero_filter_ <- indices_zero[which(!(indices_zero[,1] %in% c(8,9,10))),] # Lignes des HER 18, 19, 20
indices_zero_filter_ <- indices_zero_filter_[which(!(indices_zero_filter_[,2] %in% c(6,57))),] # Colonne d un mois d octobre et des NA
indices_zero_filter_

#13, 7
rownames(dat_)[13] # HER 24
colnames(dat_)[7] # 2013-5

#12, 11
rownames(dat_)[12] # HER 22
colnames(dat_)[11] # 2013-9

#12, 22
rownames(dat_)[12] # HER 22
colnames(dat_)[22] # 2016-5

#12, 33
rownames(dat_)[12] # HER 22
colnames(dat_)[33] # 2018-6
