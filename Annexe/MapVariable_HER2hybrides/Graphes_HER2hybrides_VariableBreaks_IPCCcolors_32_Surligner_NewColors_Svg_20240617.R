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
plot_map_variable <- function(tab_, varname_, vartitle_, breaks_, output_name_, title_, reverseColors_, nomPalette_, labels_name_ = FALSE, reverseLegend_ = FALSE, echelleAttenuee_ = FALSE, addValueUnder = NULL, HER2_excluesDensity_ = NULL, subtitle_ = NULL, annotation_txt_ = TRUE, percentFormat = T, borderCol = "#454547", doubleLegend_ = T, taillePalette = NULL, retenuPalette = NULL, reverseFinal = F, reverseFinal_bis = F){
  
  if (!(is.null(addValueUnder))){
    if (is.Date(tab_[[varname_]])){
      breaks_ <- c(as.Date(addValueUnder),as.Date(breaks_, origin = "1970-01-01"))
    }else{
      breaks_ <- c(addValueUnder,breaks_)
    }
  }
  
  labels_ <- paste0(ifelse(breaks_[-length(breaks_)] == min(breaks_[-length(breaks_)]), "[", "("),
                    breaks_[-length(breaks_)],",", breaks_[-1],"]")
  
  if (labels_name_ == FALSE){
    labels_name_ <- paste0(ifelse(breaks_[-length(breaks_)] == min(breaks_[-length(breaks_)]), "[", "("),
                           breaks_[-length(breaks_)],",", breaks_[-1],"]")
    labels_name_check_ <- FALSE
  }else{
    labels_name_ <- labels_name_
    labels_name_check_ <- TRUE
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
  if (is.Date(tab_[[varname_]])){
    fr.prj[[varname_]] <- as.Date(fr.prj[[varname_]], origin = "1970-01-01")
    fr.prj$var_cut_ <- as.character(cut(fr.prj[[varname_]],
                                        breaks=as.Date(breaks_),
                                        include.lowest = T,
                                        labels = labels_,
                                        na.rm = T))
  }else{
    fr.prj$var_cut_ <- as.character(cut(fr.prj[[varname_]],
                                        breaks=breaks_,
                                        include.lowest = T,
                                        labels = labels_))
  }
  
  
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
  
  if (doubleLegend_ == T){
    if (reverseColors_ == T){
      if (echelleAttenuee_ == TRUE){
        if (is.null(taillePalette)){
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_)*2+1,5),28)))
          palette_col_ <- palette_col_[round(length(palette_col_)/2):length(palette_col_)]
        }else{
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5),28)))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette):length(palette_col_)]
        }
      }else{
        if (is.null(taillePalette)){
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_)*2,5),28)))
          palette_col_ <- palette_col_[round(length(palette_col_)/2):length(palette_col_)]
        }else{
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5),28)))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette+2):length(palette_col_)]
        }
      }
    }else{
      if (echelleAttenuee_ == TRUE){
        if (is.null(taillePalette)){
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max((length(breaks_)-1)*2,5), 28))
          palette_col_ <- palette_col_[round(length(palette_col_)/2):length(palette_col_)]
        }else{
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5), 28))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette):length(palette_col_)]
        }
      }else{
        if (is.null(taillePalette)){
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max((length(breaks_)-1)*2,5), 28))
          palette_col_ <- palette_col_[round(length(palette_col_)/2):length(palette_col_)]
        }else{
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5), 28))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette+2):length(palette_col_)]
        }
      }
    }
  }else{
    if (reverseColors_ == T){
      if (echelleAttenuee_ == TRUE){
        if (is.null(taillePalette)){
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_),5),28)))
        }else{
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5),28)))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette):length(palette_col_)]
        }
      }else{
        if (is.null(taillePalette)){
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_) - 1,5),28)))
        }else{
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5),28)))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette+2):length(palette_col_)]
        }
      }
    }else{
      if (echelleAttenuee_ == TRUE){
        if (is.null(taillePalette)){
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max((length(breaks_)),5), 28))
        }else{
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5), 28))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette):length(palette_col_)]
        }
      }else{
        if (is.null(taillePalette)){
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max((length(breaks_)-1),5), 28))
        }else{
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5), 28))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette+2):length(palette_col_)]
        }
      }
    }
  }
  if (reverseFinal == T){
    palette_col_ <- rev(palette_col_)
  }
  # [1] "#262600" "#565527" "#8C8C55" "#C4C48E" "#E8E8D2" "#CEDAE5" "#8AA6C2" "#4A759F" "#284477" "#2B194C"
  
  
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
      palette_col_ <- palette_col_[1:(length(breaks_))]
      # palette_col_ <- palette_col_[3:(length(breaks_))]
      palette_col_ <- c("white",palette_col_)
    }
  }
  if (reverseFinal_bis == T){
    palette_col_ <- c("white",palette_col_[(length(palette_col_)-(length(labels_name_)-2)):length(palette_col_)])
    # palette_col_ <- rev(palette_col_)
    # temp <- palette_col_[1]
    # palette_col_[1] <- palette_col_[length(palette_col_)]
    # palette_col_[length(palette_col_)] <- temp
  }
  
  df_color_ = setNames(palette_col_,labels_)
  if (! is.null(HER2_excluesDensity_)){
    df_color_["Low data density"] = "#ffffff" # "#737373", #1d91c0
  }
  
  fr.df$var_cut_ <- factor(fr.df$var_cut_, levels=labels_)
  if (! is.null(HER2_excluesDensity_)){
    fr.df$var_cut_[which(fr.df$CdHER2 %in% HER2_excluesDensity_)] = "Low data density"
  }
  hatch_fill <- geom_hline(yintercept = seq(-2, 2, by = 0.5), color = "black", size = 0.5)
  
  # labels_name_annotation_ <- paste0(c(substr(str_before_first(labels_name_[1],","),2,nchar(str_before_first(labels_name_[1],","))),
  #                                     str_before_first(str_after_first(labels_name_,","),"]")))
  if (labels_name_check_ != TRUE){
    labels_name_annotation_ <- paste0(c(substr(str_before_first(labels_name_[1],","),2,nchar(str_before_first(labels_name_[1],","))),
                                        str_before_first(str_after_first(labels_name_,","),"]")))
  }else{
    if (is.null(addValueUnder)){
      labels_name_annotation_ <- labels_name_
    }else{
      labels_name_annotation_ <- c("",labels_name_)
    }
  }
  
  if (percentFormat == T){
    labels_name_annotation_ <- paste0(labels_name_annotation_,"%")
  }
  if (is.Date(tab_[[varname_]])){
    labels_name_annotation_ <- format(as.Date(labels_name_annotation_, origin = "1970-01-01"),"%d/%m")
  }
  
  unit_x_ = max(fr.df$long) - min(fr.df$long)
  unit_y_ = max(fr.df$lat) - min(fr.df$lat)
  origin_x_ = min(fr.df$long)
  origin_y_ = min(fr.df$lat)
  
  if (!is.null(addValueUnder)){
    fr.df$var_cut_[which(is.na(fr.df$var_cut_))] = levels(fr.df$var_cut_)[1]
  }
  
  if (grepl("J2000",output_name_)){
    fr.df.surligne <- fr.df[which(fr.df$CdHER2 %in% c("81")),]
  }else{
    fr.df.surligne <- fr.df[which(fr.df$CdHER2 %in% c("12","57","81","105")),]
  }
  
  # x11()
  p <- ggplot() +
    
    geom_polygon(data=fr.df, aes(x=long, y=lat, group=group, fill=var_cut_), 
                 color=borderCol, size = 0.3) +
    scale_fill_manual(values=df_color_,
                      name=vartitle_,
                      breaks=labels_,
                      labels=labels_name_annotation_[2:length(labels_name_annotation_)],
                      drop = F,
                      na.value = "grey45") +
    geom_polygon(data=fr.df.surligne, aes(x=long, y=lat, group=group), fill = NA, color = "#800080", linewidth = 1)
  
  if (paste0(varname_,"_IC95inf") %in% colnames(tab_)){
    p <- p + geom_label_repel(data = data.frame(x = her2_centers[,1], y = her2_centers[,2],
                                                label = paste0(her2_attrib, ifelse(is.na(fr.prj[[varname_]]),"",paste0(" : ",round(fr.prj[[varname_]],2),"\n[",round(fr.prj[[paste0(varname_,"_IC95inf")]],2),";",round(fr.prj[[paste0(varname_,"_IC95sup")]],2),"]")))),
                              aes(x = x, y = y, label = label),
                              fill.alpha = 0.5,
                              box.padding = 0.5,
                              col = "#2f2f32", size = 3, segment.alpha = 1,
                              force = 10)
  }else{
    p <- p + geom_label_repel(data = data.frame(x = her2_centers[,1], y = her2_centers[,2],
                                                label = paste0(her2_attrib, ifelse(is.na(fr.prj[[varname_]]),"",paste0(" : ",round(fr.prj[[varname_]],2))))),
                              aes(x = x, y = y, label = label),
                              fill.alpha = 0.5,
                              box.padding = 0.5,
                              col = "#2f2f32", size = 3, segment.alpha = 1,
                              force = 10)
  }
  p <- p + 

        theme(plot.title = element_text(color = "#060403", size = 30, face = "bold", hjust = 0),
          plot.subtitle = element_text(color = "#454547", size = 18),
          
          axis.title = element_blank(),
          axis.text = element_blank(),
          axis.line = element_blank(),
          axis.ticks = element_blank(),
          
          panel.background = element_blank(),
          panel.grid = element_blank(),
          panel.border = element_blank(),
          
          text = element_text(size = 26),
          
          legend.position = c(1.15,0.45),
          # legend.position = c(1.1,0.5),
          # legend.title = element_blank(),
          legend.title = element_text(color = "#454547", size = 18, vjust = 5, hjust = 0),
          # legend.title.align = 0,
          legend.text = element_text(color = "#454547", size = 18, vjust = 1.3, hjust = 0),
          legend.background = element_blank(),
          legend.key.height = unit(1.3, 'cm'),
          legend.spacing.y = unit(0, 'cm'),
          legend.margin = margin(0, 0, 0, 0), # Réduire les marges de la légende
          legend.box.spacing = unit(0, "cm"))+ # Réduire l'espacement interne de la légende
    
    guides(fill = guide_legend(reverse = reverseLegend_,
                               override.aes = list(linewidth = 0)))+
    coord_fixed(ratio = 1)
  
  if (annotation_txt_){
    
    # Texte legend
    # p <- p + annotate("text",
    #                   x = origin_x_ + 0.97 * unit_x_,
    #                   y = generer_positions(origin_y_ + 0.502 * unit_y_, 55500, length(labels_name_annotation_)),
    #                   label = TeX(labels_name_annotation_),
    #                   size = 18*25.4/72.27,
    #                   color = "#454547",
    #                   hjust = 0)
    
    # Titre
    p <- p + annotate("text",
                      x = origin_x_ - 0.15 * unit_x_,
                      # x = origin_x_ + 0 * unit_x_,
                      y = origin_y_ + 0.97 * unit_y_,
                      label = title_,
                      fontface = "bold",
                      # bold = T,
                      size = 30*25.4/72.27,
                      color = "#2f2f32",
                      hjust = 0,
                      vjust = 0.5)
    p <- p + annotate("text",
                      x = origin_x_ + 1.1 * unit_x_,
                      # x = origin_x_ + 1 * unit_x_,
                      y = origin_y_ + 0.97 * unit_y_,
                      label = subtitle_,
                      size = 18*25.4/72.27,
                      color = "#454547",
                      hjust = "right",
                      vjust = 0.5)
  }
  
  # Echelle
  p <- p + annotation_scale(location = "bl",
                            line_width = .8,
                            text_cex = 0.7,
                            pad_x = unit(0.05, "npc"),
                            pad_y = unit(0.05, "npc"),
                            style = 'ticks',
                            bar_cols = "#454547",
                            text = element_blank())
  if (annotation_txt_){
    p <- p + annotation_north_arrow(location = "bl",
                                    style = north_arrow_fancy_orienteering(text_col = "#454547",
                                                                           line_col = "#454547",
                                                                           fill = "#454547"),
                                    which_north = "true",
                                    pad_x = unit(0.05, "npc"),
                                    pad_y = unit(0.08, "npc"),
                                    height = unit(0.9, "cm"),
                                    width = unit(0.7, "cm"))
  }else{
    p <- p + annotation_north_arrow(location = "tr",
                                    style = north_arrow_fancy_orienteering(text_col = "#454547",
                                                                           line_col = "#454547",
                                                                           fill = "#454547"),
                                    which_north = "true",
                                    # pad_x = unit(0.05, "npc"),
                                    # pad_y = unit(0.08, "npc"),
                                    height = unit(0.9, "cm"),
                                    width = unit(0.7, "cm"))
  }
  
  # Save
  if (annotation_txt_){
    pdf(paste0(output_name_,
               ".pdf"),
        width = 18)
    print(p)
    dev.off()
    
    saveRDS(p, file = paste0(output_name_,".rds"))
    
    svg_device <- svglite(paste0(output_name_,".svg"), width = 18)#,
    print(p)
    dev.off()
    
    png(paste0(output_name_,".png"), width = 9*100)
    print(p)
    dev.off()
  }else{
    pdf(paste0(output_name_,
               "_sansTxt.pdf"),
        width = 18)
    print(p)
    dev.off()
    
    saveRDS(p, file = paste0(output_name_,"_sansTxt.rds"))
    
    svg_device <- svglite(paste0(output_name_,"_sansTxt.svg"), width = 18)#,
    print(p)
    dev.off()
    
    png(paste0(output_name_,"_sansTxt.png"), width = 9*100)
    print(p)
    dev.off()
  }
}


