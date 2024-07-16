# Charger les bibliothèques
library(sf)
library(dplyr)
library(tidyr)

# Charger les fichiers shapefile
# bassins_versants <- st_read("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DescriptionPointsSimulation/entiteHydro/BassinsVersants_Concatenes_20231129/BV_concatenes_4210pointsSimulationExp2_20231129.shp")
bassins_versants <- st_read("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DescriptionPointsSimulation/entiteHydro/BassinsVersants_Concatenes_20231129/BV_concatenes_4210pointsSimulationExp2_20231130.shp")
hydroecoregions <- st_read("/home/tjaouen/Documents/Input/HER/HER2hybrides/Shapefile_Lambert93/HER2_hybrides_L93.shp")

# Vérifier la projection des fichiers
st_crs(bassins_versants)
st_crs(hydroecoregions)

# Assurer la même projection pour les deux fichiers si ce n'est pas le cas
# Si les projections sont différentes, utilisez st_transform() pour les mettre dans la même projection

# Calculer les intersections entre les deux fichiers
intersections <- st_intersection(bassins_versants, hydroecoregions)

# Calculer les surfaces des intersections
intersections$area_intersection <- st_area(intersections)

# Regroupement des données pour obtenir la somme des surfaces d'intersection par bassin et par HER2
resultat <- intersections %>%
  group_by(Code8, Code10, CdHER2) %>%
  summarise(surface_intersection = sum(area_intersection)) %>%
  ungroup()

# Utilisation de la fonction spread() pour obtenir le tableau à double entrée
tableau_double_entree <- resultat %>%
  spread(key = CdHER2, value = surface_intersection, fill = 0)

# Exclude geometry parameters
tableau_sans_geometry <- st_drop_geometry(tableau_double_entree)


### Ajout de la partie exterieure aux HER2h
# Calculer l'union de tous les polygones HER2_hybrides_L93.shp pour obtenir une géométrie unique
union_hydroecoregions <- hydroecoregions %>%
  st_union()

# Identifier les parties des bassins versants à l'extérieur de cette zone
exterieur_hydroecoregions <- st_difference(bassins_versants, union_hydroecoregions)
surface_exterieure <- st_area(exterieur_hydroecoregions)
surf_out_ = data.frame(Code8 = exterieur_hydroecoregions$Code8,
                       '0' = surface_exterieure)

matching_indices <- match(tableau_sans_geometry$Code8, surf_out_$Code8)
tableau_sans_geometry$'0' <- ifelse(!is.na(matching_indices), surf_out_$X0[matching_indices], 0)


# Regrouper les lignes par CdHER2 et effectuer une somme par colonne
tableau_sans_geometry_grouped <- tableau_sans_geometry %>%
  group_by(Code8,Code10) %>%
  summarise(across(everything(), sum))

# Changer nom colonnes
noms_colonnes_nouveaux <- colnames(tableau_sans_geometry_grouped)[-c(1,2)] %>%
  as.numeric() %>%
  sprintf("eco%03d", .)
colnames(tableau_sans_geometry_grouped)[-c(1,2)] <- noms_colonnes_nouveaux

# Bassins versants manquants (situes uniquement a exterieur et donc non pris en compte dans la premiere intersection, non ramenes par le merge)
dim(tableau_sans_geometry_grouped) # 4209
tableau_sans_geometry_grouped <- data.frame(tableau_sans_geometry_grouped)

setdiff(bassins_versants$Code8, tableau_sans_geometry_grouped$Code8) # Un bassin versant present dans le shp n'est pas present dans le tableau final : Y4537010 -> Il est situe dans la mediterranee et n'a d'intersection avec aucun HER2h.
setdiff(tableau_sans_geometry_grouped$Code8,bassins_versants$Code8) # NA

nouvelle_ligne <- as.data.frame(matrix(0, ncol = ncol(tableau_sans_geometry_grouped)))
colnames(nouvelle_ligne) <- colnames(tableau_sans_geometry_grouped)
nouvelle_ligne$Code8 = "Y4537010"
nouvelle_ligne$Code10 = NA

tableau_sans_geometry_grouped <- rbind(tableau_sans_geometry_grouped, nouvelle_ligne)
tableau_sans_geometry_grouped$eco000[which(tableau_sans_geometry_grouped$Code8 == "Y4537010")] <- surf_out_$X0[which(surf_out_$Code8 == "Y4537010")]
dim(tableau_sans_geometry_grouped) # 4210

# Convertir en km2
tableau_sans_geometry_grouped_km2 <- tableau_sans_geometry_grouped
tableau_sans_geometry_grouped_km2[,!(grepl("Code8|Code10",colnames(tableau_sans_geometry_grouped_km2)))] <- tableau_sans_geometry_grouped_km2[,!(grepl("Code8|Code10",colnames(tableau_sans_geometry_grouped_km2)))] /1000000

# Exporter le tableau à double entrée (sans la colonne "geometry") en fichier CSV
write.table(tableau_sans_geometry_grouped_km2,
            # "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/CorrespondanceHydroHer/HER2hybrides_PointsSimulationExplore2/Version_HER2h20190607_1_TJ20231130/PropSurfaceHER2hybrides_HorsRMCfromShp_TabDoubleEntree_2_20231130.csv",
            # "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/CorrespondanceHydroHer/HER2hybrides_PointsSimulationExplore2/Version_HER2h20190607_1_TJ20231130/PropSurfaceHER2hybrides_HorsRMCfromShp_TabDoubleEntree_4_20231130.csv",
            "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/CorrespondanceHydroHer/HER2hybrides_PointsSimulationExplore2/Version_HER2h20190607_1_TJ20231130/PropSurfaceHER2hybrides_HorsRMCfromShp_AvecExterieur_TabDoubleEntree_5_20231201.csv",
            sep = ";", dec = ".", row.names = FALSE)


