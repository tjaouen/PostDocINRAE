source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_31_NewColors_Svg_20240319.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/Src_Commun/0_GraphesDescriptifsDonnees/0_GraphParameters_1_20230901.R")

### Parameters ###
folder_input_ <- folder_input_param_
folder_output_DD_ <- folder_output_DD_param_
nomSim_ <- nomSim_param_
nom_FDCfolder_ <- nom_FDCfolder_param_
ratio_epaisseurs_ <- 1.4

H0_ = "19762005"
H1_ = "20212050"
H2_ = "20412070"
H3_ = "20702099"
seuilAssec_ = 20

nom_categorieSimu_list_ = c(
  # "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp26/",
  #                           "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp45/",
                            # "CTRIP_20231128/ChroniquesCombinees_saf_hist_rcp85/")#,
  #                           "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp26/",
  #                           "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp45/",
                            # "GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/")#,
                            # "J2000_20231128/ChroniquesCombinees_saf_hist_rcp26/",
                            # "J2000_20231128/ChroniquesCombinees_saf_hist_rcp45/",
                            # "J2000_20231128/ChroniquesCombinees_saf_hist_rcp85/")#,
                            # "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp26/",
                            # "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp45/",
                            # "ORCHIDEE_20231128/ChroniquesCombinees_saf_hist_rcp85/")#,
                            # "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp26/",
                            # "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp45/",
                            "SMASH_20231128/ChroniquesCombinees_saf_hist_rcp85/")

HER_ <- c("2", "3", "5", "12", "13", "14", "17", "21", "22", "24", "25", "27", "28", "34", "35", "36",
          "38", "40", "41", "43", "44", "50", "51", "52", "53", "55", "56", "57", "58", "59", "61", 
          "62", "63", "64", "65", "66", "67", "68", "70", "71", "73", "74", "75", "76", "77", "78",
          "79", "81", "84", "85", "86", "87", "91", "93", "94", "97", "98", "99", "101", "103", "104",
          "105", "106", "107", "108", "112", "113", "117", "118", "120", "31033039", "37054", "69096",
          "89092", "49090")





