
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

#############
### J2000 ###
#############

# pattern_ = "J2000"
# 
# ### SAFRAN ###
# file_safran_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsObservesReanalyseSafran_DriasEau/DebitsComplets_CorrLocPointsLH_20231123_FormatTxt/Safran_CorrigeLH_20231128/debit_Rhone-Loire_SAFRAN-France-2022_INRAE-J2000_day_19760801-20221231/"
# 
# ### HISTORIQUE ###
# # HadGEM + CCLM
# file_hist_HadGEM_CCLM_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/J2000_20231128/ChroniquesBrutes_historical/debit_Rhone-Loire_MOHC-HadGEM2-ES_historical_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_19760801-20050731/"
# # EC Earth + HadREM
# file_hist_ECEarth_HadREM_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/J2000_20231128/ChroniquesBrutes_historical/debit_Rhone-Loire_ICHEC-EC-EARTH_historical_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_19760801-20050731/"
# # CNRM + Aladin
# file_hist_CNRM_Aladin_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/J2000_20231128/ChroniquesBrutes_historical/debit_Rhone-Loire_CNRM-CERFACS-CNRM-CM5_historical_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_19760801-20050731/"
# # HadGEM + Aladin
# file_hist_HadGEM_Aladin_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/J2000_20231128/ChroniquesBrutes_historical/debit_Rhone-Loire_MOHC-HadGEM2-ES_historical_r1i1p1_CNRM-ALADIN63_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_19760801-20050731/"
# 
# ### RCP 85 ###
# # HadGEM + CCLM
# file_rcp85_HadGEM_CCLM_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/J2000_20231128/ChroniquesBrutes_rcp85/debit_Rhone-Loire_MOHC-HadGEM2-ES_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-20990731/"
# # EC Earth + HadREM
# file_rcp85_ECEarth_HadREM_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/J2000_20231128/ChroniquesBrutes_rcp85/debit_Rhone-Loire_ICHEC-EC-EARTH_rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-21000731/"
# # CNRM + Aladin
# file_rcp85_CNRM_Aladin_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/J2000_20231128/ChroniquesBrutes_rcp85/debit_Rhone-Loire_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-21000731/"
# # HadGEM + Aladin
# file_rcp85_HadGEM_Aladin_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/J2000_20231128/ChroniquesBrutes_rcp85/debit_Rhone-Loire_MOHC-HadGEM2-ES_rcp85_r1i1p1_CNRM-ALADIN63_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-20990731/"


############
### GRSD ###
############

# pattern_ = "GRSD"
# 
# ### SAFRAN ###
# file_safran_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsObservesReanalyseSafran_DriasEau/DebitsComplets_CorrLocPointsLH_20231123_FormatTxt/Safran_CorrigeLH_20231128/debit_France_SAFRAN-France-2022_INRAE-GRSD_day_19760801-20190731/"
# 
# ### HISTORIQUE ###
# # HadGEM + CCLM
# file_hist_HadGEM_CCLM_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/GRSD_20231128/ChroniquesBrutes_historical/debit_France_MOHC-HadGEM2-ES_historical_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_19510801-20050731/"
# # EC Earth + HadREM
# file_hist_ECEarth_HadREM_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/GRSD_20231128/ChroniquesBrutes_historical/debit_France_ICHEC-EC-EARTH_historical_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_19530801-20050731/"
# # CNRM + Aladin
# file_hist_CNRM_Aladin_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/GRSD_20231128/ChroniquesBrutes_historical/debit_France_CNRM-CERFACS-CNRM-CM5_historical_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_19520801-20050731/"
# # HadGEM + Aladin
# file_hist_HadGEM_Aladin_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/GRSD_20231128/ChroniquesBrutes_historical/debit_France_MOHC-HadGEM2-ES_historical_r1i1p1_CNRM-ALADIN63_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_19510801-20050731/"
# 
# ### RCP 85 ###
# # HadGEM + CCLM
# file_rcp85_HadGEM_CCLM_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/GRSD_20231128/ChroniquesBrutes_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-20990731/"
# # EC Earth + HadREM
# file_rcp85_ECEarth_HadREM_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/GRSD_20231128/ChroniquesBrutes_rcp85/debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/"
# # CNRM + Aladin
# file_rcp85_CNRM_Aladin_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/GRSD_20231128/ChroniquesBrutes_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/"
# # HadGEM + Aladin
# file_rcp85_HadGEM_Aladin_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/GRSD_20231128/ChroniquesBrutes_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CNRM-ALADIN63_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-20990731/"


