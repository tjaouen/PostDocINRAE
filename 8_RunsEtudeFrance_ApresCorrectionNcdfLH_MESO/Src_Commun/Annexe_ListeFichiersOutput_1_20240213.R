library(strex)

control_files <- function(list_files){
  list_files_str_ = str_before_first(str_after_first(list_files, "Weight_"),".csv")
  combined_data <- expand.grid(Year = 2012:2022, HER_param = HER_param_)
  
  # Utiliser paste0 pour combiner les éléments
  combined_strings <- paste0(combined_data$Year, "_HER", combined_data$HER_param)
  combined_strings[which(!(combined_strings %in% list_files_str_))]
}


### CTRIP ###
# list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85_save/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-21000731/tmp/")
# 1 :  [1] "2012_HER10"    "2013_HER10"    "2014_HER10"    "2015_HER10"    "2016_HER10"    "2017_HER10"    "2018_HER10"    "2019_HER10"    "2020_HER10"    "2021_HER10"    "2022_HER10"

# list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85_save/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_MOHC-HadREM3-GA7-05_v3_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-21000731/tmp/")
# 2 :  [1] "2012_HER10"    "2013_HER10"    "2014_HER10"    "2015_HER10"    "2016_HER10"    "2017_HER10"    "2018_HER10"    "2019_HER10"    "2020_HER10"    "2021_HER10"    "2022_HER10"

# list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85_save/ChroniquesCombinees_saf_hist_rcp85/debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_KNMI-RACMO22E_v2_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-21000731/tmp/")
# 3 :  [1] "2012_HER10"    "2013_HER10"    "2014_HER10"    "2015_HER10"    "2016_HER10"    "2017_HER10"    "2018_HER10"    "2019_HER10"    "2020_HER10"    "2021_HER10"    "2022_HER10"

# list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85_save/ChroniquesCombinees_saf_hist_rcp85/debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-21000731/tmp/")
# 4 :  [1] "2012_HER10"    "2013_HER10"    "2014_HER10"    "2015_HER10"    "2016_HER10"    "2017_HER10"    "2018_HER10"    "2019_HER10"    "2020_HER10"    "2021_HER10"    "2022_HER10"

# list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85_save/ChroniquesCombinees_saf_hist_rcp85/debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_SMHI-RCA4_v2_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-21000731/tmp/")
# 5 :  [1] "2012_HER10"    "2013_HER10"    "2014_HER10"    "2015_HER10"    "2016_HER10"    "2017_HER10"    "2018_HER10"    "2019_HER10"    "2020_HER10"    "2021_HER10"    "2022_HER10"

# list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85_save/ChroniquesCombinees_saf_hist_rcp85/debit_France_IPSL-IPSL-CM5A-MR_rcp85_r1i1p1_DMI-HIRHAM5_v2_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-21000731/tmp/")
# 6 :  [1] "2012_HER10"    "2013_HER10"    "2014_HER10"    "2015_HER10"    "2016_HER10"    "2017_HER10"    "2018_HER10"    "2019_HER10"    "2020_HER10"    "2021_HER10"    "2022_HER10"

# list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85_save/ChroniquesCombinees_saf_hist_rcp85/debit_France_IPSL-IPSL-CM5A-MR_rcp85_r1i1p1_SMHI-RCA4_v2_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-21000731/tmp/")
# 7 :  [1] "2012_HER10"    "2013_HER10"    "2014_HER10"    "2015_HER10"    "2016_HER10"    "2017_HER10"    "2018_HER10"    "2019_HER10"    "2020_HER10"    "2021_HER10"    "2022_HER10"

# list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85_save/ChroniquesCombinees_saf_hist_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-20990731/tmp/")
# 8 :  [1] "2012_HER10"    "2013_HER10"    "2014_HER10"    "2015_HER10"    "2016_HER10"    "2017_HER10"    "2018_HER10"    "2019_HER10"    "2020_HER10"    "2021_HER10"    "2022_HER10"

