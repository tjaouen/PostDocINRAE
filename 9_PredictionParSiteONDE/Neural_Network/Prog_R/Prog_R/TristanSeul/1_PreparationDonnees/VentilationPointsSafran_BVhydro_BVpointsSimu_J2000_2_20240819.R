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
liste_ptsSimExp2_J2000_ <- read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/TablesParModele_20231203/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_J2000_32_20231204.csv",
                                     sep = ";", dec = ".", header = T)
liste_ptsSimExp2_J2000_$Code8_ChoixDefinitifPointSimu <- substr(liste_ptsSimExp2_J2000_$Code10_ChoixDefinitifPointSimu, 1, 8)
# liste_ptsSimExp2_J2000_sf_ <- st_as_sf(liste_ptsSimExp2_J2000_, coords = c("XL93","YL93"), crs = 2154)

### Safran ###
colnames(bv_ptsSimuExp2_)[which(colnames(bv_ptsSimuExp2_) == "Code10")] <- "Code10_BV"
colnames(bv_ptsSimuExp2_)[which(colnames(bv_ptsSimuExp2_) == "Code8")] <- "Code8_BV"
bv_ptsSimuExp2_$ControlMerge <- 1 # Controle que les points aient recu des points Safran Climat
liste_ptsSimExp2_J2000_$Code10_ChoixDefinitifPointSimu[which(!(liste_ptsSimExp2_J2000_$Code10_ChoixDefinitifPointSimu %in% bv_ptsSimuExp2_$Code10))]
# [1] "U230523001" "U004050000" "U013040000" "K428031000" "K428031000" "M106000100" "U122040000" "U122040000" "K126031000" "K196000101" "K122000100" "K439030000" "M105000100" "M035400000" "M031000101" "M003400000"
# [17] "K001872200" "K070451100" "K222601001" "K275862100" "K551000100" "K323030000" "M031000101" "M103402500" "M043401300" "M026400000" "M023400100" "M153451100" "M621401100" "M704401100" "M704400000" "M701024000"
# [33] "V540402600" "V540402600" "V715621300" "K228031000" "L080030000" "L061400000" "L202000300" "L111302100" "L093000100" "L211401300" "L210301300" "L210301300" "U107052000" "U141502001" "V101582200" "U260407300"
# [49] "U221521100" "U222054000" "U203502003" "U242601100" "U264040000" "U263050000" "U440502200" "U450601100" "V031040000" "V041050000" "W040040000" "V144621100" "V144621100" "V144621100" "V144621100" "V144621100"
# [65] "V144621100" "U440502200" "W331501100" "V424000100" "W333521100" "X102050000" "X102050000" "V716054000" "V716054000" "X347000100"
merge_J2000_ <- merge(liste_ptsSimExp2_J2000_, bv_ptsSimuExp2_, by.x = "Code10_ChoixDefinitifPointSimu", by.y = "Code10_BV", all.x = T) # Merge selon le code 10 les points de simu et les BV qui sont associes aux points SafranClimat
merge_J2000_$Code10_BV <- merge_J2000_$Code10_ChoixDefinitifPointSimu
length(which(is.na(merge_J2000_$ControlMerge))) # 74

# Passer a 0 si le BV ne contient pas de point Safran Climat
length(which(sapply(merge_J2000_$IndPointsSafranIntersect_, length) == 0)) # 12
merge_J2000_$ControlMerge[which(sapply(merge_J2000_$IndPointsSafranIntersect_, length) == 0)] = NA
length(which(is.na(merge_J2000_$ControlMerge))) # 86
na_rows <- which(is.na(merge_J2000_$ControlMerge)) # Points de simu sans correspondance de BV en Code10

second_merge <- merge(x = liste_ptsSimExp2_J2000_[na_rows, ], y = bv_ptsSimuExp2_, by.x = "Code8_ChoixDefinitifPointSimu", by.y = "Code8_BV", all.x = TRUE, all.y = FALSE) # Merge selon le code 8 les points de simu et les BV qui sont associes aux points SafranClimat
second_merge$Code8_BV <- second_merge$Code8_ChoixDefinitifPointSimu

second_merge <- second_merge[,colnames(merge_J2000_)]

# merge_J2000_[na_rows,c("Code8_ChoixDefinitifPointSimu","Code8.y","S_km2","dt_pstn","geometry","IndPointsSafranIntersect_","ControlMerge")]
# second_merge[,c("Code8_ChoixDefinitifPointSimu","Code8_ChoixDefinitifPointSimu","S_km2","dt_pstn","geometry","IndPointsSafranIntersect_","ControlMerge")]

merge_FirstSecondMerge_ <- rbind(merge_J2000_[which(merge_J2000_$ControlMerge == 1), ],
                                 second_merge)
merge_FirstSecondMerge_$Code10_ChoixDefinitifPointSimu[which(is.na(merge_FirstSecondMerge_$ControlMerge))]
merge_FirstSecondMerge_$ControlMerge[which(is.na(merge_FirstSecondMerge_$ControlMerge))]

length(which(is.na(merge_FirstSecondMerge_$ControlMerge))) # 19
length(which(sapply(merge_FirstSecondMerge_$IndPointsSafranIntersect_, length) == 0)) # 2
merge_FirstSecondMerge_$ControlMerge[which(sapply(merge_FirstSecondMerge_$IndPointsSafranIntersect_, length) == 0)] = NA
merge_FirstSecondMerge_$IndPointsSafranIntersect_[which(sapply(merge_FirstSecondMerge_$IndPointsSafranIntersect_, length) == 0)] = NA
merge_FirstSecondMerge_$ControlMerge[which(is.na(merge_FirstSecondMerge_$ControlMerge))]

merge_FirstSecondMerge_[which(is.na(merge_FirstSecondMerge_$ControlMerge)),] # 21: Points de simu sans correspondance ni en Code 10, ni en Code 8

merge_FirstSecondMerge_[which(!is.na(merge_FirstSecondMerge_$ControlMerge)),"IndPointsSafranIntersect_"]
nbPointsSafran_ <- sapply(merge_FirstSecondMerge_[which(!is.na(merge_FirstSecondMerge_$ControlMerge)),"IndPointsSafranIntersect_"], length)
mean(nbPointsSafran_) # 6.294

# merge_troisiemeMerge_ <- merge_J2000_[which(is.na(merge_FirstSecondMerge_$ControlMerge)),c("Code10_ChoixDefinitifPointSimu","XL93","YL93")]
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
            "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_31_ObservesReanalyseSafran_LienPointsSafranClimat/TablesParModele_20240816/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_J2000_30_20240816.csv",
            sep = ";", dec = ".", row.names = F)
