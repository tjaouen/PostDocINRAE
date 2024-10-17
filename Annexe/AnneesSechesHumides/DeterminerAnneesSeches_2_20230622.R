### Libraries ###
library(ggplot2)

### Matrice Input ###
matriceInput_file_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/15_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrImportOnde_2012_2022_20230607/MatInputModel_ByHERDates__2012_2022_KGESUp0.00_DispSup-1_Obs_Weight_merge.csv"
matriceInput_ = read.table(matriceInput_file_, sep = ",", dec = ".", header = T)
dim(matriceInput_)

### Histogrammes P assec par années ###
x11()
png("/home/tjaouen/Documents/assecs.png",
    width = 1200, height = 750,
    units = "px", pointsize = 12)

par(mfrow = c(3,4))
hist(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2012)],
     breaks = 100,
     xlim = c(0,100),
     ylim = c(0,200))
abline(v = median(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2012)]),
       col = "red")
hist(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2013)],
     breaks = 100,
     xlim = c(0,100),
     ylim = c(0,200))
abline(v = median(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2013)]),
       col = "red")
hist(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2014)],
     breaks = 100,
     xlim = c(0,100),
     ylim = c(0,200))
abline(v = median(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2014)]),
       col = "red")
hist(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2015)],
     breaks = 100,
     xlim = c(0,100),
     ylim = c(0,200))
abline(v = median(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2015)]),
       col = "red")
hist(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2016)],
     breaks = 100,
     xlim = c(0,100),
     ylim = c(0,200))
abline(v = median(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2016)]),
       col = "red")
hist(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2017)],
     breaks = 100,
     xlim = c(0,100),
     ylim = c(0,200))
abline(v = median(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2017)]),
       col = "red")
hist(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2018)],
     breaks = 100,
     xlim = c(0,100),
     ylim = c(0,200))
abline(v = median(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2018)]),
       col = "red")
hist(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2019)],
     breaks = 100,
     xlim = c(0,100),
     ylim = c(0,200))
abline(v = median(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2019)]),
       col = "red")
hist(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2020)],
     breaks = 100,
     xlim = c(0,100),
     ylim = c(0,200))
abline(v = median(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2020)]),
       col = "red")
hist(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2021)],
     breaks = 100,
     xlim = c(0,100),
     ylim = c(0,200))
abline(v = median(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2021)]),
       col = "red")
hist(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2022)],
     breaks = 100,
     xlim = c(0,100),
     ylim = c(0,200))
abline(v = median(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2022)]),
       col = "red")
dev.off()

### Medianes ###
df_ = data.frame(annee = c(2012:2022),
                 medianPassec = c(median(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2012)]),
                                  median(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2013)]),
                                  median(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2014)]),
                                  median(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2015)]),
                                  median(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2016)]),
                                  median(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2017)]),
                                  median(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2018)]),
                                  median(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2019)]),
                                  median(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2020)]),
                                  median(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2021)]),
                                  median(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2022)])))
df_[order(df_$medianPassec),]


x11()
plot(df_$annee,df_$medianPassec)

matriceInput_$Annee = format(as.Date(matriceInput_$Date), "%Y")
matriceInput_[c("Annee","X._Assec")]

x11()
ggplot(df_, aes(x = as.factor(annee), y = medianPassec)) +
  geom_bar(stat = "identity") +
  labs(x = "Année", y = "X._Assec") +
  ggtitle("Barplot par année pour X._Assec") +
  geom_hline(yintercept = 3, linetype = "dashed", color = "red") +
  geom_hline(yintercept = 10, linetype = "dashed", color = "blue")

### Boxplots p Assecs ###
ggplot(matriceInput_, aes(x = as.factor(Annee), y = X._Assec)) +
  geom_boxplot() +
  labs(x = "Année", y = "X._Assec") +
  ggtitle("Boxplot par année pour X._Assec") +
  geom_hline(yintercept = 3, linetype = "dashed", color = "red") +
  geom_hline(yintercept = 10, linetype = "dashed", color = "blue")


hist(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2022)], breaks = 100)
hist(matriceInput_$X._Assec[which(format(as.Date(matriceInput_$Date),"%Y") == 2021)], breaks = 100)

learn_ = c(2012,2015:2020,2022)
test_ = c(2013:2014,2021)

learn_ = c(2013:2014,2017,2019:2022)
test_ = c(2012,2015:2016,2018)

learn_ = c(2012:2016,2018,2021)
test_ = c(2017,2019:2020,2022)

# 2   2013     0.000000
# 3   2014     2.105263
# 10  2021     2.759802

# 1   2012     4.347826
# 5   2016     4.706534
# 4   2015     6.451613
# 7   2018     7.692308

# 9   2020    14.814815
# 6   2017    15.294118
# 8   2019    17.708333
# 11  2022    25.000000




### LIRE NETCDF
SafranNetcdf_ = "/home/tjaouen/Documents/Input/HYDRO/EtudeRMC/Debits/DebitsSimChroniques/J2000_20230308_safran_diagnostic.nc"












