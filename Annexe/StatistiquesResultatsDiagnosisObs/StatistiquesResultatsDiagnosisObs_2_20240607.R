


tab_ <- read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableGlobale/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_ValidGlobale__Jm6Jj_logit.csv",
                   sep = ";", dec = ".", header = T)

# tab_ <- read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2022_20230919/DebitsComplets_From20120101_To20221231/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableGlobale/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_ValidGlobale__Jm6Jj_logit.csv",
#                    sep = ";", dec = ".", header = T)

#12-15-20-21 Intermediate
tab_1 <- read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/ApprentissageParDeuxCategoriesParmiSechesInterHumides/Validation_3AnneesSechesInterHumides/TableGlobale/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_ValidGlobale_12-15-20-21_Jm6Jj_logit.csv",
                    sep = ";", dec = ".", header = T)
#13-14-16-18 Wet
tab_2 <- read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/ApprentissageParDeuxCategoriesParmiSechesInterHumides/Validation_3AnneesSechesInterHumides/TableGlobale/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_ValidGlobale_13-14-16-18_Jm6Jj_logit.csv",
                    sep = ";", dec = ".", header = T)
#17-19-22 Sec
tab_3 <- read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/ApprentissageParDeuxCategoriesParmiSechesInterHumides/Validation_3AnneesSechesInterHumides/TableGlobale/ModelResults_ParDate_ByHERDates__2012_2022_Observes_Weight_merge_ValidGlobale_17-19-22_Jm6Jj_logit.csv",
                    sep = ";", dec = ".", header = T)

median(tab_1$KGE_HER_AnneeValid_logit_CValid_general)
median(tab_2$KGE_HER_AnneeValid_logit_CValid_general)
median(tab_3$KGE_HER_AnneeValid_logit_CValid_general)

table(tab_$KGE_HER_AnneeValid_logit_CValid_general>0.8)
table(tab_$KGE_HER_AnneeValid_logit_CValid_general>0.75)
median(tab_$KGE_HER_AnneeValid_logit_CValid_general)
table(tab_$NASH_HER_AnneeValid_logit_CValid_general>0.8)
median(tab_$KGE_HER_AnneeValid_logit_CValid_general)

table(tab_1$KGE_HER_AnneeValid_logit_CValid_general>0.8)
median(tab_1$KGE_HER_AnneeValid_logit_CValid_general)
table(tab_2$KGE_HER_AnneeValid_logit_CValid_general>0.8)
median(tab_2$KGE_HER_AnneeValid_logit_CValid_general)
table(tab_3$KGE_HER_AnneeValid_logit_CValid_general>0.8)
median(tab_3$KGE_HER_AnneeValid_logit_CValid_general)


mean(tab_$PropParameterDeviance_logit_Learn_general)

median(tab_$KGE_HER_AnneeValid_logit_CValid_general)

mean(tab_$NASH_HER_AnneeValid_logit_CValid_general)
median(tab_$NASH_HER_AnneeValid_logit_CValid_general)
quantile(tab_$NASH_HER_AnneeValid_logit_CValid_general, probs = 0.25)
quantile(tab_$NASH_HER_AnneeValid_logit_CValid_general, probs = 0.75)

median(tab_$P_assecs_HER_MoyenneGlobale_Apredire_general)
median(tab_$P_assecs_HER_MoyenneGlobale_Predit_general)


median(tab_1$NASH_HER_AnneeValid_logit_CValid_general)
median(tab_2$NASH_HER_AnneeValid_logit_CValid_general)
median(tab_3$NASH_HER_AnneeValid_logit_CValid_general)



median(tab_$RMSE_general)
median(tab_1$RMSE_general)
median(tab_2$RMSE_general)
median(tab_3$RMSE_general)

median(abs(tab_$Biais_general))
median(abs(tab_1$Biais_general))
median(abs(tab_2$Biais_general))
median(abs(tab_3$Biais_general))

median(abs(tab_$ErreurMoyenneAbsolue_general))
median(abs(tab_1$ErreurMoyenneAbsolue_general))
median(abs(tab_2$ErreurMoyenneAbsolue_general))
median(abs(tab_3$ErreurMoyenneAbsolue_general))

mean(tab_$Biais_general)









median(tab_$P_assecs_HER_MoyenneGlobale_Apredire_general) #14.3
quantile(tab_$P_assecs_HER_MoyenneGlobale_Apredire_general, probs = 0.25)
quantile(tab_$P_assecs_HER_MoyenneGlobale_Apredire_general, probs = 0.75)
min(tab_$P_assecs_HER_MoyenneGlobale_Apredire_general)
max(tab_$P_assecs_HER_MoyenneGlobale_Apredire_general)

median(tab_$P_assecs_HER_MoyenneGlobale_Predit_general) #14.4
quantile(tab_$P_assecs_HER_MoyenneGlobale_Predit_general, probs = 0.25)
quantile(tab_$P_assecs_HER_MoyenneGlobale_Predit_general, probs = 0.75)
min(tab_$P_assecs_HER_MoyenneGlobale_Predit_general)
max(tab_$P_assecs_HER_MoyenneGlobale_Predit_general)

