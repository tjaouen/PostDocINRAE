library(strex)
library(ggplot2)

#list_ <- list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/2_ResultatsModeles_ParHer/5_PresentMesures_HERh_TsKGE_TtesStat_SensibiliteIntervalleJours_2012_2022_20230428/Tables_Resultats/", full.names = T)
list_ <- list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/2_ResultatsModeles_ParHer/12_PresentMesures_HERh_TsKGE_TtesStat_SensiIntJoursV2_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230523/Tables_Resultats/", full.names = T)
list_ <- list_[which(grepl("logit", list_) & grepl("ModelResults", list_))]

tab_list_ <- data.frame(ID = str_before_first(str_after_first(basename(list_), "_"), "_"),
                        Depart = substr(str_before_nth(str_before_first(str_after_first(basename(list_), "_"), "_"),"J",2),2,length(str_before_nth(str_before_first(str_after_first(basename(list_), "_"), "_"),"J",2))),
                        Fin = str_after_nth(str_before_first(str_after_first(basename(list_), "_"), "_"),"J",2),
                        file_ = list_)


tab_merge_ = data.frame()
for (l in 1:dim(tab_list_)[1]){
  tab_ <- read.table(tab_list_$file_[l], sep = ";", dec = ".", header = T)
  colnames(tab_) <- c("HER",paste0(tab_list_$Depart[l],"_",tab_list_$Fin[l],"_",colnames(tab_)[2:length(colnames(tab_))]))
  
  if (l == 1){
    tab_merge_ <- tab_
  }else{
    tab_merge_ <- merge(tab_merge_, tab_, by = "HER")
  }
}

tab_KGE_ <- tab_merge_[,which(grepl("KGE",colnames(tab_merge_)))]

#write.table(tab_KGE_, "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/2_ResultatsModeles_ParHer/12_PresentMesures_HERh_TsKGE_TtesStat_SensiIntJoursV2_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230523/KGE_IntervallesTemps_1_20230524.csv", dec = ".", sep  = ";", row.names = F)


# Créer un vecteur de valeurs possibles pour la variable dep_
val_possibles <- c("j", "m1", "m2", "m3", "m4", "m5", "m6", "m7", "m8", "m9", "m10")
val_remplacees <- c(0, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10)
# val_possibles <- c("j", "m1", "m2", "m3", "m4", "m5")
# val_remplacees <- c(0, -1, -2, -3, -4, -5)
ind_intervalle_max <- c()

for (line_ in 1:length(tab_merge_$HER)){
  
  print(line_)
  
  # png(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/2_ResultatsModeles_ParHer/5_PresentMesures_HERh_TsKGE_TtesStat_SensibiliteIntervalleJours_2012_2022_20230428/Graphes_ComparaisonIntervalles_v2_20230428/GrapheSensiIntervalleJours_HER",tab_merge_$HER[line_],".png"),
  png(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/2_ResultatsModeles_ParHer/12_PresentMesures_HERh_TsKGE_TtesStat_SensiIntJoursV2_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230523/Graphes_ComparaisonIntervalles_v1_20230523/GrapheSensiIntervalleJours_HER",tab_merge_$HER[line_],".png"),
      width = 1200, height = 750,
      units = "px", pointsize = 12)
  # x11()
  p <- ggplot()+
    ylim(min(tab_KGE_[line_,])-0.05,
         max(tab_KGE_[line_,])+0.05)+
    xlim(-11,1)+
    #xlim(-6,1)+
    ylab('KGE')+
    xlab('')+
    theme_bw()
  
  for (int in 1:length(colnames(tab_KGE_))){
    dep_ = str_before_first(colnames(tab_KGE_)[int], "_")
    arr_ = str_before_first(str_after_first(colnames(tab_KGE_)[int],"_"),"_")
    dep_ <- ifelse(!is.na(match(dep_, val_possibles)), val_remplacees[match(dep_, val_possibles)], dep_)
    arr_ <- ifelse(!is.na(match(arr_, val_possibles)), val_remplacees[match(arr_, val_possibles)], dep_)
    tab_int_ <- data.frame(dep_ = dep_, arr_ = arr_, KGE = tab_KGE_[line_, int])
    
    if (dep_ == arr_){
      # print(paste0("Dep = ",dep_, " Arr = ", arr_, " y = ", tab_KGE_[line_, int]))
      p <- p +
        geom_point(data = tab_int_, aes(x = dep_, y = KGE), color = "black")
    }else{
      # print(paste0("Dep = ",dep_, " Arr = ", arr_, " y = ", tab_KGE_[line_, int]))
      p <- p +
        geom_segment(data = tab_int_, aes(x = dep_, xend = arr_, y = KGE, yend = KGE))
    }
    
  }
  print(p)
  dev.off()
  
  ind_intervalle_max[line_] = list(which(tab_KGE_[line_,] == max(tab_KGE_[line_,])))
  
}

