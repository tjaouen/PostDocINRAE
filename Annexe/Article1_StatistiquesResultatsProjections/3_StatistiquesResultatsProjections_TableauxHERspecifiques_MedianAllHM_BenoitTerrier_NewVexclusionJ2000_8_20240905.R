source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")
source("/home/tjaouen/Documents/Input/FondsCartes/LHcolors/color.R")

### Libraries ###
suppressMessages(library(doParallel))
suppressMessages(library(tidyverse))
suppressMessages(library(svglite))
suppressMessages(library(ggplot2))
suppressMessages(library(strex))
suppressMessages(library(latex2exp))
suppressMessages(library(lubridate))
suppressMessages(library(readxl))

### Parameters ###
folder_output_ = folder_output_param_
nomSim_ = nomSim_param_
jourMin_ = jourMin_param_
jourMax_ = jourMax_param_
nom_categorieSimu_ = nom_categorieSimu_param_
nom_apprentissage_ = nom_apprentissage_param_
nom_validation_ = nom_validation_param_
annees_validModels_ = annees_validModels_param_
nom_GCM_ = nom_GCM_param_
breaks_NSE_ = breaks_NSE_param
folder_input_ = folder_input_param_
HER_eliminees_J2000 <- c("10", "21", "22", "24", "27", "34", "35", "36", "57", "59", "61", "65", "67", "68",
                         "77", "78", "93", "94", "103", "108", "118", "0", "31033039", "69096",
                         "66", "64", "117", "112", "56", "62", "38", "40", "105", "17", "25", "107",
                         "55", "12", "53")

pattern_rcp_ = str_before_last(str_after_last(nom_categorieSimu_,"_"),"/")
pattern_SafranHistRcp_ = "Historical|rcp"
correctionBiais_ = "ADAMONT"
seuilAssec_ = 20

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
# Je regarde l annee mediane pour la date de debut et l annee mediane pour la date de fin de tous les scenarios et pour chaque HM

tab_results_ <- data.frame(HER = HER_)
for (rcp in unique(tab_proj_$Rcp)){
  for (hor in unique(tab_proj_$Horizon)){
    for (mod in unique(tab_proj_$Model)){
      tab_results_[[paste0(mod,"_",rcp,"_",hor,"_propAssecMoyenneJuilletOct_projmedian_")]] <- NA
      tab_results_[[paste0(mod,"_",rcp,"_",hor,"_initDate_projmedian_")]] <- NA
      tab_results_[[paste0(mod,"_",rcp,"_",hor,"_finishDate_projmedian_")]] <- NA
    }
  }
}


