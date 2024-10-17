rm(list=ls(all=TRUE))

#require(maptools)
library(sf)
library(maps)
library(mapdata)
library(stringr)
library(png)
library(terra)

data_dir = paste0("C:\\Users\\esauquet\\Desktop\\Explore2\\Intermittence\\Tab_ChroniquesProba_LearnBrut_ByHer\\FDC_Projections\\GRSD_20231128")
setwd(data_dir)
# statInterm <- read.table("resulND.csv",sep=";",header=T)
# nameVariable <- "ND10"
statInterm <- read.table("resul.csv",sep=";",header=T)
nameVariable <- "ProbAssec"
# statInterm <- read.table("resulStart.csv",sep=";",header=T)
# nameVariable <- "Start"
#statInterm <- read.table("resulEnd.csv",sep=";",header=T)
#nameVariable <- "End"

all_chain_dirs <- c("ICHEC-EC-EARTH_rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT", #"EC-EARTH_HadREM3-GA7",
                    "CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT", #"CNRM-CM5_ALADIN63",   
                    "MOHC-HadGEM2-ES_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT", # "HadGEM2-ES_CCLM4-8-17"
                    "MOHC-HadGEM2-ES_rcp85_r1i1p1_CNRM-ALADIN63_v2_MF-ADAMONT") #"HadGEM2-ES_ALADIN63"
colTraject <- c("#E2A13B","#E5E840","#70194E","#447C57")

# SOUS selection admont
statInterm <- statInterm[grepl("ADAMONT",statInterm$GCM.RCM.BC),]
ssSelection <- "_Adamont"
# statInterm <- statInterm[grepl("MOHC-HadGEM2-ES_rcp85_r1i1p1_CNRM-ALADIN63_v2_MF-ADAMONT",statInterm$GCM.RCM.BC),]
# ssSelection <- "_Vert"
horizon <- "H3"

medianStatIntermH0 <- rep(0,length(statInterm[1,]))
medianStatIntermH2 <- rep(0,length(statInterm[1,]))
medianStatIntermH3 <- rep(0,length(statInterm[1,]))

for (i in 3:length(statInterm[1,])) {
  medianStatIntermH0[i] <- median(statInterm[((1:34)*4-3),i],na.rm=T)
  medianStatIntermH2[i] <- median(statInterm[((1:34)*4-1),i],na.rm=T)
  medianStatIntermH3[i] <- median(statInterm[((1:34)*4),i],na.rm=T)
}

# stats sur 4 zones privilégiées

rbind(
  c(round(min((statInterm$X57[((1:34)*4-3)]),na.rm=T),0)
    ,round(median((statInterm$X57[((1:34)*4-3)]),na.rm=T),0)
    ,round(ma(statInterm$X57[((1:34)*4-3)]),na.rm=T),0))
,
c(round(min((statInterm$X57[((1:34)*4-1)]),na.rm=T),0)
  ,round(median((statInterm$X57[((1:34)*4-1)]),na.rm=T),0)
  ,round(ma(statInterm$X57[((1:34)*4-1)]),na.rm=T),0))
,
c(round(min((statInterm$X57[((1:34)*4)]),na.rm=T),0)
  ,round(median((statInterm$X57[((1:34)*4)]),na.rm=T),0)
  ,round(ma(statInterm$X57[((1:34)*4)]),na.rm=T),0))
,
c(round(min((statInterm$X81[((1:34)*4-3)]),na.rm=T),0)
  ,round(median((statInterm$X81[((1:34)*4-3)]),na.rm=T),0)
  ,round(ma(statInterm$X81[((1:34)*4-3)]),na.rm=T),0))
,
c(round(min((statInterm$X81[((1:34)*4-1)]),na.rm=T),0)
  ,round(median((statInterm$X81[((1:34)*4-1)]),na.rm=T),0)
  ,round(ma(statInterm$X81[((1:34)*4-1)]),na.rm=T),0))
,
c(round(min((statInterm$X81[((1:34)*4)]),na.rm=T),0)
  ,round(median((statInterm$X81[((1:34)*4)]),na.rm=T),0)
  ,round(ma(statInterm$X81[((1:34)*4)]),na.rm=T),0))
