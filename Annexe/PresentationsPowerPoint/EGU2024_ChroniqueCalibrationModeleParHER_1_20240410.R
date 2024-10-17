library(lubridate)

HER_h_ = 13

chro_ = read.table(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/Tab_ChroniquesProba_LearnBrut_HER",HER_h_,".txt"),
                   sep = ";", dec = ".", header = T)

chro_ <- chro_[which(chro_$Type == "Safran" & year(chro_$Date) >= 2012 & year(chro_$Date) <= 2022),]
chro_ <- subset(chro_, select = -c(Type, Jour_annee))
df_mean <- chro_ %>%
  pivot_longer(cols = -c(Date), names_to = "Variable", values_to = "Value")


### VALEURS ONDE ###
# tab_onde_ <- read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_20050801-21000731/MatInputModel_CampOndeExcl_ByHERDates_2012_2022_Projections_Weight_merge.csv",
tab_onde_ <- read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/MatInputModel_ByHERDates__2012_2022_Observes_Weight_merge.csv",
                        sep = ",", dec = ".", header = T)
tab_onde_3_ <- tab_onde_[which(tab_onde_$HER2 == HER_h_),]
tab_onde_3_[,c("X._Assec","Date")]

tab_onde_3_$Date <- as.Date(tab_onde_3_$Date)

ratio_epaisseurs_ = 2





df_mean <- df_mean %>%
  mutate(Color = case_when(
    grepl("CNRM.CERFACS.*CNRM.ALADIN63.*CDFt", Variable) ~ "black",
    grepl("CNRM.CERFACS.*CNRM.ALADIN63.*ADAMONT", Variable) ~ "#E5E840",
    grepl("CNRM.CERFACS.*MOHC.HadREM3.*CDFt", Variable) ~ "black",
    grepl("CNRM.CERFACS.*MOHC.HadREM3.*ADAMONT", Variable) ~ "black",
    grepl("ICHEC.EC.EARTH.*KNMI.RACMO22E.*CDFt", Variable) ~ "black",
    grepl("ICHEC.EC.EARTH.*KNMI.RACMO22E.*ADAMONT", Variable) ~ "black",
    grepl("ICHEC.EC.EARTH.*MOHC.HadREM3.*CDFt", Variable) ~ "black",
    grepl("ICHEC.EC.EARTH.*MOHC.HadREM3.*ADAMONT", Variable) ~ "#E2A138",
    grepl("ICHEC.EC.EARTH.*SMHI.RCA4_v2.*CDFt", Variable) ~ "black",
    grepl("ICHEC.EC.EARTH.*SMHI.RCA4_v2.*ADAMONT", Variable) ~ "black",
    grepl("IPSL.IPSL.CM5A.MR.*DMI.HIRHAM5.*CDFt", Variable) ~ "black",
    grepl("IPSL.IPSL.CM5A.MR.*DMI.HIRHAM5.*ADAMONT", Variable) ~ "black",
    grepl("IPSL.IPSL.CM5A.MR.*SMHI.RCA4_v2.*CDFt", Variable) ~ "black",
    grepl("IPSL.IPSL.CM5A.MR.*SMHI.RCA4_v2.*ADAMONT", Variable) ~ "black",
    grepl("MOHC.HadGEM2.ES.*CLMcom.CCLM4.*CDFt", Variable) ~ "black",
    grepl("MOHC.HadGEM2.ES.*CLMcom.CCLM4.*ADAMONT", Variable) ~ "#70194E",
    grepl("MOHC.HadGEM2.ES.*CNRM.ALADIN63.*CDFt", Variable) ~ "black",
    grepl("MOHC.HadGEM2.ES.*CNRM.ALADIN63.*ADAMONT", Variable) ~ "#447C57",
    grepl("MOHC.HadGEM2.ES.*ICTP.RegCM4.6.*CDFt", Variable) ~ "black",
    grepl("MOHC.HadGEM2.ES.*ICTP.RegCM4.6.*ADAMONT", Variable) ~ "black",
    grepl("MOHC.HadGEM2.ES.*MOHC.HadREM3.GA7.*CDFt", Variable) ~ "black",
    grepl("MOHC.HadGEM2.ES.*MOHC.HadREM3.GA7.*ADAMONT", Variable) ~ "black",
    grepl("MPI.M.MPI.ESM.LR.*CLMcom.CCLM4.*CDFt", Variable) ~ "black",
    grepl("MPI.M.MPI.ESM.LR.*CLMcom.CCLM4.*ADAMONT", Variable) ~ "black",
    grepl("MPI.M.MPI.ESM.LR.*ICTP.RegCM4.6.*CDFt", Variable) ~ "black",
    grepl("MPI.M.MPI.ESM.LR.*ICTP.RegCM4.6.*ADAMONT", Variable) ~ "black",
    grepl("MPI.M.MPI.ESM.LR.*MPI.CSC.REMO2009.*CDFt", Variable) ~ "black",
    grepl("MPI.M.MPI.ESM.LR.*MPI.CSC.REMO2009.*ADAMONT", Variable) ~ "black",
    grepl("NCC.NorESM1.M.*DMI.HIRHAM5.*CDFt", Variable) ~ "black",
    grepl("NCC.NorESM1.M.*DMI.HIRHAM5.*ADAMONT", Variable) ~ "black",
    grepl("NCC.NorESM1.M.*GERICS.REMO2015.*CDFt", Variable) ~ "black",
    grepl("NCC.NorESM1.M.*GERICS.REMO2015.*ADAMONT", Variable) ~ "black",
    grepl("NCC.NorESM1.M.*IPSL.WRF381P.*CDFt", Variable) ~ "black",
    grepl("NCC.NorESM1.M.*IPSL.WRF381P.*ADAMONT", Variable) ~ "black",
    grepl("Safran", Variable) ~ "#253494"))