# list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85_save/ChroniquesCombinees_saf_hist_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CNRM-ALADIN63_v2_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-20990731/tmp/")
# 9 :  [1] "2012_HER10"    "2013_HER10"    "2014_HER10"    "2015_HER10"    "2016_HER10"    "2017_HER10"    "2018_HER10"    "2019_HER10"    "2020_HER10"    "2021_HER10"    "2022_HER10"

# list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85_save/ChroniquesCombinees_saf_hist_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_ICTP-RegCM4-6_v2_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-20990731/tmp/")
# 10 :  [1] "2012_HER10"    "2013_HER10"    "2014_HER10"    "2015_HER10"    "2016_HER10"    "2017_HER10"    "2018_HER10"    "2019_HER10"    "2020_HER10"    "2021_HER10"    "2022_HER10"

# list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85_save/ChroniquesCombinees_saf_hist_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-20990731/tmp/")
# 11 :  [1] "2012_HER10"    "2013_HER10"    "2014_HER10"    "2015_HER10"    "2016_HER10"    "2017_HER10"    "2018_HER10"    "2019_HER10"    "2020_HER10"    "2021_HER10"    "2022_HER10"

# list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85_save/ChroniquesCombinees_saf_hist_rcp85/debit_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-21000731/tmp/")
# 12 :  [1] "2012_HER10"    "2013_HER10"    "2014_HER10"    "2015_HER10"    "2016_HER10"    "2017_HER10"    "2018_HER10"    "2019_HER10"    "2020_HER10"    "2021_HER10"    "2022_HER10"

# list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85_save/ChroniquesCombinees_saf_hist_rcp85/debit_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_ICTP-RegCM4-6_v2_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-21000731/tmp/")
# 13 :  [1] "2012_HER10"    "2013_HER10"    "2014_HER10"    "2015_HER10"    "2016_HER10"    "2017_HER10"    "2018_HER10"    "2019_HER10"    "2020_HER10"    "2021_HER10"    "2022_HER10"

# list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85_save/ChroniquesCombinees_saf_hist_rcp85/debit_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_MPI-CSC-REMO2009_v2_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-21000731/tmp/")
# 14 :  [1] "2012_HER10"    "2013_HER10"    "2014_HER10"    "2015_HER10"    "2016_HER10"    "2017_HER10"    "2018_HER10"    "2019_HER10"    "2020_HER10"    "2021_HER10"    "2022_HER10"

# list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85_save/ChroniquesCombinees_saf_hist_rcp85/debit_France_NCC-NorESM1-M_rcp85_r1i1p1_DMI-HIRHAM5_v4_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-21000731/tmp/")
# 15 :  [1] "2012_HER10"    "2013_HER10"    "2014_HER10"    "2015_HER10"    "2016_HER10"    "2017_HER10"    "2018_HER10"    "2019_HER10"    "2020_HER10"    "2021_HER10"    "2022_HER10"

# list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85_save/ChroniquesCombinees_saf_hist_rcp85/debit_France_NCC-NorESM1-M_rcp85_r1i1p1_GERICS-REMO2015_v2_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-21000731/tmp/")
# 16 :  [1] "2012_HER10"    "2013_HER10"    "2014_HER10"    "2015_HER10"    "2016_HER10"    "2017_HER10"    "2018_HER10"    "2019_HER10"    "2020_HER10"    "2021_HER10"    "2022_HER10"

# list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85_save/ChroniquesCombinees_saf_hist_rcp85/debit_France_NCC-NorESM1-M_rcp85_r1i1p1_IPSL-WRF381P_v2_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-21000731/tmp/")
# 17 :  [1] "2012_HER10"    "2013_HER10"    "2014_HER10"    "2015_HER10"    "2016_HER10"    "2017_HER10"    "2018_HER10"    "2019_HER10"    "2020_HER10"    "2021_HER10"    "2022_HER10"




