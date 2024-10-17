#--------------------------------------------------------------------------------------------
# Permet de détecter et lister les stations de la banque hydro ayant des assec répertoriés
# Un assec étant défini comme étant un débit <= 1 l/s pendant au moins 5 jours consécutifs
#--------------------------------------------------------------------------------------------

rm(list=ls())

# liste<-read.table("C:/Users/aurelien.beaufort/Documents/SIG/Banque Hydro/Stations_Hydro_Rhone_Med_full.csv",sep=";",header=T)
hydro <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/Banque Hydro/Stations_Hydro_2016_non_influencees_sans_source_Regime_Hydro_HER2_1667_stations_group_new_RH.csv", header = T, sep = ";", row.names = NULL, quote="")
select <- which(hydro[,27]==58)
liste=read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/Liste_station_HYDRO_97.csv", header = T, sep = ";", row.names = NULL, quote="")
output=data.frame()

# for (i in 1:nrow(liste)){
for (i in 1:nrow(liste)){
  print(i)
  # code_Hydro <- as.character(liste[i,5])
  code_Hydro <- as.character(liste[i,1])
  rep=which(as.character(hydro[,2]) == as.character(liste[i,1]))
  # code_Hydro <- as.character(hydro[select[i],2])
  NbAssec=0
  compt_J=0
  if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/QJHYDRO/Export_2016/",code_Hydro,".txt",sep=""))==TRUE){
    
    flow <- read.table(paste("C:/Users/aurelien.beaufort/Documents/QJHYDRO/Export_2016/",code_Hydro,".txt",sep=""), sep=";",skip=3,fill=T,colClasses="character",quote="")
    DebSelect2 <- which(flow[,1] == "QJO") # AVEC 0
    dateDeb=as.Date("2011-12-31")
    dateFin=as.Date("2016-12-31")
    nbJour=as.numeric(as.Date("2016-12-31")-as.Date("2012-01-01"))

    for (date in 1:(nbJour+1)){
      
      date_search=as.Date(dateDeb)+date
      
      # on transforme la date ONDE au format Hydro
      date_deb <-paste(substr(date_search,1,4),substr(date_search,6,7),substr(date_search,9,10),sep = "")
      
      repere=which(flow[DebSelect2,3] == date_deb)
      
      if(length(repere) > 0){
        
        if (flow[DebSelect2[repere],4] != ""){
          
          if(as.numeric(flow[DebSelect2[repere],4]) <= 1){
            compt_J=compt_J+1
            output[compt_J,1]<-code_Hydro
            output[compt_J,2]<-date_deb
            output[compt_J,3]<-flow[DebSelect2[repere],4]
            output[compt_J,4]<-hydro[rep,29]
          } else {
            compt_J=0
          }
        } else {
          compt_J=0
        }
      } else {
        compt_J=0
      }

      if(compt_J > 5){
        NbAssec=NbAssec+1
      }
    }
  }
  liste[i,33]=NbAssec
}

# write.table(liste, "C:/Users/aurelien.beaufort/Documents/SIG/Banque Hydro/Stations_Hydro_Rhone_Med_full_nb_Assec.csv", sep=";", row.name=F, quote=F)
colnames(output) <- c("Code_station","Date","QJobs","Regime")
write.table(output, "C:/Users/aurelien.beaufort/Documents/Neural_Network/Stations_Hydro_Assec_POC_97.csv", sep=";", row.name=F, quote=F)
