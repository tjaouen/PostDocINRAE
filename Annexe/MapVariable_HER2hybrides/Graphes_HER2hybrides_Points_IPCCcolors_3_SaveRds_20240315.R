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
plot_map_variable_points <- function(tab_, vartitle_, output_name_, title_, nomX, nomY, color, annotation_txt_ = T){
  
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
    geom_polygon(data=fr.df, aes(x=long, y=lat, group = group),
                 fill="white",
                 color="#454547", size = 0.3) +
    
    # Ajout des points à partir des coordonnées dans la table
    geom_point(data=tab_, aes(x = !!sym(nomX), y = !!sym(nomY), color = color), size = 1) +
    scale_color_manual(name= "",
                       values = color,
                       labels = vartitle_)
  
  p <- p + ggtitle(title_) +
    # guides(fill = guide_legend(reverse = reverseLegend_)) + # Inverser l'ordre de la légende de remplissage
    theme_minimal() +
    theme(axis.line = element_blank(),
          axis.text = element_blank(),
          axis.ticks = element_blank(),
          # axis.line = element_line(color = rgb(0.6,0.6,0.6)),
          # axis.text = element_text(size = 10, color = rgb(0.6,0.6,0.6)),
          # axis.ticks = element_line(color = rgb(0.6,0.6,0.6)),
          axis.title = element_blank(),
          # panel.background = element_blank(),
          panel.background = element_rect(fill = "transparent", colour = NA),
          panel.grid = element_blank(),
          panel.border = element_blank(),
          legend.key = element_blank(),
          text = element_text(size = 26),
          plot.title = element_text(size = 30, hjust = 0.5))+
    coord_fixed(ratio = 1)
  
  p <- p + #annotation_scale(location = "bl", line_width = .5) +
    # annotation_north_arrow(location = "tl", height = unit(0.7, "cm"), width = unit(0.7, "cm")) +
    guides(color=guide_legend(override.aes=list(size=4)))
  
  # Echelle
  p <- p + annotation_scale(location = "bl",
                            line_width = 1.5,
                            text_cex = 1.5,
                            # line_width = .8,
                            # text_cex = 0.7,
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
  
  # png(output_name_,
  #     width = 1600, #height = 750,
  #     units = "px", pointsize = 12)
  # 
  # # png(output_name_,
  # #     width = 900, #height = 750,
  # #     units = "px", pointsize = 12)
  # print(p)
  # dev.off()
  
  pdf(paste0(output_name_,
             ".pdf"),
      width = 18)
  print(p)
  dev.off()
  
  saveRDS(p, file = paste0(output_name_,".rds"))
  
  svg_device <- svglite(paste0(output_name_,".svg"))#,
  print(p)
  dev.off()
  
  saveRDS(p, file = paste0(output_name_, ".rds"))
  
  ggsave(paste0(output_name_,".png"),
         plot = p)
  
}



