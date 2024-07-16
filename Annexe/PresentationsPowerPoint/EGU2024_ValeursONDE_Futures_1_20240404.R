library(lubridate)
library(hydroTSM)
library(ggplot2)
library(zoo)

ratio_epaisseurs_ = 2

chroProba_GRSD_HER3_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_ChroniquesProba_LearnBrut_HER3.txt",
                                   sep = ";", dec = ".", header = T)

### Table ###
tab_ <- chroProba_GRSD_HER3_
tab_ <- tab_[which(tab_$Type != "Safran"),]
tab_ <- tab_[which(year(tab_$Date) >= 1975),]
output_name_ONDE_future_ <- "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CourbeONDE_Future_Image1_1_20240417.png"

spline.d <- as.data.frame(spline(1:length(tab_$debit_France_ICHEC.EC.EARTH_rcp85_r12i1p1_MOHC.HadREM3.GA7.05_v2_MF.ADAMONT.SAFRAN.1980.2011_INRAE.GRSD_day_20050801.21000731),tab_$debit_France_ICHEC.EC.EARTH_rcp85_r12i1p1_MOHC.HadREM3.GA7.05_v2_MF.ADAMONT.SAFRAN.1980.2011_INRAE.GRSD_day_20050801.21000731, n = 1000))

liste_dates <- as.Date(tab_$Date)

# Trouvez la date de début et de fin
date_debut <- min(liste_dates)
date_fin <- max(liste_dates)
# Calcul de la différence en jours
difference_jours <- as.numeric(date_fin - date_debut)
# Calcul de la fréquence moyenne d'occurrence des dates
freq_moyenne <- length(liste_dates) / difference_jours
# Nombre de dates que vous souhaitez extraire
nb_dates_a_extraire <- 999
# Calculez les intervalles pour chaque date
intervalles <- seq(as.integer(date_debut), as.integer(date_fin), length.out = (nb_dates_a_extraire + 1))
# Sélectionnez une date représentative dans chaque intervalle
dates_representatives <- as.Date(intervalles, origin = "1970-01-01")
# Affichez les dates représentatives
print(dates_representatives)

spline.d$Date = dates_representatives



### VALEURS ONDE ###
# tab_onde_ <- read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_20050801-21000731/MatInputModel_CampOndeExcl_ByHERDates_2012_2022_Projections_Weight_merge.csv",
tab_onde_ <- read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/MatInputModel_ByHERDates__2012_2022_Observes_Weight_merge.csv",
                        sep = ",", dec = ".", header = T)
tab_onde_3_ <- tab_onde_[which(tab_onde_$HER2 == 3),]
tab_onde_3_[,c("X._Assec","Date")]

tab_onde_3_$Date <- as.Date(tab_onde_3_$Date)

ratio_epaisseurs_ = 2




# Afficher les données lissées
# print(smoothed_data)

# ylabels <- c(0,25,50,75,100)

flow_curve_ <- ggplot(spline.d, aes(x = Date, y = y, group = 1)) +
  # geom_line(color = "#cc4c02", lwd = 0.6*ratio_epaisseurs_) +
  theme_minimal() +
  
  geom_point(data = tab_onde_3_, mapping = aes(x = Date, y = X._Assec), color = "#2f2f32", size = 3*ratio_epaisseurs_) +
  geom_point(data = tab_onde_3_, mapping = aes(x = Date, y = X._Assec), color = "#fe9929", size = 1.8*ratio_epaisseurs_) +
  
  # scale_y_continuous(expand = c(0,0)) +
  scale_y_continuous(breaks = c(0,25,50,75,100),
                     labels = c("0%","","50%","","100%"),
                     expand = c(0,1),
                     limits = c(0,100)) +
  scale_x_date(breaks = c(as.Date("1975-01-01"),
                          as.Date("2012-01-01"),
                          as.Date("2022-01-01"),
                          as.Date("2050-01-01"),
                          as.Date("2100-01-01")),
               date_labels = "%Y",
               limits = c(min(spline.d$Date),max(spline.d$Date))) +
  
  
  theme(plot.margin = margin(20, 20, 20, 20),
        plot.background = element_rect(fill = "white"),
        
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_text(color = "#2f2f32", vjust = 0, hjust=c(0.5,0.8,0.2,0.5,0.5), size = 28*ratio_epaisseurs_), # angle = 90
        # axis.text.x = element_text(color = "#2f2f32", vjust = 0, hjust=0.5, size = 28*ratio_epaisseurs_), # angle = 90
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
        
        text = element_text(size = 20*ratio_epaisseurs_),
        
        strip.text.x = element_blank(),
        strip.background = element_blank(),
        
        legend.title = element_text(color = "#2f2f32", size = 18), #, face = "normal"
        legend.text = element_text(color = "#2f2f32", size = 18),
        legend.margin = margin(-7, 0, 0, 0),
        legend.spacing.y = unit(+0.03, "cm"))#+
flow_curve_
ggsave(filename = output_name_ONDE_future_,
       plot = flow_curve_)