,
c(round(min((statInterm$X13[((1:34)*4-3)]),na.rm=T),0)
  ,round(median((statInterm$X13[((1:34)*4-3)]),na.rm=T),0)
  ,round(ma(statInterm$X13[((1:34)*4-3)]),na.rm=T),0))
,
c(round(min((statInterm$X13[((1:34)*4-1)]),na.rm=T),0)
  ,round(median((statInterm$X13[((1:34)*4-1)]),na.rm=T),0)
  ,round(ma(statInterm$X13[((1:34)*4-1)]),na.rm=T),0))
,
c(round(min((statInterm$X13[((1:34)*4)]),na.rm=T),0)
  ,round(median((statInterm$X13[((1:34)*4)]),na.rm=T),0)
  ,round(ma(statInterm$X13[((1:34)*4)]),na.rm=T),0))
,
c(round(min((statInterm$X105[((1:34)*4-3)]),na.rm=T),0)
  ,round(median((statInterm$X105[((1:34)*4-3)]),na.rm=T),0)
  ,round(ma(statInterm$X105[((1:34)*4-3)]),na.rm=T),0))
,
c(round(min((statInterm$X105[((1:34)*4-1)]),na.rm=T),0)
  ,round(median((statInterm$X105[((1:34)*4-1)]),na.rm=T),0)
  ,round(ma(statInterm$X105[((1:34)*4-1)]),na.rm=T),0))
,
c(round(min((statInterm$X105[((1:34)*4)]),na.rm=T),0)
  ,round(median((statInterm$X105[((1:34)*4)]),na.rm=T),0)
  ,round(ma(statInterm$X105[((1:34)*4)]),na.rm=T),0))
)

setwd("C:\\Users\\esauquet\\Desktop\\Explore2\\Theo\\selection\\Resultat")
reseau = st_read("reseauReferenceHYDRO_20230425.shp")
reseau = st_union(reseau)
reseau = st_transform(reseau, 2154)

setwd("C:\\Users\\esauquet\\Desktop\\Explore2\\Theo\\selection\\SIG")
france = st_read("gadm36_FRA_0.shp")
france = st_union(france)
frLambert = st_transform(france, 2154)

setwd(paste0("C:\\Users\\esauquet\\Desktop\\Explore2\\Intermittence\\"))
HER2 = st_transform(st_read("HER2_hybrides.shp"), 2154)

x <- vect("HER2_hybrides.shp")
x$area_sqkm <- expanse(x) / 1000000

col.palette <- colorRampPalette(
  rev(c("#543005","#8c510a","#bf812d","#dfc27d","#f6e8c3","#c7eae5","#80cdc1","#35978f","#01665e","#003c30")))

if (nameVariable=="Start"|nameVariable=="End") {
  col.palette <- colorRampPalette((c('#ffffe5','#fff7bc','#fee391','#fec44f','#fe9929','#ec7014','#cc4c02','#993404','#993404','#993404','#993404','#662506','#662506','#662506','#662506')))
  ncolor <- 275
}
if (nameVariable=="End") {
  col.palette <- colorRampPalette(rev(c('#ffffe5','#fff7bc','#fee391','#fec44f','#fe9929','#ec7014','#cc4c02','#993404','#993404','#993404','#993404','#662506','#662506','#662506','#662506')))
  ncolor <- 275
}

if (nameVariable=="ProbAssec") {
  ncolor <- 70}
if (nameVariable=="ND10") {
  ncolor <- 200}

ccol <- col.palette(ncolor)

colHER2 <- rep(NA,length(HER2$NomHER2))

