source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/4_Validation/11_Func_Relation_AvecCC_ValidationSansLearn_Globale_14_20230816.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_19_Pattern_20231212.R")

### Libraries ###
library(strex)
library(ggplot2)
library(ggrepel)  # Pour les étiquettes avec geom_text_repel
library(lubridate)

graph_ = 4

### Study data ###
folder_output_ = folder_output_param_
nomSim_ = nomSim_param_
HER_ = HER_param_
jourMin_ = jourMin_param_
jourMax_ = jourMax_param_
regr = "logit"
HER_variable_ = HER_variable_param_

nom_categorieSimu_ = nom_categorieSimu_param_
nom_GCM_ = nom_GCM_param_
nom_apprentissage_ = nom_apprentissage_param_
nom_validation_ = nom_validation_param_
annees_inputMatrice_ = annees_inputMatrice_param_

### Input model ###
# liste <- c(list.files(paste0(folder_output_,"1_MatricesInputModeles_ParHERDates/",nomSim_), pattern="MatInputModel", full.names = T))
# il = liste[1]

### Table predictions - Leave One Year Out ###
files_ <- list.files(paste0(folder_output_,
                            "2_ResultatsModeles_ParHer/",
                            nomSim_,
                            ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                            ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                            # ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                            # ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                            "/ApprentissageGlobalModelesBruts/"), pattern = "logit",
                     full.names = T)
tab_ = read.table(files_, sep = ";", dec = ".", header = T)

### Input data ###
files_input_ <- list.files(paste0(folder_output_,
                                  "1_MatricesInputModeles_ParHERDates/",
                                  nomSim_,
                                  ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                  ifelse(nom_GCM_=="","",paste0("/",nom_GCM_))), pattern = "MatInputModel_CampOndeExcl_ByHERDates_",
                           full.names = T)
tab_input_ = read.table(files_input_, sep = ";", dec = ".", header = T)

### Observed ###
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunObs20122019.R")
tab_res_obs_ = read.table(list.files(paste0(folder_output_param_,
                                            "2_ResultatsModeles_ParHer/",
                                            nomSim_param_,
                                            ifelse(nom_categorieSimu_param_=="","",paste0("/",nom_categorieSimu_param_)),
                                            ifelse(nom_GCM_param_=="","",paste0("/",nom_GCM_param_)),
                                            ifelse(nom_apprentissage_param_=="","",paste0("/",nom_apprentissage_param_))),
                                     # ifelse(nom_validation_param_=="","",paste0("/",nom_validation_param_))),
                                     pattern = "logit", full.names = T),
                          dec = ".", sep = ";", header = T)


### Results KGE ###
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R") # OK avec un seul run
files_results_ <- list.files(paste0(folder_output_,
                                    "2_ResultatsModeles_ParHer/",
                                    nomSim_,
                                    ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_, "/")))),
                             pattern = "logit", recursive = T, full.names = T)
tab_res_saf_ = read.table(files_results_[grepl("SafranSeulCplt",files_results_)], sep = ";", dec = ".", header = T)

if (graph_ == 1){
  tab_res_CERFACS_ALADIN63_saf_hist_rcp85_ = read.table(files_results_[grepl("saf_hist_.*CERFACS.*ALADIN",files_results_)], sep = ";", dec = ".", header = T)
  tab_res_CERFACS_ALADIN63_saf_rcp85_ = read.table(files_results_[grepl("saf_rcp85.*CERFACS.*ALADIN",files_results_)], sep = ";", dec = ".", header = T)
}else if (graph_ == 2){
  tab_res_ECearth_HadREM3_saf_hist_rcp85_ = read.table(files_results_[grepl("saf_hist_.*EC-EARTH.*HadREM3",files_results_)], sep = ";", dec = ".", header = T)
  tab_res_ECearth_HadREM3_saf_rcp85_ = read.table(files_results_[grepl("saf_rcp85.*EC-EARTH.*HadREM3",files_results_)], sep = ";", dec = ".", header = T)
}else if (graph_ == 3){
  tab_res_HadGEM2_CCLM4_saf_hist_rcp85_ = read.table(files_results_[grepl("saf_hist_.*HadGEM2.*CCLM4",files_results_)], sep = ";", dec = ".", header = T)
  tab_res_HadGEM2_CCLM4_saf_rcp85_ = read.table(files_results_[grepl("saf_rcp85.*HadGEM2.*CCLM4",files_results_)], sep = ";", dec = ".", header = T)
}else if (graph_ == 4){
  tab_res_HadGEM2_ALADIN63_saf_hist_rcp85_ = read.table(files_results_[grepl("saf_hist_.*HadGEM2.*ALADIN",files_results_)], sep = ";", dec = ".", header = T)
  tab_res_HadGEM2_ALADIN63_saf_rcp85_ = read.table(files_results_[grepl("saf_rcp85.*HadGEM2.*ALADIN",files_results_)], sep = ";", dec = ".", header = T)
}



