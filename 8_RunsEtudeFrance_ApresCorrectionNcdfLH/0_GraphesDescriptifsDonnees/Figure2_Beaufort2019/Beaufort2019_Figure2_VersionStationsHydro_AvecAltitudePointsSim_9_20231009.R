#-------------------------------------------------------------------------------
# Bottet Quentin - Irstea - 12/09/2019 - Version 1
# Script permettant d'extraire le % d'assec, les Frequence au non depassement et frequences au
# non depassement moyen par hydroecoregion de niveau 2 et en fonction du regime hydrologique
# des cours d'eau sur lesquels sont localisees les stations HYDRO et ONDE

# changer "OBS" en "SIM" dans les repertoires et fichiers de sortie pour les valeurs Safran
#print("2023.02.20. Pour le moment, FDC faits a partir des fichiers Simulations disponibles dans le dossier Thirel. Donnees dispos jusqu a 2018.")
#-------------------------------------------------------------------------------


### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")

### Librairies ###
library(doParallel)
library(lubridate)
library(ggplot2)
library(stringr)
library(dplyr)
library(tidyr)
library(ggrepel)

### Functions ###
detect_date_format <- function(date) {
  if (grepl("^\\d{4}-\\d{2}-\\d{2}$", date)) {
    return("ymd")
  } else if (grepl("^\\d{2}-\\d{2}-\\d{4}$", date)) {
    return("dmy")
  } else {
    return(NA)
  }
}

### Run ###
cl <- makePSOCKcluster(detectCores() - 4)
registerDoParallel(cores=cl)

### Study data ###
folder_input_ = folder_input_param_
folder_output_ = folder_output_param_
folder_onde_ = folder_onde_param_
nom_GCM_ = nom_GCM_param_
nom_selectStations_ = nom_selectStations_param_
nom_categorieSimu_ = nom_categorieSimu_param_
HER_ = HER_param_
HER_variable_ = HER_variable_param_
# climatScenarioModeleHydro_ = climatScenarioModeleHydro_param_
climatScenarioModeleHydro_ = nom_GCM_param_

color_stationsHydrometriques = color_stationsHydrometriques_param
color_pointsSimu = color_pointsSimu_param
color_sitesOnde = color_sitesOnde_param

breaks_SurfaceTopo_ = breaks_SurfaceTopo_param
breaks_altitude_ = breaks_altitude_param
breaks_pente_ = breaks_pente_param

obsSim_ = obsSim_param_
nomSim_ = nomSim_param_
annees_learn_ = annees_learnModels_param_

nbJoursIntervalle_ = 10

### Points HYDRO ###
nom_selectStations_ = "SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522"
liste <- list.files(paste0(folder_input_,"StationsSelectionnees/SelectionCsv/",nom_selectStations_),pattern="Stations_HYDRO", full.names = T)
il = liste[1]
output = data.frame()

# hydro = Recoupement Stations HYDRO - HER #
# hydro = read.table(il, sep=";", dec=".", header = T)
hydro = read.table(il, sep=";", dec=".", header = T, quote = "")
if (dim(hydro)[2] == 1){
  hydro = read.table(il, sep=",", dec=".", header = T, quote = "")
}
if (substr(colnames(hydro)[1],1,2) == "X."){
  hydro = read.table(il, sep=";", dec=".", header = T)
  if (dim(hydro)[2] == 1){
    hydro = read.table(il, sep=",", dec=".", header = T)
  }
}

####################################################
### Gestion de la table des points de simulation ###
####################################################
if ("Code10_ChoixDefinitifPointSimu" %in% colnames(hydro)){
  hydro$Code = hydro$Code10_ChoixDefinitifPointSimu
}

print("Taille à verifier : CTRIP=--- \ EROS=--- \ GRSD=--- \ J2000=343 \ MORDORSD=--- \ MORDORTS=--- \ ORCHIDEE=--- \ SIM2=--- \ SMASH=---")
# print("Taille à verifier : CTRIP=535 \ EROS=159 \ GRSD=608 \ J2000=235 \ MORDORSD=610 \ MORDORTS=113 \ ORCHIDEE=557 \ SIM2=848 \ SMASH=603")
dim(hydro)

# hydro$SurfaceTopo_cut <- cut(as.numeric(hydro$SurfaceTopo), breaks = breaks_SurfaceTopo_)
# table(hydro$SurfaceTopo_cut, useNA = "always") #OK
# median(na.omit(hydro$SurfaceTopo)) #173
# quantile(na.omit(hydro$SurfaceTopo), probs = 0.25) #85
# quantile(na.omit(hydro$SurfaceTopo), probs = 0.75) #396
# 
# hydro$altitude_cut <- cut(as.numeric(hydro$Altitude), breaks = breaks_altitude_)
# table(hydro$altitude_cut, useNA = "always")
# median(na.omit(hydro$Altitude)) #170
# quantile(na.omit(hydro$Altitude), probs = 0.25) #65
# quantile(na.omit(hydro$Altitude), probs = 0.75) #305
# 
# length(which(is.na(hydro$Altitude))) #28 NA

