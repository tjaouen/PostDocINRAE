library(maps)

crimes <- data.frame(state = tolower(rownames(USArrests)), USArrests)
crimesm <- reshape2::melt(crimes, id = 1)

states_map <- map_data("state")

(p <- ggplot(crimes, aes(map_id = state)) +
    geom_map_pattern(
      aes(
        # fill            = Murder,
        pattern_fill    = Murder,
        pattern_spacing = state,
        pattern_density = state,
        pattern_angle   = state,
        pattern         = state
      ),
      fill = 'white',
      colour = 'black',
      map = states_map
    ) +
    expand_limits(x = states_map$long, y = states_map$lat) +
    coord_map() +
    theme_bw() +
    labs(title = "ggpattern::geom_map_pattern()") + 
    scale_pattern_density_discrete(range = c(0.01, 0.3)) + 
    scale_pattern_spacing_discrete(range = c(0.01, 0.05)) + 
    theme(legend.position = 'none'))




# Installation des packages nécessaires s'ils ne sont pas déjà installés
# install.packages("ggplot2")
# install.packages("ggpattern")

# Charger les bibliothèques
library(ggplot2)
library(ggpattern)

# Créer un exemple de données avec un polygone
# Supposons que vous avez déjà un polygone avec des données
# Créons donc un polygone simple à titre d'exemple
data <- data.frame(
  x = c(1, 2, 3, 2),
  y = c(1, 3, 2, 1)
)

# Tracer le polygone avec ggplot2 et le hachurer
ggplot(data, aes(x = x, y = y)) +
  geom_polygon(fill = "blue") +
  geom_polygon_pattern(
    aes(fill = "pattern"),
    pattern = "stripe", # Choisissez le type de hachure, par exemple 'stripe'
    color = "black",    # Couleur des lignes de hachure
    size = 0.5          # Épaisseur des lignes de hachure
  ) +
  scale_fill_manual(values = c("blue", "transparent"), guide = "none") +
  theme_minimal()
