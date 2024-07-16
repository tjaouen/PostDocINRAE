### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/2_Run/5_ObtenirAppliquerSeuilsDonneesOndeSurMatriceInput_1_20230607.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run3.R")

# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run3.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run4.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run5.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/3_Run/6_ObtenirAppliquerSeuilsDonneesOndeSurMatriceInput_1_20230607.R")

source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunObs20122019.R")

### Librairies ###
library(stringr)
library(doParallel)
library(dplyr)
library(lubridate)
library(strex)

### Study data ###
folder_input_ = folder_input_param_
folder_output_ = folder_output_param_
folder_onde_ = folder_onde_param_
nom_GCM_ = nom_GCM_param_
nom_selectStations_ = nom_selectStations_param_
nom_categorieSimu_ = nom_categorieSimu_param_
HER_ = HER_param_
HER_variable_ = HER_variable_param_

obsSim_ = obsSim_param_
nomSim_ = nomSim_param_
# annees_learn_ = annees_learnModels_param_
annees_inputMatrice_ = annees_inputMatrice_param_

### Run ###
liste <- c(list.files(paste0(folder_output_,
                             "1_MatricesInputModeles_ParHERDates/",
                             nomSim_,
                             ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                             ifelse(nom_GCM_=="","",paste0("/",nom_GCM_))),
                      pattern="MatInputModel", full.names = T))
NSE <- c()
colNSE <- c()

########################################
### CHOIX DE LA SIMU ###################
########################################
if (nom_GCM_ != ""){
  il = liste[which(grepl(pattern = nom_GCM_, liste) & !(grepl(pattern = "CampOndeExcl", liste)))]
}else{
  il = liste[1]
}
########################################


onde = read.table(il, header = T, sep = ";", row.names = NULL, quote="")
if (dim(onde)[2] == 1){
  onde = read.table(il, header = T, sep = ",", row.names = NULL, quote="")
}

### CONTROLER LES EXCLUSIONS DES CAMPAGNES AVEC LES MODELES QUI COUVRENT TOUTE LA FRANCE ###
# onde_na = onde[which((is.na(onde[,c("Freq_Jm6Jj")]))),]
onde_na = onde[which((is.na(onde[,c("Freq_j")])) & is.na(onde[,c("Freq_jmoins5")])),]

na_ = onde_na[,c("HER2","Date","X._Assec","Freq_jmoins10"),]
# na_ = onde_na[,c("HER2","Date","X._Assec","Freq_Jm6Jj"),]
# assign(paste0("na_",str_after_last(str_before_first(nom_GCM_,"_day"),"-")), onde_na[,c("HER2","Date","X._Assec","Freq_jmoins10"),])
# onde_na$UtiliseEnApprentissage = NA

onde = onde[which((!is.na(onde[,c("Freq_j")])) & !is.na(onde[,c("Freq_jmoins5")])),]
# onde = onde[which((!is.na(onde[,c("Freq_Jm6Jj")]))),]
liste_Her=sort(unique(onde[,1]))

if (unique(year(onde$Date)) != annees_inputMatrice_){
  stop("Some years are missing in the original Matrice Input file. Use programmes 3_OndeHydro_MatriceInput_Parallele_JonctionHERcriteresES_10jours_CoverAllYears_19_20231004 and 3_Annexe_MergeResultFiles_CoverAllYears_2_20231004 again.")
}

### Selection dates learn ###
# onde <- onde[which(format(as.Date(onde$Date),"%Y") %in% annees_validModels_),] # Supprime car dans la nouvelle version, l'exclusion des donnees ONDE se fait en fonction des 11 annees de 2012 a 2022 et non en fonction des annees choisies pour l'apprentissage.

seuils_ <- obtenirSeuilsOnde(MatriceInput = onde, Niveau = 0.75)
onde <- indiquerSeuilsOndeBinaire(tab_ = onde, Seuil_df_ = seuils_)[[1]]
# list_ <- appliquerSeuilsOnde(tab_ = onde, Seuil_df_ = seuils_)
# onde <- list_[[1]]

onde_CampOndeExcl_ = onde[which(onde$UtiliseEnApprentissage == 1),]

