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


tab_globale_ = data.frame()
for (nom_categorieSimu_ in nom_categorieSimu_list_){
  
  folders_ <- list.files(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/",nom_categorieSimu_),
                         pattern = "ModelResults.*logit.csv", recursive = T, include.dirs = F, full.names = T)
  folders_ <- folders_[grepl("TableGlobale",folders_)]
  folders_ <- folders_[grepl("ADAMONT",folders_)]
  
  for (f in folders_){
    tab_ <- read.table(f, header = T, sep = ";", dec = ".")
    tab_$Chaine <- str_split(f,"/")[[1]][13]
    tab_$Rcp <- str_split(f,"/")[[1]][11]
    tab_$Categorie <- nom_categorieSimu_
    
    if (length(tab_globale_)==0){
      tab_globale_ <- tab_
    }else{
      tab_globale_ <- rbind(tab_globale_, tab_)
    }
  }
}

table(tab_globale_$Rcp,tab_globale_$Categorie)

dim(tab_globale_)
#CTRIP, GRSD, ORCHIDEE, SMASH 75*(10+9+17)*4
#J2000 38*(10+9+17)*1

tab_globale_[,c("KGE_HER_AnneeValid_logit_CValid_general","Categorie")]

tab_res_ <- tab_globale_ %>%
  group_by(Categorie) %>%
  summarize(KGE = paste0(median(KGE_HER_AnneeValid_logit_CValid_general),
                         " (IQ: ",
                         quantile(KGE_HER_AnneeValid_logit_CValid_general, probs = 0.25),
                         "-",
                         quantile(KGE_HER_AnneeValid_logit_CValid_general, probs = 0.75),
                         ")"),
            NASH = paste0(median(NASH_HER_AnneeValid_logit_CValid_general),
                          " (IQ: ",
                          quantile(NASH_HER_AnneeValid_logit_CValid_general, probs = 0.25),
                          "-",
                          quantile(NASH_HER_AnneeValid_logit_CValid_general, probs = 0.75),
                          ")"),
            RMSE = paste0(median(RMSE_general),
                          " (IQ: ",
                          quantile(RMSE_general, probs = 0.25),
                          "-",
                          quantile(RMSE_general, probs = 0.75),
                          ")"),
            MAE = paste0(median(ErreurMoyenneAbsolue_general),
                         " (IQ: ",
                         quantile(ErreurMoyenneAbsolue_general, probs = 0.25),
                         "-",
                         quantile(ErreurMoyenneAbsolue_general, probs = 0.75),
                         ")"),
            Deviance = paste0(median(PropParameterDeviance_logit_Learn_general),
                              " (IQ: ",
                              quantile(PropParameterDeviance_logit_Learn_general, probs = 0.25),
                              "-",
                              quantile(PropParameterDeviance_logit_Learn_general, probs = 0.75),
                              ")"),
            BiaisMean = paste0(mean(Biais_general),
                           " (95% IC: ",
                           # quantile(Biais_general, probs = 0.025),
                           quantile(Biais_general, probs = 0.25),
                           "-",
                           # quantile(Biais_general, probs = 0.975),
                           quantile(Biais_general, probs = 0.75),
                           ")"),
            ProbaPredite = paste0(median(P_assecs_HER_MoyenneGlobale_Predit_general),
                                  " (IQ: ",
                                  quantile(P_assecs_HER_MoyenneGlobale_Predit_general, probs = 0.25),
                                  "-",
                                  quantile(P_assecs_HER_MoyenneGlobale_Predit_general, probs = 0.75),
                                  ")"),
            ProbaApredire = paste0(median(P_assecs_HER_MoyenneGlobale_Apredire_general),
                                   " (IQ: ",
                                   quantile(P_assecs_HER_MoyenneGlobale_Apredire_general, probs = 0.25),
                                   "-",
                                   quantile(P_assecs_HER_MoyenneGlobale_Apredire_general, probs = 0.75),
                                   ")"))

# write.table(tab_res_,
#             "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/TableGlobaleMerge/Table_ValidationSafran_1_20240517.csv",
#             sep = ";", dec = ".", row.names = F)
write.table(tab_res_,
            "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/TableGlobaleMerge/Table_ValidationSafran_quartileBiais_1_20240821.csv",
            sep = ";", dec = ".", row.names = F)




### Resultats CTRIP ###
# median(tab_globale_$KGE_HER_AnneeValid_logit_CValid_general)
# quantile(tab_globale_$KGE_HER_AnneeValid_logit_CValid_general, probs = 0.25)
# quantile(tab_globale_$KGE_HER_AnneeValid_logit_CValid_general, probs = 0.75)
# 
# median(tab_globale_$NASH_HER_AnneeValid_logit_CValid_general)
# quantile(tab_globale_$NASH_HER_AnneeValid_logit_CValid_general, probs = 0.25)
# quantile(tab_globale_$NASH_HER_AnneeValid_logit_CValid_general, probs = 0.75)
# 
# median(tab_globale_$RMSE_general)
# quantile(tab_globale_$RMSE_general, probs = 0.25)
# quantile(tab_globale_$RMSE_general, probs = 0.75)
# 
# median(tab_globale_$ErreurMoyenneAbsolue_general)
# quantile(tab_globale_$ErreurMoyenneAbsolue_general, probs = 0.25)
# quantile(tab_globale_$ErreurMoyenneAbsolue_general, probs = 0.75)

# > median(tab_globale_$KGE_HER_AnneeValid_logit_CValid_general)
# [1] 0.801
# > quantile(tab_globale_$KGE_HER_AnneeValid_logit_CValid_general, probs = 0.25)
# 25% 
# 0.69275 
# > quantile(tab_globale_$KGE_HER_AnneeValid_logit_CValid_general, probs = 0.75)
# 75% 
# 0.854 
# > 
#   > median(tab_globale_$NASH_HER_AnneeValid_logit_CValid_general)
# [1] 0.735
# > quantile(tab_globale_$NASH_HER_AnneeValid_logit_CValid_general, probs = 0.25)
# 25% 
# 0.607 
# > quantile(tab_globale_$NASH_HER_AnneeValid_logit_CValid_general, probs = 0.75)
# 75% 
# 0.799 
# > 
#   > median(tab_globale_$RMSE_general)
# [1] 0.069
# > quantile(tab_globale_$RMSE_general, probs = 0.25)
# 25% 
# 0.052 
# > quantile(tab_globale_$RMSE_general, probs = 0.75)
# 75% 
# 0.1 
# > 
# > median(tab_globale_$ErreurMoyenneAbsolue_general)
# [1] 0.049
# > quantile(tab_globale_$ErreurMoyenneAbsolue_general, probs = 0.25)
# 25% 
# 0.035 
# > quantile(tab_globale_$ErreurMoyenneAbsolue_general, probs = 0.75)
# 75% 
# 0.072 
