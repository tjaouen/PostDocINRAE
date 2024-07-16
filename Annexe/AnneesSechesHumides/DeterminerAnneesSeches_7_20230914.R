### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/6_RunsEtudeFrance_CorrectionImportOnde_20230607/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")

### Libraries ###
library(ggplot2)
library(readxl)
require(maptools)
library(rgdal)
library(maps)
library(mapdata)
library(dplyr)
library(rgeos)
library(RColorBrewer)
library(fields)
library(scales)
library(strex)

### Parameters ###
folder_output_ = folder_output_param_
nomSim_ = nomSim_param_
folder_input_ = folder_input_param_

library(ggplot2)
library(tidyverse)
library(strex)

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


# PrecipTotParETP_table_ <- PrecipTot_table_[,grep("S", colnames(PrecipTot_table_))] / ETP_table_[,grep("S", colnames(ETP_table_))]
# PrecipTotParETP_table_$Date <- PrecipTot_table_$Date
# PrecipTotParETP_table_$Annee <- PrecipTot_table_$Annee
# PrecipTotParETP_table_$Month <- PrecipTot_table_$Month



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


### Dates Mois, Annee et Annee Hydro ###
Temp_table_ <- Temp_table_ %>%
  mutate(Month = ymd(paste(format(Date, "%Y-%m"), "01"))) %>%
  mutate(Annee = format(Date, "%Y")) %>%
  mutate(AnneeHydro = case_when(
    month(as.Date(Month)) > 7 ~ year(as.Date(Month))+1,
    month(as.Date(Month)) <= 7 ~ year(as.Date(Month))
  ))

ETP_table_ <- ETP_table_ %>%
  mutate(Month = ymd(paste(format(Date, "%Y-%m"), "01"))) %>%
  mutate(Annee = format(Date, "%Y")) %>%
  mutate(AnneeHydro = case_when(
    month(as.Date(Month)) > 7 ~ year(as.Date(Month))+1,
    month(as.Date(Month)) <= 7 ~ year(as.Date(Month))
  ))

PRCP_table_ <- PRCP_table_ %>%
  mutate(Month = ymd(paste(format(Date, "%Y-%m"), "01"))) %>%
  mutate(Annee = format(Date, "%Y")) %>%
  mutate(AnneeHydro = case_when(
    month(as.Date(Month)) > 7 ~ year(as.Date(Month))+1,
    month(as.Date(Month)) <= 7 ~ year(as.Date(Month))
  ))

SNOW_table_ <- SNOW_table_ %>%
  mutate(Month = ymd(paste(format(Date, "%Y-%m"), "01"))) %>%
  mutate(Annee = format(Date, "%Y")) %>%
  mutate(AnneeHydro = case_when(
    month(as.Date(Month)) > 7 ~ year(as.Date(Month))+1,
    month(as.Date(Month)) <= 7 ~ year(as.Date(Month))
  ))

PrecipTot_table_ <- PrecipTot_table_ %>%
  mutate(Month = ymd(paste(format(Date, "%Y-%m"), "01"))) %>%
  mutate(Annee = format(Date, "%Y")) %>%
  mutate(AnneeHydro = case_when(
    month(as.Date(Month)) > 7 ~ year(as.Date(Month))+1,
    month(as.Date(Month)) <= 7 ~ year(as.Date(Month))
  ))

# PrecipTotParETP_table_ <- PrecipTotParETP_table_ %>%
#   mutate(Month = ymd(paste(format(Date, "%Y-%m"), "01"))) %>%
#   mutate(Annee = format(Date, "%Y")) %>%
#   mutate(AnneeHydro = case_when(
#     month(as.Date(Month)) > 7 ~ year(as.Date(Month))+1,
#     month(as.Date(Month)) <= 7 ~ year(as.Date(Month))
#   ))





### Calculer les moyennes / cumuls par Month en regroupant par la colonne "Month" ###
Temp_table_MoyMonth <- Temp_table_ %>%
  group_by(Month) %>%
  summarise(across(everything(), mean, na.rm = TRUE))

ETP_table_SumMonth <- ETP_table_ %>%
  group_by(Month) %>%
  summarise(across(contains("S"), sum))

PRCP_table_SumMonth <- PRCP_table_ %>%
  group_by(Month) %>%
  summarise(across(contains("S"), sum))

SNOW_table_SumMonth <- SNOW_table_ %>%
  group_by(Month) %>%
  summarise(across(contains("S"), sum))

PrecipTot_table_SumMonth <- PrecipTot_table_ %>%
  group_by(Month) %>%
  summarise(across(contains("S"), sum))

# PrecipTotParETP_table_SumMonth <- PrecipTotParETP_table_ %>%
#   group_by(Month) %>%
#   summarise(across(contains("S"), sum))

### Calculer les moyennes par Month en regroupant par la colonne "Month" ###
Temp_table_MoyAnnee <- Temp_table_ %>%
  group_by(Annee) %>%
  summarise(across(everything(), mean, na.rm = TRUE))

ETP_table_SumAnnee <- ETP_table_ %>%
  group_by(Annee) %>%
  summarise(across(contains("S"), sum))

PRCP_table_SumAnnee <- PRCP_table_ %>%
  group_by(Annee) %>%
  summarise(across(contains("S"), sum))

