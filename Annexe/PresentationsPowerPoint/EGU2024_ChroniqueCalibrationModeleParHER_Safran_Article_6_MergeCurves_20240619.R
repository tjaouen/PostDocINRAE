### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")

library(lubridate)
library(ggplot2)
library(svglite)
library(readxl)
library(strex)
library(dplyr)
library(tidyr)
library(zoo)

# HER_h_ = 13
# HER_h_ = 105
# HER_h_ = 36


### Parameters ###
nom_categorieSimu_ <- nom_categorieSimu_param_

# HER_h_ <- 57
HER_h_ <- 81
# HER_h_ <- 12
# HER_h_ <- 13
# HER_h_ <- 105

# model_ = "CTRIP"
# date_max_ <- as.Date("2020-12-31")

# model_ = "GRSD"
# date_max_ <- as.Date("2019-07-31")

# model_ = "J2000"
# date_max_ <- as.Date("2022-12-31")

# model_ = "ORCHIDEE"
# date_max_ <- as.Date("2019-07-31")

# model_ = "SMASH"
# date_max_ <- as.Date("2019-07-31")


### Parameters ###
chro_CTRIP = read.table(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_ChroniquesProba_LearnBrut_HER",HER_h_,".txt"),
                        sep = ";", dec = ".", header = T)
colnames(chro_CTRIP) <- gsub("^X", "", colnames(chro_CTRIP))
chro_CTRIP <- chro_CTRIP[which(chro_CTRIP$Type == "Safran" & year(chro_CTRIP$Date) >= 2012 & year(chro_CTRIP$Date) <= 2022),]
chro_CTRIP <- subset(chro_CTRIP, select = -c(Type))
chro_CTRIP$Mediane <- apply(chro_CTRIP[, grepl("debit_France", colnames(chro_CTRIP))], 1, median, na.rm = TRUE)
chro_CTRIP$HM <- "CTRIP"
chro_CTRIP$Date <- as.Date(chro_CTRIP$Date)
head(chro_CTRIP)


chro_GRSD = read.table(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_ChroniquesProba_LearnBrut_HER",HER_h_,".txt"),
                       sep = ";", dec = ".", header = T)
colnames(chro_GRSD) <- gsub("^X", "", colnames(chro_GRSD))
chro_GRSD <- chro_GRSD[which(chro_GRSD$Type == "Safran" & year(chro_GRSD$Date) >= 2012 & year(chro_GRSD$Date) <= 2022),]
chro_GRSD <- subset(chro_GRSD, select = -c(Type))
chro_GRSD$Mediane <- apply(chro_GRSD[, grepl("debit_France", colnames(chro_GRSD))], 1, median, na.rm = TRUE)
chro_GRSD$HM <- "GRSD"
chro_GRSD$Date <- as.Date(chro_GRSD$Date)