### GRSD ###
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_20050801-21000731/tmp/")
control_files(list_files) # 1 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/tmp/")
control_files(list_files) # 2 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_MOHC-HadREM3-GA7-05_v3_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_20050801-21000731/tmp/")
control_files(list_files) # 3 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_MOHC-HadREM3-GA7-05_v3_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/tmp/")
control_files(list_files) # 4 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_KNMI-RACMO22E_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_20050801-21000731/tmp/")
control_files(list_files) # 5 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_KNMI-RACMO22E_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/tmp/")
control_files(list_files) # 6 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_20050801-21000731/tmp/")
control_files(list_files) # 7 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/tmp/")
control_files(list_files) # 8 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_SMHI-RCA4_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_20050801-21000731/tmp/")
control_files(list_files) # 9 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_SMHI-RCA4_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/tmp/")
control_files(list_files) # 10 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_IPSL-IPSL-CM5A-MR_rcp85_r1i1p1_DMI-HIRHAM5_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_20050801-21000731/tmp/")
control_files(list_files) # 11 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_IPSL-IPSL-CM5A-MR_rcp85_r1i1p1_DMI-HIRHAM5_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/tmp/")
control_files(list_files) # 12 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_IPSL-IPSL-CM5A-MR_rcp85_r1i1p1_SMHI-RCA4_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_20050801-21000731/tmp/")
control_files(list_files) # 13 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_IPSL-IPSL-CM5A-MR_rcp85_r1i1p1_SMHI-RCA4_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/tmp/")
control_files(list_files) # 14 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_20050801-20990731/tmp/")
control_files(list_files) # 15 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-20990731/tmp/")
control_files(list_files) # 16 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CNRM-ALADIN63_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_20050801-20990731/tmp/")
control_files(list_files) # 17 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CNRM-ALADIN63_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-20990731/tmp/")
control_files(list_files) # 18 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_ICTP-RegCM4-6_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_20050801-20990731/tmp/")
control_files(list_files) # 19 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_ICTP-RegCM4-6_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-20990731/tmp/")
control_files(list_files) # 20 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_MOHC-HadREM3-GA7-05_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_20050801-20990731/tmp/")
control_files(list_files) # 21 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-20990731/tmp/")
control_files(list_files) # 22 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_20050801-21000731/tmp/")
control_files(list_files) # 23 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/tmp/")
control_files(list_files) # 24 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_ICTP-RegCM4-6_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_20050801-21000731/tmp/")
control_files(list_files) # 25 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_ICTP-RegCM4-6_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/tmp/")
control_files(list_files) # 26 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_MPI-CSC-REMO2009_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_20050801-21000731/tmp/")
control_files(list_files) # 27 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_MPI-CSC-REMO2009_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/tmp/")
control_files(list_files) # 28 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_NCC-NorESM1-M_rcp85_r1i1p1_DMI-HIRHAM5_v4_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_20050801-21000731/tmp/")
control_files(list_files) # 29 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_NCC-NorESM1-M_rcp85_r1i1p1_DMI-HIRHAM5_v4_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/tmp/")
control_files(list_files) # 30 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_NCC-NorESM1-M_rcp85_r1i1p1_GERICS-REMO2015_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_20050801-21000731/tmp/")
control_files(list_files) # 31 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_NCC-NorESM1-M_rcp85_r1i1p1_GERICS-REMO2015_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/tmp/")
control_files(list_files) # 32 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_NCC-NorESM1-M_rcp85_r1i1p1_IPSL-WRF381P_v2_LSCE-IPSL_CDFt-L-1V-0L_SAFRAN-France-2016_INRAE-GRSD_day_20050801-21000731/tmp/")
control_files(list_files) # 33 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_NCC-NorESM1-M_rcp85_r1i1p1_IPSL-WRF381P_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/tmp/")
control_files(list_files) # 34 OK



### ORCHIDEE ###
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_20050801-21000731/tmp/")
control_files(list_files) # 1 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_MOHC-HadREM3-GA7-05_v3_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_20050801-21000731/tmp/")
control_files(list_files) # 2 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_KNMI-RACMO22E_v2_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_20050801-21000731/tmp/")
control_files(list_files) # 3 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_20050801-21000731/tmp/")
control_files(list_files) # 4 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_SMHI-RCA4_v2_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_20050801-21000731/tmp/")
control_files(list_files) # 5 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_IPSL-IPSL-CM5A-MR_rcp85_r1i1p1_DMI-HIRHAM5_v2_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_20050801-21000731/tmp/")
control_files(list_files)
# [1] "2012_HER10"    "2013_HER10"    "2014_HER10"    "2015_HER10"    "2016_HER10"    "2017_HER10"    "2018_HER10"    "2019_HER10"    "2020_HER10"    "2021_HER10"    "2022_HER10"
# " 2012_HER37054" "2013_HER37054" "2014_HER37054" "2015_HER37054" "2016_HER37054" "2017_HER37054" "2018_HER37054" "2019_HER37054" "2020_HER37054" "2021_HER37054" "2022_HER37054"

