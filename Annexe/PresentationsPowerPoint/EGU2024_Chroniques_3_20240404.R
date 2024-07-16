library(lubridate)
library(hydroTSM)
library(ggplot2)
library(zoo)

ratio_epaisseurs_ = 2

chro_GRSD_HER3_V203041001_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85_narr/debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/V203041001.txt",
                                         sep = ";", dec = ".", header = T)
chro_GRSD_HER3_V203041001_ <- chro_GRSD_HER3_V203041001_[which(chro_GRSD_HER3_V203041001_$Type != "Safran"),]

chro_GRSD_HER3_U202201001_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85_narr/debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/U202201001.txt",
                                         sep = ";", dec = ".", header = T)
chro_GRSD_HER3_U202201001_ <- chro_GRSD_HER3_U202201001_[which(chro_GRSD_HER3_U202201001_$Type != "Safran"),]

chro_GRSD_HER3_U212201001_ <- read.table("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85_narr/debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/U212201001.txt",
                                         sep = ";", dec = ".", header = T)
chro_GRSD_HER3_U212201001_ <- chro_GRSD_HER3_U212201001_[which(chro_GRSD_HER3_U212201001_$Type != "Safran"),]

### Table ###
# tab_ <- chro_GRSD_HER3_V203041001_
# output_name_flow_ <- "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CourbeFlow_V203041001_Image1_1_20240405.png"
# output_name_flow_trait_ <- "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CourbeFlow_V203041001_Image2_1_20240405.png"
# output_name_flow_trait_resserre_ <- "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CourbeFlow_V203041001_Image3_1_20240405.png"
# output_name_ <- "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CourbeFDC_V203041001_Image1_1_20240405.png"
# output_name_fdc_trait_ <- "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CourbeFDC_V203041001_Image2_1_20240405.png"
# limits_ = c(log(0.017),log(100))
# tab_ <- chro_GRSD_HER3_U202201001_
# output_name_flow_ <- "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CourbeFlow_U202201001_Image1_1_20240405.png"
# output_name_flow_trait_ <- "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CourbeFlow_U202201001_Image2_1_20240405.png"
# output_name_flow_trait_resserre_ <- "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CourbeFlow_U202201001_Image3_1_20240405.png"
# output_name_ <- "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CourbeFDC_U202201001_Image1_1_20240405.png"
# output_name_fdc_trait_ <- "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CourbeFDC_U202201001_Image2_1_20240405.png"
# limits_ = c(log(0.017),log(100))
tab_ <- chro_GRSD_HER3_U212201001_
output_name_flow_ <- "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CourbeFlow_U212201001_Image1_1_20240405.png"
output_name_flow_trait_ <- "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CourbeFlow_U212201001_Image2_1_20240405.png"
output_name_flow_trait_resserre_ <- "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CourbeFlow_U212201001_Image3_1_20240405.png"
output_name_ <- "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CourbeFDC_U212201001_Image1_1_20240405.png"
output_name_fdc_trait_ <- "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CourbeFDC_U212201001_Image2_1_20240405.png"
limits_ = c(0.5,log(300))

spline.d <- as.data.frame(spline(1:length(tab_$Qm3s1),tab_$Qm3s1, n = 1000))

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




# Afficher les données lissées
# print(smoothed_data)



fdcurve <- fdc(as.numeric(spline.d$y),plot=T,lQ.thr=0.95,hQ.thr=0.2,ylab="Q [l/s]")

x = spline.d$y
log="y"
ylim=NULL
yat=c(0.01, 0.1, 1)
x <- as.numeric(x)
x.old <- x
x <- sort(x)
x.zero.index <- which(x==0)
nzeros <- length(x.zero.index)
ind <- match(x.old, x)
n <- length(x)
dc <- rep(NA, n)
dc[1:n] <- sapply(1:n, function(j,y) {
  dc[j] <- length( which(y >= y[j]) )
}, y = x)
dc <- dc/n
dc.plot <- dc

if (log == "y") {
  if (nzeros > 0) {
    x       <- x[-x.zero.index]
    dc.plot <- dc.plot[-x.zero.index]
    if (verbose) message("[Note: all 'x' equal to zero (", nzeros, ") will not be plotted ]")
  } # IF end
} # IF end

if ( is.null(ylim) ) ylim <- range(x, na.rm=TRUE)

