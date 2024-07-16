# Charger les bibliothèques
library(sf)
library(dplyr)
library(tidyr)

# Charger les fichiers shapefile
# bassins_versants <- st_read("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DescriptionPointsSimulation/entiteHydro/BassinsVersants_Concatenes_20231129/BV_concatenes_4210pointsSimulationExp2_20231129.shp")
j2000 <- st_read("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DescriptionPointsSimulation/entiteHydro/PointsJ2000/J2000.shp")
hydroecoregions <- st_read("/home/tjaouen/Documents/Input/HER/HER2hybrides/Shapefile_Lambert93/HER2_hybrides_L93.shp")

# Vérifier la projection des fichiers
st_crs(bassins_versants)
st_crs(hydroecoregions)

# Assurer la même projection pour les deux fichiers si ce n'est pas le cas
# Si les projections sont différentes, utilisez st_transform() pour les mettre dans la même projection

# Calculer les intersections entre les deux fichiers
intersections <- st_intersection(j2000, hydroecoregions)

hydroecoregions$Surface_HER2 <- st_area(hydroecoregions)

table(intersections$CdHER2)


# Calculer le nombre de points par région HER2
nombre_points_par_HER2 <- table(intersections$CdHER2)

df_nombre_points <- as.data.frame(nombre_points_par_HER2)

# Renommer les colonnes pour une meilleure compréhension
names(df_nombre_points) <- c("CdHER2", "Nombre_Points")

# Charger la surface des régions HER2
hydroecoregions$Surface_HER2 <- st_area(hydroecoregions)

# Joindre les données du nombre de points par région HER2 avec les informations de surface
merged_data <- merge(df_nombre_points, hydroecoregions[, c("CdHER2", "Surface_HER2")], by = "CdHER2")

# Calculer la densité de points pour 1000 km² pour chaque région HER2
merged_data$Densite_1000km2 <- (merged_data$Nombre_Points / (merged_data$Surface_HER2 / 1000000)) * 1000

# Afficher les résultats
print(merged_data[, c("CdHER2", "Densite_1000km2")])

# tab_densite_ = merged_data[, c("CdHER2", "Densite_1000km2")]
merged_data[order(merged_data$Densite_1000km2, decreasing = T),]