list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_IPSL-IPSL-CM5A-MR_rcp85_r1i1p1_SMHI-RCA4_v2_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_20050801-21000731/tmp/")
control_files(list_files) # 7 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_20050801-20990731/tmp/")
control_files(list_files) # 8 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CNRM-ALADIN63_v2_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_20050801-20990731/tmp/")
control_files(list_files) # 9 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_ICTP-RegCM4-6_v2_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_20050801-20990731/tmp/")
control_files(list_files) # 10 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_20050801-20990731/tmp/")
control_files(list_files) # 11 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_20050801-21000731/tmp/")
control_files(list_files) # 12 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_ICTP-RegCM4-6_v2_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_20050801-21000731/tmp/")
control_files(list_files) # 13 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_MPI-CSC-REMO2009_v2_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_20050801-21000731/tmp/")
control_files(list_files) # 14 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_NCC-NorESM1-M_rcp85_r1i1p1_DMI-HIRHAM5_v4_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_20050801-21000731/tmp/")
control_files(list_files) # 15 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_NCC-NorESM1-M_rcp85_r1i1p1_GERICS-REMO2015_v2_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_20050801-21000731/tmp/")
control_files(list_files) # 16 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_NCC-NorESM1-M_rcp85_r1i1p1_IPSL-WRF381P_v2_MF-ADAMONT-SAFRAN-1980-2011_IPSL-ORCHIDEE_day_20050801-21000731/tmp/")
control_files(list_files) # 17 OK


