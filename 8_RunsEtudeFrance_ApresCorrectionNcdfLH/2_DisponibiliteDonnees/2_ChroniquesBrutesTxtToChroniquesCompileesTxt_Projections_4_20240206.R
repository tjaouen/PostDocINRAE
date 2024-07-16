
### Modele climatique projections ###
# Chaud et saisons contrastées (HadGEM/CCLM),
# Chaud et sec (EC Earth/HadREM),
# Faibles changements en température et précipitations (CNRM/Aladin), et
# Chaud et humide (HadGEM/Aladin)

# Tout en Adamanont car pas de temps journalier

### Options compilation chroniques pour calcul FDC ###
# Option 1 = Safran 1970-2019 + Historique 1970-2005 + Futur 2005 -2100
# Option 2 = Historique 1970-2005 + Futur 2005 -2100
# Option 3 = Safran 1970-2019 + Futur 2005 -2100
### ANCIENNE VERSION, FAIRE UNIQUEMENT DES OPTIONS AVEC SAFRAN

library(doParallel)
library(dplyr) # Chargement du package dplyr pour utiliser la fonction rbind
library(strex)
library(beepr)


#############
### J2000 ###
#############

pattern_ = "J2000"

### SAFRAN ###
file_safran_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsObservesReanalyseSafran_DriasEau/DebitsComplets_CorrLocPointsLH_20231123_FormatTxt/Safran_CorrigeLH_20231128/debit_Rhone-Loire_SAFRAN-France-2022_INRAE-J2000_day_19760801-20221231/"

### HISTORIQUE ###
files_hist_ <- list.files("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/J2000_20231128/ChroniquesBrutes_historical/", full.names = T)

### RCP 85 ###
files_rcp85_ <- list.files("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/J2000_20231128/ChroniquesBrutes_rcp26/", full.names = T)
# files_rcp85_ <- list.files("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/J2000_20231128/ChroniquesBrutes_rcp45/", full.names = T)
# files_rcp85_ <- list.files("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/J2000_20231128/ChroniquesBrutes_rcp85/", full.names = T)


############
### GRSD ###
############

# pattern_ = "GRSD"
# 
# ### SAFRAN ###
# file_safran_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsObservesReanalyseSafran_DriasEau/DebitsComplets_CorrLocPointsLH_20231123_FormatTxt/Safran_CorrigeLH_20231128/debit_France_SAFRAN-France-2022_INRAE-GRSD_day_19760801-20190731/"
# 
# ### HISTORIQUE ###
# files_hist_ <- list.files("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/GRSD_20231128/ChroniquesBrutes_historical/", full.names = T)
# 
# ### RCP 85 ###
# files_rcp85_ <- list.files("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/GRSD_20231128/ChroniquesBrutes_rcp26/", full.names = T)
# # files_rcp85_ <- list.files("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/GRSD_20231128/ChroniquesBrutes_rcp45/", full.names = T)
# # files_rcp85_ <- list.files("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/GRSD_20231128/ChroniquesBrutes_rcp85/", full.names = T)


#############
### SMASH ###
#############

# pattern_ = "SMASH"
# 
# ### SAFRAN ###
# file_safran_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsObservesReanalyseSafran_DriasEau/DebitsComplets_CorrLocPointsLH_20231123_FormatTxt/Safran_CorrigeLH_20231128/debit_France_SAFRAN-France-2019_INRAE-SMASH_day_19760801-20190731/"
# 
# ### HISTORIQUE ###
# files_hist_ <- list.files("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/SMASH_20231128/ChroniquesBrutes_historical/", full.names = T)
# 
# ### RCP 85 ###
# files_rcp85_ <- list.files("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/SMASH_20231128/ChroniquesBrutes_rcp26/", full.names = T)
# # files_rcp85_ <- list.files("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/SMASH_20231128/ChroniquesBrutes_rcp45/", full.names = T)
# # files_rcp85_ <- list.files("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/SMASH_20231128/ChroniquesBrutes_rcp85/", full.names = T)


################
### ORCHIDEE ###
################

# pattern_ = "ORCHIDEE"
# 
# ### SAFRAN ###
# file_safran_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsObservesReanalyseSafran_DriasEau/DebitsComplets_CorrLocPointsLH_20231123_FormatTxt/Safran_CorrigeLH_20231128/debit_France_SAFRAN-France-2022_IPSL-ORCHIDEE_day_19760801-20190731/"
# 
# ### HISTORIQUE ###
# files_hist_ <- list.files("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/ORCHIDEE_20231128/ChroniquesBrutes_historical/", full.names = T)
# 
# ### RCP 85 ###
# files_rcp85_ <- list.files("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/ORCHIDEE_20231128/ChroniquesBrutes_rcp26/", full.names = T)
# files_rcp85_ <- list.files("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/ORCHIDEE_20231128/ChroniquesBrutes_rcp45/", full.names = T)
# files_rcp85_ <- list.files("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/ORCHIDEE_20231128/ChroniquesBrutes_rcp85/", full.names = T)



#############
### CTRIP ###
#############

# pattern_ = "CTRIP"
# 
# ### SAFRAN ###
# file_safran_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsObservesReanalyseSafran_DriasEau/DebitsComplets_CorrLocPointsLH_20231123_FormatTxt/Safran_CorrigeLH_20231128/debit_France_SAFRAN-France-2022_MF-ISBA-CTRIP_day_19760101-20201231/"
# 
# ### HISTORIQUE ###
# files_hist_ <- list.files("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/CTRIP_20231128/ChroniquesBrutes_historical/", full.names = T)
# 
# ### RCP 85 ###
# files_rcp85_ <- list.files("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/CTRIP_20231128/ChroniquesBrutes_rcp26/", full.names = T)
# files_rcp85_ <- list.files("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/CTRIP_20231128/ChroniquesBrutes_rcp45/", full.names = T)
# files_rcp85_ <- list.files("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/CTRIP_20231128/ChroniquesBrutes_rcp85/", full.names = T)

