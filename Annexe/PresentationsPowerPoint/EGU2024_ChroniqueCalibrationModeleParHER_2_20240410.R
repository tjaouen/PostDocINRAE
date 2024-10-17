library(lubridate)

# HER_h_ = 13
# HER_h_ = 105
HER_h_ = 36

chro_ = read.table(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_ChroniquesProba_LearnBrut_HER",HER_h_,".txt"),
                   sep = ";", dec = ".", header = T)

chro_ <- chro_[which(chro_$Type == "Safran" & year(chro_$Date) >= 2012 & year(chro_$Date) <= 2019),]
chro_ <- subset(chro_, select = -c(Type, Jour_annee))
chro_$Mediane <- apply(chro_[, -1], 1, median)

### VALEURS ONDE ###
# tab_onde_ <- read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_20050801-21000731/MatInputModel_CampOndeExcl_ByHERDates_2012_2022_Projections_Weight_merge.csv",
tab_onde_ <- read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/MatInputModel_ByHERDates__2012_2022_Observes_Weight_merge.csv",
                        sep = ",", dec = ".", header = T)
tab_onde_3_ <- tab_onde_[which(tab_onde_$HER2 == HER_h_),]
tab_onde_3_[,c("X._Assec","Date")]

tab_onde_3_$Date <- as.Date(tab_onde_3_$Date)
tab_onde_3_ <- tab_onde_3_[which(year(tab_onde_3_$Date) >= 2012 & tab_onde_3_$Date <= "2019-07-31"),]

ratio_epaisseurs_ = 2

### Description HER ###
descriptionHER_ = read_excel(paste0(folder_HER_DataDescription_,"../HER2officielles/DescriptionHER2_3_20240313.xlsx"))

### Rcp ###
# df_mean_rcp_ = df_mean[which(df_mean$Type == pattern_rcp_),]
# df_mean_overwriteColors_rcp_ = df_mean_overwriteColors_[which(df_mean_overwriteColors_$Type == pattern_rcp_),]

p_mean <- ggplot() +
  
  geom_line(data = chro_, aes(x = as.Date(Date), y = Mediane, group = 1, lineend = "round"), lwd = 1*ratio_epaisseurs_, color = "#cc4c02") + # linetype = Type, color = Legend, 
  
  geom_point(data = tab_onde_3_, mapping = aes(x = Date, y = X._Assec), color = "#2f2f32", size = 5*ratio_epaisseurs_) +
  geom_point(data = tab_onde_3_, mapping = aes(x = Date, y = X._Assec), color = "#fe9929", size = 3*ratio_epaisseurs_) +
  
  # Axes #
  scale_x_date(breaks = c(as.Date("2012-01-01"),
                          as.Date("2014-01-01"),
                          as.Date("2016-01-01"),
                          as.Date("2018-01-01"),
                          as.Date("2020-01-01"),
                          as.Date("2022-01-01")), 
               expand = c(0.05,0.05),
               limits = c(as.Date("2012-01-01"),
                          as.Date("2020-01-01")),
               date_labels = "%Y") +
  # scale_x_date(breaks = seq(min(tab_onde_3_$Date),max(tab_onde_3_$Date), length = 6), date_labels = "%Y") +
  scale_y_continuous(limits = c(0,100),
                     expand = c(0, 2),
                     breaks = c(0,25,50,75,100),
                     labels = c("0%","","50%","","100%")) +
  
  # scale_x_date("Date",
  #              breaks = breaks_dates_,
  #              labels = year_labels,
  #              expand = c(0,0),
  #              minor_breaks=c(seq(from=as.Date("2012-01-01"),to=as.Date("2023-12-31"),by="year"),"2023-12-31")) +
  # scale_y_continuous(expand = expansion(mult = c(0, 0.05)))+
  #                    # limits = c(0,100),
  #                    # breaks = seq(0,100,by=20),
  #                    # labels = function(x) paste0(x, "%")) + # Supprimer l'espace entre l'axe des abscisses et la première valeur de y
  
labs(title = "Moyenne des probabilités d'assecs lissées sur 5 jours",
     subtitle = paste0("HER : ",HER_h_," ",descriptionHER_$NomHER2[which(descriptionHER_$CdHER2 == HER_h_)],
                       # "\nPériode : ",year(date_intervalle_[1]),"-",year(date_intervalle_[2]),
                       " - Modèle hydrologique : ",str_before_first(nom_categorieSimu_,"_")),
     x = "Date",
     y = "Moyenne des probabilités d'assecs") +
  
  theme_minimal() +
  theme(plot.title = element_text(color = "#060403", size = 30, face = "bold"),
        plot.subtitle = element_text(color = "#2f2f32", size = 18),
        plot.margin = margin(20, 20, 20, 20),
        
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_text(color = "#2f2f32", vjust = 0, hjust=c(0.5,0.5,0.5,0.5,0.5), size = 28*ratio_epaisseurs_), # angle = 90
        axis.text.y = element_text(color = "#2f2f32", size = 28*ratio_epaisseurs_),
        axis.line.x = element_line(color = "#2f2f32", size = 1*ratio_epaisseurs_), # Trait des abscisses plus épais, IPCCgrey75
        axis.line.y = element_blank(), # Supprimer l'axe y
        axis.ticks.x=element_line(colour=c("#2f2f32"), size = 1*ratio_epaisseurs_),
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
        legend.spacing.y = unit(+0.03, "cm"))#+
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

p_mean


ggsave(filename = paste0("/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/ChroniqueCalibration_HER",HER_h_,"_1_20240412.png"),
       plot = p_mean)
