library(ggplot2)
library(tidyverse)

folder_Safran_ = "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/"

ETP_files_ = list.files(folder_Safran_, pattern = "ETP", full.names = T)
PRCP_files_ = list.files(folder_Safran_, pattern = "PRCP", full.names = T)
SNOW_files_ = list.files(folder_Safran_, pattern = "SNOW", full.names = T)
Temp_files_ = list.files(folder_Safran_, pattern = "T_", full.names = T)

metadonnees_ <- read.table(paste0(folder_Safran_, "metadata.txt"), sep = ";", header = T)
which(!(complete.cases(metadonnees_)))

### ETP ###
ETP_table_ <- metadonnees_

for (f in ETP_files_){
  ETP_tmp <- read.table(f, sep = ";", header = T)
  ETP_tmp$Point <- rownames(ETP_tmp)
  ETP_tmp <- merge(ETP_tmp, metadonnees_, by.x = "Point", by.y = "cell")
  ETP_tmp <- ETP_tmp[which(ETP_tmp$infrance),grep("X|Point",colnames(ETP_tmp))]
  ETP_table_ <- merge(ETP_table_, ETP_tmp, by.x = "cell", by.y = "Point")
}

ETP_table_ <- as.data.frame(t(ETP_table_))
colnames(ETP_table_) <- ETP_table_[1,]
ETP_table_ <- ETP_table_[grep("X",rownames(ETP_table_)),]
colnames(ETP_table_) <- paste0("S",colnames(ETP_table_))
ETP_table_$Date <- as.Date(substr(rownames(ETP_table_),2,11), format = "%Y.%m.%d")

### PRCP ###
PRCP_table_ <- metadonnees_

for (f in PRCP_files_){
  PRCP_tmp <- read.table(f, sep = ";", header = T)
  PRCP_tmp$Point <- rownames(PRCP_tmp)
  PRCP_tmp <- merge(PRCP_tmp, metadonnees_, by.x = "Point", by.y = "cell")
  PRCP_tmp <- PRCP_tmp[which(PRCP_tmp$infrance),grep("X|Point",colnames(PRCP_tmp))]
  PRCP_table_ <- merge(PRCP_table_, PRCP_tmp, by.x = "cell", by.y = "Point")
}

PRCP_table_ <- as.data.frame(t(PRCP_table_))
colnames(PRCP_table_) <- PRCP_table_[1,]
PRCP_table_ <- PRCP_table_[grep("X",rownames(PRCP_table_)),]
colnames(PRCP_table_) <- paste0("S",colnames(PRCP_table_))
PRCP_table_$Date <- as.Date(substr(rownames(PRCP_table_),2,11), format = "%Y.%m.%d")

### SNOW ###
SNOW_table_ <- metadonnees_

for (f in SNOW_files_){
  SNOW_tmp <- read.table(f, sep = ";", header = T)
  SNOW_tmp$Point <- rownames(SNOW_tmp)
  SNOW_tmp <- merge(SNOW_tmp, metadonnees_, by.x = "Point", by.y = "cell")
  SNOW_tmp <- SNOW_tmp[which(SNOW_tmp$infrance),grep("X|Point",colnames(SNOW_tmp))]
  SNOW_table_ <- merge(SNOW_table_, SNOW_tmp, by.x = "cell", by.y = "Point")
}

SNOW_table_ <- as.data.frame(t(SNOW_table_))
colnames(SNOW_table_) <- SNOW_table_[1,]
SNOW_table_ <- SNOW_table_[grep("X",rownames(SNOW_table_)),]
colnames(SNOW_table_) <- paste0("S",colnames(SNOW_table_))
SNOW_table_$Date <- as.Date(substr(rownames(SNOW_table_),2,11), format = "%Y.%m.%d")

