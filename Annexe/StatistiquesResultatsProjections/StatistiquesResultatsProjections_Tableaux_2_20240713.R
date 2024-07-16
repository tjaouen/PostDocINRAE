


CTRIP_H0_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
CTRIP_H2_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
CTRIP_H3_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp85.txt", sep = ";", dec = ".", header = T)

GRSD_H0_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
GRSD_H2_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
GRSD_H3_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp85.txt", sep = ";", dec = ".", header = T)

J2000_H0_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
J2000_H2_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
J2000_H3_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp85.txt", sep = ";", dec = ".", header = T)

ORCHIDEE_H0_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
ORCHIDEE_H2_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
ORCHIDEE_H3_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp85.txt", sep = ";", dec = ".", header = T)

SMASH_H0_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_19762005_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
SMASH_H2_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20412070_Historicalrcp85.txt", sep = ";", dec = ".", header = T)
SMASH_H3_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_Indicateurs_ADAMONT_20702099_Historicalrcp85.txt", sep = ";", dec = ".", header = T)


# Je prends la mediane de la dateInit sur les annees 1976-2005 pour chaque scenario et chaque HM
# Je regarde le min de tous les scenarios et tous les HM
# Je regarde le max de tous les scenarios et tous les HM
# Je regarde le min et le max par HM de leur scenarios medians