if ( ((log=="y") | (log=="xy") | (log=="yx")) & min(ylim)==0 ) {
  tmp <- x
  tmp[which(tmp==0)] <- NA
  ylim[1] <- min(tmp, na.rm=TRUE)
} # IF end

df_fcd_ <- data.frame(x = dc.plot, y = x)

# Calcul des positions et étiquettes d'axe personnalisées
ylabels <- pretty(range(df_fcd_$y))
if ( (log=="y") | (log=="xy") | (log=="yx") ) {            
  ylabels <- union( yat, ylabels )            
}
if (max(ylabels) == 350){
  ylabels <- c(10,50.00,100.00,200.00,300.00)
}else{
  ylabels <- c(0.1,1,10,40,80)
  # ylabels <- c(0.1,1,10,50,100)
}





# Création du ggplot avec les ajustements d'axe
fdc_curve_ <- ggplot(df_fcd_, aes(x = x, y = log(y), group = 1)) +
  geom_line(color = "#034e7b", lwd = 2*ratio_epaisseurs_) +
  theme_minimal() +
  theme(plot.margin = margin(20, 20, 20, 20),
        # plot.background = element_rect(fill = "white"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_text(color = "#2f2f32", vjust = 0, hjust=0.5, size = 28*ratio_epaisseurs_),
        axis.text.y = element_text(color = "#2f2f32", size = 28*ratio_epaisseurs_),
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
  # scale_y_continuous(breaks = log(ylabels), labels = ylabels) +
  scale_y_continuous(breaks = log(ylabels), labels = ylabels, limits = limits_) +
  scale_x_continuous(breaks = c(0,0.25,0.5,0.75,1), labels = c("0%","25%","50%","75%","100%"))

fdc_curve_
ggsave(filename = output_name_,
       plot = fdc_curve_)



if (max(ylabels) == 300){
  ylabels <- c(50.00,100.00,200.00,300.00)
}else{
  ylabels <- c(10,40,80)
  # ylabels <- c(0.1,1,10,50,100)
}

flow_curve_ <- ggplot(spline.d, aes(x = Date, y = y, group = 1)) +
  geom_line(color = "#034e7b", lwd = 0.6*ratio_epaisseurs_) +
  theme_minimal() +
  # scale_y_continuous(expand = c(0,0)) +
  scale_y_continuous(breaks = ylabels, labels = ylabels, expand = c(0,0)) +
  
  
  theme(plot.margin = margin(20, 20, 20, 20),
        # plot.background = element_rect(fill = "white"),
        
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
        
        text = element_text(size = 20*ratio_epaisseurs_),
        
        strip.text.x = element_blank(),
        strip.background = element_blank(),
        
        legend.title = element_text(color = "#2f2f32", size = 18), #, face = "normal"
        legend.text = element_text(color = "#2f2f32", size = 18),
        legend.margin = margin(-7, 0, 0, 0),
        legend.spacing.y = unit(+0.03, "cm"))#+
flow_curve_
ggsave(filename = output_name_flow_,
       plot = flow_curve_)









### VALEURS ONDE ###
# tab_onde_ <- read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_20050801-21000731/MatInputModel_CampOndeExcl_ByHERDates_2012_2022_Projections_Weight_merge.csv",
tab_onde_ <- read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/MatInputModel_ByHERDates__2012_2022_Observes_Weight_merge.csv",
                        sep = ",", dec = ".", header = T)
tab_onde_3_ <- tab_onde_[which(tab_onde_$HER2 == 3),]
tab_onde_3_[,c("X._Assec","Date")]

tab_onde_3_$Date <- as.Date(tab_onde_3_$Date)

ratio_epaisseurs_ = 2

# tab_onde_3_test_ <- merge(tab_onde_3_$Date, spline.d[,c("Date","y")], by = "Date")
find_nearest_index <- function(date, dates_list) {
  index <- which.min(abs(dates_list - date))
  return(index)
}

# Appliquer la fonction à chaque date dans tab_onde_3_test_
indices <- sapply(tab_onde_3_$Date, find_nearest_index, dates_list = spline.d$Date)
spline.d$Trait = 0
spline.d$Trait[indices] = 1

