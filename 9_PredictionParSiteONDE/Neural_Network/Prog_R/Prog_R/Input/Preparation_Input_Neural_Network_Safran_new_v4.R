#----------------------------------------------------------------------------------------
# Permet de lire les données hydro à la date de l'observation ONDE
# basé sur les stations sélectionnées suite au test 3 et sort un 
# fichier par année + réalise une courbe des débits classés + hydrogramme
#
# Sélectionne les stations à traiter en fonction du rapport des superficie 
# entre la station ONDE et la station Hydro matchée
#
# Nécessite d'avoir les débits jusqu'en 2016 disponibles dans le dossier "export_2016"
# version 3 plus rapide que la version 2 car charge directement les fréquences au non dépassement
# des débits et des niveaux piézométriques directement calculés
#
#         !!! Remplace les NA par des 0 en 2016 à corriger !!!!
#----------------------------------------------------------------------------------------

rm(list=ls())

seuil<-0 # en l/s

library(hydroTSM)
library(ggplot2)
library(zoo)

source("C:/Users/aurelien.beaufort/Documents/Prog_R/IndiceFranceIrbas/BFI.r")
source("C:/Users/aurelien.beaufort/Documents/Prog_R/IndiceFranceIrbas/HydrologicalYear.r")

listeAssec<-read.table("C:/Users/aurelien.beaufort/Documents/Onde/Données site/Liste_station_Assec.csv", header = F, sep = ";",  row.names = NULL, quote="")
listeSource<-read.table("C:/Users/aurelien.beaufort/Documents/Onde/Données site/Liste_station_souce.csv", header = F, sep = ";",  row.names = NULL, quote="")
listeStSafran<-read.table("C:/Users/aurelien.beaufort/Documents/SAFRAN/statOnde.txt", header = F,  row.names = NULL, quote="")
listeStMaille<-read.table("C:/Users/aurelien.beaufort/Documents/SAFRAN/PropSurfaceSafran.csv", sep=";", header = T, row.names = NULL, stringsAsFactors = F)

safran_1<-read.table(paste("C:/Users/aurelien.beaufort/Documents/SAFRAN/SAFRAN_NEW_NEW2/PRCP_2011_2012.txt",sep=""), sep=";", header=T, stringsAsFactors = F)
safran_2<-read.table(paste("C:/Users/aurelien.beaufort/Documents/SAFRAN/SAFRAN_NEW_NEW2/PRCP_2012_2013.txt",sep=""), sep=";", header=T, stringsAsFactors = F)
safran_3<-read.table(paste("C:/Users/aurelien.beaufort/Documents/SAFRAN/SAFRAN_NEW_NEW2/PRCP_2013_2014.txt",sep=""), sep=";", header=T, stringsAsFactors = F)
safran_4<-read.table(paste("C:/Users/aurelien.beaufort/Documents/SAFRAN/SAFRAN_NEW_NEW2/PRCP_2014_2015.txt",sep=""), sep=";", header=T, stringsAsFactors = F)
safran_5<-read.table(paste("C:/Users/aurelien.beaufort/Documents/SAFRAN/SAFRAN_NEW_NEW2/PRCP_2015_2016.txt",sep=""), sep=";", header=T, stringsAsFactors = F)
safran_6<-read.table(paste("C:/Users/aurelien.beaufort/Documents/SAFRAN/SAFRAN_NEW_NEW2/PRCP_2016_2017.txt",sep=""), sep=";", header=T, stringsAsFactors = F)

ETP_1<-read.table(paste("C:/Users/aurelien.beaufort/Documents/SAFRAN/SAFRAN_NEW_NEW2/ETP_2011_2012.txt",sep=""), sep=";", header=T, stringsAsFactors = F)
ETP_2<-read.table(paste("C:/Users/aurelien.beaufort/Documents/SAFRAN/SAFRAN_NEW_NEW2/ETP_2012_2013.txt",sep=""), sep=";", header=T, stringsAsFactors = F)
ETP_3<-read.table(paste("C:/Users/aurelien.beaufort/Documents/SAFRAN/SAFRAN_NEW_NEW2/ETP_2013_2014.txt",sep=""), sep=";", header=T, stringsAsFactors = F)
ETP_4<-read.table(paste("C:/Users/aurelien.beaufort/Documents/SAFRAN/SAFRAN_NEW_NEW2/ETP_2014_2015.txt",sep=""), sep=";", header=T, stringsAsFactors = F)
ETP_5<-read.table(paste("C:/Users/aurelien.beaufort/Documents/SAFRAN/SAFRAN_NEW_NEW2/ETP_2015_2016.txt",sep=""), sep=";", header=T, stringsAsFactors = F)
ETP_6<-read.table(paste("C:/Users/aurelien.beaufort/Documents/SAFRAN/SAFRAN_NEW_NEW2/ETP_2016_2017.txt",sep=""), sep=";", header=T, stringsAsFactors = F)

