
### Parameters ###
HER_ <- HER_param_

# CTRIP Rcp 8.5 #
CTRIP_H0_rcp85_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
CTRIP_H0_rcp85_$Model = "CTRIP"
CTRIP_H0_rcp85_$Horizon = "H0"
CTRIP_H0_rcp85_$Rcp = "rcp85"
CTRIP_H2_rcp85_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
CTRIP_H2_rcp85_$Model = "CTRIP"
CTRIP_H2_rcp85_$Horizon = "H2"
CTRIP_H2_rcp85_$Rcp = "rcp85"
CTRIP_H3_rcp85_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
CTRIP_H3_rcp85_$Model = "CTRIP"
CTRIP_H3_rcp85_$Horizon = "H3"
CTRIP_H3_rcp85_$Rcp = "rcp85"

# CTRIP Rcp 4.5 #
CTRIP_H0_rcp45_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
CTRIP_H0_rcp45_$Model = "CTRIP"
CTRIP_H0_rcp45_$Horizon = "H0"
CTRIP_H0_rcp45_$Rcp = "rcp45"
CTRIP_H2_rcp45_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
CTRIP_H2_rcp45_$Model = "CTRIP"
CTRIP_H2_rcp45_$Horizon = "H2"
CTRIP_H2_rcp45_$Rcp = "rcp45"
CTRIP_H3_rcp45_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
CTRIP_H3_rcp45_$Model = "CTRIP"
CTRIP_H3_rcp45_$Horizon = "H3"
CTRIP_H3_rcp45_$Rcp = "rcp45"

# CTRIP Rcp 2.6 #
CTRIP_H0_rcp26_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
CTRIP_H0_rcp26_$Model = "CTRIP"
CTRIP_H0_rcp26_$Horizon = "H0"
CTRIP_H0_rcp26_$Rcp = "rcp26"
CTRIP_H2_rcp26_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
CTRIP_H2_rcp26_$Model = "CTRIP"
CTRIP_H2_rcp26_$Horizon = "H2"
CTRIP_H2_rcp26_$Rcp = "rcp26"
CTRIP_H3_rcp26_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
CTRIP_H3_rcp26_$Model = "CTRIP"
CTRIP_H3_rcp26_$Horizon = "H3"
CTRIP_H3_rcp26_$Rcp = "rcp26"

# GRSD Rcp 8.5 #
GRSD_H0_rcp85_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
GRSD_H0_rcp85_$Model = "GRSD"
GRSD_H0_rcp85_$Horizon = "H0"
GRSD_H0_rcp85_$Rcp = "rcp85"
GRSD_H2_rcp85_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
GRSD_H2_rcp85_$Model = "GRSD"
GRSD_H2_rcp85_$Horizon = "H2"
GRSD_H2_rcp85_$Rcp = "rcp85"
GRSD_H3_rcp85_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
GRSD_H3_rcp85_$Model = "GRSD"
GRSD_H3_rcp85_$Horizon = "H3"
GRSD_H3_rcp85_$Rcp = "rcp85"

# GRSD Rcp 4.5 #
GRSD_H0_rcp45_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
GRSD_H0_rcp45_$Model = "GRSD"
GRSD_H0_rcp45_$Horizon = "H0"
GRSD_H0_rcp45_$Rcp = "rcp45"
GRSD_H2_rcp45_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
GRSD_H2_rcp45_$Model = "GRSD"
GRSD_H2_rcp45_$Horizon = "H2"
GRSD_H2_rcp45_$Rcp = "rcp45"
GRSD_H3_rcp45_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
GRSD_H3_rcp45_$Model = "GRSD"
GRSD_H3_rcp45_$Horizon = "H3"
GRSD_H3_rcp45_$Rcp = "rcp45"

# GRSD Rcp 2.6 #
GRSD_H0_rcp26_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
GRSD_H0_rcp26_$Model = "GRSD"
GRSD_H0_rcp26_$Horizon = "H0"
GRSD_H0_rcp26_$Rcp = "rcp26"
GRSD_H2_rcp26_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
GRSD_H2_rcp26_$Model = "GRSD"
GRSD_H2_rcp26_$Horizon = "H2"
GRSD_H2_rcp26_$Rcp = "rcp26"
GRSD_H3_rcp26_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
GRSD_H3_rcp26_$Model = "GRSD"
GRSD_H3_rcp26_$Horizon = "H3"
GRSD_H3_rcp26_$Rcp = "rcp26"

# J2000 Rcm 8.5 #
J2000_H0_rcp85_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
J2000_H0_rcp85_$Model = "J2000"
J2000_H0_rcp85_$Horizon = "H0"
J2000_H0_rcp85_$Rcp = "rcp85"
J2000_H2_rcp85_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
J2000_H2_rcp85_$Model = "J2000"
J2000_H2_rcp85_$Horizon = "H2"
J2000_H2_rcp85_$Rcp = "rcp85"
J2000_H3_rcp85_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
J2000_H3_rcp85_$Model = "J2000"
J2000_H3_rcp85_$Horizon = "H3"
J2000_H3_rcp85_$Rcp = "rcp85"

J2000_H0_rcp45_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
J2000_H0_rcp45_$Model = "J2000"
J2000_H0_rcp45_$Horizon = "H0"
J2000_H0_rcp45_$Rcp = "rcp45"
J2000_H2_rcp45_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
J2000_H2_rcp45_$Model = "J2000"
J2000_H2_rcp45_$Horizon = "H2"
J2000_H2_rcp45_$Rcp = "rcp45"
J2000_H3_rcp45_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
J2000_H3_rcp45_$Model = "J2000"
J2000_H3_rcp45_$Horizon = "H3"
J2000_H3_rcp45_$Rcp = "rcp45"

J2000_H0_rcp26_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
J2000_H0_rcp26_$Model = "J2000"
J2000_H0_rcp26_$Horizon = "H0"
J2000_H0_rcp26_$Rcp = "rcp26"
J2000_H2_rcp26_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
J2000_H2_rcp26_$Model = "J2000"
J2000_H2_rcp26_$Horizon = "H2"
J2000_H2_rcp26_$Rcp = "rcp26"
J2000_H3_rcp26_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
J2000_H3_rcp26_$Model = "J2000"
J2000_H3_rcp26_$Horizon = "H3"
J2000_H3_rcp26_$Rcp = "rcp26"

dim(J2000_H0_rcp26_)
dim(J2000_H0_rcp45_)
dim(J2000_H0_rcp85_)
dim(J2000_H2_rcp26_)
dim(J2000_H2_rcp45_)
dim(J2000_H2_rcp85_)
dim(J2000_H3_rcp26_)
dim(J2000_H3_rcp45_)
dim(J2000_H3_rcp85_)
J2000_H0_rcp26_ <- J2000_H0_rcp26_[which(!J2000_H0_rcp26_$HER == 37054),]
J2000_H0_rcp45_ <- J2000_H0_rcp45_[which(!J2000_H0_rcp45_$HER == 37054),]
J2000_H0_rcp85_ <- J2000_H0_rcp85_[which(!J2000_H0_rcp85_$HER == 37054),]
J2000_H2_rcp26_ <- J2000_H2_rcp26_[which(!J2000_H2_rcp26_$HER == 37054),]
J2000_H2_rcp45_ <- J2000_H2_rcp45_[which(!J2000_H2_rcp45_$HER == 37054),]
J2000_H2_rcp85_ <- J2000_H2_rcp85_[which(!J2000_H2_rcp85_$HER == 37054),]
J2000_H3_rcp26_ <- J2000_H3_rcp26_[which(!J2000_H3_rcp26_$HER == 37054),]
J2000_H3_rcp45_ <- J2000_H3_rcp45_[which(!J2000_H3_rcp45_$HER == 37054),]
J2000_H3_rcp85_ <- J2000_H3_rcp85_[which(!J2000_H3_rcp85_$HER == 37054),]
dim(J2000_H0_rcp26_)
dim(J2000_H0_rcp45_)
dim(J2000_H0_rcp85_)
dim(J2000_H2_rcp26_)
dim(J2000_H2_rcp45_)
dim(J2000_H2_rcp85_)
dim(J2000_H3_rcp26_)
dim(J2000_H3_rcp45_)
dim(J2000_H3_rcp85_)

