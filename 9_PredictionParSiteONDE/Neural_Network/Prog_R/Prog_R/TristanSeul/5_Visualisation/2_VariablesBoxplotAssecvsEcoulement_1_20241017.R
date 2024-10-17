# Charger les bibliothèques nécessaires
library(ggplot2)
library(reshape2)
library(dplyr)

# Supposons que df soit ton DataFrame avec toutes les colonnes listées
df <- read.table("")

# Filtrer les données pour un Code_ONDE spécifique
code_ONDE_specifique <- "valeur_du_Code_ONDE"  # Remplace par la valeur spécifique de Code_ONDE
df_filtre <- df %>% filter(Code_ONDE == code_ONDE_specifique)

# Transformer les données de format large à format long
df_long <- df_filtre %>%
  select(-Code_ONDE) %>%
  melt(id.vars = c("Assec", "Prediction"))

# Créer le plot
ggplot(df_long, aes(x = factor(Assec), y = value)) +
  geom_boxplot(aes(fill = factor(Assec))) +   # Créer les boxplots
  geom_jitter(aes(color = factor(Prediction)), width = 0.2) +  # Ajouter les points
  scale_color_manual(values = c("0" = "blue", "1" = "red")) +  # Couleurs des points
  facet_wrap(~variable, scales = "free", ncol = 4) +  # Faceting pour chaque variable, ajuster selon les besoins
  labs(x = "Assec", y = "Valeur", color = "Prédiction", fill = "Assec") +
  theme_bw() +  # Thème pour avoir un style propre
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotation des labels sur l'axe X
