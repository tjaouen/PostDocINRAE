### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")

source("https://raw.githubusercontent.com/imaddowzimet/drawcrosshatch/master/draw_crosshatch.R") 

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
library(tidyverse)
library(ggpattern)

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


pattern <- function(x, size, pattern) {
  ex = list(
    horizontal = c(1, 2),
    vertical = c(1, 4),
    left2right = c(2, 4),
    right2left = c(1, 3)
  )
  fillgrid = st_make_grid(x, cellsize = size)
  endsf = lapply(1:length(fillgrid), function(j)
    sf::st_linestring(sf::st_coordinates(fillgrid[j])[ex[[pattern]], 1:2]))
  endsf = sf::st_sfc(endsf, crs = sf::st_crs(x))
  endsf = sf::st_intersection(endsf, x)
  endsf = endsf[sf::st_geometry_type(endsf)
                %in% c("LINESTRING", "MULTILINESTRING")]
  endsf = sf::st_line_merge(sf::st_union(endsf))
  return(endsf)
}

### Function ###
plot_map_variable <- function(tab_, varname_, vartitle_, breaks_, output_name_, title_, reverseColors_, nomPalette_, labels_name_ = FALSE, reverseLegend_ = FALSE, echelleAttenuee_ = FALSE, addValueUnder = NULL, HER2_excluesDensity_ = NULL){
  
  # if (! is.null(HER2_excluesDensity_)){
  #   tab_[match(HER2_excluesDensity_, tab_$HER),varname_] = "Low data density"
  # }
  # tab_[[varname_]] <- as.factor(tab_[[varname_]])
  
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
  
  # if (! is.null(HER2_excluesDensity_)){
  #   labels_ <- as.factor(c(labels_, "Low data density"))
  #   labels_name_ <- as.factor(c(labels_name_, "Low data density"))
  #   breaks_ <- as.factor(c(breaks_, "Low data density"))
  # }
  
  ### Import HER2 ###
  fr.spdf <- readOGR("/home/tjaouen/Documents/Input/HER/HER2hybrides/Shapefile/","HER2_hybrides")
  proj4string(fr.spdf)=CRS("+proj=longlat +ellps=WGS84")
  fr.prj <- spTransform(fr.spdf, CRS("+init=epsg:2154")) # trasnformation en Lambert93
  
  ### Jonction ###
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 37)] = "37+54"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 54)] = "37+54"
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
  
  fr.prj$var_cut_ <- as.character(cut(fr.prj[[varname_]], breaks=breaks_, include.lowest = T, labels = labels_))
  
  # if (! is.null(HER2_excluesDensity_)){
  #   fr.prj$var_cut_[which(fr.prj$CdHER2 %in% HER2_excluesDensity_)] = "Low data density"
  # }
  # fr.prj$var_cut_ <- factor(fr.prj$var_cut_)
  
  # Legende des HER 2
  # Extraire les coordonnées des centres de chaque polygone d'hydroécorégion de niveau 2
  her2_centers <- coordinates(gCentroid(fr.prj, byid=TRUE))
  
  # Extraire l'attribut "NUM_HER2" de chaque polygone d'hydroécorégion de niveau 2
  her2_attrib <- fr.prj$CdHER2
  
  # Convertir fr.prj en un dataframe utilisable dans ggplot2
  fr.df <- fortify(fr.prj)
  fr.df <- merge(fr.df, as.data.frame(fr.prj@data), by.x = "id", by.y = "row.names", all = TRUE)
  
  if (! is.null(HER2_excluesDensity_)){
    palette_col_ = as.factor(c(palette_col_, "#ffffff")) # "#737373", #1d91c0
    labels_ = as.factor(c(labels_, "Low data density"))
    labels_name_ = as.factor(c(labels_name_, "Low data density"))
    breaks_ = as.factor(c(breaks_, "Low data density"))
  }
  
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
  setNames(palette_col_,labels_name_)
  ### ICI PAUSE ###
  
  
  # df_color_ = setNames(palette_col_,labels_name_)
  df_color_ = setNames(palette_col_,labels_)
  if (! is.null(HER2_excluesDensity_)){
    df_color_["Low data density"] = "#ffffff" # "#737373", #1d91c0
  }
  
  fr.df$var_cut_ <- factor(fr.df$var_cut_, levels=labels_)
  if (! is.null(HER2_excluesDensity_)){
    fr.df$var_cut_[which(fr.df$CdHER2 %in% HER2_excluesDensity_)] = "Low data density"
  }
  # palette_col_ <- factor(palette_col_)
  
  hatch_fill <- geom_hline(yintercept = seq(-2, 2, by = 0.5), color = "black", size = 0.5)
  
  
  # x11()
  p <- ggplot() +
    geom_polygon(data=fr.df, aes(x=long, y=lat, group=group, fill=var_cut_), 
                 color="black") +
    scale_fill_manual(values=df_color_,
                      name=vartitle_,
                      breaks=labels_,
                      labels=labels_name_,
                      drop = F) +
    geom_hline(yintercept = unique(fr.df$lat[fr.df$var_cut_ == "NA_hatch"]),
               color = "black",
               size = 0.5)
  
  # hatch_segments  # Ajouter les hachures
  # p <- ggplot() +
  #   geom_polygon(data=fr.df, aes(x=long, y=lat, group=group, fill=var_cut_), 
  #                color="black") +
  #   scale_fill_manual(values=df_color_,
  #                     name=vartitle_,
  #                     breaks=labels_,
  #                     drop = F)
  
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
  
  # p <- p + ggtitle(title_) +
  #   # guides(fill = guide_legend(reverse = reverseLegend_)) + # Inverser l'ordre de la légende de remplissage
  #   guides(fill = guide_legend(reverse = reverseLegend_,
  #                              keywidth = 2,
  #                              keyheight = 2)) + # Inverser l'ordre de la légende de remplissage
  #   theme(axis.line = element_blank(),
  #         axis.text = element_blank(),
  #         axis.ticks = element_blank(),
  #         # axis.line = element_line(color = rgb(0.6,0.6,0.6)),
  #         # axis.text = element_text(size = 10, color = rgb(0.6,0.6,0.6)),
  #         # axis.ticks = element_line(color = rgb(0.6,0.6,0.6)),
  #         axis.title = element_blank(),
  #         panel.background = element_blank(),
  #         text = element_text(size = 26),
  #         plot.title = element_text(size = 30, hjust = 0.5))+
  #   coord_fixed(ratio = 1)
  
  p <- p + ggtitle(title_) +
    guides(fill = guide_legend(reverse = reverseLegend_,
                               keywidth = 2,
                               keyheight = 2)) +
    theme(axis.line = element_blank(),
          axis.text = element_blank(),
          axis.ticks = element_blank(),
          axis.title = element_blank(),
          panel.background = element_blank(),
          text = element_text(size = 26),
          plot.title = element_text(size = 30, hjust = 0.5))+
    coord_fixed(ratio = 1) +
    annotation_scale(location = "bl", line_width = .8, text_cex = 1) +
    annotation_north_arrow(location = "tl", height = unit(0.7, "cm"), width = unit(0.7, "cm"))
  
  
  # guide_legend(keywidth = 2, keyheight = 2)
  
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
  
  p <- p + annotation_scale(location = "bl", line_width = .8, text_cex = 1) +
    annotation_north_arrow(location = "tl", height = unit(0.7, "cm"), width = unit(0.7, "cm"))
  
  # x11()
  # pdf(output_name_,
  #     width = 900)#, #height = 750,
  #     # units = "px", pointsize = 12)
  # # png(output_name_,
  # #     width = 900, #height = 750,
  # #     units = "px", pointsize = 12)
  # print(p)
  # dev.off()
  
  # ggsave(output_name_, plot = p, device = "pdf")
  
  # Réglages pour l'exportation PDF
  # ggsave(
  #   output_name_,
  #   plot = p,
  #   device = "pdf",
  #   width = 18,  # Définissez la largeur souhaitée du graphique en pouces
  #   height = 12,  # Définissez la hauteur souhaitée du graphique en pouces
  #   units = "in",  # Unité utilisée pour la largeur et la hauteur
  #   dpi = 300  # Résolution en DPI (points par pouce)
  # )
  p <- p +  geom_segment(data=lines, aes(x= x, y = y , xend = xend, yend = yend), 
                         inherit.aes = F)
  x11()
  print(p)
  
  pdf(output_name_,
      width = 18)#,
  # units = "in")
  
  #     width = 900) #, #height = 750,
  #     # width = 900) #, #height = 750,
  #     # units = "px", pointsize = 12)
  print(p)
  dev.off()
  
  
  saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))
  
}