ORCHIDEE_H0_rcp85_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
ORCHIDEE_H0_rcp85_$Model = "ORCHIDEE"
ORCHIDEE_H0_rcp85_$Horizon = "H0"
ORCHIDEE_H0_rcp85_$Rcp = "rcp85"
ORCHIDEE_H2_rcp85_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
ORCHIDEE_H2_rcp85_$Model = "ORCHIDEE"
ORCHIDEE_H2_rcp85_$Horizon = "H2"
ORCHIDEE_H2_rcp85_$Rcp = "rcp85"
ORCHIDEE_H3_rcp85_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
ORCHIDEE_H3_rcp85_$Model = "ORCHIDEE"
ORCHIDEE_H3_rcp85_$Horizon = "H3"
ORCHIDEE_H3_rcp85_$Rcp = "rcp85"

ORCHIDEE_H0_rcp45_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
ORCHIDEE_H0_rcp45_$Model = "ORCHIDEE"
ORCHIDEE_H0_rcp45_$Horizon = "H0"
ORCHIDEE_H0_rcp45_$Rcp = "rcp45"
ORCHIDEE_H2_rcp45_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
ORCHIDEE_H2_rcp45_$Model = "ORCHIDEE"
ORCHIDEE_H2_rcp45_$Horizon = "H2"
ORCHIDEE_H2_rcp45_$Rcp = "rcp45"
ORCHIDEE_H3_rcp45_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
ORCHIDEE_H3_rcp45_$Model = "ORCHIDEE"
ORCHIDEE_H3_rcp45_$Horizon = "H3"
ORCHIDEE_H3_rcp45_$Rcp = "rcp45"

ORCHIDEE_H0_rcp26_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
ORCHIDEE_H0_rcp26_$Model = "ORCHIDEE"
ORCHIDEE_H0_rcp26_$Horizon = "H0"
ORCHIDEE_H0_rcp26_$Rcp = "rcp26"
ORCHIDEE_H2_rcp26_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
ORCHIDEE_H2_rcp26_$Model = "ORCHIDEE"
ORCHIDEE_H2_rcp26_$Horizon = "H2"
ORCHIDEE_H2_rcp26_$Rcp = "rcp26"
ORCHIDEE_H3_rcp26_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
ORCHIDEE_H3_rcp26_$Model = "ORCHIDEE"
ORCHIDEE_H3_rcp26_$Horizon = "H3"
ORCHIDEE_H3_rcp26_$Rcp = "rcp26"

SMASH_H0_rcp85_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
SMASH_H0_rcp85_$Model = "SMASH"
SMASH_H0_rcp85_$Horizon = "H0"
SMASH_H0_rcp85_$Rcp = "rcp85"
SMASH_H2_rcp85_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
SMASH_H2_rcp85_$Model = "SMASH"
SMASH_H2_rcp85_$Horizon = "H2"
SMASH_H2_rcp85_$Rcp = "rcp85"
SMASH_H3_rcp85_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
SMASH_H3_rcp85_$Model = "SMASH"
SMASH_H3_rcp85_$Horizon = "H3"
SMASH_H3_rcp85_$Rcp = "rcp85"

SMASH_H0_rcp45_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
SMASH_H0_rcp45_$Model = "SMASH"
SMASH_H0_rcp45_$Horizon = "H0"
SMASH_H0_rcp45_$Rcp = "rcp45"
SMASH_H2_rcp45_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
SMASH_H2_rcp45_$Model = "SMASH"
SMASH_H2_rcp45_$Horizon = "H2"
SMASH_H2_rcp45_$Rcp = "rcp45"
SMASH_H3_rcp45_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
SMASH_H3_rcp45_$Model = "SMASH"
SMASH_H3_rcp45_$Horizon = "H3"
SMASH_H3_rcp45_$Rcp = "rcp45"

SMASH_H0_rcp26_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
SMASH_H0_rcp26_$Model = "SMASH"
SMASH_H0_rcp26_$Horizon = "H0"
SMASH_H0_rcp26_$Rcp = "rcp26"
SMASH_H2_rcp26_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
SMASH_H2_rcp26_$Model = "SMASH"
SMASH_H2_rcp26_$Horizon = "H2"
SMASH_H2_rcp26_$Rcp = "rcp26"
SMASH_H3_rcp26_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
SMASH_H3_rcp26_$Model = "SMASH"
SMASH_H3_rcp26_$Horizon = "H3"
SMASH_H3_rcp26_$Rcp = "rcp26"

tab_proj_ <- rbind(CTRIP_H0_rcp26_,
                   CTRIP_H0_rcp45_,
                   CTRIP_H0_rcp85_,
                   CTRIP_H2_rcp26_,
                   CTRIP_H2_rcp45_,
                   CTRIP_H2_rcp85_,
                   CTRIP_H3_rcp26_,
                   CTRIP_H3_rcp45_,
                   CTRIP_H3_rcp85_,
                   GRSD_H0_rcp26_,
                   GRSD_H0_rcp45_,
                   GRSD_H0_rcp85_,
                   GRSD_H2_rcp26_,
                   GRSD_H2_rcp45_,
                   GRSD_H2_rcp85_,
                   GRSD_H3_rcp26_,
                   GRSD_H3_rcp45_,
                   GRSD_H3_rcp85_,
                   J2000_H0_rcp26_,
                   J2000_H0_rcp45_,
                   J2000_H0_rcp85_,
                   J2000_H2_rcp26_,
                   J2000_H2_rcp45_,
                   J2000_H2_rcp85_,
                   J2000_H3_rcp26_,
                   J2000_H3_rcp45_,
                   J2000_H3_rcp85_,
                   ORCHIDEE_H0_rcp26_,
                   ORCHIDEE_H0_rcp45_,
                   ORCHIDEE_H0_rcp85_,
                   ORCHIDEE_H2_rcp26_,
                   ORCHIDEE_H2_rcp45_,
                   ORCHIDEE_H2_rcp85_,
                   ORCHIDEE_H3_rcp26_,
                   ORCHIDEE_H3_rcp45_,
                   ORCHIDEE_H3_rcp85_,
                   SMASH_H0_rcp26_,
                   SMASH_H0_rcp45_,
                   SMASH_H0_rcp85_,
                   SMASH_H2_rcp26_,
                   SMASH_H2_rcp45_,
                   SMASH_H2_rcp85_,
                   SMASH_H3_rcp26_,
                   SMASH_H3_rcp45_,
                   SMASH_H3_rcp85_)
dim(tab_proj_)

# Je prends la mediane de la dateInit sur les annees 1976-2005 pour chaque scenario et chaque HM
# Je regarde le min de tous les scenarios et tous les HM
# Je regarde le max de tous les scenarios et tous les HM
# Je regarde le min et le max par HM de leur scenarios medians


