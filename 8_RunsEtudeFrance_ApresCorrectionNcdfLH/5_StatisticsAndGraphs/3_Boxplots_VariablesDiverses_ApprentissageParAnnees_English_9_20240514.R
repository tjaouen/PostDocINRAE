source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/6_RunsEtudeFrance_CorrectionImportOnde_20230607/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/7_RunsEtudeFrance_DifferentsModelesHydro/1_Parameters/0_SimulationParameters_AvecCC_2_20230227.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_RunObs20122019.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/ToolBox/Graphes_HER2hybrides_VariableBreaks_1_20230608.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_2_20230621.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_3_20230621.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_4_20230801.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_9_SaveRds_20230829.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_10_SaveRds_20230829.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_11_SaveRds_20230831.R")
# source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_12_SaveRds_CorrRgptHER_20230921.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/Annexe/MapVariable_HER2hybrides/Graphes_HER2hybrides_VariableBreaks_IPCCcolors_31_NewColors_Svg_20240319.R")

folder_output_ = folder_output_param_
nomSim_ = nomSim_param_
jourMin_ = jourMin_param_
jourMax_ = jourMax_param_
nom_categorieSimu_ = nom_categorieSimu_param_
nom_apprentissage_ = nom_apprentissage_param_
nom_validation_ = nom_validation_param_
nom_GCM_ = nom_GCM_param_

### Librairies ###
library(ggplot2)
library(tidyr)


### Filename ###
nom_apprentissage_ = "ApprentissageParDeuxCategoriesParmiSechesInterHumides"
nom_validation_ = "Validation_3AnneesSechesInterHumides"
filenames_ <- list.files(paste0(folder_output_,
                                "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                                nomSim_,
                                ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                                ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                                "/TableGlobale/"), pattern = "ValidGlobale_", full.names = T)
if (nom_GCM_ != ""){
  filenames_ = filenames_[grepl(nom_GCM_,filenames_)]
}

# filename_ <- list.files(paste0(folder_output_,"15_ResultatsModeles_ValidationParAnnees_ParHer/",nomSim_,"/LeaveOneYearOut/Validation_Globale/"), pattern = paste0("Jm",jourMin_,"Jj.*csv"), full.names = T)

# filenames_global_ <- list.files(paste0(folder_output_,"15_ResultatsModeles_ValidationParAnnees_ParHer/17_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrOubliHerJointes20212022etFonctionSeuilOnde_SensiIntervJours_2012_2022_20230614/LeaveOneYearOut/Validation_Globale/"), pattern = paste0("Jm",jourMin_,"Jj.*csv"), full.names = T)
filenames_global_ <- list.files(paste0(folder_output_,
                                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                                       nomSim_,
                                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                                       "/ApprentissageLeaveOneYearOut/Validation_2LeaveOneYearOut/TableGlobale/"), pattern = "ValidGlobale_", full.names = T)
if (nom_GCM_ != ""){
  filenames_global_ = filenames_global_[grepl(nom_GCM_,filenames_global_)]
}


# filenames_global_ <- list.files(paste0(folder_output_,
#                                        "15_ResultatsModeles_ValidationParAnnees_ParHer/",
#                                        "17_PresentMesures_HERh_FltOnde_JctHER_SansIFetExES_CorrOubliHerJointes20212022etFonctionSeuilOnde_SensiIntervJours_2012_2022_20230614/",
#                                        ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
#                                        ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
#                                        ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
#                                        "/Validation_Globale/"), pattern = paste0("Jm",jourMin_,"Jj.*csv"), full.names = T)

tab_merge_ = data.frame()
for (filename_ in filenames_){
  
  tab_results_ = read.table(filename_, sep = ";", dec = ".", header = T)
  if (ncol(tab_results_) == 1){
    tab_results_ = read.table(filename_, sep = ",", dec = ".", header = T)
  }
  colnames(tab_results_) <- paste0(colnames(tab_results_),"_",str_before_first(str_after_first(filename_,"ValidGlobale_"),"_Jm6Jj"))
  
  if (dim(tab_merge_)[1] == 0){
    tab_merge_ = tab_results_
  }else{
    tab_merge_ = cbind(tab_merge_, tab_results_)
  }
  
}


