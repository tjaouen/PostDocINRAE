
### Parameters ###
HER_ <- HER_param_
HER_ <- HER_[which(!(HER_ %in% c(10,18,19,20)))]

# CTRIP Rcp 8.5 #
CTRIP_H0_rcp85_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
CTRIP_H0_rcp85_$Model = "CTRIP"
CTRIP_H0_rcp85_$Horizon = "H0"
CTRIP_H0_rcp85_$Rcp = "rcp85"
CTRIP_H2_rcp85_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
CTRIP_H2_rcp85_$Model = "CTRIP"
CTRIP_H2_rcp85_$Horizon = "H2"
CTRIP_H2_rcp85_$Rcp = "rcp85"
CTRIP_H3_rcp85_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
CTRIP_H3_rcp85_$Model = "CTRIP"
CTRIP_H3_rcp85_$Horizon = "H3"
CTRIP_H3_rcp85_$Rcp = "rcp85"

# CTRIP Rcp 4.5 #
CTRIP_H0_rcp45_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
CTRIP_H0_rcp45_$Model = "CTRIP"
CTRIP_H0_rcp45_$Horizon = "H0"
CTRIP_H0_rcp45_$Rcp = "rcp45"
CTRIP_H2_rcp45_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
CTRIP_H2_rcp45_$Model = "CTRIP"
CTRIP_H2_rcp45_$Horizon = "H2"
CTRIP_H2_rcp45_$Rcp = "rcp45"
CTRIP_H3_rcp45_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
CTRIP_H3_rcp45_$Model = "CTRIP"
CTRIP_H3_rcp45_$Horizon = "H3"
CTRIP_H3_rcp45_$Rcp = "rcp45"

# CTRIP Rcp 2.6 #
CTRIP_H0_rcp26_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
CTRIP_H0_rcp26_$Model = "CTRIP"
CTRIP_H0_rcp26_$Horizon = "H0"
CTRIP_H0_rcp26_$Rcp = "rcp26"
CTRIP_H2_rcp26_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
CTRIP_H2_rcp26_$Model = "CTRIP"
CTRIP_H2_rcp26_$Horizon = "H2"
CTRIP_H2_rcp26_$Rcp = "rcp26"
CTRIP_H3_rcp26_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
CTRIP_H3_rcp26_$Model = "CTRIP"
CTRIP_H3_rcp26_$Horizon = "H3"
CTRIP_H3_rcp26_$Rcp = "rcp26"

# GRSD Rcp 8.5 #
GRSD_H0_rcp85_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
GRSD_H0_rcp85_$Model = "GRSD"
GRSD_H0_rcp85_$Horizon = "H0"
GRSD_H0_rcp85_$Rcp = "rcp85"
GRSD_H2_rcp85_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
GRSD_H2_rcp85_$Model = "GRSD"
GRSD_H2_rcp85_$Horizon = "H2"
GRSD_H2_rcp85_$Rcp = "rcp85"
GRSD_H3_rcp85_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
GRSD_H3_rcp85_$Model = "GRSD"
GRSD_H3_rcp85_$Horizon = "H3"
GRSD_H3_rcp85_$Rcp = "rcp85"

# GRSD Rcp 4.5 #
GRSD_H0_rcp45_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
GRSD_H0_rcp45_$Model = "GRSD"
GRSD_H0_rcp45_$Horizon = "H0"
GRSD_H0_rcp45_$Rcp = "rcp45"
GRSD_H2_rcp45_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
GRSD_H2_rcp45_$Model = "GRSD"
GRSD_H2_rcp45_$Horizon = "H2"
GRSD_H2_rcp45_$Rcp = "rcp45"
GRSD_H3_rcp45_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
GRSD_H3_rcp45_$Model = "GRSD"
GRSD_H3_rcp45_$Horizon = "H3"
GRSD_H3_rcp45_$Rcp = "rcp45"

# GRSD Rcp 2.6 #
GRSD_H0_rcp26_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
GRSD_H0_rcp26_$Model = "GRSD"
GRSD_H0_rcp26_$Horizon = "H0"
GRSD_H0_rcp26_$Rcp = "rcp26"
GRSD_H2_rcp26_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
GRSD_H2_rcp26_$Model = "GRSD"
GRSD_H2_rcp26_$Horizon = "H2"
GRSD_H2_rcp26_$Rcp = "rcp26"
GRSD_H3_rcp26_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
GRSD_H3_rcp26_$Model = "GRSD"
GRSD_H3_rcp26_$Horizon = "H3"
GRSD_H3_rcp26_$Rcp = "rcp26"