SNOW_table_SumAnnee <- SNOW_table_ %>%
  group_by(Annee) %>%
  summarise(across(contains("S"), sum))

PrecipTot_table_SumAnnee <- PrecipTot_table_ %>%
  group_by(Annee) %>%
  summarise(across(contains("S"), sum))

# PrecipTotParETP_table_SumAnnee <- PrecipTotParETP_table_ %>%
#   group_by(Annee) %>%
#   summarise(across(contains("S"), sum))


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


### Moyennes globales ###
df_Temp_MoyAnneeGlobale <- data.frame(rowMeans(Temp_table_MoyAnnee[,grep("S",colnames(Temp_table_MoyAnnee))]))
df_Temp_MoyAnneeGlobale$Annee = Temp_table_MoyAnnee$Annee
colnames(df_Temp_MoyAnneeGlobale) <- c("TemperatureMoyenne", "Annee")
df_Temp_MoyAnneeGlobale[order(df_Temp_MoyAnneeGlobale$TemperatureMoyenne, decreasing = T),]

df_ETP_SumAnneeGlobale <- data.frame(rowMeans(ETP_table_SumAnnee[,grep("S",colnames(ETP_table_SumAnnee))]))
df_ETP_SumAnneeGlobale$Annee = ETP_table_SumAnnee$Annee
colnames(df_ETP_SumAnneeGlobale) <- c("ETPSum", "Annee")
df_ETP_SumAnneeGlobale[order(df_ETP_SumAnneeGlobale$ETPSum, decreasing = T),]

df_PRCP_SumAnneeGlobale <- data.frame(rowMeans(PRCP_table_SumAnnee[,grep("S",colnames(PRCP_table_SumAnnee))]))
df_PRCP_SumAnneeGlobale$Annee = PRCP_table_SumAnnee$Annee
colnames(df_PRCP_SumAnneeGlobale) <- c("PRCPSum", "Annee")
df_PRCP_SumAnneeGlobale[order(df_PRCP_SumAnneeGlobale$PRCPSum),]

df_SNOW_SumAnneeGlobale <- data.frame(rowMeans(SNOW_table_SumAnnee[,grep("S",colnames(SNOW_table_SumAnnee))]))
df_SNOW_SumAnneeGlobale$Annee = SNOW_table_SumAnnee$Annee
colnames(df_SNOW_SumAnneeGlobale) <- c("SNOWSum", "Annee")
df_SNOW_SumAnneeGlobale[order(df_SNOW_SumAnneeGlobale$SNOWSum),]

df_PrecipTot_SumAnneeGlobale <- data.frame(rowMeans(PrecipTot_table_SumAnnee[,grep("S",colnames(PrecipTot_table_SumAnnee))]))
df_PrecipTot_SumAnneeGlobale$Annee = PrecipTot_table_SumAnnee$Annee
colnames(df_PrecipTot_SumAnneeGlobale) <- c("PrecipTotSum", "Annee")
df_PrecipTot_SumAnneeGlobale[order(df_PrecipTot_SumAnneeGlobale$PrecipTotSum),]

df_PrecipTotParETP_SumAnneeGlobale <- data.frame(PrecipTotSumParETP = df_PrecipTot_SumAnneeGlobale$PrecipTotSum/df_ETP_SumAnneeGlobale$ETPSum,
                                                 Annee = df_PrecipTot_SumAnneeGlobale$Annee)
df_PrecipTotParETP_SumAnneeGlobale[order(df_PrecipTotParETP_SumAnneeGlobale$PrecipTotSum),]

df_PrecipTot_SumAnneeGlobale$Annee <- as.numeric(df_PrecipTot_SumAnneeGlobale$Annee)
df_ETP_SumAnneeGlobale$Annee <- as.numeric(df_ETP_SumAnneeGlobale$Annee)
df_PrecipTotParETP_SumAnneeGlobale$Annee <- as.numeric(df_PrecipTotParETP_SumAnneeGlobale$Annee)

#~ png(paste0(folder_input_,"/../../Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/PrecipETP_AnneesCiviles_20230707.png"),
#     width = 1200, height = 750,
#     units = "px", pointsize = 12)
x11()
ggplot() +
  geom_line(data = df_PrecipTot_SumAnneeGlobale, aes(x = Annee, y = PrecipTotSum, color = "PrecipTotSum"), lwd = 2) +
  geom_point(data = df_PrecipTot_SumAnneeGlobale, aes(x = Annee, y = PrecipTotSum, color = "PrecipTotSum"), size = 3) +
  geom_line(data = df_ETP_SumAnneeGlobale, aes(x = Annee, y = ETPSum, color = "ETPSum"), lwd = 2) +
  geom_point(data = df_ETP_SumAnneeGlobale, aes(x = Annee, y = ETPSum, color = "ETPSum"), size = 3) +
  geom_line(data = df_PrecipTotParETP_SumAnneeGlobale, aes(x = Annee, y = PrecipTotSumParETP*500, color = "PrecipTotSumParETPx500"), lwd = 2) +
  geom_point(data = df_PrecipTotParETP_SumAnneeGlobale, aes(x = Annee, y = PrecipTotSumParETP*500, color = "PrecipTotSumParETPx500"), size = 3) +
  labs(x = "Annee", y = "PrecipTotSum") +
  scale_color_manual(values = c("PrecipTotSum" = rgb(84, 146, 205, maxColorValue = 255),
                                "ETPSum" = rgb(196, 121, 0, maxColorValue = 255),
                                "PrecipTotSumParETPx500" = rgb(0, 52, 102, maxColorValue = 255))) +
  theme_minimal()
