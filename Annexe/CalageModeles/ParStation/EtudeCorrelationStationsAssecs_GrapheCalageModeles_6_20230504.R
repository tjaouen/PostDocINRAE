### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/4_RunsEtudeFrance_20230417/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")

### Librairies ###
library(stringr)
library(doParallel)
library(dplyr)
library(lubridate)
library(ggplot2)
library(ggrepel)


### Run ###
cor_ <- data.frame()

# Fonction pour obtenir les dates dans l'intervalle (J-5):(J-1) pour une date donnée
get_interval <- function(date) {
  interval <- seq(date-5, date, by="day")
  return(interval)
}

#noms_stations_ = read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/3_ChroniquesAssecs_ParHer/1_PresentMesures_HERh_TsKGE_TtesStat_2012_2022_20230417/Correlations/CorrelationEtLogitStationsAssecs_DescriptifStations_Jm5Jj_OrderDevianceProp_3_20230502.csv", sep = ",", dec = ".", header = T)[,1]
noms_stations_ = c("A133003001",
                   "U211201001",
                   "V293401001",
                   "V141401001",
                   "W233521001",
                   "X013001001",
                   "X045401001",
                   "X102691001",
                   "Y530501501",
                   "Y040401001",
                   "A953205050",
                   "A962102050",
                   "A812200001")
#noms_stations_ = c("I205103002","I361206001","I403201001","I692301001","I532151001","I402201001")
# noms_stations_ = c("J012151001","J014401001","J062661001","J100452001","J110301001","J110581001",
#                    "J111401001","J120541001","J131301001","J132401001","J152302001","J152401001",
#                    "J172172001","J180301001","J181301001","J202301001","J203401001","J706062001",
#                    "J710301001","J711401001","J734401001","J735301001")
# noms_stations_ = c("F467000101")