# J2000 Rcm 8.5 #
J2000_H0_rcp85_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
J2000_H0_rcp85_$Model = "J2000"
J2000_H0_rcp85_$Horizon = "H0"
J2000_H0_rcp85_$Rcp = "rcp85"
J2000_H2_rcp85_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
J2000_H2_rcp85_$Model = "J2000"
J2000_H2_rcp85_$Horizon = "H2"
J2000_H2_rcp85_$Rcp = "rcp85"
J2000_H3_rcp85_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
J2000_H3_rcp85_$Model = "J2000"
J2000_H3_rcp85_$Horizon = "H3"
J2000_H3_rcp85_$Rcp = "rcp85"

J2000_H0_rcp45_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
J2000_H0_rcp45_$Model = "J2000"
J2000_H0_rcp45_$Horizon = "H0"
J2000_H0_rcp45_$Rcp = "rcp45"
J2000_H2_rcp45_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
J2000_H2_rcp45_$Model = "J2000"
J2000_H2_rcp45_$Horizon = "H2"
J2000_H2_rcp45_$Rcp = "rcp45"
J2000_H3_rcp45_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
J2000_H3_rcp45_$Model = "J2000"
J2000_H3_rcp45_$Horizon = "H3"
J2000_H3_rcp45_$Rcp = "rcp45"

J2000_H0_rcp26_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
J2000_H0_rcp26_$Model = "J2000"
J2000_H0_rcp26_$Horizon = "H0"
J2000_H0_rcp26_$Rcp = "rcp26"
J2000_H2_rcp26_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
J2000_H2_rcp26_$Model = "J2000"
J2000_H2_rcp26_$Horizon = "H2"
J2000_H2_rcp26_$Rcp = "rcp26"
J2000_H3_rcp26_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
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

ORCHIDEE_H0_rcp85_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
ORCHIDEE_H0_rcp85_$Model = "ORCHIDEE"
ORCHIDEE_H0_rcp85_$Horizon = "H0"
ORCHIDEE_H0_rcp85_$Rcp = "rcp85"
ORCHIDEE_H2_rcp85_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
ORCHIDEE_H2_rcp85_$Model = "ORCHIDEE"
ORCHIDEE_H2_rcp85_$Horizon = "H2"
ORCHIDEE_H2_rcp85_$Rcp = "rcp85"
ORCHIDEE_H3_rcp85_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
ORCHIDEE_H3_rcp85_$Model = "ORCHIDEE"
ORCHIDEE_H3_rcp85_$Horizon = "H3"
ORCHIDEE_H3_rcp85_$Rcp = "rcp85"

ORCHIDEE_H0_rcp45_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
ORCHIDEE_H0_rcp45_$Model = "ORCHIDEE"
ORCHIDEE_H0_rcp45_$Horizon = "H0"
ORCHIDEE_H0_rcp45_$Rcp = "rcp45"
ORCHIDEE_H2_rcp45_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
ORCHIDEE_H2_rcp45_$Model = "ORCHIDEE"
ORCHIDEE_H2_rcp45_$Horizon = "H2"
ORCHIDEE_H2_rcp45_$Rcp = "rcp45"
ORCHIDEE_H3_rcp45_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
ORCHIDEE_H3_rcp45_$Model = "ORCHIDEE"
ORCHIDEE_H3_rcp45_$Horizon = "H3"
ORCHIDEE_H3_rcp45_$Rcp = "rcp45"

ORCHIDEE_H0_rcp26_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
ORCHIDEE_H0_rcp26_$Model = "ORCHIDEE"
ORCHIDEE_H0_rcp26_$Horizon = "H0"
ORCHIDEE_H0_rcp26_$Rcp = "rcp26"
ORCHIDEE_H2_rcp26_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
ORCHIDEE_H2_rcp26_$Model = "ORCHIDEE"
ORCHIDEE_H2_rcp26_$Horizon = "H2"
ORCHIDEE_H2_rcp26_$Rcp = "rcp26"
ORCHIDEE_H3_rcp26_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
ORCHIDEE_H3_rcp26_$Model = "ORCHIDEE"
ORCHIDEE_H3_rcp26_$Horizon = "H3"
ORCHIDEE_H3_rcp26_$Rcp = "rcp26"