#~ dev.off()

# write.table(df_Temp_MoyAnneeGlobale[order(df_Temp_MoyAnneeGlobale$TemperatureMoyenne, decreasing = T),], "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/df_Temp_MoyAnneeGlobale_20230706.csv", sep = ",", dec = ".", row.names = F)
# write.table(df_ETP_SumAnneeGlobale[order(df_ETP_SumAnneeGlobale$ETPSum, decreasing = T),], "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/df_ETP_SumAnneeGlobale_20230706.csv", sep = ",", dec = ".", row.names = F)
# write.table(df_PRCP_SumAnneeGlobale[order(df_PRCP_SumAnneeGlobale$PRCPSum),], "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/df_PRCP_SumAnneeGlobale_20230706.csv", sep = ",", dec = ".", row.names = F)
# write.table(df_SNOW_SumAnneeGlobale[order(df_SNOW_SumAnneeGlobale$SNOWSum),], "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/df_SNOW_SumAnneeGlobale_20230706.csv", sep = ",", dec = ".", row.names = F)
# write.table(df_PrecipTot_SumAnneeGlobale[order(df_PrecipTot_SumAnneeGlobale$PrecipTotSum),], "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/df_PrecipTot_SumAnneeGlobale_20230706.csv", sep = ",", dec = ".", row.names = F)

#~write.table(df_PrecipTotParETP_SumAnneeGlobale[order(df_PrecipTotParETP_SumAnneeGlobale$PrecipTotSum),], "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/df_PrecipTotParETP_SumAnneeGlobale_20230706.csv", sep = ",", dec = ".", row.names = F)





################## ANNEES HYDRO ###################

### Calculer les moyennes par Month en regroupant par la colonne "Month" ###
Temp_table_MoyAnneeHydro <- Temp_table_ %>%
  group_by(AnneeHydro) %>%
  summarise(across(everything(), mean, na.rm = TRUE))

ETP_table_SumAnneeHydro <- ETP_table_ %>%
  group_by(AnneeHydro) %>%
  summarise(across(contains("S"), sum))

PRCP_table_SumAnneeHydro <- PRCP_table_ %>%
  group_by(AnneeHydro) %>%
  summarise(across(contains("S"), sum))

SNOW_table_SumAnneeHydro <- SNOW_table_ %>%
  group_by(AnneeHydro) %>%
  summarise(across(contains("S"), sum))

PrecipTot_table_SumAnneeHydro <- PrecipTot_table_ %>%
  group_by(AnneeHydro) %>%
  summarise(across(contains("S"), sum))

# PrecipTotParETP_table_SumAnneeHydro <- PrecipTotParETP_table_ %>%
#   group_by(AnneeHydro) %>%
#   summarise(across(contains("S"), sum))

### Moyennes globales ###
df_Temp_MoyAnneeHydroGlobale <- data.frame(rowMeans(Temp_table_MoyAnneeHydro[,grep("S",colnames(Temp_table_MoyAnneeHydro))]))
df_Temp_MoyAnneeHydroGlobale$AnneeHydro = Temp_table_MoyAnneeHydro$AnneeHydro
colnames(df_Temp_MoyAnneeHydroGlobale) <- c("TemperatureMoyenne", "AnneeHydro")
df_Temp_MoyAnneeHydroGlobale[order(df_Temp_MoyAnneeHydroGlobale$TemperatureMoyenne, decreasing = T),]

df_ETP_SumAnneeHydroGlobale <- data.frame(rowMeans(ETP_table_SumAnneeHydro[,grep("S",colnames(ETP_table_SumAnneeHydro))]))
df_ETP_SumAnneeHydroGlobale$AnneeHydro = ETP_table_SumAnneeHydro$AnneeHydro
colnames(df_ETP_SumAnneeHydroGlobale) <- c("ETPSum", "AnneeHydro")
df_ETP_SumAnneeHydroGlobale[order(df_ETP_SumAnneeHydroGlobale$ETPSum, decreasing = T),]

df_PRCP_SumAnneeHydroGlobale <- data.frame(rowMeans(PRCP_table_SumAnneeHydro[,grep("S",colnames(PRCP_table_SumAnneeHydro))]))
df_PRCP_SumAnneeHydroGlobale$AnneeHydro = PRCP_table_SumAnneeHydro$AnneeHydro
colnames(df_PRCP_SumAnneeHydroGlobale) <- c("PRCPSum", "AnneeHydro")
df_PRCP_SumAnneeHydroGlobale[order(df_PRCP_SumAnneeHydroGlobale$PRCPSum),]

df_SNOW_SumAnneeHydroGlobale <- data.frame(rowMeans(SNOW_table_SumAnneeHydro[,grep("S",colnames(SNOW_table_SumAnneeHydro))]))
df_SNOW_SumAnneeHydroGlobale$AnneeHydro = SNOW_table_SumAnneeHydro$AnneeHydro
colnames(df_SNOW_SumAnneeHydroGlobale) <- c("SNOWSum", "AnneeHydro")
df_SNOW_SumAnneeHydroGlobale[order(df_SNOW_SumAnneeHydroGlobale$SNOWSum),]