df_mean <- df_mean %>%
  mutate(Alpha = case_when(
    grepl("CNRM.CERFACS.*CNRM.ALADIN63.*CDFt", Variable) ~ 0.15,
    grepl("CNRM.CERFACS.*CNRM.ALADIN63.*ADAMONT", Variable) ~ 1,
    grepl("CNRM.CERFACS.*MOHC.HadREM3.*CDFt", Variable) ~ 0.15,
    grepl("CNRM.CERFACS.*MOHC.HadREM3.*ADAMONT", Variable) ~ 0.15,
    grepl("ICHEC.EC.EARTH.*KNMI.RACMO22E.*CDFt", Variable) ~ 0.15,
    grepl("ICHEC.EC.EARTH.*KNMI.RACMO22E.*ADAMONT", Variable) ~ 0.15,
    grepl("ICHEC.EC.EARTH.*MOHC.HadREM3.*CDFt", Variable) ~ 0.15,
    grepl("ICHEC.EC.EARTH.*MOHC.HadREM3.*ADAMONT", Variable) ~ 1,
    grepl("ICHEC.EC.EARTH.*SMHI.RCA4_v2.*CDFt", Variable) ~ 0.15,
    grepl("ICHEC.EC.EARTH.*SMHI.RCA4_v2.*ADAMONT", Variable) ~ 0.15,
    grepl("IPSL.IPSL.CM5A.MR.*DMI.HIRHAM5.*CDFt", Variable) ~ 0.15,
    grepl("IPSL.IPSL.CM5A.MR.*DMI.HIRHAM5.*ADAMONT", Variable) ~ 0.15,
    grepl("IPSL.IPSL.CM5A.MR.*SMHI.RCA4_v2.*CDFt", Variable) ~ 0.15,
    grepl("IPSL.IPSL.CM5A.MR.*SMHI.RCA4_v2.*ADAMONT", Variable) ~ 0.15,
    grepl("MOHC.HadGEM2.ES.*CLMcom.CCLM4.*CDFt", Variable) ~ 0.15,
    grepl("MOHC.HadGEM2.ES.*CLMcom.CCLM4.*ADAMONT", Variable) ~ 1,
    grepl("MOHC.HadGEM2.ES.*CNRM.ALADIN63.*CDFt", Variable) ~ 0.15,
    grepl("MOHC.HadGEM2.ES.*CNRM.ALADIN63.*ADAMONT", Variable) ~ 1,
    grepl("MOHC.HadGEM2.ES.*ICTP.RegCM4.6.*CDFt", Variable) ~ 0.15,
    grepl("MOHC.HadGEM2.ES.*ICTP.RegCM4.6.*ADAMONT", Variable) ~ 0.15,
    grepl("MOHC.HadGEM2.ES.*MOHC.HadREM3.GA7.*CDFt", Variable) ~ 0.15,
    grepl("MOHC.HadGEM2.ES.*MOHC.HadREM3.GA7.*ADAMONT", Variable) ~ 0.15,
    grepl("MPI.M.MPI.ESM.LR.*CLMcom.CCLM4.*CDFt", Variable) ~ 0.15,
    grepl("MPI.M.MPI.ESM.LR.*CLMcom.CCLM4.*ADAMONT", Variable) ~ 0.15,
    grepl("MPI.M.MPI.ESM.LR.*ICTP.RegCM4.6.*CDFt", Variable) ~ 0.15,
    grepl("MPI.M.MPI.ESM.LR.*ICTP.RegCM4.6.*ADAMONT", Variable) ~ 0.15,
    grepl("MPI.M.MPI.ESM.LR.*MPI.CSC.REMO2009.*CDFt", Variable) ~ 0.15,
    grepl("MPI.M.MPI.ESM.LR.*MPI.CSC.REMO2009.*ADAMONT", Variable) ~ 0.15,
    grepl("NCC.NorESM1.M.*DMI.HIRHAM5.*CDFt", Variable) ~ 0.15,
    grepl("NCC.NorESM1.M.*DMI.HIRHAM5.*ADAMONT", Variable) ~ 0.15,
    grepl("NCC.NorESM1.M.*GERICS.REMO2015.*CDFt", Variable) ~ 0.15,
    grepl("NCC.NorESM1.M.*GERICS.REMO2015.*ADAMONT", Variable) ~ 0.15,
    grepl("NCC.NorESM1.M.*IPSL.WRF381P.*CDFt", Variable) ~ 0.15,
    grepl("NCC.NorESM1.M.*IPSL.WRF381P.*ADAMONT", Variable) ~ 0.15,
    grepl("Safran", Variable) ~ 1))

