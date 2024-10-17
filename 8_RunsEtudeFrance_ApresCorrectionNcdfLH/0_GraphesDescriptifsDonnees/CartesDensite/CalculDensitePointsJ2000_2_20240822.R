# Charger les bibliothèques
library(sf)
library(dplyr)
library(tidyr)

# Charger les fichiers shapefile
# bassins_versants <- st_read("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DescriptionPointsSimulation/entiteHydro/BassinsVersants_Concatenes_20231129/BV_concatenes_4210pointsSimulationExp2_20231129.shp")
j2000 <- read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_31_ObservesReanalyseSafran_LienPointsSafranClimat/TablesParModele_20240816/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_J2000_30_20240816.csv",
                    sep = ";", dec = ".", header = T)
hydroecoregions <- st_read("/home/tjaouen/Documents/Input/HER/HER2hybrides/Shapefile_Lambert93/HER2_hybrides_L93.shp")

# Vérifier la projection des fichiers
# st_crs(bassins_versants)
st_crs(j2000)
st_crs(hydroecoregions)

# Créer un objet sf avec les coordonnées Lambert 93
points_sf <- st_as_sf(j2000, coords = c("XL93", "YL93"), crs = 2154)
# points_sf_wgs84 <- st_transform(points_sf, crs = 4326)

# Assurer la même projection pour les deux fichiers si ce n'est pas le cas
# Si les projections sont différentes, utilisez st_transform() pour les mettre dans la même projection

# Calculer les intersections entre les deux fichiers
intersections <- st_intersection(points_sf, hydroecoregions)

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

merged_data$Surface_HER2

# Calculer la densité de points pour 1000 km² pour chaque région HER2
merged_data$Densite_1000km2 <- (merged_data$Nombre_Points / (merged_data$Surface_HER2 / 1000000)) * 1000

# Afficher les résultats
print(merged_data[, c("CdHER2", "Densite_1000km2")])

# tab_densite_ = merged_data[, c("CdHER2", "Densite_1000km2")]
merged_data[order(merged_data$Densite_1000km2, decreasing = T),]





HER_ <- c("2", "3", "5", "12", "13", "14", "17", "21", "22", "24", "25", "27", "28", "34", "35", "36",
          "38", "40", "41", "43", "44", "50", "51", "52", "53", "55", "56", "57", "58", "59", "61",
          "62", "63", "64", "65", "66", "67", "68", "70", "71", "73", "74", "75", "76", "77", "78",
          "79", "81", "84", "85", "86", "87", "91", "93", "94", "97", "98", "99", "101", "103", "104",
          "105", "106", "107", "108", "112", "113", "117", "118", "120", "31033039", "37054", "69096",
          "89092", "49090")

hydroecoregions$Surface_HER2[hydroecoregions$CdHER2 == 31] + hydroecoregions$Surface_HER2[hydroecoregions$CdHER2 == 33] + hydroecoregions$Surface_HER2[hydroecoregions$CdHER2 == 39] # 4591937123
hydroecoregions$Surface_HER2[hydroecoregions$CdHER2 == 37] + hydroecoregions$Surface_HER2[hydroecoregions$CdHER2 == 54] # 24768012397
hydroecoregions$Surface_HER2[hydroecoregions$CdHER2 == 69] + hydroecoregions$Surface_HER2[hydroecoregions$CdHER2 == 96] # 7807798838
hydroecoregions$Surface_HER2[hydroecoregions$CdHER2 == 89] + hydroecoregions$Surface_HER2[hydroecoregions$CdHER2 == 92] # 23847306390
hydroecoregions$Surface_HER2[hydroecoregions$CdHER2 == 49] + hydroecoregions$Surface_HER2[hydroecoregions$CdHER2 == 90] # 5757879325

merged_data[order(merged_data$Densite_1000km2),]
(4+43)/24768012397 # 1.897609e-09
(5+13)/5757879325 # 3.126151e-09

# cbind(merged_data,
#       c(37054,4+43,24768012397,NA),
#       c(49090,5+13,5757879325,NA))

# 2   3   5  12  13  14  25  28  36  37  38  41  43  44  49  50  51  52  53  54  55  56  57  58  62  64 
# 17   6   7   2   6   2   1   4   1   4   9  25   4   4   5  17   2  19  13  43   3   3   2  28   4  11 
# 66  70  71  73  74  75  76  79  81  84  85  86  87  90  91  92  93  97  98  99 101 105 106 107 112 113 
# 3   2  10   7   1  10   6   7  13  13  13  14   7  13   1  41   1  22   9  11   3   8   3   3   1   7 
# 117 120 
# 2   9 