### Function ###
plot_map_variable_sansEtiquettes <- function(tab_, varname_, vartitle_, breaks_, output_name_, title_, reverseColors_, nomPalette_, labels_name_ = FALSE, sansTexteHer_ = FALSE, reverseLegend_ = FALSE, echelleAttenuee_ = FALSE, addValueUnder = NULL, HER2_excluesDensity_ = NULL, subtitle_ = NULL, annotation_txt_ = TRUE, percentFormat = T, borderCol = "#454547", doubleLegend_ = T, taillePalette = NULL, retenuPalette = NULL, reverseFinal = F, reverseFinal_bis = F){
  
  if(sum(na.omit(tab_[[varname_]] > max(breaks_))) > 0){
    print(paste0("Error:",output_name_))
    stop()
  }
  
  if (!(is.null(addValueUnder))){
    if (is.Date(tab_[[varname_]])){
      breaks_ <- c(as.Date(addValueUnder),as.Date(breaks_, origin = "1970-01-01"))
    }else{
      breaks_ <- c(addValueUnder,breaks_)
    }
  }
  
  labels_ <- paste0(ifelse(breaks_[-length(breaks_)] == min(breaks_[-length(breaks_)]), "[", "("),
                    breaks_[-length(breaks_)],",", breaks_[-1],"]")
  
  if (labels_name_ == FALSE){
    labels_name_ <- paste0(ifelse(breaks_[-length(breaks_)] == min(breaks_[-length(breaks_)]), "[", "("),
                           breaks_[-length(breaks_)],",", breaks_[-1],"]")
    labels_name_check_ <- FALSE
  }else{
    labels_name_ <- labels_name_
    labels_name_check_ <- TRUE
  }
  # else{
  #   labels_name_ <- paste0(ifelse(labels_name_[-length(labels_name_)] == min(labels_name_[-length(labels_name_)]), "[", "("),
  #                          labels_name_[-length(labels_name_)],",", labels_name_[-1],"]")
  # }
  
  ### Import HER2 ###
  fr.spdf <- readOGR("/home/tjaouen/Documents/Input/HER/HER2hybrides/Shapefile/","HER2_hybrides")
  proj4string(fr.spdf)=CRS("+proj=longlat +ellps=WGS84")
  fr.prj <- spTransform(fr.spdf, CRS("+init=epsg:2154")) # trasnformation en Lambert93
  
  ### Jonction ###
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 37)] = "37+54"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 54)] = "37+54"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 69)] = "69+96"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 96)] = "69+96"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 31)] = "31+33+39"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 33)] = "31+33+39"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 39)] = "31+33+39"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 89)] = "89+92"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 92)] = "89+92"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 49)] = "49+90"
  fr.prj$CdHER2[which(fr.prj$CdHER2 == 90)] = "49+90"
  
  fr.prj[[varname_]] = NA
  if (paste0(varname_,"_IC95inf") %in% colnames(tab_)){
    fr.prj[[paste0(varname_,"_IC95inf")]] = NA
    fr.prj[[paste0(varname_,"_IC95sup")]] = NA
  }  
  
  for (i in 1:length(fr.prj$CdHER2)){
    if (length(which(tab_$HER == fr.prj$CdHER2[i])) > 0){
      fr.prj[[varname_]][i] = tab_[which(tab_$HER == fr.prj$CdHER2[i]),varname_]
    }else{
      fr.prj[[varname_]][i] = NA
    }
    if (paste0(varname_,"_IC95inf") %in% colnames(tab_)){
      if (length(which(tab_$HER == fr.prj$CdHER2[i])) > 0){
        fr.prj[[paste0(varname_,"_IC95inf")]][i] = tab_[which(tab_$HER == fr.prj$CdHER2[i]),paste0(varname_,"_IC95inf")]
        fr.prj[[paste0(varname_,"_IC95sup")]][i] = tab_[which(tab_$HER == fr.prj$CdHER2[i]),paste0(varname_,"_IC95sup")]
      }else{
        fr.prj[[paste0(varname_,"_IC95inf")]][i] = NA
        fr.prj[[paste0(varname_,"_IC95sup")]][i] = NA
      }
    }
  }
  
  breaks_max2_ <- breaks_[which(breaks_ != max(breaks_))]
  breaks_min1_ <- breaks_[which(breaks_ != min(breaks_))]
  breaks_min2_ <- breaks_min1_[which(breaks_min1_ != min(breaks_min1_))]
  labels_[which(labels_ == paste0("(",max(breaks_max2_),",",max(breaks_),"]"))] = paste0(">",max(breaks_max2_))
  labels_[which(labels_ == paste0("(",min(breaks_min1_),",",min(breaks_min2_),"]"))] = paste0("<(",min(breaks_min2_),")")
  
  if (is.Date(tab_[[varname_]])){
    fr.prj[[varname_]] <- as.Date(fr.prj[[varname_]], origin = "1970-01-01")
    fr.prj$var_cut_ <- cut(fr.prj[[varname_]],
                           breaks=as.Date(breaks_),
                           include.lowest = T,
                           label = labels_,
                           na.rm = T)
  }else{
    fr.prj$var_cut_ <- cut(fr.prj[[varname_]],
                           breaks=breaks_,
                           include.lowest = T,
                           label = labels_)
  }
  
  # Legende des HER 2
  # Extraire les coordonnées des centres de chaque polygone d'hydroécorégion de niveau 2
  her2_centers <- coordinates(gCentroid(fr.prj, byid=TRUE))
  
  # Extraire l'attribut "NUM_HER2" de chaque polygone d'hydroécorégion de niveau 2
  her2_attrib <- fr.prj$CdHER2
  
  # Convertir fr.prj en un dataframe utilisable dans ggplot2
  fr.df <- fortify(fr.prj)
  fr.df <- merge(fr.df, as.data.frame(fr.prj@data), by.x = "id", by.y = "row.names", all = TRUE)
  
  if (! is.null(HER2_excluesDensity_)){
    palette_col_ = as.factor(c(palette_col_, "#ffffff")) # "#737373", #1d91c0
    labels_ = as.factor(c(labels_, "Low data density"))
    labels_name_ = as.factor(c(labels_, "Low data density"))
    # labels_name_ = as.factor(c(labels_name_, "Low data density"))
    breaks_ = as.factor(c(breaks_, "Low data density"))
  }
  
  # Zoom RMC
  bbox <- c(xmin = 340000, xmax = 1300000, ymin = 6050000, ymax = 6800000)
  
  # Créer la palette de couleurs SurfaceHydroPropSurfHER2
  txt_ = read_lines(paste0(IPCCcolors_folder_,nomPalette_))
  length_color_ = max(as.numeric(str_after_last(grep("_", txt_, value = TRUE),"_")))
  
  if (doubleLegend_ == T){
    if (reverseColors_ == T){
      if (echelleAttenuee_ == TRUE){
        if (is.null(taillePalette)){
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_)*2+1,5),28)))
          palette_col_ <- palette_col_[round(length(palette_col_)/2):length(palette_col_)]
        }else{
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5),28)))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette):length(palette_col_)]
        }
      }else{
        if (is.null(taillePalette)){
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_)*2,5),28)))
          palette_col_ <- palette_col_[round(length(palette_col_)/2):length(palette_col_)]
        }else{
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5),28)))
          # palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette+2):length(palette_col_)]
          palette_col_ <- palette_col_[c(2,4,5,10,11,12,13,14,15)]
          
          # [1] "#003C30" "#015A50" "#1B7B73" "#419F96" "#76C5BA" "#A9DED5" "#D4EDEA" "#F5F5F5" "#F6ECD1"
          # [10] "#EDD8A5" "#DBB972" "#C48A39" "#A2651A" "#7B4709" "#543005"
          # 
          # 15 1 "#543005" [5:7]
          # 14 2 "#7B4709" [4:5]
          # 13 3 "#A2651A" [3:4]
          # 12 4 "#C48A39" [2:3]
          # 11 5 "#DBB972" [1:2]
          # 10 6 "#EDD8A5" [0:1]
          # 9 7 "#F6ECD1"
          # 8 "#F5F5F5"
          # 7 9 "#D4EDEA"
          # 6 10 "#A9DED5"
          # 5 11 "#76C5BA" [-1:0]
          # 4 12 "#419F96" [-1:-4]
          # 3 13 "#1B7B73"
          # 2 14 "#015A50" [-4:-7]
          # 1 15 "#003C30"
          
          # -7,-4,-2,0,1,2,3,4,5,7
          
        }
      }
    }else{
      if (echelleAttenuee_ == TRUE){
        if (is.null(taillePalette)){
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max((length(breaks_)-1)*2,5), 28))
          palette_col_ <- palette_col_[round(length(palette_col_)/2):length(palette_col_)]
        }else{
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5), 28))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette):length(palette_col_)]
        }
      }else{
        if (is.null(taillePalette)){
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max((length(breaks_)-1)*2,5), 28))
          palette_col_ <- palette_col_[round(length(palette_col_)/2):length(palette_col_)]
        }else{
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5), 28))
          # palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette+2):length(palette_col_)]
          palette_col_ <- palette_col_[c(2,4,5,10,11,12,13,14,15)]
          
          # 1 "#543005" [6:7]
          # 2 "#7B4709" [5:6]
          # 3 "#A2651A" [4:5]
          # 4 "#C48A39"
          # 5 "#DBB972" [2:4]
          # 6 "#EDD8A5" [1:2]
          # 7 "#F6ECD1"
          # 8 "#F5F5F5" [0:1]
          # 9 "#D4EDEA"
          # 10 "#A9DED5"
          # 11 "#76C5BA" [-2:0]
          # 12 "#419F96" [-2:-4]
          # 13 "#1B7B73"
          # 14 "#015A50" [-4:-7]
          # 15 "#003C30"
          
          # [-50,-7]   (-7,-4]   (-4,-2]    (-2,0]     (0,1]     (1,2]     (2,4]     (4,6]     (6,7] 
          # "white" "#D4EDEA" "#F5F5F5" "#F6ECD1" "#EDD8A5" "#DBB972" "#C48A39" "#A2651A" "#7B4709" 
          # (7,10]      <NA>      <NA> 
          # "#543005"        NA        NA 
          
        }
      }
    }
  }else{
    if (reverseColors_ == T){
      if (echelleAttenuee_ == TRUE){
        if (is.null(taillePalette)){
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_),5),28)))
        }else{
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5),28)))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette):length(palette_col_)]
        }
      }else{
        if (is.null(taillePalette)){
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(length(breaks_) - 1,5),28)))
        }else{
          palette_col_ <- rev(createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5),28)))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette+2):length(palette_col_)]
        }
      }
    }else{
      if (echelleAttenuee_ == TRUE){
        if (is.null(taillePalette)){
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max((length(breaks_)),5), 28))
        }else{
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5), 28))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette):length(palette_col_)]
        }
      }else{
        if (is.null(taillePalette)){
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max((length(breaks_)-1),5), 28))
        }else{
          palette_col_ <- createPaletteFromRgbTxt(IPCCcolors_folder_ = IPCCcolors_folder_, nomPalette_ = nomPalette_, size_ = min(max(taillePalette,5), 28))
          palette_col_ <- palette_col_[(length(palette_col_)-retenuPalette+2):length(palette_col_)]
        }
      }
    }
  }
  if (reverseFinal == T){
    palette_col_ <- rev(palette_col_)
  }
  # "#003C30" "#015248" "#046860" "#23827A" "#3E9D94" "#66B9AE" "#8CD2C7" "#B1E1DA"
  # [1] "#D7B067" "#EEDAA9" "#F6EFDE" "#E0F0EE" "#AEE0D8" "#6DBEB3" "#2D8E86" "#01625A" "#003C30"
  # [1] "#D4EDEA" "#F5F5F5" "#F6ECD1" "#EDD8A5" "#DBB972" "#C48A39" "#A2651A" "#7B4709" "#543005"
  
  
  # Ajustement de la palette
  if (length(breaks_)-1 > length_color_){
    stop("Message personnel : Erreur, pas assez de couleurs disponibles dans ce fichier txt de couleurs")
  }else{
    if (is.null(addValueUnder)){
      if (echelleAttenuee_ == TRUE){
        palette_col_ <- palette_col_[2:(length(breaks_))]
      }else{
        palette_col_ <- palette_col_[1:(length(breaks_)-1)]
      }
    }else{
      # palette_col_ <- palette_col_[1:(length(breaks_)-2)]
      palette_col_ <- palette_col_[1:(length(breaks_))]
      # palette_col_ <- palette_col_[3:(length(breaks_))]
      palette_col_ <- c("white",palette_col_)
    }
  }
  if (reverseFinal_bis == T){
    palette_col_ <- c("white",palette_col_[(length(palette_col_)-(length(labels_name_)-2)):length(palette_col_)])
    # palette_col_ <- rev(palette_col_)
    # temp <- palette_col_[1]
    # palette_col_[1] <- palette_col_[length(palette_col_)]
    # palette_col_[length(palette_col_)] <- temp
  }
  
  # fr.df$var_cut_[which(fr.df$var_cut_ == paste0("(",max(breaks_max2_),",20]"))] = as.factor(paste0(">",max(breaks_max2_)))
  fr.df$var_cut_ <- factor(fr.df$var_cut_, levels=labels_)
  
  if (! is.null(HER2_excluesDensity_)){
    fr.df$var_cut_[which(fr.df$CdHER2 %in% HER2_excluesDensity_)] = "Low data density"
  }
  
  if (labels_name_check_ != TRUE){
    labels_name_annotation_ <- paste0(c(substr(str_before_first(labels_name_[1],","),2,nchar(str_before_first(labels_name_[1],","))),
                                        str_before_first(str_after_first(labels_name_,","),"]")))
  }else{
    if (is.null(addValueUnder)){
      labels_name_annotation_ <- labels_name_
    }else{
      labels_name_annotation_ <- c("",labels_name_)
    }
  }
  
  if (percentFormat == T){
    labels_name_annotation_ <- paste0(labels_name_annotation_,"%")
  }
  if (is.Date(tab_[[varname_]])){
    labels_name_annotation_ <- format(as.Date(labels_name_annotation_, origin = "1970-01-01"),"%d/%m")
  }
