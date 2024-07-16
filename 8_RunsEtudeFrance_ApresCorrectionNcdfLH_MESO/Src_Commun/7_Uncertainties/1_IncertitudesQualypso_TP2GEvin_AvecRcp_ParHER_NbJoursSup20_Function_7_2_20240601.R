# Charger le package
library(QUALYPSO)
library(ggplot2)
library(strex)
library(tidyr)

# rm(list = ls())

source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_Commun/7_Uncertainties/QUALYPSO/R/QUALYPSO.r")

### Functions ###
# saveGraph_ <- function(output_name_, functionGraph){
#   pdf(paste0(output_name_,".pdf"),
#       width = 18)
#   functionGraph()
#   dev.off()
#   
#   saveRDS(p, file = paste0(output_name_,".rds"))
#   
#   svg_device <- svglite(paste0(output_name_,".svg"), width = 18)#,
#   functionGraph()
#   dev.off()
#   
#   png(paste0(output_name_,".png"), width = 9*100)
#   functionGraph()
#   dev.off()
# }


plot_graph_1 <- function(X_time_vec,Y) {
  plot(-1, -1, xlim = range(X_time_vec), ylim = range(Y), xlab = "Years", ylab = "          PFI (%)", yaxt = "n", cex.lab = 1.5, cex.axis = 1.4)
  for (i in 1:nrow(Y)) {
    lines(X_time_vec, Y[i, ], col = i)
  }
  y_labels <- pretty(range(Y))
  axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1, cex.axis = 1.3)
}

plot_graph_2 <- function(X_time_vec,Y,sizeWindow,nYmean,vecYmean){
  plot(-1,-1,xlim=range(X_time_vec),ylim=range(Y),xlab="Years",ylab="          PFI (%)",yaxt="n",cex.lab=1.5,cex.axis=1.2)
  for(i in 1:nrow(Y)){
    for(y in 1:nYmean){
      vecYmean[y] = mean(Y[i,y:(y+sizeWindow-1)])
    }
    lines(X_time_vec[1:nYmean]+sizeWindow/2,vecYmean,col=i)
  }
  y_labels <- pretty(range(Y))
  axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1, cex.axis = 1.3)
}

plot_graph_3 <- function(X_time_vec,Y,vec_sPar,iSimu){
  plot(-1,-1,xlim=range(X_time_vec),ylim=range(Y[iSimu,]),xlab="Years",ylab="          PFI (%)",yaxt="n",cex.lab=1.5,cex.axis=1.2)
  lines(X_time_vec,Y[iSimu,],col="black")
  for(i in 1:3){
    ySmooth = smooth.spline(x = X_time_vec,y = Y[iSimu,], spar=vec_sPar[i])$y
    lines(X_time_vec,ySmooth,col="red",lty=i,lwd=2)
  }
  legend("bottomright",legend = vec_sPar,lty=1:3,col="red",title="spar")
  y_labels <- pretty(range(range(Y[iSimu,])))
  axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1, cex.axis = 1.3)
}

plot_graph_4 <- function(Xfut_time,Y,phiStar){
  plot(-1,-1,xlim=range(Xfut_time),ylim=range(phiStar),xlab="Years",ylab="          PFI (%)",yaxt="n",cex.lab=1.5,cex.axis=1.2)
  for(i in 1:nrow(Y)){
    lines(Xfut_time,phiStar[i,],col=i)
  }
  y_labels <- pretty(range(range(phiStar)))
  axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1, cex.axis = 1.3)
}

plot_graph_5 <- function(Xfut_time,Y,phiStar,scenAvail,vecGCM){
  plot(-1,-1,xlim=range(Xfut_time),ylim=range(phiStar),xlab="Years",ylab="          PFI (%)",yaxt="n",cex.lab=1.5,cex.axis=1.2)
  for(i in 1:nrow(Y)){
    lines(Xfut_time,phiStar[i,],col=which(scenAvail$GCM[i]==vecGCM))
  }
  legend("topleft",legend=vecGCM,col=1:4,lty=1)
  y_labels <- pretty(range(range(phiStar)))
  axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1, cex.axis = 1.3)
}


