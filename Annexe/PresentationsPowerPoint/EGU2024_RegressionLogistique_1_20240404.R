tab_reg_ <- read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/2_ResultatsModeles_ParHer/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/ApprentissageGlobalModelesBruts/ModelResults_ByHERDates_2012_2022_Projections_Weight_merge_12-13-14-15-16-17-18-19_Jm6Jj_logit.csv",
                       sep = ";", dec = ".", header = T)

tab_reg_ <- tab_reg_[which(tab_reg_$HER == 3),]

x = seq(0,1, by = 0.001)
y = (exp(tab_reg_$Inter_logit_Learn + tab_reg_$Slope_logit_Learn * x))/(1+exp(tab_reg_$Inter_logit_Learn + tab_reg_$Slope_logit_Learn * x))

ratio_epaisseurs_ = 2

tab_points_ <- read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/MatInputModel_CampOndeExcl_ByHERDates_2012_2022_Projections_Weight_merge.csv",
                       sep = ";", dec = ".", header = T)
tab_points_ <- tab_points_[which(tab_points_$HER2 == 3),]

df_ = data.frame(x = x, y = y*100)


plot_regLog_ <- ggplot(df_, aes(x = x, y = y)) +
  
  # geom_line() +
  # geom_line(color = "#2f2f32", lwd = 2*ratio_epaisseurs_) +
  
  geom_point(data = tab_points_, mapping = aes(x = Freq_Jm6Jj, y = X._Assec), color = "#2f2f32", size = 4*ratio_epaisseurs_) +
  geom_point(data = tab_points_, mapping = aes(x = Freq_Jm6Jj, y = X._Assec), color = "#fe9929", size = 2.8*ratio_epaisseurs_) +
  
  theme_minimal() +
  theme(plot.margin = margin(20, 20, 20, 20),
        # plot.background = element_rect(fill = "white"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_text(color = "#2f2f32", vjust = 0, hjust=0.5, size = 28*ratio_epaisseurs_),
        axis.text.y.left = element_blank(),
        axis.text.y.right = element_text(color = "#2f2f32", size = 28*ratio_epaisseurs_),
        axis.line.x = element_line(color = "#2f2f32", linewidth = 1*ratio_epaisseurs_),
        axis.line.y = element_blank(),
        axis.ticks.x=element_line(colour=c("#2f2f32"), size = 1*ratio_epaisseurs_),
        axis.ticks.length  = unit(0.4, "cm"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_line(color = "#dcdad9", size = 0.5*ratio_epaisseurs_),
        panel.grid.minor.y = element_line(color = "#dcdad9", size = 0),
        text = element_text(size = 20),
        strip.text.x = element_blank(),
        # strip.background = element_blank(),
        legend.title = element_text(color = "#2f2f32", size = 18),
        legend.text = element_text(color = "#2f2f32", size = 18),
        legend.margin = margin(-7, 0, 0, 0),
        legend.spacing.y = unit(+0.03, "cm")) +
  # expand = c(0,2),
  # limits = c(0,100))) +
  scale_y_continuous(breaks = c(0,25,50,75,100), 
                     labels = c("0%","","50%","","100%"), 
                     expand = c(0,2),
                     limits = c(0,100),
                     sec.axis = sec_axis(trans = ~.,
                                         breaks = c(0,50,100),
                                         labels = c("0%","50%","100%"))) +
  scale_x_continuous(breaks = c(0,0.25,0.5,0.75,1),
                     labels = c("0%","25%","50%","75%","100%"),
                     expand = c(0.002,0.05),
                     limits = c(0,1))
plot_regLog_
ggsave(filename = "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CourbeRegrLog_HER3_PointsSeulement_Image1_1_20240411.png",
       plot = plot_regLog_)

plot_regLog_ <- ggplot(df_, aes(x = x, y = y)) +
  
  # geom_line() +
  geom_line(color = "#2f2f32", lwd = 2*ratio_epaisseurs_) +
  
  geom_point(data = tab_points_, mapping = aes(x = Freq_Jm6Jj, y = X._Assec), color = "#2f2f32", size = 4*ratio_epaisseurs_) +
  geom_point(data = tab_points_, mapping = aes(x = Freq_Jm6Jj, y = X._Assec), color = "#fe9929", size = 2.8*ratio_epaisseurs_) +
  
  theme_minimal() +
  theme(plot.margin = margin(20, 20, 20, 20),
        # plot.background = element_rect(fill = "white"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_text(color = "#2f2f32", vjust = 0, hjust=0.5, size = 28*ratio_epaisseurs_),
        axis.text.y.left = element_blank(),
        axis.text.y.right = element_text(color = "#2f2f32", size = 28*ratio_epaisseurs_),
        axis.line.x = element_line(color = "#2f2f32", size = 1*ratio_epaisseurs_),
        axis.line.y = element_blank(),
        axis.ticks.x=element_line(colour=c("#2f2f32"), size = 1*ratio_epaisseurs_),
        axis.ticks.length  = unit(0.4, "cm"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_line(color = "#dcdad9", size = 0.5*ratio_epaisseurs_),
        panel.grid.minor.y = element_line(color = "#dcdad9", size = 0),
        text = element_text(size = 20),
        strip.text.x = element_blank(),
        # strip.background = element_blank(),
        legend.title = element_text(color = "#2f2f32", size = 18),
        legend.text = element_text(color = "#2f2f32", size = 18),
        legend.margin = margin(-7, 0, 0, 0),
        legend.spacing.y = unit(+0.03, "cm")) +
  # expand = c(0,2),
  # limits = c(0,100))) +
  scale_y_continuous(breaks = c(0,25,50,75,100), 
                     labels = c("0%","","50%","","100%"), 
                     expand = c(0,2),
                     limits = c(0,100),
                     sec.axis = sec_axis(trans = ~.,
                                         breaks = c(0,50,100),
                                         labels = c("0%","50%","100%"))) +
  scale_x_continuous(breaks = c(0,0.25,0.5,0.75,1), labels = c("0%","25%","50%","75%","100%"), expand = c(0.002,0.05))
plot_regLog_
ggsave(filename = "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CourbeRegrLog_HER3_Image1_1_20240411.png",
       plot = plot_regLog_)



plot_regLog_ <- ggplot(df_, aes(x = x, y = y)) +
  
  # geom_line() +
  geom_line(color = "#2f2f32", lwd = 2*ratio_epaisseurs_) +
  
  # geom_point(data = tab_points_, mapping = aes(x = Freq_Jm6Jj, y = X._Assec), color = "#2f2f32", size = 4*ratio_epaisseurs_) +
  # geom_point(data = tab_points_, mapping = aes(x = Freq_Jm6Jj, y = X._Assec), color = "#fe9929", size = 2.8*ratio_epaisseurs_) +
  
  theme_minimal() +
  theme(plot.margin = margin(20, 20, 20, 20),
        # plot.background = element_rect(fill = "white"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_text(color = "#2f2f32", vjust = 0, hjust=0.5, size = 28*ratio_epaisseurs_),
        axis.text.y.left = element_blank(),
        axis.text.y.right = element_text(color = "#2f2f32", size = 28*ratio_epaisseurs_),
        axis.line.x = element_line(color = "#2f2f32", size = 1*ratio_epaisseurs_),
        axis.line.y = element_blank(),
        axis.ticks.x=element_line(colour=c("#2f2f32"), size = 1*ratio_epaisseurs_),
        axis.ticks.length  = unit(0.4, "cm"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_line(color = "#dcdad9", size = 0.5*ratio_epaisseurs_),
        panel.grid.minor.y = element_line(color = "#dcdad9", size = 0),
        text = element_text(size = 20),
        strip.text.x = element_blank(),
        # strip.background = element_blank(),
        legend.title = element_text(color = "#2f2f32", size = 18),
        legend.text = element_text(color = "#2f2f32", size = 18),
        legend.margin = margin(-7, 0, 0, 0),
        legend.spacing.y = unit(+0.03, "cm")) +
  # expand = c(0,2),
  # limits = c(0,100))) +
  scale_y_continuous(breaks = c(0,25,50,75,100), 
                     labels = c("0%","","50%","","100%"), 
                     expand = c(0,2),
                     limits = c(0,100),
                     sec.axis = sec_axis(trans = ~.,
                                         breaks = c(0,50,100),
                                         labels = c("0%","50%","100%"))) +
  scale_x_continuous(breaks = c(0,0.25,0.5,0.75,1), labels = c("0%","25%","50%","75%","100%"), expand = c(0.002,0.05))
plot_regLog_
ggsave(filename = "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CourbeRegrLog_HER3_SansPoints_Image1_1_20240411.png",
       plot = plot_regLog_)

