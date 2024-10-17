palette_colorblind <- colorRampPalette(colorblindr.palette(type = "qual", size = 8))

# Utiliser la palette dans une visualisation
x <- 1:10
y <- rnorm(10)

x11()
plot(x, y, col = palette_colorblind(10), pch = 16, main = "Palette de couleur pour daltoniens")

brewer.pal(30, "YlGn")




# Charger le package RColorBrewer
library(RColorBrewer)

# Créer une palette de taille 30 avec la palette de couleurs "Spectral"
palette <- brewer.pal(30, "BrBG")


# Choisissez une palette Brewer prédéfinie (BrBG) comme point de départ
palette_base <- brewer.pal(11, "BrBG")
# Interpoler les couleurs pour obtenir une palette de taille 30
interpolated_palette <- colorRampPalette(palette_base)(30)
t(col2rgb(interpolated_palette))


# Choisissez une palette Brewer prédéfinie (BrBG) comme point de départ
palette_base <- brewer.pal(9, "YlGnBu")
t(col2rgb(palette_base))
# Interpoler les couleurs pour obtenir une palette de taille 30
for (i in 10:30){
  interpolated_palette <- colorRampPalette(palette_base)(i)
  print(paste0("misc_div_",i))
  print(t(col2rgb(interpolated_palette)))
}