makeBlocTable_initDate_ <- function(HER_){
  
  vect_ <- c(
    
    ### H0 57 ###
    format(min(c(as.Date(CTRIP_H0_$initDate_min_[which(CTRIP_H0_$HER == HER_)]),
               as.Date(GRSD_H0_$initDate_min_[which(GRSD_H0_$HER == HER_)]),
               as.Date(ORCHIDEE_H0_$initDate_min_[which(ORCHIDEE_H0_$HER == HER_)]),
               as.Date(SMASH_H0_$initDate_min_[which(SMASH_H0_$HER == HER_)]))),"%d/%m"),
    
    format(median(c(as.Date(CTRIP_H0_$initDate_median_[which(CTRIP_H0_$HER == HER_)]),
                    as.Date(GRSD_H0_$initDate_median_[which(GRSD_H0_$HER == HER_)]),
                    as.Date(ORCHIDEE_H0_$initDate_median_[which(ORCHIDEE_H0_$HER == HER_)]),
                    as.Date(SMASH_H0_$initDate_median_[which(SMASH_H0_$HER == HER_)]))),"%d/%m"),
    
    format(max(c(as.Date(CTRIP_H0_$initDate_max_[which(CTRIP_H0_$HER == HER_)]),
                 as.Date(GRSD_H0_$initDate_max_[which(GRSD_H0_$HER == HER_)]),
                 as.Date(ORCHIDEE_H0_$initDate_max_[which(ORCHIDEE_H0_$HER == HER_)]),
                 as.Date(SMASH_H0_$initDate_max_[which(SMASH_H0_$HER == HER_)]))),"%d/%m"),
    
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
    
    ### H0 57 ###
    min(CTRIP_H0_$propAssecMoyenneJuilletOct_ModeleMin_[which(CTRIP_H0_$HER == HER_)],
        GRSD_H0_$propAssecMoyenneJuilletOct_ModeleMin_[which(GRSD_H0_$HER == HER_)],
        ORCHIDEE_H0_$propAssecMoyenneJuilletOct_ModeleMin_[which(ORCHIDEE_H0_$HER == HER_)],
        SMASH_H0_$propAssecMoyenneJuilletOct_ModeleMin_[which(SMASH_H0_$HER == HER_)]),
    
    median(CTRIP_H0_$propAssecMoyenneJuilletOct_ModeleMedian_[which(CTRIP_H0_$HER == HER_)],
               GRSD_H0_$propAssecMoyenneJuilletOct_ModeleMedian_[which(GRSD_H0_$HER == HER_)],
               ORCHIDEE_H0_$propAssecMoyenneJuilletOct_ModeleMedian_[which(ORCHIDEE_H0_$HER == HER_)],
               SMASH_H0_$propAssecMoyenneJuilletOct_ModeleMedian_[which(SMASH_H0_$HER == HER_)]),
    
    max(CTRIP_H0_$propAssecMoyenneJuilletOct_ModeleMax_[which(CTRIP_H0_$HER == HER_)],
        GRSD_H0_$propAssecMoyenneJuilletOct_ModeleMax_[which(GRSD_H0_$HER == HER_)],
        ORCHIDEE_H0_$propAssecMoyenneJuilletOct_ModeleMax_[which(ORCHIDEE_H0_$HER == HER_)],
        SMASH_H0_$propAssecMoyenneJuilletOct_ModeleMax_[which(SMASH_H0_$HER == HER_)]),
    
    ### H2 57 ###
    min(CTRIP_H2_$propAssecMoyenneJuilletOct_ModeleMin_[which(CTRIP_H2_$HER == HER_)],
        GRSD_H2_$propAssecMoyenneJuilletOct_ModeleMin_[which(GRSD_H2_$HER == HER_)],
        ORCHIDEE_H2_$propAssecMoyenneJuilletOct_ModeleMin_[which(ORCHIDEE_H2_$HER == HER_)],
        SMASH_H2_$propAssecMoyenneJuilletOct_ModeleMin_[which(SMASH_H2_$HER == HER_)]),
    
    median(CTRIP_H2_$propAssecMoyenneJuilletOct_ModeleMedian_[which(CTRIP_H2_$HER == HER_)],
               GRSD_H2_$propAssecMoyenneJuilletOct_ModeleMedian_[which(GRSD_H2_$HER == HER_)],
               ORCHIDEE_H2_$propAssecMoyenneJuilletOct_ModeleMedian_[which(ORCHIDEE_H2_$HER == HER_)],
               SMASH_H2_$propAssecMoyenneJuilletOct_ModeleMedian_[which(SMASH_H2_$HER == HER_)]),
    
    max(CTRIP_H2_$propAssecMoyenneJuilletOct_ModeleMax_[which(CTRIP_H2_$HER == HER_)],
        GRSD_H2_$propAssecMoyenneJuilletOct_ModeleMax_[which(GRSD_H2_$HER == HER_)],
        ORCHIDEE_H2_$propAssecMoyenneJuilletOct_ModeleMax_[which(ORCHIDEE_H2_$HER == HER_)],
        SMASH_H2_$propAssecMoyenneJuilletOct_ModeleMax_[which(SMASH_H2_$HER == HER_)]),
    
    ### H3 57 ###
    min(CTRIP_H3_$propAssecMoyenneJuilletOct_ModeleMin_[which(CTRIP_H3_$HER == HER_)],
        GRSD_H3_$propAssecMoyenneJuilletOct_ModeleMin_[which(GRSD_H3_$HER == HER_)],
        ORCHIDEE_H3_$propAssecMoyenneJuilletOct_ModeleMin_[which(ORCHIDEE_H3_$HER == HER_)],
        SMASH_H3_$propAssecMoyenneJuilletOct_ModeleMin_[which(SMASH_H3_$HER == HER_)]),
    
    median(CTRIP_H3_$propAssecMoyenneJuilletOct_ModeleMedian_[which(CTRIP_H3_$HER == HER_)],
               GRSD_H3_$propAssecMoyenneJuilletOct_ModeleMedian_[which(GRSD_H3_$HER == HER_)],
               ORCHIDEE_H3_$propAssecMoyenneJuilletOct_ModeleMedian_[which(ORCHIDEE_H3_$HER == HER_)],
               SMASH_H3_$propAssecMoyenneJuilletOct_ModeleMedian_[which(SMASH_H3_$HER == HER_)]),
    
    max(CTRIP_H3_$propAssecMoyenneJuilletOct_ModeleMax_[which(CTRIP_H3_$HER == HER_)],
        GRSD_H3_$propAssecMoyenneJuilletOct_ModeleMax_[which(GRSD_H3_$HER == HER_)],
        ORCHIDEE_H3_$propAssecMoyenneJuilletOct_ModeleMax_[which(ORCHIDEE_H3_$HER == HER_)],
        SMASH_H3_$propAssecMoyenneJuilletOct_ModeleMax_[which(SMASH_H3_$HER == HER_)]))
  
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
        SMASH_H3_$nbMoyenJoursParAnSup20pct_ModeleMax_[which(SMASH_H3_$HER == HER_)]))
  
  return(matrix(vect_, ncol = 3, byrow = T))
  
  
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
            "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/StatistiquesPFI_TableDateInit_1_20240713.csv",
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
            "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/StatistiquesPFI_TableDateFinish_1_20240713.csv",
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
            "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/StatistiquesPFI_TableProbaMean_1_20240713.csv",
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
            "/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/StatistiquesPFI_TableNbJoursSup20_1_20240713.csv",
            sep = ";", dec = ".", row.names = F)


# CTRIP_H0_$initDate_max_[which(CTRIP_H0_$HER == 57)]
# GRSD_H0_$initDate_max_[which(GRSD_H0_$HER == 57)]
# ORCHIDEE_H0_$initDate_max_[which(ORCHIDEE_H0_$HER == 57)]
# SMASH_H0_$initDate_max_[which(SMASH_H0_$HER == 57)]