# for (file_hist_ in files_hist_){

### Run ###
cl <- makePSOCKcluster(detectCores()/2-1)
registerDoParallel(cores=cl)

output <- foreach(file_hist_ = files_hist_) %dopar% { #, errorhandling='pass'
  
  print(file_hist_)
  
  file_rcp85_ <- files_rcp85_[grepl(gsub("_historical_",".*",str_before_first(str_after_last(file_hist_,"/"),"_day_")),files_rcp85_)]
  
  df_saf_hist_rcp85_ <- data.frame(file = c(file_safran_, file_hist_, file_rcp85_),
                                   dateDebut = c(NA,NA,NA),
                                   dateFin = c(NA,NA,NA),
                                   # name = c(paste0(pattern_,"_20231128/ChroniquesCombinees_saf_hist_rcp85/",str_after_last(file_rcp85_,"/"),"/"),NA,NA))
                                   # name = c(paste0(pattern_,"_20231128/ChroniquesCombinees_saf_hist_rcp45/",str_after_last(file_rcp85_,"/"),"/"),NA,NA))
                                   name = c(paste0(pattern_,"_20231128/ChroniquesCombinees_saf_hist_rcp26/",str_after_last(file_rcp85_,"/"),"/"),NA,NA))
  
  
  
  ### Safran + Hist + RCP ###
  vect_ = df_saf_hist_rcp85_
  
  # Chemins des répertoires
  repertoire1 <- vect_[1,]
  repertoire2 <- vect_[2,]
  repertoire3 <- vect_[3,]
  
  # Obtention des listes de fichiers
  fichiers_repertoire1 <- list.files(repertoire1$file, pattern = "\\.txt$", full.names = TRUE)
  fichiers_repertoire2 <- list.files(repertoire2$file, pattern = "\\.txt$", full.names = TRUE)
  fichiers_repertoire3 <- list.files(repertoire3$file, pattern = "\\.txt$", full.names = TRUE)
  
  length(fichiers_repertoire1)
  length(fichiers_repertoire2)
  length(fichiers_repertoire3)
  setdiff(basename(fichiers_repertoire1), basename(fichiers_repertoire2))
  setdiff(basename(fichiers_repertoire2), basename(fichiers_repertoire1))
  setdiff(basename(fichiers_repertoire1), basename(fichiers_repertoire3))
  setdiff(basename(fichiers_repertoire3), basename(fichiers_repertoire1))
  
  # Liste pour stocker les données combinées
  donnees_combinees <- list()
  
  # Boucle pour combiner les fichiers deux à deux
  for (fichier1 in fichiers_repertoire1) {
    nom_fichier <- basename(fichier1)
    
    # Vérifier si le fichier correspondant existe dans le répertoire 2
    if (nom_fichier %in% basename(fichiers_repertoire2)) {
      fichier2 <- file.path(repertoire2$file, nom_fichier)
      
      if (nom_fichier %in% basename(fichiers_repertoire3)) {
        fichier3 <- file.path(repertoire3$file, nom_fichier)
        
        
        # Lire les fichiers correspondants et les combiner avec rbind
        data_repertoire1 <- read.table(fichier1, sep = ";", header = T)
        data_repertoire2 <- read.table(fichier2, sep = ";", header = T)
        data_repertoire3 <- read.table(fichier3, sep = ";", header = T)
        
        data_repertoire1$Type = "Safran"
        data_repertoire2$Type = "Historical"
        # data_repertoire3$Type = "rcp85"
        # data_repertoire3$Type = "rcp45"
        data_repertoire3$Type = "rcp26"
        
        if (!(is.na(repertoire1$dateDebut))){
          data_repertoire1 = data_repertoire1[which(data_repertoire1$Date >= repertoire1$dateDebut),]
        }
        if (!(is.na(repertoire1$dateFin))){
          data_repertoire1 = data_repertoire1[which(data_repertoire1$Date <= repertoire1$dateFin),]
        }
        if (!(is.na(repertoire2$dateDebut))){
          data_repertoire2 = data_repertoire2[which(data_repertoire2$Date >= repertoire2$dateDebut),]
        }
        if (!(is.na(repertoire2$dateFin))){
          data_repertoire2 = data_repertoire2[which(data_repertoire2$Date <= repertoire2$dateFin),]
        }
        if (!(is.na(repertoire3$dateDebut))){
          data_repertoire3 = data_repertoire3[which(data_repertoire3$Date >= repertoire3$dateDebut),]
        }
        if (!(is.na(repertoire3$dateFin))){
          data_repertoire3 = data_repertoire3[which(data_repertoire3$Date <= repertoire3$dateFin),]
        }
        
        donnees_combinees <- bind_rows(data_repertoire1, data_repertoire2, data_repertoire3)
        
        if (!(dir.exists(paste0("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/",
                                repertoire1$name)))){
          dir.create(paste0("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/",
                            repertoire1$name))
        }
        
        write.table(donnees_combinees,
                    paste0("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/",
                           repertoire1$name,
                           nom_fichier),
                    sep = ";", dec = ".", row.names = F)
      }
    }
  }
}

# Arreter le cluster doParallel
stopCluster(cl)
beep(1)