for (her_ in HER_){
  for (rcp in unique(tab_proj_$Rcp)){
    for (hor in unique(tab_proj_$Horizon)){
      for (mod in unique(tab_proj_$Model)){
        if (length(which(tab_proj_$Model == mod & tab_proj_$Horizon == hor & tab_proj_$Rcp == rcp & tab_proj_$HER == her_)) > 0){
          
          tab_results_[[paste0(mod,"_",rcp,"_",hor,"_propAssecMoyenneJuilletOct_projmedian_")]][which(tab_results_$HER == her_)] <- tab_proj_$propAssecMoyenneJuilletOct_ModeleMedian_[which(tab_proj_$Model == mod & tab_proj_$Horizon == hor & tab_proj_$Rcp == rcp & tab_proj_$HER == her_)]
          
          # tab_results_[[paste0(mod,"_",hor,"_",rcp,"_initDate_projmin_")]][which(tab_results_$HER == her_)] <- tab_proj_$initDate_min_[which(tab_proj_$Model == mod & tab_proj_$Horizon == hor & tab_proj_$Rcp == rcp & tab_proj_$HER == her_)]
          tab_results_[[paste0(mod,"_",rcp,"_",hor,"_initDate_projmedian_")]][which(tab_results_$HER == her_)] <- format(as.Date(tab_proj_$initDate_median_[which(tab_proj_$Model == mod & tab_proj_$Horizon == hor & tab_proj_$Rcp == rcp & tab_proj_$HER == her_)]),"%d/%m")
          # tab_results_[[paste0(mod,"_",hor,"_",rcp,"_initDate_projmax_")]][which(tab_results_$HER == her_)] <- tab_proj_$initDate_max_[which(tab_proj_$Model == mod & tab_proj_$Horizon == hor & tab_proj_$Rcp == rcp & tab_proj_$HER == her_)]
          
          # tab_results_[[paste0(mod,"_",hor,"_",rcp,"_finishDate_projmin_")]][which(tab_results_$HER == her_)] <- tab_proj_$finishDate_min_[which(tab_proj_$Model == mod & tab_proj_$Horizon == hor & tab_proj_$Rcp == rcp & tab_proj_$HER == her_)]
          tab_results_[[paste0(mod,"_",rcp,"_",hor,"_finishDate_projmedian_")]][which(tab_results_$HER == her_)] <- format(as.Date(tab_proj_$finishDate_median_[which(tab_proj_$Model == mod & tab_proj_$Horizon == hor & tab_proj_$Rcp == rcp & tab_proj_$HER == her_)]),"%d/%m")
          # tab_results_[[paste0(mod,"_",hor,"_",rcp,"_finishDate_projmax_")]][which(tab_results_$HER == her_)] <- tab_proj_$finishDate_max_[which(tab_proj_$Model == mod & tab_proj_$Horizon == hor & tab_proj_$Rcp == rcp & tab_proj_$HER == her_)]
          
          # tab_results_[[paste0(mod,"_",hor,"_",rcp,"_nbMoyenJoursParAnSup20pct_projmin_")]][which(tab_results_$HER == her_)] <- tab_proj_$nbMoyenJoursParAnSup20pct_ModeleMin_[which(tab_proj_$Model == mod & tab_proj_$Horizon == hor & tab_proj_$Rcp == rcp & tab_proj_$HER == her_)]
          # tab_results_[[paste0(mod,"_",hor,"_",rcp,"_nbMoyenJoursParAnSup20pct_projmedian_")]][which(tab_results_$HER == her_)] <- tab_proj_$nbMoyenJoursParAnSup20pct_ModeleMedian_[which(tab_proj_$Model == mod & tab_proj_$Horizon == hor & tab_proj_$Rcp == rcp & tab_proj_$HER == her_)]
          # tab_results_[[paste0(mod,"_",hor,"_",rcp,"_nbMoyenJoursParAnSup20pct_projmax")]][which(tab_results_$HER == her_)] <- tab_proj_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(tab_proj_$Model == mod & tab_proj_$Horizon == hor & tab_proj_$Rcp == rcp & tab_proj_$HER == her_)]
          
          # initDate_median_test_ <- lapply(tab_initDate_HER_generale_[which(tab_initDate_HER_generale_$Year >= min(year(date_intervalle_)) &
          #                                                                    tab_initDate_HER_generale_$Year <= max(year(date_intervalle_))),
          #                                                            2:ncol(tab_initDate_HER_generale_)], function(x) median(x,na.rm=T))
          # initDate_median_ref_ <- lapply(tab_initDate_HER_generale_[which(tab_initDate_HER_generale_$Year >= min(year(c("1976-01-01","2005-12-31"))) &
          #                                                                   tab_initDate_HER_generale_$Year <= max(year(c("1976-01-01","2005-12-31")))),
          #                                                           2:ncol(tab_initDate_HER_generale_)], function(x) median(x,na.rm=T))
          # tab_allModels[which(tab_allModels$HER == HER_h_),paste0("General_",str_before_first(str_after_last(nom_categorieSimu_,"_"),"/"),"_",horizon_,"_initDelai_AnneeProjModeleMedian_")] = round(median(as.Date(unlist(initDate_median_ref_)) - as.Date(unlist(initDate_median_test_)), na.rm = T),1)
          
          
          
          # Finish date #
          # finishDate_median_ <- format(median(as.Date(unlist(tab_finishDate_HER_generale_[which(tab_finishDate_HER_generale_$Year >= min(year(date_intervalle_)) &
          #                                                                                         tab_finishDate_HER_generale_$Year <= max(year(date_intervalle_))),
          #                                                                                 2:ncol(tab_finishDate_HER_generale_)])), na.rm = T),"%d/%m")
          # tab_allModels[which(tab_allModels$HER == HER_h_),paste0("General_",str_before_first(str_after_last(nom_categorieSimu_,"_"),"/"),"_",horizon_,"_finishDate_AnneeProjModeleMedian_")] = finishDate_median_
          
          # Finish delai #
          # finishDate_median_test_ <- lapply(tab_finishDate_HER_generale_[which(tab_finishDate_HER_generale_$Year >= min(year(date_intervalle_)) &
          #                                                                        tab_finishDate_HER_generale_$Year <= max(year(date_intervalle_))),
          #                                                                2:ncol(tab_finishDate_HER_generale_)], function(x) median(x,na.rm=T))
          # finishDate_median_ref_ <- lapply(tab_finishDate_HER_generale_[which(tab_finishDate_HER_generale_$Year >= min(year(date_intervalle_)) &
          #                                                                       tab_finishDate_HER_generale_$Year <= max(year(date_intervalle_))),
          #                                                               2:ncol(tab_finishDate_HER_generale_)], function(x) median(x,na.rm=T))
          # tab_allModels[which(tab_allModels$HER == HER_h_),paste0("General_",str_before_first(str_after_last(nom_categorieSimu_,"_"),"/"),"_",horizon_,"_finishDelai_AnneeProjModeleMedian_")] = round(median(as.Date(unlist(finishDate_median_test_)) - as.Date(unlist(finishDate_median_ref_)), na.rm = T),1)
          
          
        }
      }
    }
  }
}

write.table(tab_results_,
            "/media/tjaouen/Ultra Touch1/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/StatistiquesPFI_TableProbaMean_ParHER_MedianParAnneeDetailHM_1_20240903.csv",
            sep = ";", dec = ".", row.names = F)






###### Issu du code ~/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_Commun/5_StatisticsAndGraphs/31_Statistiques_ProjectionsAssecs_CalculIndicateursParHorizon_Iter_GeneralAllHM_ConsidererNAcommeDateRef_3_20240904.R ######

