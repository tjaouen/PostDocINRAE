### Libraries ###
library(ggplot2)
library(ggrepel)
library(viridis)
library(purrr)
library(gridExtra)
library(cowplot)

### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/4_RunsEtudeFrance_20230417/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/4_RunsEtudeFrance_20230417/2_Run/7_Func_Relation_AvecCC_4_20230414.R")

### Study data ###
folder_input_ = folder_input_param_
folder_output_ = folder_output_param_
#nomSim_ = "5_PresentMesures_HERh_TsKGE_CorrectionPonderations_2012_2022_20230413"
#nomSim_ = "6_PresentMesures_HERh_TsKGE_CorrectionIntervallesJours_2012_2022_20230414"
#nomSim_ = "7_PresentMesures_HERh_TsKGE_ImpactHumainNulOuFaible_2012_2022_20230417"
#nomSim_ = "1_PresentMesures_HERh_TsKGE_TtesStat_2012_2022_20230417"
#nomSim_ = "7_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_2012_2022_20230505"
nomSim_ = nomSim_param_
HER_ = HER_param_

### File ###
#file_input_ = paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeRMC/1_MatricesInputModeles_ParHERDates/6_PresentMesures_HERh_TsKGE_CorrectionIntervallesJours_2012_2022_20230414/MatInputModel_ByHERDates__2012_2022_KGESUp0.00_DispSup-1_Obs_Weight.csv")
#file_input_ = paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeRMC/1_MatricesInputModeles_ParHERDates/",nomSim_,"/MatInputModel_ByHERDates__2012_2022_KGESUp0.00_DispSup-1_Obs_Weight.csv")
#file_input_ = paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeRMC/1_MatricesInputModeles_ParHERDates/",nomSim_,"/MatInputModel_ByHERDates__2012_2022_KGESUp0.00_DispSup-1_ImpactNulFaible_Obs_Weight.csv")
#file_input_ = paste0(folder_output_,"1_MatricesInputModeles_ParHERDates/",nomSim_,"/MatInputModel_ByHERDates__2012_2022_KGESUp0.00_DispSup-1_Obs_Weight_AllStations.csv")
#file_input_ = paste0(folder_output_,"1_MatricesInputModeles_ParHERDates/",nomSim_,"/MatInputModel_ByHERDates__2012_2022_KGESUp0.00_DispSup-1_Obs_Weight_AllStations_TestPoisson.csv")
file_input_ = paste0(folder_output_,"1_MatricesInputModeles_ParHERDates/",nomSim_,"/MatInputModel_ByHERDates__2012_2022_KGESUp0.00_DispSup-1_Obs_Weight.csv")
tab_input_ = read.table(file_input_, sep = ",", dec = ".", header = T)
if (dim(tab_input_)[2] == 1){
  tab_input_ = read.table(file_input_, sep = ";", dec = ".", header = T)
}


