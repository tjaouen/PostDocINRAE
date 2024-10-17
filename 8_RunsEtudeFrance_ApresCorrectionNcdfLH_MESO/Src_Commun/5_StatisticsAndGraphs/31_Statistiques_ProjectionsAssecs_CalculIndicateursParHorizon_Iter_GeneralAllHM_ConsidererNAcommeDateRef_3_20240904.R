# print("GRSD - 8_Chroniques_ProjectionsAssecs_19752004_7local_20240229.R")
# source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_GRSD/PathsProgram/PathProgram_1_20230206.R")
# source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_GRSD/1_Parameters_MESO/0_SimulationParameters_AvecCC_2_20230227_MESO.R")
# source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_Commun/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")

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
HER_ = HER_param_
HER_eliminees_J2000 <- c("10", "21", "22", "24", "27", "34", "35", "36", "57", "59", "61", "65", "67", "68",
                         "77", "78", "93", "94", "103", "108", "118", "0", "31033039", "69096",
                         "66", "64", "117", "112", "56", "62", "38", "40", "105", "17", "25", "107",
                         "55", "12", "53")


pattern_rcp_ = str_before_last(str_after_last(nom_categorieSimu_,"_"),"/")
pattern_SafranHistRcp_ = "Historical|rcp"
correctionBiais_ = "ADAMONT"
seuilAssec_ = 20

nom_categorieSimu_list_ = c("CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26/",
                            "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26/",
                            "J2000_20231128/ChroniquesCombinees_saf_hist_rcp26/",
                            "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26/",
                            "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26/")

# nom_categorieSimu_list_ = c("CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45/",
#                             "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp45/",
#                             "J2000_20231128/ChroniquesCombinees_saf_hist_rcp45/",
#                             "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp45/",
#                             "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp45/")

# nom_categorieSimu_list_ = c("CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/",
#                             "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/",
#                             "J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/",
#                             "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/",
#                             "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/")

# date_intervalle_ = c("1976-01-01","2005-12-31")
# date_intervalle_ = c("2041-01-01","2070-12-31")
# date_intervalle_ = c("2070-01-01","2099-12-31")

tab_allModels <- data.frame(HER = HER_,
                            propAssecMoyenneJuilletOct_ModeleMedian_19762005 = NA,
                            propAssecMoyenneJuilletOct_ModeleMedian_20412070 = NA,
                            propAssecMoyenneJuilletOct_ModeleMedian_20702099 = NA)

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
    
    for (nom_categorieSimu_ in nom_categorieSimu_list_){
      
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
    }
    
    initDate_list_median_ <- lapply(tab_ProbaMeanJuilOct_HER_generale_[which(tab_ProbaMeanJuilOct_HER_generale_$Year >= min(year(date_intervalle_)) &
                                                                               tab_ProbaMeanJuilOct_HER_generale_$Year <= max(year(date_intervalle_))),
                                                                       2:ncol(tab_ProbaMeanJuilOct_HER_generale_)], function(x) round(median(x,na.rm=T),1))
    tab_allModels[which(tab_allModels$HER == HER_h_),paste0("propAssecMoyenneJuilletOct_ModeleMedian_",min(year(date_intervalle_)),max(year(date_intervalle_)))] = initDate_list_median_
  }
}

write.table(tab_allModels,
            "/media/tjaouen/Ultra Touch1/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/StatistiquesPFI_TableProbaMean_ParHER_MedianParAnneeEtHM_1_20240904.csv",
            sep = ";", dec = ".", row.names = F)




