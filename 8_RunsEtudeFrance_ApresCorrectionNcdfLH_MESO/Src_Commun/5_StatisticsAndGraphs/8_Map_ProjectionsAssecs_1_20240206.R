source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_18_SaveRds_ChoseDensityMin_Pdf_20231211.R")


library(strex)


# list_tables_ = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_20231221/GRSD_20231128/ChroniquesBrutes_rcp85/ModA_FaFa/Tables/",
list_tables_ = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/Tables/",
                          full.names = T)

tab_generale_ = data.frame()
for (l in list_tables_){
  tab_ = read.table(l, sep = ";", dec = ".", header = T)
  tab_$HER2 = as.numeric(str_before_first(str_after_last(l,"HER"),"_"))
  if (nrow(tab_generale_) == 0){
    tab_generale_ = tab_
  }else{
    tab_generale_ = rbind(tab_generale_, tab_)
  }
}

tab_generale_dates_ = tab_generale_[which(tab_generale_$Jour_annee >= "2022-05-01" &  tab_generale_$Jour_annee <= "2022-09-30"),]
tab_generale_dates_ = tab_generale_dates_[which(!is.na(tab_generale_dates_$Median_Value)),]

median_median_value <- aggregate(tab_generale_dates_$Median_Value, by = list(HER2 = tab_generale_dates_$HER2), FUN = median)
median_median_value <- aggregate(. ~ HER2, data = tab_generale_dates_, FUN = median)

median_median_value <- aggregate(Median_Value ~ HER2 + Color + Alpha + Legend + AfficherDansLegende, data = tab_generale_dates_, FUN = median)


median_median_value_A_ = median_median_value[which(median_median_value$Legend == "Modéré en réchauffement et\nchangement de précipitations"),]
median_median_value_B_ = median_median_value[which(median_median_value$Legend == "Sec toute l'année,\nrecharge moindre en hiver"),]
median_median_value_C_ = median_median_value[which(median_median_value$Legend == "Fort réchauffement et\nfort assèchement en été"),]
median_median_value_D_ = median_median_value[which(median_median_value$Legend == "Chaud et humide\nà toutes les saisons"),]

source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_18_SaveRds_ChoseDensityMin_Pdf_20231211.R")

output_name_ <- paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_20231221/GRSD_20231128/ChroniquesBrutes_rcp85/ModA_FaFa/Map/MapProbaMediane_ModA_sansEtiq.pdf")
plot_map_variable_sansEtiquettes(tab_ = median_median_value_A_,
                                 varname_ = "Median_Value",
                                 vartitle_ = "Median proba 2070-2100 Mod Modéré en réchauffement et changement de précipitations",
                                 breaks_ = c(0,10,20,30,40,50,60,70,80,90,100),
                                 output_name_ = output_name_,
                                 title_ = paste0("Median proba 2070-2100 Mod A"),
                                 nomPalette_ = "misc_div_disc.txt",
                                 reverseColors_ = F,
                                 sansTexteHer_ = T,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = F,
                                 # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                 HER2_excluesDensity_ = NULL)

output_name_ <- paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_20231221/GRSD_20231128/ChroniquesBrutes_rcp85/ModA_FaFa/Map/MapProbaMediane_ModB_sansEtiq.pdf")
plot_map_variable_sansEtiquettes(tab_ = median_median_value_B_,
                                 varname_ = "Median_Value",
                                 vartitle_ = "Median proba 2070-2100 Mod A",
                                 breaks_ = c(0,10,20,30,40,50,60,70,80,90,100),
                                 output_name_ = output_name_,
                                 title_ = paste0("Sec toute l'année, recharge moindre en hiver"),
                                 nomPalette_ = "misc_div_disc.txt",
                                 reverseColors_ = F,
                                 sansTexteHer_ = T,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = F,
                                 # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                 HER2_excluesDensity_ = NULL)

output_name_ <- paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_20231221/GRSD_20231128/ChroniquesBrutes_rcp85/ModA_FaFa/Map/MapProbaMediane_ModC_sansEtiq.pdf")
plot_map_variable_sansEtiquettes(tab_ = median_median_value_C_,
                                 varname_ = "Median_Value",
                                 vartitle_ = "Median proba 2070-2100 Mod A",
                                 breaks_ = c(0,10,20,30,40,50,60,70,80,90,100),
                                 output_name_ = output_name_,
                                 title_ = paste0("Fort réchauffement et fort assèchement en été"),
                                 nomPalette_ = "misc_div_disc.txt",
                                 reverseColors_ = F,
                                 sansTexteHer_ = T,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = F,
                                 # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                 HER2_excluesDensity_ = NULL)

# output_name_ <- paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_20231221/GRSD_20231128/ChroniquesBrutes_rcp85/ModA_FaFa/Map/MapProbaMediane_ModD_sansEtiq.pdf")
output_name_ <- paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/Map/MapProbaMediane_sansEtiq.pdf")
plot_map_variable_sansEtiquettes(tab_ = median_median_value_D_,
                                 varname_ = "Median_Value",
                                 vartitle_ = "Median proba 2070-2100 Mod A",
                                 breaks_ = c(0,10,20,30,40,50,60,70,80,90,100),
                                 output_name_ = output_name_,
                                 title_ = paste0("Median proba 2070-2100 Mod Chaud et humide à toutes les saisons"),
                                 nomPalette_ = "misc_div_disc.txt",
                                 reverseColors_ = F,
                                 sansTexteHer_ = T,
                                 reverseLegend_ = T,
                                 echelleAttenuee_ = F,
                                 # HER2_excluesDensity_ = HER2_excluesDensity_bin_)
                                 HER2_excluesDensity_ = NULL)



# "Modéré en réchauffement et\nchangement de précipitations"
# "Sec toute l'année,\nrecharge moindre en hiver"
