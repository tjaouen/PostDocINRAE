### Libraries ###
library(ggplot2)
library(ggrepel)
library(viridis)
library(purrr)
library(gridExtra)
library(cowplot)

### HER 2 ###
HER2_ = 120
#56
#76

### Freq j- et j+, assecs ###
file_input_HER2_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeRMC/1_MatricesInputModeles_ParHERDates/7_PresentMesures_HERh_TsKGE_ImpactHumainNulOuFaible_2012_2022_20230417/MatInputModel_ByHERDates__2012_2022_KGESUp0.00_DispSup-1_ImpactNulFaible_Obs_Weight.csv"
tab_input_HER2_ = read.table(file_input_HER2_, sep = ",", dec = ".", header = T)
tab_input_HER2_$Date = as.Date(tab_input_HER2_$Date, format = "%d-%m-%Y")

tab_input_HER2_ = tab_input_HER2_[which(tab_input_HER2_$HER2 == HER2_),]
tab_inShape_ = data.frame(Date = tab_input_HER2_$Date,
                          Assec = tab_input_HER2_$X._Assec,
                          Freq_moins = rowMeans(tab_input_HER2_[,c("Freq_jmoins5","Freq_jmoins4","Freq_jmoins3","Freq_jmoins2","Freq_jmoins1")]),
                          Freq_plus = rowMeans(tab_input_HER2_[,c("Freq_jplus5","Freq_jplus4","Freq_jplus3","Freq_jplus2","Freq_jplus1","Freq_j")]))


### Freq chronologies ###
file_input_ = paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeRMC/FlowDurationCurves_ChroniquesParHer/Present/FDCChroHer_Obs_3_PresentMesures_HERhybrides_TousKGE_2012_2022_20230407/ChroniqueFDC_KGESUp0.00_DispSup-1_Obs_HER",HER2_,".csv")
tab_input_ = read.table(file_input_, sep = ";", dec = ".", header = T)
tab_input_$Date = as.Date(tab_input_$Date, format = "%Y-%m-%d")
dim(tab_input_)

tab_df_ = data.frame(Date = tab_input_$Date,
                     FDC = rowMeans(tab_input_[,2:dim(tab_input_)[2]], na.rm = T))

year = 2012:2022





# Extraction des données pour la période donnée pour chaque année
df_list <- lapply(2012:2022, function(year) {
  subset(tab_df_, format(Date, "%Y") == as.character(year) & format(Date, "%m-%d") >= "05-15" & format(Date, "%m-%d") <= "10-15")
})

df_list_HER2 <- lapply(2012:2022, function(year) {
  subset(tab_inShape_, format(Date, "%Y") == as.character(year))
})

df_list_HER2



# p <- ggplot(df_list[[d]], aes(x = as.Date(Date), y = FDC)) +
#   geom_line() +
#   
#   #geom_hline(yintercept = df_list_HER2[[d]]$Assec, color = "#e34a33") +
#   geom_segment(df_list_HER2[[d]], aes(x = as.Date(Date-5), xend = as.Date(dDate-1),
#                    y = Freq_moins, yend = Freq_moins),
#                color = "#31a354", size = 2, linetype = "dashed") +
#   # geom_segment(aes(x = as.Date(df_list_HER2[[d]]$Date), xend = as.Date(df_list_HER2[[d]]$Date+5),
#   #                  y = df_list_HER2[[d]]$Freq_plus, yend = df_list_HER2[[d]]$Freq_plus),
#   #              color = "#3182bd", size = 2, linetype = "dashed") +
#   
#   labs(title = paste("FDC de", year, "du 15 mai au 15 octobre"),
#        x = "Date", y = "FDC") +
#   theme_bw()