TEMP_1<-read.table(paste("C:/Users/aurelien.beaufort/Documents/SAFRAN/SAFRAN_NEW_NEW2/T_2011_2012.txt",sep=""), sep=";", header=T, stringsAsFactors = F)
TEMP_2<-read.table(paste("C:/Users/aurelien.beaufort/Documents/SAFRAN/SAFRAN_NEW_NEW2/T_2012_2013.txt",sep=""), sep=";", header=T, stringsAsFactors = F)
TEMP_3<-read.table(paste("C:/Users/aurelien.beaufort/Documents/SAFRAN/SAFRAN_NEW_NEW2/T_2013_2014.txt",sep=""), sep=";", header=T, stringsAsFactors = F)
TEMP_4<-read.table(paste("C:/Users/aurelien.beaufort/Documents/SAFRAN/SAFRAN_NEW_NEW2/T_2014_2015.txt",sep=""), sep=";", header=T, stringsAsFactors = F)
TEMP_5<-read.table(paste("C:/Users/aurelien.beaufort/Documents/SAFRAN/SAFRAN_NEW_NEW2/T_2015_2016.txt",sep=""), sep=";", header=T, stringsAsFactors = F)
TEMP_6<-read.table(paste("C:/Users/aurelien.beaufort/Documents/SAFRAN/SAFRAN_NEW_NEW2/T_2016_2017.txt",sep=""), sep=";", header=T, stringsAsFactors = F)

hydro <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/Banque Hydro/Stations_Hydro_2016_non_influencees_sans_source_Regime_Hydro_HER2_1667_stations_group_new_RH.csv", header = T, sep = ";", row.names = NULL, quote="")
onde <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/RHT/Stations_ONDES_snap_corr_REGIME_hydro_HER2_group.csv", header = T, sep = ";", row.names = NULL, quote="")

nom_data <- paste("C:/Users/aurelien.beaufort/Documents/Onde/Données site/Test_4/Stations_ONDES_snap_corr_match_hydro_test4_50km_attrib.csv",sep="")
liste <- read.table(file = nom_data, header = TRUE, sep = ";",  row.names = NULL, quote="")

HER2 <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/HER/Hydroecoregion2_group.csv",sep=";",header=T,quote="")

Bilan_PRCP=read.table("C:/Users/aurelien.beaufort/Documents/SAFRAN/Moy_PRCP_1958_2016.txt",sep=";",header=T)

# HERc=85

