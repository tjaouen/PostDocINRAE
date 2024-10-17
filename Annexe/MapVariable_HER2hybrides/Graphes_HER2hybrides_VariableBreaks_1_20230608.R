### Libraries ###
library(ggplot2)
library(readxl)
require(maptools)
library(rgdal)
library(maps)
library(mapdata)
library(dplyr)
library(rgeos)
library(RColorBrewer)
library(fields)
library(scales)
library(strex)
library(gridExtra)
library(ggrepel)

### Function ###
plot_map_variable <- function(tab_, varname_, vartitle_, breaks_, output_name_, title_, reverseColors_, labels_name_ = FALSE){
  
  # labels_ <- paste0(ifelse(breaks_[-length(breaks_)] == min(breaks_[-length(breaks_)]), "[", "("),
  #                   round(breaks_[-length(breaks_)],2),",", round(breaks_[-1],2),"]")
  labels_ <- paste0(ifelse(breaks_[-length(breaks_)] == min(breaks_[-length(breaks_)]), "[", "("),
                    breaks_[-length(breaks_)],",", breaks_[-1],"]")
  # labels_[1] = paste0("Très variable\n",labels_[1])
  # labels_[length(labels_)] = paste0(labels_[length(labels_)],"\nPeu variable")
  
  if (labels_name_ == FALSE){
    # labels_name_ <- paste0(ifelse(breaks_[-length(breaks_)] == min(breaks_[-length(breaks_)]), "[", "("),
    #                        round(breaks_[-length(breaks_)],2),",", round(breaks_[-1],2),"]")
    labels_name_ <- paste0(ifelse(breaks_[-length(breaks_)] == min(breaks_[-length(breaks_)]), "[", "("),
                           breaks_[-length(breaks_)],",", breaks_[-1],"]")
    # labels_name_[1] = paste0("Très variable\n",labels_name_[1])
    # labels_name_[length(labels_name_)] = paste0(labels_name_[length(labels_name_)],"\nPeu variable")
  }else{
    # labels_name_ <- paste0(ifelse(labels_name_[-length(labels_name_)] == min(labels_name_[-length(labels_name_)]), "[", "("),
    #                        round(labels_name_[-length(labels_name_)],2),",", round(labels_name_[-1],2),"]")
    labels_name_ <- paste0(ifelse(labels_name_[-length(labels_name_)] == min(labels_name_[-length(labels_name_)]), "[", "("),
                           labels_name_[-length(labels_name_)],",", labels_name_[-1],"]")
    # labels_name_[1] = paste0("Très variable\n",labels_name_[1])
    # labels_name_[length(labels_name_)] = paste0(labels_name_[length(labels_name_)],"\nPeu variable")
  }
  
  ### Import HER2 ###
  fr.spdf <- readOGR("/home/tjaouen/Documents/Input/HER/HER2hybrides/Shapefile/","HER2_hybrides")
  proj4string(fr.spdf)=CRS("+proj=longlat +ellps=WGS84")
  fr.prj <- spTransform(fr.spdf, CRS("+init=epsg:2154")) # trasnformation en Lambert93
  
  ### Jonction ###
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 37)] = "37+55"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 55)] = "37+55"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 69)] = "69+96"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 96)] = "69+96"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 31)] = "31+33+39"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 33)] = "31+33+39"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 39)] = "31+33+39"
  
  fr.prj[[varname_]] = NA
  if (paste0(varname_,"_IC95inf") %in% colnames(tab_)){
    fr.prj[[paste0(varname_,"_IC95inf")]] = NA
    fr.prj[[paste0(varname_,"_IC95sup")]] = NA
  }  
  
  for (i in 1:length(fr.prj$CdHER2)){
    if (length(which(tab_$HER == fr.prj$CdHER2[i])) > 0){
      fr.prj[[varname_]][i] = tab_[which(tab_$HER == fr.prj$CdHER2[i]),varname_]
    }else{
      fr.prj[[varname_]][i] = NA
    }
    if (paste0(varname_,"_IC95inf") %in% colnames(tab_)){
      if (length(which(tab_$HER == fr.prj$CdHER2[i])) > 0){
        fr.prj[[paste0(varname_,"_IC95inf")]][i] = tab_[which(tab_$HER == fr.prj$CdHER2[i]),paste0(varname_,"_IC95inf")]
        fr.prj[[paste0(varname_,"_IC95sup")]][i] = tab_[which(tab_$HER == fr.prj$CdHER2[i]),paste0(varname_,"_IC95sup")]
      }else{
        fr.prj[[paste0(varname_,"_IC95inf")]][i] = NA
        fr.prj[[paste0(varname_,"_IC95sup")]][i] = NA
      }
    }
  }
  
  fr.prj$var_cut_ <- cut(fr.prj[[varname_]], breaks=breaks_, include.lowest = T)
  
  # Legende des HER 2
  # Extraire les coordonnées des centres de chaque polygone d'hydroécorégion de niveau 2
  her2_centers <- coordinates(gCentroid(fr.prj, byid=TRUE))
  
  # Extraire l'attribut "NUM_HER2" de chaque polygone d'hydroécorégion de niveau 2
  her2_attrib <- fr.prj$CdHER2
  
  # Convertir fr.prj en un dataframe utilisable dans ggplot2
  fr.df <- fortify(fr.prj)
  fr.df <- merge(fr.df, as.data.frame(fr.prj@data), by.x = "id", by.y = "row.names", all = TRUE)
  
  
  # Zoom RMC
  bbox <- c(xmin = 340000, xmax = 1300000, ymin = 6050000, ymax = 6800000)
  
  # Créer la palette de couleurs SurfaceHydroPropSurfHER2
  
  if (reverseColors_ == T){
    palette_col_ <- rev(colorRampPalette(brewer.pal(min(length(breaks_) - 1, 9), "RdYlGn"))(length(breaks_) - 1))
  }else{
    palette_col_ <- colorRampPalette(brewer.pal(min(length(breaks_) - 1, 9), "RdYlGn"))(length(breaks_) - 1)
  }
  
  fr.df$var_cut_ <- factor(fr.df$var_cut_, levels=labels_)
  
  # x11()
  p <- ggplot() +
    geom_polygon(data=fr.df, aes(x=long, y=lat, group=group, fill=var_cut_), 
                 color="black") +
    # scale_fill_manual(values=setNames(palette_col_,labels_),
    #                   name=vartitle_,
    #                   breaks=labels_,
    #                   drop = F)
    scale_fill_manual(values=setNames(palette_col_,labels_name_),
                      name=vartitle_,
                      breaks=labels_,
                      drop = F)
  if (paste0(varname_,"_IC95inf") %in% colnames(tab_)){
    p <- p + geom_label_repel(data = data.frame(x = her2_centers[,1], y = her2_centers[,2],
                                                label = paste0(her2_attrib, ifelse(is.na(fr.prj[[varname_]]),"",paste0(" : ",round(fr.prj[[varname_]],2),"\n[",round(fr.prj[[paste0(varname_,"_IC95inf")]],2),";",round(fr.prj[[paste0(varname_,"_IC95sup")]],2),"]")))),
                              aes(x = x, y = y, label = label),
                              fill.alpha = 0.5,
                              box.padding = 0.5,
                              col = "black", size = 3, segment.alpha = 1,
                              force = 10)
  }else{
    p <- p + geom_label_repel(data = data.frame(x = her2_centers[,1], y = her2_centers[,2],
                                                label = paste0(her2_attrib, ifelse(is.na(fr.prj[[varname_]]),"",paste0(" : ",round(fr.prj[[varname_]],2))))),
                              aes(x = x, y = y, label = label),
                              fill.alpha = 0.5,
                              box.padding = 0.5,
                              col = "black", size = 3, segment.alpha = 1,
                              force = 10)
  }
  
  p <- p + ggtitle(title_) +
    theme(axis.line = element_blank(),
          axis.text = element_blank(),
          axis.title = element_blank(),
          panel.background = element_blank(),
          text = element_text(size = 20),
          plot.title = element_text(size = 30, hjust = 0.5))
  
  # p <- p + guides(fill = guide_legend(label.wrap = 1))
  
  png(output_name_,
      width = 1200, height = 750,
      units = "px", pointsize = 12)
  print(p)
  dev.off()
  
}