# Avec 9 NA d'Altitude
hydro$SurfaceTopo_cut <- cut(as.numeric(hydro$SurfaceTopo), breaks = breaks_SurfaceTopo_)
table(hydro$SurfaceTopo_cut, useNA = "always") #OK
median(na.omit(hydro$SurfaceTopo)) #173
quantile(na.omit(hydro$SurfaceTopo), probs = 0.25) #85
quantile(na.omit(hydro$SurfaceTopo), probs = 0.75) #396

hydro$altitude_cut <- cut(as.numeric(hydro$Altitude), breaks = breaks_altitude_)
table(hydro$altitude_cut, useNA = "always")
median(na.omit(hydro$Altitude)) #165
quantile(na.omit(hydro$Altitude), probs = 0.25) #63.5
quantile(na.omit(hydro$Altitude), probs = 0.75) #300

length(which(is.na(hydro$Altitude))) #9 NA

###################
### Points simu ###
###################
# df_pointsSimu = read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/Stations_HYDRO_AvecCorrespondanceShp_VersionCorresDistanceBruteExp2_8_20230803.csv", sep = ";", dec = ".", header = T)
df_pointsSimu = read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_12_ComparaisonShpSimulations/Stations_HYDRO_AvecCorrespondanceShp_VersionCorresDistanceBruteExp2_8_20230803.csv", sep = ",", dec = ".", header = T, quote = "")

df_pointsSimu$SurfaceTopo_ChoixDefinitifPointSimu_cut <- cut(as.numeric(df_pointsSimu$SurfaceTopo_ChoixDefinitifPointSimu), breaks = c(0,10,25,50,100,500,1000,8000))
table(df_pointsSimu$SurfaceTopo_ChoixDefinitifPointSimu_cut, useNA = "always") #OK
median(na.omit(df_pointsSimu$SurfaceTopo_ChoixDefinitifPointSimu)) #191.5
quantile(na.omit(df_pointsSimu$SurfaceTopo_ChoixDefinitifPointSimu), probs = 0.25) #109.6
quantile(na.omit(df_pointsSimu$SurfaceTopo_ChoixDefinitifPointSimu), probs = 0.75) #417

### FAUX, C'est l'altitude du fichier HYDRO et non l'altitude du point de simulation apres correspondance !! ###
# df_pointsSimu$Altitude_cut <- cut(as.numeric(df_pointsSimu$Altitude), breaks = c(-0.1, 25, 50, 100, 200, 300, 500, 1000, 100000))
# table(df_pointsSimu$Altitude_cut, useNA = "always") #OK
# median(na.omit(df_pointsSimu$Altitude)) #191.5
# quantile(na.omit(df_pointsSimu$Altitude), probs = 0.25) #109.6
# quantile(na.omit(df_pointsSimu$Altitude), probs = 0.75) #417

metadonees_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/ListeStations/ListeMetadata/00_sta_metadata_1_20230414_RemoveVirgules.csv", header = T, sep = ";", dec = ".")
# metadonees_ = read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/ListeStations/ListeMetadata/00_sta_metadata_1_20230414.csv", header = T, sep = ";", dec = ".")

df_pointsSimu = merge(df_pointsSimu, metadonees_, by.x = "Code10_ChoixDefinitifPointSimu", by.y = "code", all.x = T)

length(df_pointsSimu$Code10[which(is.na(df_pointsSimu$Altitude))]) #24 NA
df_pointsSimu$Altitude[which(is.na(df_pointsSimu$Altitude))] = round(df_pointsSimu$altitude_staff_gauge[which(is.na(df_pointsSimu$Altitude))]/1000)
df_pointsSimu$Code10[which(is.na(df_pointsSimu$Altitude))]
length(df_pointsSimu$Code10[which(is.na(df_pointsSimu$Altitude))]) #8 NA

df_pointsSimu$Altitude_cut <- cut(as.numeric(df_pointsSimu$Altitude), breaks = breaks_altitude_)
table(df_pointsSimu$Altitude_cut, useNA = "always")
mean(na.omit(df_pointsSimu$Altitude)) #223.9735
median(na.omit(df_pointsSimu$Altitude)) #165
quantile(na.omit(df_pointsSimu$Altitude), probs = 0.25) #63.5
quantile(na.omit(df_pointsSimu$Altitude), probs = 0.75) #297

df_pointsSimu$Code10
metadonees_$code