nom_categorieSimu_list_list_ = list(c("CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26/"),
                                    c("GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26/"),
                                    c("J2000_20231128/ChroniquesCombinees_saf_hist_rcp26/"),
                                    c("ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26/"),
                                    c("SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26/"),
                                    c("CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45/"),
                                    c("GRSD_20231128/ChroniquesCombinees_saf_hist_rcp45/"),
                                    c("J2000_20231128/ChroniquesCombinees_saf_hist_rcp45/"),
                                    c("ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp45/"),
                                    c("SMASH_20231128/ChroniquesCombinees_saf_hist_rcp45/"),
                                    c("CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/"),
                                    c("GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/"),
                                    c("J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/"),
                                    c("ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/"),
                                    c("SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/"),
                                    c("CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26/",
                                      "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26/",
                                      "J2000_20231128/ChroniquesCombinees_saf_hist_rcp26/",
                                      "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26/",
                                      "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26/"),
                                    c("CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45/",
                                      "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp45/",
                                      "J2000_20231128/ChroniquesCombinees_saf_hist_rcp45/",
                                      "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp45/",
                                      "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp45/"),
                                    c("CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/",
                                      "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/",
                                      "J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/",
                                      "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/",
                                      "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/"))

# date_intervalle_ = c("1976-01-01","2005-12-31")
# date_intervalle_ = c("2041-01-01","2070-12-31")
# date_intervalle_ = c("2070-01-01","2099-12-31")

