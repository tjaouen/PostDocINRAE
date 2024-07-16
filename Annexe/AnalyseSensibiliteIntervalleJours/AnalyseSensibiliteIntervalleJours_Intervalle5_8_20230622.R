library(strex)
library(ggplot2)

list_ <- list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/16_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_ValidParAnnees_SensiIntervJours_2012_2022_20230613/LeaveOneYearOut/Validation_Globale/", full.names = T)
#list_ <- list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/2_ResultatsModeles_ParHer/12_PresentMesures_HERh_TsKGE_TtesStat_SensiIntJoursV2_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230523/Tables_Resultats/", full.names = T)
list_ <- list_[which(grepl("logit", list_) & grepl("ModelResults", list_))]

tab_list_ <- data.frame(ID = str_before_first(str_after_first(basename(list_), "_"), "_"),
                        Depart = substr(str_before_nth(str_before_first(str_after_nth(basename(list_), "__", 2), "_"),"J",2),2,length(str_before_nth(str_before_first(str_after_nth(basename(list_), "__", 2), "_"),"J",2))),
                        Fin = str_after_nth(str_before_first(str_after_nth(basename(list_), "__", 2), "_"),"J",2),
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
  png(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/16_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_ValidParAnnees_SensiIntervJours_2012_2022_20230613/LeaveOneYearOut/Validation_Globale/SensiJours/GrapheSensiIntervalleJours_HER",tab_merge_$HER[line_],".png"),
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
  
  if (grepl("sup",colnames(tab_KGE_)[int])){
    colnames(tab_KGE_)[int] = paste0("[j",ifelse(dep_==0,"",dep_),";j",ifelse(arr_==0,"",arr_),"]_sup")
  }else if (grepl("inf",colnames(tab_KGE_)[int])){
    colnames(tab_KGE_)[int] = paste0("[j",ifelse(dep_==0,"",dep_),";j",ifelse(arr_==0,"",arr_),"]_inf")
  }else{
    colnames(tab_KGE_)[int] = paste0("[j",ifelse(dep_==0,"",dep_),";j",ifelse(arr_==0,"",arr_),"]")
  }

}


# df_ = data.frame(table(unlist(ind_intervalle_max)))
# colnames(df_) <- c("ind_intervalle_max","Freq")
# names_ <- colnames(tab_KGE_)
# 
# # Création d'un data frame contenant toutes les valeurs de 1 à 21
# all_vals <- data.frame(ind_intervalle_max = 1:21)
# 
# # Fusionner avec la table existante en utilisant une jointure externe à gauche (left join)
# df_new <- merge(all_vals, df_, by = "ind_intervalle_max", all.x = TRUE)
# 
# # Remplacer les NA par des 0 dans la colonne "Freq"
# df_new$Freq[is.na(df_new$Freq)] <- 0
# 
# # Réorganiser les colonnes dans l'ordre initial
# df_new <- df_new[, c("ind_intervalle_max", "Freq")]
# df_new$names <- names_
# df_new$names <- factor(df_new$names, levels = c("[j;j]",
#                                                 "[j-1;j]",
#                                                 "[j-2;j]",
#                                                 "[j-3;j]",
#                                                 "[j-4;j]",
#                                                 "[j-5;j]",
#                                                 "[j-6;j]",
#                                                 "[j-7;j]",
#                                                 "[j-8;j]",
#                                                 "[j-9;j]",
#                                                 "[j-10;j]"))#,
# 
# png("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/16_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_ValidParAnnees_SensiIntervJours_2012_2022_20230613/LeaveOneYearOut/Validation_Globale/SensiJours/BarplotDensiteKGEmax_ParIntervalleTemps_1_20230613_a.png",
#     width = 1200, height = 750,
#     units = "px", pointsize = 12)
# ggplot(data = df_new, aes(x = names, y = Freq)) +
#   geom_bar(stat = "identity", fill = "#08519c") +
#   labs(x = "Intervalle FDC", y = "Nombre de HER 2") +
#   ggtitle("Distribution des HER selon l'intervalle de temps correspondant à leur KGE maximal") +
#   scale_x_discrete(guide = guide_axis(n.dodge=3)) +
#   theme_bw()
# dev.off()
# 
# colnames(tab_KGE_)
# colMeans(tab_KGE_)





means <- colMeans(na.omit(tab_KGE_))
minimums <- apply(na.omit(tab_KGE_), 2, min)
maximums <- apply(na.omit(tab_KGE_), 2, max)

means_val_ <- means[which(!(grepl("sup",names(tab_KGE_)) | grepl("inf",names(tab_KGE_))))]
means_val_ <- data.frame(means_val_)
means_val_$intervalle <- rownames(means_val_)

minimums <- minimums[which(grepl("inf",names(tab_KGE_)))]
minimums <- data.frame(minimums)
minimums$intervalle <- rownames(minimums)
minimums$intervalle_short <- paste0(str_before_first(minimums$intervalle,"]"),"]")

maximums <- maximums[which(grepl("sup",names(tab_KGE_)))]
maximums <- data.frame(maximums)
maximums$intervalle <- rownames(maximums)
maximums$intervalle_short <- paste0(str_before_first(maximums$intervalle,"]"),"]")

means_val_ <- merge(means_val_, minimums, by.x = "intervalle", by.y = "intervalle_short")
means_val_$intervalle_min = means_val_[,"intervalle.y"]
means_val_ <- means_val_[, c("intervalle", "means_val_", "minimums", "intervalle_min")]
means_val_ <- merge(means_val_, maximums, by.x = "intervalle", by.y = "intervalle_short")

ordre_specifie <- c("[j-1;j]", "[j-2;j]", "[j-3;j]", "[j-4;j]", "[j-5;j]", "[j-6;j]", "[j-7;j]", "[j-8;j]", "[j-9;j]", "[j-10;j]")
means_val_ <- means_val_[order(match(means_val_$intervalle, ordre_specifie)), ]

# x11()
# png("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/17_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrOubliHerJointes20212022etFonctionSeuilOnde_SensiIntervJours_2012_2022_20230614/LeaveOneYearOut/Validation_ParAnnees/SensibiliteJour/BarplotKGEdesHER_ParIntervalleTemps_1_20230616_b.png",
#     width = 1200, height = 750,
#     units = "px", pointsize = 12)
pSensi <- ggplot(means_val_, aes(x = factor(intervalle), y = means_val_)) +
  geom_boxplot(stat = "identity", fill = "steelblue", width = 0.6) +
  geom_errorbar(aes(ymin = minimums, ymax = maximums),
                width = 0.2, color = "black", size = 0.7) +
  labs(x = "Intervalle de temps", y = "KGE") +
  scale_x_discrete(guide = guide_axis(n.dodge=3)) +
  ggtitle(paste0("KGE - Validation en Leave One Year Out - Analyse de sensibilité des intervalles de temps de la FDC")) +
  theme_minimal() +
  theme(text = element_text(size = 16),
        plot.title = element_text(size = 30, hjust = 0.5))
print(pSensi)
dev.off()




tab_ <- tab_KGE_[which(!(grepl("sup",names(tab_KGE_)) | grepl("inf",names(tab_KGE_))))]
x11()
pSensi <- ggplot(tab_, aes(x = factor(intervalle), y = means_val_)) +
  geom_boxplot(stat = "identity", fill = "steelblue", width = 0.6) +
  geom_errorbar(aes(ymin = minimums, ymax = maximums),
                width = 0.2, color = "black", size = 0.7) +
  labs(x = "Intervalle de temps", y = "KGE") +
  scale_x_discrete(guide = guide_axis(n.dodge=3)) +
  ggtitle(paste0("KGE - Validation en Leave One Year Out - Analyse de sensibilité des intervalles de temps de la FDC")) +
  theme_minimal() +
  theme(text = element_text(size = 16),
        plot.title = element_text(size = 30, hjust = 0.5))
print(pSensi)



library(ggplot2)

# Les données de la table df sont déjà connues
df_long <- reshape2::melt(tab_)
ordre_specifie <- c("[j-1;j]", "[j-2;j]", "[j-3;j]", "[j-4;j]", "[j-5;j]", "[j-6;j]", "[j-7;j]", "[j-8;j]", "[j-9;j]", "[j-10;j]")
df_long <- df_long[order(match(df_long$variable, ordre_specifie)), ]
df_long$variable <- factor(df_long$variable, levels = ordre_specifie)

# Création du boxplot avec ggplot2
png("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/17_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrOubliHerJointes20212022etFonctionSeuilOnde_SensiIntervJours_2012_2022_20230614/LeaveOneYearOut/Validation_ParAnnees/SensibiliteJour/BarplotKGEdesHER_ParIntervalleTemps_1_20230616_c.png",
    width = 1200, height = 750,
    units = "px", pointsize = 12)
# x11()
p_KGE <- ggplot(df_long, aes(x = variable, y = value)) +
  geom_boxplot() +
  xlab("Intervalle") +
  ylab("KGE") +
  ggtitle("Kling-Gupta Efficiency (KGE)\nValidation en Leave One Year Out [J-6;J]") +
  theme(text = element_text(size = 20),
        # axis.line = element_blank(),
        # axis.text = element_blank(),
        # axis.title = element_blank(),
        # panel.background = element_blank(),
        plot.title = element_text(size = 30, hjust = 0.5))

print(p_KGE)
dev.off()




# tab_KGE_nonValidationCroisee_file = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/2_ResultatsModeles_ParHer/16_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_ValidParAnnees_SensiIntervJours_2012_2022_20230613/"
tab_KGE_nonValidationCroisee_file = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/2_ResultatsModeles_ParHer/17_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrOubliHerJointes20212022etFonctionSeuilOnde_SensiIntervJours_2012_2022_20230614/"
list_ <- list.files(tab_KGE_nonValidationCroisee_file, pattern = "logit", full.names = T)
#list_ <- list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/2_ResultatsModeles_ParHer/12_PresentMesures_HERh_TsKGE_TtesStat_SensiIntJoursV2_FiltreOndeManquantes_JonctionHER_SansImpactFortEtExclusionsES_2012_2022_20230523/Tables_Resultats/", full.names = T)
list_ <- list_[which(grepl("logit", list_) & grepl("ModelResults", list_))]

tab_list_ <- data.frame(ID = paste0("[J",str_before_first(str_after_first(basename(list_), "Jm"), "J"),";J",str_before_first(str_after_first(str_after_first(basename(list_),"Jm"),"J"),"_"),"]"),
                        Depart = str_before_first(str_after_first(basename(list_), "Jm"), "J"),
                        Fin = str_before_first(str_after_first(str_after_first(basename(list_),"Jm"),"J"),"_"),
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



# tab_KGE_nonValidationCroisee = read.table(tab_KGE_nonValidationCroisee_file, sep = ";", dec = ".", header = T)

df_long_nonValidationCroisee <- reshape2::melt(tab_merge_)
ordre_specifie <- c("[j-1;j]", "[j-2;j]", "[j-3;j]", "[j-4;j]", "[j-5;j]", "[j-6;j]", "[j-7;j]", "[j-8;j]", "[j-9;j]", "[j-10;j]")
df_long_nonValidationCroisee <- df_long_nonValidationCroisee[order(match(df_long_nonValidationCroisee$variable, ordre_specifie)), ]
df_long_nonValidationCroisee$variable <- factor(df_long_nonValidationCroisee$variable, levels = ordre_specifie)

# Création du boxplot avec ggplot2
x11()
ggplot(df_long, aes(x = variable, y = value)) +
  geom_boxplot() +
  xlab("Intervalle") +
  ylab("Valeur")


tab_melt_ = reshape2::melt(tab_)
ordre_specifie <- c("[j-1;j]", "[j-2;j]", "[j-3;j]", "[j-4;j]", "[j-5;j]", "[j-6;j]", "[j-7;j]", "[j-8;j]", "[j-9;j]", "[j-10;j]")
tab_melt_ <- tab_melt_[order(match(tab_melt_$variable, ordre_specifie)), ]
tab_melt_$variable <- factor(tab_melt_$variable, levels = ordre_specifie)

png("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/15_ResultatsModeles_ValidationParAnnees_ParHer/17_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrOubliHerJointes20212022etFonctionSeuilOnde_SensiIntervJours_2012_2022_20230614/LeaveOneYearOut/Validation_ParAnnees/SensibiliteJour/BarplotKGEdesHER_ParIntervalleTemps_1_20230616_d.png",
    width = 1200, height = 750,
    units = "px", pointsize = 12)
# x11()
p_KGE <- ggplot(tab_melt_, aes(x = variable, y = value)) +
  geom_boxplot() +
  # geom_hline(yintercept = 0, color = "red", linetype = "solid", size = 1) +
  geom_line(data = means_val_, mapping = aes(x = intervalle, y = minimums, group = 1),
            color = "black", linetype = "solid", size = 2) +
  geom_line(data = means_val_, mapping = aes(x = intervalle, y = maximums, group = 1),
            color = "black", linetype = "solid", size = 2) +
  xlab("Intervalle") +
  ylab("Valeur")
print(p_KGE)
dev.off()








