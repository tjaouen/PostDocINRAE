#----------------------------------------------------------------------------------------
# Permet de lire les donn?es hydro ? la date de l'observation ONDE
# bas? sur les stations s?lectionn?es suite au test 3 et sort un 
# fichier par ann?e + r?alise une courbe des d?bits class?s + hydrogramme
#
# S?lectionne les stations ? traiter en fonction du rapport des superficie 
# entre la station ONDE et la station Hydro match?e
#
# N?cessite d'avoir les d?bits jusqu'en 2016 disponibles dans le dossier "export_2016"
# version 3 plus rapide que la version 2 car charge directement les fr?quences au non d?passement
# des d?bits et des niveaux pi?zom?triques directement calcul?s
#
#         !!! Remplace les NA par des 0 en 2016 ? corriger !!!!
#----------------------------------------------------------------------------------------
rm(list=ls())

### Programmes ###
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH/1_Parameters/0_SimulationParameters_AvecCC_2_20230227_Run2.R")

seuil<-0 # en l/s

library(lubridate)
library(hydroTSM)
library(ggplot2)
library(tidyr)
library(dplyr)
library(strex)
library(zoo)

listeStSafran<-read.table("/home/tjaouen/Documents/Input/ONDE/Data_Description/VentilationSafranClimat/statOnde2018.txt", sep = " ", header = F,  row.names = NULL, quote="")
listeStMaille<-read.table("/home/tjaouen/Documents/Input/ONDE/Data_Description/VentilationSafranClimat/PropSurfaceSafran_2_20240912.txt", sep=";", header = T, row.names = NULL)
listeStRecharge<-read.table("/home/tjaouen/Documents/Input/ONDE/Data_Description/VentilationRecharge/Ventilation_SiteONDE_RechargePotentielle_1_20241001.csv", sep=";", header = T)

list_safran_ <- c("/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/PRCP_2010_2011.txt",
                  "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/PRCP_2011_2012.txt",
                  "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/PRCP_2012_2013.txt",
                  "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/PRCP_2013_2014.txt",
                  "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/PRCP_2014_2015.txt",
                  "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/PRCP_2015_2016.txt",
                  "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/PRCP_2016_2017.txt",
                  "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/PRCP_2017_2018.txt",
                  "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/PRCP_2018_2019.txt",
                  "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/PRCP_2019_2020.txt",
                  "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/PRCP_2020_2021.txt",
                  "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/PRCP_2021_2022.txt")

list_ETP_ <- c("/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/ETP_2010_2011.txt",
               "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/ETP_2011_2012.txt",
               "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/ETP_2012_2013.txt",
               "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/ETP_2013_2014.txt",
               "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/ETP_2014_2015.txt",
               "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/ETP_2015_2016.txt",
               "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/ETP_2016_2017.txt",
               "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/ETP_2017_2018.txt",
               "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/ETP_2018_2019.txt",
               "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/ETP_2019_2020.txt",
               "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/ETP_2020_2021.txt",
               "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/ETP_2021_2022.txt")

list_TEMP_ <- c("/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/T_2010_2011.txt",
                "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/T_2011_2012.txt",
                "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/T_2012_2013.txt",
                "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/T_2013_2014.txt",
                "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/T_2014_2015.txt",
                "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/T_2015_2016.txt",
                "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/T_2016_2017.txt",
                "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/T_2017_2018.txt",
                "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/T_2018_2019.txt",
                "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/T_2019_2020.txt",
                "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/T_2020_2021.txt",
                "/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/T_2021_2022.txt")

# Bilan_PRCP=read.table("/home/tjaouen/Documents/Input/Climat/SAFRAN_2010_2022/"
# Users/aurelien.beaufort/Documents/SAFRAN/Moy_PRCP_1958_2016.txt",sep=";",header=T)

hydro <- read.table("/home/tjaouen/Documents/Input/HYDRO/EtudeFrance/StationsSelectionnees/SelectionCsv/SelectionCsv_30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/Stations_HYDRO_KGESUp0.00_DispSup-1_2.csv", header = T, sep = ";", row.names = NULL, quote="")
colnames(hydro) <- gsub("X","",colnames(hydro))
onde <- read.table("/home/tjaouen/Documents/Input/ONDE/Data_Description/CorrespondanceOndeHer/HER2hybrides/Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2hybrides_newRH_3_20230331.csv", header = T, sep = ",", dec = ".", row.names = NULL, quote="")

