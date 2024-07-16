library(readxl)

tab_points = read_excel("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DescriptionPointsSimulation/FichierCorrespondancesLH/Selection_points_simulation_V20230510_TJ20231218_AjoutColonneSIM2_ControlMORDOR.xlsx", sheet = 2)
dim(tab_points)
tab_points$EROS[which(is.na(tab_points$EROS))] = 0

which(is.na(tab_points$CTRIP + 
              tab_points$EROS + 
              tab_points$GRSD + 
              tab_points$J2000 + 
              tab_points$`MORDOR-TS` + 
              tab_points$`MORDOR-SD` + 
              tab_points$SIM2 +
              tab_points$SMASH +
              tab_points$ORCHIDEE))

mean(tab_points$CTRIP + 
       tab_points$EROS + 
       tab_points$GRSD + 
       tab_points$J2000 + 
       tab_points$`MORDOR-TS` + 
       tab_points$`MORDOR-SD` + 
       tab_points$SIM2 +
       tab_points$SMASH +
       tab_points$ORCHIDEE)

quantile(tab_points$CTRIP + 
           tab_points$EROS + 
           tab_points$GRSD + 
           tab_points$J2000 + 
           tab_points$`MORDOR-TS` + 
           tab_points$`MORDOR-SD` + 
           tab_points$SIM2 +
           tab_points$SMASH +
           tab_points$ORCHIDEE, probs = 0.25)

quantile(tab_points$CTRIP + 
           tab_points$EROS + 
           tab_points$GRSD + 
           tab_points$J2000 + 
           tab_points$`MORDOR-TS` + 
           tab_points$`MORDOR-SD` + 
           tab_points$SIM2 +
           tab_points$SMASH +
           tab_points$ORCHIDEE, probs = 0.75)

length(which(tab_points$CTRIP == 1 & tab_points$PointsSupprimes != "Supprimer"))
table(tab_points$PointsSupprimes[which(tab_points$CTRIP == 1 & tab_points$PointsSupprimes != "Supprimer")])

