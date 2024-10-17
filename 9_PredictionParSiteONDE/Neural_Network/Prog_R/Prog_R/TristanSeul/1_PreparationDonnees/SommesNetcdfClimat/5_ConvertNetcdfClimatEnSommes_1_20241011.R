rm(list = ls())

library(abind)
library(ncdf4)

nc_prtotAdjust_historical_ <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J10Jj/prtotAdjust_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_19500101-20051231_J10Jj.nc")
# evspsblpotAdjust_historical_ <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/evspsblpotAdjust_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_19500101-20051231_Hg0175.nc")
# tasAdjust_historical_ <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/tasAdjust_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_19500101-20051231.nc")

nc_prtotAdjust_rcp26_ <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J10Jj/prtotAdjust_France_MPI-M-MPI-ESM-LR_rcp26_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_J10Jj.nc")
# evspsblpotAdjust_rcp26_ <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/evspsblpotAdjust_France_MPI-M-MPI-ESM-LR_rcp26_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_Hg0175.nc")
# tasAdjust_rcp26_ <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/tasAdjust_France_MPI-M-MPI-ESM-LR_rcp26_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231.nc")


prtotAdjust_historical_ <- ncvar_get(nc_prtotAdjust_historical_,"prtotAdjust")
dim(prtotAdjust_historical_)
# evspsblpotAdjust_historical_ <- ncvar_get(evspsblpotAdjust_historical_,"evspsblpotAdjust")
# dim(evspsblpotAdjust_historical_)
# tasAdjust_historical_ <- ncvar_get(tasAdjust_historical_,"tasAdjust")
# dim(tasAdjust_historical_)

prtotAdjust_rcp26_ <- ncvar_get(nc_prtotAdjust_rcp26_,"prtotAdjust")
dim(prtotAdjust_rcp26_)
# evspsblpotAdjust_rcp26_ <- ncvar_get(evspsblpotAdjust_rcp26_,"evspsblpotAdjust")
# dim(evspsblpotAdjust_rcp26_)
# tasAdjust_rcp26_ <- ncvar_get(tasAdjust_rcp26_,"tasAdjust")
# dim(tasAdjust_rcp26_)



# Concaténation des matrices selon la 3ème dimension (d = 3)
prtotAdjust_combined_ <- abind(prtotAdjust_historical_, prtotAdjust_rcp26_, along = 3)

dim(prtotAdjust_historical_)[3]+dim(prtotAdjust_rcp26_)[3]
dim(prtotAdjust_combined_)


# Initialiser la variable de sortie avec les mêmes dimensions
prtotAdjust_JjJ10_ <- prtotAdjust_combined_
n_slices <- dim(prtotAdjust_JjJ10_)[3]  # Nombre de slices (55152)
n_slices

for (i in 11:n_slices) {
  if (i %% 2500 == 0){
    print(paste0("Slice i: ",i))
  }
  prtotAdjust_JjJ10_[, , i] <- apply(prtotAdjust_combined_[, , (i-10):i], MARGIN = c(1, 2), sum)
}


# for (i in 1:10) {
#   prtotAdjust_JjJ10_[, , i] <- NA
# }

prtotAdjust_historical_ <- prtotAdjust_JjJ10_[,,1:dim(prtotAdjust_historical_)[3]]
prtotAdjust_rcp26_ <- prtotAdjust_JjJ10_[,,(dim(prtotAdjust_historical_)[3]+1):(dim(prtotAdjust_historical_)[3]+dim(prtotAdjust_rcp26_)[3])]

nc_prtotAdjust_historical_$writable <- TRUE

ncvar_put(nc = nc_prtotAdjust_historical_,
          varid = "prtotAdjust",
          vals = prtotAdjust_historical_)
nc = nc_prtotAdjust_historical_
varid = "prtotAdjust"
vals = prtotAdjust_historical_
start=NA
count=NA
verbose=FALSE
na_replace="fast"

ncvar_put(nc_prtotAdjust_rcp26_, "prtotAdjust", prtotAdjust_rcp26_)


# nc_prtotAdjust_historical_$



source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/CreateNetcdf_ExampleDrias/ncdf4_priv_var.R")

