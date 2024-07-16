source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run3.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run4.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunGraphe.R")

# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Option0SafranCompletSeul_Run2.R")

source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run3.R")

########### EN COURS DE MODIFICATION ##############

### Libraries ###
library(doParallel)
library(ggplot2)
library(strex)
library(dplyr)

### Study data ###
folder_input_ = folder_input_param_
folder_input_PC_ = folder_input_PC_param_
folder_output_ = folder_output_param_
folder_onde_ = folder_onde_param_
nom_GCM_ = nom_GCM_param_
nom_selectStations_ = nom_selectStations_param_
nom_categorieSimu_ = nom_categorieSimu_param_
HER_ = HER_param_
HER_variable_ = HER_variable_param_
jourMin_ = jourMin_param_
jourMax_ = jourMax_param_
obsSim_ = obsSim_param_
nomSim_ = nomSim_param_
nom_apprentissage_ = "ApprentissageGlobalModelesBruts"
nom_validation_ = ""
annees_validModels_ = ""
nom_seqProjetee_ = nom_seqProjetee_param_

### Chroniques ###
folder_Aprojeter_ <- list.files(paste0(folder_input_,"FlowDurationCurves_HERweighted_meanJm6Jj/",
                                       ifelse(obsSim_=="",nom_GCM_,
                                              paste0("FDC_",obsSim_,
                                                     ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                     nom_seqProjetee_,"/"))), full.names = T)

### Table Modele ###
tab_modeles_ = read.table(list.files(paste0(folder_output_,
                                            "2_ResultatsModeles_ParHer/",
                                            nomSim_,"/",
                                            # "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/",
                                            # "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/",
                                            # "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-20990731/",
                                            # "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CNRM-ALADIN63_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-20990731/",
                                            ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                            ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                                            ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),"/"),
                                     # ifelse(nom_validation_=="","",paste0("/",nom_validation_))),
                                     pattern = "logit", full.names = T),
                          dec = ".", sep = ";", header = T)


### Run ###
cl <- makePSOCKcluster(3)
# cl <- makePSOCKcluster(detectCores()/2-1)
registerDoParallel(cores=cl)