if (file.exists(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_ChroniquesProba_LearnBrut_HER",HER_h_,".txt"))){
  chro_J2000 = read.table(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_ChroniquesProba_LearnBrut_HER",HER_h_,".txt"),
                          sep = ";", dec = ".", header = T)
  colnames(chro_J2000) <- gsub("^X", "", colnames(chro_J2000))
  chro_J2000 <- chro_J2000[which(chro_J2000$Type == "Safran" & year(chro_J2000$Date) >= 2012 & year(chro_J2000$Date) <= 2022),]
  chro_J2000 <- subset(chro_J2000, select = -c(Type))
  chro_J2000$Mediane <- apply(chro_J2000[, grepl("debit_Rhone", colnames(chro_J2000))], 1, median, na.rm = TRUE)
  chro_J2000$HM <- "J2000"
  chro_J2000$Date <- as.Date(chro_J2000$Date)
  
  J2000_test_ <- T
}else{
  J2000_test_ <- F
}

chro_ORCHIDEE = read.table(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_ChroniquesProba_LearnBrut_HER",HER_h_,".txt"),
                           sep = ";", dec = ".", header = T)
colnames(chro_ORCHIDEE) <- gsub("^X", "", colnames(chro_ORCHIDEE))
chro_ORCHIDEE <- chro_ORCHIDEE[which(chro_ORCHIDEE$Type == "Safran" & year(chro_ORCHIDEE$Date) >= 2012 & year(chro_ORCHIDEE$Date) <= 2022),]
chro_ORCHIDEE <- subset(chro_ORCHIDEE, select = -c(Type))
chro_ORCHIDEE$Mediane <- apply(chro_ORCHIDEE[, grepl("debit_France", colnames(chro_ORCHIDEE))], 1, median, na.rm = TRUE)
chro_ORCHIDEE$HM <- "ORCHIDEE"
chro_ORCHIDEE$Date <- as.Date(chro_ORCHIDEE$Date)


chro_SMASH = read.table(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_ChroniquesProba_LearnBrut_HER",HER_h_,".txt"),
                        sep = ";", dec = ".", header = T)
colnames(chro_SMASH) <- gsub("^X", "", colnames(chro_SMASH))
chro_SMASH <- chro_SMASH[which(chro_SMASH$Type == "Safran" & year(chro_SMASH$Date) >= 2012 & year(chro_SMASH$Date) <= 2022),]
chro_SMASH <- subset(chro_SMASH, select = -c(Type))
chro_SMASH$Mediane <- apply(chro_SMASH[, grepl("debit_France", colnames(chro_SMASH))], 1, median, na.rm = TRUE)
chro_SMASH$HM <- "SMASH"
chro_SMASH$Date <- as.Date(chro_SMASH$Date)

### Ramener les tables a la date max ###
if (J2000_test_){
  date_max_ <- max(as.Date(chro_CTRIP$Date),
                   as.Date(chro_GRSD$Date),
                   as.Date(chro_J2000$Date),
                   as.Date(chro_ORCHIDEE$Date),
                   as.Date(chro_SMASH$Date))
  
  all_dates <- seq(min(as.Date(chro_J2000$Date)), date_max_, by = "day") # Générer toutes les dates entre la première date et date_max
  all_dates_df <- data.frame(Date = all_dates,
                             HM = "J2000") # Créer un data.frame avec toutes les dates
  chro_J2000 <- all_dates_df %>%
    left_join(chro_J2000, by = c("Date","HM")) # Fusionner votre data.frame original avec ce nouvel ensemble de dates
}else{
  date_max_ <- max(as.Date(chro_CTRIP$Date),
                   as.Date(chro_GRSD$Date),
                   as.Date(chro_ORCHIDEE$Date),
                   as.Date(chro_SMASH$Date))
}

all_dates <- seq(min(as.Date(chro_CTRIP$Date)), date_max_, by = "day") # Générer toutes les dates entre la première date et date_max
all_dates_df <- data.frame(Date = all_dates,
                           HM = "CTRIP") # Créer un data.frame avec toutes les dates
chro_CTRIP <- all_dates_df %>%
  left_join(chro_CTRIP, by = c("Date","HM")) # Fusionner votre data.frame original avec ce nouvel ensemble de dates

all_dates <- seq(min(as.Date(chro_GRSD$Date)), date_max_, by = "day") # Générer toutes les dates entre la première date et date_max
all_dates_df <- data.frame(Date = all_dates,
                           HM = "GRSD") # Créer un data.frame avec toutes les dates
chro_GRSD <- all_dates_df %>%
  left_join(chro_GRSD, by = c("Date","HM")) # Fusionner votre data.frame original avec ce nouvel ensemble de dates

all_dates <- seq(min(as.Date(chro_ORCHIDEE$Date)), date_max_, by = "day") # Générer toutes les dates entre la première date et date_max
all_dates_df <- data.frame(Date = all_dates,
                           HM = "ORCHIDEE") # Créer un data.frame avec toutes les dates
chro_ORCHIDEE <- all_dates_df %>%
  left_join(chro_ORCHIDEE, by = c("Date","HM")) # Fusionner votre data.frame original avec ce nouvel ensemble de dates

all_dates <- seq(min(as.Date(chro_SMASH$Date)), date_max_, by = "day") # Générer toutes les dates entre la première date et date_max
all_dates_df <- data.frame(Date = all_dates,
                           HM = "SMASH") # Créer un data.frame avec toutes les dates
chro_SMASH <- all_dates_df %>%
  left_join(chro_SMASH, by = c("Date","HM")) # Fusionner votre data.frame original avec ce nouvel ensemble de dates

### Run ###
# chro_ = read.table(paste0("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Tab_ChroniquesProba_LearnBrut_ByHer/FDC_Observes/Mod_DebitsComplets_From20120101_To20221231/Tab_ChroniquesProba_LearnBrut_ByHer.txt"),
#                    sep = ";", dec = ".", header = T)
# colnames(chro_) <- gsub("^X", "", colnames(chro_))
# chro_ <- chro_[,c("Date","Type",as.character(HER_h_))]

# chro_ <- chro_[which(chro_$Type == "Safran" & year(chro_$Date) >= 2012 & chro_$Date <= date_max_),]
# # chro_ <- chro_[which(chro_$Type == "Safran" & year(chro_$Date) >= 2012 & year(chro_$Date) <= 2019),]
# # chro_ <- chro_[which(chro_$Type == "Observes" & year(chro_$Date) >= 2012 & year(chro_$Date) <= 2022),]
# chro_ <- subset(chro_, select = -c(Type))
# # chro_ <- subset(chro_, select = -c(Type, Jour_annee))
# # chro_$Mediane <- apply(chro_[, -1], 1, median)
# chro_$Mediane <- chro_[,2]

### VALEURS ONDE ###
# tab_onde_ <- read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_20050801-21000731/MatInputModel_CampOndeExcl_ByHERDates_2012_2022_Projections_Weight_merge.csv",
tab_onde_ <- read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/MatInputModel_ByHERDates__2012_2022_Observes_Weight_merge.csv",
                        sep = ",", dec = ".", header = T)
