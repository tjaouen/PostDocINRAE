library(sf)
library(dplyr)
library(geosphere)

### Functions ###
concat_elements <- function(x) {
  if (length(x) == 0) {
    return("")
  }
  paste(x, collapse = ", ")  # Concaténer les éléments avec un espace comme séparateur
}


pts_SafranClimat_ <- read.table("/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/metadata.txt", sep = ";", dec = ".", header = T)
pts_SafranClimat_sf_ <- st_as_sf(pts_SafranClimat_, coords = c("x","y"), crs = 27572)
pts_SafranClimat_sf_ <- st_transform(pts_SafranClimat_sf_, crs = 2154)
# sf_points <- st_as_sf(coords_lambert_IIe, coords = c("X", "Y"), crs = 27572)
# pts_SafranClimat_sf_ <- st_as_sf(pts_SafranClimat_, coords = c("x", "y"), crs = 27572)
# Convertir en Lambert 93 (EPSG:2154)
# pts_SafranClimat_sf_ <- st_transform(pts_SafranClimat_sf_, crs = 2154)

### EXPLORE 2 ###
bv_ptsSimuExp2_ <- st_read("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DescriptionPointsSimulation/entiteHydro/BassinsVersants_Concatenes_20231129/BV_concatenes_4210pointsSimulationExp2_20231130.shp")

bv_ptsSimuExp2_$IndPointsSafranIntersect_ <- NA
for (c in 1:nrow(bv_ptsSimuExp2_)){
  bv_ptsSimuExp2_$IndPointsSafranIntersect_[c] <- st_intersects(bv_ptsSimuExp2_[c,],pts_SafranClimat_sf_)
}


### Concatener en texte les listes de points Safran Climat pour pouvoir exporter la table ###
bv_ptsSimuExp2_export_ <- bv_ptsSimuExp2_
concatenated_list <- sapply(bv_ptsSimuExp2_export_$IndPointsSafranIntersect_, concat_elements)
bv_ptsSimuExp2_export_$IndPointsSafranIntersect_ <- concatenated_list

write.table(bv_ptsSimuExp2_export_,"/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DescriptionPointsSimulation/entiteHydro/BassinsVersants_Concatenes_20231129/bv_ptsSimuExp2_intersect_1_20240814.csv",
            sep = ";", dec = ".", row.names = F)

### Importer les tableaux de points de simulation pour savoir les BV qui nous interessent ###
liste_ptsSimExp2_CTRIP_ <- read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/TablesParModele_20231203/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_CTRIP_30_20231221.csv",
                                      sep = ";", dec = ".", header = T)
liste_ptsSimExp2_CTRIP_$Code8_ChoixDefinitifPointSimu <- substr(liste_ptsSimExp2_CTRIP_$Code10_ChoixDefinitifPointSimu, 1, 8)
# liste_ptsSimExp2_CTRIP_sf_ <- st_as_sf(liste_ptsSimExp2_CTRIP_, coords = c("XL93","YL93"), crs = 2154)

### Safran ###
colnames(bv_ptsSimuExp2_)[which(colnames(bv_ptsSimuExp2_) == "Code10")] <- "Code10_BV"
colnames(bv_ptsSimuExp2_)[which(colnames(bv_ptsSimuExp2_) == "Code8")] <- "Code8_BV"
bv_ptsSimuExp2_$ControlMerge <- 1 # Controle que les points aient recu des points Safran Climat
liste_ptsSimExp2_CTRIP_$Code10_ChoixDefinitifPointSimu[which(!(liste_ptsSimExp2_CTRIP_$Code10_ChoixDefinitifPointSimu %in% bv_ptsSimuExp2_$Code10))]
# [1] "B517201001" "E237601001" "E237721001" "E237601001" "E366060002" "E638607001" "M102000301" "J471201002" "J522401002" "J552401002" "J522401002" "J621301001" "K222601001" "K222601001" "K222601001" "K262303000"
# [17] "K272422001" "K272422001" "K272422001" "K277312001" "L541182301" "M331301010" "N340000000" "N601400000" "P231050000" "S011451001" "U242521001" "U242521001" "U242522001" "U261582001" "W041401002" "V175501001"
# [33] "V615502002" "Y024401001" "Y046921101"
merge_CTRIP_ <- merge(liste_ptsSimExp2_CTRIP_, bv_ptsSimuExp2_, by.x = "Code10_ChoixDefinitifPointSimu", by.y = "Code10_BV", all.x = T) # Merge selon le code 10 les points de simu et les BV qui sont associes aux points SafranClimat
merge_CTRIP_$Code10_BV <- merge_CTRIP_$Code10_ChoixDefinitifPointSimu
length(which(is.na(merge_CTRIP_$ControlMerge))) # 35

# Passer a 0 si le BV ne contient pas de point Safran Climat
length(which(sapply(merge_CTRIP_$IndPointsSafranIntersect_, length) == 0))
merge_CTRIP_$ControlMerge[which(sapply(merge_CTRIP_$IndPointsSafranIntersect_, length) == 0)] = NA
length(which(is.na(merge_CTRIP_$ControlMerge))) # 72
na_rows <- which(is.na(merge_CTRIP_$ControlMerge)) # Points de simu sans correspondance de BV en Code10

