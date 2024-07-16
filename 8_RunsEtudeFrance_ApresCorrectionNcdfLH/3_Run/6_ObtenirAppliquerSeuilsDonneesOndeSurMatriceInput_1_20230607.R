obtenirSeuilsOnde <- function(MatriceInput, Niveau){

  Seuil_df_ = data.frame()
  for (h in unique(MatriceInput$HER2)){
    Mat_h_ <- MatriceInput[which(MatriceInput$HER2 == h),]
    if (length(which(is.na(MatriceInput$NbOutputONDE))) > 0){
      stop(paste0("Erreur. Message personnalisé : nombre d'observations ONDE non disponible à certaines dates pour l'HER ",h))
    }else{
      Seuil_df_ <- rbind(Seuil_df_,data.frame(HER = h, Seuil = round(Niveau * max(Mat_h_$NbOutputONDE))))
    }
  }
  return(Seuil_df_)

}

appliquerSeuilsOnde <- function(tab_, Seuil_df_){
  stat_ = data.frame()
  for (h in unique(tab_$HER2)){
    # print(h)
    ind_excl_ <- which((tab_$HER2 == h) & (tab_$NbOutputONDE <= Seuil_df_$Seuil[which(Seuil_df_$HER == h)]))
    if (length(ind_excl_) > 0){
      tab_ <- tab_[-ind_excl_,]
      # print(ind_excl_)
    }
    stat_ <- rbind(stat_, data.frame(HER = h,
                                     nb_excl_ = length(ind_excl_),
                                     nb_cons_ = length(which(tab_$HER2 == h))-length(ind_excl_)))
  }
  return(list(tab_,stat_))
}


indiquerSeuilsOndeBinaire <- function(tab_, Seuil_df_){
  stat_ = data.frame()
  tab_$UtiliseEnApprentissage = NA
  tab_$Seuil = NA
  for (h in unique(tab_$HER2)){
    # print(h)
    ind_excl_ <- which((tab_$HER2 == h) & (tab_$NbOutputONDE <= Seuil_df_$Seuil[which(Seuil_df_$HER == h)]))
    ind_incl_ <- which((tab_$HER2 == h) & (tab_$NbOutputONDE > Seuil_df_$Seuil[which(Seuil_df_$HER == h)]))
    tab_$UtiliseEnApprentissage[ind_excl_] <- 0
    tab_$UtiliseEnApprentissage[ind_incl_] <- 1
    tab_$Seuil[ind_incl_] <- Seuil_df_$Seuil[which(Seuil_df_$HER == h)]
    stat_ <- rbind(stat_, data.frame(HER = h,
                                     nb_excl_ = length(ind_excl_),
                                     nb_cons_ = length(ind_incl_)))
  }
  return(list(tab_,stat_))
}