df_mean <- df_mean %>%
  mutate(Legend = case_when(
    grepl("CNRM.CERFACS.*CNRM.ALADIN63.*CDFt", Variable) ~ "Autres modèles",
    grepl("CNRM.CERFACS.*CNRM.ALADIN63.*ADAMONT", Variable) ~ "Modéré en réchauffement et\nen changement de précipitations",
    grepl("CNRM.CERFACS.*MOHC.HadREM3.*CDFt", Variable) ~ "Autres modèles",
    grepl("CNRM.CERFACS.*MOHC.HadREM3.*ADAMONT", Variable) ~ "Autres modèles",
    grepl("ICHEC.EC.EARTH.*KNMI.RACMO22E.*CDFt", Variable) ~ "Autres modèles",
    grepl("ICHEC.EC.EARTH.*KNMI.RACMO22E.*ADAMONT", Variable) ~ "Autres modèles",
    grepl("ICHEC.EC.EARTH.*MOHC.HadREM3.*CDFt", Variable) ~ "Autres modèles",
    grepl("ICHEC.EC.EARTH.*MOHC.HadREM3.*ADAMONT", Variable) ~ "Sec toute l'année,\nrecharge moindre en hiver",
    grepl("ICHEC.EC.EARTH.*SMHI.RCA4_v2.*CDFt", Variable) ~ "Autres modèles",
    grepl("ICHEC.EC.EARTH.*SMHI.RCA4_v2.*ADAMONT", Variable) ~ "Autres modèles",
    grepl("IPSL.IPSL.CM5A.MR.*DMI.HIRHAM5.*CDFt", Variable) ~ "Autres modèles",
    grepl("IPSL.IPSL.CM5A.MR.*DMI.HIRHAM5.*ADAMONT", Variable) ~ "Autres modèles",
    grepl("IPSL.IPSL.CM5A.MR.*SMHI.RCA4_v2.*CDFt", Variable) ~ "Autres modèles",
    grepl("IPSL.IPSL.CM5A.MR.*SMHI.RCA4_v2.*ADAMONT", Variable) ~ "Autres modèles",
    grepl("MOHC.HadGEM2.ES.*CLMcom.CCLM4.*CDFt", Variable) ~ "Autres modèles",
    grepl("MOHC.HadGEM2.ES.*CLMcom.CCLM4.*ADAMONT", Variable) ~ "Fort réchauffement et\nfort assèchement en été",
    grepl("MOHC.HadGEM2.ES.*CNRM.ALADIN63.*CDFt", Variable) ~ "Autres modèles",
    grepl("MOHC.HadGEM2.ES.*CNRM.ALADIN63.*ADAMONT", Variable) ~ "Chaud et humide\nà toutes les saisons",
    grepl("MOHC.HadGEM2.ES.*ICTP.RegCM4.6.*CDFt", Variable) ~ "Autres modèles",
    grepl("MOHC.HadGEM2.ES.*ICTP.RegCM4.6.*ADAMONT", Variable) ~ "Autres modèles",
    grepl("MOHC.HadGEM2.ES.*MOHC.HadREM3.GA7.*CDFt", Variable) ~ "Autres modèles",
    grepl("MOHC.HadGEM2.ES.*MOHC.HadREM3.GA7.*ADAMONT", Variable) ~ "Autres modèles",
    grepl("MPI.M.MPI.ESM.LR.*CLMcom.CCLM4.*CDFt", Variable) ~ "Autres modèles",
    grepl("MPI.M.MPI.ESM.LR.*CLMcom.CCLM4.*ADAMONT", Variable) ~ "Autres modèles",
    grepl("MPI.M.MPI.ESM.LR.*ICTP.RegCM4.6.*CDFt", Variable) ~ "Autres modèles",
    grepl("MPI.M.MPI.ESM.LR.*ICTP.RegCM4.6.*ADAMONT", Variable) ~ "Autres modèles",
    grepl("MPI.M.MPI.ESM.LR.*MPI.CSC.REMO2009.*CDFt", Variable) ~ "Autres modèles",
    grepl("MPI.M.MPI.ESM.LR.*MPI.CSC.REMO2009.*ADAMONT", Variable) ~ "Autres modèles",
    grepl("NCC.NorESM1.M.*DMI.HIRHAM5.*CDFt", Variable) ~ "Autres modèles",
    grepl("NCC.NorESM1.M.*DMI.HIRHAM5.*ADAMONT", Variable) ~ "Autres modèles",
    grepl("NCC.NorESM1.M.*GERICS.REMO2015.*CDFt", Variable) ~ "Autres modèles",
    grepl("NCC.NorESM1.M.*GERICS.REMO2015.*ADAMONT", Variable) ~ "Autres modèles",
    grepl("NCC.NorESM1.M.*IPSL.WRF381P.*CDFt", Variable) ~ "Autres modèles",
    grepl("NCC.NorESM1.M.*IPSL.WRF381P.*ADAMONT", Variable) ~ "Autres modèles",
    grepl("Safran", Variable) ~ "Safran"))