# write.table(onde_CampOndeExcl_, paste0(folder_output_,"1_MatricesInputModeles_ParHERDates/",nomSim_,ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),"/MatInputModel_CampOndeExcl_ByHERDates_",nom_GCM_,"_",as.character(min(annees_learn_)),"_",as.character(max(annees_learn_)),"_",str_replace_all(basename(il), 'Stations_HYDRO_|.csv', ''),"_",obsSim_,"_Weight.csv"), sep=";", row.name=F, quote=F)

write.table(onde_CampOndeExcl_, paste0(folder_output_,
                                       "1_MatricesInputModeles_ParHERDates/",
                                       nomSim_,
                                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),"/",
                                       ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),"/",
                                       str_before_first(basename(il),"_"),"_CampOndeExcl_",str_after_first(basename(il),"_")), sep=";", row.name=F, quote=F)

inclusions_ = onde[which(onde$UtiliseEnApprentissage == 1),c("HER2","Date","X._Assec","Freq_jmoins10","Seuil"),]
exclusions_ = onde[which(onde$UtiliseEnApprentissage == 0),c("HER2","Date","X._Assec","Freq_jmoins10","Seuil"),]
# inclusions_ = onde[which(onde$UtiliseEnApprentissage == 1),c("HER2","Date","X._Assec","Freq_Jm6Jj","Seuil"),]
# exclusions_ = onde[which(onde$UtiliseEnApprentissage == 0),c("HER2","Date","X._Assec","Freq_Jm6Jj","Seuil"),]
# assign(paste0("inclusions_",str_after_last(str_before_first(nom_GCM_,"_day"),"-")), onde[which(onde$UtiliseEnApprentissage == 1),c("HER2","Date","X._Assec","Freq_jmoins10"),]) #ORCHIDEE
# assign(paste0("exclusions_",str_after_last(str_before_first(nom_GCM_,"_day"),"-")), onde[which(onde$UtiliseEnApprentissage == 0),c("HER2","Date","X._Assec","Freq_jmoins10"),]) #ORCHIDEE
# date_J2000_ = onde[which(onde$UtiliseEnApprentissage == 0),c("HER2","Date","X._Assec","Freq_jmoins10"),] #J2000
# date_SIM2_ = onde[which(onde$UtiliseEnApprentissage == 0),c("HER2","Date","X._Assec","Freq_jmoins10"),] #SIM2



#####################################
### CONTROLER LES EXCLUSIONS ONDE ###
#####################################
exclusions_$Paste = paste0(exclusions_$HER2,"_",exclusions_$Date)
inclusions_$Paste = paste0(inclusions_$HER2,"_",inclusions_$Date)

# Obtenir toutes les valeurs uniques de HER2 à partir des trois sorties
# toutes_her2 <- sort(as.numeric(unique(c(names(table(na_$HER2)), names(table(inclusions_$HER2)), names(table(exclusions_$HER2))))))
# toutes_her2 <- c(sort(HER2_hybrides.spdf$CdHER2)[which(!(sort(HER2_hybrides.spdf$CdHER2) %in% c(18, 19, 20, 10, 31, 33, 39, 37, 54, 69, 96)))], 037054, 031033039, 069096)
toutes_her2 <- c(sort(HER2_hybrides.spdf$CdHER2)[which(!(sort(HER2_hybrides.spdf$CdHER2) %in% c(31, 33, 39, 37, 54, 69, 96, 89, 92, 49, 90)))], 031033039, 037054, 069096, 089092, 049090)

nouvelle_table <- data.frame(
  HER2 = toutes_her2,
  NA_ = table(na_$HER2)[match(toutes_her2, names(table(na_$HER2)))],
  Inclusions = table(inclusions_$HER2)[match(toutes_her2, names(table(inclusions_$HER2)))],
  Exclusions = table(exclusions_$HER2)[match(toutes_her2, names(table(exclusions_$HER2)))]
)
nouvelle_table = nouvelle_table[,c("HER2","NA_.Freq","Inclusions.Freq","Exclusions.Freq")]
colnames(nouvelle_table) <- c("HER2","DatesSansDebit","InclusionsCampagnesCompletes","ExclusionsCampagnesIncompletes")
nouvelle_table$Reference <- ifelse(nouvelle_table$HER2 == 22, 52,
                                   ifelse(nouvelle_table$HER2 == 24, 54, 
                                          ifelse(nouvelle_table$HER2 == 38,56,55)))
