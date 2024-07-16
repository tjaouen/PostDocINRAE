  ### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/4_RunsEtudeFrance_20230417/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_11_SaveRds_20230831.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")

### Libraries ###
library(ggplot2)
library(readxl)
require(maptools)
library(rgdal)
library(maps)
library(mapdata)
library(dplyr)
library(rgeos)
library(RColorBrewer)
library(fields)
library(scales)

### Output forlder ###
output_folder_ = "/home/tjaouen/Documents/Input/ONDE/Data_DatesAjustees/MapSitesOndeDisponibles/"

### Study data ###
folder_input_ = folder_input_param_
folder_output_ = folder_output_param_
folder_onde_ = folder_onde_param_
nomSim_ = nomSim_param_
HER_variable_ = "HER2"


############
### Onde ###
############
#data.frame(table(df_descriptionStations_2012_2017_$Surf_BV_cut, useNA = "always")))
df_ <- read.table("/home/tjaouen/Documents/Input/ONDE/Data_Description/DescriptionSites/Surf_ONDE_2_20230525.csv", header = T, sep = ",", row.names = NULL, quote="")
annees_ = c(2012:2017)

onde = read.table(paste0(folder_ONDE_CorrespondanceHER_,"HER2hybrides_Jonction/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_JonctionHER_4_20230512.csv"), header = T, sep = ";", row.names = NULL, quote="")
if (dim(onde)[2] == 1){
  onde = read.table(paste0(folder_ONDE_CorrespondanceHER_,"HER2hybrides_Jonction/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_JonctionHER_4_20230512.csv"), sep=",", dec=".", header = T)
}
onde = onde[,c("Code","X_Lambert93","Y_Lambert93",paste0("Cd",HER_variable_))]
colnames(onde) = c("Code","X_Lambert93","Y_Lambert93",paste0("Cd",HER_variable_))
print("Taille à verifier : 3302")
dim(onde)

df_ = merge(df_, onde, by.x = "F_CdSiteHy", by.y = "Code")

# Utilisez la fonction aggregate avec des fonctions personnalisées pour calculer la somme, le nombre de non-NA et le nombre de NA
result <- aggregate(df_$Surf_BV, by=list(df_$CdHER2), FUN=function(x) c(
  Somme_Surf_BV = sum(x, na.rm = TRUE),
  Count_Non_NA = sum(!is.na(x)),
  Count_NA = sum(is.na(x))
))
df_onde_ = data.frame(HER2 = result[[1]],
                      AreaOnde = result$x[,1],
                      Count_Non_NA = result$x[,2],
                      Count_NA = result$x[,3],
                      Count_Total = result$x[,2] + result$x[,3])

# Affichez le résultat
print(df_onde_)
df_onde_$HER2[which(df_onde_$HER2 == "37055")] = "37+55"
df_onde_$HER2[which(df_onde_$HER2 == "69096")] = "69+96"
df_onde_$HER2[which(df_onde_$HER2 == "31033039")] = "31+33+39"



### Caracteristiques HER 2 hybrides - Utilisation de l'aire des HER 2 ###
file_HER2off_desc_ = "/home/tjaouen/Documents/Input/HER/HER2hybrides/DescriptionHER2hybrides_R_1_20230405.xlsx"
tab_HER2off_desc_ = read_excel(file_HER2off_desc_)
tab_HER2off_desc_$Area_km2 = as.numeric(tab_HER2off_desc_$Area_km2)

# tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == )]
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 37)] = "37+55"
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 55)] = "37+55"
tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "37+55")] = sum(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "37+55")])

tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 69)] = "69+96"
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 96)] = "69+96"
tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "69+96")] = sum(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "69+96")])

tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 31)] = "31+33+39"
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 33)] = "31+33+39"
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 39)] = "31+33+39"
tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "31+33+39")] = sum(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "31+33+39")])