SMASH_H0_rcp85_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
SMASH_H0_rcp85_$Model = "SMASH"
SMASH_H0_rcp85_$Horizon = "H0"
SMASH_H0_rcp85_$Rcp = "rcp85"
SMASH_H2_rcp85_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
SMASH_H2_rcp85_$Model = "SMASH"
SMASH_H2_rcp85_$Horizon = "H2"
SMASH_H2_rcp85_$Rcp = "rcp85"
SMASH_H3_rcp85_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
SMASH_H3_rcp85_$Model = "SMASH"
SMASH_H3_rcp85_$Horizon = "H3"
SMASH_H3_rcp85_$Rcp = "rcp85"

SMASH_H0_rcp45_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
SMASH_H0_rcp45_$Model = "SMASH"
SMASH_H0_rcp45_$Horizon = "H0"
SMASH_H0_rcp45_$Rcp = "rcp45"
SMASH_H2_rcp45_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
SMASH_H2_rcp45_$Model = "SMASH"
SMASH_H2_rcp45_$Horizon = "H2"
SMASH_H2_rcp45_$Rcp = "rcp45"
SMASH_H3_rcp45_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp45/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp45.txt", sep = ";", dec = ".", header = T)
SMASH_H3_rcp45_$Model = "SMASH"
SMASH_H3_rcp45_$Horizon = "H3"
SMASH_H3_rcp45_$Rcp = "rcp45"

SMASH_H0_rcp26_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
SMASH_H0_rcp26_$Model = "SMASH"
SMASH_H0_rcp26_$Horizon = "H0"
SMASH_H0_rcp26_$Rcp = "rcp26"
SMASH_H2_rcp26_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
SMASH_H2_rcp26_$Model = "SMASH"
SMASH_H2_rcp26_$Horizon = "H2"
SMASH_H2_rcp26_$Rcp = "rcp26"
SMASH_H3_rcp26_ <- read.table("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp26.txt", sep = ";", dec = ".", header = T)
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

# tab_results_ <- data.frame(model = c(rep("CTRIP",9),
#                                      rep("GRSD",9),
#                                      rep("J2000",9),
#                                      rep("ORCHIDEE",9),
#                                      rep("SMASH",9)),
#                            horizon = rep(c(rep("H0",3),
#                                            rep("H1",3),
#                                            rep("H2",3)),5),
#                            rcp = rep(c("rcp26","rcp45","rcp85"),15),
#                            )
tab_results_ <- data.frame(HER = HER_)
for (rcp in unique(tab_proj_$Rcp)){
  for (hor in unique(tab_proj_$Horizon)){
    # tab_results_[[paste0("General_",hor,"_",rcp,"_propAssecMoyenneJuilletOct_ModeleMedian_")]] <- NA
    # tab_results_[[paste0("General_",hor,"_",rcp,"_initDate_projmedian_")]] <- NA
    # tab_results_[[paste0("General_",hor,"_",rcp,"_finishDate_projmedian_")]] <- NA
    for (mod in unique(tab_proj_$Model)){
      tab_results_[[paste0(mod,"_",hor,"_",rcp,"_propAssecMoyenneJuilletOct_ModeleMedian_")]] <- NA
      # tab_results_[[paste0(mod,"_",hor,"_",rcp,"_initDate_projmin_")]] <- NA
      tab_results_[[paste0(mod,"_",hor,"_",rcp,"_initDate_projmedian_")]] <- NA
      # tab_results_[[paste0(mod,"_",hor,"_",rcp,"_initDate_projmax_")]] <- NA
      # tab_results_[[paste0(mod,"_",hor,"_",rcp,"_finishDate_projmin_")]] <- NA
      tab_results_[[paste0(mod,"_",hor,"_",rcp,"_finishDate_projmedian_")]] <- NA
      # tab_results_[[paste0(mod,"_",hor,"_",rcp,"_finishDate_projmax_")]] <- NA
      # tab_results_[[paste0(mod,"_",hor,"_",rcp,"_nbMoyenJoursParAnSup20pct_projmin_")]] <- NA
      # tab_results_[[paste0(mod,"_",hor,"_",rcp,"_nbMoyenJoursParAnSup20pct_projmedian_")]] <- NA
      # tab_results_[[paste0(mod,"_",hor,"_",rcp,"_nbMoyenJoursParAnSup20pct_projmax")]] <- NA
    }
  }
}


