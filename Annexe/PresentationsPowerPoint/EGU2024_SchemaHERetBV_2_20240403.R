# tab_points_ = read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/TablesParModele_20231203/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_CTRIP_30_20231221.csv",
#                          sep = ";", dec = ".", header = T)
# tab_points_ = read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/TablesParModele_20231203/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_GRSD_30_20231203.csv",
#                              sep = ";", dec = ".", header = T)
# tab_points_ = read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/TablesParModele_20231203/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_J2000_32_20231204.csv",
#                          sep = ";", dec = ".", header = T)
# tab_points_ = read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/TablesParModele_20231203/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_ORCHIDEE_30_20231203.csv",
#                          sep = ";", dec = ".", header = T)
# tab_points_ = read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/TablesParModele_20231203/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_SMASH_30_20231203.csv",
#                          sep = ";", dec = ".", header = T)

# tab_points_$XL93_ChoixDefinitifPointSimu
# tab_points_$YL93_ChoixDefinitifPointSimu

# library(rgdal)
# library(sp)
# 
# # Créez un objet SpatialPointsDataFrame
# coordinates <- cbind(tab_GRSDpoints_$XL93_ChoixDefinitifPointSimu, tab_GRSDpoints_$YL93_ChoixDefinitifPointSimu)
# proj4string <- CRS("+proj=lcc +lat_1=49 +lat_2=44 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")  # Projection Lambert 93
# sp_points <- SpatialPointsDataFrame(coordinates, data = tab_GRSDpoints_, proj4string = proj4string)

# Écrivez l'objet SpatialPointsDataFrame dans un fichier shapefile
# writeOGR(obj = sp_points, dsn = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/ShpParModele_20240402/", layer = "StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_CTRIP_30_20231203", driver = "ESRI Shapefile")  # Remplacez "chemin/vers/votre/dossier/de/destination" par le chemin réel du dossier de destination et "nom_du_fichier_shapefile" par le nom souhaité pour le fichier shapefile
# writeOGR(obj = sp_points, dsn = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/ShpParModele_20240402/", layer = "StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_GRSD_30_20231203", driver = "ESRI Shapefile")  # Remplacez "chemin/vers/votre/dossier/de/destination" par le chemin réel du dossier de destination et "nom_du_fichier_shapefile" par le nom souhaité pour le fichier shapefile
# writeOGR(obj = sp_points, dsn = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/ShpParModele_20240402/", layer = "StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_J2000_30_20231203", driver = "ESRI Shapefile")  # Remplacez "chemin/vers/votre/dossier/de/destination" par le chemin réel du dossier de destination et "nom_du_fichier_shapefile" par le nom souhaité pour le fichier shapefile
# writeOGR(obj = sp_points, dsn = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/ShpParModele_20240402/", layer = "StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_ORCHIDEE_30_20231203", driver = "ESRI Shapefile")  # Remplacez "chemin/vers/votre/dossier/de/destination" par le chemin réel du dossier de destination et "nom_du_fichier_shapefile" par le nom souhaité pour le fichier shapefile
# writeOGR(obj = sp_points, dsn = "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/ShpParModele_20240402/", layer = "StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_SMASH_30_20231203", driver = "ESRI Shapefile")  # Remplacez "chemin/vers/votre/dossier/de/destination" par le chemin réel du dossier de destination et "nom_du_fichier_shapefile" par le nom souhaité pour le fichier shapefile










# Chargement des packages
library(sf)
library(ggplot2)
library(ggspatial)

# Chemin vers les fichiers shapefile
chemin_HER <- "/home/tjaouen/Documents/Input/HER/HER2hybrides/Shapefile_Lambert93/HER2_hybrides_L93.shp"
chemin_ONDE <- "/home/tjaouen/Documents/Input/ONDE/Data_Description/Shapefiles/Liste_3302StationsONDES_SansArrondi_VersionShp_1/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_1_20230404.shp"
# chemin_ONDE <- "/home/tjaouen/Documents/Input/ONDE/Data_Description/Shapefiles/Liste_3302StationsONDES_SimpleArrondi_VersionShp_1/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_SimpleArrondi_1_20230404.shp"
chemin_HYDRO <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/ShpParModele_20240402/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_GRSD_30_20231203.shp"
chemin_RHT <- "/home/tjaouen/Documents/Input/RHT/rht_2020/rht_lbt93.shp"
chemin_BV <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DescriptionPointsSimulation/entiteHydro/BassinsVersants_Concatenes_20231129/BV_concatenes_4210pointsSimulationExp2_20231130.shp"
chemin_France <- "/home/tjaouen/Documents/Input/FondsCartes/ContoursAdministratifs/FRA_adm_shp/FRA_adm0.shp"

# Charger les données shapefile
HER <- st_read(chemin_HER)
ONDE <- st_read(chemin_ONDE)
HYDRO <- st_read(chemin_HYDRO)
RHT <- st_read(chemin_RHT)
BV <- st_read(chemin_BV)
France_ <- st_read(chemin_France)

