rm(list = ls())


library(ncdf4)


file_netcdf_DiagSafran_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeRMC/Debits/DebitsSimChroniques/J2000_20230308_safran_diagnostic.nc" #235 stations, OK
nc_DiagSafran_ <- nc_open(file_netcdf_DiagSafran_)
variable_code_hydro_DiagSafran_ <- ncvar_get(nc_DiagSafran_, "code_hydro") # J2000 Safran
length(variable_code_hydro_DiagSafran_) #235


# Récupération des noms de toutes les variables netCDF
var_names <- names(nc_DiagSafran_$var)


# Itération sur chaque variable netCDF
for (var_name in var_names[!var_names %in% c("code_type","code","LII")]) {
  
  # Extraction des données de la variable netCDF
  variable_data <- ncvar_get(nc_DiagSafran_, var_name)
  
  if (length(dim(variable_data)) > 1){
    # Récupération des noms de dimensions de la variable
    dimnames(variable_data) <- list(ncvar_get(nc_DiagSafran_, "code_hydro"), nc_DiagSafran_$var$Q$dim[[2]]$vals)
    # dimnames(variable_data) <- list(ncvar_get(nc_DiagSafran_, "code"), nc_DiagSafran_$var$debit$dim[[2]]$vals)
    #dimnames(variable_data) <- list(nc_DiagSafran_$var$debit$dim[[1]]$vals, nc_DiagSafran_$var$debit$dim[[2]]$vals)
    #dimnames(variable_data) <- list(paste0("station_",nc_DiagSafran_$var$ET0$dim[[1]]$vals),paste0("jour_",nc_DiagSafran_$var$ET0$dim[[2]]$vals))
    
  }else if(!is.null(dim(variable_data))){
    
    if (typeof(variable_data) == "character"){
      # Obtenir la première dimension de la variable
      rownames(variable_data) <- nc_DiagSafran_$var[[var_name]]$dim[[2]]$vals
    }else{
      # Obtenir la première dimension de la variable
      #rownames(variable_data) <- nc_DiagSafran_$var[[var_name]]$dim[[1]]$vals
      rownames(variable_data) <- ncvar_get(nc_DiagSafran_, "code")
    }
  }else{
    rownames(variable_data) <- nc_DiagSafran_$var[[var_name]]$dim[[1]]$vals
  }
  
  # Stockage de la variable netCDF dans une variable R avec un nom différent pour chaque variable
  assign(paste0("variable_", var_name), variable_data)
  
}













# Fonction récursive pour parcourir les sous-variables
explore_variables <- function(ncfile, varname_prefix = "") {
  
  var_names <- names(ncfile$var)
  
  for (varname in varnames) {
    
    var_names <- names(ncfile$var[varname])
    
    variable_data <- ncvar_get(nc_DiagSafran_, varname)
    
    # varname <- ncvar_get(ncfile)
    # full_varname <- paste(varname_prefix, varname, sep = "/")
    
    # Vérifier si la variable contient des sous-variables
    subvarnames <- ncatt_get(ncfile, full_varname, "_Netcdf4Coordinates")
    if (!is.null(subvarnames)) {
      print(paste("Variable:", full_varname))
      print(subvarnames)
      
      # Récursivement parcourir les sous-variables
      explore_variables(ncfile, varname_prefix = full_varname)
    } else {
      # Si la variable n'a pas de sous-variables, vous pouvez insérer le code pour générer le schéma souhaité ici
      # Par exemple, utiliser la fonction plot() pour afficher un graphique
    }
  }
}

# Appeler la fonction pour parcourir les variables
explore_variables(ncfile = nc_DiagSafran_)

# Fermer le fichier NetCDF
nc_close(ncfile)




library(ncdf4)

library(ncdf4)