for (int in 1:length(colnames(tab_KGE_))){
  dep_ = str_before_first(colnames(tab_KGE_)[int], "_")
  arr_ = str_before_first(str_after_first(colnames(tab_KGE_)[int],"_"),"_")
  dep_ <- ifelse(!is.na(match(dep_, val_possibles)), val_remplacees[match(dep_, val_possibles)], dep_)
  arr_ <- ifelse(!is.na(match(arr_, val_possibles)), val_remplacees[match(arr_, val_possibles)], dep_)
  
  colnames(tab_KGE_)[int] = paste0("[j",ifelse(dep_==0,"",dep_),";j",ifelse(arr_==0,"",arr_),"]")
  
  # if (dep_ == 0){
  #   if (arr_ == 0){
  #     colnames(tab_KGE_)[int] = "[j:j]"
  #   }else{
  #     colnames(tab_KGE_)[int] = paste0("[j:j-",arr_,"]")
  #   }
  # }else{
  #   if (arr_ == 0){
  #     colnames(tab_KGE_)[int] = paste0("[j",dep_,":j]")
  #   }else{
  #     colnames(tab_KGE_)[int] = paste0("[j",dep_,":j",arr_,"]")
  #   }
  # }
}



# tab_merge_$HER[which(ind_intervalle_max == 16)]
# ind_intervalle_max[which(tab_merge_$HER == 41)]
# colnames(tab_KGE_)[11]
# 
# tab_KGE_[23,]

#df_ = data.frame(table(ind_intervalle_max))
df_ = data.frame(table(unlist(ind_intervalle_max)))
colnames(df_) <- c("ind_intervalle_max","Freq")
#colnames(tab_KGE_)
# names_ <- c("[j;j]",
#             "[j-1;j]","[j-1;j-1]",
#             "[j-2;j]","[j-2;j-1]","[j-2;j-2]",
#             "[j-3;j]","[j-3;j-1]","[j-3;j-2]","[j-3;j-3]",
#             "[j-4;j]","[j-4;j-1]","[j-4;j-2]","[j-4;j-3]","[j-4;j-4]",
#             "[j-5;j]","[j-5;j-1]","[j-5;j-2]","[j-5;j-3]","[j-5;j-4]","[j-5;j-5]",
#             "[j-6;j]","[j-6;j-1]","[j-6;j-2]","[j-6;j-3]","[j-6;j-4]","[j-6;j-5]","[j-6;j-6]",
#             "[j-7;j]","[j-7;j-1]","[j-7;j-2]","[j-7;j-3]","[j-7;j-4]","[j-7;j-5]","[j-7;j-6]","[j-7;j-7]",
#             "[j-8;j]","[j-8;j-1]","[j-8;j-2]","[j-8;j-3]","[j-8;j-4]","[j-8;j-5]","[j-8;j-6]","[j-8;j-7]","[j-8;j-8]",
#             "[j-9;j]","[j-9;j-1]","[j-9;j-2]","[j-9;j-3]","[j-9;j-4]","[j-9;j-5]","[j-9;j-6]","[j-9;j-7]","[j-9;j-8]","[j-9;j-9]",
#             "[j-10;j]","[j-10;j-1]","[j-10;j-2]","[j-10;j-3]","[j-10;j-4]","[j-10;j-5]","[j-10;j-6]","[j-10;j-7]","[j-10;j-8]","[j-10;j-9]","[j-10;j-10]")
names_ <- colnames(tab_KGE_)

# Création d'un data frame contenant toutes les valeurs de 1 à 21
all_vals <- data.frame(ind_intervalle_max = 1:66)
#all_vals <- data.frame(ind_intervalle_max = 1:21)

# Fusionner avec la table existante en utilisant une jointure externe à gauche (left join)
df_new <- merge(all_vals, df_, by = "ind_intervalle_max", all.x = TRUE)

# Remplacer les NA par des 0 dans la colonne "Freq"
df_new$Freq[is.na(df_new$Freq)] <- 0

