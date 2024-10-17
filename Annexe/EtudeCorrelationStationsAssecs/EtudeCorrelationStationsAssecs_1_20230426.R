### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/4_RunsEtudeFrance_20230417/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")

### Librairies ###
library(stringr)
library(doParallel)
library(dplyr)
library(lubridate)


### Run ###
cor_ <- data.frame()

# Fonction pour obtenir les dates dans l'intervalle (J-5):(J-1) pour une date donnée
get_interval <- function(date) {
  interval <- seq(date-5, date-1, by="day")
  return(interval)
}



for (HER_ in HER_param_){

  print(HER_)
  
  if (file.exists(paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/FlowDurationCurves_ChroniquesParHer/Present/FDCChroHer_Obs_1_PresentMesures_HERh_TsKGE_PremierRun_2012_2022_20230417/ChroniqueFDC_KGESUp0.00_DispSup-1_Obs_HER",HER_,".csv"))){
    file_ <- paste0("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/FlowDurationCurves_ChroniquesParHer/Present/FDCChroHer_Obs_1_PresentMesures_HERh_TsKGE_PremierRun_2012_2022_20230417/ChroniqueFDC_KGESUp0.00_DispSup-1_Obs_HER",HER_,".csv")
    tab_ <- read.table(file_, sep = ";", dec = ".", header = T)
    # print("File exists")
  }
  
  input_mat_ <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/1_PresentMesures_HERh_TsKGE_PremierRun_2012_2022_20230417/MatInputModel_ByHERDates__2012_2022_KGESUp0.00_DispSup-1_Obs_Weight_AllStations.csv"
  tab_input_ <- read.table(input_mat_, sep = ";", dec = ".", header = T)
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
    
    tab_merge_ <- merge(tab_input_[,c("HER2","Date","X._Assec","Annee","Mois")],tab_data_, by = c("Annee", "Mois"))
    
    ### Correlation ###
    for (c in 6:dim(tab_merge_)[2]){
      cor_[dim(cor_)[1]+1,1] <- HER_
      cor_[dim(cor_)[1],2] <- colnames(tab_merge_)[c]
      cor_[dim(cor_)[1],3] <- cor(tab_merge_$X._Assec,tab_merge_[,c])
    }
  }
}

colnames(cor_) <- c("HER","Station","Cor")
#HER_ <- 12

#~write.table(cor_, "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/3_ChroniquesAssecs_ParHer/1_PresentMesures_HERh_TsKGE_PremierRun_2012_2022_20230417/Correlations/CorrelationStationsAssecs_1_20230426.csv", sep = ";", dec = ".", row.names = F)





### Verifier que toutes les correlations aient ete calculees a partir de la liste de selection des stations SelectionCsv ###
file_selec_ <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_1_PresentMesures_HERh_TsKGE_PremierRun_2012_2022_20230417/Stations_HYDRO_KGESUp0.00_DispSup-1.csv"
tab_selec_ <- read.table(file_selec_, sep = ";", dec = ".", header = T)
colSums(tab_selec_[,grep("eco0|eco1",colnames(tab_selec_))])
sum(colSums(tab_selec_[,grep("eco0|eco1",colnames(tab_selec_))]>0))

tab_selec_eco_ <- tab_selec_[,grep("eco0|eco1",colnames(tab_selec_))]>0
rownames(tab_selec_eco_) <- tab_selec_$Code


# On crée une matrice à partir des données
tab_selec_eco_ <- as.matrix(tab_selec_eco_)

# On crée un vecteur de noms de colonnes et un vecteur de noms de lignes
noms_colonnes <- colnames(tab_selec_eco_)
noms_lignes <- rownames(tab_selec_eco_)

# On crée une liste vide pour stocker les combinaisons
combinaisons <- data.frame()

# On parcourt toutes les combinaisons possibles de lignes et de colonnes
for (i in 1:nrow(tab_selec_eco_)) {
  for (j in 1:ncol(tab_selec_eco_)) {
    if (tab_selec_eco_[i,j]) {
      combinaisons[dim(combinaisons)[1]+1,1] <- c(noms_lignes[i])
      combinaisons[dim(combinaisons)[1],2] <- c(noms_colonnes[j])
    }
  }
}
colnames(combinaisons) <- c("Station","HER")
# On affiche la liste des combinaisons
print(combinaisons)


cor_str_ <- paste0(cor_$HER,"_",substr(cor_$Station,6,15))
comb_str_ <- paste0(as.numeric(substr(combinaisons$HER,4,6)),"_",substr(combinaisons$Station,1,10))

setdiff(cor_str_,comb_str_)
setdiff(comb_str_,cor_str_)
# Le fichier des stations selectionnees contient plus de stations que la matrice input.
# L'HER 0 n'est pas representee dans la matrice input car hors frontieres.
# L'HER 10 n'est pas representee dans la matrice input car cette HER n'a aucune observation ONDE.


### Etude des correlations ###

cor_[rev(order(cor_$Cor)),]

cor_$Code_short <- substr(cor_$Station,6,15)
tab_selec_$Code_short <- substr(tab_selec_$Code,1,10)
cor_merge_ <- merge(cor_, tab_selec_, by = "Code_short")

write.table(cor_merge_[rev(order(cor_merge_$Cor)),], "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/3_ChroniquesAssecs_ParHer/1_PresentMesures_HERh_TsKGE_PremierRun_2012_2022_20230417/Correlations/CorrelationStationsAssecs_DescriptifStations_1_20230427.csv", sep = ";", dec = ".", row.names = F)

cor_merge_[,c("Station","Cor","Impact_local")]

library(ggplot2)


# Créer le graphe
png(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/3_ChroniquesAssecs_ParHer/1_PresentMesures_HERh_TsKGE_PremierRun_2012_2022_20230417/Correlations/Boxplots_CorrelationParImpact_SimFr1_20230427.png"),
    width = 1200, height = 750,
    units = "px", pointsize = 12)
ggplot(cor_merge_, aes(x=Impact_local, y=Cor)) +
  geom_boxplot() +
  labs(title="Corrélation des FDC des stations avec les probabilités d'assec de leur HER hybride", x="Impact local", y="Corrélation")
dev.off()