median(tab_$NASH_HER_AnneeValid_logit_CValid_general) #0.79
quantile(tab_$NASH_HER_AnneeValid_logit_CValid_general, probs = 0.25)
quantile(tab_$NASH_HER_AnneeValid_logit_CValid_general, probs = 0.75)
min(tab_$NASH_HER_AnneeValid_logit_CValid_general)
max(tab_$NASH_HER_AnneeValid_logit_CValid_general)

median(tab_$KGE_HER_AnneeValid_logit_CValid_general) #0.85
quantile(tab_$KGE_HER_AnneeValid_logit_CValid_general, probs = 0.25)
quantile(tab_$KGE_HER_AnneeValid_logit_CValid_general, probs = 0.75)
min(tab_$KGE_HER_AnneeValid_logit_CValid_general)
max(tab_$KGE_HER_AnneeValid_logit_CValid_general)

median(tab_$Biais_general)
quantile(tab_$Biais_general, probs = 0.25)
quantile(tab_$Biais_general, probs = 0.75)
min(tab_$Biais_general)
max(tab_$Biais_general)

median(tab_$ErreurMoyenneAbsolue_3maxApred_general) #0.10
quantile(tab_$ErreurMoyenneAbsolue_3maxApred_general, probs = 0.25)
quantile(tab_$ErreurMoyenneAbsolue_3maxApred_general, probs = 0.75)
min(tab_$ErreurMoyenneAbsolue_3maxApred_general)
max(tab_$ErreurMoyenneAbsolue_3maxApred_general)

median(tab_$RMSE_general) #0.07
quantile(tab_$RMSE_general, probs = 0.25)
quantile(tab_$RMSE_general, probs = 0.75)
min(tab_$RMSE_general)
max(tab_$RMSE_general)




median(tab_2$P_assecs_HER_MoyenneGlobale_Apredire_general)
quantile(tab_2$P_assecs_HER_MoyenneGlobale_Apredire_general, probs = 0.25)
quantile(tab_2$P_assecs_HER_MoyenneGlobale_Apredire_general, probs = 0.75)
min(tab_2$P_assecs_HER_MoyenneGlobale_Apredire_general)
max(tab_2$P_assecs_HER_MoyenneGlobale_Apredire_general)

median(tab_2$P_assecs_HER_MoyenneGlobale_Predit_general)
quantile(tab_2$P_assecs_HER_MoyenneGlobale_Predit_general, probs = 0.25)
quantile(tab_2$P_assecs_HER_MoyenneGlobale_Predit_general, probs = 0.75)
min(tab_2$P_assecs_HER_MoyenneGlobale_Predit_general)
max(tab_2$P_assecs_HER_MoyenneGlobale_Predit_general)

median(tab_2$NASH_HER_AnneeValid_logit_CValid_general)
quantile(tab_2$NASH_HER_AnneeValid_logit_CValid_general, probs = 0.25)
quantile(tab_2$NASH_HER_AnneeValid_logit_CValid_general, probs = 0.75)
min(tab_2$NASH_HER_AnneeValid_logit_CValid_general)
max(tab_2$NASH_HER_AnneeValid_logit_CValid_general)

median(tab_2$KGE_HER_AnneeValid_logit_CValid_general)
quantile(tab_2$KGE_HER_AnneeValid_logit_CValid_general, probs = 0.25)
quantile(tab_2$KGE_HER_AnneeValid_logit_CValid_general, probs = 0.75)
min(tab_2$KGE_HER_AnneeValid_logit_CValid_general)
max(tab_2$KGE_HER_AnneeValid_logit_CValid_general)

median(tab_2$Biais_general)
quantile(tab_2$Biais_general, probs = 0.25)
quantile(tab_2$Biais_general, probs = 0.75)
min(tab_2$Biais_general)
max(tab_2$Biais_general)

median(tab_2$ErreurMoyenneAbsolue_3maxApred_general)
quantile(tab_2$ErreurMoyenneAbsolue_3maxApred_general, probs = 0.25)
quantile(tab_2$ErreurMoyenneAbsolue_3maxApred_general, probs = 0.75)
min(tab_2$ErreurMoyenneAbsolue_3maxApred_general)
max(tab_2$ErreurMoyenneAbsolue_3maxApred_general)

median(tab_2$RMSE_general)
quantile(tab_2$RMSE_general, probs = 0.25)
quantile(tab_2$RMSE_general, probs = 0.75)
min(tab_2$RMSE_general)
max(tab_2$RMSE_general)






median(tab_1$P_assecs_HER_MoyenneGlobale_Apredire_general) #12.9
quantile(tab_1$P_assecs_HER_MoyenneGlobale_Apredire_general, probs = 0.25)
quantile(tab_1$P_assecs_HER_MoyenneGlobale_Apredire_general, probs = 0.75)
min(tab_1$P_assecs_HER_MoyenneGlobale_Apredire_general)
max(tab_1$P_assecs_HER_MoyenneGlobale_Apredire_general)

