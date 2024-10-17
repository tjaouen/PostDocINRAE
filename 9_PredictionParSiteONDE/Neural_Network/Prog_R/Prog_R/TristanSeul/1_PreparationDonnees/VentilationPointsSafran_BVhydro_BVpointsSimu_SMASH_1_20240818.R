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
liste_ptsSimExp2_SMASH_ <- read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/TablesParModele_20231203/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_SMASH_30_20231203.csv",
                                         sep = ";", dec = ".", header = T)
liste_ptsSimExp2_SMASH_$Code8_ChoixDefinitifPointSimu <- substr(liste_ptsSimExp2_SMASH_$Code10_ChoixDefinitifPointSimu, 1, 8)
# liste_ptsSimExp2_SMASH_sf_ <- st_as_sf(liste_ptsSimExp2_SMASH_, coords = c("XL93","YL93"), crs = 2154)

### Safran ###
colnames(bv_ptsSimuExp2_)[which(colnames(bv_ptsSimuExp2_) == "Code10")] <- "Code10_BV"
colnames(bv_ptsSimuExp2_)[which(colnames(bv_ptsSimuExp2_) == "Code8")] <- "Code8_BV"
bv_ptsSimuExp2_$ControlMerge <- 1 # Controle que les points aient recu des points Safran Climat
liste_ptsSimExp2_SMASH_$Code10_ChoixDefinitifPointSimu[which(!(liste_ptsSimExp2_SMASH_$Code10_ChoixDefinitifPointSimu %in% bv_ptsSimuExp2_$Code10))]
# [1] "A152020100" "A111020000" "A404006000" "A600010000" "A810000100" "B517201001" "E237721001" "E237601001" "E364062000" "E490941100" "E403653200" "E638607001" "F333000100" "F041000201" "U303601100" "F333000201"
# [17] "F486000200" "G600061100" "F304000100" "F705000100" "H213060000" "H502301100" "F607060000" "H541203001" "H134000100" "E131000100" "F615000100" "F705000100" "I652000101" "J070000100" "J060016000" "J170017000"
# [33] "J470000100" "J522401002" "J381471000" "J311000000" "J310600000" "J351000000" "J362401101" "J394000000" "J411000000" "J463000000" "J471201002" "J470000100" "J470000100" "J641000000" "J552400000" "J470000100"
# [49] "J621301001" "M611000100" "J561832200" "K001872200" "V353000200" "V353000200" "K070451100" "V540402600" "K222601001" "K256400000" "K273400000" "K277312001" "K439030000" "M023400100" "M103402500" "M043401300"
# [65] "M061030000" "M153451100" "M331301010" "M621401100" "M704401100" "N111400000" "N202401100" "N420401100" "O149431003" "O335431200" "O335431100" "O631025000" "O714522100" "P502000100" "K265400000" "P301010000"
# [81] "P151000100" "P134040000" "P242000100" "P708000100" "Q245029000" "R114040000" "R233050000" "S011451001" "O968531100" "S226000100" "U107052000" "U132903100" "U132903100" "U200201100" "U222054000" "U234641400"
# [97] "U234641400" "U261582001" "U263050000" "U200201100" "U440502200" "U450601100" "V031040000" "V041050000" "V125841200" "W040040000" "V144621100" "V144621100" "W110050000" "U200201100" "U440502200" "V403402200"
# [113] "W333521100" "X102050000" "X140000200" "Y062522200" "Y024401001" "Y046600600" "Y081400200" "Y154000100" "X311000100" "Y420000300" "Y545000000" "Y760000100" "Y970000100"
merge_SMASH_ <- merge(liste_ptsSimExp2_SMASH_, bv_ptsSimuExp2_, by.x = "Code10_ChoixDefinitifPointSimu", by.y = "Code10_BV", all.x = T) # Merge selon le code 10 les points de simu et les BV qui sont associes aux points SafranClimat
merge_SMASH_$Code10_BV <- merge_SMASH_$Code10_ChoixDefinitifPointSimu
length(which(is.na(merge_SMASH_$ControlMerge))) # 125
na_rows <- which(is.na(merge_SMASH_$ControlMerge)) # Points de simu sans correspondance de BV en Code10

