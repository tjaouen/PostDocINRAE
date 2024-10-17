source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")

library(grid)
library(gridExtra)
library(ggplot2)  # Vous pouvez utiliser ggplot2 pour créer des graphiques

# Fonction pour créer les graphiques
creer_graphique <- function(chemin,list_) {
  # readRDS(chemin)
  image <- readRDS(chemin)
  image <- image + theme(legend.position = "none", plot.title = element_text(size = 15))
  list_ <- c(list_, list(image))
  return(list_)
  # image <- readRDS(chemin)
  # return(image)
}

# chemin <- output_folder_[1]

output_folder_ <- list.files(paste0(folder_output_,
                                    "16_ChroniquesProbabilites_MoyennePeriodes/",
                                    nomSim_,
                                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                    ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_))),
                             full.names = T, pattern = ".rds")

# Création des graphiques individuels
# graphiques <- lapply(output_folder_, function(chemin) creer_graphique(chemin))
# donnees <- lapply(output_folder_, function(chemin) creer_graphique(chemin))
# donnees <- lapply(output_folder_, function(chemin) creer_graphique(chemin))

# Création de la liste de données accumulée à partir des fichiers RDS
donnees <- list()
for (chemin in output_folder_[51:77]) {
  donnees <- creer_graphique(chemin, donnees)
}


list_graphiques <- list()
for (i in seq_along(donnees)) {
  # print(class(donnees[[i]]))
  list_graphiques[[i]] <- cowplot::plot_grid(plotlist = donnees[[i]], ncol = 10, align = "hv")
}

panneau_global <- cowplot::plot_grid(plotlist = donnees, ncol = 5, align = "hv")

# x11()
# plot(panneau_global)

pdf(paste0(folder_output_,
           "16_ChroniquesProbabilites_MoyennePeriodes/",
           nomSim_,
           ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
           ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
           ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
           # "panneau_graphiques_1_25.pdf"), width = 18, height = 18)
           # "panneau_graphiques_26_50.pdf"), width = 18, height = 18)
           "panneau_graphiques_51_77.pdf"), width = 18, height = 18)
plot(panneau_global)
dev.off()






# donnees1 <- output_folder_[1]
donnee = list(readRDS(output_folder_[1]),
              readRDS(output_folder_[2]))
# donnees1 <- output_folder_[1]
# donnees2 <- output_folder_[2]
# donnee <- list(readRDS(donnees1), readRDS(donnees2))

donnee1 = readRDS(output_folder_[1])
donnee2 = readRDS(output_folder_[2])

cowplot::plot_grid(donnee[[1]],donnee[[2]], ncol = 2, align = "hv")


# graphiques <- cowplot::plot_grid(donnees[1],donnees[2], ncol = 2, align = "hv")
graphiques <- cowplot::plot_grid(donnee[1],donnee[2], ncol = 2, align = "hv")


graphiques <- cowplot::plot_grid(donnee[[1]],donnee[[2]], ncol = 2, align = "hv")

graphiques <- cowplot::plot_grid(donnees[1],donnees[2], ncol = 2, align = "hv")
# graphiques <- cowplot::plot_grid(donnee[1],donnee[2], ncol = 2, align = "hv")

if (length(donnees) >= 1) {
  cowplot::plot_grid(plotlist = donnees[1], ncol = 5, align = "hv")
  # graphiques <- cowplot::plot_grid(plotlist = donnees[1:25], ncol = 5, align = "hv")
} else {
  print("Aucune donnée disponible pour créer les graphiques.")
}

# Afficher le panneau de graphiques
plot(graphiques)







if (length(donnees) >= 2) {
  graphiques <- cowplot::plot_grid(donnees[[1]], donnees[[2]], ncol = 2, align = "hv")
} else if (length(donnees) == 1) {
  graphiques <- donnees[[1]]
  # S'il y a une seule donnée, affichez-la directement sans plot_grid
} else {
  print("Aucune donnée disponible pour créer les graphiques.")
}


# donnees1 <- output_folder_[1]
# donnees2 <- output_folder_[2]
# donnee <- list(readRDS(donnees1), readRDS(donnees2))







x11()
graphiques
# grid.arrange(grobs = graphiques, ncol = 10)



# # Organisation des graphiques dans un panneau de 10 colonnes et 8 lignes
# pdf(paste0(folder_output_,
#            "16_ChroniquesProbabilites_MoyennePeriodes/",
#            nomSim_,
#            ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
#            ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
#            ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
#            "panneau_graphiques.pdf"), width = 14, height = 18)
# grid.arrange(grobs = graphiques, ncol = 10)
# dev.off()