translation_dict <- c("Modéré en réchauffement et\nen changement de précipitations" = "Moderate warming and\nprecipitation change",
                      "Sec toute l'année,\nrecharge moindre en hiver" = "Dry all year round,\nreduced winter recharge",
                      "Fort réchauffement et\nfort assèchement en été" = "Strong warming and\nsummer drying",
                      "Chaud et humide\nà toutes les saisons" = "Hot and humid\nall seasons",
                      "Autres modèles" = "Other models",
                      "Safran" = "Safran")
df_mean <- df_mean %>%
  mutate(Legend_English = translation_dict[Legend])

### Legende ###
variables_a_afficher <- unique(df_mean$Legend[which(df_mean$Alpha == 1)])
df_mean$AfficherDansLegende <- ifelse(df_mean$Legend %in% variables_a_afficher, as.character(df_mean$Legend), "")

desired_order <- c(unique(df_mean$Legend[which(df_mean$Color == "#E5E840")]),
                   unique(df_mean$Legend[which(df_mean$Color == "#E2A138")]),
                   unique(df_mean$Legend[which(df_mean$Color == "#70194E")]),
                   unique(df_mean$Legend[which(df_mean$Color == "#447C57")]),
                   unique(df_mean$Legend[which(df_mean$Color == "#253494")]),
                   "")

df_mean$AfficherDansLegende <- factor(df_mean$AfficherDansLegende, levels = c(desired_order))

custom_colors <- c("Modéré en réchauffement et\nen changement de précipitations" = "#E5E840",
                   "Sec toute l'année,\nrecharge moindre en hiver" = "#E2A138",
                   "Fort réchauffement et\nfort assèchement en été" = "#70194E",
                   "Chaud et humide\nà toutes les saisons" = "#447C57",
                   "Autres modèles" = "black")
