library(ggplot2)
library(ggrepel)
library(ncdf4)
library(sf)

### Explore2 Climat ###
nc_ <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/prtotAdjust_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_19500101-20051231.nc")

lat <- ncvar_get(nc_, "lat")
lon <- ncvar_get(nc_, "lon")
LambertParisII <- ncvar_get(nc_, "LambertParisII")
prtotAdjust <- ncvar_get(nc_, "prtotAdjust")
# 143*134

dim(lat)
dim(lon)
length(LambertParisII)
dim(prtotAdjust)
nc_$dim$x$vals
nc_$dim$x$units
nc_$dim$y$vals
nc_$dim$y$units
as.Date(nc_$dim$time$vals, origin = "1950-01-01")
nc_$dim$time$units

df_lat_lon_ <- data.frame(lat_ = as.vector(lat),
                          lon_ = as.vector(lon))
df_lat_lon_$num <- 1:nrow(df_lat_lon_)


# Conversion du data frame en objet sf (système de coordonnées EPSG:4326 - WGS84)
coord_sf <- st_as_sf(df_lat_lon_, coords = c("lon_", "lat_"), crs = 4326)

# Transformation des coordonnées en Lambert 93 (EPSG:2154)
coord_lambert93 <- st_transform(coord_sf, crs = 2154)
coord_lambert93_xy <- st_coordinates(coord_lambert93)

coord_lambertII <- st_transform(coord_sf, crs = 27572)

# Afficher les coordonnées converties
coord_lambert93

### Metadata ###
metadata_ <- read.table("/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/metadata.txt",sep=";",dec=".",header=T)
metadata_lambert2 <- st_as_sf(metadata_, coords = c("x", "y"), crs = 27572)
metadata_lambert93 <- st_transform(metadata_lambert2, crs = 2154)
metadata_lambert93_xy <- st_coordinates(metadata_lambert93)

# Lire le fichier de formes de la France (remplacez par le chemin correct)
france_shp <- st_read("/home/tjaouen/Documents/Input/FondsCartes/ContoursAdministratifs/FRA_adm_shp/FRA_adm0.shp")
france_lambert93 <- st_transform(france_shp, crs = 2154)


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
