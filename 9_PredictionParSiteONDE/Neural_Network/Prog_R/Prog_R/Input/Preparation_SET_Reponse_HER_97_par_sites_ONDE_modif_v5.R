#----------------------------------------------------------------------------------------
# Extrait toutes les variables explicatives nécessaires à prédictions des assecs 
# sur 30 jours nécessaires aux prédictions aux sites ONDE
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
Piezo <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/Bd ades/Piezo_echange_hydro_BRGM_final_L2E_HER2_inertie_faible_group.csv", header = T, sep = ";", row.names = NULL, quote="")

onde <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/RHT/Stations_ONDES_snap_corr_REGIME_hydro_HER2_group.csv", header = T, sep = ";", row.names = NULL, quote="")

nom_data <- paste("C:/Users/aurelien.beaufort/Documents/Onde/Données site/Test_4/Stations_ONDES_snap_corr_match_hydro_test4_50km_attrib.csv",sep="")
liste <- read.table(file = nom_data, header = TRUE, sep = ";",  row.names = NULL, quote="")
HER2 <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/HER/Hydroecoregion2_group.csv",sep=";",header=T,quote="")

Bilan_PRCP=read.table("C:/Users/aurelien.beaufort/Documents/SAFRAN/Moy_PRCP_1958_2016.txt",sep=";",header=T)

id<-1

T1<-Sys.time()

