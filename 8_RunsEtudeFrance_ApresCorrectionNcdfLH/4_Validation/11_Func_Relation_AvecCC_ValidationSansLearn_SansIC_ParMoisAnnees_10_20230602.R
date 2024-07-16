#-------------------------------------------------------------------------------
# Fonction FUNC_CAL_VAL() qui permet de faire un calage et une validation crois? des r?sultats 

# Bottet Quentin - Irstea - 18/09/2019 - Version 1
#-------------------------------------------------------------------------------

FUNC_CAL_VAL_ValidationSansLearn_SansIC_ParDate <- function(annee,Matrice_comp,liste_Her,regression,tab_Reg_,jourMin_,jourMax_){
  
  if (is.numeric(annee) & nchar(annee) == 4){onde = Matrice_comp[which(substr(Matrice_comp[,c("Date")],7,10)!= annee),]
  }else if(is.numeric(annee) & nchar(annee) != 4){onde = Matrice_comp[which(substr(Matrice_comp[,c("Date")],5,5)!= annee),]
  }else{onde = Matrice_comp}
  # output=data.frame()
  compt=0
  compte=0
  
  output <- Matrice_comp[,c("HER2","Date",
                            "NbInputStationsHydroUtilisees",
                            "NbInputStationsHydroDispos",
                            "NbEnregistrementsHydroNA")]
  
  ### Annees Learn ###
  output$AnneesLearn <- NA
  output$UtiliseEnApprentissage <- NA
  
  ### Modeles ###
  output$Inter_logit_Learn <- NA
  output$Inter_pv_logit_Learn <- NA
  output$Slope_logit_Learn <- NA
  output$Slope_pv_logit_Learn <- NA
  
  ### Indicateurs apprentissage ###
  output$TotalDeviance_logit_Learn <- NA
  output$ParameterDeviance_logit_Learn <- NA
  output$PropParameterDeviance_logit_Learn <- NA
  
  ### Output a predire Learn ###
  output$P_assecs_HER_MoyenMois_Apredire_Learn <- NA
  
  ### Performances predictions Learn ###
  output$NASH_logit_Learn <- NA
  output$KGE_logit_Learn <- NA
  output$CV_logit_Learn <- NA
  
  ### Output a predire Cross Validation ###
  output$NbStationsObservesONDE_CValid <- NA # Nombre d'observations
  output$NbAssecsObservesONDE_CValid <- NA #Nombre d'observations d'assecs
  output$P_assecs_HER_Apredire_CValid <- NA #Proba assec a predire

  ### Input FDC ###
  output$FDC <- NA
  
  ### Output y ###
  output$ProbaAssec_HERMoisAnnee_Apredire_CValid <- NA
  output$ProbaAssec_HERMoisAnnee_Predite_CValid <- NA
  
  ### Performance predictions ###
  output$NASH_HER_AnneeValid_logit_CValid <- NA
  output$KGE_HER_AnneeValid_logit_CValid <- NA
  output$CV_HER_AnneeValid_logit_CValid <- NA

  for (id in 1:length(liste_Her)) {
    # print(id)
    Reg = tab_Reg_[which(tab_Reg_$HER == liste_Her[id]),]
    
    select <- which(onde[,1]==liste_Her[id])

    ### Pas de selection en validation ###
    # select <- select[which(onde$NbOutputONDE[select] > round(0.75*max(onde$NbOutputONDE[select])))]
    
    if(!is.na(onde[select[1],4])){
      compt=compt+1
      data_x <- vector()
      
      for (ligne in 1:length(select)){
        # On prend les valeurs entre obs au jour j et j-5 car donne la meilleure performance (cf Beaufort et al 2018)
        
        #data_x[ligne]=mean(as.numeric(onde[select[ligne], (10:15)])) #mean(as.numeric(onde[select[select2[ligne]],5:9]))
        
        # if (jourMax_ == 0){
        #   data_x[ligne]=mean(as.numeric(onde[select[ligne], c(paste0("Freq_jmoins",jourMin_:1),"Freq_j")])) #mean(as.numeric(onde[select[select2[ligne]],5:9]))
        # }else{
        #   data_x[ligne]=mean(as.numeric(onde[select[ligne], c(paste0("Freq_jmoins",jourMin_:jourMax_))])) #mean(as.numeric(onde[select[select2[ligne]],5:9]))
        # }
        
        data_x[ligne]=as.numeric(onde$Freq_Jm6Jj[select[ligne]])

        if(!is.na(data_x[ligne])){
          if(data_x[ligne]==0){
            data_x[ligne]=0.00001
          }
        }
      }
      
      data_y=as.numeric(onde[select,3]) # Donnees assec a predire
      
      x=data_x[data_x >= 0 & !is.na(data_x) & !is.na(data_y)]
      y=data_y[data_x >= 0 & !is.na(data_x) & !is.na(data_y)]
      
      # if (sum(y)!=0 & length(unique(y))>2){ # Precaution utile a l'apprentissage uniquement
      # if (sum(y)!=0){
        if(regression == "lin"){
          y_pred=(Reg$Slope_logit*x+Reg$Inter_logit)
          # seuillage des pr?dictions entre 0 et 100
          for (l in 1:length(y_pred)){
            y_pred[l]=min(max(y_pred[l],0),100)
          }
          y = y / 100
        }
        if(regression == "log"){
          y_pred=(Reg$Slope_logit*log(x)+Reg$Inter_logit)
          
          for (l2 in 1:length(y_pred)){
            y_pred[l2] = min(max(y_pred[l2],0),100)
          }
          y = y / 100
        }
        if(regression == "logit"){
          y = y / 100
          y_pred = (exp(Reg$Slope_logit*x+Reg$Inter_logit)/(1+exp(Reg$Slope_logit*x+Reg$Inter_logit)))*100
        }

        ### Dates apprentissage ###
        output$AnneesLearn[select] <- Reg$AnneesLearn
        output$UtiliseEnApprentissage[select] <- onde[select,"UtiliseEnApprentissage"]

        ### Modeles ###
        output$Inter_logit_Learn[select] <- Reg$Inter_logit_Learn
        output$Inter_pv_logit_Learn[select] <- Reg$Inter_pv_logit_Learn
        output$Slope_logit_Learn[select] <- Reg$Slope_logit_Learn
        output$Slope_pv_logit_Learn[select] <- Reg$Slope_pv_logit_Learn
        
        ### Indicateurs apprentissage ###
        output$TotalDeviance_logit_Learn[select] <- Reg$TotalDeviance_logit_Learn
        output$ParameterDeviance_logit_Learn[select] <- Reg$ParameterDeviance_logit_Learn
        output$PropParameterDeviance_logit_Learn[select] <- Reg$PropParameterDeviance_logit_Learn
        
        ### Output a predire Learn ###
        output$P_assecs_HER_MoyenMois_Apredire_Learn[select] <- Reg$P_assecs_HER_MoyenMois_Apredire_Learn
        
        ### Performances predictions Learn ###
        output$NASH_logit_Learn[select] <- Reg$NASH_logit_Learn
        output$KGE_logit_Learn[select] <- Reg$KGE_logit_Learn
        output$CV_logit_Learn[select] <- Reg$CV_logit_Learn
        
        ### Output a predire Cross Validation ###
        output$NbStationsObservesONDE_CValid[select] = onde[select,"NbOutputONDE"] # Nombre d'observations
        output$NbAssecsObservesONDE_CValid[select] = onde[select,"NbOutputONDEAssecs"] #Nombre d'observations d'assecs
        output$P_assecs_HER_Apredire_CValid[select] = onde[select,"NbOutputONDEAssecs"]/onde[select,"NbOutputONDE"] #Proba assec a predire
        moy_obs <- onde[select,"NbOutputONDEAssecs"]/onde[select,"NbOutputONDE"]
        
        ### Input FDC ###
        output$FDC[select] <- x
        
        ### Output y ###
        output$ProbaAssec_HERMoisAnnee_Apredire_CValid[select] <- y
        output$ProbaAssec_HERMoisAnnee_Predite_CValid[select] <- y_pred/100

        ### Performance predictions ###
        output$NASH_HER_AnneeValid_logit_CValid[select] <- 1 - sum((y_pred-(y*100))**2) / sum((moy_obs-(y*100))**2)
        
        r <- cor(y*100,y_pred) #Coeff de correlation entre donnees observees et donnees predites
        beta <- mean(y_pred)/mean(y*100)
        alpha <- mean(y*100)/mean(y_pred)*sd(y_pred)/sd(y*100)
        output$KGE_HER_AnneeValid_logit_CValid[select] <- 1-sqrt((1-r)**2+(1-beta)**2+(1-alpha)**2)
        output$CV_HER_AnneeValid_logit_CValid[select] <- sd(y)/moy_obs ### INDICATEUR FAUX

      # } else {
      #   
      #   ### Dates apprentissage ###
      #   output$AnneesLearn[select] <- Reg$AnneesLearn
      #   
      #   ### Modeles ###
      #   output$Inter_logit_Learn[select] <- Reg$Inter_logit_Learn
      #   output$Inter_pv_logit_Learn[select] <- Reg$Inter_pv_logit_Learn
      #   output$Slope_logit_Learn[select] <- Reg$Slope_logit_Learn
      #   output$Slope_pv_logit_Learn[select] <- Reg$Slope_pv_logit_Learn
      #   
      #   ### Indicateurs apprentissage ###
      #   output$TotalDeviance_logit_Learn[select] <- Reg$TotalDeviance_logit_Learn
      #   output$ParameterDeviance_logit_Learn[select] <- Reg$ParameterDeviance_logit_Learn
      #   output$PropParameterDeviance_logit_Learn[select] <- Reg$PropParameterDeviance_logit_Learn
      #   
      #   ### Output a predire Learn ###
      #   output$P_assecs_HER_MoyenMois_Apredire_Learn[select] <- Reg$P_assecs_HER_MoyenMois_Apredire_Learn
      #   
      #   ### Performances predictions Learn ###
      #   output$NASH_logit_Learn[select] <- Reg$NASH_logit_Learn
      #   output$KGE_logit_Learn[select] <- Reg$KGE_logit_Learn
      #   output$CV_logit_Learn[select] <- Reg$CV_logit_Learn
      #   
      #   ### Output a predire Cross Validation ###
      #   output$NbStationsObservesONDE_CValid[select] = onde[select,"NbOutputONDE"] # Nombre d'observations
      #   output$NbAssecsObservesONDE_CValid[select] = onde[select,"NbOutputONDEAssecs"] #Nombre d'observations d'assecs
      #   output$P_assecs_HER_Apredire_CValid[select] = onde[select,"NbOutputONDEAssecs"]/onde[select,"NbOutputONDE"] #Proba assec a predire
      #   moy_obs <- onde[select,"NbOutputONDEAssecs"]/onde[select,"NbOutputONDE"]
      #   
      #   ### Input FDC ###
      #   output$FDC[select] <- x
      #   
      #   ### Output y ###
      #   output$ProbaAssec_HERMoisAnnee_Apredire_CValid[select] <- y
      #   output$ProbaAssec_HERMoisAnnee_Predite_CValid[select] <- NA
      #   
      #   ### Performance predictions ###
      #   output$NASH_HER_AnneeValid_logit_CValid[select] <- NA
      #   output$KGE_HER_AnneeValid_logit_CValid[select] <- NA
      #   output$CV_HER_AnneeValid_logit_CValid[select] <- NA
      # 
      # }
    }
  }
  
  ### Order columns ###
  # output <- output[,!(grepl("Freq|X._Assec",colnames(output)))]
  col_ <- c("HER2","Date",
            
            "AnneesLearn","UtiliseEnApprentissage",
            
            "NbInputStationsHydroUtilisees","NbInputStationsHydroDispos","NbEnregistrementsHydroNA",
            
            "Inter_logit_Learn","Inter_pv_logit_Learn",
            "Slope_logit_Learn","Slope_pv_logit_Learn",
            
            "TotalDeviance_logit_Learn","ParameterDeviance_logit_Learn","PropParameterDeviance_logit_Learn",
            
            "P_assecs_HER_MoyenMois_Apredire_Learn",
            "NASH_logit_Learn","KGE_logit_Learn","CV_logit_Learn",
            
            "NbStationsObservesONDE_CValid",
            "NbAssecsObservesONDE_CValid",
            "P_assecs_HER_Apredire_CValid",
            
            "FDC",
            "ProbaAssec_HERMoisAnnee_Apredire_CValid",
            "ProbaAssec_HERMoisAnnee_Predite_CValid",
            
            paste0("NASH_HER_AnneeValid_",regression,"_CValid"),
            paste0("KGE_HER_AnneeValid_",regression,"_CValid"),
            paste0("CV_HER_AnneeValid_",regression,"_CValid"))
  output <- output[col_]

  return(output)
} 
