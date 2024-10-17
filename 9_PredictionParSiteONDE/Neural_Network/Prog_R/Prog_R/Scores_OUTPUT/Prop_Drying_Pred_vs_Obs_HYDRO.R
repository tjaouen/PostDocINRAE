#-------------------------------------------------------------
# Calcul les proportions d'assecs prédites aux sites ONDE
# par les différents modèles LASSO/Knn/ANN/RF et compare 
# ces valeurs aux observations ONDE période entre 2012 et 2016
#-------------------------------------------------------------

library(pROC)

rm(list=ls())

methode <- "Random_Forest" #"LASSO" "Knn" "Random_Forest" "ANN"
onde <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/RHT/Stations_ONDES_snap_corr_REGIME_hydro_HER2_group.csv", header = T, sep = ";", row.names = NULL, quote="")

# nom_data <- paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Liste_station_4_HER_SELECT_NEW.csv",sep="")
nom_data <- paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Liste_station_HER_FRANCE.csv",sep="")
liste_HYDRO <- read.table(file = nom_data, header = TRUE, sep = ";",  row.names = NULL, quote="")

output <- data.frame()
output2 <- data.frame()

compteur <- 0
all_year=0

for (code_ONDE in liste_HYDRO[,1]){
  compteur=compteur+1
  # compteur=33
  HER=liste_HYDRO[compteur,2]
  output[compteur,1]=code_ONDE
  output[compteur,2]=HER
  output2[compteur,1]=code_ONDE
  output2[compteur,2]=HER
  if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/",methode,"/J30_FRANCE_2012_2016_station_HYDRO/Output_RF_station_HYDRO_",code_ONDE,"_HER2_",HER,".csv",sep=""))){
    
    # repere <- which(as.character(onde[,9])==code_ONDE)
    
    donnees_st <- read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/",methode,"/J30_FRANCE_2012_2016_station_HYDRO/Output_RF_station_HYDRO_",code_ONDE,"_HER2_",HER,".csv",sep=""), sep=";", header = T)
    # select <- which(donnees[,126]>=0)
    # assec=0
    # ev=0
    # no_flow=0
    # flow=0
    
    
    compt2=0
    for (annee in 2012:2016){
      
      select_an=which(as.numeric(format(as.Date(donnees_st$Date,"%d/%m/%Y"),"%Y"))==annee)
      assec_y=which((donnees_st$Prediction[select_an])==1) # Nombre de jour en assec par an
      assec_y_obs=which((donnees_st$Q_obs[select_an])<=1) # Nombre de jour en assec par an
      
      compt_dur_max=0
      compt_dur=0
      compt_ev=0
      compt_dur_max_obs=0
      compt_dur_obs=0
      compt_ev_obs=0

      for (j in 1:length(select_an)){
        
        # Calcul des métriques pour les prédictions
        if (donnees_st$Prediction[select_an[j]]==1){
          if (j==1){
            compt_ev=compt_ev+1
            compt_dur=compt_dur+1
          } else if(j==length(select_an)){
            if (compt_dur>compt_dur_max){
              compt_dur_max=compt_dur
            }
          } else {
            if(donnees_st$Prediction[select_an[j-1]]!=1){
              compt_ev=compt_ev+1
              compt_dur=compt_dur+1
            } else if (donnees_st$Prediction[select_an[j-1]]==1){
              compt_dur=compt_dur+1
            }
          }
        } else if (donnees_st$Prediction[select_an[j]]==0){
          if (j!=1){
            if(donnees_st$Prediction[select_an[j-1]]==1){
              if (compt_dur>compt_dur_max){
                compt_dur_max=compt_dur
              }
              compt_dur=0
            }
          }
        }
        
        # Calcul des métriques pour les observations
        if (!is.na(donnees_st$Q_obs[select_an[j]])){
          if (donnees_st$Q_obs[select_an[j]]<=1){
            if (j==1){
              compt_ev_obs=compt_ev_obs+1
              compt_dur_obs=compt_dur_obs+1
            } else if(j==length(select_an)){
              if (compt_dur_obs>compt_dur_max_obs){
                compt_dur_max_obs=compt_dur_obs
              }
            } else {
              if(!is.na(donnees_st$Q_obs[select_an[j-1]])){
                if(donnees_st$Q_obs[select_an[j-1]]>1){
                  compt_ev_obs=compt_ev_obs+1
                  compt_dur_obs=compt_dur_obs+1
                } else if (donnees_st$Q_obs[select_an[j-1]]<=1){
                  compt_dur_obs=compt_dur_obs+1
                }
              } else {
                compt_ev_obs=compt_ev_obs+1
                compt_dur_obs=compt_dur_obs+1
              }
            }
          } else if (donnees_st$Q_obs[select_an[j]]>1){
            if (j!=1){
              if(!is.na(donnees_st$Q_obs[select_an[j-1]])){
                if(donnees_st$Q_obs[select_an[j-1]]<=1){
                  if (compt_dur_obs>compt_dur_max_obs){
                    compt_dur_max_obs=compt_dur_obs
                  }
                  compt_dur_obs=0
                }
              }
            }
          }
        } else {
          compt_dur_obs=0
        }
      }
      
      if (length(assec_y)> 0){
        jourjul = as.numeric(format(as.Date(donnees_st$Date[assec_y[1]],"%d/%m/%Y"),"%j")) # jour julien de l'assec le plus récent
        output[compteur,(4*compt2+3)] = length(assec_y)
        output[compteur,(4*compt2+4)] = jourjul
      } else {
        jourjul = 0
        output[compteur,(4*compt2+3)] = 0
        output[compteur,(4*compt2+4)] = jourjul
      }
      
      if (length(assec_y_obs)> 0){
        jourjulObs = as.numeric(format(as.Date(donnees_st$Date[assec_y_obs[1]],"%d/%m/%Y"),"%j")) # jour julien de l'assec le plus récent
        output2[compteur,(4*compt2+3)] = length(assec_y_obs)
        output2[compteur,(4*compt2+4)] = jourjulObs
      } else {
        jourjulObs = 0
        output2[compteur,(4*compt2+3)] = 0
        output2[compteur,(4*compt2+4)] = jourjulObs
      }
      
      output[compteur,(4*compt2+5)] = compt_dur_max
      output[compteur,(4*compt2+6)] = compt_ev
      output2[compteur,(4*compt2+5)] = compt_dur_max_obs
      output2[compteur,(4*compt2+6)] = compt_ev_obs
      compt2=compt2+1
    }
  }
}  