#for (sta in (length(noms_stations_)-100):length(noms_stations_)){
for (sta in 1:length(noms_stations_)){
  
  nom_station_ = noms_stations_[sta]
  
  list_stations_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_1_PresentMesures_HERh_TsKGE_TtesStat_2012_2022_20230417/Stations_HYDRO_KGESUp0.00_DispSup-1.csv"
  hydro = read.table(list_stations_, sep=";", dec=".", header = T)
  if (dim(hydro)[2] == 1){
    hydro = read.table(il, sep=",", dec=".", header = T)
  }
  tab_tmp_ <- hydro[which(hydro$Code_short == nom_station_),which(grepl("eco0",colnames(hydro)) | grepl("eco1",colnames(hydro)))]
  HER_list_ <- as.numeric(substr(colnames(tab_tmp_)[which(tab_tmp_ > 0)],4,6))
  
  
  
  for (HER_ in HER_list_){
    
    print(HER_)
    
    if (file.exists(paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/FlowDurationCurves_ChroniquesParHer/Present/FDCChroHer_Obs_1_PresentMesures_HERh_TsKGE_PremierRun_2012_2022_20230417/ChroniqueFDC_KGESUp0.00_DispSup-1_Obs_HER",HER_,".csv"))){
      file_ <- paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/FlowDurationCurves_ChroniquesParHer/Present/FDCChroHer_Obs_1_PresentMesures_HERh_TsKGE_PremierRun_2012_2022_20230417/ChroniqueFDC_KGESUp0.00_DispSup-1_Obs_HER",HER_,".csv")
      tab_ <- read.table(file_, sep = ";", dec = ".", header = T)
      # print("File exists")
    }
    
    #input_mat_ <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/1_PresentMesures_HERh_TsKGE_TtesStat_2012_2022_20230417/MatInputModel_ByHERDates__2012_2022_KGESUp0.00_DispSup-1_Obs_Weight_AllStations.csv"
    #input_mat_ <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/6_PresentMesures_HERh_TsKGE_TtesStat_TestPoisson_2012_2022_20230503/MatInputModel_ByHERDates__2012_2022_KGESUp0.00_DispSup-1_Obs_Weight_AllStations_TestPoisson.csv"
    input_mat_ <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/7_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_2012_2022_20230505/MatInputModel_ByHERDates__2012_2022_KGESUp0.00_DispSup-1_Obs_Weight_AllStations_TestPoisson.csv"
    #tab_input_ <- read.table(input_mat_, sep = ";", dec = ".", header = T)
    tab_input_ <- read.table(input_mat_, sep = ",", dec = ".", header = T)
    tab_input_ <- tab_input_[which(tab_input_$HER2 == HER_),]
    
    if (dim(tab_input_)[1] > 0){
      # print("Inside if")
      
      # Convertir les chaînes de caractères en objets de classe Date
      dates <- as.Date(tab_input_$Date)
      
      # Appliquer la fonction à chaque date du vecteur
      intervals <- lapply(dates, get_interval)
      all_dates <- unlist(intervals)
      date_strings <- format(as.Date(all_dates, origin="1970-01-01"), "%Y-%m-%d")
      
      tab_ <- tab_[which(tab_$Date %in% date_strings),]
      tab_$Annee <- lubridate::year(tab_$Date)
      tab_$Mois <- lubridate::month(tab_$Date)
      
      tab_data_ <- aggregate(. ~ Annee + Mois, data = tab_[,2:dim(tab_)[2]], FUN = mean)
      tab_data_ <- tab_data_[order(tab_data_$Annee,tab_data_$Mois),]
      
      
      tab_input_$Annee <- lubridate::year(tab_input_$Date)
      tab_input_$Mois <- lubridate::month(tab_input_$Date)
      
      #tab_merge_ <- merge(tab_input_[,c("HER2","Date","X._Assec","Annee","Mois")],tab_data_, by = c("Annee", "Mois"))
      tab_merge_ <- merge(tab_input_[,c("HER2","Date","X._Assec","Annee","Mois","NbOutputONDEAssecs","NbOutputONDE")],tab_data_, by = c("Annee", "Mois"))
      
      ### Correlation ###
      y = tab_merge_$X._Assec/100
      moy_obs = mean(tab_merge_$X._Assec)
      
      c = grep(nom_station_, colnames(tab_merge_))
      name_ = colnames(tab_merge_)[c]
      
      #for (c in 6:dim(tab_merge_)[2]){
      Reg = glm(y ~ tab_merge_[,c], family=binomial(link=logit))
      y_pred_logit = (exp(Reg$coef[2]*tab_merge_[,c]+Reg$coef[1])/(1+exp(Reg$coef[2]*tab_merge_[,c]+Reg$coef[1])))*100
      
      
      # cor_[dim(cor_)[1]+1,1] <- HER_
      # cor_[dim(cor_)[1],2] <- colnames(tab_merge_)[c]
      # cor_[dim(cor_)[1],3] <- cor(tab_merge_$X._Assec,tab_merge_[,c])
      # 
      # cor_[dim(cor_)[1],4] = Reg$coef[1] #Coefficient 1 de la regression
      # cor_[dim(cor_)[1],5] = summary(Reg)$coefficients[1,4] #Coefficient 1 de la regression
      # 
      # cor_[dim(cor_)[1],6] = Reg$coef[2] #Coefficient 2 de la regression
      # cor_[dim(cor_)[1],7] = summary(Reg)$coefficients[2,4] #Coefficient 2 de la regression
      # 
      # cor_[dim(cor_)[1],8] = 1 - sum((y_pred-(y*100))**2) / sum((moy_obs-(y*100))**2) #1 - SCE_modele / SCE_Aexpliquer = SCE_residus
      # cor_[dim(cor_)[1],9] = anova(Reg)[[4]][1]
      # cor_[dim(cor_)[1],10] = anova(Reg)[[4]][1]-anova(Reg)[[4]][2]
      # cor_[dim(cor_)[1],11] = (anova(Reg)[[4]][1]-anova(Reg)[[4]][2])/anova(Reg)[[4]][1]*100
      # 
      # cor_[dim(cor_)[1],12] = mean(y) #Moyenne observee
      # cor_[dim(cor_)[1],13] = length(which(y>0)) #Nombre d'observation superieures a 0
      # 
      # r = cor(y*100,y_pred) #Coeff de correlation entre donnees observees et donnees predites
      # beta = mean(y_pred)/mean(y*100)
      # alpha = mean(y*100)/mean(y_pred)*sd(y_pred)/sd(y*100)
      # cor_[dim(cor_)[1],14] = 1-sqrt((1-r)**2+(1-beta)**2+(1-alpha)**2)
      # cor_[dim(cor_)[1],15] = sd(y)/mean(y)
      
      #png(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/3_ChroniquesAssecs_ParHer/1_PresentMesures_HERh_TsKGE_TtesStat_2012_2022_20230417/GraphesModeles_ParStations/StationOrdrePropDeviance_EtudeBretagneNormandie_20230504/GrapheModParStat_",sta,"_Station_",nom_station_,"_HER_",HER_,"_logit.png"),
      png(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/12_Graphes_CalageModele_FDCAssecs_ParStations/7_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_2012_2022_20230505/GrapheModParStat_",sta,"_Station_",nom_station_,"_HER_",HER_,"_logit.png"),
          width = 1200, height = 750,
          units = "px", pointsize = 12)
      p <- ggplot(tab_merge_, aes(x = !!sym(name_), y = X._Assec/100, color = as.factor(format(as.Date(Date, format = "%Y-%m-%d"), "%Y")))) +
        geom_point(size = 3) +
        geom_line(aes(x = tab_merge_[,c], y = y_pred_logit/100), color = "black") +
        #geom_line(data = tab_inShape_, aes(x = Freq_moins, y = A_FreqMoins_), color = "black") +
        scale_color_viridis_d(name = "Année") +
        theme_minimal() +
        xlim(0,1) +
        theme(axis.text = element_text(size = 14),
              axis.title = element_text(size = 16)) +
        labs(x = "Fréquence moyenne de non dépassement", y = "Pourcentage d'assecs") +
        geom_text_repel(aes(label = format(as.Date(Date),"%m-%Y")), size = 4, force = 5,  # réduction de la valeur de "force"
                        nudge_x = 0.05, nudge_y = 0.05)  # réduction des valeurs de "nudge_x" et "nudge_y"
      print(p)
      dev.off()
      
      
      # ### Regression Poisson ###
      # Reg_poisson = glm(tab_merge_$NbOutputONDEAssecs ~ tab_merge_[,c], family = poisson(link = "log"))
      # y_pred_poisson = predict(Reg_poisson, newdata = data.frame(x = tab_merge_[,c]), type = "response") # Equivaut a fitted(Reg)
      # 
      # #png(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/3_ChroniquesAssecs_ParHer/1_PresentMesures_HERh_TsKGE_TtesStat_2012_2022_20230417/GraphesModeles_ParStations/StationOrdrePropDeviance_EtudeBretagneNormandie_20230504/GrapheModParStat_",sta,"_Station_",nom_station_,"_HER_",HER_,"_poisson.png"),
      # png(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/12_Graphes_CalageModele_FDCAssecs_ParStations/7_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_2012_2022_20230505/GrapheModParStat_",sta,"_Station_",nom_station_,"_HER_",HER_,"_poisson.png"),
      #     width = 1200, height = 750,
      #     units = "px", pointsize = 12)
      # # x11()
      # p <- ggplot(tab_merge_, aes(x = !!sym(name_), y = tab_merge_$NbOutputONDEAssecs, color = as.factor(format(as.Date(Date, format = "%Y-%m-%d"), "%Y")))) +
      #   geom_point(size = 3) +
      #   geom_line(aes(x = tab_merge_[,c], y = y_pred_poisson), color = "red") +
      #   scale_color_viridis_d(name = "Année") +
      #   theme_minimal() +
      #   xlim(0,1) +
      #   theme(axis.text = element_text(size = 14),
      #         axis.title = element_text(size = 16)) +
      #   labs(x = "Fréquence moyenne de non dépassement", y = "Pourcentage d'assecs") +
      #   geom_text_repel(aes(label = format(as.Date(Date),"%m-%Y")), size = 4, force = 5,  # réduction de la valeur de "force"
      #                   nudge_x = 0.05, nudge_y = 0.05)  # réduction des valeurs de "nudge_x" et "nudge_y"
      # print(p)
      # #dev.off()
      
      #}
    }
  }
  
}


