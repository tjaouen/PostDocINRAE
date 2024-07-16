library(ncdf4) # package for netcdf manipulation

file_netcdf_hist_ = "/home/tjaouen/Documents/Input/HYDRO/DebitsRhone_20230308/Work/debit_Rhone_CNRM-CERFACS-CNRM-CM5_historical_r1i1p1_CNRM-ALADIN63_v2_ADAMONT-France_INRAE-J2000_day_19750101-20051231.nc"

# nc_data_hist_ <- nc_open(file_netcdf_hist_)
# {
#   sink('/home/tjaouen/Documents/Input/HYDRO/DebitsRhone_20230308/Work/debit_Rhone_CNRM-CERFACS-CNRM-CM5_historical_r1i1p1_CNRM-ALADIN63_v2_ADAMONT-France_INRAE-J2000_day_19750101-20051231.txt')
#   print(nc_data)
#   sink()
# }

# nc_data_hist_$var$L93_X
# #nc_data_hist_$dim$
# 
# code_type_ <- ncvar_get(nc_data_hist_, "code_type")
# length(code_type)
# debit_ <- ncvar_get(nc_data_hist_, "debit")
# length(debit_)
# L93_X_ <- ncvar_get(nc_data_hist_, "L93_X")
# length(L93_X_)
# L93_Y_ <- ncvar_get(nc_data_hist_, "L93_Y")
# length(L93_Y_)
# #debit_[1:30]

# lat <- ncvar_get(nc_data_hist_, "lat", verbose = F)
# t <- ncvar_get(nc_data_hist_, "time")
# 
# head(lon) # look at the first few entries in the longitude vector


# Ouverture du fichier netcdf
nc <- nc_open("/home/tjaouen/Documents/Input/HYDRO/EtudeRMC/Debits/DebitsSimChroniques/J2000_20230308_safran_diagnostic.nc")

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

# Extraction des données d'une variable netCDF
variable_code_hydro_ <- ncvar_get(nc, "code_hydro")
variable_code_hydro_ <- ncvar_get(nc, "code_hydro")
variable_code_hydro_ <- ncvar_get(nc, "code_hydro")
variable_code_hydro_ <- ncvar_get(nc, "code_hydro")

# Récupération des noms de toutes les variables netCDF
var_names <- names(nc$var)


# Itération sur chaque variable netCDF
for (var_name in var_names) {
  
  # Extraction des données de la variable netCDF
  variable_data <- ncvar_get(nc, var_name)
  
  if (length(dim(variable_data)) > 1){
    # Récupération des noms de dimensions de la variable
    dimnames(variable_data) <- list(variable_code_hydro,paste0(nc$var$ET0$dim[[2]]$vals))
    #dimnames(variable_data) <- list(paste0("station_",nc$var$ET0$dim[[1]]$vals),paste0("jour_",nc$var$ET0$dim[[2]]$vals))
  }

  # Stockage de la variable netCDF dans une variable R avec un nom différent pour chaque variable
  assign(paste0("variable_", var_name), variable_data)

}

date_debut <- as.Date("19500101", format = "%Y%m%d")
colnames(variable_Q) <- as.character(date_debut + as.numeric(colnames(variable_Q)))
#colnames(variable_Q) <- as.character(date_debut + as.numeric(colnames(variable_Q)) - 1)
colnames(variable_Q) <- gsub("-","",colnames(variable_Q))

# Boucle pour chaque station
for (i in 1:dim(variable_Q)[1]) {
  
  # Extraire les données pour la station i
  station_data <- data.frame(variable_Q[i,])
  colnames(station_data) <- c("Qsim")
  station_data$Date = as.numeric(rownames(station_data))
  station_data <- station_data[, c("Date", "Qsim")]

  # Nom du fichier de sortie
  nom_fichier <- paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeRMC/Debits/DebitsSimChroniques/DebitsTxt_J2000_SafranDiagnostic_20230315/", rownames(variable_Q)[i], "_Safran_J2000.txt")
  
  # Écrire le fichier de sortie
  write.table(station_data, nom_fichier, sep=";", col.names=TRUE, row.names=FALSE, quote = F)
  
}



# dimnames_attrib <- ncatt_get(nc, "Pl", "dimnames")
# units_attrib <- ncatt_get(nc, "Pl", "units")
# longname_attrib <- ncatt_get(nc, "Pl", "long_name")


# Fermeture du fichier netcdf
nc_close(nc)
