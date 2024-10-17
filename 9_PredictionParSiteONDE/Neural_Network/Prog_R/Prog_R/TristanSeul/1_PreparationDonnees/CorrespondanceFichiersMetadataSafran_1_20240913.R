library(sf)

tab_propSurfSafran_ <- read.table("/home/tjaouen/Documents/Input/ONDE/Data_Description/VentilationSafranClimat/PropSurfaceSafran_2_20240912.txt", sep = ";", dec = ".", header = T)
sf_object <- st_as_sf(tab_propSurfSafran_, coords = c("XLambert2", "YLambert2"), crs = 27572)
sf_object_Lambert93 <- st_transform(sf_object, crs = 2154)
st_coordinates(sf_object_Lambert93)
new_coords <- st_coordinates(sf_object_Lambert93)
tab_propSurfSafran_$XLambert93 <- new_coords[,1]
tab_propSurfSafran_$YLambert93 <- new_coords[,2]

tab_metaData_ <- read.table("/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/metadata.txt", sep = ";", dec = ".", header = T)
tab_metaData_sf_ <- st_as_sf(tab_metaData_, coords = c("x","y"), crs = 27572)
tab_metaData_sf_Lambert93 <- st_transform(tab_metaData_sf_, crs = 2154)
st_coordinates(tab_metaData_sf_Lambert93)
tab_metaData_new_coords <- st_coordinates(tab_metaData_sf_Lambert93)
tab_metaData_$XLambert93 <-tab_metaData_new_coords[,1]
tab_metaData_$YLambert93 <-tab_metaData_new_coords[,2]

tab_propSurfSafran_$XLambert93 == tab_metaData_$XLambert93


length(unique(tab_propSurfSafran_$NumMaill))


min(tab_metaData_$x)
max(tab_metaData_$x)
min(tab_metaData_$y)
max(tab_metaData_$y)

min(tab_propSurfSafran_$XLambert93)
max(tab_propSurfSafran_$XLambert93)
min(tab_propSurfSafran_$YLambert93)
max(tab_propSurfSafran_$YLambert93)

which(tab_metaData_$XLambert93 == tab_propSurfSafran_$XLambert93)
which(tab_metaData_$YLambert93 == tab_propSurfSafran_$YLambert93)