# liste <- read.table("/home/tjaouen/Documents/Input/ONDE/Data_Description/DescriptionSites/Surf_ONDE_4_AjoutMetadonneesManquantes_VentilationSafranClim_20240909.csv", header = T, sep = ";", row.names = NULL, quote="")

# lecture par annee de suivi
metaData_complet <- read.table(paste("/home/tjaouen/Documents/Input/ONDE/Data_Versions/Data_VersionParSites/DonneesOnde_VersionParSites_TJ01_20240617.csv",sep=""),sep=";",header=T,fill=T,colClasses="character")
liste_exclusions <- read.table("/home/tjaouen/Documents/Input/ONDE/Data_DatesAjustees/ONDE_ListeCampagnesUsuellesExclues.csv",sep=";",dec=".",header=T)
dim(metaData_complet) # dim = 174099 10
dim(metaData_complet[which(metaData_complet$CdHER2 ==  str_before_first(str_after_first(liste_exclusions$HER_AnneeMois,"HER"),"_")
                           & year(metaData_complet$Date) == str_before_first(str_after_first(liste_exclusions$HER_AnneeMois,"_"),"/")
                           & month(metaData_complet$Date) == str_after_first(liste_exclusions$HER_AnneeMois,"/")),]) # dim = 43 10
dim(metaData_complet[which(!(metaData_complet$CdHER2 ==  str_before_first(str_after_first(liste_exclusions$HER_AnneeMois,"HER"),"_")
                             & year(metaData_complet$Date) == str_before_first(str_after_first(liste_exclusions$HER_AnneeMois,"_"),"/")
                             & month(metaData_complet$Date) == str_after_first(liste_exclusions$HER_AnneeMois,"/"))),]) # dim = 174056
metaData_complet <- metaData_complet[which(!(metaData_complet$CdHER2 ==  str_before_first(str_after_first(liste_exclusions$HER_AnneeMois,"HER"),"_")
                                             & year(metaData_complet$Date) == str_before_first(str_after_first(liste_exclusions$HER_AnneeMois,"_"),"/")
                                             & month(metaData_complet$Date) == str_after_first(liste_exclusions$HER_AnneeMois,"/"))),]

# HER2 <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/HER/Hydroecoregion2_group.csv",sep=";",header=T,quote="")
HER2 <- HER_param_
HER2 <- HER2[which(!(HER2 %in% c(10,18,19,20)))]

# annees <- c(2015:2022)
# annees <- c(2022)
annees <- c(2012:2022)

# HERc=85
# HERc=62
# HERc = 3

recharge_ <- read.table()