desired_order <- c("Modéré en réchauffement et\nen changement de précipitations",
                   "Sec toute l'année,\nrecharge moindre en hiver",
                   "Fort réchauffement et\nfort assèchement en été",
                   "Chaud et humide\nà toutes les saisons",
                   "Autres modèles")
desired_order_english <- c("Moderate warming and\nprecipitation change",
                           "Dry all year round,\nreduced winter recharge",
                           "Strong warming and\nsummer drying",
                           "Hot and humid\nall seasons",
                           "Other models")

desired_order_lty <- c(pattern_rcp_)

df_mean$Color <- factor(df_mean$Color, levels = intersect(c("#E5E840", "#E2A138", "#70194E", "#447C57","#253494","black"), levels(factor(df_mean$Color))))
df_mean$Legend <- factor(df_mean$Legend, levels = desired_order)
df_mean$Legend_English <- factor(df_mean$Legend_English, levels = desired_order_english)

### Lissage ###
# df_mean <- df_mean %>%
#   group_by(Variable) %>%
#   mutate(Mean_ValueLissee = (lag(Mean_Value, 2) + lag(Mean_Value, 1) + Mean_Value + lead(Mean_Value, 1) + lead(Mean_Value, 2)) / 5) %>%
#   mutate(Median_ValueLissee = (lag(Median_Value, 2) + lag(Median_Value, 1) + Median_Value + lead(Median_Value, 1) + lead(Median_Value, 2)) / 5)

df_mean_overwriteColors_ <- df_mean[which(df_mean$Legend %in% c("Modéré en réchauffement et\nen changement de précipitations",
                                                                "Sec toute l'année,\nrecharge moindre en hiver",
                                                                "Fort réchauffement et\nfort assèchement en été",
                                                                "Chaud et humide\nà toutes les saisons",
                                                                "Safran")),]

df_mean_nonNar_ <- df_mean[which(!(df_mean$Legend %in% c("Modéré en réchauffement et\nen changement de précipitations",
                                                         "Sec toute l'année,\nrecharge moindre en hiver",
                                                         "Fort réchauffement et\nfort assèchement en été",
                                                         "Chaud et humide\nà toutes les saisons"))),]
df_mean_nonNar_$Color <- factor(df_mean_nonNar_$Color, levels = intersect(c("#E5E840", "#E2A138", "#70194E", "#447C57","#253494","black"), levels(factor(df_mean_nonNar_$Color))))
df_mean_nonNar_$Legend <- factor(df_mean_nonNar_$Legend, levels = intersect(desired_order, levels(factor(df_mean_nonNar_$Legend))))
df_mean_nonNar_$Legend_English <- factor(df_mean_nonNar_$Legend_English, levels = intersect(desired_order_english, levels(factor(df_mean_nonNar_$Legend_English))))
df_mean_nonNar_$Variable <- factor(df_mean_nonNar_$Variable, levels = unique(df_mean_nonNar_$Variable))
df_mean_nonNar_$Alpha <- factor(df_mean_nonNar_$Alpha, levels = c(0.15))

df_mean_nar_ <- df_mean[which(df_mean$Legend %in% c("Modéré en réchauffement et\nen changement de précipitations",
                                                    "Sec toute l'année,\nrecharge moindre en hiver",
                                                    "Fort réchauffement et\nfort assèchement en été",
                                                    "Chaud et humide\nà toutes les saisons")),]
df_mean_nar_$Color <- factor(df_mean_nar_$Color, levels = intersect(c("#E5E840", "#E2A138", "#70194E", "#447C57","#253494","black"), levels(factor(df_mean_nar_$Color))))
df_mean_nar_$Legend <- factor(df_mean_nar_$Legend, levels = intersect(desired_order, levels(factor(df_mean_nar_$Legend))))
df_mean_nar_$Legend_English <- factor(df_mean_nar_$Legend_English, levels = intersect(desired_order_english, levels(factor(df_mean_nar_$Legend_English))))
df_mean_nar_$Variable <- factor(df_mean_nar_$Variable, levels = unique(df_mean_nar_$Variable))