#############
### SMASH ###
#############

# pattern_ = "SMASH"
# 
# ### SAFRAN ###
# file_safran_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsObservesReanalyseSafran_DriasEau/DebitsComplets_CorrLocPointsLH_20231123_FormatTxt/Safran_CorrigeLH_20231128/debit_France_SAFRAN-France-2019_INRAE-SMASH_day_19760801-20190731/"
# 
# ### HISTORIQUE ###
# # HadGEM + CCLM
# file_hist_HadGEM_CCLM_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/SMASH_20231128/ChroniquesBrutes_historical/debit_France_MOHC-HadGEM2-ES_historical_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_19500101-20051231/"
# # EC Earth + HadREM
# file_hist_ECEarth_HadREM_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/SMASH_20231128/ChroniquesBrutes_historical/debit_France_ICHEC-EC-EARTH_historical_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_19520101-20051231/"
# # CNRM + Aladin
# file_hist_CNRM_Aladin_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/SMASH_20231128/ChroniquesBrutes_historical/debit_France_CNRM-CERFACS-CNRM-CM5_historical_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_19510101-20051231/"
# # HadGEM + Aladin
# file_hist_HadGEM_Aladin_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/SMASH_20231128/ChroniquesBrutes_historical/debit_France_MOHC-HadGEM2-ES_historical_r1i1p1_CNRM-ALADIN63_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_19500101-20051231/"
# 
# ### RCP 85 ###
# # HadGEM + CCLM
# file_rcp85_HadGEM_CCLM_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/SMASH_20231128/ChroniquesBrutes_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_20060101-20991231/"
# # EC Earth + HadREM
# file_rcp85_ECEarth_HadREM_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/SMASH_20231128/ChroniquesBrutes_rcp85/debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_20060101-21001231/"
# # CNRM + Aladin
# file_rcp85_CNRM_Aladin_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/SMASH_20231128/ChroniquesBrutes_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_20060101-21001231/"
# # HadGEM + Aladin
# file_rcp85_HadGEM_Aladin_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/SMASH_20231128/ChroniquesBrutes_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CNRM-ALADIN63_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_20060101-20991231/"


################
### ORCHIDEE ###
################

# pattern_ = "ORCHIDEE"
# 
# ### SAFRAN ###
# file_safran_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsObservesReanalyseSafran_DriasEau/DebitsComplets_CorrLocPointsLH_20231123_FormatTxt/Safran_CorrigeLH_20231128/debit_France_SAFRAN-France-2022_IPSL-ORCHIDEE_day_19760801-20190731/"
# 
# ### HISTORIQUE ###
# # HadGEM + CCLM
# file_hist_HadGEM_CCLM_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/ORCHIDEE_20231128/ChroniquesBrutes_historical/debit_France_MOHC-HadGEM2-ES_historical_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_19500801-20050731/"
# # EC Earth + HadREM
# file_hist_ECEarth_HadREM_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/ORCHIDEE_20231128/ChroniquesBrutes_historical/debit_France_ICHEC-EC-EARTH_historical_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_19520801-20050731/"
# # CNRM + Aladin
# file_hist_CNRM_Aladin_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/ORCHIDEE_20231128/ChroniquesBrutes_historical/debit_France_CNRM-CERFACS-CNRM-CM5_historical_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_19510801-20050731/"
# # HadGEM + Aladin
# file_hist_HadGEM_Aladin_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/ORCHIDEE_20231128/ChroniquesBrutes_historical/debit_France_MOHC-HadGEM2-ES_historical_r1i1p1_CNRM-ALADIN63_v2_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_19500801-20050731/"
# 
# ### RCP 85 ###
# # HadGEM + CCLM
# file_rcp85_HadGEM_CCLM_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/ORCHIDEE_20231128/ChroniquesBrutes_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_20050801-20990731/"
# # EC Earth + HadREM
# file_rcp85_ECEarth_HadREM_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/ORCHIDEE_20231128/ChroniquesBrutes_rcp85/debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_20050801-21000731/"
# # CNRM + Aladin
# file_rcp85_CNRM_Aladin_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/ORCHIDEE_20231128/ChroniquesBrutes_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_20050801-21000731/"
# # HadGEM + Aladin
# file_rcp85_HadGEM_Aladin_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/ORCHIDEE_20231128/ChroniquesBrutes_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CNRM-ALADIN63_v2_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_20050801-20990731/"