flow_curve_ <- ggplot(spline.d, aes(x = Date, y = y, group = 1)) +
  
  
  geom_line(color = "#034e7b", lwd = 0.6*ratio_epaisseurs_) +
  
  geom_segment(aes(x = Date,
                   xend = Date,
                   y = 0,
                   yend = Trait*max(y)), color = "#fe9929",
               lwd = 0.2*ratio_epaisseurs_) +  # Ajout de traits verticaux
  
  theme_minimal() +
  # scale_y_continuous(expand = c(0,0)) +
  scale_y_continuous(breaks = ylabels, labels = ylabels, expand = c(0,0)) +
  scale_x_date(breaks = c(as.Date("1950-01-01"),
                          as.Date("2012-01-01"),
                          as.Date("2022-01-01"),
                          as.Date("2050-01-01"),
                          as.Date("2100-01-01")),
               date_labels = "%Y")+
  
  theme(plot.margin = margin(20, 20, 20, 20),
        # plot.background = element_rect(fill = "white"),
        
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_text(color = "#2f2f32", vjust = 0, hjust=c(0.5,0.8,0.2,0.5,0.5), size = 28*ratio_epaisseurs_), # angle = 90
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
ggsave(filename = output_name_flow_trait_,
       plot = flow_curve_)



spline.d_resserre_ <- spline.d[which(year(spline.d$Date) >= 2012 & year(spline.d$Date) <= 2022),]

flow_curve_ <- ggplot(spline.d_resserre_, aes(x = Date, y = y, group = 1)) +
  
  geom_line(color = "#034e7b", lwd = 2*ratio_epaisseurs_) +
  
  geom_segment(aes(x = Date,
                   xend = Date,
                   y = 0,
                   yend = Trait*max(y)), color = "#fe9929",
               lwd = 1.5*ratio_epaisseurs_) +  # Ajout de traits verticaux
  
  theme_minimal() +
  # scale_y_continuous(expand = c(0,0)) +
  scale_y_continuous(breaks = ylabels, labels = ylabels, expand = c(0,0)) +
  scale_x_date(breaks = c(#as.Date("1950-01-01"),
                          as.Date("2012-01-01"),
                          as.Date("2014-01-01"),
                          as.Date("2016-01-01"),
                          as.Date("2018-01-01"),
                          as.Date("2020-01-01"),
                          as.Date("2022-01-01")),
                          #as.Date("2050-01-01"),
                          #as.Date("2100-01-01")),
               # limits = c(2012,2023),
               date_labels = "%Y")+
  
  theme(plot.margin = margin(20, 20, 20, 20),
        # plot.background = element_rect(fill = "white"),
        
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_text(color = "#2f2f32", vjust = 0, hjust=c(0.5,0.8,0.2,0.5,0.5), size = 28*ratio_epaisseurs_), # angle = 90
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
ggsave(filename = output_name_flow_trait_resserre_,
       plot = flow_curve_)






### FDC avec traits ###
if (max(ylabels) == 300){
  ylabels <- c(10,50.00,100.00,200.00,300.00)
}else{
  ylabels <- c(0.1,1,10,40,80)
  # ylabels <- c(0.1,1,10,50,100)
}

df_fcd_ <- data.frame(x = dc.plot, y = x)

indices <- sapply(spline.d$y[which(spline.d$Trait == 1)], find_nearest_index, dates_list = df_fcd_$y)
df_fcd_$Trait = 0
set.seed(15)
df_fcd_$Trait[sample(indices,8)] = 1

# Création du ggplot avec les ajustements d'axe
fdc_curve_ <- ggplot(df_fcd_, aes(x = x, y = log(y), group = 1)) +
  geom_line(color = "#034e7b", lwd = 2*ratio_epaisseurs_) +
  
  geom_segment(data = df_fcd_,
               mapping = aes(x = 0,
                             xend = x*Trait,
                             y = log(y)*Trait,
                             yend = log(y)*Trait),
               color = "#fe9929",
               lwd = 1.5*ratio_epaisseurs_) +

  theme_minimal() +
  theme(plot.margin = margin(20, 20, 20, 20),
        # plot.background = element_rect(fill = "white"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_text(color = "#2f2f32", vjust = 0, hjust=0.5, size = 28*ratio_epaisseurs_),
        axis.text.y = element_text(color = "#2f2f32", size = 28*ratio_epaisseurs_),
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
  scale_y_continuous(breaks = log(ylabels), labels = ylabels, limits = limits_) +
  scale_x_continuous(breaks = c(0,0.25,0.5,0.75,1), labels = c("0%","25%","50%","75%","100%"))

fdc_curve_
ggsave(filename = output_name_fdc_trait_,
       plot = fdc_curve_)
