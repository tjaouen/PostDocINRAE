








tab_res_ = read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/2_ResultatsModeles_ParHer/29_ObservesReanalyseSafran_CorrNcdfLH_InterBVPS_NouvelAlgoJctHydroExp2_JctHER89et92_20231221/GRSD_20231128/ChroniquesCombinees_saf_hist_rcp85/debit_France_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CNRM-ALADIN63_v3_MF-ADAMONT-SAFRAN-1980-2011_INRAE-GRSD_day_20050801-21000731/ApprentissageGlobalModelesBruts/ModelResults_ByHERDates_2012_2022_Projections_Weight_merge_12-13-14-15-16-17-18-19_Jm6Jj_logit.csv",
                      sep = ";", dec = ".", header = T)
tab_obs_2012_2022_ = read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/2_ResultatsModeles_ParHer/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/ApprentissageGlobalModelesBruts/ModelResults_ByHERDates__2012_2022_Observes_Weight_merge_12-13-14-15-16-17-18-19-20-21-22_Jm6Jj_logit.csv",
                                sep = ";", dec = ".", header = T)
tab_obs_2012_072019_ = read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/2_ResultatsModeles_ParHer/31_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_072019_20231221/DebitsComplets_From20120101_To20190731/ApprentissageGlobalModelesBruts/ModelResults_ByHERDates__2012_2019_Observes_Weight_merge_12-13-14-15-16-17-18-19_Jm6Jj_logit.csv",
                                sep = ";", dec = ".", header = T)


ind_HER_ = HER_param_[6]

tab_res_HER_ = tab_res_[which(tab_res_$HER == ind_HER_),]
tab_obs_2012_2022_HER_ = tab_obs_2012_2022_[which(tab_obs_2012_2022_$HER == ind_HER_),]
tab_obs_2012_072019_HER_ = tab_obs_2012_072019_[which(tab_obs_2012_072019_$HER == ind_HER_),]
x_ = seq(0,1,0.01)
y_res_ = exp(tab_res_HER_$Inter_logit_Learn + tab_res_HER_$Slope_logit_Learn * x_)/(1+exp(tab_res_HER_$Inter_logit_Learn + tab_res_HER_$Slope_logit_Learn * x_))
y_obs_2012_2022_ = exp(tab_obs_2012_2022_HER_$Inter_logit_Learn + tab_obs_2012_2022_HER_$Slope_logit_Learn * x_)/(1+exp(tab_obs_2012_2022_HER_$Inter_logit_Learn + tab_obs_2012_2022_HER_$Slope_logit_Learn * x_))
y_obs_2012_072019_ = exp(tab_obs_2012_072019_HER_$Inter_logit_Learn + tab_obs_2012_072019_HER_$Slope_logit_Learn * x_)/(1+exp(tab_obs_2012_072019_HER_$Inter_logit_Learn + tab_obs_2012_072019_HER_$Slope_logit_Learn * x_))


# Install ggplot2 if not already installed
# install.packages("ggplot2")

# Load ggplot2
library(ggplot2)

# Assuming x_, y_res_, y_obs_2012_2022_, and y_obs_2012_072019_ are defined

# Create a data frame with the x and y values
data_df <- data.frame(x = rep(x_, 3),
                      y = c(y_res_, y_obs_2012_2022_, y_obs_2012_072019_),
                      category = rep(c("y_res_", "y_obs_2012_2022_", "y_obs_2012_072019_"), each = length(x_)))

# Plot the data using ggplot
ggplot(data_df, aes(x = x, y = y, color = category)) +
  geom_line() +
  labs(title = paste0("HER ",HER_param_[6]),
       x = "FDC",
       y = "Drying probability") +
  theme_minimal()
