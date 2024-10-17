#----------------------------------------------------------------------------------------
# Permet de lire les données hydro à la date de l'observation ONDE
# basé sur les stations sélectionnées suite au test 3 et sort un 
# fichier par année + réalise une courbe des débits classés + hydrogramme
#
# Sélectionne les stations à traiter en fonction du rapport des superficie 
# entre la station ONDE et la station Hydro matchée
#
# Extrait toutes les variables explicatives nécessaires à prédictions des assecs en 
#----------------------------------------------------------------------------------------

rm(list=ls())

seuil<-0 # en l/s

library(hydroTSM)
library(ggplot2)
library(zoo)

source("C:/Users/aurelien.beaufort/Documents/Prog_R/IndiceFranceIrbas/BFI.r")
source("C:/Users/aurelien.beaufort/Documents/Prog_R/IndiceFranceIrbas/HydrologicalYear.r")

hydro <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/Banque Hydro/Stations_Hydro_2016_non_influencees_sans_source_Regime_Hydro_HER2_1667_stations_group_new_RH.csv", header = T, sep = ";", row.names = NULL, quote="")
Piezo <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/Bd ades/Piezo_echange_hydro_BRGM_final_L2E_HER2_inertie_faible_group.csv", header = T, sep = ";", row.names = NULL, quote="")

onde <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/RHT/Stations_ONDES_snap_corr_REGIME_hydro_HER2_group.csv", header = T, sep = ";", row.names = NULL, quote="")

nom_data <- paste("C:/Users/aurelien.beaufort/Documents/Onde/Données site/Test_4/Stations_ONDES_snap_corr_match_hydro_test4_50km_attrib.csv",sep="")
liste <- read.table(file = nom_data, header = TRUE, sep = ";",  row.names = NULL, quote="")
HER2 <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/HER/Hydroecoregion2_group.csv",sep=";",header=T,quote="")

T1<-Sys.time()

test=0
NB_Station_HYDRO<-data.frame()
compteur=0
list_HER=sort(HER2[,3])

