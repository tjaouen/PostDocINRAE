
library(readxl)

tab_ = read_excel("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DescriptionPointsSimulation/FichierCorrespondancesLH/Selection_points_simulation_V20230510_TJ20231218_AjoutColonneSIM2.xlsx", sheet = 2)
dim(tab_)

dim(tab_[which(tab_$CTRIP+tab_$EROS+tab_$GRSD+tab_$J2000+tab_$`MORDOR-TS`+tab_$`MORDOR-SD`+tab_$SIM2+tab_$SMASH+tab_$ORCHIDEE >= 1 & tab_$PointsSupprimes != "Supprimer"),])
