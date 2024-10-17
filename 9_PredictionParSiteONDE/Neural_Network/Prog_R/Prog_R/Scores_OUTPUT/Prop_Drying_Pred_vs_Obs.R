#-------------------------------------------------------------
# Calcul les proportions d'assecs prédites aux sites ONDE
# par les différents modèles LASSO/Knn/ANN/RF et compare 
# ces valeurs aux observations ONDE période entre 2012 et 2016
#-------------------------------------------------------------

library(pROC)

rm(list=ls())

methode <- "ANN" #"LASSO" "Knn" "Random_Forest" "ANN"
onde <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/RHT/Stations_ONDES_snap_corr_REGIME_hydro_HER2_group.csv", header = T, sep = ";", row.names = NULL, quote="")

output <- data.frame()
compteur <- 0
all_year=0

for (code_ONDE in onde[,9]){
  
  if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/",methode,"/J30_FRANCE_2012_2016/Output_ANN_",code_ONDE,".csv",sep=""))){
    
  repere <- which(as.character(onde[,9])==code_ONDE)
  HER=onde$CdHER2[repere]
  donnees <- read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_Matrice/Input_test_classif_HER_",HER,"_30_jours_fin_caract_new_meteo_FINAL.txt",sep=""), sep=";", header = T, quote="", stringsAsFactors=F)
  select <- which(donnees[,126]>=0)
  compteur=compteur+1 # compteur site ONDE
  assec=0
  ev=0
  no_flow=0
  flow=0
  # on repere les dates d'observation ONDE comprise entre les mois de Mai et Septembre
  repere2 = which(as.character(donnees[,1])==code_ONDE & as.numeric(format(as.Date(donnees[,3],"%d/%m/%Y"),"%m"))>4 & as.numeric(format(as.Date(donnees[,3],"%d/%m/%Y"),"%m")) < 10 )
  
    
    # loading des input de la station à prédire:
    donnees_st<-read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/",methode,"/J30_FRANCE_2012_2016/Output_ANN_",code_ONDE,".csv",sep=""), sep=";", header = T, stringsAsFactors=F)
    val_pred=vector()
    compt=0
    
    for (a in 1:length(repere2)){
      # on repère les dates d'observation ONDE pour calculer les Prop d'assec prédites
      repere3=which(donnees_st[,ncol(donnees_st)]==donnees[repere2[a],3])
      if (length(repere3)>0){
        compt=compt+1
        val_pred[compt]=donnees_st$Prediction[repere3]
      }
    }
    
    assec=which(val_pred==1)
    ev=which(val_pred==0)
    
    output[compteur,1]=code_ONDE
    output[compteur,2]=HER
    output[compteur,3]=onde[repere,13]
    output[compteur,4]=onde[repere,14]
    output[compteur,5]=(length(assec)/(length(assec)+length(ev)))*100
    
    # Calcul de la proportion d'assec observé dans ONDE
    no_flow=which(as.character(donnees[repere2,4])=="Ecoulement non visible" | as.character(donnees[repere2,4])=="Assec")
    flow=which(as.character(donnees[repere2,4])=="Ecoulement visible")
    output[compteur,6]=(length(no_flow)/(length(flow)+length(no_flow)))*100 # PDrying annuel
  } else {
    output[compteur,1]=code_ONDE
    output[compteur,2]=HER
    output[compteur,3]=onde[repere,13]
    output[compteur,4]=onde[repere,14]
    output[compteur,5]=NA
    
    # Calcul de la proportion d'assec observé dans ONDE
    no_flow=which(as.character(donnees[repere2,4])=="Ecoulement non visible" | as.character(donnees[repere2,4])=="Assec")
    flow=which(as.character(donnees[repere2,4])=="Ecoulement visible")
    output[compteur,6]=(length(no_flow)/(length(flow)+length(no_flow)))*100 # PDrying annuel
  }
  compt2=0
  for (annee in 2012:2016){

    select_an=which(as.numeric(format(as.Date(donnees_st$Date,"%d/%m/%Y"),"%Y"))==annee)
    assec_y=which((donnees_st$Prediction[select_an])==1) # Nombre de jour en assec par an
 
    compt_dur_max=0
    compt_dur=0
    compt_ev=0
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
    }
    
    if (length(assec_y)> 0){
      jourjul = as.numeric(format(as.Date(donnees_st$Date[assec_y[1]],"%d/%m/%Y"),"%j")) # jour julien de l'assec le plus récent
      output[compteur,(4*compt2+7)] = length(assec_y)
      output[compteur,(4*compt2+8)] = jourjul
    } else {
      jourjul = 0
      output[compteur,(4*compt2+7)] = 0
      output[compteur,(4*compt2+8)] = jourjul
    }
    output[compteur,(4*compt2+9)] = compt_dur_max
    output[compteur,(4*compt2+10)] = compt_ev
    compt2=compt2+1
  }
}

colnames(output) <- c("Code_ONDE","HER2","x","y","Prop_pred","Prop_obs","NbJ_2012","FreqJul_2012","DUR_2012","NbEv_2012","NbJ_2013","FreqJul_2013","DUR_2013","NbEv_2013","NbJ_2014","FreqJul_2014","DUR_2014","NbEv_2014","NbJ_2015","FreqJul_2015","DUR_2015","NbEv_2015","NbJ_2016","FreqJul_2016","DUR_2016","NbEv_2016")
write.table(output,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/Metrics_Prop_assec_",methode,"_J30_moy_new_HYDRO_ONLY.csv", sep=""), sep=";", row.names = F, col.names = T)
