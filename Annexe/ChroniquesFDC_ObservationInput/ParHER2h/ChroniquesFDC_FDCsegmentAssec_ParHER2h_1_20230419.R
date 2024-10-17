### Libraries ###
library(ggplot2)
library(ggrepel)
library(viridis)
library(purrr)
library(gridExtra)
library(cowplot)


file_input_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeRMC/1_MatricesInputModeles_ParHERDates/7_PresentMesures_HERh_TsKGE_ImpactHumainNulOuFaible_2012_2022_20230417/MatInputModel_ByHERDates__2012_2022_KGESUp0.00_DispSup-1_ImpactNulFaible_Obs_Weight.csv"
tab_input_ = read.table(file_input_, sep = ",", dec = ".", header = T)
HER2_ = 76


### Assec ~ Freq ###
tab_input_HER2_ = tab_input_[which(tab_input_$HER2 == HER2_),]
tab_inShape_ = data.frame(Date = tab_input_HER2_$Date,
                          Assec = tab_input_HER2_$X._Assec,
                          Freq_moins = rowMeans(tab_input_HER2_[,c("Freq_jmoins5","Freq_jmoins4","Freq_jmoins3","Freq_jmoins2","Freq_jmoins1")]),
                          Freq_plus = rowMeans(tab_input_HER2_[,c("Freq_jplus5","Freq_jplus4","Freq_jplus3","Freq_jplus2","Freq_jplus1","Freq_j")]))

x11()
ggplot(tab_inShape_, aes(x = Freq_moins, y = Assec, color = as.factor(format(as.Date(Date, format = "%d-%m-%Y"), "%Y")))) +
  geom_point(size = 3) +
  scale_color_viridis_d() +
  theme_minimal() +
  theme(axis.text = element_text(size = 14),
        axis.title = element_text(size = 16)) +
  labs(x = "Freq", y = "Assec") +
  geom_text_repel(aes(label = Date), size = 4, force = 20,
                  nudge_x = 0.3, nudge_y = 0.3)

x11()
ggplot(tab_inShape_, aes(x = Freq_plus, y = Assec, color = as.factor(format(as.Date(Date, format = "%d-%m-%Y"), "%Y")))) +
  geom_point(size = 3) +
  scale_color_viridis_d() +
  theme_minimal() +
  theme(axis.text = element_text(size = 14),
        axis.title = element_text(size = 16)) +
  labs(x = "Freq", y = "Assec") +
  geom_text_repel(aes(label = Date), size = 4, force = 20,
                  nudge_x = 0.3, nudge_y = 0.3)


### Freq ###
#file_input_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeRMC/FlowDurationCurves_ChroniquesParHer/Present/FDCChroHer_Obs_3_PresentMesures_HERhybrides_TousKGE_2012_2022_20230407/ChroniqueFDC_KGESUp0.00_DispSup-1_Obs_HER",HER2_,".csv")
file_input_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeRMC/FlowDurationCurves_ChroniquesParHer/Present/FDCChroHer_Obs_3_PresentMesures_HERhybrides_TousKGE_2012_2022_20230407/ChroniqueFDC_KGESUp0.00_DispSup-1_Obs_HER",HER2_,".csv")
tab_input_ = read.table(file_input_, sep = ";", dec = ".", header = T)
dim(tab_input_)

tab_df_ = data.frame(Date = tab_input_$Date,
                     FDC = rowMeans(tab_input_[,2:dim(tab_input_)[2]], na.rm = T))

# Extraction des données pour chaque date
fenetre <- 6  # Fenêtre de 6 jours
tab_dates <- as.Date(tab_inShape_$Date, "%d-%m-%Y")  # Conversion des dates en format Date
tab_FDCmoins <- tab_inShape_$Freq_moins  # Conversion des dates en format Date
tab_FDCplus <- tab_inShape_$Freq_plus  # Conversion des dates en format Date
tab_Assec <- tab_inShape_$Assec/100  # Conversion des dates en format Date
n_dates <- length(tab_dates)  # Nombre de dates à tracer

# Création des groupes de données pour chaque graphe avec facet_wrap
grp <- rep(1:(ceiling(n_dates/5)), each=5)[1:n_dates]

# Création de la liste des graphes
plots_list <- map(1:n_dates, function(i) {
  date_i <- tab_dates[i]
  FDCmoins_i <- tab_FDCmoins[i]
  FDCplus_i <- tab_FDCplus[i]
  Assec_i <- tab_Assec[i]
  
  tab_df_i <- subset(tab_df_, Date >= date_i - fenetre & Date <= date_i + fenetre)
  
  # Création du graphe avec ggplot2
  p <- ggplot(tab_df_i, aes(x=as.Date(Date), y=FDC)) +
    geom_line() +
    geom_hline(yintercept = Assec_i, color = "#e34a33") +
    geom_segment(aes(x = as.Date(tab_df_i$Date[1]), xend = as.Date(tab_df_i$Date[5]),
                     y = FDCmoins_i, yend = FDCmoins_i),
                 color = "#31a354", size = 2) +
                #color = "#31a354", size = 2, linetype = "dashed") +
    geom_segment(aes(x = as.Date(tab_df_i$Date[6]), xend = as.Date(tab_df_i$Date[11]),
                     y = FDCplus_i, yend = FDCplus_i),
                 color = "#3182bd", size = 2) +
                #color = "#3182bd", size = 2, linetype = "dashed") +
    #geom_hline(yintercept = FDCplus_i, color =  "#3182bd", size = 2, linetype = "dashed") +
    #geom_vline(xintercept = as.numeric(date_i), linetype = "dashed") +
    ylim(0,1) +
    labs(title = paste("FDC autour de la date", format(date_i, "%d/%m/%Y"))) +
    theme_bw()
  
  return(p)
})

# Affichage des graphes
# x11()
# plots_grid <- reduce(plots_list, "+")  # Assemblage des graphes en grille
# print(plots_grid)
# 
# plot_grid(plotlist = plots_list, ncol = 5)
# grid.arrange(plots_list, ncol=5)



n_plots <- length(plots_list)
n_cols <- 5
n_rows <- ceiling(n_plots/n_cols)

# Afficher les graphes sur plusieurs fenêtres avec 5 graphes par ligne
for (i in seq(1, n_plots, n_cols)) {
  j <- i+4
  png(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeRMC/10_GraphesChroniquesFDC/7_PresentMesures_HERh_TsKGE_ImpactHumainNulOuFaible_2012_2022_20230417/HER",HER2_,"/ChroniqueFDC_HER2h",HER2_,"_", format(as.Date(tab_inShape_$Date[i], "%d-%m-%Y"), "%Y"), ".png"),
  #png(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeRMC/10_GraphesChroniquesFDC/7_PresentMesures_HERh_TsKGE_ImpactHumainNulOuFaible_2012_2022_20230417/HER56/ChroniqueFDC_HER2h56_", i, "-", j, ".png"),
      width = 1200, height = 750,
      units = "px", pointsize = 12)
  print(plot_grid(plotlist = plots_list[i:j], ncol = n_cols))
  dev.off()
}


