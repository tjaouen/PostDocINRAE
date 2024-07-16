# Créer la carte
library(sf)
library(ggplot2)
library(ggspatial)

chemin_Europe <- "/home/tjaouen/Documents/Input/FondsCartes/ContoursAdministratifs/Europe/Europe_merged.shp"
chemin_France <- "/home/tjaouen/Documents/Input/FondsCartes/ContoursAdministratifs/FRA_adm_shp/FRA_adm0.shp"
chemin_CoursEau <- "/home/tjaouen/Documents/Input/FondsCartes/ContoursHydrologiques/CoursEau/COURS_D_EAU.shp"
chemin_points_Explore2 <- "/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DescriptionPointsSimulation/FichierCorrespondancesLH/Shp/Shp_20231128/TableCorrespondance_Selection_points_simulation_V20230510_TJ20231120_CorrectionDeuxPointsSmash_SansNA_20231128.shp"

Europe_ <- st_read(chemin_Europe)
France_ <- st_read(chemin_France)
CoursEau_ <- st_read(chemin_CoursEau)
PointsExp2_ <- st_read(chemin_points_Explore2)

Europe_ <- st_transform(Europe_, "+proj=lcc +lat_1=44 +lat_2=49 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +datum=WGS84 +units=m +no_defs")
CoursEau_ <- st_transform(CoursEau_, "+proj=lcc +lat_1=44 +lat_2=49 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +datum=WGS84 +units=m +no_defs")
CoursEau_ <- CoursEau_[which(as.numeric(CoursEau_$CLASSE) < 4),]
PointsExp2_ <- st_transform(PointsExp2_, "+proj=lcc +lat_1=44 +lat_2=49 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +datum=WGS84 +units=m +no_defs")



# Définir les limites de la fenêtre en Lambert 93 pour l'Europe
limites_europe <- st_bbox(Europe_, crs = st_crs(2154))  # Code EPSG 2154 pour Lambert 93

# Coordonnées de Paris et de Vienne en Lambert 93
paris_coord <- st_transform(st_sfc(st_point(c(2.3522, 48.8566)), crs = 4326), crs = st_crs(2154))
lyon_coord <- st_transform(st_sfc(st_point(c(4.8357, 45.7640)), crs = 4326), crs = st_crs(2154))
vienne_coord <- st_transform(st_sfc(st_point(c(16.3738, 48.2082)), crs = 4326), crs = st_crs(2154))
France_coord <- st_transform(st_sfc(st_point(c(-10, 47)), crs = 4326), crs = st_crs(2154))
Austria_coord <- st_transform(st_sfc(st_point(c(12, 47)), crs = 4326), crs = st_crs(2154))


# Extraire les coordonnées sous forme de dataframe
paris_df <- as.data.frame(st_coordinates(paris_coord))
lyon_df <- as.data.frame(st_coordinates(lyon_coord))
vienne_df <- as.data.frame(st_coordinates(vienne_coord))
France_df <- as.data.frame(st_coordinates(France_coord))
Austria_df <- as.data.frame(st_coordinates(Austria_coord))

# Renommer les colonnes
colnames(paris_df) <- c("lon", "lat")
colnames(lyon_df) <- c("lon", "lat")
colnames(vienne_df) <- c("lon", "lat")
colnames(France_df) <- c("lon", "lat")
colnames(Austria_df) <- c("lon", "lat")

# Définir les nouvelles limites pour le zoom
nouvelles_limites <- list(
  xlim = c(-500000, 1900000),  # Par exemple, ajustez ces valeurs selon vos besoins
  ylim = c(5500000, 7700000)  # Par exemple, ajustez ces valeurs selon vos besoins
)

# Créer la carte avec les nouvelles limites
# x11()
p_Europe_ <- ggplot() +
  geom_sf(data = Europe_, fill = "white", alpha = 0, color = "#454547", lwd = 0.4) +
  geom_sf(data = CoursEau_, color = "#a6bddb", lwd = 0.3) +
  geom_point(data = paris_df, aes(x = lon, y = lat), color = "#454547", size = 3) +  # Ajouter les points de Paris
  geom_point(data = lyon_df, aes(x = lon, y = lat), color = "#454547", size = 3) +  # Ajouter les points de Paris
  geom_point(data = vienne_df, aes(x = lon, y = lat), color = "#454547", size = 3) +  # Ajouter les points de Vienne
  geom_text(data = paris_df, aes(x = lon, y = lat-40000, label = "Paris"), color = "#454547", size = 5, nudge_y = 5000) + # Ajouter le texte "Paris"
  geom_text(data = lyon_df, aes(x = lon, y = lat-40000, label = "Lyon"), color = "#454547", size = 5, nudge_y = 5000) + # Ajouter le texte "Paris"
  geom_text(data = vienne_df, aes(x = lon-40000, y = lat-40000, label = "Vienna"), color = "#454547", size = 5, nudge_y = 5000) + # Ajouter le texte "Wien"
  coord_sf(crs = st_crs(2154), xlim = nouvelles_limites$xlim, ylim = nouvelles_limites$ylim) +  # Projection et limites en Lambert 93
  annotation_scale(location = "bl",
                   line_width = .8,
                   text_cex = 0.7,
                   pad_x = unit(0.5, "npc"),
                   pad_y = unit(0.05, "npc"),
                   style = 'ticks',
                   bar_cols = "#454547",
                   text = element_blank()) +
  theme_void()
