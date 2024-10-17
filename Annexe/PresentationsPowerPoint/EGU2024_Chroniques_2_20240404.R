library(hydroTSM)
library(ggplot2)
library(zoo)

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
# output_name_flow_ <- "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CourbeFlow_V203041001_Image1_1_20240404.png"
# output_name_ <- "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CourbeFDC_V203041001_Image1_1_20240404.png"
# tab_ <- chro_GRSD_HER3_U202201001_
# output_name_flow_ <- "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CourbeFlow_U202201001_Image1_1_20240404.png"
# output_name_ <- "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CourbeFDC_U202201001_Image1_1_20240404.png"
tab_ <- chro_GRSD_HER3_U212201001_
output_name_flow_ <- "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CourbeFlow_U212201001_Image1_1_20240404.png"
output_name_ <- "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CourbeFDC_U212201001_Image1_1_20240404.png"

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

flow_curve_ <- ggplot(spline.d, aes(x = Date, y = y, group = 1)) +
  geom_line(color = "#034e7b") +
  theme_minimal() +
  
  theme(plot.margin = margin(20, 20, 20, 20),
        plot.background = element_rect(fill = "white"),
        
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_text(color = "#2f2f32", vjust = 0, hjust=0.5, size = 28), # angle = 90
        axis.text.y = element_text(color = "#2f2f32", size = 28),
        axis.line.x = element_line(color = "#2f2f32", size = 1), # Trait des abscisses plus épais, IPCCgrey75
        axis.line.y = element_blank(), # Supprimer l'axe y
        axis.ticks.x=element_line(colour=c("#2f2f32")),
        # axis.ticks.x=element_line(colour=c("#2f2f32",rep(c(NA, "#2f2f32"), t=12))),
        axis.ticks.length  = unit(0.25, "cm"),
        
        panel.grid.major.x = element_blank(), # Traits horizontaux plus clairs
        panel.grid.minor.x = element_blank(), # Traits horizontaux plus clairs
        panel.grid.major.y = element_line(color = "#dcdad9", size = 0.5), # Traits horizontaux plus clairs
        panel.grid.minor.y = element_line(color = "#dcdad9", size = 0), # Traits horizontaux plus clairs
        
        text = element_text(size = 20),
        
        strip.text.x = element_blank(),
        strip.background = element_blank(),
        
        legend.title = element_text(color = "#2f2f32", size = 18), #, face = "normal"
        legend.text = element_text(color = "#2f2f32", size = 18),
        legend.margin = margin(-7, 0, 0, 0),
        legend.spacing.y = unit(+0.03, "cm"))#+
flow_curve_
ggsave(filename = output_name_flow_,
       plot = flow_curve_)


fdcurve <- fdc(as.numeric(spline.d$y),plot=T,lQ.thr=0.95,hQ.thr=0.2,ylab="Q [l/s]")

x = spline.d$y
# lQ.thr=0.7
# hQ.thr=0.2
# plot=TRUE
log="y"
# main="Flow Duration Curve"
# xlab="% Time flow equalled or exceeded"
# ylab="Q, [m3/s]"
ylim=NULL
yat=c(0.01, 0.1, 1)
# xat=c(0.01, 0.025, 0.05)
# #yaxp=c(range(x),2),
# col="black"
#   pch=1
#   lwd=1
#   lty=1
#   cex=0.4
#   cex.axis=1.2
#   cex.lab=1.2
#   leg.txt=NULL
#   leg.cex=1
#   leg.pos="topright"
#   verbose= TRUE
#   thr.shw=TRUE
#   new=TRUE

# # Returns the position in the vector 'x' where the scalar 'Q' is located
# Qposition <- function(x, Q) {
#   Q.dist  <- abs(x - Q)
#   Q.index <- which.min( Q.dist )
#   return(Q.index)
# } # end

# If 'x' is of class 'ts' or 'zoo'
#if ( !is.na( match( class(x), c("ts", "zoo") ) ) )
x <- as.numeric(x)
  
# Storing the original values
x.old <- x
  
# 1) Sort 'x' in drecreasing order. This is just for avoiding misleading
#lines when using 'type="o"' for plotting
x <- sort(x)
  
# Detecting zero values
x.zero.index <- which(x==0)
nzeros <- length(x.zero.index)
  
# Index with the position of the original values
ind <- match(x.old, x)
  
# 2) Compute the length of 'x'
n <- length(x)
  
# 3) Creation of the output vector
dc <- rep(NA, n)
  
# 4) Exceedence Probability
dc[1:n] <- sapply(1:n, function(j,y) {
  dc[j] <- length( which(y >= y[j]) )
}, y = x)
  
# Computing the probabilitites
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
}

# Création du ggplot avec les ajustements d'axe
fdc_curve_ <- ggplot(df_fcd_, aes(x = x, y = log(y), group = 1)) +
  geom_line(color = "#034e7b", lwd = 2) +
  theme_minimal() +
  theme(plot.margin = margin(20, 20, 20, 20),
        plot.background = element_rect(fill = "white"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_text(color = "#2f2f32", vjust = 0, hjust=0.5, size = 28),
        axis.text.y = element_text(color = "#2f2f32", size = 28),
        axis.line.x = element_line(color = "#2f2f32", size = 1),
        axis.line.y = element_blank(),
        axis.ticks.x=element_line(colour=c("#2f2f32")),
        axis.ticks.length  = unit(0.25, "cm"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_line(color = "#dcdad9", size = 0.5),
        panel.grid.minor.y = element_line(color = "#dcdad9", size = 0),
        text = element_text(size = 20),
        strip.text.x = element_blank(),
        # strip.background = element_blank(),
        legend.title = element_text(color = "#2f2f32", size = 18),
        legend.text = element_text(color = "#2f2f32", size = 18),
        legend.margin = margin(-7, 0, 0, 0),
        legend.spacing.y = unit(+0.03, "cm")) +
  scale_y_continuous(breaks = log(ylabels), labels = ylabels) +
  scale_x_continuous(breaks = c(0,0.25,0.5,0.75,1), labels = c("0%","25%","50%","75%","100%"))

ggsave(filename = output_name_,
       plot = fdc_curve_)