# for (fold_ in folder_Aprojeter_){
output <- foreach(fold_ = folder_Aprojeter_) %dopar% { #, errorhandling='pass'
  
  chroniqueFDCbyHERweighted_ <- read.table(paste0(fold_,"/Tab_FDCchroniquesByHER2weigthedFDC.txt"), sep=";", header = T)
  
  chroniqueFDCbyHERweighted_hist_ <- chroniqueFDCbyHERweighted_[which(chroniqueFDCbyHERweighted_$Type == "Historical"),]
  chroniqueFDCbyHERweighted_proj_ <- chroniqueFDCbyHERweighted_[which(grepl("rcp",chroniqueFDCbyHERweighted_$Type)),]
  chroniqueFDCbyHERweighted_saf_ <- chroniqueFDCbyHERweighted_[which(chroniqueFDCbyHERweighted_$Type == "Safran"),]
  dim(chroniqueFDCbyHERweighted_hist_) # 19724
  dim(chroniqueFDCbyHERweighted_proj_) # CTRIP 34698, GRSD 34333
  dim(chroniqueFDCbyHERweighted_saf_) # CTRIP 16437, GRSD 15705
  
  chroniqueFDCbyHERweighted_hist_[, !colnames(chroniqueFDCbyHERweighted_hist_) %in% c("Date", "Type")]
  colnames(chroniqueFDCbyHERweighted_hist_)[!colnames(chroniqueFDCbyHERweighted_hist_) %in% c("Date", "Type")] <- gsub("X", "", colnames(chroniqueFDCbyHERweighted_hist_)[!colnames(chroniqueFDCbyHERweighted_hist_) %in% c("Date", "Type")])
  
  chroniqueFDCbyHERweighted_proj_[, !colnames(chroniqueFDCbyHERweighted_proj_) %in% c("Date", "Type")]
  colnames(chroniqueFDCbyHERweighted_proj_)[!colnames(chroniqueFDCbyHERweighted_proj_) %in% c("Date", "Type")] <- gsub("X", "", colnames(chroniqueFDCbyHERweighted_proj_)[!colnames(chroniqueFDCbyHERweighted_proj_) %in% c("Date", "Type")])
  
  chroniqueFDCbyHERweighted_saf_[, !colnames(chroniqueFDCbyHERweighted_saf_) %in% c("Date", "Type")]
  colnames(chroniqueFDCbyHERweighted_saf_)[!colnames(chroniqueFDCbyHERweighted_saf_) %in% c("Date", "Type")] <- gsub("X", "", colnames(chroniqueFDCbyHERweighted_saf_)[!colnames(chroniqueFDCbyHERweighted_saf_) %in% c("Date", "Type")])
  
  
  ### Probability ###
  for (i in colnames(chroniqueFDCbyHERweighted_hist_)[3:length(chroniqueFDCbyHERweighted_hist_)]){
    tab_modeles_HER_ <- tab_modeles_[which(tab_modeles_$HER == as.numeric(i)),]
    chroniqueFDCbyHERweighted_hist_[[as.character(i)]] = (exp(tab_modeles_HER_$Inter_logit_Learn+chroniqueFDCbyHERweighted_hist_[[as.character(i)]]*tab_modeles_HER_$Slope_logit_Learn)/
                                                            (1+exp(tab_modeles_HER_$Inter_logit_Learn+chroniqueFDCbyHERweighted_hist_[[as.character(i)]]*tab_modeles_HER_$Slope_logit_Learn)))*100
  }
  for (i in colnames(chroniqueFDCbyHERweighted_proj_)[3:length(chroniqueFDCbyHERweighted_proj_)]){
    tab_modeles_HER_ <- tab_modeles_[which(tab_modeles_$HER == i),]
    chroniqueFDCbyHERweighted_proj_[[as.character(i)]] = (exp(tab_modeles_HER_$Inter_logit_Learn+chroniqueFDCbyHERweighted_proj_[[as.character(i)]]*tab_modeles_HER_$Slope_logit_Learn)/
                                                            (1+exp(tab_modeles_HER_$Inter_logit_Learn+chroniqueFDCbyHERweighted_proj_[[as.character(i)]]*tab_modeles_HER_$Slope_logit_Learn)))*100
  }
  for (i in colnames(chroniqueFDCbyHERweighted_saf_)[3:length(chroniqueFDCbyHERweighted_saf_)]){
    tab_modeles_HER_ <- tab_modeles_[which(tab_modeles_$HER == i),]
    chroniqueFDCbyHERweighted_saf_[[as.character(i)]] = (exp(tab_modeles_HER_$Inter_logit_Learn+chroniqueFDCbyHERweighted_saf_[[as.character(i)]]*tab_modeles_HER_$Slope_logit_Learn)/
                                                           (1+exp(tab_modeles_HER_$Inter_logit_Learn+chroniqueFDCbyHERweighted_saf_[[as.character(i)]]*tab_modeles_HER_$Slope_logit_Learn)))*100
  }
  
  chroniqueFDCbyHERweighted_final_ = rbind(chroniqueFDCbyHERweighted_hist_,
                                           chroniqueFDCbyHERweighted_proj_,
                                           chroniqueFDCbyHERweighted_saf_)
  
  
  if (!(dir.exists(gsub("FlowDurationCurves_HERweighted_meanJm6Jj/","Tab_ChroniquesProba_LearnBrut_ByHer/",fold_)))){
    dir.create(gsub("FlowDurationCurves_HERweighted_meanJm6Jj/","Tab_ChroniquesProba_LearnBrut_ByHer/",fold_))}
  
  write.table(chroniqueFDCbyHERweighted_final_, paste0(gsub("FlowDurationCurves_HERweighted_meanJm6Jj/","Tab_ChroniquesProba_LearnBrut_ByHer/",fold_),
                                                       "/Tab_ChroniquesProba_LearnBrut_ByHer.txt"), sep=";", row.name=F, quote=F)
}

# Arreter le cluster doParallel
stopCluster(cl)
