library(readxl)
library(ncdf4)
library(rgdal)
library(sf)

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