# 
# ### Parameters ###
# folder_output_ = folder_output_param_
# nomSim_ = nomSim_param_
# folder_input_ = folder_input_param_
# output_name_ <- paste0(folder_output_,"/15_ResultatsModeles_ValidationParAnnees_ParHer/",nomSim_,"/LeaveOneYearOut/Validation_Globale/Map/Map_Globale_NASH_NewColor_",str_before_first(basename(l),pattern = ".csv"),"_",d,"_SimFr15_20230608.png")
# breaks_ = c(0,0.4,0.5,0.6,0.7,0.8,0.9,1)
# 
# ### Table results ###
# list_ <- list.files(paste0(folder_output_,"15_ResultatsModeles_ValidationParAnnees_ParHer/",nomSim_,"/LeaveOneYearOut/Validation_Globale/"), pattern = "ModelResults_ParDate__2012_2022_KGESUp0.00_DispSup-1_Obs_Weight_merge_Valid", full.names = T)
# tab_results_ = data.frame()
# for (l in list_){
#   tab_ = read.table(l, sep = ";", dec = ".", header = T)
#   if (ncol(tab_) == 1){
#     tab_ = read.table(l, sep = ",", dec = ".", header = T)
#   }
#   tab_results_ <- rbind(tab_results_,tab_)
# }
# 
# ### Jonction HER ###
# tab_results_$HER[which(tab_results_$HER == 37055)] = "37+55"
# tab_results_$HER[which(tab_results_$HER == 69096)] = "69+96"
# tab_results_$HER[which(tab_results_$HER == 31033039)] = "31+33+39"
# 
# ### Paremeters ###
# plot_map_variable(tab_ = tab_results_, 
#                   varname_ = "NASH_HER_AnneeValid_logit_CValid", 
#                   vartitle_ = "NASH",
#                   breaks_ = breaks_, 
#                   output_name_ = output_name_,
#                   title_ = "NASH - Validation en Leave One Year Out",
#                   reverseColors_ = F)



