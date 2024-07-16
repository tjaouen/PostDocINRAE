#-------------------------------------------------------------------------------
# Bottet Quentin - Irstea - 14/06/2019 - Version 1
# Etablir une table des assecs | HER | RH | Date | % observes | % simules | 
#-------------------------------------------------------------------------------

### Libraries ###
library(strex)
library(rgdal)
library(lubridate)

### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/3_Run/7_Func_Relation_AvecCC_TestOndeManquantes_ExcludeOndeUsingFunction_12_20231206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_Commun/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")

### Study data ###
folder_output_ = folder_output_param_
nomSim_ = nomSim_param_
HER_ = HER_param_
nom_GCM_ = nom_GCM_param_
annees_learnModels_ = annees_learnModels_param_
nom_apprentissage_ = nom_apprentissage_param_
nom_categorieSimu_ = nom_categorieSimu_param_
jourMin_ = jourMin_param_
jourMax_ = jourMax_param_

# nom_apprentissage_param_ = "ApprentissageGlobalModelesBruts"
# nom_validation_param_ = "Validation_1ModelesBruts"
# annees_inputMatrice_param_ = c(2012:2019)
# annees_learnModels_param_ = c(2012:2019)


### Folders ###
folders_GCM_ <- list.files(paste0(folder_output_,
                                  "1_MatricesInputModeles_ParHERDates/",
                                  nomSim_,
                                  ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_))),
                           full.names = T)