second_merge <- merge(x = liste_ptsSimExp2_SMASH_[na_rows, ], y = bv_ptsSimuExp2_, by.x = "Code8_ChoixDefinitifPointSimu", by.y = "Code8_BV", all.x = TRUE, all.y = FALSE) # Merge selon le code 8 les points de simu et les BV qui sont associes aux points SafranClimat
second_merge$Code8_BV <- second_merge$Code8_ChoixDefinitifPointSimu

second_merge <- second_merge[,colnames(merge_SMASH_)]
length(which(second_merge$ControlMerge == 1)) # 90

# merge_SMASH_[na_rows,c("Code8_ChoixDefinitifPointSimu","Code8.y","S_km2","dt_pstn","geometry","IndPointsSafranIntersect_","ControlMerge")]
# second_merge[,c("Code8_ChoixDefinitifPointSimu","Code8_ChoixDefinitifPointSimu","S_km2","dt_pstn","geometry","IndPointsSafranIntersect_","ControlMerge")]

merge_FirstSecondMerge_ <- rbind(merge_SMASH_[which(merge_SMASH_$ControlMerge == 1), ],
                                 second_merge)
merge_FirstSecondMerge_$Code10_ChoixDefinitifPointSimu[which(is.na(merge_FirstSecondMerge_$ControlMerge))]

merge_FirstSecondMerge_[which(is.na(merge_FirstSecondMerge_$ControlMerge)),] # Points de simu sans correspondance ni en Code 10, ni en Code 8
# 35 points

merge_FirstSecondMerge_[which(!is.na(merge_FirstSecondMerge_$ControlMerge)),"IndPointsSafranIntersect_"]
nbPointsSafran_ <- sapply(merge_FirstSecondMerge_[which(!is.na(merge_FirstSecondMerge_$ControlMerge)),"IndPointsSafranIntersect_"], length)
mean(nbPointsSafran_) # 5.73

# merge_troisiemeMerge_ <- merge_SMASH_[which(is.na(merge_FirstSecondMerge_$ControlMerge)),c("Code10_ChoixDefinitifPointSimu","XL93","YL93")]
merge_troisiemeMerge_ <- merge_FirstSecondMerge_[which(is.na(merge_FirstSecondMerge_$ControlMerge)),]
merge_troisiemeMerge_ <- st_as_sf(merge_troisiemeMerge_, coords = c("XL93","YL93"), crs = 2154)

### Selection des 5 points les plus proches ###
for (i in 1:nrow(merge_troisiemeMerge_)){
  pts_SafranClimat_sf_$Distance <- st_distance(pts_SafranClimat_sf_, merge_troisiemeMerge_$geometry[i])
  merge_troisiemeMerge_$IndPointsSafranIntersect_[i] <- list(pts_SafranClimat_sf_$cell[order(pts_SafranClimat_sf_$Distance)][1:6])
}

merge_troisiemeMerge_$IndPointsSafranIntersect_ <- sapply(merge_troisiemeMerge_$IndPointsSafranIntersect_, concat_elements)
merge_FirstSecondMerge_[which(is.na(merge_FirstSecondMerge_$ControlMerge)),"IndPointsSafranIntersect_"] <- merge_troisiemeMerge_$IndPointsSafranIntersect_
merge_FirstSecondMerge_[which(is.na(merge_FirstSecondMerge_$ControlMerge)),"ControlMerge"] <- merge_troisiemeMerge_$ControlMerge

# merge_FirstSecondMerge_export_ <- merge_FirstSecondMerge_export_ %>% select(-geometry)
concatenated_list <- sapply(merge_FirstSecondMerge_export_$IndPointsSafranIntersect_, concat_elements)
merge_FirstSecondMerge_export_$IndPointsSafranIntersect_ <- concatenated_list


write.table(merge_FirstSecondMerge_export_,
            "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_31_ObservesReanalyseSafran_LienPointsSafranClimat/TablesParModele_20240816/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_SMASH_30_20240816.csv",
            sep = ";", dec = ".", row.names = F)