### Pour eviter le debut de l'algo ###
# tableau_sans_geometry_grouped_km2 <- read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/CorrespondanceHydroHer/HER2hybrides_PointsSimulationExplore2/Version_HER2h20190607_1_TJ20231130/PropSurfaceHER2hybrides_HorsRMCfromShp_TabDoubleEntree_2_20231130.csv",
# tableau_sans_geometry_grouped_km2 <- read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/CorrespondanceHydroHer/HER2hybrides_PointsSimulationExplore2/Version_HER2h20190607_1_TJ20231130/PropSurfaceHER2hybrides_HorsRMCfromShp_TabDoubleEntree_4_20231130.csv",
#                                                 sep = ";", dec = ".", header = T)

# Calculer les totaux par ligne
totals_per_row <- rowSums(tableau_sans_geometry_grouped_km2[, -c(1,2)]) # Exclure les colonnes 'Code8', 'Code10'

# Convertir les valeurs en pourcentages par ligne
# tableau_pourcentages <- tableau_sans_geometry_grouped_km2 %>%
#   mutate(across(-Code, function(x) 100 * x / totals_per_row))
tableau_pourcentages <- tableau_sans_geometry_grouped_km2
tableau_pourcentages[,!(grepl("Code8|Code10",colnames(tableau_sans_geometry_grouped_km2)))] <- tableau_sans_geometry_grouped_km2[,!(grepl("Code8|Code10",colnames(tableau_sans_geometry_grouped_km2)))] / matrix(totals_per_row, ncol = 1)

write.table(tableau_pourcentages,
            "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/CorrespondanceHydroHer/HER2hybrides_PointsSimulationExplore2/Version_HER2h20190607_1_TJ20231130/PropSurfaceHER2hybrides_HorsRMCfromShp_AvecExterieur_TabDoubleEntree_Proportions_5_20231201.csv",
            sep = ";", dec = ".", row.names = FALSE)
# write.table(tableau_pourcentages,
#             "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/CorrespondanceHydroHer/HER2hybrides_PointsSimulationExplore2/Version_HER2h20190607_1_TJ20231130/PropSurfaceHER2hybrides_HorsRMCfromShp_TabDoubleEntree_Proportions_3_20231130.csv",
#             sep = ";", dec = ".", row.names = FALSE)


### Jonction des HER2 ###
tableau_sans_geometry_grouped_km2$eco31033039 <- tableau_sans_geometry_grouped_km2$eco031 + tableau_sans_geometry_grouped_km2$eco033 + tableau_sans_geometry_grouped_km2$eco039
tableau_sans_geometry_grouped_km2$eco37054 <- tableau_sans_geometry_grouped_km2$eco037 + tableau_sans_geometry_grouped_km2$eco054
tableau_sans_geometry_grouped_km2$eco69096 <- tableau_sans_geometry_grouped_km2$eco069 + tableau_sans_geometry_grouped_km2$eco096
tableau_sans_geometry_grouped_km2 <- tableau_sans_geometry_grouped_km2[, !names(tableau_sans_geometry_grouped_km2) %in% c("eco031", "eco033", "eco039", "eco037", "eco054", "eco069", "eco096")]

write.table(tableau_sans_geometry_grouped_km2,
            "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/CorrespondanceHydroHer/HER2hybrides_PointsSimulationExplore2/Version_HER2h20190607_1_TJ20231130/PropSurfaceHER2hybrides_HorsRMCfromShp_AvecExterieur_TabDoubleEntree_JonctionHER2h_4_20231201.csv",
            sep = ";", dec = ".", row.names = FALSE)
# write.table(tableau_sans_geometry_grouped_km2,
#             "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/CorrespondanceHydroHer/HER2hybrides_PointsSimulationExplore2/Version_HER2h20190607_1_TJ20231130/PropSurfaceHER2hybrides_HorsRMCfromShp_TabDoubleEntree_JonctionHER2h_4_20231130.csv",
#             sep = ";", dec = ".", row.names = FALSE)


tableau_pourcentages$eco31033039 <- tableau_pourcentages$eco031 + tableau_pourcentages$eco033 + tableau_pourcentages$eco039
tableau_pourcentages$eco37054 <- tableau_pourcentages$eco037 + tableau_pourcentages$eco054
tableau_pourcentages$eco69096 <- tableau_pourcentages$eco069 + tableau_pourcentages$eco096
tableau_pourcentages <- tableau_pourcentages[, !names(tableau_pourcentages) %in% c("eco031", "eco033", "eco039", "eco037", "eco054", "eco069", "eco096")]


write.table(tableau_pourcentages,
            "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/CorrespondanceHydroHer/HER2hybrides_PointsSimulationExplore2/Version_HER2h20190607_1_TJ20231130/PropSurfaceHER2hybrides_HorsRMCfromShp_AvecExterieur_TabDoubleEntree_JonctionHER2h_Proportions_5_20231201.csv",
            sep = ";", dec = ".", row.names = FALSE)
# write.table(tableau_pourcentages,
#             "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/CorrespondanceHydroHer/HER2hybrides_PointsSimulationExplore2/Version_HER2h20190607_1_TJ20231130/PropSurfaceHER2hybrides_HorsRMCfromShp_TabDoubleEntree_JonctionHER2h_Proportions_5_20231130.csv",
#             sep = ";", dec = ".", row.names = FALSE)

# eco31033039	eco37054	eco69096

## Attacher les proportions dans tab_selection
## Voir quelles proportions prendre pour les points de simu restants

## Concatener les netcdf

## Verifier le CTRIP

## Lancer simu



