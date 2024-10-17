validationPredictions <- function(test,seuil){
  
  TP_test = length(which(test$Prediction_bin==1 & test$Assec==1))
  FP_test = length(which(test$Prediction_bin==1 & test$Assec==0))
  FN_test = length(which(test$Prediction_bin==0 & test$Assec==1))
  TN_test = length(which(test$Prediction_bin==0 & test$Assec==0))
  
  frame_test <- c()
  
  my_roc <- roc(test$Assec,test$Prediction_bin)
  
  if ((TP_test+FP_test) > 0 & (TP_test+FN_test) > 0 & (TN_test+FP_test) > 0){
    frame_test[1]<-year_test
    frame_test[2]<-median(seuil_opti)
    Precision <- round(TP_test/(TP_test+FP_test),4)
    Recall <- round(TP_test/(TP_test+FN_test),4)
    frame_test[3]<-round((2*Precision*Recall)/(Precision+Recall),4) # F1 score
    frame_test[4]<-round(Precision,4) # Precision
    frame_test[5]<-round(Recall,4) # Recall
    frame_test[6]<-round((TP_test+TN_test)/length(yhat$Prediction_bin),4) # Accuracy
    frame_test[7]<-round(my_roc$auc,4) # AUC
    frame_test[8]<-round(TP_test/(TP_test+FN_test),4) # Sensi
    frame_test[9]<-round(TN_test/(TN_test+FP_test),4) # Speci
    frame_test[10]<-round(FP_test/(FP_test+TP_test),4) # FAR
  } else {
    frame_test[1]<-year_test
    frame_test[2]<-seuil
    frame_test[3]<-NA # F1 score
    frame_test[4]<-NA # Precision
    frame_test[5]<-NA # Recall
    frame_test[6]<-NA # Accuracy
    frame_test[7]<-NA # Sensi
    frame_test[8]<-NA # Speci
    frame_test[9]<-NA # FAR
    frame_test[10]<-NA # FAR
  }
  
  ### Performances ###
  y <- test$Assec
  y_pred <- test$Prection
  
  frame_test[11] = length(which(test$Assec>0)) #Nombre d'observation superieures a 0
  frame_test[12] = round(mean(y),4) #Moyenne observee

  moy_obs = mean(y*100)
  # moy_obs = sum(onde$NbOutputONDEAssecs)/sum(onde$NbOutputONDE)
  frame_test[13] = round(1 - sum((y_pred-(y*100))**2) / sum((moy_obs-(y*100))**2),4) #1 - SCE_residuelle / SCE_Aexpliquer = SCE_expliquee par modele
  r = cor(y*100,y_pred) #Coeff de correlation entre donnees observees et donnees predites
  beta = mean(y_pred)/mean(y*100)
  alpha = mean(y*100)/mean(y_pred)*sd(y_pred)/sd(y*100)
  frame_test[14] = round(1-sqrt((1-r)**2+(1-beta)**2+(1-alpha)**2),4) #KGE
  frame_test[15] = round(sd(y)/mean(y),4) #CV => Indicateur litigieux car mean(y) n'est pas pondere au nombre de donnees ONDE utilisees pour obtenir y

  frame_test[16] = round(mean(y_pred)/100,4)
  
  frame_test <- data.frame(matrix(frame_test,nrow = 1))
  colnames(frame_test) <- c("YearTest","Seuil","F1.score","Precision","Recall",
                            "Accuracy","AUC","Sensitivity","Specificity","FalseAlarm",
                            "NbAssecONDE_Test",
                            "P_assecs_HER_MoyenMois_Apredire_Test",
                            paste0("NASH_Test"),
                            paste0("KGE_Test"),
                            paste0("CV_Test"),
                            "P_assecs_HER_MoyenMois_Predite_Test")
  
  return(frame_test)
  
}