HER <- st_transform(HER, "+proj=lcc +lat_1=44 +lat_2=49 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +datum=WGS84 +units=m +no_defs")
ONDE <- st_transform(ONDE, "+proj=lcc +lat_1=44 +lat_2=49 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +datum=WGS84 +units=m +no_defs")
HYDRO <- st_transform(HYDRO, "+proj=lcc +lat_1=44 +lat_2=49 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +datum=WGS84 +units=m +no_defs")
RHT <- st_transform(RHT, "+proj=lcc +lat_1=44 +lat_2=49 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +datum=WGS84 +units=m +no_defs")
BV <- st_transform(BV, "+proj=lcc +lat_1=44 +lat_2=49 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +datum=WGS84 +units=m +no_defs")

France_ <- st_transform(France_, "+proj=lcc +lat_1=44 +lat_2=49 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +datum=WGS84 +units=m +no_defs")

# Filtrer les données de la région CdHER2 = 3
region_HER <- HER[HER$CdHER2 == 3, ]

# Trouver l'intersection entre region_HER et les points ONDE
intersection_ONDE <- st_intersection(region_HER, ONDE)

intersection_HYDRO <- st_intersection(region_HER, HYDRO)
# intersection_HYDRO <- intersection_HYDRO[which(intersection_HYDRO$Cod10 %in% c("V203041001","U203503002","U212201001")),]
intersection_HYDRO <- intersection_HYDRO[which(intersection_HYDRO$Cod10 %in% c("V203041001","U202201001","U212201001")),]

intersection_RHT <- st_intersection(region_HER, RHT)

intersection_BV <- BV[which(BV$Code10 %in% intersection_HYDRO$Cod10),]
intersection_BV <- st_intersection(region_HER, intersection_BV)

# intersection_HYDRO$Cod10
# U200201001, U201201001, U202201001, U203503002, U212201001, U345501001, V203041001, V211401001, V220601001


### CARTE DE LA HER ###
x11()
plot_1_ <- ggplot() +
  geom_sf(data = region_HER, fill = "white", alpha = 0, color = "#454547", lwd = 0.7) +
  
  geom_sf(data = intersection_BV, alpha = 0, color = "#034e7b", lwd = 1.3) +
  # geom_sf(data = intersection_BV, fill = "#a6bddb", alpha = 0.5, color = "#034e7b", lwd = 0.2) +
  
  geom_sf(data = intersection_RHT, color = "#a6bddb", lwd = 0.8) +
  geom_sf(data = intersection_HYDRO, aes(label = Cod10), color = "white", size = 13.5) +
  geom_sf(data = intersection_HYDRO, aes(label = Cod10), color = "#034e7b", size = 12) +
  # geom_sf(data = intersection_ONDE, color = "#fe9929", size = 3) +
  
  # geom_text(data = intersection_HYDRO, aes(label = Cod10), color = "black", size = 3, check_overlap = TRUE) +  # Ajout de labels
  # geom_text(data = intersection_HYDRO, aes(x = XL93, y = YL93, label = Cod10), color = "black", size = 3, check_overlap = TRUE) +  # Ajout de labels
  
  annotation_scale(location = "bl",
                   line_width = .8,
                   text_cex = 1.1,
                   pad_x = unit(0.2, "npc"),
                   pad_y = unit(0.05, "npc"),
                   style = 'ticks',
                   bar_cols = "#454547",
                   text = element_blank())+
  theme_void()
plot_1_
ggsave(filename = "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/SchemaHER3_Image1_2_20240405.png",
       plot = plot_1_)


plot_2_ <- ggplot() +
  geom_sf(data = region_HER, fill = "#ece7f2", alpha = 0, color = "#454547", lwd = 0.7) +
  
  geom_sf(data = intersection_BV, alpha = 0, color = "#034e7b", lwd = 1.3) +
  # geom_sf(data = intersection_BV, fill = "#a6bddb", alpha = 0.5, color = "#034e7b", lwd = 0.2) +
  
  geom_sf(data = intersection_RHT, color = "#a6bddb", lwd = 0.8) +
  geom_sf(data = intersection_HYDRO, aes(label = Cod10), color = "white", size = 13.5) +
  geom_sf(data = intersection_HYDRO, aes(label = Cod10), color = "#034e7b", size = 12) +
  geom_sf(data = intersection_ONDE, color = "#fe9929", size = 6) +
  
  # geom_text(data = intersection_HYDRO, aes(x = XL93, y = YL93, label = Cod10), color = "black", size = 3, check_overlap = TRUE) +  # Ajout de labels
  
  annotation_scale(location = "bl",
                   line_width = .8,
                   text_cex = 1.1,
                   pad_x = unit(0.2, "npc"),
                   pad_y = unit(0.05, "npc"),
                   style = 'ticks',
                   bar_cols = "#454547",
                   text = element_blank())+
  theme_void()
plot_2_
ggsave(filename = "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/SchemaHER3_Image2_2_20240405.png",
       plot = plot_2_)


