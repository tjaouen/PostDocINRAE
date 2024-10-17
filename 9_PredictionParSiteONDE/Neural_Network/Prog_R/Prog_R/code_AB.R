panel.cor <- function(x, y, digits = 2, prefix = "", cex.cor=2, ...)
{
   usr <- par("usr"); on.exit(par(usr))
   par(usr = c(0, 1, 0, 1))
   r <- cor(x, y,method="kendall",use="pairwise")
   txt <- format(c(r, 0.123456789), digits = digits)[1]
   txt <- paste0(prefix, txt)
   #if(missing(cex.cor)) cex.cor <- 1.5/strwidth(txt)
   test <- cor.test(x,y,method="kendall",use="pairwise")
   if (test$p.value < 0.05)
       text(0.5, 0.5, txt, cex = cex.cor)
}


pwm01.homoreg.cv <- function(nreg,nfold,y,x,mu.bw=NULL){
   lnreg <- length(nreg)
   m <- length(x)
   n <- nrow(y)
   lfold <- floor(m/nfold)
   cat("Performing cross-validation with ", nfold, " folds of approximate size ",lfold, "\n")


   rid <- sample(m,m) # shuffle data

   negloglike <- matrix(nrow=nfold, ncol=lnreg)
   msqe <- negloglike
   statAD <- negloglike

   for (k in 1:nfold){
       if (k < nfold){
           ridk <- rid[(1+(k-1)*lfold):(k*lfold)]
       } else {
           ridk <- rid[(1+(k-1)*lfold):max(k*lfold,m)]
       }

       for (nr in 1:lnreg){
           m.nreg <- pwm01.homoreg(y[,-ridk],x[-ridk],nreg=nreg[nr],
                                   mu.bw = mu.bw)
           m.nreg.valid <- pwm01.homoreg.interp(m.nreg,x[ridk])

            # evaluation of cost fcts for each model
           ys <- as.vector(apply(y[,ridk]/matrix(m.nreg.valid$mu0,n,length(ridk),
                                                 byrow=TRUE),2, sort))
           shapes <-as.vector(matrix(m.nreg.valid$shape,n,length(ridk),byrow=TRUE))
           scales <- as.vector(matrix(1-m.nreg.valid$shape,n,length(ridk),byrow=TRUE))

           # neg-log-like
           nlls.nr <- try(sum(dgpd(ys,loc=0,
                                   scale=scales,
                                   shape=shapes,
                                   log.d=TRUE)))
           if (class(nlls.nr) == "numeric")
               negloglike[k,nr] <- -nlls.nr

           # AD stat
           ad <- try(ad.test(ys,"pgpd",
                             scale=scales,
                             shape=shapes))

           if (class(ad) == "htest")
               statAD[k,nr] <- ad$stat

            # quantile SSE
           qths <- try(qgpd(rep(ppoints(n),length(ridk)),loc=0,scale=scales,
                            shape=shapes))
           if (class(qths) == "numeric")
               msqe[k,nr] <- sum((ys-qths)^2)

       }  # nreg loop
   } # nfold loop

   list(negloglike=negloglike, msqe=msqe,statAD=statAD)
}
