source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunObs20122019.R")

### Libraries ###
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

### Chroniques ###
chroniqueFDCbyHERweighted_ <- read.table(paste0(folder_input_,"FlowDurationCurves_HERweighted_meanJm6Jj/",
                                                ifelse(obsSim_=="",nom_GCM_,
                                                       paste0("FDC_",obsSim_,
                                                              ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                              ifelse(nom_categorieSimu_param_=="","",str_before_first(nom_categorieSimu_param_,"/")),"/",
                                                              # "ChroniquesCombinees_saf_hist_rcp85/",
                                                              ifelse(nom_GCM_=="","",nom_GCM_))), #,"/ExtraitAnneesOnde20102023/"
                                                "/Tab_FDCchroniquesByHER2weigthedFDC.txt"), sep=";", header = T)

chroniqueFDCbyHERweighted_obs_ <- chroniqueFDCbyHERweighted_[which(chroniqueFDCbyHERweighted_$Type == "Observes"),]
dim(chroniqueFDCbyHERweighted_obs_) # 3910

chroniqueFDCbyHERweighted_obs_[, !colnames(chroniqueFDCbyHERweighted_obs_) %in% c("Date", "Type")]
colnames(chroniqueFDCbyHERweighted_obs_)[!colnames(chroniqueFDCbyHERweighted_obs_) %in% c("Date", "Type")] <- gsub("X", "", colnames(chroniqueFDCbyHERweighted_obs_)[!colnames(chroniqueFDCbyHERweighted_obs_) %in% c("Date", "Type")])

### Table Modele ###
tab_modeles_ = read.table(list.files(paste0(folder_output_,
                                            "2_ResultatsModeles_ParHer/",
                                            nomSim_,
                                            ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                            ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                                            ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                                            ifelse(nom_validation_=="","",paste0("/",nom_validation_))),
                                     pattern = "logit", full.names = T),
                          dec = ".", sep = ";", header = T)

### Probability ###
for (i in colnames(chroniqueFDCbyHERweighted_obs_)[3:length(chroniqueFDCbyHERweighted_obs_)]){
  tab_modeles_HER_ <- tab_modeles_[which(tab_modeles_$HER == as.numeric(i)),]
  chroniqueFDCbyHERweighted_obs_[[as.character(i)]] = (exp(tab_modeles_HER_$Inter_logit_Learn+chroniqueFDCbyHERweighted_obs_[[as.character(i)]]*tab_modeles_HER_$Slope_logit_Learn)/
                                                          (1+exp(tab_modeles_HER_$Inter_logit_Learn+chroniqueFDCbyHERweighted_obs_[[as.character(i)]]*tab_modeles_HER_$Slope_logit_Learn)))*100
}

if (!(dir.exists(paste0(folder_input_,"Tab_ChroniquesProba_LearnBrut_ByHer/",
                        ifelse(obsSim_=="",nom_GCM_,
                               paste0("FDC_",obsSim_,
                                      ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                      ifelse(nom_categorieSimu_=="","",str_before_first(nom_categorieSimu_,"/")),"/",
                                      ifelse(nom_categorieSimu_=="","",paste0("Mod_",str_after_first(nom_categorieSimu_,"/"))),"/",
                                      ifelse(nom_GCM_=="","",paste0("Mod_",nom_GCM_)),"/")))))){
  dir.create(paste0(folder_input_,"Tab_ChroniquesProba_LearnBrut_ByHer/",
                    ifelse(obsSim_=="",nom_GCM_,
                           paste0("FDC_",obsSim_,
                                  ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                  ifelse(nom_categorieSimu_=="","",str_before_first(nom_categorieSimu_,"/")),"/",
                                  ifelse(nom_categorieSimu_=="","",paste0("Mod_",str_after_first(nom_categorieSimu_,"/"))),"/",
                                  ifelse(nom_GCM_=="","",paste0("Mod_",nom_GCM_)),"/"))))}

write.table(chroniqueFDCbyHERweighted_obs_, paste0(folder_input_,"Tab_ChroniquesProba_LearnBrut_ByHer/",
                                               ifelse(obsSim_=="",nom_GCM_,
                                                      paste0("FDC_",obsSim_,
                                                             ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                             ifelse(nom_categorieSimu_=="","",str_before_first(nom_categorieSimu_,"/")),"/",
                                                             ifelse(nom_categorieSimu_=="","",paste0("Mod_",str_after_first(nom_categorieSimu_,"/"))),"/",
                                                             ifelse(nom_GCM_=="","",paste0("Mod_",nom_GCM_)))), #,"/ExtraitAnneesOnde20102023/"
                                               "/Tab_ChroniquesProba_LearnBrut_ByHer.txt"), sep=";", row.name=F, quote=F)


