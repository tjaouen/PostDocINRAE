library(readxl)
library(ncdf4)
library(rgdal)
library(sf)

### Convert Shp HER2 en Lambert 93 ###

chemin_fichier_entree <- "/home/tjaouen/Documents/Input/HER/HER2hybrides/Shapefile/HER2_hybrides.shp"
chemin_fichier_sortie <- "/home/tjaouen/Documents/Input/HER/HER2hybrides/Shapefile_Lambert93/HER2_hybrides_L93.shp"

# Charger le fichier shp en utilisant l'EPSG 4326
donnees <- st_read(chemin_fichier_entree, crs = 4326)

# Convertir les données vers l'EPSG 2154
donnees_lambert93 <- st_transform(donnees, crs = 2154)

# Écrire les données converties dans un nouveau fichier shp
st_write(donnees_lambert93, chemin_fichier_sortie)



library(readxl)
tab_HER2_ = read_excel("/home/tjaouen/Documents/Input/HER/HER2hybrides/DescriptionHER2hybrides_R_1_20230405.xlsx", sheet = 1)
tab_HER2_ <- tab_HER2_[which(!(tab_HER2_$CdHER2 %in% c(10,18,19,20))),]
tab_HER2_ <- tab_HER2_[,c("CdHER2","Area_km2")]
dim(tab_HER2_)

library(dplyr)

# Agrégation des aires par les CdHER2 spécifiés
votre_table_agregee <- tab_HER2_ %>%
  mutate(
    CdHER2_group = case_when(
      CdHER2 %in% c(89, 92) ~ "89092",
      CdHER2 %in% c(31, 33, 39) ~ "31033039",
      CdHER2 %in% c(69, 96) ~ "69096",
      CdHER2 %in% c(37, 54) ~ "37054",
      CdHER2 %in% c(49, 90) ~ "49090",
      CdHER2 %in% c(89, 92) ~ "89092",
      TRUE ~ as.character(CdHER2)
    )
  ) #%>%

votre_table_agregee <- votre_table_agregee %>%
  mutate(Area_km2 = as.numeric(Area_km2)) %>%  # Convertir la colonne en numérique
  group_by(CdHER2_group) %>%
  summarise(Total_Area_km2 = sum(Area_km2, na.rm = TRUE))

dim(votre_table_agregee) # 76

tab_res_ = read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_20231221/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-21000731/MatInputModel_CampOndeExcl_ByHERDates_2012_2022_Projections_Weight_merge.csv",
                      sep = ";", dec = ".", header = T)
length(unique(tab_res_$HER2)) # 76

# Affichage de la table agrégée
print(votre_table_agregee)

unique(tab_res_$HER2) %in% votre_table_agregee$CdHER2_group
votre_table_agregee$CdHER2_group[which(!votre_table_agregee$CdHER2_group %in% unique(tab_res_$HER2))]

median(votre_table_agregee$Total_Area_km2) # 4692.94
mean(votre_table_agregee$Total_Area_km2) # 7178.085
# plot(density(votre_table_agregee$Total_Area_km2))

votre_table_agregee[which(votre_table_agregee$Total_Area_km2 >10000),]