ncvar_put <- function( nc, varid=NA, vals=NULL, start=NA, count=NA, verbose=FALSE, na_replace="fast" ) {
  
  if( verbose ) print('ncvar_put: entering')
  
  #if( class(nc) != 'ncdf4' )
  if( ! inherits( nc, 'ncdf4' ))
    stop(paste("Error: first argument to ncvar_put must be an object of type ncdf,",
               "as returned by a call to nc_open(...,write=TRUE) or nc_create"))
  
  #---------------------------------------------
  # Make sure the passed ncid is a writable file
  #---------------------------------------------
  if( ! nc$writable ) 
    stop(paste("Error: called with a nc object that is NOT a writable netcdf file! Passed nc file name:", nc$filename ))
  
  is_class_ncvar4 = ( inherits( varid, 'ncvar4' ))
  is_class_ncdim4 = ( inherits( varid, 'ncdim4' ))
  if( (mode(varid) != 'character') && ( ! is_class_ncvar4 ) && (! is_class_ncdim4 ) && (! is.na(varid)))
    stop(paste("Error: second argument to ncvar_put must be either an object of type ncvar,",
               "as returned by a call to ncvar_def, or the character-string name of a variable",
               "in the file.  If there are multiple vars in the file with the same name (but",
               "in different groups), then the fully qualified var name must be given, for",
               "example, model1/run5/Temperature"))
  
  #-----------------------------------------------------------------------------------
  # Exactly why we do the following is obscure.  Note that DIMVARS are not kept on 
  # the 'variable' list for the file.  So if we explicitly make a dimvar, then pass
  # that ncvar object to this routine, it will ordinarily fail because no 'var' 
  # matching that dimvar will be found.  This however works if we pass the NAME of
  # the dimvar, because that is matched on the dimvar list as well as the var list.
  # To avoid this error, we force all matches to be by name, rather than by var object
  #-----------------------------------------------------------------------------------
  #if( (class(varid) == 'ncvar4') || (class(varid) == 'ncdim4')) {
  if( is_class_ncvar4 || is_class_ncdim4 ) {
    varid = varid$name
    if( verbose ) print(paste("ncvar_put: converting passed ncvar4/ncdim4 object to the name:", varid))
  }
  
  #----------------------------------------------------
  # If we are running in safemode, must reopen the file
  # and renew the varid
  #----------------------------------------------------
  if( nc$safemode ) {
    if(verbose) print(paste('ncvar_put: file is in safe mode, so reopening file', nc$filename))
    nc$id = ncdf4_inner_open( nc )
    c_varid_gid = ncvar_id_hier( nc$id, varid )
  }
  
  if( is.null(vals))
    stop("requires a vals argument to be set")
  
  if( verbose ) {
    if( mode(varid) == 'character')
      vname <- varid
    else
      vname <- varid$name
    print(paste("ncvar_put: entering, filename=", nc$filename, ' varname=', vname ))
  }
  
  #-----------------------------------------------------------------
  # Identify exactly what var (or dimvar) we will be putting data to
  #-----------------------------------------------------------------
  idobj = vobjtovarid4( nc, varid, allowdimvar=TRUE, verbose=verbose )	# NOTE: not a simple integer, but a ncid4 class object with $id, $group_index, $group_id, $list_index
  ncid2use   = idobj$group_id
  varid2use  = idobj$id
  varidx2use = idobj$list_index	# this is the index into the nc$vars[[]] list that indictes this variable
  isdimvar   = idobj$isdimvar
  if( nc$safemode ) {
    varid2use = c_varid_gid[1]
    ncid2use  = c_varid_gid[2]
  }
  
  if( verbose ) 
    print(paste('ncvar_put: writing to var (or dimvar) with id=',idobj$id, ' group_id=', idobj$group_id ))
  
  #-----------------------------
  # Check inputs for correctness
  #-----------------------------
  sm <- storage.mode(start)
  if( (sm != "double") && (sm != "integer") && (sm != "logical"))
    stop(paste("passed a start argument of storage mode",sm,"; can only handle double or integer"))
  sm <- storage.mode(count)
  if( (sm != "double") && (sm != "integer") && (sm != "logical"))
    stop(paste("passed a 'count' argument with storage mode '",sm,"'; can only handle double or integer", sep=''))
  
  #--------------------
  # Prevent dumb errors
  #--------------------
  if( ! nc$writable ) 
    stop(paste("trying to write to file",nc$filename,"but it was not opened with write=TRUE"))
  
  varsize <- ncvar_size ( ncid2use, varid2use )
  ndims   <- ncvar_ndims( ncid2use, varid2use )
  is_scalar = all(varsize == 1) && all(ndims == 0)
  if( verbose ) {
    print(paste("ncvar_put: varsize="))
    print(varsize)
    print(paste("ncvar_put: ndims=", ndims))
    print(paste("ncvar_put: is_scalar=", is_scalar ))
  }
  
  #--------------------------------------------------------
  # Fix up start and count to use (in R convention for now)
  #--------------------------------------------------------
  if( (length(start)==1) && is.na(start) ) {
    if( is_scalar )
      start <- 1
    else
      start <- rep(1,ndims)	# Note: use R convention for now
  }else{
    if( length(start) != ndims ) 
      stop(paste("'start' should specify",ndims,
                 "dims but actually specifies",length(start)))
  }
  if( verbose ) {
    print("ncvar_put: using start=")
    print(start)
  }
  if( (length(count)==1) && is.na(count)) {
    count <- varsize - start + 1	
  }else{
    if( length(count) != ndims ) 
      stop(paste("'count' should specify",ndims,
                 "dims but actually specifies",length(count)))
    count <- ifelse( (count == -1), varsize-start+1, count)
  }
  if( verbose ) {
    print("ncvar_put: using count=")
    print(count)
  }
  
  #------------------------------
  # Switch from R to C convention
  #------------------------------
  c.start <- start[ ndims:1 ] - 1
  c.count <- count[ ndims:1 ]
  
  #--------------------------------------------
  # Change NA's to the variable's missing value
  #--------------------------------------------
  if( verbose )
    print("about to change NAs to variables missing value")
  if( isdimvar ){
    mv <- default_missval_ncdf4()
  }else{
    mv <- nc$var[[ varidx2use ]]$missval 
  }
  
  if( ! is.null(mv)) {
    ierr = 0
    if( storage.mode( vals ) == "double" ) {
      
      if( na_replace == "safe" ) {
        vals = vals + 0.0	# This triggers R to make a copy of vals, since vals is modified in the call below
      } else if( na_replace != "fast" ){
        stop(paste("Error, argument na_replace must be either the string 'fast' or 'safe', but got:", na_replace ))
      }
      
      rv <- .Call( "R_nc4_set_NA_to_val_double", 
                   vals, 
                   as.double(mv),
                   PACKAGE="ncdf4" )
    }else{
      vals <- ifelse( is.na(vals), mv, vals)
    }
  }
  
  #---------------------------------
  # Get the correct type of variable
  #---------------------------------
  precint <- ncvar_type( ncid2use, varid2use ) # 1=short, 2=int, 3=float, 4=double, 5=char, 6=byte, 7=ubyte, 8=ushort, 9=uint, 10=int64, 11=uint64, 12=string
  if( verbose )
    print(paste("ncvar_put: Putting var of type",precint," (1=short, 2=int, 3=float, 4=double, 5=char, 6=byte, 7=ubyte, 8=ushort, 9=uint, 10=int64, 11=uint64, 12=string)"))
  
  #----------------------------------------------------------
  # Sanity check to make sure we have at least as many values 
  # in the data array as we are writing.  Chars are a special
  # case because typically they are defined with an extra
  # "nchar" dim that is not included in the passed array.
  #----------------------------------------------------------
  n2write <- prod(count)
  if( (precint != 5) && (length(vals) != n2write)) {
    if( length(vals) > n2write ) {
      print(paste("ncvar_put: warning: you asked to write",n2write,
                  "values, but the passed data array has",length(vals),
                  "entries!"))
    } else {
      stop(paste("ncvar_put: error: you asked to write",n2write,
                 "values, but the passed data array only has",length(vals),
                 "entries!"))
    }
  }
  
  rv <- list()
  rv$error <- -1
  
  if( verbose ) {
    print("ncvar_put: calling C routines with C-style count=")
    print(c.count)
    print("and C-style start=")
    print(c.start)
  }
  if( (precint == 1) || (precint == 2) || (precint == 6) || (precint == 7) || (precint == 8) || (precint == 9)) {
    #--------------------------------------
    # Short, Int, Byte, UByte, UShort, UInt 
    #--------------------------------------
    rv_error <- .Call("Rsx_nc4_put_vara_int",
                      as.integer(ncid2use),
                      as.integer(varid2use),
                      as.integer(c.start),	# Already switched to C convention...
                      as.integer(c.count),	# Already switched to C convention...
                      as.integer(vals),
                      PACKAGE="ncdf4")
    if( rv_error != 0 ) 
      stop("C function Rsx_nc4_put_vara_int returned error")
    if( verbose )
      print(paste("C function Rsx_nc4_put_vara_int returned", rv_error))
  }else if( (precint == 3) || (precint == 4) || (precint == 10) || (precint == 11)) {
    #-----------------------------------------------
    # Float, double, 8-byte int, unsigned 8-byte int
    #-----------------------------------------------
    if( (precint == 10) || (precint == 11)) {
      print(paste(">>>> WARNING <<<< You are attempting to write data to a 8-byte integer,"))
      print(paste("but R does not have an 8-byte integer type.  This is a bad idea! I will"))
      print(paste("TRY to write this by converting from double precision floating point, but"))
      print(paste("this could lose precision in your data!"))
    }
    HDF5_USE_FILE_LOCKING=FALSE
    rv_error <- .Call("Rsx_nc4_put_vara_double", 
                      as.integer(ncid2use),
                      as.integer(varid2use),	
                      as.integer(c.start),	# Already switched to C convention...
                      as.integer(c.count),	# Already switched to C convention...
                      data=as.double(vals),
                      PACKAGE="ncdf4")
    if( rv_error != 0 ) 
      stop("C function Rsx_nc4_put_vara_double returned error")
    if( verbose )
      print(paste("C function Rsx_nc4_put_vara_double returned", rv_error))
  }else if( precint == 5 ) {
    #----------
    # Character
    #----------
    rv <- .C("R_nc4_put_vara_text", 
             as.integer(ncid2use),
             as.integer(varid2use),	
             as.integer(c.start),	# Already switched to C convention...
             as.integer(c.count),	# Already switched to C convention...
             data=as.character(vals),
             error=as.integer(rv$error),
             PACKAGE="ncdf4")
    if( rv$error != 0 ) 
      stop("C function R_nc4_put_vara_text returned error")
    if( verbose )
      print(paste("C function R_nc4_put_var_text returned", rv$error))
  }else{
    stop(paste("Internal error in ncvar_put: unhandled variable type=",precint,". Types I know: 1=short 2=int 3=float 4=double 5=char"))
  }
  
  #----------------------------------------------------------------
  # If we are running in safe mode, close the file before returning
  #----------------------------------------------------------------
  if( nc$safemode ) {
    rv = .C("R_nc4_close", as.integer(nc$id), PACKAGE="ncdf4")
    nc$id = -1	# invalidate this ID since it's not valid any more (duh)
  }
  
  if( verbose ) print('ncvar_put: exiting')
}



