df_PrecipTot_SumAnneeHydroGlobale <- data.frame(rowMeans(PrecipTot_table_SumAnneeHydro[,grep("S",colnames(PrecipTot_table_SumAnneeHydro))]))
df_PrecipTot_SumAnneeHydroGlobale$AnneeHydro = PrecipTot_table_SumAnneeHydro$AnneeHydro
colnames(df_PrecipTot_SumAnneeHydroGlobale) <- c("PrecipTotSum", "AnneeHydro")
df_PrecipTot_SumAnneeHydroGlobale[order(df_PrecipTot_SumAnneeHydroGlobale$PrecipTotSum),]

df_PrecipTotParETP_SumAnneeHydroGlobale <- data.frame(PrecipTotSumParETP = df_PrecipTot_SumAnneeHydroGlobale$PrecipTotSum/df_ETP_SumAnneeHydroGlobale$ETPSum,
                                                      AnneeHydro = df_PrecipTot_SumAnneeHydroGlobale$Annee)
df_PrecipTotParETP_SumAnneeHydroGlobale[order(df_PrecipTotParETP_SumAnneeHydroGlobale$PrecipTotSum),]

df_PrecipTot_SumAnneeHydroGlobale$AnneeHydro <- as.numeric(df_PrecipTot_SumAnneeHydroGlobale$AnneeHydro)
df_ETP_SumAnneeHydroGlobale$AnneeHydro <- as.numeric(df_ETP_SumAnneeHydroGlobale$AnneeHydro)
df_PrecipTotParETP_SumAnneeHydroGlobale$AnneeHydro <- as.numeric(df_PrecipTotParETP_SumAnneeHydroGlobale$AnneeHydro)


#~ png(paste0(folder_input_,"/../../Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/PrecipETP_AnneesHydro_20230707.png"),
#     width = 1200, height = 750,
#     units = "px", pointsize = 12)
x11()
ggplot() +
  geom_line(data = df_PrecipTot_SumAnneeHydroGlobale, aes(x = AnneeHydro, y = PrecipTotSum, color = "PrecipTotSum"), lwd = 2) +
  geom_point(data = df_PrecipTot_SumAnneeHydroGlobale, aes(x = AnneeHydro, y = PrecipTotSum, color = "PrecipTotSum"), size = 3) +
  geom_line(data = df_ETP_SumAnneeHydroGlobale, aes(x = AnneeHydro, y = ETPSum, color = "ETPSum"), lwd = 2) +
  geom_point(data = df_ETP_SumAnneeHydroGlobale, aes(x = AnneeHydro, y = ETPSum, color = "ETPSum"), size = 3) +
  geom_line(data = df_PrecipTotParETP_SumAnneeHydroGlobale, aes(x = AnneeHydro, y = PrecipTotSumParETP*500, color = "PrecipTotSumParETPx500"), lwd = 2) +
  geom_point(data = df_PrecipTotParETP_SumAnneeHydroGlobale, aes(x = AnneeHydro, y = PrecipTotSumParETP*500, color = "PrecipTotSumParETPx500"), size = 3) +
  labs(x = "AnneeHydro", y = "PrecipTotSum") +
  scale_color_manual(values = c("PrecipTotSum" = rgb(84, 146, 205, maxColorValue = 255),
                                "ETPSum" = rgb(196, 121, 0, maxColorValue = 255),
                                "PrecipTotSumParETPx500" = rgb(0, 52, 102, maxColorValue = 255))) +
  theme_minimal()
#~ dev.off()

#~ write.table(df_Temp_MoyAnneeHydroGlobale[order(df_Temp_MoyAnneeHydroGlobale$TemperatureMoyenne, decreasing = T),], "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/df_Temp_MoyAnneeHydroGlobale_20230706.csv", sep = ",", dec = ".", row.names = F)
#~ write.table(df_ETP_SumAnneeHydroGlobale[order(df_ETP_SumAnneeHydroGlobale$ETPSum, decreasing = T),], "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/df_ETP_SumAnneeHydroGlobale_20230706.csv", sep = ",", dec = ".", row.names = F)
#~ write.table(df_PRCP_SumAnneeHydroGlobale[order(df_PRCP_SumAnneeHydroGlobale$PRCPSum),], "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/df_PRCP_SumAnneeHydroGlobale_20230706.csv", sep = ",", dec = ".", row.names = F)
#~ write.table(df_SNOW_SumAnneeHydroGlobale[order(df_SNOW_SumAnneeHydroGlobale$SNOWSum),], "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/df_SNOW_SumAnneeHydroGlobale_20230706.csv", sep = ",", dec = ".", row.names = F)
#~ write.table(df_PrecipTot_SumAnneeHydroGlobale[order(df_PrecipTot_SumAnneeHydroGlobale$PrecipTotSum),], "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/df_PrecipTot_SumAnneeHydroGlobale_20230706.csv", sep = ",", dec = ".", row.names = F)
#~ write.table(df_PrecipTotParETP_SumAnneeHydroGlobale[order(df_PrecipTotParETP_SumAnneeHydroGlobale$PrecipTotSum),], "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/df_PrecipTotParETP_SumAnneeHydroGlobale_20230706.csv", sep = ",", dec = ".", row.names = F)






