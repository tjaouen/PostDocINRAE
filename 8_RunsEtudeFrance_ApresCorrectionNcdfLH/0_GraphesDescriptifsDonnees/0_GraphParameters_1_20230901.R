

### Metadonnees stations ###
breaks_SurfaceTopo_param = c(0,10,25,50,100,500,1000,8000)
breaks_altitude_param = c(-0.1,25,50,100,200,300,500,1000,8000)
breaks_pente_param = c(-0.1, 1, 5, 15, 30, 60, 100, 150, 100000)


### Input data ###
breaks_SurfaceEntitesHydroPropSurfHER2_param = c(0,0.1,0.2,0.3,0.4,0.5,1,2,3)
breaks_SurfaceEntitesHydroPropSurfHER2_log_param = c(-11.5,-2.3,-1.6,-1.2,-0.9,-0.7,0,0.7,1.1)
# breaks_NbEntitesHydroProp1000SurfHER2_param = c(0,1,2,3,4,6,10,14)
# breaks_NbEntitesHydroProp1000SurfHER2_param = c(0,0.25,0.5,0.75,1,2,3,4,5,10,15)
# breaks_NbEntitesHydroProp1000SurfHER2_param = c(0,0.25,0.5,0.75,1,3,5,10,15)
breaks_NbEntitesHydroProp1000SurfHER2_param = c(0,2,6,10,15,20)
breaks_SurfHER2ParEntiteHydro_param = c(0,50,100,200,250,500,1000,2000)

# breaks_col_NbStationPerKm2_param = c(0,1,2,3,4,6,10,14)
# breaks_col_SurfaceHydroPropSurfHER2_param <- c(0,0.1,0.2,0.3,0.4,0.5,1,2,3)


# color_sitesOnde_param = rgb(196,121,0, maxColorValue = 255)
color_sitesOnde_param = rgb(0,52,102, maxColorValue = 255)
color_stationsHydrometriques_param = rgb(84,146,205, maxColorValue = 255)
color_pointsSimu_param = rgb(0,52,102, maxColorValue = 255)


### Resultats modeles ###
breaks_Intercept_param = c(-2,-1,0,1,2)

# breaks_ProbaAssecMoyenne_param = c(0,0.05,0.10,0.15,0.20,0.25,0.30,0.40,0.50,0.75,1)
# breaks_ProbaAssecMoyenne_param = c(0,5,10,15,20,25,30,40,50,75,100)
breaks_ProbaAssecMoyenne_param = c(0,10,20,30,40,50,60,70)
breaks_nbJoursAssecsAn_param = c(0,50,100,150,200,250,300)
breaks_dateMediane_start_param = c("2022-04-01","2022-05-01","2022-06-01","2022-07-01","2022-08-01","2022-09-01","2022-10-01")
# breaks_dateMediane_end_param = c("2022-06-01","2022-07-01","2022-08-01","2022-09-01","2022-10-01","2022-11-01","2022-12-01")
breaks_dateMediane_end_param = c("2022-07-01","2022-08-01","2022-09-01","2022-10-01","2022-11-01","2022-12-01","2022-12-31")
breaks_nbJoursDelai_param = c(-14,-7,0,7,14,21,28,35,70)

breaks_ProbaAssecFDCnulle_param = c(0,20,40,60,80,100)
breaks_Slope_param = c(-100,-20,-15,-12,-10,-8,-6,-4,-2,0)
breaks_propDev_param = c(0,50,60,70,80,85,90,95,100)
breaks_KGE_param = c(0,0.5,0.6,0.7,0.8,0.85,0.9,0.95,1)
# breaks_Biais_param = c(-0.5,-0.01,-0.001,-0.0005,0.0005,0.001,0.01,0.5)
breaks_Biais_param = c(-0.5,-0.1,-0.01,-0.001,-0.0005,0.0005,0.001,0.01,0.1,0.5)
breaks_ErrMoyAbs_param = c(0,0.02,0.04,0.06,0.08,0.1,0.12,0.15,0.5)
breaks_RMSE_param = c(0,0.02,0.04,0.06,0.08,0.1,0.12,0.16,0.2,0.6)
# breaks_Biais3max_param = c(-1,-0.3,-0.2,-0.1,0.1,0.2,0.3,1)
# breaks_Biais3max_param = c(-0.5,-0.01,-0.001,-0.0005,0.0005,0.001,0.01,0.5)
breaks_Biais3max_param = c(-0.5,-0.1,-0.01,-0.001,-0.0005,0.0005,0.001,0.01,0.1,0.5)
# breaks_ErrMoyAbs_param = c(0,0.05,0.1,0.15,0.2,0.25,0.3,0.5)

breaks_pvalue_param = c(0,0.05,1)

breaks_NSE_param = c(0,0.5,0.6,0.7,0.8,0.85,0.9,0.95,1)




