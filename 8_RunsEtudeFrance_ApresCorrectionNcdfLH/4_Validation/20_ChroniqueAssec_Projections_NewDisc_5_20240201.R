source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run4.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Option0SafranCompletSeul_Run2.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Option0SafranCompletSeul.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run3.R")

library(doParallel)
library(strex)
library(beepr)

### Functions ###
detect_date_format <- function(date) {
  if (grepl("^\\d{4}-\\d{2}-\\d{2}$", date)) {
    return("ymd")
  } else if (grepl("^\\d{2}-\\d{2}-\\d{4}$", date)) {
    return("dmy")
  } else {
    return(NA)
  }
}

### Run ###
# cl <- makePSOCKcluster(detectCores() - 4)
# registerDoParallel(cores=cl)

### Study data ###
folder_input_ = folder_input_param_
folder_input_PC_ = folder_input_PC_param_
folder_output_ = folder_output_param_
folder_onde_ = folder_onde_param_
nom_GCM_ = nom_GCM_param_
nom_selectStations_ = nom_selectStations_param_
nom_categorieSimu_ = nom_categorieSimu_param_
HER_ = HER_param_
HER_variable_ = HER_variable_param_
# climatScenarioModeleHydro_ = climatScenarioModeleHydro_param_

obsSim_ = obsSim_param_
nomSim_ = nomSim_param_
# annees_learn_ = annees_learnModels_param_
annees_inputMatrice_ = annees_inputMatrice_param_

# nbJoursIntervalle_ = 10

### Run ###
liste <- list.files(paste0(folder_input_PC_,
                           "StationsSelectionnees/SelectionCsv/",
                           nom_selectStations_,"/",
                           ifelse(nom_GCM_=="","TablesParModele_20231203/","TablesParModele_20231203/")),pattern="StationsHYDRO", full.names = T)
# il = liste[grepl(str_after_last(str_before_first(nom_GCM_,"_day"),"-"), liste)]
il = liste[grepl(str_before_first(nom_categorieSimu_,"_"), liste)]


output = data.frame()
#compteur = 0

# hydro = Recoupement Stations HYDRO - HER #
hydro = read.table(il, sep=";", dec=".", header = T, quote = "")
if (dim(hydro)[2] == 1){
  hydro = read.table(il, sep=",", dec=".", header = T, quote = "")
}
if (substr(colnames(hydro)[1],1,2) == "X."){
  hydro = read.table(il, sep=";", dec=".", header = T)
  if (dim(hydro)[2] == 1){
    hydro = read.table(il, sep=",", dec=".", header = T)
  }
}

### Gestion de la table des points de simulation ###
if ("Code10_ChoixDefinitifPointSimu" %in% colnames(hydro)){
  hydro$Code = hydro$Code10_ChoixDefinitifPointSimu
}

print("Taille à verifier : CTRIP=--- \ EROS=--- \ GRSD=1008 \ J2000=343 \ MORDORSD=--- \ MORDORTS=--- \ ORCHIDEE=--- \ SIM2=--- \ SMASH=---")
# print("Taille à verifier : CTRIP=535 \ EROS=159 \ GRSD=608 \ J2000=235 \ MORDORSD=610 \ MORDORTS=113 \ ORCHIDEE=557 \ SIM2=848 \ SMASH=603")
dim(hydro)

# # onde = Recoupement Stations ONDE - HER #
# # onde = read.table(paste0(folder_ONDE_CorrespondanceHER_,"HER2hybrides_Jonction/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_JonctionHER_5_20230920.csv"), header = T, sep = ";", row.names = NULL, quote="")
# onde = read.table(paste0(folder_ONDE_CorrespondanceHER_,"HER2hybrides_Jonction/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_JonctionHER_6_20231221.csv"), header = T, sep = ";", row.names = NULL)
# if (dim(onde)[2] == 1){
#   # onde = read.table(paste0(folder_ONDE_CorrespondanceHER_,"HER2hybrides_Jonction/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_JonctionHER_5_20230920.csv"), sep=",", dec=".", header = T)
#   onde = read.table(paste0(folder_ONDE_CorrespondanceHER_,"HER2hybrides_Jonction/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_JonctionHER_6_20231221.csv"), sep=",", dec=".", header = T)
# }
# onde = onde[,c("Code","X_Lambert93","Y_Lambert93",paste0("Cd",HER_variable_))]
# colnames(onde) = c("Code","X_Lambert93","Y_Lambert93",paste0("Cd",HER_variable_))
# print("Taille à verifier : 3302")
# dim(onde)
# 
# # Observations ONDE #
# ONDE <- read.table(folder_onde_, sep = ";", dec = ".", header = T)
# if (dim(ONDE)[2] == 1){
#   ONDE = read.table(folder_onde_, sep = ",", dec = ".", header = T, quote = "")
# }
# print("Taille à verifier apres correction ONDE 2023.06.07 : 175 972")
# dim(ONDE)