which(!(SNOW_table_$Annee == PRCP_table_$Annee))
dim(SNOW_table_[,grep("S", colnames(SNOW_table_))])
dim(PRCP_table_[,grep("S", colnames(SNOW_table_))])
PrecipTot_table_ <- SNOW_table_[,grep("S", colnames(SNOW_table_))] + PRCP_table_[,grep("S", colnames(SNOW_table_))]
PrecipTot_table_$Date <- SNOW_table_$Date
PrecipTot_table_$Annee <- SNOW_table_$Annee
PrecipTot_table_$Month <- SNOW_table_$Month

### Temp ###
Temp_table_ <- metadonnees_

for (f in Temp_files_){
  Temp_tmp <- read.table(f, sep = ";", header = T)
  Temp_tmp$Point <- rownames(Temp_tmp)
  Temp_tmp <- merge(Temp_tmp, metadonnees_, by.x = "Point", by.y = "cell")
  Temp_tmp <- Temp_tmp[which(Temp_tmp$infrance),grep("X|Point",colnames(Temp_tmp))]
  Temp_table_ <- merge(Temp_table_, Temp_tmp, by.x = "cell", by.y = "Point")
}

Temp_table_ <- as.data.frame(t(Temp_table_))
colnames(Temp_table_) <- Temp_table_[1,]
Temp_table_ <- Temp_table_[grep("X",rownames(Temp_table_)),]
colnames(Temp_table_) <- paste0("S",colnames(Temp_table_))
Temp_table_ <- Temp_table_ - 273.15
Temp_table_$Date <- as.Date(substr(rownames(Temp_table_),2,11), format = "%Y.%m.%d")




### Plot chroniques ###
x11()
ggplot(Temp_table_, aes(x=as.Date(Date),y=S13))+
  geom_line(color = "black")

ggplot(ETP_table_, aes(x=as.Date(Date),y=S13))+
  geom_line(color = "black")

ggplot(PRCP_table_, aes(x=as.Date(Date),y=S13))+
  geom_line(color = "black")

ggplot(SNOW_table_, aes(x=as.Date(Date),y=S13))+
  geom_line(color = "black")


### Dates ###
Temp_table_ <- Temp_table_ %>%
  mutate(Month = format(Date, "%Y-%m")) %>%
  mutate(Annee = format(Date, "%Y"))

ETP_table_ <- ETP_table_ %>%
  mutate(Month = format(Date, "%Y-%m")) %>%
  mutate(Annee = format(Date, "%Y"))

PRCP_table_ <- PRCP_table_ %>%
  mutate(Month = format(Date, "%Y-%m")) %>%
  mutate(Annee = format(Date, "%Y"))

SNOW_table_ <- SNOW_table_ %>%
  mutate(Month = format(Date, "%Y-%m")) %>%
  mutate(Annee = format(Date, "%Y"))

PrecipTot_table_ <- PrecipTot_table_ %>%
  mutate(Month = format(Date, "%Y-%m")) %>%
  mutate(Annee = format(Date, "%Y"))

### Calculer les moyennes / cumuls par Month en regroupant par la colonne "Month" ###
Temp_table_MoyMonth <- Temp_table_ %>%
  group_by(Month) %>%
  summarise(across(everything(), mean, na.rm = TRUE))
Temp_table_MoyMonth$Month <- ymd(paste(Temp_table_MoyMonth$Month, "01"))  # Convertir en format de date

ETP_table_SumMonth <- ETP_table_ %>%
  group_by(Month) %>%
  summarise(across(contains("S"), sum))
ETP_table_SumMonth$Month <- ymd(paste(ETP_table_SumMonth$Month, "01"))  # Convertir en format de date

PRCP_table_SumMonth <- PRCP_table_ %>%
  group_by(Month) %>%
  summarise(across(contains("S"), sum))
PRCP_table_SumMonth$Month <- ymd(paste(PRCP_table_SumMonth$Month, "01"))  # Convertir en format de date

SNOW_table_SumMonth <- SNOW_table_ %>%
  group_by(Month) %>%
  summarise(across(contains("S"), sum))
