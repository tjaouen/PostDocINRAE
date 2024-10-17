### VALEURS ONDE ###
# tab_onde_ <- read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_20050801-21000731/MatInputModel_CampOndeExcl_ByHERDates_2012_2022_Projections_Weight_merge.csv",
tab_onde_ <- read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/MatInputModel_ByHERDates__2012_2022_Observes_Weight_merge.csv",
                        sep = ",", dec = ".", header = T)
tab_onde_3_ <- tab_onde_[which(tab_onde_$HER2 == 3),]
tab_onde_3_[,c("X._Assec","Date")]

tab_onde_3_$Date <- as.Date(tab_onde_3_$Date)

ratio_epaisseurs_ = 2


# Plot using ggplot2 with date scale
plot_onde_ <- ggplot(tab_onde_3_, aes(x = Date, y = X._Assec)) +
  geom_point() +
  # geom_hline(yintercept = 0, color = "#2f2f32", linetype = "solid") +  # Ajout de la ligne à y = 0
  # geom_line() +
  # labs(title = "Your Title Here", x = "Date", y = "X._Assec") +
  # ylim(0,100) +
  theme_minimal() +
  # scale_x_date(date_breaks = "2 year", date_labels = "%Y") +
  scale_x_date(breaks = c(as.Date("2012-01-01"),
                          as.Date("2014-01-01"),
                          as.Date("2016-01-01"),
                          as.Date("2018-01-01"),
                          as.Date("2020-01-01"),
                          as.Date("2022-01-01")), date_labels = "%Y") +
  # scale_x_date(breaks = seq(min(tab_onde_3_$Date),max(tab_onde_3_$Date), length = 6), date_labels = "%Y") +
  scale_y_continuous(limits = c(0,100),
                     expand = c(0, 2),
                     breaks = c(0,25,50,75,100),
                     labels = c("0%","","50%","","100%")) +
  geom_point(color = "#2f2f32", size = 4*ratio_epaisseurs_) +
  geom_point(color = "#fe9929", size = 2.8*ratio_epaisseurs_) +
  
  theme(plot.margin = margin(20, 20, 20, 20),
        # plot.background = element_rect(fill = "white", colour = NA),
        
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_text(color = "#2f2f32", vjust = 0, hjust=0.5, size = 28*ratio_epaisseurs_), # angle = 90
        axis.text.y = element_text(color = "#2f2f32", size = 28*ratio_epaisseurs_),
        axis.line.x = element_line(color = "#2f2f32", size = 1*ratio_epaisseurs_), # Trait des abscisses plus épais, IPCCgrey75
        axis.line.y = element_blank(), # Supprimer l'axe y
        axis.ticks.x=element_line(colour=c("#2f2f32"), size = 1*ratio_epaisseurs_),
        # axis.ticks.x=element_line(colour=c("#2f2f32",rep(c(NA, "#2f2f32"), t=12))),
        axis.ticks.length  = unit(0.4, "cm"),
        
        panel.grid.major.x = element_blank(), # Traits horizontaux plus clairs
        panel.grid.minor.x = element_blank(), # Traits horizontaux plus clairs
        panel.grid.major.y = element_line(color = "#dcdad9", size = 0.5*ratio_epaisseurs_), # Traits horizontaux plus clairs
        panel.grid.minor.y = element_line(color = "#dcdad9", size = 0), # Traits horizontaux plus clairs
        
        text = element_text(size = 20),
        
        strip.text.x = element_blank(),
        strip.background = element_blank(),
        
        legend.title = element_text(color = "#2f2f32", size = 18), #, face = "normal"
        legend.text = element_text(color = "#2f2f32", size = 18),
        legend.margin = margin(-7, 0, 0, 0),
        legend.spacing.y = unit(+0.03, "cm"))
plot_onde_

ggsave(filename = "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/PropONDEHER3_2_20240405.png",
       plot = plot_onde_)