df_onde_$SurfaceHER2 = NA
df_onde_$SurfaceOndePropSurfHER2 = NA
df_onde_$SurfaceOndePropSurfHER2_log = NA
df_onde_$NbStationsOndeProp1000SurfHER2 = NA
df_onde_$SurfHER2ParStationsOnde = NA

for (i in 1:nrow(df_onde_)){
  if (length(which(tab_HER2off_desc_$CdHER2 == df_onde_$HER2[i])) > 0){
    
    print(df_onde_$HER2[i])
    print(which(tab_HER2off_desc_$CdHER2 == df_onde_$HER2[i]))
    print(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == df_onde_$HER2[i])])
    
    df_onde_$SurfaceHER2[i] = tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == df_onde_$HER2[i])]
    
    df_onde_$SurfaceOndePropSurfHER2[i] = unique(df_onde_$AreaOnde[i]/tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == df_onde_$HER2[i])]) # Surface topographique des stations hydro de l'HER 2 hybrides / Surface de l'HER 2 hybrides 
    df_onde_$SurfaceOndePropSurfHER2_log[i] = log(unique(df_onde_$AreaOnde[i]/tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == df_onde_$HER2[i])])) # Surface topographique des stations hydro de l'HER 2 hybrides / Surface de l'HER 2 hybrides 
    
    df_onde_$NbStationsOndeProp1000SurfHER2[i] = ifelse(df_onde_$Count_Total[i]==0,NA,unique(df_onde_$Count_Total[i]/tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == df_onde_$HER2[i])])*1000) # Nombre de stations par km2 de l'HER 2 hybride
    df_onde_$SurfHER2ParStationsOnde[i] = unique(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == df_onde_$HER2[i])]/ifelse(df_onde_$Count_Total[i] == 0,NA,df_onde_$Count_Total[i])) # Surface de l'HER couverte par une station Hydro
  }
}

breaks_SurfaceEntitesHydroPropSurfHER2 = breaks_SurfaceEntitesHydroPropSurfHER2_param
breaks_SurfaceEntitesHydroPropSurfHER2_log = breaks_SurfaceEntitesHydroPropSurfHER2_log_param
breaks_NbEntitesHydroProp1000SurfHER2 = breaks_NbEntitesHydroProp1000SurfHER2_param
breaks_SurfHER2ParEntiteHydro = breaks_SurfHER2ParEntiteHydro_param
color_sitesOnde = color_sitesOnde_param