makeBlocTable_initDate_ <- function(HER_){
  
  for (mod in unique(tab_proj_$Model)){
    for (hor in unique(tab_proj_$Horizon)){
      for (rcp in unique(tab_proj_$Rcp)){
        vect_ <- c(tab_proj_$initDate_min_[which(tab_proj_$Model == mod & tab_proj_$Horizon == hor & tab_proj_$Rcp == rcp & tab_proj_$HER == HER_)],
                   tab_proj_$initDate_median_[which(tab_proj_$Model == mod & tab_proj_$Horizon == hor & tab_proj_$Rcp == rcp & tab_proj_$HER == HER_)],
                   tab_proj_$initDate_max_[which(tab_proj_$Model == mod & tab_proj_$Horizon == hor & tab_proj_$Rcp == rcp & tab_proj_$HER == HER_)])
      }
    }
  }
  
  vect_ <- c(
    
    ### H0 rcp 26 ###
    tab_proj_$initDate_min_[which(tab_proj_$Model == "CTRIP" & tab_proj_$Horizon == "H0" & tab_proj_$Rcp == "rcp26" & tab_proj_$HER == HER_)],
    tab_proj_$initDate_min_[which(tab_proj_$Model == "GRSD" & tab_proj_$Horizon == "H0" & tab_proj_$Rcp == "rcp26" & tab_proj_$HER == HER_)],
    tab_proj_$initDate_min_[which(tab_proj_$Model == "ORCHIDEE" & tab_proj_$Horizon == "H0" & tab_proj_$Rcp == "rcp26" & tab_proj_$HER == HER_)],
    tab_proj_$initDate_min_[which(tab_proj_$Model == "SMASH" & tab_proj_$Horizon == "H0" & tab_proj_$Rcp == "rcp26" & tab_proj_$HER == HER_)],
    
    tab_proj_$initDate_median_[which(tab_proj_$Model == "CTRIP" & tab_proj_$Horizon == "H0" & tab_proj_$Rcp == "rcp26" & tab_proj_$HER == HER_)],
    tab_proj_$initDate_median_[which(tab_proj_$Model == "GRSD" & tab_proj_$Horizon == "H0" & tab_proj_$Rcp == "rcp26" & tab_proj_$HER == HER_)],
    tab_proj_$initDate_median_[which(tab_proj_$Model == "ORCHIDEE" & tab_proj_$Horizon == "H0" & tab_proj_$Rcp == "rcp26" & tab_proj_$HER == HER_)],
    tab_proj_$initDate_median_[which(tab_proj_$Model == "SMASH" & tab_proj_$Horizon == "H0" & tab_proj_$Rcp == "rcp26" & tab_proj_$HER == HER_)],
    
    tab_proj_$initDate_max_[which(tab_proj_$Model == "CTRIP" & tab_proj_$Horizon == "H0" & tab_proj_$Rcp == "rcp26" & tab_proj_$HER == HER_)],
    tab_proj_$initDate_max_[which(tab_proj_$Model == "GRSD" & tab_proj_$Horizon == "H0" & tab_proj_$Rcp == "rcp26" & tab_proj_$HER == HER_)],
    tab_proj_$initDate_max_[which(tab_proj_$Model == "ORCHIDEE" & tab_proj_$Horizon == "H0" & tab_proj_$Rcp == "rcp26" & tab_proj_$HER == HER_)],
    tab_proj_$initDate_max_[which(tab_proj_$Model == "SMASH" & tab_proj_$Horizon == "H0" & tab_proj_$Rcp == "rcp26" & tab_proj_$HER == HER_)],
    
    ### H0 rcp 45 ###
    tab_proj_$initDate_min_[which(tab_proj_$Model == "CTRIP" & tab_proj_$Horizon == "H0" & tab_proj_$Rcp == "rcp45" & tab_proj_$HER == HER_)],
    tab_proj_$initDate_min_[which(tab_proj_$Model == "GRSD" & tab_proj_$Horizon == "H0" & tab_proj_$Rcp == "rcp45" & tab_proj_$HER == HER_)],
    tab_proj_$initDate_min_[which(tab_proj_$Model == "ORCHIDEE" & tab_proj_$Horizon == "H0" & tab_proj_$Rcp == "rcp45" & tab_proj_$HER == HER_)],
    tab_proj_$initDate_min_[which(tab_proj_$Model == "SMASH" & tab_proj_$Horizon == "H0" & tab_proj_$Rcp == "rcp45" & tab_proj_$HER == HER_)],
    
    tab_proj_$initDate_median_[which(tab_proj_$Model == "CTRIP" & tab_proj_$Horizon == "H0" & tab_proj_$Rcp == "rcp45" & tab_proj_$HER == HER_)],
    tab_proj_$initDate_median_[which(tab_proj_$Model == "GRSD" & tab_proj_$Horizon == "H0" & tab_proj_$Rcp == "rcp45" & tab_proj_$HER == HER_)],
    tab_proj_$initDate_median_[which(tab_proj_$Model == "ORCHIDEE" & tab_proj_$Horizon == "H0" & tab_proj_$Rcp == "rcp45" & tab_proj_$HER == HER_)],
    tab_proj_$initDate_median_[which(tab_proj_$Model == "SMASH" & tab_proj_$Horizon == "H0" & tab_proj_$Rcp == "rcp45" & tab_proj_$HER == HER_)],
    
    tab_proj_$initDate_max_[which(tab_proj_$Model == "CTRIP" & tab_proj_$Horizon == "H0" & tab_proj_$Rcp == "rcp45" & tab_proj_$HER == HER_)],
    tab_proj_$initDate_max_[which(tab_proj_$Model == "GRSD" & tab_proj_$Horizon == "H0" & tab_proj_$Rcp == "rcp45" & tab_proj_$HER == HER_)],
    tab_proj_$initDate_max_[which(tab_proj_$Model == "ORCHIDEE" & tab_proj_$Horizon == "H0" & tab_proj_$Rcp == "rcp45" & tab_proj_$HER == HER_)],
    tab_proj_$initDate_max_[which(tab_proj_$Model == "SMASH" & tab_proj_$Horizon == "H0" & tab_proj_$Rcp == "rcp45" & tab_proj_$HER == HER_)],
    
    
    ### H2 57 ###
    format(min(c(as.Date(CTRIP_H2_$initDate_min_[which(CTRIP_H2_$HER == HER_)]),
                 as.Date(GRSD_H2_$initDate_min_[which(GRSD_H2_$HER == HER_)]),
                 as.Date(ORCHIDEE_H2_$initDate_min_[which(ORCHIDEE_H2_$HER == HER_)]),
                 as.Date(SMASH_H2_$initDate_min_[which(SMASH_H2_$HER == HER_)]))),"%d/%m"),
    
    format(median(c(as.Date(CTRIP_H2_$initDate_median_[which(CTRIP_H2_$HER == HER_)]),
                    as.Date(GRSD_H2_$initDate_median_[which(GRSD_H2_$HER == HER_)]),
                    as.Date(ORCHIDEE_H2_$initDate_median_[which(ORCHIDEE_H2_$HER == HER_)]),
                    as.Date(SMASH_H2_$initDate_median_[which(SMASH_H2_$HER == HER_)]))),"%d/%m"),
    
    format(max(c(as.Date(CTRIP_H2_$initDate_max_[which(CTRIP_H2_$HER == HER_)]),
                 as.Date(GRSD_H2_$initDate_max_[which(GRSD_H2_$HER == HER_)]),
                 as.Date(ORCHIDEE_H2_$initDate_max_[which(ORCHIDEE_H2_$HER == HER_)]),
                 as.Date(SMASH_H2_$initDate_max_[which(SMASH_H2_$HER == HER_)]))),"%d/%m"),
    
    ### H3 57 ###
    format(min(c(as.Date(CTRIP_H3_$initDate_min_[which(CTRIP_H3_$HER == HER_)]),
                 as.Date(GRSD_H3_$initDate_min_[which(GRSD_H3_$HER == HER_)]),
                 as.Date(ORCHIDEE_H3_$initDate_min_[which(ORCHIDEE_H3_$HER == HER_)]),
                 as.Date(SMASH_H3_$initDate_min_[which(SMASH_H3_$HER == HER_)]))),"%d/%m"),
    
    format(median(c(as.Date(CTRIP_H3_$initDate_median_[which(CTRIP_H3_$HER == HER_)]),
                    as.Date(GRSD_H3_$initDate_median_[which(GRSD_H3_$HER == HER_)]),
                    as.Date(ORCHIDEE_H3_$initDate_median_[which(ORCHIDEE_H3_$HER == HER_)]),
                    as.Date(SMASH_H3_$initDate_median_[which(SMASH_H3_$HER == HER_)]))),"%d/%m"),
    
    format(max(c(as.Date(CTRIP_H3_$initDate_max_[which(CTRIP_H3_$HER == HER_)]),
                 as.Date(GRSD_H3_$initDate_max_[which(GRSD_H3_$HER == HER_)]),
                 as.Date(ORCHIDEE_H3_$initDate_max_[which(ORCHIDEE_H3_$HER == HER_)]),
                 as.Date(SMASH_H3_$initDate_max_[which(SMASH_H3_$HER == HER_)]))),"%d/%m"))
  
  return(matrix(vect_, ncol = 3, byrow = T))
  
  
}