# #geom_hline(yintercept = df_list_HER2[[d]]$Assec, color = "#e34a33") +
# geom_segment(df_list_HER2[[d]], aes(x = as.Date(Date-5), xend = as.Date(dDate-1),
#                                     y = Freq_moins, yend = Freq_moins),
#              color = "#31a354", size = 2, linetype = "dashed") +
# # geom_segment(aes(x = as.Date(df_list_HER2[[d]]$Date), xend = as.Date(df_list_HER2[[d]]$Date+5),
# #                  y = df_list_HER2[[d]]$Freq_plus, yend = df_list_HER2[[d]]$Freq_plus),
# #              color = "#3182bd", size = 2, linetype = "dashed") +


for (d in 1:length(df_list)){
  
  # png(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeRMC/10_GraphesChroniquesFDC/7_PresentMesures_HERh_TsKGE_ImpactHumainNulOuFaible_2012_2022_20230417/HER",HER2_,"/ChroniqueFDC_HER2h",HER2_,"_", year[d], ".png"),
  #     width = 1200, height = 750,
  #     units = "px", pointsize = 12)
  
  x11()
  p <- ggplot(df_list_HER2[[d]], aes(x = as.Date(Date), y = Freq_moins)) +
    #geom_line() +
    geom_segment(aes(x = as.Date(Date-5), xend = as.Date(Date-1),
                     y = Freq_moins, yend = Freq_moins),
                 color = "#31a354", size = 2) +
    #color = "#31a354", size = 2, linetype = "dashed") +
    geom_segment(aes(x = as.Date(Date), xend = as.Date(Date+5),
                     y = Freq_plus, yend = Freq_plus),
                 color = "#3182bd", size = 2) +
    #color = "#3182bd", size = 2, linetype = "dashed") +
    geom_point(aes(x = as.Date(Date), y = 1-Assec/100),
               color = "#e34a33", size = 6) +
    
    geom_line(data = df_list[[d]], aes(x = as.Date(Date), y = FDC)) +
    
    labs(title = paste("FDC de", year[d], "du 15 mai au 15 octobre"),
         x = "Date", y = "FDC") +
    ylim(0,1) +
    theme_bw()
  
  print(p)
  dev.off()
  
}







# x11()
# p <- ggplot(tab_inShape_, aes(x = as.Date(Date), y = Freq_moins)) +
#   #geom_line() +
#   geom_segment(aes(x = as.Date(Date-5), xend = as.Date(Date-1),
#                    y = Freq_moins, yend = Freq_moins),
#                color = "#31a354", size = 6) +
#   #color = "#31a354", size = 2, linetype = "dashed") +
#   geom_segment(aes(x = as.Date(Date), xend = as.Date(Date+5),
#                    y = Freq_plus, yend = Freq_plus),
#                color = "#3182bd", size = 6) +
#   #color = "#3182bd", size = 2, linetype = "dashed") +
#   geom_point(aes(x = as.Date(Date), y = 1-Assec/100),
#              color = "#e34a33", size = 6) +
#   
#   geom_line(data = tab_inShape_, aes(x = as.Date(Date), y = Freq_moins), size = 1.5) +
#   
#   labs(title = paste("FDC de 2012 à 2022, du 15 mai au 15 octobre"),
#        x = "Date", y = "FDC") +
#   ylim(0,1) +
#   theme_bw()
# 
# print(p)


x11()
p <- ggplot(tab_inShape_, aes(x = as.Date(Date), y = Freq_moins)) +
  #geom_line() +
  geom_point(aes(x = as.Date(Date), y = Freq_moins),
               color = "#31a354", size = 6) +
  #color = "#31a354", size = 2, linetype = "dashed") +
  #color = "#3182bd", size = 2, linetype = "dashed") +
  geom_point(aes(x = as.Date(Date), y = 1-Assec/100),
             color = "#e34a33", size = 6) +
  
  geom_line(data = tab_inShape_, aes(x = as.Date(Date), y = Freq_moins), size = 1.5) +
  
  labs(title = paste0("FDC de 2012 à 2022 et probabilité d'écoulement dans l'HER ",HER2_),
       x = "Date", y = "FDC") +
  ylim(0,1) +
  theme_bw()

print(p)