############
### Onde ###
############
#data.frame(table(df_descriptionStations_2012_2017_$Surf_BV_cut, useNA = "always")))
df_ancien <- read.table("/home/tjaouen/Documents/Input/ONDE/Data_Description/DescriptionSites/Surf_ONDE_2_20230525.csv", header = T, sep = ",", row.names = NULL, quote="")
df_new <- read.table("/home/tjaouen/Documents/Input/ONDE/Data_Description/DescriptionSites/Attributs_RHT_pour_stations_hors_liste_LV_20231004.txt", header = T, sep = ";", dec = ",", row.names = NULL, quote="")
annees_ = c(2012:2017)

dim(df_new) # 44 stations
df_ancien[which(df_ancien$F_CdSiteHy %in% df_new$cd_site_hy),c("F_CdSiteHy","sfbvu")] # 6 stations dans les 3302
df_new[which(df_new$cd_site_hy %in% df_ancien$F_CdSiteHy),c("cd_site_hy","sfbvu","surf_bv","altitude","STRAHLER","strahler_1","pente")]
df_new[,c("cd_site_hy","sfbvu")]
df_ancien$F_CdSiteHy[which(is.na(df_ancien$sfbvu))]
df_new$cd_site_hy

# df_ancien[which(df_ancien$F_CdSiteHy %in% df_new$cd_site_hy),] # 6 stations

# Table de tous les enregistrements ONDE #
folder_onde_ = folder_onde_param_
ONDE <- read.table(folder_onde_, sep = ";", dec = ".", header = T)
if (dim(ONDE)[2] == 1){
  ONDE = read.table(folder_onde_, sep = ",", dec = ".", header = T, quote = "")
}
print("Taille à verifier apres correction ONDE 2023.06.07 : 175 972")
dim(ONDE)
length(unique(ONDE$CdSiteHydro)) #3409

for (d in 1:nrow(df_new)){
  if (length(which(df_ancien$F_CdSiteHy %in% df_new$cd_site_hy[d])) > 0){
    df_ancien$altitude[which(df_ancien$F_CdSiteHy %in% df_new$cd_site_hy[d])] = df_new$altitude[d]
    df_ancien$Surf_BV[which(df_ancien$F_CdSiteHy %in% df_new$cd_site_hy[d])] = df_new$surf_bv[d]
    df_ancien$Pente[which(df_ancien$F_CdSiteHy %in% df_new$cd_site_hy[d])] = df_new$pente[d]
    df_ancien$Strahler[which(df_ancien$F_CdSiteHy %in% df_new$cd_site_hy[d])] = df_new$STRAHLER[d]
  }
}
df_ = df_ancien

### Import ONDE data ###
#Avant recoupement Aurelien Beaufort : 3417 2012-2023 / 3332 2012-2017
#Apres recoupement Aurelien Beaufort : 3302 2012-2023 / 3302 2012-2017

df_descriptionStations_2012_2017_ = df_[!duplicated(df_[,"F_CdSiteHy"]),]
dim(df_descriptionStations_2012_2017_) #3302
# table(df_descriptionStations_2012_2017_$Strahler, useNA = "always")

df_descriptionStations_2012_2017_$Surf_BV_cut <- cut(as.numeric(df_descriptionStations_2012_2017_$Surf_BV), breaks = breaks_SurfaceTopo_)
table(df_descriptionStations_2012_2017_$Surf_BV_cut, useNA = "always") #OK
median(na.omit(df_descriptionStations_2012_2017_$Surf_BV)) #24
quantile(na.omit(df_descriptionStations_2012_2017_$Surf_BV), probs = 0.25) #12
quantile(na.omit(df_descriptionStations_2012_2017_$Surf_BV), probs = 0.75) #50

df_descriptionStations_2012_2017_$altitude_cut <- cut(as.numeric(df_descriptionStations_2012_2017_$altitude), breaks = breaks_altitude_)
table(df_descriptionStations_2012_2017_$altitude_cut, useNA = "always") #OK
median(na.omit(df_descriptionStations_2012_2017_$altitude)) #158.4
quantile(na.omit(df_descriptionStations_2012_2017_$altitude), probs = 0.25) #81.15
quantile(na.omit(df_descriptionStations_2012_2017_$altitude), probs = 0.75) #302.75



df_descriptionStations_2012_2017_[which(is.na(df_descriptionStations_2012_2017_$altitude)),]





### Merge Surface ###
mg_surface_ = merge(data.frame(table(df_pointsSimu$SurfaceTopo_ChoixDefinitifPointSimu_cut, useNA = "always")),
                    data.frame(table(hydro$SurfaceTopo_cut, useNA = "always")), by = "Var1")
mg_surface_ = merge(mg_surface_,
                    data.frame(table(df_descriptionStations_2012_2017_$Surf_BV_cut, useNA = "always")), by = "Var1")
colnames(mg_surface_) <- c("SurfaceTopo",
                           "Points de simulation du projet Explore2",
                           "Stations hydrométriques du réseau HYDRO",
                           "Sites du réseau ONDE")

