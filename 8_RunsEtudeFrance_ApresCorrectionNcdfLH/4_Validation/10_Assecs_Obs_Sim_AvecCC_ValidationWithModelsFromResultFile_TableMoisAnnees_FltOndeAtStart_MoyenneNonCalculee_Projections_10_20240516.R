### Libraries ###
library(lubridate)
library(strex)
library(rgdal)

### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/3_Validation/11_Func_Relation_AvecCC_ValidationSansLearn_SansIC_ParAnnees_9_20230524.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/3_Validation/11_Func_Relation_AvecCC_ValidationSansLearn_SansIC_ParMoisAnnees_10_20230602.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/2_Run/5_ObtenirAppliquerSeuilsDonneesOndeSurMatriceInput_1_20230607.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")

# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")

# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunObs20122019.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/4_Validation/11_Func_Relation_AvecCC_ValidationSansLearn_SansIC_ParAnnees_9_20230524.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/4_Validation/11_Func_Relation_AvecCC_ValidationSansLearn_SansIC_ParMoisAnnees_10_20230602.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/3_Run/6_ObtenirAppliquerSeuilsDonneesOndeSurMatriceInput_1_20230607.R")

# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/3_Validation/11_Func_Relation_AvecCC_ValidationSansLearn_SansIC_ParAnnees_9_20230524.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/3_Validation/11_Func_Relation_AvecCC_ValidationSansLearn_SansIC_ParMoisAnnees_10_20230602.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/4_Validation/11_Func_Relation_AvecCC_ValidationSansLearn_SansIC_ParAnnees_9_20230524.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/4_Validation/11_Func_Relation_AvecCC_ValidationSansLearn_SansIC_ParMoisAnnees_10_20230602.R")

### Study data ###
folder_output_ = folder_output_param_
nomSim_ = nomSim_param_
nom_categorieSimu_ = nom_categorieSimu_param_
nom_apprentissage_ = nom_apprentissage_param_
nom_validation_ = nom_validation_param_
HER_ = HER_param_
annees_learnModels_p_ = annees_learnModels_param_
annees_validModels_p_ = annees_validModels_param_
jourMin_ = jourMin_param_
jourMax_ = jourMax_param_
regr = "logit"
nom_GCM_ = nom_GCM_param_

# nom_apprentissage_ = "ApprentissageLeaveOneYearOut"
nom_apprentissage_ = "ApprentissageGlobalModelesBruts"
# nom_validation_ = "Validation_2LeaveOneYearOut"