makeBlocTable_finishDate_ <- function(HER_){
  
  vect_ <- c(
    
    ### H0 57 ###
    format(min(c(as.Date(CTRIP_H0_$finishDate_min_[which(CTRIP_H0_$HER == HER_)]),
                 as.Date(GRSD_H0_$finishDate_min_[which(GRSD_H0_$HER == HER_)]),
                 as.Date(ORCHIDEE_H0_$finishDate_min_[which(ORCHIDEE_H0_$HER == HER_)]),
                 as.Date(SMASH_H0_$finishDate_min_[which(SMASH_H0_$HER == HER_)]))),"%d/%m"),
    
    format(median(c(as.Date(CTRIP_H0_$finishDate_median_[which(CTRIP_H0_$HER == HER_)]),
                    as.Date(GRSD_H0_$finishDate_median_[which(GRSD_H0_$HER == HER_)]),
                    as.Date(ORCHIDEE_H0_$finishDate_median_[which(ORCHIDEE_H0_$HER == HER_)]),
                    as.Date(SMASH_H0_$finishDate_median_[which(SMASH_H0_$HER == HER_)]))),"%d/%m"),
    
    format(max(c(as.Date(CTRIP_H0_$finishDate_max_[which(CTRIP_H0_$HER == HER_)]),
                 as.Date(GRSD_H0_$finishDate_max_[which(GRSD_H0_$HER == HER_)]),
                 as.Date(ORCHIDEE_H0_$finishDate_max_[which(ORCHIDEE_H0_$HER == HER_)]),
                 as.Date(SMASH_H0_$finishDate_max_[which(SMASH_H0_$HER == HER_)]))),"%d/%m"),
    
    ### H2 57 ###
    format(min(c(as.Date(CTRIP_H2_$finishDate_min_[which(CTRIP_H2_$HER == HER_)]),
                 as.Date(GRSD_H2_$finishDate_min_[which(GRSD_H2_$HER == HER_)]),
                 as.Date(ORCHIDEE_H2_$finishDate_min_[which(ORCHIDEE_H2_$HER == HER_)]),
                 as.Date(SMASH_H2_$finishDate_min_[which(SMASH_H2_$HER == HER_)]))),"%d/%m"),
    
    format(median(c(as.Date(CTRIP_H2_$finishDate_median_[which(CTRIP_H2_$HER == HER_)]),
                    as.Date(GRSD_H2_$finishDate_median_[which(GRSD_H2_$HER == HER_)]),
                    as.Date(ORCHIDEE_H2_$finishDate_median_[which(ORCHIDEE_H2_$HER == HER_)]),
                    as.Date(SMASH_H2_$finishDate_median_[which(SMASH_H2_$HER == HER_)]))),"%d/%m"),
    
    format(max(c(as.Date(CTRIP_H2_$finishDate_max_[which(CTRIP_H2_$HER == HER_)]),
                 as.Date(GRSD_H2_$finishDate_max_[which(GRSD_H2_$HER == HER_)]),
                 as.Date(ORCHIDEE_H2_$finishDate_max_[which(ORCHIDEE_H2_$HER == HER_)]),
                 as.Date(SMASH_H2_$finishDate_max_[which(SMASH_H2_$HER == HER_)]))),"%d/%m"),
    
    ### H3 57 ###
    format(min(c(as.Date(CTRIP_H3_$finishDate_min_[which(CTRIP_H3_$HER == HER_)]),
                 as.Date(GRSD_H3_$finishDate_min_[which(GRSD_H3_$HER == HER_)]),
                 as.Date(ORCHIDEE_H3_$finishDate_min_[which(ORCHIDEE_H3_$HER == HER_)]),
                 as.Date(SMASH_H3_$finishDate_min_[which(SMASH_H3_$HER == HER_)]))),"%d/%m"),
    
    format(median(c(as.Date(CTRIP_H3_$finishDate_median_[which(CTRIP_H3_$HER == HER_)]),
                    as.Date(GRSD_H3_$finishDate_median_[which(GRSD_H3_$HER == HER_)]),
                    as.Date(ORCHIDEE_H3_$finishDate_median_[which(ORCHIDEE_H3_$HER == HER_)]),
                    as.Date(SMASH_H3_$finishDate_median_[which(SMASH_H3_$HER == HER_)]))),"%d/%m"),
    
    format(max(c(as.Date(CTRIP_H3_$finishDate_max_[which(CTRIP_H3_$HER == HER_)]),
                 as.Date(GRSD_H3_$finishDate_max_[which(GRSD_H3_$HER == HER_)]),
                 as.Date(ORCHIDEE_H3_$finishDate_max_[which(ORCHIDEE_H3_$HER == HER_)]),
                 as.Date(SMASH_H3_$finishDate_max_[which(SMASH_H3_$HER == HER_)]))),"%d/%m"))
  
  return(matrix(vect_, ncol = 3, byrow = T))
  
}

