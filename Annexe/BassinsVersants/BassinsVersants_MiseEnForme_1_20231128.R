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


### Station HYDRO ###
tab_correspondance_ <- read_excel("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DescriptionPointsSimulation/FichierCorrespondancesLH/Selection_points_simulation_V20230510_TJ20231120_CorrectionDeuxPointsSmash_SansNA.xlsx",
                                  sheet = "stationSimulation")
dim(tab_correspondance_) # 4367
tab_correspondance_ <- tab_correspondance_[which((tab_correspondance_$PointsSupprimes != "Supprimer") | is.na(tab_correspondance_$PointsSupprimes)),]
dim(tab_correspondance_) # 4043

# crs <- st_crs("+init=epsg:2154")
# sf_data_ <- st_as_sf(data_, coords = c("XL93", "YL93"), crs = crs)
# output_shapefile <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DescriptionPointsSimulation/FichierCorrespondancesLH/Shp/Shp_20231128/TableCorrespondance_Selection_points_simulation_V20230510_TJ20231120_CorrectionDeuxPointsSmash_SansNA_20231128.shp"
# st_write(sf_data_, output_shapefile)


### Exporter points ###
netcdfToShp <- function(netcdf_, shp_){
  
  netcdf_read_ <- nc_open(netcdf_)
  
  variables <- names(netcdf_read_$var)
  
  # Créer un dataframe pour stocker les données
  dataframe <- c()
  
  # Boucle à travers les variables et les stocker dans le dataframe
  for (var_name in variables) {
    print(var_name)
    print("ok1.1")
    if (!(var_name %in% c("L93","LII","code_type","network_origin","debit"))){
      variable <- ncvar_get(netcdf_read_, varid = var_name)
      if (length(variable) > 1){
        print("ok1")
        if (is.numeric(variable)){
          dataframe[[var_name]] = as.numeric(variable)
        }else if (is.character(variable)){
          dataframe[[var_name]] = as.character(variable)
        }else{
          dataframe[[var_name]] = variable
        }
        print("ok2")
        dataframe = data.frame(dataframe)
        print("ok3")
      }
    }
  }
  dataframe <- dataframe[which(!(is.na(dataframe$L93_X))),]
  
  # colnames(dataframe)
  # dataframe <- dataframe[,c("code", "name", "topologicalSurface", "topologicalSurface_model", "L93_X", "L93_Y")]
  dataframe <- as.data.frame(dataframe)
  
  # Fermer le fichier NetCDF
  nc_close(netcdf_read_)
  
  # Afficher les premières lignes du dataframe
  head(dataframe)
  
  crs <- st_crs("+init=epsg:2154")
  sf_data_ <- st_as_sf(dataframe, coords = c("L93_X", "L93_Y"), crs = crs, remove = F)
  st_write(sf_data_, shp_)
  
}

CTRIP_netcdf_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_Ncdf/CTRIP_20231128/debit_France_CNRM-CERFACS-CNRM-CM5_historical_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_19510801-20050731.nc"
CTRIP_shp_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/PointsSimulation_FormatShp_20231129/PointsSimulation_CTRIP_20231129.shp"
GRSD_netcdf_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_Ncdf/GRSD_20231128/debit_France_CNRM-CERFACS-CNRM-CM5_historical_r1i1p1_CNRM-ALADIN63_v3_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_19520801-20050731.nc"
GRSD_shp_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/PointsSimulation_FormatShp_20231129/PointsSimulation_GRSD_20231129.shp"
J2000_netcdf_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_Ncdf/J2000_20231128/debit_Rhone-Loire_CNRM-CERFACS-CNRM-CM5_historical_r1i1p1_CNRM-ALADIN63_v3_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-J2000_day_19760801-20050731.nc"
J2000_shp_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/PointsSimulation_FormatShp_20231129/PointsSimulation_J2000_20231129.shp"
ORCHIDEE_netcdf_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_Ncdf/ORCHIDEE_20231128/debit_France_CNRM-CERFACS-CNRM-CM5_historical_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_19510801-20050731.nc"
ORCHIDEE_shp_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/PointsSimulation_FormatShp_20231129/PointsSimulation_ORCHIDEE_20231129.shp"
SMASH_netcdf_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_Ncdf/SMASH_20231128/debit_France_CNRM-CERFACS-CNRM-CM5_historical_r1i1p1_CNRM-ALADIN63_v3_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-SMASH_day_19510801-20050731.nc"
SMASH_shp_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/PointsSimulation_FormatShp_20231129/PointsSimulation_SMASH_20231129.shp"

