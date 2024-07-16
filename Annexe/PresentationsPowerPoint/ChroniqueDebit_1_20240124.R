library(ggplot2)

chro_ = read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsObserves/DebitsRdata_StationsHydro_20230412/3_Reunion_TxtHorsRMC_RdataRMCetCorr/A402061001_HYDRO_QJM.txt",
                   sep = ";", dec = ".", header = T)


# Convertir la colonne Date en format de date
chro_$Date <- as.Date(as.character(chro_$Date), format = "%Y%m%d")

x11()

# Tracer le graphique
ggplot(chro_, aes(x = Date, y = Qls)) +
  geom_line(color = "#225ea8") +
  labs(title = "Chronique de Qls en fonction de la Date", x = "Date", y = "Qls") +
  theme_minimal()



p <- ggplot(chro_, aes(x = Date, y = Qls)) +
  geom_line(color = "#225ea8") +
  labs(x = "Date", y = "Flow (L/s)", size = 14) +
  ylim(0,125000)+
  theme_minimal() +
  theme(
    text = element_text(size = 40)  # Ajuster la taille du texte global
  )

# pdf("/home/tjaouen/Documents/Administratif/Conferences/Hypopo/20230125/Images/ChroniqueDebit_1_20230124.pdf",
#     width = 18)

png("/home/tjaouen/Documents/Administratif/Conferences/Hypopo/20230125/Images/ChroniqueDebit_1_20230124.png",
    width = 1600, #height = 750,
    units = "px", pointsize = 12)
print(p)
dev.off()






library(ggplot2)

chro_ = read.table("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/GRSD_20231128/ChroniquesBrutes_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_MOHC-HadREM3-GA7-05_v3_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_20050801-21000731/A402061001.txt",
                   sep = ";", dec = ".", header = T)


# Convertir la colonne Date en format de date
chro_$Date <- as.Date(as.character(chro_$Date), format = "%Y-%m-%d")

chro_$Qls = chro_$Qm3s1*1000

x11()

# Tracer le graphique
ggplot(chro_, aes(x = Date, y = Qls)) +
  geom_line(color = "#f03b20") +
  labs(title = "Chronique de Qls en fonction de la Date", x = "Date", y = "Qls") +
  theme_minimal()



p <- ggplot(chro_, aes(x = Date, y = Qls)) +
  geom_line(color = "#f03b20") +
  labs(x = "Date", y = "Flow (L/s)", size = 14) +
  theme_minimal() +
  theme(
    text = element_text(size = 40)  # Ajuster la taille du texte global
  )

# pdf("/home/tjaouen/Documents/Administratif/Conferences/Hypopo/20230125/Images/ChroniqueDebit_1_20230124.pdf",
#     width = 18)

png("/home/tjaouen/Documents/Administratif/Conferences/Hypopo/20230125/Images/ChroniqueDebit_Projections_1_20230126.png",
    width = 1600, #height = 750,
    units = "px", pointsize = 12)
print(p)
dev.off()

