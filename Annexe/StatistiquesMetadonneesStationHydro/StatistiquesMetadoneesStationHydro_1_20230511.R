library(readxl)
library(ggplot2)
library(dplyr)


# name_station_ = "A133003001" #AGAIN
# name_station_ = "U211201001"
# name_station_ = "V293401001"
# name_station_ = "V141401001"
# name_station_ = "W233521001"
# name_station_ = "X013001001"
# name_station_ = "X045401001"
# name_station_ = "X102691001"
# name_station_ = "Y530501501"
# name_station_ = "Y040401001"
# name_station_ = "A953205050"
# name_station_ = "A902102050"
# name_station_ = "A812200001"
name_station_ = "F459000101"
name_station_ = "F453000101"
name_station_ = "H402203001"
name_station_ = "K441409001"
name_station_ = "D019701001"
name_station_ = "D015850001"
name_station_ = "F232000101"
name_station_ = "H730202001"
name_station_ = "F483000202"
name_station_ = "I205103002"
name_station_ = "I361206001"
name_station_ = "F232000101"
name_station_ = "F410000101"
name_station_ = "K272421001"
name_station_ = "K208082001"
name_station_ = "K209081001"
name_station_ = "K010002010"
name_station_ = "K230081001"
name_station_ = "K224082001"
name_station_ = "K230081881" #PAS SUR DU CODE
name_station_ = "H205101001"
name_station_ = "K272421001" #AGAIN
name_station_ = "K276311001"
name_station_ = "A735201001"
name_station_ = "F410000101"
name_station_ = "A812200001"
name_station_ = "H205101001"
name_station_ = "Y421404001"
name_station_ = "E639701001"
name_station_ = "N430062201"
name_station_ = "N410403001"
name_station_ = "M720302010"
name_station_ = "M721301010"
name_station_ = "J362401001"
name_station_ = "J340301001"
name_station_ = "J340302001"
## REVOIR 59
name_station_ = "P807401001"
name_station_ = "O566401001"
name_station_ = "O153291001"
name_station_ = "O182401001"
name_station_ = "O146401001"
name_station_ = "O166291001"



### VOIR HER 54, LEGENDE INCOMPLETE


file_meta_input_ <- "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/2_ResultatsModeles_ParHer/7_CriteresSelectionES_CroisePerformancesSim7_20230511/SelectionStationsCritereES_20230510/Selection_stations_Tristan_MergeFromTabSelect_5_20230509.xlsx"
tab_meta_input_ <- read_excel(file_meta_input_, sheet = 2)

cols_to_convert <- c("Slope_pv_logit","NASH_Calib_logit", "PropParameterDeviance_logit", "Altitude", "SurfaceTopo", "CAPACITE_RESERVOIR",
                     "PRELEVEMENTS_AEP", "PRELEVEMENTS_IRRIGATION", "PRELEVEMENTS_INDUSTRIE", "PRELEVEMENTS_ENERGIE", "PRELEVEMENTS_HYDROELECTRICITE",
                     "QAOUT", "QAOUT_VOLUME", "CONSOMMATION_MOIS_ETIAGE", "CONSOMMATION_ANNEE", "QA", "PRESSION_MOIS_ETIAGE", "PRESSION_ANNEE", "CAPACITE_RESERVOIR/QA")
for (col in cols_to_convert) {
  tab_meta_input_[[col]] <- as.numeric(tab_meta_input_[[col]])
}


#"Impact_local"
#"InfluenceCritereES"             






# Filtrer les données pour la station spécifiée
data_station <- filter(tab_meta_input_, Code_short == name_station_)

# Définir la fonction pour ajouter la ligne verticale pour la station spécifiée
add_vertical_line <- function(plot, value) {
  plot + geom_vline(xintercept = value, linetype = "dashed", color = "red")
}