tab_results_ = read.table(filenames_global_, sep = ";", dec = ".", header = T)
if (ncol(tab_results_) == 1){
  tab_results_ = read.table(filenames_global_, sep = ",", dec = ".", header = T)
}
colnames(tab_results_) <- paste0(colnames(tab_results_),"_General")
if (dim(tab_merge_)[1] == 0){
  tab_merge_ = tab_results_
}else{
  tab_merge_ = cbind(tab_merge_, tab_results_)
}


### Intercept boot ###
data_ = tab_merge_[,grepl("Intercept_boot_1|Intercept_boot_2|Intercept_boot_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")

table_as_rows <- pivot_longer(data_, 
                              cols = everything(),  # Ou spécifiez les colonnes que vous souhaitez rassembler
                              names_to = "Années", 
                              values_to = "Valeur")

table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/1_Boxplot_Globale_Intercept_Boot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/1_Boxplot_Globale_Intercept_Boot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/1_Boxplot_Globale_Intercept_Boot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
# boxplot(Valeur ~ Années, data = table_as_rows,
#         main = "Intercept de la régression logistique",
#         xlab = "Années",
#         ylab = "Intercept")
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Intercept of the logistic regression",
       x = "",
       y = "Intercept (unitless)") +
  theme_bw()+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))


### Intercept non boot ###
data_ = tab_merge_[,grepl("Intercept_general_1|Intercept_general_2|Intercept_general_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/1_Boxplot_Globale_Intercept_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/1_Boxplot_Globale_Intercept_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/1_Boxplot_Globale_Intercept_NonBoot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
# boxplot(Valeur ~ Années, data = table_as_rows,
#         main = "Intercept de la régression logistique",
#         xlab = "Années",
#         ylab = "Intercept")
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Intercept of the logistic regression",
       x = "",
       y = "Intercept (unitless)") +
  theme_bw()+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))


### Proba Assecs FDC nulle ###
tab_merge_$ProbaAssecFDCnulle_boot_17_19_22 = exp(tab_merge_$`Intercept_boot_17-19-22`)/(1+exp(tab_merge_$`Intercept_boot_17-19-22`))*100
tab_merge_$ProbaAssecFDCnulle_boot_12_15_20_21 = exp(tab_merge_$`Intercept_boot_12-15-20-21`)/(1+exp(tab_merge_$`Intercept_boot_12-15-20-21`))*100
tab_merge_$ProbaAssecFDCnulle_boot_13_14_16_18 = exp(tab_merge_$`Intercept_boot_13-14-16-18`)/(1+exp(tab_merge_$`Intercept_boot_13-14-16-18`))*100
tab_merge_$ProbaAssecFDCnulle_boot_General = exp(tab_merge_$Intercept_boot_General)/(1+exp(tab_merge_$Intercept_boot_General))*100

data_ = tab_merge_[,grepl("ProbaAssecFDCnulle_boot_1|ProbaAssecFDCnulle_boot_2|ProbaAssecFDCnulle_boot_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13_14_16_18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12_15_20_21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17_19_22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/1_Boxplot_Globale_ProbaAssecFDCnulle_Boot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/1_Boxplot_Globale_ProbaAssecFDCnulle_Boot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/1_Boxplot_Globale_ProbaAssecFDCnulle_Boot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
# boxplot(Valeur ~ Années, data = table_as_rows,
#         main = "Intercept de la régression logistique",
#         xlab = "Années",
#         ylab = "Intercept")
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Probability of drying at a zero frequency of discharge (%)",
       x = "",
       y = "Probability (%)") +
  theme_bw()+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))

### Proba Assecs FDC nulle ###
tab_merge_$ProbaAssecFDCnulle_general_17_19_22 = exp(tab_merge_$`Intercept_general_17-19-22`)/(1+exp(tab_merge_$`Intercept_general_17-19-22`))*100
tab_merge_$ProbaAssecFDCnulle_general_12_15_20_21 = exp(tab_merge_$`Intercept_general_12-15-20-21`)/(1+exp(tab_merge_$`Intercept_general_12-15-20-21`))*100
tab_merge_$ProbaAssecFDCnulle_general_13_14_16_18 = exp(tab_merge_$`Intercept_general_13-14-16-18`)/(1+exp(tab_merge_$`Intercept_general_13-14-16-18`))*100
tab_merge_$ProbaAssecFDCnulle_general_General = exp(tab_merge_$Intercept_general_General)/(1+exp(tab_merge_$Intercept_general_General))*100