### Function ###
plot_map_variable_sansEtiquettes <- function(tab_, varname_, vartitle_, breaks_, output_name_, title_, reverseColors_, nomPalette_, labels_name_ = FALSE, sansTexteHer_ = FALSE, reverseLegend_ = FALSE, echelleAttenuee_ = FALSE, addValueUnder = NULL, HER2_excluesDensity_ = NULL, subtitle_ = NULL, annotation_txt_ = TRUE, percentFormat = T, borderCol = "#454547", doubleLegend_ = T, taillePalette = NULL, retenuPalette = NULL, reverseFinal = F, reverseFinal_bis = F){
  
  if (!(is.null(addValueUnder))){
    if (is.Date(tab_[[varname_]])){
      breaks_ <- c(as.Date(addValueUnder),as.Date(breaks_, origin = "1970-01-01"))
    }else{
      breaks_ <- c(addValueUnder,breaks_)
    }
  }
  
  labels_ <- paste0(ifelse(breaks_[-length(breaks_)] == min(breaks_[-length(breaks_)]), "[", "("),
                    breaks_[-length(breaks_)],",", breaks_[-1],"]")
  
  if (labels_name_ == FALSE){
    labels_name_ <- paste0(ifelse(breaks_[-length(breaks_)] == min(breaks_[-length(breaks_)]), "[", "("),
                           breaks_[-length(breaks_)],",", breaks_[-1],"]")
    labels_name_check_ <- FALSE
  }else{
    labels_name_ <- labels_name_
    labels_name_check_ <- TRUE
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
  
  if (is.Date(tab_[[varname_]])){
    fr.prj[[varname_]] <- as.Date(fr.prj[[varname_]], origin = "1970-01-01")
    fr.prj$var_cut_ <- cut(fr.prj[[varname_]],
                           breaks=as.Date(breaks_),
                           include.lowest = T,
                           label = labels_,
                           na.rm = T)
  }else{
    fr.prj$var_cut_ <- cut(fr.prj[[varname_]],
                           breaks=breaks_,
                           include.lowest = T,
                           label = labels_)
  }
  
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
  
  if (doubleLegend_ == T){
    if (reverseColors_ == T){
      if (echelleAttenuee_ == TRUE){
        if (is.null(taillePalette)){
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_)*2+1,5),28)))
          palette_col_ <- palette_col_[round(length(palette_col_)/2):length(palette_col_)]
        }else{
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5),28)))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette):length(palette_col_)]
        }
      }else{
        if (is.null(taillePalette)){
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_)*2,5),28)))
          palette_col_ <- palette_col_[round(length(palette_col_)/2):length(palette_col_)]
        }else{
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5),28)))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette+2):length(palette_col_)]
        }
      }
    }else{
      if (echelleAttenuee_ == TRUE){
        if (is.null(taillePalette)){
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max((length(breaks_)-1)*2,5), 28))
          palette_col_ <- palette_col_[round(length(palette_col_)/2):length(palette_col_)]
        }else{
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5), 28))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette):length(palette_col_)]
        }
      }else{
        if (is.null(taillePalette)){
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max((length(breaks_)-1)*2,5), 28))
          palette_col_ <- palette_col_[round(length(palette_col_)/2):length(palette_col_)]
        }else{
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5), 28))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette+2):length(palette_col_)]
        }
      }
    }
  }else{
    if (reverseColors_ == T){
      if (echelleAttenuee_ == TRUE){
        if (is.null(taillePalette)){
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_),5),28)))
        }else{
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5),28)))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette):length(palette_col_)]
        }
      }else{
        if (is.null(taillePalette)){
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_) - 1,5),28)))
        }else{
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5),28)))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette+2):length(palette_col_)]
        }
      }
    }else{
      if (echelleAttenuee_ == TRUE){
        if (is.null(taillePalette)){
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max((length(breaks_)),5), 28))
        }else{
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5), 28))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette):length(palette_col_)]
        }
      }else{
        if (is.null(taillePalette)){
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max((length(breaks_)-1),5), 28))
        }else{
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5), 28))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette+2):length(palette_col_)]
        }
      }
    }
  }
  if (reverseFinal == T){
    palette_col_ <- rev(palette_col_)
  }
  # "#003C30" "#015248" "#046860" "#23827A" "#3E9D94" "#66B9AE" "#8CD2C7" "#B1E1DA"
  # [1] "#D7B067" "#EEDAA9" "#F6EFDE" "#E0F0EE" "#AEE0D8" "#6DBEB3" "#2D8E86" "#01625A" "#003C30"
  
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
      palette_col_ <- palette_col_[1:(length(breaks_))]
      # palette_col_ <- palette_col_[3:(length(breaks_))]
      palette_col_ <- c("white",palette_col_)
    }
  }
  if (reverseFinal_bis == T){
    palette_col_ <- c("white",palette_col_[(length(palette_col_)-(length(labels_name_)-2)):length(palette_col_)])
    # palette_col_ <- rev(palette_col_)
    # temp <- palette_col_[1]
    # palette_col_[1] <- palette_col_[length(palette_col_)]
    # palette_col_[length(palette_col_)] <- temp
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
  
  if (labels_name_check_ != TRUE){
    labels_name_annotation_ <- paste0(c(substr(str_before_first(labels_name_[1],","),2,nchar(str_before_first(labels_name_[1],","))),
                                        str_before_first(str_after_first(labels_name_,","),"]")))
  }else{
    if (is.null(addValueUnder)){
      labels_name_annotation_ <- labels_name_
    }else{
      labels_name_annotation_ <- c("",labels_name_)
    }
  }
  
  if (percentFormat == T){
    labels_name_annotation_ <- paste0(labels_name_annotation_,"%")
  }
  if (is.Date(tab_[[varname_]])){
    labels_name_annotation_ <- format(as.Date(labels_name_annotation_, origin = "1970-01-01"),"%d/%m")
  }
  
  unit_x_ = max(fr.df$long) - min(fr.df$long)
  unit_y_ = max(fr.df$lat) - min(fr.df$lat)
  origin_x_ = min(fr.df$long)
  origin_y_ = min(fr.df$lat)
  
  if (!is.null(addValueUnder)){
    fr.df$var_cut_[which(is.na(fr.df$var_cut_))] = levels(fr.df$var_cut_)[1]
  }
  
  if (grepl("J2000",output_name_)){
    fr.df.surligne <- fr.df[which(fr.df$CdHER2 %in% c("81")),]
  }else{
    fr.df.surligne <- fr.df[which(fr.df$CdHER2 %in% c("12","57","81","105")),]
  }
  
  p <- ggplot() +
    geom_polygon(data=fr.df, aes(x=long, y=lat, group=group, fill=var_cut_), 
                 color=borderCol, size = 0.3) +
    scale_fill_manual(values=df_color_,
                      name=vartitle_,
                      breaks=labels_,
                      labels=labels_name_annotation_[2:length(labels_name_annotation_)],
                      drop = F,
                      na.value = "grey45") +
    geom_polygon(data=fr.df.surligne, aes(x=long, y=lat, group=group), fill = NA, color = "#800080", linewidth = 1)
  if (sansTexteHer_ == FALSE){
    p <- p + geom_text(data = data.frame(x = her2_centers[,1], y = her2_centers[,2], label = her2_attrib),
                       aes(x = x, y = y, label = label),
                       color = "#2f2f32", size = 4, segment.alpha = 0.3,
                       force = 10)
  }
  p <- p + 
    theme(plot.title = element_text(color = "#060403", size = 30, face = "bold", hjust = 0.5),
          plot.subtitle = element_text(color = "#2f2f32", size = 18),
          
          axis.title = element_blank(),
          axis.text = element_blank(),
          axis.line = element_blank(),
          axis.ticks = element_blank(),
          
          panel.background = element_blank(),
          panel.grid = element_blank(),
          panel.border = element_blank(),
          
          text = element_text(size = 26),
          
          legend.position = c(1.15,0.45),
          # legend.position = c(1.1,0.5),
          # legend.title = element_blank(),
          legend.title = element_text(color = "#454547", size = 18, vjust = 5, hjust = 0),
          # legend.title.align = 0.5,
          legend.text = element_text(color = "#454547", size = 18, vjust = 1.3, hjust = 0),
          legend.background = element_blank(),
          legend.key.height = unit(1.3, 'cm'),
          legend.spacing.y = unit(0, 'cm'),
          legend.margin = margin(0, 0, 0, 0), # Réduire les marges de la légende
          legend.box.spacing = unit(0, "cm"))+ # Réduire l'espacement interne de la légende
    
    guides(fill = guide_legend(reverse = reverseLegend_,
                               override.aes = list(linewidth = 0)))+
    coord_fixed(ratio = 1)
  
  if (annotation_txt_){
    
    # Texte legend
    # p <- p + annotate("text",
    #                   x = origin_x_ + 0.97 * unit_x_,
    #                   y = generer_positions(origin_y_ + 0.502 * unit_y_, 55500, length(labels_name_annotation_)),
    #                   label = TeX(labels_name_annotation_),
    #                   size = 18*25.4/72.27,
    #                   hjust = 0)
    
    # Titre
    p <- p + annotate("text",
                      x = origin_x_ - 0.15 * unit_x_,
                      # x = origin_x_ + 0 * unit_x_,
                      y = origin_y_ + 0.97 * unit_y_,
                      label = title_,
                      fontface = "bold",
                      # bold = T,
                      size = 30*25.4/72.27,
                      color = "#2f2f32",
                      hjust = 0,
                      vjust = 0.5)
    p <- p + annotate("text",
                      # x = origin_x_ + 1 * unit_x_,
                      x = origin_x_ + 1.1 * unit_x_,
                      y = origin_y_ + 0.97 * unit_y_,
                      label = subtitle_,
                      size = 18*25.4/72.27,
                      color = "#454547",
                      hjust = "right",
                      vjust = 0.5)
  }
  
  # Echelle
  p <- p + annotation_scale(location = "bl",
                            line_width = .8,
                            text_cex = 0.7,
                            pad_x = unit(0.05, "npc"),
                            pad_y = unit(0.05, "npc"),
                            style = 'ticks',
                            bar_cols = "#454547",
                            text = element_blank())
  if (annotation_txt_){
    p <- p + annotation_north_arrow(location = "bl",
                                    style = north_arrow_fancy_orienteering(text_col = "#454547",
                                                                           line_col = "#454547",
                                                                           fill = "#454547"),
                                    which_north = "true",
                                    pad_x = unit(0.05, "npc"),
                                    pad_y = unit(0.08, "npc"),
                                    height = unit(0.9, "cm"),
                                    width = unit(0.7, "cm"))
  }else{
    p <- p + annotation_north_arrow(location = "tr",
                                    style = north_arrow_fancy_orienteering(text_col = "#454547",
                                                                           line_col = "#454547",
                                                                           fill = "#454547"),
                                    which_north = "true",
                                    # pad_x = unit(0.05, "npc"),
                                    # pad_y = unit(0.08, "npc"),
                                    height = unit(0.9, "cm"),
                                    width = unit(0.7, "cm"))
  }
  
  # Save
  if (annotation_txt_){
    pdf(paste0(output_name_,
               "_sansEt.pdf"),
        width = 18)
    print(p)
    dev.off()
    
    saveRDS(p, file = paste0(output_name_,"_sansEt.rds"))
    
    svg_device <- svglite(paste0(output_name_,"_sansEt.svg"), width = 18)#,
    print(p)
    dev.off()
    
    png(paste0(output_name_,"_sansEt.png"), width = 9*100)
    print(p)
    dev.off()
  }else{
    pdf(paste0(output_name_,
               "_sansTxt_sansEt.pdf"),
        width = 18)
    print(p)
    dev.off()
    
    saveRDS(p, file = paste0(output_name_,"_sansTxt_sansEt.rds"))
    
    svg_device <- svglite(paste0(output_name_,"_sansTxt_sansEt.svg"), width = 18)#,
    print(p)
    dev.off()
    
    png(paste0(output_name_,"_sansTxt_sansEt.png"), width = 9*100)
    print(p)
    dev.off()
  }
  
}