runPlot <- function(Y,scenAvail,X_time_vec,Xfut_time,nomSimulation_,HER_,nomVariable_,ylim_,ylim_enveloppe_){
  
  if (!dir.exists(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/"))){
    dir.create(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/"))
  }
  if (!dir.exists(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/"))){
    dir.create(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/"))
  }
  if (!dir.exists(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/"))){
    dir.create(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/"))
  }
  
  ## ------------------------------------------------------------------------------------------------------
  # Première représentation des simulations: superposition des différentes simulations avec une couleur par GCM
  # plot(-1,-1,xlim=range(X_time_vec),ylim=range(Y),xlab="Years",ylab="          PFI (%)",yaxt="n",cex.lab=1.5,cex.axis=1.4)
  # for(i in 1:nrow(Y)){
  #   lines(X_time_vec,Y[i,],col=i)
  # }
  # y_labels <- pretty(range(Y))
  # axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1, cex.axis = 1.3)
  # recorded_plot <- recordPlot()
  
  
  png(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/1_ChroniquesPFI_",nomVariable_,"_",nomSimulation_,"_1_20240526.png"),
      width = 800, height = 600)
  par(mar = c(5, 5, 4, 2) + 0.1)  # Augmenter la marge gauche (2ème valeur)
  plot_graph_1(X_time_vec,Y)
  dev.off()
  
  svg(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/1_ChroniquesPFI_",nomVariable_,"_",nomSimulation_,"_1_20240526.svg"),
      width = 16, height = 12)
  par(mar = c(5, 5, 4, 2) + 0.1)  # Augmenter la marge gauche (2ème valeur)
  plot_graph_1(X_time_vec,Y)
  dev.off()
  
  pdf(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/1_ChroniquesPFI_",nomVariable_,"_",nomSimulation_,"_1_20240526.pdf"),
      width = 16, height = 12)
  par(mar = c(5, 5, 4, 2) + 0.1)  # Augmenter la marge gauche (2ème valeur)
  plot_graph_1(X_time_vec,Y)
  dev.off()
  
  saveRDS(plot_graph_1(X_time_vec,Y), paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/1_ChroniquesPFI_",nomVariable_,"_",nomSimulation_,"_1_20240526.rds"))
  
  # dev.off()
  
  # La variabilité inter-annuelle est importante. On regarde souvent les moyennes sur 30 ans pour obtenir des statistiques du climat sur des fenêtres glissantes et gommer une partie de cette variabilité haute-fréquence
  sizeWindow = 30
  nYmean = ncol(Y)-30
  # nYmean = 100
  vecYmean = vector(length=nYmean)
  # x11()
  # plot(-1,-1,xlim=range(X_time_vec),ylim=range(Y),xlab="Years",ylab="          PFI (%)",yaxt="n",cex.lab=1.5,cex.axis=1.2)
  # for(i in 1:nrow(Y)){
  #   for(y in 1:nYmean){
  #     vecYmean[y] = mean(Y[i,y:(y+sizeWindow-1)])
  #   }
  #   lines(X_time_vec[1:nYmean]+sizeWindow/2,vecYmean,col=i)
  # }
  # y_labels <- pretty(range(Y))
  # axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1, cex.axis = 1.3)
  # recorded_plot <- recordPlot()
  
  png(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/2_ChroniquesPFI_MoySur30ans_",nomVariable_,"_",nomSimulation_,"_1_20240526.png"),
      width = 800, height = 600)
  par(mar = c(5, 5, 4, 2) + 0.1)  # Augmenter la marge gauche (2ème valeur)
  plot_graph_2(X_time_vec,Y,sizeWindow,nYmean,vecYmean)
  dev.off()
  
  svg(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/2_ChroniquesPFI_MoySur30ans_",nomVariable_,"_",nomSimulation_,"_1_20240526.svg"),
      width = 16, height = 12)
  par(mar = c(5, 5, 4, 2) + 0.1)  # Augmenter la marge gauche (2ème valeur)
  plot_graph_2(X_time_vec,Y,sizeWindow,nYmean,vecYmean)
  dev.off()
  
  pdf(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/2_ChroniquesPFI_MoySur30ans_",nomVariable_,"_",nomSimulation_,"_1_20240526.pdf"),
      width = 16, height = 12)
  par(mar = c(5, 5, 4, 2) + 0.1)  # Augmenter la marge gauche (2ème valeur)
  plot_graph_2(X_time_vec,Y,sizeWindow,nYmean,vecYmean)
  dev.off()
  
  saveRDS(plot_graph_2(X_time_vec,Y,sizeWindow,nYmean,vecYmean), paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/2_ChroniquesPFI_MoySur30ans_",nomVariable_,"_",nomSimulation_,"_1_20240526.rds"))
  
  #' ## Extraction des réponses climatiques
  ## ------------------------------------------------------------------------------------------------------
  # illustration pour la première simulation: peut être modifié
  iSimu=1
  # sPar peut varier entre 0 et l'infini
  vec_sPar = c(0.01,0.5,1)
  
  # x11()
  # plot(-1,-1,xlim=range(X_time_vec),ylim=range(Y[iSimu,]),xlab="Years",ylab="          PFI (%)",yaxt="n",cex.lab=1.5,cex.axis=1.2)
  # lines(X_time_vec,Y[iSimu,],col="black")
  # for(i in 1:3){
  #   ySmooth = smooth.spline(x = X_time_vec,y = Y[iSimu,], spar=vec_sPar[i])$y
  #   lines(X_time_vec,ySmooth,col="red",lty=i,lwd=2)
  # }
  # legend("bottomright",legend = vec_sPar,lty=1:3,col="red",title="spar")
  # y_labels <- pretty(range(range(Y[iSimu,])))
  # axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1, cex.axis = 1.3)
  # recorded_plot <- recordPlot()
  
  png(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/3_ChroniquesPFI_ExempleSimu_",nomVariable_,"_",nomSimulation_,"_1_20240526.png"),
      width = 800, height = 600)
  par(mar = c(5, 5, 4, 2) + 0.1)  # Augmenter la marge gauche (2ème valeur)
  plot_graph_3(X_time_vec,Y,vec_sPar,iSimu)
  dev.off()
  
  svg(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/3_ChroniquesPFI_ExempleSimu_",nomVariable_,"_",nomSimulation_,"_1_20240526.svg"),
      width = 16, height = 12)
  par(mar = c(5, 5, 4, 2) + 0.1)  # Augmenter la marge gauche (2ème valeur)
  plot_graph_3(X_time_vec,Y,vec_sPar,iSimu)
  dev.off()
  
  pdf(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/3_ChroniquesPFI_ExempleSimu_",nomVariable_,"_",nomSimulation_,"_1_20240526.pdf"),
      width = 16, height = 12)
  par(mar = c(5, 5, 4, 2) + 0.1)  # Augmenter la marge gauche (2ème valeur)
  plot_graph_3(X_time_vec,Y,vec_sPar,iSimu)
  dev.off()
  
  saveRDS(plot_graph_3(X_time_vec,Y,vec_sPar,iSimu), paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/3_ChroniquesPFI_ExempleSimu_",nomVariable_,"_",nomSimulation_,"_1_20240526.rds"))
  
  
  
  ## ------------------------------------------------------------------------------------------------------
  # list of options
  # if (nomVariable_ == "ProbaMeanJuilOct"){
  #   listOption = list(typeChangeVariable='abs',spar=1)
  # }
  # if (nomVariable_ == "NbJoursSup20"){
  #   listOption = list(typeChangeVariable='rel',spar=1)
  # }
  listOption = list(typeChangeVariable='rel',spar=1)
  
  QUALYPSO.time = QUALYPSO(Y=Y,scenAvail=scenAvail,X=X_time_vec,
                           Xfut=Xfut_time,listOption=listOption)
  
  ## ------------------------------------------------------------------------------------------------------
  phiStar = QUALYPSO.time$CLIMATERESPONSE$phiStar
  # x11()
  # plot(-1,-1,xlim=range(Xfut_time),ylim=range(phiStar),xlab="Years",ylab="          PFI (%)",yaxt="n",cex.lab=1.5,cex.axis=1.2)
  # for(i in 1:nrow(Y)){
  #   lines(Xfut_time,phiStar[i,],col=i)
  # }
  # y_labels <- pretty(range(range(phiStar)))
  # axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1, cex.axis = 1.3)
  # recorded_plot <- recordPlot()
  
  png(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/4_ChroniquesPFI_ProjChgtValAbs_",nomVariable_,"_",nomSimulation_,"_1_20240526.png"),
      width = 800, height = 600)
  par(mar = c(5, 5, 4, 2) + 0.1)  # Augmenter la marge gauche (2ème valeur)
  plot_graph_4(Xfut_time,Y,phiStar)
  dev.off()
  
  svg(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/4_ChroniquesPFI_ProjChgtValAbs_",nomVariable_,"_",nomSimulation_,"_1_20240526.svg"),
      width = 16, height = 12)
  par(mar = c(5, 5, 4, 2) + 0.1)  # Augmenter la marge gauche (2ème valeur)
  plot_graph_4(Xfut_time,Y,phiStar)
  dev.off()
  
  pdf(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/4_ChroniquesPFI_ProjChgtValAbs_",nomVariable_,"_",nomSimulation_,"_1_20240526.pdf"),
      width = 16, height = 12)
  par(mar = c(5, 5, 4, 2) + 0.1)  # Augmenter la marge gauche (2ème valeur)
  plot_graph_4(Xfut_time,Y,phiStar)
  dev.off()
  
  saveRDS(plot_graph_4(Xfut_time,Y,phiStar), paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/4_ChroniquesPFI_ProjChgtValAbs_",nomVariable_,"_",nomSimulation_,"_1_20240526.rds"))
  
  
  # on peut essayer de produire une figure similaire avec une couleur par GCM
  vecGCM = unique(scenAvail$GCM)
  # x11()
  # plot(-1,-1,xlim=range(Xfut_time),ylim=range(phiStar),xlab="Years",ylab="          PFI (%)",yaxt="n",cex.lab=1.5,cex.axis=1.2)
  # for(i in 1:nrow(Y)){
  #   lines(Xfut_time,phiStar[i,],col=which(scenAvail$GCM[i]==vecGCM))
  # }
  # legend("topleft",legend=vecGCM,col=1:4,lty=1)
  # y_labels <- pretty(range(range(phiStar)))
  # axis(2, at = y_labels, labels = paste0(y_labels, "%"), las = 1, cex.axis = 1.3)
  # recorded_plot <- recordPlot()
  
  png(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/5_ChroniquesPFI_EffectTotal_",nomVariable_,"_",nomSimulation_,"_1_20240526.png"),
      width = 800, height = 600)
  par(mar = c(5, 5, 4, 2) + 0.1)  # Augmenter la marge gauche (2ème valeur)
  plot_graph_5(Xfut_time,Y,phiStar,scenAvail,vecGCM)
  dev.off()
  
  svg(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/5_ChroniquesPFI_EffectTotal_",nomVariable_,"_",nomSimulation_,"_1_20240526.svg"),
      width = 16, height = 12)
  par(mar = c(5, 5, 4, 2) + 0.1)  # Augmenter la marge gauche (2ème valeur)
  plot_graph_5(Xfut_time,Y,phiStar,scenAvail,vecGCM)
  dev.off()
  
  pdf(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/5_ChroniquesPFI_EffectTotal_",nomVariable_,"_",nomSimulation_,"_1_20240526.pdf"),
      width = 16, height = 12)
  par(mar = c(5, 5, 4, 2) + 0.1)  # Augmenter la marge gauche (2ème valeur)
  plot_graph_5(Xfut_time,Y,phiStar,scenAvail,vecGCM)
  dev.off()
  
  saveRDS(plot_graph_5(Xfut_time,Y,phiStar,scenAvail,vecGCM), paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/5_ChroniquesPFI_EffectTotal_",nomVariable_,"_",nomSimulation_,"_1_20240526.rds"))
  
  ## ------------------------------------------------------------------------------------------------------
  # moyenne d'ensemble
  # x11()
  # plotQUALYPSOgrandmean(QUALYPSO.time)
  # recorded_plot <- recordPlot()
  
  plotQUALYPSOgrandmean(QUALYPSOOUT = QUALYPSO.time,
                        cex.lab=1.5,
                        cex.axis=1.2,
                        outputName_ = paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/6_ChroniquesPFI_GrandMean_",nomVariable_,"_",nomSimulation_,"_1_20240526"))
  
  # png(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/6_ChroniquesPFI_GrandMean_",nomVariable_,"_",nomSimulation_,"_1_20240526.png"),
  #     width = 800, height = 600)
  # plotQUALYPSOgrandmean(QUALYPSO.time,cex.lab=1.5,cex.axis=1.2)
  # dev.off()
  # 
  # svg(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/6_ChroniquesPFI_GrandMean_",nomVariable_,"_",nomSimulation_,"_1_20240526.svg"),
  #     width = 16, height = 12)
  # plotQUALYPSOgrandmean(QUALYPSO.time,cex.lab=1.5,cex.axis=1.2)
  # dev.off()
  # 
  # pdf(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/6_ChroniquesPFI_GrandMean_",nomVariable_,"_",nomSimulation_,"_1_20240526.pdf"),
  #     width = 16, height = 12)
  # plotQUALYPSOgrandmean(QUALYPSO.time,cex.lab=1.5,cex.axis=1.2)
  # dev.off()
  # 
  # saveRDS(plotQUALYPSOgrandmean(QUALYPSO.time,cex.lab=1.5,cex.axis=1.2), paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/6_ChroniquesPFI_GrandMean_",nomVariable_,"_",nomSimulation_,"_1_20240526.rds"))
  
  
  # effet GCM: les projections obtenues avec le GCM HadGEM2-ES sont en moyenne 0.6°C plus chaudes que les autres projections
  # x11()
  # plotQUALYPSOeffect(QUALYPSO.time,nameEff = "GCM_RCM")
  # recorded_plot <- recordPlot()
  
  
  # plotQUALYPSOeffect(QUALYPSOOUT = QUALYPSO.time,
  #                    nameEff = "GCM_RCM",
  #                    ylim=ylim_,
  #                    cex.lab=1.5,
  #                    cex.axis=1.2,
  #                    outputName_ = paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/7_ChroniquesPFI_EffectGCMRCM_",nomVariable_,"_",nomSimulation_,"_1_20240526"))
  
  plotQUALYPSOeffect(QUALYPSOOUT = QUALYPSO.time,
                     nameEff = "GCM",
                     ylim=ylim_,
                     cex.lab=1.5,
                     cex.axis=1.2,
                     outputName_ = paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/7_ChroniquesPFI_EffectGCM_",nomVariable_,"_",nomSimulation_,"_1_20240526"))
  
  plotQUALYPSOeffect(QUALYPSOOUT = QUALYPSO.time,
                     nameEff = "RCM",
                     ylim=ylim_,
                     cex.lab=1.5,
                     cex.axis=1.2,
                     outputName_ = paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/7_ChroniquesPFI_EffectRCM_",nomVariable_,"_",nomSimulation_,"_1_20240526"))
  
  # png(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/7_ChroniquesPFI_EffectGCMRCM_",nomVariable_,"_",nomSimulation_,"_1_20240526.png"),
  #     width = 800, height = 600)
  # plotQUALYPSOeffect(QUALYPSO.time,nameEff = "GCM_RCM",ylim=ylim_,cex.lab=1.5,cex.axis=1.2)
  # dev.off()
  # 
  # svg(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/7_ChroniquesPFI_EffectGCMRCM_",nomVariable_,"_",nomSimulation_,"_1_20240526.svg"),
  #     width = 16, height = 12)
  # plotQUALYPSOeffect(QUALYPSO.time,nameEff = "GCM_RCM",ylim=ylim_,cex.lab=1.5,cex.axis=1.2)
  # dev.off()
  # 
  # pdf(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/7_ChroniquesPFI_EffectGCMRCM_",nomVariable_,"_",nomSimulation_,"_1_20240526.pdf"),
  #     width = 16, height = 12)
  # plotQUALYPSOeffect(QUALYPSO.time,nameEff = "GCM_RCM",ylim=ylim_,cex.lab=1.5,cex.axis=1.2)
  # dev.off()
  # 
  # saveRDS(plotQUALYPSOeffect(QUALYPSO.time,nameEff = "GCM_RCM",ylim=ylim_,cex.lab=1.5,cex.axis=1.2), paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/7_ChroniquesPFI_EffectGCMRCM_",nomVariable_,"_",nomSimulation_,"_1_20240526.rds"))
  
  
  # effet HM: de manière similaire, quels sont les RCMs plus marqués que les autres sur une "hausse/baisse" de la PFI ?
  # x11()
  # plotQUALYPSOeffect(QUALYPSO.time,nameEff = "HM")
  # recorded_plot <- recordPlot()
  
  
  plotQUALYPSOeffect(QUALYPSOOUT = QUALYPSO.time,
                     nameEff = "HM",
                     ylim=ylim_,
                     cex.lab=1.5,
                     cex.axis=1.2,
                     outputName_ = paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/8_ChroniquesPFI_EffectHM_",nomVariable_,"_",nomSimulation_,"_1_20240526"))
  
  # png(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/8_ChroniquesPFI_EffectHM_",nomVariable_,"_",nomSimulation_,"_1_20240526.png"),
  #     width = 800, height = 600)
  # plotQUALYPSOeffect(QUALYPSO.time,nameEff = "HM",ylim=ylim_,cex.lab=1.5,cex.axis=1.2)
  # dev.off()
  # 
  # svg(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/8_ChroniquesPFI_EffectHM_",nomVariable_,"_",nomSimulation_,"_1_20240526.svg"),
  #     width = 16, height = 12)
  # plotQUALYPSOeffect(QUALYPSO.time,nameEff = "HM",ylim=ylim_,cex.lab=1.5,cex.axis=1.2)
  # dev.off()
  # 
  # pdf(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/8_ChroniquesPFI_EffectHM_",nomVariable_,"_",nomSimulation_,"_1_20240526.pdf"),
  #     width = 16, height = 12)
  # plotQUALYPSOeffect(QUALYPSO.time,nameEff = "HM",ylim=ylim_,cex.lab=1.5,cex.axis=1.2)
  # dev.off()
  # 
  # saveRDS(plotQUALYPSOeffect(QUALYPSO.time,nameEff = "HM",ylim=ylim_,cex.lab=1.5,cex.axis=1.2), paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/8_ChroniquesPFI_EffectRCP_",nomVariable_,"_",nomSimulation_,"_1_20240526.rds"))
  
  
  ### RCP ###
  if ("RCP" %in% colnames(scenAvail)){
    
    plotQUALYPSOeffect(QUALYPSOOUT = QUALYPSO.time,
                       nameEff = "RCP",
                       ylim=ylim_,
                       cex.lab=1.5,
                       cex.axis=1.2,
                       outputName_ = paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/8_ChroniquesPFI_EffectRCP_",nomVariable_,"_",nomSimulation_,"_1_20240526"))
    
    # png(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/8_ChroniquesPFI_EffectRCP_",nomVariable_,"_",nomSimulation_,"_1_20240526.png"),
    #     width = 800, height = 600)
    # plotQUALYPSOeffect(QUALYPSO.time,nameEff = "RCP",ylim=ylim_,cex.lab=1.5,cex.axis=1.2)
    # dev.off()
    # 
    # svg(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/8_ChroniquesPFI_EffectRCP_",nomVariable_,"_",nomSimulation_,"_1_20240526.svg"),
    #     width = 16, height = 12)
    # plotQUALYPSOeffect(QUALYPSO.time,nameEff = "RCP",ylim=ylim_,cex.lab=1.5,cex.axis=1.2)
    # dev.off()
    # 
    # pdf(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/8_ChroniquesPFI_EffectRCP_",nomVariable_,"_",nomSimulation_,"_1_20240526.pdf"),
    #     width = 16, height = 12)
    # plotQUALYPSOeffect(QUALYPSO.time,nameEff = "RCP",ylim=ylim_,cex.lab=1.5,cex.axis=1.2)
    # dev.off()
    # 
    # saveRDS(plotQUALYPSOeffect(QUALYPSO.time,nameEff = "RCP",ylim=ylim_,cex.lab=1.5,cex.axis=1.2), paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/8_ChroniquesPFI_EffectRCP_",nomVariable_,"_",nomSimulation_,"_1_20240526.rds"))
  }
  
  ## ------------------------------------------------------------------------------------------------------
  # la part des différentes sources d'incertitude est contenue dans QUALYPSO.time$DECOMPVAR
  QUALYPSO.time$DECOMPVAR
  
  # la fonction plotQUALYPSOTotalVarianceDecomposition permet d'illustrer cette décomposition
  # x11()
  # plotQUALYPSOTotalVarianceDecomposition(QUALYPSO.time)
  # recorded_plot <- recordPlot()
  
  
  plotQUALYPSOTotalVarianceDecomposition(QUALYPSOOUT = QUALYPSO.time,
                                         cex.lab=1.5,
                                         cex.axis=1.2,
                                         ylim=ylim_enveloppe_,
                                         outputName_ = paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/9_ChroniquesPFI_TotalVarianceDecomposition_",nomVariable_,"_",nomSimulation_,"_1_20240526"))
  
  # png(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/9_ChroniquesPFI_TotalVarianceDecomposition_",nomVariable_,"_",nomSimulation_,"_1_20240526.png"),
  #     width = 800, height = 600)
  # plotQUALYPSOTotalVarianceDecomposition(QUALYPSO.time,cex.lab=1.5,cex.axis=1.2)
  # dev.off()
  # 
  # svg(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/9_ChroniquesPFI_TotalVarianceDecomposition_",nomVariable_,"_",nomSimulation_,"_1_20240526.svg"),
  #     width = 16, height = 12)
  # plotQUALYPSOTotalVarianceDecomposition(QUALYPSO.time,cex.lab=1.5,cex.axis=1.2)
  # dev.off()
  # 
  # pdf(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/9_ChroniquesPFI_TotalVarianceDecomposition_",nomVariable_,"_",nomSimulation_,"_1_20240526.pdf"),
  #     width = 16, height = 12)
  # plotQUALYPSOTotalVarianceDecomposition(QUALYPSO.time,cex.lab=1.5,cex.axis=1.2)
  # dev.off()
  # 
  # saveRDS(plotQUALYPSOTotalVarianceDecomposition(QUALYPSO.time,cex.lab=1.5,cex.axis=1.2), paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/9_ChroniquesPFI_TotalVarianceDecomposition_",nomVariable_,"_",nomSimulation_,"_1_20240526.rds"))
  
  
  # la variabilité des réponses au changement climatique (écart-type) correspond à la variance totale issue de l'ANOVA, sans la variabilité interne
  phiStar = QUALYPSO.time$CLIMATERESPONSE$phiStar
  apply(phiStar,2,sd)
  sqrt(QUALYPSO.time$TOTALVAR*(1-QUALYPSO.time$DECOMPVAR[,4]))
  
  ## ------------------------------------------------------------------------------------------------------
  # plotQUALYPSOMeanChangeAndUncertainties(QUALYPSO.time)
  # recorded_plot <- recordPlot()
  
  
  plotQUALYPSOMeanChangeAndUncertainties(QUALYPSOOUT = QUALYPSO.time,
                                         cex.lab=1.5,
                                         cex.axis=1.2,
                                         ylim=ylim_enveloppe_,
                                         outputName_ = paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/10_ChroniquesPFI_MeanChangeAndUncertainties_",nomVariable_,"_",nomSimulation_,"_1_20240526"))
  
  # png(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/10_ChroniquesPFI_MeanChangeAndUncertainties_",nomVariable_,"_",nomSimulation_,"_1_20240526.png"),
  #     width = 800, height = 600)
  # plotQUALYPSOMeanChangeAndUncertainties(QUALYPSO.time,cex.lab=1.5,cex.axis=1.2)
  # dev.off()
  # 
  # svg(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/10_ChroniquesPFI_MeanChangeAndUncertainties_",nomVariable_,"_",nomSimulation_,"_1_20240526.svg"),
  #     width = 16, height = 12)
  # plotQUALYPSOMeanChangeAndUncertainties(QUALYPSO.time,cex.lab=1.5,cex.axis=1.2)
  # dev.off()
  # 
  # pdf(paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/10_ChroniquesPFI_MeanChangeAndUncertainties_",nomVariable_,"_",nomSimulation_,"_1_20240526.pdf"),
  #     width = 16, height = 12)
  # plotQUALYPSOMeanChangeAndUncertainties(QUALYPSO.time,cex.lab=1.5,cex.axis=1.2)
  # dev.off()
  # 
  # saveRDS(plotQUALYPSOMeanChangeAndUncertainties(QUALYPSO.time,cex.lab=1.5,cex.axis=1.2), paste0("/media/tjaouen/Ultra Touch/Backup/Main/Output/ChangementClimatique2019/EtudeFrance/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/32_ObservesReanalyseSafran_ApprentissageTousScenariosProjections_20240208/StatistiquesPFI/Incertitudes/Version_1_20240526/HER",HER_,"/",nomVariable_,"/",nomSimulation_,"/10_ChroniquesPFI_MeanChangeAndUncertainties_",nomVariable_,"_",nomSimulation_,"_1_20240526.rds"))
  
  
  Y_rcp85 <- Y
  scenAvail_rcp85 <- scenAvail
  X_rcp85 <- X_time_vec
  Xfut_rcp85 <- Xfut_time
  listOption_rcp85 <- listOption
  
  graphics.off()
  
}

### Parameters ###
ratio_epaisseurs_ = 1

# HER_ = 57 #Haute Normandie Picardie (57)
# HER_ = 81 #Plaine de Bourgogne (81)
# HER_ = 13 #Dévoluy Vercors sud (13)
HER_ = 105 #Plaine méditerranéenne (105)

nomVariable_ = "NbJoursSup20_SplitRCPGCM"
ylim_param_ = c(-6,6)
ylim_enveloppe_param_ = c(-6,6)

###########################
######### RCP 8.5 #########
###########################

# Les projections de moyennes de température hivernale pour 20 simulations de 129 Years sont contenus dans Y sous la forme d'une matrice 20 x 129
# list_files_ <- list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProba_LearnBrut_ByHer/FDC_Projections/",
# list_files_ <- list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/FDC_Projections/",
#                           pattern = paste0("Tab_AnnualMean_",HER_,".txt"), full.names = T, recursive = T, include.dirs = F)
list_files_ <- list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/",
                          pattern = paste0("Tab_Indicateurs_NbJoursSup20_HER",HER_), full.names = T, recursive = T, include.dirs = F)

# list_files_ <- list_files_[grepl("CTRIP",list_files_)]
# list_files_ <- list_files_[grepl("ADAMONT",list_files_)]
list_files_ <- list_files_[grepl("rcp85",list_files_)]
list_files_ <- list_files_[!grepl("J2000_20231128_avecHERexclues",list_files_)]


Y = data.frame()
noms_chaines_ = c()

for (fl in list_files_){
  tab_ <- read.table(fl, header = T, sep = ";", dec = ".")
  tab_ <- tab_[which(tab_$Year >= 1976 & tab_$Year <= 2099),]
  colnames(tab_)[2:ncol(tab_)] <- paste0(strsplit(fl,"/")[[1]][13],"_",colnames(tab_)[2:ncol(tab_)])
  # colnames(tab_)[2] <- paste0(strsplit(fl,"/")[[1]][c(13,15)], collapse = "_")
  
  if (nrow(Y) == 0){
    Y = tab_
  }else{
    if (nrow(Y) != nrow(tab_)){
      print(tab_$Year)
      # stop("Error nb lines")
    }else{
      Y = merge(Y, tab_, by = "Year", all.x = T)
    }
  }
}

?Y
Y$Year
dim(Y) # 124 annees, 136 simu

# Les Years correspondantes sont contenues dans le vecteur X_time_vec
X_time_vec <- Y$Year
Y <- Y[,which(colnames(Y) != "Year")]
colnames(Y) <- gsub("\\.", "_", colnames(Y))
Y <- Y[,grepl("ADAMONT",colnames(Y))]


# Les modèles GCM et RCM correspondants aux 20 simulations sont données dans scenAvail (data.frame avec deux colonnes "GCM" et "RCM" et 20 lignes correspondant aux 20 simulations). Ces 20 simulations correspondent à 4 GCMs descendus en échelle aveec 5 RCMs
pattern_HM_ <- c("CTRIP","GRSD","J2000","ORCHIDEE","SMASH")
pattern_GCM_ <- c("CNRM_CERFACS_CNRM_CM5",
                  "ICHEC_EC_EARTH",
                  "IPSL_IPSL_CM5A_MR",
                  "MOHC_HadGEM2_ES",
                  "MPI_M_MPI_ESM_LR",
                  "NCC_NorESM1_M")
pattern_RCM_ <- c("CNRM_ALADIN6",
                  "MOHC_HadREM3_GA7_05",
                  "KNMI_RACMO22E",
                  "SMHI_RCA4",
                  "DMI_HIRHAM5",
                  "CLMcom_CCLM4_8_17",
                  "ICTP_RegCM4_6",
                  "MPI_CSC_REMO2009",
                  "GERICS_REMO2015",
                  "IPSL_WRF381P")

colnames(Y)

scenAvail <- data.frame(RCM = character(),
                        GCM = character(),
                        HM = character(),
                        stringsAsFactors = FALSE)

# Extraction des patterns
for (nom in colnames(Y)) {
  hm <- pattern_HM_[sapply(pattern_HM_, grepl, nom)]
  gcm <- pattern_GCM_[sapply(pattern_GCM_, grepl, nom)]
  rcm <- pattern_RCM_[sapply(pattern_RCM_, grepl, nom)]
  
  # Ajout des résultats dans le data frame
  scenAvail <- rbind(scenAvail, data.frame(GCM = gcm,
                                           RCM = rcm,
                                           HM = hm,
                                           stringsAsFactors = FALSE))
}
dim(scenAvail)
scenAvail
table(scenAvail$GCM)
table(scenAvail$RCM)
table(scenAvail$HM)
# scenAvail$GCM_RCM <- paste0(scenAvail$GCM," + ",scenAvail$RCM)
# scenAvail <- scenAvail[,c("GCM_RCM","HM")]
# apply(scenAvail,2,unique)

Y <- t(Y)
Y_rcp85 <- Y
scenAvail_rcp85 <- scenAvail

# runPlot(Y_rcp85,"rcp85")
# runPlot(Y = Y_rcp85,
#         scenAvail = scenAvail_rcp85,
#         X_time_vec = X_time_vec,
#         # Xfut_time = Xfut_time,
#         Xfut_time = c(seq(1990,2090,by =10),2099),
#         nomSimulation_ = paste0("rcp85_HER",HER_),
#         HER_ = HER_,
#         nomVariable_ = nomVariable_,
#         ylim_ = ylim_param_,
#         ylim_enveloppe_ = ylim_enveloppe_param_)




###########################
######### RCP 4.5 #########
###########################

# if (nomVariable_ == "NbJoursSup20"){
list_files_ <- list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_Indicateurs/FDC_Projections/",
                          pattern = paste0("Tab_Indicateurs_NbJoursSup20_HER",HER_), full.names = T, recursive = T, include.dirs = F)
# }
# Les projections de moyennes de température hivernale pour 20 simulations de 129 Years sont contenus dans Y sous la forme d'une matrice 20 x 129
# list_files_ <- list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProba_LearnBrut_ByHer/FDC_Projections/",
#                           pattern = paste0("Tab_Indicateurs_NbJoursSup20_HER",HER_), full.names = T, recursive = T, include.dirs = F)
# list_files_ <- list_files_[grepl("CTRIP",list_files_)]
list_files_ <- list_files_[grepl("ADAMONT",list_files_)]
list_files_ <- list_files_[grepl("rcp45",list_files_)]
list_files_ <- list_files_[!grepl("J2000_20231128_avecHERexclues",list_files_)]


Y = data.frame()
for (fl in list_files_){
  tab_ <- read.table(fl, header = T, sep = ";", dec = ".")
  # tab_ <- group_by()
  tab_ <- tab_[which(tab_$Year >= 1976 & tab_$Year <= 2099),]
  # tab_ <- tab_ %>%
  #   group_by(Year) %>%
  #   summarize(mean_PFI = mean(mean_PFI, na.rm = TRUE))
  colnames(tab_)[2:ncol(tab_)] <- paste0(strsplit(fl,"/")[[1]][13],"_",colnames(tab_)[2:ncol(tab_)])
  # colnames(tab_)[2] <- paste0(strsplit(fl,"/")[[1]][c(13,15)], collapse = "_")
  
  if (nrow(Y) == 0){
    Y = tab_
  }else{
    if (nrow(Y) != nrow(tab_)){
      print(tab_$Year)
      # stop("Error nb lines")
    }else{
      Y = merge(Y, tab_, by = "Year", all.x = T)
    }
  }
}

?Y
Y$Year
dim(Y) # 124 simulations

# Les Years correspondantes sont contenues dans le vecteur X_time_vec
X_time_vec <- Y$Year
Y <- Y[,which(colnames(Y) != "Year")]

# Les modèles GCM et RCM correspondants aux 20 simulations sont données dans scenAvail (data.frame avec deux colonnes "GCM" et "RCM" et 20 lignes correspondant aux 20 simulations). Ces 20 simulations correspondent à 4 GCMs descendus en échelle aveec 5 RCMs
pattern_HM_ <- c("CTRIP","GRSD","J2000","ORCHIDEE","SMASH")
# pattern_GCM_ <- c("CNRM-CM5","EC-EARTH","IPSL-CM5A","MOHC-HadGEM2","MPI-ESM-LR","NCC-NorESM1-M")
pattern_GCM_ <- c("CNRM_CERFACS_CNRM_CM5",
                  "ICHEC_EC_EARTH",
                  "IPSL_IPSL_CM5A_MR",
                  "MOHC_HadGEM2_ES",
                  "MPI_M_MPI_ESM_LR",
                  "NCC_NorESM1_M")
pattern_RCM_ <- c("CNRM_ALADIN6",
                  "MOHC_HadREM3_GA7_05",
                  "KNMI_RACMO22E",
                  "SMHI_RCA4",
                  "DMI_HIRHAM5",
                  "CLMcom_CCLM4_8_17",
                  "ICTP_RegCM4_6",
                  "MPI_CSC_REMO2009",
                  "GERICS_REMO2015",
                  "IPSL_WRF381P")

colnames(Y)
colnames(Y) <- gsub("\\.","_",colnames(Y))

scenAvail <- data.frame(RCM = character(),
                        GCM = character(),
                        HM = character(),
                        stringsAsFactors = FALSE)

# Extraction des patterns
for (nom in colnames(Y)) {
  hm <- pattern_HM_[sapply(pattern_HM_, grepl, nom)]
  gcm <- pattern_GCM_[sapply(pattern_GCM_, grepl, nom)]
  rcm <- pattern_RCM_[sapply(pattern_RCM_, grepl, nom)]
  
  # Ajout des résultats dans le data frame
  scenAvail <- rbind(scenAvail, data.frame(GCM = gcm,
                                           RCM = rcm,
                                           HM = hm,
                                           stringsAsFactors = FALSE))
}
dim(scenAvail)
scenAvail
# scenAvail$GCM_RCM <- paste0(scenAvail$GCM," + ",scenAvail$RCM)
# scenAvail <- scenAvail[,c("GCM_RCM","HM")]
# apply(scenAvail,2,unique)

Y <- t(Y)
Y_rcp45 <- Y
scenAvail_rcp45 <- scenAvail

# runPlot(Y_rcp45,"rcp45")
# runPlot(Y = Y_rcp45,
#         scenAvail = scenAvail_rcp45,
#         X_time_vec = X_time_vec,
#         # Xfut_time = Xfut_time,
#         Xfut_time = c(seq(1990,2090,by =10),2099),
#         nomSimulation_ = paste0("rcp45_HER",HER_),
#         HER_ = HER_,
#         nomVariable_ = nomVariable_,
#         ylim_ = ylim_param_,
#         ylim_enveloppe_ = ylim_enveloppe_param_)


###################################
######### RCP 45 + RCP 85 #########
###################################

Y_rpc45and85 <- rbind(Y_rcp45,Y_rcp85)
scenAvail_rcp45$RCP <- "rcp45"
scenAvail_rcp85$RCP <- "rcp85"
scenAvail_rpc45and85 <- rbind(scenAvail_rcp45,scenAvail_rcp85)
Y <- Y_rpc45and85

# Convertir la matrice en data frame
data <- as.data.frame(Y)

# Ajouter une colonne pour les modèles
data$model <- row.names(data)

# Restructurer le data frame pour qu'il soit en format long
data_long <- data %>%
  pivot_longer(cols = -model, names_to = "time", values_to = "value")

# Convertir les colonnes en numérique
data_long$time <- as.numeric(gsub("V", "", data_long$time))
data_long$value <- as.numeric(data_long$value)

# Créer le plot ggplot
ggplot(data_long, aes(x = time, y = value, color = model)) +
  geom_line() +
  labs(title = "Débit en fonction du temps",
       x = "Temps (jours)",
       y = "Débit") +
  theme_minimal() +
  theme(legend.position = "none")


# runPlot(Y,"rcp45and85")
runPlot(Y = Y_rpc45and85,
        scenAvail = scenAvail_rpc45and85,
        X_time_vec = X_time_vec,
        # Xfut_time = Xfut_time,
        Xfut_time = c(seq(1990,2090,by =10),2099),
        nomSimulation_ = paste0("rcp45and85_HER",HER_),
        HER_ = HER_,
        nomVariable_ = nomVariable_,
        ylim_ = ylim_param_,
        ylim_enveloppe_ = ylim_enveloppe_param_)



#### Rcp 45 sans J2000 et ORCHIDEE ###
# ind_ <- which(scenAvail_rcp45$HM %in% c("CTRIP","GRSD","SMASH"))
# scenAvail_rcp45_sansJ2000Orchidee <- scenAvail_rcp45[ind_,]
# Y <- Y_rcp45[ind_,]
# runPlot(Y = Y,
#         scenAvail = scenAvail_rcp45_sansJ2000Orchidee[,c("GCM_RCM","HM")],
#         X_time_vec = X_time_vec,
#         # Xfut_time = Xfut_time,
#         Xfut_time = c(seq(1990,2090,by =10),2099),
#         nomSimulation_ = paste0("rcp45_CtripGrsdSmash_HER",HER_),
#         HER_ = HER_,
#         nomVariable_ = nomVariable_,
#         ylim_ = ylim_param_,
#         ylim_enveloppe_ = ylim_enveloppe_param_)

#### Rcp 85 sans J2000 et ORCHIDEE ###
# ind_ <- which(scenAvail_rcp85$HM %in% c("CTRIP","GRSD","SMASH"))
# scenAvail_rcp85_sansJ2000Orchidee <- scenAvail_rcp85[ind_,]
# Y <- Y_rcp85[ind_,]
# runPlot(Y = Y,
#         scenAvail = scenAvail_rcp85_sansJ2000Orchidee[,c("GCM_RCM","HM")],
#         X_time_vec = X_time_vec,
#         # Xfut_time = Xfut_time,
#         Xfut_time = c(seq(1990,2090,by =10),2099),
#         nomSimulation_ = paste0("rcp85_CtripGrsdSmash_HER",HER_),
#         HER_ = HER_,
#         nomVariable_ = nomVariable_,
#         ylim_ = ylim_param_,
#         ylim_enveloppe_ = ylim_enveloppe_param_)

#### Rcp 45+85 sans J2000 et ORCHIDEE ###
ind_ <- which(scenAvail_rpc45and85$HM %in% c("CTRIP","GRSD","SMASH"))
scenAvail_rcp45and85_sansJ2000Orchidee <- scenAvail_rpc45and85[ind_,]
Y <- Y_rpc45and85[ind_,]
runPlot(Y = Y,
        scenAvail = scenAvail_rcp45and85_sansJ2000Orchidee,
        # scenAvail = scenAvail_rcp45and85_sansJ2000Orchidee[,c("GCM_RCM","HM")],
        X_time_vec = X_time_vec,
        # Xfut_time = Xfut_time,
        Xfut_time = c(seq(1990,2090,by =10),2099),
        nomSimulation_ = paste0("rcp45and85_CtripGrsdSmash_HER",HER_),
        HER_ = HER_,
        nomVariable_ = nomVariable_,
        ylim_ = ylim_param_,
        ylim_enveloppe_ = ylim_enveloppe_param_)


#### Rcp 45+85 sans J2000 ###
ind_ <- which(scenAvail_rpc45and85$HM %in% c("CTRIP","GRSD","ORCHIDEE","SMASH"))
scenAvail_rcp45and85_sansJ2000 <- scenAvail_rpc45and85[ind_,]
Y <- Y_rpc45and85[ind_,]
runPlot(Y = Y,
        # scenAvail = scenAvail_rcp45and85_sansJ2000Orchidee[,c("GCM_RCM","HM")],
        scenAvail = scenAvail_rcp45and85_sansJ2000,
        X_time_vec = X_time_vec,
        # Xfut_time = Xfut_time,
        Xfut_time = c(seq(1990,2090,by =10),2099),
        nomSimulation_ = paste0("rcp45and85_CtripGrsdSmash_HER",HER_),
        HER_ = HER_,
        nomVariable_ = nomVariable_,
        ylim_ = ylim_param_,
        ylim_enveloppe_ = ylim_enveloppe_param_)


# 
# 
# 
# 
# listOption = list(typeChangeVariable='rel',spar=1)
# QUALYPSO.time = QUALYPSO(Y=Y,scenAvail=scenAvail,X=X_time_vec,
#                          Xfut=Xfut_time,listOption=listOption)
# 
# x11()
# plotQUALYPSOclimateResponse(QUALYPSO.time,lim=NULL,xlab="X",ylab="Y")
# plotQUALYPSOclimateChangeResponse(QUALYPSO.time,lim=NULL,xlab="",
#                                   ylab="Climate change response")
# plotQUALYPSOgrandmean(QUALYPSO.time,lim=NULL,col='black',xlab="",
#                       ylab="Grand mean",addLegend=T)
# plotQUALYPSOeffect(QUALYPSO.time,nameEff = "GCM_RCM",includeMean=FALSE,lim=NULL,
#                    col=1:20,xlab="",ylab="Effect",addLegend=TRUE)
# plotQUALYPSOTotalVarianceDecomposition(QUALYPSO.time,vecEff=NULL,
#                                        col=c("orange","yellow","cadetblue1","blue1","darkgreen","darkgoldenrod4","darkorchid1"),
#                                        xlab="",ylab="% Total Variance",addLegend=TRUE)
# plotQUALYPSOTotalVarianceByScenario(QUALYPSO.time,nameEff="GCM_RCM",
#                                     nameScenario="CTRIP_20231128_debit_France_CNRM_CERFACS_CNRM_CM5_rcp85_r1i1p1_CNRM_ALADIN63_v3_MF_ADAMONT_SAFRAN_1980_2011_MF_ISBA_CTRIP_day_20050801_21000731",
#                                     col=NULL,ylim=NULL,xlab="",
#                                     ylab="Change variable",
#                                     addLegend=TRUE)
# plotQUALYPSOMeanChangeAndUncertainties(QUALYPSO.time,col=NULL,ylim=NULL,
#                                        xlab="",ylab="Change variable",addLegend=TRUE)
# plotQUALYPSOMeanChangeAndUncertaintiesBetatest(QUALYPSO.time,col=NULL,ylim=NULL,
#                                                xlab="",ylab="Change variable",addLegend=TRUE)
# 
