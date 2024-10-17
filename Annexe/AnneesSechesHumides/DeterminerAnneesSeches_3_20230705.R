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
PrecipTot_table_$Mois <- SNOW_table_$Mois

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





x11()
ggplot(ETP_table_, aes(x=as.Date(Date),y=S13))+
  geom_line(color = "black")

ggplot(PRCP_table_, aes(x=as.Date(Date),y=S13))+
  geom_line(color = "black")

ggplot(SNOW_table_, aes(x=as.Date(Date),y=S13))+
  geom_line(color = "black")

ggplot(Temp_table_, aes(x=as.Date(Date),y=S13))+
  geom_line(color = "black")


ETP_table_ <- ETP_table_ %>%
  mutate(Mois = format(Date, "%Y-%m")) %>%
  mutate(Annee = format(Date, "%Y"))

PRCP_table_ <- PRCP_table_ %>%
  mutate(Mois = format(Date, "%Y-%m")) %>%
  mutate(Annee = format(Date, "%Y"))

SNOW_table_ <- SNOW_table_ %>%
  mutate(Mois = format(Date, "%Y-%m")) %>%
  mutate(Annee = format(Date, "%Y"))

Temp_table_ <- Temp_table_ %>%
  mutate(Mois = format(Date, "%Y-%m")) %>%
  mutate(Annee = format(Date, "%Y"))

PrecipTot_table_ <- PrecipTot_table_ %>%
  mutate(Mois = format(Date, "%Y-%m")) %>%
  mutate(Annee = format(Date, "%Y"))

# Calculer les moyennes par mois en regroupant par la colonne "Mois"
ETP_table_MoyMois <- ETP_table_ %>%
  group_by(Mois) %>%
  summarise(across(everything(), mean, na.rm = TRUE))

PRCP_table_MoyMois <- PRCP_table_ %>%
  group_by(Mois) %>%
  summarise(across(everything(), mean, na.rm = TRUE))

SNOW_table_MoyMois <- SNOW_table_ %>%
  group_by(Mois) %>%
  summarise(across(everything(), mean, na.rm = TRUE))

Temp_table_MoyMois <- Temp_table_ %>%
  group_by(Mois) %>%
  summarise(across(everything(), mean, na.rm = TRUE))

PrecipTot_table_MoyMois <- PrecipTot_table_ %>%
  group_by(Mois) %>%
  summarise(across(everything(), mean, na.rm = TRUE))

# Calculer les moyennes par mois en regroupant par la colonne "Mois"
ETP_table_MoyAnnee <- ETP_table_ %>%
  group_by(Annee) %>%
  summarise(across(everything(), mean, na.rm = TRUE))

PRCP_table_MoyAnnee <- PRCP_table_ %>%
  group_by(Annee) %>%
  summarise(across(everything(), mean, na.rm = TRUE))

SNOW_table_MoyAnnee <- SNOW_table_ %>%
  group_by(Annee) %>%
  summarise(across(everything(), mean, na.rm = TRUE))

Temp_table_MoyAnnee <- Temp_table_ %>%
  group_by(Annee) %>%
  summarise(across(everything(), mean, na.rm = TRUE))

PrecipTot_table_MoyAnnee <- PrecipTot_table_ %>%
  group_by(Annee) %>%
  summarise(across(everything(), mean, na.rm = TRUE))



# Plot
ggplot(ETP_table_MoyMois, aes(x=as.Date(Date),y=S13))+
  geom_line() +
  geom_point()

ggplot(ETP_table_MoyAnnee, aes(x=as.Date(Date),y=S13))+
  geom_line() +
  geom_point()

ggplot(PRCP_table_MoyMois, aes(x=as.Date(Date),y=S13))+
  geom_line() +
  geom_point()

ggplot(PRCP_table_MoyAnnee, aes(x=as.Date(Date),y=S13))+
  geom_line() +
  geom_point()

ggplot(SNOW_table_MoyMois, aes(x=as.Date(Date),y=S13))+
  geom_line() +
  geom_point()

ggplot(SNOW_table_MoyAnnee, aes(x=as.Date(Date),y=S13))+
  geom_line() +
  geom_point()

ggplot(Temp_table_MoyMois, aes(x=as.Date(Date),y=S13))+
  geom_line() +
  geom_point()

ggplot(Temp_table_MoyAnnee, aes(x=as.Date(Date),y=S13))+
  geom_line() +
  geom_point()

ggplot(PrecipTot_table_MoyMois, aes(x=as.Date(Date),y=S13))+
  geom_line() +
  geom_point()