data_ = tab_merge_[,grepl("ProbaAssecFDCnulle_general_1|ProbaAssecFDCnulle_general_2|ProbaAssecFDCnulle_general_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13_14_16_18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12_15_20_21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17_19_22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/1_Boxplot_Globale_ProbaAssecFDCnulle_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/1_Boxplot_Globale_ProbaAssecFDCnulle_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/1_Boxplot_Globale_ProbaAssecFDCnulle_NonBoot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
# boxplot(Valeur ~ Années, data = table_as_rows,
#         main = "Intercept de la régression logistique",
#         xlab = "Années",
#         ylab = "Intercept")
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Probability of drying at a zero frequency of discharge (%)",
       x = "",
       y = "Probability (%)") +
  theme_bw()+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))


### Slope boot ###
data_ = tab_merge_[,grepl("Slope_boot_1|Slope_boot_2|Slope_boot_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/2_Boxplot_Globale_Slope_Boot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/2_Boxplot_Globale_Slope_Boot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/2_Boxplot_Globale_Slope_Boot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
# boxplot(Valeur ~ Années, data = table_as_rows,
#         main = "Pente de la régression logistique",
#         xlab = "Années",
#         ylab = "Pente")
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Logistic regression slope",
       x = "",
       y = bquote("Slope (%"^{-1}~")"))+   # Utilisation de expression pour mettre le -1 en exposant
  theme_bw()+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))

### Slope non boot ###
data_ = tab_merge_[,grepl("Slope_general_1|Slope_general_2|Slope_general_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/2_Boxplot_Globale_Slope_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/2_Boxplot_Globale_Slope_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/2_Boxplot_Globale_Slope_NonBoot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Logistic regression slope",
       x = "",
       y = bquote("Slope (%"^{-1}~")"))+   # Utilisation de expression pour mettre le -1 en exposant
  theme_bw()+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
# boxplot(Valeur ~ Années, data = table_as_rows,
#         main = "Pente de la régression logistique",
#         xlab = "Années",
#         ylab = "Pente")
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))


### Proportion deviance ###
data_ = tab_merge_[,grepl("PropParameterDeviance_logit_Learn_boot_1|PropParameterDeviance_logit_Learn_boot_2|PropParameterDeviance_logit_Learn_boot_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/3_Boxplot_Globale_PropDev_Boot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/3_Boxplot_Globale_PropDev_Boot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/3_Boxplot_Globale_PropDev_Boot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
# boxplot(Valeur ~ Années, data = table_as_rows,
#         main = "Pente de la régression logistique",
#         xlab = "Années",
#         ylab = "Pente")
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Proportion of total\ndeviance explained by\nthe frequency of discharge",
       x = "",
       y = "Proportion of deviance (%)") +
  theme_bw()+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))

### Proportion deviance ###
data_ = tab_merge_[,grepl("PropParameterDeviance_logit_Learn_general_1|PropParameterDeviance_logit_Learn_general_2|PropParameterDeviance_logit_Learn_general_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/3_Boxplot_Globale_PropDev_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/3_Boxplot_Globale_PropDev_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/3_Boxplot_Globale_PropDev_NonBoot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Proportion of total\ndeviance explained by\nthe frequency of discharge",
       x = "",
       y = "Proportion of deviance (%)") +
  theme_bw()+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
# boxplot(Valeur ~ Années, data = table_as_rows,
#         main = "Pente de la régression logistique",
#         xlab = "Années",
#         ylab = "Pente")
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))


### KGE boot ###
data_ = tab_merge_[,grepl("KGE_HER_AnneeValid_logit_CValid_boot_1|KGE_HER_AnneeValid_logit_CValid_boot_2|KGE_HER_AnneeValid_logit_CValid_boot_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/4_Boxplot_Globale_KGE_Boot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/4_Boxplot_Globale_KGE_Boot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/4_Boxplot_Globale_KGE_Boot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
# boxplot(Valeur ~ Années, data = table_as_rows,
#         main = "Kling-Gupta Efficiency (KGE)",
#         xlab = "Années",
#         ylab = "KGE")
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Kling-Gupta Efficiency (KGE)",
       x = "",
       y = "KGE (unitless)") +
  theme_bw()+
  ylim(-5,1)+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))

