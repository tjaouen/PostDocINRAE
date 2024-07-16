#-------------------------------------------------------------------------------
# Fonction FUNC_CAL_VAL() qui permet de faire un calage et une validation crois? des r?sultats 

# Bottet Quentin - Irstea - 18/09/2019 - Version 1
#-------------------------------------------------------------------------------

FUNC_CAL_VAL_ValidationSansLearn_SansIC <- function(annee,Matrice_comp,liste_Her,regression,tab_Reg_,jourMin_,jourMax_){
  
  if (is.numeric(annee) & nchar(annee) == 4){onde = Matrice_comp[which(substr(Matrice_comp[,c("Date")],7,10)!= annee),]
  }else if(is.numeric(annee) & nchar(annee) != 4){onde = Matrice_comp[which(substr(Matrice_comp[,c("Date")],5,5)!= annee),]
  }else{onde = Matrice_comp}
  output=data.frame()
  compt=0
  compte=0

  for (id in 1:length(liste_Her)) {
    
    print(liste_Her[id])
    
    Reg = tab_Reg_[which(tab_Reg_$HER == liste_Her[id]),]
    
    select <- which(onde[,1]==liste_Her[id])
    non_select_ <- length(which(!(onde$NbOutputONDE[select] > round(0.75*max(onde$NbOutputONDE[select])))))
    nb_select_ <- length(which(onde$NbOutputONDE[select] > round(0.75*max(onde$NbOutputONDE[select]))))
    select <- select[which(onde$NbOutputONDE[select] > round(0.75*max(onde$NbOutputONDE[select])))]
    
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
      
      #if (sum(y)!=0 & length(unique(y))>2){ # Precaution utile a l'apprentissage uniquement
      if (sum(y)!=0){
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
        
        ### HER ###
        output[compt,1] = liste_Her[id]

        ### Dates apprentissage ###
        output[compt,2] = Reg$AnneesLearn
        
        ### Modeles ###
        output[compt,3] = Reg$Inter_logit #Coefficient 1 de la regression
        output[compt,4] = Reg$Inter_pv_logit #Coefficient 1 de la regression
        output[compt,5] = Reg$Slope_logit #Coefficient 2 de la regression
        output[compt,6] = Reg$Slope_pv_logit #Coefficient 2 de la regression
        
        ### Indicateurs apprentissage ###
        output[compt,7] = Reg$TotalDeviance_logit_Learn
        output[compt,8] = Reg$ParameterDeviance_logit_Learn
        output[compt,9] = Reg$PropParameterDeviance_logit_Learn
        
        ### Proba moyenne assec en apprentissage ###
        output[compt,10] = Reg$P_assecs_HER_MoyenMois_Apredire_Learn
        
        output[compt,11] = Reg$NASH_logit_Learn
        output[compt,12] = Reg$KGE_logit_Learn
        output[compt,13] = Reg$CV_logit_Learn
        
        output[compt,14] = Reg$Indicatif_NbTotalObservationsONDE
        output[compt,15] = Reg$Indicatif_NbObservationsAssecsONDE
        output[compt,16] = Reg$Indicatif_ProportionTotaleAssecsObservationsONDE

        output[compt,17] = non_select_
        output[compt,18] = nb_select_
        output[compt,19] = non_select_/(non_select_+nb_select_)
        
        ### Output a predire ###
        output[compt,20] = sum(onde[select,"NbOutputONDE"]) # Nombre d'observations
        output[compt,21] = sum(onde[select,"NbOutputONDEAssecs"]) #Nombre d'observations d'assecs
        output[compt,22] = sum(onde[select,"NbOutputONDEAssecs"])/sum(onde[select,"NbOutputONDE"]) #Proba assec a predire
        
        ### Performance predictions ###
        moy_obs <- sum(onde[select,"NbOutputONDEAssecs"])/sum(onde[select,"NbOutputONDE"])
        output[compt,23] = 1 - sum((y_pred-(y*100))**2) / sum((moy_obs-(y*100))**2) #1 - SCE_modele / SCE_Aexpliquer = SCE_residus
        r = cor(y*100,y_pred) #Coeff de correlation entre donnees observees et donnees predites
        beta = mean(y_pred)/mean(y*100)
        alpha = mean(y*100)/mean(y_pred)*sd(y_pred)/sd(y*100)
        output[compt,24] = 1-sqrt((1-r)**2+(1-beta)**2+(1-alpha)**2) #KGE validation
        # output[compt,15] = sd(y)/mean(y) #CV => Indicateur litigieux car mean(y) n'est pas pondere au nombre de donnees ONDE utilisees pour obtenir y
        output[compt,25] = sd(y)/moy_obs #CV => Indicateur litigieux car mean(y) n'est pas pondere au nombre de donnees ONDE utilisees pour obtenir y

      } else {
        moy_obs <- sum(onde[select,"NbOutputONDEAssecs"])/sum(onde[select,"NbOutputONDE"])
        output[compt,1] = liste_Her[id]
        output[compt,2] = Reg$AnneesLearn
        
        output[compt,3] = Reg$Inter_logit
        output[compt,4] = Reg$Inter_pv_logit
        output[compt,5] = Reg$Slope_logit
        output[compt,6] = Reg$Slope_pv_logit
        
        output[compt,7] = Reg$TotalDeviance_logit_Learn
        output[compt,8] = Reg$ParameterDeviance_logit_Learn
        output[compt,9] = Reg$PropParameterDeviance_logit_Learn
        
        output[compt,10] = Reg$P_assecs_HER_MoyenMois_Apredire_Learn
        
        output[compt,11] = Reg$NASH_logit_Learn
        output[compt,12] = Reg$KGE_logit_Learn
        output[compt,13] = Reg$CV_logit_Learn
        
        output[compt,14] = Reg$Indicatif_NbTotalObservationsONDE
        output[compt,15] = Reg$Indicatif_NbObservationsAssecsONDE
        output[compt,16] = Reg$Indicatif_ProportionTotaleAssecsObservationsONDE
        
        output[compt,17] = non_select_
        output[compt,18] = nb_select_
        output[compt,19] = non_select_/(non_select_+nb_select_)
        
        output[compt,20] = sum(onde[select,"NbOutputONDE"]) # Nombre d'observations
        output[compt,21] = sum(onde[select,"NbOutputONDEAssecs"]) #Nombre d'observations d'assecs
        output[compt,22] = sum(onde[select,"NbOutputONDEAssecs"])/sum(onde[select,"NbOutputONDE"]) #Proba assec a predire
        
        output[compt,23] = NA
        output[compt,24] = NA
        # output[compt,15] = sd(y)/mean(y)
        output[compt,25] = sd(y)/moy_obs
      }
    }
  }

  colnames(output) = c("HER",
                       "AnneesLearn",
                       paste0("Inter_",regression,"_Learn"),paste0("Inter_pv_",regression,"_Learn"),
                       paste0("Slope_",regression,"_Learn"),paste0("Slope_pv_",regression,"_Learn"),
                       
                       paste0("TotalDeviance_",regression,"_Learn"),
                       paste0("ParameterDeviance_",regression,"_Learn"),
                       paste0("PropParameterDeviance_",regression,"_Learn"),
                       
                       "P_assecs_HER_MoyenMois_Apredire_Learn",
                       "NASH_logit_Learn","KGE_logit_Learn","CV_logit_Learn",
                       
                       "Indicatif_NbTotalObservationsONDE","Indicatif_NbObservationsAssecsONDE","Indicatif_ProportionTotaleAssecsObservationsONDE",
                       
                       "NbMoisExclusONDE_CValid",
                       "NbMoisSelectionnesONDE_CValid",
                       "PourcentageExclusions_CValid",
  
                       "NbStationsObservesONDE_CValid",
                       "NbAssecsObservesONDE_CValid",
                       "P_assecs_HER_MoyenMoisAnnee_Apredire_CValid",

                       paste0("NASH_HER_AnneeValid_",regression,"_CValid"),
                       paste0("KGE_HER_AnneeValid_",regression,"_CValid"),
                       paste0("CV_HER_AnneeValid_",regression,"_CValid"))

  return(output)
} 
