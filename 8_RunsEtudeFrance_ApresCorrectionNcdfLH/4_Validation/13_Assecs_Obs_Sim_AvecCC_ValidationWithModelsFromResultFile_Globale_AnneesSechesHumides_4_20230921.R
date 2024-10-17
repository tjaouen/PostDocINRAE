source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/6_RunsEtudeFrance_CorrectionImportOnde_20230607/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/6_RunsEtudeFrance_CorrectionImportOnde_20230607/3_Validation/11_Func_Relation_AvecCC_ValidationSansLearn_Globale_11_20230607.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/6_RunsEtudeFrance_CorrectionImportOnde_20230607/3_Validation/11_Func_Relation_AvecCC_ValidationSansLearn_Globale_12_20230616.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/6_RunsEtudeFrance_CorrectionImportOnde_20230607/3_Validation/11_Func_Relation_AvecCC_ValidationSansLearn_Globale_13_20230703.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/6_RunsEtudeFrance_CorrectionImportOnde_20230607/3_Validation/11_Func_Relation_AvecCC_ValidationSansLearn_Globale_14_20230816.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/6_RunsEtudeFrance_CorrectionImportOnde_20230607/3_Validation/11_Func_Relation_AvecCC_ValidationSansLearn_Globale_14_20230816.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/4_Validation/11_Func_Relation_AvecCC_ValidationSansLearn_Globale_14_20230816.R")

source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunObs20122019.R")

### Libraries ###
library(strex)

### Study data ###
folder_output_ = folder_output_param_
nomSim_ = nomSim_param_
HER_ = HER_param_
jourMin_ = jourMin_param_
jourMax_ = jourMax_param_
regr = "logit"
annees_validModels_ = annees_validModels_param_

nom_categorieSimu_ = nom_categorieSimu_param_
nom_apprentissage_ = nom_apprentissage_param_
nom_validation_ = nom_validation_param_
nomSim_ = nomSim_param_
nom_GCM_ = nom_GCM_param_

### Input ###
liste <- c(list.files(paste0(folder_output_,"1_MatricesInputModeles_ParHERDates/",
                             nomSim_,
                             ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_))), pattern="MatInputModel_CampOndeExcl_", full.names = T))

if (nom_GCM_ != ""){
  il = liste[grepl(nom_GCM_, liste)]
}else{
  il = liste[1]  
}

### Table predictions - Leave One Year Out ###
tab_comp_ = data.frame()
# for (a in 2012:2022){
#   print(a)

if (dir.exists(paste0(folder_output_,
                      "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableParMoisAnnees/Results_Jm",jourMin_,"Jj/"))){
  tab_ <- read.table(paste0(folder_output_,
                            "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                            nomSim_,
                            ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                            ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                            ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                            "/TableParMoisAnnees/Results_Jm",jourMin_,"Jj/ModelResults_ParDate_",str_after_nth(str_before_last(basename(il), "\\."),"\\_",2),"_Valid_",paste(substr(annees_validModels_,3,4),collapse = "-"),
                            "_J",ifelse(jourMin_ == 0,"j",paste0("m",jourMin_)),"J",ifelse(jourMax_ == 0,"j",paste0("m",jourMax_)),"_logit.csv"),
                     sep = ";", dec = ".", header = T)
}else if (dir.exists(paste0(folder_output_,
                            "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                            nomSim_,
                            ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                            ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                            ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                            "/TableParMoisAnnees/Results_Jm",jourMin_,"Jj/"))){
  tab_ <- read.table(paste0(folder_output_,
                            "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                            nomSim_,
                            ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                            ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                            ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                            "/TableParMoisAnnees/Results_Jm",jourMin_,"Jj/ModelResults_ParDate_",str_after_nth(str_before_last(basename(il), "\\."),"\\_",2),"_Valid_",paste(substr(annees_validModels_,3,4),collapse = "-"),
                            "_J",ifelse(jourMin_ == 0,"j",paste0("m",jourMin_)),"J",ifelse(jourMax_ == 0,"j",paste0("m",jourMax_)),"_logit.csv"),
                     sep = ";", dec = ".", header = T)
}
tab_comp_ <- rbind(tab_comp_,tab_)
# }
table(tab_comp_$Date)
liste_Her=sort(unique(tab_comp_$HER2))

