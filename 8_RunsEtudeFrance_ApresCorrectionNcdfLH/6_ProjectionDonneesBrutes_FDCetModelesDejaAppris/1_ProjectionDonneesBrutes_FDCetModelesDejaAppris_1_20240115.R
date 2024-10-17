




source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
folder_input_ = folder_input_param_
obsSim_ = obsSim_param_
nom_categorieSimu_ = nom_categorieSimu_param_
nom_GCM_ = nom_GCM_param_


### FDC prise en reference ###
files_FDC_ref_ = list.files(paste0(folder_input_,
                                   "FlowDurationCurves/",
                                   ifelse(obsSim_=="","",paste0("FDC_",obsSim_,"/")),
                                   ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),
                                   ifelse(nom_GCM_=="","",nom_GCM_)), full.names = T)


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
                                       "/ChroniquesBrutes_historical/"), full.names = T)

for (ind_folder_ in 1:length(folder_a_projeter_)){
  files_a_projeter_ = list.files(paste0(folder_a_projeter_[ind_files_], "/"), full.names = T)
  
  for (ind_file_ in 1:length(files_a_projeter_)){
    tab_debit_aProjeter_ = read.table(files_a_projeter_[ind_file_], sep = ";", dec = ".", header = T)
    
    ind_ref_ = which(grepl(pattern = paste0("FDC_",basename(files_a_projeter_[ind_file_])), x = files_FDC_ref_))
    tab_FDC_ref_ = read.table(files_FDC_ref_[ind_ref_], sep = ";", dec = ".", header = T)
    
  }
  
}



# Fonction pour trouver l'indice du débit le plus proche
find_nearest_debit_index <- function(debit, debits) {
  nearest_index <- which.min(abs(debits - debit))
  return(nearest_index)
}

# Ajouter la colonne FreqNonDep à tab_debit_aProjeter_
tab_debit_aProjeter_$FreqNonDep <- sapply(seq_len(nrow(tab_debit_aProjeter_)), function(i) {
  nearest_index <- find_nearest_debit_index(tab_debit_aProjeter_$Qm3s1[i], tab_FDC_ref_$Debit)
  return(tab_FDC_ref_$FreqNonDep[nearest_index])
})

write.table(tab_debit_aProjeter_, "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/FlowDurationCurves/FDC_Projections/",
            str_before_first(nom_categorieSimu_,"/"),
            "/ChroniquesBrutes_historical/",
            "Modele_",str_after_first(nom_categorieSimu_,"/"),"CNRM-CM5_CNRM-ALADIN63/",
            basename(files_a_projeter_[ind_file_]), sep = ";", dec = ".")