second_merge <- merge(x = liste_ptsSimExp2_CTRIP_[na_rows, ], y = bv_ptsSimuExp2_, by.x = "Code8_ChoixDefinitifPointSimu", by.y = "Code8_BV", all.x = TRUE, all.y = FALSE) # Merge selon le code 8 les points de simu et les BV qui sont associes aux points SafranClimat
second_merge$Code8_BV <- second_merge$Code8_ChoixDefinitifPointSimu

second_merge <- second_merge[,colnames(merge_CTRIP_)]

# merge_CTRIP_[na_rows,c("Code8_ChoixDefinitifPointSimu","Code8.y","S_km2","dt_pstn","geometry","IndPointsSafranIntersect_","ControlMerge")]
# second_merge[,c("Code8_ChoixDefinitifPointSimu","Code8_ChoixDefinitifPointSimu","S_km2","dt_pstn","geometry","IndPointsSafranIntersect_","ControlMerge")]

merge_FirstSecondMerge_ <- rbind(merge_CTRIP_[which(merge_CTRIP_$ControlMerge == 1), ],
                                 second_merge)
merge_FirstSecondMerge_$Code10_ChoixDefinitifPointSimu[which(is.na(merge_FirstSecondMerge_$ControlMerge))]
merge_FirstSecondMerge_$ControlMerge[which(is.na(merge_FirstSecondMerge_$ControlMerge))]

length(which(is.na(merge_FirstSecondMerge_$ControlMerge))) # 5
length(which(sapply(merge_FirstSecondMerge_$IndPointsSafranIntersect_, length) == 0)) # 14
merge_FirstSecondMerge_$ControlMerge[which(sapply(merge_FirstSecondMerge_$IndPointsSafranIntersect_, length) == 0)] = NA
merge_FirstSecondMerge_$IndPointsSafranIntersect_[which(sapply(merge_FirstSecondMerge_$IndPointsSafranIntersect_, length) == 0)] = NA
merge_FirstSecondMerge_$ControlMerge[which(is.na(merge_FirstSecondMerge_$ControlMerge))]

merge_FirstSecondMerge_[which(is.na(merge_FirstSecondMerge_$ControlMerge)),] # 19: Points de simu sans correspondance ni en Code 10, ni en Code 8
# 105                       E2377210 E237721001 E176601001 E176601001_HYDRO_QJM.txt            La Rhonelle à Aulnoy-lez-Valenciennes 737909 7025928 737.909  7025.928  685206.9  2593390          36         88.4
# 354                       J5524010 J552401002 J561832001 J561832001_HYDRO_QJM.txt                           Le Frémeur à Pluméliau 255903 6776495 255.903  6776.495  204965.3  2339825          59          6.7
# 429                       K2724220 K272422001 K272421001 K272421001_HYDRO_QJM.txt L'Artière à Clermont-Ferrand [Domaine de Crouel] 711070 6519114 711.070  6519.114  662635.0  2086010         341           49
# 435                       K2773120 K277312001 K277312001 K277312001_HYDRO_QJM.txt                           Le Bédat à Saint-Laure 722677 6533410 722.677  6533.410  674131.7  2100416         301          391

merge_FirstSecondMerge_[which(!is.na(merge_FirstSecondMerge_$ControlMerge)),"IndPointsSafranIntersect_"]
nbPointsSafran_ <- sapply(merge_FirstSecondMerge_[which(!is.na(merge_FirstSecondMerge_$ControlMerge)),"IndPointsSafranIntersect_"], length)
mean(nbPointsSafran_) # 5.59

# merge_troisiemeMerge_ <- merge_CTRIP_[which(is.na(merge_FirstSecondMerge_$ControlMerge)),c("Code10_ChoixDefinitifPointSimu","XL93","YL93")]
merge_troisiemeMerge_ <- merge_FirstSecondMerge_[which(is.na(merge_FirstSecondMerge_$ControlMerge)),]
merge_troisiemeMerge_ <- st_as_sf(merge_troisiemeMerge_, coords = c("XL93","YL93"), crs = 2154)

### Selection des 5 points les plus proches ###
for (i in 1:nrow(merge_troisiemeMerge_)){
  pts_SafranClimat_sf_$Distance <- st_distance(pts_SafranClimat_sf_, merge_troisiemeMerge_$geometry[i])
  merge_troisiemeMerge_$IndPointsSafranIntersect_[i] <- list(pts_SafranClimat_sf_$cell[order(pts_SafranClimat_sf_$Distance)][1:6])
}