#+
# guides(alpha = guide_legend(override.aes = list(lwd = 2.5,color =levels(df_mean_nonNar_$Color)),
#                             keyheight = 3.2,
#                             keywidth = unit(2,"cm"),
#                             order = 1),
#        color = guide_legend(
#          override.aes = list(lwd = 2.5),
#          keyheight = 3.2,
#          keywidth = unit(1,"cm"),
#          title.hjust = 0.2,
#          order = 2))

# theme(strip.background = element_blank(),
#       panel.grid.major.x = element_blank(),  # Remove vertical grid lines
#       axis.line.x = element_line(size = 1))  # Increase thickness of x axis line)


# theme(strip.text.x = element_blank(),
#       strip.background = element_blank(),
#       axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
#       legend.title = element_blank(),  # Supprimer le titre de la légende Alpha
#       text = element_text(size = 20))+#,







# Plot using ggplot2 with date scale
plot_onde_ <- ggplot(tab_onde_3_, aes(x = Date, y = X._Assec)) +
  geom_point() +
  # geom_hline(yintercept = 0, color = "#2f2f32", linetype = "solid") +  # Ajout de la ligne à y = 0
  # geom_line() +
  # labs(title = "Your Title Here", x = "Date", y = "X._Assec") +
  # ylim(0,100) +
  theme_minimal() +
  # scale_x_date(date_breaks = "2 year", date_labels = "%Y") +
  scale_x_date(breaks = c(as.Date("2012-01-01"),
                          as.Date("2014-01-01"),
                          as.Date("2016-01-01"),
                          as.Date("2018-01-01"),
                          as.Date("2020-01-01"),
                          as.Date("2022-01-01")), date_labels = "%Y") +
  # scale_x_date(breaks = seq(min(tab_onde_3_$Date),max(tab_onde_3_$Date), length = 6), date_labels = "%Y") +
  scale_y_continuous(limits = c(0,100),
                     expand = c(0, 2),
                     breaks = c(0,25,50,75,100),
                     labels = c("0%","","50%","","100%")) +
  
  geom_segment(aes(x = Date, xend = Date, y = 0, yend = X._Assec),
               color = "#034e7b",
               lwd = 1.5*ratio_epaisseurs_) +  # Ajout de traits verticaux
  geom_point(color = "#2f2f32", size = 4*ratio_epaisseurs_) +
  geom_point(color = "#fe9929", size = 2.8*ratio_epaisseurs_) +
  
  theme(plot.margin = margin(20, 20, 20, 20),
        # plot.background = element_rect(fill = "white", colour = NA),
        
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_text(color = "#2f2f32", vjust = 0, hjust=0.5, size = 28*ratio_epaisseurs_), # angle = 90
        axis.text.y = element_text(color = "#2f2f32", size = 28*ratio_epaisseurs_),
        axis.line.x = element_line(color = "#2f2f32", size = 1*ratio_epaisseurs_), # Trait des abscisses plus épais, IPCCgrey75
        axis.line.y = element_blank(), # Supprimer l'axe y
        axis.ticks.x=element_line(colour=c("#2f2f32"), size = 1*ratio_epaisseurs_),
        # axis.ticks.x=element_line(colour=c("#2f2f32",rep(c(NA, "#2f2f32"), t=12))),
        axis.ticks.length  = unit(0.4, "cm"),
        
        panel.grid.major.x = element_blank(), # Traits horizontaux plus clairs
        panel.grid.minor.x = element_blank(), # Traits horizontaux plus clairs
        panel.grid.major.y = element_line(color = "#dcdad9", size = 0.5*ratio_epaisseurs_), # Traits horizontaux plus clairs
        panel.grid.minor.y = element_line(color = "#dcdad9", size = 0), # Traits horizontaux plus clairs
        
        text = element_text(size = 20),
        
        strip.text.x = element_blank(),
        strip.background = element_blank(),
        
        legend.title = element_text(color = "#2f2f32", size = 18), #, face = "normal"
        legend.text = element_text(color = "#2f2f32", size = 18),
        legend.margin = margin(-7, 0, 0, 0),
        legend.spacing.y = unit(+0.03, "cm"))
plot_onde_

ggsave(filename = "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/PropONDEHER3_Points_3_20240405.png",
       plot = plot_onde_)