#   [-50,-7]   (-7,-4]   (-4,-2]    (-2,0]     (0,1]     (1,2]     (2,4]     (4,6]     (6,7] 
# "white" "#D4EDEA" "#F5F5F5" "#F6ECD1" "#EDD8A5" "#DBB972" "#C48A39" "#A2651A" "#7B4709" 
# (7,10]      <NA>      <NA> 
#   "#543005"        NA        NA 
#   [-50,-7]   (-7,-4]   (-4,-2]    (-2,0]     (0,1]     (1,2]     (2,4]     (4,6]     (6,7] 
# "white" "#D4EDEA" "#F5F5F5" "#F6ECD1" "#EDD8A5" "#DBB972" "#C48A39" "#A2651A" "#7B4709" 
# (7,10]      <NA>      <NA> 
#   "#543005"        NA        NA 

  ### df color ###
  labels_name_annotation_[length(labels_name_annotation_)] <- paste0(">",max(breaks_max2_))
  labels_name_annotation_[2] <- paste0("<(",min(breaks_min2_),")")
  # df_color_ = setNames(palette_col_,labels_name_)
  df_color_ = setNames(palette_col_,labels_)
  if (! is.null(HER2_excluesDensity_)){
    df_color_["Low data density"] = "white" # "#737373", #1d91c0
      # df_color_["Low data density"] = "#ffffff" # "#737373", #1d91c0
  }
  
  unit_x_ = max(fr.df$long) - min(fr.df$long)
  unit_y_ = max(fr.df$lat) - min(fr.df$lat)
  origin_x_ = min(fr.df$long)
  origin_y_ = min(fr.df$lat)
  
  if (!is.null(addValueUnder)){
    # fr.df$var_cut_[which(is.na(fr.df$var_cut_))] = levels(fr.df$var_cut_)[1]
    fr.df$var_cut_[which(is.na(fr.df$var_cut_))] = NA
    fr.df$var_cut_[which(fr.df$CdHER2 == 10)] = levels(fr.df$var_cut_)[1]
    if (grepl("J2000",output_name_)){
      HER_eliminees_J2000 <- c("10", "21", "22", "24", "27", "34", "35", "36", "57", "59", "61", "65", "67", "68",
                               "77", "78", "93", "94", "103", "108", "118", "0", "31+33+39", "69+96",
                               "66", "64", "117", "112", "56", "62", "38", "40", "105", "17", "25", "107",
                               "55", "12", "53")
      fr.df$var_cut_[which(fr.df$CdHER2 %in% HER_eliminees_J2000)] = levels(fr.df$var_cut_)[1]
    }
  }
  
  p <- ggplot() +
    geom_polygon(data=fr.df, aes(x=long, y=lat, group=group, fill=var_cut_), 
                 color=borderCol, size = 0.3) +
    scale_fill_manual(values=df_color_,
                      name=vartitle_,
                      breaks=labels_,
                      labels=labels_name_annotation_[2:length(labels_name_annotation_)],
                      drop = F,
                      na.value = "grey45")
  if (sansTexteHer_ == FALSE){
    p <- p + geom_text(data = data.frame(x = her2_centers[,1], y = her2_centers[,2], label = her2_attrib),
                       aes(x = x, y = y, label = label),
                       color = "#2f2f32", size = 4, segment.alpha = 0.3,
                       force = 10)
  }
  p <- p + 
    theme(plot.title = element_text(color = "#060403", size = 30, face = "bold", hjust = 0.5),
          plot.subtitle = element_text(color = "#2f2f32", size = 18),
          
          axis.title = element_blank(),
          axis.text = element_blank(),
          axis.line = element_blank(),
          axis.ticks = element_blank(),
          
          panel.background = element_blank(),
          panel.grid = element_blank(),
          panel.border = element_blank(),
          
          text = element_text(size = 26),
          
          legend.position = c(1.1,0.5),
          # legend.title = element_blank(),
          legend.title = element_text(color = "#454547", size = 18, vjust = 5, hjust = 0),
          # legend.title.align = 0.5,
          legend.text = element_text(color = "#454547", size = 18, vjust = 1.3, hjust = 0),
          legend.background = element_blank(),
          legend.key.height = unit(1.3, 'cm'),
          legend.spacing.y = unit(0, 'cm'),
          legend.margin = margin(0, 0, 0, 0), # Réduire les marges de la légende
          legend.box.spacing = unit(0, "cm"))+ # Réduire l'espacement interne de la légende
    
    guides(fill = guide_legend(reverse = reverseLegend_,
                               override.aes = list(linewidth = 0)))+
    coord_fixed(ratio = 1)
  
  if (annotation_txt_){
    
    # Texte legend
    # p <- p + annotate("text",
    #                   x = origin_x_ + 0.97 * unit_x_,
    #                   y = generer_positions(origin_y_ + 0.502 * unit_y_, 55500, length(labels_name_annotation_)),
    #                   label = TeX(labels_name_annotation_),
    #                   size = 18*25.4/72.27,
    #                   hjust = 0)
    
    # Titre
    p <- p + annotate("text",
                      x = origin_x_ - 0.15 * unit_x_,
                      # x = origin_x_ + 0 * unit_x_,
                      y = origin_y_ + 0.97 * unit_y_,
                      label = title_,
                      fontface = "bold",
                      # bold = T,
                      size = 30*25.4/72.27,
                      color = "#2f2f32",
                      hjust = 0,
                      vjust = 0.5)
    p <- p + annotate("text",
                      # x = origin_x_ + 1 * unit_x_,
                      x = origin_x_ + 1.1 * unit_x_,
                      y = origin_y_ + 0.97 * unit_y_,
                      label = subtitle_,
                      size = 18*25.4/72.27,
                      color = "#454547",
                      hjust = "right",
                      vjust = 0.5)
  }
  
  # Echelle
  p <- p + annotation_scale(location = "bl",
                            line_width = .8,
                            text_cex = 0.7,
                            pad_x = unit(0.05, "npc"),
                            pad_y = unit(0.05, "npc"),
                            style = 'ticks',
                            bar_cols = "#454547",
                            text = element_blank())
  if (annotation_txt_){
    p <- p + annotation_north_arrow(location = "bl",
                                    style = north_arrow_fancy_orienteering(text_col = "#454547",
                                                                           line_col = "#454547",
                                                                           fill = "#454547"),
                                    which_north = "true",
                                    pad_x = unit(0.05, "npc"),
                                    pad_y = unit(0.08, "npc"),
                                    height = unit(0.9, "cm"),
                                    width = unit(0.7, "cm"))
  }else{
    p <- p + annotation_north_arrow(location = "tr",
                                    style = north_arrow_fancy_orienteering(text_col = "#454547",
                                                                           line_col = "#454547",
                                                                           fill = "#454547"),
                                    which_north = "true",
                                    # pad_x = unit(0.05, "npc"),
                                    # pad_y = unit(0.08, "npc"),
                                    height = unit(0.9, "cm"),
                                    width = unit(0.7, "cm"))
  }
  
  # Save
  if (annotation_txt_){
    pdf(paste0(output_name_,
               "_sansEt.pdf"),
        width = 18)
    print(p)
    dev.off()
    
    saveRDS(p, file = paste0(output_name_,"_sansEt.rds"))
    
    svg_device <- svglite(paste0(output_name_,"_sansEt.svg"), width = 18)#,
    print(p)
    dev.off()
    
    png(paste0(output_name_,"_sansEt.png"), width = 9*100)
    print(p)
    dev.off()
  }else{
    pdf(paste0(output_name_,
               "_sansTxt_sansEt.pdf"),
        width = 18)
    print(p)
    dev.off()
    
    saveRDS(p, file = paste0(output_name_,"_sansTxt_sansEt.rds"))
    
    svg_device <- svglite(paste0(output_name_,"_sansTxt_sansEt.svg"), width = 18)#,
    print(p)
    dev.off()
    
    png(paste0(output_name_,"_sansTxt_sansEt.png"), width = 9*100)
    print(p)
    dev.off()
  }
  
}