p_Europe_
ggsave(filename = "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/Europe_Image1_1_20240405.png",
       plot = p_Europe_)



p_Europe_Exp2_ <- ggplot() +
  geom_sf(data = Europe_, fill = "white", alpha = 0, color = "#454547", lwd = 0.4) +
  geom_sf(data = CoursEau_, color = "#a6bddb", lwd = 0.3) +
  geom_sf(data = PointsExp2_, color = "#034e7b", size = 0.5) +  # Ajouter les points d'Explore2
  geom_point(data = paris_df, aes(x = lon, y = lat), color = "#454547", size = 3) +  # Ajouter les points de Paris
  geom_point(data = lyon_df, aes(x = lon, y = lat), color = "#454547", size = 3) +  # Ajouter les points de Lyon
  geom_point(data = vienne_df, aes(x = lon, y = lat), color = "#454547", size = 3) +  # Ajouter les points de Vienne
  geom_text(data = paris_df, aes(x = lon, y = lat-40000, label = "Paris"), color = "#454547", size = 5, nudge_y = 5000) + # Ajouter le texte "Paris"
  geom_text(data = lyon_df, aes(x = lon, y = lat-40000, label = "Lyon"), color = "#454547", size = 5, nudge_y = 5000) + # Ajouter le texte "Paris"
  geom_text(data = vienne_df, aes(x = lon-50000, y = lat-30000, label = "Vienna"), color = "#454547", size = 5, nudge_y = 5000) + # Ajouter le texte "Wien"
  coord_sf(crs = st_crs(2154), xlim = nouvelles_limites$xlim, ylim = nouvelles_limites$ylim) +  # Projection et limites en Lambert 93
  annotation_scale(location = "bl",
                   line_width = .8,
                   text_cex = 0.7,
                   pad_x = unit(0.5, "npc"),
                   pad_y = unit(0.05, "npc"),
                   style = 'ticks',
                   bar_cols = "#454547",
                   text = element_blank()) +
  theme_void()

p_Europe_Exp2_ <- ggplot() +
  geom_sf(data = Europe_, fill = "white", alpha = 0, color = "#454547", lwd = 0.4) +
  geom_sf(data = CoursEau_, color = "#a6bddb", lwd = 0.3) +
  geom_sf(data = PointsExp2_, color = "#034e7b", size = 0.5) +  # Ajouter les points d'Explore2
  geom_point(data = paris_df, aes(x = lon, y = lat), color = "white", size = 4.5, alpha = 0.7) +  # Ajouter les points de Paris
  geom_point(data = paris_df, aes(x = lon, y = lat), color = "#454547", size = 3) +  # Ajouter les points de Paris
  geom_point(data = lyon_df, aes(x = lon, y = lat), color = "white", size = 4.5, alpha = 0.7) +  # Ajouter les points de Paris
  geom_point(data = lyon_df, aes(x = lon, y = lat), color = "#454547", size = 3) +  # Ajouter les points de Paris
  geom_point(data = vienne_df, aes(x = lon, y = lat), color = "#454547", size = 3) +  # Ajouter les points de Vienne
  geom_rect(data = paris_df, aes(xmin = lon - 70000, xmax = lon + 70000, ymin = lat -50000 - 20000, ymax = lat -50000 + 30000), fill = "white", color = "white", alpha = 0.7) + # Fond blanc sur Paris
  geom_text(data = paris_df, aes(x = lon, y = lat-50000, label = "Paris"), color = "#454547", size = 7, nudge_y = 5000) + # Ajouter le texte "Paris"
  geom_rect(data = lyon_df, aes(xmin = lon - 70000, xmax = lon + 70000, ymin = lat -50000 - 20000, ymax = lat -50000 + 30000), fill = "white", color = "white", alpha = 0.7) + # Fond blanc sur Paris
  geom_text(data = lyon_df, aes(x = lon, y = lat-50000, label = "Lyon"), color = "#454547", size = 7, nudge_y = 5000) + # Ajouter le texte "Paris"
  geom_text(data = vienne_df, aes(x = lon-90000, y = lat-37000, label = "Vienna"), color = "#454547", size = 7, nudge_y = 5000) + # Ajouter le texte "Wien"
  geom_text(data = France_df, aes(x = lon+450000, y = lat-200000, label = "FRANCE"), color = "#454547", size = 7) +  # Ajouter "France" dans l'Atlantique
  geom_text(data = Austria_df, aes(x = lon+160000, y = lat+37000, label = "AUSTRIA"), color = "#454547", size = 7) +  # Ajouter "France" dans l'Atlantique
  coord_sf(crs = st_crs(2154), xlim = nouvelles_limites$xlim, ylim = nouvelles_limites$ylim) +  # Projection et limites en Lambert 93
  annotation_scale(location = "bl",
                   line_width = .8,
                   text_cex = 0.7,
                   pad_x = unit(0.5, "npc"),
                   pad_y = unit(0.05, "npc"),
                   style = 'ticks',
                   bar_cols = "#454547",
                   text = element_blank()) +
  theme_void()
  # theme_bw()

