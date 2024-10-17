### Import ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")

source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_ProjectionSurFDCApprise.R")

folder_input_ = folder_input_param_
obsSim_ = obsSim_param_
nom_categorieSimu_ = nom_categorieSimu_param_
nom_GCM_ = nom_GCM_param_

### Librairies ###
library(doParallel)
library(strex)


files_FDC_ref_ = list.files(paste0(folder_input_,
                                   "FlowDurationCurves/",
                                   ifelse(obsSim_=="","",paste0("FDC_",obsSim_,"/")),
                                   ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),
                                   ifelse(nom_GCM_=="","",nom_GCM_)), full.names = T)

tab_FDC_ref_ = read.table(files_FDC_ref_[1], sep = ";", dec = ".", header = T)


# 365*(2019-1976+1)+365*(2005-1976+1)+365*(96)
dim(tab_FDC_ref_)




# Convertir la colonne "Date" en format Date
tab_FDC_ref_sample_ <- tab_FDC_ref_
tab_FDC_ref_sample_ <- tab_FDC_ref_sample_[order(tab_FDC_ref_sample_$FreqNonDep),]
sampled_data <- tab_FDC_ref_sample_[seq(1, nrow(tab_FDC_ref_sample_), length.out = 10000), ]

# Convertir la colonne "Date" en format Date
tab_FDC_ref_interp_ <- tab_FDC_ref_
interpolated_data <- approx(sort(tab_FDC_ref_interp_$FreqNonDep), n = 10000)

x11()
plot(tab_FDC_ref_sample_$FreqNonDep ~ tab_FDC_ref_sample_$Date)
line(sampled_data$FreqNonDep ~ sampled_data$Date, col = "blue")
line(interpolated_data$FreqNonDep ~ interpolated_data$Date, col = "red")



library(hydroTSM)
library(ggplot2)
library(zoo)

fdc(tab_FDC_ref_$Debit)

x11()
fdc_ = fdc(tab_FDC_ref_$Debit)

plot(fdc_)




dc.plot <- fdc_

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





lQ.thr=0.7
hQ.thr=0.2
plot=TRUE
log="y"
main="Flow Duration Curve"
xlab="% Time flow equalled or exceeded"
ylab="Q, [m3/s]"
ylim=NULL
yat=c(0.01, 0.1, 1)
xat=c(0.01, 0.025, 0.05)
#yaxp=c(range(x),2),
col="black"
pch=1
lwd=1
lty=1
cex=0.4
cex.axis=1.2
cex.lab=1.2
leg.txt=NULL
leg.cex=1
leg.pos="topright"
verbose= TRUE
thr.shw=TRUE
new=TRUE

Qposition <- function(x, Q) {
  Q.dist  <- abs(x - Q)
  Q.index <- which.min( Q.dist )
  return(Q.index)
} # end


# If a new plot has to be created
x <- tab_FDC_ref_$Debit

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

dc <- dc/n

dc.plot <- dc

plot(dc.plot, x,  xaxt = "n", yaxt = "n", type="o", col=col, pch=pch, lwd=lwd, lty=lty,
       cex=cex, cex.axis=cex.axis, cex.lab=cex.lab, main=main, xlab=xlab, ylab=ylab, ylim=ylim, log=log)




# Y axis: Drawing the ticks and labels
ylabels <- pretty(ylim)
if ( (log=="y") | (log=="xy") | (log=="yx") ) {            
  ylabels <- union( yat, ylabels )            
} # IF end
axis( side = 2, at =ylabels, cex.axis=cex.axis, labels = ylabels)

# X axis: Drawing the ticks and labels
xpos    <- seq(0.0, 1, by=0.05)
xlabels <- seq(0.0, 1, by=0.1)
if ( (log=="x") | (log=="xy") | (log=="yx") ) {            
  xpos    <- union( xat, xpos ) 
  xlabels <- union( xat, xlabels )            
} # IF end
axis(side = 1, at = xpos, cex.axis=cex.axis, labels = FALSE)
axis(side = 1, at = xlabels, cex.axis=cex.axis, labels = paste(100*xlabels,"%", sep="") )               

# If the user provided a value for 'lQ.thr', a vertical line is drawn
if ( !is.na(lQ.thr) ) abline(v=lQ.thr, col="grey", lty=3, lwd=2)

# If the user provided a value for 'hQ.thr', a vertical line is drawn
if ( !is.na(hQ.thr) ) abline(v=hQ.thr, col="grey", lty=3, lwd=2)

# Drawing a legend. bty="n" => no border
if ( !is.null(leg.txt) )
  legend(x=leg.pos, legend=leg.txt, cex=leg.cex, col=col, pch=pch, lwd=lwd, lty=lty, bty="n") # cex=cex*1.5,

if (thr.shw) {
  # Finding the flow values corresponding to the 'lQ.thr' and 'hQ.thr' pbb of excedence
  x.lQ <- x[Qposition(dc.plot, lQ.thr)]
  x.hQ <- x[Qposition(dc.plot, hQ.thr)]
  
  legend("bottomleft", c(paste("Qhigh.thr=", round(x.hQ, 2), sep=""),
                         paste("Qlow.thr=", round(x.lQ, 2), sep="") ),
         cex=0.8, bty="n") #bty="n" => no box around the legend
} # IF end




x11()
plot(sampled_data$FreqNonDep, col = "red")
plot(interpolated_data$y)


# If a new plot has to be created
x <- sampled_data$Debit

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

dc <- dc/n

dc.plot <- dc

plot(dc.plot, x,  xaxt = "n", yaxt = "n", type="o", col=col, pch=pch, lwd=lwd, lty=lty,
     cex=cex, cex.axis=cex.axis, cex.lab=cex.lab, main=main, xlab=xlab, ylab=ylab, ylim=ylim, log=log)
