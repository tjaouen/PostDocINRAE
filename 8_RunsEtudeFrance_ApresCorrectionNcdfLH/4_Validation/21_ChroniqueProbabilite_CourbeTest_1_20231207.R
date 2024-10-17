source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")

# Charger les bibliothèques nécessaires
library(dplyr)

find_closest_index <- function(x, y) {
  sapply(x, function(val) which.min(abs(val - y)))
}

folder_input_DD_ = folder_input_DD_param_

nom_categorieRef_ = "GRSD_20231128/ChroniquesCombinees_saf_rcp85"
# nom_categorieTest_ = "GRSD_20231128/ChroniquesBrutes_rcp85"
nom_categorieTest_ = "GRSD_20231128/ChroniquesBrutes_historical"

GCM_RCM_ref_ = c("CNRM-CM5","CNRM-ALADIN63") # option 1 en hist_saf_rcp, 5 en saf_rcp
# GCM_RCM_ref_ = c("ICHEC-EC-EARTH","MOHC-HadREM3") # option 2 en hist_saf_rcp, 6 en saf_rcp
# GCM_RCM_ref_ = c("MOHC-HADGEM2","CLMcom-CCLM4") # option 3 en hist_saf_rcp, 7 en saf_rcp
# GCM_RCM_ref_ = c("MOHC-HADGEM2","CNRM-ALADIN63") # option 4 en hist_saf_rcp, 8 en saf_rcp

option_ref_ = paste0("Modele_",basename(nom_categorieRef_),"_",paste(GCM_RCM_ref_,collapse = "_"))

courbe_FDCcalibree_ref = list.files(paste0("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/FlowDurationCurves/FDC_Projections/",nom_categorieRef_),
                        full.names = T)

courbe_test = list.files(paste0("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/",nom_categorieTest_),
                         full.names = T)

courbe_FDCcalibree_ref_in = list.files(courbe_FDCcalibree_ref[grepl(GCM_RCM_ref_[1],courbe_FDCcalibree_ref) & grepl(GCM_RCM_ref_[2],courbe_FDCcalibree_ref)],
                           full.names = T)

courbe_test_in = list.files(courbe_test[1],
                            full.names = T)


for (c in courbe_test_in){
  nom_fichier_test <- basename(c)
  courbe_test = read.table(c, sep = ";", header = T)
  
  # Vérifier si le fichier correspondant existe dans le répertoire 2
  if (paste0("FDC_",nom_fichier_test) %in% basename(courbe_FDCcalibree_ref_in)) {
    fichier2 <- file.path(str_before_last(courbe_FDCcalibree_ref_in[1],"/"), paste0("FDC_",nom_fichier_test))
    courbe_FDCcalibree_ref <- read.table(fichier2, sep = ";", header = T)
    
    # Créer une nouvelle colonne contenant les index des débits les plus proches dans courbe_FDCcalibree_ref
    courbe_test$Index_Ref <- sapply(courbe_test$Qm3s1, function(x) which.min(abs(x - courbe_FDCcalibree_ref$Debit)))

    # Ajouter une colonne FDC à partir des valeurs correspondant aux index dans courbe_FDCcalibree_ref
    courbe_test$FreqNonDep <- courbe_FDCcalibree_ref$FreqNonDep[courbe_test$Index_Ref]
    
    # courbe_test$FreqNonDep = NA
    # for (k in 1:nrow(courbe_test)){
    #   courbe_test$FreqNonDep[k] = courbe_FDCcalibree_ref$FreqNonDep[which.min(abs(courbe_FDCcalibree_ref$Debit - courbe_test$Qm3s1[k]))]
    # }
    
    # courbe_test <- courbe_test %>%
    #   mutate(Index_Ref = find_closest_index(Qm3s1, courbe_FDCcalibree_ref$Debit),
    #          FreqNonDep = courbe_FDCcalibree_ref$FreqNonDep[Index_Ref])
    
    
    # Afficher le dataframe résultant
    # print(courbe_test)
    
    if (!dir.exists(paste0(folder_input_DD_, "FlowDurationCurves/",
                           ifelse(obsSim_=="",nom_GCM_,
                                  paste0("FDC_",obsSim_,
                                         ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                         ifelse(nom_categorieTest_=="","",nom_categorieTest_),"/",
                                         option_ref_,"/"))))){
      dir.create(paste0(folder_input_DD_, "FlowDurationCurves/",
                        ifelse(obsSim_=="",nom_GCM_,
                               paste0("FDC_",obsSim_,
                                      ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                      ifelse(nom_categorieTest_=="","",nom_categorieTest_),"/",
                                      option_ref_,"/"))))
    }
    
    if (!dir.exists(paste0(folder_input_DD_, "FlowDurationCurves/",
                           ifelse(obsSim_=="",nom_GCM_,
                                  paste0("FDC_",obsSim_,
                                         ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                         ifelse(nom_categorieTest_=="","",nom_categorieTest_),"/",
                                         option_ref_,"/",
                                         ifelse(nom_GCM_=="","",nom_GCM_)))))){
      dir.create(paste0(folder_input_DD_, "FlowDurationCurves/",
                        ifelse(obsSim_=="",nom_GCM_,
                               paste0("FDC_",obsSim_,
                                      ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                      ifelse(nom_categorieTest_=="","",nom_categorieTest_),"/",
                                      option_ref_,"/",
                                      ifelse(nom_GCM_=="","",nom_GCM_)))))
    }
    
    stop("VERIFIER QUE FORMAT DATE OK")
    courbe_test$Date <- format(as.Date(courbe_test$Date), "%Y%m%d")
    courbe_test$Type <- str_after_last(nom_categorieTest_,"_")
    
    write.table(courbe_test,
                paste0(folder_input_DD_, "FlowDurationCurves/",
                       ifelse(obsSim_=="",nom_GCM_,
                              paste0("FDC_",obsSim_,
                                     ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                     ifelse(nom_categorieTest_=="","",nom_categorieTest_),"/",
                                     option_ref_,"/",
                                     ifelse(nom_GCM_=="","",nom_GCM_),"/",
                                     "FDC_",nom_fichier_test))),
                sep = ";", dec = ".", row.names = F)
    
  }

}