# Créer un vecteur de couleurs correspondant aux années
# colors <- c("2012" = "#F8F8F7", "2013" = "#543005", "2014" = "#543005", "2015" = "#F8F8F7",
#             "2016" = "#543005", "2017" = "#003C30", "2018" = "#543005", "2019" = "#003C30",
#             "2020" = "#F8F8F7", "2021" = "#F8F8F7", "2022" = "#003C30")

colors <- c("2012" = rgb(191, 220, 217, maxColorValue = 255),
            "2013" = rgb(31, 113, 103, maxColorValue = 255),
            "2014" = rgb(31, 113, 103, maxColorValue = 255),
            "2015" = rgb(191, 220, 217, maxColorValue = 255),
            "2016" = rgb(31, 113, 103, maxColorValue = 255),
            "2017" = rgb(178, 119, 40, maxColorValue = 255),
            "2018" = rgb(31, 113, 103, maxColorValue = 255),
            "2019" = rgb(178, 119, 40, maxColorValue = 255),
            "2020" = rgb(191, 220, 217, maxColorValue = 255),
            "2021" = rgb(191, 220, 217, maxColorValue = 255),
            "2022" = rgb(178, 119, 40, maxColorValue = 255))

df_PrecipTotParETP_SumAnneeHydroGlobale$AnneesSechesHumides = NA
df_PrecipTotParETP_SumAnneeHydroGlobale$AnneesSechesHumides[which(df_PrecipTot_SumAnneeHydroGlobale$AnneeHydro %in% c(2012,2015,2020,2021))] = "Intermediate"
df_PrecipTotParETP_SumAnneeHydroGlobale$AnneesSechesHumides[which(df_PrecipTot_SumAnneeHydroGlobale$AnneeHydro %in% c(2013,2014,2016,2018))] = "Wet"
df_PrecipTotParETP_SumAnneeHydroGlobale$AnneesSechesHumides[which(df_PrecipTot_SumAnneeHydroGlobale$AnneeHydro %in% c(2017,2019,2022))] = "Dry"

df_PrecipTotParETP_SumAnneeHydroGlobale$ColorAnneesSechesHumides = NA
df_PrecipTotParETP_SumAnneeHydroGlobale$ColorAnneesSechesHumides[which(df_PrecipTot_SumAnneeHydroGlobale$AnneeHydro %in% c(2012,2015,2020,2021))] = rgb(191, 220, 217, maxColorValue = 255)
df_PrecipTotParETP_SumAnneeHydroGlobale$ColorAnneesSechesHumides[which(df_PrecipTot_SumAnneeHydroGlobale$AnneeHydro %in% c(2013,2014,2016,2018))] = rgb(31, 113, 103, maxColorValue = 255)
df_PrecipTotParETP_SumAnneeHydroGlobale$ColorAnneesSechesHumides[which(df_PrecipTot_SumAnneeHydroGlobale$AnneeHydro %in% c(2017,2019,2022))] = rgb(178, 119, 40, maxColorValue = 255)

df_PrecipTotParETP_SumAnneeHydroGlobale$AnneesSechesHumides <- factor(df_PrecipTotParETP_SumAnneeHydroGlobale$AnneesSechesHumides, c("Wet","Intermediate","Dry"))

category_colors <- c("Wet" = rgb(31, 113, 103, maxColorValue = 255),
                     "Intermediate" = rgb(191, 220, 217, maxColorValue = 255),
                     "Dry" = rgb(178, 119, 40, maxColorValue = 255))

# Créez le graphique en utilisant le vecteur de couleurs des catégories
png("/home/tjaouen/Documents/Administratif/Articles/Jaouen_10_TJ20230913/Fig3_SeparationAnneesSechesIntermediairesHumides_1_20230914.png",
    width = 700, height = 600,
    units = "px", pointsize = 12)
p <- ggplot(data = df_PrecipTotParETP_SumAnneeHydroGlobale[which(df_PrecipTotParETP_SumAnneeHydroGlobale$AnneeHydro >= 2012),], aes(x = factor(AnneeHydro), y = PrecipTotSumParETP, fill = AnneesSechesHumides)) +
  geom_bar(stat = "identity", width = 0.7) +
  labs(x = "Year", y = "Annual Precipitation relative to Potential Evapotranspiration (unitless)") +
  scale_fill_manual(values = category_colors) +
  theme_minimal() +
  theme(legend.title = element_blank(),
        legend.position = "top",
        text = element_text(size = 18)) + # Ajustez la taille du texte ici
  guides(fill = guide_legend(title = "Year Category"))
print(p)
dev.off()





### Faire sur saison
### Faire sur mai - septembre -> peut etre pas trop de sens hydro


############### PAR SAISON - TEMPERATURE ###############
Temp_table_MoyPeriod <- Temp_table_  %>%
  mutate(Period = case_when(
    month(as.Date(Month)) %in% c(6, 7, 8) ~ paste0("JJA_",AnneeHydro),
    month(as.Date(Month)) %in% c(9, 10, 11) ~ paste0("SON_",AnneeHydro),
    month(as.Date(Month)) %in% c(12, 1, 2) ~ paste0("DJF_",AnneeHydro),
    month(as.Date(Month)) %in% c(3, 4, 5) ~ paste0("MAM_",AnneeHydro)))