SNOW_table_SumMonth$Month <- ymd(paste(SNOW_table_SumMonth$Month, "01"))  # Convertir en format de date

PrecipTot_table_SumMonth <- PrecipTot_table_ %>%
  group_by(Month) %>%
  summarise(across(contains("S"), sum))
PrecipTot_table_SumMonth$Month <- ymd(paste(PrecipTot_table_SumMonth$Month, "01"))  # Convertir en format de date

### Calculer les moyennes par Month en regroupant par la colonne "Month" ###
Temp_table_MoyAnnee <- Temp_table_ %>%
  group_by(Annee) %>%
  summarise(across(everything(), mean, na.rm = TRUE))
# Temp_table_MoyAnnee$Annee <- ymd(paste(Temp_table_MoyAnnee$Annee, "01"))  # Convertir en format de date

ETP_table_SumAnnee <- ETP_table_ %>%
  group_by(Annee) %>%
  summarise(across(contains("S"), sum))
# ETP_table_SumAnnee$Annee <- ymd(paste(ETP_table_SumAnnee$Annee, "01"))  # Convertir en format de date

PRCP_table_SumAnnee <- PRCP_table_ %>%
  group_by(Annee) %>%
  summarise(across(contains("S"), sum))
# PRCP_table_SumAnnee$Annee <- ymd(paste(PRCP_table_SumAnnee$Annee, "01"))  # Convertir en format de date

SNOW_table_SumAnnee <- SNOW_table_ %>%
  group_by(Annee) %>%
  summarise(across(contains("S"), sum))
# SNOW_table_SumAnnee$Annee <- ymd(paste(SNOW_table_SumAnnee$Annee, "01"))  # Convertir en format de date

PrecipTot_table_SumAnnee <- PrecipTot_table_ %>%
  group_by(Annee) %>%
  summarise(across(contains("S"), sum))
# PrecipTot_table_SumAnnee$Annee <- ymd(paste(PrecipTot_table_SumAnnee$Annee, "01"))  # Convertir en format de date



# Plot
# ggplot(Temp_table_MoyMonth, aes(x=as.Date(Date),y=S13))+
#   geom_line() +
#   geom_point()
# 
# ggplot(Temp_table_MoyAnnee, aes(x=as.Date(Date),y=S13))+
#   geom_line() +
#   geom_point()
# 
# ggplot(ETP_table_SumMonth, aes(x=as.Date(Month),y=S13))+
#   geom_line() +
#   geom_point()
# 
# ggplot(ETP_table_SumAnnee, aes(x=Annee,y=S13))+
#   geom_line() +
#   geom_point()
# 
# ggplot(PRCP_table_SumMonth, aes(x=as.Date(Month),y=S13))+
#   geom_line() +
#   geom_point()
# 
# ggplot(PRCP_table_SumAnnee, aes(x=as.Date(Annee),y=S13))+
#   geom_line() +
#   geom_point()
# 
# ggplot(SNOW_table_SumMonth, aes(x=as.Date(Month),y=S13))+
#   geom_line() +
#   geom_point()
# 
# ggplot(SNOW_table_SumAnnee, aes(x=as.Date(Annee),y=S13))+
#   geom_line() +
#   geom_point()
# 
# ggplot(PrecipTot_table_SumMonth, aes(x=as.Date(Month),y=S13))+
#   geom_line() +
#   geom_point()
# 
# ggplot(PrecipTot_table_SumAnnee, aes(x=as.Date(Annee),y=S13))+
#   geom_line() +
#   geom_point()


df_Temp_MoyAnneeGlobale <- data.frame(rowMeans(Temp_table_MoyAnnee[,grep("S",colnames(Temp_table_MoyAnnee))]))
df_Temp_MoyAnneeGlobale$Annee = Temp_table_MoyAnnee$Annee
colnames(df_Temp_MoyAnneeGlobale) <- c("TemperatureMoyenne", "Annee")
df_Temp_Mean[order(df_Temp_MoyAnneeGlobale$TemperatureMoyenne, decreasing = T),]

