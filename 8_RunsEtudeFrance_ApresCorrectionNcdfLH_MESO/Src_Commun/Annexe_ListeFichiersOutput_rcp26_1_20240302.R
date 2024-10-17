library(strex)

control_files <- function(list_files){
  list_files_str_ = str_before_first(str_after_first(list_files, "Weight_"),".csv")
  combined_data <- expand.grid(Year = 2012:2022, HER_param = HER_param_)
  
  # Utiliser paste0 pour combiner les éléments
  combined_strings <- paste0(combined_data$Year, "_HER", combined_data$HER_param)
  combined_strings[which(!(combined_strings %in% list_files_str_))]
}



# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26/", full.names = T) # OK 77
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26/", full.names = T) # OK 77
list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/J2000_20231128/ChroniquesCombinees_saf_hist_rcp26/", full.names = T) # OK 55
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26/", full.names = T) # 77
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26/", full.names = T)
for (l in 1:length(list_)){
  print(l)
  print(list_[l])
  print(dim(read.table(list.files(list_[l], full.names = T)[1], sep = ";", dec = ".", header = T)))
  print(dim(read.table(list.files(list_[l], full.names = T)[length(list.files(list_[l], full.names = T))], sep = ";", dec = ".", header = T)))
  # tab_ = read.table(paste0(list_[l],"/Tab_FDCchroniquesByHER2weigthedFDC.txt"), sep = ";", dec = ".", header = T)
  # print(dim(tab_))
}


# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26/", full.names = T) # OK 77
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26/", full.names = T) # OK 77
list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp26/", full.names = T) # OK 55
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26/", full.names = T) # 77
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26/", full.names = T)
for (l in 1:length(list_)){
  print(l)
  print(list_[l])
  print(dim(read.table(list.files(list_[l], full.names = T)[1], sep = ";", dec = ".", header = T)))
  print(dim(read.table(list.files(list_[l], full.names = T)[length(list.files(list_[l], full.names = T))], sep = ";", dec = ".", header = T)))
  # tab_ = read.table(paste0(list_[l],"/Tab_FDCchroniquesByHER2weigthedFDC.txt"), sep = ";", dec = ".", header = T)
  # print(dim(tab_))
}


# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves_meanJm6Jj/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26/", full.names = T) # OK 77
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves_meanJm6Jj/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26/", full.names = T) # OK 77
list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves_meanJm6Jj/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp26/", full.names = T) # OK 55
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves_meanJm6Jj/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26/", full.names = T) # 77
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves_meanJm6Jj/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26/", full.names = T)
for (l in 1:length(list_)){
  print(l)
  print(list_[l])
  print(dim(read.table(list.files(list_[l], full.names = T)[1], sep = ";", dec = ".", header = T)))
  print(dim(read.table(list.files(list_[l], full.names = T)[length(list.files(list_[l], full.names = T))], sep = ";", dec = ".", header = T)))
  # tab_ = read.table(paste0(list_[l],"/Tab_FDCchroniquesByHER2weigthedFDC.txt"), sep = ";", dec = ".", header = T)
  # print(dim(tab_))
}


# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves_HERweighted_meanJm6Jj/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26/", full.names = T) # OK 77
list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves_HERweighted_meanJm6Jj/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26/", full.names = T) # OK 77
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves_HERweighted_meanJm6Jj/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp26/", full.names = T) # OK 55
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves_HERweighted_meanJm6Jj/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26/", full.names = T) # 77
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves_HERweighted_meanJm6Jj/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26/", full.names = T)
for (l in 1:length(list_)){
  print(l)
  print(list_[l])
  print(dim(read.table(list.files(list_[l], full.names = T)[1], sep = ";", dec = ".", header = T)))
  print(dim(read.table(list.files(list_[l], full.names = T)[length(list.files(list_[l], full.names = T))], sep = ";", dec = ".", header = T)))
  # tab_ = read.table(paste0(list_[l],"/Tab_FDCchroniquesByHER2weigthedFDC.txt"), sep = ";", dec = ".", header = T)
  # print(dim(tab_))
}


# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProba_LearnBrut_ByHer/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26/", full.names = T) # OK 77
list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProba_LearnBrut_ByHer/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26/", full.names = T) # OK 77
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProba_LearnBrut_ByHer/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp26/", full.names = T) # OK 55
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProba_LearnBrut_ByHer/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26/", full.names = T) # 77
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProba_LearnBrut_ByHer/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26/", full.names = T)
for (l in 1:length(list_)){
  print(l)
  print(list_[l])
  print(dim(read.table(list.files(list_[l], full.names = T)[1], sep = ";", dec = ".", header = T)))
  # print(dim(read.table(list.files(list_[l], full.names = T)[length(list.files(list_[l], full.names = T))], sep = ";", dec = ".", header = T)))
  # tab_ = read.table(paste0(list_[l],"/Tab_FDCchroniquesByHER2weigthedFDC.txt"), sep = ";", dec = ".", header = T)
  # print(dim(tab_))
}



list_ = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26/Map/", full.names = T) # OK 77
for (l in HER_[which(!(HER_ %in% c(10,18,19,20)))]){
  if (sum(grepl(paste0("_HER",l,"_"), list_)) != 2){
    print(l)
  }else{
    print(paste0("HER ",l," OK"))
  }
}