makeBlocTable_ProbaMean_ <- function(HER_){
  
  vect_ <- c(
    
    ### H0 rcp 85 ###
    min(CTRIP_H0_rcp85_$propAssecMoyenneJuilletOct_ModeleMin_[which(CTRIP_H0_rcp85_$HER == HER_)],
        GRSD_H0_rcp85_$propAssecMoyenneJuilletOct_ModeleMin_[which(GRSD_H0_rcp85_$HER == HER_)],
        ORCHIDEE_H0_rcp85_$propAssecMoyenneJuilletOct_ModeleMin_[which(ORCHIDEE_H0_rcp85_$HER == HER_)],
        SMASH_H0_rcp85_$propAssecMoyenneJuilletOct_ModeleMin_[which(SMASH_H0_rcp85_$HER == HER_)]),
    
    median(CTRIP_H0_rcp85_$propAssecMoyenneJuilletOct_ModeleMedian_[which(CTRIP_H0_rcp85_$HER == HER_)],
           GRSD_H0_rcp85_$propAssecMoyenneJuilletOct_ModeleMedian_[which(GRSD_H0_rcp85_$HER == HER_)],
           ORCHIDEE_H0_rcp85_$propAssecMoyenneJuilletOct_ModeleMedian_[which(ORCHIDEE_H0_rcp85_$HER == HER_)],
           SMASH_H0_rcp85_$propAssecMoyenneJuilletOct_ModeleMedian_[which(SMASH_H0_rcp85_$HER == HER_)]),
    
    max(CTRIP_H0_rcp85_$propAssecMoyenneJuilletOct_ModeleMax_[which(CTRIP_H0_rcp85_$HER == HER_)],
        GRSD_H0_rcp85_$propAssecMoyenneJuilletOct_ModeleMax_[which(GRSD_H0_rcp85_$HER == HER_)],
        ORCHIDEE_H0_rcp85_$propAssecMoyenneJuilletOct_ModeleMax_[which(ORCHIDEE_H0_rcp85_$HER == HER_)],
        SMASH_H0_rcp85_$propAssecMoyenneJuilletOct_ModeleMax_[which(SMASH_H0_rcp85_$HER == HER_)]),
    
    ### H2 rcp 85 ###
    min(CTRIP_H2_rcp85_$propAssecMoyenneJuilletOct_ModeleMin_[which(CTRIP_H2_rcp85_$HER == HER_)],
        GRSD_H2_rcp85_$propAssecMoyenneJuilletOct_ModeleMin_[which(GRSD_H2_rcp85_$HER == HER_)],
        ORCHIDEE_H2_rcp85_$propAssecMoyenneJuilletOct_ModeleMin_[which(ORCHIDEE_H2_rcp85_$HER == HER_)],
        SMASH_H2_rcp85_$propAssecMoyenneJuilletOct_ModeleMin_[which(SMASH_H2_rcp85_$HER == HER_)]),
    
    median(CTRIP_H2_rcp85_$propAssecMoyenneJuilletOct_ModeleMedian_[which(CTRIP_H2_rcp85_$HER == HER_)],
           GRSD_H2_rcp85_$propAssecMoyenneJuilletOct_ModeleMedian_[which(GRSD_H2_rcp85_$HER == HER_)],
           ORCHIDEE_H2_rcp85_$propAssecMoyenneJuilletOct_ModeleMedian_[which(ORCHIDEE_H2_rcp85_$HER == HER_)],
           SMASH_H2_rcp85_$propAssecMoyenneJuilletOct_ModeleMedian_[which(SMASH_H2_rcp85_$HER == HER_)]),
    
    max(CTRIP_H2_rcp85_$propAssecMoyenneJuilletOct_ModeleMax_[which(CTRIP_H2_rcp85_$HER == HER_)],
        GRSD_H2_rcp85_$propAssecMoyenneJuilletOct_ModeleMax_[which(GRSD_H2_rcp85_$HER == HER_)],
        ORCHIDEE_H2_rcp85_$propAssecMoyenneJuilletOct_ModeleMax_[which(ORCHIDEE_H2_rcp85_$HER == HER_)],
        SMASH_H2_rcp85_$propAssecMoyenneJuilletOct_ModeleMax_[which(SMASH_H2_rcp85_$HER == HER_)]),
    
    ### H3 rcp 85 ###
    min(CTRIP_H3_rcp85_$propAssecMoyenneJuilletOct_ModeleMin_[which(CTRIP_H3_rcp85_$HER == HER_)],
        GRSD_H3_rcp85_$propAssecMoyenneJuilletOct_ModeleMin_[which(GRSD_H3_rcp85_$HER == HER_)],
        ORCHIDEE_H3_rcp85_$propAssecMoyenneJuilletOct_ModeleMin_[which(ORCHIDEE_H3_rcp85_$HER == HER_)],
        SMASH_H3_rcp85_$propAssecMoyenneJuilletOct_ModeleMin_[which(SMASH_H3_rcp85_$HER == HER_)]),
    
    median(CTRIP_H3_rcp85_$propAssecMoyenneJuilletOct_ModeleMedian_[which(CTRIP_H3_rcp85_$HER == HER_)],
           GRSD_H3_rcp85_$propAssecMoyenneJuilletOct_ModeleMedian_[which(GRSD_H3_rcp85_$HER == HER_)],
           ORCHIDEE_H3_rcp85_$propAssecMoyenneJuilletOct_ModeleMedian_[which(ORCHIDEE_H3_rcp85_$HER == HER_)],
           SMASH_H3_rcp85_$propAssecMoyenneJuilletOct_ModeleMedian_[which(SMASH_H3_rcp85_$HER == HER_)]),
    
    max(CTRIP_H3_rcp85_$propAssecMoyenneJuilletOct_ModeleMax_[which(CTRIP_H3_rcp85_$HER == HER_)],
        GRSD_H3_rcp85_$propAssecMoyenneJuilletOct_ModeleMax_[which(GRSD_H3_rcp85_$HER == HER_)],
        ORCHIDEE_H3_rcp85_$propAssecMoyenneJuilletOct_ModeleMax_[which(ORCHIDEE_H3_rcp85_$HER == HER_)],
        SMASH_H3_rcp85_$propAssecMoyenneJuilletOct_ModeleMax_[which(SMASH_H3_rcp85_$HER == HER_)]),
  
  
  ### H0 rcp 45 ###
  min(CTRIP_H0_rcp45_$propAssecMoyenneJuilletOct_ModeleMin_[which(CTRIP_H0_rcp45_$HER == HER_)],
      GRSD_H0_rcp45_$propAssecMoyenneJuilletOct_ModeleMin_[which(GRSD_H0_rcp45_$HER == HER_)],
      ORCHIDEE_H0_rcp45_$propAssecMoyenneJuilletOct_ModeleMin_[which(ORCHIDEE_H0_rcp45_$HER == HER_)],
      SMASH_H0_rcp45_$propAssecMoyenneJuilletOct_ModeleMin_[which(SMASH_H0_rcp45_$HER == HER_)]),
  
  median(CTRIP_H0_rcp45_$propAssecMoyenneJuilletOct_ModeleMedian_[which(CTRIP_H0_rcp45_$HER == HER_)],
         GRSD_H0_rcp45_$propAssecMoyenneJuilletOct_ModeleMedian_[which(GRSD_H0_rcp45_$HER == HER_)],
         ORCHIDEE_H0_rcp45_$propAssecMoyenneJuilletOct_ModeleMedian_[which(ORCHIDEE_H0_rcp45_$HER == HER_)],
         SMASH_H0_rcp45_$propAssecMoyenneJuilletOct_ModeleMedian_[which(SMASH_H0_rcp45_$HER == HER_)]),
  
  max(CTRIP_H0_rcp45_$propAssecMoyenneJuilletOct_ModeleMax_[which(CTRIP_H0_rcp45_$HER == HER_)],
      GRSD_H0_rcp45_$propAssecMoyenneJuilletOct_ModeleMax_[which(GRSD_H0_rcp45_$HER == HER_)],
      ORCHIDEE_H0_rcp45_$propAssecMoyenneJuilletOct_ModeleMax_[which(ORCHIDEE_H0_rcp45_$HER == HER_)],
      SMASH_H0_rcp45_$propAssecMoyenneJuilletOct_ModeleMax_[which(SMASH_H0_rcp45_$HER == HER_)]),
  
  ### H2 rcp 45 ###
  min(CTRIP_H2_rcp45_$propAssecMoyenneJuilletOct_ModeleMin_[which(CTRIP_H2_rcp45_$HER == HER_)],
      GRSD_H2_rcp45_$propAssecMoyenneJuilletOct_ModeleMin_[which(GRSD_H2_rcp45_$HER == HER_)],
      ORCHIDEE_H2_rcp45_$propAssecMoyenneJuilletOct_ModeleMin_[which(ORCHIDEE_H2_rcp45_$HER == HER_)],
      SMASH_H2_rcp45_$propAssecMoyenneJuilletOct_ModeleMin_[which(SMASH_H2_rcp45_$HER == HER_)]),
  
  median(CTRIP_H2_rcp45_$propAssecMoyenneJuilletOct_ModeleMedian_[which(CTRIP_H2_rcp45_$HER == HER_)],
         GRSD_H2_rcp45_$propAssecMoyenneJuilletOct_ModeleMedian_[which(GRSD_H2_rcp45_$HER == HER_)],
         ORCHIDEE_H2_rcp45_$propAssecMoyenneJuilletOct_ModeleMedian_[which(ORCHIDEE_H2_rcp45_$HER == HER_)],
         SMASH_H2_rcp45_$propAssecMoyenneJuilletOct_ModeleMedian_[which(SMASH_H2_rcp45_$HER == HER_)]),
  
  max(CTRIP_H2_rcp45_$propAssecMoyenneJuilletOct_ModeleMax_[which(CTRIP_H2_rcp45_$HER == HER_)],
      GRSD_H2_rcp45_$propAssecMoyenneJuilletOct_ModeleMax_[which(GRSD_H2_rcp45_$HER == HER_)],
      ORCHIDEE_H2_rcp45_$propAssecMoyenneJuilletOct_ModeleMax_[which(ORCHIDEE_H2_rcp45_$HER == HER_)],
      SMASH_H2_rcp45_$propAssecMoyenneJuilletOct_ModeleMax_[which(SMASH_H2_rcp45_$HER == HER_)]),
  
  ### H3 rcp 45 ###
  min(CTRIP_H3_rcp45_$propAssecMoyenneJuilletOct_ModeleMin_[which(CTRIP_H3_rcp45_$HER == HER_)],
      GRSD_H3_rcp45_$propAssecMoyenneJuilletOct_ModeleMin_[which(GRSD_H3_rcp45_$HER == HER_)],
      ORCHIDEE_H3_rcp45_$propAssecMoyenneJuilletOct_ModeleMin_[which(ORCHIDEE_H3_rcp45_$HER == HER_)],
      SMASH_H3_rcp45_$propAssecMoyenneJuilletOct_ModeleMin_[which(SMASH_H3_rcp45_$HER == HER_)]),
  
  median(CTRIP_H3_rcp45_$propAssecMoyenneJuilletOct_ModeleMedian_[which(CTRIP_H3_rcp45_$HER == HER_)],
         GRSD_H3_rcp45_$propAssecMoyenneJuilletOct_ModeleMedian_[which(GRSD_H3_rcp45_$HER == HER_)],
         ORCHIDEE_H3_rcp45_$propAssecMoyenneJuilletOct_ModeleMedian_[which(ORCHIDEE_H3_rcp45_$HER == HER_)],
         SMASH_H3_rcp45_$propAssecMoyenneJuilletOct_ModeleMedian_[which(SMASH_H3_rcp45_$HER == HER_)]),
  
  max(CTRIP_H3_rcp45_$propAssecMoyenneJuilletOct_ModeleMax_[which(CTRIP_H3_rcp45_$HER == HER_)],
      GRSD_H3_rcp45_$propAssecMoyenneJuilletOct_ModeleMax_[which(GRSD_H3_rcp45_$HER == HER_)],
      ORCHIDEE_H3_rcp45_$propAssecMoyenneJuilletOct_ModeleMax_[which(ORCHIDEE_H3_rcp45_$HER == HER_)],
      SMASH_H3_rcp45_$propAssecMoyenneJuilletOct_ModeleMax_[which(SMASH_H3_rcp45_$HER == HER_)]),
  

  ### H0 rcp 26 ###
  min(CTRIP_H0_rcp26_$propAssecMoyenneJuilletOct_ModeleMin_[which(CTRIP_H0_rcp26_$HER == HER_)],
      GRSD_H0_rcp26_$propAssecMoyenneJuilletOct_ModeleMin_[which(GRSD_H0_rcp26_$HER == HER_)],
      ORCHIDEE_H0_rcp26_$propAssecMoyenneJuilletOct_ModeleMin_[which(ORCHIDEE_H0_rcp26_$HER == HER_)],
      SMASH_H0_rcp26_$propAssecMoyenneJuilletOct_ModeleMin_[which(SMASH_H0_rcp26_$HER == HER_)]),
  
  median(CTRIP_H0_rcp26_$propAssecMoyenneJuilletOct_ModeleMedian_[which(CTRIP_H0_rcp26_$HER == HER_)],
         GRSD_H0_rcp26_$propAssecMoyenneJuilletOct_ModeleMedian_[which(GRSD_H0_rcp26_$HER == HER_)],
         ORCHIDEE_H0_rcp26_$propAssecMoyenneJuilletOct_ModeleMedian_[which(ORCHIDEE_H0_rcp26_$HER == HER_)],
         SMASH_H0_rcp26_$propAssecMoyenneJuilletOct_ModeleMedian_[which(SMASH_H0_rcp26_$HER == HER_)]),
  
  max(CTRIP_H0_rcp26_$propAssecMoyenneJuilletOct_ModeleMax_[which(CTRIP_H0_rcp26_$HER == HER_)],
      GRSD_H0_rcp26_$propAssecMoyenneJuilletOct_ModeleMax_[which(GRSD_H0_rcp26_$HER == HER_)],
      ORCHIDEE_H0_rcp26_$propAssecMoyenneJuilletOct_ModeleMax_[which(ORCHIDEE_H0_rcp26_$HER == HER_)],
      SMASH_H0_rcp26_$propAssecMoyenneJuilletOct_ModeleMax_[which(SMASH_H0_rcp26_$HER == HER_)]),
  
  ### H2 rcp 45 ###
  min(CTRIP_H2_rcp26_$propAssecMoyenneJuilletOct_ModeleMin_[which(CTRIP_H2_rcp26_$HER == HER_)],
      GRSD_H2_rcp26_$propAssecMoyenneJuilletOct_ModeleMin_[which(GRSD_H2_rcp26_$HER == HER_)],
      ORCHIDEE_H2_rcp26_$propAssecMoyenneJuilletOct_ModeleMin_[which(ORCHIDEE_H2_rcp26_$HER == HER_)],
      SMASH_H2_rcp26_$propAssecMoyenneJuilletOct_ModeleMin_[which(SMASH_H2_rcp26_$HER == HER_)]),
  
  median(CTRIP_H2_rcp26_$propAssecMoyenneJuilletOct_ModeleMedian_[which(CTRIP_H2_rcp26_$HER == HER_)],
         GRSD_H2_rcp26_$propAssecMoyenneJuilletOct_ModeleMedian_[which(GRSD_H2_rcp26_$HER == HER_)],
         ORCHIDEE_H2_rcp26_$propAssecMoyenneJuilletOct_ModeleMedian_[which(ORCHIDEE_H2_rcp26_$HER == HER_)],
         SMASH_H2_rcp26_$propAssecMoyenneJuilletOct_ModeleMedian_[which(SMASH_H2_rcp26_$HER == HER_)]),
  
  max(CTRIP_H2_rcp26_$propAssecMoyenneJuilletOct_ModeleMax_[which(CTRIP_H2_rcp26_$HER == HER_)],
      GRSD_H2_rcp26_$propAssecMoyenneJuilletOct_ModeleMax_[which(GRSD_H2_rcp26_$HER == HER_)],
      ORCHIDEE_H2_rcp26_$propAssecMoyenneJuilletOct_ModeleMax_[which(ORCHIDEE_H2_rcp26_$HER == HER_)],
      SMASH_H2_rcp26_$propAssecMoyenneJuilletOct_ModeleMax_[which(SMASH_H2_rcp26_$HER == HER_)]),
  
  ### H3 rcp 45 ###
  min(CTRIP_H3_rcp26_$propAssecMoyenneJuilletOct_ModeleMin_[which(CTRIP_H3_rcp26_$HER == HER_)],
      GRSD_H3_rcp26_$propAssecMoyenneJuilletOct_ModeleMin_[which(GRSD_H3_rcp26_$HER == HER_)],
      ORCHIDEE_H3_rcp26_$propAssecMoyenneJuilletOct_ModeleMin_[which(ORCHIDEE_H3_rcp26_$HER == HER_)],
      SMASH_H3_rcp26_$propAssecMoyenneJuilletOct_ModeleMin_[which(SMASH_H3_rcp26_$HER == HER_)]),
  
  median(CTRIP_H3_rcp26_$propAssecMoyenneJuilletOct_ModeleMedian_[which(CTRIP_H3_rcp26_$HER == HER_)],
         GRSD_H3_rcp26_$propAssecMoyenneJuilletOct_ModeleMedian_[which(GRSD_H3_rcp26_$HER == HER_)],
         ORCHIDEE_H3_rcp26_$propAssecMoyenneJuilletOct_ModeleMedian_[which(ORCHIDEE_H3_rcp26_$HER == HER_)],
         SMASH_H3_rcp26_$propAssecMoyenneJuilletOct_ModeleMedian_[which(SMASH_H3_rcp26_$HER == HER_)]),
  
  max(CTRIP_H3_rcp26_$propAssecMoyenneJuilletOct_ModeleMax_[which(CTRIP_H3_rcp26_$HER == HER_)],
      GRSD_H3_rcp26_$propAssecMoyenneJuilletOct_ModeleMax_[which(GRSD_H3_rcp26_$HER == HER_)],
      ORCHIDEE_H3_rcp26_$propAssecMoyenneJuilletOct_ModeleMax_[which(ORCHIDEE_H3_rcp26_$HER == HER_)],
      SMASH_H3_rcp26_$propAssecMoyenneJuilletOct_ModeleMax_[which(SMASH_H3_rcp26_$HER == HER_)]))

  
  return(matrix(vect_, ncol = 3, byrow = T))
  
  
}

