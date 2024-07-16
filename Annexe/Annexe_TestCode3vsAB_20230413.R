#-------------------------------------------------------------------------------
# Bottet Quentin - Irstea - 12/09/2019 - Version 1
# Script permettant d'extraire le % d'assec, les Frequence au non depassement et frequences au
# non depassement moyen par hydroecoregion de niveau 2 et en fonction du regime hydrologique
# des cours d'eau sur lesquels sont localisees les stations HYDRO et ONDE

# changer "OBS" en "SIM" dans les repertoires et fichiers de sortie pour les valeurs Safran
#print("2023.02.20. Pour le moment, FDC faits a partir des fichiers Simulations disponibles dans le dossier Thirel. Donnees dispos jusqu a 2018.")
#-------------------------------------------------------------------------------

### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/3_RunsTristan_20230407/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")

### Librairies ###
library(stringr)

### Study data ###
folder_input_ = folder_input_param_
folder_output_ = folder_output_param_
folder_onde_ = folder_onde_param_
nom_GCM_ = nom_GCM_param_
nom_selectStations_ = nom_selectStations_param_
HER_ = c(56)
HER_variable_ = "HER2"

obsSim_ = obsSim_param_
nomSim_ = nomSim_param_
annees_learn_ = c(2012)
#annees_learn_ = c(2012:2022)

nomSim_ = "5_PresentMesures_HERh_TsKGE_CorrectionPonderations_2012_2022_20230413"
nom_selectStations_ = "5_PresentMesures_HERh_TsKGE_CorrectionPonderations_2012_2022_20230413"

### Run ###
liste <- list.files(paste0(folder_input_,"StationsSelectionnees/SelectionCsv/SelectionCsv_",nom_selectStations_),pattern="Stations_HYDRO_KGES", full.names = T)