for (HER in 64) { #list_HER

# for (HER in 13) {
  select=which(onde[,18]==HER)
  position=which(HER2[,3]==HER)
  compt_HER_PIEZO=0
  select_PIEZO=vector()
  # On regroupe les stations ONDE des stations voisines
  
  #---------------------------------------------
  # Calcul des fréquences au non dépassement GW
  #---------------------------------------------
  
  debExtract_full=data.frame()
  col_deb=0
  
  # for (voisin in 3:7){
  #   if (HER2[position,voisin] > 0){
  #     select_HER_1<-which(Piezo[,16]==HER2[position,voisin])
  #     if (length(select_HER_1>0)){
  #       for (l in 1:length(select_HER_1)){
  #         compt_HER_PIEZO=compt_HER_PIEZO+1
  #         select_PIEZO[compt_HER_PIEZO]=select_HER_1[l]
  #       }
  #     }
  #   }
  # }
  # 
  # if (length(select_PIEZO) > 0){
  #   for (st_piezo in 1:length(select_PIEZO)){
  #     if ((as.character(Piezo[select_PIEZO[st_piezo],12]) != "Cycle pluriannuel unique (inertie forte)") & (as.character(Piezo[select_PIEZO[st_piezo],12]) != "Double cycle (inertie forte)")){
  #       code_ades <- gsub("/","-",as.character(Piezo[select_PIEZO[st_piezo],4]))
  #       
  #       if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Bd ades/FDC_1970_2016/FDC_",code_ades,".txt",sep=""))==TRUE){
  #         col_deb=col_deb+1
  #         debExtract<-read.table(paste("C:/Users/aurelien.beaufort/Documents/Bd ades/FDC_1970_2016/FDC_",code_ades,".txt",sep=""), header = T, sep = ";", row.names = NULL, quote="")
  #         for (j in 1:nrow(debExtract)){
  #           debExtract_full[j,((col_deb*2)-1)]=debExtract[j,1]
  #           debExtract_full[j,(col_deb*2)]=debExtract[j,2]
  #         }
  #       }
  #     }
  #   }
  # }
  
  # ncol_piezo=ncol(debExtract_full)
  
  liste_RH = unique(onde[select,17])
  for (RH in liste_RH){
    # print(RH)
    # debExtract_full=debExtract_full
    # debExtract_full=debExtract_full[,1:ncol_piezo]
    debExtract_full=data.frame()
    compt=0
    output<-data.frame()
    n_obs=0
    # obs_tot=153*5
    obs_tot=as.Date(paste("31/12/2016",sep = ""), "%d/%m/%Y")-as.Date(paste("01/01/2012",sep = ""), "%d/%m/%Y")
    # col_deb=(ncol_piezo/2)
    col_deb=0
    
    while(n_obs < obs_tot){
      date_onde=format(as.Date(paste("01/01/2012",sep = ""), "%d/%m/%Y")+n_obs,"%d/%m/%Y")
      date_onde<-paste(substr(date_onde,7,10),"-",substr(date_onde,4,5),"-",substr(date_onde,1,2),sep = "")
      
      # print(n_obs)
      compt=compt+1
      output[compt,1] <- date_onde
      
      #--------------------------------------------
      # Calcul des fréquences au non dépassement Q
      #--------------------------------------------
      if (compt==1){
        compt_HER_HYDRO=0
        compt_HER_PIEZO=0

        # On regroupe les stations ONDE des stations voisines
        select_HYDRO1=vector()
        select_HYDRO2=vector()

        for (voisin in 3:7){
          if (HER2[position,voisin] > 0){
            select_HER_1<-which(hydro[,27]==HER2[position,voisin])
            if (length(select_HER_1>0)){
              for (l in 1:length(select_HER_1)){
                compt_HER_HYDRO=compt_HER_HYDRO+1
                select_HYDRO1[compt_HER_HYDRO]=select_HER_1[l]
              }
            }
          }
        }

        if (RH < 9){

          compt_hydro=0
          select_HYDRO2_1<-which(hydro[select_HYDRO1,26]==(RH-1))
          if (length(select_HYDRO2_1>0)){
            for (l in 1:length(select_HYDRO2_1)){
              compt_hydro=compt_hydro+1
              select_HYDRO2[compt_hydro]=select_HYDRO2_1[l]
            }
          }
          select_HYDRO2_2<-which(hydro[select_HYDRO1,26]==RH)
          if (length(select_HYDRO2_2>0)){
            for (m in 1:length(select_HYDRO2_2)){
              compt_hydro=compt_hydro+1
              select_HYDRO2[compt_hydro]=select_HYDRO2_2[m]
            }
          }
          select_HYDRO2_3<-which(hydro[select_HYDRO1,26]==(RH+1))
          if (length(select_HYDRO2_3>0)){
            for (n in 1:length(select_HYDRO2_3)){
              compt_hydro=compt_hydro+1
              select_HYDRO2[compt_hydro]=select_HYDRO2_3[n]
            }
          }
        } else {
          # on sélectionne les stations ONDE et HYDRO ayant un même régime hydrologique dans l'HER
          select_HYDRO2<-which(hydro[select_HYDRO1,26]==RH)
        }

        if (length(select_HYDRO2) > 0){
          # On rassemble les freq au non dépassement dans une matrice
          for (st_HYDRO in 1:length(select_HYDRO2)){

            code_Hydro <- as.character(hydro[select_HYDRO1[select_HYDRO2[st_HYDRO]],2])

            if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/QJHYDRO/FDC_2000_2016/FDC_",code_Hydro,".txt",sep=""))==TRUE){
              col_deb=col_deb+1
              debExtract<-read.table(paste("C:/Users/aurelien.beaufort/Documents/QJHYDRO/FDC_2000_2016/FDC_",code_Hydro,".txt",sep=""), header = T, sep = ";", row.names = NULL, quote="")

              for (j in 1:nrow(debExtract)){
                debExtract_full[j,((col_deb*2)-1)]=debExtract[j,1]
                debExtract_full[j,(col_deb*2)]=debExtract[j,2]
              }
            }
          }
        }
      }
      
      #-----------------------------------------------------------------------------------------------------
      # Calcul des fréquences au non dépassement des débits et des cotes piézométriques pour le suivi usuel
      #-----------------------------------------------------------------------------------------------------
      if (nrow(debExtract_full)>0){
        # On va chercher les débits aux dates d'observations usuelles ONDE
        output_HYDRO=data.frame()
        compt2=0
        
        # ------------------------------------------------------
        # On calcul les fréquences au non dépassement des débits
        # ------------------------------------------------------
        for (station in 1:(ncol(debExtract_full)/2)){
          
          # on transforme la date ONDE au format Hydro
          
          # if (station > (ncol_piezo/2)){
            date_deb <-paste(substr(date_onde,1,4),substr(date_onde,6,7),substr(date_onde,9,10),sep = "")
          # } else {
          # date_deb <-paste(substr(date_onde,1,4),substr(date_onde,6,7),substr(date_onde,9,10),sep = "-")
          # }
          
          flow_cible <- which(debExtract_full[,(station*2-1)] == date_deb, arr.ind = TRUE)
          
          if (length(flow_cible) > 0){
            if (as.numeric(flow_cible) > 10){
              compt2=compt2+1
              output_HYDRO[compt2,1]=debExtract_full[flow_cible[1],(station*2)] # Freq non dépassement au jour j
              output_HYDRO[compt2,2]=debExtract_full[flow_cible[1]-1,(station*2)] # Freq non dépassement au jour j-1
              output_HYDRO[compt2,3]=debExtract_full[flow_cible[1]-2,(station*2)] # Freq non dépassement au jour j-2
              output_HYDRO[compt2,4]=debExtract_full[flow_cible[1]-3,(station*2)] # Freq non dépassement au jour j-3
              output_HYDRO[compt2,5]=debExtract_full[flow_cible[1]-4,(station*2)] # Freq non dépassement au jour j-4
              output_HYDRO[compt2,6]=debExtract_full[flow_cible[1]-5,(station*2)] # Freq non dépassement au jour j-5
              output_HYDRO[compt2,7]=debExtract_full[flow_cible[1]-6,(station*2)] # Freq non dépassement au jour j-1
              output_HYDRO[compt2,8]=debExtract_full[flow_cible[1]-7,(station*2)] # Freq non dépassement au jour j-2
              output_HYDRO[compt2,9]=debExtract_full[flow_cible[1]-8,(station*2)] # Freq non dépassement au jour j-3
              output_HYDRO[compt2,10]=debExtract_full[flow_cible[1]-9,(station*2)] # Freq non dépassement au jour j-4
              output_HYDRO[compt2,11]=debExtract_full[flow_cible[1]-10,(station*2)] # Freq non dépassement au jour j-5
            }
          }
        }
        
        if (nrow(output_HYDRO)>0){
          for (h in 1:11){
            output[compt,(1+h)] = mean(output_HYDRO[,h], na.rm = T) # Moyenne des débits spécifiques au jour j de toutes les stations HYDRO d'une régime hydro donnée
          }
        } else {
          for (h in 1:11){
            output[compt,(1+h)] = NA
          }
        }
        output[compt,13] = mean(as.numeric(output[compt,2:12]))
        
      } else {
        for (h in 1:11){
          output[compt,(1+h)] = NA
        }
        output[compt,13] = NA
      }
      n_obs=n_obs+1
    }
    if (nrow(debExtract_full)>0){
      colnames(output)<-c("Date","J0","J1","J2","J3","J4","J5","J6","J7","J8","J9","J10","Moy_Freq")
      # write.table(output,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Freq_2017_HER_HR/Freq_2017_",HER,"_",RH,"_HYDRO_ONLY.txt",sep=""),sep=";", row.name=F,quote=F)
      write.table(output,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Freq_2012_2016_HER_HR/Freq_2012_2016_",HER,"_",RH,"_HYDRO_ONLY_test.txt",sep=""),sep=";", row.name=F,quote=F)
      T2 <- Sys.time()
      
      Tdiff = difftime(T2, T1)
      # print(Tdiff)
    }
    print(RH)
    print(ncol(debExtract_full)/2)
    compteur=compteur+1
    NB_Station_HYDRO[compteur,1]=HER
    NB_Station_HYDRO[compteur,2]=RH
    NB_Station_HYDRO[compteur,3]=(ncol(debExtract_full)/2)
  } # Boucle RH
} # HER2

colnames(NB_Station_HYDRO)<-c("HER","RH","NB_ST_HYDRO")
write.table(NB_Station_HYDRO,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Freq_2012_2016_HER_HR/NB_Station_HYDRO_HER.csv",sep=""),sep=";", row.name=F,quote=F)