### SMASH ###
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-SMASH_day_20050801-21000731/tmp/")
control_files(list_files) # 1 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_20060101-21001231/tmp/")
control_files(list_files) # 2 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_MOHC-HadREM3-GA7-05_v3_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-SMASH_day_20050801-21000731/tmp/")
control_files(list_files) # 3 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_MOHC-HadREM3-GA7-05_v3_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_20060101-21001230/tmp/")
control_files(list_files) # 4 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_KNMI-RACMO22E_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-SMASH_day_20050801-21000731/tmp/")
control_files(list_files) # 5 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_KNMI-RACMO22E_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_20060101-21001231/tmp/")
control_files(list_files) # 6 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-SMASH_day_20050801-21000731/tmp/")
control_files(list_files) # 7 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_20060101-21001231/tmp/")
control_files(list_files) # 8 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_SMHI-RCA4_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-SMASH_day_20050801-21000731/tmp/")
control_files(list_files) # 9 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_ICHEC-EC-EARTH_rcp85_r12i1p1_SMHI-RCA4_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_20060101-21001231/tmp/")
control_files(list_files) # 10 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_IPSL-IPSL-CM5A-MR_rcp85_r1i1p1_DMI-HIRHAM5_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-SMASH_day_20050801-21000731/tmp/")
control_files(list_files) # 11 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_IPSL-IPSL-CM5A-MR_rcp85_r1i1p1_DMI-HIRHAM5_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_20060101-21001231/tmp/")
control_files(list_files) # 12 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_IPSL-IPSL-CM5A-MR_rcp85_r1i1p1_SMHI-RCA4_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-SMASH_day_20050801-21000731/tmp/")
control_files(list_files) # 13 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_IPSL-IPSL-CM5A-MR_rcp85_r1i1p1_SMHI-RCA4_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_20060101-21001231/tmp/")
control_files(list_files) # 14 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-SMASH_day_20050801-20990731/tmp/")
control_files(list_files) # 15 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_20060101-20991231/tmp/")
control_files(list_files) # 16 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CNRM-ALADIN63_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-SMASH_day_20050801-20990731/tmp/")
control_files(list_files) # 17 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_CNRM-ALADIN63_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_20060101-20991231/tmp/")
control_files(list_files) # 18 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_ICTP-RegCM4-6_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-SMASH_day_20050801-20990731/tmp/")
control_files(list_files) # 19 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_ICTP-RegCM4-6_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_20060101-20991231/tmp/")
control_files(list_files) # 20 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_MOHC-HadREM3-GA7-05_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-SMASH_day_20050801-20990731/tmp/")
control_files(list_files) # 21 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MOHC-HadGEM2-ES_rcp85_r1i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_20060101-20991219/tmp/")
control_files(list_files) # 22 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-SMASH_day_20050801-21000731/tmp/")
control_files(list_files) # 23 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_20060101-21001231/tmp/")
control_files(list_files) # 24 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_ICTP-RegCM4-6_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-SMASH_day_20050801-21000731/tmp/")
control_files(list_files) # 25 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_ICTP-RegCM4-6_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_20060101-21001130/tmp/")
control_files(list_files) # 26 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_MPI-CSC-REMO2009_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-SMASH_day_20050801-21000731/tmp/")
control_files(list_files) # 27 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_MPI-CSC-REMO2009_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_20060101-21001231/tmp/")
control_files(list_files) # 28 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_NCC-NorESM1-M_rcp85_r1i1p1_DMI-HIRHAM5_v4_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-SMASH_day_20050801-21000731/tmp/")
control_files(list_files) # 29 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_NCC-NorESM1-M_rcp85_r1i1p1_DMI-HIRHAM5_v4_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_20060101-21001231/tmp/")
control_files(list_files) # 30 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_NCC-NorESM1-M_rcp85_r1i1p1_GERICS-REMO2015_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-SMASH_day_20050801-21000731/tmp/")
control_files(list_files) # 31 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_NCC-NorESM1-M_rcp85_r1i1p1_GERICS-REMO2015_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_20060101-21001231/tmp/")
control_files(list_files) # 32 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_NCC-NorESM1-M_rcp85_r1i1p1_IPSL-WRF381P_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-SMASH_day_20050801-21000731/tmp/")
control_files(list_files) # 33 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_NCC-NorESM1-M_rcp85_r1i1p1_IPSL-WRF381P_v2_MF-ADAMONT-SAFRAN-1980-2011_INRAE-SMASH_day_20060101-21001231/tmp/")
control_files(list_files) # 34 OK