### Resultats modeles 2023.10.19 ###
breaks_Intercept_param = c(-20,-10,0,10,20)
breaks_ProbaAssecFDCnulle_param = c(0,20,40,60,80,100)
breaks_Slope_param = c(-100,-20,-15,-12,-10,-8,-6,-4,-2,0)
breaks_propDev_param = c(0,50,60,70,80,85,90,95,100)
breaks_KGE_param = c(0,0.5,0.6,0.7,0.8,0.85,0.9,0.95,1)
# breaks_Biais_param = c(-0.5,-0.01,-0.001,-0.0005,0.0005,0.001,0.01,0.5)
# breaks_Biais_param = c(-0.5,-0.1,-0.01,-0.001,-0.0005,0.0005,0.001,0.01,0.1,0.5)
# breaks_Biais_param = c(-0.5,-0.1,-0.01,-0.001,-0.0005,0.0005,0.001,0.01,0.1,0.5)
breaks_Biais_param = c(-0.5,-0.1,-0.01,-1e-04,-1e-05,1e-05,1e-04,0.01,0.1,0.5)
breaks_ErrMoyAbs_param = c(0,0.02,0.04,0.06,0.08,0.1,0.12,0.15,0.5)
breaks_RMSE_param = c(0,0.02,0.04,0.06,0.08,0.1,0.12,0.16,0.2,0.6)
# breaks_Biais3max_param = c(-1,-0.3,-0.2,-0.1,0.1,0.2,0.3,1)
# breaks_Biais3max_param = c(-0.5,-0.01,-0.001,-0.0005,0.0005,0.001,0.01,0.5)
breaks_Biais3max_param = c(-0.5,-0.1,-0.01,-0.001,-0.0005,0.0005,0.001,0.01,0.1,0.5)
# breaks_ErrMoyAbs_param = c(0,0.05,0.1,0.15,0.2,0.25,0.3,0.5)

breaks_NSE_param = c(0,0.5,0.6,0.7,0.8,0.85,0.9,0.95,1)





# col_mod_Obs__Data_Obs_param_ = "#2ca25f"
# col_mod_SafSeul__Data_Saf_param_ = "#2b8cbe"
# col_mod_CERFACS_ALADIN63_saf_hist_rcp85__Data_Safran_20122019_param_ = "#f1eef6"
# col_mod_ECearth_HadREM3_saf_hist_rcp85__Data_Safran_20122019_param_ = "#c994c7"
# col_mod_HadGEM2_CCLM4_saf_hist_rcp85__Data_Safran_20122019_param_ = "#e7298a"
# col_mod_HadGEM2_ALADIN63_saf_hist_rcp85__Data_Safran_20122019_param_ = "#ce1256"
# col_mod_CERFACS_ALADIN63_saf_rcp85__Data_Safran_20122019_param_ = "#fee5d9"
# col_mod_ECearth_HadREM3_saf_rcp85__Data_Safran_20122019_param_ = "#fc9272"
# col_mod_HadGEM2_CCLM4_saf_rcp85__Data_Safran_20122019_param_ = "#fb6a4a"
# col_mod_HadGEM2_ALADIN63_saf_rcp85__Data_Safran_20122019_param_ = "#cb181d"

col_mod_Obs__Data_Obs_param_ = "#969696"
col_mod_SafSeul__Data_Saf_param_ = "#000000"
col_mod_CERFACS_ALADIN63_saf_hist_rcp85__Data_Safran_20122019_param_ = "#feb24c"
col_mod_ECearth_HadREM3_saf_hist_rcp85__Data_Safran_20122019_param_ = "#fc4e2a"
col_mod_HadGEM2_CCLM4_saf_hist_rcp85__Data_Safran_20122019_param_ = "#bd0026"
col_mod_HadGEM2_ALADIN63_saf_hist_rcp85__Data_Safran_20122019_param_ = "#dd3497"
col_mod_CERFACS_ALADIN63_saf_rcp85__Data_Safran_20122019_param_ = "#7fcdbb"
col_mod_ECearth_HadREM3_saf_rcp85__Data_Safran_20122019_param_ = "#1d91c0"
col_mod_HadGEM2_CCLM4_saf_rcp85__Data_Safran_20122019_param_ = "#225ea8"
col_mod_HadGEM2_ALADIN63_saf_rcp85__Data_Safran_20122019_param_ = "#081d58"

# 
# color_scale <- c("#feb24c", "#fc4e2a",
#                           "#bd0026", "#800026", 
#                           
#                           "#7fcdbb",
#                           "#1d91c0", 
#                           "#225ea8", 
#                           "#081d58",
#                           
#                           "#41ab5d", "#004529")
# 
# values = c("all" = "#feb24c", "none" = "#fc4e2a", 
#            "regle1" = "#bd0026", "regle2" = "#800026", 
#            "regle3" = "#7fcdbb", "regle4" = "#1d91c0", 
#            "regle5" = "#225ea8", "regle6" = "#081d58", 
#            "regle7" = "#41ab5d", "regle8" = "#004529"),