p_Europe_Exp2_
ggsave(filename = "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/EuropeExp2_Image1_1_20240405.png",
       plot = p_Europe_Exp2_)





p_Europe_Exp2_ <- ggplot() +
  geom_sf(data = Europe_, fill = "white", alpha = 0, color = "#454547", lwd = 0.4) +
  geom_sf(data = CoursEau_, color = "#a6bddb", lwd = 0.3) +
  # geom_sf(data = PointsExp2_, color = "#034e7b", size = 0.5) +  # Ajouter les points d'Explore2
  geom_point(data = paris_df, aes(x = lon, y = lat), color = "white", size = 4.5, alpha = 0.7) +  # Ajouter les points de Paris
  geom_point(data = paris_df, aes(x = lon, y = lat), color = "#454547", size = 3) +  # Ajouter les points de Paris
  geom_point(data = lyon_df, aes(x = lon, y = lat), color = "white", size = 4.5, alpha = 0.7) +  # Ajouter les points de Paris
  geom_point(data = lyon_df, aes(x = lon, y = lat), color = "#454547", size = 3) +  # Ajouter les points de Paris
  geom_point(data = vienne_df, aes(x = lon, y = lat), color = "#454547", size = 3) +  # Ajouter les points de Vienne
  geom_rect(data = paris_df, aes(xmin = lon - 70000, xmax = lon + 70000, ymin = lat -50000 - 20000, ymax = lat -50000 + 30000), fill = "white", color = "white", alpha = 0.7) + # Fond blanc sur Paris
  geom_text(data = paris_df, aes(x = lon, y = lat-50000, label = "Paris"), color = "#454547", size = 7, nudge_y = 5000) + # Ajouter le texte "Paris"
  geom_rect(data = lyon_df, aes(xmin = lon - 70000, xmax = lon + 70000, ymin = lat -50000 - 20000, ymax = lat -50000 + 30000), fill = "white", color = "white", alpha = 0.7) + # Fond blanc sur Paris
  geom_text(data = lyon_df, aes(x = lon, y = lat-50000, label = "Lyon"), color = "#454547", size = 7, nudge_y = 5000) + # Ajouter le texte "Paris"
  geom_text(data = vienne_df, aes(x = lon-90000, y = lat-37000, label = "Vienna"), color = "#454547", size = 7, nudge_y = 5000) + # Ajouter le texte "Wien"
  geom_text(data = France_df, aes(x = lon+450000, y = lat-200000, label = "FRANCE"), color = "#454547", size = 7) +  # Ajouter "France" dans l'Atlantique
  geom_text(data = Austria_df, aes(x = lon+160000, y = lat+37000, label = "AUSTRIA"), color = "#454547", size = 7) +  # Ajouter "France" dans l'Atlantique
  coord_sf(crs = st_crs(2154), xlim = nouvelles_limites$xlim, ylim = nouvelles_limites$ylim) +  # Projection et limites en Lambert 93
  annotation_scale(location = "bl",
                   line_width = .8,
                   text_cex = 0.7,
                   pad_x = unit(0.5, "npc"),
                   pad_y = unit(0.05, "npc"),
                   style = 'ticks',
                   bar_cols = "#454547",
                   text = element_blank()) +
  theme_void()
# theme_bw()


p_Europe_Exp2_
ggsave(filename = "/home/tjaouen/Documents/Administratif/Conferences/EGU2024/Presentation/Images_JaouenTristan/EuropeExp2_Image2_1_20240405.png",
       plot = p_Europe_Exp2_)