# Créer une liste de plots pour chaque colonne
plots <- list()
plots[[1]] <- ggplot(tab_meta_input_, aes(x = Slope_pv_logit)) + geom_histogram(bins = 100) + geom_vline(xintercept = data_station$Slope_pv_logit, linetype = "dashed", color = "red")
plots[[2]] <- ggplot(tab_meta_input_, aes(x = NASH_Calib_logit)) + geom_histogram(bins = 100) + geom_vline(xintercept = data_station$NASH_Calib_logit, linetype = "dashed", color = "red")
plots[[3]] <- ggplot(tab_meta_input_, aes(x = PropParameterDeviance_logit)) + geom_histogram(bins = 100) + geom_vline(xintercept = data_station$PropParameterDeviance_logit, linetype = "dashed", color = "red")
plots[[4]] <- ggplot(tab_meta_input_, aes(x = Altitude)) + geom_histogram(bins = 100) + geom_vline(xintercept = data_station$Altitude, linetype = "dashed", color = "red")
plots[[5]] <- ggplot(tab_meta_input_, aes(x = SurfaceTopo)) + geom_histogram(bins = 100) + geom_vline(xintercept = data_station$SurfaceTopo, linetype = "dashed", color = "red")
plots[[6]] <- ggplot(tab_meta_input_, aes(x = CAPACITE_RESERVOIR)) + geom_histogram(bins = 100) + geom_vline(xintercept = data_station$CAPACITE_RESERVOIR, linetype = "dashed", color = "red")
plots[[7]] <- ggplot(tab_meta_input_, aes(x = PRELEVEMENTS_AEP)) + geom_histogram(bins = 100) + geom_vline(xintercept = data_station$PRELEVEMENTS_AEP, linetype = "dashed", color = "red")
plots[[8]] <- ggplot(tab_meta_input_, aes(x = PRELEVEMENTS_IRRIGATION)) + geom_histogram(bins = 100) + geom_vline(xintercept = data_station$PRELEVEMENTS_IRRIGATION, linetype = "dashed", color = "red")
plots[[9]] <- ggplot(tab_meta_input_, aes(x = PRELEVEMENTS_INDUSTRIE)) + geom_histogram(bins = 100) + geom_vline(xintercept = data_station$PRELEVEMENTS_INDUSTRIE, linetype = "dashed", color = "red")
plots[[10]] <- ggplot(tab_meta_input_, aes(x = PRELEVEMENTS_ENERGIE)) + geom_histogram(bins = 100) + geom_vline(xintercept = data_station$PRELEVEMENTS_ENERGIE, linetype = "dashed", color = "red")
plots[[11]] <- ggplot(tab_meta_input_, aes(x = PRELEVEMENTS_HYDROELECTRICITE)) + geom_histogram(bins = 100) + geom_vline(xintercept = data_station$PRELEVEMENTS_HYDROELECTRICITE, linetype = "dashed", color = "red")
plots[[12]] <- ggplot(tab_meta_input_, aes(x = QAOUT)) + geom_histogram(bins = 100) + geom_vline(xintercept = data_station$QAOUT, linetype = "dashed", color = "red")
plots[[13]] <- ggplot(tab_meta_input_, aes(x = QAOUT_VOLUME)) + geom_histogram(bins = 100) + geom_vline(xintercept = data_station$QAOUT_VOLUME, linetype = "dashed", color = "red")
plots[[14]] <- ggplot(tab_meta_input_, aes(x = CONSOMMATION_MOIS_ETIAGE)) + geom_histogram(bins = 100) + geom_vline(xintercept = data_station$CONSOMMATION_MOIS_ETIAGE, linetype = "dashed", color = "red")
plots[[15]] <- ggplot(tab_meta_input_, aes(x = CONSOMMATION_ANNEE)) + geom_histogram(bins = 100) + geom_vline(xintercept = data_station$CONSOMMATION_ANNEE, linetype = "dashed", color = "red")
plots[[16]] <- ggplot(tab_meta_input_, aes(x = QA)) + geom_histogram(bins = 100) + geom_vline(xintercept = data_station$QA, linetype = "dashed", color = "red")
plots[[17]] <- ggplot(tab_meta_input_, aes(x = PRESSION_MOIS_ETIAGE)) + geom_histogram(bins = 100) + geom_vline(xintercept = data_station$PRESSION_MOIS_ETIAGE, linetype = "dashed", color = "red")
plots[[18]] <- ggplot(tab_meta_input_, aes(x = PRESSION_ANNEE)) + geom_histogram(bins = 100) + geom_vline(xintercept = data_station$PRESSION_ANNEE, linetype = "dashed", color = "red")
plots[[19]] <- ggplot(tab_meta_input_, aes(x = CAPACITE_RESERVOIR/QA)) + geom_histogram(bins = 100) + geom_vline(xintercept = data_station$`CAPACITE_RESERVOIR/QA`, linetype = "dashed", color = "red")


multiplot <- function(..., plotlist = NULL, file, cols = 1, layout = NULL) {
  require(grid)
  plots <- c(list(...), plotlist)
  numPlots = length(plots)
  if (is.null(layout)) {
    # Make the panel height proportional to the number of rows
    # and the panel width proportional to the number of columns
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  if (numPlots==1) {
    print(plots[[1]])
  } else {
    # Set up the grid
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    # Make each plot
    for (i in 1:numPlots) {
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}


png(paste0("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/14_Graphes_MetadonneesParStations/7_PresentMesures_HERh_TsKGE_TtesStat_FiltreOndeManquantes_2012_2022_20230505/Version1_20230511/MetadonneesPerformances_Station",name_station_,"_1_20230511.png"),
    width = 1200, height = 750,
    units = "px", pointsize = 12)
multiplot(
  plots[[1]], plots[[2]], plots[[3]], plots[[4]], plots[[5]], plots[[6]], plots[[7]],
  plots[[8]], plots[[9]], plots[[10]], plots[[11]],
  plots[[12]], plots[[13]], plots[[14]], plots[[15]],
  plots[[16]], plots[[17]], plots[[18]], plots[[19]], cols = 5)
dev.off()



# x11()
# ggplot(tab_meta_input_, aes(x = Altitude)) + geom_histogram(bins = 300)




