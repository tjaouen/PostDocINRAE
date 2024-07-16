library(readxl)



tab_CTRIP <- read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/TablesParModele_20231203/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_CTRIP_30_20231221.csv",
                        sep = ";", dec = ".", header = T)
tab_GRSD <- read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/TablesParModele_20231203/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_GRSD_30_20231203.csv",
                        sep = ";", dec = ".", header = T)
tab_J2000 <- read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/TablesParModele_20231203/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_J2000_32_20231204.csv",
                        sep = ";", dec = ".", header = T)
tab_ORCHIDEE <- read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/TablesParModele_20231203/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_ORCHIDEE_30_20231203.csv",
                        sep = ";", dec = ".", header = T)
tab_SMASH <- read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/TablesParModele_20231203/StationsHYDROPointsSimu_CorrDistExp2enKm_RattachNomParDefaut_PostCorrectionNetcdf_InterBVpSimExp2_Algo1008_RapprochementDoublons_PropHER2h_SMASH_30_20231203.csv",
                        sep = ";", dec = ".", header = T)

median(c(tab_CTRIP$SurfaceTopo_ChoixDefinitifPointSimu,
       tab_GRSD$SurfaceTopo_ChoixDefinitifPointSimu,
       tab_J2000$SurfaceTopo_ChoixDefinitifPointSimu,
       tab_ORCHIDEE$SurfaceTopo_ChoixDefinitifPointSimu,
       tab_SMASH$SurfaceTopo_ChoixDefinitifPointSimu))
quantile(c(tab_CTRIP$SurfaceTopo_ChoixDefinitifPointSimu,
         tab_GRSD$SurfaceTopo_ChoixDefinitifPointSimu,
         tab_J2000$SurfaceTopo_ChoixDefinitifPointSimu,
         tab_ORCHIDEE$SurfaceTopo_ChoixDefinitifPointSimu,
         tab_SMASH$SurfaceTopo_ChoixDefinitifPointSimu), probs = 0.25)
quantile(c(tab_CTRIP$SurfaceTopo_ChoixDefinitifPointSimu,
         tab_GRSD$SurfaceTopo_ChoixDefinitifPointSimu,
         tab_J2000$SurfaceTopo_ChoixDefinitifPointSimu,
         tab_ORCHIDEE$SurfaceTopo_ChoixDefinitifPointSimu,
         tab_SMASH$SurfaceTopo_ChoixDefinitifPointSimu), probs = 0.75)

median(na.omit(c(tab_CTRIP$Altitude,
         tab_GRSD$Altitude,
         tab_J2000$Altitude,
         tab_ORCHIDEE$Altitude,
         tab_SMASH$Altitude)))
quantile(na.omit(c(tab_CTRIP$Altitude,
           tab_GRSD$Altitude,
           tab_J2000$Altitude,
           tab_ORCHIDEE$Altitude,
           tab_SMASH$Altitude)), probs = 0.25)
quantile(na.omit(c(tab_CTRIP$Altitude,
           tab_GRSD$Altitude,
           tab_J2000$Altitude,
           tab_ORCHIDEE$Altitude,
           tab_SMASH$Altitude)), probs = 0.75)

length(which(is.na(tab_CTRIP$Altitude)))
length(which(is.na(tab_GRSD$Altitude)))
length(which(is.na(tab_J2000$Altitude)))
length(which(is.na(tab_ORCHIDEE$Altitude)))
length(which(is.na(tab_SMASH$Altitude)))










HER_eliminees_J2000 <- c("10", "21", "22", "24", "27", "34", "35", "36", "57", "59", "61", "65", "67", "68",
                         "77", "78", "93", "94", "103", "108", "118", "0", "31033039", "69096",
                         "66", "64", "117", "112", "56", "62", "38", "40", "105", "17", "25", "107",
                         "55", "12", "53")