### Bootstrap ###
out_ValidationGlobale_ <- FUNC_CAL_VAL_ValidationSansLearn_Globale(annee = 1, Matrice_comp = tab_comp_, liste_Her = liste_Her, nbrRep = 100, proportionTest = 0.65)
out_ValidationGlobale_$Biais_boot

if (dir.exists(paste0(folder_output_,
                      "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/"))){
  write.table(data.frame(out_ValidationGlobale_), paste0(folder_output_,
                                                         "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                                                         nomSim_,
                                                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                                                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                                                         "/TableGlobale/ModelResults_ParDate_",str_after_nth(str_before_last(basename(il), "\\."),"\\_",2),"_ValidGlobale_",paste(substr(annees_validModels_,3,4),collapse = "-"),
                                                         "_J",ifelse(jourMin_ == 0,"j",paste0("m",jourMin_)),"J",ifelse(jourMax_ == 0,"j",paste0("m",jourMax_)),"_logit.csv"),
              dec = ".", sep=";", row.name=F) #Pourquoi s'appelle validation ?
}else if (dir.exists(paste0(folder_output_,"15_ResultatsModeles_ValidationParAnnees_ParHer/",nomSim_,"/Validation_Globale/"))){
  write.table(data.frame(out_ValidationGlobale_), paste0(folder_output_,
                                                         "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                                                         nomSim_,
                                                         ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                                         ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                                                         ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                                                         "/TableGlobale/ModelResults_ParDate_",str_after_nth(str_before_last(basename(il), "\\."),"\\_",2),"_ValidGlobale_",paste(substr(annees_validModels_,3,4),collapse = "-"),
                                                         "_J",ifelse(jourMin_ == 0,"j",paste0("m",jourMin_)),"J",ifelse(jourMax_ == 0,"j",paste0("m",jourMax_)),"_logit.csv"),
              dec = ".", sep=";", row.name=F) #Pourquoi s'appelle validation ?
}
# write.table(out_ValidationGlobale_, paste0(folder_output_,"15_ResultatsModeles_ValidationParAnnees_ParHer/",nomSim_,
#                                            "/LeaveOneYearOut/Validation_Globale/ModelResults_ParDate_",str_after_nth(str_before_last(basename(il), "\\."),"\\_",2),"_ValidGlobale_",
#                                            "_J",ifelse(jourMin_ == 0,"j",paste0("m",jourMin_)),"J",ifelse(jourMax_ == 0,"j",paste0("m",jourMax_)),"_logit_kge.csv"),
#             dec = ".", sep=";", row.name=F, quote=F) #Pourquoi s'appelle validation ?


# ### Validation annees seches, intermediaires, humides ###
# annees_validModels_ <- annees_validModels_param_
# tab_comp_ <- read.table(paste0(folder_output_,"15_ResultatsModeles_ValidationParAnnees_ParHer/",nomSim_,
#                                "/Validation_ParMoisAnnees/Results_Jm",jourMin_,"Jj/ModelResults_ParDate_",str_after_nth(str_before_last(basename(il), "\\."),"\\_",2),"_Valid_",paste(annees_validModels_, collapse = "-"),
#                                "_J",ifelse(jourMin_ == 0,"j",paste0("m",jourMin_)),"J",ifelse(jourMax_ == 0,"j",paste0("m",jourMax_)),"_logit_kge.csv"),
#                      sep = ";", dec = ".", header = T)
# liste_Her=sort(unique(tab_comp_$HER2))
# 
# ### Bootstrap ###
# out_ValidationGlobale_ <- FUNC_CAL_VAL_ValidationSansLearn_Globale(annee = 1, Matrice_comp = tab_comp_, liste_Her = liste_Her, nbrRep = 100, proportionTest = 0.65)
# 
# write.table(out_ValidationGlobale_, paste0(folder_output_,"15_ResultatsModeles_ValidationParAnnees_ParHer/",nomSim_,
#                                            "/Validation_Globale/ModelResults_ParDate_",str_after_nth(str_before_last(basename(il), "\\."),"\\_",2),"_ValidGlobale_",paste(annees_validModels_, collapse = "-"),
#                                            "_J",ifelse(jourMin_ == 0,"j",paste0("m",jourMin_)),"J",ifelse(jourMax_ == 0,"j",paste0("m",jourMax_)),"_logit_kge.csv"), sep=";", row.name=F, quote=F) #Pourquoi s'appelle validation ?
# 



