### Libraries ###
library(ggplot2)

### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/4_RunsEtudeFrance_20230417/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")

### Study data ###
folder_input_ = folder_input_param_
folder_onde_ = folder_onde_param_
nomSim_ = nomSim_param_

### Disponibilite des Stations par dates ### 
#tab_stations_ = read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsObserves/DisponibiliteDonneesHydroDates/TablesDisponibiliteDonneesHydro/DisponibiliteTemporelle_VersionTJ_20230412/1_DisponibiliteDonneesDates_ToutesStationsHydro/1_DisponibiliteDonneesDates_ToutesStationsHydro_All_1_20230417.csv", sep = ";", dec = ".", quote = "", na.strings = NA, header = T)
tab_stations_ = read.csv("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsObserves/DisponibiliteDonneesHydroDates/TablesDisponibiliteDonneesHydro/DisponibiliteTemporelle_VersionTJ_20230412/3_DisponibiliteDonnees_DatesEtMergeHER2hybrides/HER2_VersionES_2_20230417/3_Merge_DisponibiliteHydro_CorrespondanceHER2hybridesv2_3_20230420.csv", sep = ";", dec = ".", na.strings = NA, header = T)
dim(tab_stations_) #1250 134

tab_stations_[which(is.na(tab_stations_$SurfaceTopo)),]
# Surfaces non renseignees sur l'hydroportail : "H110200901", "H320000104", "O408101001", "O710060101", "Q110501001"

tab_stations_ = tab_stations_[which(tab_stations_$SurfaceTopo < 2000),]
dim(tab_stations_) #1094

### Impact ###
table(tab_stations_$Impact_local)


tab_stations_[,c("Code","Impact_local","eco000","eco002","eco012")]
tab_stations_ImpFort = tab_stations_[which(tab_stations_$Impact_local == "Influence forte en toute saison"),]
dim(tab_stations_ImpFort)


# Surfaces sous influence forte
colsums <- colSums(tab_stations_ImpFort[grep("eco0|eco1",colnames(tab_stations_ImpFort))])
names(colsums) <- as.numeric(substr(names(colsums),4,6))

# Conversion du résultat en data frame
colsums_df <- data.frame(values = colsums, categories = names(colsums))

# Création du graphique à barres
png(paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_2_PresentMesures_HERh_TsKGE_SansImpactFort_2012_2022_20230426/Graphes/1_SommeSurfacesDraineesFortInfluence_1_20230426.png"),
    width = 1200, height = 750,
    units = "px", pointsize = 12)
ggplot(colsums_df, aes(x = categories, y = values)) +
  geom_bar(stat = "identity", fill = "#756bb1") +
  xlab("HER 2 hybrides") +
  ylab("Surfaces (km²)") +
  ggtitle("Somme des surfaces drainées par des stations soumises à une influence forte en toute saison") +
  theme_bw()
dev.off()

# Proportion des surfaces sous influence forte
colsums <- colSums(tab_stations_ImpFort[grep("eco0|eco1",colnames(tab_stations_ImpFort))])/colSums(tab_stations_[grep("eco0|eco1",colnames(tab_stations_))])
names(colsums) <- as.numeric(substr(names(colsums),4,6))

# Conversion du résultat en data frame
colsums_df <- data.frame(values = colsums, categories = names(colsums))

# Création du graphique à barres
png(paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_2_PresentMesures_HERh_TsKGE_SansImpactFort_2012_2022_20230426/Graphes/2_ProportionSurfacesDraineesFortInfluence_1_20230426.png"),
    width = 1200, height = 750,
    units = "px", pointsize = 12)
ggplot(colsums_df, aes(x = categories, y = values)) +
  geom_bar(stat = "identity", fill = "#756bb1") +
  xlab("HER 2 hybrides") +
  ylab("Pourcentage de surfaces (km²)") +
  ggtitle("Proportion des surfaces drainées soumises à une influence forte en toute saison") +
  theme_bw()
dev.off()


# Nombre de stations sous forte influence
colsums <- colSums(tab_stations_ImpFort[grep("eco0|eco1",colnames(tab_stations_ImpFort))]>0)
names(colsums) <- as.numeric(substr(names(colsums),4,6))

# Conversion du résultat en data frame
colsums_df <- data.frame(values = colsums, categories = names(colsums))

# Création du graphique à barres
png(paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_2_PresentMesures_HERh_TsKGE_SansImpactFort_2012_2022_20230426/Graphes/3_NbStationsFortInfluence_1_20230426.png"),
    width = 1200, height = 750,
    units = "px", pointsize = 12)
ggplot(colsums_df, aes(x = categories, y = values)) +
  geom_bar(stat = "identity", fill = "#756bb1") +
  xlab("HER 2 hybrides") +
  ylab("Nombre de stations") +
  ggtitle("Nombre de stations soumises à une influence forte en toute saison") +
  scale_y_continuous(breaks = seq(0, max(colsums_df$values), 1), 
                     labels = function(x) format(x, scientific = FALSE))+
  theme_bw()
dev.off()

# Pourcentage de stations sous forte influence
colsums <- colSums(tab_stations_ImpFort[grep("eco0|eco1",colnames(tab_stations_ImpFort))]>0)/colSums(tab_stations_[grep("eco0|eco1",colnames(tab_stations_))]>0)
names(colsums) <- as.numeric(substr(names(colsums),4,6))

# Conversion du résultat en data frame
colsums_df <- data.frame(values = colsums, categories = names(colsums))

# Création du graphique à barres
png(paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_2_PresentMesures_HERh_TsKGE_SansImpactFort_2012_2022_20230426/Graphes/4_ProportionStationsFortInfluence_1_20230426.png"),
    width = 1200, height = 750,
    units = "px", pointsize = 12)
ggplot(colsums_df, aes(x = categories, y = values*100)) +
  geom_bar(stat = "identity", fill = "#756bb1") +
  xlab("HER 2 hybrides") +
  ylab("Pourcentage de stations") +
  ggtitle("Pourcentage de stations soumises à une influence forte en toute saison") +
  theme_bw()
dev.off()

# x11()
# barplot(colSums(tab_stations_ImpFort[grep("eco0|eco1",colnames(tab_stations_ImpFort))]))
# barplot(colSums(tab_stations_ImpFort[grep("eco0|eco1",colnames(tab_stations_ImpFort))]>0)/colSums(tab_stations_[grep("eco0|eco1",colnames(tab_stations_))]>0))