ggplot(PrecipTot_table_MoyAnnee, aes(x=as.Date(Date),y=S13))+
  geom_line() +
  geom_point()



df_ETP_MoyAnneeGlobale <- data.frame(rowMeans(ETP_table_MoyAnnee[,grep("S",colnames(ETP_table_MoyAnnee))]))
df_ETP_MoyAnneeGlobale$Annee = ETP_table_MoyAnnee$Annee
colnames(df_ETP_MoyAnneeGlobale) <- c("ETPMoyenne", "Annee")
df_ETP_MoyAnneeGlobale[order(df_ETP_MoyAnneeGlobale$ETPMoyenne, decreasing = T),]

df_PRCP_MoyAnneeGlobale <- data.frame(rowMeans(PRCP_table_MoyAnnee[,grep("S",colnames(PRCP_table_MoyAnnee))]))
df_PRCP_MoyAnneeGlobale$Annee = PRCP_table_MoyAnnee$Annee
colnames(df_PRCP_MoyAnneeGlobale) <- c("PRCPMoyenne", "Annee")
df_PRCP_MoyAnneeGlobale[order(df_PRCP_MoyAnneeGlobale$PRCPMoyenne),]

df_SNOW_MoyAnneeGlobale <- data.frame(rowMeans(SNOW_table_MoyAnnee[,grep("S",colnames(SNOW_table_MoyAnnee))]))
df_SNOW_MoyAnneeGlobale$Annee = SNOW_table_MoyAnnee$Annee
colnames(df_SNOW_MoyAnneeGlobale) <- c("SNOWMoyenne", "Annee")
df_SNOW_MoyAnneeGlobale[order(df_SNOW_MoyAnneeGlobale$SNOWMoyenne),]

df_Temp_MoyAnneeGlobale <- data.frame(rowMeans(Temp_table_MoyAnnee[,grep("S",colnames(Temp_table_MoyAnnee))]))
df_Temp_MoyAnneeGlobale$Annee = Temp_table_MoyAnnee$Annee
colnames(df_Temp_MoyAnneeGlobale) <- c("TemperatureMoyenne", "Annee")
df_Temp_Mean[order(df_Temp_MoyAnneeGlobale$TemperatureMoyenne, decreasing = T),]

df_PrecipTot_MoyAnneeGlobale <- data.frame(rowMeans(PrecipTot_table_MoyAnnee[,grep("S",colnames(PrecipTot_table_MoyAnnee))]))
df_PrecipTot_MoyAnneeGlobale$Annee = PrecipTot_table_MoyAnnee$Annee
colnames(df_PrecipTot_MoyAnneeGlobale) <- c("PrecipTotMoyenne", "Annee")
df_PrecipTot_MoyAnneeGlobale[order(df_PrecipTot_MoyAnneeGlobale$PrecipTotMoyenne),]

write.table(df_ETP_MoyAnneeGlobale[order(df_ETP_MoyAnneeGlobale$ETPMoyenne, decreasing = T),], "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/df_ETP_MoyAnneeGlobale_20230706.csv", sep = ",", dec = ".", row.names = F)
write.table(df_PRCP_MoyAnneeGlobale[order(df_PRCP_MoyAnneeGlobale$PRCPMoyenne),], "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/df_PRCP_MoyAnneeGlobale_20230706.csv", sep = ",", dec = ".", row.names = F)
write.table(df_SNOW_MoyAnneeGlobale[order(df_SNOW_MoyAnneeGlobale$SNOWMoyenne),], "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/df_SNOW_MoyAnneeGlobale_20230706.csv", sep = ",", dec = ".", row.names = F)
write.table(df_Temp_MoyAnneeGlobale[order(df_Temp_MoyAnneeGlobale$TemperatureMoyenne, decreasing = T),], "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/df_Temp_MoyAnneeGlobale_20230706.csv", sep = ",", dec = ".", row.names = F)
write.table(df_PrecipTot_MoyAnneeGlobale[order(df_PrecipTot_MoyAnneeGlobale$PrecipTotMoyenne),], "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/df_PrecipTot_MoyAnneeGlobale_20230706.csv", sep = ",", dec = ".", row.names = F)

ggplot(df_Temp_Mean, aes(x=Annee,y=TemperatureMoyenne))+
  geom_bar()

ggplot(df_Temp_Mean, aes(x = Annee, y = TemperatureMoyenne)) +
  geom_bar(stat = "identity", fill = "blue") +
  ylim(10,12.5) +
  labs(x = "Année", y = "Température moyenne", title = "Température moyenne par année") +
  theme_minimal()


### Faire sur saison
### Faire sur mai - septembre -> peut etre pas trop de sens hydro