varname_list = c()
# Fonction récursive pour parcourir les variables d'un fichier NetCDF
recursive_ncdf <- function(nc) {
  if (exists("nc$var")){
    print("TRUE")

    varnames <- names(nc$var)
    varname_list = c(varname_list,varnames)

    # Parcours des variables du fichier
    if (length(varnames) > 0){
      for (varname in varnames) {
        nc_branch = ncvar_get(nc, varname)
        # varname_list <- 
        # varname_list <- c(varname_list,varname,recursive_ncdf(nc_branch))
        # return(ncvar_get(nc, varname))
      }
    }
  }else{
    return("")
  }
  return(varname_list)
}


# Appel de la fonction récursive avec le fichier racine
nc <- nc_open(filename)
#var_names <- names(nc$var)
var_res <- recursive_ncdf(nc = nc)







ajouter_element_recursif <- function(varnames, nc) {
  if (!is.null(names(nc))){
    varnames <- c(varnames,names(nc))
    for (varname in varnames){
      if (varname == "var"){
        varnames <- c(varnames,ajouter_element_recursif(varnames, nc[[varname]]))
      }
    }
  }else{
    return(varnames)
  }
}

# return(ajouter_element_recursif(varnames, nc_branch))  # Appel récursif avec les éléments restants

nc <- nc_open(file_netcdf_DiagSafran_)
varnames <- c()
nouveau_vecteur <- ajouter_element_recursif(varnames, nc)
print(nouveau_vecteur)
















### Librairies ###
library(sf)


### Sim RCP 85 ###
file_netcdf_rcp85j2000_HistFutur_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeRMC/Debits/Futur/Work/debit_Rhone_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v2_ADAMONT-France_INRAE-J2000_day_19750101-21001231.nc"
nc_rcp85 <- nc_open(file_netcdf_rcp85j2000_HistFutur_)
variable_code_rcp85j2000_HistFutur_ <- ncvar_get(nc_rcp85, "code")
length(variable_code_rcp85j2000_HistFutur_) #652


df_rcp85 <- data.frame(variable_code_rcp85j2000_HistFutur_,round(ncvar_get(nc_rcp85,"L93_X")),round(ncvar_get(nc_rcp85,"L93_Y")))
colnames(df_rcp85) <- c("Code","L93_X","L93_Y")

df_rcp85_notRound <- data.frame(variable_code_rcp85j2000_HistFutur_, ncvar_get(nc_rcp85,"L93_X"), ncvar_get(nc_rcp85,"L93_Y"))
colnames(df_rcp85_notRound) <- c("Code","L93_X","L93_Y")


# Convertir les coordonnées en un objet sf de type "POINT"
data_sf_rcp85 <- st_as_sf(df_rcp85, coords = c("L93_X", "L93_Y"), crs = "+init=epsg:2154")

# Spécifier le chemin de sortie du fichier shapefile
output_file_rcp85 <- "/home/tjaouen/Documents/Input/HYDRO/EtudeRMC/Debits/Futur/ShpVersion_StationLocation/debit_Rhone_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v2_ADAMONT-France_INRAE-J2000_day_19750101-21001231.shp"

# Écrire le fichier shapefile
st_write(data_sf_rcp85, output_file_rcp85)           



### Station selectionnees projet ###
file_selectionStationsHydro_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/Stations_HYDRO_KGESUp0.00_DispSup-1.csv"
tab_selectionStationsHydro_ <- read.table(file_selectionStationsHydro_, sep = ";", dec = ".", header = T)

df_selectionStationsHydro_ <- data.frame(tab_selectionStationsHydro_$Code_short, tab_selectionStationsHydro_$XL93, tab_selectionStationsHydro_$YL93)
colnames(df_selectionStationsHydro_) <- c("Code","L93_X","L93_Y")

# Convertir les coordonnées en un objet sf de type "POINT"
data_sf_selectionStationsHydro_ <- st_as_sf(df_selectionStationsHydro_, coords = c("L93_X", "L93_Y"), crs = "+init=epsg:2154")

