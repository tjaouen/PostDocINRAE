### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")

# source("https://raw.githubusercontent.com/imaddowzimet/drawcrosshatch/master/draw_crosshatch.R") 

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
library(svglite)
library(latex2exp)

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

generer_positions <- function(position_centrale, pas, taille) {
  positions <- seq(position_centrale - (taille - 1) * pas / 2, 
                   position_centrale + (taille - 1) * pas / 2, 
                   by = pas)
  return(positions)
}


### Function ###
plot_map_variable <- function(tab_, varname_, vartitle_, breaks_, output_name_, title_, reverseColors_, nomPalette_, labels_name_ = FALSE, reverseLegend_ = FALSE, echelleAttenuee_ = FALSE, addValueUnder = NULL, HER2_excluesDensity_ = NULL, subtitle_ = NULL){
  
  if (!(is.null(addValueUnder))){
    breaks_ <- c(addValueUnder,breaks_)
  }
  
  labels_ <- paste0(ifelse(breaks_[-length(breaks_)] == min(breaks_[-length(breaks_)]), "[", "("),
                    breaks_[-length(breaks_)],",", breaks_[-1],"]")
  
  if (labels_name_ == FALSE){
    labels_name_ <- paste0(ifelse(breaks_[-length(breaks_)] == min(breaks_[-length(breaks_)]), "[", "("),
                           breaks_[-length(breaks_)],",", breaks_[-1],"]")
  }
  
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
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 89)] = "89+92"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 92)] = "89+92"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 49)] = "49+90"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 90)] = "49+90"
  
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
  txt_ = read_lines(paste0(IPCCcolors_folder_,nomPalette_))
  length_color_ = max(as.numeric(str_after_last(grep("_", txt_, value = TRUE),"_")))
  
  if (reverseColors_ == T){
    if (echelleAttenuee_ == TRUE){
      # palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_),5),length_color_)))
      # palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_),5),14)))
      palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_)*2+1,5),28)))
      palette_col_ <- palette_col_[round(length(palette_col_)/2):length(palette_col_)]
    }else{
      # palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_)-1,5),length_color_)))
      # palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_)-1,5),14)))
      palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_)*2,5),28)))
      palette_col_ <- palette_col_[round(length(palette_col_)/2):length(palette_col_)]
    }
  }else{
    if (echelleAttenuee_ == TRUE){
      # palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_),5), length_color_))
      # palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_),5), 14))
      palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max((length(breaks_)-1)*2,5), 28))
      palette_col_ <- palette_col_[round(length(palette_col_)/2):length(palette_col_)]
    }else{
      # palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_)-1,5), length_color_))
      # palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_)-1,5), 14))
      palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max((length(breaks_)-1)*2,5), 28))
      palette_col_ <- palette_col_[round(length(palette_col_)/2):length(palette_col_)]
    }
  }
  # "#E8F2F0" "#F6F1E6" "#F6EAC9" "#ECD6A2" "#DDBE78" "#CB984A" "#B37525" "#955911" "#744308" "#543005"
  
  # Ajustement de la palette
  if (length(breaks_)-1 > length_color_){
    stop("Message personnel : Erreur, pas assez de couleurs disponibles dans ce fichier txt de couleurs")
  }else{
    if (is.null(addValueUnder)){
      if (echelleAttenuee_ == TRUE){
        palette_col_ <- palette_col_[2:(length(breaks_))]
      }else{
        palette_col_ <- palette_col_[1:(length(breaks_)-1)]
      }
    }else{
      # palette_col_ <- palette_col_[1:(length(breaks_)-2)]
      # palette_col_ <- palette_col_[1:(length(breaks_))]
      palette_col_ <- palette_col_[3:(length(breaks_))]
      palette_col_ <- c("white",palette_col_)
    }
  }
  # [1] "white"   "#E8F2F0" "#F6F1E6" "#F6EAC9" "#ECD6A2" "#DDBE78" "#CB984A" "#B37525"
  # [1] "white"   "#E8F2F0" "#F6F1E6" "#F6EAC9" "#ECD6A2" "#DDBE78" "#CB984A" "#B37525" "#955911" "#744308"

  
  df_color_ = setNames(palette_col_,labels_)
  if (! is.null(HER2_excluesDensity_)){
    df_color_["Low data density"] = "#ffffff" # "#737373", #1d91c0
  }
  
  fr.df$var_cut_ <- factor(fr.df$var_cut_, levels=labels_)
  if (! is.null(HER2_excluesDensity_)){
    fr.df$var_cut_[which(fr.df$CdHER2 %in% HER2_excluesDensity_)] = "Low data density"
  }
  hatch_fill <- geom_hline(yintercept = seq(-2, 2, by = 0.5), color = "black", size = 0.5)
  
  labels_name_annotation_ <- paste0(c(substr(str_before_first(labels_name_[1],","),2,nchar(str_before_first(labels_name_[1],","))),
                                      str_before_first(str_after_first(labels_name_,","),"]")),
                                    "%")
  
  unit_x_ = max(fr.df$long) - min(fr.df$long)
  unit_y_ = max(fr.df$lat) - min(fr.df$lat)
  origin_x_ = min(fr.df$long)
  origin_y_ = min(fr.df$lat)
  
  # x11()
  p <- ggplot() +
    geom_polygon(data=fr.df, aes(x=long, y=lat, group=group, fill=var_cut_), 
                 color="black", size = 0.3) +
    scale_fill_manual(values=df_color_,
                      name=vartitle_,
                      breaks=labels_,
                      labels=labels_name_annotation_[2:length(labels_name_annotation_)],
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
  p <- p + 
    theme(legend.position = c(0.92,0.5),
          axis.line = element_blank(),
          axis.text = element_blank(),
          axis.ticks = element_blank(),
          axis.title = element_blank(),
          legend.title = element_blank(),
          # legend.text = element_text(size = 0),
          legend.background = element_blank(),
          legend.key.height = unit(1.3, 'cm'),
          legend.spacing.y = unit(0, 'cm'),
          legend.margin = margin(0, 0, 0, 0), # Réduire les marges de la légende
          legend.box.spacing = unit(0, "cm"), # Réduire l'espacement interne de la légende
          panel.background = element_blank(),
          text = element_text(size = 26),
          plot.title = element_text(size = 30, hjust = 0.5))+
    guides(fill = guide_legend(reverse = reverseLegend_,
                               override.aes = list(linewidth = 0)))+
    coord_fixed(ratio = 1)
  
  # Texte legend
  # p <- p + annotate("text",
  #                   x = origin_x_ + 0.97 * unit_x_,
  #                   y = generer_positions(origin_y_ + 0.502 * unit_y_, 55500, length(labels_name_annotation_)),
  #                   label = TeX(labels_name_annotation_),
  #                   size = 18*25.4/72.27,
  #                   hjust = 0)
  
  # Titre
  # p <- p + annotate("text",
  #                   x = origin_x_ + 0 * unit_x_,
  #                   y = origin_y_ + 0.97 * unit_y_,
  #                   label = title_,
  #                   fontface = "bold",
  #                   # bold = T,
  #                   size = 30*25.4/72.27,
  #                   hjust = 0,
  #                   vjust = 0.5)
  # p <- p + annotate("text",
  #                   x = origin_x_ + 1 * unit_x_,
  #                   y = origin_y_ + 0.97 * unit_y_,
  #                   label = subtitle_,
  #                   size = 18*25.4/72.27,
  #                   hjust = "right",
  #                   vjust = 0.5)
  
  # Echelle
  p <- p + annotation_scale(location = "bl",
                            line_width = .8,
                            text_cex = 0.7,
                            # pad_x = unit(1.5, "cm"), pad_y = unit(2, "cm"),
                            style = 'ticks',
                            text = element_blank()) +
    # annotation_north_arrow(location = "tr", height = unit(0.7, "cm"), width = unit(0.7, "cm"))#,
    # annotation_north_arrow(location = "tr", height = unit(0.7, "cm"), width = unit(0.7, "cm"), text_cex = 0.2)#,
    annotation_north_arrow(location = "tr", height = unit(0.4, "cm"), width = unit(0.4, "cm"), text_cex = 0.2)#,
  # pad_x = unit(1.5, "cm"),
  # pad_y = unit(3, "cm"))
  # p <- p +
  #   annotate("rect",
  #            xmin = origin_x_ + 0.28 * unit_x_, xmax = origin_x_ + 0.35 * unit_x_,
  #            ymin = origin_y_ + 0 * unit_y_, ymax = origin_y_ + 0.1 * unit_y_, fill = "white")
  # p <- p + annotate("text",
  #                   x = origin_x_ + 0.28 * unit_x_,
  #                   y = origin_y_ + 0.037 * unit_y_,
  #                   label = TeX("300 km"),
  #                   size = 4,
  #                   hjust = 0)
  
  # Save
  svg_device <- svglite(paste0(output_name_,".svg"))#,
  # width = 18)
  print(p)
  dev.off()
  
  saveRDS(p, file = paste0(output_name_,".rds"))
  
}