makeBlocTable_NbJoursSup20_ <- function(HER_){
  
  vect_ <- c(
    
    ### H0 57 ###
    min(CTRIP_H0_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(CTRIP_H0_$HER == HER_)],
        GRSD_H0_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(GRSD_H0_$HER == HER_)],
        ORCHIDEE_H0_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(ORCHIDEE_H0_$HER == HER_)],
        SMASH_H0_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(SMASH_H0_$HER == HER_)]),
    
    median(CTRIP_H0_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(CTRIP_H0_$HER == HER_)],
           GRSD_H0_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(GRSD_H0_$HER == HER_)],
           ORCHIDEE_H0_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(ORCHIDEE_H0_$HER == HER_)],
           SMASH_H0_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(SMASH_H0_$HER == HER_)]),
    
    max(CTRIP_H0_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(CTRIP_H0_$HER == HER_)],
        GRSD_H0_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(GRSD_H0_$HER == HER_)],
        ORCHIDEE_H0_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(ORCHIDEE_H0_$HER == HER_)],
        SMASH_H0_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(SMASH_H0_$HER == HER_)]),
    
    ### H2 57 ###
    min(CTRIP_H2_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(CTRIP_H2_$HER == HER_)],
        GRSD_H2_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(GRSD_H2_$HER == HER_)],
        ORCHIDEE_H2_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(ORCHIDEE_H2_$HER == HER_)],
        SMASH_H2_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(SMASH_H2_$HER == HER_)]),
    
    median(CTRIP_H2_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(CTRIP_H2_$HER == HER_)],
           GRSD_H2_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(GRSD_H2_$HER == HER_)],
           ORCHIDEE_H2_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(ORCHIDEE_H2_$HER == HER_)],
           SMASH_H2_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(SMASH_H2_$HER == HER_)]),
    
    max(CTRIP_H2_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(CTRIP_H2_$HER == HER_)],
        GRSD_H2_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(GRSD_H2_$HER == HER_)],
        ORCHIDEE_H2_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(ORCHIDEE_H2_$HER == HER_)],
        SMASH_H2_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(SMASH_H2_$HER == HER_)]),
    
    ### H3 57 ###
    min(CTRIP_H3_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(CTRIP_H3_$HER == HER_)],
        GRSD_H3_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(GRSD_H3_$HER == HER_)],
        ORCHIDEE_H3_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(ORCHIDEE_H3_$HER == HER_)],
        SMASH_H3_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(SMASH_H3_$HER == HER_)]),
    
    median(CTRIP_H3_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(CTRIP_H3_$HER == HER_)],
           GRSD_H3_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(GRSD_H3_$HER == HER_)],
           ORCHIDEE_H3_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(ORCHIDEE_H3_$HER == HER_)],
           SMASH_H3_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(SMASH_H3_$HER == HER_)]),
    
    max(CTRIP_H3_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(CTRIP_H3_$HER == HER_)],
        GRSD_H3_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(GRSD_H3_$HER == HER_)],
        ORCHIDEE_H3_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(ORCHIDEE_H3_$HER == HER_)],
        SMASH_H3_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(SMASH_H3_$HER == HER_)]),
  
  
  
  
  min(CTRIP_H0_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(CTRIP_H0_$HER == HER_)],
      GRSD_H0_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(GRSD_H0_$HER == HER_)],
      ORCHIDEE_H0_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(ORCHIDEE_H0_$HER == HER_)],
      SMASH_H0_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(SMASH_H0_$HER == HER_)]),
  
  median(CTRIP_H0_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(CTRIP_H0_$HER == HER_)],
         GRSD_H0_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(GRSD_H0_$HER == HER_)],
         ORCHIDEE_H0_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(ORCHIDEE_H0_$HER == HER_)],
         SMASH_H0_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(SMASH_H0_$HER == HER_)]),
  
  max(CTRIP_H0_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(CTRIP_H0_$HER == HER_)],
      GRSD_H0_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(GRSD_H0_$HER == HER_)],
      ORCHIDEE_H0_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(ORCHIDEE_H0_$HER == HER_)],
      SMASH_H0_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(SMASH_H0_$HER == HER_)]),
  
  ### H2 57 ###
  min(CTRIP_H2_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(CTRIP_H2_$HER == HER_)],
      GRSD_H2_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(GRSD_H2_$HER == HER_)],
      ORCHIDEE_H2_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(ORCHIDEE_H2_$HER == HER_)],
      SMASH_H2_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(SMASH_H2_$HER == HER_)]),
  
  median(CTRIP_H2_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(CTRIP_H2_$HER == HER_)],
         GRSD_H2_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(GRSD_H2_$HER == HER_)],
         ORCHIDEE_H2_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(ORCHIDEE_H2_$HER == HER_)],
         SMASH_H2_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(SMASH_H2_$HER == HER_)]),
  
  max(CTRIP_H2_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(CTRIP_H2_$HER == HER_)],
      GRSD_H2_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(GRSD_H2_$HER == HER_)],
      ORCHIDEE_H2_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(ORCHIDEE_H2_$HER == HER_)],
      SMASH_H2_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(SMASH_H2_$HER == HER_)]),
  
  ### H3 57 ###
  min(CTRIP_H3_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(CTRIP_H3_$HER == HER_)],
      GRSD_H3_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(GRSD_H3_$HER == HER_)],
      ORCHIDEE_H3_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(ORCHIDEE_H3_$HER == HER_)],
      SMASH_H3_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(SMASH_H3_$HER == HER_)]),
  
  median(CTRIP_H3_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(CTRIP_H3_$HER == HER_)],
         GRSD_H3_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(GRSD_H3_$HER == HER_)],
         ORCHIDEE_H3_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(ORCHIDEE_H3_$HER == HER_)],
         SMASH_H3_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(SMASH_H3_$HER == HER_)]),
  
  max(CTRIP_H3_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(CTRIP_H3_$HER == HER_)],
      GRSD_H3_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(GRSD_H3_$HER == HER_)],
      ORCHIDEE_H3_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(ORCHIDEE_H3_$HER == HER_)],
      SMASH_H3_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(SMASH_H3_$HER == HER_)]),
  
  min(CTRIP_H0_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(CTRIP_H0_$HER == HER_)],
      GRSD_H0_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(GRSD_H0_$HER == HER_)],
      ORCHIDEE_H0_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(ORCHIDEE_H0_$HER == HER_)],
      SMASH_H0_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(SMASH_H0_$HER == HER_)]),
  
  median(CTRIP_H0_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(CTRIP_H0_$HER == HER_)],
         GRSD_H0_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(GRSD_H0_$HER == HER_)],
         ORCHIDEE_H0_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(ORCHIDEE_H0_$HER == HER_)],
         SMASH_H0_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(SMASH_H0_$HER == HER_)]),
  
  max(CTRIP_H0_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(CTRIP_H0_$HER == HER_)],
      GRSD_H0_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(GRSD_H0_$HER == HER_)],
      ORCHIDEE_H0_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(ORCHIDEE_H0_$HER == HER_)],
      SMASH_H0_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(SMASH_H0_$HER == HER_)]),
  
  ### H2 57 ###
  min(CTRIP_H2_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(CTRIP_H2_$HER == HER_)],
      GRSD_H2_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(GRSD_H2_$HER == HER_)],
      ORCHIDEE_H2_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(ORCHIDEE_H2_$HER == HER_)],
      SMASH_H2_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(SMASH_H2_$HER == HER_)]),
  
  median(CTRIP_H2_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(CTRIP_H2_$HER == HER_)],
         GRSD_H2_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(GRSD_H2_$HER == HER_)],
         ORCHIDEE_H2_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(ORCHIDEE_H2_$HER == HER_)],
         SMASH_H2_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(SMASH_H2_$HER == HER_)]),
  
  max(CTRIP_H2_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(CTRIP_H2_$HER == HER_)],
      GRSD_H2_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(GRSD_H2_$HER == HER_)],
      ORCHIDEE_H2_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(ORCHIDEE_H2_$HER == HER_)],
      SMASH_H2_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(SMASH_H2_$HER == HER_)]),
  
  ### H3 57 ###
  min(CTRIP_H3_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(CTRIP_H3_$HER == HER_)],
      GRSD_H3_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(GRSD_H3_$HER == HER_)],
      ORCHIDEE_H3_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(ORCHIDEE_H3_$HER == HER_)],
      SMASH_H3_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(SMASH_H3_$HER == HER_)]),
  
  median(CTRIP_H3_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(CTRIP_H3_$HER == HER_)],
         GRSD_H3_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(GRSD_H3_$HER == HER_)],
         ORCHIDEE_H3_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(ORCHIDEE_H3_$HER == HER_)],
         SMASH_H3_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(SMASH_H3_$HER == HER_)]),
  
  max(CTRIP_H3_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(CTRIP_H3_$HER == HER_)],
      GRSD_H3_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(GRSD_H3_$HER == HER_)],
      ORCHIDEE_H3_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(ORCHIDEE_H3_$HER == HER_)],
      SMASH_H3_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(SMASH_H3_$HER == HER_)]))
  








  
  
  
  
  return(matrix(vect_, ncol = 3, byrow = T))
  
  
}

