# Définir le chemin du dossier contenant les fichiers à renommer
chemin_dossier <- "/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/SauvegardeCodesES_20230215/Changement Clim/eric/HYDRO/FDC OBS_20230314/"

# Obtenir la liste de tous les fichiers dans le dossier
liste_fichiers <- list.files(chemin_dossier)

# Définir l'expression régulière à remplacer
pattern_old <- "Sim"

# Définir la nouvelle expression régulière
pattern_new <- "Obs"

# Renommer chaque fichier en utilisant l'expression régulière
for (fichier in liste_fichiers) {
  nouveau_nom <- gsub(pattern_old, pattern_new, fichier)
  file.rename(paste(chemin_dossier, fichier, sep = "/"), 
              paste(chemin_dossier, nouveau_nom, sep = "/"))
}
