library(ggplot2)
library(ggrepel)
library(ncdf4)
library(sf)

### Explore2 Climat ###
nc_proj_ <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/prtotAdjust_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_19500101-20051231.nc")

lat_proj_ <- ncvar_get(nc_proj_, "lat")
lon_proj_ <- ncvar_get(nc_proj_, "lon")
LambertParisII_proj_ <- ncvar_get(nc_proj_, "LambertParisII")
prtotAdjust_proj_ <- ncvar_get(nc_proj_, "prtotAdjust")
# 143*134

dim(lat_proj_)
dim(lon_proj_)
length(LambertParisII_proj_)
dim(prtotAdjust_proj_)
nc_proj_$dim$x$vals
nc_proj_$dim$x$units
nc_proj_$dim$y$vals
nc_proj_$dim$y$units
as.Date(nc_proj_$dim$time$vals, origin = "1950-01-01")
nc_proj_$dim$time$units

df_proj_ <- data.frame(lat_proj_ = as.vector(lat_proj_),
                       lon_proj_ = as.vector(lon_proj_))
df_proj_$NumMaille_proj_ <- 1:nrow(df_proj_)


# Conversion du data frame en objet sf (système de coordonnées EPSG:4326 - WGS84)
coord_proj_ <- st_as_sf(df_proj_, coords = c("lon_proj_", "lat_proj_"), crs = 4326)
coord_proj_lambertII <- st_transform(coord_proj_, crs = 27572)
coord_proj_lambertII_xy <- as.data.frame(st_coordinates(coord_proj_lambertII))
coord_proj_lambertII_xy$X <- round(coord_proj_lambertII_xy$X)
coord_proj_lambertII_xy$Y <- round(coord_proj_lambertII_xy$Y)
coord_proj_lambertII_xy$NumMaille_proj_ <- coord_proj_lambertII$NumMaille_proj_
coord_proj_arrondi <- st_as_sf(coord_proj_lambertII_xy, coords = c("X", "Y"), crs = 27572)


### Metadata ###
df_calib_ <- read.table("/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/metadata.txt",sep=";",dec=".",header=T)
coord_calib_lambertII <- st_as_sf(df_calib_, coords = c("x", "y"), crs = 27572)
coord_calib_lambertII_xy <- as.data.frame(st_coordinates(coord_calib_lambertII))
coord_calib_lambertII_xy$NumMaille_calib_ <- 1:nrow(coord_calib_lambertII_xy)

# Lire le fichier de formes de la France (remplacez par le chemin correct)
# france_shp <- st_read("/home/tjaouen/Documents/Input/FondsCartes/ContoursAdministratifs/FRA_adm_shp/FRA_adm0.shp")
# france_lambert93 <- st_transform(france_shp, crs = 2154)



corresp_ <- merge(coord_calib_lambertII_xy,coord_proj_lambertII_xy, by=c("X","Y"), all.x=T)
corresp_ <- corresp_[order(corresp_$NumMaille_calib_),]
colnames(corresp_) <- c("XLambert2_Maille","YLambert2_Maille","NumMaille_calib_","NumMaille_proj_")

ventilationONDE_Safran_ <- read.table("/home/tjaouen/Documents/Input/ONDE/Data_Description/VentilationSafranClimat/PropSurfaceSafran_2_20240912.txt",
                                      sep=";",dec =".",header=T)
colnames(ventilationONDE_Safran_) <- c("XLambert2_onde","YLambert2_onde","SurfaceT_onde","NumMaille_calib_","SurfCont","Name_onde")
mergeVentilation_ <- merge(ventilationONDE_Safran_,corresp_,by=c("NumMaille_calib_"))

mergeVentilation_ <- mergeVentilation_[order(mergeVentilation_$Name,-mergeVentilation_$NumMaille_calib_),
                                       c("Name_onde","XLambert2_onde","YLambert2_onde","SurfaceT_onde","SurfCont",
                                         "NumMaille_calib_","NumMaille_proj_","XLambert2_Maille","YLambert2_Maille")]

write.table(mergeVentilation_,"/home/tjaouen/Documents/Input/ONDE/Data_Description/VentilationSafranClimat/PropSurfaceSafran_3_20241011.txt",
            sep=";",dec =".",row.names=F)




join_result <- st_is_within_distance(coord_calib_lambertII, coord_proj_lambertII, dist = 0)

join_df <- data.frame(
  calib_index = rep(1:nrow(coord_calib_lambertII), sapply(join_result, length)),
  proj_index = unlist(join_result)
)

joined_data <- merge(
  coord_calib_lambertII, 
  coord_proj_lambertII[join_df$proj_index,], 
  by.x = "geometry", 
  by.y = "geometry"
)


