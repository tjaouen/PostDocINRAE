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


