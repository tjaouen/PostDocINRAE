#-------------------------------------------------------------------------------
# Bottet Quentin - Irstea - 12/09/2019 - Version 1
# Script permettant d'extraire le % d'assec, les Frequence au non depassement et frequences au
# non depassement moyen par hydroecoregion de niveau 2 et en fonction du regime hydrologique
# des cours d'eau sur lesquels sont localisees les stations HYDRO et ONDE

# changer "OBS" en "SIM" dans les repertoires et fichiers de sortie pour les valeurs Safran
#print("2023.02.20. Pour le moment, FDC faits a partir des fichiers Simulations disponibles dans le dossier Thirel. Donnees dispos jusqu a 2018.")
#-------------------------------------------------------------------------------

print('SMASH - 3_OndeHydro_MatriceInput_Parallele_JonctionHERcriteresES_10jours_GestionErreurs_FDCmeanJm6Jj_MPI_26_20240209')

### Programmes ###
source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_SMASH/PathsProgram/PathProgram_1_20230206.R")
source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_SMASH/1_Parameters_MESO/0_SimulationParameters_AvecCC_2_20230227_MESO.R")

# source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")

### Librairies ###
suppressMessages(library(doParallel))
suppressMessages(library(lubridate))
suppressMessages(library(stringr))
suppressMessages(library(dplyr))
suppressMessages(library(strex))

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

### Run ###
liste <- list.files(paste0(folder_input_PC_,
                           "StationsSelectionnees/SelectionCsv/",
                           nom_selectStations_,"/",
                           ifelse(nom_GCM_=="","TablesParModele_20231203/","TablesParModele_20231203/")),pattern="StationsHYDRO", full.names = T)
# liste = liste[grepl(str_after_last(str_before_first(nom_GCM_,"_day"),"-"), liste)]
liste = liste[grepl(str_before_first(nom_categorieSimu_,"_"), liste)]

# print(liste)

### Folders ###
liste_scenarios_ = list.files(paste0(folder_input_,"FlowDurationCurves_meanJm6Jj/",
                                     ifelse(obsSim_=="",nom_GCM_,
                                            paste0("FDC_",obsSim_,
                                                   ifelse(nom_FDCfolder_param_=="","",paste0("_",nom_FDCfolder_param_)),"/",
                                                   ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),"/"))),
                              full.names = T)
# liste_scenarios_ = liste_scenarios_[1]
nFiles_to_use = length(liste_scenarios_)

# print(liste_scenarios_)

### Parallel MPI ###
post = function(x, ...) {
  print(paste0(formatC(as.character(rank),
                       width=3, flag=" "),
               "/", size-1, " > ", x), ...)
}

library(Rmpi)
rank = mpi.comm.rank(comm=0)
size = mpi.comm.size(comm=0)

# print("rank")
# print(rank)
# print("size")
# print(size)

if (size > 1) {
  if (rank == 0) {
    # print("option1")
    Rrank_sample = sample(0:(size-1))
    for (root in 1:(size-1)) {
      Rmpi::mpi.send(as.integer(Rrank_sample[root+1]),
                     type=1, dest=root,
                     tag=1, comm=0)
    }
    Rrank = Rrank_sample[1]
    # print(Rrank)
  } else {
    # print("option2")
    Rrank = Rmpi::mpi.recv(as.integer(0),
                           type=1,
                           source=0,
                           tag=1, comm=0)
    # print(Rrank)
  }
} else {
  Rrank = 0
}
post(paste0("Random rank attributed : ", Rrank))

### Paralleliser sur fichiers ###
start = ceiling(seq(1, nFiles_to_use,
                    by=(nFiles_to_use/size)))
if (any(diff(start) == 0)) {
  start = 1:nFiles_to_use
  end = start
} else {
  end = c(start[-1]-1, nFiles_to_use)
}

if (rank == 0) {
  post(paste0(paste0("rank ", 0:(size-1), " get ",
                     end-start+1, " files"),
              collapse="    "))
}

# print("Rrank")
# print(Rrank)

if (Rrank+1 > nFiles_to_use) {
  liste_scenarios_ = NULL
} else {
  liste_scenarios_ = liste_scenarios_[start[Rrank+1]:end[Rrank+1]]
}
####################