### Axe x ###
first_days <- df_mean[which(day(as.Date(df_mean$Jour_annee)) == 15),]
# year_labels <- rep(c('Janv.','Févr.','Mars','Avril','Mai','Juin','Juil.','Août','Sept.','Oct.','Nov.','Déc.'))
year_labels <- rep(c('J','F','M','A','M','J','J','A','S','O','N','D'))
year_labels <- c("", as.vector(rbind(year_labels, rep("", length(year_labels)))))
# year_labels_eng <- rep(c('Jan.','Feb.','Mar.','Apr.','May','Jun.','Jul.','Aug.','Sep.','Oct.','Nov.','Dec.'))
year_labels_eng <- rep(c('J','F','M','A','M','J','J','A','S','O','N','D'))
year_labels_eng <- c("", as.vector(rbind(year_labels_eng, rep("", length(year_labels_eng)))))
breaks_dates_ <- sort(c(seq(as.Date("2022-01-01"), 
                            as.Date("2022-12-01"), by="months"),
                        "2022-01-15","2022-02-14","2022-03-16","2022-04-15","2022-05-16","2022-06-15","2022-07-16","2022-08-16","2022-09-15","2022-10-16","2022-11-15","2022-12-16",
                        "2022-12-31"))

### Rcp ###
# df_mean_rcp_ = df_mean[which(df_mean$Type == pattern_rcp_),]
# df_mean_overwriteColors_rcp_ = df_mean_overwriteColors_[which(df_mean_overwriteColors_$Type == pattern_rcp_),]

p_mean <- ggplot() +
  
  geom_line(data = df_mean_nonNar_, aes(x = as.Date(Date), y = Value, group = Variable, lineend = "round", alpha = Alpha), lwd = 0.2) + # linetype = Type, color = Legend, 
  scale_alpha_manual(name = "Forçage climatique",
                     values = as.numeric(levels(df_mean_nonNar_$Alpha)),
                     labels = levels(df_mean_nonNar_$Legend))+
  
  geom_line(data = df_mean_nar_, aes(x = as.Date(Date), y = Value, group = Variable, color = Legend, lineend = "round"), alpha = 1, lwd = 0.2) + # linetype = Type,
  scale_color_manual(name = "dont narratifs :",
                     values = levels(df_mean_nar_$Color),
                     guide = "legend")+
  # Axes #
  scale_x_date(breaks = c(as.Date("2012-01-01"),
                          as.Date("2014-01-01"),
                          as.Date("2016-01-01"),
                          as.Date("2018-01-01"),
                          as.Date("2020-01-01"),
                          as.Date("2022-01-01")), date_labels = "%Y") +
  # scale_x_date(breaks = seq(min(tab_onde_3_$Date),max(tab_onde_3_$Date), length = 6), date_labels = "%Y") +
  scale_y_continuous(limits = c(0,100),
                     expand = c(0, 2),
                     breaks = c(0,25,50,75,100),
                     labels = c("0%","","50%","","100%")) +
  
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
       subtitle = paste0("HER : ",HER_h_," ",descriptionHER_$NomHER2[which(descriptionHER_$CdHER2 == HER_h_)],
                         "\nPériode : ",year(date_intervalle_[1]),"-",year(date_intervalle_[2]),
                         " - Modèle hydrologique : ",str_before_first(nom_categorieSimu_,"_")),
       x = "Date",
       y = "Moyenne des probabilités d'assecs") +
  
  theme_minimal() +
  theme(plot.title = element_text(color = "#060403", size = 30, face = "bold"),
        plot.subtitle = element_text(color = "#2f2f32", size = 18),
        plot.margin = margin(20, 20, 20, 20),
        
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_text(color = "#2f2f32", vjust = 0, hjust=0.5, size = 28*ratio_epaisseurs_), # angle = 90
        axis.text.y = element_text(color = "#2f2f32", size = 28*ratio_epaisseurs_),
        axis.line.x = element_line(color = "#2f2f32", size = 1*ratio_epaisseurs_), # Trait des abscisses plus épais, IPCCgrey75
        axis.line.y = element_blank(), # Supprimer l'axe y
        axis.ticks.x=element_line(colour=c("#2f2f32",rep(c(NA, "#2f2f32"), t=12)), size = 1*ratio_epaisseurs_),
        axis.ticks.length  = unit(0.4, "cm"),
        
        panel.grid.major.x = element_blank(), # Traits horizontaux plus clairs
        panel.grid.minor.x = element_blank(), # Traits horizontaux plus clairs
        panel.grid.major.y = element_line(color = "#dcdad9", size = 0.5*ratio_epaisseurs_), # Traits horizontaux plus clairs
        panel.grid.minor.y = element_line(color = "#dcdad9", size = 0), # Traits horizontaux plus clairs
        
        text = element_text(size = 20),
        
        strip.text.x = element_blank(),
        strip.background = element_blank(),
        
        legend.title = element_text(color = "#2f2f32", size = 18), #, face = "normal"
        legend.text = element_text(color = "#2f2f32", size = 18),
        legend.margin = margin(-7, 0, 0, 0),
        legend.spacing.y = unit(+0.03, "cm"))+
  guides(alpha = guide_legend(override.aes = list(lwd = 2.5,color =levels(df_mean_nonNar_$Color)),
                              keyheight = 3.2,
                              keywidth = unit(2,"cm"),
                              order = 1),
         color = guide_legend(
           override.aes = list(lwd = 2.5),
           keyheight = 3.2,
           keywidth = unit(1,"cm"),
           title.hjust = 0.2,
           order = 2))