### J2000 ###
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-J2000_day_20050801-21000731/tmp/")
control_files(list_files) # 1 OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-21000731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_MOHC-HadREM3-GA7-05_v3_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-J2000_day_20050801-21000731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_MOHC-HadREM3-GA7-05_v3_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-21000731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_ICHEC-EC-EARTH_rcp85_r12i1p1_KNMI-RACMO22E_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-J2000_day_20050801-21000731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_ICHEC-EC-EARTH_rcp85_r12i1p1_KNMI-RACMO22E_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-21000731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_ICHEC-EC-EARTH_rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-J2000_day_20050801-21000731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_ICHEC-EC-EARTH_rcp85_r12i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-21000731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_ICHEC-EC-EARTH_rcp85_r12i1p1_SMHI-RCA4_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-J2000_day_20050801-21000731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_ICHEC-EC-EARTH_rcp85_r12i1p1_SMHI-RCA4_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-21000731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_IPSL-IPSL-CM5A-MR_rcp85_r1i1p1_DMI-HIRHAM5_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-J2000_day_20050801-21000731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_IPSL-IPSL-CM5A-MR_rcp85_r1i1p1_DMI-HIRHAM5_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-21000731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_IPSL-IPSL-CM5A-MR_rcp85_r1i1p1_SMHI-RCA4_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-J2000_day_20050801-21000731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_IPSL-IPSL-CM5A-MR_rcp85_r1i1p1_SMHI-RCA4_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-21000731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_MOHC-HadGEM2-ES_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-J2000_day_20050801-20990731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_MOHC-HadGEM2-ES_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-20990731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_MOHC-HadGEM2-ES_rcp85_r1i1p1_CNRM-ALADIN63_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-J2000_day_20050801-20990731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_MOHC-HadGEM2-ES_rcp85_r1i1p1_CNRM-ALADIN63_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-20990731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_MOHC-HadGEM2-ES_rcp85_r1i1p1_ICTP-RegCM4-6_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-J2000_day_20050801-20990731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_MOHC-HadGEM2-ES_rcp85_r1i1p1_ICTP-RegCM4-6_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-20990731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_MOHC-HadGEM2-ES_rcp85_r1i1p1_MOHC-HadREM3-GA7-05_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-J2000_day_20050801-20990731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_MOHC-HadGEM2-ES_rcp85_r1i1p1_MOHC-HadREM3-GA7-05_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-20990731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-J2000_day_20050801-21000731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-21000731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_ICTP-RegCM4-6_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-J2000_day_20050801-21000731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_ICTP-RegCM4-6_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-21000731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_MPI-CSC-REMO2009_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-J2000_day_20050801-21000731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_MPI-CSC-REMO2009_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-21000731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_NCC-NorESM1-M_rcp85_r1i1p1_DMI-HIRHAM5_v4_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-J2000_day_20050801-21000731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_NCC-NorESM1-M_rcp85_r1i1p1_DMI-HIRHAM5_v4_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-21000731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_NCC-NorESM1-M_rcp85_r1i1p1_GERICS-REMO2015_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-J2000_day_20050801-21000731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_NCC-NorESM1-M_rcp85_r1i1p1_GERICS-REMO2015_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-21000731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_NCC-NorESM1-M_rcp85_r1i1p1_IPSL-WRF381P_v2_LSCE-IPSL-CDFt-L-1V-0L-SAFRAN-1976-2005_INRAE-J2000_day_20050801-21000731/tmp/")
control_files(list_files) # OK
list_files = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_Rhone-Loire_NCC-NorESM1-M_rcp85_r1i1p1_IPSL-WRF381P_v2_MF-ADAMONT-SAFRAN-France-1980-2011_INRAE-J2000_day_20050801-21000731/tmp/")
control_files(list_files) # OK






# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves_HERweighted_meanJm6Jj/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T) # OK 77
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves_HERweighted_meanJm6Jj/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T) # OK 77
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves_HERweighted_meanJm6Jj/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T) # OK 55
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves_HERweighted_meanJm6Jj/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T) # 77
list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves_HERweighted_meanJm6Jj/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T)
for (l in 1:length(list_)){
  print(l)
  tab_ = read.table(paste0(list_[l],"/Tab_FDCchroniquesByHER2weigthedFDC.txt"), sep = ";", dec = ".", header = T)
  print(dim(tab_))
}



list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-21000731/", full.names = T) # OK 77
tab_1_ = read.table(list_[925], header = T, sep = ";", dec = ".")

list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_MOHC-HadREM3-GA7-05_v3_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-21000731/", full.names = T) # OK 77
tab_2_ = read.table(list_[925], header = T, sep = ";", dec = ".")

paste0(tab_1_$Date,"_",tab_1_$Type)[which(!(paste0(tab_1_$Date,"_",tab_1_$Type) %in% paste0(tab_2_$Date,"_",tab_2_$Type)))]


# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves_HERweighted_meanJm6Jj/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T) # OK 77
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves_HERweighted_meanJm6Jj/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T) # OK 55
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves_HERweighted_meanJm6Jj/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T) # 77
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves_HERweighted_meanJm6Jj/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T)
for (l in 1:length(list_)){
  print(l)
  tab_ = read.table(paste0(list_[l],"/Tab_FDCchroniquesByHER2weigthedFDC.txt"), sep = ";", dec = ".", header = T)
  print(dim(tab_))
}



list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-21000731/", full.names = T) # OK 77
tab_FDC_1_ = read.table(list_[925], header = T, sep = ";", dec = ".")
dim(tab_FDC_1_)

list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-21000731/", full.names = T) # OK 77
list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_MOHC-HadREM3-GA7-05_v3_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-21000731/", full.names = T) # OK 77
tab_FDC_2_ = read.table(list_[925], header = T, sep = ";", dec = ".")
dim(tab_FDC_2_)



