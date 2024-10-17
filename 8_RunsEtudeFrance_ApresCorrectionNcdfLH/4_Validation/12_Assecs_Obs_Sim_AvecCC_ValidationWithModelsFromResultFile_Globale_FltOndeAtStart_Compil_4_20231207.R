source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/3_Validation/11_Func_Relation_AvecCC_ValidationSansLearn_Globale_14_20230816.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/4_Validation/11_Func_Relation_AvecCC_ValidationSansLearn_Globale_14_20230816.R")

source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunObs20122019.R")

### Libraries ###
library(strex)
library(data.table)

### Study data ###
folder_output_ = folder_output_param_
nom_categorieSimu_ = nom_categorieSimu_param_
nom_apprentissage_ = nom_apprentissage_param_
nom_validation_ = nom_validation_param_
nomSim_ = nomSim_param_
nom_GCM_ = nom_GCM_param_
HER_ = HER_param_
jourMin_ = jourMin_param_
jourMax_ = jourMax_param_
regr = "logit"

nom_apprentissage_ = "ApprentissageLeaveOneYearOut"
nom_validation_ = "Validation_2LeaveOneYearOut"

### Input ###
# liste <- c(list.files(paste0(folder_output_,
#                              "1_MatricesInputModeles_ParHERDates/",
#                              nomSim_,
#                              ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_))), pattern="MatInputModel_CampOndeExcl", full.names = T))
liste <- c(list.files(paste0(folder_output_,
                             "1_MatricesInputModeles_ParHERDates/",
                             nomSim_,
                             ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                             ifelse(nom_GCM_=="","",paste0("/",nom_GCM_))),
                      pattern="MatInputModel_CampOndeExcl", full.names = T))


########################################
### CHOIX DE LA SIMU ###################
########################################
# il = liste[1]
# il = liste[4]
if (nom_GCM_ != ""){
  il = liste[grepl(nom_GCM_,liste)]
}else{
  il = liste[1]
}
########################################

### Table predictions - Leave One Year Out ###
tab_comp_ = data.frame()
# for (a in 2012:2019){
# for (a in 2012:2020){
for (a in 2012:2022){
  print(a)
  
  if (dir.exists(paste0(folder_output_,
                        "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                        ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                        ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                        "/TableParCategories/Results_Jm",jourMin_,"Jj/"))){
    
    if (file.exists(paste0(folder_output_,
                           "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                           nomSim_,
                           ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                           ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                           ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                           ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                           "/TableParMoisAnnees/Results_Jm",jourMin_,"Jj/ModelResults_ParDate_",str_after_nth(str_before_last(basename(il), "\\."),"\\_",2),"_Valid_",substr(a,3,4),
                           "_J",ifelse(jourMin_ == 0,"j",paste0("m",jourMin_)),"J",ifelse(jourMax_ == 0,"j",paste0("m",jourMax_)),"_logit.csv"))){
      tab_ <- read.table(paste0(folder_output_,
                                "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                                nomSim_,
                                ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                                ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                                ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                                "/TableParMoisAnnees/Results_Jm",jourMin_,"Jj/ModelResults_ParDate_",str_after_nth(str_before_last(basename(il), "\\."),"\\_",2),"_Valid_",substr(a,3,4),
                                "_J",ifelse(jourMin_ == 0,"j",paste0("m",jourMin_)),"J",ifelse(jourMax_ == 0,"j",paste0("m",jourMax_)),"_logit.csv"),
                         sep = ";", dec = ".", header = T)
    }else{
      print(paste0("File does not exists: ",paste0(folder_output_,
                                                   "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                                                   nomSim_,
                                                   ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                                   ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                                                   ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                                                   ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                                                   "/TableParMoisAnnees/Results_Jm",jourMin_,"Jj/ModelResults_ParDate_",str_after_nth(str_before_last(basename(il), "\\."),"\\_",2),"_Valid_",substr(a,3,4),
                                                   "_J",ifelse(jourMin_ == 0,"j",paste0("m",jourMin_)),"J",ifelse(jourMax_ == 0,"j",paste0("m",jourMax_)),"_logit.csv")))
    }
    
  }else if (dir.exists(paste0(folder_output_,
                              "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                              nomSim_,
                              ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                              ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                              ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                              ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                              "/TableParCategories/Results_Jm",jourMin_,"Jj/"))){
    
    tab_ <- read.table(paste0(folder_output_,
                              "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                              nomSim_,
                              ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                              ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                              ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                              ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                              "/TableParMoisAnnees/Results_Jm",jourMin_,"Jj/ModelResults_ParDate_",str_after_nth(str_before_last(basename(il), "\\."),"\\_",2),"_Valid_",substr(a,3,4),
                              "_J",ifelse(jourMin_ == 0,"j",paste0("m",jourMin_)),"J",ifelse(jourMax_ == 0,"j",paste0("m",jourMax_)),"_logit.csv"),
                       sep = ";", dec = ".", header = T)
  }
  tab_comp_ <- rbind(tab_comp_,tab_)
}
table(tab_comp_$Date)
liste_Her=sort(unique(tab_comp_$HER2))

### Bootstrap ###
out_ValidationGlobale_ <- FUNC_CAL_VAL_ValidationSansLearn_Globale(annee = 1, Matrice_comp = tab_comp_, liste_Her = liste_Her, nbrRep = 100, proportionTest = 0.65)
out_ValidationGlobale_$Biais_boot

if (!dir.exists(paste0(folder_output_,
                       "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/"))){
  dir.create(paste0(folder_output_,
                    "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/"))
}

write.table(data.frame(out_ValidationGlobale_), paste0(folder_output_,
                                                       "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                                                       nomSim_,
                                                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                                       ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                                                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                                                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                                                       "/TableGlobale/ModelResults_ParDate_",str_after_nth(str_before_last(basename(il), "\\."),"\\_",2),"_ValidGlobale_",
                                                       "_J",ifelse(jourMin_ == 0,"j",paste0("m",jourMin_)),"J",ifelse(jourMax_ == 0,"j",paste0("m",jourMax_)),"_logit.csv"),
            dec = ".", sep=";", row.name=F) #Pourquoi s'appelle validation ?







# list_ = list.files(paste0(folder_output_,
#                           "15_ResultatsModeles_ValidationParAnnees_ParHer/",
#                           nomSim_,
#                           ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
#                           ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
#                           ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
#                           ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
#                           "/TableParMoisAnnees/Results_Jm",jourMin_,"Jj/"),
#                    pattern = "ModelResults_ParDate_",
#                    full.names = T)
# 
# read.table(list_, sep = ";", dec = ".", header = T)
# 
# list_of_tables <- lapply(list_, fread)  # Utilise fread si les fichiers sont des fichiers de données tabulaires
# combined_table <- rbindlist(list_of_tables)
# combined_table <- combined_table[order(combined_table$HER2),]
# 
# write.table(combined_table,
#             paste0(folder_output_,
#                   "15_ResultatsModeles_ValidationParAnnees_ParHer/",
#                   nomSim_,
#                   ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
#                   ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
#                   ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
#                   ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
#                   "/TableParMoisAnnees/Results_Jm",jourMin_,"Jj/",
#                   str_before_first(basename(list_[1]),"_Valid"),".csv"),
#             sep = ";", dec = ".", row.names = F)