nouvelle_table$Seuil <- NA
for (l in 1:nrow(nouvelle_table)){
  if (length(which(inclusions_$HER2 == nouvelle_table$HER2[l])) > 0){
    nouvelle_table$Seuil[l] = unique(inclusions_$Seuil[which(inclusions_$HER2 == nouvelle_table$HER2[l])])
  }else{
    nouvelle_table$Seuil[l] = 0
  }
}
nouvelle_table[is.na(nouvelle_table)] <- 0
print(nouvelle_table)

write.table(nouvelle_table,
            paste0(folder_output_,
                   "1_MatricesInputModeles_ParHERDates/",
                   nomSim_,
                   ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                   ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                   "/BilanExclusionsOnde_",
                   as.character(min(annees_inputMatrice_)),"_",as.character(max(annees_inputMatrice_)),"_",obsSim_,"_Weight_merge.csv"), sep=";", row.name=F, quote=F)

### Verifier que toutes les exclusions soient connues, deja observees lors de l'experimentation sur HYDRO. Verifier qu'aucune campagne inclue ne corresponde a une campagne qui avait ete exclue precedemment ###
avExclOnde_Ref_ = read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2022_20230919/DebitsComplets_From20120101_To20221231/MatInputModel_ByHERDates__2012_2022_Observes_Weight_merge.csv", sep = ",", dec = ".", header = T)
apExclOnde_Ref_ = read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2022_20230919/DebitsComplets_From20120101_To20221231/MatInputModel_CampOndeExcl_ByHERDates__2012_2022_Observes_Weight_merge.csv", sep = ";", dec = ".", header = T)
excluRef_ = paste0(avExclOnde_Ref_$HER2,"_",avExclOnde_Ref_$Date)[which(!(paste0(avExclOnde_Ref_$HER2,"_",avExclOnde_Ref_$Date) %in% paste0(apExclOnde_Ref_$HER2,"_",apExclOnde_Ref_$Date)))]

### Exclusion Safran (ATTENTION limite a 2012 - 2019) ###
# avExclOnde_Ref_ = read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_20231221/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-21000731/MatInputModel_ByHERDates_2012_2022_Projections_Weight_merge.csv", sep = ",", dec = ".", header = T)
# apExclOnde_Ref_ = read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_20231221/CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_MF-ISBA-CTRIP_day_20050801-21000731/MatInputModel_CampOndeExcl_ByHERDates_2012_2022_Projections_Weight_merge.csv", sep = ";", dec = ".", header = T)
# excluRef_ = paste0(avExclOnde_Ref_$HER2,"_",avExclOnde_Ref_$Date)[which(!(paste0(avExclOnde_Ref_$HER2,"_",avExclOnde_Ref_$Date) %in% paste0(apExclOnde_Ref_$HER2,"_",apExclOnde_Ref_$Date)))]
# excluRef_ = Avec la campagne 38_2013-10-23, sans les campagnes vides

if ((length(which(!(exclusions_$Paste %in% excluRef_))) > 0) | (length(which(inclusions_$Paste %in% excluRef_)) > 0)){
  stop("Exclusions of ONDE compaigns does not correspond to the exclusions done during the test on HYDRO stations.")
}


########### VOIR EXCLUSION DES CAMPAGNES ONDE INCOMPLETE
### /home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/4_StatisticsAndGraphs/5_SyntheseResultats_3_20230925


# tab_ORCHIDEE = read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/23_ObservesReanalyseSafran_DriasEau_20231002/DebitsComplets_DebitsParModelesHydro_From20120101_To20221231/BilanExclusionsOnde_debit_France_SAFRAN-France-2022_IPSL-ORCHIDEE_day_19760801-20190731_2012_2022_ObservesReanalyseSafran_DriasEau_Weight_merge.csv", sep =";", dec = ".", header = T)
# tab_SIM2 = read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/23_ObservesReanalyseSafran_DriasEau_20231002/DebitsComplets_DebitsParModelesHydro_From20120101_To20221231/BilanExclusionsOnde_debit_France_SAFRAN-France-2022_MF-SIM2_day_19760801-20220731_2012_2022_ObservesReanalyseSafran_DriasEau_Weight_merge.csv", sep =";", dec = ".", header = T)
# tab_J2000 = read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/23_ObservesReanalyseSafran_DriasEau_20231002/DebitsComplets_DebitsParModelesHydro_From20120101_To20221231/BilanExclusionsOnde_debit_Rhone-Loire_SAFRAN-France-2022_INRAE-J2000_day_19760801-20221231_2012_2022_ObservesReanalyseSafran_DriasEau_Weight_merge.csv", sep =";", dec = ".", header = T)