for (h in HER_){
  tab_h_ <- makeBlocTable_initDate_(h)
}


tab_57_ <- makeBlocTable_initDate_(57)
tab_81_ <- makeBlocTable_initDate_(81)
# tab_13_ <- makeBlocTable_initDate_(13)
tab_12_ <- makeBlocTable_initDate_(12)
tab_105_ <- makeBlocTable_initDate_(105)

write.table(rbind(tab_57_,
                  tab_81_,
                  # tab_13_,
                  tab_12_,
                  tab_105_),
            "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/StatistiquesPFI_TableDateInit_1_20240823.csv",
            sep = ";", dec = ".", row.names = F)


tab_57_ <- makeBlocTable_finishDate_(57)
tab_81_ <- makeBlocTable_finishDate_(81)
# tab_13_ <- makeBlocTable_finishDate_(13)
tab_12_ <- makeBlocTable_finishDate_(12)
tab_105_ <- makeBlocTable_finishDate_(105)

write.table(rbind(tab_57_,
                  tab_81_,
                  # tab_13_,
                  tab_12_,
                  tab_105_),
            "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/StatistiquesPFI_TableDateFinish_1_20240823.csv",
            sep = ";", dec = ".", row.names = F)


tab_57_ <- makeBlocTable_ProbaMean_(57)
tab_81_ <- makeBlocTable_ProbaMean_(81)
# tab_13_ <- makeBlocTable_ProbaMean_(13)
tab_12_ <- makeBlocTable_ProbaMean_(12)
tab_105_ <- makeBlocTable_ProbaMean_(105)

write.table(rbind(tab_57_,
                  tab_81_,
                  # tab_13_,
                  tab_12_,
                  tab_105_),
            "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/StatistiquesPFI_TableProbaMean_1_20240823.csv",
            sep = ";", dec = ".", row.names = F)


tab_57_ <- makeBlocTable_NbJoursSup20_(57)
tab_81_ <- makeBlocTable_NbJoursSup20_(81)
# tab_13_ <- makeBlocTable_NbJoursSup20_(13)
tab_12_ <- makeBlocTable_NbJoursSup20_(12)
tab_105_ <- makeBlocTable_NbJoursSup20_(105)

write.table(rbind(tab_57_,
                  tab_81_,
                  # tab_13_,
                  tab_12_,
                  tab_105_),
            "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/StatistiquesPFI_TableNbJoursSup20_1_20240823.csv",
            sep = ";", dec = ".", row.names = F)


# CTRIP_H0_$initDate_max_[which(CTRIP_H0_$HER == 57)]
# GRSD_H0_$initDate_max_[which(GRSD_H0_$HER == 57)]
# ORCHIDEE_H0_$initDate_max_[which(ORCHIDEE_H0_$HER == 57)]
# SMASH_H0_$initDate_max_[which(SMASH_H0_$HER == 57)]