### Calculer les moyennes / cumuls par Month en regroupant par la colonne "Month" ###
Temp_table_MoyPeriod <- Temp_table_MoyPeriod %>%
  group_by(Period) %>%
  summarise(across(contains("S"), mean))

df_Temp_MoyPeriodGlobale <- data.frame(rowMeans(Temp_table_MoyPeriod[,grep("S",colnames(Temp_table_MoyPeriod))]))
df_Temp_MoyPeriodGlobale$Period = Temp_table_MoyPeriod$Period
colnames(df_Temp_MoyPeriodGlobale) <- c("TemperatureMoyenne", "Period")
df_Temp_MoyPeriodGlobale[order(df_Temp_MoyPeriodGlobale$TemperatureMoyenne, decreasing = T),]

df_Temp_MoyPeriodGlobale <- df_Temp_MoyPeriodGlobale %>%
  separate(Period, into = c("Saison", "Annee"), sep = "_", remove = FALSE)

df_wide <- reshape(df_Temp_MoyPeriodGlobale, direction = "wide", 
                   idvar = "Annee",
                   timevar = "Saison")
df_wide <-df_wide[which(df_wide$Annee > 2011),grep("Annee|Temperature",colnames(df_wide))]

x11()
ggplot() +
  geom_line(data = df_wide, aes(x = Annee, y = TemperatureMoyenne.DJF, color = "DJF")) +
  geom_line(data = df_wide, aes(x = Annee, y = TemperatureMoyenne.JJA, color = "JJA")) +
  geom_line(data = df_wide, aes(x = Annee, y = TemperatureMoyenne.MAM, color = "MAM")) +
  geom_line(data = df_wide, aes(x = Annee, y = TemperatureMoyenne.SON, color = "SON")) +
  labs(x = "Annee", y = "TemperatureMoyenne.DJF") +
  scale_color_manual(values = c("DJF" = "blue", 
                                "JJA" = "red",
                                "MAM" = "green",
                                "SON" = "brown")) +
  theme_minimal()


data <- df_wide %>%
  pivot_longer(cols = starts_with("TemperatureMoyenne."), names_to = "Saison", values_to = "TemperatureMoyenne") %>%
  mutate(Saison = gsub("TemperatureMoyenne.", "", Saison))

# Définir l'ordre des saisons
season_order <- c("DJF", "MAM", "JJA", "SON")
data$Saison <- factor(data$Saison, levels = season_order)

# Tracer un graphique avec ggplot
couleurs <- c("#082158", "#234DA0", "#2498C0", "#73C8BC", "#D6EFB2", "#FEFED1", "#FEE187", "#FDAA48", "#FC5A2D", "#D30F1F", "#800026")
#~ png(paste0(folder_input_,"/../../Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/TemperaturesSaisons_20230706.png"),
#     width = 1200, height = 750,
#     units = "px", pointsize = 12)
x11()
ggplot(data, aes(x = factor(Saison), y = TemperatureMoyenne, color = as.factor(Annee), group = Annee)) +
  geom_line(lwd = 2) +
  labs(x = "Saison", y = "Temperature Moyenne", color = "Année") +
  scale_color_manual(values = couleurs, name = "Année") +
  theme_minimal()
#~ dev.off()

# ggplot(data, aes(x = factor(Saison), y = TemperatureMoyenne, color = as.factor(Annee), group = Annee)) +
#   geom_line() +
#   labs(x = "Saison", y = "Température Moyenne", color = "Année") +
#   scale_color_discrete(name = "Année") +
#   theme_minimal()



#~ write.table(df_wide, "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/df_wide_MoySaisons_20230706.csv", sep = ",", dec = ".", row.names = F)
length(df_wide$TemperatureMoyenne.DJF) - rank(df_wide$TemperatureMoyenne.DJF) + 1
length(df_wide$TemperatureMoyenne.JJA) - rank(df_wide$TemperatureMoyenne.JJA) + 1
length(df_wide$TemperatureMoyenne.MAM) - rank(df_wide$TemperatureMoyenne.MAM) + 1
length(df_wide$TemperatureMoyenne.SON) - rank(df_wide$TemperatureMoyenne.SON) + 1















############### PAR SAISON - PRECIPITATIONS ###############
PrecipTot_table_SumPeriod <- PrecipTot_table_ %>%
  mutate(Period = case_when(
    month(as.Date(Month)) %in% c(6, 7, 8) ~ paste0("JJA_",AnneeHydro),
    month(as.Date(Month)) %in% c(9, 10, 11) ~ paste0("SON_",AnneeHydro),
    month(as.Date(Month)) %in% c(12, 1, 2) ~ paste0("DJF_",AnneeHydro),
    month(as.Date(Month)) %in% c(3, 4, 5) ~ paste0("MAM_",AnneeHydro)))

### Calculer les moyennes / cumuls par Month en regroupant par la colonne "Month" ###
PrecipTot_table_MoyPeriod <- PrecipTot_table_SumPeriod %>%
  group_by(Period) %>%
  summarise(across(contains("S"), mean))

