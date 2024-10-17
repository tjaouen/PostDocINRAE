library(sf)

shp_Recharge_ <- st_read("/home/tjaouen/Documents/Input/Recharge/Shp/MESO_FR_Hor1_RGF_93.shp")

# head(shapefile)
# summary(shapefile)

onde <- read.table("/home/tjaouen/Documents/Input/ONDE/Data_Description/CorrespondanceOndeHer/HER2hybrides/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_3_20230331.csv", header = T, sep = ",", dec = ".", row.names = NULL, quote="")
onde_sf <- st_as_sf(onde, coords = c("X_Lambert93", "Y_Lambert93"), crs = 2154)  # EPSG 4326 correspond à WGS84

# Si nécessaire, transforme onde_sf au même CRS que shp_Recharge_
shp_Recharge_ <- st_transform(shp_Recharge_, st_crs(onde_sf))

# Maintenant, tu peux utiliser st_intersects
intersections <- st_intersects(onde_sf,shp_Recharge_)

# Convertir les intersections en un data.frame lisible
# Associer chaque point à l'indice du polygone intersecté (ou NA si pas d'intersection)
result_df <- data.frame(
  Code = seq_along(intersections),  # Indice du point dans onde_sf
  ID_Recharge = sapply(intersections, function(x) if (length(x) == 0) NA else x[1])  # Premier polygone intersecté ou NA
)

onde_sf$ID_Recharge <- result_df$ID_Recharge
onde_sf <- cbind(onde_sf,shp_Recharge_[onde_sf$ID_Recharge,])

write.table(onde_sf[,!grepl("geometry",colnames(onde_sf))],
            "/home/tjaouen/Documents/Input/ONDE/Data_Description/VentilationRecharge/Ventilation_SiteONDE_RechargePotentielle_1_20241001.csv",
            sep = ";", dec = ".", row.names = F)



# library(ggplot2)
# x11()
# ggplot() +
#   geom_sf(data = shp_Recharge_) +
#   geom_point(data = onde_sf, color = "red") +
#   theme_minimal()


