#-------------------------------------------------------------------------------
# Calcul les frequences de non depassement pour les stations HYDRO
# Bottet Quentin - Irstea - 10/09/2019 - Version 1
#-------------------------------------------------------------------------------

### Librairies ###
library(hydroTSM)
library(rgdal)
library(lubridate)

### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/4_RunsEtudeFrance_20230417/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run3.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run4.R")

# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Option0SafranCompletSeul.R")

### Study data ###
folder_input_ = folder_input_param_
# presFut_ = presFut_param_
obsSim_ = obsSim_param_
nomSim_ = nomSim_param_
nom_GCM_ = nom_GCM_param_
date_variable_name_ = "Date"
FDC_dateBorneMin_ = FDC_dateBorneMin_param_
FDC_dateBorneMax_ = FDC_dateBorneMax_param_
# FDC_dateBorneMin_param_ = "2012-01-01"
# FDC_dateBorneMax_param_ = "2022-12-31"
nom_categorieSimu_ = nom_categorieSimu_param_


# nom_GCM_ = "debit_Rhone-Loire_CNRM-CERFACS-CNRM-CM5_historical-rcp85_r1i1p1_CNRM-ALADIN63_v2_ADAMONT-France_INRAE-J2000_day_20060101-21001231"
# nom_GCM_ = "debit_Rhone-Loire_ICHEC-EC-EARTH_historical-rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v1_ADAMONT-France_INRAE-J2000_day_20060101-21001231"
# nom_GCM_ = "debit_Rhone-Loire_MOHC-HadGEM2-ES_historical-rcp85_r1i1p1_CLMcom-CCLM4-8-17_v1_ADAMONT-France_INRAE-J2000_day_20060101-20991231"
# nom_GCM_ = "debit_Rhone-Loire_MOHC-HadGEM2-ES_historical-rcp85_r1i1p1_CNRM-ALADIN63_v1_ADAMONT-France_INRAE-J2000_day_20060101-20991231"
# nom_GCM_ = "debit_Rhone-Loire_MOHC-HadGEM2-ES_historical-rcp85_r1i1p1_CNRM-ALADIN63_v1_ADAMONT-France_INRAE-J2000_day_20060101-20991231"

# liste = list.files("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsObserves/DebitsRdata_StationsHydro_20230412/3_Reunion_TxtHorsRMC_RdataRMCetCorr/", pattern = ".txt|.Rdata", full.names = T)
# liste = list.files("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsObserves/DebitsRdata_StationsHydro_20230412/SaveTestMetadonnees/", pattern = ".txt|.Rdata", full.names = T)
# liste = list.files("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsObservesReanalyseSafranJusqua2022_ProjectionsEnsuite/DebitsComplets_DebitsParModelesHydro_NetcdfMerged/debit_Rhone-Loire_CNRM-CERFACS-CNRM-CM5_historical-rcp85_r1i1p1_CNRM-ALADIN63_v2_ADAMONT-France_INRAE-J2000_day_20060101-21001231/", pattern = ".txt|.Rdata", full.names = T)
# liste = list.files("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsObservesReanalyseSafranJusqua2022_ProjectionsEnsuite/DebitsComplets_DebitsParModelesHydro_NetcdfMerged/debit_Rhone-Loire_ICHEC-EC-EARTH_historical-rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v1_ADAMONT-France_INRAE-J2000_day_20060101-21001231/", pattern = ".txt|.Rdata", full.names = T)
# liste = list.files("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsObservesReanalyseSafranJusqua2022_ProjectionsEnsuite/DebitsComplets_DebitsParModelesHydro_NetcdfMerged/debit_Rhone-Loire_MOHC-HadGEM2-ES_historical-rcp85_r1i1p1_CLMcom-CCLM4-8-17_v1_ADAMONT-France_INRAE-J2000_day_20060101-20991231/", pattern = ".txt|.Rdata", full.names = T)
liste = list.files(paste0(folder_input_,"/Debits/Debits",
                          ifelse(obsSim_=="","",obsSim_),"/",
                          "NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/",
                          ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),"/",
                          ifelse(nom_GCM_=="","",nom_GCM_)), pattern = ".txt|.Rdata", full.names = T)