df_ETP_SumAnneeGlobale <- data.frame(rowMeans(ETP_table_SumAnnee[,grep("S",colnames(ETP_table_SumAnnee))]))
df_ETP_SumAnneeGlobale$Annee = ETP_table_SumAnnee$Annee
colnames(df_ETP_SumAnneeGlobale) <- c("ETPSum", "Annee")
df_ETP_SumAnneeGlobale[order(df_ETP_SumAnneeGlobale$ETPSum, decreasing = T),]

df_PRCP_SumAnneeGlobale <- data.frame(rowMeans(PRCP_table_SumAnnee[,grep("S",colnames(PRCP_table_SumAnnee))]))
df_PRCP_SumAnneeGlobale$Annee = PRCP_table_SumAnnee$Annee
colnames(df_PRCP_SumAnneeGlobale) <- c("PRCPSum", "Annee")
df_PRCP_MoyAnneeGlobale[order(df_PRCP_SumAnneeGlobale$PRCPSum),]

df_SNOW_SumAnneeGlobale <- data.frame(rowMeans(SNOW_table_SumAnnee[,grep("S",colnames(SNOW_table_SumAnnee))]))
df_SNOW_SumAnneeGlobale$Annee = SNOW_table_SumAnnee$Annee
colnames(df_SNOW_SumAnneeGlobale) <- c("SNOWSum", "Annee")
df_SNOW_SumAnneeGlobale[order(df_SNOW_SumAnneeGlobale$SNOWSum),]

df_PrecipTot_SumAnneeGlobale <- data.frame(rowMeans(PrecipTot_table_SumAnnee[,grep("S",colnames(PrecipTot_table_SumAnnee))]))
df_PrecipTot_SumAnneeGlobale$Annee = PrecipTot_table_SumAnnee$Annee
colnames(df_PrecipTot_SumAnneeGlobale) <- c("PrecipTotSum", "Annee")
df_PrecipTot_SumAnneeGlobale[order(df_PrecipTot_SumAnneeGlobale$PrecipTotSum),]

df_PrecipTot_SumAnneeGlobale$Annee <- as.numeric(df_PrecipTot_SumAnneeGlobale$Annee)
df_ETP_SumAnneeGlobale$Annee <- as.numeric(df_ETP_SumAnneeGlobale$Annee)

ggplot() +
  geom_line(data = df_PrecipTot_SumAnneeGlobale, aes(x = Annee, y = PrecipTotSum, color = "PrecipTotSum")) +
  geom_line(data = df_ETP_SumAnneeGlobale, aes(x = Annee, y = ETPSum, color = "ETPSum")) +
  labs(x = "Annee", y = "PrecipTotSum") +
  scale_color_manual(values = c("PrecipTotSum" = "blue", "ETPSum" = "red")) +
  theme_minimal()


# write.table(df_Temp_MoyAnneeGlobale[order(df_Temp_MoyAnneeGlobale$TemperatureMoyenne, decreasing = T),], "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/df_Temp_MoyAnneeGlobale_20230706.csv", sep = ",", dec = ".", row.names = F)
# write.table(df_ETP_SumAnneeGlobale[order(df_ETP_SumAnneeGlobale$ETPSum, decreasing = T),], "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/df_ETP_SumAnneeGlobale_20230706.csv", sep = ",", dec = ".", row.names = F)
# write.table(df_PRCP_SumAnneeGlobale[order(df_PRCP_SumAnneeGlobale$PRCPSum),], "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/df_PRCP_SumAnneeGlobale_20230706.csv", sep = ",", dec = ".", row.names = F)
# write.table(df_SNOW_SumAnneeGlobale[order(df_SNOW_SumAnneeGlobale$SNOWSum),], "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/df_SNOW_SumAnneeGlobale_20230706.csv", sep = ",", dec = ".", row.names = F)
# write.table(df_PrecipTot_SumAnneeGlobale[order(df_PrecipTot_SumAnneeGlobale$PrecipTotSum),], "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/df_PrecipTot_SumAnneeGlobale_20230706.csv", sep = ",", dec = ".", row.names = F)