#############
### CTRIP ###
#############

pattern_ = "CTRIP"

### SAFRAN ###
file_safran_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsObservesReanalyseSafran_DriasEau/DebitsComplets_CorrLocPointsLH_20231123_FormatTxt/Safran_CorrigeLH_20231128/debit_France_SAFRAN-France-2022_MF-ISBA-CTRIP_day_19760101-20201231/"

### HISTORIQUE ###
# HadGEM + CCLM
file_hist_HadGEM_CCLM_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/CTRIP_20231128/ChroniquesBrutes_historical/debit_France_MOHC-HadGEM2-ES_historical_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_19510801-20050731/"
# EC Earth + HadREM
file_hist_ECEarth_HadREM_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/CTRIP_20231128/ChroniquesBrutes_historical/debit_France_ICHEC-EC-EARTH_historical_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_19520801-20050731/"
# CNRM + Aladin
file_hist_CNRM_Aladin_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/CTRIP_20231128/ChroniquesBrutes_historical/debit_France_CNRM-CERFACS-CNRM-CM5_historical_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_19510801-20050731/"
# HadGEM + Aladin
file_hist_HadGEM_Aladin_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/CTRIP_20231128/ChroniquesBrutes_historical/debit_France_MOHC-HadGEM2-ES_historical_r1i1p1_CNRM-ALADIN63_v2_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_19510801-20050731/"

### RCP 85 ###
# HadGEM + CCLM
file_rcp85_HadGEM_CCLM_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/CTRIP_20231128/ChroniquesBrutes_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-20990731/"
# EC Earth + HadREM
file_rcp85_ECEarth_HadREM_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/CTRIP_20231128/ChroniquesBrutes_rcp85/debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-21000731/"
# CNRM + Aladin
file_rcp85_CNRM_Aladin_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/CTRIP_20231128/ChroniquesBrutes_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-21000731/"
# HadGEM + Aladin
file_rcp85_HadGEM_Aladin_ <- "/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/CTRIP_20231128/ChroniquesBrutes_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CNRM-ALADIN63_v2_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-20990731/"




df_saf_rcp85_HadGEM_CCLM_ <- data.frame(file = c(file_safran_, file_rcp85_HadGEM_CCLM_),
                                        dateDebut = c(NA,NA),
                                        dateFin = c(NA,NA),
                                        name = c(paste0(pattern_,"_20231128/ChroniquesCombinees_saf_rcp85/",str_after_last(str_before_last(file_rcp85_HadGEM_CCLM_,"/"),"/"),"/"),NA))
df_saf_rcp85_ECEarth_HadREM_ <- data.frame(file = c(file_safran_, file_rcp85_ECEarth_HadREM_),
                                           dateDebut = c(NA,NA),
                                           dateFin = c(NA,NA),
                                           name = c(paste0(pattern_,"_20231128/ChroniquesCombinees_saf_rcp85/",str_after_last(str_before_last(file_rcp85_ECEarth_HadREM_,"/"),"/"),"/"),NA))
df_saf_rcp85_CNRM_Aladin_ <- data.frame(file = c(file_safran_, file_rcp85_CNRM_Aladin_),
                                        dateDebut = c(NA,NA),
                                        dateFin = c(NA,NA),
                                        name = c(paste0(pattern_,"_20231128/ChroniquesCombinees_saf_rcp85/",str_after_last(str_before_last(file_rcp85_CNRM_Aladin_,"/"),"/"),"/"),NA))
df_saf_rcp85_HadGEM_Aladin_ <- data.frame(file = c(file_safran_, file_rcp85_HadGEM_Aladin_),
                                          dateDebut = c(NA,NA),
                                          dateFin = c(NA,NA),
                                          name = c(paste0(pattern_,"_20231128/ChroniquesCombinees_saf_rcp85/",str_after_last(str_before_last(file_rcp85_HadGEM_Aladin_,"/"),"/"),"/"),NA))

df_saf_hist_rcp85_HadGEM_CCLM_ <- data.frame(file = c(file_safran_, file_hist_HadGEM_CCLM_, file_rcp85_HadGEM_CCLM_),
                                             dateDebut = c(NA,NA,NA),
                                             dateFin = c(NA,NA,NA),
                                             name = c(paste0(pattern_,"_20231128/ChroniquesCombinees_saf_hist_rcp85/",str_after_last(str_before_last(file_rcp85_HadGEM_CCLM_,"/"),"/"),"/"),NA,NA))