# titre_tab_ = "CTRIP"
# titre_tab_ = "GRSD"
# titre_tab_ = "J2000"
# titre_tab_ = "ORCHIDEE"
titre_tab_ = "SMASH"
tab_stations_ = read.csv(list.files("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/TablesParModele_20231203/", pattern = titre_tab_, full.names = T), dec = ".", na.strings = NA, header = T)
if (ncol(tab_stations_) == 1){
  tab_stations_ = read.csv(list.files("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_49et90_20231221/TablesParModele_20231203/", pattern = titre_tab_, full.names = T), sep = ";", dec = ".", na.strings = NA, header = T)
}
dim(tab_stations_) #1008 194
tab_stations_[which(is.na(tab_stations_$SurfaceTopo)),]
tab_stations_ = tab_stations_[which(tab_stations_$SurfaceTopo < 2000),]
dim(tab_stations_) #1008 194
tab_graph_ <- tab_stations_

### Calcul de la surface par HER sachant les stations conservees ###
tab_graph_TransfoPropToSurfAbsolues <- tab_graph_[,grep(pattern = "eco0|eco1|eco3|eco4|eco6|eco8", colnames(tab_graph_))]
tab_graph_TransfoPropToSurfAbsolues <- tab_graph_$SurfaceTopo_ChoixDefinitifPointSimu * tab_graph_TransfoPropToSurfAbsolues
which(!(round(rowSums(tab_graph_TransfoPropToSurfAbsolues)) == round(tab_graph_$SurfaceTopo))) #664 : 696 et 697, OK
tab_graph_[,grep(pattern = "eco0|eco1|eco3|eco4|eco6|eco8", colnames(tab_graph_))] <- tab_graph_TransfoPropToSurfAbsolues
dispo_hydroOff_ = tab_graph_

# # Croisement HER 2
dispo_hydroOff_her2_ <- dispo_hydroOff_[,grep(pattern = "eco0|eco1|eco3|eco4|eco6|eco8", colnames(dispo_hydroOff_))]

### Caracteristiques HER 2 hybrides - Utilisation de l'aire des HER 2 ###
file_HER2off_desc_ = "/home/tjaouen/Documents/Input/HER/HER2hybrides/DescriptionHER2hybrides_R_1_20230405.xlsx"
tab_HER2off_desc_ = read_excel(file_HER2off_desc_)
tab_HER2off_desc_$Area_km2 = as.numeric(tab_HER2off_desc_$Area_km2)

# tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == )]
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 37)] = "37+54"
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 54)] = "37+54"
tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "37+54")] = sum(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "37+54")])

tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 69)] = "69+96"
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 96)] = "69+96"
tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "69+96")] = sum(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "69+96")])

tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 31)] = "31+33+39"
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 33)] = "31+33+39"
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 39)] = "31+33+39"
tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "31+33+39")] = sum(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "31+33+39")])

tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 49)] = "49+90"
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 90)] = "49+90"
tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "49+90")] = sum(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "49+90")])

tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 89)] = "89+92"
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 92)] = "89+92"
tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "89+92")] = sum(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "89+92")])

tab_sum_ = data.frame(AreaHydro = colSums(dispo_hydroOff_her2_))
tab_sum_bin_ = data.frame(NbStationsHydro = colSums(dispo_hydroOff_her2_>0))
rownames(tab_sum_) <- as.numeric(gsub("eco", "", rownames(tab_sum_bin_)))
rownames(tab_sum_bin_) <- as.numeric(gsub("eco", "", rownames(tab_sum_bin_)))

tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("31","33","39"))] = sum(tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("31","33","39"))])
tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("31","33","39"))] = sum(tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("31","33","39"))])
tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("37","54"))] = sum(tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("37","54"))])
tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("37","54"))] = sum(tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("37","54"))])
tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("69","96"))] = sum(tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("69","96"))])
tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("69","96"))] = sum(tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("69","96"))])
tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("49","90"))] = sum(tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("69","96"))])
tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("49","90"))] = sum(tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("69","96"))])
tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("89","92"))] = sum(tab_sum_$AreaHydro[which(rownames(tab_sum_) %in% c("69","96"))])
tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("89","92"))] = sum(tab_sum_bin_$NbStationsHydro[which(rownames(tab_sum_) %in% c("69","96"))])
tab_sum_$HER2 = rownames(tab_sum_)
tab_sum_bin_$HER2 = rownames(tab_sum_bin_)

