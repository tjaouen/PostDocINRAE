### Import ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")

source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_ProjectionSurFDCApprise_3.R")

folder_input_ = folder_input_param_
obsSim_ = obsSim_param_
nom_categorieSimu_ = nom_categorieSimu_param_
nom_GCM_ = nom_GCM_param_

### Librairies ###
library(doParallel)
library(strex)

files_FDC_ref_ = list.files(paste0(folder_input_,
                                   "FlowDurationCurves/",
                                   ifelse(obsSim_=="","",paste0("FDC_",obsSim_,"/")),
                                   ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),
                                   ifelse(nom_GCM_=="","",nom_GCM_)), full.names = T)




for (f_ in 1:length(files_FDC_ref_)){
  
  tab_FDC_ref_ = read.table(files_FDC_ref_[f_], sep = ";", dec = ".", header = T)
  
  # 365*(2019-1976+1)+365*(2005-1976+1)+365*(96)
  dim(tab_FDC_ref_)
  
  # Convertir la colonne "Date" en format Date
  tab_FDC_ref_sample_ <- tab_FDC_ref_
  
  # Définir l'ordre personnalisé
  tab_FDC_ref_sample_ <- tab_FDC_ref_sample_[order(tab_FDC_ref_sample_$FreqNonDep),]
  sampled_data <- tab_FDC_ref_sample_[seq(1, nrow(tab_FDC_ref_sample_), length.out = 10000), ]
  
  custom_order <- c("Safran", "Historical", "rcp26", "rcp45", "rcp85")
  sampled_data$Type <- factor(sampled_data$Type, levels = custom_order)
  sampled_data <- sampled_data[order(sampled_data$Type, sampled_data$Date), ]
  # sampled_data <- sampled_data[order(sampled_data$Type,sampled_data$Date),]
  
  if (!dir.exists(paste0(folder_input_,
                         "FlowDurationCurves_Sampled10000/",
                         ifelse(obsSim_=="","",paste0("FDC_",obsSim_,"/")),
                         ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),
                         ifelse(nom_GCM_=="","",nom_GCM_)))){
    dir.create(paste0(folder_input_,
                      "FlowDurationCurves_Sampled10000/",
                      ifelse(obsSim_=="","",paste0("FDC_",obsSim_,"/")),
                      ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),
                      ifelse(nom_GCM_=="","",nom_GCM_)))
  }

  write.table(sampled_data,paste0(folder_input_,
                                  "FlowDurationCurves_Sampled10000/",
                                  ifelse(obsSim_=="","",paste0("FDC_",obsSim_,"/")),
                                  ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),"/",
                                  ifelse(nom_GCM_=="","",nom_GCM_),"/",
                                  basename(files_FDC_ref_[f_])),
              sep = ";", dec = ".", row.names = F, quote = F)
}

