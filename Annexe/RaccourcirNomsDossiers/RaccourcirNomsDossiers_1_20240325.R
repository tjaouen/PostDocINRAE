

patterns_ = matrix(c("debit_France_","",
              
              "CNRM-CERFACS","CERFACS",
              "ICHEC-EC-EARTH","EC-EARTH",
              "IPSL-IPSL-CM5A-MR","IPSL-CM5A-MR",
              "MOHC-HadGEM2-ES","HadGEM2-ES",
              "MPI-M-MPI-ESM-LR","MPI-ESM-LR",
              "NCC-NorESM1-M","NorESM1-M",
              
              "-r1i1p1","",
              "-r12i1p1","",
              "_r1i1p1","",
              "_r12i1p1","",
              
              "CNRM-ALADIN63_v3","ALADIN63",
              "MOHC-HadREM3-GA7-05_v3","HadREM3-GA7",
              "KNMI-RACMO22E_v2","RACMO22E",
              "MOHC-HadREM3-GA7-05_v2","HadREM3-GA7",
              "SMHI-RCA4_v2","SMHI-RCA4",
              "DMI-HIRHAM5_v2","DMI-HIRHAM5",
              "CLMcom-CCLM4-8-17_v2","CCLM4",
              "ICTP-RegCM4-6_v2","RegCM4",
              "MOHC-HadREM3-GA7-05_v2","HadREM3-GA7",
              "MPI-CSC-REMO2009_v2","CSC-REMO2009",
              "DMI-HIRHAM5_v4","HIRHAM5",
              "GERICS-REMO2015_v2","REMO2015",
              "IPSL-WRF381P_v2","WRF381P_v2",
              
              "MF-ADAMONT","ADAMONT",
              "LSCE-IPSL_CDFt-L-1V-0L","CDFt",
              "-SAFRAN-1980-2011_MF-ISBA","",
              "_SAFRAN-1980-2011_MF-ISBA","",
              "_day_20050801-21000731","",
              "_day_20050801-20990731",""),
              
              ncol = 2, byrow = T)

# patterns_ = as.data.frame(patterns_)
# colnames(patterns_) <- c("Origine","Remplacement")

path_origin_ = "/media/tjaouen/My Passport/DonneesTristanJ_Assecs/"


# Fonction pour renommer les fichiers
rename_files <- function(path, patterns) {
  # List all files and directories recursively
  files <- list.files(path, recursive = TRUE, full.names = TRUE, include.dirs = T)
  
  for (i in length(files)){
    if (file.info(files[i])$isdir){
      dir.rename(files[i], gsub(patterns[i, 1], patterns[i, 2], files[i]))
      files <- list.files(path, recursive = TRUE, full.names = TRUE, include.dirs = T)
    }else{
      files[i] <- gsub(patterns[i, 1], patterns[i, 2], files[i])
    }
  }
}

rename_files(path_origin_, patterns_)


rename_files <- function(path, patterns) {
  # List all files and directories recursively
  files <- list.files(path, recursive = TRUE, full.names = TRUE, include.dirs = T)
  files_new <- c()
  
  for (i in length(files)){
    file_ = files[i]
    for (j in 1:nrow(patterns)) {
      files_new[i] <- gsub(patterns[j, 1], patterns[j, 2], file_)
      file_ = files_new[i]
    }
    
    if (file.info(files[i])$isdir){
      dir.rename(files[i], file_)
    }else{
      file.rename(files[i], file_)
    }
    
  }
}