tab_sum_ = tab_sum_[which(!(rownames(tab_sum_) %in% c("33","39","54","96"))),]
tab_sum_bin_ = tab_sum_bin_[which(!(rownames(tab_sum_bin_) %in% c("33","39","54","96"))),]

rownames(tab_sum_)[which(rownames(tab_sum_) %in% c("31033039"))] = "31+33+39"
rownames(tab_sum_)[which(rownames(tab_sum_) %in% c("37054"))] = "37+54"
rownames(tab_sum_)[which(rownames(tab_sum_) %in% c("69096"))] = "69+96"
rownames(tab_sum_)[which(rownames(tab_sum_) %in% c("49090"))] = "49+90"
rownames(tab_sum_)[which(rownames(tab_sum_) %in% c("89092"))] = "89+92"
tab_sum_$HER2 = rownames(tab_sum_)

rownames(tab_sum_bin_)[which(rownames(tab_sum_bin_) %in% c("31033039"))] = "31+33+39"
rownames(tab_sum_bin_)[which(rownames(tab_sum_bin_) %in% c("37054"))] = "37+54"
rownames(tab_sum_bin_)[which(rownames(tab_sum_bin_) %in% c("69096"))] = "69+96"
rownames(tab_sum_bin_)[which(rownames(tab_sum_bin_) %in% c("49090"))] = "49+90"
rownames(tab_sum_bin_)[which(rownames(tab_sum_bin_) %in% c("89092"))] = "89+92"
tab_sum_bin_$HER2 = rownames(tab_sum_bin_)

tab_sum_$SurfaceHER2 = NA
tab_sum_$SurfaceHydroPropSurfHER2 = NA
tab_sum_bin_$SurfaceHER2 = NA
tab_sum_bin_$SurfaceHydroPropSurfHER2_bin = NA
tab_sum_bin_$SurfaceDivNbHydro_bin = NA

for (i in 1:dim(tab_sum_)[1]){
  if (length(which(tab_HER2off_desc_$CdHER2 == rownames(tab_sum_)[i])) > 0){
    tab_sum_$SurfaceHER2[i] = tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == tab_sum_$HER2[i])]
    tab_sum_$SurfaceHydroPropSurfHER2[i] = ifelse(tab_sum_$AreaHydro[i]==0,NA,unique(tab_sum_$AreaHydro[i]/tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == tab_sum_$HER2[i])])) # Surface topographique des stations hydro de l'HER 2 hybrides / Surface de l'HER 2 hybrides 
    
    tab_sum_bin_$SurfaceHER2[i] = tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == tab_sum_$HER2[i])]
    tab_sum_bin_$SurfaceHydroPropSurfHER2_bin[i] = ifelse(tab_sum_bin_$NbStationsHydro[i]==0,NA,unique(tab_sum_bin_$NbStationsHydro[i]/tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == tab_sum_bin_$HER2[i])])*1000) # Nombre de stations par km2 de l'HER 2 hybride
    tab_sum_bin_$SurfaceDivNbHydro_bin[i] = unique(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == tab_sum_bin_$HER2[i])]/ifelse(tab_sum_bin_$NbStationsHydro[i] == 0,NA,tab_sum_bin_$NbStationsHydro[i])) # Surface de l'HER couverte par une station Hydro
  }
}

tab_sum_$SurfaceHydroPropSurfHER2_log <- log(tab_sum_$SurfaceHydroPropSurfHER2)

tab_compil_sum_sumbin_ <- merge(tab_sum_bin_, tab_sum_, by = "HER2")
tab_compil_sum_sumbin_ <- tab_compil_sum_sumbin_[order(as.numeric(tab_compil_sum_sumbin_$HER2)),]

