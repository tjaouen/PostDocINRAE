library(ncdf4) # package for netcdf manipulation


# Ouverture du fichier netcdf
#nc <- nc_open("/home/tjaouen/Documents/Input/HYDRO/EtudeRMC/Debits/Futur/Work/debit_Rhone_CNRM-CERFACS-CNRM-CM5_historical_r1i1p1_CNRM-ALADIN63_v2_ADAMONT-France_INRAE-J2000_day_19750101-20051231.nc")
#nc <- nc_open("/home/tjaouen/Documents/Input/HYDRO/EtudeRMC/Debits/Futur/Work/debit_Rhone_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v2_ADAMONT-France_INRAE-J2000_day_19750101-21001231.nc")
# nc <- nc_open("/home/tjaouen/Documents/Input/HYDRO/EtudeRMC/Debits/Futur/Work/debit_Rhone_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v2_ADAMONT-France_INRAE-J2000_day_19750101-21001231.nc")
nc <- nc_open("/home/tjaouen/Documents/Input/HYDRO/EtudeRMC/Debits/Futur/Work/debit_Rhone_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v2_ADAMONT-France_INRAE-J2000_day_19750101-21001231.nc")

# Affichage des informations sur les dimensions du fichier netcdf
print(nc$dim)

# Affichage des informations sur les variables du fichier netcdf
print(nc$var)

# Affichage des informations sur les attributs du fichier netcdf
print(nc$var$attrib)

# Afficher les attributs de dimensions
print(nc$dim$attrib)

# Afficher les attributs de fichier
print(nc$att)

# Récupération des noms de toutes les variables netCDF
var_names <- names(nc$var)


# Itération sur chaque variable netCDF
for (var_name in var_names[!var_names %in% c("code_type","code","LII")]) {
  
  # Extraction des données de la variable netCDF
  variable_data <- ncvar_get(nc, var_name)
  
  if (length(dim(variable_data)) > 1){
    # Récupération des noms de dimensions de la variable
    dimnames(variable_data) <- list(ncvar_get(nc, "code"), nc$var$debit$dim[[2]]$vals)
    #dimnames(variable_data) <- list(nc$var$debit$dim[[1]]$vals, nc$var$debit$dim[[2]]$vals)
    #dimnames(variable_data) <- list(paste0("station_",nc$var$ET0$dim[[1]]$vals),paste0("jour_",nc$var$ET0$dim[[2]]$vals))
    
  }else if(!is.null(dim(variable_data))){
    
    if (typeof(variable_data) == "character"){
      # Obtenir la première dimension de la variable
      rownames(variable_data) <- nc$var[[var_name]]$dim[[2]]$vals
    }else{
      # Obtenir la première dimension de la variable
      #rownames(variable_data) <- nc$var[[var_name]]$dim[[1]]$vals
      rownames(variable_data) <- ncvar_get(nc, "code")
    }
  }else{
    rownames(variable_data) <- nc$var[[var_name]]$dim[[1]]$vals
  }

  # Stockage de la variable netCDF dans une variable R avec un nom différent pour chaque variable
  assign(paste0("variable_", var_name), variable_data)

}

date_debut <- as.Date("19500101", format = "%Y%m%d")
colnames(variable_debit) <- as.character(date_debut + as.numeric(colnames(variable_debit)))
#colnames(variable_debit) <- as.character(date_debut + as.numeric(colnames(variable_debit)) - 1)
colnames(variable_debit) <- gsub("-","",colnames(variable_debit))


# Boucle pour chaque station
for (i in 1:dim(variable_debit)[1]) {

  # Extraire les données pour la station i
  station_data <- data.frame(variable_debit[i,])
  colnames(station_data) <- c("Debit")
  station_data$Date = as.numeric(rownames(station_data))
  station_data <- station_data[, c("Date", "Debit")]

  # Nom du fichier de sortie
  #nom_fichier <- paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeRMC/Debits/Futur/DebitsTxt_Rhone_CNRM-CERFACS-CNRM-CM5_historical_r1i1p1_CNRM-ALADIN63_v2_ADAMONT-France_INRAE-J2000_day_19750101-20051231_20230316/", rownames(variable_debit)[i], "_Sim.txt")
  nom_fichier <- paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeRMC/Debits/Futur/DebitsTxt_Rhone_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v2_ADAMONT-France_INRAE-J2000_day_19750101-21001231_20230316/", substr(rownames(variable_debit)[i], 1, nchar(rownames(variable_debit)[i])-2), "_Sim.txt")

  # Écrire le fichier de sortie
  write.table(station_data, nom_fichier, sep=";", col.names=TRUE, row.names=FALSE, quote = F)

}



# dimnames_attrib <- ncatt_get(nc, "Pl", "dimnames")
# units_attrib <- ncatt_get(nc, "Pl", "units")
# longname_attrib <- ncatt_get(nc, "Pl", "long_name")


# Fermeture du fichier netcdf
nc_close(nc)
