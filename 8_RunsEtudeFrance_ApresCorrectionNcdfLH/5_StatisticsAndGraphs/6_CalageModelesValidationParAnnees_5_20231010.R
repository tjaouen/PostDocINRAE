source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/3_Validation/11_Func_Relation_AvecCC_ValidationSansLearn_Globale_14_20230816.R")

### Libraries ###
library(strex)

### Study data ###
folder_output_ = folder_output_param_
nomSim_ = nomSim_param_
HER_ = HER_param_
jourMin_ = jourMin_param_
jourMax_ = jourMax_param_
regr = "logit"
HER_variable_ = HER_variable_param_

nom_categorieSimu_ = nom_categorieSimu_param_
nom_GCM_ = nom_GCM_param_

### Input ###
# liste <- c(list.files(paste0(folder_output_,"1_MatricesInputModeles_ParHERDates/",nomSim_), pattern="MatInputModel", full.names = T))
# il = liste[1]

### Table predictions - Leave One Year Out ###
tab_comp_ = data.frame()
# for (a in 2012:2022){
#   print(a)
#   tab_ <- read.table(paste0(folder_output_,
#                             "15_ResultatsModeles_ValidationParAnnees_ParHer/",
#                             nomSim_,
#                             ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
#                             ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
#                             ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
#                             "/TableGlobale/Map_English/Results_Jm",jourMin_,"Jj/ModelResults_ParDate_",str_after_nth(str_before_last(basename(il), "\\."),"\\_",2),"_Valid_",a,
#                             "_J",ifelse(jourMin_ == 0,"j",paste0("m",jourMin_)),"J",ifelse(jourMax_ == 0,"j",paste0("m",jourMax_)),"_logit_kge.csv"),
#                      sep = ";", dec = ".", header = T)
#   tab_comp_ <- rbind(tab_comp_,tab_)
# }