while(id < nrow(liste)) { # 
  
  id=id+1
  
  code_ONDE <- liste[id,14]
  ligne_st=which(as.character(onde[,9]) == code_ONDE)
  HER = onde[ligne_st,18]
  RH = onde[ligne_st,17]
  
  # if(HER==105){
    
    print(id)
    position=which(HER2[,3]==HER)
    
    compt=0
    output<-data.frame()
    n_obs=0
    obs_tot=153*5

    while(n_obs < obs_tot){
      compt=compt+1
      output[compt,1]<-code_ONDE
      output[compt,2] <- liste[id,22] #altitude
      if (n_obs<153){
        date_onde=format(as.Date(paste("01/05/2012",sep = ""), "%d/%m/%Y")+n_obs,"%d/%m/%Y")
      } else if (n_obs > 152 & n_obs < 306){
        date_onde=format(as.Date(paste("30/04/2013",sep = ""), "%d/%m/%Y")+(n_obs-152),"%d/%m/%Y")
      } else if (n_obs > 305 & n_obs < 459){
        date_onde=format(as.Date(paste("30/04/2014",sep = ""), "%d/%m/%Y")+(n_obs-305),"%d/%m/%Y")
      } else if (n_obs > 458 & n_obs < 612){
        date_onde=format(as.Date(paste("30/04/2015",sep = ""), "%d/%m/%Y")+(n_obs-458),"%d/%m/%Y")
      } else if (n_obs > 611 & n_obs < 765){
        date_onde=format(as.Date(paste("30/04/2016",sep = ""), "%d/%m/%Y")+(n_obs-611),"%d/%m/%Y")
      }
      
      output[compt,3] <- date_onde
      
      if(date_onde != ""){
        
        # on transforme la date ONDE au format Safran
        date_onde<-paste(substr(date_onde,7,10),"-",substr(date_onde,4,5),"-",substr(date_onde,1,2),sep = "")
        # date_onde<-"2012-08-01"
        # Chargement des données Safran 
        if (format(as.Date(date_onde), "%Y")==2012 | format(as.Date(date_onde), "%Y")==2016){
          if (format(as.Date(date_onde), "%j")<214){
            if(format(as.Date(date_onde), "%Y")==2012){
              safran_data<-safran_1
              etp_data<-ETP_1
              Temp_data<-TEMP_1
            } else if (format(as.Date(date_onde), "%Y")==2016){
              safran_data<-safran_5
              etp_data<-ETP_5
              Temp_data<-TEMP_5
            }
            repere=as.numeric(format(as.Date(date_onde), "%j"))+153
          } else if (format(as.Date(date_onde), "%j")>213){
            if(format(as.Date(date_onde), "%Y")==2012){
              safran_data<-safran_2
              etp_data<-ETP_2
              Temp_data<-TEMP_2
            } else if (format(as.Date(date_onde), "%Y")==2016){
              safran_data<-safran_6
              etp_data<-ETP_6
              Temp_data<-TEMP_6
            }
            repere=as.numeric(format(as.Date(date_onde), "%j"))-213
          }
        } else {
          if (format(as.Date(date_onde), "%j") < 213){
            if(format(as.Date(date_onde), "%Y") == 2013){
              safran_data<-safran_2
              etp_data<-ETP_2
              Temp_data<-TEMP_2
            } else if (format(as.Date(date_onde), "%Y")==2014){
              safran_data<-safran_3
              etp_data<-ETP_3
              Temp_data<-TEMP_3
            } else if (format(as.Date(date_onde), "%Y")==2015){
              safran_data<-safran_4
              etp_data<-ETP_4
              Temp_data<-TEMP_4
            }
            repere=as.numeric(format(as.Date(date_onde), "%j"))+153
          } else if (format(as.Date(date_onde), "%j")>212){
            if(format(as.Date(date_onde), "%Y")==2013){
              safran_data<-safran_3
              etp_data<-ETP_3
              Temp_data<-TEMP_3
            } else if (format(as.Date(date_onde), "%Y")==2014){
              safran_data<-safran_4
              etp_data<-ETP_4
              Temp_data<-TEMP_4
            } else if (format(as.Date(date_onde), "%Y")==2015){
              safran_data<-safran_5
              etp_data<-ETP_5
              Temp_data<-TEMP_5
            }
            repere=as.numeric(format(as.Date(date_onde), "%j"))-212
          }
        }
      }
      
      output[compt,4]<-NA
      
      # On cherche la position de la station dans la liste des stations indexées avec une maille SAFRAN
      ligneSt<-which(as.character(listeStSafran[,1])==code_ONDE)
      
      if(date_onde != "" & length(ligneSt) > 0){
        
        x_st=listeStSafran[ligneSt,2]
        y_st=listeStSafran[ligneSt,3]
        
        # On cherche les mailles présentent dans le BV de la station et leur contribution
        # indexMaille<-which(as.numeric(as.character(listeStMaille[,1]))==x_st & as.numeric(as.character(listeStMaille[,2]))==y_st)
        indexMaille<-which(as.character(listeStMaille[,6]) == code_ONDE)
        
        #------------------------------
        # calcul de l'indice d'aridité
        #------------------------------
        
        if (format(as.Date(date_onde), "%Y")==2012){
          m=as.numeric(as.numeric(listeStMaille[indexMaille[1],4])+1)
          P<-sum(as.numeric(safran_1[m,154:366]))+sum(as.numeric(safran_2[m,1:153]))
          E<-sum(as.numeric(ETP_1[m,154:366]))+sum(as.numeric(ETP_2[m,1:153]))
          AI<-P/E
        } else if (format(as.Date(date_onde), "%Y")==2013){
          m=as.numeric(as.numeric(listeStMaille[indexMaille[1],4])+1)
          P<-sum(as.numeric(safran_2[m,154:365]))+sum(as.numeric(safran_3[m,1:153]))
          E<-sum(as.numeric(ETP_2[m,154:365]))+sum(as.numeric(ETP_3[m,1:153]))
          AI<-P/E
        } else if (format(as.Date(date_onde), "%Y")==2014){
          m=as.numeric(as.numeric(listeStMaille[indexMaille[1],4])+1)
          P<-sum(as.numeric(safran_3[m,154:365]))+sum(as.numeric(safran_4[m,1:153]))
          E<-sum(as.numeric(ETP_3[m,154:365]))+sum(as.numeric(ETP_4[m,1:153]))
          AI<-P/E
        } else if (format(as.Date(date_onde), "%Y")==2015){
          m=as.numeric(as.numeric(listeStMaille[indexMaille[1],4])+1)
          P<-sum(as.numeric(safran_4[m,154:365]))+sum(as.numeric(safran_5[m,1:153]))
          E<-sum(as.numeric(ETP_4[m,154:365]))+sum(as.numeric(ETP_5[m,1:153]))
          AI<-P/E
        } else if (format(as.Date(date_onde), "%Y")==2016){
          m=as.numeric(as.numeric(listeStMaille[indexMaille[1],4])+1)
          P<-sum(as.numeric(safran_5[m,154:365]))+sum(as.numeric(safran_6[m,1:153]))
          E<-sum(as.numeric(ETP_5[m,154:365]))+sum(as.numeric(ETP_6[m,1:153]))
          AI<-P/E
        }
        output[compt,5]<- AI
        
        #----------------------------------------------------
        # Calcul anomalies recharche nappe HIVER
        #----------------------------------------------------
        m=as.numeric(listeStMaille[indexMaille[1],4])+1
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
        
        for (a in 7:99){
          output[compt,a] <- 0
        }
        
        for (index in 1:length(indexMaille)){
          
          ratio <- as.numeric(as.character(listeStMaille[indexMaille[index],5])) / as.numeric(as.character(listeStMaille[indexMaille[index],3])) # Surface contributive de la maille pour une station
          
          if(format(as.Date(date_onde), "%Y")==2017 & format(as.Date(date_onde), "%j") > 213){
            
            for (a in 7:99){
              output[compt,a] <- NA
            }
            
          } else {
            
            if (compt==1 | compt==154 | compt==307 | compt==460 | compt==613) {
              #PRCP
              for (e in 0:30){
                output[compt,(7+e)] <- as.numeric(as.character(safran_data[as.numeric(listeStMaille[indexMaille[index],4])+1,(repere-e)]))*ratio + output[compt,(7+e)]
              }
              # ETP
              for (f in 0:30){
                output[compt,(38+f)] <- as.numeric(as.character(etp_data[as.numeric(listeStMaille[indexMaille[index],4])+1,(repere-f)]))*ratio + output[compt,(38+f)]
              }
              # TAIR
              for (g in 0:30){
                output[compt,(69+g)] <- as.numeric(as.character(Temp_data[as.numeric(listeStMaille[indexMaille[index],4])+1,(repere-g)]))*ratio + output[compt,(69+g)]
              }
            } else {
              #PRCP
              output[compt,7] <- as.numeric(as.character(safran_data[as.numeric(listeStMaille[indexMaille[index],4])+1,(repere)]))*ratio + output[compt,7]
              output[compt,8:37] <- output[(compt-1),7:36]
              # ETP
              output[compt,38] <- as.numeric(as.character(etp_data[as.numeric(listeStMaille[indexMaille[index],4])+1,(repere)]))*ratio + output[compt,38]
              output[compt,39:68] <- output[(compt-1),38:67]
              # TAIR
              output[compt,69] <- as.numeric(as.character(Temp_data[as.numeric(listeStMaille[indexMaille[index],4])+1,(repere)]))*ratio + output[compt,69]
              output[compt,70:99] <- output[(compt-1),69:98]
            }
            # }
          }
        } # boucle maille
      } else {
        for (a in 5:99){
          output[compt,a] <- NA
        }
      }
      
      #----------------------------------------------------
      # Calcul des fréquences au non dépassement Q
      #----------------------------------------------------
      if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Freq_2012_2016_HER_HR/Freq_2012_2016_",HER,"_",RH,"_HYDRO_ONLY.txt",sep=""))==TRUE){
        output_HYDRO<-read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Freq_2012_2016_HER_HR/Freq_2012_2016_",HER,"_",RH,"_HYDRO_ONLY.txt",sep=""),sep=";",header=T)
        date_select<-which(as.character(output_HYDRO[,1])==date_onde)
        
        if (nrow(output_HYDRO)>0){
          for (h in 1:11){
            output[compt,(99+h)] = output_HYDRO[date_select,(h+1)] # Moyenne des débits spécifiques au jour j de toutes les stations HYDRO d'une régime hydro donnée
          }
        } else {
          for (h in 1:11){
            output[compt,(99+h)] = NA
          }
        }
        output[compt,111] = mean(as.numeric(output[compt,100:110]))
      } else {
        for (h in 1:11){
          output[compt,(99+h)] = NA
        }
        output[compt,111] = NA
      }
      
      #----------------------------------------------------
      # Calcul des fréquences au non dépassement GW
      #----------------------------------------------------
      if (file.exists(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Freq_2012_2016_HER_HR/Freq_2012_2016_",HER,"_",RH,"_PIEZO_ONLY.txt",sep=""))==TRUE){
        output_HYDRO<-read.table(paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Freq_2012_2016_HER_HR/Freq_2012_2016_",HER,"_",RH,"_PIEZO_ONLY.txt",sep=""),sep=";",header=T)
        date_select<-which(as.character(output_HYDRO[,1])==date_onde)
        
        if (nrow(output_HYDRO)>0){
          for (h in 1:11){
            output[compt,(111+h)] = output_HYDRO[date_select,(h+1)] # Moyenne des débits spécifiques au jour j de tous les piézo d'une HER donnée
          }
        } else {
          for (h in 1:11){
            output[compt,(111+h)] = NA
          }
        }
        output[compt,123] = mean(as.numeric(output[compt,112:122]))
      } else {
        for (h in 1:11){
          output[compt,(111+h)] = NA
        }
        output[compt,123] = NA
      }
      n_obs=n_obs+1
    } # HER2
    colnames(output)<-c("Code_Onde","Altitude","Date","Mod_ecoulement","AI","REC_HIV",
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
                        "FreqGW_J","FreqGW_J-1","FreqGW_J-2","FreqGW_J-3","FreqGW_J-4","FreqGW_J-5","FreqGW_J-6","FreqGW_J-7","FreqGW_J-8","FreqGW_J-9","FreqGW_J-10","Moy_FreqGW")
    
    write.table(output,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Var_exp_station_NEW_30J_ALL/Input_",code_ONDE,".txt",sep=""),sep=";", row.name=F,quote=F)
    
    T2 <- Sys.time()
    Tdiff = difftime(T2, T1)
    print(Tdiff)
  # } # Condition HER
} # Liste stations