# Remodeler la table de données
mg_surface_long <- pivot_longer(mg_surface_, cols = c("Points de simulation du projet Explore2",
                                                      "Stations hydrométriques du réseau HYDRO",
                                                      "Sites du réseau ONDE"), names_to = "Variable", values_to = "Valeur")

# Définir l'ordre des barres
order_variable <- c("Sites du réseau ONDE",
                    "Stations hydrométriques du réseau HYDRO",
                    "Points de simulation du projet Explore2")
# order_variable <- c("Stations hydrométriques du réseau HYDRO",
#                     "Points de simulation du projet Explore2",
#                     "Sites du réseau ONDE")
mg_surface_long$Variable <- factor(mg_surface_long$Variable, levels = order_variable)

mg_surface_long$Color <- NA
mg_surface_long$Color[which(mg_surface_long$Variable == "Stations hydrométriques du réseau HYDRO")] = color_stationsHydrometriques
mg_surface_long$Color[which(mg_surface_long$Variable == "Points de simulation du projet Explore2")] = color_pointsSimu
mg_surface_long$Color[which(mg_surface_long$Variable == "Sites du réseau ONDE")] = color_sitesOnde
mg_surface_long$Color <- factor(mg_surface_long$Color, levels = c(color_sitesOnde,color_stationsHydrometriques,color_pointsSimu))

# x11()
png("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/BarplotVersion_Beaufort2019_20231009/Surface_French_1_20230918.png",
    width = 1200, height = 750,
    units = "px", pointsize = 12)