tab_allModels <- data.frame(HER = HER_,

                            General_rcp26_H0_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,

                            General_rcp26_H2_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            General_rcp26_H2_initDate_AnneeProjModeleMedian_ = NA,
                            General_rcp26_H2_initDelai_AnneeProjModeleMedian_ = NA,
                            General_rcp26_H2_finishDate_AnneeProjModeleMedian_ = NA,
                            General_rcp26_H2_finishDelai_AnneeProjModeleMedian_ = NA,

                            General_rcp26_H3_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            General_rcp26_H3_initDate_AnneeProjModeleMedian_ = NA,
                            General_rcp26_H3_initDelai_AnneeProjModeleMedian_ = NA,
                            General_rcp26_H3_finishDate_AnneeProjModeleMedian_ = NA,
                            General_rcp26_H3_finishDelai_AnneeProjModeleMedian_ = NA,

                            General_rcp45_H0_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,

                            General_rcp45_H2_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            General_rcp45_H2_initDate_AnneeProjModeleMedian_ = NA,
                            General_rcp45_H2_initDelai_AnneeProjModeleMedian_ = NA,
                            General_rcp45_H2_finishDate_AnneeProjModeleMedian_ = NA,
                            General_rcp45_H2_finishDelai_AnneeProjModeleMedian_ = NA,

                            General_rcp45_H3_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            General_rcp45_H3_initDate_AnneeProjModeleMedian_ = NA,
                            General_rcp45_H3_initDelai_AnneeProjModeleMedian_ = NA,
                            General_rcp45_H3_finishDate_AnneeProjModeleMedian_ = NA,
                            General_rcp45_H3_finishDelai_AnneeProjModeleMedian_ = NA,

                            General_rcp85_H0_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,

                            General_rcp85_H2_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            General_rcp85_H2_initDate_AnneeProjModeleMedian_ = NA,
                            General_rcp85_H2_initDelai_AnneeProjModeleMedian_ = NA,
                            General_rcp85_H2_finishDate_AnneeProjModeleMedian_ = NA,
                            General_rcp85_H2_finishDelai_AnneeProjModeleMedian_ = NA,

                            General_rcp85_H3_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            General_rcp85_H3_initDate_AnneeProjModeleMedian_ = NA,
                            General_rcp85_H3_initDelai_AnneeProjModeleMedian_ = NA,
                            General_rcp85_H3_finishDate_AnneeProjModeleMedian_ = NA,
                            General_rcp85_H3_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            CTRIP_rcp26_H0_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            
                            CTRIP_rcp26_H2_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            CTRIP_rcp26_H2_initDate_AnneeProjModeleMedian_ = NA,
                            CTRIP_rcp26_H2_initDelai_AnneeProjModeleMedian_ = NA,
                            CTRIP_rcp26_H2_finishDate_AnneeProjModeleMedian_ = NA,
                            CTRIP_rcp26_H2_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            CTRIP_rcp26_H3_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            CTRIP_rcp26_H3_initDate_AnneeProjModeleMedian_ = NA,
                            CTRIP_rcp26_H3_initDelai_AnneeProjModeleMedian_ = NA,
                            CTRIP_rcp26_H3_finishDate_AnneeProjModeleMedian_ = NA,
                            CTRIP_rcp26_H3_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            CTRIP_rcp45_H0_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            
                            CTRIP_rcp45_H2_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            CTRIP_rcp45_H2_initDate_AnneeProjModeleMedian_ = NA,
                            CTRIP_rcp45_H2_initDelai_AnneeProjModeleMedian_ = NA,
                            CTRIP_rcp45_H2_finishDate_AnneeProjModeleMedian_ = NA,
                            CTRIP_rcp45_H2_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            CTRIP_rcp45_H3_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            CTRIP_rcp45_H3_initDate_AnneeProjModeleMedian_ = NA,
                            CTRIP_rcp45_H3_initDelai_AnneeProjModeleMedian_ = NA,
                            CTRIP_rcp45_H3_finishDate_AnneeProjModeleMedian_ = NA,
                            CTRIP_rcp45_H3_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            CTRIP_rcp85_H0_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            
                            CTRIP_rcp85_H2_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            CTRIP_rcp85_H2_initDate_AnneeProjModeleMedian_ = NA,
                            CTRIP_rcp85_H2_initDelai_AnneeProjModeleMedian_ = NA,
                            CTRIP_rcp85_H2_finishDate_AnneeProjModeleMedian_ = NA,
                            CTRIP_rcp85_H2_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            CTRIP_rcp85_H3_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            CTRIP_rcp85_H3_initDate_AnneeProjModeleMedian_ = NA,
                            CTRIP_rcp85_H3_initDelai_AnneeProjModeleMedian_ = NA,
                            CTRIP_rcp85_H3_finishDate_AnneeProjModeleMedian_ = NA,
                            CTRIP_rcp85_H3_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            GRSD_rcp26_H0_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            
                            GRSD_rcp26_H2_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            GRSD_rcp26_H2_initDate_AnneeProjModeleMedian_ = NA,
                            GRSD_rcp26_H2_initDelai_AnneeProjModeleMedian_ = NA,
                            GRSD_rcp26_H2_finishDate_AnneeProjModeleMedian_ = NA,
                            GRSD_rcp26_H2_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            GRSD_rcp26_H3_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            GRSD_rcp26_H3_initDate_AnneeProjModeleMedian_ = NA,
                            GRSD_rcp26_H3_initDelai_AnneeProjModeleMedian_ = NA,
                            GRSD_rcp26_H3_finishDate_AnneeProjModeleMedian_ = NA,
                            GRSD_rcp26_H3_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            GRSD_rcp45_H0_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            
                            GRSD_rcp45_H2_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            GRSD_rcp45_H2_initDate_AnneeProjModeleMedian_ = NA,
                            GRSD_rcp45_H2_initDelai_AnneeProjModeleMedian_ = NA,
                            GRSD_rcp45_H2_finishDate_AnneeProjModeleMedian_ = NA,
                            GRSD_rcp45_H2_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            GRSD_rcp45_H3_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            GRSD_rcp45_H3_initDate_AnneeProjModeleMedian_ = NA,
                            GRSD_rcp45_H3_initDelai_AnneeProjModeleMedian_ = NA,
                            GRSD_rcp45_H3_finishDate_AnneeProjModeleMedian_ = NA,
                            GRSD_rcp45_H3_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            GRSD_rcp85_H0_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            
                            GRSD_rcp85_H2_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            GRSD_rcp85_H2_initDate_AnneeProjModeleMedian_ = NA,
                            GRSD_rcp85_H2_initDelai_AnneeProjModeleMedian_ = NA,
                            GRSD_rcp85_H2_finishDate_AnneeProjModeleMedian_ = NA,
                            GRSD_rcp85_H2_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            GRSD_rcp85_H3_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            GRSD_rcp85_H3_initDate_AnneeProjModeleMedian_ = NA,
                            GRSD_rcp85_H3_initDelai_AnneeProjModeleMedian_ = NA,
                            GRSD_rcp85_H3_finishDate_AnneeProjModeleMedian_ = NA,
                            GRSD_rcp85_H3_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            J2000_rcp26_H0_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            
                            J2000_rcp26_H2_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            J2000_rcp26_H2_initDate_AnneeProjModeleMedian_ = NA,
                            J2000_rcp26_H2_initDelai_AnneeProjModeleMedian_ = NA,
                            J2000_rcp26_H2_finishDate_AnneeProjModeleMedian_ = NA,
                            J2000_rcp26_H2_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            J2000_rcp26_H3_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            J2000_rcp26_H3_initDate_AnneeProjModeleMedian_ = NA,
                            J2000_rcp26_H3_initDelai_AnneeProjModeleMedian_ = NA,
                            J2000_rcp26_H3_finishDate_AnneeProjModeleMedian_ = NA,
                            J2000_rcp26_H3_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            J2000_rcp45_H0_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            
                            J2000_rcp45_H2_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            J2000_rcp45_H2_initDate_AnneeProjModeleMedian_ = NA,
                            J2000_rcp45_H2_initDelai_AnneeProjModeleMedian_ = NA,
                            J2000_rcp45_H2_finishDate_AnneeProjModeleMedian_ = NA,
                            J2000_rcp45_H2_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            J2000_rcp45_H3_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            J2000_rcp45_H3_initDate_AnneeProjModeleMedian_ = NA,
                            J2000_rcp45_H3_initDelai_AnneeProjModeleMedian_ = NA,
                            J2000_rcp45_H3_finishDate_AnneeProjModeleMedian_ = NA,
                            J2000_rcp45_H3_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            J2000_rcp85_H0_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            
                            J2000_rcp85_H2_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            J2000_rcp85_H2_initDate_AnneeProjModeleMedian_ = NA,
                            J2000_rcp85_H2_initDelai_AnneeProjModeleMedian_ = NA,
                            J2000_rcp85_H2_finishDate_AnneeProjModeleMedian_ = NA,
                            J2000_rcp85_H2_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            J2000_rcp85_H3_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            J2000_rcp85_H3_initDate_AnneeProjModeleMedian_ = NA,
                            J2000_rcp85_H3_initDelai_AnneeProjModeleMedian_ = NA,
                            J2000_rcp85_H3_finishDate_AnneeProjModeleMedian_ = NA,
                            J2000_rcp85_H3_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            ORCHIDEE_rcp26_H0_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            
                            ORCHIDEE_rcp26_H2_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            ORCHIDEE_rcp26_H2_initDate_AnneeProjModeleMedian_ = NA,
                            ORCHIDEE_rcp26_H2_initDelai_AnneeProjModeleMedian_ = NA,
                            ORCHIDEE_rcp26_H2_finishDate_AnneeProjModeleMedian_ = NA,
                            ORCHIDEE_rcp26_H2_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            ORCHIDEE_rcp26_H3_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            ORCHIDEE_rcp26_H3_initDate_AnneeProjModeleMedian_ = NA,
                            ORCHIDEE_rcp26_H3_initDelai_AnneeProjModeleMedian_ = NA,
                            ORCHIDEE_rcp26_H3_finishDate_AnneeProjModeleMedian_ = NA,
                            ORCHIDEE_rcp26_H3_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            ORCHIDEE_rcp45_H0_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            
                            ORCHIDEE_rcp45_H2_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            ORCHIDEE_rcp45_H2_initDate_AnneeProjModeleMedian_ = NA,
                            ORCHIDEE_rcp45_H2_initDelai_AnneeProjModeleMedian_ = NA,
                            ORCHIDEE_rcp45_H2_finishDate_AnneeProjModeleMedian_ = NA,
                            ORCHIDEE_rcp45_H2_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            ORCHIDEE_rcp45_H3_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            ORCHIDEE_rcp45_H3_initDate_AnneeProjModeleMedian_ = NA,
                            ORCHIDEE_rcp45_H3_initDelai_AnneeProjModeleMedian_ = NA,
                            ORCHIDEE_rcp45_H3_finishDate_AnneeProjModeleMedian_ = NA,
                            ORCHIDEE_rcp45_H3_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            ORCHIDEE_rcp85_H0_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            
                            ORCHIDEE_rcp85_H2_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            ORCHIDEE_rcp85_H2_initDate_AnneeProjModeleMedian_ = NA,
                            ORCHIDEE_rcp85_H2_initDelai_AnneeProjModeleMedian_ = NA,
                            ORCHIDEE_rcp85_H2_finishDate_AnneeProjModeleMedian_ = NA,
                            ORCHIDEE_rcp85_H2_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            ORCHIDEE_rcp85_H3_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            ORCHIDEE_rcp85_H3_initDate_AnneeProjModeleMedian_ = NA,
                            ORCHIDEE_rcp85_H3_initDelai_AnneeProjModeleMedian_ = NA,
                            ORCHIDEE_rcp85_H3_finishDate_AnneeProjModeleMedian_ = NA,
                            ORCHIDEE_rcp85_H3_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            SMASH_rcp26_H0_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            
                            SMASH_rcp26_H2_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            SMASH_rcp26_H2_initDate_AnneeProjModeleMedian_ = NA,
                            SMASH_rcp26_H2_initDelai_AnneeProjModeleMedian_ = NA,
                            SMASH_rcp26_H2_finishDate_AnneeProjModeleMedian_ = NA,
                            SMASH_rcp26_H2_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            SMASH_rcp26_H3_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            SMASH_rcp26_H3_initDate_AnneeProjModeleMedian_ = NA,
                            SMASH_rcp26_H3_initDelai_AnneeProjModeleMedian_ = NA,
                            SMASH_rcp26_H3_finishDate_AnneeProjModeleMedian_ = NA,
                            SMASH_rcp26_H3_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            SMASH_rcp45_H0_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            
                            SMASH_rcp45_H2_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            SMASH_rcp45_H2_initDate_AnneeProjModeleMedian_ = NA,
                            SMASH_rcp45_H2_initDelai_AnneeProjModeleMedian_ = NA,
                            SMASH_rcp45_H2_finishDate_AnneeProjModeleMedian_ = NA,
                            SMASH_rcp45_H2_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            SMASH_rcp45_H3_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            SMASH_rcp45_H3_initDate_AnneeProjModeleMedian_ = NA,
                            SMASH_rcp45_H3_initDelai_AnneeProjModeleMedian_ = NA,
                            SMASH_rcp45_H3_finishDate_AnneeProjModeleMedian_ = NA,
                            SMASH_rcp45_H3_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            SMASH_rcp85_H0_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            
                            SMASH_rcp85_H2_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            SMASH_rcp85_H2_initDate_AnneeProjModeleMedian_ = NA,
                            SMASH_rcp85_H2_initDelai_AnneeProjModeleMedian_ = NA,
                            SMASH_rcp85_H2_finishDate_AnneeProjModeleMedian_ = NA,
                            SMASH_rcp85_H2_finishDelai_AnneeProjModeleMedian_ = NA,
                            
                            SMASH_rcp85_H3_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_ = NA,
                            SMASH_rcp85_H3_initDate_AnneeProjModeleMedian_ = NA,
                            SMASH_rcp85_H3_initDelai_AnneeProjModeleMedian_ = NA,
                            SMASH_rcp85_H3_finishDate_AnneeProjModeleMedian_ = NA,
                            SMASH_rcp85_H3_finishDelai_AnneeProjModeleMedian_ = NA)


