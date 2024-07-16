### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")

library(dplyr)


# nom_categorieSimu_ <- str_before_first(nom_categorieSimu_param_,"/")
nom_categorieSimu_list_ <- c("CTRIP_20231128",
                             "GRSD_20231128",
                             "J2000_20231128",
                             "ORCHIDEE_20231128",
                             "SMASH_20231128")

# CTRIP #
nom_categorieSimu_ <- nom_categorieSimu_list_[1]
tab_globale_1_ = data.frame()
folders_1_ <- list.files(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/",nom_categorieSimu_),
                       pattern = "ModelResults.*logit.csv", recursive = T, include.dirs = F, full.names = T)
folders_1_ <- folders_1_[grepl("TableGlobale",folders_1_)]
folders_1_ <- folders_1_[grepl("ADAMONT",folders_1_)]
  
for (f in folders_1_){
  tab_1_ <- read.table(f, header = T, sep = ";", dec = ".")
  tab_1_$Chaine <- str_split(f,"/")[[1]][13]
  tab_1_$Rcp <- str_split(f,"/")[[1]][11]
  tab_1_$Categorie <- nom_categorieSimu_
  
  if (length(tab_globale_1_)==0){
    tab_globale_1_ <- tab_1_
  }else{
    tab_globale_1_ <- rbind(tab_globale_1_, tab_1_)
  }
}
table(tab_globale_1_$Rcp,tab_globale_1_$Categorie)
dim(tab_globale_1_) # 2700
median(tab_globale_1_$KGE_HER_AnneeValid_logit_CValid_general) #0.801
quantile(tab_globale_1_$KGE_HER_AnneeValid_logit_CValid_general,probs = 0.25) # 0.69275
quantile(tab_globale_1_$KGE_HER_AnneeValid_logit_CValid_general,probs = 0.75) # 0.854

tab_globale_1_median_ <- tab_globale_1_ %>%
  group_by(HER) %>%
  summarize(KGE = median(KGE_HER_AnneeValid_logit_CValid_general))
median(tab_globale_1_median_$KGE) # 0.801
table(tab_globale_1_median_$KGE>0.8) # 38/75

median(tab_globale_1_$NASH_HER_AnneeValid_logit_CValid_general) # 0.735
quantile(tab_globale_1_$NASH_HER_AnneeValid_logit_CValid_general,probs = 0.25) # 0.607
quantile(tab_globale_1_$NASH_HER_AnneeValid_logit_CValid_general,probs = 0.75) # 0.799

median(tab_globale_1_$ErreurMoyenneAbsolue_general) # 0.049
quantile(tab_globale_1_$ErreurMoyenneAbsolue_general,probs = 0.25) # 0.035
quantile(tab_globale_1_$ErreurMoyenneAbsolue_general,probs = 0.75) # 0.073

median(tab_globale_1_$RMSE_general) # 0.069
quantile(tab_globale_1_$RMSE_general,probs = 0.25) # 0.052
quantile(tab_globale_1_$RMSE_general,probs = 0.75) # 0.1

median(tab_globale_1_$P_assecs_HER_MoyenneGlobale_Predit_general) # 13.473

# GRSD #
nom_categorieSimu_ <- nom_categorieSimu_list_[2]
tab_globale_2_ = data.frame()
folders_2_ <- list.files(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/",nom_categorieSimu_),
                         pattern = "ModelResults.*logit.csv", recursive = T, include.dirs = F, full.names = T)
folders_2_ <- folders_2_[grepl("TableGlobale",folders_2_)]
folders_2_ <- folders_2_[grepl("ADAMONT",folders_2_)]

for (f in folders_2_){
  tab_2_ <- read.table(f, header = T, sep = ";", dec = ".")
  tab_2_$Chaine <- str_split(f,"/")[[1]][13]
  tab_2_$Rcp <- str_split(f,"/")[[1]][11]
  tab_2_$Categorie <- nom_categorieSimu_
  
  if (length(tab_globale_2_)==0){
    tab_globale_2_ <- tab_2_
  }else{
    tab_globale_2_ <- rbind(tab_globale_2_, tab_2_)
  }
}
table(tab_globale_2_$Rcp,tab_globale_2_$Categorie)
dim(tab_globale_2_) # 2700
median(tab_globale_2_$KGE_HER_AnneeValid_logit_CValid_general) # 0.814
quantile(tab_globale_2_$KGE_HER_AnneeValid_logit_CValid_general,probs = 0.25) # 0.711
quantile(tab_globale_2_$KGE_HER_AnneeValid_logit_CValid_general,probs = 0.75) # 0.863

tab_globale_2_median_ <- tab_globale_2_ %>%
  group_by(HER) %>%
  summarize(KGE = median(KGE_HER_AnneeValid_logit_CValid_general))