tab_onde_3_ <- tab_onde_[which(tab_onde_$HER2 == HER_h_),]
tab_onde_3_[,c("X._Assec","Date")]

tab_onde_3_$Date <- as.Date(tab_onde_3_$Date)
# tab_onde_3_ <- tab_onde_3_[which(year(tab_onde_3_$Date) >= 2012 & tab_onde_3_$Date <= "2022-12-31"),]
# tab_onde_3_ <- tab_onde_3_[which(year(tab_onde_3_$Date) >= 2012 & tab_onde_3_$Date <= "2019-07-31"),]
tab_onde_3_ <- tab_onde_3_[which(year(tab_onde_3_$Date) >= 2012 & tab_onde_3_$Date <= date_max_),]

ratio_epaisseurs_ = 1.5
# ratio_epaisseurs_ = 0.8

### Description HER ###
descriptionHER_ = read_excel(paste0(folder_HER_DataDescription_,"../HER2officielles/DescriptionHER2_3_20240313.xlsx"))

### Rcp ###
# df_mean_rcp_ = df_mean[which(df_mean$Type == pattern_rcp_),]
# df_mean_overwriteColors_rcp_ = df_mean_overwriteColors_[which(df_mean_overwriteColors_$Type == pattern_rcp_),]

chro_CTRIP_mediane_ <- chro_CTRIP[,c("Date","Mediane","HM")]
chro_GRSD_mediane_ <- chro_GRSD[,c("Date","Mediane","HM")]
if (J2000_test_){chro_J2000_mediane_ <- chro_J2000[,c("Date","Mediane","HM")]}
chro_ORCHIDEE_mediane_ <- chro_ORCHIDEE[,c("Date","Mediane","HM")]
chro_SMASH_mediane_ <- chro_SMASH[,c("Date","Mediane","HM")]

chro_CTRIP_mediane_$Mediane_Smoothed <- rollmean(chro_CTRIP_mediane_$Mediane, 30, fill = NA, align = "right")
chro_GRSD_mediane_$Mediane_Smoothed <- rollmean(chro_GRSD_mediane_$Mediane, 30, fill = NA, align = "right")
if (J2000_test_){chro_J2000_mediane_$Mediane_Smoothed <- rollmean(chro_J2000_mediane_$Mediane, 30, fill = NA, align = "right")}
chro_ORCHIDEE_mediane_$Mediane_Smoothed <- rollmean(chro_ORCHIDEE_mediane_$Mediane, 30, fill = NA, align = "right")
chro_SMASH_mediane_$Mediane_Smoothed <- rollmean(chro_SMASH_mediane_$Mediane, 30, fill = NA, align = "right")

# Suppose chro_ is your original dataset
if (J2000_test_){
  chro_ <- rbind(chro_CTRIP_mediane_,
                 chro_GRSD_mediane_,
                 chro_J2000_mediane_,
                 chro_ORCHIDEE_mediane_,
                 chro_SMASH_mediane_)
}else{
  chro_ <- rbind(chro_CTRIP_mediane_,
                 chro_GRSD_mediane_,
                 chro_ORCHIDEE_mediane_,
                 chro_SMASH_mediane_)
}
chro_interp <- chro_ %>%
  mutate(Date = as.Date(Date)) %>%
  complete(Date = seq.Date(min(Date), max(Date), by = "day")) %>%
  fill(Mediane, .direction = "downup") %>% # or other interpolation method
  mutate(Interpolated = is.na(Mediane)) # Flag interpolated values

