### Import ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_ProjectionSurFDCApprise.R")

source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run3.R")

folder_input_ = folder_input_param_
obsSim_ = obsSim_param_
nom_categorieSimu_ = nom_categorieSimu_param_
nom_GCM_ = nom_GCM_param_

### Librairies ###
library(doParallel)
library(strex)

# typeSequence_ = "historical"
typeSequence_ = "rcp85"
# typeSequence_ = "rcp45"
# typeSequence_ = "rcp26"

### Fonction pour trouver l'indice du débit le plus proche ###
find_nearest_debit_index <- function(debit, debits) {
  nearest_index <- which.min(abs(debits - debit))
  return(nearest_index)
}

ajouterMajuscule <- function(mot) {
  # Convertir le premier caractère en majuscule
  mot <- paste(toupper(substr(mot, 1, 1)), substr(mot, 2, nchar(mot)), sep = "")
  return(mot)
}

### Run ###
cl <- makePSOCKcluster(detectCores()/2-1)
# cl <- makePSOCKcluster(detectCores() - 4)
# cl <- makePSOCKcluster(6)
registerDoParallel(cores=cl)

### FDC prise en reference ###
files_FDC_ref_ = list.files(paste0(folder_input_DD_param_,
                                   "FlowDurationCurves_Sampled10000/",
                                   ifelse(obsSim_=="","",paste0("FDC_",obsSim_,"/")),
                                   ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),
                                   ifelse(nom_GCM_=="","",nom_GCM_)), full.names = T)


if(grepl("CERFACS.*ALADIN63",nom_GCM_)){
  model_folder_name_ = "ModA_FaFa"
}
if(grepl("EC-EARTH.*HadREM",nom_GCM_)){
  model_folder_name_ = "ModB_ChSc"
}
if(grepl("HadGEM.*CCLM",nom_GCM_)){
  model_folder_name_ = "ModC_ChCnt"
}
if(grepl("HadGEM.*ALADIN63",nom_GCM_)){
  model_folder_name_ = "ModD_ChHm"
}

# tab_FDC_ref_ = read.table(files_FDC_ref_[1], sep = ";", dec = ".", header = T)
# head(tab_FDC_ref_)
# 
# ind_folder_ = 1
# ind_file_ = 1
# tab_debit_aProjeter_ = read.table(files_a_projeter_[ind_file_], sep = ";", dec = ".", header = T)
# head(tab_debit_aProjeter_)


### Debit a projeter ###
folder_a_projeter_ = list.files(paste0("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/",
                                       str_before_first(nom_categorieSimu_,"/"),
                                       "/ChroniquesBrutes_",typeSequence_,"/"), full.names = T)
# folder_a_projeter_ = folder_a_projeter_[c(1)]
# folder_a_projeter_ = folder_a_projeter_[c(2:length(folder_a_projeter_))]
# folder_a_projeter_ = folder_a_projeter_[17]
# folder_a_projeter_ = folder_a_projeter_[17:length(folder_a_projeter_)]
# folder_a_projeter_ = folder_a_projeter_[c(4:5,9)]
# folder_a_projeter_ = folder_a_projeter_[7:34]
# folder_a_projeter_ = folder_a_projeter_[c(1:8,11,12,15,16)]
# folder_a_projeter_ = folder_a_projeter_[c(10,13,14)]

# for (ind_folder_ in 1:1){
# for (folder_ in folder_a_projeter_){
output <- foreach(folder_ = folder_a_projeter_) %dopar% { #, errorhandling='pass'
  
  files_a_projeter_ = list.files(paste0(folder_, "/"), full.names = T)
  
  # for (ind_file_ in 1:5){
  # for (ind_file_ in 1:199){
  for (ind_file_ in 1:length(files_a_projeter_)){
  # for (ind_file_ in 830:length(files_a_projeter_)){
    # for (ind_file_ in 6:length(files_a_projeter_)){
    tab_debit_aProjeter_ = read.table(files_a_projeter_[ind_file_], sep = ";", dec = ".", header = T)
    
    ind_ref_ = which(grepl(pattern = paste0("FDC_",basename(files_a_projeter_[ind_file_])), x = files_FDC_ref_))
    tab_FDC_ref_ = read.table(files_FDC_ref_[ind_ref_], sep = ";", dec = ".", header = T)
    
    # Ajouter la colonne FreqNonDep à tab_debit_aProjeter_
    tab_debit_aProjeter_$FreqNonDep <- sapply(seq_len(nrow(tab_debit_aProjeter_)), function(i) {
      nearest_index <- find_nearest_debit_index(tab_debit_aProjeter_$Qm3s1[i], tab_FDC_ref_$Debit)
      return(tab_FDC_ref_$FreqNonDep[nearest_index])
    })
    
    tab_debit_aProjeter_$Date = format(as.Date(tab_debit_aProjeter_$Date),"%Y%m%d")
    tab_debit_aProjeter_$Type = ajouterMajuscule(typeSequence_)
    colnames(tab_debit_aProjeter_) = c("Date","Debit","FreqNonDep","Type")
    tab_debit_aProjeter_ <- tab_debit_aProjeter_[, c("Date", "FreqNonDep", "Debit", "Type")]
    
    if (!dir.exists(paste0("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/FlowDurationCurves/FDC_Projections/",
                           str_before_first(nom_categorieSimu_,"/"),
                           "/ChroniquesBrutes_",typeSequence_,"/",
                           model_folder_name_,"/"))){
      dir.create(paste0("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/FlowDurationCurves/FDC_Projections/",
                        str_before_first(nom_categorieSimu_,"/"),
                        "/ChroniquesBrutes_",typeSequence_,"/",
                        model_folder_name_,"/"))
    }
    
    if (!dir.exists(paste0("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/FlowDurationCurves/FDC_Projections/",
                           str_before_first(nom_categorieSimu_,"/"),
                           "/ChroniquesBrutes_",typeSequence_,"/",
                           model_folder_name_,"/",
                           str_after_last(folder_,"/")))){
      dir.create(paste0("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/FlowDurationCurves/FDC_Projections/",
                        str_before_first(nom_categorieSimu_,"/"),
                        "/ChroniquesBrutes_",typeSequence_,"/",
                        model_folder_name_,"/",
                        str_after_last(folder_,"/")))
    }
    
    write.table(tab_debit_aProjeter_,
                paste0("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/FlowDurationCurves/FDC_Projections/",
                       str_before_first(nom_categorieSimu_,"/"),
                       "/ChroniquesBrutes_",typeSequence_,"/",
                       model_folder_name_,"/",
                       str_after_last(folder_,"/"),"/",
                       "FDC_",basename(files_a_projeter_[ind_file_])), sep = ";", dec = ".", row.names = F, quote = F)
    
  }
  
  return(folder_)
  
}