p <- ggplot(mg_surface_long, aes(x = SurfaceTopo, y = Valeur, fill = Variable)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +
  geom_text(aes(label = Valeur), position = position_dodge(width = 0.7), vjust = -0.5, size = 4) +
  scale_x_discrete(labels = c(expression(""<=10), "]10;25]", "]25;50]", "]50;100]","]100;500]","]500;1000]",">1000","NA")) +
  labs(title = bquote('Diagramme en barres des effectifs par surface de drainage'),
       x = bquote('Surface de drainage ('~km^2~')'),
       y = "Effectif") +
  scale_fill_manual(values = levels(mg_surface_long$Color),
                    labels = levels(mg_surface_long$Variable)) +
  theme(text = element_text(size = 20),
        axis.line.x = element_line(color = "black", size = 1),
        axis.line.y = element_line(color = "black", size = 1),
        axis.text.x = element_text(angle = 35, hjust = 1, vjust = 1),
        panel.background = element_blank(),
        panel.border = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank(),
        legend.spacing.y = unit(0.5, "cm"),  # Ajustez ces valeurs selon vos besoins
        legend.key.size = unit(1, "cm")) +  # Ajustez cette valeur selon vos besoins
  labs(fill = "Entités hydrologiques") + # Changer le titre de la légende
  guides(fill = guide_legend(byrow = TRUE))
print(p)
dev.off()


### Area Merge ###
mg_surface_ = merge(data.frame(table(df_pointsSimu$SurfaceTopo_ChoixDefinitifPointSimu_cut, useNA = "always")),
                    data.frame(table(hydro$SurfaceTopo_cut, useNA = "always")), by = "Var1")
mg_surface_ = merge(mg_surface_,
                    data.frame(table(df_descriptionStations_2012_2017_$Surf_BV_cut, useNA = "always")), by = "Var1")
colnames(mg_surface_) <- c("SurfaceTopo",
                           "Simulation points from Explore2 project",
                           "Hydrometric stations from HYDRO network",
                           "ONDE network sites")

# Reshape the data table
mg_surface_long <- pivot_longer(mg_surface_, cols = c("Simulation points from Explore2 project",
                                                      "Hydrometric stations from HYDRO network",
                                                      "ONDE network sites"), names_to = "Variable", values_to = "Value")

# Define the order of bars
order_variable <- c("ONDE network sites",
                    "Hydrometric stations from HYDRO network",
                    "Simulation points from Explore2 project")
mg_surface_long$Variable <- factor(mg_surface_long$Variable, levels = order_variable)

mg_surface_long$Color <- NA
mg_surface_long$Color[which(mg_surface_long$Variable == "Hydrometric stations from HYDRO network")] = color_stationsHydrometriques
mg_surface_long$Color[which(mg_surface_long$Variable == "Simulation points from Explore2 project")] = color_pointsSimu
mg_surface_long$Color[which(mg_surface_long$Variable == "ONDE network sites")] = color_sitesOnde
mg_surface_long$Color <- factor(mg_surface_long$Color, levels = c(color_sitesOnde,color_stationsHydrometriques,color_pointsSimu))

png("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/BarplotVersion_Beaufort2019_20231009/Surface_English_1_20230918.png",
    width = 1200, height = 750,
    units = "px", pointsize = 12)
p <- ggplot(mg_surface_long, aes(x = SurfaceTopo, y = Value, fill = Variable)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +
  geom_text(aes(label = Value), position = position_dodge(width = 0.7), vjust = -0.5, size = 4) +
  scale_x_discrete(labels = c(expression(""<=10), "]10;25]", "]25;50]", "]50;100]","]100;500]","]500;1000]",">1000","NA")) +
  labs(title = bquote('Bar Chart of Frequencies by Drainage Area'),
       x = bquote('Drainage area ('~km^2~')'),
       y = "Frequency") +
  scale_fill_manual(values = levels(mg_surface_long$Color),
                    labels = levels(mg_surface_long$Variable)) +
  theme(text = element_text(size = 20),
        axis.line.x = element_line(color = "black", size = 1),
        axis.line.y = element_line(color = "black", size = 1),
        axis.text.x = element_text(angle = 35, hjust = 1, vjust = 1),
        panel.background = element_blank(),
        panel.border = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank(),
        legend.spacing.y = unit(0.5, "cm"),  # Ajustez ces valeurs selon vos besoins
        legend.key.size = unit(1, "cm")) +  # Ajustez cette valeur selon vos besoins
  labs(fill = "Hydrological entities") +  # Change the legend title
  guides(fill = guide_legend(byrow = TRUE))
print(p)
dev.off()



#Faire pour altitude, pente, sharder
#Rechercher les valeurs pour les points simu Exp2
#Rechercher les NA

# hydro #Manque pente et strahler
# df_pointsSimu #Manque pente et strahler
# df_descriptionStations_2012_2017_


### Merge Altitude ###
mg_altitude_ = merge(data.frame(table(df_pointsSimu$Altitude_cut, useNA = "always")),
                     data.frame(table(hydro$altitude_cut, useNA = "always")), by = "Var1")

mg_altitude_ = merge(mg_altitude_, 
                     data.frame(table(df_descriptionStations_2012_2017_$altitude_cut, useNA = "always")), by = "Var1")
colnames(mg_altitude_) <- c("Elevation",
                            "Simulation points from Explore2 project",
                            "Hydrometric stations from HYDRO network",
                            "ONDE network sites")

# Remodeler la table de données
mg_altitude_long <- pivot_longer(mg_altitude_, cols = c("Simulation points from Explore2 project",
                                                        "Hydrometric stations from HYDRO network",
                                                        "ONDE network sites"), names_to = "Variable", values_to = "Valeur")

# Définir l'ordre des barres
order_variable <- c("ONDE network sites",
                    "Hydrometric stations from HYDRO network",
                    "Simulation points from Explore2 project")
mg_altitude_long$Variable <- factor(mg_altitude_long$Variable, levels = order_variable)
mg_altitude_long$Altitude

mg_altitude_long$Color <- NA
mg_altitude_long$Color[which(mg_altitude_long$Variable == "Stations hydrométriques du réseau HYDRO")] = color_stationsHydrometriques
mg_altitude_long$Color[which(mg_altitude_long$Variable == "Points de simulation du projet Explore2")] = color_pointsSimu
mg_altitude_long$Color[which(mg_altitude_long$Variable == "Sites du réseau ONDE")] = color_sitesOnde
mg_altitude_long$Color <- factor(mg_altitude_long$Color, levels = c(color_sitesOnde,color_stationsHydrometriques,color_pointsSimu))

png("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/BarplotVersion_Beaufort2019_20231009/Altitude_French_1_20230918.png",
    width = 1200, height = 750,
    units = "px", pointsize = 12)
p <- ggplot(mg_altitude_long, aes(x = Elevation, y = Valeur, fill = Variable)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +
  geom_text(#aes(y = Valeur + ifelse(mg_altitude_long$Variable == "Simulation points from Explore2 project",15,0),
    #    label = Valeur),
    aes(label = Valeur),
    position = position_dodge(width = 0.7), vjust = -0.5, size = 4) +
  # geom_text(aes(label = Valeur), position = position_stack(vjust = 0.5), size = 4) +
  # geom_text(aes(label = Valeur),
  #           position = position_dodge(width = 0.7), # Alignement avec dodge
  #           hjust = -0.5,
  #           size = 4) +
  scale_x_discrete(labels = c("[0;25]", "]25;50]", "]50;100]","]100;200]","]200;300]","]300;500]","]500;1000]",">1000","NA")) +
  labs(title = "Diagramme en barres des effectifs par niveau d'altitude",
       x = "Altitude (m)",
       y = "Effectif") +
  scale_fill_manual(values = levels(mg_surface_long$Color),
                    labels = levels(mg_surface_long$Variable)) +
  theme(text = element_text(size = 20),
        axis.line.x = element_line(color = "black", size = 1),
        axis.line.y = element_line(color = "black", size = 1),
        axis.text.x = element_text(angle = 35, hjust = 1, vjust = 1),
        panel.background = element_blank(),
        panel.border = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank(),
        legend.spacing.y = unit(0.5, "cm"),  # Ajustez ces valeurs selon vos besoins
        legend.key.size = unit(1, "cm")) +  # Ajustez cette valeur selon vos besoins
  labs(fill = "Entités hydrologiques") + # Changer le titre de la légende
  guides(fill = guide_legend(byrow = TRUE))
print(p)
dev.off()





### Altitude - English version ###
mg_altitude_ = merge(data.frame(table(df_pointsSimu$Altitude_cut, useNA = "always")),
                     data.frame(table(hydro$altitude_cut, useNA = "always")), by = "Var1")

mg_altitude_ = merge(mg_altitude_, 
                     data.frame(table(df_descriptionStations_2012_2017_$altitude_cut, useNA = "always")), by = "Var1")
colnames(mg_altitude_) <- c("Elevation",
                            "Simulation points from Explore2 project",
                            "Hydrometric stations from HYDRO network",
                            "ONDE network sites")

# Remodeler la table de données
mg_altitude_long <- pivot_longer(mg_altitude_, cols = c("Simulation points from Explore2 project",
                                                        "Hydrometric stations from HYDRO network",
                                                        "ONDE network sites"), names_to = "Variable", values_to = "Valeur")

# Définir l'ordre des barres
order_variable <- c("ONDE network sites",
                    "Hydrometric stations from HYDRO network",
                    "Simulation points from Explore2 project")
mg_altitude_long$Variable <- factor(mg_altitude_long$Variable, levels = order_variable)
mg_altitude_long$Altitude

mg_altitude_long$Color <- NA
mg_altitude_long$Color[which(mg_altitude_long$Variable == "Stations hydrométriques du réseau HYDRO")] = color_stationsHydrometriques
mg_altitude_long$Color[which(mg_altitude_long$Variable == "Points de simulation du projet Explore2")] = color_pointsSimu
mg_altitude_long$Color[which(mg_altitude_long$Variable == "Sites du réseau ONDE")] = color_sitesOnde
mg_altitude_long$Color <- factor(mg_altitude_long$Color, levels = c(color_sitesOnde,color_stationsHydrometriques,color_pointsSimu))

png("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/BarplotVersion_Beaufort2019_20231009/Altitude_English_1_20230918.png",
    width = 1200, height = 750,
    units = "px", pointsize = 12)
p <- ggplot(mg_altitude_long, aes(x = Elevation, y = Valeur, fill = Variable)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +
  geom_text(aes(label = Valeur), position = position_dodge(width = 0.7), vjust = -0.5, size = 4) +
  scale_x_discrete(labels = c("[0;25]", "]25;50]", "]50;100]","]100;200]","]200;300]","]300;500]","]500;1000]",">1000","NA")) +
  labs(title = "Bar Chart of Frequencies by Altitude Level",
       x = "Elevation (m)",
       y = "Frequency") +
  scale_fill_manual(values = levels(mg_surface_long$Color),
                    labels = levels(mg_surface_long$Variable)) +
  theme(text = element_text(size = 20),
        axis.line.x = element_line(color = "black", size = 1),
        axis.line.y = element_line(color = "black", size = 1),
        axis.text.x = element_text(angle = 35, hjust = 1, vjust = 1),
        panel.background = element_blank(),
        panel.border = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank(),
        legend.spacing.y = unit(0.5, "cm"),  # Ajustez ces valeurs selon vos besoins
        legend.key.size = unit(1, "cm")) +  # Ajustez cette valeur selon vos besoins
  labs(fill = "Hydrological entities") + # Change the legend title
  guides(fill = guide_legend(byrow = TRUE))
print(p)
dev.off()









### Merge Pente ###
df_descriptionStations_2012_2017_$Pente_cut <- cut(as.numeric(df_descriptionStations_2012_2017_$Pente), breaks = breaks_pente_)
table(df_descriptionStations_2012_2017_$Pente_cut, useNA = "always") #OK
median(na.omit(df_descriptionStations_2012_2017_$Pente)) #6.3
quantile(na.omit(df_descriptionStations_2012_2017_$Pente), probs = 0.25) #3
quantile(na.omit(df_descriptionStations_2012_2017_$Pente), probs = 0.75) #14

mg_pente_ = data.frame(table(df_descriptionStations_2012_2017_$Pente_cut, useNA = "always"))
colnames(mg_pente_) <- c("Pente",
                         "Valeur")

# Remodeler la table de données
# mg_pente_long <- pivot_longer(mg_pente_, cols = c("Sites du réseau ONDE"), names_to = "Variable", values_to = "Valeur")
mg_pente_long <- mg_pente_
mg_pente_long$Variable = "Sites du réseau ONDE"

# Définir l'ordre des barres
order_variable <- c("Sites du réseau ONDE")
mg_pente_long$Variable <- factor(mg_pente_long$Variable, levels = order_variable)

png("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/BarplotVersion_Beaufort2019_20231009/Pente_French_1_20230918.png",
    width = 1200, height = 750,
    units = "px", pointsize = 12)
p <- ggplot(mg_pente_long, aes(x = Pente, y = Valeur, fill = Variable)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +
  geom_text(aes(label = Valeur), position = position_dodge(width = 0.7), vjust = -0.5, size = 4) +
  scale_x_discrete(labels = c(expression(""<=1), "]1;5]", "]5;15]", "]15;30]","]30;60]","]60;100]","]100;150]",">150","NA")) +
  labs(title = "Diagramme en barres des effectifs par pente",
       x = "Pente (m/km)",
       y = "Effectif") +
  scale_fill_manual(values = c("Sites du réseau ONDE" = rgb(196,121,0, maxColorValue = 255)),
                    labels = c("Sites du réseau ONDE")) +
  theme(text = element_text(size = 20),
        axis.line.x = element_line(color = "black", size = 1),
        axis.line.y = element_line(color = "black", size = 1),
        axis.text.x = element_text(angle = 35, hjust = 1, vjust = 1),
        panel.background = element_blank(),
        panel.border = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank(),
        legend.spacing.y = unit(0.5, "cm"),  # Ajustez ces valeurs selon vos besoins
        legend.key.size = unit(1, "cm")) +  # Ajustez cette valeur selon vos besoins
  labs(fill = "Entités hydrologiques") + # Changer le titre de la légende
  guides(fill = guide_legend(byrow = TRUE))
print(p)
dev.off()


mg_pente_long$Variable = "ONDE network sites"

# Define the order of bars
order_variable <- c("ONDE network sites")
mg_pente_long$Variable <- factor(mg_pente_long$Variable, levels = order_variable)

png("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/BarplotVersion_Beaufort2019_20231009/Pente_English_1_20230918.png",
    width = 1200, height = 750,
    units = "px", pointsize = 12)
p <- ggplot(mg_pente_long, aes(x = Pente, y = Valeur, fill = Variable)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +
  geom_text(aes(label = Valeur), position = position_dodge(width = 0.7), vjust = -0.5, size = 4) +
  scale_x_discrete(labels = c(expression(""<=1), "]1;5]", "]5;15]", "]15;30]","]30;60]","]60;100]","]100;150]",">150","NA")) +
  labs(title = "Bar Chart of Frequencies by Slope",
       x = "Slope (m/km)",
       y = "Frequency") +
  scale_fill_manual(values = c("ONDE network sites" = rgb(196,121,0, maxColorValue = 255)),
                    labels = c("ONDE network sites")) +
  theme(text = element_text(size = 20),
        axis.line.x = element_line(color = "black", size = 1),
        axis.line.y = element_line(color = "black", size = 1),
        axis.text.x = element_text(angle = 35, hjust = 1, vjust = 1),
        panel.background = element_blank(),
        panel.border = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank(),
        legend.spacing.y = unit(0.5, "cm"),  # Adjust these values as needed
        legend.key.size = unit(1, "cm")) +  # Adjust this value as needed
  labs(fill = "Hydrological entities") + # Change the legend title
  guides(fill = guide_legend(byrow = TRUE))
print(p)
dev.off()






### Indice de Strahler ###
table(df_descriptionStations_2012_2017_$Strahler, useNA = "always") #OK
median(na.omit(df_descriptionStations_2012_2017_$Strahler)) #2
quantile(na.omit(df_descriptionStations_2012_2017_$Strahler), probs = 0.25) #1
quantile(na.omit(df_descriptionStations_2012_2017_$Strahler), probs = 0.75) #2

mg_strahler_ = data.frame(table(df_descriptionStations_2012_2017_$Strahler, useNA = "always"))
colnames(mg_strahler_) <- c("Strahler",
                            "Valeur")

# Remodeler la table de données
# mg_strahler_long <- pivot_longer(mg_strahler_, cols = c("Sites du réseau ONDE"), names_to = "Variable", values_to = "Valeur")
mg_strahler_long <- mg_strahler_
mg_strahler_long$Variable = "Sites du réseau ONDE"

# Définir l'ordre des barres
order_variable <- c("Sites du réseau ONDE")
mg_strahler_long$Variable <- factor(mg_strahler_long$Variable, levels = order_variable)

png("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/BarplotVersion_Beaufort2019_20231009/Strahler_French_1_20230918.png",
    width = 1200, height = 750,
    units = "px", pointsize = 12)
p <- ggplot(mg_strahler_long, aes(x = Strahler, y = Valeur, fill = Variable)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +
  geom_text(aes(label = Valeur), position = position_dodge(width = 0.7), vjust = -0.5, size = 4) +
  scale_x_discrete(labels = c("1", "2", "3","4","5","NA")) +
  labs(title = "Diagramme en barres des effectifs par indice de Strahler",
       x = "Indice de Strahler (sans unité)",
       y = "Effectif") +
  scale_fill_manual(values = c("Sites du réseau ONDE" = rgb(196,121,0, maxColorValue = 255)),
                    labels = c("Sites du réseau ONDE")) +
  theme(text = element_text(size = 20),
        axis.line.x = element_line(color = "black", size = 1),
        axis.line.y = element_line(color = "black", size = 1),
        axis.text.x = element_text(angle = 35, hjust = 1, vjust = 1),
        panel.background = element_blank(),
        panel.border = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank(),
        legend.spacing.y = unit(0.5, "cm"),  # Ajustez ces valeurs selon vos besoins
        legend.key.size = unit(1, "cm")) +  # Ajustez cette valeur selon vos besoins
  labs(fill = "Entités hydrologiques") + # Changer le titre de la légende
  guides(fill = guide_legend(byrow = TRUE))
print(p)
dev.off()



mg_strahler_long$Variable = "ONDE network sites"

# Définir l'ordre des barres
order_variable <- c("ONDE network sites")
mg_strahler_long$Variable <- factor(mg_strahler_long$Variable, levels = order_variable)

png("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/BarplotVersion_Beaufort2019_20231009/Strahler_English_1_20230918.png",
    width = 1200, height = 750,
    units = "px", pointsize = 12)
p <- ggplot(mg_strahler_long, aes(x = Strahler, y = Valeur, fill = Variable)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +
  geom_text(aes(label = Valeur), position = position_dodge(width = 0.7), vjust = -0.5, size = 4) +
  scale_x_discrete(labels = c("1", "2", "3","4","5","NA")) +
  labs(title = "Bar Chat of frequency by Strahler number",
       x = "Strahler number (unitless)",
       y = "Frequency") +
  scale_fill_manual(values = c("ONDE network sites" = rgb(196,121,0, maxColorValue = 255)),
                    labels = c("ONDE network sites")) +
  theme(text = element_text(size = 20),
        axis.line.x = element_line(color = "black", size = 1),
        axis.line.y = element_line(color = "black", size = 1),
        axis.text.x = element_text(angle = 35, hjust = 1, vjust = 1),
        panel.background = element_blank(),
        panel.border = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank(),
        legend.spacing.y = unit(0.5, "cm"),  # Ajustez ces valeurs selon vos besoins
        legend.key.size = unit(1, "cm")) +  # Ajustez cette valeur selon vos besoins
  labs(fill = "Hydrological entities") + # Changer le titre de la légende
  guides(fill = guide_legend(byrow = TRUE))
print(p)
dev.off()






#### Rattachement station hydro aux points Explore2 ####
min(df_pointsSimu$DistanceBrute_ChoixDefinitifPointSimu) #0
max(df_pointsSimu$DistanceBrute_ChoixDefinitifPointSimu) #26.61996 km
median(df_pointsSimu$DistanceBrute_ChoixDefinitifPointSimu) #51.84499 m
quantile(df_pointsSimu$DistanceBrute_ChoixDefinitifPointSimu, probs = 0.25) #21.58104 m
quantile(df_pointsSimu$DistanceBrute_ChoixDefinitifPointSimu, probs = 0.75) #146.3048 m
length(which(df_pointsSimu$DistanceExplore2_ChoixDefinitifPointSimu < 1000)) #821
length(which(df_pointsSimu$DistanceExplore2_ChoixDefinitifPointSimu >= 1000)) #187
#821/1008 = 0.81
df_pointsSimu$Code10_ChoixDefinitifPointSimu[which(df_pointsSimu$Code10_ChoixDefinitifPointSimu %in% df_pointsSimu$Code10_ChoixDefinitifPointSimu[which(duplicated(df_pointsSimu$Code10_ChoixDefinitifPointSimu))])]
length(df_pointsSimu$Code10_ChoixDefinitifPointSimu[which(df_pointsSimu$Code10_ChoixDefinitifPointSimu %in% df_pointsSimu$Code10_ChoixDefinitifPointSimu[which(duplicated(df_pointsSimu$Code10_ChoixDefinitifPointSimu))])]) #137
table(df_pointsSimu$Code10_ChoixDefinitifPointSimu[which(df_pointsSimu$Code10_ChoixDefinitifPointSimu %in% df_pointsSimu$Code10_ChoixDefinitifPointSimu[which(duplicated(df_pointsSimu$Code10_ChoixDefinitifPointSimu))])]) #
table(table(df_pointsSimu$Code10_ChoixDefinitifPointSimu))
#1   2   3   4 
#871  56   7   1 
#Savoir nombre de nombre d'apparitions


df_pointsSimu[which(df_pointsSimu$DistanceBrute_ChoixDefinitifPointSimu == max(df_pointsSimu$DistanceBrute_ChoixDefinitifPointSimu)),]





