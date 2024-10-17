#---------------------------------------------
# Modèle benchmark de prédiction des assecs
#---------------------------------------------

rm(list=ls())

list_year=c(2017)
param=c(27)

HER2 <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/HER/Hydroecoregion2_group.csv",sep=";",header=T,quote="")

critere_full=data.frame()

for (HERc in HER2[,3]){
  if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_model_benchmark/Input_test_model_simple_usuelle_",HERc,".txt",sep=""))){
    data <- read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_model_benchmark/Input_test_model_simple_usuelle_",HERc,".txt",sep=""), sep=";", header = T, quote="", stringsAsFactors=F)
    donnees <- read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_Matrice_2017/Input_test_classif_HER_",HERc,"_30_jours_fin_caract_new_meteo_FINAL.txt",sep=""), sep=";", header = T, quote="", stringsAsFactors=F)
    # select = which(donnees[,126]>=0)
    
    # on garde : code_station/date/obs
    data2<- data.frame(cbind(donnees[,1],donnees[,3],donnees[,127]))
    

    for (year_test in list_year){
      
      # Selection des jeux de données d'entrainement et de validation par année
      selection_test2 = which(format(as.Date(data2[,2]),"%Y")==as.numeric(year_test))
      ypred_all<-data2[selection_test2,]
      selection_train = which(format(as.Date(data[,2], "%d/%m/%Y"),"%Y")!=as.numeric(year_test))
      selection_test = which(format(as.Date(data[,2], "%d/%m/%Y"),"%Y")==as.numeric(year_test))
      ypred=data.frame()
      
      # Pour déterminer la fréquence d'états d'écouelement majoritaire on en se base que sur les observations 
      # usuelles contenues dans "data"
      for (i in 1:length(selection_test)){
        
        code_onde=data[selection_test[i],1]
        mois=format(as.Date(data[selection_test[i],2], "%d/%m/%Y"),"%m")
        repere=which(as.character(data[selection_train,1])==code_onde & format(as.Date(data[selection_train,2], "%d/%m/%Y"),"%m")==mois)
        ypred[i,1]=data[selection_test[i],3] #obs
        
        if (length(repere)>0){
          no_flow=which(data[selection_train[repere],3]==1)
          flow=which(data[selection_train[repere],3]==0)
          if(length(no_flow)>length(flow)){
            ypred[i,2]=1
          } else if (length(no_flow)<length(flow)){
            ypred[i,2]=0
          } else if (length(no_flow)==length(flow)){
            ypred[i,2] = sample(0:1, 1)
          }
        } else {
          ypred[i,2]=NA
        }
        ypred[i,3]=data[selection_test[i],2] # Date obs
        ypred[i,4]=code_onde # code onde
      }
      
      # On affecte l'état d'écoulement majoritaire ensuite aux observations usuelles ET suivi complémentaire
      # on se basant sur les dates les plus proches
      for (b in 1:nrow(ypred_all)){
        
        code_onde=ypred_all[b,1]
        select_st=which(as.character(ypred[,4])==code_onde)
        date_diff_ref=9999
        if (length(select_st) > 0){
          for (c in 1:length(select_st)){
            date_diff = abs(as.numeric(as.Date(ypred_all[b,2]) - as.Date(ypred[select_st[c],3], "%d/%m/%Y")))
            
            if (date_diff < date_diff_ref){
              repere_fin=select_st[c]
              date_diff_ref=date_diff
            }
          }
        }
        if (date_diff_ref!=9999){
          ypred_all[b,4]=as.numeric(ypred[repere_fin,2])
        } else {
          ypred_all[b,4]=NA
        }
      }
      
      TP=0
      FP=0
      FN=0
      TN=0
      
      # si donnees usuelles uniquement
      # for (id in 1:nrow(ypred)){
      #   if (!is.na(ypred[id,2])){
      #     if(ypred[id,2]==1 & ypred[id,1]==1){
      #       TP=TP+1
      #     } else if (ypred[id,2]==1 & ypred[id,1]==0){
      #       FP=FP+1
      #     } else if (ypred[id,2]==0 & ypred[id,1]==1){
      #       FN=FN+1
      #     } else if (ypred[id,2]==0 & ypred[id,1]==0){
      #       TN=TN+1
      #     }
      #   }
      # }
      
      # si toutes les données disponibles
      for (id in 1:nrow(ypred_all)){
        if (!is.na(ypred_all[id,4])){
          if(ypred_all[id,3]==1 & ypred_all[id,4]==1){
            TP=TP+1
          } else if (ypred_all[id,3]==1 & ypred_all[id,4]==0){
            FP=FP+1
          } else if (ypred_all[id,3]==0 & ypred_all[id,4]==1){
            FN=FN+1
          } else if (ypred_all[id,3]==0 & ypred_all[id,4]==0){
            TN=TN+1
          }
        }
      }
      
      F1.score <- NULL
      accuracy <- NULL
      precision <- NULL
      Recall <- NULL
      POD <- NULL
      FAR <- NULL
      
      POD <- (TP/(TP+FN))*100
      FAR <- (FP/(FP+TP))*100
      accuracy <- ((TP+TN)/(TP+TN+FP+FN))*100
      precision <- TP/(TP+FP)
      Recall <- TP/(TP+FN)
      F1.score <- (2*precision*Recall)/(precision+Recall)
      critere = data.frame(cbind(HERc,POD,FAR,accuracy,precision,Recall,F1.score,year_test,param))
      critere_full = data.frame(rbind(critere_full,critere))
      
      colnames(ypred_all)<-c("CODE","Date","OBS","PRED")
      write.table(ypred_all,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/BENCHMARK_MODEL/France_2017/Output_BM_",HERc,"_2017.csv", sep=""), sep=";", row.names = F, col.names = T)
      
    } # liste année
  } # si matrice données existe
} # boucle HER2

colnames(critere_full) <- c("HER2", "POD", "FAR","Accuracy","Precision","Recall","F1_score","year_test","Nb_param")
write.table(critere_full,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Predictions/BENCHMARK_MODEL/France_2017/critere_2017_FULL_Model_benchmark.csv", sep=""), sep=";", row.names = F, col.names = T)