if (titre_tab_ == "J2000"){
  tab_sum_ <- tab_sum_[which(!(tab_sum_$HER2 %in% HER_eliminees_J2000)),]
  tab_sum_bin_ <- tab_sum_bin_[which(!(tab_sum_bin_$HER2 %in% HER_eliminees_J2000)),]
}

# tab_sum_CTRIP_ <- tab_sum_
# tab_sum_GRSD_ <- tab_sum_
# tab_sum_J2000_ <- tab_sum_
# tab_sum_ORCHIDEE_ <- tab_sum_
# tab_sum_SMASH_ <- tab_sum_

# tab_sum_bin_CTRIP_ <- tab_sum_bin_
# tab_sum_bin_GRSD_ <- tab_sum_bin_
# tab_sum_bin_J2000_ <- tab_sum_bin_
# tab_sum_bin_ORCHIDEE_ <- tab_sum_bin_
tab_sum_bin_SMASH_ <- tab_sum_bin_


# median(c(na.omit(tab_sum_CTRIP_$SurfaceHydroPropSurfHER2),
#   na.omit(tab_sum_GRSD_$SurfaceHydroPropSurfHER2),
#   na.omit(tab_sum_J2000_$SurfaceHydroPropSurfHER2),
#   na.omit(tab_sum_ORCHIDEE_$SurfaceHydroPropSurfHER2),
#   na.omit(tab_sum_SMASH_$SurfaceHydroPropSurfHER2)))
# quantile(c(na.omit(tab_sum_CTRIP_$SurfaceHydroPropSurfHER2),
#          na.omit(tab_sum_GRSD_$SurfaceHydroPropSurfHER2),
#          na.omit(tab_sum_J2000_$SurfaceHydroPropSurfHER2),
#          na.omit(tab_sum_ORCHIDEE_$SurfaceHydroPropSurfHER2),
#          na.omit(tab_sum_SMASH_$SurfaceHydroPropSurfHER2)), probs = 0.25)
# quantile(c(na.omit(tab_sum_CTRIP_$SurfaceHydroPropSurfHER2),
#          na.omit(tab_sum_GRSD_$SurfaceHydroPropSurfHER2),
#          na.omit(tab_sum_J2000_$SurfaceHydroPropSurfHER2),
#          na.omit(tab_sum_ORCHIDEE_$SurfaceHydroPropSurfHER2),
#          na.omit(tab_sum_SMASH_$SurfaceHydroPropSurfHER2)), probs = 0.75)


median(c(na.omit(tab_sum_bin_CTRIP_$SurfaceHydroPropSurfHER2),
         na.omit(tab_sum_bin_GRSD_$SurfaceHydroPropSurfHER2),
         na.omit(tab_sum_bin_J2000_$SurfaceHydroPropSurfHER2),
         na.omit(tab_sum_bin_ORCHIDEE_$SurfaceHydroPropSurfHER2),
         na.omit(tab_sum_bin_SMASH_$SurfaceHydroPropSurfHER2)))
quantile(c(na.omit(tab_sum_bin_CTRIP_$SurfaceHydroPropSurfHER2),
           na.omit(tab_sum_bin_GRSD_$SurfaceHydroPropSurfHER2),
           na.omit(tab_sum_bin_J2000_$SurfaceHydroPropSurfHER2),
           na.omit(tab_sum_bin_ORCHIDEE_$SurfaceHydroPropSurfHER2),
           na.omit(tab_sum_bin_SMASH_$SurfaceHydroPropSurfHER2)), probs = 0.25)
quantile(c(na.omit(tab_sum_bin_CTRIP_$SurfaceHydroPropSurfHER2),
           na.omit(tab_sum_bin_GRSD_$SurfaceHydroPropSurfHER2),
           na.omit(tab_sum_bin_J2000_$SurfaceHydroPropSurfHER2),
           na.omit(tab_sum_bin_ORCHIDEE_$SurfaceHydroPropSurfHER2),
           na.omit(tab_sum_bin_SMASH_$SurfaceHydroPropSurfHER2)), probs = 0.75)



