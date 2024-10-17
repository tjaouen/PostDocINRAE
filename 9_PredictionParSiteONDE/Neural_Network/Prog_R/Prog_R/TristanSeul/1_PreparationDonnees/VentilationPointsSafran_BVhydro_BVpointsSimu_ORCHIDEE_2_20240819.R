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
# [1] "A152020100" "A404006000" "A600010000" "A261020100" "A321020000" "A810000100" "A312000101" "B517201001" "E237721001" "E237601001" "E364062000" "E403653200" "E490941100" "E520000000" "E510000000" "E638607001"
# [17] "F333000100" "F041000201" "F333000100" "F333000201" "F486000200" "G600061100" "F304000100" "F705000100" "H213060000" "H502301100" "F040040000" "F607060000" "H541203001" "H134000100" "E131000100" "F615000100"
# [33] "F705000100" "I146000100" "I652000101" "I722202002" "J070000100" "J060016000" "J120000000" "J132401100" "J060016000" "J361181000" "J240000000" "J351000000" "J262301100" "J272000000" "J301000000" "J302000000"
# [49] "J362401101" "J411000000" "J381471000" "J463000000" "J481030000" "J522401002" "J552401002" "J641000000" "J832000100" "J470000100" "J621301001" "M611000100" "K011403001" "K001872200" "K070451100" "K212030000"
# [65] "K222601001" "K256400000" "K272422001" "K275862100" "K235000100" "K322020000" "K551000100" "L610000100" "K323030000" "M003400000" "M103402500" "M043401300" "M026400000" "M061030000" "M111401501" "M121301200"
# [81] "M141000500" "K497000200" "M153451100" "M331301010" "M371181100" "M383401100" "M512431100" "M704401100" "N111400000" "N100015000" "N202401100" "N430521100" "O149431003" "V540402600" "O339040000" "O335431200"
# [97] "O333402101" "O631025000" "O714522100" "P502000100" "O938050000" "K265400000" "P174040000" "P174401100" "P137043000" "P301010000" "P151000100" "P242000100" "P533000100" "P708000100" "Q245029000" "R114040000"
# [113] "R201501100" "R233050000" "S011451001" "O968531100" "U107052000" "U132903100" "U132903100" "U200201100" "U221521100" "U222054000" "U203502003" "U263050000" "U141502001" "U200201100" "U347000300" "U440502200"
# [129] "U450601100" "V031040000" "V041050000" "W040040000" "V144621100" "V125841200" "V144621100" "V144621100" "V151050000" "V144621100" "V161040000" "V101582200" "U440502200" "V302511002" "V373000100" "V427591100"
# [145] "X104000100" "W333521100" "X102050000" "X140000200" "Y042401100" "Y062522200" "Y046600600" "Y084000000" "Y224040000" "Y545000000" "Y760000100" "Y800000000"
merge_ORCHIDEE_ <- merge(liste_ptsSimExp2_ORCHIDEE_, bv_ptsSimuExp2_, by.x = "Code10_ChoixDefinitifPointSimu", by.y = "Code10_BV", all.x = T) # Merge selon le code 10 les points de simu et les BV qui sont associes aux points SafranClimat
merge_ORCHIDEE_$Code10_BV <- merge_ORCHIDEE_$Code10_ChoixDefinitifPointSimu
length(which(is.na(merge_ORCHIDEE_$ControlMerge))) # 156

# Passer a 0 si le BV ne contient pas de point Safran Climat
length(which(sapply(merge_ORCHIDEE_$IndPointsSafranIntersect_, length) == 0)) # 25
merge_ORCHIDEE_$ControlMerge[which(sapply(merge_ORCHIDEE_$IndPointsSafranIntersect_, length) == 0)] = NA
length(which(is.na(merge_ORCHIDEE_$ControlMerge))) # 181
na_rows <- which(is.na(merge_ORCHIDEE_$ControlMerge)) # Points de simu sans correspondance de BV en Code10

second_merge <- merge(x = liste_ptsSimExp2_ORCHIDEE_[na_rows, ], y = bv_ptsSimuExp2_, by.x = "Code8_ChoixDefinitifPointSimu", by.y = "Code8_BV", all.x = TRUE, all.y = FALSE) # Merge selon le code 8 les points de simu et les BV qui sont associes aux points SafranClimat
second_merge$Code8_BV <- second_merge$Code8_ChoixDefinitifPointSimu

second_merge <- second_merge[,colnames(merge_ORCHIDEE_)]

# merge_ORCHIDEE_[na_rows,c("Code8_ChoixDefinitifPointSimu","Code8.y","S_km2","dt_pstn","geometry","IndPointsSafranIntersect_","ControlMerge")]
# second_merge[,c("Code8_ChoixDefinitifPointSimu","Code8_ChoixDefinitifPointSimu","S_km2","dt_pstn","geometry","IndPointsSafranIntersect_","ControlMerge")]

merge_FirstSecondMerge_ <- rbind(merge_ORCHIDEE_[which(merge_ORCHIDEE_$ControlMerge == 1), ],
                                 second_merge)
merge_FirstSecondMerge_$Code10_ChoixDefinitifPointSimu[which(is.na(merge_FirstSecondMerge_$ControlMerge))]
merge_FirstSecondMerge_$ControlMerge[which(is.na(merge_FirstSecondMerge_$ControlMerge))]

length(which(is.na(merge_FirstSecondMerge_$ControlMerge))) # 58
length(which(sapply(merge_FirstSecondMerge_$IndPointsSafranIntersect_, length) == 0)) # 7
merge_FirstSecondMerge_$ControlMerge[which(sapply(merge_FirstSecondMerge_$IndPointsSafranIntersect_, length) == 0)] = NA
merge_FirstSecondMerge_$IndPointsSafranIntersect_[which(sapply(merge_FirstSecondMerge_$IndPointsSafranIntersect_, length) == 0)] = NA
merge_FirstSecondMerge_$ControlMerge[which(is.na(merge_FirstSecondMerge_$ControlMerge))]

merge_FirstSecondMerge_[which(is.na(merge_FirstSecondMerge_$ControlMerge)),] # 65 : Points de simu sans correspondance ni en Code 10, ni en Code 8

merge_FirstSecondMerge_[which(!is.na(merge_FirstSecondMerge_$ControlMerge)),"IndPointsSafranIntersect_"]
nbPointsSafran_ <- sapply(merge_FirstSecondMerge_[which(!is.na(merge_FirstSecondMerge_$ControlMerge)),"IndPointsSafranIntersect_"], length)
mean(nbPointsSafran_) # 6.196

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
