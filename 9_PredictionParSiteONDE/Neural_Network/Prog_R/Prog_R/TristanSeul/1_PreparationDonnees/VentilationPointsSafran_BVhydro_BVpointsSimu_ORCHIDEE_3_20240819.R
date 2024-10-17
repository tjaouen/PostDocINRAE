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
liste_ptsSimExp2_ORCHIDEE_ <- read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/TablesParModele_20231203/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_ORCHIDEE_30_20231203.csv",
                                      sep = ";", dec = ".", header = T)
liste_ptsSimExp2_ORCHIDEE_$Code8_ChoixDefinitifPointSimu <- substr(liste_ptsSimExp2_ORCHIDEE_$Code10_ChoixDefinitifPointSimu, 1, 8)
# liste_ptsSimExp2_ORCHIDEE_sf_ <- st_as_sf(liste_ptsSimExp2_ORCHIDEE_, coords = c("XL93","YL93"), crs = 2154)

### Safran ###
colnames(bv_ptsSimuExp2_)[which(colnames(bv_ptsSimuExp2_) == "Code10")] <- "Code10_BV"
colnames(bv_ptsSimuExp2_)[which(colnames(bv_ptsSimuExp2_) == "Code8")] <- "Code8_BV"
bv_ptsSimuExp2_$ControlMerge <- 1 # Controle que les points aient recu des points Safran Climat
liste_ptsSimExp2_ORCHIDEE_$Code10_ChoixDefinitifPointSimu[which(!(liste_ptsSimExp2_ORCHIDEE_$Code10_ChoixDefinitifPointSimu %in% bv_ptsSimuExp2_$Code10))]
# [1] "B517201001" "E237601001" "E237721001" "E237601001" "E366060002" "E638607001" "M102000301" "J471201002" "J522401002" "J552401002" "J522401002" "J621301001" "K222601001" "K222601001" "K222601001" "K262303000"
# [17] "K272422001" "K272422001" "K272422001" "K277312001" "L541182301" "M331301010" "N340000000" "N601400000" "P231050000" "S011451001" "U242521001" "U242521001" "U242522001" "U261582001" "W041401002" "V175501001"
# [33] "V615502002" "Y024401001" "Y046921101"
liste_ptsSimExp2_ORCHIDEE_$id <- 1:nrow(liste_ptsSimExp2_ORCHIDEE_)
merge_ORCHIDEE_ <- merge(liste_ptsSimExp2_ORCHIDEE_, bv_ptsSimuExp2_, by.x = "Code10_ChoixDefinitifPointSimu", by.y = "Code10_BV", all.x = T) # Merge selon le code 10 les points de simu et les BV qui sont associes aux points SafranClimat
merge_ORCHIDEE_ <- merge_ORCHIDEE_[order(merge_ORCHIDEE_$id), ]
merge_ORCHIDEE_$Code10_BV <- merge_ORCHIDEE_$Code10_ChoixDefinitifPointSimu
length(which(is.na(merge_ORCHIDEE_$ControlMerge))) # 35

# Passer a 0 si le BV ne contient pas de point Safran Climat
length(which(sapply(merge_ORCHIDEE_$IndPointsSafranIntersect_, length) == 0))
merge_ORCHIDEE_$ControlMerge[which(sapply(merge_ORCHIDEE_$IndPointsSafranIntersect_, length) == 0)] = NA
length(which(is.na(merge_ORCHIDEE_$ControlMerge))) # 72
na_rows <- which(is.na(merge_ORCHIDEE_$ControlMerge)) # Points de simu sans correspondance de BV en Code10

second_merge <- merge(x = liste_ptsSimExp2_ORCHIDEE_[na_rows, ], y = bv_ptsSimuExp2_, by.x = "Code8_ChoixDefinitifPointSimu", by.y = "Code8_BV", all.x = TRUE, all.y = FALSE) # Merge selon le code 8 les points de simu et les BV qui sont associes aux points SafranClimat
second_merge$Code8_BV <- second_merge$Code8_ChoixDefinitifPointSimu

second_merge <- second_merge[,colnames(merge_ORCHIDEE_)]

# merge_ORCHIDEE_[na_rows,c("Code8_ChoixDefinitifPointSimu","Code8.y","S_km2","dt_pstn","geometry","IndPointsSafranIntersect_","ControlMerge")]
# second_merge[,c("Code8_ChoixDefinitifPointSimu","Code8_ChoixDefinitifPointSimu","S_km2","dt_pstn","geometry","IndPointsSafranIntersect_","ControlMerge")]

merge_FirstSecondMerge_ <- rbind(merge_ORCHIDEE_[which(merge_ORCHIDEE_$ControlMerge == 1), ],
                                 second_merge)
merge_FirstSecondMerge_ <- merge_FirstSecondMerge_[order(merge_FirstSecondMerge_$id), ]
merge_FirstSecondMerge_$Code10_ChoixDefinitifPointSimu[which(is.na(merge_FirstSecondMerge_$ControlMerge))]
merge_FirstSecondMerge_$ControlMerge[which(is.na(merge_FirstSecondMerge_$ControlMerge))]

length(which(is.na(merge_FirstSecondMerge_$ControlMerge))) # 29
length(which(sapply(merge_FirstSecondMerge_$IndPointsSafranIntersect_, length) == 0)) # 36
merge_FirstSecondMerge_$ControlMerge[which(sapply(merge_FirstSecondMerge_$IndPointsSafranIntersect_, length) == 0)] = NA
merge_FirstSecondMerge_$IndPointsSafranIntersect_[which(sapply(merge_FirstSecondMerge_$IndPointsSafranIntersect_, length) == 0)] = NA
merge_FirstSecondMerge_$ControlMerge[which(is.na(merge_FirstSecondMerge_$ControlMerge))]

merge_FirstSecondMerge_[which(is.na(merge_FirstSecondMerge_$ControlMerge)),] # 65 : Points de simu sans correspondance ni en Code 10, ni en Code 8

merge_FirstSecondMerge_[which(!is.na(merge_FirstSecondMerge_$ControlMerge)),"IndPointsSafranIntersect_"]
nbPointsSafran_ <- sapply(merge_FirstSecondMerge_[which(!is.na(merge_FirstSecondMerge_$ControlMerge)),"IndPointsSafranIntersect_"], length)
mean(nbPointsSafran_) # 5.646

# merge_troisiemeMerge_ <- merge_ORCHIDEE_[which(is.na(merge_FirstSecondMerge_$ControlMerge)),c("Code10_ChoixDefinitifPointSimu","XL93","YL93")]
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
            "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_31_ObservesReanalyseSafran_LienPointsSafranClimat/TablesParModele_20240816/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_ORCHIDEE_30_20240816.csv",
            sep = ";", dec = ".", row.names = F)


# plot(st_geometry(bv_ptsSimuExp2_[1]), col = 'lightblue', main = "Polygone et Points")
# plot(merge_troisiemeMerge_$geometry[i], col = "red", cex = 20, add = TRUE)
# plot(pts_SafranClimat_sf_$geometry[188], col = "black", cex = 2, add = TRUE)
# plot(pts_SafranClimat_sf_$geometry[189], col = "black", cex = 5, add = TRUE)
# plot(pts_SafranClimat_sf_$geometry[163], col = "black", cex = 8, add = TRUE)
# plot(pts_SafranClimat_sf_$geometry[213], col = "black", cex = 10, add = TRUE)
# plot(pts_SafranClimat_sf_$geometry[187], col = "black", cex = 14, add = TRUE)