df_PrecipTot_SumPeriodGlobale <- data.frame(rowSums(PrecipTot_table_SumPeriod[,grep("S",colnames(PrecipTot_table_SumPeriod))]))
df_PrecipTot_SumPeriodGlobale$Period = PrecipTot_table_SumPeriod$Period
colnames(df_PrecipTot_SumPeriodGlobale) <- c("PrecipTotMoyenne", "Period")
df_PrecipTot_SumPeriodGlobale[order(df_PrecipTot_SumPeriodGlobale$PrecipTotMoyenne, decreasing = T),]

df_PrecipTot_SumPeriodGlobale <- df_PrecipTot_SumPeriodGlobale %>%
  separate(Period, into = c("Saison", "Annee"), sep = "_", remove = FALSE)

df_wide <- reshape(df_PrecipTot_SumPeriodGlobale, direction = "wide", 
                   idvar = "Annee",
                   timevar = "Saison")
df_wide <-df_wide[which(df_wide$Annee > 2011),grep("Annee|PrecipTot",colnames(df_wide))]

x11()
ggplot() +
  geom_line(data = df_wide, aes(x = Annee, y = PrecipTotMoyenne.DJF, color = "DJF")) +
  geom_line(data = df_wide, aes(x = Annee, y = PrecipTotMoyenne.JJA, color = "JJA")) +
  geom_line(data = df_wide, aes(x = Annee, y = PrecipTotMoyenne.MAM, color = "MAM")) +
  geom_line(data = df_wide, aes(x = Annee, y = PrecipTotMoyenne.SON, color = "SON")) +
  labs(x = "Annee", y = "PrecipTotMoyenne.DJF") +
  scale_color_manual(values = c("DJF" = "blue", 
                                "JJA" = "red",
                                "MAM" = "green",
                                "SON" = "brown")) +
  theme_minimal()


data <- df_wide %>%
  pivot_longer(cols = starts_with("PrecipTotMoyenne."), names_to = "Saison", values_to = "PrecipTotMoyenne") %>%
  mutate(Saison = gsub("PrecipTotMoyenne.", "", Saison))

# Définir l'ordre des saisons
season_order <- c("DJF", "MAM", "JJA", "SON")
data$Saison <- factor(data$Saison, levels = season_order)

# Tracer un graphique avec ggplot

couleurs <- c("#082158", "#234DA0", "#2498C0", "#73C8BC", "#D6EFB2", "#FEFED1", "#FEE187", "#FDAA48", "#FC5A2D", "#D30F1F", "#800026")
#~ png(paste0(folder_input_,"/../../Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/PrecipTotalesSaisons_20230706.png"),
#     width = 1200, height = 750,
#     units = "px", pointsize = 12)
x11()
ggplot(data, aes(x = factor(Saison), y = PrecipTotMoyenne, color = as.factor(Annee), group = Annee)) +
  geom_line(lwd = 2) +
  labs(x = "Saison", y = "Precipitations Totales", color = "Année") +
  scale_color_manual(values = couleurs, name = "Année") +
  theme_minimal()
#~ dev.off()


#~ write.table(df_wide, "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/df_wide_PrecipTotalesSaisons_20230706.csv", sep = ",", dec = ".", row.names = F)
length(df_wide$PrecipTotMoyenne.DJF) - rank(df_wide$PrecipTotMoyenne.DJF) + 1
length(df_wide$PrecipTotMoyenne.JJA) - rank(df_wide$PrecipTotMoyenne.JJA) + 1
length(df_wide$PrecipTotMoyenne.MAM) - rank(df_wide$PrecipTotMoyenne.MAM) + 1
length(df_wide$PrecipTotMoyenne.SON) - rank(df_wide$PrecipTotMoyenne.SON) + 1















############### PAR SAISON - PRECIPITATIONS PAR ETP ###############
PrecipTot_table_SumPeriod <- PrecipTot_table_ %>%
  mutate(Period = case_when(
    month(as.Date(Month)) %in% c(6, 7, 8) ~ paste0("JJA_",AnneeHydro),
    month(as.Date(Month)) %in% c(9, 10, 11) ~ paste0("SON_",AnneeHydro),
    month(as.Date(Month)) %in% c(12, 1, 2) ~ paste0("DJF_",AnneeHydro),
    month(as.Date(Month)) %in% c(3, 4, 5) ~ paste0("MAM_",AnneeHydro)))

### Calculer les moyennes / cumuls par Month en regroupant par la colonne "Month" ###
PrecipTot_table_MoyPeriod <- PrecipTot_table_SumPeriod %>%
  group_by(Period) %>%
  summarise(across(contains("S"), mean))

df_PrecipTot_SumPeriodGlobale <- data.frame(rowSums(PrecipTot_table_SumPeriod[,grep("S",colnames(PrecipTot_table_SumPeriod))]))
df_PrecipTot_SumPeriodGlobale$Period = PrecipTot_table_SumPeriod$Period
colnames(df_PrecipTot_SumPeriodGlobale) <- c("PrecipTotMoyenne", "Period")
df_PrecipTot_SumPeriodGlobale[order(df_PrecipTot_SumPeriodGlobale$PrecipTotMoyenne, decreasing = T),]

