### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")

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
library(ggnewscale)

### Functions ###
generer_positions <- function(position_centrale, pas, taille) {
  positions <- seq(position_centrale - (taille - 1) * pas / 2, 
                   position_centrale + (taille - 1) * pas / 2, 
                   by = pas)
  return(positions)
}

### Parameters ###
folder_output_ = folder_output_param_
nomSim_ = nomSim_param_
jourMin_ = jourMin_param_
jourMax_ = jourMax_param_
nom_categorieSimu_ = nom_categorieSimu_param_
nom_apprentissage_ = nom_apprentissage_param_
nom_validation_ = nom_validation_param_
annees_validModels_ = annees_validModels_param_
nom_GCM_ = nom_GCM_param_
folder_input_ = folder_input_param_
HER_ = HER_param_

sansTexteHer_ = T
HER2_excluesDensity_ = NULL

### Import HER2 ###
fr.frontieres <- readOGR("/home/tjaouen/Documents/Input/FondsCartes/ContoursAdministratifs/FRA_adm_shp/","FRA_adm0")
proj4string(fr.frontieres)=CRS("+proj=longlat +ellps=WGS84")
fr.frontieres <- spTransform(fr.frontieres, CRS("+init=epsg:2154")) # trasnformation en Lambert93

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

HER_[which(HER_ == 31033039)] = "31+33+39"
HER_[which(HER_ == 37054)] = "37+54"
HER_[which(HER_ == 69096)] = "69+96"
HER_[which(HER_ == 89092)] = "89+92"
HER_[which(HER_ == 49090)] = "49+90"

# Legende des HER 2
# Extraire les coordonnées des centres de chaque polygone d'hydroécorégion de niveau 2
her2_centers <- coordinates(gCentroid(fr.prj, byid=TRUE))

# Extraire l'attribut "NUM_HER2" de chaque polygone d'hydroécorégion de niveau 2
her2_attrib <- fr.prj$CdHER2

# Convertir fr.prj en un dataframe utilisable dans ggplot2
fr.df <- fortify(fr.prj)
fr.df <- merge(fr.df, as.data.frame(fr.prj@data), by.x = "id", by.y = "row.names", all = TRUE)

# Coordonnees
unit_x_ = max(fr.df$long) - min(fr.df$long)
unit_y_ = max(fr.df$lat) - min(fr.df$lat)
origin_x_ = min(fr.df$long)
origin_y_ = min(fr.df$lat)

fr.df.surligne <- fr.df[which(fr.df$CdHER2 %in% c("12","57","81","105")),]

# fr.df$var_cut_ <- "#ffffff"
# fr.df$var_cut_[which(as.numeric(fr.df$CdHER2) == HER_h_)] <- "#037398"
# fr.df$var_cut_ <- factor(fr.df$var_cut_, levels = c("#ffffff","#037398"))
# fr.df = fr.df[which(fr.df$CdHER2 == HER_h_),]

# HER_h_ <- c(105,36,12)
# fr.df_HER_ = fr.df[which(fr.df$CdHER2 %in% HER_h_),]
# fr.df_HER_$var_cut_ <- "#037398"

p <- ggplot() +
  geom_polygon(data=fr.frontieres, aes(x=long, y=lat, group=group), fill = NA,
               color="grey38", linewidth = 0.3) +
  geom_polygon(data=fr.df, aes(x=long, y=lat, group=group), fill="white", color = "black", linewidth = 0.3) +
  geom_polygon(data=fr.df.surligne, aes(x=long, y=lat, group=group), fill = NA,
               color = "#800080", linewidth = 1)

# scale_fill_manual(values=c("#ffffff"),
#                   breaks=c("#ffffff"),
#                   drop = F)
# p <- p +
  # geom_polygon(data=fr.df, aes(x=long, y=lat, group=group), fill="white", color = "black", linewidth = 0.3) +
  # geom_polygon(data=fr.df.surligne, aes(x=long, y=lat, group=group), fill="white", color = "black", linewidth = 0.7)
# scale_fill_manual(values=c("#037398"),
#                   breaks=c("#037398"))+
# new_scale_color()+
# geom_polygon(data=fr.frontieres, aes(x=long, y=lat, group=group), fill = NA,
#              color="grey38",
#              size = 0.3)

# p <- p + geom_text(data = data.frame(x = her2_centers[,1], y = her2_centers[,2], label = her2_attrib),
#                    aes(x = x, y = y, label = label),
#                    col = "grey38", size = 4, segment.alpha = 0.3,
#                    force = 10)
p <- p + 
  theme(axis.line = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        axis.title = element_blank(),
        legend.position = "none",
        legend.title = element_blank(),
        legend.text = element_blank(),
        panel.background = element_blank(),
        text = element_text(size = 26),
        plot.title = element_text(size = 30, hjust = 0.5))+
  coord_fixed(ratio = 1)

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
                          line_width = 1.5,
                          # text_cex = 1.2,
                          text_cex = 1.3,
                          # pad_x = unit(40, "points"),
                          # pad_y = unit(60, "points"),
                          style = 'ticks')+#,
  # text = element_blank()) +
  annotation_north_arrow(location = "tr",
                         height = unit(1, "cm"),
                         width = unit(1, "cm"),
                         style = north_arrow_fancy_orienteering(text_col = "grey38",
                                                                line_col = "grey38",
                                                                fill = "grey38"))#,
# pad_x = unit(40, "points"),
# pad_y = unit(90, "points"))#,
# pad_x = unit(1.5, "cm"),
# pad_y = unit(3, "cm"))
# p <- p +
#   annotate("rect",
#            xmin = origin_x_ + 0.255 * unit_x_, xmax = origin_x_ + 0.35 * unit_x_,
#            ymin = origin_y_ + 0 * unit_y_, ymax = origin_y_ + 0.1 * unit_y_, fill = "white")
# p <- p + annotate("text",
#                   x = origin_x_ + 0.26 * unit_x_,
#                   y = origin_y_ + 0.034 * unit_y_,
#                   label = TeX("300 km"),
#                   size = 4,
#                   hjust = 0)
# p



# Save
svg_device <- svglite(paste0("/home/tjaouen/Documents/Input/HER/HER2hybrides/MapGenerale/MapHER_sansEt_1_20240626.svg"),
                      width = 18)
print(p)
dev.off()

saveRDS(p, file = paste0("/home/tjaouen/Documents/Input/HER/HER2hybrides/MapGenerale/MapHER_sansEt_1_20240626.rds"))

# x11()
ggsave(paste0("/home/tjaouen/Documents/Input/HER/HER2hybrides/MapGenerale/MapHER_sansEt_1_20240626.png"),
       plot = p)

