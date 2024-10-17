tab_
varname_
vartitle_
breaks_
output_name_
title_
reverseColors_
nomPalette_
labels_name_ = FALSE
sansTexteHer_ = FALSE
reverseLegend_ = FALSE
echelleAttenuee_ = FALSE
addValueUnder = NULL
HER2_excluesDensity_ = NULL
  
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

# Legende des HER 2
# Extraire les coordonnées des centres de chaque polygone d'hydroécorégion de niveau 2
her2_centers <- coordinates(gCentroid(fr.prj, byid=TRUE))

# Extraire l'attribut "NUM_HER2" de chaque polygone d'hydroécorégion de niveau 2
her2_attrib <- fr.prj$CdHER2

# Convertir fr.prj en un dataframe utilisable dans ggplot2
fr.df <- fortify(fr.prj)
fr.df <- merge(fr.df, as.data.frame(fr.prj@data), by.x = "id", by.y = "row.names", all = TRUE)

# Créer la palette de couleurs SurfaceHydroPropSurfHER2
p <- ggplot() +
  geom_polygon(data=fr.df, aes(x=long, y=lat, group = group), fill  = "white", color="black") +
  scale_fill_manual(values=df_color_)

p <- p + geom_text(data = data.frame(x = her2_centers[,1], y = her2_centers[,2], label = her2_attrib),
                   aes(x = x, y = y, label = label),
                   col = "black", size = 2.5, segment.alpha = 0.3,
                   force = 10)

p <- p +
  guides(fill = guide_legend(reverse = reverseLegend_,
                             keywidth = 2,
                             keyheight = 2)) + # Inverser l'ordre de la légende de remplissage
  theme(axis.line = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        axis.title = element_blank(),
        panel.background = element_blank(),
        text = element_text(size = 22),
        plot.title = element_text(size = 22, hjust = 0.5))+
  coord_fixed(ratio = 1)

p <- p + annotation_scale(location = "bl", line_width = .8, text_cex = 1) +
  annotation_north_arrow(location = "tl", height = unit(0.7, "cm"), width = unit(0.7, "cm"))

p

pdf("/home/tjaouen/Documents/Input/HER/HER2hybrides/HER2hybrides_VersionJonctions_1_20240115.pdf",
    height = 10, width = 10)
print(p)
dev.off()

saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))


