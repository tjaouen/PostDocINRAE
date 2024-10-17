wd<-'F:/ActionAgenceBottomUp/Scripts/IndiceSecheresse/Scores/outputs_Mod2005-2013OBSvsSIMvsAP/Final/'
nYear<<-9
yearMin<<-2005
yearMax<<-2013

####
bv1<- 'Y5032010 - Argens'
AP1<-read.table(paste( wd, 'Y5032010 - Argens/AP/Y5032010APdecadeAMJJASO.txt', sep=""), header = F, sep="")
AP1<-as.matrix(AP1);AP1<-as.vector(AP1); 
HYDRO1<-read.table(paste( wd, 'Y5032010 - Argens/HYDRO/Y5032010ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
HYDRO1<-as.matrix(HYDRO1); HYDRO1<-as.vector(HYDRO1)
GR6J1<-read.table(paste( wd, 'Y5032010 - Argens/GR6J/Y5032010ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
GR6J1<-as.matrix(GR6J1); GR6J1<-as.vector(GR6J1)

####
bv2<- 'X1424010 - Asse'
AP2<-read.table(paste( wd, 'X1424010 - Asse/AP/X1424010APdecadeAMJJASO.txt', sep=""), header = F, sep="")
AP2<-as.matrix(AP2);AP2<-as.vector(AP2); 
HYDRO2<-read.table(paste( wd, 'X1424010 - Asse/HYDRO/X1424010ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
HYDRO2<-as.matrix(HYDRO2); HYDRO2<-as.vector(HYDRO2)
GR6J2<-read.table(paste( wd, 'X1424010 - Asse/GR6J/X1424010ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
GR6J2<-as.matrix(GR6J2); GR6J2<-as.vector(GR6J2)

####
bv3<- 'W2314010 - Bonne'
AP3<-read.table(paste( wd, 'W2314010 - Bonne/AP/W2314010APdecadeAMJJASO.txt', sep=""), header = F, sep="")
AP3<-as.matrix(AP3);AP3<-as.vector(AP3); 
HYDRO3<-read.table(paste( wd, 'W2314010 - Bonne/HYDRO/W2314010ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
HYDRO3<-as.matrix(HYDRO3); HYDRO3<-as.vector(HYDRO3)
GR6J3<-read.table(paste( wd, 'W2314010 - Bonne/GR6J/W2314010ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
GR6J3<-as.matrix(GR6J3); GR6J3<-as.vector(GR6J3)

####
bv4<- 'V1774010 - Bourbe'
AP4<-read.table(paste( wd, 'V1774010 - Bourbe/AP/V1774010APdecadeAMJJASO.txt', sep=""), header = F, sep="")
AP4<-as.matrix(AP4);AP4<-as.vector(AP4); 
HYDRO4<-read.table(paste( wd, 'V1774010 - Bourbe/HYDRO/V1774010ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
HYDRO4<-as.matrix(HYDRO4); HYDRO4<-as.vector(HYDRO4)
GR6J4<-read.table(paste( wd, 'V1774010 - Bourbe/GR6J/V1774010ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
GR6J4<-as.matrix(GR6J4); GR6J4<-as.vector(GR6J4)

####
bv5<- 'X1034020 - Buech'
AP5<-read.table(paste( wd, 'X1034020 - Buech/AP/X1034020APdecadeAMJJASO.txt', sep=""), header = F, sep="")
AP5<-as.matrix(AP5);AP5<-as.vector(AP5); 
HYDRO5<-read.table(paste( wd, 'X1034020 - Buech/HYDRO/X1034020ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
HYDRO5<-as.matrix(HYDRO5); HYDRO5<-as.vector(HYDRO5)
GR6J5<-read.table(paste( wd, 'X1034020 - Buech/GR6J/X1034020ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
GR6J5<-as.matrix(GR6J5); GR6J5<-as.vector(GR6J5)

####
bv6<- 'Y5105010 - Caramy'
AP6<-read.table(paste( wd, 'Y5105010 - Caramy/AP/Y5105010APdecadeAMJJASO.txt', sep=""), header = F, sep="")
AP6<-as.matrix(AP6);AP6<-as.vector(AP6); 
HYDRO6<-read.table(paste( wd, 'Y5105010 - Caramy/HYDRO/Y5105010ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
HYDRO6<-as.matrix(HYDRO6); HYDRO6<-as.vector(HYDRO6)
GR6J6<-read.table(paste( wd, 'Y5105010 - Caramy/GR6J/Y5105010ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
GR6J6<-as.matrix(GR6J6); GR6J6<-as.vector(GR6J6)

####
bv7<- 'V4214010 - Drome'
AP7<-read.table(paste( wd, 'V4214010 - Drome/AP/V4214010APdecadeAMJJASO.txt', sep=""), header = F, sep="")
AP7<-as.matrix(AP7);AP7<-as.vector(AP7); 
HYDRO7<-read.table(paste( wd, 'V4214010 - Drome/HYDRO/V4214010ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
HYDRO7<-as.matrix(HYDRO7); HYDRO7<-as.vector(HYDRO7)
GR6J7<-read.table(paste( wd, 'V4214010 - Drome/GR6J/V4214010ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
GR6J7<-as.matrix(GR6J7); GR6J7<-as.vector(GR6J7)

####
bv8<- 'V4264010 - Drome'
AP8<-read.table(paste( wd, 'V4264010 - Drome/AP/V4264010APdecadeAMJJASO.txt', sep=""), header = F, sep="")
AP8<-as.matrix(AP8);AP8<-as.vector(AP8); 
HYDRO8<-read.table(paste( wd, 'V4264010 - Drome/HYDRO/V4264010ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
HYDRO8<-as.matrix(HYDRO8); HYDRO8<-as.vector(HYDRO8)
GR6J8<-read.table(paste( wd, 'V4264010 - Drome/GR6J/V4264010ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
GR6J8<-as.matrix(GR6J8); GR6J8<-as.vector(GR6J8)

####
bv9<- 'Y2102010 - Herault'
AP9<-read.table(paste( wd, 'Y2102010 - Herault/AP/Y2102010APdecadeAMJJASO.txt', sep=""), header = F, sep="")
AP9<-as.matrix(AP9);AP9<-as.vector(AP9); 
HYDRO9<-read.table(paste( wd, 'Y2102010 - Herault/HYDRO/Y2102010ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
HYDRO9<-as.matrix(HYDRO9); HYDRO9<-as.vector(HYDRO9)
GR6J9<-read.table(paste( wd, 'Y2102010 - Herault/GR6J/Y2102010ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
GR6J9<-as.matrix(GR6J9); GR6J9<-as.vector(GR6J9)

####
bv10<- 'O7041510 - Lot'
AP10<-read.table(paste( wd, 'O7041510 - Lot/AP/O7041510APdecadeAMJJASO.txt', sep=""), header = F, sep="")
AP10<-as.matrix(AP10);AP10<-as.vector(AP10); 
HYDRO10<-read.table(paste( wd, 'O7041510 - Lot/HYDRO/O7041510ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
HYDRO10<-as.matrix(HYDRO10); HYDRO10<-as.vector(HYDRO10)
GR6J10<-read.table(paste( wd, 'O7041510 - Lot/GR6J/O7041510ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
GR6J10<-as.matrix(GR6J10); GR6J10<-as.vector(GR6J10)

####
bv11<- 'U1324010 - Ouche'
AP11<-read.table(paste( wd, 'U1324010 - Ouche/AP/U1324010APdecadeAMJJASO.txt', sep=""), header = F, sep="")
AP11<-as.matrix(AP11);AP11<-as.vector(AP11);
HYDRO11<-read.table(paste( wd, 'U1324010 - Ouche/HYDRO/U1324010ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
HYDRO11<-as.matrix(HYDRO11); HYDRO11<-as.vector(HYDRO11)
GR6J11<-read.table(paste( wd, 'U1324010 - Ouche/GR6J/U1324010ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
GR6J11<-as.matrix(GR6J11); GR6J11<-as.vector(GR6J11)

####
bv12<- 'W2335210 - Roizonne'
AP12<-read.table(paste( wd, 'W2335210 - Roizonne/AP/W2335210APdecadeAMJJASO.txt', sep=""), header = F, sep="")
AP12<-as.matrix(AP12);AP12<-as.vector(AP12);
HYDRO12<-read.table(paste( wd, 'W2335210 - Roizonne/HYDRO/W2335210ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
HYDRO12<-as.matrix(HYDRO12); HYDRO12<-as.vector(HYDRO12)
GR6J12<-read.table(paste( wd, 'W2335210 - Roizonne/GR6J/W2335210ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
GR6J12<-as.matrix(GR6J12); GR6J12<-as.vector(GR6J12)

####
bv13<- 'V4414010 - Roubion'
AP13<-read.table(paste( wd, 'V4414010 - Roubion/AP/V4414010APdecadeAMJJASO.txt', sep=""), header = F, sep="")
AP13<-as.matrix(AP13);AP13<-as.vector(AP13);
HYDRO13<-read.table(paste( wd, 'V4414010 - Roubion/HYDRO/V4414010ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
HYDRO13<-as.matrix(HYDRO13); HYDRO13<-as.vector(HYDRO13)
GR6J13<-read.table(paste( wd, 'V4414010 - Roubion/GR6J/V4414010ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
GR6J13<-as.matrix(GR6J13); GR6J13<-as.vector(GR6J13)

####
bv14<- 'O3011010 - Tarn'
AP14<-read.table(paste( wd, 'O3011010 - Tarn/AP/O3011010APdecadeAMJJASO.txt', sep=""), header = F, sep="")
AP14<-as.matrix(AP14);AP14<-as.vector(AP14);
HYDRO14<-read.table(paste( wd, 'O3011010 - Tarn/HYDRO/O3011010ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
HYDRO14<-as.matrix(HYDRO14); HYDRO14<-as.vector(HYDRO14)
GR6J14<-read.table(paste( wd, 'O3011010 - Tarn/GR6J/O3011010ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
GR6J14<-as.matrix(GR6J14); GR6J14<-as.vector(GR6J14)

####
bv15<- 'O3031010 - Tarn'
AP15<-read.table(paste( wd, 'O3031010 - Tarn/AP/O3031010APdecadeAMJJASO.txt', sep=""), header = F, sep="")
AP15<-as.matrix(AP15);AP15<-as.vector(AP15);
HYDRO15<-read.table(paste( wd, 'O3031010 - Tarn/HYDRO/O3031010ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
HYDRO15<-as.matrix(HYDRO15); HYDRO15<-as.vector(HYDRO15)
GR6J15<-read.table(paste( wd, 'O3031010 - Tarn/GR6J/O3031010ALERTMOD3decadeAMJJASO_Pcorr.txt', sep=""), header = F, sep="")
GR6J15<-as.matrix(GR6J15); GR6J15<-as.vector(GR6J15)

####
# decade<-cbind( AP1, HYDRO1, GR6J1, AP2, HYDRO2, GR6J2, AP3, HYDRO3, GR6J3, AP4, HYDRO4, GR6J4, AP5, HYDRO5, GR6J5, AP6, HYDRO6, GR6J6,
#                AP7, HYDRO7, GR6J7, AP8, HYDRO8, GR6J8, AP9, HYDRO9, GR6J9, AP10, HYDRO10, GR6J10, AP11, HYDRO11, GR6J11, AP12, HYDRO12, GR6J12,
#                AP13, HYDRO13, GR6J13, AP14, HYDRO14, GR6J14, AP15, HYDRO15, GR6J15)
decade<-cbind( AP15, HYDRO15, GR6J15, AP14, HYDRO14, GR6J14, AP13, HYDRO13, GR6J13, AP12, HYDRO12, GR6J12, AP11, HYDRO11, GR6J11, AP10, HYDRO10, GR6J10,
               AP9, HYDRO9, GR6J9, AP8, HYDRO8, GR6J8, AP7, HYDRO7, GR6J7, AP6, HYDRO6, GR6J6, AP5, HYDRO5, GR6J5, AP4, HYDRO4, GR6J4,
               AP3, HYDRO3, GR6J3, AP2, HYDRO2, GR6J2, AP1, HYDRO1, GR6J1)

# decade[which(is.na(decade))]<-0; ## Remplace les NA par 0="pas de données" dans le code couleurs
if (any(decade==0)==T) {; ## Attention jeu de couleur qui marche slt si suite continue d'alerte, pas si 1,2,4,5...
  if (max(decade)==5) {;
    col.palette  <- colorRampPalette(c("gray30","white","gray","yellow","orange","red"),space="Lab");
    ccol         <- col.palette(6);
  }else if (max(decade)==4) {;
    col.palette  <- colorRampPalette(c("gray30","white","gray","yellow","orange"),space="Lab");
    ccol         <- col.palette(5);
  }else if (max(decade)==3) {;
    col.palette  <- colorRampPalette(c("gray30","white","gray","yellow"),space="Lab");
    ccol         <- col.palette(4);
  }else if (max(decade)==2) {;
    col.palette  <- colorRampPalette(c("gray30","white","gray"),space="Lab");
    ccol         <- col.palette(3);
  }else if (max(decade)==1) {;
    col.palette  <- colorRampPalette(c("gray30","white"),space="Lab");
    ccol         <- col.palette(2);
  };
}else if (any(decade==0)==F) {;
  if (max(decade)==5) {;
    col.palette  <- colorRampPalette(c("white","gray","yellow","orange","red"),space="Lab");
    ccol         <- col.palette(5);
  }else if (max(decade)==4) {;
    col.palette  <- colorRampPalette(c("white","gray","yellow","orange"),space="Lab");
    ccol         <- col.palette(4);
  }else if (max(decade)==3) {;
    col.palette  <- colorRampPalette(c("white","gray","yellow"),space="Lab");
    ccol         <- col.palette(3);
  }else if (max(decade)==2) {;
    col.palette  <- colorRampPalette(c("white","gray"),space="Lab");
    ccol         <- col.palette(2);
  }else if (max(decade)==1) {;
    col.palette  <- colorRampPalette(c("white"),space="Lab");
    ccol         <- col.palette(1);
  }
}


x11()
layout(matrix(c(0,1,0), 1, 3, byrow = F), width = c(1,20,2));
# grid_decade2_fn(mat,nYear,yearMin,yearMax);
image(x=1:(21*nYear),y=1:45,xlab='',ylab='',z=(decade[1:(21*nYear),1:45]),col=ccol,axes=FALSE, main=paste(" "), line=+3);
# axis(side=1,at=(1:(21*nYear)),labels=rep(c('D10','D11','D12','D13','D14','D15','D16','D17','D18','D19','D20','D21','D22','D23','D24','D25','D26','D27','D28','D29','D30'),9),cex.axis=1,tick=FALSE);
axis(side=1,at=c( 1, 6, 11, 16, 1+21, 6+21, 11+21, 16+21, 1+(21)*2, 6+(21)*2, 11+(21)*2, 16+(21)*2, 1+(21)*3 , 6+(21)*3, 11+(21)*3, 16+(21)*3,1+(21)*4, 6+(21)*4, 11+(21)*4, 16+(21)*4,
                  1+(21)*5, 6+(21)*5, 11+(21)*5, 16+(21)*5, 1+(21)*6, 6+(21)*6, 11+(21)*6, 16+(21)*6, 1+(21)*7, 6+(21)*7, 11+(21)*7,16+(21)*7, 1+(21)*8, 6+(21)*8, 11+(21)*8, 16+(21)*8),
     labels=rep(c('10','15','20','25'),9),cex.axis=1,tick=FALSE);
axis(side=1,at=(1:((21*nYear)+1))-0.5,labels=rep('',(21*nYear)+1),cex.axis=0.65,tick=TRUE);
axis(side=3,at= c(1,22,43,64,85,106,127,148,169,190)-0.5,labels=rep('',10),cex.axis=0.65,tick=T);
axis(side=3,at= c(11,32,53,74,95,116,137,158,179),labels=(yearMin:yearMax),cex.axis=1,tick=F);
axis(side=2,las=1,at=1:45,labels= paste(rep(c("OBS","HYDRO","GR6J"),15),sep=""),cex.axis=0.75,tick=F);
axis(side=2,las=1,at=(1:6)-0.5,labels= rep('',6),cex.axis=1,tick=T);
axis(side=4,at= c(1,4,7,10,13,16,19,22,25,28,31,34,37,40,43,46)-0.5, labels = rep("", 16));
axis(side=4,at= c(4,7,10,13,16,19,22,25,28,31,34,37,40,43,46)-2, labels = c('basin n°15', 'basin n°14',
'basin n°13', 'basin n°12', 'basin n°11', 'basin n°10', 'basin n°9', 'basin n°8',
'basin n°7', 'basin n°6','basin n°5', 'basin n°4', 'basin n°3', 'basin n°2', 'basin n°1'),tick=F, las=2);
abline(v=(c(22,43,64,85,106,127,148,169,190)-0.5), lty=2, cex.axis=1)
abline(h=(c(4,7,10,13,16,19,22,25,28,31,34,37,40,43)-0.5), lty=1)
par(fig = c(0, 1, 0, 1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE);  plot(0, 0, type = "n", col="white",bty = "n", xaxt = "n", yaxt = "n");  par(mai=c(0,0,0,0));
# legend("top",legend=paste(bviSTAT,sep=""),bty="n",cex=1.5,xpd = TRUE,horiz=FALSE)
legend("bottom","center",legend=c("NA","","Vigilance","Alert","Alert +","Crisis"),pch=15,cex=1,col=c("gray30","white","gray","yellow","orange","red"),bty="n",xpd = TRUE,horiz=TRUE,inset = c(0,0))