for(annee in annees){
  
  safran_5 <- read.table(list_safran_[grep(annee,str_after_last(list_safran_,"/"))[1]], sep =";",dec=".",header = T)
  colnames(safran_5) <- as.Date(gsub("X","",colnames(safran_5)), format = "%Y.%m.%d")
  if (!is.na(grep(annee,str_after_last(list_safran_,"/"))[2])){
    safran_6 <- read.table(list_safran_[grep(annee,str_after_last(list_safran_,"/"))[2]], sep =";",dec=".",header = T)
    colnames(safran_6) <- as.Date(gsub("X","",colnames(safran_6)), format = "%Y.%m.%d")
  }
  ETP_5 <- read.table(list_ETP_[grep(annee,str_after_last(list_ETP_,"/"))[1]], sep =";",dec=".",header = T)
  colnames(ETP_5) <- as.Date(gsub("X","",colnames(ETP_5)), format = "%Y.%m.%d")
  if (!is.na(grep(annee,str_after_last(list_ETP_,"/"))[2])){
    ETP_6 <- read.table(list_ETP_[grep(annee,str_after_last(list_ETP_,"/"))[2]], sep =";",dec=".",header = T)
    colnames(ETP_6) <- as.Date(gsub("X","",colnames(ETP_6)), format = "%Y.%m.%d")
  }
  TEMP_5 <- read.table(list_TEMP_[grep(annee,str_after_last(list_TEMP_,"/"))[1]], sep =";",dec=".",header = T)
  colnames(TEMP_5) <- as.Date(gsub("X","",colnames(TEMP_5)), format = "%Y.%m.%d")
  if (!is.na(grep(annee,str_after_last(list_TEMP_,"/"))[2])){
    TEMP_6 <- read.table(list_TEMP_[grep(annee,str_after_last(list_TEMP_,"/"))[2]], sep =";",dec=".",header = T)
    colnames(TEMP_6) <- as.Date(gsub("X","",colnames(TEMP_6)), format = "%Y.%m.%d")
  }
  
  for (HERc in HER2){ #[1]
    
    id <- 0
    compt=0
    output<-data.frame()
    
    metaData_complet_HER_ <- metaData_complet[which(metaData_complet$CdHER2 == HERc),]
    metaData <- metaData_complet[which(metaData_complet$Annee == annee & as.Date(metaData_complet$Date) <= "2022-07-31"),]
    
    while(id < length(unique(metaData_complet_HER_$Code))){
      
      id=id+1
      print(id)
      code_ONDE <- unique(metaData_complet_HER_$Code)[id]
      ligne_st <- which(as.character(onde$Code) == code_ONDE)
      
      # HER <- unique(metaData_complet$CdHER2[which(metaData_complet$Code == code_ONDE)])
      print("ATTENTION - CHOIX DE LA COLONNE RH DANS TABLE ONDE.")
      RH <- onde$RH_new_modif[ligne_st]
      HER <- HERc
      
      # on cherche le nombre d'obervation ONDE dispo sur une ann?e
      row_st=which(metaData$Code==code_ONDE, arr.ind = TRUE)
      n_obs=1
      
      while(n_obs <= length(row_st)){
        
        compt=compt+1
        output[compt,1]<-code_ONDE
        # output[compt,2] <- liste$altitude[id] #altitude
        output[compt,2] <- liste$altitude[which(liste$F_CdSiteHy == code_ONDE)] #altitude
        date_onde<-as.character(metaData$Date[row_st[n_obs]])
        output[compt,3] <- date_onde
        
        # if(date_onde != ""){
        
        # Chargement des donn?es Safran
        # safran_data<-safran_5
        # etp_data<-ETP_5
        # Temp_data<-TEMP_5
        # safran_data2<-safran_6
        # etp_data2<-ETP_6
        # Temp_data2<-TEMP_6
        
        # repere=which(as.Date(colnames(safran_data)) == as.Date(date_onde))
        # if (length(repere)==0){repere=-10}
        # repere2=which(as.Date(colnames(safran_data2)) == as.Date(date_onde))
        # if (length(repere2)==0){repere2=-10}
        # }
        
        output[compt,4]<-metaData$Observation[row_st[n_obs]] # ajout de la modalit? d'?coulement ONDE
        output[compt,5]<- NA #debExtract[flow_cible[1],2] # ajout du d?bit mesur? correspondant
        output[compt,6]<-NA #debExtract[flow_cible[1],2] # ajout du d?bit sp?cifique jour J
        output[compt,7]<-NA #debExtract[(flow_cible[1]-1),2] # ajout du d?bit sp?cifique jour J-1
        output[compt,8]<-NA #debExtract[(flow_cible[1]-2),2] # ajout du d?bit sp?cifique jour J-2
        output[compt,9]<-NA #debExtract[(flow_cible[1]-3),2] # ajout du d?bit sp?cifique jour J-3
        output[compt,10]<-NA #debExtract[(flow_cible[1]-4),2] # ajout du d?bit sp?cifique jour J-4
        output[compt,11]<-NA #debExtract[(flow_cible[1]-5),2] # ajout du d?bit sp?cifique jour J-5
        output[compt,12]<-NA #debExtract[(flow_cible[1]),3] # ajout de la Fr?quence de non d?passement du d?bit jour J
        output[compt,13]<-NA #debExtract[(flow_cible[1]-1),3] # ajout de la Fr?quence de non d?passement du d?bit jour J
        output[compt,14]<-NA #debExtract[(flow_cible[1]-2),3] # ajout de la Fr?quence de non d?passement du d?bit jour J
        output[compt,15]<-NA #debExtract[(flow_cible[1]-3),3] # ajout de la Fr?quence de non d?passement du d?bit jour J
        output[compt,16]<-NA #debExtract[(flow_cible[1]-4),3] # ajout de la Fr?quence de non d?passement du d?bit jour J
        output[compt,17]<-NA #[(flow_cible[1]-5),3] # ajout de la Fr?quence de non d?passement du d?bit jour J
        
        # On cherche la position de la station dans la liste des stations index?es avec une maille SAFRAN
        ligneSt<-which(as.character(listeStSafran[,1])==code_ONDE)
        
        if(date_onde != "" & length(ligneSt) > 0){
          
          x_st=listeStSafran[ligneSt,2]
          y_st=listeStSafran[ligneSt,3]
          
          # On cherche les mailles pr?sentent dans le BV de la station et leur contribution
          indexMaille<-which(as.character(listeStMaille$Name) == code_ONDE)
          
          for (a in 18:110){
            output[compt,a] <- NA
          }
          
          for (index in 1:length(indexMaille)){
            
            ratio <- as.numeric(as.character(listeStMaille$SurfCont[indexMaille[index]])) / as.numeric(as.character(listeStMaille$SurfaceT[indexMaille[index]])) # Surface contributive de la maille pour une station
            # VOIR COMMENT EST CALCULE
            
            jour=0
            while (jour <= 30){
              date_ <- as.Date(date_onde)-jour
              if (sum(grepl(date_,colnames(safran_5)))>0){
                output[compt,(18+jour)] <- as.numeric(safran_5[[as.character(date_)]][as.numeric(listeStMaille$NumMaill[indexMaille[index]])])*ratio + ifelse(is.na(output[compt,(18+jour)]),0,output[compt,(18+jour)])
              }else if (sum(grepl(date_,colnames(safran_6)))>0){
                output[compt,(18+jour)] <- as.numeric(safran_6[[as.character(date_)]][as.numeric(listeStMaille$NumMaill[indexMaille[index]])])*ratio + ifelse(is.na(output[compt,(18+jour)]),0,output[compt,(18+jour)])
              }
              # if((repere-jour)>0){
              #   output[compt,(18+jour)] <- as.numeric(as.character(safran_data[as.numeric(listeStMaille$NumMaill[indexMaille[index]]),(repere-jour)]))*ratio + ifelse(is.na(output[compt,(18+jour)]),0,output[compt,(18+jour)])
              # } else if((repere-jour)<=0 & (repere2-jour)>0){
              #   output[compt,(18+jour)] <- as.numeric(as.character(safran_data2[as.numeric(listeStMaille$NumMaill[indexMaille[index]]),(repere2-jour)]))*ratio + ifelse(is.na(output[compt,(18+jour)]),0,output[compt,(18+jour)])
              # }
              jour=jour+1
            }
            
            jour=0
            while (jour <= 30){
              date_ <- as.Date(date_onde)-jour
              if (sum(grepl(date_,colnames(ETP_5)))>0){
                output[compt,(49+jour)] <- as.numeric(ETP_5[[as.character(date_)]][as.numeric(listeStMaille$NumMaill[indexMaille[index]])])*ratio + ifelse(is.na(output[compt,(49+jour)]),0,output[compt,(49+jour)])
              }else if (sum(grepl(date_,colnames(ETP_6)))>0){
                output[compt,(49+jour)] <- as.numeric(ETP_6[[as.character(date_)]][as.numeric(listeStMaille$NumMaill[indexMaille[index]])])*ratio + ifelse(is.na(output[compt,(49+jour)]),0,output[compt,(49+jour)])
              }
              # if((repere-jour)>0){
              #   output[compt,(49+jour)] <- as.numeric(as.character(etp_data[as.numeric(listeStMaille$NumMaill[indexMaille[index]]),(repere-jour)]))*ratio + ifelse(is.na(output[compt,(49+jour)]),0,output[compt,(49+jour)])
              # } else if((repere-jour)<=0 & (repere2-jour)>0){
              #   output[compt,(49+jour)] <- as.numeric(as.character(etp_data2[as.numeric(listeStMaille$NumMaill[indexMaille[index]]),(repere2-jour)]))*ratio + ifelse(is.na(output[compt,(49+jour)]),0,output[compt,(49+jour)])
              # }
              jour=jour+1
            }
            
            jour=0
            while (jour <= 30){
              date_ <- as.Date(date_onde)-jour
              if (sum(grepl(date_,colnames(TEMP_5)))>0){
                output[compt,(80+jour)] <- as.numeric(TEMP_5[[as.character(date_)]][as.numeric(listeStMaille$NumMaill[indexMaille[index]])])*ratio + ifelse(is.na(output[compt,(80+jour)]),0,output[compt,(80+jour)])
              }else if (sum(grepl(date_,colnames(TEMP_6)))>0){
                output[compt,(80+jour)] <- as.numeric(TEMP_6[[as.character(date_)]][as.numeric(listeStMaille$NumMaill[indexMaille[index]])])*ratio + ifelse(is.na(output[compt,(80+jour)]),0,output[compt,(80+jour)])
              }
              # if((repere-jour)>0){
              #   output[compt,(80+jour)] <- as.numeric(as.character(Temp_data[as.numeric(listeStMaille$NumMaill[indexMaille[index]]),(repere-jour)]))*ratio + ifelse(is.na(output[compt,(80+jour)]),0,output[compt,(80+jour)])
              # } else if((repere-jour)<=0 & (repere2-jour)>0){
              #   output[compt,(80+jour)] <- as.numeric(as.character(Temp_data2[as.numeric(listeStMaille$NumMaill[indexMaille[index]]),(repere2-jour)]))*ratio + ifelse(is.na(output[compt,(80+jour)]),0,output[compt,(80+jour)])
              # }
              jour=jour+1
            }
            # }
          }
        } else {
          for (a in 18:110){
            output[compt,a]<-NA
          }
        }
        
        #------------------------------
        # calcul de l'indice d'aridit?
        #------------------------------
        
        if (format(as.Date(date_onde), "%Y")==annee){
          m=as.numeric(listeStMaille$NumMaill[indexMaille[index]])
          P <- sum(as.numeric(safran_5[m,which(month(colnames(safran_5)) >= 1 & month(colnames(safran_5)) <= 7 & year(colnames(safran_5)) == annee)]))
          E <- sum(as.numeric(ETP_5[m,which(month(colnames(ETP_5)) >= 1 & month(colnames(ETP_5)) <= 7 & year(colnames(ETP_5)) == annee)]))
          AI<-P/E
        }
        output[compt,5] <- AI
        
        #----------------------------------------------------
        # Calcul anomalies recharche nappe HIVER
        #----------------------------------------------------
        # m=as.numeric(listeStMaille[indexMaille[index],4])
        # if (format(as.Date(date_onde), "%Y")==2017){
        #   REC<-sum(as.numeric(safran_6[m,123:245]))
        # }
        # output[compt,6]<- REC/Bilan_PRCP[m,14]
        
        #----------------------------------------------------
        # Calcul des fr?quences au non d?passement Q
        #----------------------------------------------------
        
        if (file.exists(paste("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/9_PredictionParSiteONDE/Neural_Network/Data/Freq_",annee,"_",HER,"_",indexMaille[index],"_HYDRO_ONLY.txt",sep=""))){
          output_HYDRO<-read.table(paste("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/9_PredictionParSiteONDE/Neural_Network/Data/Freq_",annee,"_",HER,"_",indexMaille[index],"_HYDRO_ONLY.txt",sep=""),sep=";",header=T)
          
          date_select<-which(as.Date(output_HYDRO$Date)==as.Date(date_onde))
          
          if (length(date_select)>0){
            output$V111[compt]=output_HYDRO$J0[date_select] # Moyenne des d?bits sp?cifiques au jour j de toutes les stations HYDRO d'une r?gime hydro donn?e
            output$V112[compt]=output_HYDRO$J1[date_select] # Moyenne des d?bits sp?cifiques au jour j-1 de toutes les stations HYDRO d'une r?gime hydro donn?e
            output$V113[compt]=output_HYDRO$J2[date_select] # Moyenne des d?bits sp?cifiques au jour j-2 de toutes les stations HYDRO d'une r?gime hydro donn?e
            output$V114[compt]=output_HYDRO$J3[date_select] # Moyenne des d?bits sp?cifiques au jour j-3 de toutes les stations HYDRO d'une r?gime hydro donn?e
            output$V115[compt]=output_HYDRO$J4[date_select] # Moyenne des d?bits sp?cifiques au jour j-4 de toutes les stations HYDRO d'une r?gime hydro donn?e
            output$V116[compt]=output_HYDRO$J5[date_select] # Moyenne des d?bits sp?cifiques au jour j de toutes les stations HYDRO d'une r?gime hydro donn?e
            output$V117[compt]=output_HYDRO$J6[date_select] # Moyenne des d?bits sp?cifiques au jour j-1 de toutes les stations HYDRO d'une r?gime hydro donn?e
            output$V118[compt]=output_HYDRO$J7[date_select] # Moyenne des d?bits sp?cifiques au jour j-2 de toutes les stations HYDRO d'une r?gime hydro donn?e
            output$V119[compt]=output_HYDRO$J8[date_select] # Moyenne des d?bits sp?cifiques au jour j-3 de toutes les stations HYDRO d'une r?gime hydro donn?e
            output$V120[compt]=output_HYDRO$J9[date_select] # Moyenne des d?bits sp?cifiques au jour j-4 de toutes les stations HYDRO d'une r?gime hydro donn?e
            output$V121[compt]=output_HYDRO$J10[date_select] # Moyenne des d?bits sp?cifiques au jour j de toutes les stations HYDRO d'une r?gime hydro donn?e
          } else {
            output$V111[compt]=NA
            output$V112[compt]=NA
            output$V113[compt]=NA
            output$V114[compt]=NA
            output$V115[compt]=NA
            output$V116[compt]=NA
            output$V117[compt]=NA
            output$V118[compt]=NA
            output$V119[compt]=NA
            output$V120[compt]=NA
            output$V121[compt]=NA
          }
          output$V122[compt]=mean(as.numeric(output[compt,111:121]))
        } else {
          output$V111[compt]=NA
          output$V112[compt]=NA
          output$V113[compt]=NA
          output$V114[compt]=NA
          output$V115[compt]=NA
          output$V116[compt]=NA
          output$V117[compt]=NA
          output$V118[compt]=NA
          output$V119[compt]=NA
          output$V120[compt]=NA
          output$V121[compt]=NA
          output$V122[compt]=NA
        }
        
        #----------------------------------------------------
        # Calcul des fr?quences au non d?passement GW
        #----------------------------------------------------
        
        if (file.exists(paste("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/23_PredictionParSiteONDE_PremierTest/Input/Data/Freq_PiezoOnly/Freq_",annee,"_",HER,"_",indexMaille[index],"_PIEZO_ONLY.txt",sep=""))){
          
          output_HYDRO<-read.table(paste("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/23_PredictionParSiteONDE_PremierTest/Input/Data/Freq_PiezoOnly/Freq_",annee,"_",HER,"_",indexMaille[index],"_PIEZO_ONLY.txt",sep=""),sep=";",header=T)
          date_select<-which(as.Date(output_HYDRO$Date)==as.Date(date_onde))
          
          if (length(date_select)>0){
            output$V123[compt]=output_HYDRO$J0[date_select] # Moyenne des d?bits sp?cifiques au jour j de toutes les stations HYDRO d'une r?gime hydro donn?e
            output$V124[compt]=output_HYDRO$J1[date_select] # Moyenne des d?bits sp?cifiques au jour j-1 de toutes les stations HYDRO d'une r?gime hydro donn?e
            output$V125[compt]=output_HYDRO$J2[date_select] # Moyenne des d?bits sp?cifiques au jour j-2 de toutes les stations HYDRO d'une r?gime hydro donn?e
            output$V126[compt]=output_HYDRO$J3[date_select] # Moyenne des d?bits sp?cifiques au jour j-3 de toutes les stations HYDRO d'une r?gime hydro donn?e
            output$V127[compt]=output_HYDRO$J4[date_select] # Moyenne des d?bits sp?cifiques au jour j-4 de toutes les stations HYDRO d'une r?gime hydro donn?e
            output$V128[compt]=output_HYDRO$J5[date_select] # Moyenne des d?bits sp?cifiques au jour j de toutes les stations HYDRO d'une r?gime hydro donn?e
            output$V129[compt]=output_HYDRO$J6[date_select] # Moyenne des d?bits sp?cifiques au jour j-1 de toutes les stations HYDRO d'une r?gime hydro donn?e
            output$V130[compt]=output_HYDRO$J7[date_select] # Moyenne des d?bits sp?cifiques au jour j-2 de toutes les stations HYDRO d'une r?gime hydro donn?e
            output$V131[compt]=output_HYDRO$J8[date_select] # Moyenne des d?bits sp?cifiques au jour j-3 de toutes les stations HYDRO d'une r?gime hydro donn?e
            output$V132[compt]=output_HYDRO$J9[date_select] # Moyenne des d?bits sp?cifiques au jour j-4 de toutes les stations HYDRO d'une r?gime hydro donn?e
            output$V133[compt]=output_HYDRO$J10[date_select] # Moyenne des d?bits sp?cifiques au jour j de toutes les stations HYDRO d'une r?gime hydro donn?e
          } else {
            output$V123[compt]=NA
            output$V124[compt]=NA
            output$V125[compt]=NA
            output$V126[compt]=NA
            output$V127[compt]=NA
            output$V128[compt]=NA
            output$V129[compt]=NA
            output$V130[compt]=NA
            output$V131[compt]=NA
            output$V132[compt]=NA
            output$V133[compt]=NA
          }
          output[compt,134]=mean(as.numeric(output[compt,123:133]))
        } else {
          output$V123[compt]=NA
          output$V124[compt]=NA
          output$V125[compt]=NA
          output$V126[compt]=NA
          output$V127[compt]=NA
          output$V128[compt]=NA
          output$V129[compt]=NA
          output$V130[compt]=NA
          output$V131[compt]=NA
          output$V132[compt]=NA
          output$V133[compt]=NA
          output$V134[compt]=NA
        }
        
        n_obs=n_obs+1
        output$V135[compt]=HER # Num?ro HER 2 d'apr?s Wasson et al., 2002
        output$V136[compt]=RH # Num?ro R?gime Hydro d'apr?s Sauquet et al., 2008
      }
    }
    
    if (ncol(output)>0){
      colnames(output)<-c("Code_Onde","Altitude","Date","Mod_ecoulement","AI_JanvJuil","REC_HIV","Q_J-1","Q_J-2","Q_J-3","Q_J-4","Q_J-5","Q_J-6","Q_J-7","Q_J-8","Q_J-9","Q_J-10","Q_J-11",
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
      output=output[,-c(7:17)]
    }
    
    write.table(output,paste("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/23_PredictionParSiteONDE_PremierTest/Input/Data/InputTestClassif/Input_test_classif_HER_",HERc,"_annee",annee,"_30_jours_fin_caract_new_meteo_FINAL.txt",sep=""),sep=";", row.name=F,quote=F)
    # }
  }
}



for (HERc in HER2){ # [1]
  
  list_files_ <- list.files("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/23_PredictionParSiteONDE_PremierTest/Input/Data/InputTestClassif/", pattern=paste0("Input_test_classif_HER_",HERc,"_annee"), full.names = T)
  output <- data.frame()
  for (f_ in list_files_){
    output <- rbind(output,read.table(f_, sep = ";", dec = ".", header = T))
  }
  
  if (ncol(output)>0){
    
    list=unique(output$Code_Onde)
    
    for (i in 1:length(list)){
      select=which(as.character(output$Code_Onde)==as.character(list[i]))
      
      for (id in 1:length(select)){
        # Calcul du Zeroqual par Mois
        no_flow=which((as.character(output$Mod_ecoulement[select])=="Ecoulement non visible" | as.character(output$Mod_ecoulement[select])=="Assec") &
                        (format(as.Date(output$Date[select],"%Y-%m-%d"),"%m")==format(as.Date(output$Date[select[id]],"%Y-%m-%d"),"%m")))
        flow=which((as.character(output$Mod_ecoulement[select])=="Ecoulement visible" | as.character(output$Mod_ecoulement[select])=="Ecoulement visible acceptable" | as.character(output$Mod_ecoulement[select])=="Ecoulement visible faible") &
                     (format(as.Date(output$Date[select],"%Y-%m-%d"),"%m")==format(as.Date(output$Date[select[id]],"%Y-%m-%d"),"%m")))
        
        if (length(no_flow) == 0 & length(flow) == 0){
          print(HERc)
          print(annee)
          print(output$Code_Onde[select[id]])
          print(output$Date[select[id]])
          print(id)
          
          if (output$Mod_ecoulement[select[which((format(as.Date(output$Date[select],"%Y-%m-%d"),"%m")==format(as.Date(output$Date[select[id]],"%Y-%m-%d"),"%m")))]] != "Observation impossible"){
            print(aaaa)
          }
          
        }
        
        output[select[id],126]=(length(no_flow)/(length(flow)+length(no_flow)))*100
        
        if (as.character(output$Mod_ecoulement[select[id]])=="Ecoulement non visible" | as.character(output$Mod_ecoulement[select[id]])=="Assec"){
          output[select[id],127]=1
        } else{
          output[select[id],127]=0
        }
      }
    }
    
    colnames(output)[126:127] <- c("PourcentZeroCalage","Bin_Assec")
    
    #----------------------------------------
    # Ajout de caract?ristiques par stations
    #----------------------------------------
    for (a in 1:nrow(output)){
      output[a,128] <- liste$Surf_BV[which(liste$F_CdSiteHy == output$Code_Onde[a])]
      output[a,129] <- NA # PK amont
      output[a,130] <- liste$Pente[which(liste$F_CdSiteHy == output$Code_Onde[a])]
    }
    
    colnames(output)[128:130]<-c("Aire_BV","PK_amont","Pente")
    
    # output <- output %>%
    #   arrange(Code_Onde, month(Date))
    output <- output %>%
      arrange(Code_Onde, Date)
  }
  # write.table(output,paste("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/23_PredictionParSiteONDE_PremierTest/Input/Data/InputTestClassif/Input_test_classif_HER_",HERc,"_30_jours_fin_caract_new_meteo_FINAL.txt",sep=""),sep=";", row.name=F,quote=F)
  write.table(output,paste("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/23_PredictionParSiteONDE_PremierTest/Input/Data/InputTestClassif/Input_test_classif_HER_",HERc,"_30_jours_fin_caract_new_meteo_FINAL.csv",sep=""),sep=";", row.name=F,quote=F)
}










# ### Control ###
# tab_new_ <- read.table("/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/23_PredictionParSiteONDE_PremierTest/Input/Data/InputTestClassif/Input_test_classif_HER_66_annee2017_30_jours_fin_caract_new_meteo_FINAL.txt",sep=";",dec=".",header=T)
# tab_old_ <- read.table("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/9_PredictionParSiteONDE/Neural_Network/Data_save/Input_Matrice_2017_save/Input_test_classif_HER_66_30_jours_fin_caract_new_meteo_FINAL.txt",sep=";",dec=".",header=T)
# 
# tab_old_comp_ <- tab_old_[which(tab_old_$Date %in% tab_new_$Date),]
# 
# dim(tab_new_)
# dim(tab_old_comp_)
# 
# tab_new_$Code_Onde == tab_old_comp_$Code_Onde
# dim(tab_new_)
# dim(tab_old_comp_)
# colnames(tab_new_)
# colnames(tab_old_comp_) <- colnames(tab_new_)
# 
# tab_new_$Aire_BV
# tab_old_comp_$Aire_BV
# 
# are_equal <- all_equal(tab_new_, tab_old_comp_, ignore_col_order = FALSE, ignore_row_order = FALSE)