# output <- foreach(annee = annees_inputMatrice_, .combine = "rbind", .verbose = T) %:% #, errorhandling='pass'
#   foreach(i = HER_, .combine = "rbind", .verbose = T) %dopar% { #, errorhandling='pass'

tab_HER2_ = data.frame()


list_scenarios_ = list.files(paste0(folder_input_,"FlowDurationCurves_meanJm6Jj/",
                                    ifelse(obsSim_=="",nom_GCM_,
                                           paste0("FDC_",obsSim_,
                                                  ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                  nom_categorieSimu_,"/"))), full.names = T)
# list_scenarios_ = list_scenarios_[c(8)]
# list_scenarios_ = list_scenarios_[c(1:7,9:length(list_scenarios_))]

### Run ###
cl <- makePSOCKcluster(detectCores()/2-1)
registerDoParallel(cores=cl)

# for (ls_ in list_scenarios_){
output <- foreach(ls_ = list_scenarios_) %dopar% { #, errorhandling='pass'
  
  for (i in HER_){
    
    print(i)
    
    output_parAnneeParHer_toutesDates = data.frame()
    
    if (paste0("eco",sprintf("%03d", i)) %in% colnames(hydro)){
      Select_hydro = hydro$Code[which(as.numeric(as.vector(hydro[,paste0("eco",sprintf("%03d", i))]))>0)]
      Weight_hydro <- as.numeric(as.vector(hydro[which(as.numeric(as.vector(hydro[,paste0("eco",sprintf("%03d", i))]))>0),paste0("eco",sprintf("%03d", i))]))
      
      if(length(Select_hydro) > 0 ){
        
        output_hydro = data.frame()
        compt = 0
        weightcompt = 0
        cmpt_hydro_ = 0
        cmpt_NA_ = 0
        FDCweighted_ = data.frame()
        
        for (st in 1:length(Select_hydro)){
          
          if (dir.exists(ls_)){ #,"/ExtraitAnneesOnde20102023/"
            if (file.exists(paste0(ls_, #,"/ExtraitAnneesOnde20102023/"
                                   "/FDC_",sub("\\..*", "", Select_hydro[st]),".txt"))){
              
              st_hydro = read.table(paste0(ls_, #,"/ExtraitAnneesOnde20102023/"
                                           "/FDC_",sub("\\..*", "", Select_hydro[st]),".txt"),
                                    header = T, sep = ";", row.names = NULL, quote="")
              
              if (length(FDCweighted_) == 0){
                FDCweighted_ = data.frame(Date = st_hydro$Date,
                                          Type = st_hydro$Type)
              }
              if ((length(which(!(FDCweighted_$Date == st_hydro$Date))) == 0) & (length(which(!(FDCweighted_$Type == st_hydro$Type))) == 0)){
                FDCweighted_ = cbind(FDCweighted_,
                                     st_hydro$Moyenne_6jours * Weight_hydro[st])
                colnames(FDCweighted_)[length(colnames(FDCweighted_))] = st
              }else{
                print(st)
                stop("Erreur 1")
              }
            }else{
              print(st)
              stop("Erreur 2")
            }
          }else{
            print(st)
            stop("FDC folder not found.")
          }
        }
        
        if (ncol(FDCweighted_) > 3){
          FDCweighted_$FDCmeanWeighted = rowSums(FDCweighted_[, !colnames(FDCweighted_) %in% c("Date", "Type")], ) / sum(Weight_hydro)
        }else{
          FDCweighted_$FDCmeanWeighted = FDCweighted_$'1'
        }
        
        if (length(tab_HER2_)==0){
          tab_HER2_ = data.frame(Date = FDCweighted_$Date,
                                 Type = FDCweighted_$Type)
        }
        if ((length(which(!(tab_HER2_$Date == FDCweighted_$Date))) == 0) & (length(which(!(tab_HER2_$Type == FDCweighted_$Type))) == 0)){
          tab_HER2_ = cbind(tab_HER2_,
                            FDCweighted_$FDCmeanWeighted)
          colnames(tab_HER2_)[length(colnames(tab_HER2_))] = i
        }else{
          print(i)
          print("Erreur 3")
        }
      }
    }
  }
  
  
  
  if (!(dir.exists(gsub("FlowDurationCurves_meanJm6Jj/","FlowDurationCurves_HERweighted_meanJm6Jj/",ls_)))){
    dir.create(gsub("FlowDurationCurves_meanJm6Jj/","FlowDurationCurves_HERweighted_meanJm6Jj/",ls_))}
  
  write.table(tab_HER2_, paste0(gsub("FlowDurationCurves_meanJm6Jj/","FlowDurationCurves_HERweighted_meanJm6Jj/",ls_), #,"/ExtraitAnneesOnde20102023/"
                                "/Tab_FDCchroniquesByHER2weigthedFDC.txt"), sep=";", row.name=F, quote=F)

}

# Arreter le cluster doParallel
stopCluster(cl)

beep(5)