for (HERc in HER2[2:85,3]){ #
  
  id <- 0
  compt=0
  output<-data.frame()
  
  while(id < nrow(liste)){
    
    id=id+1
    print(id)
    code_ONDE <- liste[id,14]
    ligne_st <- which(as.character(onde[,9]) == code_ONDE)
    HER <- onde[ligne_st,18]
    RH <- onde[ligne_st,17]
    
    if(HER==HERc){
      
      for(annee in 2012:2016){
        
        # lecture par annee de suivi
        metaData <- read.table(paste("C:/Users/aurelien.beaufort/Documents/Onde/Données site/onde_france_",annee,"/onde_france_",annee,".csv",sep=""),sep=";",header=T,fill=T,colClasses="character",quote="")  
        
        # on cherche le nombre d'obervation ONDE dispo sur une année
        row_st=which(metaData[,1]==code_ONDE, arr.ind = TRUE)
        n_obs=1
        
        while(n_obs <= length(row_st)){
          
          compt=compt+1
          output[compt,1]<-code_ONDE
          output[compt,2] <- liste[id,22] #altitude
          date_onde<-as.character(metaData[row_st[n_obs],5])
          output[compt,3] <- date_onde
          
          if(date_onde != ""){
            
            # on transforme la date ONDE au format Safran
            date_onde<-paste(substr(date_onde,7,10),"-",substr(date_onde,4,5),"-",substr(date_onde,1,2),sep = "")
            
            # Chargement des données Safran 
            if (format(as.Date(date_onde), "%Y")==2012 | format(as.Date(date_onde), "%Y")==2016){
              if (format(as.Date(date_onde), "%j")<214){
                if(format(as.Date(date_onde), "%Y")==2012){
                  safran_data<-safran_1
                  etp_data<-ETP_1
                  Temp_data<-TEMP_1
                  safran_data2<-data.frame()
                  etp_data2<-data.frame()
                  Temp_data2<-data.frame()
                } else if (format(as.Date(date_onde), "%Y")==2016){
                  safran_data<-safran_5
                  etp_data<-ETP_5
                  Temp_data<-TEMP_5
                  safran_data2<-safran_4
                  etp_data2<-ETP_4
                  Temp_data2<-TEMP_4
                }
                repere=as.numeric(format(as.Date(date_onde), "%j"))+153
              } else if (format(as.Date(date_onde), "%j")>213){
                if(format(as.Date(date_onde), "%Y")==2012){
                  safran_data<-safran_2
                  etp_data<-ETP_2
                  Temp_data<-TEMP_2
                  safran_data2<-safran_1
                  etp_data2<-ETP_1
                  Temp_data2<-TEMP_1
                } else if (format(as.Date(date_onde), "%Y")==2016){
                  safran_data<-safran_6
                  etp_data<-ETP_6
                  Temp_data<-TEMP_6
                  safran_data2<-safran_5
                  etp_data2<-ETP_5
                  Temp_data2<-TEMP_5
                }
                repere=as.numeric(format(as.Date(date_onde), "%j"))-213
              }
            } else {
              if (format(as.Date(date_onde), "%j")<213){
                if(format(as.Date(date_onde), "%Y")==2013){
                  safran_data<-safran_2
                  etp_data<-ETP_2
                  Temp_data<-TEMP_2
                  safran_data2<-safran_1
                  etp_data2<-ETP_1
                  Temp_data2<-TEMP_1
                } else if (format(as.Date(date_onde), "%Y")==2014){
                  safran_data<-safran_3
                  etp_data<-ETP_3
                  Temp_data<-TEMP_3
                  safran_data2<-safran_2
                  etp_data2<-ETP_2
                  Temp_data2<-TEMP_2
                } else if (format(as.Date(date_onde), "%Y")==2015){
                  safran_data<-safran_4
                  etp_data<-ETP_4
                  Temp_data<-TEMP_4
                  safran_data2<-safran_3
                  etp_data2<-ETP_3
                  Temp_data2<-TEMP_3
                }
                repere=as.numeric(format(as.Date(date_onde), "%j"))+153
              } else if (format(as.Date(date_onde), "%j")>212){
                if(format(as.Date(date_onde), "%Y")==2013){
                  safran_data<-safran_3
                  etp_data<-ETP_3
                  Temp_data<-TEMP_3
                  safran_data2<-safran_2
                  etp_data2<-ETP_2
                  Temp_data2<-TEMP_2
                } else if (format(as.Date(date_onde), "%Y")==2014){
                  safran_data<-safran_4
                  etp_data<-ETP_4
                  Temp_data<-TEMP_4
                  safran_data2<-safran_3
                  etp_data2<-ETP_3
                  Temp_data2<-TEMP_3
                } else if (format(as.Date(date_onde), "%Y")==2015){
                  safran_data<-safran_5
                  etp_data<-ETP_5
                  Temp_data<-TEMP_5
                  safran_data2<-safran_4
                  etp_data2<-ETP_4
                  Temp_data2<-TEMP_4
                }
                repere=as.numeric(format(as.Date(date_onde), "%j"))-212
              }
            }
          }
          
          output[compt,4]<-metaData[row_st[n_obs],8] # ajout de la modalité d'écoulement ONDE
          output[compt,5]<- NA #debExtract[flow_cible[1],2] # ajout du débit mesuré correspondant
          output[compt,6]<-NA #debExtract[flow_cible[1],2] # ajout du débit spécifique jour J
          output[compt,7]<-NA #debExtract[(flow_cible[1]-1),2] # ajout du débit spécifique jour J-1
          output[compt,8]<-NA #debExtract[(flow_cible[1]-2),2] # ajout du débit spécifique jour J-2
          output[compt,9]<-NA #debExtract[(flow_cible[1]-3),2] # ajout du débit spécifique jour J-3
          output[compt,10]<-NA #debExtract[(flow_cible[1]-4),2] # ajout du débit spécifique jour J-4
          output[compt,11]<-NA #debExtract[(flow_cible[1]-5),2] # ajout du débit spécifique jour J-5
          output[compt,12]<-NA #debExtract[(flow_cible[1]),3] # ajout de la Fréquence de non dépassement du débit jour J
          output[compt,13]<-NA #debExtract[(flow_cible[1]-1),3] # ajout de la Fréquence de non dépassement du débit jour J
          output[compt,14]<-NA #debExtract[(flow_cible[1]-2),3] # ajout de la Fréquence de non dépassement du débit jour J
          output[compt,15]<-NA #debExtract[(flow_cible[1]-3),3] # ajout de la Fréquence de non dépassement du débit jour J
          output[compt,16]<-NA #debExtract[(flow_cible[1]-4),3] # ajout de la Fréquence de non dépassement du débit jour J
          output[compt,17]<-NA #[(flow_cible[1]-5),3] # ajout de la Fréquence de non dépassement du débit jour J
          
          # On cherche la position de la station dans la liste des stations indexées avec une maille SAFRAN
          ligneSt<-which(as.character(listeStSafran[,1])==code_ONDE)
          
          if(date_onde != "" & length(ligneSt) > 0){
            
            x_st=listeStSafran[ligneSt,2]
            y_st=listeStSafran[ligneSt,3]
            
            # On cherche les mailles présentent dans le BV de la station et leur contribution
            # indexMaille<-which(as.numeric(as.character(listeStMaille[,1]))==x_st & as.numeric(as.character(listeStMaille[,2]))==y_st)
            indexMaille<-which(as.character(listeStMaille[,6]) == code_ONDE)
            
            for (a in 18:110){
              output[compt,a] <- 0
            }
            
            for (index in 1:length(indexMaille)){
              
              ratio <- as.numeric(as.character(listeStMaille[indexMaille[index],5])) / as.numeric(as.character(listeStMaille[indexMaille[index],3])) # Surface contributive de la maille pour une station
              
              if(format(as.Date(date_onde), "%Y")==2017 & format(as.Date(date_onde), "%j")>212){
                for (a in 18:110){
                  output[compt,a] <- NA
                }
              } else {
                jour=0
                while (jour <= 30){
                  if((repere-jour)>0){
                    output[compt,(18+jour)] <- as.numeric(as.character(safran_data[as.numeric(listeStMaille[indexMaille[index],4]),(repere-jour)]))*ratio + output[compt,(18+jour)]
                  } else if((repere-jour)<=0){
                    repere2=ncol(safran_data2)+(repere-jour)
                    output[compt,(18+jour)] <- as.numeric(as.character(safran_data2[as.numeric(listeStMaille[indexMaille[index],4]),repere2]))*ratio + output[compt,(18+jour)]
                  }
                  jour=jour+1
                }
                
                jour=0
                while (jour <= 30){
                  if((repere-jour)>0){
                    output[compt,(49+jour)] <- as.numeric(as.character(etp_data[as.numeric(listeStMaille[indexMaille[index],4]),(repere-jour)]))*ratio + output[compt,(49+jour)]
                  } else if((repere-jour)<=0){
                    repere2=ncol(etp_data2)+(repere-jour)
                    output[compt,(49+jour)] <- as.numeric(as.character(etp_data2[as.numeric(listeStMaille[indexMaille[index],4]),repere2]))*ratio + output[compt,(49+jour)]
                  }
                  jour=jour+1
                }
                
                jour=0
                while (jour <= 30){
                  if((repere-jour)>0){
                    output[compt,(80+jour)] <- as.numeric(as.character(Temp_data[as.numeric(listeStMaille[indexMaille[index],4]),(repere-jour)]))*ratio + output[compt,(80+jour)]
                  } else if((repere-jour)<=0){
                    repere2=ncol(Temp_data2)+(repere-jour)
                    output[compt,(80+jour)] <- as.numeric(as.character(Temp_data2[as.numeric(listeStMaille[indexMaille[index],4]),repere2]))*ratio + output[compt,(80+jour)]
                  }
                  jour=jour+1
                }
              }
            }
          } else {
            for (a in 18:110){
              output[compt,a]<-NA
            }
          }
          
          #------------------------------
          # calcul de l'indice d'aridité
          #------------------------------
          
          if (format(as.Date(date_onde), "%Y")==2012){
            m=as.numeric(as.numeric(listeStMaille[indexMaille[index],4]))
            P<-sum(as.numeric(safran_1[m,154:366]))+sum(as.numeric(safran_2[m,1:153]))
            E<-sum(as.numeric(ETP_1[m,154:366]))+sum(as.numeric(ETP_2[m,1:153]))
            AI<-P/E
          } else if (format(as.Date(date_onde), "%Y")==2013){
            m=as.numeric(as.numeric(listeStMaille[indexMaille[index],4]))
            P<-sum(as.numeric(safran_2[m,154:365]))+sum(as.numeric(safran_3[m,1:153]))
            E<-sum(as.numeric(ETP_2[m,154:365]))+sum(as.numeric(ETP_3[m,1:153]))
            AI<-P/E
          } else if (format(as.Date(date_onde), "%Y")==2014){
            m=as.numeric(as.numeric(listeStMaille[indexMaille[index],4]))
            P<-sum(as.numeric(safran_3[m,154:365]))+sum(as.numeric(safran_4[m,1:153]))
            E<-sum(as.numeric(ETP_3[m,154:365]))+sum(as.numeric(ETP_4[m,1:153]))
            AI<-P/E
          } else if (format(as.Date(date_onde), "%Y")==2015){
            m=as.numeric(as.numeric(listeStMaille[indexMaille[index],4]))
            P<-sum(as.numeric(safran_4[m,154:365]))+sum(as.numeric(safran_5[m,1:153]))
            E<-sum(as.numeric(ETP_4[m,154:365]))+sum(as.numeric(ETP_5[m,1:153]))
            AI<-P/E
          } else if (format(as.Date(date_onde), "%Y")==2016){
            m=as.numeric(as.numeric(listeStMaille[indexMaille[index],4]))
            P<-sum(as.numeric(safran_5[m,154:365]))+sum(as.numeric(safran_6[m,1:153]))
            E<-sum(as.numeric(ETP_5[m,154:365]))+sum(as.numeric(ETP_6[m,1:153]))
            AI<-P/E
          }
          output[compt,5]<- AI
          
          #----------------------------------------------------
          # Calcul anomalies recharche nappe HIVER
          #----------------------------------------------------
          m=as.numeric(listeStMaille[indexMaille[index],4])
          if (format(as.Date(date_onde), "%Y")==2012){
            REC<-sum(as.numeric(safran_1[m,123:245]))
          } else if (format(as.Date(date_onde), "%Y")==2013){
            REC<-sum(as.numeric(safran_2[m,123:244]))
          } else if (format(as.Date(date_onde), "%Y")==2014){
            REC<-sum(as.numeric(safran_3[m,123:244]))
          } else if (format(as.Date(date_onde), "%Y")==2015){
            REC<-sum(as.numeric(safran_4[m,123:244]))
          } else if (format(as.Date(date_onde), "%Y")==2016){
            REC<-sum(as.numeric(safran_5[m,123:245]))
          }
          output[compt,6]<- REC/Bilan_PRCP[m,14]
          
          #----------------------------------------------------
          # Calcul des fréquences au non dépassement Q
          #----------------------------------------------------
          
          if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Freq_2012_2016_HER_HR/Freq_2012_2016_",HER,"_",RH,"_HYDRO_ONLY.txt",sep=""))==TRUE){
            output_HYDRO<-read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Freq_2012_2016_HER_HR/Freq_2012_2016_",HER,"_",RH,"_HYDRO_ONLY.txt",sep=""),sep=";",header=T)
            
            date_select<-which(as.character(output_HYDRO[,1])==date_onde)
            
            if (length(date_select)>0){
              output[compt,111]=output_HYDRO[date_select,2] # Moyenne des débits spécifiques au jour j de toutes les stations HYDRO d'une régime hydro donnée
              output[compt,112]=output_HYDRO[date_select,3] # Moyenne des débits spécifiques au jour j-1 de toutes les stations HYDRO d'une régime hydro donnée
              output[compt,113]=output_HYDRO[date_select,4] # Moyenne des débits spécifiques au jour j-2 de toutes les stations HYDRO d'une régime hydro donnée
              output[compt,114]=output_HYDRO[date_select,5] # Moyenne des débits spécifiques au jour j-3 de toutes les stations HYDRO d'une régime hydro donnée
              output[compt,115]=output_HYDRO[date_select,6] # Moyenne des débits spécifiques au jour j-4 de toutes les stations HYDRO d'une régime hydro donnée
              output[compt,116]=output_HYDRO[date_select,7] # Moyenne des débits spécifiques au jour j de toutes les stations HYDRO d'une régime hydro donnée
              output[compt,117]=output_HYDRO[date_select,8] # Moyenne des débits spécifiques au jour j-1 de toutes les stations HYDRO d'une régime hydro donnée
              output[compt,118]=output_HYDRO[date_select,9] # Moyenne des débits spécifiques au jour j-2 de toutes les stations HYDRO d'une régime hydro donnée
              output[compt,119]=output_HYDRO[date_select,10] # Moyenne des débits spécifiques au jour j-3 de toutes les stations HYDRO d'une régime hydro donnée
              output[compt,120]=output_HYDRO[date_select,11] # Moyenne des débits spécifiques au jour j-4 de toutes les stations HYDRO d'une régime hydro donnée
              output[compt,121]=output_HYDRO[date_select,12] # Moyenne des débits spécifiques au jour j de toutes les stations HYDRO d'une régime hydro donnée
            } else {
              output[compt,111]=NA
              output[compt,112]=NA
              output[compt,113]=NA
              output[compt,114]=NA
              output[compt,115]=NA
              output[compt,116]=NA
              output[compt,117]=NA
              output[compt,118]=NA
              output[compt,119]=NA
              output[compt,120]=NA
              output[compt,121]=NA
            }
            output[compt,122]=mean(as.numeric(output[compt,111:121]))
          } else {
            output[compt,111]=NA
            output[compt,112]=NA
            output[compt,113]=NA
            output[compt,114]=NA
            output[compt,115]=NA
            output[compt,116]=NA
            output[compt,117]=NA
            output[compt,118]=NA
            output[compt,119]=NA
            output[compt,120]=NA
            output[compt,121]=NA
            output[compt,122]=NA
          }
          
          #----------------------------------------------------
          # Calcul des fréquences au non dépassement GW
          #----------------------------------------------------
          
          if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Freq_2012_2016_HER_HR/Freq_2012_2016_",HER,"_",RH,"_PIEZO_ONLY.txt",sep=""))==TRUE){
            
            output_HYDRO<-read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Freq_2012_2016_HER_HR/Freq_2012_2016_",HER,"_",RH,"_PIEZO_ONLY.txt",sep=""),sep=";",header=T)
            date_select<-which(as.character(output_HYDRO[,1])==date_onde)
            
            if (length(date_select)>0){
              output[compt,123]=output_HYDRO[date_select,2] # Moyenne des débits spécifiques au jour j de toutes les stations HYDRO d'une régime hydro donnée
              output[compt,124]=output_HYDRO[date_select,3] # Moyenne des débits spécifiques au jour j-1 de toutes les stations HYDRO d'une régime hydro donnée
              output[compt,125]=output_HYDRO[date_select,4] # Moyenne des débits spécifiques au jour j-2 de toutes les stations HYDRO d'une régime hydro donnée
              output[compt,126]=output_HYDRO[date_select,5] # Moyenne des débits spécifiques au jour j-3 de toutes les stations HYDRO d'une régime hydro donnée
              output[compt,127]=output_HYDRO[date_select,6] # Moyenne des débits spécifiques au jour j-4 de toutes les stations HYDRO d'une régime hydro donnée
              output[compt,128]=output_HYDRO[date_select,7] # Moyenne des débits spécifiques au jour j de toutes les stations HYDRO d'une régime hydro donnée
              output[compt,129]=output_HYDRO[date_select,8] # Moyenne des débits spécifiques au jour j-1 de toutes les stations HYDRO d'une régime hydro donnée
              output[compt,130]=output_HYDRO[date_select,9] # Moyenne des débits spécifiques au jour j-2 de toutes les stations HYDRO d'une régime hydro donnée
              output[compt,131]=output_HYDRO[date_select,10] # Moyenne des débits spécifiques au jour j-3 de toutes les stations HYDRO d'une régime hydro donnée
              output[compt,132]=output_HYDRO[date_select,11] # Moyenne des débits spécifiques au jour j-4 de toutes les stations HYDRO d'une régime hydro donnée
              output[compt,133]=output_HYDRO[date_select,12] # Moyenne des débits spécifiques au jour j de toutes les stations HYDRO d'une régime hydro donnée
            } else {
              output[compt,123]=NA
              output[compt,124]=NA
              output[compt,125]=NA
              output[compt,126]=NA
              output[compt,127]=NA
              output[compt,128]=NA
              output[compt,129]=NA
              output[compt,130]=NA
              output[compt,131]=NA
              output[compt,132]=NA
              output[compt,133]=NA
            }
            output[compt,134]=mean(as.numeric(output[compt,123:133]))
          } else {
            output[compt,123]=NA
            output[compt,124]=NA
            output[compt,125]=NA
            output[compt,126]=NA
            output[compt,127]=NA
            output[compt,128]=NA
            output[compt,129]=NA
            output[compt,130]=NA
            output[compt,131]=NA
            output[compt,132]=NA
            output[compt,133]=NA
            output[compt,134]=NA
          }
          
          n_obs=n_obs+1
          output[compt,135]=HER # Numéro HER 2 d'après Wasson et al., 2002
          output[compt,136]=RH # Numéro Régime Hydro d'après Sauquet et al., 2008
        }
      }
    }
  }
  if (ncol(output)>0){
    colnames(output)<-c("Code_Onde","Altitude","Date","Mod_ecoulement","AI","REC_HIV","Q_J-1","Q_J-2","Q_J-3","Q_J-4","Q_J-5","Q_J-6","Q_J-7","Q_J-8","Q_J-9","Q_J-10","Q_J-11",
                        "PRCP_J","PRCP_J-1","PRCP_J-2","PRCP_J-3","PRCP_J-4","PRCP_J-5","PRCP_J-6","PRCP_J-7","PRCP_J-8","PRCP_J-9","PRCP_J-10",
                        "PRCP_J-11","PRCP_J-12","PRCP_J-13","PRCP_J-14","PRCP_J-15","PRCP_J-16","PRCP_J-17","PRCP_J-18","PRCP_J-19","PRCP_J-20",
                        "PRCP_J-21","PRCP_J-22","PRCP_J-23","PRCP_J-24","PRCP_J-25","PRCP_J-26","PRCP_J-27","PRCP_J-28","PRCP_J-29","PRCP_J-30",
                        "ETP_J","ETP_J-1","ETP_J-2","ETP_J-3","ETP_J-4","ETP_J-5","ETP_J-6","ETP_J-7","ETP_J-8","ETP_J-9","ETP_J-10",
                        "ETP_J-11","ETP_J-12","ETP_J-13","ETP_J-14","ETP_J-15","ETP_J-16","ETP_J-17","ETP_J-18","ETP_J-19","ETP_J-20",
                        "ETP_J-21","ETP_J-22","ETP_J-23","ETP_J-24","ETP_J-25","ETP_J-26","ETP_J-27","ETP_J-28","ETP_J-29","ETP_J-30",
                        "TA_J","TA_J-1","TA_J-2","TA_J-3","TA_J-4","TA_J-5","TA_J-6","TA_J-7","TA_J-8","TA_J-9","TA_J-10",
                        "TA_J-11","TA_J-12","TA_J-13","TA_J-14","TA_J-15","TA_J-16","TA_J-17","TA_J-18","TA_J-19","TA_J-20","TA_J-21",
                        "TA_J-22","TA_J-23","TA_J-24","TA_J-25","TA_J-26","TA_J-27","TA_J-28","TA_J-29","TA_J-30",
                        "FreqQ_J","FreqQ_J-1","FreqQ_J-2","FreqQ_J-3","FreqQ_J-4","FreqQ_J-5","FreqQ_J-6","FreqQ_J-7","FreqQ_J-8","FreqQ_J-9","FreqQ_J-10",'Moy_FreqQ',
                        "FreqGW_J","FreqGW_J-1","FreqGW_J-2","FreqGW_J-3","FreqGW_J-4","FreqGW_J-5","FreqGW_J-6","FreqGW_J-7","FreqGW_J-8","FreqGW_J-9","FreqGW_J-10","Moy_FreqGW","HER","RH")
    write.table(output,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_test_classif_HER_",HERc,"_30_jours_new_meteo_FINAL.txt", sep=""),sep=";", row.name=F,quote=F)
    
    output=read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_test_classif_HER_",HERc,"_30_jours_new_meteo_FINAL.txt", sep=""), header = T, sep = ";", row.names = NULL, quote="")
    output=output[,-c(7:17)]
    list=unique(output[,1])
    
    for (i in 1:length(list)){
      select=which(as.character(output[,1])==as.character(list[i]))
      
      for (id in 1:length(select)){
        # Calcul du Zeroqual par Mois
        no_flow=which((as.character(output[select,4])=="Ecoulement non visible" | as.character(output[select,4])=="Assec") & (format(as.Date(output[select,3],"%d/%m/%Y"),"%m")==format(as.Date(output[select[id],3],"%d/%m/%Y"),"%m")))
        flow=which((as.character(output[select,4])=="Ecoulement visible") & (format(as.Date(output[select,3],"%d/%m/%Y"),"%m")==format(as.Date(output[select[id],3],"%d/%m/%Y"),"%m")))
        
        # output[select[id],111]=mean(as.numeric(output[select[id],100:110]))
        output[select[id],126]=(length(no_flow)/(length(flow)+length(no_flow)))*100
        
        if (as.character(output[select[id],4])=="Ecoulement non visible" | as.character(output[select[id],4])=="Assec"){
          output[select[id],127]=1
        } else {
          output[select[id],127]=0
        }
      }
    }
    
    
    colnames(output)[126:127] <- c("%ZeroCalage","Bin_Assec")
    write.table(output,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_test_classif_HER_",HERc,"_30_jours_fin_new_meteo_FINAL.txt",sep=""),sep=";", row.name=F,quote=F)
    
    #----------------------------------------
    # Ajout de caractéristiques par stations
    #----------------------------------------
    output <- read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_test_classif_HER_",HERc,"_30_jours_fin_new_meteo_FINAL.txt", sep=""), sep=";", header = T, quote="", stringsAsFactors=F)
    
    nom_data <- paste("C:/Users/aurelien.beaufort/Documents/Onde/Données site/Test_4/Stations_ONDES_snap_corr_match_hydro_test4_50km_attrib.csv",sep="")
    liste <- read.table(file = nom_data, header = TRUE, sep = ";",  row.names = NULL, quote="")
    ref_nowak <- read.table("C:/Users/aurelien.beaufort/Documents/Onde/Referentiel_ONDE_NOWAK.csv", header = TRUE, sep = ";",  row.names = NULL, quote="")
    
    for (a in 1:nrow(output)){
      
      code <-as.character(output[a,1])
      repere = which(as.character(ref_nowak[,2])==code)
      repere2 = which(as.character(liste[,14])==code)
      
      if (length(repere) > 0){
        if (ref_nowak[repere,26] > 0 & !is.null(ref_nowak[repere,26]) & !is.na(ref_nowak[repere,26]) & ref_nowak[repere,26]!= 999){
          output[a,128]<-ref_nowak[repere,26] # Aire BV
        } else {
          if(length(repere2)>0){
            output[a,128]<-liste[repere2,26]
          }
        }
        if (ref_nowak[repere,23] > 0 & !is.null(ref_nowak[repere,23]) & !is.na(ref_nowak[repere,23]) & ref_nowak[repere,23]!= 999){
          output[a,129]<-ref_nowak[repere,23] # Distance à la source
        } else {
          output[a,129]<-NA
        }
      }
      
      if (length(repere2)>0){
        output[a,130]<-liste[repere2,27] # Pente
      }
    }
    
    colnames(output)[128:130]<-c("Aire_BV","PK_amont","Pente")
    write.table(output,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_Matrice/Input_test_classif_HER_",HERc,"_30_jours_fin_caract_new_meteo_FINAL.txt",sep=""),sep=";", row.name=F,quote=F)
  }
}