library(readxl)
library(ncdf4)
library(rgdal)
library(sf)

### Station HYDRO ###
tab_correspondance_ <- read_excel("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DescriptionPointsSimulation/FichierCorrespondancesLH/Selection_points_simulation_V20230510_TJ20231120_CorrectionDeuxPointsSmash_SansNA.xlsx",
                                  sheet = "stationSimulation")
dim(tab_correspondance_) # 4367
tab_correspondance_ <- tab_correspondance_[which((tab_correspondance_$PointsSupprimes != "Supprimer") | is.na(tab_correspondance_$PointsSupprimes)),]
dim(tab_correspondance_) # 4043

### Merger les deux shp de bassins versants ###
# Charger les fichiers shp
donnees_fichier1 <- st_read("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DescriptionPointsSimulation/entiteHydro/BassinsVersants_Rawdata_GRSD_20220322/BV_4207_stations.shp")
donnees_fichier2 <- st_read("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DescriptionPointsSimulation/entiteHydro/BassinsVersants_Rawdata_GRSD_20220322/3BVs_FRANCE_L2E_2018.shp")

# Convertir donnees_fichier2 vers le CRS de donnees_fichier1
donnees_fichier2_converti <- st_transform(donnees_fichier2, crs = st_crs(donnees_fichier1))

# Concaténer les deux jeux de données
donnees_concatenees <- rbind(donnees_fichier1, donnees_fichier2_converti)


# Afficher les premières lignes pour vérifier la structure des données
head(donnees_concatenees)

# Afficher des informations sur les données
summary(donnees_concatenees)

# Accéder aux informations géométriques
donnees_geom <- st_geometry(donnees_concatenees)
print(donnees_geom)

# Accéder aux attributs
attributs <- donnees_concatenees$nom_attribut
print(attributs)

# Gestion des doublons
donnees_concatenees$Code[duplicated(donnees_concatenees$Code)]
tab_correspondance_$CODE[duplicated(tab_correspondance_$CODE)]

tableau_sans_geometry <- st_drop_geometry(donnees_concatenees)
table(donnees_concatenees$Code %in% tab_correspondance_$CODE[duplicated(tab_correspondance_$CODE)]) # Donnees du shp qui auront deux possibilites lors de l'attribution des Code10 car leur Code8 correspond a deux Code8 de la table de correspondance
print(tableau_sans_geometry[which(tableau_sans_geometry$Code %in% tab_correspondance_$CODE[duplicated(tab_correspondance_$CODE)]),])

# Code   S_km2 dt_pstn                       geometr
# 331  B5172010  434.07    2018 POLYGON ((819413 6947875
# 437  F4560420  260.96    2018 POLYGON ((619685.5 68005
# 536  H2332020  636.45    2018 POLYGON ((769815.5 67215
# 665  H5062010  618.04    2018 POLYGON ((859951.4 68033
# 684  H5122350  840.34    2018 POLYGON ((854130.7 68588
# 1068 I7222020  141.22    2018 POLYGON ((375287.5 68910
# 1604 K5712310 1968.06    2018 POLYGON ((636424.6 66755
# 2220 O1494310  111.89    2018
# 2405 O4754010  439.29    2018 POLYGON ((633664.6 62985
# 2836 Q0612520  510.71    2018 POLYGON ((466580.7 62313
# 2937 R0110010  485.84    2018
# 3418 V2934010  290.48    2018
# 3445 V3224020  287.48    2018


print(tab_correspondance_[which(tab_correspondance_$CODE %in% c("B5172010",
                                                          "F4560420",
                                                          "H2332020",
                                                          "H5062010",
                                                          "H5122350",
                                                          "I7222020",
                                                          "K5712310",
                                                          "O1494310",
                                                          "O4754010",
                                                          "Q0612520",
                                                          "R0110010",
                                                          "V2934010",
                                                          "V3224020")),c("CODE","SuggestionCode","S_HYDRO")],n = 26)