for (i in HER_){
  
  # tab_r_ <- tab_[which(tab_$HER == i),c('Inter_logit_Learn','Slope_logit_Learn')]
  tab_i_ <- tab_input_[which(tab_input_$HER == i),c('Date','X._Assec','Freq_Jm6Jj')]
  
  tab_res_obs_i_ <- tab_res_obs_[which(tab_res_obs_$HER == i),c('Inter_logit_Learn','Slope_logit_Learn')]
  tab_res_saf_i_ <- tab_res_saf_[which(tab_res_saf_$HER == i),c('Inter_logit_Learn','Slope_logit_Learn')]

  if (graph_ == 1){
    tab_res_CERFACS_ALADIN63_saf_hist_rcp85_i_ <- tab_res_CERFACS_ALADIN63_saf_hist_rcp85_[which(tab_res_CERFACS_ALADIN63_saf_hist_rcp85_$HER == i),c('Inter_logit_Learn','Slope_logit_Learn')]
    tab_res_CERFACS_ALADIN63_saf_rcp85_i_ <- tab_res_CERFACS_ALADIN63_saf_rcp85_[which(tab_res_CERFACS_ALADIN63_saf_rcp85_$HER == i),c('Inter_logit_Learn','Slope_logit_Learn')]
  }else if (graph_ == 2){
    tab_res_ECearth_HadREM3_saf_hist_rcp85_i_ <- tab_res_ECearth_HadREM3_saf_hist_rcp85_[which(tab_res_ECearth_HadREM3_saf_hist_rcp85_$HER == i),c('Inter_logit_Learn','Slope_logit_Learn')]
    tab_res_ECearth_HadREM3_saf_rcp85_i_ <- tab_res_ECearth_HadREM3_saf_rcp85_[which(tab_res_ECearth_HadREM3_saf_rcp85_$HER == i),c('Inter_logit_Learn','Slope_logit_Learn')]
  }else if (graph_ == 3){
    tab_res_HadGEM2_CCLM4_saf_hist_rcp85_i_ <- tab_res_HadGEM2_CCLM4_saf_hist_rcp85_[which(tab_res_HadGEM2_CCLM4_saf_hist_rcp85_$HER == i),c('Inter_logit_Learn','Slope_logit_Learn')]
    tab_res_HadGEM2_CCLM4_saf_rcp85_i_ <- tab_res_HadGEM2_CCLM4_saf_rcp85_[which(tab_res_HadGEM2_CCLM4_saf_rcp85_$HER == i),c('Inter_logit_Learn','Slope_logit_Learn')]
  }else if (graph_ == 4){
    tab_res_HadGEM2_ALADIN63_saf_hist_rcp85_i_ <- tab_res_HadGEM2_ALADIN63_saf_hist_rcp85_[which(tab_res_HadGEM2_ALADIN63_saf_hist_rcp85_$HER == i),c('Inter_logit_Learn','Slope_logit_Learn')]
    tab_res_HadGEM2_ALADIN63_saf_rcp85_i_ <- tab_res_HadGEM2_ALADIN63_saf_rcp85_[which(tab_res_HadGEM2_ALADIN63_saf_rcp85_$HER == i),c('Inter_logit_Learn','Slope_logit_Learn')]
  }
  
  
  if (nrow(tab_i_) > 0){
    # palette_file_ = read("/home/tjaouen/Documents/Input/FondsCartes/IpccColors/sequence_beigeBleu_personnelle_div_disc.txt",sep=" ")
    
    print(length(unique(year(as.Date(tab_i_$Date)))))
    palette_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = "/home/tjaouen/Documents/Input/FondsCartes/IpccColors/", nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", size_ = length(unique(year(as.Date(tab_i_$Date)))))
    color_mapping <- setNames(palette_[1:length(unique(year(as.Date(tab_i_$Date))))], unique(year(as.Date(tab_i_$Date))))
    
    # Création d'un dataframe factice pour la courbe de régression
    # data_regression <- data.frame(
    #   X._Assec = seq(min(tab_i_$X._Assec), max(tab_i_$X._Assec), length.out = 100)
    # )
    
    # data_regression <- data.frame(
    #   Freq_Jm6Jj = seq(min(tab_i_$Freq_Jm6Jj), max(tab_i_$Freq_Jm6Jj), length.out = 100)
    # )
    data_regression <- data.frame(
      Freq_Jm6Jj = seq(0,1, length.out = 100)
    )
    data_regression$X._Assec_Model_Observed__Data_Observed_20122019 <- exp(tab_res_obs_i_$Inter_logit_Learn + tab_res_obs_i_$Slope_logit_Learn * data_regression$Freq_Jm6Jj)/(1+exp(tab_res_obs_i_$Inter_logit_Learn + tab_res_obs_i_$Slope_logit_Learn * data_regression$Freq_Jm6Jj))*100
    data_regression$X._Assec_Model_SafranSeul__Data_Safran_20122019 <- exp(tab_res_saf_i_$Inter_logit_Learn + tab_res_saf_i_$Slope_logit_Learn * data_regression$Freq_Jm6Jj)/(1+exp(tab_res_saf_i_$Inter_logit_Learn + tab_res_saf_i_$Slope_logit_Learn * data_regression$Freq_Jm6Jj))*100
    
    if (graph_ == 1){
      data_regression$X._Assec_Model_CERFACS_ALADIN63_saf_hist_rcp85__Data_Safran_20122019 <- exp(tab_res_CERFACS_ALADIN63_saf_hist_rcp85_i_$Inter_logit_Learn + tab_res_CERFACS_ALADIN63_saf_hist_rcp85_i_$Slope_logit_Learn * data_regression$Freq_Jm6Jj)/(1+exp(tab_res_CERFACS_ALADIN63_saf_hist_rcp85_i_$Inter_logit_Learn + tab_res_CERFACS_ALADIN63_saf_hist_rcp85_i_$Slope_logit_Learn * data_regression$Freq_Jm6Jj))*100
      data_regression$X._Assec_Model_CERFACS_ALADIN63_saf_rcp85__Data_Safran_20122019 <- exp(tab_res_CERFACS_ALADIN63_saf_rcp85_i_$Inter_logit_Learn + tab_res_CERFACS_ALADIN63_saf_rcp85_i_$Slope_logit_Learn * data_regression$Freq_Jm6Jj)/(1+exp(tab_res_CERFACS_ALADIN63_saf_rcp85_i_$Inter_logit_Learn + tab_res_CERFACS_ALADIN63_saf_rcp85_i_$Slope_logit_Learn * data_regression$Freq_Jm6Jj))*100
      
      custom_colors <- c("Model_Observed__Data_Observed_20122019" = "#2ca25f",
                         "Model_SafranSeul__Data_Safran_20122019" = "#2b8cbe",
                         "Model_CERFACS_ALADIN63_saf_hist_rcp85__Data_Safran_20122019" = "#f1eef6",
                         "Model_CERFACS_ALADIN63_saf_rcp85__Data_Safran_20122019" = "#fee5d9")
      desired_order <- c("Model_Observed__Data_Observed_20122019",
                         "Model_SafranSeul__Data_Safran_20122019",
                         "Model_CERFACS_ALADIN63_saf_hist_rcp85__Data_Safran_20122019",
                         "Model_CERFACS_ALADIN63_saf_rcp85__Data_Safran_20122019")
      labels_ <- c(paste0("Model: Observed - Data: Observed - 2012/2019 - KGE: ", tab_res_obs_$KGE_logit_Learn[which(tab_res_obs_$HER == HER_h_)]),
                   paste0("Model: Safran seul - Data: Safran - 2012/2019 - KGE: ", tab_res_saf_$KGE_logit_Learn[which(tab_res_saf_$HER == HER_h_)]),
                   paste0("Model: CERFACS_ALADIN63_saf_hist_rcp85 - Data: Safran - 2012/2019 - KGE: ", tab_res_CERFACS_ALADIN63_saf_hist_rcp85_$KGE_logit_Learn[which(tab_res_CERFACS_ALADIN63_saf_hist_rcp85_$HER == HER_h_)]),
                   paste0("Model: CERFACS_ALADIN63_saf_rcp85 - Data: Safran - 2012/2019 - KGE: ", tab_res_CERFACS_ALADIN63_saf_rcp85_$KGE_logit_Learn[which(tab_res_CERFACS_ALADIN63_saf_rcp85_$HER == HER_h_)]))
      
    }else if (graph_ == 2){
      data_regression$X._Assec_Model_ECearth_HadREM3_saf_hist_rcp85__Data_Safran_20122019 <- exp(tab_res_ECearth_HadREM3_saf_hist_rcp85_i_$Inter_logit_Learn + tab_res_ECearth_HadREM3_saf_hist_rcp85_i_$Slope_logit_Learn * data_regression$Freq_Jm6Jj)/(1+exp(tab_res_ECearth_HadREM3_saf_hist_rcp85_i_$Inter_logit_Learn + tab_res_ECearth_HadREM3_saf_hist_rcp85_i_$Slope_logit_Learn * data_regression$Freq_Jm6Jj))*100
      data_regression$X._Assec_Model_ECearth_HadREM3_saf_rcp85__Data_Safran_20122019 <- exp(tab_res_ECearth_HadREM3_saf_rcp85_i_$Inter_logit_Learn + tab_res_ECearth_HadREM3_saf_rcp85_i_$Slope_logit_Learn * data_regression$Freq_Jm6Jj)/(1+exp(tab_res_ECearth_HadREM3_saf_rcp85_i_$Inter_logit_Learn + tab_res_ECearth_HadREM3_saf_rcp85_i_$Slope_logit_Learn * data_regression$Freq_Jm6Jj))*100
      
      custom_colors <- c("Model_Observed__Data_Observed_20122019" = "#2ca25f",
                         "Model_SafranSeul__Data_Safran_20122019" = "#2b8cbe",
                         "Model_ECearth_HadREM3_saf_hist_rcp85__Data_Safran_20122019" = "#c994c7",
                         "Model_ECearth_HadREM3_saf_rcp85__Data_Safran_20122019" = "#fc9272")
      desired_order <- c("Model_Observed__Data_Observed_20122019",
                         "Model_SafranSeul__Data_Safran_20122019",
                         "Model_ECearth_HadREM3_saf_hist_rcp85__Data_Safran_20122019",
                         "Model_ECearth_HadREM3_saf_rcp85__Data_Safran_20122019")
      labels_ <- c(paste0("Model: Observed - Data: Observed - 2012/2019 - KGE: ", tab_res_obs_$KGE_logit_Learn[which(tab_res_obs_$HER == HER_h_)]),
                   paste0("Model: Safran seul - Data: Safran - 2012/2019 - KGE: ", tab_res_saf_$KGE_logit_Learn[which(tab_res_saf_$HER == HER_h_)]),
                   paste0("Model: ECearth_HadREM3_saf_hist_rcp85 - Data: Safran - 2012/2019 - KGE: ", tab_res_ECearth_HadREM3_saf_hist_rcp85_$KGE_logit_Learn[which(tab_res_ECearth_HadREM3_saf_hist_rcp85_$HER == HER_h_)]),
                   paste0("Model: ECearth_HadREM3_saf_rcp85 - Data: Safran - 2012/2019 - KGE: ", tab_res_ECearth_HadREM3_saf_rcp85_$KGE_logit_Learn[which(tab_res_ECearth_HadREM3_saf_rcp85_$HER == HER_h_)]))
      
    }else if (graph_ == 3){
      data_regression$X._Assec_Model_HadGEM2_CCLM4_saf_hist_rcp85__Data_Safran_20122019 <- exp(tab_res_HadGEM2_CCLM4_saf_hist_rcp85_i_$Inter_logit_Learn + tab_res_HadGEM2_CCLM4_saf_hist_rcp85_i_$Slope_logit_Learn * data_regression$Freq_Jm6Jj)/(1+exp(tab_res_HadGEM2_CCLM4_saf_hist_rcp85_i_$Inter_logit_Learn + tab_res_HadGEM2_CCLM4_saf_hist_rcp85_i_$Slope_logit_Learn * data_regression$Freq_Jm6Jj))*100
      data_regression$X._Assec_Model_HadGEM2_CCLM4_saf_rcp85__Data_Safran_20122019 <- exp(tab_res_HadGEM2_CCLM4_saf_rcp85_i_$Inter_logit_Learn + tab_res_HadGEM2_CCLM4_saf_rcp85_i_$Slope_logit_Learn * data_regression$Freq_Jm6Jj)/(1+exp(tab_res_HadGEM2_CCLM4_saf_rcp85_i_$Inter_logit_Learn + tab_res_HadGEM2_CCLM4_saf_rcp85_i_$Slope_logit_Learn * data_regression$Freq_Jm6Jj))*100
      
      custom_colors <- c("Model_Observed__Data_Observed_20122019" = "#2ca25f",
                         "Model_SafranSeul__Data_Safran_20122019" = "#2b8cbe",
                         "Model_HadGEM2_CCLM4_saf_hist_rcp85__Data_Safran_20122019" = "#e7298a",
                         "Model_HadGEM2_CCLM4_saf_rcp85__Data_Safran_20122019" = "#fb6a4a")
      desired_order <- c("Model_Observed__Data_Observed_20122019",
                         "Model_SafranSeul__Data_Safran_20122019",
                         "Model_HadGEM2_CCLM4_saf_hist_rcp85__Data_Safran_20122019",
                         "Model_HadGEM2_CCLM4_saf_rcp85__Data_Safran_20122019")
      labels_ <- c(paste0("Model: Observed - Data: Observed - 2012/2019 - KGE: ", tab_res_obs_$KGE_logit_Learn[which(tab_res_obs_$HER == HER_h_)]),
                   paste0("Model: Safran seul - Data: Safran - 2012/2019 - KGE: ", tab_res_saf_$KGE_logit_Learn[which(tab_res_saf_$HER == HER_h_)]),
                   paste0("Model: HadGEM2_CCLM4_saf_hist_rcp85 - Data: Safran - 2012/2019 - KGE: ", tab_res_HadGEM2_CCLM4_saf_hist_rcp85_$KGE_logit_Learn[which(tab_res_HadGEM2_CCLM4_saf_hist_rcp85_$HER == HER_h_)]),
                   paste0("Model: HadGEM2_CCLM4_saf_rcp85 - Data: Safran - 2012/2019 - KGE: ", tab_res_HadGEM2_CCLM4_saf_rcp85_$KGE_logit_Learn[which(tab_res_HadGEM2_CCLM4_saf_rcp85_$HER == HER_h_)]))
      
    }else if (graph_ == 4){
      data_regression$X._Assec_Model_HadGEM2_ALADIN63_saf_hist_rcp85__Data_Safran_20122019 <- exp(tab_res_HadGEM2_ALADIN63_saf_hist_rcp85_i_$Inter_logit_Learn + tab_res_HadGEM2_ALADIN63_saf_hist_rcp85_i_$Slope_logit_Learn * data_regression$Freq_Jm6Jj)/(1+exp(tab_res_HadGEM2_ALADIN63_saf_hist_rcp85_i_$Inter_logit_Learn + tab_res_HadGEM2_ALADIN63_saf_hist_rcp85_i_$Slope_logit_Learn * data_regression$Freq_Jm6Jj))*100
      data_regression$X._Assec_Model_HadGEM2_ALADIN63_saf_rcp85__Data_Safran_20122019 <- exp(tab_res_HadGEM2_ALADIN63_saf_rcp85_i_$Inter_logit_Learn + tab_res_HadGEM2_ALADIN63_saf_rcp85_i_$Slope_logit_Learn * data_regression$Freq_Jm6Jj)/(1+exp(tab_res_HadGEM2_ALADIN63_saf_rcp85_i_$Inter_logit_Learn + tab_res_HadGEM2_ALADIN63_saf_rcp85_i_$Slope_logit_Learn * data_regression$Freq_Jm6Jj))*100
      
      custom_colors <- c("Model_Observed__Data_Observed_20122019" = "#2ca25f",
                         "Model_SafranSeul__Data_Safran_20122019" = "#2b8cbe",
                         "Model_HadGEM2_ALADIN63_saf_hist_rcp85__Data_Safran_20122019" = "#ce1256",
                         "Model_HadGEM2_ALADIN63_saf_rcp85__Data_Safran_20122019" = "#cb181d")
      desired_order <- c("Model_Observed__Data_Observed_20122019",
                         "Model_SafranSeul__Data_Safran_20122019",
                         "Model_HadGEM2_ALADIN63_saf_hist_rcp85__Data_Safran_20122019",
                         "Model_HadGEM2_ALADIN63_saf_rcp85__Data_Safran_20122019")
      labels_ <- c(paste0("Model: Observed - Data: Observed - 2012/2019 - KGE: ", tab_res_obs_$KGE_logit_Learn[which(tab_res_obs_$HER == HER_h_)]),
                   paste0("Model: Safran seul - Data: Safran - 2012/2019 - KGE: ", tab_res_saf_$KGE_logit_Learn[which(tab_res_saf_$HER == HER_h_)]),
                   paste0("Model: HadGEM2_ALADIN63_saf_hist_rcp85 - Data: Safran - 2012/2019 - KGE: ", tab_res_HadGEM2_ALADIN63_saf_hist_rcp85_$KGE_logit_Learn[which(tab_res_HadGEM2_ALADIN63_saf_hist_rcp85_$HER == HER_h_)]),
                   paste0("Model: HadGEM2_ALADIN63_saf_rcp85 - Data: Safran - 2012/2019 - KGE: ", tab_res_HadGEM2_ALADIN63_saf_rcp85_$KGE_logit_Learn[which(tab_res_HadGEM2_ALADIN63_saf_rcp85_$HER == HER_h_)]))
      
    }
    
    reformed_data <- gather(data_regression, key = "Modele", value = "X._Assec", -Freq_Jm6Jj)
    reformed_data <- reformed_data %>%
      mutate(Modele = sub("X._Assec_", "", Modele))
    
    
    reformed_data$Modele <- factor(reformed_data$Modele, levels = desired_order)
    
    
    # x11()
    p <- ggplot(reformed_data, aes(x = Freq_Jm6Jj*100, y = X._Assec, color = Modele, group = Modele)) +
      xlim(0, 100) +
      ylim(0, 100) +
      geom_line() +
      labs(x = "FDC (%)", y = "Drying probabilty (%)", title = paste0("Logistic regressions - Hydrological model: ",str_before_first(nom_categorieSimu_,"_")," - HER: ",i)) +
      scale_color_manual(name = "Model",
                         values = custom_colors,
                         labels_ <- labels_)+
      theme_minimal() +
      theme(strip.text.x = element_blank(),
            strip.background = element_blank(),
            text = element_text(size = 18),  # Modifier la taille du texte global du graphique
            axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
            legend.position = "bottom",
            legend.box = "horizontal",
            legend.direction = "horizontal") +
      guides(color = guide_legend(ncol = 2, override.aes = list(lwd=2.5)))
    p
    
    pdf(paste0(folder_output_,
               "11_Graphes_CalageModele_FDCAssecs_ParHER/",
               nomSim_,
               ifelse(nom_categorieSimu_=="","",paste0("/",str_before_first(nom_categorieSimu_,"/"))),
               # ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
               "/ApprentissageGlobalModelesBruts/GraphesSepares/CalibrageModele_HER",i,"_",graph_,".pdf"),
        width = 18)
    print(p)
    dev.off()
  }
}