### Function ###
plot_map_variable_sansEtiquettes <- function(tab_, varname_, vartitle_, breaks_, output_name_, title_, reverseColors_, nomPalette_, labels_name_ = FALSE, sansTexteHer_ = FALSE, reverseLegend_ = FALSE, echelleAttenuee_ = FALSE, addValueUnder = NULL, HER2_excluesDensity_ = NULL){
  
  if (!(is.null(addValueUnder))){
    breaks_ <- c(addValueUnder,breaks_)
  }
  
  labels_ <- paste0(ifelse(breaks_[-length(breaks_)] == min(breaks_[-length(breaks_)]), "[", "("),
                    breaks_[-length(breaks_)],",", breaks_[-1],"]")
  
  if (labels_name_ == FALSE){
    labels_name_ <- paste0(ifelse(breaks_[-length(breaks_)] == min(breaks_[-length(breaks_)]), "[", "("),
                           breaks_[-length(breaks_)],",", breaks_[-1],"]")
  }
  # else{
  #   labels_name_ <- paste0(ifelse(labels_name_[-length(labels_name_)] == min(labels_name_[-length(labels_name_)]), "[", "("),
  #                          labels_name_[-length(labels_name_)],",", labels_name_[-1],"]")
  # }
  
  ### Import HER2 ###
  fr.spdf <- readOGR("/home/tjaouen/Documents/Input/HER/HER2hybrides/Shapefile/","HER2_hybrides")
  proj4string(fr.spdf)=CRS("+proj=longlat +ellps=WGS84")
  fr.prj <- spTransform(fr.spdf, CRS("+init=epsg:2154")) # trasnformation en Lambert93
  
  ### Jonction ###
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 37)] = "37+54"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 54)] = "37+54"
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
  
  fr.prj$var_cut_ <- cut(fr.prj[[varname_]], breaks=breaks_, include.lowest = T, label = labels_)
  
  # Legende des HER 2
  # Extraire les coordonnées des centres de chaque polygone d'hydroécorégion de niveau 2
  her2_centers <- coordinates(gCentroid(fr.prj, byid=TRUE))
  
  # Extraire l'attribut "NUM_HER2" de chaque polygone d'hydroécorégion de niveau 2
  her2_attrib <- fr.prj$CdHER2
  
  # Convertir fr.prj en un dataframe utilisable dans ggplot2
  fr.df <- fortify(fr.prj)
  fr.df <- merge(fr.df, as.data.frame(fr.prj@data), by.x = "id", by.y = "row.names", all = TRUE)
  
  if (! is.null(HER2_excluesDensity_)){
    palette_col_ = as.factor(c(palette_col_, "#ffffff")) # "#737373", #1d91c0
    labels_ = as.factor(c(labels_, "Low data density"))
    labels_name_ = as.factor(c(labels_name_, "Low data density"))
    breaks_ = as.factor(c(breaks_, "Low data density"))
  }
  
  # Zoom RMC
  bbox <- c(xmin = 340000, xmax = 1300000, ymin = 6050000, ymax = 6800000)
  
  # Créer la palette de couleurs SurfaceHydroPropSurfHER2
  
  if (reverseColors_ == T){
    if (echelleAttenuee_ == TRUE){
      palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ =  min(max(length(breaks_),5),21)))
    }else{
      palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ =  min(max(length(breaks_) - 1,5),21)))
    }
  }else{
    if (echelleAttenuee_ == TRUE){
      palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ =  min(max(length(breaks_),5),21))
    }else{
      palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ =  min(max(length(breaks_) - 1,5),21))
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
  
  # df_color_ = setNames(palette_col_,labels_name_)
  df_color_ = setNames(palette_col_,labels_)
  if (! is.null(HER2_excluesDensity_)){
    df_color_["Low data density"] = "#ffffff" # "#737373", #1d91c0
  }
  
  fr.df$var_cut_ <- factor(fr.df$var_cut_, levels=labels_)
  
  if (! is.null(HER2_excluesDensity_)){
    fr.df$var_cut_[which(fr.df$CdHER2 %in% HER2_excluesDensity_)] = "Low data density"
  }
  
  
  fr.df$group_polygon = paste0(fr.df$CdHER2,"_",fr.df$group)
  
  fr.df$var_cut_factor <- factor(!is.na(fr.df$var_cut_), levels = c(FALSE, TRUE), labels = c("Missing", "Present"))
  fr.df$var_cut_num <- as.numeric(is.na(fr.df$var_cut_), levels = c(FALSE, TRUE), labels = c(1, 0))
  

  
  p <- ggplot(fr.df, aes(map_id = var_cut_)) +
    # geom_polygon(data=fr.df, aes(x=long, y=lat, group=group, fill=var_cut_), 
    #              color="black") +
    # scale_fill_manual(values=df_color_,
    #                   name=vartitle_,
    #                   breaks=labels_,
    #                   labels = labels_name_,
    #                   drop = F) +
    geom_map_pattern(
      aes(
        # fill            = Murder,
        fill = as.numeric(!is.na(var_cut_)),
        pattern_fill    = as.numeric(!is.na(var_cut_)),
        pattern_spacing = 1,
        pattern_density = 1,
        pattern_angle   = 1,
        pattern         = 1
      ),
      fill = 'white',
      colour = 'black',
      map = fr.df
    ) #+
    # expand_limits(x = fr.df$long, y = fr.df$lat) +
    # coord_map() +
    # theme_bw() +
    # labs(title = "ggpattern::geom_map_pattern()") + 
    # scale_pattern_density_discrete(range = c(0.01, 0.3)) + 
    # scale_pattern_spacing_discrete(range = c(0.01, 0.05)) + 
    # theme(legend.position = 'none')

  p
  
  
  p <- ggplot(fr.df, aes(map_id = var_cut_num)) +
    geom_polygon(data=fr.df, aes(x=long, y=lat, group=group, fill = var_cut_),
                 color="black") +
    
    geom_map_pattern(data = fr.df,
      aes(
        # fill = var_cut_factor,
        pattern         = var_cut_num,
        fill = var_cut_
      ),
      # pattern_fill    = "black",
      pattern_spacing = 0.01,
      pattern_angle   = 0,
      pattern_density = 0.01,
      colour = 'black',
      map = fr.df
    ) +
  
    # expand_limits(x = fr.df$long, y = fr.df$lat) +
    # coord_map() +
    theme_bw() +
    labs(title = "ggpattern::geom_map_pattern()") +
    # scale_pattern_density_discrete(range = c(0.01, 0.3)) +
    # scale_pattern_spacing_discrete(range = c(0.01, 0.05)) +
    theme(legend.position = 'none')+
  scale_fill_manual(values=df_color_,
                    name=vartitle_,
                    breaks=labels_,
                    labels = labels_name_,
                    drop = F)
  
  
  p
  
  
  # fr.df$var_cut_num[which(fr.df$var_cut_num == 0)] = NA
  # fr.df$var_cut_num[which(fr.df$var_cut_num == 0)] = NA
  
  ggplot() +
    geom_polygon(data=fr.df, aes(x=long, y=lat, group=group, fill=var_cut_), 
                 color="black") +
    scale_fill_manual(values=df_color_,
                      name=vartitle_,
                      breaks=labels_,
                      labels=labels_name_,
                      drop = F) +
    geom_hline(yintercept = unique(fr.df$lat[fr.df$var_cut_ == "NA_hatch"]),
               color = "black",
               size = 0.5)
  
  
  # ggplot(data = fr.df, aes(x = long, y = lat,
  #                          group = group_polygon, fill = var_cut_, pattern = as.factor(var_cut_num)))+
  ggplot(data = fr.df, aes(x = long, y = lat,
                           group = group_polygon, fill = var_cut_))+
    geom_polygon_pattern(aes(pattern_type = as.factor(var_cut_num)),
                         pattern_color = NA,
                         pattern_fill = "black",
                         pattern_angle = 45,
                         # pattern_density = 0.5,
                         pattern_spacing = 0.01,
                         pattern_key_scale_factor = 1) +
    scale_pattern_type_manual(values = c("hexagonal",
                                         "pythagorean"))
  
  
  ggplot(data = fr.df, aes(x = long, y = lat, group = group_polygon, fill = var_cut_)) +
    geom_polygon_pattern(
      aes(pattern_type = as.factor(var_cut_num)),
      pattern_color = NA,
      pattern_fill = "black",
      pattern_angle = 45,
      pattern_spacing = 0.01,
      pattern_key_scale_factor = 1
    ) +
    # scale_pattern_manual(values=c('stripe', 'wave', 'wave')) #+
    scale_pattern_type_discrete(values = c("stripe", "none"))  # Utilisation de "none" pour aucun motif

  
  ggplot(data = fr.df, aes(x = long, y = lat, group = group_polygon, fill = var_cut_)) +
    geom_polygon_pattern(
      aes(pattern_type = ifelse(var_cut_num == 1, as.factor(var_cut_num), "none")),
      pattern_color = NA,
      pattern_fill = "black",
      pattern_angle = 45,
      pattern_spacing = 0.01,
      pattern_key_scale_factor = 1
    ) +
    scale_pattern_type_manual(values = c("stripe", "none")) # Utilisation de "none" pour aucun motif
    
                         # color="black", )#, pattern = var_cut_num)) +
    # geom_polygon_pattern(pattern_color = NA,
    #                   pattern_fill = "black",
    #                   pattern_angle = 45,
    #                   pattern_density = 0.5,
    #                   pattern_spacing = 0.025,
    #                   pattern_key_scale_factor = 1) #+
  
  

  
  
    # geom_polygon(aes(group = group, fill = var_cut_), color = "black") +
    
    # geom_polygon_pattern(
    #   aes(group = group, fill = as.factor(var_cut_),
    #       # pattern = as.factor(var_cut_num),color=),
    #   # Choisissez le type de hachure, par exemple 'stripe'
    #   color = c(NA,"black"),    # Couleur des lignes de hachure
    #   size = 0.5          # Épaisseur des lignes de hachure
    # ) +
      geom_polygon_pattern(width=0.9, height=0.9, pattern_color = NA, 
                           pattern_fill = "black",
                           pattern_angle = 45,
                           pattern_density = 0.5,
                           pattern_spacing = 0.025,
                           pattern_key_scale_factor = 1) + 
      
      
    scale_fill_manual(values=df_color_,
                      name=vartitle_,
                      breaks=labels_,
                      labels = labels_name_,
                      drop = F)+
  theme_minimal()
  
  
  
  
  
  
  
  
  # Convertir le dataframe en objet sf (simple feature)
  fr.sf <- st_as_sf(fr.df, coords = c("long","lat"),  crs = "+proj=longlat +datum=WGS84")
  
  # Convertir en multipolygones ou multilignes
  fr.multi <- st_cast(fr.sf, "MULTIPOLYGON")  # Ou utilisez "MULTILINESTRING" si nécessaire
  
  # Maintenant, vous pouvez essayer de convertir en un autre type géométrique
  # Par exemple, convertir en polygones simples
  fr.simple <- st_cast(fr.multi, "POLYGON")
  
  # Tracer les polygones avec ggplot en utilisant les données simplifiées
  ggplot(data = fr.simple, aes(fill = var_cut_)) +
    geom_sf(color = "black") +
    geom_sf_pattern(
      aes(fill = as.factor(var_cut_num)),
      pattern = "stripe",
      color = "black",
      size = 0.5
    ) +
    scale_fill_manual(
      values = df_color_,
      name = vartitle_,
      breaks = labels_,
      labels = labels_name_,
      drop = FALSE
    ) +
    theme_minimal()
  
  
  
  
  
  
  
  
  p <- ggplot(fr.df, aes(map_id = var_cut_num)) +
    geom_polygon(aes(x = long, y = lat, group = group, fill = var_cut_),
                 color = "black") +
    geom_polygon_pattern(
      aes(fill = "pattern"),
      pattern = "stripe", # Choisissez le type de hachure, par exemple 'stripe'
      color = "black",    # Couleur des lignes de hachure
      size = 0.5          # Épaisseur des lignes de hachure
    ) +
    
    
    
    # geom_map_pattern(
    #   aes(
    #     pattern = var_cut_num
    #   ),
    #   pattern_fill = "black",
    #   pattern_spacing = 0.01,
    #   pattern_angle = 0,
    #   pattern_density = 0.01,
    #   fill = 'white',
    #   colour = 'black',
    #   map = fr.df
    # ) +
    theme_bw() +
    labs(title = "ggpattern::geom_map_pattern()") +
    theme(legend.position = 'none')
  
  
  
  
  
  
  
  
  
  
  if (sansTexteHer_ == FALSE){
    p <- p + geom_text(data = data.frame(x = her2_centers[,1], y = her2_centers[,2], label = her2_attrib),
                       aes(x = x, y = y, label = label),
                       col = "black", size = 4, segment.alpha = 0.3,
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
          plot.title = element_text(size = 30, hjust = 0.5))+
    coord_fixed(ratio = 1)
  
  # p <- p + annotation_scale(location = "bl", line_width = .5) +
  #   annotation_north_arrow(location = "tl", height = unit(0.7, "cm"), width = unit(0.7, "cm"))
  
  p <- p + annotation_scale(location = "bl", line_width = .8, text_cex = 1) +
    annotation_north_arrow(location = "tl", height = unit(0.7, "cm"), width = unit(0.7, "cm"))
  
  # x11()
  # pdf(output_name_,
  #     width = 900)#, #height = 750,
  #     # units = "px", pointsize = 12)
  # # png(output_name_,
  # #     width = 900, #height = 750,
  # #     units = "px", pointsize = 12)
  # print(p)
  # dev.off()
  
  # ggsave(output_name_, plot = p, device = "pdf")
  
  # # Ajouter le texte indiquant le nord
  # p <- p + geom_segment(
  #   aes(x = 1200000, y = 6950000, xend = 1200000, yend = 7050000),
  #   arrow = arrow(type = "closed", length = unit(0.25, "inches")),
  #   lineend = "round",
  #   linejoin = "round",
  #   color = "black") +
  #   
  #   # Ajouter le texte "Nord"
  #   geom_text(
  #     aes(x = 1200000, y = 7070000, label = "Nord"),
  #     color = "black",
  #     size = 5,
  #     hjust = 0.5,  # Aligner à gauche
  #     vjust = 0.5   # Aligner en bas
  #   )
  
  # png(output_name_,
  #     width = 900, #height = 750,
  #     units = "px", pointsize = 12)
  
  # Réglages pour l'exportation PDF
  # ggsave(
  #   output_name_,
  #   plot = p,
  #   device = "pdf",
  #   width = 18,  # Définissez la largeur souhaitée du graphique en pouces
  #   height = 12,  # Définissez la hauteur souhaitée du graphique en pouces
  #   units = "in",  # Unité utilisée pour la largeur et la hauteur
  #   dpi = 300  # Résolution en DPI (points par pouce)
  # )
  
  ## LAAA ##
  # pdf(output_name_,
  #     width = 18)#,
  x11()
  ## LAAA ##
  
  
  # units = "in")
  
  #     width = 900) #, #height = 750,
  #     # width = 900) #, #height = 750,
  #     # units = "px", pointsize = 12)
  print(p)
  dev.off()
  
  saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))
  
}