x11()
p_mean



flow_curve_ <- ggplot(spline.d, aes(x = Date, y = y, group = 1)) +
  geom_line(color = "#cc4c02", lwd = 0.6*ratio_epaisseurs_) +
  theme_minimal() +
  
  geom_point(data = tab_onde_3_, mapping = aes(x = Date, y = X._Assec), color = "#2f2f32", size = 2*ratio_epaisseurs_) +
  geom_point(data = tab_onde_3_, mapping = aes(x = Date, y = X._Assec), color = "#fe9929", size = 1.2*ratio_epaisseurs_) +
  
  # scale_y_continuous(expand = c(0,0)) +
  scale_y_continuous(breaks = c(0,25,50,75,100),
                     labels = c("0%","","50%","","100%"),
                     expand = c(0,1),
                     limits = c(0,100)) +
  scale_x_date(breaks = c(as.Date("1975-01-01"),
                          as.Date("2012-01-01"),
                          as.Date("2022-01-01"),
                          as.Date("2050-01-01"),
                          as.Date("2100-01-01")), date_labels = "%Y") +
  
  
  theme(plot.margin = margin(20, 20, 20, 20),
        plot.background = element_rect(fill = "white"),
        
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_text(color = "#2f2f32", vjust = 0, hjust=c(0.5,0.8,0.2,0.5,0.5), size = 28*ratio_epaisseurs_), # angle = 90
        # axis.text.x = element_text(color = "#2f2f32", vjust = 0, hjust=0.5, size = 28*ratio_epaisseurs_), # angle = 90
        axis.text.y = element_text(color = "#2f2f32", size = 28*ratio_epaisseurs_),
        axis.line.x = element_line(color = "#2f2f32", size = 1*ratio_epaisseurs_), # Trait des abscisses plus épais, IPCCgrey75
        axis.line.y = element_blank(), # Supprimer l'axe y
        axis.ticks.x=element_line(colour=c("#2f2f32"), size = 1*ratio_epaisseurs_),
        # axis.ticks.x=element_line(colour=c("#2f2f32",rep(c(NA, "#2f2f32"), t=12))),
        axis.ticks.length  = unit(0.4, "cm"),
        
        panel.grid.major.x = element_blank(), # Traits horizontaux plus clairs
        panel.grid.minor.x = element_blank(), # Traits horizontaux plus clairs
        panel.grid.major.y = element_line(color = "#dcdad9", size = 0.5*ratio_epaisseurs_), # Traits horizontaux plus clairs
        panel.grid.minor.y = element_line(color = "#dcdad9", size = 0), # Traits horizontaux plus clairs
        
        text = element_text(size = 20*ratio_epaisseurs_),
        
        strip.text.x = element_blank(),
        strip.background = element_blank(),
        
        legend.title = element_text(color = "#2f2f32", size = 18), #, face = "normal"
        legend.text = element_text(color = "#2f2f32", size = 18),
        legend.margin = margin(-7, 0, 0, 0),
        legend.spacing.y = unit(+0.03, "cm"))#+
flow_curve_
ggsave(filename = output_name_ONDE_future_,
       plot = flow_curve_)