# for (a in 2012:2019){
for (a in 2012:2022){
  print(a)
  files_ <- list.files(paste0(folder_output_,
                              "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                              nomSim_,
                              ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                              # ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                              # ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                              "/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableParMoisAnnees/Results_Jm6Jj/"), pattern = paste0(".*",ifelse(nom_GCM_!="",nom_GCM_,""),".*_",substr(a,nchar(a)-1,nchar(a)),"_"),
                       full.names = T)
  tab_ = read.table(files_, sep = ";", dec = ".", header = T)
  
  tab_comp_ <- rbind(tab_comp_,tab_)
}

table(tab_comp_$Date)
liste_Her=sort(unique(tab_comp_$HER2))

dim(tab_comp_) # 3545
#2852 version annees seches, int, hum
# Version 22 : 4156

annee = 1
Matrice_comp = tab_comp_
liste_Her = liste_Her
nbrRep = 100
proportionTest = 0.65


### Table predictions - Annees seches, inter, humides ###
tab_globale_secIntHum_ = data.frame()
for (a in c("12-15-20-21","13-14-16-18","17-19-22")){
  print(a)
  files_ <- list.files(paste0(folder_output_,
                              "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                              nomSim_,
                              ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                              # "/ApprentissageParDeuxCategoriesParmiSechesInterHumides/Validation_3AnneesSechesInterHumides/TableParMoisAnnees/Results_Jm6Jj/"), pattern = paste0(".*",nom_GCM_,".*_",a,"_"),
                              "/ApprentissageParDeuxCategoriesParmiSechesInterHumides/Validation_3AnneesSechesInterHumides/TableParCategories/Results_Jm6Jj/"), pattern = paste0(".*",ifelse(nom_GCM_!="",nom_GCM_,""),".*_",a,"_"),
                       full.names = T)
  tab_ = read.table(files_, sep = ";", dec = ".", header = T)
  tab_globale_secIntHum_ <- rbind(tab_globale_secIntHum_,tab_)
}
# table(tab_globale_secIntHum_$Date)
liste_Her=sort(unique(tab_globale_secIntHum_$HER))

dim(tab_globale_secIntHum_) #231

### Table complete predictions Mois Annees - Annees seches, inter, humides ###
tab_comp_secIntHum_ = data.frame()
for (a in c("12-15-20-21","13-14-16-18","17-19-22")){
  print(a)
  files_ <- list.files(paste0(folder_output_,
                              "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                              nomSim_,
                              ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                              # "/ApprentissageParDeuxCategoriesParmiSechesInterHumides/Validation_3AnneesSechesInterHumides/TableParMoisAnnees/Results_Jm6Jj/"), pattern = paste0(".*",nom_GCM_,".*_",a,"_"),
                              "/ApprentissageParDeuxCategoriesParmiSechesInterHumides/Validation_3AnneesSechesInterHumides/TableParMoisAnnees/Results_Jm6Jj/"), pattern = paste0(".*",ifelse(nom_GCM_!="",nom_GCM_,""),".*_",a,"_"),
                       full.names = T)
  print(files_)
  tab_ = read.table(files_, sep = ";", dec = ".", header = T)
  tab_comp_secIntHum_ <- rbind(tab_comp_secIntHum_,tab_)
}



# ### Table validation globale ###
list_globale_ <- list.files(paste0(folder_output_,
                                   "15_ResultatsModeles_ValidationParAnnees_ParHer/",
                                   nomSim_,
                                   ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                   "/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableGlobale/"),
                            pattern = ifelse(nom_GCM_!="",nom_GCM_,".csv"),
                            full.names = T)
tab_globale_ = read.table(list_globale_,
                          sep = ";", dec = ".", header = T)




for (id in 1:length(liste_Her)) {
  
  # select <- which(tab_comp_[,1]==liste_Her[id])
  select <- which(tab_comp_secIntHum_[,1]==liste_Her[id])
  
  tab_globale_her_ <- tab_globale_[which(tab_globale_$HER == liste_Her[id]),]
  tab_comp_sec_her_ <- tab_globale_secIntHum_[which(tab_globale_secIntHum_$HER == liste_Her[id] & grepl("2012",tab_globale_secIntHum_$AnneesLearn) & grepl("2013",tab_globale_secIntHum_$AnneesLearn)),]
  tab_comp_int_her_ <- tab_globale_secIntHum_[which(tab_globale_secIntHum_$HER == liste_Her[id] & grepl("2013",tab_globale_secIntHum_$AnneesLearn) & grepl("2017",tab_globale_secIntHum_$AnneesLearn)),]
  tab_comp_hum_her_ <- tab_globale_secIntHum_[which(tab_globale_secIntHum_$HER == liste_Her[id] & grepl("2012",tab_globale_secIntHum_$AnneesLearn) & grepl("2017",tab_globale_secIntHum_$AnneesLearn)),]
  
  P_assecs_HER_MoyenneGlobale_Predit_tmp <- c()
  P_assecs_HER_MoyenneGlobale_Apredire_tmp <- c()
  NASH_HER_AnneeValid_logit_CValid_tmp <- c()
  KGE_HER_AnneeValid_logit_CValid_tmp <- c()
  CV_HER_AnneeValid_logit_CValid_tmp <- c()
  PropParameterDeviance_logit_Learn_tmp <- c()
  
  print(paste0('HER2 : ',id))
  
  # set.seed(i)
  # # set.seed(seed)
  # 
  # select_test_ <- sample(select, size = round(proportionTest*length(select)))
  # tab_test = tab_comp_[select_test_,]
  # 
  # y <- tab_test$ProbaAssec_HERMoisAnnee_Apredire_CValid
  # y_pred <- tab_test$ProbaAssec_HERMoisAnnee_Predite_CValid
  # 
  # unique_dates <- unique(format(as.Date(tab_test$Date),"%Y"))
  # color_palette <- colorRampPalette(c("blue", "red"))(length(unique_dates))
  # # Créer une correspondance entre les dates uniques et les couleurs de la palette
  # date_color_mapping <- setNames(color_palette, unique_dates)
  # # Créer une colonne "couleur" en utilisant la correspondance
  # tab_test$couleur <- date_color_mapping[format(as.Date(tab_test$Date),"%Y")]
  # # tab_test$col <- rainbow(length(unique(format(as.Date(tab_test$Date),"%Y"))))
  # 
  # plot(0,0,
  #      col = "white",
  #      xlim = c(0,1),
  #      ylim = c(0,max(max(y),max(y_pred))))
  # for (j in 1:length(y)){
  #   points(tab_test$FDC[j],y[j], col = tab_test$couleur[j], pch = 16)
  #   points(tab_test$FDC[j],y_pred[j], col = tab_test$couleur[j], pch = 17)
  #   model_pred <- exp(tab_test$Inter_logit_Learn[j] + tab_test$Slope_logit_Learn[j] * seq(0,1,0.01))/(1 + exp(tab_test$Inter_logit_Learn[j] + tab_test$Slope_logit_Learn[j] * seq(0,1,0.01)))
  #   lines(seq(0,1,0.01), model_pred, col = tab_test$couleur[j])
  #   segments(x0 = tab_test$FDC[j], x1 = tab_test$FDC[j], y0 = y[j], y1 = y_pred[j])
  # }
  # dev.off()
  
  
  # tab_essai = tab_comp_[select,]
  tab_essai = tab_comp_secIntHum_[select,]
  
  y <- tab_essai$ProbaAssec_HERMoisAnnee_Apredire_CValid
  y_pred <- tab_essai$ProbaAssec_HERMoisAnnee_Predite_CValid
  
  
  # Créer une correspondance entre les dates uniques et les couleurs de la palette
  # unique_dates <- unique(format(as.Date(tab_essai$Date),"%Y"))
  # color_palette <- colorRampPalette(c("blue", "red"))(length(unique_dates))
  # date_color_mapping <- setNames(color_palette, unique_dates)
  # Créer une colonne "couleur" en utilisant la correspondance
  
  # Créer une correspondance entre les categories d'annees et les couleurs de la palette
  unique_dates <- c("2012-2015-2017-2019-2020-2021-2022","2013-2014-2016-2017-2018-2019-2022","2012-2013-2014-2015-2016-2018-2020-2021")
  color_palette <- c("orange", "blue", "black")
  date_color_mapping <- setNames(color_palette, unique_dates)
  
  # tab_essai$couleur <- date_color_mapping[format(as.Date(tab_essai$Date),"%Y")]
  # tab_test$col <- rainbow(length(unique(format(as.Date(tab_test$Date),"%Y"))))
  tab_essai$couleur <- date_color_mapping[tab_essai$AnneesLearn]
  
  png(paste0(folder_output_,
             "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
             nomSim_,
             ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
             "/ApprentissageParDeuxCategoriesParmiSechesInterHumides/Validation_3AnneesSechesInterHumides/TableParMoisAnnees/Results_Jm6Jj/CalibrationPlots/",
             "CalageModele_FDCAssecs_HER",liste_Her[id],"_20231009.png"),
      # "/LeaveOneYearOut/Validation_ParAnnees/CalageModele_FDCAssecs_ParHER/CalageModele_FDCAssecs_HER",liste_Her[id],"_20230616.png"),
      width = 1200, height = 750,
      units = "px", pointsize = 12)
  
  x11()
  plot(0,0,
       col = "white",
       xlim = c(0,1),
       # ylim = c(0,max(max(na.omit(y)),max(na.omit(y_pred)))),
       ylim = c(0,1),
       ylab = "Probabilité d'assec",
       xlab = "FDC",
       main = paste0("Validation par année dans la HER ",unique(tab_essai$HER2)),
       cex.lab = 1.5,
       cex.main = 1.5,
       cex.axis = 1.5)
  
  for (j in 1:length(y)){
    points(tab_essai$FDC[j],y[j], col = tab_essai$couleur[j], pch = 16, cex = 2)
    points(tab_essai$FDC[j],y_pred[j], col = tab_essai$couleur[j], pch = 17, cex = 2)
    model_pred <- exp(tab_essai$Inter_logit_Learn[j] + tab_essai$Slope_logit_Learn[j] * seq(0,1,0.01))/(1 + exp(tab_essai$Inter_logit_Learn[j] + tab_essai$Slope_logit_Learn[j] * seq(0,1,0.01)))
    lines(seq(0,1,0.01), model_pred, col = tab_essai$couleur[j], lwd = 5 )
    # segments(x0 = tab_essai$FDC[j], x1 = tab_essai$FDC[j], y0 = y[j], y1 = y_pred[j])
  }
  
  lines(seq(0,1,0.01), exp(tab_globale_her_$Intercept_general + tab_globale_her_$Slope_general * seq(0,1,0.01)) / (1+exp(tab_globale_her_$Intercept_general + tab_globale_her_$Slope_general * seq(0,1,0.01))), lwd = 5, col = "#addd8e")
  
  # lines(seq(0,1,0.01), exp(tab_globale_her_$Intercept+tab_globale_her_$Slope*seq(0,1,0.01))/(1+exp(tab_globale_her_$Intercept+tab_globale_her_$Slope*seq(0,1,0.01))), lwd = 5, col = "#addd8e")
  # lines(seq(0,1,0.01), exp(tab_globale_her_$Intercept+tab_globale_her_$Slope*seq(0,1,0.01))/(1+exp(tab_globale_her_$Intercept+tab_globale_her_$Slope*seq(0,1,0.01)))+tab_globale_her_$RMSE, lwd = 5, col = "red")
  # lines(seq(0,1,0.01), exp(tab_globale_her_$Intercept+tab_globale_her_$Slope*seq(0,1,0.01))/(1+exp(tab_globale_her_$Intercept+tab_globale_her_$Slope*seq(0,1,0.01)))+tab_globale_her_$Biais, lwd = 5, col = "blue")
  # lines(seq(0,1,0.01), exp(tab_globale_her_$Intercept+tab_globale_her_$Slope*seq(0,1,0.01))/(1+exp(tab_globale_her_$Intercept+tab_globale_her_$Slope*seq(0,1,0.01)))+tab_globale_her_$ErreurMoyenneAbsolue, lwd = 5, col = "blue")
  
  
  upper_bound <- ifelse(exp(tab_globale_her_$Intercept_general + tab_globale_her_$Slope_general * seq(0, 1, 0.01)) / (1 + exp(tab_globale_her_$Intercept_general + tab_globale_her_$Slope_general * seq(0, 1, 0.01))) + tab_globale_her_$RMSE_general > 0,
                        exp(tab_globale_her_$Intercept_general + tab_globale_her_$Slope_general * seq(0, 1, 0.01)) / (1 + exp(tab_globale_her_$Intercept_general + tab_globale_her_$Slope_general * seq(0, 1, 0.01))) + tab_globale_her_$RMSE_general,NA)
  lower_bound <- ifelse(exp(tab_globale_her_$Intercept_general + tab_globale_her_$Slope_general * seq(0, 1, 0.01)) / (1 + exp(tab_globale_her_$Intercept_general + tab_globale_her_$Slope_general * seq(0, 1, 0.01))) - tab_globale_her_$RMSE_general > 0,
                        exp(tab_globale_her_$Intercept_general + tab_globale_her_$Slope_general * seq(0, 1, 0.01)) / (1 + exp(tab_globale_her_$Intercept_general + tab_globale_her_$Slope_general * seq(0, 1, 0.01))) - tab_globale_her_$RMSE_general,NA)
  
  # lines(seq(0,1,0.01), upper_bound, lwd = 2, lty = "dashed", col = "#ef3b2c")
  # lines(seq(0,1,0.01), lower_bound, lwd = 2, lty = "dashed", col = "#ef3b2c")
  
  # lines(seq(0,1,0.01), exp(tab_globale_her_$Intercept_general + tab_globale_her_$Slope_general * seq(0,1,0.01))/(1+exp(tab_globale_her_$Intercept_general + tab_globale_her_$Slope_general * seq(0,1,0.01)))+tab_globale_her_$Biais_general, lwd = 2, lty = "dashed", col = "#41ab5d")
  
  upper_bound_EMA <- ifelse(exp(tab_globale_her_$Intercept_general + tab_globale_her_$Slope_general * seq(0, 1, 0.01)) / (1 + exp(tab_globale_her_$Intercept_general + tab_globale_her_$Slope_general * seq(0, 1, 0.01))) + tab_globale_her_$ErreurMoyenneAbsolue_general > 0,
                            exp(tab_globale_her_$Intercept_general + tab_globale_her_$Slope_general * seq(0, 1, 0.01)) / (1 + exp(tab_globale_her_$Intercept_general + tab_globale_her_$Slope_general * seq(0, 1, 0.01))) + tab_globale_her_$ErreurMoyenneAbsolue_general,NA)
  lower_bound_EMA <- ifelse(exp(tab_globale_her_$Intercept_general + tab_globale_her_$Slope_general * seq(0, 1, 0.01)) / (1 + exp(tab_globale_her_$Intercept_general + tab_globale_her_$Slope_general * seq(0, 1, 0.01))) - tab_globale_her_$ErreurMoyenneAbsolue_general > 0,
                            exp(tab_globale_her_$Intercept_general + tab_globale_her_$Slope_general * seq(0, 1, 0.01)) / (1 + exp(tab_globale_her_$Intercept_general + tab_globale_her_$Slope_general * seq(0, 1, 0.01))) - tab_globale_her_$ErreurMoyenneAbsolue_general,NA)
  
  # lines(seq(0,1,0.01), upper_bound_EMA, lwd = 2, lty = "dashed", col = "#225ea8")
  # lines(seq(0,1,0.01), lower_bound_EMA, lwd = 2, lty = "dashed", col = "#225ea8")
  
  
  # Tracer l'intervalle d'ombre
  
  
  
  # lines(seq(0,1,0.01), exp(tab_comp_hum_her_$Inter_logit_Learn + tab_comp_hum_her_$Slope_logit_Learn * seq(0,1,0.01)) / (1+exp(tab_comp_hum_her_$Inter_logit_Learn + tab_comp_hum_her_$Slope_logit_Learn * seq(0,1,0.01))), lwd = 5, col = "orange")
  # lines(seq(0,1,0.01), exp(tab_comp_int_her_$Inter_logit_Learn + tab_comp_int_her_$Slope_logit_Learn * seq(0,1,0.01)) / (1+exp(tab_comp_int_her_$Inter_logit_Learn + tab_comp_int_her_$Slope_logit_Learn * seq(0,1,0.01))), lwd = 5, col = "blue")
  # lines(seq(0,1,0.01), exp(tab_comp_sec_her_$Inter_logit_Learn + tab_comp_sec_her_$Slope_logit_Learn * seq(0,1,0.01)) / (1+exp(tab_comp_sec_her_$Inter_logit_Learn + tab_comp_sec_her_$Slope_logit_Learn * seq(0,1,0.01))), lwd = 5, col = "black")
  
  legend("topright", 
         legend = c("Modèle général", 
                    "Modèle apprentissage années sèches et intermédiaires", 
                    "Modèle apprentissage années sèches et humides", 
                    "Modèle apprentissage années humides et intermédiaires"),
         col = c("#addd8e", "orange", "blue", "black"),
         lwd = 5,
         cex = 1.2)  
  
  
  dev.off()
  
}









# tab_essai = tab_comp_[select,]
# unique_dates <- unique(format(as.Date(tab_essai$Date),"%Y"))
# color_palette <- colorRampPalette(c("blue", "red"))(length(unique_dates))
# # Créer une correspondance entre les dates uniques et les couleurs de la palette
# date_color_mapping <- setNames(color_palette, unique_dates)
# tab_essai$couleur <- date_color_mapping[format(as.Date(tab_essai$Date),"%Y")]
# max_y = max(max(tab_essai$ProbaAssec_HERMoisAnnee_Apredire_CValid),max(tab_essai$ProbaAssec_HERMoisAnnee_Predite_CValid))
# ggplot(tab_essai, aes(x = FDC)) +
#   xlim(0,1)+
#   ylim(0,max_y)+
#   # geom_blank(col = "white", xlim = c(0, 1), ylim = c(0, max_y)) +
#   geom_point(aes(y = ProbaAssec_HERMoisAnnee_Apredire_CValid, col = couleur), pch = 16) +
#   geom_point(aes(y = ProbaAssec_HERMoisAnnee_Predite_CValid, col = couleur), pch = 17) +
#   geom_line(aes(y = exp(Inter_logit_Learn + Slope_logit_Learn * seq(0, 1, 0.01)) / (1 + exp(Inter_logit_Learn + Slope_logit_Learn * seq(0, 1, 0.01))), col = couleur)) #+
# # geom_segment(aes(y = ProbaAssec_HERMoisAnnee_Apredire_CValid, yend = ProbaAssec_HERMoisAnnee_Predite_CValid), xend = tab_essai$FDC) +
# # theme_minimal()