concatenated_list <- sapply(merge_FirstSecondMerge_$IndPointsSafranIntersect_, concat_elements)
merge_FirstSecondMerge_$IndPointsSafranIntersect_ <- concatenated_list
concatenated_list <- sapply(merge_troisiemeMerge_$IndPointsSafranIntersect_, concat_elements)
merge_troisiemeMerge_$IndPointsSafranIntersect_ <- concatenated_list
merge_FirstSecondMerge_[which(is.na(merge_FirstSecondMerge_$ControlMerge)),"IndPointsSafranIntersect_"] <- merge_troisiemeMerge_$IndPointsSafranIntersect_
merge_FirstSecondMerge_[which(is.na(merge_FirstSecondMerge_$ControlMerge)),"ControlMerge"] <- merge_troisiemeMerge_$ControlMerge
# na_rows <- which(is.na(merge_FirstSecondMerge_$ControlMerge))
# for (r in 1:length(na_rows)){
#   merge_FirstSecondMerge_[na_rows[r],"IndPointsSafranIntersect_"] <- merge_troisiemeMerge_$IndPointsSafranIntersect_[r]
#   merge_FirstSecondMerge_[na_rows[r],"ControlMerge"] <- merge_troisiemeMerge_$ControlMerge[r]
# }

if ("geometry" %in% colnames(merge_FirstSecondMerge_)){
  merge_FirstSecondMerge_ <- merge_FirstSecondMerge_ %>% select(-geometry)
}
concatenated_list <- sapply(merge_FirstSecondMerge_$IndPointsSafranIntersect_, concat_elements)
merge_FirstSecondMerge_$IndPointsSafranIntersect_ <- concatenated_list


write.table(merge_FirstSecondMerge_,
            "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_31_ObservesReanalyseSafran_LienPointsSafranClimat/TablesParModele_20240816/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_CTRIP_30_20240816.csv",
            sep = ";", dec = ".", row.names = F)


# plot(st_geometry(bv_ptsSimuExp2_[1]), col = 'lightblue', main = "Polygone et Points")
# plot(merge_troisiemeMerge_$geometry[i], col = "red", cex = 20, add = TRUE)
# plot(pts_SafranClimat_sf_$geometry[188], col = "black", cex = 2, add = TRUE)
# plot(pts_SafranClimat_sf_$geometry[189], col = "black", cex = 5, add = TRUE)
# plot(pts_SafranClimat_sf_$geometry[163], col = "black", cex = 8, add = TRUE)
# plot(pts_SafranClimat_sf_$geometry[213], col = "black", cex = 10, add = TRUE)
# plot(pts_SafranClimat_sf_$geometry[187], col = "black", cex = 14, add = TRUE)

### REMERGER LE TROISIEME
### FAIRE POUR TOUS LES MODELES



pts_SafranClimat_sf_

point_ref <- st_point(c(737909,7025928))
point_ref_sf <- st_sfc(point_ref, crs = 2154)  # EPSG:2154 pour RGF93 / Lambert-93

coords <- matrix(c(673426.1, 7114037,
                   641374.2, 7106309,
                   649370.4, 7106242,
                   657366.5, 7106175,
                   665362.7, 7106108,
                   673358.8, 7106041), 
                 ncol = 2, byrow = TRUE)
pts_SafranClimat_sf <- st_as_sf(data, coords = coords, crs = 2154)
pts_SafranClimat_sf$distance <- st_distance(pts_SafranClimat_sf, point_ref_sf)
closest_points <- pts_SafranClimat_sf[order(pts_SafranClimat_sf$distance), ][1:5, ]
print(closest_points)








liste_ptsSimExp2_GRSD_$Code10_ChoixDefinitifPointSimu[which(!(liste_ptsSimExp2_GRSD_$Code10_ChoixDefinitifPointSimu %in% bv_ptsSimuExp2_$Code10))]
liste_ptsSimExp2_J2000_$Code10_ChoixDefinitifPointSimu[which(!(liste_ptsSimExp2_J2000_$Code10_ChoixDefinitifPointSimu %in% bv_ptsSimuExp2_$Code10))]
liste_ptsSimExp2_ORCHIDEE_$Code10_ChoixDefinitifPointSimu[which(!(liste_ptsSimExp2_ORCHIDEE_$Code10_ChoixDefinitifPointSimu %in% bv_ptsSimuExp2_$Code10))]
liste_ptsSimExp2_SMASH_$Code10_ChoixDefinitifPointSimu[which(!(liste_ptsSimExp2_SMASH_$Code10_ChoixDefinitifPointSimu %in% bv_ptsSimuExp2_$Code10))]



### HYDRO OBS ###
liste_ptsHYDRO_ <- read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidAnSecInterHum_2012_2022_20230919/Stations_HYDRO_KGESUp0.00_DispSup-1.csv",
                              sep = ";", dec = ".", header = T)

plot(st_geometry(bv_ptsSimuExp2_[c,]), col = 'lightblue', main = "Polygone et Points")
plot(st_geometry(pts_SafranClimat_sf_[list_intersect_[[1]],]), col = 'red', pch = 19, add = TRUE)


# Prendre tous les points qui sont dans le BV
# Compter combien ca fait de points par point de simu
# Selectionner les n points safran les plus proches des points de simu qui n'ont pas de BV