# CODE     SuggestionCode S_HYDRO
# <chr>    <chr>          <chr>  
#   1 B5172010 B517201001     389
# 2 B5172010 B517201002     434.07 
# 10 F4560420 F456042000     131.2  
# 11 F4560420 F456042001     257    
# 3 H2332020 H233202002     728    
# 12 H2332020 H233202001     636    
# 4 H5062010 H506201002     573    
# 13 H5062010 H506201001     614    
# 5 H5122350 H512235001     769    
# 14 H5122350 H512235002     840    
# 15 I7222020 I722202001     142    
# 7 I7222020 I722202002     177    
# 6 K5712310 K571231003     2158   
# 16 K5712310 K571231001     1970   
# 22 O1494310 O149433201     108    
# 8 O1494310 O149431003     68.3   
# 8 O4754010 O475401002     405    
# 17 O4754010 O475401001     502    
# 9 Q0612520 Q061252000     498    
# 18 Q0612520 Q061252001     560
# 11 R0110010 R011001001     485.84 
# 12 R0110010 R011001003     651    
# 25 V2934010 V293401001     288    
# 13 V2934010 V293401002     307    
# 26 V3224020 V322402001     266    
# 14 V3224020 V322402002     283    

### Conversions a effectuer
# B5172010 -> B517201002
# F4560420 -> F456042001
# H2332020 -> H233202001
# H5062010 -> H506201001
# H5122350 -> H512235002
# I7222020 -> I722202001
# K5712310 -> K571231001
# O1494310 -> O149433201
# O4754010 -> O475401002
# Q0612520 -> Q061252000
# R0110010 -> R011001001
# V2934010 -> V293401001
# V3224020 -> V322402002

tab_correspDoublons_ = data.frame(Code8 = c("B5172010", "F4560420", "H2332020", "H5062010", "H5122350", "I7222020", "K5712310", "O1494310", "O4754010", "Q0612520", "R0110010", "V2934010", "V3224020"),
                                  Code10 = c("B517201002", "F456042001", "H233202001", "H506201001", "H512235002", "I722202001", "K571231001", "O149433201", "O475401002", "Q061252000", "R011001001", "V293401001", "V322402002"))

dim(donnees_concatenees) # 4210
dim(tab_correspondance_) # 4043

donnees_concatenees$Code8 = donnees_concatenees$Code
donnees_concatenees <- donnees_concatenees[, -which(names(donnees_concatenees) == "Code")]
donnees_concatenees$Code10 = NA
donnees_concatenees <- donnees_concatenees[,c("Code8","Code10","S_km2","dt_pstn","geometry")]

for (b in 1:nrow(donnees_concatenees)){
  if (length(which(tab_correspondance_$CODE == donnees_concatenees$Code8[b]))==1){
    donnees_concatenees$Code10[b] = tab_correspondance_$SuggestionCode[which(tab_correspondance_$CODE == donnees_concatenees$Code8[b])]
  }
  if (length(which(tab_correspondance_$CODE == donnees_concatenees$Code8[b]))>1){
    print(donnees_concatenees$Code8[b])
  }
}

dim(donnees_concatenees) # 4210
length(donnees_concatenees$Code10[which(donnees_concatenees$Code10 %in% donnees_concatenees$Code10[duplicated(donnees_concatenees$Code10)])]) # 1706
donnees_concatenees[which(donnees_concatenees$Code8 %in% tab_correspDoublons_$Code8),]

# Chercher les indices correspondants dans donnees_concatenees
indices <- match(donnees_concatenees$Code8, tab_correspDoublons_$Code8)

# Mettre à jour les valeurs de Code10 dans donnees_concatenees
donnees_concatenees$Code10 <- ifelse(!is.na(indices), tab_correspDoublons_$Code10[indices], donnees_concatenees$Code10)

length(donnees_concatenees$Code10[which(donnees_concatenees$Code10 %in% donnees_concatenees$Code10[duplicated(donnees_concatenees$Code10)])]) # 1693 (-13 associations)
donnees_concatenees[which(donnees_concatenees$Code8 %in% tab_correspDoublons_$Code8),]




# Écrire les données concaténées dans un nouveau fichier shp
chemin_fichier_sortie <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DescriptionPointsSimulation/entiteHydro/BassinsVersants_Concatenes_20231129/BV_concatenes_4210pointsSimulationExp2_20231130.shp"
st_write(donnees_concatenees, chemin_fichier_sortie)