df_saf_hist_rcp85_ECEarth_HadREM_ <- data.frame(file = c(file_safran_, file_hist_ECEarth_HadREM_, file_rcp85_ECEarth_HadREM_),
                                                dateDebut = c(NA,NA,NA),
                                                dateFin = c(NA,NA,NA),
                                                name = c(paste0(pattern_,"_20231128/ChroniquesCombinees_saf_hist_rcp85/",str_after_last(str_before_last(file_rcp85_ECEarth_HadREM_,"/"),"/"),"/"),NA,NA))
df_saf_hist_rcp85_CNRM_Aladin_ <- data.frame(file = c(file_safran_, file_hist_CNRM_Aladin_, file_rcp85_CNRM_Aladin_),
                                             dateDebut = c(NA,NA,NA),
                                             dateFin = c(NA,NA,NA),
                                             name = c(paste0(pattern_,"_20231128/ChroniquesCombinees_saf_hist_rcp85/",str_after_last(str_before_last(file_rcp85_CNRM_Aladin_,"/"),"/"),"/"),NA,NA))
df_saf_hist_rcp85_HadGEM_Aladin_ <- data.frame(file = c(file_safran_, file_hist_HadGEM_Aladin_, file_rcp85_HadGEM_Aladin_),
                                               dateDebut = c(NA,NA,NA),
                                               dateFin = c(NA,NA,NA),
                                               name = c(paste0(pattern_,"_20231128/ChroniquesCombinees_saf_hist_rcp85/",str_after_last(str_before_last(file_rcp85_HadGEM_Aladin_,"/"),"/"),"/"),NA,NA))



# df_saf_rcp85_HadGEM_CCLM_ <- data.frame(file = c(file_safran_, file_rcp85_HadGEM_CCLM_),
#                                            dateDebut = c(NA,"2023-01-01"),
#                                            dateFin = c(NA,NA),
#                                            name = c(paste0(pattern_,"_20231128/ChroniquesCombinees_saf_rcp85/HadGEM_CCLM/"),NA))
# df_saf_rcp85_ECEarth_HadREM_ <- data.frame(file = c(file_safran_, file_rcp85_ECEarth_HadREM_),
#                                               dateDebut = c(NA,"2023-01-01"),
#                                               dateFin = c(NA,NA),
#                                               name = c(paste0(pattern_,"_20231128/ChroniquesCombinees_saf_rcp85/ECEarth_HadREM/"),NA))
# df_saf_rcp85_CNRM_Aladin_ <- data.frame(file = c(file_safran_, file_rcp85_CNRM_Aladin_),
#                                            dateDebut = c(NA,"2023-01-01"),
#                                            dateFin = c(NA,NA),
#                                            name = c(paste0(pattern_,"_20231128/ChroniquesCombinees_saf_rcp85/CNRM_Aladin/"),NA))
# df_saf_rcp85_HadGEM_Aladin_ <- data.frame(file = c(file_safran_, file_rcp85_HadGEM_Aladin_),
#                                              dateDebut = c(NA,"2023-01-01"),
#                                              dateFin = c(NA,NA),
#                                              name = c(paste0(pattern_,"_20231128/ChroniquesCombinees_saf_rcp85/HadGEM_Aladin/"),NA))
# 
# df_saf_hist_rcp85_HadGEM_CCLM_ <- data.frame(file = c(file_safran_, file_hist_HadGEM_CCLM_, file_rcp85_HadGEM_CCLM_),
#                                              dateDebut = c(NA,NA,"2023-01-01"),
#                                              dateFin = c(NA,"2011-12-31",NA),
#                                              name = c(paste0(pattern_,"_20231128/ChroniquesCombinees_saf_hist_rcp85/HadGEM_CCLM/"),NA,NA))
# df_saf_hist_rcp85_ECEarth_HadREM_ <- data.frame(file = c(file_safran_, file_hist_ECEarth_HadREM_, file_rcp85_ECEarth_HadREM_),
#                                                 dateDebut = c(NA,NA,"2023-01-01"),
#                                                 dateFin = c(NA,"2011-12-31",NA),
#                                                 name = c(paste0(pattern_,"_20231128/ChroniquesCombinees_saf_hist_rcp85/ECEarth_HadREM/"),NA,NA))
# df_saf_hist_rcp85_CNRM_Aladin_ <- data.frame(file = c(file_safran_, file_hist_CNRM_Aladin_, file_rcp85_CNRM_Aladin_),
#                                              dateDebut = c(NA,NA,"2023-01-01"),
#                                              dateFin = c(NA,"2011-12-31",NA),
#                                              name = c(paste0(pattern_,"_20231128/ChroniquesCombinees_saf_hist_rcp85/CNRM_Aladin/"),NA,NA))
# df_saf_hist_rcp85_HadGEM_Aladin_ <- data.frame(file = c(file_safran_, file_hist_HadGEM_Aladin_, file_rcp85_HadGEM_Aladin_),
#                                                dateDebut = c(NA,NA,"2023-01-01"),
#                                                dateFin = c(NA,"2011-12-31",NA),
#                                                name = c(paste0(pattern_,"_20231128/ChroniquesCombinees_saf_hist_rcp85/HadGEM_Aladin/"),NA,NA))