### Function ###
plot_map_variable_sansEtiquettes <- function(tab_, varname_, vartitle_, breaks_, output_name_, title_, reverseColors_, labels_name_ = FALSE){
  
  labels_ <- paste0(ifelse(breaks_[-length(breaks_)] == min(breaks_[-length(breaks_)]), "[", "("),
                    round(breaks_[-length(breaks_)],2),",", round(breaks_[-1],2),"]")
  
  if (labels_name_ == FALSE){
    labels_name_ <- paste0(ifelse(breaks_[-length(breaks_)] == min(breaks_[-length(breaks_)]), "[", "("),
                           round(breaks_[-length(breaks_)],2),",", round(breaks_[-1],2),"]")
  }else{
    labels_name_ <- paste0(ifelse(labels_name_[-length(labels_name_)] == min(labels_name_[-length(labels_name_)]), "[", "("),
                           round(labels_name_[-length(labels_name_)],2),",", round(labels_name_[-1],2),"]")
  }
  
  ### Import HER2 ###
  fr.spdf <- readOGR("/home/tjaouen/Documents/Input/HER/HER2hybrides/Shapefile/","HER2_hybrides")
  proj4string(fr.spdf)=CRS("+proj=longlat +ellps=WGS84")
  fr.prj <- spTransform(fr.spdf, CRS("+init=epsg:2154")) # trasnformation en Lambert93
  
  ### Jonction ###
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 37)] = "37+55"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 55)] = "37+55"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 69)] = "69+96"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 96)] = "69+96"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 31)] = "31+33+39"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 33)] = "31+33+39"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 39)] = "31+33+39"
  
  fr.prj[[varname_]] = NA
  if (paste0(varname_,"_IC95inf") %in% colnames(tab_)){
    fr.prj[[paste0(varname_,"_IC95inf")]] = NA
    fr.prj[[paste0(varname_,"_IC95sup")]] = NA
  }  
  
  for (i in 1:length(fr.prj$CdHER2)){
    if (length(which(tab_$HER == fr.prj$CdHER2[i])) > 0){
      fr.prj[[varname_]][i] = tab_[which(tab_$HER == fr.prj$CdHER2[i]),varname_]
    }else{
      fr.prj[[varname_]][i] = NA
    }
    if (paste0(varname_,"_IC95inf") %in% colnames(tab_)){
      if (length(which(tab_$HER == fr.prj$CdHER2[i])) > 0){
        fr.prj[[paste0(varname_,"_IC95inf")]][i] = tab_[which(tab_$HER == fr.prj$CdHER2[i]),paste0(varname_,"_IC95inf")]
        fr.prj[[paste0(varname_,"_IC95sup")]][i] = tab_[which(tab_$HER == fr.prj$CdHER2[i]),paste0(varname_,"_IC95sup")]
      }else{
        fr.prj[[paste0(varname_,"_IC95inf")]][i] = NA
        fr.prj[[paste0(varname_,"_IC95sup")]][i] = NA
      }
    }
  }
  
  fr.prj$var_cut_ <- cut(fr.prj[[varname_]], breaks=breaks_, include.lowest = T)
  
  # Legende des HER 2
  # Extraire les coordonnées des centres de chaque polygone d'hydroécorégion de niveau 2
  her2_centers <- coordinates(gCentroid(fr.prj, byid=TRUE))
  
  # Extraire l'attribut "NUM_HER2" de chaque polygone d'hydroécorégion de niveau 2
  her2_attrib <- fr.prj$CdHER2
  
  # Convertir fr.prj en un dataframe utilisable dans ggplot2
  fr.df <- fortify(fr.prj)
  fr.df <- merge(fr.df, as.data.frame(fr.prj@data), by.x = "id", by.y = "row.names", all = TRUE)
  
  
  # Zoom RMC
  bbox <- c(xmin = 340000, xmax = 1300000, ymin = 6050000, ymax = 6800000)
  
  # Créer la palette de couleurs SurfaceHydroPropSurfHER2
  
  if (reverseColors_ == T){
    palette_col_ <- rev(colorRampPalette(brewer.pal(min(length(breaks_) - 1, 9), "RdYlGn"))(length(breaks_) - 1))
  }else{
    palette_col_ <- colorRampPalette(brewer.pal(min(length(breaks_) - 1, 9), "RdYlGn"))(length(breaks_) - 1)
  }
  
  fr.df$var_cut_ <- factor(fr.df$var_cut_, levels=labels_)
  
  # x11()
  p <- ggplot() +
    geom_polygon(data=fr.df, aes(x=long, y=lat, group=group, fill=var_cut_), 
                 color="black") +
    # scale_fill_manual(values=setNames(palette_col_,labels_),
    #                   name=vartitle_,
    #                   breaks=labels_,
    #                   drop = F)
    scale_fill_manual(values=setNames(palette_col_,labels_name_),
                      name=vartitle_,
                      breaks=labels_,
                      drop = F)
  p <- p +     geom_text(data = data.frame(x = her2_centers[,1], y = her2_centers[,2], label = her2_attrib),
                         aes(x = x, y = y, label = label),
                         col = "black", size = 4, segment.alpha = 0.3,
                         force = 10)

  p <- p + ggtitle(title_) +
    theme(axis.line = element_blank(),
          axis.text = element_blank(),
          axis.title = element_blank(),
          panel.background = element_blank(),
          text = element_text(size = 20),
          plot.title = element_text(size = 30, hjust = 0.5))
  
  png(output_name_,
      width = 1200, height = 750,
      units = "px", pointsize = 12)
  print(p)
  dev.off()
  
}