### APPLY MEAN POUR LA TEMPERATURE, SOMME POUR ETP



prtotAdjust_JjJ10_historical_ <- prtotAdjust_JjJ10_[,,1:dim(prtotAdjust_historical_)[3]]

# Écrire les données modifiées dans la variable du fichier NetCDF
ncvar_put(nc_prtotAdjust_historical_, "prtotAdjust", prtotAdjust_JjJ10_historical_)




  
} else {
  message("La variable 'var_name' n'existe pas dans le fichier NetCDF.")
}

# Fermer le fichier NetCDF après modification
nc_close(nc)


# Définir les dimensions du nouveau fichier NetCDF
dim_x <- ncdim_def("x", "meters", vals = seq(1, 10, by = 1))
dim_y <- ncdim_def("y", "meters", vals = seq(1, 10, by = 1))

# Définir une nouvelle variable
var_new <- ncvar_def("new_var", "units", list(dim_x, dim_y), missval = NA)

# Créer un nouveau fichier NetCDF
nc_new <- nc_create("new_file.nc", var_new)

# Écrire des données dans la nouvelle variable
ncvar_put(nc_new, var_new, var_data_modified)

# Fermer le fichier
nc_close(nc_new)




source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/9_PredictionParSiteONDE/Neural_Network/Prog_R/TristanSeul/1_PreparationDonnees/NCf.R")

generate_NCf(out_dir="/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/prtotAdjust_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_19500101-20051231_JjJ10.nc",
             environment_name="NCf",
             overwrite=TRUE,
             chunksizes_list=c("time"=365),
             missval=NaN,
             unlim_list=c("time"),
             return_path=FALSE,
             verbose=FALSE)
  
  
  
  
  
  
  
  