validationPredictions <- function(test,seuil){
  
  TP_test = length(which(test$Prediction_bin==1 & test$Assec==1))
  FP_test = length(which(test$Prediction_bin==1 & test$Assec==0))
  FN_test = length(which(test$Prediction_bin==0 & test$Assec==1))
  TN_test = length(which(test$Prediction_bin==0 & test$Assec==0))
  
  frame_test <- c()
  
  if (length(unique(test$Assec))>1){
    my_roc <- roc(test$Assec,test$Prediction_bin)
  }else{
    my_roc <- NA
  }
  
  if ((TP_test+FP_test) > 0 & (TP_test+FN_test) > 0 & (TN_test+FP_test) > 0){
    frame_test[1]<-paste(unique(year(test$Date)),collapse = ", ")
    frame_test[2]<-seuil
    frame_test[3]<-TP_test
    frame_test[4]<-FN_test
    frame_test[5]<-TN_test
    frame_test[6]<-FP_test
    Precision <- TP_test/(TP_test+FP_test)
    Recall <- TP_test/(TP_test+FN_test)
    frame_test[7]<-round((2*Precision*Recall)/(Precision+Recall),4) # F1 score
    frame_test[8]<-Precision # Precision
    frame_test[9]<-Recall # Recall
    frame_test[10]<-round((TP_test+TN_test)/(TP_test+TN_test+FP_test+FN_test),4) # Accuracy
    # frame_test[10]<-round((TP_test+TN_test)/length(yhat$Prediction_bin),4) # Accuracy
    if (!is.na(my_roc)){
      frame_test[11]<-round(my_roc$auc,4) # AUC
    }else{
      frame_test[11]<-NA
    }
    frame_test[12]<-round(TP_test/(TP_test+FN_test),4) # Sensi
    frame_test[13]<-round(TN_test/(TN_test+FP_test),4) # Speci
    frame_test[14]<-round(FP_test/(FP_test+TP_test),4) # FAR
  } else {
    frame_test[1]<-year_test
    frame_test[2]<-seuil
    frame_test[3]<-TP_test
    frame_test[4]<-FN_test
    frame_test[5]<-TN_test
    frame_test[6]<-FP_test
    frame_test[7]<-NA # F1 score
    frame_test[8]<-NA # Precision
    frame_test[9]<-NA # Recall
    frame_test[10]<-NA # Accuracy
    frame_test[11]<-NA # Sensi
    frame_test[12]<-NA # Speci
    frame_test[13]<-NA # FAR
    frame_test[14]<-NA # FAR
  }
  
  ### Performances ###
  y <- test$Assec
  y_pred <- test$Prection
  
  frame_test[15] = length(which(test$Assec>0)) #Nombre d'observation superieures a 0
  frame_test[16] = round(mean(y),4) #Moyenne observee
  frame_test[17] = round(mean(y_pred)/100,4)
  
  moy_obs = mean(y*100)
  # moy_obs = sum(onde$NbOutputONDEAssecs)/sum(onde$NbOutputONDE)
  frame_test[18] = round(1 - sum((y_pred-(y*100))**2) / sum((moy_obs-(y*100))**2),4) # NASH = 1 - SCE_residuelle / SCE_Aexpliquer = SCE_expliquee par modele
  r = cor(y*100,y_pred) #Coeff de correlation entre donnees observees et donnees predites
  beta = mean(y_pred)/mean(y*100)
  alpha = mean(y*100)/mean(y_pred)*sd(y_pred)/sd(y*100)
  frame_test[19] = round(1-sqrt((1-r)**2+(1-beta)**2+(1-alpha)**2),4) #KGE
  frame_test[20] = round(sd(y)/mean(y),4) #CV => Indicateur litigieux car mean(y) n'est pas pondere au nombre de donnees ONDE utilisees pour obtenir y
  
  frame_test[21] <- round(sqrt(1/length(y) * sum((y*100-y_pred*100)^2)),4) # RMSE
  frame_test[22] <- round(sum(y_pred*100-y*100)/length(y),4) # Biais
  frame_test[23] <- round(sum(abs(y_pred*100-y*100))/length(y),4) # EMA
  
  frame_test <- data.frame(matrix(frame_test,nrow = 1))
  colnames(frame_test) <- c("YearTest","Seuil",
                            "TP_Test","FN_Test","TN_Test","FP_Test",
                            "F1score_Test","Precision_Test","Recall_Test",
                            "Accuracy_Test","AUC_Test","Sensitivity_Test","Specificity_Test","FalseAlarm_Test",
                            "NbAssecONDE_Test",
                            "P_assecs_HER_MoyenMois_Apredire_Test",
                            "P_assecs_HER_MoyenMois_Predite_Test",
                            "NASH_Test","KGE_Test","CV_Test",
                            "RMSE_Test","Biais_Test","EMA_Test")
  
  return(frame_test)
  
}

