

list_appGlobSafran_ <- list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/2_ResultatsModeles_ParHer/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/",
                                  pattern = "logit", all.files = T, recursive = T, include.dirs = F, full.names = T)
list_appGlobSafran_

KGE_list_ = c()
RMSE_list_ = c()

for (l in list_appGlobSafran_){
  tab_ <- read.table(l, sep = ";", dec = ".", header = T)
  KGE_list_ <- c(KGE_list_,tab_$KGE)
  RMSE_list_ <- c(RMSE_list_, tab_$)
}

length(KGE_list_)
median(KGE_list_)
quantile(KGE_list_, probs = 0.25)
quantile(KGE_list_, probs = 0.75)