# Arreter le cluster doParallel
stopCluster(cl)


# "debit_France_CNRM-CERFACS-CNRM-CM5_historical_r1i1p1_CNRM-ALADIN63_v3_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_19520801-20050731"
# "debit_France_CNRM-CERFACS-CNRM-CM5_historical_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_19520801-20050731"
# "debit_France_CNRM-CERFACS-CNRM-CM5_historical_r1i1p1_MOHC-HadREM3-GA7-05_v3_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_19530801-20050731"
# "debit_France_CNRM-CERFACS-CNRM-CM5_historical_r1i1p1_MOHC-HadREM3-GA7-05_v3_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_19530801-20050731"
# "debit_France_ICHEC-EC-EARTH_historical_r12i1p1_KNMI-RACMO22E_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_19510801-20050731"
# "debit_France_ICHEC-EC-EARTH_historical_r12i1p1_KNMI-RACMO22E_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_19510801-20050731"
# "debit_France_ICHEC-EC-EARTH_historical_r12i1p1_MOHC-HadREM3-GA7-05_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_19530801-20050731"
# "debit_France_ICHEC-EC-EARTH_historical_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_19530801-20050731"
# "debit_France_ICHEC-EC-EARTH_historical_r12i1p1_SMHI-RCA4_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_19710801-20050731"
# "debit_France_ICHEC-EC-EARTH_historical_r12i1p1_SMHI-RCA4_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_19710801-20050731"
# "debit_France_IPSL-IPSL-CM5A-MR_historical_r1i1p1_DMI-HIRHAM5_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_19520801-20050731"
# "debit_France_IPSL-IPSL-CM5A-MR_historical_r1i1p1_DMI-HIRHAM5_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_19520801-20050731"
# "debit_France_IPSL-IPSL-CM5A-MR_historical_r1i1p1_SMHI-RCA4_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_19710801-20050731"
# "debit_France_IPSL-IPSL-CM5A-MR_historical_r1i1p1_SMHI-RCA4_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_19710801-20050731"
# "debit_France_MOHC-HadGEM2-ES_historical_r1i1p1_CLMcom-CCLM4-8-17_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_19510801-20050731"
# "debit_France_MOHC-HadGEM2-ES_historical_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_19510801-20050731"
# "debit_France_MOHC-HadGEM2-ES_historical_r1i1p1_CNRM-ALADIN63_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_19510801-20050731"
# "debit_France_MOHC-HadGEM2-ES_historical_r1i1p1_CNRM-ALADIN63_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_19510801-20050731"
# "debit_France_MOHC-HadGEM2-ES_historical_r1i1p1_ICTP-RegCM4-6_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_19720801-20050731"
# "debit_France_MOHC-HadGEM2-ES_historical_r1i1p1_ICTP-RegCM4-6_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_19720801-20050731"
# "debit_France_MOHC-HadGEM2-ES_historical_r1i1p1_MOHC-HadREM3-GA7-05_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_19530801-20050731"
# "debit_France_MOHC-HadGEM2-ES_historical_r1i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_19530801-20050731"
# "debit_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_CLMcom-CCLM4-8-17_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_19510801-20050731"
# "debit_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_19510801-20050731"
# "debit_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_ICTP-RegCM4-6_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_19710801-20050731"
# "debit_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_ICTP-RegCM4-6_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_19710801-20050731"
# "debit_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_MPI-CSC-REMO2009_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_19510801-20050731"
# "debit_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_MPI-CSC-REMO2009_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_19510801-20050731"
# "debit_France_NCC-NorESM1-M_historical_r1i1p1_DMI-HIRHAM5_v4_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_19520801-20050731"
# "debit_France_NCC-NorESM1-M_historical_r1i1p1_DMI-HIRHAM5_v4_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_19520801-20050731"
# "debit_France_NCC-NorESM1-M_historical_r1i1p1_GERICS-REMO2015_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_19510801-20050731"
# "debit_France_NCC-NorESM1-M_historical_r1i1p1_GERICS-REMO2015_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_19510801-20050731"
# "debit_France_NCC-NorESM1-M_historical_r1i1p1_IPSL-WRF381P_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_19520801-20050731"
# "debit_France_NCC-NorESM1-M_historical_r1i1p1_IPSL-WRF381P_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_19520801-20050731"



