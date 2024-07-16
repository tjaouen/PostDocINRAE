source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunGraphe_Obs.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunObs20122019.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/4_Validation/11_Func_Relation_AvecCC_ValidationSansLearn_Globale_14_20230816.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_19_Pattern_20231212.R")

### Libraries ###
library(strex)
library(ggplot2)
library(ggrepel)  # Pour les étiquettes avec geom_text_repel
library(lubridate)

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
if (ncol(tab_input_)){
  tab_input_ = read.table(files_input_, sep = ",", dec = ".", header = T)
}


for (i in HER_){
  
  tab_r_ <- tab_[which(tab_$HER == i),c('Inter_logit_Learn','Slope_logit_Learn')]
  tab_i_ <- tab_input_[which(tab_input_$HER == i),c('Date','X._Assec','Freq_jmoins6','Freq_jmoins5','Freq_jmoins4','Freq_jmoins3','Freq_jmoins2','Freq_jmoins1','Freq_j')]
  tab_i_$Freq_Jm6Jj <- rowMeans(tab_i_[,c("Freq_jmoins6","Freq_jmoins5","Freq_jmoins4","Freq_jmoins3","Freq_jmoins2","Freq_jmoins1","Freq_j")])
  
  if (nrow(tab_i_) > 0){
    # palette_file_ = read("/home/tjaouen/Documents/Input/FondsCartes/IpccColors/sequence_beigeBleu_personnelle_div_disc.txt",sep=" ")
    
    print(length(unique(year(as.Date(tab_i_$Date)))))
    palette_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = "/home/tjaouen/Documents/Input/FondsCartes/IpccColors/", nomPalette_ = "sequence_beigeBleu_personnelle_div_disc.txt", size_ = length(unique(year(as.Date(tab_i_$Date)))))
    color_mapping <- setNames(palette_[1:length(unique(year(as.Date(tab_i_$Date))))], unique(year(as.Date(tab_i_$Date))))
    
    # Création d'un dataframe factice pour la courbe de régression
    # data_regression <- data.frame(
    #   X._Assec = seq(min(tab_i_$X._Assec), max(tab_i_$X._Assec), length.out = 100)
    # )
    
    data_regression <- data.frame(
      Freq_Jm6Jj = seq(min(tab_i_$Freq_Jm6Jj), max(tab_i_$Freq_Jm6Jj), length.out = 100)
    )
    data_regression$X._Assec <- exp(tab_r_$Inter_logit_Learn + tab_r_$Slope_logit_Learn * data_regression$Freq_Jm6Jj)/(1+exp(tab_r_$Inter_logit_Learn + tab_r_$Slope_logit_Learn * data_regression$Freq_Jm6Jj))*100
    
    
    # Tracer la courbe de régression et les points de tab_input_
    p <- ggplot() +
      xlim(0, 100) +
      ylim(0, 100) +
      geom_line(data = data_regression, aes(x = Freq_Jm6Jj*100, y = X._Assec), color = "blue") +
      geom_point(data = tab_i_, aes(x = Freq_Jm6Jj*100, y = X._Assec, color = as.factor(year(as.Date(Date))))) +
      scale_color_manual(name = "Year", values = color_mapping) + # Remplacez les couleurs par celles de votre choix
      geom_text_repel(
        data = tab_i_,
        aes(x = Freq_Jm6Jj*100, y = X._Assec, label = format(as.Date(Date), "%m-%Y")),
        box.padding = unit(0.35, "lines"),
        point.padding = unit(0.3, "lines")
      ) +
      labs(x = "FDC (%)", y = "Drying probabilty (%)", title = paste0("Régression logistique - HER ",i)) +
      theme_minimal() + 
      theme(
        text = element_text(size = 18)  # Modifier la taille du texte global du graphique
      )
    
    pdf(paste0(folder_output_,
               "11_Graphes_CalageModele_FDCAssecs_ParHER/",
               nomSim_,
               ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
               ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
               "/ApprentissageGlobalModelesBruts/CalibrageModele_HER",i,".pdf"),
        width = 18)
    print(p)
    dev.off()
  }
}





