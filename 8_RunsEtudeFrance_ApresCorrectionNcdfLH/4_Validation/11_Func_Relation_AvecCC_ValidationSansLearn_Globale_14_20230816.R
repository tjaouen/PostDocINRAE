#-------------------------------------------------------------------------------
# Fonction FUNC_CAL_VAL() qui permet de faire un calage et une validation crois? des r?sultats 

# Bottet Quentin - Irstea - 18/09/2019 - Version 1
#-------------------------------------------------------------------------------
library(dplyr)

FUNC_CAL_VAL_ValidationSansLearn_Globale <- function(annee,Matrice_comp,liste_Her,nbrRep,proportionTest){
  
  if (is.numeric(annee) & nchar(annee) == 4){onde = Matrice_comp[which(substr(Matrice_comp[,c("Date")],7,10)!= annee),]
  }else if(is.numeric(annee) & nchar(annee) != 4){onde = Matrice_comp[which(substr(Matrice_comp[,c("Date")],5,3)!= annee),]
  }else{onde = Matrice_comp}
  # output=data.frame()
  compt=0
  compte=0
  
  ### Performance predictions ###
  P_assecs_HER_MoyenneGlobale_Predit_general <- c()
  P_assecs_HER_MoyenneGlobale_Predit_boot <- c()
  P_assecs_HER_MoyenneGlobale_Predit_boot_IC95inf <- c()
  P_assecs_HER_MoyenneGlobale_Predit_boot_IC95sup <- c()
  P_assecs_HER_MoyenneGlobale_Apredire_general <- c()
  P_assecs_HER_MoyenneGlobale_Apredire_boot <- c()
  P_assecs_HER_MoyenneGlobale_Apredire_boot_IC95inf <- c()
  P_assecs_HER_MoyenneGlobale_Apredire_boot_IC95sup <- c()
  NASH_HER_AnneeValid_logit_CValid_general <- c()
  NASH_HER_AnneeValid_logit_CValid_boot <- c()
  NASH_HER_AnneeValid_logit_CValid_boot_IC95inf <- c()
  NASH_HER_AnneeValid_logit_CValid_boot_IC95sup <- c()
  KGE_HER_AnneeValid_logit_CValid_general <- c()
  KGE_HER_AnneeValid_logit_CValid_boot <- c()
  KGE_HER_AnneeValid_logit_CValid_boot_IC95inf <- c()
  KGE_HER_AnneeValid_logit_CValid_boot_IC95sup <- c()
  CV_HER_AnneeValid_logit_CValid_general <- c()
  CV_HER_AnneeValid_logit_CValid_boot <- c()
  CV_HER_AnneeValid_logit_CValid_boot_IC95inf <- c()
  CV_HER_AnneeValid_logit_CValid_boot_IC95sup <- c()
  PropParameterDeviance_logit_Learn_general <- c()
  PropParameterDeviance_logit_Learn_boot <- c()
  PropParameterDeviance_logit_Learn_boot_IC95inf <- c()
  PropParameterDeviance_logit_Learn_boot_IC95sup <- c()
  
  Intercept_general = c()
  Intercept_boot = c()
  Intercept_boot_IC95inf = c()
  Intercept_boot_IC95sup = c()
  Slope_general = c()
  Slope_boot = c()
  Slope_boot_IC95inf = c()
  Slope_boot_IC95sup = c()
  
  RMSE_general = c()
  RMSE_boot = c()
  RMSE_boot_IC95inf = c()
  RMSE_boot_IC95sup = c()
  Biais_general = c()
  Biais_boot = c()
  Biais_boot_IC95inf = c()
  Biais_boot_IC95sup = c()
  ErreurMoyenneAbsolue_general = c()
  ErreurMoyenneAbsolue_boot = c()
  ErreurMoyenneAbsolue_boot_IC95inf = c()
  ErreurMoyenneAbsolue_boot_IC95sup = c()
  
  RMSE_3maxApred_general = c()
  RMSE_3maxApred_boot = c()
  RMSE_3maxApred_boot_IC95inf = c()
  RMSE_3maxApred_boot_IC95sup = c()
  Biais_3maxApred_general = c()
  Biais_3maxApred_boot = c()
  Biais_3maxApred_boot_IC95inf = c()
  Biais_3maxApred_boot_IC95sup = c()
  ErreurMoyenneAbsolue_3maxApred_general = c()
  ErreurMoyenneAbsolue_3maxApred_boot = c()
  ErreurMoyenneAbsolue_3maxApred_boot_IC95inf = c()
  ErreurMoyenneAbsolue_3maxApred_boot_IC95sup = c()
  
  RMSE_mai_general = c()
  RMSE_mai_boot = c()
  RMSE_mai_boot_IC95inf = c()
  RMSE_mai_boot_IC95sup = c()
  Biais_mai_general = c()
  Biais_mai_boot = c()
  Biais_mai_boot_IC95inf = c()
  Biais_mai_boot_IC95sup = c()
  ErreurMoyenneAbsolue_mai_general = c()
  ErreurMoyenneAbsolue_mai_boot = c()
  ErreurMoyenneAbsolue_mai_boot_IC95inf = c()
  ErreurMoyenneAbsolue_mai_boot_IC95sup = c()
  
  RMSE_juin_general = c()
  RMSE_juin_boot = c()
  RMSE_juin_boot_IC95inf = c()
  RMSE_juin_boot_IC95sup = c()
  Biais_juin_general = c()
  Biais_juin_boot = c()
  Biais_juin_boot_IC95inf = c()
  Biais_juin_boot_IC95sup = c()
  ErreurMoyenneAbsolue_juin_general = c()
  ErreurMoyenneAbsolue_juin_boot = c()
  ErreurMoyenneAbsolue_juin_boot_IC95inf = c()
  ErreurMoyenneAbsolue_juin_boot_IC95sup = c()
  
  RMSE_juillet_general = c()
  RMSE_juillet_boot = c()
  RMSE_juillet_boot_IC95inf = c()
  RMSE_juillet_boot_IC95sup = c()
  Biais_juillet_general = c()
  Biais_juillet_boot = c()
  Biais_juillet_boot_IC95inf = c()
  Biais_juillet_boot_IC95sup = c()
  ErreurMoyenneAbsolue_juillet_general = c()
  ErreurMoyenneAbsolue_juillet_boot = c()
  ErreurMoyenneAbsolue_juillet_boot_IC95inf = c()
  ErreurMoyenneAbsolue_juillet_boot_IC95sup = c()
  
  RMSE_aout_general = c()
  RMSE_aout_boot = c()
  RMSE_aout_boot_IC95inf = c()
  RMSE_aout_boot_IC95sup = c()
  Biais_aout_general = c()
  Biais_aout_boot = c()
  Biais_aout_boot_IC95inf = c()
  Biais_aout_boot_IC95sup = c()
  ErreurMoyenneAbsolue_aout_general = c()
  ErreurMoyenneAbsolue_aout_boot = c()
  ErreurMoyenneAbsolue_aout_boot_IC95inf = c()
  ErreurMoyenneAbsolue_aout_boot_IC95sup = c()
  
  RMSE_septembre_general = c()
  RMSE_septembre_boot = c()
  RMSE_septembre_boot_IC95inf = c()
  RMSE_septembre_boot_IC95sup = c()
  Biais_septembre_general = c()
  Biais_septembre_boot = c()
  Biais_septembre_boot_IC95inf = c()
  Biais_septembre_boot_IC95sup = c()
  ErreurMoyenneAbsolue_septembre_general = c()
  ErreurMoyenneAbsolue_septembre_boot = c()
  ErreurMoyenneAbsolue_septembre_boot_IC95inf = c()
  ErreurMoyenneAbsolue_septembre_boot_IC95sup = c()
  
  RMSE_maxAnnees_general <- c()
  Biais_maxAnnees_general <- c()
  ErreurMoyenneAbsolue_maxAnnees_general <- c()
  
  
  ### Version sans IC ###
  P_assecs_HER_MoyenneGlobale_Predit_general <- c()
  P_assecs_HER_MoyenneGlobale_Apredire_general <- c()
  NASH_HER_AnneeValid_logit_CValid_general <- c()
  KGE_HER_AnneeValid_logit_CValid_general <- c()
  CV_HER_AnneeValid_logit_CValid_general <- c()
  PropParameterDeviance_logit_Learn_general <- c()
  
  for (id in 1:length(liste_Her)) {
    
    print(id)
    select <- which(onde[,1]==liste_Her[id])
    
    P_assecs_HER_MoyenneGlobale_Predit_tmp <- c()
    P_assecs_HER_MoyenneGlobale_Apredire_tmp <- c()
    NASH_HER_AnneeValid_logit_CValid_tmp <- c()
    KGE_HER_AnneeValid_logit_CValid_tmp <- c()
    CV_HER_AnneeValid_logit_CValid_tmp <- c()
    PropParameterDeviance_logit_Learn_tmp <- c()
    RMSE_tmp = c()
    Biais_tmp = c()
    ErreurMoyenneAbsolue_tmp = c()
    RMSE_3maxApred_tmp = c()
    Biais_3maxApred_tmp = c()
    ErreurMoyenneAbsolue_3maxApred_tmp = c()
    
    RMSE_mai_tmp = c()
    Biais_mai_tmp = c()
    ErreurMoyenneAbsolue_mai_tmp = c()
    RMSE_juin_tmp = c()
    Biais_juin_tmp = c()
    ErreurMoyenneAbsolue_juin_tmp = c()
    RMSE_juillet_tmp = c()
    Biais_juillet_tmp = c()
    ErreurMoyenneAbsolue_juillet_tmp = c()
    RMSE_aout_tmp = c()
    Biais_aout_tmp = c()
    ErreurMoyenneAbsolue_aout_tmp = c()
    RMSE_septembre_tmp = c()
    Biais_septembre_tmp = c()
    ErreurMoyenneAbsolue_septembre_tmp = c()
    
    for (i in 1:nbrRep){
      
      print(paste0('Rep : ',i))
      
      set.seed(i)
      # set.seed(seed)
      
      select_test_ <- sample(select, size = round(proportionTest*length(select)))
      tab_test = onde[select_test_,]
      
      y <- tab_test$ProbaAssec_HERMoisAnnee_Apredire_CValid
      y_pred <- tab_test$ProbaAssec_HERMoisAnnee_Predite_CValid
      moy_obs  <- mean(y_pred)
      
      ### Performance predictions ###
      P_assecs_HER_MoyenneGlobale_Predit_tmp[i] <- moy_obs
      P_assecs_HER_MoyenneGlobale_Apredire_tmp[i] <- mean(y)
      NASH_HER_AnneeValid_logit_CValid_tmp[i] <- 1 - sum((y_pred-y)**2) / sum((moy_obs-y)**2)
      
      r <- cor(y,y_pred) #Coeff de correlation entre donnees observees et donnees predites
      beta <- mean(y_pred)/mean(y)
      alpha <- mean(y)/mean(y_pred)*sd(y_pred)/sd(y)
      KGE_HER_AnneeValid_logit_CValid_tmp[i] <- 1-sqrt((1-r)**2+(1-beta)**2+(1-alpha)**2)
      CV_HER_AnneeValid_logit_CValid_tmp[i] <- sd(y)/moy_obs ### INDICATEUR FAUX
      
      PropParameterDeviance_logit_Learn_tmp[i] <- mean(tab_test$PropParameterDeviance_logit_Learn)
      
      RMSE_tmp[i] <- sqrt(1/length(y) * sum((y-y_pred)^2))
      Biais_tmp[i] <- sum(y_pred-y)/length(y)
      ErreurMoyenneAbsolue_tmp[i] <- sum(abs(y_pred-y))/length(y)
      
      
      ### Sur les 5 valeurs les plus hautes de la Proba d'assec a predire ###
      tab_test_3val = tab_test[which(tab_test$ProbaAssec_HERMoisAnnee_Apredire_CValid %in% head(unique(sort(tab_test$ProbaAssec_HERMoisAnnee_Apredire_CValid, decreasing = T)),3)),]
      y <- tab_test_3val$ProbaAssec_HERMoisAnnee_Apredire_CValid
      y_pred <- tab_test_3val$ProbaAssec_HERMoisAnnee_Predite_CValid
      RMSE_3maxApred_tmp[i] <- sqrt(1/length(y) * sum((y-y_pred)^2))
      Biais_3maxApred_tmp[i] <- sum(y_pred-y)/length(y)
      ErreurMoyenneAbsolue_3maxApred_tmp[i] <- sum(abs(y_pred-y))/length(y)
      
      ### Sur le mois de mai ###
      tab_test_mai = tab_test[which(months(as.Date(tab_test$Date)) == "mai"),]
      y <- tab_test_mai$ProbaAssec_HERMoisAnnee_Apredire_CValid
      y_pred <- tab_test_mai$ProbaAssec_HERMoisAnnee_Predite_CValid
      RMSE_mai_tmp[i] <- sqrt(1/length(y) * sum((y-y_pred)^2))
      Biais_mai_tmp[i] <- sum(y_pred-y)/length(y)
      ErreurMoyenneAbsolue_mai_tmp[i] <- sum(abs(y_pred-y))/length(y)
      
      ### Sur le mois de juin ###
      tab_test_juin = tab_test[which(months(as.Date(tab_test$Date)) == "juin"),]
      y <- tab_test_juin$ProbaAssec_HERMoisAnnee_Apredire_CValid
      y_pred <- tab_test_juin$ProbaAssec_HERMoisAnnee_Predite_CValid
      RMSE_juin_tmp[i] <- sqrt(1/length(y) * sum((y-y_pred)^2))
      Biais_juin_tmp[i] <- sum(y_pred-y)/length(y)
      ErreurMoyenneAbsolue_juin_tmp[i] <- sum(abs(y_pred-y))/length(y)
      
      ### Sur le mois de juillet ###
      tab_test_juillet = tab_test[which(months(as.Date(tab_test$Date)) == "juillet"),]
      y <- tab_test_juillet$ProbaAssec_HERMoisAnnee_Apredire_CValid
      y_pred <- tab_test_juillet$ProbaAssec_HERMoisAnnee_Predite_CValid
      RMSE_juillet_tmp[i] <- sqrt(1/length(y) * sum((y-y_pred)^2))
      Biais_juillet_tmp[i] <- sum(y_pred-y)/length(y)
      ErreurMoyenneAbsolue_juillet_tmp[i] <- sum(abs(y_pred-y))/length(y)
      
      ### Sur le mois de aout ###
      tab_test_aout = tab_test[which(months(as.Date(tab_test$Date)) == "août"),]
      y <- tab_test_aout$ProbaAssec_HERMoisAnnee_Apredire_CValid
      y_pred <- tab_test_aout$ProbaAssec_HERMoisAnnee_Predite_CValid
      RMSE_aout_tmp[i] <- sqrt(1/length(y) * sum((y-y_pred)^2))
      Biais_aout_tmp[i] <- sum(y_pred-y)/length(y)
      ErreurMoyenneAbsolue_aout_tmp[i] <- sum(abs(y_pred-y))/length(y)
      
      ### Sur le mois de septembre ###
      tab_test_septembre = tab_test[which(months(as.Date(tab_test$Date)) == "septembre"),]
      y <- tab_test_septembre$ProbaAssec_HERMoisAnnee_Apredire_CValid
      y_pred <- tab_test_septembre$ProbaAssec_HERMoisAnnee_Predite_CValid
      RMSE_septembre_tmp[i] <- sqrt(1/length(y) * sum((y-y_pred)^2))
      Biais_septembre_tmp[i] <- sum(y_pred-y)/length(y)
      ErreurMoyenneAbsolue_septembre_tmp[i] <- sum(abs(y_pred-y))/length(y)

    }
    
    ### Donnees ###
    P_assecs_HER_MoyenneGlobale_Predit_boot[id] <- round(mean(na.omit(P_assecs_HER_MoyenneGlobale_Predit_tmp))*100,1)
    P_assecs_HER_MoyenneGlobale_Predit_boot_IC95inf[id] <- round(quantile(na.omit(P_assecs_HER_MoyenneGlobale_Predit_tmp),c(0.025,0.975))[[1]]*100,1)
    P_assecs_HER_MoyenneGlobale_Predit_boot_IC95sup[id] <- round(quantile(na.omit(P_assecs_HER_MoyenneGlobale_Predit_tmp),c(0.025,0.975))[[2]]*100,1)
    
    P_assecs_HER_MoyenneGlobale_Apredire_boot[id] <- round(mean(na.omit(P_assecs_HER_MoyenneGlobale_Apredire_tmp))*100,1)
    P_assecs_HER_MoyenneGlobale_Apredire_boot_IC95inf[id] <- round(quantile(na.omit(P_assecs_HER_MoyenneGlobale_Apredire_tmp),c(0.025,0.975))[[1]]*100,1)
    P_assecs_HER_MoyenneGlobale_Apredire_boot_IC95sup[id] <- round(quantile(na.omit(P_assecs_HER_MoyenneGlobale_Apredire_tmp),c(0.025,0.975))[[2]]*100,1)
    
    ### Performances ###
    NASH_HER_AnneeValid_logit_CValid_boot[id] <- round(mean(na.omit(NASH_HER_AnneeValid_logit_CValid_tmp)),3)
    NASH_HER_AnneeValid_logit_CValid_boot_IC95inf[id] <- round(quantile(na.omit(NASH_HER_AnneeValid_logit_CValid_tmp),c(0.025,0.975))[[1]],3)
    NASH_HER_AnneeValid_logit_CValid_boot_IC95sup[id] <- round(quantile(na.omit(NASH_HER_AnneeValid_logit_CValid_tmp),c(0.025,0.975))[[2]],3)
    
    KGE_HER_AnneeValid_logit_CValid_boot[id] <- round(mean(na.omit(KGE_HER_AnneeValid_logit_CValid_tmp)),3)
    KGE_HER_AnneeValid_logit_CValid_boot_IC95inf[id] <- round(quantile(na.omit(KGE_HER_AnneeValid_logit_CValid_tmp),c(0.025,0.975))[[1]],3)
    KGE_HER_AnneeValid_logit_CValid_boot_IC95sup[id] <- round(quantile(na.omit(KGE_HER_AnneeValid_logit_CValid_tmp),c(0.025,0.975))[[2]],3)
    
    CV_HER_AnneeValid_logit_CValid_boot[id] <- round(mean(na.omit(CV_HER_AnneeValid_logit_CValid_tmp)),3)
    CV_HER_AnneeValid_logit_CValid_boot_IC95inf[id] <- round(quantile(na.omit(CV_HER_AnneeValid_logit_CValid_tmp),c(0.025,0.975))[[1]],3)
    CV_HER_AnneeValid_logit_CValid_boot_IC95sup[id] <- round(quantile(na.omit(CV_HER_AnneeValid_logit_CValid_tmp),c(0.025,0.975))[[2]],3)
    
    ### Modeles ###
    PropParameterDeviance_logit_Learn_boot[id] <- round(mean(na.omit(PropParameterDeviance_logit_Learn_tmp)),3)
    PropParameterDeviance_logit_Learn_boot_IC95inf[id] <- round(quantile(na.omit(PropParameterDeviance_logit_Learn_tmp),c(0.025,0.975))[[1]],3)
    PropParameterDeviance_logit_Learn_boot_IC95sup[id] <- round(quantile(na.omit(PropParameterDeviance_logit_Learn_tmp),c(0.025,0.975))[[2]],3)
    
    tab_reduiteParApprentissage_ = aggregate(onde[select,c("AnneesLearn","Inter_logit_Learn","Slope_logit_Learn")],by = list(onde$AnneesLearn[select]),FUN = mean)
    Intercept_boot[id] <- round(mean(na.omit(tab_reduiteParApprentissage_$Inter_logit_Learn)),3)
    Intercept_boot_IC95inf[id] <- round(quantile(na.omit(tab_reduiteParApprentissage_$Inter_logit_Learn),c(0.025,0.975))[[1]],3)
    Intercept_boot_IC95sup[id] <- round(quantile(na.omit(tab_reduiteParApprentissage_$Inter_logit_Learn),c(0.025,0.975))[[2]],3)
    
    Slope_boot[id] <- round(mean(na.omit(tab_reduiteParApprentissage_$Slope_logit_Learn)),3)
    Slope_boot_IC95inf[id] <- round(quantile(na.omit(tab_reduiteParApprentissage_$Slope_logit_Learn),c(0.025,0.975))[[1]],3)
    Slope_boot_IC95sup[id] <- round(quantile(na.omit(tab_reduiteParApprentissage_$Slope_logit_Learn),c(0.025,0.975))[[2]],3)
    
    ### Erreur ###
    RMSE_boot[id] <- round(mean(na.omit(RMSE_tmp)),3)
    RMSE_boot_IC95inf[id] <- round(quantile(na.omit(RMSE_tmp),c(0.025,0.975))[[1]],3)
    RMSE_boot_IC95sup[id] <- round(quantile(na.omit(RMSE_tmp),c(0.025,0.975))[[2]],3)
    
    Biais_boot[id] <- round(mean(na.omit(Biais_tmp)),5) #,3)
    Biais_boot_IC95inf[id] <- round(quantile(na.omit(Biais_tmp),c(0.025,0.975))[[1]],5) #,3)
    Biais_boot_IC95sup[id] <- round(quantile(na.omit(Biais_tmp),c(0.025,0.975))[[2]],5) #,3)
    
    ErreurMoyenneAbsolue_boot[id] <- round(mean(na.omit(ErreurMoyenneAbsolue_tmp)),3)
    ErreurMoyenneAbsolue_boot_IC95inf[id] <- round(quantile(na.omit(ErreurMoyenneAbsolue_tmp),c(0.025,0.975))[[1]],3)
    ErreurMoyenneAbsolue_boot_IC95sup[id] <- round(quantile(na.omit(ErreurMoyenneAbsolue_tmp),c(0.025,0.975))[[2]],3)
    
    RMSE_3maxApred_boot[id] <- round(mean(na.omit(RMSE_3maxApred_tmp)),3)
    RMSE_3maxApred_boot_IC95inf[id] <- round(quantile(na.omit(RMSE_3maxApred_tmp),c(0.025,0.975))[[1]],3)
    RMSE_3maxApred_boot_IC95sup[id] <- round(quantile(na.omit(RMSE_3maxApred_tmp),c(0.025,0.975))[[2]],3)
    
    Biais_3maxApred_boot[id] <- round(mean(na.omit(Biais_3maxApred_tmp)),5) #,3)
    Biais_3maxApred_boot_IC95inf[id] <- round(quantile(na.omit(Biais_3maxApred_tmp),c(0.025,0.975))[[1]],5) #,3)
    Biais_3maxApred_boot_IC95sup[id] <- round(quantile(na.omit(Biais_3maxApred_tmp),c(0.025,0.975))[[2]],5) #,3)
    
    ErreurMoyenneAbsolue_3maxApred_boot[id] <- round(mean(na.omit(ErreurMoyenneAbsolue_3maxApred_tmp)),3)
    ErreurMoyenneAbsolue_3maxApred_boot_IC95inf[id] <- round(quantile(na.omit(ErreurMoyenneAbsolue_3maxApred_tmp),c(0.025,0.975))[[1]],3)
    ErreurMoyenneAbsolue_3maxApred_boot_IC95sup[id] <- round(quantile(na.omit(ErreurMoyenneAbsolue_3maxApred_tmp),c(0.025,0.975))[[2]],3)
    
    RMSE_mai_boot[id] <- round(mean(na.omit(RMSE_mai_tmp)),3)
    RMSE_mai_boot_IC95inf[id] <- round(quantile(na.omit(RMSE_mai_tmp),c(0.025,0.975))[[1]],3)
    RMSE_mai_boot_IC95sup[id] <- round(quantile(na.omit(RMSE_mai_tmp),c(0.025,0.975))[[2]],3)
    
    Biais_mai_boot[id] <- round(mean(na.omit(Biais_mai_tmp)),5) #,3)
    Biais_mai_boot_IC95inf[id] <- round(quantile(na.omit(Biais_mai_tmp),c(0.025,0.975))[[1]],5) #,3)
    Biais_mai_boot_IC95sup[id] <- round(quantile(na.omit(Biais_mai_tmp),c(0.025,0.975))[[2]],5) #,3)
    
    ErreurMoyenneAbsolue_mai_boot[id] <- round(mean(na.omit(ErreurMoyenneAbsolue_mai_tmp)),3)
    ErreurMoyenneAbsolue_mai_boot_IC95inf[id] <- round(quantile(na.omit(ErreurMoyenneAbsolue_mai_tmp),c(0.025,0.975))[[1]],3)
    ErreurMoyenneAbsolue_mai_boot_IC95sup[id] <- round(quantile(na.omit(ErreurMoyenneAbsolue_mai_tmp),c(0.025,0.975))[[2]],3)
    
    RMSE_juin_boot[id] <- round(mean(na.omit(RMSE_juin_tmp)),3)
    RMSE_juin_boot_IC95inf[id] <- round(quantile(na.omit(RMSE_juin_tmp),c(0.025,0.975))[[1]],3)
    RMSE_juin_boot_IC95sup[id] <- round(quantile(na.omit(RMSE_juin_tmp),c(0.025,0.975))[[2]],3)
    
    Biais_juin_boot[id] <- round(mean(na.omit(Biais_juin_tmp)),5) #,3)
    Biais_juin_boot_IC95inf[id] <- round(quantile(na.omit(Biais_juin_tmp),c(0.025,0.975))[[1]],5) #,3)
    Biais_juin_boot_IC95sup[id] <- round(quantile(na.omit(Biais_juin_tmp),c(0.025,0.975))[[2]],5) #,3)
    
    ErreurMoyenneAbsolue_juin_boot[id] <- round(mean(na.omit(ErreurMoyenneAbsolue_juin_tmp)),3)
    ErreurMoyenneAbsolue_juin_boot_IC95inf[id] <- round(quantile(na.omit(ErreurMoyenneAbsolue_juin_tmp),c(0.025,0.975))[[1]],3)
    ErreurMoyenneAbsolue_juin_boot_IC95sup[id] <- round(quantile(na.omit(ErreurMoyenneAbsolue_juin_tmp),c(0.025,0.975))[[2]],3)
    
    RMSE_juillet_boot[id] <- round(mean(na.omit(RMSE_juillet_tmp)),3)
    RMSE_juillet_boot_IC95inf[id] <- round(quantile(na.omit(RMSE_juillet_tmp),c(0.025,0.975))[[1]],3)
    RMSE_juillet_boot_IC95sup[id] <- round(quantile(na.omit(RMSE_juillet_tmp),c(0.025,0.975))[[2]],3)
    
    Biais_juillet_boot[id] <- round(mean(na.omit(Biais_juillet_tmp)),5) #,3)
    Biais_juillet_boot_IC95inf[id] <- round(quantile(na.omit(Biais_juillet_tmp),c(0.025,0.975))[[1]],5) #,3)
    Biais_juillet_boot_IC95sup[id] <- round(quantile(na.omit(Biais_juillet_tmp),c(0.025,0.975))[[2]],5) #,3)
    
    ErreurMoyenneAbsolue_juillet_boot[id] <- round(mean(na.omit(ErreurMoyenneAbsolue_juillet_tmp)),3)
    ErreurMoyenneAbsolue_juillet_boot_IC95inf[id] <- round(quantile(na.omit(ErreurMoyenneAbsolue_juillet_tmp),c(0.025,0.975))[[1]],3)
    ErreurMoyenneAbsolue_juillet_boot_IC95sup[id] <- round(quantile(na.omit(ErreurMoyenneAbsolue_juillet_tmp),c(0.025,0.975))[[2]],3)

    RMSE_aout_boot[id] <- round(mean(na.omit(RMSE_aout_tmp)),3)
    RMSE_aout_boot_IC95inf[id] <- round(quantile(na.omit(RMSE_aout_tmp),c(0.025,0.975))[[1]],3)
    RMSE_aout_boot_IC95sup[id] <- round(quantile(na.omit(RMSE_aout_tmp),c(0.025,0.975))[[2]],3)
    
    Biais_aout_boot[id] <- round(mean(na.omit(Biais_aout_tmp)),5) #,3)
    Biais_aout_boot_IC95inf[id] <- round(quantile(na.omit(Biais_aout_tmp),c(0.025,0.975))[[1]],5) #,3)
    Biais_aout_boot_IC95sup[id] <- round(quantile(na.omit(Biais_aout_tmp),c(0.025,0.975))[[2]],5) #,3)
    
    ErreurMoyenneAbsolue_aout_boot[id] <- round(mean(na.omit(ErreurMoyenneAbsolue_aout_tmp)),3)
    ErreurMoyenneAbsolue_aout_boot_IC95inf[id] <- round(quantile(na.omit(ErreurMoyenneAbsolue_aout_tmp),c(0.025,0.975))[[1]],3)
    ErreurMoyenneAbsolue_aout_boot_IC95sup[id] <- round(quantile(na.omit(ErreurMoyenneAbsolue_aout_tmp),c(0.025,0.975))[[2]],3)

    RMSE_septembre_boot[id] <- round(mean(na.omit(RMSE_septembre_tmp)),3)
    RMSE_septembre_boot_IC95inf[id] <- round(quantile(na.omit(RMSE_septembre_tmp),c(0.025,0.975))[[1]],3)
    RMSE_septembre_boot_IC95sup[id] <- round(quantile(na.omit(RMSE_septembre_tmp),c(0.025,0.975))[[2]],3)
    
    Biais_septembre_boot[id] <- round(mean(na.omit(Biais_septembre_tmp)),5) #,3)
    Biais_septembre_boot_IC95inf[id] <- round(quantile(na.omit(Biais_septembre_tmp),c(0.025,0.975))[[1]],5) #,3)
    Biais_septembre_boot_IC95sup[id] <- round(quantile(na.omit(Biais_septembre_tmp),c(0.025,0.975))[[2]],5) #,3)
    
    ErreurMoyenneAbsolue_septembre_boot[id] <- round(mean(na.omit(ErreurMoyenneAbsolue_septembre_tmp)),3)
    ErreurMoyenneAbsolue_septembre_boot_IC95inf[id] <- round(quantile(na.omit(ErreurMoyenneAbsolue_septembre_tmp),c(0.025,0.975))[[1]],3)
    ErreurMoyenneAbsolue_septembre_boot_IC95sup[id] <- round(quantile(na.omit(ErreurMoyenneAbsolue_septembre_tmp),c(0.025,0.975))[[2]],3)
    
    
    ### Version sans IC ###
    tab_test = onde[select,]
    y <- tab_test$ProbaAssec_HERMoisAnnee_Apredire_CValid
    y_pred <- tab_test$ProbaAssec_HERMoisAnnee_Predite_CValid
    moy_obs  <- mean(y_pred)
    
    ### Performance predictions ###
    P_assecs_HER_MoyenneGlobale_Predit_general[id] <- round(moy_obs*100,3)
    P_assecs_HER_MoyenneGlobale_Apredire_general[id] <- round(mean(y)*100,3)
    NASH_HER_AnneeValid_logit_CValid_general[id] <- round(1 - sum((y_pred-y)**2) / sum((moy_obs-y)**2),3)
    
    r <- cor(y,y_pred) #Coeff de correlation entre donnees observees et donnees predites
    beta <- mean(y_pred)/mean(y)
    alpha <- mean(y)/mean(y_pred)*sd(y_pred)/sd(y)
    KGE_HER_AnneeValid_logit_CValid_general[id] <- round(1-sqrt((1-r)**2+(1-beta)**2+(1-alpha)**2),3)
    CV_HER_AnneeValid_logit_CValid_general[id] <- round(sd(y)/moy_obs,3) ### INDICATEUR FAUX
    
    PropParameterDeviance_logit_Learn_general[id] <- round(mean(tab_test$PropParameterDeviance_logit_Learn),3)
    
    Intercept_general[id] <- round(mean(na.omit(tab_reduiteParApprentissage_$Inter_logit_Learn)),3)
    Slope_general[id] <- round(mean(na.omit(tab_reduiteParApprentissage_$Slope_logit_Learn)),3)
    RMSE_general[id] <- round(sqrt(1/length(y) * sum((y-y_pred)^2)),3)
    Biais_general[id] <- round(sum(y_pred-y)/length(y),5) #,3)
    ErreurMoyenneAbsolue_general[id] <- round(sum(abs(y_pred-y))/length(y),3)
    
    ### Sur les 5 valeurs les plus hautes de la Proba d'assec a predire ###
    tab_test_3val = tab_test[which(tab_test$ProbaAssec_HERMoisAnnee_Apredire_CValid %in% head(unique(sort(tab_test$ProbaAssec_HERMoisAnnee_Apredire_CValid, decreasing = T)),3)),]
    y <- tab_test_3val$ProbaAssec_HERMoisAnnee_Apredire_CValid
    y_pred <- tab_test_3val$ProbaAssec_HERMoisAnnee_Predite_CValid
    RMSE_3maxApred_general[id] <- round(sqrt(1/length(y) * sum((y-y_pred)^2)),3)
    Biais_3maxApred_general[id] <- round(sum(y_pred-y)/length(y),5) #,3)
    ErreurMoyenneAbsolue_3maxApred_general[id] <- round(sum(abs(y_pred-y))/length(y),3)
    
    ### Sur les valeurs de mai ###
    tab_test_mai = tab_test[which(months(as.Date(tab_test$Date)) == "mai"),]
    y <- tab_test_mai$ProbaAssec_HERMoisAnnee_Apredire_CValid
    y_pred <- tab_test_mai$ProbaAssec_HERMoisAnnee_Predite_CValid
    RMSE_mai_general[id] <- round(sqrt(1/length(y) * sum((y-y_pred)^2)),3)
    Biais_mai_general[id] <- round(sum(y_pred-y)/length(y),5) #,3)
    ErreurMoyenneAbsolue_mai_general[id] <- round(sum(abs(y_pred-y))/length(y),3)
    
    ### Sur les valeurs de juin ###
    tab_test_juin = tab_test[which(months(as.Date(tab_test$Date)) == "juin"),]
    y <- tab_test_juin$ProbaAssec_HERMoisAnnee_Apredire_CValid
    y_pred <- tab_test_juin$ProbaAssec_HERMoisAnnee_Predite_CValid
    RMSE_juin_general[id] <- round(sqrt(1/length(y) * sum((y-y_pred)^2)),3)
    Biais_juin_general[id] <- round(sum(y_pred-y)/length(y),5) #,3)
    ErreurMoyenneAbsolue_juin_general[id] <- round(sum(abs(y_pred-y))/length(y),3)
    
    ### Sur les valeurs de juillet ###
    tab_test_juillet = tab_test[which(months(as.Date(tab_test$Date)) == "juillet"),]
    y <- tab_test_juillet$ProbaAssec_HERMoisAnnee_Apredire_CValid
    y_pred <- tab_test_juillet$ProbaAssec_HERMoisAnnee_Predite_CValid
    RMSE_juillet_general[id] <- round(sqrt(1/length(y) * sum((y-y_pred)^2)),3)
    Biais_juillet_general[id] <- round(sum(y_pred-y)/length(y),5) #,3)
    ErreurMoyenneAbsolue_juillet_general[id] <- round(sum(abs(y_pred-y))/length(y),3)
    
    ### Sur les valeurs de aout ###
    tab_test_aout = tab_test[which(months(as.Date(tab_test$Date)) == "août"),]
    y <- tab_test_aout$ProbaAssec_HERMoisAnnee_Apredire_CValid
    y_pred <- tab_test_aout$ProbaAssec_HERMoisAnnee_Predite_CValid
    RMSE_aout_general[id] <- round(sqrt(1/length(y) * sum((y-y_pred)^2)),3)
    Biais_aout_general[id] <- round(sum(y_pred-y)/length(y),5) #,3)
    ErreurMoyenneAbsolue_aout_general[id] <- round(sum(abs(y_pred-y))/length(y),3)
    
    ### Sur les valeurs de septembre ###
    tab_test_septembre = tab_test[which(months(as.Date(tab_test$Date)) == "septembre"),]
    y <- tab_test_septembre$ProbaAssec_HERMoisAnnee_Apredire_CValid
    y_pred <- tab_test_septembre$ProbaAssec_HERMoisAnnee_Predite_CValid
    RMSE_septembre_general[id] <- round(sqrt(1/length(y) * sum((y-y_pred)^2)),3)
    Biais_septembre_general[id] <- round(sum(y_pred-y)/length(y),5) #,3)
    ErreurMoyenneAbsolue_septembre_general[id] <- round(sum(abs(y_pred-y))/length(y),3)
    
    ### Sur les valeurs max de l'annee ###
    tab_maxByYear <- tab_test %>% 
      mutate(Annee = lubridate::year(Date)) %>%
      group_by(Annee) %>%
      filter(ProbaAssec_HERMoisAnnee_Apredire_CValid == max(ProbaAssec_HERMoisAnnee_Apredire_CValid))
    y <- tab_maxByYear$ProbaAssec_HERMoisAnnee_Apredire_CValid
    y_pred <- tab_maxByYear$ProbaAssec_HERMoisAnnee_Predite_CValid
    RMSE_maxAnnees_general[id] <- round(sqrt(1/length(y) * sum((y-y_pred)^2)),3)
    Biais_maxAnnees_general[id] <- round(sum(y_pred-y)/length(y),5) #,3)
    ErreurMoyenneAbsolue_maxAnnees_general[id] <- round(sum(abs(y_pred-y))/length(y),3)
    
    
  }
  
  ### Order columns ###
  # output <- output[,!(grepl("Freq|X._Assec",colnames(output)))]
  output <- data.frame(HER = liste_Her,
                       
                       P_assecs_HER_MoyenneGlobale_Predit_general = P_assecs_HER_MoyenneGlobale_Predit_general,
                       P_assecs_HER_MoyenneGlobale_Predit_boot = P_assecs_HER_MoyenneGlobale_Predit_boot,
                       P_assecs_HER_MoyenneGlobale_Predit_boot_IC95inf = P_assecs_HER_MoyenneGlobale_Predit_boot_IC95inf,
                       P_assecs_HER_MoyenneGlobale_Predit_boot_IC95sup = P_assecs_HER_MoyenneGlobale_Predit_boot_IC95sup,
                       
                       P_assecs_HER_MoyenneGlobale_Apredire_general = P_assecs_HER_MoyenneGlobale_Apredire_general,
                       P_assecs_HER_MoyenneGlobale_Apredire_boot = P_assecs_HER_MoyenneGlobale_Apredire_boot,
                       P_assecs_HER_MoyenneGlobale_Apredire_boot_IC95inf = P_assecs_HER_MoyenneGlobale_Apredire_boot_IC95inf,
                       P_assecs_HER_MoyenneGlobale_Apredire_boot_IC95sup = P_assecs_HER_MoyenneGlobale_Apredire_boot_IC95sup,
                       
                       NASH_HER_AnneeValid_logit_CValid_general = NASH_HER_AnneeValid_logit_CValid_general,
                       NASH_HER_AnneeValid_logit_CValid_boot = NASH_HER_AnneeValid_logit_CValid_boot,
                       NASH_HER_AnneeValid_logit_CValid_boot_IC95inf = NASH_HER_AnneeValid_logit_CValid_boot_IC95inf,
                       NASH_HER_AnneeValid_logit_CValid_boot_IC95sup = NASH_HER_AnneeValid_logit_CValid_boot_IC95sup,
                       
                       KGE_HER_AnneeValid_logit_CValid_general = KGE_HER_AnneeValid_logit_CValid_general,
                       KGE_HER_AnneeValid_logit_CValid_boot = KGE_HER_AnneeValid_logit_CValid_boot,
                       KGE_HER_AnneeValid_logit_CValid_boot_IC95inf = KGE_HER_AnneeValid_logit_CValid_boot_IC95inf,
                       KGE_HER_AnneeValid_logit_CValid_boot_IC95sup = KGE_HER_AnneeValid_logit_CValid_boot_IC95sup,
                       
                       CV_HER_AnneeValid_logit_CValid_general = CV_HER_AnneeValid_logit_CValid_general,
                       CV_HER_AnneeValid_logit_CValid_boot = CV_HER_AnneeValid_logit_CValid_boot,
                       CV_HER_AnneeValid_logit_CValid_boot_IC95inf = CV_HER_AnneeValid_logit_CValid_boot_IC95inf,
                       CV_HER_AnneeValid_logit_CValid_boot_IC95sup = CV_HER_AnneeValid_logit_CValid_boot_IC95sup,
                       
                       PropParameterDeviance_logit_Learn_general = PropParameterDeviance_logit_Learn_general,
                       PropParameterDeviance_logit_Learn_boot = PropParameterDeviance_logit_Learn_boot,
                       PropParameterDeviance_logit_Learn_boot_IC95inf = PropParameterDeviance_logit_Learn_boot_IC95inf,
                       PropParameterDeviance_logit_Learn_boot_IC95sup = PropParameterDeviance_logit_Learn_boot_IC95sup,
                       
                       Intercept_general = Intercept_general,
                       Intercept_boot = Intercept_boot,
                       Intercept_boot_IC95inf = Intercept_boot_IC95inf,
                       Intercept_boot_IC95sup = Intercept_boot_IC95sup,
                       
                       Slope_general = Slope_general,
                       Slope_boot = Slope_boot,
                       Slope_boot_IC95inf = Slope_boot_IC95inf,
                       Slope_boot_IC95sup = Slope_boot_IC95sup,
                       
                       RMSE_general = RMSE_general,
                       RMSE_boot = RMSE_boot,
                       RMSE_boot_IC95inf = RMSE_boot_IC95inf,
                       RMSE_boot_IC95sup = RMSE_boot_IC95sup,
                       
                       Biais_general = Biais_general,
                       Biais_boot = Biais_boot,
                       Biais_boot_IC95inf = Biais_boot_IC95inf,
                       Biais_boot_IC95sup = Biais_boot_IC95sup,
                       
                       ErreurMoyenneAbsolue_general = ErreurMoyenneAbsolue_general,
                       ErreurMoyenneAbsolue_boot = ErreurMoyenneAbsolue_boot,
                       ErreurMoyenneAbsolue_boot_IC95inf = ErreurMoyenneAbsolue_boot_IC95inf,
                       ErreurMoyenneAbsolue_boot_IC95sup = ErreurMoyenneAbsolue_boot_IC95sup,
                       
                       ### 3 valeurs max ###
                       RMSE_3maxApred_general = RMSE_3maxApred_general,
                       RMSE_3maxApred_boot = RMSE_3maxApred_boot,
                       RMSE_3maxApred_boot_IC95inf = RMSE_3maxApred_boot_IC95inf,
                       RMSE_3maxApred_boot_IC95sup = RMSE_3maxApred_boot_IC95sup,
                       
                       Biais_3maxApred_general = Biais_3maxApred_general,
                       Biais_3maxApred_boot = Biais_3maxApred_boot,
                       Biais_3maxApred_boot_IC95inf = Biais_3maxApred_boot_IC95inf,
                       Biais_3maxApred_boot_IC95sup = Biais_3maxApred_boot_IC95sup,
                       
                       ErreurMoyenneAbsolue_3maxApred_general = ErreurMoyenneAbsolue_3maxApred_general,
                       ErreurMoyenneAbsolue_3maxApred_boot = ErreurMoyenneAbsolue_3maxApred_boot,
                       ErreurMoyenneAbsolue_3maxApred_boot_IC95inf = ErreurMoyenneAbsolue_3maxApred_boot_IC95inf,
                       ErreurMoyenneAbsolue_3maxApred_boot_IC95sup = ErreurMoyenneAbsolue_3maxApred_boot_IC95sup,
                       
                       ### Par mois ###
                       RMSE_mai_general = RMSE_mai_general,
                       RMSE_mai_boot = RMSE_mai_boot,
                       RMSE_mai_boot_IC95inf = RMSE_mai_boot_IC95inf,
                       RMSE_mai_boot_IC95sup = RMSE_mai_boot_IC95sup,
                       
                       Biais_mai_general = Biais_mai_general,
                       Biais_mai_boot = Biais_mai_boot,
                       Biais_mai_boot_IC95inf = Biais_mai_boot_IC95inf,
                       Biais_mai_boot_IC95sup = Biais_mai_boot_IC95sup,
                       
                       ErreurMoyenneAbsolue_mai_general = ErreurMoyenneAbsolue_mai_general,
                       ErreurMoyenneAbsolue_mai_boot = ErreurMoyenneAbsolue_mai_boot,
                       ErreurMoyenneAbsolue_mai_boot_IC95inf = ErreurMoyenneAbsolue_mai_boot_IC95inf,
                       ErreurMoyenneAbsolue_mai_boot_IC95sup = ErreurMoyenneAbsolue_mai_boot_IC95sup,
                       
                       RMSE_juin_general = RMSE_juin_general,
                       RMSE_juin_boot = RMSE_juin_boot,
                       RMSE_juin_boot_IC95inf = RMSE_juin_boot_IC95inf,
                       RMSE_juin_boot_IC95sup = RMSE_juin_boot_IC95sup,
                       
                       Biais_juin_general = Biais_juin_general,
                       Biais_juin_boot = Biais_juin_boot,
                       Biais_juin_boot_IC95inf = Biais_juin_boot_IC95inf,
                       Biais_juin_boot_IC95sup = Biais_juin_boot_IC95sup,
                       
                       ErreurMoyenneAbsolue_juin_general = ErreurMoyenneAbsolue_juin_general,
                       ErreurMoyenneAbsolue_juin_boot = ErreurMoyenneAbsolue_juin_boot,
                       ErreurMoyenneAbsolue_juin_boot_IC95inf = ErreurMoyenneAbsolue_juin_boot_IC95inf,
                       ErreurMoyenneAbsolue_juin_boot_IC95sup = ErreurMoyenneAbsolue_juin_boot_IC95sup,
                       
                       RMSE_juillet_general = RMSE_juillet_general,
                       RMSE_juillet_boot = RMSE_juillet_boot,
                       RMSE_juillet_boot_IC95inf = RMSE_juillet_boot_IC95inf,
                       RMSE_juillet_boot_IC95sup = RMSE_juillet_boot_IC95sup,
                       
                       Biais_juillet_general = Biais_juillet_general,
                       Biais_juillet_boot = Biais_juillet_boot,
                       Biais_juillet_boot_IC95inf = Biais_juillet_boot_IC95inf,
                       Biais_juillet_boot_IC95sup = Biais_juillet_boot_IC95sup,
                       
                       ErreurMoyenneAbsolue_juillet_general = ErreurMoyenneAbsolue_juillet_general,
                       ErreurMoyenneAbsolue_juillet_boot = ErreurMoyenneAbsolue_juillet_boot,
                       ErreurMoyenneAbsolue_juillet_boot_IC95inf = ErreurMoyenneAbsolue_juillet_boot_IC95inf,
                       ErreurMoyenneAbsolue_juillet_boot_IC95sup = ErreurMoyenneAbsolue_juillet_boot_IC95sup,
                       
                       RMSE_aout_general = RMSE_aout_general,
                       RMSE_aout_boot = RMSE_aout_boot,
                       RMSE_aout_boot_IC95inf = RMSE_aout_boot_IC95inf,
                       RMSE_aout_boot_IC95sup = RMSE_aout_boot_IC95sup,
                       
                       Biais_aout_general = Biais_aout_general,
                       Biais_aout_boot = Biais_aout_boot,
                       Biais_aout_boot_IC95inf = Biais_aout_boot_IC95inf,
                       Biais_aout_boot_IC95sup = Biais_aout_boot_IC95sup,
                       
                       ErreurMoyenneAbsolue_aout_general = ErreurMoyenneAbsolue_aout_general,
                       ErreurMoyenneAbsolue_aout_boot = ErreurMoyenneAbsolue_aout_boot,
                       ErreurMoyenneAbsolue_aout_boot_IC95inf = ErreurMoyenneAbsolue_aout_boot_IC95inf,
                       ErreurMoyenneAbsolue_aout_boot_IC95sup = ErreurMoyenneAbsolue_aout_boot_IC95sup,
                       
                       RMSE_septembre_general = RMSE_septembre_general,
                       RMSE_septembre_boot = RMSE_septembre_boot,
                       RMSE_septembre_boot_IC95inf = RMSE_septembre_boot_IC95inf,
                       RMSE_septembre_boot_IC95sup = RMSE_septembre_boot_IC95sup,
                       
                       Biais_septembre_general = Biais_septembre_general,
                       Biais_septembre_boot = Biais_septembre_boot,
                       Biais_septembre_boot_IC95inf = Biais_septembre_boot_IC95inf,
                       Biais_septembre_boot_IC95sup = Biais_septembre_boot_IC95sup,
                       
                       ErreurMoyenneAbsolue_septembre_general = ErreurMoyenneAbsolue_septembre_general,
                       ErreurMoyenneAbsolue_septembre_boot = ErreurMoyenneAbsolue_septembre_boot,
                       ErreurMoyenneAbsolue_septembre_boot_IC95inf = ErreurMoyenneAbsolue_septembre_boot_IC95inf,
                       ErreurMoyenneAbsolue_septembre_boot_IC95sup = ErreurMoyenneAbsolue_septembre_boot_IC95sup,
                       
                       RMSE_maxAnnees_general = RMSE_maxAnnees_general,
                       Biais_maxAnnees_general = Biais_maxAnnees_general,
                       ErreurMoyenneAbsolue_maxAnnees_general = ErreurMoyenneAbsolue_maxAnnees_general)
  
  
  
  return(output)
} 