for (nom_categorieSimu_list_ in nom_categorieSimu_list_list_){
  
  for (date_intervalle_ in list(c("1976-01-01","2005-12-31"),
                                c("2041-01-01","2070-12-31"),
                                c("2070-01-01","2099-12-31"))){
    
    # ### Description HER ###
    HER_ <- c("2", "3", "5", "12", "13", "14", "17", "21", "22", "24", "25", "27", "28", "34", "35", "36",
              "38", "40", "41", "43", "44", "50", "51", "52", "53", "55", "56", "57", "58", "59", "61", 
              "62", "63", "64", "65", "66", "67", "68", "70", "71", "73", "74", "75", "76", "77", "78",
              "79", "81", "84", "85", "86", "87", "91", "93", "94", "97", "98", "99", "101", "103", "104",
              "105", "106", "107", "108", "112", "113", "117", "118", "120", "31033039", "37054", "69096",
              "89092", "49090")
    
    if (str_before_first(nom_categorieSimu_,"_") == "J2000"){
      HER_ <- HER_[which(!(HER_ %in% HER_eliminees_J2000))]
    }
    
    for (HER_h_ in HER_){
      
      tab_ProbaMeanJuilOct_HER_generale_ <- NULL
      tab_initDate_HER_generale_ <- NULL
      tab_initDelai_HER_generale_ <- NULL
      tab_finishDate_HER_generale_ <- NULL
      tab_finishDelai_HER_generale_ <- NULL
      
      # for (nom_categorieSimu_ in nom_categorieSimu_list_[[1]]){
      for (nom_categorieSimu_ in nom_categorieSimu_list_){
        print(nom_categorieSimu_)
        
        ### Mean proba ###
        if (file.exists(paste0("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/",
                               ifelse(obsSim_param_=="",nom_GCM_param_,
                                      paste0("FDC_",obsSim_param_,
                                             ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                             ifelse(nom_categorieSimu_=="","",nom_categorieSimu_))),
                               "/Tab_Indicateurs_ProbaMeanJuilOct_HER",
                               HER_h_,"_",
                               paste0(unique(correctionBiais_), collapse = ""),"_",
                               "Historical",str_before_first(str_after_last(nom_categorieSimu_,"_"),"/"),".txt"))){
          
          tab_ProbaMeanJuilOct_HER_ <- read.table(paste0("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/",
                                                         ifelse(obsSim_param_=="",nom_GCM_param_,
                                                                paste0("FDC_",obsSim_param_,
                                                                       ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                                       ifelse(nom_categorieSimu_=="","",nom_categorieSimu_))),
                                                         "/Tab_Indicateurs_ProbaMeanJuilOct_HER",
                                                         HER_h_,"_",
                                                         paste0(unique(correctionBiais_), collapse = ""),"_",
                                                         "Historical",str_before_first(str_after_last(nom_categorieSimu_,"_"),"/"),".txt"),
                                                  sep = ";", dec = ".", header = T)
          tab_ProbaMeanJuilOct_HER_ <- tab_ProbaMeanJuilOct_HER_[which(tab_ProbaMeanJuilOct_HER_$Year >= 1976 & tab_ProbaMeanJuilOct_HER_$Year <= 2099),]
          
          if (is.null(tab_ProbaMeanJuilOct_HER_generale_)){
            tab_ProbaMeanJuilOct_HER_generale_ <- tab_ProbaMeanJuilOct_HER_
          }else{
            tab_ProbaMeanJuilOct_HER_generale_ <- cbind(tab_ProbaMeanJuilOct_HER_generale_, tab_ProbaMeanJuilOct_HER_[,which(colnames(tab_ProbaMeanJuilOct_HER_) != "Year")])
          }
        }
        
        # Init Date #
        if (file.exists(paste0("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/",
                               ifelse(obsSim_param_=="",nom_GCM_param_,
                                      paste0("FDC_",obsSim_param_,
                                             ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                             ifelse(nom_categorieSimu_=="","",nom_categorieSimu_))),
                               "/Tab_Indicateurs_InitDate_Seuil20_HER",
                               HER_h_,"_",
                               paste0(unique(correctionBiais_), collapse = ""),"_",
                               "Historical",str_before_first(str_after_last(nom_categorieSimu_,"_"),"/"),".txt"))){
          
          tab_initDate_HER_ <- read.table(paste0("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/",
                                                 ifelse(obsSim_param_=="",nom_GCM_param_,
                                                        paste0("FDC_",obsSim_param_,
                                                               ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                               ifelse(nom_categorieSimu_=="","",nom_categorieSimu_))),
                                                 "/Tab_Indicateurs_InitDate_Seuil20_HER",
                                                 HER_h_,"_",
                                                 paste0(unique(correctionBiais_), collapse = ""),"_",
                                                 "Historical",str_before_first(str_after_last(nom_categorieSimu_,"_"),"/"),".txt"),
                                          sep = ";", dec = ".", header = T)
          tab_initDate_HER_ <- tab_initDate_HER_[which(tab_initDate_HER_$Year >= 1976 & tab_initDate_HER_$Year <= 2099),]
          
          if (is.null(tab_initDate_HER_generale_)){
            tab_initDate_HER_generale_ <- tab_initDate_HER_
          }else{
            tab_initDate_HER_generale_ <- cbind(tab_initDate_HER_generale_, tab_initDate_HER_[,which(colnames(tab_initDate_HER_) != "Year")])
          }
        }
        
        # Finish Date #
        if (file.exists(paste0("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/",
                               ifelse(obsSim_param_=="",nom_GCM_param_,
                                      paste0("FDC_",obsSim_param_,
                                             ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                             ifelse(nom_categorieSimu_=="","",nom_categorieSimu_))),
                               "/Tab_Indicateurs_InitDate_Seuil20_HER",
                               HER_h_,"_",
                               paste0(unique(correctionBiais_), collapse = ""),"_",
                               "Historical",str_before_first(str_after_last(nom_categorieSimu_,"_"),"/"),".txt"))){
          
          tab_finishDate_HER_ <- read.table(paste0("/media/tjaouen/Ultra Touch1/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/",
                                                   ifelse(obsSim_param_=="",nom_GCM_param_,
                                                          paste0("FDC_",obsSim_param_,
                                                                 ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                                 ifelse(nom_categorieSimu_=="","",nom_categorieSimu_))),
                                                   "/Tab_Indicateurs_FinishDate_Seuil20_HER",
                                                   HER_h_,"_",
                                                   paste0(unique(correctionBiais_), collapse = ""),"_",
                                                   "Historical",str_before_first(str_after_last(nom_categorieSimu_,"_"),"/"),".txt"),
                                            sep = ";", dec = ".", header = T)
          tab_finishDate_HER_ <- tab_finishDate_HER_[which(tab_finishDate_HER_$Year >= 1976 & tab_finishDate_HER_$Year <= 2099),]
          
          if (is.null(tab_finishDate_HER_generale_)){
            tab_finishDate_HER_generale_ <- tab_finishDate_HER_
          }else{
            tab_finishDate_HER_generale_ <- cbind(tab_finishDate_HER_generale_, tab_finishDate_HER_[,which(colnames(tab_finishDate_HER_) != "Year")])
          }
        }
      }
      
      horizon_ <- ifelse(min(year(date_intervalle_))==1976,"H0",ifelse(min(year(date_intervalle_))==2041,"H2","H3"))
      
      # Proba mean #
      if (!is.null(tab_ProbaMeanJuilOct_HER_generale_)){
        proba_median_ <- round(median(unlist(tab_ProbaMeanJuilOct_HER_generale_[which(tab_ProbaMeanJuilOct_HER_generale_$Year >= min(year(date_intervalle_)) &
                                                                                        tab_ProbaMeanJuilOct_HER_generale_$Year <= max(year(date_intervalle_))),
                                                                                2:ncol(tab_ProbaMeanJuilOct_HER_generale_)])),2)
        if (length(nom_categorieSimu_list_) > 1){
          tab_allModels[which(tab_allModels$HER == HER_h_),paste0("General_",str_before_first(str_after_last(nom_categorieSimu_,"_"),"/"),"_",horizon_,"_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_")] = proba_median_
        }else{
          tab_allModels[which(tab_allModels$HER == HER_h_),paste0(str_before_first(nom_categorieSimu_,"_"),"_",str_before_first(str_after_last(nom_categorieSimu_,"_"),"/"),"_",horizon_,"_propAssecMoyenneJuilletOct_AnneeProjModeleMedian_")] = proba_median_
        }
      }
      
      # Init date #
      if (!is.null(tab_initDate_HER_generale_)){
        initDate_median_ <- format(median(as.Date(unlist(tab_initDate_HER_generale_[which(tab_initDate_HER_generale_$Year >= min(year(date_intervalle_)) &
                                                                                          tab_initDate_HER_generale_$Year <= max(year(date_intervalle_))),
                                                                                  2:ncol(tab_initDate_HER_generale_)])), na.rm = T),"%d/%m")
        if (length(nom_categorieSimu_list_) > 1){
          tab_allModels[which(tab_allModels$HER == HER_h_),paste0("General_",str_before_first(str_after_last(nom_categorieSimu_,"_"),"/"),"_",horizon_,"_initDate_AnneeProjModeleMedian_")] = initDate_median_
        }else{
          tab_allModels[which(tab_allModels$HER == HER_h_),paste0(str_before_first(nom_categorieSimu_,"_"),"_",str_before_first(str_after_last(nom_categorieSimu_,"_"),"/"),"_",horizon_,"_initDate_AnneeProjModeleMedian_")] = initDate_median_
        }
        
        initDate_median_test_ <- lapply(tab_initDate_HER_generale_[which(tab_initDate_HER_generale_$Year >= min(year(date_intervalle_)) &
                                                                         tab_initDate_HER_generale_$Year <= max(year(date_intervalle_))),
                                                                 2:ncol(tab_initDate_HER_generale_)], function(x) median(x,na.rm=T))
        initDate_median_ref_ <- lapply(tab_initDate_HER_generale_[which(tab_initDate_HER_generale_$Year >= min(year(c("1976-01-01","2005-12-31"))) &
                                                                          tab_initDate_HER_generale_$Year <= max(year(c("1976-01-01","2005-12-31")))),
                                                                  2:ncol(tab_initDate_HER_generale_)], function(x) median(x,na.rm=T))
        if (length(nom_categorieSimu_list_) > 1){
          tab_allModels[which(tab_allModels$HER == HER_h_),paste0("General_",str_before_first(str_after_last(nom_categorieSimu_,"_"),"/"),"_",horizon_,"_initDelai_AnneeProjModeleMedian_")] = round(median(as.Date(unlist(initDate_median_ref_)) - as.Date(unlist(initDate_median_test_)), na.rm = T),1)
        }else{
          tab_allModels[which(tab_allModels$HER == HER_h_),paste0(str_before_first(nom_categorieSimu_,"_"),"_",str_before_first(str_after_last(nom_categorieSimu_,"_"),"/"),"_",horizon_,"_initDelai_AnneeProjModeleMedian_")] = round(median(as.Date(unlist(initDate_median_ref_)) - as.Date(unlist(initDate_median_test_)), na.rm = T),1)
        }
      }
      
      
      # Finish date #
      if (!is.null(tab_initDate_HER_generale_)){
        finishDate_median_ <- format(median(as.Date(unlist(tab_finishDate_HER_generale_[which(tab_finishDate_HER_generale_$Year >= min(year(date_intervalle_)) &
                                                                                              tab_finishDate_HER_generale_$Year <= max(year(date_intervalle_))),
                                                                                      2:ncol(tab_finishDate_HER_generale_)])), na.rm = T),"%d/%m")
        if (length(nom_categorieSimu_list_) > 1){
          tab_allModels[which(tab_allModels$HER == HER_h_),paste0("General_",str_before_first(str_after_last(nom_categorieSimu_,"_"),"/"),"_",horizon_,"_finishDate_AnneeProjModeleMedian_")] = finishDate_median_
        }else{
          tab_allModels[which(tab_allModels$HER == HER_h_),paste0(str_before_first(nom_categorieSimu_,"_"),"_",str_before_first(str_after_last(nom_categorieSimu_,"_"),"/"),"_",horizon_,"_finishDate_AnneeProjModeleMedian_")] = finishDate_median_
        }
      
        # Finish delai #
        finishDate_median_test_ <- lapply(tab_finishDate_HER_generale_[which(tab_finishDate_HER_generale_$Year >= min(year(date_intervalle_)) &
                                                                               tab_finishDate_HER_generale_$Year <= max(year(date_intervalle_))),
                                                                       2:ncol(tab_finishDate_HER_generale_)], function(x) median(x,na.rm=T))
        finishDate_median_ref_ <- lapply(tab_finishDate_HER_generale_[which(tab_finishDate_HER_generale_$Year >= min(year(c("1976-01-01","2005-12-31"))) &
                                                                              tab_finishDate_HER_generale_$Year <= max(year(c("1976-01-01","2005-12-31")))),
                                                                      2:ncol(tab_finishDate_HER_generale_)], function(x) median(x,na.rm=T))
        if (length(nom_categorieSimu_list_) > 1){
          tab_allModels[which(tab_allModels$HER == HER_h_),paste0("General_",str_before_first(str_after_last(nom_categorieSimu_,"_"),"/"),"_",horizon_,"_finishDelai_AnneeProjModeleMedian_")] = round(median(as.Date(unlist(finishDate_median_test_)) - as.Date(unlist(finishDate_median_ref_)), na.rm = T),1)
        }else{
          tab_allModels[which(tab_allModels$HER == HER_h_),paste0(str_before_first(nom_categorieSimu_,"_"),"_",str_before_first(str_after_last(nom_categorieSimu_,"_"),"/"),"_",horizon_,"_finishDelai_AnneeProjModeleMedian_")] = round(median(as.Date(unlist(finishDate_median_test_)) - as.Date(unlist(finishDate_median_ref_)), na.rm = T),1)
        }
      }
    }
  }
}