df_PrecipTot_SumPeriodGlobale <- df_PrecipTot_SumPeriodGlobale %>%
  separate(Period, into = c("Saison", "Annee"), sep = "_", remove = FALSE)

df_wide_PrecipTot <- reshape(df_PrecipTot_SumPeriodGlobale, direction = "wide", 
                             idvar = "Annee",
                             timevar = "Saison")
df_wide_PrecipTot <-df_wide_PrecipTot[which(df_wide_PrecipTot$Annee > 2011),grep("Annee|PrecipTot",colnames(df_wide_PrecipTot))]



ETP_table_SumPeriod <- ETP_table_ %>%
  mutate(Period = case_when(
    month(as.Date(Month)) %in% c(6, 7, 8) ~ paste0("JJA_",AnneeHydro),
    month(as.Date(Month)) %in% c(9, 10, 11) ~ paste0("SON_",AnneeHydro),
    month(as.Date(Month)) %in% c(12, 1, 2) ~ paste0("DJF_",AnneeHydro),
    month(as.Date(Month)) %in% c(3, 4, 5) ~ paste0("MAM_",AnneeHydro)))

### Calculer les moyennes / cumuls par Month en regroupant par la colonne "Month" ###
PrecipTot_table_MoyPeriod <- PrecipTot_table_SumPeriod %>%
  group_by(Period) %>%
  summarise(across(contains("S"), mean))

df_ETP_SumPeriodGlobale <- data.frame(rowSums(ETP_table_SumPeriod[,grep("S",colnames(ETP_table_SumPeriod))]))
df_ETP_SumPeriodGlobale$Period = ETP_table_SumPeriod$Period
colnames(df_ETP_SumPeriodGlobale) <- c("PrecipTotMoyenne", "Period")
df_ETP_SumPeriodGlobale[order(df_ETP_SumPeriodGlobale$PrecipTotMoyenne, decreasing = T),]

df_ETP_SumPeriodGlobale <- df_ETP_SumPeriodGlobale %>%
  separate(Period, into = c("Saison", "Annee"), sep = "_", remove = FALSE)

df_wide_ETP <- reshape(df_ETP_SumPeriodGlobale, direction = "wide", 
                       idvar = "Annee",
                       timevar = "Saison")
df_wide_ETP <-df_wide_ETP[which(df_wide_ETP$Annee > 2011),grep("Annee|PrecipTot",colnames(df_wide_ETP))]

df_wide_PrecipTotParETP <- data.frame(AnneeHydro = df_wide_PrecipTot$Annee,
                                      PrecipTotParETP.DJF = df_wide_PrecipTot$PrecipTotMoyenne.DJF/df_wide_ETP$PrecipTotMoyenne.DJF,
                                      PrecipTotParETP.MAM = df_wide_PrecipTot$PrecipTotMoyenne.MAM/df_wide_ETP$PrecipTotMoyenne.MAM,
                                      PrecipTotParETP.JJA = df_wide_PrecipTot$PrecipTotMoyenne.JJA/df_wide_ETP$PrecipTotMoyenne.JJA,
                                      PrecipTotParETP.SON = df_wide_PrecipTot$PrecipTotMoyenne.SON/df_wide_ETP$PrecipTotMoyenne.SON)




data <- df_wide_PrecipTotParETP %>%
  pivot_longer(cols = starts_with("PrecipTotParETP."), names_to = "Saison", values_to = "PrecipTotParETP") %>%
  mutate(Saison = gsub("PrecipTotParETP.", "", Saison))

# Définir l'ordre des saisons
season_order <- c("DJF", "MAM", "JJA", "SON")
data$Saison <- factor(data$Saison, levels = season_order)

# Tracer un graphique avec ggplot

couleurs <- c("#082158", "#234DA0", "#2498C0", "#73C8BC", "#D6EFB2", "#FEFED1", "#FEE187", "#FDAA48", "#FC5A2D", "#D30F1F", "#800026")
#~ png(paste0(folder_input_,"/../../Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/PrecipTotalesParETPSaisons_20230707.png"),
#     width = 1200, height = 750,
#     units = "px", pointsize = 12)
x11()
ggplot(data, aes(x = factor(Saison), y = PrecipTotParETP, color = as.factor(AnneeHydro), group = AnneeHydro)) +
  geom_line(lwd = 2) +
  labs(x = "Saison", y = "Precipitations Totales", color = "Année") +
  scale_color_manual(values = couleurs, name = "Année") +
  theme_minimal()
#~ dev.off()


#~write.table(df_wide, "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/MoyennesAnneesMoisSaisons/df_wide_PrecipTotalesSaisons_20230706.csv", sep = ",", dec = ".", row.names = F)
length(df_wide$PrecipTotMoyenne.DJF) - rank(df_wide$PrecipTotMoyenne.DJF) + 1
length(df_wide$PrecipTotMoyenne.JJA) - rank(df_wide$PrecipTotMoyenne.JJA) + 1
length(df_wide$PrecipTotMoyenne.MAM) - rank(df_wide$PrecipTotMoyenne.MAM) + 1
length(df_wide$PrecipTotMoyenne.SON) - rank(df_wide$PrecipTotMoyenne.SON) + 1

