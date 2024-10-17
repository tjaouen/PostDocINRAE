

list_ <- list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/2_ResultatsModeles_ParHer/5_PresentMesures_HERh_TsKGE_TtesStat_SensibiliteIntervalleJours_2012_2022_20230428/Tables_Resultats/", full.names = T)
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

# tab_j_ <- tab_merge_[,which(grepl("KGE",colnames(tab_merge_)) & grepl("_j_",colnames(tab_merge_)))]
# tab_m1_ <- tab_merge_[,which(grepl("KGE",colnames(tab_merge_)) & grepl("_m1_",colnames(tab_merge_)))]
# tab_m2_ <- tab_merge_[,which(grepl("KGE",colnames(tab_merge_)) & grepl("_m2_",colnames(tab_merge_)))]
# tab_m3_ <- tab_merge_[,which(grepl("KGE",colnames(tab_merge_)) & grepl("_m3_",colnames(tab_merge_)))]
# tab_m4_ <- tab_merge_[,which(grepl("KGE",colnames(tab_merge_)) & grepl("_m4_",colnames(tab_merge_)))]
# tab_m5_ <- tab_merge_[,which(grepl("KGE",colnames(tab_merge_)) & grepl("_m5_",colnames(tab_merge_)))]

for (line_ in tab_merge_$HER){
  
  print(line_)
  
  tab_line_j_ <- data.frame(x = 0:5, X1 = t(rev(tab_j_[line_,])))
  colnames(tab_line_j_) <- c("J","KGE")
  tab_line_m1_ <- data.frame(x = 0:4, X1 = t(rev(tab_m1_[line_,])))
  colnames(tab_line_m1_) <- c("J","KGE")
  tab_line_m2_ <- data.frame(x = 0:3, X1 = t(rev(tab_m2_[line_,])))
  colnames(tab_line_m2_) <- c("J","KGE")
  tab_line_m3_ <- data.frame(x = 0:2, X1 = t(rev(tab_m3_[line_,])))
  colnames(tab_line_m3_) <- c("J","KGE")
  tab_line_m4_ <- data.frame(x = 0:1, X1 = t(rev(tab_m4_[line_,])))
  colnames(tab_line_m4_) <- c("J","KGE")
  tab_line_m5_ <- data.frame(x = 0:0, X1 = tab_m5_[line_])
  colnames(tab_line_m5_) <- c("J","KGE")
  
  x11()
  # png(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/2_ResultatsModeles_ParHer/5_PresentMesures_HERh_TsKGE_TtesStat_SensibiliteIntervalleJours_2012_2022_20230428/Graphes/GrapheSensiIntervalleJours_HER",line_,".png"),
  #     width = 1200, height = 750,
  #     units = "px", pointsize = 12)
  p <- ggplot()+
    geom_line(data = tab_line_j_, aes(x = J, y = KGE), color = "#a50f15")+
    geom_point(data = tab_line_j_[1:(dim(tab_line_j_)[1]-1),], aes(x = J, y = KGE), color = "#a50f15", size = 8, shape = "\u25C4")+
    geom_linerange(data = tab_line_j_[dim(tab_line_j_)[1],], aes(x = J, ymin = KGE - 0.01, ymax = KGE + 0.01), color = "#a50f15", size = 1)+
    
    geom_line(data = tab_line_m1_, aes(x = J, y = KGE), color = "#de2d26")+
    geom_point(data = tab_line_m1_[1:(dim(tab_line_m1_)[1]-1),], aes(x = J, y = KGE), color = "#de2d26", size = 8, shape = "\u25C4")+
    geom_linerange(data = tab_line_m1_[dim(tab_line_m1_)[1],], aes(x = J, ymin = KGE - 0.01, ymax = KGE + 0.01), color = "#de2d26", size = 1)+
    
    geom_line(data = tab_line_m2_, aes(x = J, y = KGE), color = "#fb6a4a")+
    geom_point(data = tab_line_m2_[1:(dim(tab_line_m2_)[1]-1),], aes(x = J, y = KGE), color = "#fb6a4a", size = 8, shape = "\u25C4")+
    geom_linerange(data = tab_line_m2_[dim(tab_line_m2_)[1],], aes(x = J, ymin = KGE - 0.01, ymax = KGE + 0.01), color = "#fb6a4a", size = 1)+
    
    geom_line(data = tab_line_m3_, aes(x = J, y = KGE), color = "#fc9272")+
    geom_point(data = tab_line_m3_[1:(dim(tab_line_m3_)[1]-1),], aes(x = J, y = KGE), color = "#fc9272", size = 8, shape = "\u25C4")+
    geom_linerange(data = tab_line_m3_[dim(tab_line_m3_)[1],], aes(x = J, ymin = KGE - 0.01, ymax = KGE + 0.01), color = "#fc9272", size = 1)+
    
    geom_line(data = tab_line_m4_, aes(x = J, y = KGE), color = "#fcbba1")+
    geom_point(data = tab_line_m4_[1:(dim(tab_line_m4_)[1]-1),], aes(x = J, y = KGE), color = "#fcbba1", size = 8, shape = "\u25C4")+
    geom_linerange(data = tab_line_m4_[dim(tab_line_m4_)[1],], aes(x = J, ymin = KGE - 0.01, ymax = KGE + 0.01), color = "#fcbba1", size = 1)+
    
    geom_point(data = tab_line_m5_, aes(x = J, y = KGE), color = "#fee5d9")+
    ylim(0.5,1)+
    xlab('')+
    ylab('KGE')+
    theme_bw()
  p
  
  # Récupérer les données pour la ligne noire
  data_j <- ggplot_build(p)$data[[1]]
  
  # Ajouter les flèches
  p + geom_segment(data = data_j[-nrow(data_j), ], 
                   aes(x = x, y = y, xend = x + 1, yend = y, color = "black"), 
                   arrow = arrow(length = unit(0.2,"cm"), type = "closed")) +
    scale_color_manual(name = "", values = c("black" = "black", "pink" = "pink", "brown" = "brown", 
                                                     "yellow" = "yellow", "blue" = "blue", "red" = "red"))
                                                     
  
  print(p)
  dev.off()
}

#geom_line(data = tab_j_[line_,], x = 0:5, y = line_)


library(ggplot2)

# Créer un dataframe de données fictives
df <- data.frame(x = 1:10, y = rnorm(10))

# Utiliser ggplot pour créer un graphique avec des points en forme de triangle tourné vers la gauche
ggplot(df, aes(x = x, y = y)) +
  geom_point(shape = "\u25C4", size = 4, color = "black")













#Lame eau = Volume par surface bassin versant.