for (fold_ in folders_GCM_){
  
  ### Run ###
  liste <- c(list.files(fold_,
                        pattern="MatInputModel_CampOndeExcl", full.names = T))

  NSE <- c()
  colNSE <- c()
  
  ### Choix simu ###
  if (basename(fold_) != ""){
    liste = liste[grepl(basename(fold_),liste)]
  }
  
  if (length(liste) == 0){
    stop("Erreur de table ONDE. Vous n'avez pas exclu les campagnes incompletes de la Matrice Input avec le programme 4_ExclureCampagnesOndeIncompletes.")
  }
  ###### TESTER LA DIM #####
  
  for (il in liste) {
    
    print("il")
    print(il)
    
    #liste = read.table(paste0(dir.in,"Classif_Assec_ONDE_HYDRO_PIEZO_HER2_group_new_RH_2019.csv"), header = T, sep = ";", row.names = NULL, quote="")
    onde = read.table(il, header = T, sep = ";", row.names = NULL, quote="")
    if (dim(onde)[2] == 1){
      onde = read.table(il, header = T, sep = ",", row.names = NULL, quote="")
    }
    # onde = onde[which((!is.na(onde[,c("Freq_j")])) & !is.na(onde[,c("Freq_jmoins5")])),]
    onde = onde[which((!is.na(onde[,c("Freq_Jm6Jj")]))),]
    annees_learnModels_ <- annees_learnModels_[which(annees_learnModels_ %in% year(as.Date(onde$Date)))]
    # annees_learnModels_ <- annees_learnModels_p_[which(annees_learnModels_p_ %in% year(as.Date(onde$Date)))]
    
    liste_Her=sort(unique(onde[,1]))
    
    ### Selection dates learn ###
    onde <- onde[which(format(as.Date(onde$Date),"%Y") %in% annees_learnModels_),]
    
    if (!dir.exists(paste0(folder_output_,
                           "2_ResultatsModeles_ParHer/",
                           nomSim_,
                           ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                           ifelse(basename(fold_)=="","",paste0("/",basename(fold_)))))){
      dir.create(paste0(folder_output_,
                        "2_ResultatsModeles_ParHer/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        ifelse(basename(fold_)=="","",paste0("/",basename(fold_)))))
    }
    if (!dir.exists(paste0(folder_output_,
                           "2_ResultatsModeles_ParHer/",
                           nomSim_,
                           ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                           ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                           ifelse(nom_apprentissage_param_=="","",paste0("/",nom_apprentissage_param_))))){
      dir.create(paste0(folder_output_,
                        "2_ResultatsModeles_ParHer/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                        ifelse(nom_apprentissage_param_=="","",paste0("/",nom_apprentissage_param_))))
    }
    
    print("ok0")
    print(paste0(folder_output_,
                 "2_ResultatsModeles_ParHer/",
                 nomSim_,
                 ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                 ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                 ifelse(nom_apprentissage_param_=="","",paste0("/",nom_apprentissage_param_)),
                 "/ModelResults_",str_after_nth(str_before_last(basename(il), "\\."),"\\_",2),"_",paste(substr(annees_learnModels_,3,4),collapse = "-"),
                 "_J",ifelse(jourMin_ == 0,"j",paste0("m",jourMin_)),"J",ifelse(jourMax_ == 0,"j",paste0("m",jourMax_)),"_logit.csv"))
    
    ### Calcul des diff?rents crit?res de NASH (Sortie : NASH en validation)
    # Sortie : | HER | RH | Date | %NoF_obs | %NoF_sim |
    regr = "logit"
    Assecs = FUNC_CAL_VAL(annee = 1, Matrice_comp = onde, liste_Her = liste_Her, regression = regr, jourMin_ = jourMin_, jourMax_ = jourMax_)
    
    Assecs[3:ncol(Assecs)] = round(Assecs[3:ncol(Assecs)],3)
    write.table(Assecs, paste0(folder_output_,
                               "2_ResultatsModeles_ParHer/",
                               nomSim_,
                               ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                               ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                               ifelse(nom_apprentissage_param_=="","",paste0("/",nom_apprentissage_param_)),
                               "/ModelResults_",str_after_nth(str_before_last(basename(il), "\\."),"\\_",2),"_",paste(substr(annees_learnModels_,3,4),collapse = "-"),
                               "_J",ifelse(jourMin_ == 0,"j",paste0("m",jourMin_)),"J",ifelse(jourMax_ == 0,"j",paste0("m",jourMax_)),"_logit.csv"), sep=";", row.name=F, quote=F) #Pourquoi s'appelle validation ?
    vecTemp <- rep(NA,length(HER_))
    for(i in HER_){
      if(length(which(Assecs[,1]==i))>0) {
        vecTemp[i] <- round(Assecs[which(Assecs[,1]==i),4],3) }
    }
    NSE <- cbind(NSE, c(vecTemp,
                        paste0(str_before_nth(str_after_nth(basename(il), "\\_", 2), "\\_", 1),"-",str_before_nth(str_after_nth(basename(il), "\\_", 3), "\\_", 1)),
                        str_before_nth(str_after_nth(basename(il), "\\_", 4), "\\_", 1),
                        str_before_nth(str_after_nth(basename(il), "\\_", 5), "\\_", 1),
                        str_before_nth(str_after_nth(basename(il), "\\_", 6), "\\_", 1),
                        str_before_last(str_after_nth(basename(il), "\\_", 8),"\\."),
                        "LR"))
    colNSE <- c(colNSE,
                paste0(str_before_nth(str_after_nth(basename(il), "\\_", 4), "\\_", 1),
                       str_before_nth(str_after_nth(basename(il), "\\_", 5), "\\_", 1),
                       str_before_nth(str_after_nth(basename(il), "\\_", 6), "\\_", 1),
                       str_before_last(str_after_nth(basename(il), "\\_", 8),"\\.")))
    
    # NSE <- cbind(NSE, c(vecTemp,substr(il,9,11),substr(il,24,33),substr(il,60,60),"LR"))
    # colNSE <- c(colNSE,paste0(substr(il,9,11),substr(il,23,43),substr(il,59,63),"_logit"))
    
    print("ok1")
    
    
    regr = "log"
    Assecs = FUNC_CAL_VAL(1, onde, liste_Her, regr, jourMin_ = 5, jourMax_ = 0)
    Assecs[3:ncol(Assecs)] = round(Assecs[3:ncol(Assecs)],3)
    write.table(Assecs,paste0(folder_output_,
                              "2_ResultatsModeles_ParHer/",
                              nomSim_,
                              ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                              ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
                              ifelse(nom_apprentissage_param_=="","",paste0("/",nom_apprentissage_param_)),
                              "/ModelResults_",str_after_nth(str_before_last(basename(il), "\\."),"\\_",2),"_",paste(substr(annees_learnModels_,3,4),collapse = "-"),
                              "_J",ifelse(jourMin_ == 0,"j",paste0("m",jourMin_)),"J",ifelse(jourMax_ == 0,"j",paste0("m",jourMax_)),"_log.csv"),sep=";", row.name=F, quote=F)
    vecTemp <- rep(NA,length(HER_))
    for(i in HER_){
      if(length(which(Assecs[,1]==i))>0) {
        vecTemp[i] <- round(Assecs[which(Assecs[,1]==i),7],3) }
    }
    NSE <- cbind(NSE, c(vecTemp,
                        paste0(str_before_nth(str_after_nth(basename(il), "\\_", 2), "\\_", 1),"-",str_before_nth(str_after_nth(basename(il), "\\_", 3), "\\_", 1)),
                        str_before_nth(str_after_nth(basename(il), "\\_", 4), "\\_", 1),
                        str_before_nth(str_after_nth(basename(il), "\\_", 5), "\\_", 1),
                        str_before_nth(str_after_nth(basename(il), "\\_", 6), "\\_", 1),
                        str_before_last(str_after_nth(basename(il), "\\_", 8),"\\."),
                        "TLLR"))
    colNSE <- c(colNSE,
                paste0(str_before_nth(str_after_nth(basename(il), "\\_", 4), "\\_", 1),
                       str_before_nth(str_after_nth(basename(il), "\\_", 5), "\\_", 1),
                       str_before_nth(str_after_nth(basename(il), "\\_", 6), "\\_", 1),
                       str_before_last(str_after_nth(basename(il), "\\_", 8),"\\.")))
    
    # NSE <- cbind(NSE, c(vecTemp,substr(il,9,11),substr(il,24,33),substr(il,60,60),"TLLR"))
    # colNSE <- c(colNSE,paste0(substr(il,9,11),substr(il,23,43),substr(il,59,63),"_log"))
    
    print("ok2")
    
    
    #-------------------------------------------------------------------------------
  }
}
# colnames(NSE) <- colNSE
# write.table(NSE,paste0(folder_output_,
#                        "2_ResultatsModeles_ParHer/",
#                        nomSim_,
#                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
#                        ifelse(basename(fold_)=="","",paste0("/",basename(fold_))),
#                        ifelse(nom_apprentissage_param_=="","",paste0("/",nom_apprentissage_param_)),
#                        "/KGE_HER_J",ifelse(jourMin_ == 0,"j",paste0("m",jourMin_)),"J",ifelse(jourMax_ == 0,"j",paste0("m",jourMax_)),"_logit_log.csv"),sep=";", row.name=F, quote=F)