median(tab_globale_2_median_$KGE) # 0.8135
table(tab_globale_2_median_$KGE>0.8) # 43/75

median(tab_globale_2_$NASH_HER_AnneeValid_logit_CValid_general) # 0.737
quantile(tab_globale_2_$NASH_HER_AnneeValid_logit_CValid_general,probs = 0.25) # 0.643
quantile(tab_globale_2_$NASH_HER_AnneeValid_logit_CValid_general,probs = 0.75) # 0.802

median(tab_globale_2_$ErreurMoyenneAbsolue_general) # 0.043
quantile(tab_globale_2_$ErreurMoyenneAbsolue_general,probs = 0.25) # 0.031
quantile(tab_globale_2_$ErreurMoyenneAbsolue_general,probs = 0.75) # 0.062

median(tab_globale_2_$RMSE_general) # 0.064
quantile(tab_globale_2_$RMSE_general,probs = 0.25) # 0.043
quantile(tab_globale_2_$RMSE_general,probs = 0.75) # 0.082

median(tab_globale_2_$P_assecs_HER_MoyenneGlobale_Predit_general) # 11.276

# J2000 #
nom_categorieSimu_ <- nom_categorieSimu_list_[3]
tab_globale_3_ = data.frame()
folders_3_ <- list.files(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/",nom_categorieSimu_),
                         pattern = "ModelResults.*logit.csv", recursive = T, include.dirs = F, full.names = T)
folders_3_ <- folders_3_[grepl("TableGlobale",folders_3_)]
folders_3_ <- folders_3_[grepl("ADAMONT",folders_3_)]

for (f in folders_3_){
  tab_3_ <- read.table(f, header = T, sep = ";", dec = ".")
  tab_3_$Chaine <- str_split(f,"/")[[1]][13]
  tab_3_$Rcp <- str_split(f,"/")[[1]][11]
  tab_3_$Categorie <- nom_categorieSimu_
  
  if (length(tab_globale_3_)==0){
    tab_globale_3_ <- tab_3_
  }else{
    tab_globale_3_ <- rbind(tab_globale_3_, tab_3_)
  }
}
table(tab_globale_3_$Rcp,tab_globale_3_$Categorie)
dim(tab_globale_3_) # 1368
median(tab_globale_3_$KGE_HER_AnneeValid_logit_CValid_general) # 0.689
quantile(tab_globale_3_$KGE_HER_AnneeValid_logit_CValid_general,probs = 0.25) # 0.626
quantile(tab_globale_3_$KGE_HER_AnneeValid_logit_CValid_general,probs = 0.75) # 0.785

tab_globale_3_median_ <- tab_globale_3_ %>%
  group_by(HER) %>%
  summarize(KGE = median(KGE_HER_AnneeValid_logit_CValid_general))
median(tab_globale_3_median_$KGE) # 0.68825
table(tab_globale_3_median_$KGE>0.8) # 5/33

median(tab_globale_3_$NASH_HER_AnneeValid_logit_CValid_general) # 0.6125
quantile(tab_globale_3_$NASH_HER_AnneeValid_logit_CValid_general,probs = 0.25) # 0.5138
quantile(tab_globale_3_$NASH_HER_AnneeValid_logit_CValid_general,probs = 0.75) # 0.708

median(tab_globale_3_$ErreurMoyenneAbsolue_general) # 0.061
quantile(tab_globale_3_$ErreurMoyenneAbsolue_general,probs = 0.25) # 0.044
quantile(tab_globale_3_$ErreurMoyenneAbsolue_general,probs = 0.75) # 0.091

median(tab_globale_3_$RMSE_general) # 0.091
quantile(tab_globale_3_$RMSE_general,probs = 0.25) # 0.064
quantile(tab_globale_3_$RMSE_general,probs = 0.75) # 0.124

median(tab_globale_3_$P_assecs_HER_MoyenneGlobale_Predit_general) # 12.3775

# ORCHIDEE #
nom_categorieSimu_ <- nom_categorieSimu_list_[4]
tab_globale_4_ = data.frame()
folders_4_ <- list.files(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/",nom_categorieSimu_),
                         pattern = "ModelResults.*logit.csv", recursive = T, include.dirs = F, full.names = T)
folders_4_ <- folders_4_[grepl("TableGlobale",folders_4_)]
folders_4_ <- folders_4_[grepl("ADAMONT",folders_4_)]