colnames(output) <- c("Code_ONDE","HER2","NbJ_2012","FreqJul_2012","DUR_2012","NbEv_2012","NbJ_2013","FreqJul_2013","DUR_2013","NbEv_2013","NbJ_2014","FreqJul_2014","DUR_2014","NbEv_2014","NbJ_2015","FreqJul_2015","DUR_2015","NbEv_2015","NbJ_2016","FreqJul_2016","DUR_2016","NbEv_2016")
write.table(output,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/Metrics_PRED_Stations_HYDRO_",methode,"_J30_moy_2012_2016_FRANCE.csv", sep=""), sep=";", row.names = F, col.names = T)

colnames(output2) <- c("Code_ONDE","HER2","NbJ_2012","FreqJul_2012","DUR_2012","NbEv_2012","NbJ_2013","FreqJul_2013","DUR_2013","NbEv_2013","NbJ_2014","FreqJul_2014","DUR_2014","NbEv_2014","NbJ_2015","FreqJul_2015","DUR_2015","NbEv_2015","NbJ_2016","FreqJul_2016","DUR_2016","NbEv_2016")
write.table(output2,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/Metrics_OBS_Stations_HYDRO_",methode,"_J30_moy_2012_2016_FRANCE.csv", sep=""), sep=";", row.names = F, col.names = T)