# liste <- liste[908:length(liste)]

for(i in liste){
  
  if (grepl("\\.Rdata",i)){
    tab_ = get(load(i))
    flow = data.frame(Date = tab_$Chron$Date, Qls = tab_$Chron$Qls)
    colnames(flow) <- c("Date","Debit")
    debit_variable_name_ = "Debit"
  }else{
    flow = read.table(i, header=T, sep=";")
    # flow$Qmmj[which(flow$Qmmj == -99)] = NA
    # flow$Qls[which(flow$Qls == -99)] = NA
    flow$Qm3s1[which(flow$Qm3s1 == -99)] = NA
    # debit_variable_name_ = "Qls"
    debit_variable_name_ = "Qm3s1"
  }
  
  flow$Date <- parse_date_time(flow$Date, orders = c("Ymd","dmY"))
  
  # Borner le flow entre deux dates
  if (!(is.null(FDC_dateBorneMin_param_))){
    flow <- flow[which((as.Date(flow$Date, format = "%Y-%m-%d") >= as.Date(FDC_dateBorneMin_, format = "%Y-%m-%d")) & (as.Date(flow$Date, format = "%Y-%m-%d") <= as.Date(FDC_dateBorneMax_, format = "%Y-%m-%d"))),]
  }
  fdcurve <- fdc(as.numeric((flow[, debit_variable_name_])),plot=F,lQ.thr=0.95,hQ.thr=0.2,ylab="Q [l/s]")
  
  # Creation d'un matrice avec date/debit/debit spe/% de depassement du debit -> Correction ? Creation d'un matrice avec date/frequence de non depassement/debit
  debExtract = flow[, date_variable_name_]
  debExtract = as.data.frame(cbind(Date = format(debExtract, "%Y%m%d"),
                                   FreqNonDep = 1-fdcurve,
                                   Debit = flow[, debit_variable_name_],
                                   Type = flow$Type))
  
  if (!(dir.exists(paste0(folder_input_,
                        "FlowDurationCurves/",
                        ifelse(obsSim_=="","",paste0("FDC_",obsSim_,"/")),
                        ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),
                        ifelse(nom_GCM_=="","",nom_GCM_),"/")))){
    dir.create(paste0(folder_input_,
                      "FlowDurationCurves/",
                      ifelse(obsSim_=="","",paste0("FDC_",obsSim_,"/")),
                      ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),
                      ifelse(nom_GCM_=="","",nom_GCM_),"/"))
  }
  
  if (".Rdata" %in% i){
    write.table(debExtract, paste0(folder_input_,
                                   "FlowDurationCurves/",
                                   # presFut_,"/",
                                   # ifelse(nom_GCM_=="",paste0("FDC_",obsSim_,"_",nom_FDCfolder_param_),nom_GCM_),
                                   ifelse(obsSim_=="","",paste0("FDC_",obsSim_,"/")),
                                   ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),
                                   ifelse(nom_GCM_=="","",nom_GCM_),
                                   "/FDC_",sub("\\..*", "", basename(i)),".Rdata"), sep=";", row.name=F, quote=F)
  }else{
    write.table(debExtract, paste0(folder_input_,
                                   "FlowDurationCurves/",
                                   # presFut_,"/",
                                   # ifelse(nom_GCM_=="",paste0("FDC_",obsSim_,"_",nom_FDCfolder_param_),nom_GCM_),
                                   # ifelse(nom_GCM_=="",paste0("FDC_",obsSim_,"/"),nom_GCM_),
                                   ifelse(obsSim_=="","",paste0("FDC_",obsSim_,"/")),
                                   ifelse(nom_categorieSimu_=="","",paste0(nom_categorieSimu_,"/")),
                                   ifelse(nom_GCM_=="","",nom_GCM_),
                                   "/FDC_",sub("\\..*", "", basename(i)),".txt"), sep=";", row.name=F, quote=F)
  }
}