### KGE non boot ###
data_ = tab_merge_[,grepl("KGE_HER_AnneeValid_logit_CValid_general_1|KGE_HER_AnneeValid_logit_CValid_general_2|KGE_HER_AnneeValid_logit_CValid_general_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/4_Boxplot_Globale_KGE_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/4_Boxplot_Globale_KGE_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/4_Boxplot_Globale_KGE_NonBoot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
# boxplot(Valeur ~ Années, data = table_as_rows,
#         main = "Kling-Gupta Efficiency (KGE)",
#         xlab = "Années",
#         ylab = "KGE")
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Kling-Gupta Efficiency (KGE)",
       x = "",
       y = "KGE (unitless)") +
  theme_bw()+
  ylim(-5,1)+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))



### Biais boot ###
data_ = tab_merge_[,grepl("Biais_boot_1|Biais_boot_2|Biais_boot_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/5_Boxplot_Globale_Biais_General_Boot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/5_Boxplot_Globale_Biais_General_Boot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/5_Boxplot_Globale_Biais_General_Boot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
# boxplot(Valeur ~ Années, data = table_as_rows,
#         main = "Biais",
#         xlab = "Années",
#         ylab = "Biais")
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Prediction bias",
       x = "",
       y = "Bias (unitless)") +
  theme_bw()+
  ylim(-0.15,0.15)+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))

### Biais non boot ###
data_ = tab_merge_[,grepl("Biais_general_1|Biais_general_2|Biais_general_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/5_Boxplot_Globale_Biais_General_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/5_Boxplot_Globale_Biais_General_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/5_Boxplot_Globale_Biais_General_NonBoot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Prediction bias",
       x = "",
       y = "Bias (unitless)") +
  theme_bw()+
  ylim(-0.15,0.15)+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
# boxplot(Valeur ~ Années, data = table_as_rows,
#         main = "Biais",
#         xlab = "Années",
#         ylab = "Biais")
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))



### EMA boot ###
data_ = tab_merge_[,grepl("ErreurMoyenneAbsolue_boot_1|ErreurMoyenneAbsolue_boot_2|ErreurMoyenneAbsolue_boot_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/6_Boxplot_Globale_ErrMoyAbs_General_Boot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/6_Boxplot_Globale_ErrMoyAbs_General_Boot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/6_Boxplot_Globale_ErrMoyAbs_General_Boot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Mean Absolute Error",
       x = "",
       y = "Mean Absolute Error (unitless)") +
  theme_bw()+
  ylim(0,0.2)+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
# boxplot(Valeur ~ Années, data = table_as_rows,
#         main = "Erreur Moyenne Absolue",
#         xlab = "Années",
#         ylab = "Erreur Moyenne Absolue")
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))

### EMA non boot ###
data_ = tab_merge_[,grepl("ErreurMoyenneAbsolue_general_1|ErreurMoyenneAbsolue_general_2|ErreurMoyenneAbsolue_general_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/6_Boxplot_Globale_ErrMoyAbs_General_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/6_Boxplot_Globale_ErrMoyAbs_General_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/6_Boxplot_Globale_ErrMoyAbs_General_NonBoot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Mean Absolute Error",
       x = "",
       y = "Mean Absolute Error (unitless)") +
  theme_bw()+
  ylim(0,0.2)+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
# boxplot(Valeur ~ Années, data = table_as_rows,
#         main = "Erreur Moyenne Absolue",
#         xlab = "Années",
#         ylab = "Erreur Moyenne Absolue")
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))


### RMSE boot ###
data_ = tab_merge_[,grepl("RMSE_boot_1|RMSE_boot_2|RMSE_boot_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/7_Boxplot_Globale_RMSE_General_Boot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/7_Boxplot_Globale_RMSE_General_Boot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/7_Boxplot_Globale_RMSE_General_Boot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Root Mean Squared Error (RMSE)",
       x = "",
       y = "RMSE (unitless)") +
  theme_bw()+
  ylim(0,0.4)+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
# boxplot(Valeur ~ Années, data = table_as_rows,
#         main = "Ecart Quadratique Moyen (RMSE)",
#         xlab = "Années",
#         ylab = "RMSE")
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))

### RMSE non boot ###
data_ = tab_merge_[,grepl("RMSE_general_1|RMSE_general_2|RMSE_general_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/7_Boxplot_Globale_RMSE_General_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/7_Boxplot_Globale_RMSE_General_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/7_Boxplot_Globale_RMSE_General_NonBoot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Root Mean Squared Error (RMSE)",
       x = "",
       y = "RMSE (unitless)") +
  theme_bw()+
  ylim(0,0.4)+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
# boxplot(Valeur ~ Années, data = table_as_rows,
#         main = "Ecart Quadratique Moyen (RMSE)",
#         xlab = "Années",
#         ylab = "RMSE")
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))