for (il in liste) {
  
  output = data.frame()
  compteur = 0
  
  # hydro = Recoupement Stations HYDRO - HER #
  hydro = read.table(il, sep=";", dec=".", header = T)
  if (dim(hydro)[2] == 1){
    hydro = read.table(il, sep=",", dec=".", header = T)
  }
  
  # onde = Recoupement Stations ONDE - HER #
  onde = read.table(paste0(folder_ONDE_CorrespondanceHER_,"HER2hybrides/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_3_20230331.csv"), header = T, sep = ";", row.names = NULL, quote="")
  if (dim(onde)[2] == 1){
    onde = read.table(paste0(folder_ONDE_CorrespondanceHER_,"HER2hybrides/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_3_20230331.csv"), sep=",", dec=".", header = T)
  }
  onde = onde[,c("Code","X_Lambert93","Y_Lambert93",paste0("Cd",HER_variable_))]
  colnames(onde) = c("Code","X_Lambert93","Y_Lambert93",paste0("Cd",HER_variable_))
  
  # Description des regions HER1 #
  # HER1 = read.table(paste0(folder_HER_DataDescription_,"Hydroecoregion2_group.csv"), sep=";", header=T, quote="")
  # HER1 = HER1[,c("CdHER1","CdHER2")]
  # list_HER1 = sort(unique(HER1[,1]))
  
  ONDE <- read.table(paste0(folder_onde_,"ONDE_RMC_cmpUsuelles_2012_2022_20230316.csv"), sep = ";", dec = ".", header = T)
  
  # Etude par annee, par HER et par station ONDE
  for (annee in annees_learn_){
    print(annee)
    
    # Observations ONDE usuelles
    ONDE_us <- ONDE[which(ONDE$TypeCampObservations == "usuelle" & ONDE$Annee == annee),c("CdSiteHydro","Annee","TypeCampObservations","DtRealObservation","LbRsObservationDpt")]
    colnames(ONDE_us) = c("Code","Annee","Type","Date","Observation")
    
    for(i in HER_){
      print(i)
      
      # Selection des stations hydro (avec un pourcentage >0 pour cet HER)
      #Select_hydro = hydro$Code[which(as.numeric(as.vector(hydro2[,(i+1)]))>0)]
      #Select_hydro = hydro$Code[which(as.numeric(as.vector(hydro[,paste0("eco",sprintf("%03d", i),"res")]))>0)]
      
      if (paste0("eco",sprintf("%03d", i)) %in% colnames(hydro)){
        Select_hydro = hydro$Code[which(as.numeric(as.vector(hydro[,paste0("eco",sprintf("%03d", i))]))>0)]
        # print(paste0("Selec = ",Select_hydro))
        
        #Weight_hydro <- as.numeric(as.vector(hydro2[which(as.numeric(as.vector(hydro2[,(i+1)]))>0),(i+1)]))
        #Weight_hydro <- as.numeric(as.vector(hydro[which(as.numeric(as.vector(hydro[,paste0("eco",sprintf("%03d", i),"res")]))>0),paste0("eco",sprintf("%03d", i),"res")]))
        Weight_hydro <- as.numeric(as.vector(hydro[which(as.numeric(as.vector(hydro[,paste0("eco",sprintf("%03d", i))]))>0),paste0("eco",sprintf("%03d", i))]))
        # print(paste0("Wei = ",Weight_hydro))
        #    Select_hydro = hydro[which(hydro$HER1 == i),c("Code")] #Si hydro rattachee a une seule HER
        #    Weight_hydro <- rep(1,length(Select_hydro))
        
        # Selection des stations ONDE (possible en 1 seul temps)
        Select_onde = onde$Code[which(onde[[paste0("Cd",HER_variable_)]] == i)]
        Obs_onde = ONDE_us[which(ONDE_us$Code %in% Select_onde),]
        
        if(nrow(Obs_onde) > 0){
          
          liste_mois <- sort(unique(format(as.Date(Obs_onde$Date),"%m")))
          
          # Parcours par mois
          for (date in 1:length(liste_mois)){
            obs_us=which(format(as.Date(Obs_onde$Date),"%m")==liste_mois[date])
            assec_us=which(format(as.Date(Obs_onde$Date),"%m")==liste_mois[date] & (Obs_onde[,c("Observation")]=="Assec" | Obs_onde[,c("Observation")]=="Ecoulement non visible"))
            
            # Calcul une date moyenne pour toutes les observations usuelles donnees dans un mois
            jour_moy=round(mean(as.numeric((format(as.Date(Obs_onde$Date[obs_us]),"%d")))))
            date_moy = sprintf("%02d-%02d-%04d", jour_moy, as.numeric(liste_mois[date]), annee)
            
            if(length(Select_hydro) > 0 ){
              
              output_hydro = data.frame()
              compt = 0
              weightcompt = rep(0,13)
              
              for (st in 1:length(Select_hydro)){
                #st =1
                #code_hydro <- as.character(hydro[select_HYDRO1[select_HYDRO2[st]],2])
                
                if (dir.exists(paste0(folder_input_,"FlowDurationCurves/",presFut_param_,"/",ifelse(nom_GCM_=="",paste0("FDC_",obsSim_,"_",nom_FDCfolder_param_),nom_GCM_),"/"))){
                  if (file.exists(paste0(folder_input_,"FlowDurationCurves/",presFut_param_,"/",ifelse(nom_GCM_=="",paste0("FDC_",obsSim_,"_",nom_FDCfolder_param_),nom_GCM_),"/FDC_",sub("\\..*", "", Select_hydro[st]),".txt"))){
                    
                    st_hydro = read.table(paste0(folder_input_,"FlowDurationCurves/",presFut_param_,"/",ifelse(nom_GCM_=="",paste0("FDC_",obsSim_,"_",nom_FDCfolder_param_),nom_GCM_),"/FDC_",sub("\\..*", "", Select_hydro[st]),".txt"), header = T, sep = ";", row.names = NULL, quote="")
                    #st_hydro = read.table(paste0(folder_input_,"FlowDurationCurves/",presFut_param_,"/",ifelse(nom_GCM_=="",paste0("FDC_",obsSim_,"_",nomSim_),nom_GCM_),"/FDC_",Select_hydro[st],"_",obsSim_,".txt"), header = T, sep = ";", row.names = NULL, quote="")
                    
                    date_deb = sprintf("%04d-%02d-%02d", annee, as.numeric(liste_mois[date]), jour_moy) # Date au format Hydro
                    # print(date_deb)
                    if (is.na(as.Date(as.character(st_hydro[,1]), "%Y%m%d")[1])){
                      flow_cible = which(as.Date(as.character(st_hydro[,1]), "%Y-%m-%d") == date_deb, arr.ind = TRUE)
                    }else{
                      flow_cible = which(as.Date(as.character(st_hydro[,1]), "%Y%m%d") == date_deb, arr.ind = TRUE)
                    }
                    
                    if (length(flow_cible)>0){
                      for(y in -6:6){
                        if(flow_cible[1]+y<nrow(st_hydro) & flow_cible[1]+y >0){
                          if (!is.na(st_hydro[flow_cible[1]+y,2])){
                            compt = compt + 1
                            weightcompt[(7+y)] = weightcompt[(7+y)]+Weight_hydro[st]
                            if ((flow_cible[1]+y) > 0){
                              output_hydro[compt,y+7] = Weight_hydro[st]*st_hydro[flow_cible[1]+y,2] # Freq non depassement des jours j-6 a j+6
                            }
                          }else{
                            compt = compt + 1
                            output_hydro[compt,y+7] = NA
                          }
                        }
                        else{
                          compt = compt + 1
                          output_hydro[compt,y+7] = NA
                        }
                      }
                    }
                  }
                }else{
                  stop("FDC folder not found.")
                }
              }
              
              # On remplit la matrice finale
              compteur = compteur+1
              
              output[compteur,1] = i # Numero HER 1
              output[compteur,2] = date_moy # Date moyenne des obs usuelles ONDE utilisees pour extraire les valeurs de debit
              output[compteur,3] = (length(assec_us)/length(obs_us))*100 # Calcul du pourcentage d'assec a une date d'obs usuelle dans une HER
              
              if (nrow(output_hydro) > 0){
                # print(sum(output_hydro[,1], na.rm = T))
                # print(weightcompt[1])
                
                output[compteur,4]=sum(output_hydro[,1], na.rm = T)/weightcompt[1] # Moyenne des Frequence au non depassement au jour j de toutes les stations HYDRO d'une HER1
                output[compteur,5]=sum(output_hydro[,2], na.rm = T)/weightcompt[2] # Moyenne des Frequence au non depassement au jour j-1 de toutes les stations HYDRO d'une HER1
                output[compteur,6]=sum(output_hydro[,3], na.rm = T)/weightcompt[3] # Moyenne des Frequence au non depassement au jour j-2 de toutes les stations HYDRO d'une HER1
                output[compteur,7]=sum(output_hydro[,4], na.rm = T)/weightcompt[4] # Moyenne des Frequence au non depassement au jour j-3 de toutes les stations HYDRO d'une HER1
                output[compteur,8]=sum(output_hydro[,5], na.rm = T)/weightcompt[5] # Moyenne des Frequence au non depassement au jour j-4 de toutes les stations HYDRO d'une HER1
                output[compteur,9]=sum(output_hydro[,6], na.rm = T)/weightcompt[6] # Moyenne des Frequence au non depassement au jour j de toutes les stations HYDRO d'une HER1
                output[compteur,10]=sum(output_hydro[,7], na.rm = T)/weightcompt[7] # Moyenne des Frequence au non depassement au jour j-1 de toutes les stations HYDRO d'une HER1
                output[compteur,11]=sum(output_hydro[,9], na.rm = T)/weightcompt[8] # Moyenne des Frequence au non depassement au jour j-2 de toutes les stations HYDRO d'une HER1
                output[compteur,12]=sum(output_hydro[,9], na.rm = T)/weightcompt[9] # Moyenne des Frequence au non depassement au jour j-3 de toutes les stations HYDRO d'une HER1
                output[compteur,13]=sum(output_hydro[,10], na.rm = T)/weightcompt[10] # Moyenne des Frequence au non depassement au jour j-4 de toutes les stations HYDRO d'une HER1
                output[compteur,14]=sum(output_hydro[,11], na.rm = T)/weightcompt[11] # Moyenne des Frequence au non depassement au jour j de toutes les stations HYDRO d'une HER1
                output[compteur,15]=sum(output_hydro[,12], na.rm = T)/weightcompt[12] # Moyenne des Frequence au non depassement au jour j-1 de toutes les stations HYDRO d'une HER1
                output[compteur,16]=sum(output_hydro[,13], na.rm = T)/weightcompt[13] # Moyenne des Frequence au non depassement au jour j-2 de toutes les stations HYDRO d'une HER1
                
              } else {
                output[compteur,4:16]=NA
              }
              
            }else{
              compteur = compteur+1
              output[compteur,1]=i # Numero HER
              output[compteur,2]=date_moy # Date moyenne des obs usuelle ONDE utilisee pour extraire les valeurs de d?bit
              output[compteur,3]=(length(assec_us)/length(obs_us))*100 # Calcul du pourcentage d'assec a une date d'obs usuelle dans une HER
              output[compteur,4:16]=NA
            }
          }
        }
      }
    }
  }
  
  # print(output)
  # print(aaaa)
  colnames(output)<-c(HER_variable_,"Date","%_Assec","Freq_j+6","Freq_j+5","Freq_j+4","Freq_j+3","Freq_j+2","Freq_j+1","Freq_j","Freq_j-1","Freq_j-2","Freq_j-3","Freq_j-4","Freq_j-5","Freq_j-6")
  write.table(output, paste0(folder_output_,"1_MatricesInputModeles_ParHERDates/",nomSim_,"/MatInputModel_ByHERDates_",nom_GCM_,"_",as.character(min(annees_learn_)),"_",as.character(max(annees_learn_)),"_",str_replace_all(basename(il), 'Stations_HYDRO_|.csv', ''),"_",obsSim_,"_Weight.csv"), sep=";", row.name=F, quote=F)
}


### Control ###
# file_eric_ = "/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/SauvegardeCodesES_20230215/Changement Clim/eric/MATRICE_autres/Matrice_SIM_2012_2018__KGESUp0.10_DispSup1._stations_Hydro_weight.csv"
# file_new_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/GR_Thirel_20230216/1_MatricesInputModeles_ParHERDates/2_SelecSurfaceCorr_2012_2018_20230222/MatricesInputModel_ByHERDates_KGESUp0.10_DispSup1_stations_Hydro_weight.csv"
# 
# tab_eric_ = read.table(file_eric_, header = T, sep = ";")
# tab_new_ = read.table(file_new_, header = T, sep = ";")
# 
# dim(tab_eric_)
# dim(tab_new_)
# 
# head(tab_eric_)
# head(tab_new_)