### Safran + RCP ###
# vect_ = df_saf_rcp85_HadGEM_CCLM_
# vect_ = df_saf_rcp85_ECEarth_HadREM_
# vect_ = df_saf_rcp85_CNRM_Aladin_
# vect_ = df_saf_rcp85_HadGEM_Aladin_

# # Chemins des répertoires
# repertoire1 <- vect_[1,]
# repertoire2 <- vect_[2,]
# 
# # Obtention des listes de fichiers
# fichiers_repertoire1 <- list.files(repertoire1$file, pattern = "\\.txt$", full.names = TRUE)
# fichiers_repertoire2 <- list.files(repertoire2$file, pattern = "\\.txt$", full.names = TRUE)
# 
# length(fichiers_repertoire1)
# length(fichiers_repertoire2)
# setdiff(basename(fichiers_repertoire1), basename(fichiers_repertoire2))
# setdiff(basename(fichiers_repertoire2), basename(fichiers_repertoire1))
# 
# # Liste pour stocker les données combinées
# donnees_combinees <- list()
# 
# # Boucle pour combiner les fichiers deux à deux
# for (fichier1 in fichiers_repertoire1) {
#   nom_fichier <- basename(fichier1)
# 
#   # Vérifier si le fichier correspondant existe dans le répertoire 2
#   if (nom_fichier %in% basename(fichiers_repertoire2)) {
#     fichier2 <- file.path(repertoire2$file, nom_fichier)
# 
#     # Lire les fichiers correspondants et les combiner avec rbind
#     data_repertoire1 <- read.table(fichier1, sep = ";", header = T)
#     data_repertoire2 <- read.table(fichier2, sep = ";", header = T)
# 
#     data_repertoire1$Type = "Safran"
#     data_repertoire2$Type = "rcp85"
# 
#     if (!(is.na(repertoire1$dateDebut))){
#       data_repertoire1 = data_repertoire1[which(data_repertoire1$Date >= repertoire1$dateDebut),]
#     }
#     if (!(is.na(repertoire1$dateFin))){
#       data_repertoire1 = data_repertoire1[which(data_repertoire1$Date <= repertoire1$dateFin),]
#     }
#     if (!(is.na(repertoire2$dateDebut))){
#       data_repertoire2 = data_repertoire2[which(data_repertoire2$Date >= repertoire2$dateDebut),]
#     }
#     if (!(is.na(repertoire2$dateFin))){
#       data_repertoire2 = data_repertoire2[which(data_repertoire2$Date <= repertoire2$dateFin),]
#     }
# 
#     donnees_combinees <- bind_rows(data_repertoire1, data_repertoire2)
# 
#     if (!(dir.exists(paste0("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/",
#                             repertoire1$name)))){
#       dir.create(paste0("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/",
#                         repertoire1$name))
#     }
# 
#     write.table(donnees_combinees,
#                 paste0("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/",
#                        repertoire1$name,
#                        nom_fichier),
#                 sep = ";", dec = ".", row.names = F)
#   }
# }



### Safran + Hist + RCP ###
# vect_ = df_saf_hist_rcp85_HadGEM_CCLM_
# vect_ = df_saf_hist_rcp85_ECEarth_HadREM_
# vect_ = df_saf_hist_rcp85_CNRM_Aladin_
vect_ = df_saf_hist_rcp85_HadGEM_Aladin_

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
      data_repertoire3$Type = "rcp85"

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

