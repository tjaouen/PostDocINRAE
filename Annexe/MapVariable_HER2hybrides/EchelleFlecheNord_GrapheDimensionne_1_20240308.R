fr.spdf <- readOGR("/home/tjaouen/Documents/Input/HER/HER2hybrides/Shapefile/","HER2_hybrides")
proj4string(fr.spdf)=CRS("+proj=longlat +ellps=WGS84")
fr.prj <- spTransform(fr.spdf, CRS("+init=epsg:2154")) # trasnformation en Lambert93
fr.df <- fortify(fr.prj)
fr.df <- merge(fr.df, as.data.frame(fr.prj@data), by.x = "id", by.y = "row.names", all = TRUE)

p <- ggplot() +
  geom_polygon(data=fr.df,
               aes(x=long, y=lat, group = group), 
               color="white",alpha = 1, fill = "white", size = 0.3) +
  # ylim(6800000,6940000) +
  annotation_scale(location = "tl",
                   line_width = .8,
                   text_cex = 0.7,
                   # pad_x = unit(1.5, "cm"), pad_y = unit(2, "cm"),
                   style = 'ticks',
                   text = element_blank()) +
  annotation_north_arrow(location = "tr",
                         which_north = "true",
                         # pad_x = unit(0.1, "npc"),
                         # pad_y = unit(0.1, "npc"),
                         height = unit(0.9, "cm"),
                         width = unit(0.7, "cm"))+
  theme_void() +
  theme(plot.margin = unit(c(0,0,0,0), 'cm'),
        legend.position = c(0.92,0.5),
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
p

saveRDS(p, "/home/tjaouen/Documents/Input/FondsCartes/EchelleNord/EchelleNordGraph_1_20240308.rds")