### Run ###
# liste <- c(list.files(paste0(folder_output_,"1_MatricesInputModeles_ParHERDates/",nomSim_,ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_))), pattern="MatInputModel_CampOndeExcl", full.names = T))
liste <- c(list.files(paste0(folder_output_,
                             "1_MatricesInputModeles_ParHERDates/",
                             nomSim_,
                             ifelse(nom_categorieSimu_=="","",paste0("/",str_before_last(str_before_last(nom_categorieSimu_,"/"),"/"))),"/",
                             # ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                             ifelse(nom_GCM_=="","",paste0("/",nom_GCM_))),
                      pattern="MatInputModel_CampOndeExcl", full.names = T, recursive = T, include.dirs = F))
NSE <- c()
colNSE <- c()

########################################
### CHOIX DE LA SIMU ###################
########################################
# il = liste[1]
# il = liste[4]
# if (nom_GCM_ != ""){
#   il = liste[grepl(nom_GCM_, liste)]
# }else{
#   il = liste[1]
# }
########################################


for (il in liste){
  
  onde = read.table(il, header = T, sep = ";", row.names = NULL, quote="")
  if (dim(onde)[2] == 1){
    onde = read.table(il, header = T, sep = ",", row.names = NULL, quote="")
  }
  # onde = onde[which((!is.na(onde[,c("Freq_j")])) & !is.na(onde[,c("Freq_jmoins5")])),]
  onde = onde[which((!is.na(onde$Freq_Jm6Jj))),]
  liste_Her=sort(unique(onde[,1]))
  
  ### Selection dates learn ###
  onde <- onde[which(format(as.Date(onde$Date),"%Y") %in% annees_validModels_p_),]
  annees_learnModels_p_ <- annees_learnModels_p_[which(annees_learnModels_p_ %in% year(as.Date(onde$Date)))]
  
  seuils_ <- obtenirSeuilsOnde(MatriceInput = onde, Niveau = 0.75)
  onde <- indiquerSeuilsOndeBinaire(tab_ = onde, Seuil_df_ = seuils_)[[1]]
  # list_ <- appliquerSeuilsOnde(tab_ = onde, Seuil_df_ = seuils_)
  # onde <- list_[[1]]
  
  # for (an in annees_learnModels_p_){
    
  # annees_learnModels_ = annees_learnModels_p_[which(annees_learnModels_p_ != an)]
  annees_validModels_ = annees_learnModels_
  
  ### Tab modeles ###
  # tab_Reg_ <- read.table(paste0(folder_output_,"2_ResultatsModeles_ParHer/",nomSim_,"/ModelResults_",str_after_nth(str_before_last(basename(il), "\\."),"\\_",2),"_",paste(annees_learnModels_,collapse = "-"),"_logit.csv"), sep=";", dec = ".", header=T)
  
  # tab_Reg_ <- read.table(paste0(folder_output_,
  #                               "2_ResultatsModeles_ParHer/",
  #                               nomSim_,
  #                               ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
  #                               ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
  #                               str_after_last(str_before_last(il,"/"),"/"),"/",
  #                               ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
  #                               "/ModelResults_",str_after_nth(str_before_last(basename(il), "\\."),"\\_",2),"_",paste(substr(annees_learnModels_,3,4),collapse = "-"),
  #                               "_J",ifelse(jourMin_ == 0,"j",paste0("m",jourMin_)),"J",ifelse(jourMax_ == 0,"j",paste0("m",jourMax_)),"_logit.csv"), sep=";", dec = ".", header=T)
  # tab_Reg_ <- read.table(list.files(paste0(folder_output_,
  #                                          "2_ResultatsModeles_ParHer/",
  #                                          nomSim_,
  #                                          ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
  #                                          ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
  #                                          str_after_last(str_before_last(il,"/"),"/"),"/",
  #                                          ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),"/"),
  #                                   pattern = "ModelResults_.*logit.csv", full.names = T), sep=";", dec = ".", header=T)
  
  tab_Reg_ <- read.table(list.files(gsub("1_MatricesInputModeles_ParHERDates","2_ResultatsModeles_ParHer",str_before_last(il,"/")),
                                    pattern = "ModelResults_.*logit.csv", full.names = T, recursive = T), sep=";", dec = ".", header=T)
  
  ### Validation par (Mois,Annee) ###
  #Validation brute sur toutes les années tests mais affichage des valeurs pour chaque Mois-Année
  
  #annee,Matrice_comp,liste_Her,regression,tab_Reg_,jourMin_,jourMax_
  
  Assecs_val = FUNC_CAL_VAL_ValidationSansLearn_SansIC_ParDate(1,onde,liste_Her,regr,tab_Reg_,jourMin_ = jourMin_, jourMax_ = jourMax_)
  Assecs_val[4:ncol(Assecs_val)] = round(Assecs_val[4:ncol(Assecs_val)],3)
  
  nom_categorieSimu_ <- paste(strsplit(il, "/")[[1]][10:12],collapse = "/")
  
  if (dir.exists(paste0(folder_output_,
                        "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                        # ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                        # ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                        "/TableParMoisAnnees/"))){
    if (!(dir.exists(paste0(folder_output_,
                            "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                            nomSim_,
                            ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                            ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                            # ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                            # ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                            "/TableParMoisAnnees/Results_Jm",jourMin_,"Jj/")))){
      dir.create(paste0(folder_output_,
                        "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                        # ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                        # ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                        "/TableParMoisAnnees/Results_Jm",jourMin_,"Jj/"))
    }
    if (!(dir.exists(paste0(folder_output_,
                            "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                            nomSim_,
                            ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                            ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                            # ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                            # ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                            "/TableParMoisAnnees/Results_Jm",jourMin_,"Jj/",
                            str_after_last(str_before_last(il,"/"),"/"),"/")))){
      dir.create(paste0(folder_output_,
                        "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                        # ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                        # ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                        "/TableParMoisAnnees/Results_Jm",jourMin_,"Jj/",
                        str_after_last(str_before_last(il,"/"),"/"),"/"))
    }
    
    write.table(Assecs_val, paste0(folder_output_,
                                   "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                                   nomSim_,
                                   ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                   ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                                   # ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                                   # ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                                   "/TableParMoisAnnees/Results_Jm",jourMin_,"Jj/",
                                   str_after_last(str_before_last(il,"/"),"/"),"/",
                                   "ModelResults_ParDate_",str_after_nth(str_before_last(basename(il), "\\."),"\\_",2),"_Valid_",paste(substr(annees_validModels_,3,4),collapse = "-"),
                                   "_J",ifelse(jourMin_ == 0,"j",paste0("m",jourMin_)),"J",ifelse(jourMax_ == 0,"j",paste0("m",jourMax_)),"_logit.csv"), sep=";", row.name=F, quote=F) #Pourquoi s'appelle validation ?
  }else{
    if (!(dir.exists(paste0(folder_output_,
                            "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                            nomSim_,
                            ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                            ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                            # ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                            # ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                            "/TableParMoisAnnees/Results_Jm",jourMin_,"Jj/")))){
      dir.create(paste0(folder_output_,
                        "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                        # ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                        # ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                        "/TableParMoisAnnees/Results_Jm",jourMin_,"Jj/"))
    }
    
    if (!(dir.exists(paste0(folder_output_,
                            "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                            nomSim_,
                            ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                            ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                            # ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                            # ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                            "/TableParMoisAnnees/Results_Jm",jourMin_,"Jj/",
                            str_after_last(str_before_last(il,"/"),"/"),"/")))){
      dir.create(paste0(folder_output_,
                        "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                        # ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                        # ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                        "/TableParMoisAnnees/Results_Jm",jourMin_,"Jj/",
                        str_after_last(str_before_last(il,"/"),"/"),"/"))
    }
    
    write.table(Assecs_val, paste0(folder_output_,
                                   "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                                   nomSim_,
                                   ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                   ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                                   # ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                                   # ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                                   "/TableParMoisAnnees/Results_Jm",jourMin_,"Jj/",
                                   str_after_last(str_before_last(il,"/"),"/"),"/",
                                   "ModelResults_ParDate_",str_after_nth(str_before_last(basename(il), "\\."),"\\_",2),"_Valid_",paste(substr(annees_validModels_,3,4),collapse = "-"),
                                   "_J",ifelse(jourMin_ == 0,"j",paste0("m",jourMin_)),"J",ifelse(jourMax_ == 0,"j",paste0("m",jourMax_)),"_logit.csv"), sep=";", row.name=F, quote=F) #Pourquoi s'appelle validation ?
  }
    
  # }
  
}