coord_proj_lambertII_xy[which.min(sqrt(abs(coord_proj_lambertII_xy$X-coord_calib_lambertII_xy$X[1])^2+abs(coord_proj_lambertII_xy$Y-coord_calib_lambertII_xy$Y[1])^2)),]
coord_calib_lambertII_xy[1,]
coord_proj_lambertII_xy[19090,]

coord_lambertII$geometry

metadata_lambert2$
st_

# # Tracer la carte de la France et les points
# ggplot() +
#   geom_sf(data = france_lambert93, fill = "lightblue", color = "black") +  # Carte de la France
#   geom_sf(data = coord_lambert93, color = "red", size = 0.2) +  # Points en Lambert 93
#   geom_sf(data = metadata_lambert93, color = "blue", size = 0.2) +  # Points en Lambert 93
#   theme_minimal() +
#   labs(title = "Points sur la carte de la France (Lambert 93)",
#        x = "Longitude (Lambert 93)",
#        y = "Latitude (Lambert 93)")



# Coordonnées Lambert 93 pour Lyon
x_min <- 820000  # Limite ouest
x_max <- 930000  # Limite est
y_min <- 6460000  # Limite sud
y_max <- 6600000  # Limite nord


coord_lambert93_zoom <- coord_lambert93[which(coord_lambert93_xy)]
# Tracer la carte avec les points et les étiquettes
ggplot() +
  geom_sf(data = france_lambert93, fill = "lightblue", color = "black") +  # Carte de la France
  geom_sf(data = coord_lambert93, color = "red", size = 4) +  # Points de coord_lambert93 en rouge
  geom_sf(data = metadata_lambert93, color = "blue", size = 2) +  # Points de metadata_lambert93 en bleu
  coord_sf(xlim = c(835000, 870000), ylim = c(6200000, 6250000)) +  # Zoom sur Lyon  
  # Étiquettes pour coord_lambert93 en rouge
  geom_text_repel(data = coord_lambert93, 
                  aes(label = num, geometry = geometry), 
                  stat = "sf_coordinates", 
                  color = "red", size = 3) +
  
  # Étiquettes pour metadata_lambert93 en bleu
  geom_text_repel(data = metadata_lambert93, 
                  aes(label = cell, geometry = geometry), 
                  stat = "sf_coordinates", 
                  color = "blue", size = 3) +
  
  # coord_sf() +  # Ajustement des axes automatiquement
  theme_minimal() +
  labs(title = "Points avec étiquettes sur la carte de la France (Lambert 93)",
       x = "Longitude (Lambert 93)",
       y = "Latitude (Lambert 93)")



# Tracer la carte avec zoom sur Lyon
ggplot() +
  geom_sf(data = france_lambert93, fill = "lightblue", color = "black") +  # Carte de la France
  geom_sf(data = coord_lambert93, color = "red", size = 0.2) +  # Points en Lambert 93
  geom_sf(data = metadata_lambert93, color = "blue", size = 0.2) +  # Points en Lambert 93
  # coord_sf(xlim = c(x_min, x_max), ylim = c(y_min, y_max)) +  # Zoom sur Lyon
  theme_minimal() +
  labs(title = "Zoom sur Lyon (Lambert 93)",
       x = "Longitude (Lambert 93)",
       y = "Latitude (Lambert 93)")




which.min(abs(round(coord_lambert93_xy,0)[,1]-round(metadata_lambert93_xy,0)[1,1]))

st_join(metadata_lambert93_xy,coord_lambert93_xy)


coord_lambert93$geometry == metadata_lambert93$geometry



a = st_sf(a = 1:3,
          geom = st_sfc(st_point(c(1,1)), st_point(c(2,2)), st_point(c(3,3))))
b = st_sf(a = 11:14,
          geom = st_sfc(st_point(c(10,10)), st_point(c(2,2)), st_point(c(2,2)), st_point(c(3,3))))
st_join(a, b)
st_join(a, b, left = FALSE)
# two ways to aggregate y's attribute values outcome over x's geometries:
st_join(a, b) %>% aggregate(list(.$a.x), mean)
if (require(dplyr, quietly = TRUE)) {
  st_join(a, b) %>% group_by(a.x) %>% summarise(mean(a.y))
}





# Effectuer une jointure spatiale pour trouver les points correspondants
points_intersection <- st_join(coord_metadata_, coord_lambert93, join = st_equals)

# Afficher les points qui ont une correspondance
points_correspondants <- points_intersection[!is.na(points_intersection$cell), ]


# Affichage des résultats
print(points_correspondants)