for (nom_categorieSimu_ in nom_categorieSimu_list_){
  
  print(nom_categorieSimu_)
  
  file_ref_ <- list.files(paste0(folder_input_,"Tab_Indicateurs/",
                                 ifelse(obsSim_=="",nom_GCM_,
                                        paste0("FDC_",obsSim_,
                                               ifelse(nom_FDCfolder_=="","",paste0("_",nom_FDCfolder_)),"/",
                                               ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),"/"))),
                          pattern = paste(c("Tab_Indicateurs_ADAMONT_19762005",".txt"),collapse = ".*"), full.names = T)
  tab_ref_ <- read.table(file_ref_, sep = ";", dec = ".", header = T)
  
  for (pattern_ in c(H2_,H3_)){
    
    print(pattern_)
    
    file_test_ <- list.files(paste0(folder_input_,"Tab_Indicateurs/",
                                    ifelse(obsSim_=="",nom_GCM_,
                                           paste0("FDC_",obsSim_,
                                                  ifelse(nom_FDCfolder_=="","",paste0("_",nom_FDCfolder_)),"/",
                                                  ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),"/"))),
                             pattern = paste(c("Tab_Indicateurs_ADAMONT_",pattern_,".txt"),collapse = ".*"), full.names = T)
    
    tab_test_ <- read.table(file_test_, sep = ";", dec = ".", header = T)
    
    # tab_ref_[,c("HER","initDate_median_")]
    # tab_test_[,c("HER","initDate_median_")]
    
    merged_data <- merge(tab_ref_, tab_test_, by = "HER", suffixes = c("ref", "test"))
    # merged_data[,c("HER","initDate_median_ref","initDate_median_test")]
    # merged_data[,c("HER","finishDate_median_ref","finishDate_median_test")]
    
    # Calculer la différence entre les dates
    merged_data$difference_init <- as.Date(merged_data$initDate_median_ref) - as.Date(merged_data$initDate_median_test)
    merged_data$difference_finish <- as.Date(merged_data$finishDate_median_test) - as.Date(merged_data$finishDate_median_ref)
    
    # merged_data[,c("HER","initDate_median_ref","initDate_median_test","difference_init")]
    # merged_data[,c("HER","finishDate_median_ref","finishDate_median_test","difference_finish")]
    
    
    # file_ <- list.files(paste0(folder_input_,"Tab_Indicateurs/",
    #                            ifelse(obsSim_=="",nom_GCM_,
    #                                   paste0("FDC_",obsSim_,
    #                                          ifelse(nom_FDCfolder_=="","",paste0("_",nom_FDCfolder_)),"/",
    #                                          ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),"/"))),
    #                     pattern = paste(c("Tab_Indicateurs_ADAMONT_",pattern_,"txt"),collapse = ".*"), full.names = T)
    
    table_globale <- merged_data
    # "Tab_Indicateurs_ADAMONT_",pattern_,"_",str_before_first(str_after_last(nom_categorieSimu_,"_"),"/"),".txt"), sep = ";", header = T)
    
    ### Jonction HER ###
    table_globale$HER[which(table_globale$HER == 37054)] = "37+54"
    table_globale$HER[which(table_globale$HER == 69096)] = "69+96"
    table_globale$HER[which(table_globale$HER == 31033039)] = "31+33+39"
    table_globale$HER[which(table_globale$HER == 89092)] = "89+92"
    table_globale$HER[which(table_globale$HER == 49090)] = "49+90"
    
    table_globale_test_ = table_globale
    table_globale_test_$difference_init[which(is.na(table_globale_test_$difference_init))] = 0
    table_globale_test_$difference_finish[which(is.na(table_globale_test_$difference_finish))] = 0
    mean(table_globale$difference_init, na.rm = T)
    mean(table_globale$difference_finish, na.rm = T)
    mean(table_globale_test_$difference_init)
    mean(table_globale_test_$difference_finish)
    
    
    if (!(dir.exists(paste0(folder_output_DD_,
                            "/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                            nomSim_,
                            ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                            "/Map/")))){
      dir.create(paste0(folder_output_DD_,
                        "/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                        nomSim_,
                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                        "/Map/"))}
    
    
    ### Date mediane debut ###
    # title_ = paste0("\nNombre moyen de jours\npar an avec une proportion\nd'assec >10% :\n projection\nmédiane")
    # title_ = paste0("Date médiane de la première proportion\nd'assec supérieure à ",seuilAssec_,"%")
    title_ = paste0("\nNumber of days in advance of the first\nday with over ",seuilAssec_,"% of sites drying: median projection")
    # subtitle_ = paste0("Modèle hydrologique : ",str_before_first(nom_categorieSimu_,"_"))
    subtitle_ = paste0("Période : April-December ",
                       substr(pattern_,1,4),
                       "-",
                       substr(pattern_,5,8),
                       "\nHydrological model ",
                       str_before_first(nom_categorieSimu_,"_"))
    output_name_ <- paste0(folder_output_DD_,
                           "/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                           nomSim_,
                           ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                           "/Map/Map_delaiMedianDebutSup",seuilAssec_,"pct_ProjMediane_",pattern_,"_1_20240711")
    breaks_nbJoursDelai <- breaks_nbJoursDelai_param
    table_globale$difference_init <- as.numeric(table_globale$difference_init)/7
    # table_globale$initDate_median_ <- as.Date(paste0("2020-",table_globale$initDate_median_))
    plot_map_variable(tab_ = table_globale,
                      varname_ = "difference_init",
                      vartitle_ = "Number of weeks",
                      breaks_ = breaks_nbJoursDelai,
                      output_name_ = output_name_,
                      title_ = title_,
                      subtitle_ = subtitle_,
                      nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                      reverseColors_ = T,
                      reverseLegend_ = T,
                      echelleAttenuee_ = F,
                      addValueUnder = -50,
                      HER2_excluesDensity_ = NULL,
                      annotation_txt_ = T,
                      percentFormat = F,
                      doubleLegend_ = T,
                      borderCol = "gray40",
                      taillePalette = length(breaks_nbJoursDelai)+5,
                      retenuPalette = length(breaks_nbJoursDelai))
    
    
    # tab_ = table_globale
    # varname_ = "difference_init"
    # vartitle_ = "Number of weeks"
    # breaks_ = breaks_nbJoursDelai
    # output_name_ = output_name_
    # title_ = title_
    # subtitle_ = subtitle_
    # nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt" # "sequence_vertRouge_personnelle_div_disc.txt"
    # reverseColors_ = T
    # reverseLegend_ = T
    # echelleAttenuee_ = F
    # addValueUnder = -50
    # HER2_excluesDensity_ = NULL
    # annotation_txt_ = T
    # percentFormat = F
    # doubleLegend_ = T
    # borderCol = "gray40"
    # taillePalette = length(breaks_nbJoursDelai)+5
    # retenuPalette = length(breaks_nbJoursDelai)
    
    
    plot_map_variable_sansEtiquettes(tab_ = table_globale,
                                     varname_ = "difference_init",
                                     vartitle_ = "Number of weeks",
                                     breaks_ = breaks_nbJoursDelai,
                                     output_name_ = output_name_,
                                     title_ = title_,
                                     subtitle_ = subtitle_,
                                     nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                     reverseColors_ = T,
                                     sansTexteHer_ = T,
                                     reverseLegend_ = T,
                                     echelleAttenuee_ = F,
                                     addValueUnder = -50,
                                     HER2_excluesDensity_ = NULL,
                                     annotation_txt_ = F,
                                     percentFormat = F,
                                     doubleLegend_ = T,
                                     borderCol = "gray40",
                                     taillePalette = length(breaks_nbJoursDelai)+5,
                                     retenuPalette = length(breaks_nbJoursDelai))
    
    # tab_ = table_globale
    # varname_ = "difference_init"
    # vartitle_ = "Number of weeks"
    # breaks_ = breaks_nbJoursDelai
    # output_name_ = output_name_
    # title_ = title_
    # subtitle_ = subtitle_
    # nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt" # "sequence_vertRouge_personnelle_div_disc.txt"
    # reverseColors_ = T
    # sansTexteHer_ = T
    # reverseLegend_ = T
    # echelleAttenuee_ = F
    # addValueUnder = -50
    # HER2_excluesDensity_ = NULL
    # annotation_txt_ = F
    # percentFormat = F
    # doubleLegend_ = T
    # borderCol = "gray40"
    # taillePalette = length(breaks_nbJoursDelai)+5
    # retenuPalette = length(breaks_nbJoursDelai)
    
    
    # title_ = paste0("\nNombre moyen de jours\npar an avec une proportion\nd'assec >10% :\n projection\nmédiane")
    title_ = paste0("\nNumber of days delayed for the last day\nwith over ",seuilAssec_,"% of sites drying: median projection")
    # subtitle_ = paste0("Modèle hydrologique : ",str_before_first(nom_categorieSimu_,"_"))
    subtitle_ = paste0("Période : April-December ",
                       substr(pattern_,1,4),
                       "-",
                       substr(pattern_,5,8),
                       "\nHydrological model ",
                       str_before_first(nom_categorieSimu_,"_"))
    output_name_ <- paste0(folder_output_DD_,
                           "/22_GrapheChroniqueProbabilite_OneModelHorizon20702100_Projections/",
                           nomSim_,
                           ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                           "/Map/Map_delaiMedianFinSup",seuilAssec_,"pct_ProjMediane_",pattern_,"_1_20240711")
    table_globale$difference_finish <- as.numeric(table_globale$difference_finish)/7
    plot_map_variable(tab_ = table_globale,
                      varname_ = "difference_finish",
                      vartitle_ = "Number of weeks",
                      breaks_ = breaks_nbJoursDelai,
                      output_name_ = output_name_,
                      title_ = title_,
                      subtitle_ = subtitle_,
                      nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                      reverseColors_ = T,
                      reverseLegend_ = T,
                      echelleAttenuee_ = F,
                      addValueUnder = -50,
                      HER2_excluesDensity_ = NULL,
                      annotation_txt_ = T,
                      percentFormat = F,
                      doubleLegend_ = T,
                      borderCol = "gray40",
                      taillePalette = length(breaks_nbJoursDelai)+5,
                      retenuPalette = length(breaks_nbJoursDelai))
    
    tab_ = table_globale
    varname_ = "difference_finish"
    vartitle_ = "Number of weeks"
    breaks_ = breaks_nbJoursDelai
    output_name_ = output_name_
    title_ = title_
    subtitle_ = subtitle_
    nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt" # "sequence_vertRouge_personnelle_div_disc.txt"
    reverseColors_ = T
    reverseLegend_ = T
    echelleAttenuee_ = F
    addValueUnder = -50
    HER2_excluesDensity_ = NULL
    annotation_txt_ = T
    percentFormat = F
    doubleLegend_ = T
    borderCol = "gray40"
    taillePalette = length(breaks_nbJoursDelai)+5
    retenuPalette = length(breaks_nbJoursDelai)

    labels_name_ = F
    sansTexteHer_ = F
    reverseFinal = F
    reverseFinal_bis = F
    
    plot_map_variable_sansEtiquettes(tab_ = table_globale,
                                     varname_ = "difference_finish",
                                     vartitle_ = "Number of weeks",
                                     breaks_ = breaks_nbJoursDelai,
                                     output_name_ = output_name_,
                                     title_ = title_,
                                     subtitle_ = subtitle_,
                                     nomPalette_ = "sequence_vertMarron_personnelle_div_disc.txt", # "sequence_vertRouge_personnelle_div_disc.txt"
                                     reverseColors_ = T,
                                     sansTexteHer_ = T,
                                     reverseLegend_ = T,
                                     echelleAttenuee_ = F,
                                     addValueUnder = -50,
                                     HER2_excluesDensity_ = NULL,
                                     annotation_txt_ = F,
                                     percentFormat = F,
                                     doubleLegend_ = T,
                                     borderCol = "gray40",
                                     taillePalette = length(breaks_nbJoursDelai)+5,
                                     retenuPalette = length(breaks_nbJoursDelai))
    
  }
}






