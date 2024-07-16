
library(readxl)

tab_points_ = read_excel("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/Debits/DescriptionPointsSimulation/FichierCorrespondancesLH/Selection_points_simulation_V20230510_TJ20231218_AjoutColonneSIM2_ControlMORDOR.xlsx",
                         sheet = "stationSimulation")

hist(rowSums(tab_points_[,c("CTRIP","EROS","GRSD","J2000","MORDOR-SD","MORDOR-TS","ORCHIDEE","SIM2","SMASH")]))

length(which(rowSums(tab_points_[,c("CTRIP","EROS","GRSD","J2000","MORDOR-SD","MORDOR-TS","ORCHIDEE","SIM2","SMASH")])>=4))

length(which(rowSums(tab_points_[,c("CTRIP","EROS","GRSD","J2000","MORDOR-SD","MORDOR-TS","ORCHIDEE","SIM2","SMASH")])>=2))

length(which(rowSums(tab_points_[,c("CTRIP","EROS","GRSD","J2000","MORDOR-SD","MORDOR-TS","ORCHIDEE","SIM2","SMASH")])>=1))


table(rowSums(tab_points_[,c("CTRIP","EROS","GRSD","J2000","MORDOR-SD","MORDOR-TS","ORCHIDEE","SIM2","SMASH")]))


write.table(tab_points_$Synth = paste0(ifelse(tab_points_$CTRIP,"CTRIP_",""),
                           ifelse(tab_points_$EROS,"EROS_",""),
                           ifelse(tab_points_$J2000,"J2000_",""),
                           ifelse(tab_points_$`MORDOR-SD`,"MORDORSD_",""),
                           ifelse(tab_points_$`MORDOR-TS`,"MORDORTS_",""),
                           ifelse(tab_points_$ORCHIDEE,"ORCHIDEE_",""),
                           ifelse(tab_points_$SIM2,"SIM2_",""),
                           ifelse(tab_points_$SMASH,"SMASH",""))

table(tab_points_$Synth)

barplot(table(substr(tab_points_$CODE,1,1)))