for (i in 1:length(HER2$NomHER2)) {
  if (HER2$CdHER2[i]==31) {
    HER2$CdHER2[i]=31033039}
  if (HER2$CdHER2[i]==33) {
    HER2$CdHER2[i]=31033039}
  if (HER2$CdHER2[i]==39) {
    HER2$CdHER2[i]=31033039}
  
  if (HER2$CdHER2[i]==37) {
    HER2$CdHER2[i]=37054}
  if (HER2$CdHER2[i]==54) {
    HER2$CdHER2[i]=37054}
  
  if (HER2$CdHER2[i]==69) {
    HER2$CdHER2[i]=69096}
  if (HER2$CdHER2[i]==96) {
    HER2$CdHER2[i]=69096}
  
  if (HER2$CdHER2[i]==89) {
    HER2$CdHER2[i]=89092}
  if (HER2$CdHER2[i]==92) {
    HER2$CdHER2[i]=89092}  
  
  if (HER2$CdHER2[i]==49) {
    HER2$CdHER2[i]=49090}
  if (HER2$CdHER2[i]==90) {
    HER2$CdHER2[i]=49090}  
  
  if (length(which(HER2$CdHER2[i]==as.integer(substr(colnames(statInterm),2,10))))>0) {
    i0 <- which(HER2$CdHER2[i]==as.integer(substr(colnames(statInterm),2,10)))
    
    if (nameVariable=="Start"|nameVariable=="End") {
      if (horizon=="H0")  {colHER2[i] <- ccol[min(ma1,round((medianStatIntermH0[i0]-90),0)),ncolor)]}
      if (horizon=="H2")  {colHER2[i] <- ccol[min(ma1,round((medianStatIntermH2[i0]-90),0)),ncolor)]}
      if (horizon=="H3")  {colHER2[i] <- ccol[min(ma1,round((medianStatIntermH3[i0]-90),0)),ncolor)]}
    } else {
      if (horizon=="H0")  {colHER2[i] <- ccol[min(ma1,round(medianStatIntermH0[i0],0)),ncolor)]}
      if (horizon=="H2")  {colHER2[i] <- ccol[min(ma1,round(medianStatIntermH2[i0],0)),ncolor)]}
      if (horizon=="H3")  {colHER2[i] <- ccol[min(ma1,round(medianStatIntermH3[i0],0)),ncolor)]}
    }
  }}

# fr.prj$CdHER2[which(fr.prj$CdHER2 == 37)] = "37+54"
# fr.prj$CdHER2[which(fr.prj$CdHER2 == 54)] = "37+54"
# fr.prj$CdHER2[which(fr.prj$CdHER2 == 69)] = "69+96"
# fr.prj$CdHER2[which(fr.prj$CdHER2 == 96)] = "69+96"
# fr.prj$CdHER2[which(fr.prj$CdHER2 == 31)] = "31+33+39"
# fr.prj$CdHER2[which(fr.prj$CdHER2 == 33)] = "31+33+39"
# fr.prj$CdHER2[which(fr.prj$CdHER2 == 39)] = "31+33+39"

#png(paste("HER_Intermittence_",horizon,"_",nameVariable,ssSelection,".png",sep=""),width = 1600, height = 1600,
png(paste("HER_Intermittence_",horizon,"_",nameVariable,ssSelection,".png",sep=""),width = 1600, height = 1600,
    units = "px", pointsize = 12)
rappSize = 3.5

plot(frLambert,lwd=1.5*rappSize,border=
       "black",axes=F)
     
rappSize = 3

plot(HER2,lwd=1.1*rappSize,border="black",add=T,col=colHER2)

rappSize = 3


# text(120000-20000,7050000+295/733*150000, "NJ(P>10%)",cex=8,pos=4,col= "black",font=2)
# text(120000-20000,7050000+295/733*150000, "Prop. Assec",cex=8,pos=4,col= "black",font=2)
# text(120000-20000,7050000+295/733*150000-60000, "Analyse multi-modèle sous RCP8.5",cex=2.5,
#      pos=4,col= "black")
# text(120000-20000,7050000+295/733*150000-100000, "Période : 1976-2005",cex=2.5,pos=4,col= "black")
#text(120000-20000,7050000+295/733*150000-100000, "Période : 2041-2070",cex=2.5,pos=4,col= "black")
#text(120000-20000,7050000+295/733*150000-100000, "Période : 2070-2099",cex=2.5,pos=4,col= "black")
# Picture<-readPNG("C:\\Users\\esauquet\\Desktop\\Explore2\\2024_data\\explore2_logo_color.png")
# rasterImage(Picture,950000,7050000,1250000,7050000+295/733*300000)

# text(60000,6190000-50000+0,expression("Nombre de jours avec une "),
#      cex=3,pos=4,col="black")
# text(60000,6190000-50000-50000,expression("probabilité > 10% par an"),
#      cex=3,pos=4,col="black")