### Faire sur saison
### Faire sur mai - septembre -> peut etre pas trop de sens hydro


############### PAR SAISON ###############
Temp_table_MoyMonth <- Temp_table_MoyMonth %>%
  mutate(Period = case_when(
    month(as.Date(Month)) %in% c(6, 7, 8) ~ "JJA",
    month(as.Date(Month)) %in% c(9, 10, 11) ~ "SON",
    month(as.Date(Month)) %in% c(12, 1, 2) ~ "DJF",
    month(as.Date(Month)) %in% c(3, 4, 5) ~ "MAM"
  ))

ETP_table_SumMonth <- ETP_table_SumMonth %>%
  mutate(Period = case_when(
    month(as.Date(Month)) %in% c(6, 7, 8) ~ "JJA",
    month(as.Date(Month)) %in% c(9, 10, 11) ~ "SON",
    month(as.Date(Month)) %in% c(12, 1, 2) ~ "DJF",
    month(as.Date(Month)) %in% c(3, 4, 5) ~ "MAM"
  ))

PRCP_table_SumMonth <- PRCP_table_SumMonth %>%
  mutate(Period = case_when(
    month(as.Date(Month)) %in% c(6, 7, 8) ~ "JJA",
    month(as.Date(Month)) %in% c(9, 10, 11) ~ "SON",
    month(as.Date(Month)) %in% c(12, 1, 2) ~ "DJF",
    month(as.Date(Month)) %in% c(3, 4, 5) ~ "MAM"
  ))

SNOW_table_SumMonth <- SNOW_table_SumMonth %>%
  mutate(Period = case_when(
    month(as.Date(Month)) %in% c(6, 7, 8) ~ "JJA",
    month(as.Date(Month)) %in% c(9, 10, 11) ~ "SON",
    month(as.Date(Month)) %in% c(12, 1, 2) ~ "DJF",
    month(as.Date(Month)) %in% c(3, 4, 5) ~ "MAM"
  ))

PrecipTot_table_SumMonth <- PrecipTot_table_SumMonth %>%
  mutate(Period = case_when(
    month(as.Date(Month)) %in% c(6, 7, 8) ~ paste0("JJA_",year(as.Date(Month))),
    month(as.Date(Month)) %in% c(9, 10, 11) ~ paste0("SON_",year(as.Date(Month))),
    month(as.Date(Month)) %in% c(12, 1, 2) ~ paste0("DJF_",year(as.Date(Month))),
    month(as.Date(Month)) %in% c(3, 4, 5) ~ paste0("MAM_",year(as.Date(Month)))
  ))


### Calculer les moyennes / cumuls par Month en regroupant par la colonne "Month" ###
Temp_table_MoyPeriod <- Temp_table_MoyMonth %>%
  group_by(Period) %>%
  summarise(across(contains("S"), mean))
# summarise(across(everything(), mean, na.rm = TRUE))

ETP_table_SumPeriod <- ETP_table_SumMonth %>%
  group_by(Period) %>%
  summarise(across(contains("S"), sum))

PRCP_table_SumPeriod <- PRCP_table_SumMonth %>%
  group_by(Period) %>%
  summarise(across(contains("S"), sum))

SNOW_table_SumPeriod <- SNOW_table_SumMonth %>%
  group_by(Period) %>%
  summarise(across(contains("S"), sum))

PrecipTot_table_SumPeriod <- PrecipTot_table_SumMonth %>%
  group_by(Period) %>%
  summarise(across(contains("S"), sum))