### Function ###
plot_map_variable_sansEtiquettes <- function(tab_, varname_, vartitle_, breaks_, output_name_, title_, reverseColors_, nomPalette_, labels_name_ = FALSE, sansTexteHer_ = FALSE, reverseLegend_ = FALSE, echelleAttenuee_ = FALSE, addValueUnder = NULL, HER2_excluesDensity_ = NULL, subtitle_ = NULL){
  
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
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 89)] = "89+92"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 92)] = "89+92"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 49)] = "49+90"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 90)] = "49+90"
  
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
  txt_ = read_lines(paste0(IPCCcolors_folder_,nomPalette_))
  length_color_ = max(as.numeric(str_after_last(grep("_", txt_, value = TRUE),"_")))
  
  if (reverseColors_ == T){
    if (echelleAttenuee_ == TRUE){
      # palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_),5),length_color_)))
      # palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_),5),14)))
      palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_)*2+1,5),28)))
      palette_col_ <- palette_col_[round(length(palette_col_)/2):length(palette_col_)]
    }else{
      # palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_)-1,5),length_color_)))
      # palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_)-1,5),14)))
      palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_)*2,5),28)))
      palette_col_ <- palette_col_[round(length(palette_col_)/2):length(palette_col_)]
    }
  }else{
    if (echelleAttenuee_ == TRUE){
      # palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_),5), length_color_))
      # palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_),5), 14))
      palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max((length(breaks_)-1)*2,5), 28))
      palette_col_ <- palette_col_[round(length(palette_col_)/2):length(palette_col_)]
    }else{
      # palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_)-1,5), length_color_))
      # palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_)-1,5), 14))
      palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max((length(breaks_)-1)*2,5), 28))
      palette_col_ <- palette_col_[round(length(palette_col_)/2):length(palette_col_)]
    }
  }
  # "#E8F2F0" "#F6F1E6" "#F6EAC9" "#ECD6A2" "#DDBE78" "#CB984A" "#B37525" "#955911" "#744308" "#543005"
  
  # Ajustement de la palette
  if (length(breaks_)-1 > length_color_){
    stop("Message personnel : Erreur, pas assez de couleurs disponibles dans ce fichier txt de couleurs")
  }else{
    if (is.null(addValueUnder)){
      if (echelleAttenuee_ == TRUE){
        palette_col_ <- palette_col_[2:(length(breaks_))]
      }else{
        palette_col_ <- palette_col_[1:(length(breaks_)-1)]
      }
    }else{
      # palette_col_ <- palette_col_[1:(length(breaks_)-2)]
      # palette_col_ <- palette_col_[1:(length(breaks_))]
      palette_col_ <- palette_col_[3:(length(breaks_))]
      palette_col_ <- c("white",palette_col_)
    }
  }

  # df_color_ = setNames(palette_col_,labels_name_)
  df_color_ = setNames(palette_col_,labels_)
  if (! is.null(HER2_excluesDensity_)){
    df_color_["Low data density"] = "white" # "#737373", #1d91c0
      # df_color_["Low data density"] = "#ffffff" # "#737373", #1d91c0
  }
  
  fr.df$var_cut_ <- factor(fr.df$var_cut_, levels=labels_)
  
  if (! is.null(HER2_excluesDensity_)){
    fr.df$var_cut_[which(fr.df$CdHER2 %in% HER2_excluesDensity_)] = "Low data density"
  }
  
  labels_name_annotation_ <- paste0(c(substr(str_before_first(labels_name_[1],","),2,nchar(str_before_first(labels_name_[1],","))),
                                      str_before_first(str_after_first(labels_name_,","),"]")),
                                    "%")
  
  unit_x_ = max(fr.df$long) - min(fr.df$long)
  unit_y_ = max(fr.df$lat) - min(fr.df$lat)
  origin_x_ = min(fr.df$long)
  origin_y_ = min(fr.df$lat)
  
  
  p <- ggplot() +
    geom_polygon(data=fr.df, aes(x=long, y=lat, group=group, fill=var_cut_), 
                 color="#454547", size = 0.3) +
    scale_fill_manual(values=df_color_,
                      name=vartitle_,
                      breaks=labels_,
                      labels=labels_name_annotation_[2:length(labels_name_annotation_)],
                      drop = F)
  if (sansTexteHer_ == FALSE){
    p <- p + geom_text(data = data.frame(x = her2_centers[,1], y = her2_centers[,2], label = her2_attrib),
                       aes(x = x, y = y, label = label),
                       color = "#2f2f32", size = 4, segment.alpha = 0.3,
                       force = 10)
  }
  p <- p + 
    theme(legend.position = c(0.92,0.5),
          axis.line = element_blank(),
          axis.text = element_blank(),
          axis.ticks = element_blank(),
          axis.title = element_blank(),
          legend.title = element_blank(),
          legend.text = element_text(size = 10, vjust = 1.2),
          legend.background = element_blank(),
          legend.key.height = unit(1.3, 'cm'),
          legend.spacing.y = unit(0, 'cm'),
          legend.margin = margin(0, 0, 0, 0), # Réduire les marges de la légende
          legend.box.spacing = unit(0, "cm"), # Réduire l'espacement interne de la légende
          panel.background = element_blank(),
          text = element_text(size = 26),
          plot.title = element_text(size = 30, hjust = 0.5))+
    guides(fill = guide_legend(reverse = reverseLegend_,
                               override.aes = list(linewidth = 0)))+
    coord_fixed(ratio = 1)
  
  # Texte legend
  # p <- p + annotate("text",
  #                   x = origin_x_ + 0.97 * unit_x_,
  #                   y = generer_positions(origin_y_ + 0.502 * unit_y_, 55500, length(labels_name_annotation_)),
  #                   label = TeX(labels_name_annotation_),
  #                   size = 18*25.4/72.27,
  #                   hjust = 0)
  
  # Titre
  # p <- p + annotate("text",
  #                   x = origin_x_ + 0 * unit_x_,
  #                   y = origin_y_ + 0.97 * unit_y_,
  #                   label = title_,
  #                   fontface = "bold",
  #                   # bold = T,
  #                   size = 30*25.4/72.27,
  #                   hjust = 0,
  #                   vjust = 0.5)
  # p <- p + annotate("text",
  #                   x = origin_x_ + 1 * unit_x_,
  #                   y = origin_y_ + 0.97 * unit_y_,
  #                   label = subtitle_,
  #                   size = 18*25.4/72.27,
  #                   hjust = "right",
  #                   vjust = 0.5)
  
  # Echelle
  p <- p + annotation_scale(location = "bl",
                            line_width = .8,
                            text_cex = 0.7,
                            # pad_x = unit(1.5, "cm"), pad_y = unit(2, "cm"),
                            style = 'ticks',
                            bar_cols = "#454547",
                            # color = "#454547",
                            text = element_blank()) +
    # annotation_north_arrow(location = "tr", height = unit(0.7, "cm"), width = unit(0.7, "cm"), text_cex = 0.2)#,
    # annotation_north_arrow(location = "tr",
    #                        height = unit(0.4, "cm"),
    #                        width = unit(0.4, "cm"),
    #                        text_cex = 0.2)#,
    
    annotation_north_arrow(location = "tr",
                           style = north_arrow_fancy_orienteering(text_col = "#454547",
                                                                  line_col = "#454547",
                                                                  fill = "#454547"),
                           which_north = "true",
                           pad_x = unit(0.1, "npc"),
                           pad_y = unit(0.1, "npc"),
                           height = unit(0.9, "cm"),
                           width = unit(0.7, "cm"))
  
  # annotation_north_arrow(location = "tr", height = unit(0.7, "cm"), width = unit(0.7, "cm"))#,
  # pad_x = unit(1.5, "cm"), pad_y = unit(3, "cm"))
  # p <- p +
  #   annotate("rect",
  #            xmin = origin_x_ + 0.28 * unit_x_, xmax = origin_x_ + 0.35 * unit_x_,
  #            ymin = origin_y_ + 0 * unit_y_, ymax = origin_y_ + 0.1 * unit_y_, fill = "white")
  # p <- p + annotate("text",
  #                   x = origin_x_ + 0.28 * unit_x_,
  #                   y = origin_y_ + 0.037 * unit_y_,
  #                   label = TeX("300 km"),
  #                   size = 4,
  #                   hjust = 0)
  print(p)
  
  # Save
  svg_device <- svglite(paste0(output_name_,"_sansEt.svg"))#,
  # width = 18)
  # x11()
  print(p)
  dev.off()
  
  saveRDS(p, file = paste0(output_name_,"_sansEt.rds"))
  
}