### Biais boot 3 MAX ###
data_ = tab_merge_[,grepl("Biais_3maxApred_boot_1|Biais_3maxApred_boot_2|Biais_3maxApred_boot_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/5_Boxplot_Globale_Biais_Max3_Boot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/5_Boxplot_Globale_Biais_Max3_Boot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/5_Boxplot_Globale_Biais_Max3_Boot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Prediction bias for the 3 highest observed drying values",
       x = "",
       y = "Bias (unitless)") +
  theme_bw()+
  ylim(-0.5,0.15)+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
# boxplot(Valeur ~ Années, data = table_as_rows,
#         main = "Biais",
#         xlab = "Années",
#         ylab = "Biais")
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))

### Biais non boot 3 MAX ###
data_ = tab_merge_[,grepl("Biais_3maxApred_general_1|Biais_3maxApred_general_2|Biais_3maxApred_general_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/5_Boxplot_Globale_Biais_Max3_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/5_Boxplot_Globale_Biais_Max3_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/5_Boxplot_Globale_Biais_Max3_NonBoot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Prediction bias for the 3 highest observed drying values",
       x = "",
       y = "Bias (unitless)") +
  theme_bw()+
  ylim(-0.5,0.15)+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
# boxplot(Valeur ~ Années, data = table_as_rows,
#         main = "Biais",
#         xlab = "Années",
#         ylab = "Biais")
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))



### EMA boot 3 MAX ###
data_ = tab_merge_[,grepl("ErreurMoyenneAbsolue_3maxApred_boot_1|ErreurMoyenneAbsolue_3maxApred_boot_2|ErreurMoyenneAbsolue_3maxApred_boot_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/6_Boxplot_Globale_ErrMoyAbs_Max3_Boot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/6_Boxplot_Globale_ErrMoyAbs_Max3_Boot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/6_Boxplot_Globale_ErrMoyAbs_Max3_Boot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Mean Absolute Error for the 3 months with the highest drying probabilities",
       x = "",
       y = "Mean Absolute Error (unitless)") +
  theme_bw()+
  ylim(0,0.5)+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
# boxplot(Valeur ~ Années, data = table_as_rows,
#         main = "Erreur Moyenne Absolue",
#         xlab = "Années",
#         ylab = "Erreur Moyenne Absolue")
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))

### EMA non boot 3 MAX ###
data_ = tab_merge_[,grepl("ErreurMoyenneAbsolue_3maxApred_general_1|ErreurMoyenneAbsolue_3maxApred_general_2|ErreurMoyenneAbsolue_3maxApred_general_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/6_Boxplot_Globale_ErrMoyAbs_Max3_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/6_Boxplot_Globale_ErrMoyAbs_Max3_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/6_Boxplot_Globale_ErrMoyAbs_Max3_NonBoot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Mean Absolute Error for the 3 months with the highest drying probabilities",
       x = "",
       y = "Mean Absolute Error (unitless)") +
  theme_bw()+
  ylim(0,0.5)+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
# boxplot(Valeur ~ Années, data = table_as_rows,
#         main = "Erreur Moyenne Absolue",
#         xlab = "Années",
#         ylab = "Erreur Moyenne Absolue")
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))


### RMSE boot 3 MAX ###
data_ = tab_merge_[,grepl("RMSE_3maxApred_boot_1|RMSE_3maxApred_boot_2|RMSE_3maxApred_boot_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/7_Boxplot_Globale_RMSE_Max3_Boot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/7_Boxplot_Globale_RMSE_Max3_Boot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/7_Boxplot_Globale_RMSE_Max3_Boot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Root Mean Squared Error (RMSE) for the 3 months with the highest drying probabilities",
       x = "",
       y = "RMSE (unitless)") +
  theme_bw()+
  ylim(0,0.6)+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
# boxplot(Valeur ~ Années, data = table_as_rows,
#         main = "Ecart Quadratique Moyen (RMSE)",
#         xlab = "Années",         ylab = "RMSE")
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))