# table_globale_test_[which(table_globale_test_$difference_init + table_globale_test_$difference_finish > (7*7)),]

#CTRIP
# [1] "5"     "12"    "13"    "14"    "17"    "52"    "64"    "65"    "67"    "68"    "70"    "71"    "77"    "78"    "86"    "93"    "94"    "103"   "105"   "106"  
# [21] "108"   "112"   "113"   "69+96"
c_CTRIP_ <- c("5","12","13","14","17","52","64","65","67","68","70","71","77","78","86","93","94","103","105","106","108","112","113","69+96")

# GRSD
# [1] "3"     "5"     "13"    "14"    "17"    "67"    "68"    "71"    "77"    "78"    "94"    "103"   "105"   "108"   "112"   "113"   "69+96"
c_GRSD_ <- c("3","5","13","14","17","67","68","71","77","78","94","103","105","108","112","113","69+96")

#J2000
# [1] "91"  "113"
c_J2000_ <- c("91","113")

# Total HER J2000
# [1] "2"     "3"     "5"     "13"    "14"    "28"    "41"    "43"    "44"    "50"    "51"    "52"    "58"    "63"    "70"    "71"    "73"    "74"    "75"    "76"   
# [21] "79"    "81"    "84"    "85"    "86"    "87"    "91"    "97"    "98"    "99"    "101"   "104"   "106"   "113"   "120"   "37+54" "49+90" "89+92"

# ORCHIDEE
# Aucun

# SMASH
# [1] "13"    "14"    "17"    "56"    "65"    "66"    "67"    "68"    "71"    "77"    "78"    "91"    "94"    "105"   "112"   "113"   "69+96"
c_SMASH_ <- c("13","14","17","56","65","66","67","68","71","77","78","91","94","105","112","113","69+96")

common_elements <- Reduce(intersect, list(c_CTRIP_, c_GRSD_, c_SMASH_))
print(common_elements)

## Commun :
# 13, 14, 17, 67, 68, 71, 77, 78, 94, 105, 112, 113, 69+96

# 3 modeles : 113
# 2 modeles : 5, 65, 103, 108, 