custom_colors <- c("CTRIP" = "#969696",
                   "GRSD" = "#bd0026",
                   "J2000" = "#238b45",
                   "ORCHIDEE" = "#253494",
                   "SMASH" = "#fe9929")

p_mean <- ggplot() +
  
  geom_line(data = chro_, aes(x = as.Date(Date), y = Mediane_Smoothed, group = HM, lineend = "round", color = HM), lwd = 0.5*ratio_epaisseurs_, lineend = "round") + # linetype = Type, color = Legend, 
  # geom_line(data = chro_[which(chro_$HM == "J2000"),], aes(x = as.Date(Date), y = Mediane_Smoothed, group = HM, lineend = "round", color = HM), lwd = 0.5*ratio_epaisseurs_, lineend = "round") + # linetype = Type, color = Legend, 

  # Interpolated line with dotted style
  # geom_line(data = chro_interp, #%>% filter(Interpolated == TRUE),
  #           aes(x = Date, y = Mediane, group = 1),
  #           linetype = "dotted", lwd = 1 * ratio_epaisseurs_, color = "#cc4c02") +
  
  geom_point(data = tab_onde_3_, mapping = aes(x = Date, y = X._Assec), color = "#2f2f32", size = 5*ratio_epaisseurs_) +
  geom_point(data = tab_onde_3_, mapping = aes(x = Date, y = X._Assec), color = "#fe9929", size = 3*ratio_epaisseurs_) +
  
  # Axes #
  scale_x_date(breaks = c(as.Date("2012-01-01"),
                          as.Date("2014-01-01"),
                          as.Date("2016-01-01"),
                          as.Date("2018-01-01"),
                          as.Date("2020-01-01"),
                          as.Date("2022-01-01")), 
               expand = c(0.05,0.05),
               # limits = c(as.Date("2015-01-01"),
               #            as.Date("2016-12-31")),
               limits = c(as.Date("2012-01-01"),
                          as.Date(date_max_)),
               # as.Date("2022-10-01")),
               date_labels = "%Y") +
  # scale_x_date(breaks = seq(min(tab_onde_3_$Date),max(tab_onde_3_$Date), length = 6), date_labels = "%Y") +
  scale_y_continuous(limits = c(0,70),
                     # limits = c(0,100),
                     expand = c(0, 2),
                     breaks = c(0,20,40,60,75,100),
                     labels = c("0%","20%","40%","60%","","100%")) +
  
  # scale_x_date("Date",
  #              breaks = breaks_dates_,
  #              labels = year_labels,
  #              expand = c(0,0),
  #              minor_breaks=c(seq(from=as.Date("2012-01-01"),to=as.Date("2023-12-31"),by="year"),"2023-12-31")) +
  # scale_y_continuous(expand = expansion(mult = c(0, 0.05)))+
  #                    # limits = c(0,100),
  #                    # breaks = seq(0,100,by=20),
  #                    # labels = function(x) paste0(x, "%")) + # Supprimer l'espace entre l'axe des abscisses et la première valeur de y
  