### RMSE non boot 3 MAX ###
data_ = tab_merge_[,grepl("RMSE_3maxApred_general_1|RMSE_3maxApred_general_2|RMSE_3maxApred_general_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/7_Boxplot_Globale_RMSE_Max3_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/7_Boxplot_Globale_RMSE_Max3_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/7_Boxplot_Globale_RMSE_Max3_NonBoot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Ecart Quadratique Moyen (RMSE) sur\nles 3 valeurs d'assecs observées\nmaximales",
       x = "",
       y = "RMSE (sans unité)") +
  theme_bw()+
  ylim(0,0.6)+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))

# boxplot(Valeur ~ Années, data = table_as_rows,
#         main = "Ecart Quadratique Moyen (RMSE)",
#         xlab = "",
#         ylab = "RMSE",
#         cex.axis = 1.4,  # Taille de police pour les étiquettes des axes
#         cex.lab = 1.4,   # Taille de police pour les étiquettes des axes x et y
#         cex.main = 2,  # Taille de police pour le titre principal
#         cex.sub = 1.4)

# ggplot(data = table_as_rows, aes(x = Années, y = Valeur)) +
#   geom_boxplot() +
#   labs(title = "Ecart Quadratique Moyen (RMSE)",
#        x = "Années",
#        y = "RMSE") +
#   theme(text = element_text(size = 26))



# 
# tab_results_$
#   "Intercept_boot"
# "Intercept_general"
# "ProbaAssecFDCnulle_boot"
# "ProbaAssecFDCnulle_general"
# "Slope_boot"
# "Slope_general"
# "PropParameterDeviance_logit_Learn_boot"
# "PropParameterDeviance_logit_Learn_general"
# "KGE_HER_AnneeValid_logit_CValid_boot"
# "KGE_HER_AnneeValid_logit_CValid_general"
# "Biais_boot"
# "Biais_general"
# "ErreurMoyenneAbsolue_boot"
# "ErreurMoyenneAbsolue_general"
# "RMSE_boot"
# "RMSE_general"
# "Biais_3maxApred_boot"
# "Biais_3maxApred_general"
# "ErreurMoyenneAbsolue_3maxApred_boot"
# "ErreurMoyenneAbsolue_3maxApred_general"
# "RMSE_3maxApred_boot"
# "RMSE_3maxApred_general"
# 












### RMSE mai ###
data_ = tab_merge_[,grepl("RMSE_mai_general_1|RMSE_mai_general_2|RMSE_mai_general_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/7_Boxplot_Globale_RMSE_Mois05_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/7_Boxplot_Globale_RMSE_Mois05_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/7_Boxplot_Globale_RMSE_Mois05_NonBoot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Root Mean Squared Error (RMSE)\nfor the month of May",
       x = "",
       y = "RMSE (unitless)") +
  theme_bw()+
  ylim(0,0.4)+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))

### RMSE juin ###
data_ = tab_merge_[,grepl("RMSE_juin_general_1|RMSE_juin_general_2|RMSE_juin_general_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/7_Boxplot_Globale_RMSE_Mois06_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/7_Boxplot_Globale_RMSE_Mois06_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/7_Boxplot_Globale_RMSE_Mois06_NonBoot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Root Mean Squared Error (RMSE)\nfor the month of June",
       x = "",
       y = "RMSE (unitless)") +
  theme_bw()+
  ylim(0,0.4)+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))

### RMSE juillet ###
data_ = tab_merge_[,grepl("RMSE_juillet_general_1|RMSE_juillet_general_2|RMSE_juillet_general_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/7_Boxplot_Globale_RMSE_Mois07_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/7_Boxplot_Globale_RMSE_Mois07_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/7_Boxplot_Globale_RMSE_Mois07_NonBoot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Root Mean Squared Error (RMSE)\nfor the month of July",
       x = "",
       y = "RMSE (unitless)") +
  theme_bw()+
  ylim(0,0.4)+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))

### RMSE aout ###
data_ = tab_merge_[,grepl("RMSE_aout_general_1|RMSE_aout_general_2|RMSE_aout_general_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/7_Boxplot_Globale_RMSE_Mois08_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/7_Boxplot_Globale_RMSE_Mois08_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/7_Boxplot_Globale_RMSE_Mois08_NonBoot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Root Mean Squared Error (RMSE)\nfor the month of August",
       x = "",
       y = "RMSE (unitless)") +
  ylim(0,0.4)+
  theme_bw()+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))

