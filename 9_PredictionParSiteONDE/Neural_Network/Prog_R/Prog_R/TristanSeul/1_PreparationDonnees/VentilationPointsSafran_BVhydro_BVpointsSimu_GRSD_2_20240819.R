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
liste_ptsSimExp2_GRSD_ <- read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/TablesParModele_20231203/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_GRSD_30_20231203.csv",
                                      sep = ";", dec = ".", header = T)
liste_ptsSimExp2_GRSD_$Code8_ChoixDefinitifPointSimu <- substr(liste_ptsSimExp2_GRSD_$Code10_ChoixDefinitifPointSimu, 1, 8)
# liste_ptsSimExp2_GRSD_sf_ <- st_as_sf(liste_ptsSimExp2_GRSD_, coords = c("XL93","YL93"), crs = 2154)

### Safran ###
colnames(bv_ptsSimuExp2_)[which(colnames(bv_ptsSimuExp2_) == "Code10")] <- "Code10_BV"
colnames(bv_ptsSimuExp2_)[which(colnames(bv_ptsSimuExp2_) == "Code8")] <- "Code8_BV"
bv_ptsSimuExp2_$ControlMerge <- 1 # Controle que les points aient recu des points Safran Climat
liste_ptsSimExp2_GRSD_$Code10_ChoixDefinitifPointSimu[which(!(liste_ptsSimExp2_GRSD_$Code10_ChoixDefinitifPointSimu %in% bv_ptsSimuExp2_$Code10))]
# [1] "A152020100" "A111020000" "A404006000" "A600010000" "A261020100" "A321020000" "A810000100" "B517201001" "D020060000" "E131000100" "E364062000" "E490941100" "E403653200" "E648093300" "F333000100" "F041000201"
# [17] "U303601100" "F333000201" "F486000200" "G600061100" "F131000100" "F304000100" "F705000100" "H213060000" "H502301100" "H541203001" "H134000100" "E131000100" "F615000100" "F705000100" "I652000101" "J070000100"
# [33] "J060016000" "J170017000" "J262301100" "J381471000" "J362401101" "J471201002" "J552401002" "J132401100" "J552400000" "J832000100" "J470000100" "J621301001" "J764030000" "M611000100" "J522401002" "J561832200"
# [49] "K001872200" "V353000200" "V353000200" "K070451100" "V540402600" "K222601001" "K256400000" "K277312001" "K551000100" "K323030000" "M043401300" "M026400000" "M023400100" "M023400100" "M061030000" "M153451100"
# [65] "M331301010" "M621401100" "M704401100" "N111400000" "N202401100" "N420401100" "O149431003" "O335431200" "O333402101" "O631025000" "O714522100" "P502000100" "K265400000" "P301010000" "P151000100" "P242000100"
# [81] "P708000100" "Q068025000" "Q245029000" "R114040000" "R201501100" "R233050000" "S011451100" "O968531100" "U107052000" "U132903100" "U200201100" "U222054000" "U234641400" "U234641400" "U261582001" "U264040000"
# [97] "U263050000" "V231000201" "U200201100" "U440502200" "U450601100" "V031040000" "V041050000" "W042501002" "V125841200" "V144621100" "V144621100" "W110050000" "V161040000" "U200201100" "U440502200" "V403402200"
# [113] "W333521100" "X102050000" "X140000200" "Y062522200" "Y046600600" "Y081400200" "Y121020000" "Y420000300" "Y461502701" "Y760000100" "Y970000100"
merge_GRSD_ <- merge(liste_ptsSimExp2_GRSD_, bv_ptsSimuExp2_, by.x = "Code10_ChoixDefinitifPointSimu", by.y = "Code10_BV", all.x = T) # Merge selon le code 10 les points de simu et les BV qui sont associes aux points SafranClimat
merge_GRSD_$Code10_BV <- merge_GRSD_$Code10_ChoixDefinitifPointSimu
length(which(is.na(merge_GRSD_$ControlMerge))) # 123

# Passer a 0 si le BV ne contient pas de point Safran Climat
length(which(sapply(merge_GRSD_$IndPointsSafranIntersect_, length) == 0)) # 23
merge_GRSD_$ControlMerge[which(sapply(merge_GRSD_$IndPointsSafranIntersect_, length) == 0)] = NA
length(which(is.na(merge_GRSD_$ControlMerge))) # 146
na_rows <- which(is.na(merge_GRSD_$ControlMerge)) # Points de simu sans correspondance de BV en Code10

second_merge <- merge(x = liste_ptsSimExp2_GRSD_[na_rows, ], y = bv_ptsSimuExp2_, by.x = "Code8_ChoixDefinitifPointSimu", by.y = "Code8_BV", all.x = TRUE, all.y = FALSE) # Merge selon le code 8 les points de simu et les BV qui sont associes aux points SafranClimat
second_merge$Code8_BV <- second_merge$Code8_ChoixDefinitifPointSimu

second_merge <- second_merge[,colnames(merge_GRSD_)]

# merge_GRSD_[na_rows,c("Code8_ChoixDefinitifPointSimu","Code8.y","S_km2","dt_pstn","geometry","IndPointsSafranIntersect_","ControlMerge")]
# second_merge[,c("Code8_ChoixDefinitifPointSimu","Code8_ChoixDefinitifPointSimu","S_km2","dt_pstn","geometry","IndPointsSafranIntersect_","ControlMerge")]

merge_FirstSecondMerge_ <- rbind(merge_GRSD_[which(merge_GRSD_$ControlMerge == 1), ],
                                 second_merge)
merge_FirstSecondMerge_$Code10_ChoixDefinitifPointSimu[which(is.na(merge_FirstSecondMerge_$ControlMerge))]
merge_FirstSecondMerge_$ControlMerge[which(is.na(merge_FirstSecondMerge_$ControlMerge))]

length(which(is.na(merge_FirstSecondMerge_$ControlMerge))) # 44
length(which(sapply(merge_FirstSecondMerge_$IndPointsSafranIntersect_, length) == 0)) # 2
merge_FirstSecondMerge_$ControlMerge[which(sapply(merge_FirstSecondMerge_$IndPointsSafranIntersect_, length) == 0)] = NA
merge_FirstSecondMerge_$IndPointsSafranIntersect_[which(sapply(merge_FirstSecondMerge_$IndPointsSafranIntersect_, length) == 0)] = NA
merge_FirstSecondMerge_$ControlMerge[which(is.na(merge_FirstSecondMerge_$ControlMerge))]

merge_FirstSecondMerge_[which(is.na(merge_FirstSecondMerge_$ControlMerge)),] # 46: Points de simu sans correspondance ni en Code 10, ni en Code 8

merge_FirstSecondMerge_[which(!is.na(merge_FirstSecondMerge_$ControlMerge)),"IndPointsSafranIntersect_"]
nbPointsSafran_ <- sapply(merge_FirstSecondMerge_[which(!is.na(merge_FirstSecondMerge_$ControlMerge)),"IndPointsSafranIntersect_"], length)
mean(nbPointsSafran_) # 5.738

# merge_troisiemeMerge_ <- merge_GRSD_[which(is.na(merge_FirstSecondMerge_$ControlMerge)),c("Code10_ChoixDefinitifPointSimu","XL93","YL93")]
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
            "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_31_ObservesReanalyseSafran_LienPointsSafranClimat/TablesParModele_20240816/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_GRSD_30_20240816.csv",
            sep = ";", dec = ".", row.names = F)
