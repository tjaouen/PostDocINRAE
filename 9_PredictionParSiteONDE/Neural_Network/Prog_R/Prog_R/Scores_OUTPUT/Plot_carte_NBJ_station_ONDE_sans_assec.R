# création de carte pour les output des prédictions

library("GISTools")
# library("maps")
library("rgdal")
library("cartography")
library("RColorBrewer")
library("classInt")
library("SDMTools")

rm(list=ls())

methode = "LASSO" # "ANN" "Random_Forest" "LASSO" "Knn"

# display.brewer.all(type="div")
# display.brewer.all(type="seq")
# display.brewer.all(type="qual")

# variable=c("Prop","NbJ","Diff")
variable=c("Prop","NbJ","Diff")
jour="J30_moy"
data=read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/Proportion_assec_",methode,"_",jour,"_new_HYDRO_ONLY.csv", sep=""), header = T, sep = ";")
data=data[c(-2,-104,-172),]

for (v in variable){
  compt=0
  if (v == "NbJ"){
    an = c("2012","2013","2014","2015","2016")
  } else {
    an = c("")
  }
  
  for (annee in an){
    compt=compt+1
    
    if (v=="NbJ"){
      nomFichier <- paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/Graph/NbJ_ASSEC_HER97_",methode,"_",jour,"_",annee,"_new_meteo_HYDRO_ONLY.png",sep="")
      plotvar <- data[,(5+compt)] # Nbj Assec
      classe <- c(0, 0.1, 30, 60, 90, 160)
      couleur <- "YlOrRd"
      nomLegend <- c("0","0 - 30","30 - 60","60 - 90","90 - 160")
      titreLegend <- paste("NbJ Assec ", annee, sep="")
    } else if (v=="Diff") {
      nomFichier <- paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/Graph/Diff_prop_ASSEC_HER97_",methode,"_",jour,"_new_meteo_HYDRO_ONLY.png",sep="")
      plotvar <- data[,4]-data[,5] # Diff prop assec
      classe <- c(-50, -20, -5, 5, 20, 50)
      couleur <- "RdBu"
      nomLegend <- c("< -20","-20 ; -5","-5 ; 5","5 ; 20","20 ; 50")
      titreLegend <- "Diff (Apred-Asim)  "
    } else if (v=="Prop") {
      nomFichier <- paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/Graph/Proportion_ASSEC_2012-2016_HER97_",methode,"_",jour,"_new_meteo_HYDRO_ONLY.png",sep="")
      plotvar <- data[,4] # prop assec pred
      classe <- c(0, 20, 40, 60, 80, 100)
      couleur <- "RdBu"
      nomLegend <- c("0 - 20","20 - 40","40 - 60","60 - 80","80 - 100")
      titreLegend <- "Prop Apred 2012-2016  "
    }
    
    png(file = nomFichier, width = 20, height = 20, units = "cm", res=1000)
    contour_HER <- readOGR(dsn = "C:/Users/aurelien.beaufort/Documents/SIG/HER", layer = "HER97_group")
    # class(contour_HER)
    # contour_HER@proj4string
    contour_HER <- spTransform(contour_HER, CRS("+init=epsg:2154"))
    
    plot(contour_HER, col = "#FFFFFF", border = "black", lwd = 1)
    par(mar = c(0, 0, 0, 0))
    contour_France <- readOGR(dsn = "C:/Users/aurelien.beaufort/Documents/SIG/contour_France", layer = "contour_France_L2E")
    contour_France2 <- readOGR(dsn = "C:/Users/aurelien.beaufort/Documents/SIG/contour_France", layer = "contour_France_L93")
    
    # contour_France@proj4string
    plot(contour_France2, col = "#E6E6E6", border = "#CCCCCC", lwd = 1, add=TRUE)
    plot(contour_HER, col = "#FFFFFF", border = "#CCCCCC", lwd = 1, add=TRUE)
    
    # points(data[,2],data[,3], pch=5, col = "black", add=TRUE)
    
    # Conversion des donnees en objet spatial ponctuel avec une table d'attributs
    dat<-SpatialPointsDataFrame(coords = data[,2:3], data = data[,c(1, 4:10)])
    
    # Definition du systeme (WGS84)
    prj <- CRS("+init=epsg:27572")
    
    # Attribution de ce systeme aux donnees
    dat@proj4string <- prj
    dat <- spTransform(dat, CRS("+init=epsg:2154")) # transformation en L2E
    plot(dat, col = "black", pch=1, lwd = 1, add=TRUE)
    
    cols <- carto.pal(pal1 = "green.pal", n1 = 2, pal2 = "red.pal",n2 = 3)
    
    nclr <- 5
    plotclr <- brewer.pal(nclr,couleur)
    
    if (v=="Prop") {
      plotclr <- plotclr[nclr:1] # réeordonne les couleurs
    }
    
    class <- classIntervals(plotvar, nclr, style="fixed", fixedBreaks = classe) # 
    colcode <- findColours(class, plotclr)
    plot(dat,col = colcode, pch=19, lwd = 1, add=TRUE)
    # locator(n=1)
    
    
    legend(526722.6,6554350, legend=nomLegend,
           fill=attr(colcode, "palette"), cex=1, bty="n", title= titreLegend) # 
    
    # map.scale(x=465552.7, y=6482533, ratio=FALSE, relwidth=0.01, metric =T, cex=0.8)
    Scalebar(449474.3, 6472886, 50000, unit = "km", scale = 0.001, t.cex = 1)
    north.arrow(xb=554519.9, yb=6563644, len = 3000, lab = "N", cex.lab = 0.8, col='gray10')
    par(mar = c(0, 0, 0, 0))
    dev.off()
  }
}
