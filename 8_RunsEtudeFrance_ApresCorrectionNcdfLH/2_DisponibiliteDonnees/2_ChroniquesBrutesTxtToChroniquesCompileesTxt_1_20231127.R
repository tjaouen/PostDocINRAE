
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



library(dplyr) # Chargement du package dplyr pour utiliser la fonction rbind



### SAFRAN ###
J2000_safran_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DebitsObservesReanalyseSafran_DriasEau/DebitsComplets_DebitsParModelesHydro_FormatTxt/debit_Rhone-Loire_SAFRAN-France-2022_INRAE-J2000_day_19760801-20221231/"

### HISTORIQUE ###

# HadGEM + CCLM
J2000_hist_HadGEM_CCLM_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/J2000_20231124/ChroniquesBrutes_historical/debit_Rhone-Loire_MOHC-HadGEM2-ES_historical_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_19760801-20050731/"

# EC Earth + HadREM
J2000_hist_ECEarth_HadREM_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/J2000_20231124/ChroniquesBrutes_historical/debit_Rhone-Loire_ICHEC-EC-EARTH_historical_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_19760801-20050731/"

# CNRM + Aladin
J2000_hist_CNRM_Aladin_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/J2000_20231124/ChroniquesBrutes_historical/debit_Rhone-Loire_CNRM-CERFACS-CNRM-CM5_historical_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_19760801-20050731/"

# HadGEM + Aladin
J2000_hist_HadGEM_Aladin_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/J2000_20231124/ChroniquesBrutes_historical/debit_Rhone-Loire_MOHC-HadGEM2-ES_historical_r1i1p1_CNRM-ALADIN63_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_19760801-20050731/"


### RCP 26 ###

# HadGEM + CCLM 
# Non dispo

# EC Earth + HadREM
J2000_rcp26_ECEarth_HadREM_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/J2000_20231124/ChroniquesBrutes_rcp26/debit_Rhone-Loire_ICHEC-EC-EARTH_rcp26_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-20990731/"

# CNRM + Aladin
J2000_rcp26_CNRM_Aladin_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/J2000_20231124/ChroniquesBrutes_rcp26/debit_Rhone-Loire_CNRM-CERFACS-CNRM-CM5_rcp26_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-21000731/"

# HadGEM + Aladin
# Non dispo

### RCP 45 ###

# HadGEM + CCLM 
J2000_rcp26_HadGEM_CCLM_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/J2000_20231124/ChroniquesBrutes_rcp45/debit_Rhone-Loire_MOHC-HadGEM2-ES_rcp45_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-20990731/"

# EC Earth + HadREM
# Non dispo

# CNRM + Aladin
J2000_rcp26_CNRM_Aladin_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/J2000_20231124/ChroniquesBrutes_rcp45/debit_Rhone-Loire_CNRM-CERFACS-CNRM-CM5_rcp45_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-21000731/"

# HadGEM + Aladin
# Non dispo


### RCP 85 ###

# HadGEM + CCLM
J2000_rcp85_HadGEM_CCLM_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/J2000_20231124/ChroniquesBrutes_rcp85/debit_Rhone-Loire_MOHC-HadGEM2-ES_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-20990731/"

# EC Earth + HadREM
J2000_rcp85_ECEarth_HadREM_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/J2000_20231124/ChroniquesBrutes_rcp85/debit_Rhone-Loire_ICHEC-EC-EARTH_rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-21000731/"

# CNRM + Aladin
J2000_rcp85_CNRM_Aladin_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/J2000_20231124/ChroniquesBrutes_rcp85/debit_Rhone-Loire_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-21000731/"

# HadGEM + Aladin
J2000_rcp85_HadGEM_Aladin_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/J2000_20231124/ChroniquesBrutes_rcp85/debit_Rhone-Loire_MOHC-HadGEM2-ES_rcp85_r1i1p1_CNRM-ALADIN63_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-20990731/"
# Non dispo



J2000_saf_rcp85_HadGEM_CCLM_ <- data.frame(file = c(J2000_safran_, J2000_rcp85_HadGEM_CCLM_),
                                           dateDebut = c(NA,NA),
                                           dateFin = c(NA,NA),
                                           name = c("J2000_20231124/ChroniquesCombinees_saf_rcp85/HadGEM_CCLM/",NA))
J2000_saf_rcp85_ECEarth_HadREM_ <- data.frame(file = c(J2000_safran_, J2000_rcp85_ECEarth_HadREM_),
                                              dateDebut = c(NA,NA),
                                              dateFin = c(NA,NA),
                                              name = c("J2000_20231124/ChroniquesCombinees_saf_rcp85/ECEarth_HadREM/",NA))
J2000_saf_rcp85_CNRM_Aladin_ <- data.frame(file = c(J2000_safran_, J2000_rcp85_CNRM_Aladin_),
                                           dateDebut = c(NA,NA),
                                           dateFin = c(NA,NA),
                                           name = c("J2000_20231124/ChroniquesCombinees_saf_rcp85/CNRM_Aladin/",NA))
J2000_saf_rcp85_HadGEM_Aladin_ <- data.frame(file = c(J2000_safran_, J2000_rcp85_HadGEM_Aladin_),
                                             dateDebut = c(NA,NA),
                                             dateFin = c(NA,NA),
                                             name = c("J2000_20231124/ChroniquesCombinees_saf_rcp85/HadGEM_Aladin/",NA))

