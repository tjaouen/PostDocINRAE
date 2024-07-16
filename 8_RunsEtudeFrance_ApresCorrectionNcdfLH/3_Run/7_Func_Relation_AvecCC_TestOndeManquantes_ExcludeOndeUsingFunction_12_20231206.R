#-------------------------------------------------------------------------------
# Fonction FUNC_CAL_VAL() qui permet de faire un calage et une validation crois? des r?sultats 

# Bottet Quentin - Irstea - 18/09/2019 - Version 1
#-------------------------------------------------------------------------------
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/2_Run/5_ObtenirAppliquerSeuilsDonneesOndeSurMatriceInput_1_20230607.R")

FUNC_CAL_VAL = function(annee,Matrice_comp,liste_Her,regression,jourMin_,jourMax_){
  
  if (is.numeric(annee) & nchar(annee) == 4){onde = Matrice_comp[which(substr(Matrice_comp[,c("Date")],7,10)!= annee),]
  }else if(is.numeric(annee) & nchar(annee) != 4){onde = Matrice_comp[which(substr(Matrice_comp[,c("Date")],5,5)!= annee),]
  }else{onde = Matrice_comp}
  output=data.frame()
  compt=0
  compte=0
  
  seuils_ <- obtenirSeuilsOnde(MatriceInput = onde, Niveau = 0.75)
  list_ <- appliquerSeuilsOnde(tab_ = onde, Seuil_df_ = seuils_)
  onde <- list_[[1]]
  stat <- list_[[2]]
  
  for (id in 1:length(liste_Her)) {
    
    select <- which(onde[,1]==liste_Her[id])
    non_select_ <- stat$nb_excl_[which(stat$HER == liste_Her[id])]
    nb_select_ <- stat$nb_cons_[which(stat$HER == liste_Her[id])]
    
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
      
      if (sum(y)!=0 & length(unique(y))>2){
        if(regression == "lin"){
          Reg <- lm(y~x)
          y_pred=(Reg$coef[2]*x+Reg$coef[1])
          # seuillage des pr?dictions entre 0 et 100
          for (l in 1:length(y_pred)){
            y_pred[l]=min(max(y_pred[l],0),100)
          }
          y = y / 100
        }
        if(regression == "log"){
          Reg <- lm(y~log(x))
          y_pred=(Reg$coef[2]*log(x)+Reg$coef[1])
          
          for (l2 in 1:length(y_pred)){
            y_pred[l2] = min(max(y_pred[l2],0),100)
          }
          y = y / 100
        }
        if(regression == "logit"){
          y = y / 100
          Reg = glm(y~x, family=binomial(link=logit))
          y_pred = (exp(Reg$coef[2]*x+Reg$coef[1])/(1+exp(Reg$coef[2]*x+Reg$coef[1])))*100
        }
        
        ### HER ###
        HER = liste_Her[id]
        output[compt,1] = liste_Her[id]
        
        ### Dates apprentissage ###
        output[compt,2] = paste(unique(format(as.Date(onde$Date[select]),"%Y")), collapse = "-") #Annees apprentissage
        
        ### Modeles ###
        output[compt,3] = Reg$coef[1] #Coefficient 1 de la regression
        output[compt,4] = summary(Reg)$coefficients[1,4] #Coefficient 1 de la regression
        output[compt,5] = Reg$coef[2] #Coefficient 2 de la regression
        output[compt,6] = summary(Reg)$coefficients[2,4] #Coefficient 2 de la regression
        
        ### Indicateurs apprentissage ###
        output[compt,7] = anova(Reg)[[4]][1] #Total deviance
        output[compt,8] = anova(Reg)[[4]][1]-anova(Reg)[[4]][2] #Parameter deviance
        output[compt,9] = (anova(Reg)[[4]][1]-anova(Reg)[[4]][2])/anova(Reg)[[4]][1]*100 #Proportion parameter deviance
        
        ### A predire ###
        output[compt,10] = non_select_
        output[compt,11] = length(select) #Nombre de (mois,annee) disponibles
        output[compt,12] = non_select_/(non_select_+nb_select_)
        output[compt,13] = length(which(y>0)) #Nombre d'observation superieures a 0
        output[compt,14] = mean(y) #Moyenne observee
        
        ### Performances ###
        moy_obs = mean(y*100)
        # moy_obs = sum(onde$NbOutputONDEAssecs)/sum(onde$NbOutputONDE)
        output[compt,15] = 1 - sum((y_pred-(y*100))**2) / sum((moy_obs-(y*100))**2) #1 - SCE_residuelle / SCE_Aexpliquer = SCE_expliquee par modele
        r = cor(y*100,y_pred) #Coeff de correlation entre donnees observees et donnees predites
        beta = mean(y_pred)/mean(y*100)
        alpha = mean(y*100)/mean(y_pred)*sd(y_pred)/sd(y*100)
        output[compt,16] = 1-sqrt((1-r)**2+(1-beta)**2+(1-alpha)**2) #KGE
        output[compt,17] = sd(y)/mean(y) #CV => Indicateur litigieux car mean(y) n'est pas pondere au nombre de donnees ONDE utilisees pour obtenir y
        output[compt,18] = sum(onde$NbOutputONDE[select])
        output[compt,19] = sum(onde$NbOutputONDEAssecs[select])
        output[compt,20] = sum(onde$NbOutputONDEAssecs[select])/sum(onde$NbOutputONDE[select])
        
        output[compt,21] = mean(y_pred)/100
        
      } else {
        output[compt,1] = liste_Her[id]
        output[compt,2] = paste(unique(format(as.Date(onde$Date[select]),"%Y")), collapse = "-")
        output[compt,3] = NA
        output[compt,4] = NA
        output[compt,5] = NA
        output[compt,6] = NA
        output[compt,7] = NA
        output[compt,8] = NA
        output[compt,9] = NA
        output[compt,10] = non_select_
        output[compt,11] = length(select)
        output[compt,12] = non_select_/(non_select_+length(select))
        output[compt,13] = length(which(y>0))
        output[compt,14] = mean(y)
        output[compt,15] = NA
        output[compt,16] = NA
        output[compt,17] = sd(y)/mean(y)
        output[compt,18] = sum(onde$NbOutputONDE[select])
        output[compt,19] = sum(onde$NbOutputONDEAssecs[select])
        output[compt,20] = sum(onde$NbOutputONDEAssecs[select])/sum(onde$NbOutputONDE[select])
        
        output[compt,21] = NA
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
                       
                       "NbMoisExclusONDE_CValid",
                       "NbTotalMoisObservesONDE_Learn",
                       "PourcentageExclusions_CValid",
                       "NbMoisAuMoinsUnAssecONDE_Learn",
                       "P_assecs_HER_MoyenMois_Apredire_Learn",
                       
                       paste0("NASH_",regression,"_Learn"),
                       paste0("KGE_",regression,"_Learn"),
                       paste0("CV_",regression,"_Learn"),
                       
                       "Indicatif_NbTotalObservationsONDE",
                       "Indicatif_NbObservationsAssecsONDE",
                       "Indicatif_ProportionTotaleAssecsObservationsONDE",
                       
                       "P_assecs_HER_MoyenMois_Predite_Learn")
  
  ## Validation crois?e directement dans la fonction FUNC_CAL_VAL !
  #if (is.numeric(annee) & nchar(annee) == 4){ONDE = Matrice_comp[which(substr(Matrice_comp[,c("Date")],7,10)== annee),]
  #}else if(is.numeric(annee) & nchar(annee) != 4){ONDE = Matrice_comp[which(substr(Matrice_comp[,c("Date")],5,5)== annee),]
  #}else{ONDE = Matrice_comp}
  #
  #for (id in 1:nrow(output)){
  #  HER2 = output[id,1]
  #  #RH = output[id,2]
  #  couple2 = which(ONDE[,1]==HER2)
  #  for (j in couple2){
  #    if(regression == "lin"){
  #      ONDE[j,17] = max(output[id,3]*(mean(as.numeric(ONDE[j,10:15])))+output[id,2],0) # calcul du % d'assec en fonction des coefficients de r?gression d?termin?s
  #    }
  #    if(regression == "log"){
  #      ONDE[j,17] = max(output[id,3]*log(mean(as.numeric(ONDE[j,10:15])))+output[id,2],0)
  #    }
  #    if(regression == "logit"){
  #      ONDE[j,17] = max((exp(output[id,3]*(mean(as.numeric(ONDE[j,10:15])))+output[id,2])/(1+exp(output[id,3]*(mean(as.numeric(ONDE[j,10:15])))+output[id,2]))),0)*100
  #    }
  #    ONDE[j,17] = min(ONDE[j,17],100)
  #  }
  #
  #  y = ONDE[which(ONDE$HER == HER2),]$X._Assec
  #  moy_obs = mean(y)
  #  output[id,7] = 1 - sum((ONDE[couple2,17]-(y))**2) / sum((moy_obs-(y))**2)
  #}
  #colnames(output)[4] = c(paste0("NASH_Calib_",annee,"_",regression))
  #colnames(output)[7] = c(paste0("NASH_Valid_",annee,"_",regression))
  #colnames(ONDE)[17] = c(paste0("%NoF_sim_",regression))
  #NASH_table = output[,c("HER",paste0("NASH_Calib_",annee,"_",regression),paste0("NASH_Valid_",annee,"_",regression))]
  
  return(output)
} 