write.table(tab_allModels,
            "/media/tjaouen/Ultra Touch1/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/StatistiquesPFI_TableProbaMean_ParHER_MedianParAnneeEtHM_1_20240904.csv",
            sep = ";", dec = ".", row.names = F)

tab_results_merge_ <- tab_allModels
# tab_results_merge_ <- merge(tab_results_,tab_allModels, by = "HER")
general_cols <- grep("^General", colnames(tab_results_merge_), value = TRUE)
general_cols_sorted <- sort(general_cols)
other_cols <- setdiff(colnames(tab_results_merge_), c("HER", general_cols))
other_cols_sorted <- sort(other_cols)
tab_results_merge_ <- tab_results_merge_[, c("HER",general_cols_sorted,other_cols_sorted)]

col_names <- colnames(tab_results_merge_)
new_order <- NULL
i <- 1
while (i <= length(col_names)) {
  # Vérifie si une paire "finishDate" / "initDate" est présente
  if (grepl("finishDate", col_names[i]) && (i+1 <= length(col_names)) &&
      grepl("finishDelai", col_names[i+1]) && (i+2 <= length(col_names)) &&
      grepl("initDate", col_names[i+2]) && (i+3 <= length(col_names)) &&
      grepl("initDelai", col_names[i+3]) && (i+4 <= length(col_names)) &&
      grepl("propAssec", col_names[i+4])) {
    # Inverse l'ordre de la paire
    new_order <- c(new_order,
                   col_names[i+4],
                   col_names[i+2],
                   col_names[i+3],
                   col_names[i],
                   col_names[i+1])
    i <- i + 5  # Passe à la paire suivante
  }else if(grepl("finishDate", col_names[i]) && (i+1 <= length(col_names)) &&
           grepl("initDate", col_names[i+1]) && (i+2 <= length(col_names)) &&
           grepl("propAssec", col_names[i+2])) {
      # Inverse l'ordre de la paire
      new_order <- c(new_order,
                     col_names[i+2],
                     col_names[i+1],
                     col_names[i])
      i <- i + 3  # Passe à la paire suivante
  } else {
    # Si pas de paire à inverser, ajouter simplement la colonne
    new_order <- c(new_order, col_names[i])
    i <- i + 1
  }
}
tab_results_merge_ <- tab_results_merge_[, new_order]
tab_results_merge_ <- tab_results_merge_[,which(!grepl("H0_initDelai",colnames(tab_results_merge_)))]
tab_results_merge_ <- tab_results_merge_[,which(!grepl("H0_finishDelai",colnames(tab_results_merge_)))]


write.table(tab_results_merge_,
            "/media/tjaouen/Ultra Touch1/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/StatistiquesPFI_TableProbaMeanAndDates_ParHER_MedianParAnneeEtHMpuisParHM_1_20240904.csv",
            sep = ";", dec = ".", row.names = F)