netcdfToShp(netcdf_ = CTRIP_netcdf_, shp_ = CTRIP_shp_)
netcdfToShp(netcdf_ = GRSD_netcdf_, shp_ = GRSD_shp_)
netcdfToShp(netcdf_ = J2000_netcdf_, shp_ = J2000_shp_)
netcdfToShp(netcdf_ = ORCHIDEE_netcdf_, shp_ = ORCHIDEE_shp_)
netcdfToShp(netcdf_ = SMASH_netcdf_, shp_ = SMASH_shp_)


### Merger les deux shp de bassins versants ###
# Charger les fichiers shp
donnees_fichier1 <- st_read("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DescriptionPointsSimulation/entiteHydro/Rawdata_GRSD_20220322/BV_4207_stations.shp")
donnees_fichier2 <- st_read("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DescriptionPointsSimulation/entiteHydro/Rawdata_GRSD_20220322/3BVs_FRANCE_L2E_2018.shp")

# Convertir donnees_fichier2 vers le CRS de donnees_fichier1
donnees_fichier2_converti <- st_transform(donnees_fichier2, crs = st_crs(donnees_fichier1))

# Concaténer les deux jeux de données
donnees_concatenees <- rbind(donnees_fichier1, donnees_fichier2_converti)

# Écrire les données concaténées dans un nouveau fichier shp
chemin_fichier_sortie <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DescriptionPointsSimulation/entiteHydro/BassinsVersants_Concatenes_20231129/BV_concatenes_4210pointsSimulationExp2_20231129.shp"
st_write(donnees_concatenees, chemin_fichier_sortie)

### Traitement des Bassins Versants ###
chemin_fichier <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DescriptionPointsSimulation/entiteHydro/BV_4207_stations.shp"
# chemin_fichier <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DescriptionPointsSimulation/entiteHydro/3BVs_FRANCE_L2E_2018.shp"



# Lire le fichier SHP
donnees_shp <- st_read(chemin_fichier)

# Afficher les premières lignes pour vérifier la structure des données
head(donnees_shp)

# Afficher des informations sur les données
summary(donnees_shp)

# Accéder aux informations géométriques
donnees_geom <- st_geometry(donnees_shp)
print(donnees_geom)

# Accéder aux attributs
attributs <- donnees_shp$nom_attribut
print(attributs)

donnees_shp$Code[duplicated(donnees_shp$Code)]
tab_correspondance_$CODE[duplicated(tab_correspondance_$CODE)]

dim(donnees_shp) # 4207
dim(tab_correspondance_) # 4043

tab_correspondance_[which(tab_correspondance_$CODE %in% tab_correspondance_$CODE[duplicated(tab_correspondance_$CODE)]),]

donnees_shp$Code8 = donnees_shp$Code
donnees_shp$Code10 = NA

for (b in 1:nrow(donnees_shp)){
  if (length(which(tab_correspondance_$CODE == donnees_shp$Code[b]))==1){
    donnees_shp$Code10[b] = tab_correspondance_$SuggestionCode[which(tab_correspondance_$CODE == donnees_shp$Code[b])]
  }
  if (length(which(tab_correspondance_$CODE == donnees_shp$Code[b]))>1){
    print(donnees_shp$Code[b])
  }
}

length(tab_correspondance_$SuggestionCode[which(tab_correspondance_$SuggestionCode %in% donnees_shp$Code10)])
length(tab_correspondance_$SuggestionCode[which(!(tab_correspondance_$SuggestionCode %in% donnees_shp$Code10))])

tab_correspondance_$CODE[which(!(tab_correspondance_$SuggestionCode %in% donnees_shp$Code10))]