for (f in folders_4_){
  tab_4_ <- read.table(f, header = T, sep = ";", dec = ".")
  tab_4_$Chaine <- str_split(f,"/")[[1]][13]
  tab_4_$Rcp <- str_split(f,"/")[[1]][11]
  tab_4_$Categorie <- nom_categorieSimu_
  
  if (length(tab_globale_4_)==0){
    tab_globale_4_ <- tab_4_
  }else{
    tab_globale_4_ <- rbind(tab_globale_4_, tab_4_)
  }
}
table(tab_globale_4_$Rcp,tab_globale_4_$Categorie)
dim(tab_globale_4_) # 2700
median(tab_globale_4_$KGE_HER_AnneeValid_logit_CValid_general) # 0.5995
quantile(tab_globale_4_$KGE_HER_AnneeValid_logit_CValid_general,probs = 0.25) # 0.497
quantile(tab_globale_4_$KGE_HER_AnneeValid_logit_CValid_general,probs = 0.75) # 0.722

tab_globale_4_median_ <- tab_globale_4_ %>%
  group_by(HER) %>%
  summarize(KGE = median(KGE_HER_AnneeValid_logit_CValid_general))
median(tab_globale_4_median_$KGE) # 0.6035
table(tab_globale_4_median_$KGE>0.8) # 7/75

median(tab_globale_4_$NASH_HER_AnneeValid_logit_CValid_general) # 0.485
quantile(tab_globale_4_$NASH_HER_AnneeValid_logit_CValid_general,probs = 0.25) # 0.392
quantile(tab_globale_4_$NASH_HER_AnneeValid_logit_CValid_general,probs = 0.75) # 0.627

median(tab_globale_4_$ErreurMoyenneAbsolue_general) # 0.06
quantile(tab_globale_4_$ErreurMoyenneAbsolue_general,probs = 0.25) # 0.042
quantile(tab_globale_4_$ErreurMoyenneAbsolue_general,probs = 0.75) # 0.087

median(tab_globale_4_$RMSE_general) # 0.082
quantile(tab_globale_4_$RMSE_general,probs = 0.25) # 0.061
quantile(tab_globale_4_$RMSE_general,probs = 0.75) # 0.115

median(tab_globale_4_$P_assecs_HER_MoyenneGlobale_Predit_general) # 11.276

# SMASH
nom_categorieSimu_ <- nom_categorieSimu_list_[5]
tab_globale_5_ = data.frame()
folders_5_ <- list.files(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/",nom_categorieSimu_),
                         pattern = "ModelResults.*logit.csv", recursive = T, include.dirs = F, full.names = T)
folders_5_ <- folders_5_[grepl("TableGlobale",folders_5_)]
folders_5_ <- folders_5_[grepl("ADAMONT",folders_5_)]

for (f in folders_5_){
  tab_5_ <- read.table(f, header = T, sep = ";", dec = ".")
  tab_5_$Chaine <- str_split(f,"/")[[1]][13]
  tab_5_$Rcp <- str_split(f,"/")[[1]][11]
  tab_5_$Categorie <- nom_categorieSimu_
  
  if (length(tab_globale_5_)==0){
    tab_globale_5_ <- tab_5_
  }else{
    tab_globale_5_ <- rbind(tab_globale_5_, tab_5_)
  }
}
table(tab_globale_5_$Rcp,tab_globale_5_$Categorie)
dim(tab_globale_5_) # 2700
median(tab_globale_5_$KGE_HER_AnneeValid_logit_CValid_general) # 0.804
quantile(tab_globale_5_$KGE_HER_AnneeValid_logit_CValid_general,probs = 0.25) # 0.716
quantile(tab_globale_5_$KGE_HER_AnneeValid_logit_CValid_general,probs = 0.75) # 0.863

tab_globale_5_median_ <- tab_globale_5_ %>%
  group_by(HER) %>%
  summarize(KGE = median(KGE_HER_AnneeValid_logit_CValid_general))
median(tab_globale_5_median_$KGE) # 0.807
table(tab_globale_5_median_$KGE>0.8) # 38/75

median(tab_globale_5_$NASH_HER_AnneeValid_logit_CValid_general) # 0.714
quantile(tab_globale_5_$NASH_HER_AnneeValid_logit_CValid_general,probs = 0.25) # 0.6518
quantile(tab_globale_5_$NASH_HER_AnneeValid_logit_CValid_general,probs = 0.75) # 0.797

median(tab_globale_5_$ErreurMoyenneAbsolue_general) # 0.043
quantile(tab_globale_5_$ErreurMoyenneAbsolue_general,probs = 0.25) # 0.031
quantile(tab_globale_5_$ErreurMoyenneAbsolue_general,probs = 0.75) # 0.063

median(tab_globale_5_$RMSE_general) # 0.064
quantile(tab_globale_5_$RMSE_general,probs = 0.25) # 0.046
quantile(tab_globale_5_$RMSE_general,probs = 0.75) # 0.082

median(tab_globale_5_$P_assecs_HER_MoyenneGlobale_Predit_general) # 11.276