### SURFACE ONDE / SURFACE HER2 ###
output_name_ = "/home/tjaouen/Documents/Input/ONDE/Data_DatesAjustees/MapSitesOndeDisponibles/Version_20230910/Carte_RepartitionSitesONDEHER2hyb_SumSurfacePondSurfHER2_1_20230908.png"
plot_map_variable(tab_ = df_onde_,
                  varname_ = "SurfaceOndePropSurfHER2",
                  vartitle_ = "Ratio (sans unité)",
                  breaks_ = round(breaks_SurfaceEntitesHydroPropSurfHER2,1),
                  output_name_ = output_name_,
                  title_ = "",
                  reverseColors_ = F,
                  reverseLegend_ = T,
                  labels_name_ = FALSE,
                  nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt") #nomPalette_ = "misc_div_disc.txt")

output_name_ = "/home/tjaouen/Documents/Input/ONDE/Data_DatesAjustees/MapSitesOndeDisponibles/Version_20230910/Carte_RepartitionSitesONDEHER2hyb_SumSurfacePondSurfHER2_English_1_20230908.png"
plot_map_variable(tab_ = df_onde_,
                  varname_ = "SurfaceOndePropSurfHER2",
                  vartitle_ = "Ratio (unitless)",
                  breaks_ = round(breaks_SurfaceEntitesHydroPropSurfHER2, 1),
                  output_name_ = output_name_,
                  title = "",
                  reverseColors_ = F,
                  reverseLegend_ = T,
                  labels_name_ = F,
                  nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt") #nomPalette_ = "misc_div_disc.txt")

output_name_ = "/home/tjaouen/Documents/Input/ONDE/Data_DatesAjustees/MapSitesOndeDisponibles/Version_20230910/Carte_RepartitionSitesONDEHER2hyb_SumSurfacePondSurfHER2_sansEtiq_1_20230908.png"
plot_map_variable_sansEtiquettes(tab_ = df_onde_,
                                 varname_ = "SurfaceOndePropSurfHER2",
                                 vartitle_ = "Ratio (sans unité)",
                                 breaks_ = round(breaks_SurfaceEntitesHydroPropSurfHER2,1),
                                 output_name_ = output_name_,
                                 title_ = "",
                                 reverseColors_ = F,
                                 reverseLegend_ = T,
                                 labels_name_ = F,
                                 nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt", #nomPalette_ = "misc_div_disc.txt")
                                 sansTexteHer_ = T)

output_name_ = "/home/tjaouen/Documents/Input/ONDE/Data_DatesAjustees/MapSitesOndeDisponibles/Version_20230910/Carte_RepartitionSitesONDEHER2hyb_SumSurfacePondSurfHER2_sansEtiq_English_1_20230908.png"
plot_map_variable_sansEtiquettes(tab_ = df_onde_,
                                 varname_ = "SurfaceOndePropSurfHER2",
                                 vartitle_ = "Ratio (unitless)",
                                 breaks_ = round(breaks_SurfaceEntitesHydroPropSurfHER2, 1),
                                 output_name_ = output_name_,
                                 title = "",
                                 reverseColors_ = F,
                                 reverseLegend_ = T,
                                 labels_name_ = F,
                                 nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt", #nomPalette_ = "misc_div_disc.txt")
                                 sansTexteHer_ = T)

### LOG SURFACE ONDE / SURFACE HER2 ###
output_name_ = "/home/tjaouen/Documents/Input/ONDE/Data_DatesAjustees/MapSitesOndeDisponibles/Version_20230910/Carte_RepartitionSitesONDEHER2hyb_SumSurfacePondSurfHER2_log_1_20230908.png"
plot_map_variable(tab_ = df_onde_,
                  varname_ = "SurfaceOndePropSurfHER2_log",
                  vartitle_ = "Log-ratio (sans unité)",
                  breaks_ = round(breaks_SurfaceEntitesHydroPropSurfHER2_log,1),
                  output_name_ = output_name_,
                  title_ = "",
                  reverseColors_ = F,
                  reverseLegend_ = T,
                  labels_name_ = F,
                  nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt") #nomPalette_ = "misc_div_disc.txt")

output_name_ = "/home/tjaouen/Documents/Input/ONDE/Data_DatesAjustees/MapSitesOndeDisponibles/Version_20230910/Carte_RepartitionSitesONDEHER2hyb_SumSurfacePondSurfHER2_log_English_1_20230908.png"
plot_map_variable(tab_ = df_onde_,
                  varname_ = "SurfaceOndePropSurfHER2_log",
                  vartitle_ = "Log-ratio (unitless)",
                  breaks_ = round(breaks_SurfaceEntitesHydroPropSurfHER2_log, 1),
                  output_name_ = output_name_,
                  title = "",
                  reverseColors_ = F,
                  reverseLegend_ = T,
                  labels_name_ = F,
                  nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt") #nomPalette_ = "misc_div_disc.txt")

output_name_ = "/home/tjaouen/Documents/Input/ONDE/Data_DatesAjustees/MapSitesOndeDisponibles/Version_20230910/Carte_RepartitionSitesONDEHER2hyb_SumSurfacePondSurfHER2_log_sansEtiq_1_20230908.png"
plot_map_variable_sansEtiquettes(tab_ = df_onde_,
                                 varname_ = "SurfaceOndePropSurfHER2_log",
                                 vartitle_ = "Log-ratio (sans unité)",
                                 breaks_ = round(breaks_SurfaceEntitesHydroPropSurfHER2_log,1),
                                 output_name_ = output_name_,
                                 title_ = "",
                                 reverseColors_ = F,
                                 reverseLegend_ = T,
                                 labels_name_ = F,
                                 nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt", #nomPalette_ = "misc_div_disc.txt")
                                 sansTexteHer_ = T)

output_name_ = "/home/tjaouen/Documents/Input/ONDE/Data_DatesAjustees/MapSitesOndeDisponibles/Version_20230910/Carte_RepartitionSitesONDEHER2hyb_SumSurfacePondSurfHER2_log_sansEtiq_English_1_20230908.png"
plot_map_variable_sansEtiquettes(tab_ = df_onde_,
                                 varname_ = "SurfaceOndePropSurfHER2_log",
                                 vartitle_ = "Log-ratio (unitless)",
                                 breaks_ = round(breaks_SurfaceEntitesHydroPropSurfHER2_log, 1),
                                 output_name_ = output_name_,
                                 title = "",
                                 reverseColors_ = F,
                                 reverseLegend_ = T,
                                 labels_name_ = F,
                                 nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt", #nomPalette_ = "misc_div_disc.txt")
                                 sansTexteHer_ = T)

### NOMBRE STATIONS ONDE / 1000 KM 2 HER2 ###
output_name_ = "/home/tjaouen/Documents/Input/ONDE/Data_DatesAjustees/MapSitesOndeDisponibles/Version_20230910/Carte_RepartitionSitesONDEHER2hyb_NbStationsOndeProp1000SurfHER2_1_20230908.png"
plot_map_variable(tab_ = df_onde_,
                  varname_ = "NbStationsOndeProp1000SurfHER2",
                  vartitle_ = bquote(atop("Nombre de stations pour", "1000 " ~ km^2 ~ "d'HER2")),
                  breaks_ = round(breaks_NbEntitesHydroProp1000SurfHER2,1),
                  output_name_ = output_name_,
                  title_ = "",
                  reverseColors_ = F,
                  reverseLegend_ = T,
                  labels_name_ = F,
                  nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt") #nomPalette_ = "misc_div_disc.txt")

output_name_ = "/home/tjaouen/Documents/Input/ONDE/Data_DatesAjustees/MapSitesOndeDisponibles/Version_20230910/Carte_RepartitionSitesONDEHER2hyb_NbStationsOndeProp1000SurfHER2_English_1_20230908.png"
plot_map_variable(tab_ = df_onde_,
                  varname_ = "NbStationsOndeProp1000SurfHER2",
                  vartitle_ = bquote(atop("Number of stations per", "1000 " ~ km^2 ~ "of HER2")),
                  breaks_ = round(breaks_NbEntitesHydroProp1000SurfHER2, 1),
                  output_name_ = output_name_,
                  title = "",
                  reverseColors_ = F,
                  reverseLegend_ = T,
                  labels_name_ = F,
                  nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt") #nomPalette_ = "misc_div_disc.txt")

output_name_ = "/home/tjaouen/Documents/Input/ONDE/Data_DatesAjustees/MapSitesOndeDisponibles/Version_20230910/Carte_RepartitionSitesONDEHER2hyb_NbStationsOndeProp1000SurfHER2_sansEtiq_1_20230908.png"
plot_map_variable_sansEtiquettes(tab_ = df_onde_,
                                 varname_ = "NbStationsOndeProp1000SurfHER2",
                                 vartitle_ = bquote(atop("Nombre de stations pour", "1000 " ~ km^2 ~ "d'HER2")),
                                 breaks_ = round(breaks_NbEntitesHydroProp1000SurfHER2,1),
                                 output_name_ = output_name_,
                                 title_ = "",
                                 reverseColors_ = F,
                                 reverseLegend_ = T,
                                 labels_name_ = F,
                                 nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt", #nomPalette_ = "misc_div_disc.txt")
                                 sansTexteHer_ = T)

output_name_ = "/home/tjaouen/Documents/Input/ONDE/Data_DatesAjustees/MapSitesOndeDisponibles/Version_20230910/Carte_RepartitionSitesONDEHER2hyb_NbStationsOndeProp1000SurfHER2_sansEtiq_English_1_20230908.png"
plot_map_variable_sansEtiquettes(tab_ = df_onde_,
                                 varname_ = "NbStationsOndeProp1000SurfHER2",
                                 vartitle_ = bquote(atop("Number of stations per", "1000 " ~ km^2 ~ "of HER2")),
                                 breaks_ = round(breaks_NbEntitesHydroProp1000SurfHER2, 1),
                                 output_name_ = output_name_,
                                 title = "",
                                 reverseColors_ = F,
                                 reverseLegend_ = T,
                                 labels_name_ = F,
                                 nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt", #nomPalette_ = "misc_div_disc.txt")
                                 sansTexteHer_ = T)

### SURFACE HER2 PAR STATIONS ONDE ###
output_name_ = "/home/tjaouen/Documents/Input/ONDE/Data_DatesAjustees/MapSitesOndeDisponibles/Version_20230910/Carte_RepartitionSitesONDEHER2hyb_SurfaceHER2ParStations_1_20230908.png"
plot_map_variable(tab_ = df_onde_,
                  varname_ = "SurfHER2ParStationsOnde",
                  vartitle_ = bquote(atop("Surface moyenne d'HER2 (en " ~ km^2 ~ ")", "couverte par une station")),
                  breaks_ = round(breaks_SurfHER2ParEntiteHydro,1),
                  output_name_ = output_name_,
                  title_ = "",
                  reverseColors_ = T,
                  reverseLegend_ = T,
                  labels_name_ = F,
                  nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt") #nomPalette_ = "misc_div_disc.txt")

output_name_ = "/home/tjaouen/Documents/Input/ONDE/Data_DatesAjustees/MapSitesOndeDisponibles/Version_20230910/Carte_RepartitionSitesONDEHER2hyb_SurfaceHER2ParStations_English_1_20230908.png"
plot_map_variable(tab_ = df_onde_,
                  varname_ = "SurfHER2ParStationsOnde",
                  vartitle_ = bquote(atop("Average HER2 area (in " ~ km^2 ~ ")", "covered by a station")),
                  breaks_ = round(breaks_SurfHER2ParEntiteHydro, 1),
                  output_name_ = output_name_,
                  title = "",
                  reverseColors_ = T,
                  reverseLegend_ = T,
                  labels_name_ = F,
                  nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt") #nomPalette_ = "misc_div_disc.txt")

output_name_ = "/home/tjaouen/Documents/Input/ONDE/Data_DatesAjustees/MapSitesOndeDisponibles/Version_20230910/Carte_RepartitionSitesONDEHER2hyb_SurfaceHER2ParStations_sansEtiq_1_20230908.png"
plot_map_variable_sansEtiquettes(tab_ = df_onde_,
                                 varname_ = "SurfHER2ParStationsOnde",
                                 vartitle_ = bquote(atop("Surface moyenne d'HER2 (en " ~ km^2 ~ ")", "couverte par une station")),
                                 breaks_ = round(breaks_SurfHER2ParEntiteHydro,1),
                                 output_name_ = output_name_,
                                 title_ = "",
                                 reverseColors_ = T,
                                 reverseLegend_ = T,
                                 labels_name_ = F,
                                 nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt", #nomPalette_ = "misc_div_disc.txt")
                                 sansTexteHer_ = T)

output_name_ = "/home/tjaouen/Documents/Input/ONDE/Data_DatesAjustees/MapSitesOndeDisponibles/Version_20230910/Carte_RepartitionSitesONDEHER2hyb_SurfaceHER2ParStations_sansEtiq_English_1_20230908.png"
plot_map_variable_sansEtiquettes(tab_ = df_onde_,
                                 varname_ = "SurfHER2ParStationsOnde",
                                 vartitle_ = bquote(atop("Average HER2 area (in " ~ km^2 ~ ")", "covered by a station")),
                                 breaks_ = round(breaks_SurfHER2ParEntiteHydro, 1),
                                 output_name_ = output_name_,
                                 title = "",
                                 reverseColors_ = T,
                                 reverseLegend_ = T,
                                 labels_name_ = F,
                                 nomPalette_ = "sequence_vertRouge_personnelle_div_disc.txt", #nomPalette_ = "misc_div_disc.txt")
                                 sansTexteHer_ = T)


output_name_ = "/home/tjaouen/Documents/Input/ONDE/Data_DatesAjustees/MapSitesOndeDisponibles/Version_20230910/Carte_PointsStationsOnde_sansEtiq_English_1_20230908.png"
plot_map_variable_points(tab_ = onde,
                         vartitle_ = paste0(nrow(onde)," ONDE sites"),
                         output_name_ = output_name_,
                         title_ = "",
                         nomX = "X_Lambert93",
                         nomY = "Y_Lambert93",
                         color = color_sitesOnde)


tab_sum_$HER2
df_onde_$HER2

tab_sum_$SurfaceHER2
df_onde_$SurfaceHER2

paste0(tab_sum_$HER2,"_",tab_sum_$SurfaceHER2)[which(!(paste0(tab_sum_$HER2,"_",tab_sum_$SurfaceHER2) %in% paste0(df_onde_$HER2,"_",df_onde_$SurfaceHER2)))]
paste0(df_onde_$HER2,"_",df_onde_$SurfaceHER2)[which(!(paste0(df_onde_$HER2,"_",df_onde_$SurfaceHER2) %in% paste0(tab_sum_$HER2,"_",tab_sum_$SurfaceHER2)))]

dim(df_onde_)

length(df_$F_CdSiteHy) # 3302
length(unique(df_$F_CdSiteHy)) # 3302

### Aires HER2 ###
hist(df_onde_$SurfaceHER2)
length(which(df_onde_$SurfaceHER2<10000))/length(which(!(is.na(df_onde_$SurfaceHER2)))) # 77.9
median(df_onde_$SurfaceHER2, na.rm = T) # 4614.968
quantile(df_onde_$SurfaceHER2, na.rm = T, probs = 0.25) # 2885.09
quantile(df_onde_$SurfaceHER2, na.rm = T, probs = 0.75) # 9557.127

### Somme aires stations Hydro par HER2 ###
hist(df_onde_$AreaOnde) # 
median(df_onde_$AreaOnde, na.rm = T) # 1037
quantile(df_onde_$AreaOnde, na.rm = T, probs = 0.25) # 528
quantile(df_onde_$AreaOnde, na.rm = T, probs = 0.75) # 1997

### Proportion surface Hydro / surface HER2 ###
hist(df_onde_$SurfaceOndePropSurfHER2) # 
mean(df_onde_$SurfaceOndePropSurfHER2, na.rm = T) #0.2678
median(df_onde_$SurfaceOndePropSurfHER2, na.rm = T) #0.1976
quantile(df_onde_$SurfaceOndePropSurfHER2, na.rm = T, probs = 0.25) #0.148
quantile(df_onde_$SurfaceOndePropSurfHER2, na.rm = T, probs = 0.75) #0.348

### Nombre station Hydro / surface HER2 * 1000 ###
median(df_onde_$NbStationsOndeProp1000SurfHER2, na.rm = T) #6.1174
quantile(df_onde_$NbStationsOndeProp1000SurfHER2, na.rm = T, probs = 0.25) #4.752
quantile(df_onde_$NbStationsOndeProp1000SurfHER2, na.rm = T, probs = 0.75) #7.455




table(df_onde_$AreaOnde>0,df_onde_$HER2 != 0) #77/77








### Import HER2 ###
fr.spdf <- readOGR("/home/tjaouen/Téléchargements/pointSimulationHYDRO_20220928/","pointSimulationHYDRO_20220928")
proj4string(fr.spdf)=CRS("+proj=longlat +ellps=WGS84")
fr.prj <- spTransform(fr.spdf, CRS("+init=epsg:2154")) # trasnformation en Lambert93


