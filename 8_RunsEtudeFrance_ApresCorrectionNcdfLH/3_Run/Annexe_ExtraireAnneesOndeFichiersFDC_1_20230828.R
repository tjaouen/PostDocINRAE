### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")




# folder_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/FlowDurationCurves/Present/FDC_ObsReanalyseSafranJusqua2022_ProjEnsuite/DebitsComp_ParModHydro_NetcdfMerged_From19760801_To21001231/debit_Rhone-Loire_CNRM-CERFACS-CNRM-CM5_historical-rcp85_r1i1p1_CNRM-ALADIN63_v2_ADAMONT-France_INRAE-J2000_day_20060101-21001231/"
# folder_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/FlowDurationCurves/Present/FDC_ObsReanalyseSafranJusqua2022_ProjEnsuite/DebitsComp_ParModHydro_NetcdfMerged_From19760801_To21001231/debit_Rhone-Loire_ICHEC-EC-EARTH_historical-rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v1_ADAMONT-France_INRAE-J2000_day_20060101-21001231/"
# folder_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/FlowDurationCurves/Present/FDC_ObsReanalyseSafranJusqua2022_ProjEnsuite/DebitsComp_ParModHydro_NetcdfMerged_From19760801_To21001231/debit_Rhone-Loire_MOHC-HadGEM2-ES_historical-rcp85_r1i1p1_CLMcom-CCLM4-8-17_v1_ADAMONT-France_INRAE-J2000_day_20060101-20991231/"
# folder_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/FlowDurationCurves/Present/FDC_ObsReanalyseSafranJusqua2022_ProjEnsuite/DebitsComp_ParModHydro_NetcdfMerged_From19760801_To21001231/debit_Rhone-Loire_MOHC-HadGEM2-ES_historical-rcp85_r1i1p1_CNRM-ALADIN63_v1_ADAMONT-France_INRAE-J2000_day_20060101-20991231/"

if (!(dir.exists(paste0(folder_, "ExtraitAnneesOnde20102023/")))){
  dir.create(paste0(folder_, "ExtraitAnneesOnde20102023/"))
}

for (f in list.files(folder_,full.names = T)[grepl(".txt", list.files(folder_,full.names = T))]){
  df <- read.table(f, sep = ";", dec = ".", header = T)
  df <- df[which((as.Date(as.character(df$Date), format = "%Y%m%d") >= as.Date("2010-01-01")) & (as.Date(as.character(df$Date), format = "%Y%m%d") <= "2023-12-31")),]
  write.table(df,paste0(dirname(f),"/ExtraitAnneesOnde20102023/",basename(f)), sep = ";", dec = ".", row.names = F, quote = F)
}