for (HER2_ in unique(tab_input_$HER2)){
  
  #HER2_ = 37
  
  ### Assec ~ Freq ###
  tab_input_HER2_ = tab_input_[which(tab_input_$HER2 == HER2_),]
  tab_input_HER2_ = tab_input_HER2_[which(tab_input_HER2_$NbOutputONDE > round(0.75*mean(tab_input_HER2_$NbOutputONDE))),]
  
  tab_inShape_ = data.frame(Date = tab_input_HER2_$Date,
                            Assec = tab_input_HER2_$X._Assec,
                            Freq_moins = rowMeans(tab_input_HER2_[,c("Freq_jmoins5","Freq_jmoins4","Freq_jmoins3","Freq_jmoins2","Freq_jmoins1")]),
                            Freq_plus = rowMeans(tab_input_HER2_[,c("Freq_jplus5","Freq_jplus4","Freq_jplus3","Freq_jplus2","Freq_jplus1","Freq_j")]))
  
  
  ### Model ###
  #file_results_ = paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeRMC/2_ResultatsModeles_ParHer/",nomSim_,"/ModelResults__2012_2022_KGESUp0.00_DispSup-1_Obs_Weight_logit_kge_save.csv")
  #file_results_ = paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeRMC/2_ResultatsModeles_ParHer/",nomSim_,"/ModelResults__2012_2022_KGESUp0.00_DispSup-1_Obs_Weight_logit_kge.csv")
  #file_results_ = paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeRMC/2_ResultatsModeles_ParHer/",nomSim_,"/ModelResults__2012_2022_KGESUp0.00_DispSup-1_ImpactNulFaible_Obs_Weight_logit_kge.csv")
  #file_results_ = paste0(folder_output_,"2_ResultatsModeles_ParHer/",nomSim_,"/ModelResults__2012_2022_KGESUp0.00_DispSup-1_Obs_Weight_AllStations_logit_kge.csv")
  file_results_ = paste0(folder_output_,"2_ResultatsModeles_ParHer/",nomSim_,"/ModelResults__2012_2022_KGESUp0.00_DispSup-1_Obs_Weight_logit_kge.csv")
  tab_results_ = read.table(file_results_, sep = ";", dec = ".", header = T)
  Reg = tab_results_[which(tab_results_$HER == HER2_),c("Inter_logit","Slope_logit")]
  tab_inShape_$A_FreqMoins_ = exp(Reg$Slope_logit*tab_inShape_$Freq_moins+Reg$Inter_logit)/(1+exp(Reg$Slope_logit*tab_inShape_$Freq_moins+Reg$Inter_logit))*100
  
  ### Graphe FDC / Assecs ###
  #x11()
  png(paste0(folder_output_,"11_Graphes_CalageModele_FDCAssecs/",nomSim_,"/CalageModele_FDCAssecs_FDCplus_HERh",HER2_,"_Sim",substr(nomSim_,1,1),"_1_20230421.png"),
      width = 1200, height = 750,
      units = "px", pointsize = 12)
  
  p <- ggplot(tab_inShape_, aes(x = Freq_moins, y = Assec, color = as.factor(format(as.Date(Date, format = "%Y-%m-%d"), "%Y")))) +
    geom_point(size = 3) +
    geom_line(data = tab_inShape_, aes(x = Freq_moins, y = A_FreqMoins_), color = "black") +
    scale_color_viridis_d(name = "Année") +
    theme_minimal() +
    xlim(0,1) +
    ylim(0,100) +
    theme(axis.text = element_text(size = 14),
          axis.title = element_text(size = 16)) +
    labs(x = "Fréquence moyenne de non dépassement", y = "Pourcentage d'assecs") +
    geom_text_repel(aes(label = format(as.Date(Date),"%m-%Y")), size = 4, force = 5,  # réduction de la valeur de "force"
                    nudge_x = 0.05, nudge_y = 0.05)  # réduction des valeurs de "nudge_x" et "nudge_y"
  print(p)
  dev.off()
  
}



# tab_inShape_$A_FreqPlus_ = exp(Reg$Slope_logit*tab_inShape_$Freq_plus+Reg$Inter_logit)/(1+exp(Reg$Slope_logit*tab_inShape_$Freq_plus+Reg$Inter_logit))*100

# #x11()
# png(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeRMC/11_Graphes_CalageModele_FDCAssecs/",nomSim_,"/CalageModele_FDCAssecs_FDCplus_HERh",HER2_,"_Sim",substr(nomSim_,1,1),"_1_20230421.png"),
#     width = 1200, height = 750,
#     units = "px", pointsize = 12)
# # x11()
# ggplot(tab_inShape_, aes(x = Freq_plus, y = Assec, color = as.factor(format(as.Date(Date, format = "%d-%m-%Y"), "%Y")))) +
#   geom_point(size = 3) +
#   geom_line(data = tab_inShape_, aes(x = Freq_plus, y = A_FreqPlus_), color = "black") +
#   scale_color_viridis_d(name = "Année") +
#   theme_minimal() +
#   xlim(0,1) +
#   theme(axis.text = element_text(size = 14),
#         axis.title = element_text(size = 16)) +
#   labs(x = "Fréquence moyenne de non dépassement", y = "Pourcentage d'assecs") +
#   geom_text_repel(aes(label = format(as.Date(Date),"%m-%Y")), size = 4, force = 5,  # réduction de la valeur de "force"
#                   nudge_x = 0.05, nudge_y = 0.05)  # réduction des valeurs de "nudge_x" et "nudge_y"
# dev.off()