xminpanel <-100000
xmaxpanel <- 450000
yminpanel <- 6200000-50000-90000+20000-50000
ymaxpanel <- 6200000-50000-50000+20000-50000
ecarttext <- 30000

if (nameVariable=="Start"|nameVariable=="End") {
  text(80000,6200000-50000-50000,expression("Jour de l'année"),
       cex=4,pos=4,col="black")
  text(xminpanel+(xmaxpanel-xminpanel)/ncolor,
       yminpanel-ecarttext,label="01/04",cex=4)
  text(xminpanel+(ncolor-1)*(xmaxpanel-xminpanel)/ncolor,
       #     yminpanel-ecarttext,label=paste("> ",as.character(ncolor),sep=" "),cex=3)
       yminpanel-ecarttext,label=paste("31/12",sep=" "),cex=4)
  text(xminpanel+(ncolor-1)*(xmaxpanel-xminpanel)/ncolor*91/275,
       #     yminpanel-ecarttext,label=paste("> ",as.character(ncolor),sep=" "),cex=3)
       yminpanel-ecarttext,label=paste("01/07",sep=" "),cex=4)
  text(xminpanel+(ncolor-1)*(xmaxpanel-xminpanel)/ncolor*2*91/275,
       #     yminpanel-ecarttext,label=paste("> ",as.character(ncolor),sep=" "),cex=3)
       yminpanel-ecarttext,label=paste("01/10",sep=" "),cex=4)
} else {
  text(xminpanel+(xmaxpanel-xminpanel)/ncolor,
       yminpanel-ecarttext,label=0,cex=4)
  text(xminpanel+(ncolor-1)*(xmaxpanel-xminpanel)/ncolor,
       yminpanel-ecarttext,label=paste("> ",as.character(ncolor),sep=" "),cex=4)
}


if (nameVariable=="ProbAssec") {
  text(80000,6200000-50000-50000,expression("Proportion "),
       cex=4,pos=4,col="black")}
if (nameVariable=="ND10") {
  text(80000,6200000-50000-50000,expression("Nombre de jours "),
       cex=4,pos=4,col="black")}

for (ik in 1:ncolor) {
  rect(xminpanel+(ik-1)*(xmaxpanel-xminpanel)/ncolor,yminpanel,
       xminpanel+ik*(xmaxpanel-xminpanel)/ncolor,ymaxpanel,col=ccol[ik]
       ,border=NA)
}

rect(xminpanel,yminpanel, xmaxpanel,ymaxpanel,col=NA,border="black")

# points(80000,6190000-50000-50000,pch=21,col="black",
#        bg= rgb(215/255,25/255,28/255),cex=5,lwd=2)
# text(80000+15000,6190000-50000-50000,expression("1"),
#      cex=3,pos=4,col=rgb(0/255,122/255,146/255))
#
# points(80000,6190000-50000-100000,pch=21,col="black",
#        bg= rgb(253/255,174/255,97/255),cex=5,lwd=2)
# #text(80000+10000,6190000-50000-50000,"> 50 Mm3",cex=3,pos=4,col=rgb(0/255,122/255,146/255))
# text(80000+15000,6190000-50000-100000,expression(paste("2 ou 3")),
#      cex=3,pos=4,col=rgb(0/255,122/255,146/255),lwd=2)
#
# points(280000,6190000-50000-50000,pch=21,col="black",
#        bg= rgb(255/255,255/255,191/255),cex=5,lwd=2)
# text(280000+15000,6190000-50000-50000,expression("4 ou 5"),
#      cex=3,pos=4,col=rgb(0/255,122/255,146/255))
#
# points(280000,6190000-50000-100000,pch=21,col="black",
#        bg= rgb(171/255,217/255,233/255),cex=5,lwd=2)
# text(280000+15000,6190000-50000-100000,expression(paste("6 et plus")),
#      cex=3,pos=4,col=rgb(0/255,122/255,146/255))

segments(700000,6200000-200000,900000,6200000-200000,lwd=5,col="black")
segments(700000,6200000-200000,700000,6200000-200000+10000,lwd=5,col="black")
segments(900000,6200000-200000,900000,6200000-200000+10000,lwd=5,col="black")
text(700000,6200000-200000+40000,"0",cex=4,col="black")
text(900000,6200000-200000+40000,"200 km",cex=4,col="black")


dev.off()