


CTRIP_rcp85_20702099_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp85.txt",
                                   sep = ";", dec = ".", header = T)
GRSD_rcp85_20702099_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp85.txt",
                                   sep = ";", dec = ".", header = T)
J2000_rcp85_20702099_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp85.txt",
                                   sep = ";", dec = ".", header = T)
ORCHIDEE_rcp85_20702099_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp85.txt",
                                   sep = ";", dec = ".", header = T)
SMASH_rcp85_20702099_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp85.txt",
                                   sep = ";", dec = ".", header = T)

CTRIP_rcp85_19762005_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp85.txt",
                                   sep = ";", dec = ".", header = T)
GRSD_rcp85_19762005_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp85.txt",
                                   sep = ";", dec = ".", header = T)
J2000_rcp85_19762005_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp85.txt",
                                   sep = ";", dec = ".", header = T)
ORCHIDEE_rcp85_19762005_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp85.txt",
                                   sep = ";", dec = ".", header = T)
SMASH_rcp85_19762005_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp85.txt",
                                   sep = ";", dec = ".", header = T)



CTRIP_rcp85_20702099_$difference_init <- as.Date(CTRIP_rcp85_20702099_$initDate_median_) - as.Date(CTRIP_rcp85_19762005_$initDate_median_)
GRSD_rcp85_20702099_$difference_init <- as.Date(GRSD_rcp85_20702099_$initDate_median_) - as.Date(GRSD_rcp85_19762005_$initDate_median_)
J2000_rcp85_20702099_$difference_init <- as.numeric(round((as.Date(J2000_rcp85_20702099_$initDate_median_) - as.Date(J2000_rcp85_19762005_$initDate_median_))/7,1))
ORCHIDEE_rcp85_20702099_$difference_init <- as.Date(ORCHIDEE_rcp85_20702099_$initDate_median_) - as.Date(ORCHIDEE_rcp85_19762005_$initDate_median_)
SMASH_rcp85_20702099_$difference_init <- as.Date(SMASH_rcp85_20702099_$initDate_median_) - as.Date(SMASH_rcp85_19762005_$initDate_median_)

CTRIP_rcp85_20702099_$difference_finish <- as.Date(CTRIP_rcp85_20702099_$finishDate_median_) - as.Date(CTRIP_rcp85_19762005_$finishDate_median_)
GRSD_rcp85_20702099_$difference_finish <- as.Date(GRSD_rcp85_20702099_$finishDate_median_) - as.Date(GRSD_rcp85_19762005_$finishDate_median_)
J2000_rcp85_20702099_$difference_finish <- as.numeric(round((as.Date(J2000_rcp85_20702099_$finishDate_median_) - as.Date(J2000_rcp85_19762005_$finishDate_median_))/7,1))
ORCHIDEE_rcp85_20702099_$difference_finish <- as.Date(ORCHIDEE_rcp85_20702099_$finishDate_median_) - as.Date(ORCHIDEE_rcp85_19762005_$finishDate_median_)
SMASH_rcp85_20702099_$difference_finish <- as.Date(SMASH_rcp85_20702099_$finishDate_median_) - as.Date(SMASH_rcp85_19762005_$finishDate_median_)


tab_ecart_init_ = data.frame(HER = CTRIP_rcp85_20702099_$HER,
                             CTRIP_rcp85_diffInit_ = as.numeric(round(CTRIP_rcp85_20702099_$difference_init/7,1)),
                             GRSD_rcp85_diffInit_ = as.numeric(round(GRSD_rcp85_20702099_$difference_init/7,1)),
                             ORCHIDEE_rcp85_diffInit_ = as.numeric(round(ORCHIDEE_rcp85_20702099_$difference_init/7,1)),
                             SMASH_rcp85_diffInit_ = as.numeric(round(SMASH_rcp85_20702099_$difference_init/7,1)))
tab_ecart_init_ <- merge(tab_ecart_init_, J2000_rcp85_20702099_[,c("HER","difference_init")], by = "HER", all.x = T)

tab_ecart_finish_ = data.frame(HER = CTRIP_rcp85_20702099_$HER,
                               CTRIP_rcp85_diffFinish_ = as.numeric(round(CTRIP_rcp85_20702099_$difference_finish/7,1)),
                               GRSD_rcp85_diffFinish_ = as.numeric(round(GRSD_rcp85_20702099_$difference_finish/7,1)),
                               ORCHIDEE_rcp85_diffFinish_ = as.numeric(round(ORCHIDEE_rcp85_20702099_$difference_finish/7,1)),
                               SMASH_rcp85_diffFinish_ = as.numeric(round(SMASH_rcp85_20702099_$difference_finish/7,1)))
tab_ecart_finish_ <- merge(tab_ecart_finish_, J2000_rcp85_20702099_[,c("HER","finishDate_median_")], by = "HER", all.x = T)


table(rowSums(tab_ecart_finish_[,2:6] > 6, na.rm = T))
tab_ecart_init_$SixWeeksInit <- rowSums(tab_ecart_init_[,2:6] < -5, na.rm = T)
tab_ecart_finish_$SixWeeksFinish <- rowSums(tab_ecart_finish_[,2:6] > 5, na.rm = T)

tab_ecart_init_[which(tab_ecart_init_$SixWeeksInit >= 2),]
tab_ecart_finish_[which(tab_ecart_finish_$SixWeeksFinish >= 2),]
#Jura:3,5
#Alpes:12,14,17,107
#Pyr:67,94,69096



tab_ecart_init_[which(tab_ecart_init_$SixWeeksInit >= 1),]
tab_ecart_finish_[which(tab_ecart_finish_$SixWeeksFinish >= 1),]