# print("liste")
# print(liste_scenarios_)

if (! is.null(liste_scenarios_)){


  for (il in liste) {
    
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
    
    # onde = Recoupement Stations ONDE - HER #
    # onde = read.table(paste0(folder_ONDE_CorrespondanceHER_,"HER2hybrides_Jonction/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_JonctionHER_5_20230920.csv"), header = T, sep = ";", row.names = NULL, quote="")
    onde = read.table(paste0(folder_ONDE_CorrespondanceHER_,"HER2hybrides_Jonction/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_JonctionHER_6_20231221.csv"), header = T, sep = ";", row.names = NULL)
    # print("folder_ONDE_CorrespondanceHER_")
    # print(folder_ONDE_CorrespondanceHER_)
    if (dim(onde)[2] == 1){
      # onde = read.table(paste0(folder_ONDE_CorrespondanceHER_,"HER2hybrides_Jonction/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_JonctionHER_5_20230920.csv"), sep=",", dec=".", header = T)
      onde = read.table(paste0(folder_ONDE_CorrespondanceHER_,"HER2hybrides_Jonction/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_JonctionHER_6_20231221.csv"), sep=",", dec=".", header = T)
    }
    onde = onde[,c("Code","X_Lambert93","Y_Lambert93",paste0("Cd",HER_variable_))]
    colnames(onde) = c("Code","X_Lambert93","Y_Lambert93",paste0("Cd",HER_variable_))
    # print("Taille à verifier : 3302")
    # print(dim(onde))
    
    # Observations ONDE #
    ONDE <- read.table(folder_onde_, sep = ";", dec = ".", header = T)
    if (dim(ONDE)[2] == 1){
      ONDE = read.table(folder_onde_, sep = ",", dec = ".", header = T, quote = "")
    }
    # print("Taille à verifier apres correction ONDE 2023.06.07 : 175 972")
    # print(dim(ONDE))
    
    for (sc_ in liste_scenarios_){
      
      # output <- foreach(annee = annees_inputMatrice_, .combine = "rbind", .verbose = T) %:% #, errorhandling='pass'
      #   foreach(i = HER_, .combine = "rbind", .verbose = T) %dopar% { #, errorhandling='pass'
      
      for (annee in annees_inputMatrice_){
      # for (annee in 2017:2020){
        
        # for (i in HER_[75:79]){
        for (i in HER_){
          
          tryCatch({
            # print(annee)
            # print(i)
          
            ONDE_us <- ONDE[which(ONDE$TypeCampObservations == "usuelle" & ONDE$Annee == annee),c("CdSiteHydro","Annee","TypeCampObservations","DtRealObservation","LbRsObservationDpt")]
            # print(head(ONDE_us))
            # print(colnames(ONDE_us))
            colnames(ONDE_us) = c("Code","Annee","Type","Date","Observation")
            # print("ok")
            
            output_parAnneeParHer_toutesDates = data.frame()
            
            if (paste0("eco",sprintf("%03d", i)) %in% colnames(hydro)){
              Select_hydro = hydro$Code[which(as.numeric(as.vector(hydro[,paste0("eco",sprintf("%03d", i))]))>0)]
              Weight_hydro <- as.numeric(as.vector(hydro[which(as.numeric(as.vector(hydro[,paste0("eco",sprintf("%03d", i))]))>0),paste0("eco",sprintf("%03d", i))]))
              
              # Selection des stations ONDE (possible en 1 seul temps)
              Select_onde = onde$Code[which(onde[[paste0("Cd",HER_variable_)]] == i)]
              Obs_onde = ONDE_us[which(ONDE_us$Code %in% Select_onde),]
              # print('ok1.01')
              if(nrow(Obs_onde) > 0){
                
                liste_mois <- sort(unique(format(as.Date(Obs_onde$Date),"%m")))
                # print('ok1.02')
                
                # Parcours par mois
                for (date in 1:length(liste_mois)){
                  
                  obs_us=which(format(as.Date(Obs_onde$Date),"%m")==liste_mois[date])
                  assec_us=which(format(as.Date(Obs_onde$Date),"%m")==liste_mois[date] & (Obs_onde[,c("Observation")]=="Assec" | Obs_onde[,c("Observation")]=="Ecoulement non visible"))
                  # print('ok1.03')
                  
                  # Calcul une date moyenne pour toutes les observations usuelles donnees dans un mois
                  jour_moy=round(mean(as.numeric((format(as.Date(Obs_onde$Date[obs_us]),"%d")))))
                  date_moy = sprintf("%02d-%02d-%04d", jour_moy, as.numeric(liste_mois[date]), annee)
                  
                  # print('ok1.2')
                  
                  if(length(Select_hydro) > 0 ){
                    
                    output_hydro = data.frame()
                    compt = 0
                    weightcompt = 0
                    cmpt_hydro_ = 0
                    cmpt_NA_ = 0
                    # print('ok1.3')
                    
                    for (st in 1:length(Select_hydro)){
                      
                      if (dir.exists(sc_)){ #,"/ExtraitAnneesOnde20102023/"
                        # print('ok1.31')
                        if (file.exists(paste0(sc_, #,"/ExtraitAnneesOnde20102023/"
                                               "/FDC_",sub("\\..*", "", Select_hydro[st]),".txt"))){
                          # print('ok1.32')
                          # print(paste0(sc_, #,"/ExtraitAnneesOnde20102023/"
                          #              "/FDC_",sub("\\..*", "", Select_hydro[st]),".txt"))
                          # st_hydro = read.table(paste0(sc_, #,"/ExtraitAnneesOnde20102023/"
                          #                              "/FDC_",sub("\\..*", "", Select_hydro[st]),".txt"),
                          #                       header = T, sep = ";", row.names = NULL, quote="")
                          st_hydro = read.table(paste0(sc_, #,"/ExtraitAnneesOnde20102023/"
                                                       "/FDC_",sub("\\..*", "", Select_hydro[st]),".txt"),
                                                header = T, sep = ";", dec = ".")
                          # print('ok1.331')
                          # print(dim(st_hydro))
                          # print('ok1.33')
                          st_hydro <- st_hydro[which(st_hydro$Type == "Safran"),]
                          
                          # print('ok1.4')
                          formats_detectes <- guess_formats(as.character(st_hydro$Date), orders = c("Ymd", "Y-m-d", "Y/m/d"))
                          
                          # Convertir les dates au format "%Y-%m-%d" si necessaire
                          if ("%Y%Om%d" %in% formats_detectes) {
                            st_hydro$Date <- format(as.Date(as.character(st_hydro$Date), format = "%Y%m%d", origin = "1970-01-01"), "%Y-%m-%d")
                          }
                          
                          date_deb = sprintf("%04d-%02d-%02d", annee, as.numeric(liste_mois[date]), jour_moy) # Date au format Hydro #CHANGER PLACE SORTIR FOR ST
                          
                          if (length(which(st_hydro$Date == as.Date(date_deb))) > 1){
                            stop("Erreur: plusieurs FDC à la même date.")
                          }
                          compt = compt + 1
                          
                          # print("compt")
                          # print(compt)
                          # print(weightcompt)
                          # print(Weight_hydro[st])
                          # print(Weight_hydro[st]*st_hydro$Moyenne_6jours[which(st_hydro$Date == as.Date(date_deb))])
                          
                          weightcompt = weightcompt+Weight_hydro[st]
                          if (length(which(st_hydro$Date == as.Date(date_deb))) == 1){
                            output_hydro[compt,1] = Weight_hydro[st]*st_hydro$Moyenne_6jours[which(st_hydro$Date == as.Date(date_deb))]
                          }
                          if (length(which(st_hydro$Date == as.Date(date_deb))) == 0){
                            output_hydro[compt,1] = NA
                          }
                          # print('ok1.5')
                          
                        }
                      }else{
                        stop("FDC folder not found.")
                      }
                    }
                    
                    # On remplit la matrice finale
                    #compteur = compteur+1
                    
                    output_parAnneeParHer_toutesDates[date,1] = i # Numero HER 1
                    output_parAnneeParHer_toutesDates[date,2] = date_moy # Date moyenne des obs usuelles ONDE utilisees pour extraire les valeurs de debit
                    output_parAnneeParHer_toutesDates[date,3] = (length(assec_us)/length(obs_us))*100 # Calcul du pourcentage d'assec a une date d'obs usuelle dans une HER
                    
                    # print(output_hydro)
                    if (nrow(output_hydro) > 0){
                      
                      if (length(which(is.na(output_hydro[,1]))) == length(output_hydro[,1])){
                        output_parAnneeParHer_toutesDates[date,4]=NA
                      }else{
                        output_parAnneeParHer_toutesDates[date,4]=sum(output_hydro[,1], na.rm = T)/weightcompt # Moyenne des Frequence au non depassement au jour j de toutes les stations HYDRO d'une HER1
                      }
                      
                      output_parAnneeParHer_toutesDates[date,5]=cmpt_hydro_
                      output_parAnneeParHer_toutesDates[date,6]=length(Select_hydro)
                      output_parAnneeParHer_toutesDates[date,7]=cmpt_NA_
                      output_parAnneeParHer_toutesDates[date,8]=length(obs_us) #Nombre d'observations ONDE
                      output_parAnneeParHer_toutesDates[date,9]=length(assec_us) #Nombre d'observations ONDE
                      
                    } else {
                      output_parAnneeParHer_toutesDates[date,4:9] = NA
                    }
                    
                  }else{
                    output_parAnneeParHer_toutesDates[date,1] = i # Numero HER 1
                    output_parAnneeParHer_toutesDates[date,2] = date_moy # Date moyenne des obs usuelles ONDE utilisees pour extraire les valeurs de debit
                    output_parAnneeParHer_toutesDates[date,3] = (length(assec_us)/length(obs_us))*100 # Calcul du pourcentage d'assec a une date d'obs usuelle dans une HER
                    output_parAnneeParHer_toutesDates[date,4:9] = NA
                  }
                }
              }else{
                stop("Table is empty for: Annee=",annee," HER=",i)
              }
            }else{
              output_parAnneeParHer_toutesDates[1,1] = i # Numero HER 1
              output_parAnneeParHer_toutesDates[1,2] = NA # Date moyenne des obs usuelles ONDE utilisees pour extraire les valeurs de debit
              output_parAnneeParHer_toutesDates[1,3] = NA # Calcul du pourcentage d'assec a une date d'obs usuelle dans une HER
              output_parAnneeParHer_toutesDates[1,4:9] = NA
            }
            
            # print("ok2")
            
            if (dim(output_parAnneeParHer_toutesDates)[1] == 0){
              stop("Table is empty for: Annee=",annee," HER=",i)
            }
            
            colnames(output_parAnneeParHer_toutesDates)<-c(HER_variable_,"Date","%_Assec",
                                                           "Freq_Jm6Jj",
                                                           "NbInputStationsHydroUtilisees","NbInputStationsHydroDispos","NbEnregistrementsHydroNA","NbOutputONDE","NbOutputONDEAssecs")
            
            # Gerer format de Date
            date_formats <- sapply(output_parAnneeParHer_toutesDates$Date, detect_date_format)  # Appliquer la fonction pour détecter le format de chaque date
            parsed_dates <- mapply(parse_date_time, output_parAnneeParHer_toutesDates$Date, date_formats, SIMPLIFY = FALSE)  # Convertir les dates en objets de type date en utilisant les formats détectés
            formatted_dates <- lapply(parsed_dates, function(date) {  # Convertir toutes les dates au format "%Y-%m-%d"
              format(date, format = "%Y-%m-%d")
            })
            output_parAnneeParHer_toutesDates$Date = unlist(formatted_dates)
            # output_parAnneeParHer_toutesDates$Date <- format(as.Date(output_parAnneeParHer_toutesDates$Date,"%d-%m-%Y"),"%Y-%m-%d") # Ne fonctionne pas si date dans un autre format
            
            if (!(dir.exists(paste0(folder_output_,
                                    "1_MatricesInputModeles_ParHERDates/",
                                    nomSim_,
                                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                    ifelse(sc_=="","",paste0("/",basename(sc_))))))){
              # ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)))))){
              dir.create(paste0(folder_output_,
                                "1_MatricesInputModeles_ParHERDates/",
                                nomSim_,
                                ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                ifelse(sc_=="","",paste0("/",basename(sc_)))))}
            # ifelse(nom_GCM_=="","",paste0("/",nom_GCM_))))}
            
            if (!(dir.exists(paste0(folder_output_,
                                    "1_MatricesInputModeles_ParHERDates/",
                                    nomSim_,
                                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                    ifelse(sc_=="","",paste0("/",basename(sc_))),
                                    # ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                                    "/tmp/")))){ 
              dir.create(paste0(folder_output_,
                                "1_MatricesInputModeles_ParHERDates/",
                                nomSim_,
                                ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                ifelse(sc_=="","",paste0("/",basename(sc_))),
                                # ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                                "/tmp/"))}
            write.table(output_parAnneeParHer_toutesDates, paste0(folder_output_,
                                                                  "1_MatricesInputModeles_ParHERDates/",
                                                                  nomSim_,
                                                                  ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                                                  ifelse(sc_=="","",paste0("/",basename(sc_))),
                                                                  # ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                                                                  "/tmp/MatInputModel_ByHERDates_2012_2022_",str_replace_all(basename(il), 'Stations_HYDRO_|.csv', ''),"_",obsSim_,"_Weight_",annee,"_HER",i,".csv"), sep=";", row.name=F, quote=F)
            # "/tmp/MatInputModel_ByHERDates_",as.character(min(annees_inputMatrice_)),"_",as.character(max(annees_inputMatrice_)),"_",str_replace_all(basename(il), 'Stations_HYDRO_|.csv', ''),"_",obsSim_,"_Weight_",annee,"_HER",i,".csv"), sep=";", row.name=F, quote=F)
            
            return(output_parAnneeParHer_toutesDates)
            
          }, error = function(e) {
            # En cas d'erreur, renvoyez l'année et i dans un data frame
            error_data <- data.frame(Annee = annee, i = i, Error = as.character(e))
            return(error_data)
          })
        }
      }
    }
  
    # print(output)
    # print(c(HER_variable_,"Date","%_Assec",
    #         "Freq_jmoins6_jJ",
    #         "NbInputStationsHydroUtilisees","NbInputStationsHydroDispos","NbEnregistrementsHydroNA","NbOutputONDE","NbOutputONDEAssecs"))
    
      
    # colnames(output)<-c(HER_variable_,"Date","%_Assec",
    #                     "Freq_jmoins6_jJ",
    #                     "NbInputStationsHydroUtilisees","NbInputStationsHydroDispos","NbEnregistrementsHydroNA","NbOutputONDE","NbOutputONDEAssecs")
    
    # # Gerer format de Date
    # date_formats <- sapply(output$Date, detect_date_format)  # Appliquer la fonction pour détecter le format de chaque date
    # parsed_dates <- mapply(parse_date_time, output$Date, date_formats, SIMPLIFY = FALSE)  # Convertir les dates en objets de type date en utilisant les formats détectés
    # formatted_dates <- lapply(parsed_dates, function(date) {  # Convertir toutes les dates au format "%Y-%m-%d"
    #   format(date, format = "%Y-%m-%d")
    # })
    # output$Date = unlist(formatted_dates)
    # # output$Date <- format(as.Date(output$Date,"%d-%m-%Y"),"%Y-%m-%d") # Ne fonctionne pas si date dans un autre format
    # 
    # write.table(output, paste0(folder_output_,
    #                            "1_MatricesInputModeles_ParHERDates/",
    #                            nomSim_,
    #                            ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),"/",
    #                            ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
    #                            "/MatInputModel_ByHERDates_2012_2022_",str_replace_all(basename(il), 'Stations_HYDRO_|.csv', ''),"_",obsSim_,"_Weight.csv"), sep=";", row.name=F, quote=F)
    # "/MatInputModel_ByHERDates_",as.character(min(annees_inputMatrice_)),"_",as.character(max(annees_inputMatrice_)),"_",str_replace_all(basename(il), 'Stations_HYDRO_|.csv', ''),"_",obsSim_,"_Weight.csv"), sep=";", row.name=F, quote=F)

  }
}

### Parallel MPI ###
Sys.sleep(10)
mpi.finalize()
####################

# Arreter le cluster doParallel
# stopCluster(cl)
