# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run3.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run4.R")

library(grid)
library(gridExtra)
library(ggplot2)  # Vous pouvez utiliser ggplot2 pour créer des graphiques

folder_output_ = folder_output_param_
nom_categorieSimu_ = nom_categorieSimu_param_
nom_GCM_ = nom_GCM_param_
nomSim_ = nomSim_param_
nom_apprentissage_ = nom_apprentissage_param_

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
                                    # "27_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2019_20231221/",
                                    nomSim_,
                                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                    ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
                                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_))),
                             full.names = T, pattern = ".rds")

output_folder_ <- output_folder_[order(as.numeric(str_before_first(str_after_first(output_folder_, "_HER"), "_logit.rds")))]

# Création des graphiques individuels
# graphiques <- lapply(output_folder_, function(chemin) creer_graphique(chemin))
# donnees <- lapply(output_folder_, function(chemin) creer_graphique(chemin))
# donnees <- lapply(output_folder_, function(chemin) creer_graphique(chemin))

# Création de la liste de données accumulée à partir des fichiers RDS
donnees <- list()
for (chemin in output_folder_[1:25]) {
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
           # "27_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2019_20231221/",
           nomSim_,
           ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
           ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
           ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
           "panneau_graphiques_1_25.pdf"), width = 18, height = 18)
           # "panneau_graphiques_26_50.pdf"), width = 18, height = 18)
           # "panneau_graphiques_51_77.pdf"), width = 18, height = 18)
plot(panneau_global)
dev.off()


## 26 - 50 ##
donnees <- list()
for (chemin in output_folder_[26:50]) {
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
           # "27_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2019_20231221/",
           nomSim_,
           ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
           ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
           ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
           "panneau_graphiques_26_50.pdf"), width = 18, height = 18)
plot(panneau_global)
dev.off()



## 51 - 75 ##
donnees <- list()
for (chemin in output_folder_[51:75]) {
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
           # "27_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2019_20231221/",
           nomSim_,
           ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
           ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
           ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
           "panneau_graphiques_51_75.pdf"), width = 18, height = 18)
plot(panneau_global)
dev.off()




## Pour J2000 : 51 - 53 ##
# donnees <- list()
# for (chemin in output_folder_[51:53]) {
#   donnees <- creer_graphique(chemin, donnees)
# }
# 
# list_graphiques <- list()
# for (i in seq_along(donnees)) {
#   # print(class(donnees[[i]]))
#   list_graphiques[[i]] <- cowplot::plot_grid(plotlist = donnees[[i]], ncol = 3, align = "hv")
# }
# 
# panneau_global <- cowplot::plot_grid(plotlist = donnees, ncol = 3, align = "hv")
# 
# # x11()
# # plot(panneau_global)
# 
# pdf(paste0(folder_output_,
#            "16_ChroniquesProbabilites_MoyennePeriodes/",
#            # "27_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2019_20231221/",
#            nomSim_,
#            ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
#            ifelse(nom_GCM_=="","",paste0("/",nom_GCM_)),
#            ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
#            "panneau_graphiques_51_53.pdf"), width = 18, height = 18)
# plot(panneau_global)
# dev.off()



# for (chemin in output_folder_[26:50]) {
# for (chemin in output_folder_[51:77]) {