median(tab_1$P_assecs_HER_MoyenneGlobale_Predit_general)
quantile(tab_1$P_assecs_HER_MoyenneGlobale_Predit_general, probs = 0.25)
quantile(tab_1$P_assecs_HER_MoyenneGlobale_Predit_general, probs = 0.75)
min(tab_1$P_assecs_HER_MoyenneGlobale_Predit_general)
max(tab_1$P_assecs_HER_MoyenneGlobale_Predit_general)

median(tab_1$NASH_HER_AnneeValid_logit_CValid_general)
quantile(tab_1$NASH_HER_AnneeValid_logit_CValid_general, probs = 0.25)
quantile(tab_1$NASH_HER_AnneeValid_logit_CValid_general, probs = 0.75)
min(tab_1$NASH_HER_AnneeValid_logit_CValid_general)
max(tab_1$NASH_HER_AnneeValid_logit_CValid_general)

median(tab_1$KGE_HER_AnneeValid_logit_CValid_general)
quantile(tab_1$KGE_HER_AnneeValid_logit_CValid_general, probs = 0.25)
quantile(tab_1$KGE_HER_AnneeValid_logit_CValid_general, probs = 0.75)
min(tab_1$KGE_HER_AnneeValid_logit_CValid_general)
max(tab_1$KGE_HER_AnneeValid_logit_CValid_general)

median(tab_1$Biais_general)
quantile(tab_1$Biais_general, probs = 0.25)
quantile(tab_1$Biais_general, probs = 0.75)
min(tab_1$Biais_general)
max(tab_1$Biais_general)

median(tab_1$ErreurMoyenneAbsolue_3maxApred_general)
quantile(tab_1$ErreurMoyenneAbsolue_3maxApred_general, probs = 0.25)
quantile(tab_1$ErreurMoyenneAbsolue_3maxApred_general, probs = 0.75)
min(tab_1$ErreurMoyenneAbsolue_3maxApred_general)
max(tab_1$ErreurMoyenneAbsolue_3maxApred_general)

median(tab_1$RMSE_general)
quantile(tab_1$RMSE_general, probs = 0.25)
quantile(tab_1$RMSE_general, probs = 0.75)
min(tab_1$RMSE_general)
max(tab_1$RMSE_general)






median(tab_3$P_assecs_HER_MoyenneGlobale_Apredire_general)
quantile(tab_3$P_assecs_HER_MoyenneGlobale_Apredire_general, probs = 0.25)
quantile(tab_3$P_assecs_HER_MoyenneGlobale_Apredire_general, probs = 0.75)
min(tab_3$P_assecs_HER_MoyenneGlobale_Apredire_general)
max(tab_3$P_assecs_HER_MoyenneGlobale_Apredire_general)

median(tab_3$P_assecs_HER_MoyenneGlobale_Predit_general)
quantile(tab_3$P_assecs_HER_MoyenneGlobale_Predit_general, probs = 0.25)
quantile(tab_3$P_assecs_HER_MoyenneGlobale_Predit_general, probs = 0.75)
min(tab_3$P_assecs_HER_MoyenneGlobale_Predit_general)
max(tab_3$P_assecs_HER_MoyenneGlobale_Predit_general)

median(tab_3$NASH_HER_AnneeValid_logit_CValid_general)
quantile(tab_3$NASH_HER_AnneeValid_logit_CValid_general, probs = 0.25)
quantile(tab_3$NASH_HER_AnneeValid_logit_CValid_general, probs = 0.75)
min(tab_3$NASH_HER_AnneeValid_logit_CValid_general)
max(tab_3$NASH_HER_AnneeValid_logit_CValid_general)

median(tab_3$KGE_HER_AnneeValid_logit_CValid_general)
quantile(tab_3$KGE_HER_AnneeValid_logit_CValid_general, probs = 0.25)
quantile(tab_3$KGE_HER_AnneeValid_logit_CValid_general, probs = 0.75)
min(tab_3$KGE_HER_AnneeValid_logit_CValid_general)
max(tab_3$KGE_HER_AnneeValid_logit_CValid_general)

median(tab_3$Biais_general)
quantile(tab_3$Biais_general, probs = 0.25)
quantile(tab_3$Biais_general, probs = 0.75)
min(tab_3$Biais_general)
max(tab_3$Biais_general)

median(tab_3$ErreurMoyenneAbsolue_3maxApred_general)
quantile(tab_3$ErreurMoyenneAbsolue_3maxApred_general, probs = 0.25)
quantile(tab_3$ErreurMoyenneAbsolue_3maxApred_general, probs = 0.75)
min(tab_3$ErreurMoyenneAbsolue_3maxApred_general)
max(tab_3$ErreurMoyenneAbsolue_3maxApred_general)

median(tab_3$RMSE_general)
quantile(tab_3$RMSE_general, probs = 0.25)
quantile(tab_3$RMSE_general, probs = 0.75)
min(tab_3$RMSE_general)
max(tab_3$RMSE_general)