# Spécifier le chemin de sortie du fichier shapefile
output_file_selectionStationsHydro_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/ShpVersion_StationLocation/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522.shp"

# Écrire le fichier shapefile
st_write(data_sf_selectionStationsHydro_, output_file_selectionStationsHydro_)           

length(data_sf_selectionStationsHydro_$Code[which(substr(data_sf_selectionStationsHydro_$Code,1,1) %in% c("U","V","W","X","Y","Z"))])
length(data_sf_selectionStationsHydro_$Code[which(data_sf_selectionStationsHydro_$Code %in% data_sf_rcp85$Code)])
length(data_sf_selectionStationsHydro_$Code[which(!(data_sf_selectionStationsHydro_$Code %in% data_sf_rcp85$Code) & (substr(data_sf_selectionStationsHydro_$Code,1,1) %in% c("U","V","W","X","Y","Z")))])


### Intersection ###
st_intersection_ = c()
st_nonIntersection_NomCommun_ = c()
st_nonIntersection_pasNomCommun_ = c()
for (st in 1:nrow(tab_selectionStationsHydro_)){
  if (length(which(df_rcp85$L93_X == tab_selectionStationsHydro_$XL93[st] & df_rcp85$L93_Y == tab_selectionStationsHydro_$YL93[st] & df_rcp85$Code == tab_selectionStationsHydro_$Code_short[st])) > 0){
    st_intersection_ = c(st_intersection_,tab_selectionStationsHydro_$Code_short[st])
  }else if (length(which((df_rcp85$Code == tab_selectionStationsHydro_$Code_short[st]) & !(df_rcp85$L93_X == tab_selectionStationsHydro_$XL93[st] & df_rcp85$L93_Y == tab_selectionStationsHydro_$YL93[st]))) > 0){
    st_nonIntersection_NomCommun_ = c(st_nonIntersection_NomCommun_,tab_selectionStationsHydro_$Code_short[st])
  }else{
    st_nonIntersection_pasNomCommun_ = c(st_nonIntersection_pasNomCommun_,tab_selectionStationsHydro_$Code_short[st])
  }
}
length(st_intersection_) #81
length(st_nonIntersection_NomCommun_) #31
length(st_nonIntersection_pasNomCommun_) #896




df_rcp85[which(df_rcp85$Code %in% st_nonIntersection_NomCommun_),]
tab_selectionStationsHydro_[which(tab_selectionStationsHydro_$Code_short %in% st_nonIntersection_NomCommun_),c("Code_short", "XL93", "YL93")]
df_rcp85_notRound[which(df_rcp85_notRound$Code %in% st_nonIntersection_NomCommun_),c("Code", "L93_X", "L93_Y")]

#length(data_sf_selectionStationsHydro_$Code[which(data_sf_selectionStationsHydro_$geometry %in% data_sf_rcp85$Code) & (substr(data_sf_selectionStationsHydro_$Code,1,1) %in% c("U","V","W","X","Y","Z")))])


### Ecriture Selection Csv ###
file_selectionStationsHydro_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_11_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230522/Stations_HYDRO_KGESUp0.00_DispSup-1.csv"
tab_selectionStationsHydro_ <- read.table(file_selectionStationsHydro_, sep = ";", dec = ".", header = T)
write.table(tab_selectionStationsHydro_[which((tab_selectionStationsHydro_$Code_short %in% st_intersection_) | (tab_selectionStationsHydro_$Code_short %in% st_nonIntersection_NomCommun_)),],
            "/home/tjaouen/Documents/Input/HYDRO/EtudeRMC/StationsSelectionnees/SelectionCsv/SelectionCsv_AVENIR_StationsCommunesObsSim/debit_Rhone_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v2_ADAMONT-France_INRAE-J2000_day_19750101-21001231/Stations_HYDRO_KGESUpAll_DispSupAll.csv",
            sep = ";", dec = ".", row.names = F)





