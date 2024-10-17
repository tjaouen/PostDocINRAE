source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")

library(pdf_layout_pages)

folder_output_ = folder_output_param_
nomSim_ = nomSim_param_
nom_GCM_ = nom_GCM_param_
nom_categorieSimu_ = nom_categorieSimu_param_
nom_apprentissage_ = "ApprentissageGlobalModelesBruts"



output_folder_ <- list.files(paste0(folder_output_,
                                    "16_ChroniquesProbabilites_MoyennePeriodes/",
                                    nomSim_,
                                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                    ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_))),
                             full.names = T, pattern = ".rds")



creer_graphique <- function(chemin) {
  # Code pour générer vos graphiques à partir du chemin du fichier
  # Remplacez cette partie par votre propre code pour créer le graphique
  # Par exemple :
  plot(1:10, main = basename(chemin))
}

# Création du panneau de graphiques dans un fichier PDF
pdf(paste0(folder_output_,
           "16_ChroniquesProbabilites_MoyennePeriodes/",
           nomSim_,
           ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
           ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
           ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
           "panneau_graphiques.pdf"),
    width = 14, height = 18)  # Taille de la page PDF

# Diviser les graphiques en un panneau de 10 colonnes et 8 lignes
pdf_layout_begin(ncol = 10, nrow = 8)
for (i in 1:length(chemins)) {
  pdf_layout_page()
  creer_graphique(chemins[i])
}
pdf_layout_end()

dev.off()  # Fermer le fichier PDF






library(grid)
library(gridExtra)
library(ggplot2)  # Vous pouvez utiliser ggplot2 pour créer des graphiques

# Fonction pour créer les graphiques
creer_graphique <- function(chemin) {
  
  # Code pour générer vos graphiques à partir du chemin du fichier
  # Remplacez cette partie par votre propre code pour créer le graphique
  # Utilisation de ggplot2 comme exemple
  # data <- data.frame(x = 1:10, y = rnorm(10))  # Exemple de données aléatoires
  # ggplot(data, aes(x = x, y = y)) + geom_point() +
  #   ggtitle(basename(chemin))  # Titre du graphique avec le nom du fichier
  
  image <- readRDS(chemin)
  return(image)

}

# chemin <- output_folder_[1]


# Création des graphiques individuels
graphiques <- lapply(output_folder_, function(chemin) creer_graphique(chemin))

cowplot::plot_grid(graphiques, ncol = 10, align = "hv")

# Organisation des graphiques dans un panneau de 10 colonnes et 8 lignes
pdf(paste0(folder_output_,
           "16_ChroniquesProbabilites_MoyennePeriodes/",
           nomSim_,
           ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
           ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
           ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
           "panneau_graphiques.pdf"), width = 14, height = 18)
grid.arrange(grobs = graphiques, ncol = 10)
dev.off()



# print(ggplot_build(image1))

# ggplot() +
#   
#   geom_line(data = combined_data, aes(x = Jour_annee, y = Proba_moyen, color = Periode, group = Periode), size = 1.5) +
#   geom_point(data = combined_data_min_max_, aes(x = Date, y = Proba_Q5, color = Periode, group = Periode), size = 2, shape = 3) +
#   geom_point(data = combined_data_min_max_, aes(x = Date, y = Proba_Q95, color = Periode, group = Periode), size = 2, shape = 3) +
#   
#   scale_color_manual(values = custom_colors) +  # Utilisation de la palette de couleurs personnalisée
#   
#   geom_point(data = first_days, aes(x = Jour_annee, y = Proba_moyen, color = Periode, group = Periode), size = 0) +
#   scale_x_date(date_breaks = "1 month", date_labels = "%d-%b") +
#   
#   geom_point(data = moyennes_mois, aes(x = Date, y = Moyenne_X_Assec), color = "#252525", size = 3, shape = 16) +
#   geom_point(data = tab_input_h_min_max_, aes(x = Date, y = Min_X_Assec), color = "#969696", size = 3, shape = 16) +
#   geom_point(data = tab_input_h_min_max_, aes(x = Date, y = Max_X_Assec), color = "#969696", size = 3, shape = 16) +
#   # geom_point(data = all_dates, aes(x = Date_2022, y = X._Assec), color = "blue", size = 3, shape = 16) +
#   # geom_text_repel(data = all_dates, aes(label = format(as.Date(Date), "%m-%Y"), x = Date_2022, y = X._Assec), vjust = -1, hjust = 0, size = 3) +
#   
#   ylim(0,50) +
#   theme_minimal() +
#   theme(strip.text.x = element_blank(),
#         strip.background = element_blank()) +
#   labs(x = "Date", y = "Probabilité d'assec", color = "Période", title = paste0("HER ",HER_h_))