# Réorganiser les colonnes dans l'ordre initial
df_new <- df_new[, c("ind_intervalle_max", "Freq")]
df_new$names <- names_
levels_ <- c("[j;j]",
             "[j-1;j]",
             "[j-2;j]",
             "[j-3;j]",
             "[j-4;j]",
             "[j-5;j]",
             "[j-6;j]",
             "[j-7;j]",
             "[j-8;j]",
             "[j-9;j]",
             "[j-10;j]",
             
             "[j-1;j-1]",
             "[j-2;j-1]",
             "[j-3;j-1]",
             "[j-4;j-1]",
             "[j-5;j-1]",
             "[j-6;j-1]",
             "[j-7;j-1]",
             "[j-8;j-1]",
             "[j-9;j-1]",
             "[j-10;j-1]",
             
             "[j-2;j-2]",
             "[j-3;j-2]",
             "[j-4;j-2]",
             "[j-5;j-2]",
             "[j-6;j-2]",
             "[j-7;j-2]",
             "[j-8;j-2]",
             "[j-9;j-2]",
             "[j-10;j-2]",
             
             "[j-3;j-3]",
             "[j-4;j-3]",
             "[j-5;j-3]",
             "[j-6;j-3]",
             "[j-7;j-3]",
             "[j-8;j-3]",
             "[j-9;j-3]",
             "[j-10;j-3]",
             
             "[j-4;j-4]",
             "[j-5;j-4]",
             "[j-6;j-4]",
             "[j-7;j-4]",
             "[j-8;j-4]",
             "[j-9;j-4]",
             "[j-10;j-4]",
             
             "[j-5;j-5]",
             "[j-6;j-5]",
             "[j-7;j-5]",
             "[j-8;j-5]",
             "[j-9;j-5]",
             "[j-10;j-5]",
             
             "[j-6;j-6]",
             "[j-7;j-6]",
             "[j-8;j-6]",
             "[j-9;j-6]",
             "[j-10;j-6]",
             
             "[j-7;j-7]",
             "[j-8;j-7]",
             "[j-9;j-7]",
             "[j-10;j-7]",
             
             "[j-8;j-8]",
             "[j-9;j-8]",
             "[j-10;j-8]",
             
             "[j-9;j-9]",
             "[j-10;j-9]",
             
             "[j-10;j-10]")
df_new$names <- factor(df_new$names, levels = levels_)

#x11()
#png("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/2_ResultatsModeles_ParHer/5_PresentMesures_HERh_TsKGE_TtesStat_SensibiliteIntervalleJours_2012_2022_20230428/Graphes_ComparaisonIntervalles_v2_20230428/BarplotDensiteKGEmax_ParIntervalleTemps_1_20230428.png",
png("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/2_ResultatsModeles_ParHer/5_PresentMesures_HERh_TsKGE_TtesStat_SensibiliteIntervalleJours_2012_2022_20230428/Graphes_ComparaisonIntervalles_v2_20230428/BarplotDensiteKGEmax_ParIntervalleTemps_1_20230524.png",
#png("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/2_ResultatsModeles_ParHer/12_PresentMesures_HERh_TsKGE_TtesStat_SensiIntJoursV2_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230523/Graphes_ComparaisonIntervalles_v1_20230523/BarplotDensiteKGEmax_ParIntervalleTemps_1_20230523.png",
    width = 1200, height = 750,
    units = "px", pointsize = 12)
ggplot(data = df_new, aes(x = names, y = Freq)) +
  geom_bar(stat = "identity", fill = "#08519c") +
  labs(x = "Intervalle FDC", y = "Nombre de HER 2") +
  ggtitle("Distribution des HER selon l'intervalle de temps correspondant à leur KGE maximal") +
  scale_x_discrete(guide = guide_axis(n.dodge=3)) +
  theme_bw()
dev.off()




colnames(tab_KGE_)
tab_meanKGE_ <- data.frame(colMeans(tab_KGE_))
colnames(tab_meanKGE_) <- c("KGE")
tab_meanKGE_$names <- rownames(tab_meanKGE_)
tab_meanKGE_$names <- factor(tab_meanKGE_$names, levels = levels_)


png("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/2_ResultatsModeles_ParHer/12_PresentMesures_HERh_TsKGE_TtesStat_SensiIntJoursV2_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230523/Graphes_ComparaisonIntervalles_v1_20230523/BarplotMeanKGE_ParIntervalleTemps_1_20230524.png",
    width = 1200, height = 750,
    units = "px", pointsize = 12)
ggplot(data = tab_meanKGE_, aes(x = names, y = KGE)) +
  geom_bar(stat = "identity", fill = "#08519c") +
  labs(x = "Intervalle de mesure de la FDC", y = "KGE moyen") +
  ggtitle("KGE moyens selon les intervalles de temps utilises pour mesurer la FDC en entrée des modèles") +
  #ylim(0.8,1) +
  coord_cartesian(ylim = c(0.7, 0.85)) +  # Spécifier les limites de l'axe y
  scale_x_discrete(guide = guide_axis(n.dodge=3)) +
  theme_bw()
dev.off()

#Lame eau = Volume par surface bassin versant.

