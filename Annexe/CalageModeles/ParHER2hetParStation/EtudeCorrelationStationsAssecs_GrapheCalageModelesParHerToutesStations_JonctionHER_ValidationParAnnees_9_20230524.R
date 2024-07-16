### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/4_RunsEtudeFrance_20230417/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")

### Librairies ###
library(stringr)
library(doParallel)
library(strex)
library(dplyr)
library(lubridate)
library(ggplot2)
library(ggrepel)
library(reshape2)
library(viridisLite)

### Parameters ###
nomSim_ = nomSim_param_
nom_selectStations_ = nom_selectStations_param_
folder_output_ = folder_output_param_
folder_input_ = folder_input_param_
HER_list_ = HER_param_

annees_learnModels_ = annees_learnModels_param_
annees_validModels_ = annees_validModels_param_

### Run ###
cor_ <- data.frame()

# Fonction pour obtenir les dates dans l'intervalle (J-5):(J-1) pour une date donnée
get_interval <- function(date) {
  interval <- seq(date-5, date, by="day")
  return(interval)
}

# noms_stations_ = c("I205103002","I361206001","I403201001","I692301001","I532151001","I402201001")



liste <- list.files(paste0(folder_input_,"StationsSelectionnees/SelectionCsv/SelectionCsv_",nom_selectStations_),pattern="Stations_HYDRO_KGES", full.names = T)
list_stations_ = liste[1]
tab_list_stations_ = read.table(list_stations_, sep = ";", dec = ".", header = T)

HER_list_ = HER_param_
#HER_list_ = c(31033039,37055,69096)