# Dans quelles HER2 est ce que les exclusions ONDE n'ont pas ete equivalentes entre les modeles ?
# tab_ORCHIDEE[which(!(tab_ORCHIDEE$ExclusionsCampagnesIncompletes == tab_J2000$ExclusionsCampagnesIncompletes)),] #Si inclusion et exclusion sont a 0, c'est que l'HER n'est pas couverte par le modele. Donc ni inclusion ni exclusion ONDE
# tab_J2000[which(!(tab_J2000$ExclusionsCampagnesIncompletes == tab_ORCHIDEE$ExclusionsCampagnesIncompletes)),] #Si inclusion et exclusion sont a 0, c'est que l'HER n'est pas couverte par le modele. Donc ni inclusion ni exclusion ONDE
# Certains ecarts peuvent exister si des modeles ont des stations sur certaines HER2 et les incluent tandis que d'autres n'en ont pas et ne font ni inclusion, ni exclusion sur ces HER2

# tab_SIM2[which(!(tab_SIM2$ExclusionsCampagnesIncompletes == tab_J2000$ExclusionsCampagnesIncompletes)),]
# tab_J2000[which(!(tab_J2000$ExclusionsCampagnesIncompletes == tab_SIM2$ExclusionsCampagnesIncompletes)),]

# tab_SIM2[which(!(tab_SIM2$ExclusionsCampagnesIncompletes == tab_ORCHIDEE$ExclusionsCampagnesIncompletes)),]
# tab_ORCHIDEE[which(!(tab_ORCHIDEE$ExclusionsCampagnesIncompletes == tab_SIM2$ExclusionsCampagnesIncompletes)),]
# 5 -> 1 de plus dans SIM2 car exclue en 2020 et NA pour ORCHIDEE, 44  -> 1 de plus dans SIM2 car exclue en 2020 et NA pour ORCHIDEE, 59 -> 1 de plus dans SIM2 car exclue en 2021 et NA pour ORCHIDEE

# tab_SIM2[which(!(tab_SIM2$ExclusionsCampagnesIncompletes == tab_ORCHIDEE$ExclusionsCampagnesIncompletes)),]
# HER2 DatesSansDebit InclusionsCampagnesCompletes ExclusionsCampagnesIncompletes Reference Seuil
# 3     5              2                           52                              1        55     8
# 7    17             55                            0                              0        55     0
# 9    22             52                            0                              0        52     0
# 20   43             55                            0                              0        55     0
# 21   44              2                           50                              3        55     4
# 28   56             55                            0                              0        55     0
# 31   59              2                           49                              4        55    48
# 67  106             55                            0                              0        55     0
# > tab_ORCHIDEE[which(!(tab_ORCHIDEE$ExclusionsCampagnesIncompletes == tab_SIM2$ExclusionsCampagnesIncompletes)),]
# HER2 DatesSansDebit InclusionsCampagnesCompletes ExclusionsCampagnesIncompletes Reference Seuil
# 3     5             17                           38                              0        55     8
# 7    17             17                           36                              2        55     4
# 9    22             17                           32                              3        52    25
# 20   43             17                           37                              1        55     4
# 21   44             17                           36                              2        55     4
# 28   56             17                           37                              1        55    20
# 31   59             17                           35                              3        55    48
# 67  106             17                           35                              3        55    19

### 4 exclusions de campagnes totales absentes ###
# # combinations_out[which(!(combinations_out %in% combinations))] #38_2013_10 -> 1 campagne en trop qui sera retiree au filtre des campagnes incompletes
# # combinations[which(!(combinations %in% combinations_out))] #22_2013_9, 22_2016_5, 22_2018_6, 24_2013_5 -> 4 campagnes sans donnees

