### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")


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
library(sp)
library(rgdal)
library(sf)
library(ggspatial)


### IPCC colors ###

# Fonction pour extraire les valeurs RGB
extract_rgb <- function(lines) {
  rgb_values <- strsplit(lines, " ")[[1]]
  rgb_values <- rgb_values[rgb_values != ""]
  rgb_values <- as.integer(rgb_values)
  rgb_values <- matrix(rgb_values, ncol = 3, byrow = TRUE)
  return(rgb_values)
}

createPaletteFromRgbTxt <- function(IPCCcolors_folder_, nomPalette_, size_){
  
  # Diviser le texte en lignes
  text <- readLines(paste0(IPCCcolors_folder_,nomPalette_))
  lines <- unlist(strsplit(text, "\n"))
  
  # Créer la palette de couleurs
  palette <- list()
  current_key <- ""
  
  if (nomPalette_ == "prec_div_disc.txt"){
    size_ <- size_ + 3
  }
  
  for (line in lines) {
    if (grepl("_", line)) {
      current_key <- as.numeric(str_after_last(line, "_"))
    } else if (line != "" & current_key == size_) {
      palette <- rbind(palette, extract_rgb(line))
    }
  }
  palette <- rgb(palette[,1], palette[,2], palette[,3], maxColorValue = 255)
  return(palette)
}


### Function ###
plot_map_variable <- function(tab_, varname_, vartitle_, breaks_, output_name_, title_, reverseColors_, nomPalette_, labels_name_ = FALSE, reverseLegend_ = FALSE, echelleAttenuee_ = FALSE, addValueUnder = NULL){
  
  if (!(is.null(addValueUnder))){
    breaks_ <- c(addValueUnder,breaks_)
  }
  
  labels_ <- paste0(ifelse(breaks_[-length(breaks_)] == min(breaks_[-length(breaks_)]), "[", "("),
                    breaks_[-length(breaks_)],",", breaks_[-1],"]")
  
  if (labels_name_ == FALSE){
    labels_name_ <- paste0(ifelse(breaks_[-length(breaks_)] == min(breaks_[-length(breaks_)]), "[", "("),
                           breaks_[-length(breaks_)],",", breaks_[-1],"]")
  }else{
    labels_name_ <- paste0(ifelse(labels_name_[-length(labels_name_)] == min(labels_name_[-length(labels_name_)]), "[", "("),
                           labels_name_[-length(labels_name_)],",", labels_name_[-1],"]")
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
  
  fr.prj$var_cut_ <- cut(fr.prj[[varname_]], breaks=breaks_, include.lowest = T, labels = labels_)
  
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
    if (echelleAttenuee_ == TRUE){
      palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_),5),21)))
    }else{
      palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_)-1,5),21)))
    }
  }else{
    if (echelleAttenuee_ == TRUE){
      palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_),5), 21))
    }else{
      palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_)-1,5), 21))
    }
  }
  
  # Ajustement de la palette
  if (length(breaks_)-1 > 21){
    stop("Message personnel : Erreur, pas assez de couleurs disponibles dans ce fichier txt de couleurs")
  }else{
    if (echelleAttenuee_ == TRUE){
      palette_col_ <- palette_col_[2:(length(breaks_))]
    }else{
      palette_col_ <- palette_col_[1:(length(breaks_)-1)]
    }
    if (!(is.null(addValueUnder))){
      palette_col_ <- c("#ffffff",palette_col_)
    }
  }
  
  fr.df$var_cut_ <- factor(fr.df$var_cut_, levels=labels_)
  
  # x11()
  p <- ggplot() +
    geom_polygon(data=fr.df, aes(x=long, y=lat, group=group, fill=var_cut_), 
                 color="black") +
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
    guides(fill = guide_legend(reverse = reverseLegend_)) + # Inverser l'ordre de la légende de remplissage
    theme(axis.line = element_blank(),
          axis.text = element_blank(),
          axis.ticks = element_blank(),
          # axis.line = element_line(color = rgb(0.6,0.6,0.6)),
          # axis.text = element_text(size = 10, color = rgb(0.6,0.6,0.6)),
          # axis.ticks = element_line(color = rgb(0.6,0.6,0.6)),
          axis.title = element_blank(),
          panel.background = element_blank(),
          text = element_text(size = 26),
          plot.title = element_text(size = 30, hjust = 0.5))
  
  # Ajouter le texte indiquant le nord
  # p <- p + geom_segment(
  #   aes(x = 1200000, y = 6950000, xend = 1200000, yend = 7050000),
  #   arrow = arrow(type = "closed", length = unit(0.25, "inches")),
  #   lineend = "round",
  #   linejoin = "round",
  #   color = "black") +
  
  # Ajouter le texte "Nord"
  # geom_text(
  #   aes(x = 1200000, y = 7070000, label = "Nord"),
  #   color = "black",
  #   size = 5,
  #   hjust = 0.5,  # Aligner à gauche
  #   vjust = 0.5   # Aligner en bas
  # )
  
  p <- p + annotation_scale(location = "bl", line_width = .5) +
    annotation_north_arrow(location = "tl", height = unit(0.7, "cm"), width = unit(0.7, "cm"))
  
  # x11()
  png(output_name_,
      width = 900, height = 750,
      units = "px", pointsize = 12)
  print(p)
  dev.off()
  
  saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))
  
}


### Function ###
plot_map_variable_points <- function(tab_, vartitle_, output_name_, title_, nomX, nomY, color){
  
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
  
  
  p <- ggplot() +
    geom_polygon(data=fr.df, aes(x=long, y=lat, group = group), fill="white", color="black") +
    
    # Ajout des points à partir des coordonnées dans la table
    geom_point(data=tab_, aes(x = !!sym(nomX), y = !!sym(nomY), color = color), size = 0.8) +
    scale_color_manual(name= "",
                       values = color,
                       labels = vartitle_)
  
  p <- p + ggtitle(title_) +
    # guides(fill = guide_legend(reverse = reverseLegend_)) + # Inverser l'ordre de la légende de remplissage
    theme(axis.line = element_blank(),
          axis.text = element_blank(),
          axis.ticks = element_blank(),
          # axis.line = element_line(color = rgb(0.6,0.6,0.6)),
          # axis.text = element_text(size = 10, color = rgb(0.6,0.6,0.6)),
          # axis.ticks = element_line(color = rgb(0.6,0.6,0.6)),
          axis.title = element_blank(),
          panel.background = element_blank(),
          text = element_text(size = 26),
          plot.title = element_text(size = 30, hjust = 0.5))+
    coord_fixed(ratio = 1)
  
  p <- p + annotation_scale(location = "bl", line_width = .5) +
    annotation_north_arrow(location = "tl", height = unit(0.7, "cm"), width = unit(0.7, "cm"))

  png(output_name_,
      width = 1600, #height = 750,
      units = "px", pointsize = 12)
    
  # png(output_name_,
  #     width = 900, #height = 750,
  #     units = "px", pointsize = 12)
  print(p)
  dev.off()
  
  saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))
  
}