# CTRIP_H0_Rcp_initDate_projMedianTousHM_HMmin_ = NA, CTRIP_H0_Rcp_initDate_projMedianTousHM_HMmedian_ = NA, CTRIP_H0_Rcp_initDate_projMedianTousHM_HMmax_ = NA,
#                          CTRIP_H2_Rcp_initDate_projMedianTousHM_HMmin_ = NA, CTRIP_H2_Rcp_initDate_projMedianTousHM_HMmedian_ = NA, CTRIP_H2_Rcp_initDate_projMedianTousHM_HMmax_ = NA,
#                          CTRIP_H3_Rcp_initDate_projMedianTousHM_HMmin_ = NA, CTRIP_H3_Rcp_initDate_projMedianTousHM_HMmedian_ = NA, CTRIP_H3_Rcp_initDate_projMedianTousHM_HMmax_ = NA,
#                          GRSD_H0_Rcp_initDate_projMedianTousHM_HMmin_ = NA, GRSD_H0_Rcp_initDate_projMedianTousHM_HMmedian_ = NA, GRSD_H0_Rcp_initDate_projMedianTousHM_HMmax_ = NA,
#                          GRSD_H2_Rcp_initDate_projMedianTousHM_HMmin_ = NA, GRSD_H2_Rcp_initDate_projMedianTousHM_HMmedian_ = NA, GRSD_H2_Rcp_initDate_projMedianTousHM_HMmax_ = NA,
#                          GRSD_H3_Rcp_initDate_projMedianTousHM_HMmin_ = NA, GRSD_H3_Rcp_initDate_projMedianTousHM_HMmedian_ = NA, GRSD_H3_Rcp_initDate_projMedianTousHM_HMmax_ = NA,
#                          J2000_H0_Rcp_initDate_projMedianTousHM_HMmin_ = NA, J2000_H0_Rcp_initDate_projMedianTousHM_HMmedian_ = NA, J2000_H0_Rcp_initDate_projMedianTousHM_HMmax_ = NA,
#                          J2000_H2_Rcp_initDate_projMedianTousHM_HMmin_ = NA, J2000_H2_Rcp_initDate_projMedianTousHM_HMmedian_ = NA, J2000_H2_Rcp_initDate_projMedianTousHM_HMmax_ = NA,
#                          J2000_H3_Rcp_initDate_projMedianTousHM_HMmin_ = NA, J2000_H3_Rcp_initDate_projMedianTousHM_HMmedian_ = NA, J2000_H3_Rcp_initDate_projMedianTousHM_HMmax_ = NA,
#                          ORCHIDEE_H0_Rcp_initDate_projMedianTousHM_HMmin_ = NA, ORCHIDEE_H0_Rcp_initDate_projMedianTousHM_HMmedian_ = NA, ORCHIDEE_H0_Rcp_initDate_projMedianTousHM_HMmax_ = NA,
#                          ORCHIDEE_H2_Rcp_initDate_projMedianTousHM_HMmin_ = NA, ORCHIDEE_H2_Rcp_initDate_projMedianTousHM_HMmedian_ = NA, ORCHIDEE_H2_Rcp_initDate_projMedianTousHM_HMmax_ = NA,
#                          ORCHIDEE_H3_Rcp_initDate_projMedianTousHM_HMmin_ = NA, ORCHIDEE_H3_Rcp_initDate_projMedianTousHM_HMmedian_ = NA, ORCHIDEE_H3_Rcp_initDate_projMedianTousHM_HMmax_ = NA,
#                          SMASH_H0_Rcp_initDate_projMedianTousHM_HMmin_ = NA, SMASH_H0_Rcp_initDate_projMedianTousHM_HMmedian_ = NA, SMASH_H0_Rcp_initDate_projMedianTousHM_HMmax_ = NA,
#                          SMASH_H2_Rcp_initDate_projMedianTousHM_HMmin_ = NA, SMASH_H2_Rcp_initDate_projMedianTousHM_HMmedian_ = NA, SMASH_H2_Rcp_initDate_projMedianTousHM_HMmax_ = NA,
#                          SMASH_H3_Rcp_initDate_projMedianTousHM_HMmin_ = NA, SMASH_H3_Rcp_initDate_projMedianTousHM_HMmedian_ = NA, SMASH_H3_Rcp_initDate_projMedianTousHM_HMmax_ = NA)