for (HER_ in HER_list_){
  
  print(HER_)
  
  # if (file.exists(paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/FlowDurationCurves_ChroniquesParHer/Present/FDCChroHER_Obs_2_PresentMesures_HERh_TsKGE_JonctionHER_2012_2022_20230512/ChroniqueFDC_KGESUp0.00_DispSup-1_Obs_HER",HER_,".csv"))){
  #   file_ <- paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/FlowDurationCurves_ChroniquesParHer/Present/FDCChroHER_Obs_2_PresentMesures_HERh_TsKGE_JonctionHER_2012_2022_20230512/ChroniqueFDC_KGESUp0.00_DispSup-1_Obs_HER",HER_,".csv")
  #   tab_ <- read.table(file_, sep = ";", dec = ".", header = T)
  #   if (ncol(tab_) == 1){
  #     tab_ <- read.table(file_, sep = ",", dec = ".", header = T)
  #   }
  #   # print("File exists")
  # }
  
  if (file.exists(paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/FlowDurationCurves_ChroniquesParHer/Present/FDCChroHer_Obs_1_PresentMesures_HERh_TsKGE_PremierRun_2012_2022_20230417/ChroniqueFDC_KGESUp0.00_DispSup-1_Obs_HER",HER_,".csv"))){
    file_ <- paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/FlowDurationCurves_ChroniquesParHer/Present/FDCChroHer_Obs_1_PresentMesures_HERh_TsKGE_PremierRun_2012_2022_20230417/ChroniqueFDC_KGESUp0.00_DispSup-1_Obs_HER",HER_,".csv")
    tab_ <- read.table(file_, sep = ";", dec = ".", header = T)
    if (ncol(tab_) == 1){
      tab_ <- read.table(file_, sep = ",", dec = ".", header = T)
    }
    # print("File exists")
  }
  
  #input_mat_ <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/1_PresentMesures_HERh_TsKGE_TtesStat_2012_2022_20230417/MatInputModel_ByHERDates__2012_2022_KGESUp0.00_DispSup-1_Obs_Weight_AllStations.csv"
  input_mat_ <- list.files(paste0(folder_output_,"1_MatricesInputModeles_ParHERDates/",nomSim_), full.names = T)
  input_mat_ <- input_mat_[which(grepl(".csv",input_mat_))]
  #tab_input_ <- read.table(input_mat_, sep = ";", dec = ".", header = T)
  tab_input_ <- read.table(input_mat_, sep = ",", dec = ".", header = T)
  if (dim(tab_input_)[2] == 1){
    tab_input_ <- read.table(input_mat_, sep = ";", dec = ".", header = T)
  }
  tab_input_ <- tab_input_[which(tab_input_$HER2 == HER_),]
  
  if (dim(tab_input_)[1] > 0){
    # print("Inside if")
    
    # Convertir les chaînes de caractères en objets de classe Date
    dates <- as.Date(tab_input_$Date, format = "%Y-%m-%d")
    
    # Appliquer la fonction à chaque date du vecteur
    intervals <- lapply(dates, get_interval)
    all_dates <- unlist(intervals)
    date_strings <- format(as.Date(all_dates, origin="1970-01-01"), "%Y-%m-%d")
    
    tab_ <- tab_[which(tab_$Date %in% date_strings),]
    tab_$Annee <- lubridate::year(tab_$Date)
    tab_$Mois <- lubridate::month(tab_$Date)
    
    tab_data_ <- aggregate(. ~ Annee + Mois, data = tab_[,2:dim(tab_)[2]], FUN = mean) #On n'utilise pas na.action = NULL On n'exclut pas le mois pour le manque d'une seule date dans l'intervalle.
    # Pour la FDC moyenne, Nous sommes obliges de sortir les NA pour chaque date avant d'aggreger par mois. Sinon on exclut la station sur tout le mois. Ce n'est pas le choix fait dans le code original.
    # On enleve juste les prelevements manquants et on calcule le poids des stations chaque jour, pour ecarter ces prelevements manquants.
    # On ne peut donc pas utiliser la table tab_data_ pour la FDC moyenne, il faut utiliser la table complete, tab_
    tab_data_ <- tab_data_[order(tab_data_$Annee,tab_data_$Mois),]
    
    tab_input_$Annee <- lubridate::year(tab_input_$Date)
    tab_input_$Mois <- lubridate::month(tab_input_$Date)
    
    #tab_merge_ <- merge(tab_input_[,c("HER2","Date","X._Assec","Annee","Mois")],tab_data_, by = c("Annee", "Mois"))
    tab_merge_ <- merge(tab_input_[,c("HER2","Date","X._Assec","Annee","Mois","NbOutputONDEAssecs","NbOutputONDE")],tab_data_, by = c("Annee", "Mois"))
    
    # Retirer les dates avec des donnees ONDE incompletes
    print("RETRAIT DES DATES ONDE AVEC UN NOMBRE DE DONNEES REDUIT.")
    tab_merge_ <- tab_merge_[which(tab_merge_$NbOutputONDE > round(0.75*max(tab_merge_$NbOutputONDE))),]
    

    # Utiliser uniquement les stations de la liste de stations # 
    numColStat_ <- grep("flow", colnames(tab_merge_))
    numColStat_ <- which(grepl("flow", colnames(tab_merge_)) & (str_before_first(str_after_first(colnames(tab_merge_),"_"),"_") %in% tab_list_stations_$Code_short))
    
    # Controle que toutes les stations de la liste de station soit utilisees
    if (sum(!(tab_list_stations_$Code_short[which(tab_list_stations_[[paste0("eco",sprintf("%03d",HER_))]]>0)] %in% str_before_first(str_after_first(colnames(tab_merge_),"_"),"_"))>0)){
      stop("STOP")
    }
    
    # Weights
    tab_weight <- data.frame(t(tab_list_stations_[which(tab_list_stations_$Code_short %in% str_before_first(str_after_first(colnames(tab_merge_)[numColStat_],"_"),"_")),c("Code_short",paste0("eco",sprintf("%03d",HER_)))]))
    colnames(tab_weight) <- tab_weight[1,]
    tab_weight <- tab_weight[2,]
    
    # FDC moyenne et modele
    colnames(tab_merge_)[numColStat_] <- str_before_first(str_after_first(colnames(tab_merge_)[numColStat_],"_"),"_")
    
    if (sum(!(sort(colnames(tab_merge_)[numColStat_]) == sort(colnames(tab_weight))))>0){
      stop("Message personnalisé : Le nombre de stations des ponderations ne correspond pas au nombre de stations de la table. Attention aux stations dupliquees.")
    }
    
    # tab_merge_$FDCmoy = NA
    # for (l in 1:nrow(tab_merge_)){
    #   missing_cols <- which(is.na(colSums(tab_merge_[l,numColStat_])))
    #   numColStat_l_ <- numColStat_[which(numColStat_ != missing_cols)]
    #   tab_merge_$FDCmoy[l] <- sum(tab_merge_[i,numColStat_l_] * as.numeric(tab_weight[1,]))
    # }
    
    #tab_calc_ <- tab_# * tab_weight
    colnames(tab_)[2:(ncol(tab_)-2)] <- str_before_first(str_after_first(colnames(tab_)[2:(ncol(tab_)-2)],"_"),"_")
    tab_ = tab_[,c("Date","Annee","Mois",colnames(tab_)[which(colnames(tab_) %in% tab_list_stations_$Code_short)])]
    if (sum(!(sort(colnames(tab_[4:ncol(tab_)])) == sort(colnames(tab_weight))))>0){
      stop("Stop")
    }
    if (is.character(tab_weight)){
      tab_$FDCmoy = as.numeric(sapply(1:nrow(tab_), function(i) {sum(tab_[i,4:ncol(tab_)] * as.numeric(tab_weight[1]),na.rm = T)/(sum(as.numeric(tab_weight[1]) * (!is.na(tab_[i,4:ncol(tab_)]))))}))
    }else{
      tab_$FDCmoy = as.numeric(sapply(1:nrow(tab_), function(i) {sum(tab_[i,4:ncol(tab_)] * as.numeric(tab_weight[1,]),na.rm = T)/(sum(as.numeric(tab_weight[1,]) * (!is.na(tab_[i,4:ncol(tab_)]))))}))
    }
    tab_FDC_ <- aggregate(. ~ Annee + Mois, data = tab_[,c("Annee","Mois","FDCmoy")], FUN = mean) #On n'utilise pas na.action = NULL On n'exclut pas le mois pour le manque d'une seule date dans l'intervalle.
    tab_FDC_ <- tab_FDC_[order(tab_FDC_$Annee,tab_FDC_$Mois),]
    
    tab_merge_ <- merge(tab_merge_, tab_FDC_, by = c("Annee", "Mois"))
    
    
    # Split table Learn / Validation
    tab_valid_ <- tab_merge_[which(tab_merge_$Annee %in% annees_validModels_),]
    tab_merge_ <- tab_merge_[which(tab_merge_$Annee %in% annees_learnModels_),]
    
    
    #tab_merge_$FDCmoy <- as.numeric(sapply(1:nrow(tab_merge_), function(i) {sum(tab_merge_[i,numColStat_] * as.numeric(tab_weight[1,]))/sum(as.numeric(tab_weight[1,]))}))
    #tab_merge_$FDCmoy <- rowMeans(tab_merge_[,numColStat_])
    y = tab_merge_$X._Assec/100
    Reg = glm(y ~ tab_merge_$FDCmoy, family=binomial(link=logit))
    y_pred_logit = (exp(Reg$coef[2]*tab_merge_$FDCmoy+Reg$coef[1])/(1+exp(Reg$coef[2]*tab_merge_$FDCmoy+Reg$coef[1])))*100
    print(summary(Reg))
    
    df_ <- melt(tab_merge_[,c("Date","FDCmoy",colnames(tab_merge_)[numColStat_])], id.vars = "Date")
    df_ <- merge(df_, tab_merge_[,c("Date","X._Assec")], by = "Date")
    #df_$variable <- str_before_first(str_after_first(as.character(df_$variable),"_"),"_")
    df_ <- df_[order(df_$variable),]
    colnames(df_) <- c("Date", "variable", "FDC", "X._Assec")
    
    # Modele predictif par station
    tab_mod_ = tab_merge_[,c("Date","X._Assec","FDCmoy",colnames(tab_merge_)[numColStat_])]
    tab_mod_out_ = data.frame("Date" = tab_mod_$Date, "X._Assec" = tab_mod_$X._Assec)
    for (col in 3:dim(tab_mod_)[2]){
      Reg = glm(tab_mod_$X._Assec/100 ~ tab_mod_[,col], family=binomial(link=logit))
      tab_mod_out_[[paste0(colnames(tab_mod_)[col])]] = (exp(Reg$coef[2]*tab_mod_[,col]+Reg$coef[1])/(1+exp(Reg$coef[2]*tab_mod_[,col]+Reg$coef[1])))*100
    }
    df_pred_ <- melt(tab_mod_out_[,which(colnames(tab_mod_out_) != "X._Assec")], id.vars = "Date") #value = prediction
    colnames(df_pred_) <- c("Date", "variable", "prediction")
    #df_pred_$variable <- str_before_first(str_after_first(as.character(df_pred_$variable),"_"),"_")
    df_merge_ <- merge(df_, df_pred_, by = c("Date","variable"))
    df_merge_ <- df_merge_[order(df_merge_$variable),]
    df_merge_$size_col_ <- ifelse(df_merge_$variable == "FDCmoy", 5, 1)
    df_merge_$variable <- gsub("FDCmoy", "FDC moyenne de l'HER", df_merge_$variable)
    
    # Graph parameters
    size_ = c(5,rep(0.5,length(numColStat_)))
    df_merge_max <- df_merge_ %>%
      group_by(variable) %>%
      slice(which.max(prediction))
    
    # Add weights
    tab_weight_etiquettes_ <- data.frame(t(tab_weight))
    colnames(tab_weight_etiquettes_) <- "weight"
    tab_weight_etiquettes_$variable <-rownames(tab_weight_etiquettes_)
    df_merge_max_etiquette_ <- merge(df_merge_max,tab_weight_etiquettes_, by = "variable", all.x = T)
    df_merge_max_etiquette_$etiquette_ <- ifelse(is.na(df_merge_max_etiquette_$weight), df_merge_max_etiquette_$variable, paste0(df_merge_max_etiquette_$variable," ",round(as.numeric(df_merge_max_etiquette_$weight)*100,1),"%"))
    
    # Creer une couleur par station
    # color_list <- brewer.pal(length(numColStat_)+1, "RdYlBu")
    color_list <- viridis(length(numColStat_)+1)
    
    png(paste0(folder_output_,"13_Graphes_CalageModele_FDCAssecs_ParHERetParStations/",nomSim_,"/Valid",annees_validModels_,"/GrapheModParHERetParStat_HER_",HER_,"_Valid",annees_validModels_,"_logit.png"),
        width = 1200, height = 750,
        units = "px", pointsize = 12)
    # x11()
    p <- ggplot(df_merge_, aes(x = FDC, y = X._Assec/100, color = variable)) +
      #geom_point() +
      geom_line(data = df_merge_, aes(x = FDC, y = prediction/100, color = variable, size = size_col_)) +
      #geom_line(data = df_merge_, aes(x = FDC, y = prediction/100, color = variable, size = size_col_)) +
      #geom_line(data = df_merge_, aes(x = FDC, y = prediction/100, color = variable, size = variable)) +
      scale_color_manual(values = color_list) +
      
      geom_point(data = tab_merge_, aes(x = FDCmoy, y = X._Assec/100), color = "#e34a33", size = 4) +
      geom_point(data = tab_valid_, aes(x = FDCmoy, y = X._Assec/100), color = "#3182bd", size = 4) +
      geom_text_repel(data = tab_merge_, aes(x = FDCmoy, y = X._Assec/100, label = paste0(Mois,"/",Annee)), color = "#e34a33", size = 4) +
      geom_text_repel(data = tab_valid_, aes(x = FDCmoy, y = X._Assec/100, label = paste0(Mois,"/",Annee)), color = "#3182bd", size = 4) +
      
      #scale_size_manual(values = df_merge_$size_col_) +
      labs(x = "FDC Moyen", y = "Pourcentage d'assecs") +
      xlim(-0.1,1) +
      ggtitle(paste0("Modèles de prédiction par station du pourcentage d'assec de l'HER ",HER_)) +
      geom_text_repel(data = df_merge_max_etiquette_,
                      aes(x = FDC, y = prediction/100, label = etiquette_),
                      size = 3, # définir la taille de la police
                      nudge_x = -0.1, # ajuster la position horizontale du texte
                      direction = "y",
                      segment.linetype = "dashed")+#, # orienter le texte horizontalement
      #segment.color = variable) + # supprimer les lignes reliant le texte aux points
      theme(legend.position = "none")
    print(p)
    dev.off()
    
  }
}


