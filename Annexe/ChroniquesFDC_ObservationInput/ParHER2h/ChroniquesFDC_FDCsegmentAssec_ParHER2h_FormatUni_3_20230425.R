### Libraries ###
library(ggplot2)
library(ggrepel)
library(viridis)
library(purrr)
library(gridExtra)
library(cowplot)

### HER 2 ###
HER2_ = 120
year = 2012:2022
#56
#76

for (HER2_ in HER_param_){

  ### Freq j- et j+, assecs ###
  file_input_HER2_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/1_PresentMesures_HERh_TsKGE_PremierRun_2012_2022_20230417/MatInputModel_ByHERDates__2012_2022_KGESUp0.00_DispSup-1_Obs_Weight.csv"
  tab_input_HER2_ = read.table(file_input_HER2_, sep = ";", dec = ".", header = T)
  #tab_input_HER2_$Date = as.Date(tab_input_HER2_$Date, format = "%d-%m-%Y")
  tab_input_HER2_$Date = as.Date(tab_input_HER2_$Date, format = "%Y-%m-%d")
  
  if (length(which(tab_input_HER2_$HER2 == HER2_)) > 0){
    
    tab_input_HER2_ = tab_input_HER2_[which(tab_input_HER2_$HER2 == HER2_),]
    tab_inShape_ = data.frame(Date = tab_input_HER2_$Date,
                              Assec = tab_input_HER2_$X._Assec,
                              Freq_moins = rowMeans(tab_input_HER2_[,c("Freq_jmoins5","Freq_jmoins4","Freq_jmoins3","Freq_jmoins2","Freq_jmoins1")]),
                              Freq_plus = rowMeans(tab_input_HER2_[,c("Freq_jplus5","Freq_jplus4","Freq_jplus3","Freq_jplus2","Freq_jplus1","Freq_j")]),
                              Annee = lubridate::year(tab_input_HER2_$Date),
                              Mois = lubridate::month(tab_input_HER2_$Date))
    
    # Créer une liste avec tous les mois à vérifier
    mois_a_verifier <- c(5,6,7,8,9)
    
    # Créer un data frame vide pour stocker les résultats
    df_resultat <- data.frame()
    
    # Pour chaque année
    for (annee in year) {
      
      # Obtenir les mois présents pour l'année courante
      mois_present <- unique(tab_inShape_$Mois[tab_inShape_$Annee == annee])
      
      # Vérifier s'il manque des mois à l'année courante
      mois_manquant <- setdiff(mois_a_verifier, mois_present)
      
      # Si des mois manquent, créer une ligne avec NA dans les autres colonnes
      if (length(mois_manquant) > 0) {
        for (mois in mois_manquant) {
          ligne <- c(as.Date(paste(annee, mois, "25", sep="-"), origin = "1970-01-01", format = "%Y-%m-%d"), rep(NA,dim(tab_inShape_)[2]-3), annee, mois)
          df_resultat <- rbind(df_resultat, ligne)
          colnames(df_resultat) <- colnames(tab_inShape_)
        }
      }
    }
    df_resultat$Date = as.Date(df_resultat$Date)
    
    # Combiner la table d'origine avec la nouvelle table contenant les combinaisons manquantes
    tab_inShape_ <- rbind(tab_inShape_, df_resultat)
    tab_inShape_ = tab_inShape_[order(tab_inShape_$Date),]
    
    ### FDC chronologies ###
    file_ChroFDC_ = paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/3_ChroniquesAssecs_ParHer/1_PresentMesures_HERh_TsKGE_PremierRun_2012_2022_20230417/ChroFDC_ParHer_ModelResults__2012_2022_KGESUp0.00_DispSup-1_Obs_Weight_logit_kge_pondere.csv")
    tab_ChroFDC_ = read.table(file_ChroFDC_, sep = ";", dec = ".", header = T)
    tab_ChroFDC_$Date = as.Date(tab_ChroFDC_$Date, format = "%Y-%m-%d")
    dim(tab_ChroFDC_)
    
    ### Assecs chronologies ###
    file_ChroAssecs_ = paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/3_ChroniquesAssecs_ParHer/1_PresentMesures_HERh_TsKGE_PremierRun_2012_2022_20230417/ChroProbaAssecs_ParHer_ModelResults__2012_2022_KGESUp0.00_DispSup-1_Obs_Weight_logit_kge_pondere.csv")
    tab_ChroAssecs_ = read.table(file_ChroAssecs_, sep = ";", dec = ".", header = T)
    tab_ChroAssecs_$Date = as.Date(tab_ChroAssecs_$Date, format = "%Y-%m-%d")
    dim(tab_ChroAssecs_)
    
    ChroFDC_ = tab_ChroFDC_[,c("Date",paste0("H",HER2_))]
    ChroAssecs_ = tab_ChroAssecs_[,c("Date",paste0("H",HER2_))]
    ChroAssecs_[,paste0("H",HER2_)] = ChroAssecs_[,paste0("H",HER2_)]/100
    
    
    #x11()
    png(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/3_ChroniquesAssecs_ParHer/1_PresentMesures_HERh_TsKGE_PremierRun_2012_2022_20230417/Graphes/ChroFDCProbaAssecs_ModelResults_2012_2022_HERh",HER2_),
        width = 1200, height = 750,
        units = "px", pointsize = 12)
    p <- ggplot(ChroFDC_, aes(x = as.Date(Date), y = !!sym(paste0("H", HER2_)))) +
      geom_line(size = 0.2, color = "#31a354") +
      geom_line(data = ChroAssecs_, aes(x = as.Date(Date), y = !!sym(paste0("H", HER2_))+1), size = 0.2, color = "#e34a33") +
      
      geom_point(data = tab_inShape_, aes(x = as.Date(Date), y = Assec/100+1), size = 3, color = "#e34a33") +
      geom_point(data = tab_inShape_, aes(x = as.Date(Date), y = Freq_moins), size = 3, color = "#31a354") +
      
      geom_point(data = tab_inShape_[which(is.na(tab_inShape_$Assec)),], aes(x = as.Date(Date), y = 0), size = 3, color = "black") +
      geom_point(data = tab_inShape_[which(is.na(tab_inShape_$Assec)),], aes(x = as.Date(Date), y = 1), size = 3, color = "black") +
      
      labs(title = paste0("FDC de 2012 à 2022 et probabilité d'écoulement dans l'HER ", HER2_),
           x = "Date", y = "FDC") +
      ylim(0, max(1.5,1.1+max(na.omit(tab_inShape_$Assec))/100)) +
      scale_x_date(limits = as.Date(c("2012-01-01", "2022-12-31")), date_labels = "%Y") +
      theme_bw()
    print(p)
    dev.off()
    
  }

}