for (her_ in HER_){
  for (rcp in unique(tab_proj_$Rcp)){
    for (hor in unique(tab_proj_$Horizon)){
      tab_results_[[paste0("General_",hor,"_",rcp,"_propAssecMoyenneJuilletOct_ModeleMedian_")]] <- tab_proj_$propAssecMoyenneJuilletOct_ModeleMedian_[which(tab_proj_$Model == mod & tab_proj_$Horizon == hor & tab_proj_$Rcp == rcp & tab_proj_$HER == her_)]
      tab_results_[[paste0("General_",hor,"_",rcp,"_initDate_projmedian_")]] <- NA
      tab_results_[[paste0("General_",hor,"_",rcp,"_finishDate_projmedian_")]] <- NA
      for (mod in unique(tab_proj_$Model)){
        if (length(which(tab_proj_$Model == mod & tab_proj_$Horizon == hor & tab_proj_$Rcp == rcp & tab_proj_$HER == her_)) > 0){
          tab_results_[[paste0(mod,"_",hor,"_",rcp,"_propAssecMoyenneJuilletOct_ModeleMedian_")]][which(tab_results_$HER == her_)] <- tab_proj_$propAssecMoyenneJuilletOct_ModeleMedian_[which(tab_proj_$Model == mod & tab_proj_$Horizon == hor & tab_proj_$Rcp == rcp & tab_proj_$HER == her_)]
          
          # tab_results_[[paste0(mod,"_",hor,"_",rcp,"_initDate_projmin_")]][which(tab_results_$HER == her_)] <- tab_proj_$initDate_min_[which(tab_proj_$Model == mod & tab_proj_$Horizon == hor & tab_proj_$Rcp == rcp & tab_proj_$HER == her_)]
          tab_results_[[paste0(mod,"_",hor,"_",rcp,"_initDate_projmedian_")]][which(tab_results_$HER == her_)] <- tab_proj_$initDate_median_[which(tab_proj_$Model == mod & tab_proj_$Horizon == hor & tab_proj_$Rcp == rcp & tab_proj_$HER == her_)]
          # tab_results_[[paste0(mod,"_",hor,"_",rcp,"_initDate_projmax_")]][which(tab_results_$HER == her_)] <- tab_proj_$initDate_max_[which(tab_proj_$Model == mod & tab_proj_$Horizon == hor & tab_proj_$Rcp == rcp & tab_proj_$HER == her_)]
          
          # tab_results_[[paste0(mod,"_",hor,"_",rcp,"_finishDate_projmin_")]][which(tab_results_$HER == her_)] <- tab_proj_$finishDate_min_[which(tab_proj_$Model == mod & tab_proj_$Horizon == hor & tab_proj_$Rcp == rcp & tab_proj_$HER == her_)]
          tab_results_[[paste0(mod,"_",hor,"_",rcp,"_finishDate_projmedian_")]][which(tab_results_$HER == her_)] <- tab_proj_$finishDate_median_[which(tab_proj_$Model == mod & tab_proj_$Horizon == hor & tab_proj_$Rcp == rcp & tab_proj_$HER == her_)]
          # tab_results_[[paste0(mod,"_",hor,"_",rcp,"_finishDate_projmax_")]][which(tab_results_$HER == her_)] <- tab_proj_$finishDate_max_[which(tab_proj_$Model == mod & tab_proj_$Horizon == hor & tab_proj_$Rcp == rcp & tab_proj_$HER == her_)]
          
          # tab_results_[[paste0(mod,"_",hor,"_",rcp,"_nbMoyenJoursParAnSup20pct_projmin_")]][which(tab_results_$HER == her_)] <- tab_proj_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(tab_proj_$Model == mod & tab_proj_$Horizon == hor & tab_proj_$Rcp == rcp & tab_proj_$HER == her_)]
          # tab_results_[[paste0(mod,"_",hor,"_",rcp,"_nbMoyenJoursParAnSup20pct_projmedian_")]][which(tab_results_$HER == her_)] <- tab_proj_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(tab_proj_$Model == mod & tab_proj_$Horizon == hor & tab_proj_$Rcp == rcp & tab_proj_$HER == her_)]
          # tab_results_[[paste0(mod,"_",hor,"_",rcp,"_nbMoyenJoursParAnSup20pct_projmax")]][which(tab_results_$HER == her_)] <- tab_proj_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(tab_proj_$Model == mod & tab_proj_$Horizon == hor & tab_proj_$Rcp == rcp & tab_proj_$HER == her_)]
        }
      }
    }
  }
}

write.table(tab_results_,
            "/media/tjaouen/Ultra Touch1/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/StatistiquesPFI_TableProbaMean_ParHER_MedianParHM_1_20240903.csv",
            sep = ";", dec = ".", row.names = F)