labs(title = "Moyenne des probabilités d'assecs lissées sur 5 jours",
     # subtitle = paste0("HER 57 Tables calcaires Haute Normandie Picardie"),
     subtitle = paste0("HER ",HER_h_," ",descriptionHER_$NomHER2[which(descriptionHER_$CdHER2 == HER_h_)]),#,
     # "\nPériode : ",year(date_intervalle_[1]),"-",year(date_intervalle_[2]),
     # " - Modèle hydrologique : ",str_before_first(nom_categorieSimu_,"_")),
     x = "Date",
     y = "PFI") +
  
  theme_minimal() +
  theme(plot.title = element_blank(),
        # plot.title = element_text(color = "#060403", size = 30, face = "bold"),
        plot.subtitle = element_text(color = "#2f2f32", size = 18*ratio_epaisseurs_),
        plot.margin = margin(20, 20, 20, 20),
        
        axis.title.x = element_blank(),
        # axis.title.y = element_blank(),
        axis.title.y = element_text(color = "#2f2f32", size = 18*ratio_epaisseurs_),
        axis.text.x = element_text(color = "#2f2f32", vjust = 0, hjust=c(0.5,0.5,0.5,0.5,0.5), size = 18*ratio_epaisseurs_), # angle = 90
        axis.text.y = element_text(color = "#2f2f32", size = 18*ratio_epaisseurs_),
        axis.line.x = element_line(color = "#2f2f32", size = 1*ratio_epaisseurs_), # Trait des abscisses plus épais, IPCCgrey75
        axis.line.y = element_blank(), # Supprimer l'axe y
        axis.ticks.x=element_line(colour=c("#2f2f32"), size = 1*ratio_epaisseurs_),
        axis.ticks.length  = unit(0.4, "cm"),
        
        panel.grid.major.x = element_blank(), # Traits horizontaux plus clairs
        panel.grid.minor.x = element_blank(), # Traits horizontaux plus clairs
        panel.grid.major.y = element_line(color = "#dcdad9", size = 0.5*ratio_epaisseurs_), # Traits horizontaux plus clairs
        panel.grid.minor.y = element_line(color = "#dcdad9", size = 0), # Traits horizontaux plus clairs
        
        text = element_text(size = 14),
        
        strip.text.x = element_blank(),
        strip.background = element_blank(),
        
        legend.title = element_text(color = "#2f2f32", size = 18), #, face = "normal"
        legend.text = element_text(color = "#2f2f32", size = 18),
        legend.margin = margin(-7, 0, 0, 0),
        legend.spacing.y = unit(+0.03, "cm"))+
  scale_color_manual(values = custom_colors,
                     name = "Hydrological model") +
  guides(color = guide_legend(override.aes = list(lwd = 2)))
# guides(alpha = guide_legend(override.aes = list(lwd = 2.5,color =levels(df_mean_nonNar_$Color)),
#                             keyheight = 3.2,
#                             keywidth = unit(2,"cm"),
#                             order = 1),
#        color = guide_legend(
#          override.aes = list(lwd = 2.5),
#          keyheight = 3.2,
#          keywidth = unit(1,"cm"),
#          title.hjust = 0.2,
#          order = 2))

# x11()
p_mean

# ggsave(filename = paste0("/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/ChroniqueCalibration_HER",HER_h_,"_2_20240521.png"),
#        plot = p_mean)


# pdf(paste0("/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/ChroniqueCalibration_HER",HER_h_,"_Observed_3_20240606.pdf"),
# pdf(paste0("/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CalibrationSafran/ChroniqueCalibration_HER",HER_h_,"_Safran_",model_,"_1_20240610.pdf"),
pdf(paste0("/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CalibrationSafran/ChroniqueCalibration_HER",HER_h_,"_Safran_1_20240709.pdf"),
    width = 18)
plot(p_mean)
dev.off()

# saveRDS(p_mean, file = paste0("/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/ChroniqueCalibration_HER",HER_h_,"_Observed_3_20240606.rds"))
# saveRDS(p_mean, file = paste0("/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CalibrationSafran/ChroniqueCalibration_HER",HER_h_,"_Safran_",model_,"_1_20240610.rds"))
saveRDS(p_mean, file = paste0("/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CalibrationSafran/ChroniqueCalibration_HER",HER_h_,"_Safran_1_20240709.rds"))

# svg_device <- svglite(paste0("/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/ChroniqueCalibration_HER",HER_h_,"_Observed_3_20240606.svg"), width = 18)#,
# svg_device <- svglite(paste0("/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CalibrationSafran/ChroniqueCalibration_HER",HER_h_,"_Safran_",model_,"_1_20240610.svg"), width = 18)#,
svg_device <- svglite(paste0("/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CalibrationSafran/ChroniqueCalibration_HER",HER_h_,"_Safran_1_20240709.svg"), width = 18)#,
plot(p_mean)
dev.off()

# png(paste0("/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/ChroniqueCalibration_HER",HER_h_,"_Observed_3_20240606.png"), width = 9*100)
# png(paste0("/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CalibrationSafran/ChroniqueCalibration_HER",HER_h_,"_Safran_",model_,"_1_20240610.png"), width = 9*100)
png(paste0("/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/CalibrationSafran/ChroniqueCalibration_HER",HER_h_,"_Safran_1_20240709.png"), width = 9*100)
plot(p_mean)
dev.off()