list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-21000731/", full.names = T) # OK 77
tab_deb_1_ = read.table(list_[925], header = T, sep = ";", dec = ".")
dim(tab_deb_1_)

list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_MOHC-HadREM3-GA7-05_v3_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-21000731/", full.names = T) # OK 77
tab_deb_2_ = read.table(list_[925], header = T, sep = ";", dec = ".")
dim(tab_deb_2_)










# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T) # OK 77
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T) # OK 77
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T) # OK 55
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T) # 77
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T)
for (l in 1:length(list_)){
  print(l)
  print(list_[l])
  print(dim(read.table(list.files(list_[l], full.names = T)[1], sep = ";", dec = ".", header = T)))
  print(dim(read.table(list.files(list_[l], full.names = T)[length(list.files(list_[l], full.names = T))], sep = ";", dec = ".", header = T)))
  # tab_ = read.table(paste0(list_[l],"/Tab_FDCchroniquesByHER2weigthedFDC.txt"), sep = ";", dec = ".", header = T)
  # print(dim(tab_))
}


# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T) # OK 77
# list_ = list.files("/media/tjaouen/Ultra Touch1/Bkcp_JaouenTristan/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T) # OK 77
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T) # OK 55
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T) # 77
list_ = list.files("/media/tjaouen/Ultra Touch1/Bkcp_JaouenTristan/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T)
for (l in 1:length(list_)){
  print(l)
  print(list_[l])
  print(dim(read.table(list.files(list_[l], full.names = T)[1], sep = ";", dec = ".", header = T)))
  print(dim(read.table(list.files(list_[l], full.names = T)[length(list.files(list_[l], full.names = T))], sep = ";", dec = ".", header = T)))
  # tab_ = read.table(paste0(list_[l],"/Tab_FDCchroniquesByHER2weigthedFDC.txt"), sep = ";", dec = ".", header = T)
  # print(dim(tab_))
}


# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves_HERweighted_meanJm6Jj/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T) # OK 77
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves_HERweighted_meanJm6Jj/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T) # OK 77
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves_HERweighted_meanJm6Jj/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T) # OK 55
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves_HERweighted_meanJm6Jj/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T) # 77
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/FlowDurationCurves_HERweighted_meanJm6Jj/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T)
for (l in 1:length(list_)){
  print(l)
  print(list_[l])
  print(dim(read.table(list.files(list_[l], full.names = T)[1], sep = ";", dec = ".", header = T)))
  print(dim(read.table(list.files(list_[l], full.names = T)[length(list.files(list_[l], full.names = T))], sep = ";", dec = ".", header = T)))
  # tab_ = read.table(paste0(list_[l],"/Tab_FDCchroniquesByHER2weigthedFDC.txt"), sep = ";", dec = ".", header = T)
  # print(dim(tab_))
}


# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProba_LearnBrut_ByHer/FDC_Projections/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T) # OK 77
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProba_LearnBrut_ByHer/FDC_Projections/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T) # OK 77
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProba_LearnBrut_ByHer/FDC_Projections/J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T) # OK 55
list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProba_LearnBrut_ByHer/FDC_Projections/ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T) # 77
# list_ = list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProba_LearnBrut_ByHer/FDC_Projections/SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/", full.names = T)
for (l in 1:length(list_)){
  print(l)
  print(list_[l])
  print(dim(read.table(list.files(list_[l], full.names = T)[1], sep = ";", dec = ".", header = T)))
  # print(dim(read.table(list.files(list_[l], full.names = T)[length(list.files(list_[l], full.names = T))], sep = ";", dec = ".", header = T)))
  # tab_ = read.table(paste0(list_[l],"/Tab_FDCchroniquesByHER2weigthedFDC.txt"), sep = ";", dec = ".", header = T)
  # print(dim(tab_))
}



list_ = list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/Map/", full.names = T) # OK 77
for (l in HER_[which(!(HER_ %in% c(10,18,19,20)))]){
  if (sum(grepl(paste0("_HER",l,"_"), list_)) != 2){
    print(l)
  }else{
    print(paste0("HER ",l," OK"))
  }
}