### RMSE septembre ###
data_ = tab_merge_[,grepl("RMSE_septembre_general_1|RMSE_septembre_general_2|RMSE_septembre_general_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/7_Boxplot_Globale_RMSE_Mois09_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/7_Boxplot_Globale_RMSE_Mois09_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/7_Boxplot_Globale_RMSE_Mois09_NonBoot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Root Mean Squared Error (RMSE)\nfor the month of September",
       x = "",
       y = "RMSE (unitless)") +
  ylim(0,0.4)+
  theme_bw()+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))


### Biais non boot Mai ###
data_ = tab_merge_[,grepl("Biais_mai_general_1|Biais_mai_general_2|Biais_mai_general_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/5_Boxplot_Globale_Biais_Mois05_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/5_Boxplot_Globale_Biais_Mois05_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/5_Boxplot_Globale_Biais_Mois05_NonBoot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  ylim(-0.4,0.2) +
  labs(title = "Prediction bias\nfor the month of May",
       x = "",
       y = "Bias (unitless)") +
  theme_bw()+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))

### Biais non boot Juin ###
data_ = tab_merge_[,grepl("Biais_juin_general_1|Biais_juin_general_2|Biais_juin_general_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/5_Boxplot_Globale_Biais_Mois06_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/5_Boxplot_Globale_Biais_Mois06_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/5_Boxplot_Globale_Biais_Mois06_NonBoot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Prediction bias\nfor the month of June",
       x = "",
       y = "Bias (unitless)") +
  theme_bw()+
  ylim(-0.4,0.2) +
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))

### Biais non boot Juillet ###
data_ = tab_merge_[,grepl("Biais_juillet_general_1|Biais_juillet_general_2|Biais_juillet_general_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/5_Boxplot_Globale_Biais_Mois07_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/5_Boxplot_Globale_Biais_Mois07_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/5_Boxplot_Globale_Biais_Mois07_NonBoot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Prediction bias\nfor the month of July",
       x = "",
       y = "Bias (unitless)") +
  theme_bw()+
  ylim(-0.4,0.2) +
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))

### Biais non boot Aout ###
data_ = tab_merge_[,grepl("Biais_aout_general_1|Biais_aout_general_2|Biais_aout_general_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/5_Boxplot_Globale_Biais_Mois08_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/5_Boxplot_Globale_Biais_Mois08_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/5_Boxplot_Globale_Biais_Mois08_NonBoot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Prediction bias\nfor the month of August",
       x = "",
       y = "Bias (unitless)") +
  theme_bw()+
  ylim(-0.4,0.2) +
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))

### Biais non boot Septembre ###
data_ = tab_merge_[,grepl("Biais_aout_general_1|Biais_aout_general_2|Biais_aout_general_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/5_Boxplot_Globale_Biais_Mois09_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/5_Boxplot_Globale_Biais_Mois09_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/5_Boxplot_Globale_Biais_Mois09_NonBoot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Prediction bias\nfor the month of September",
       x = "",
       y = "Bias (unitless)") +
  theme_bw()+
  ylim(-0.4,0.2) +
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))




### EMA non boot ###
data_ = tab_merge_[,grepl("ErreurMoyenneAbsolue_mai_general_1|ErreurMoyenneAbsolue_mai_general_2|ErreurMoyenneAbsolue_mai_general_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/6_Boxplot_Globale_ErrMoyAbs_Mois05_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/6_Boxplot_Globale_ErrMoyAbs_Mois05_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/6_Boxplot_Globale_ErrMoyAbs_Mois05_NonBoot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Erreur Moyenne Absolue\nau mois de Mai",
       x = "",
       y = "Erreur Moyenne Absolue (sans unité)") +
  theme_bw()+
  ylim(0,0.2)+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))

data_ = tab_merge_[,grepl("ErreurMoyenneAbsolue_juin_general_1|ErreurMoyenneAbsolue_juin_general_2|ErreurMoyenneAbsolue_juin_general_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/6_Boxplot_Globale_ErrMoyAbs_Mois06_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/6_Boxplot_Globale_ErrMoyAbs_Mois06_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/6_Boxplot_Globale_ErrMoyAbs_Mois06_NonBoot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Erreur Moyenne Absolue\nau mois de Juin",
       x = "",
       y = "Erreur Moyenne Absolue (sans unité)") +
  theme_bw()+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))