J2000_hist_rcp85_HadGEM_CCLM_ <- data.frame(c(J2000_hist_HadGEM_CCLM_, J2000_rcp85_HadGEM_CCLM_),
                                            dateDebut = c(NA,NA),
                                            dateFin = c(NA,NA),
                                            name = c("J2000_20231124/ChroniquesCombinees_hist_rcp85/HadGEM_CCLM/",NA))
J2000_hist_rcp85_ECEarth_HadREM_ <- data.frame(c(J2000_hist_ECEarth_HadREM_, J2000_rcp85_ECEarth_HadREM_),
                                               dateDebut = c(NA,NA),
                                               dateFin = c(NA,NA),
                                               name = c("J2000_20231124/ChroniquesCombinees_hist_rcp85/ECEarth_HadREM/",NA))
J2000_hist_rcp85_CNRM_Aladin_ <- data.frame(c(J2000_hist_CNRM_Aladin_, J2000_rcp85_CNRM_Aladin_),
                                            dateDebut = c(NA,NA),
                                            dateFin = c(NA,NA),
                                            name = c("J2000_20231124/ChroniquesCombinees_hist_rcp85/CNRM_Aladin/",NA))
J2000_hist_rcp85_HadGEM_Aladin_ <- data.frame(c(J2000_hist_HadGEM_Aladin_, J2000_rcp85_HadGEM_Aladin_),
                                              dateDebut = c(NA,NA),
                                              dateFin = c(NA,NA),
                                              name = c("J2000_20231124/ChroniquesCombinees_hist_rcp85/HadGEM_Aladin/",NA))

J2000_saf_hist_rcp85_HadGEM_CCLM_ <- data.frame(c(J2000_safran_, J2000_hist_HadGEM_CCLM_, J2000_rcp85_HadGEM_CCLM_),
                                                dateDebut = c(NA,NA,NA),
                                                dateFin = c(NA,NA,NA),
                                                name = c("J2000_20231124/ChroniquesCombinees_saf_hist_rcp85/HadGEM_CCLM/",NA,NA))
J2000_saf_hist_rcp85_ECEarth_HadREM_ <- data.frame(c(J2000_safran_, J2000_hist_ECEarth_HadREM_, J2000_rcp85_ECEarth_HadREM_),
                                                   dateDebut = c(NA,NA,NA),
                                                   dateFin = c(NA,NA,NA),
                                                   name = c("J2000_20231124/ChroniquesCombinees_saf_hist_rcp85/ECEarth_HadREM/",NA,NA))
J2000_saf_hist_rcp85_CNRM_Aladin_ <- data.frame(c(J2000_safran_, J2000_hist_CNRM_Aladin_, J2000_rcp85_CNRM_Aladin_),
                                                dateDebut = c(NA,NA,NA),
                                                dateFin = c(NA,NA,NA),
                                                name = c("J2000_20231124/ChroniquesCombinees_saf_hist_rcp85/CNRM_Aladin/",NA,NA))
J2000_saf_hist_rcp85_HadGEM_Aladin_ <- data.frame(c(J2000_safran_, J2000_hist_HadGEM_Aladin_, J2000_rcp85_HadGEM_Aladin_),
                                                  dateDebut = c(NA,NA,NA),
                                                  dateFin = c(NA,NA,NA),
                                                  name = c("J2000_20231124/ChroniquesCombinees_saf_hist_rcp85/HadGEM_Aladin/",NA,NA))


vect_ = J2000_saf_rcp85_HadGEM_CCLM_

# Chemins des répertoires
repertoire1 <- vect_[1,]
repertoire2 <- vect_[2,]

# Obtention des listes de fichiers
fichiers_repertoire1 <- list.files(repertoire1$file, pattern = "\\.txt$", full.names = TRUE)
fichiers_repertoire2 <- list.files(repertoire2$file, pattern = "\\.txt$", full.names = TRUE)

length(fichiers_repertoire1)
length(fichiers_repertoire2)
setdiff(basename(fichiers_repertoire1), basename(fichiers_repertoire2))
setdiff(basename(fichiers_repertoire2), basename(fichiers_repertoire1))

# Liste pour stocker les données combinées
donnees_combinees <- list()

# Boucle pour combiner les fichiers deux à deux
for (fichier1 in fichiers_repertoire1) {
  nom_fichier <- basename(fichier1)
  
  # Vérifier si le fichier correspondant existe dans le répertoire 2
  if (nom_fichier %in% basename(fichiers_repertoire2)) {
    fichier2 <- file.path(repertoire2$file, nom_fichier)
    
    # Lire les fichiers correspondants et les combiner avec rbind
    data_repertoire1 <- read.table(fichier1, sep = ";", header = T)
    data_repertoire2 <- read.table(fichier2, sep = ";", header = T)
    
    if (!(is.na(repertoire1$dateDebut) & is.na(repertoire1$dateFin))){
      data_repertoire1 = data_repertoire1[which((data_repertoire1$Date >= repertoire1$dateDebut) & 
                                                  (data_repertoire1$Date <= repertoire1$dateFin)),]
    }
    if (!(is.na(repertoire2$dateDebut) & is.na(repertoire2$dateFin))){
      data_repertoire2 = data_repertoire2[which((data_repertoire2$Date >= repertoire2$dateDebut) & 
                                                  (data_repertoire2$Date <= repertoire2$dateFin)),]
    }
    
    donnees_combinees <- bind_rows(data_repertoire1, data_repertoire2)
    
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