data_ = tab_merge_[,grepl("ErreurMoyenneAbsolue_juillet_general_1|ErreurMoyenneAbsolue_juillet_general_2|ErreurMoyenneAbsolue_juillet_general_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/6_Boxplot_Globale_ErrMoyAbs_Mois07_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/6_Boxplot_Globale_ErrMoyAbs_Mois07_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/6_Boxplot_Globale_ErrMoyAbs_Mois07_NonBoot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Mean Absolute Error\nfor the month of July",
       x = "",
       y = "Mean Absolute Error (unitless)") +
  theme_bw()+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))

data_ = tab_merge_[,grepl("ErreurMoyenneAbsolue_aout_general_1|ErreurMoyenneAbsolue_aout_general_2|ErreurMoyenneAbsolue_aout_general_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/6_Boxplot_Globale_ErrMoyAbs_Mois08_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/6_Boxplot_Globale_ErrMoyAbs_Mois08_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/6_Boxplot_Globale_ErrMoyAbs_Mois08_NonBoot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Mean Absolute Error\nfor the month of August",
       x = "",
       y = "Mean Absolute Error (unitless)") +
  theme_bw()+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))

data_ = tab_merge_[,grepl("ErreurMoyenneAbsolue_septembre_general_1|ErreurMoyenneAbsolue_septembre_general_2|ErreurMoyenneAbsolue_septembre_general_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/6_Boxplot_Globale_ErrMoyAbs_Mois09_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/6_Boxplot_Globale_ErrMoyAbs_Mois09_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/6_Boxplot_Globale_ErrMoyAbs_Mois09_NonBoot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Mean Absolute Error\nfor the month of September",
       x = "",
       y = "Mean Absolute Error (unitless)") +
  theme_bw()+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))







data_ = tab_merge_[,grepl("NASH_HER_AnneeValid_logit_CValid_general_1|NASH_HER_AnneeValid_logit_CValid_general_2|NASH_HER_AnneeValid_logit_CValid_general_G", colnames(tab_merge_))]
table_as_rows <- gather(data_, key = "Années", value = "Valeur")
table_as_rows$Années[grepl("General",table_as_rows$Années)] = "Overall"
table_as_rows$Années[grepl("13-14-16-18",table_as_rows$Années)] = "Wet\nyears"
table_as_rows$Années[grepl("12-15-20-21",table_as_rows$Années)] = "Intermediate\nyears"
table_as_rows$Années[grepl("17-19-22",table_as_rows$Années)] = "Dry\nyears"
ordre_annees <- c("Overall", "Wet\nyears", "Intermediate\nyears", "Dry\nyears")
table_as_rows$Années <- factor(table_as_rows$Années, levels = ordre_annees)

if(!dir.exists(paste0(folder_output_,
                      "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                      nomSim_,
                      ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                      ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                      ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                      "/TableGlobale/Map_English/8_Boxplot_Globale_NSE_General_NonBoot/"))){
  dir.create(paste0(folder_output_,
                    "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                    nomSim_,
                    ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                    ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                    ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                    "/TableGlobale/Map_English/8_Boxplot_Globale_NSE_General_NonBoot/"))
}
output_name_ <- paste0(folder_output_,
                       "/15_ResultatsModeles_ValidationParAnnees_ParHer/",
                       nomSim_,
                       ifelse(nom_categorieSimu_=="","",paste0("/",nom_categorieSimu_)),
                       ifelse(nom_apprentissage_=="","",paste0("/",nom_apprentissage_)),
                       ifelse(nom_validation_=="","",paste0("/",nom_validation_)),
                       "/TableGlobale/Map_English/8_Boxplot_Globale_NSE_General_NonBoot/",str_before_first(basename(filename_),pattern = "ValidGlobale_"),"ValidGlobale.png")
png(output_name_,
    width = 600, height = 1300,
    units = "px", pointsize = 12)
p <- ggplot(data = table_as_rows, aes(x = factor(Années), y = Valeur)) +
  geom_boxplot() +
  labs(title = "Nash Sutcliffe Efficiency",
       x = "",
       y = "Nash Sutcliffe Efficiency\n(%)") +
  theme_bw()+
  theme(text = element_text(size = 26),
        plot.title = element_text(hjust = 0))
print(p)
dev.off()
saveRDS(p, file = paste0(str_before_first(output_name_, ".png"),".rds"))

