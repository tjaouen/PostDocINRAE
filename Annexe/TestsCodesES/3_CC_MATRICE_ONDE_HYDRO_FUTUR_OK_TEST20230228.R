#rm(list=ls())
source("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/2_AvecChangementClimatique_20230227/0_SimulationParameters_AvecCC_2_20230227.R")
source("/home/tjaouen/Documents/Src/PathsProgram/PathProgram_1_20230206.R")

library(hydroTSM)
library(ggplot2)
library(zoo)
#library(na.tools)

#-------------------------------------------------------------------------------
# Script permettant d'extraire le % d'assec, les Fr?quence au non d?passement et fr?quences au
# non d?passement moyen par hydro?cor?gion de niveau 2 et en fonction du r?gime hydrologique
# des cours d'eau sur lesquels sont localis?es les stations HYDRO et ONDE

# Bottet Quentin - Irstea - 12/09/2019 - Version 1
#-------------------------------------------------------------------------------
folder_onde_ = folder_onde_param_
folder_input_ = folder_input_param_
nom_FDC_ = nom_FDC_param_
obsSim_ = obsSim_param_

# Entr?e
dir.in = "/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/SauvegardeCodesES_20230215/Changement Clim/eric/"
dir.in.GCM <- c("bcc-csm1-1_rcp26_r1")

#dir.out = "C:/eric/CHANGEMENT CLIM 2019 (BOTTET)/Changement Clim/eric/"
#-------------------------------------------------------------------------------

for (inum in 1:length(dir.in.GCM)){
  
  output = data.frame()
  compteur = 0
  
  #hydro = read.table("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/SauvegardeCodesES_20230215/Changement Clim/eric/Stations_HYDRO_KGESUp0.60_DispSup-1.csv",sep=";",header=T)
  hydro = read.table("/home/tjaouen/Documents/Input/HYDRO/GR_Thirel_20230216/StationsSelectionnees/SelectionCsv/SelectionCsv_3_Essai568stations_2012_2018_20230224/Stations_HYDRO_KGESUp0.60_DispSup-1.csv",sep=";",header=T)
  hydro2 = hydro[-1,c(1,5:27)]
  colnames(hydro2) = c("Code","E1","E2","E3","E4","E5","E6","E7","E8","E9","E10","E11","E12","E13","E14","E15","E16","E17","E18","E19","E20","E21","ER","HER1")
  hydro = hydro[-1,c(1,2,3,27)]
  colnames(hydro) = c("Code","X","Y","HER1")
  
  onde = read.table(paste0(folder_ONDE_CorrespondanceHER_,"Liste_3302StationsONDES_snap_corr_REGIMEhydro_HER1et2_newRH.csv"), header = T, sep = ";", row.names = NULL, quote="")
  #onde = read.table("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/SauvegardeCodesES_20230215/Changement Clim/ONDE/Stations_ONDES_snap_corr_REGIME_hydro_HER2_new_RH.csv", header = T, sep = ";", row.names = NULL, quote="")
  onde = onde[,c(9,13,14,19)]
  colnames(onde) = c("Code","X","Y","HER1")
  
  HER1 = read.table(paste0(folder_HER_DataDescription_,"Hydroecoregion2_group.csv"), sep=";", header=T, quote="")
  #HER1 = read.table("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/SauvegardeCodesES_20230215/Changement Clim/ONDE/Hydroecoregion2_group.csv",sep=";",header=T,quote="")
  HER1 = HER1[,c(1,3)]
  list_HER1 = sort(unique(HER1[,1]))
  
  for (annee in c(2012)){
  #for (annee in 2012:2018){
    print(annee)
    ONDE <- read.table(paste0(folder_onde_, "onde_france_",annee,"/onde_france_",annee,".csv"), sep=";", header=T, fill=T, colClasses="character", quote="")  
    #ONDE <- read.table(paste("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/SauvegardeCodesES_20230215/Changement Clim/ONDE/Donnees ONDE/onde_france_",annee,"/onde_france_",annee,".csv",sep=""),sep=";",header=T,fill=T,colClasses="character",quote="")  
    
    ONDE_us <- ONDE[which(ONDE[,4]=="usuelle"),c(1,3,4,5,6)]
    colnames(ONDE_us) = c("Code","Annee","Type","Date","Observation")
    
    for(i in c(20:21)){
    #for(i in list_HER1){
      print(i)
      Select_hydro = hydro[which(as.numeric(as.vector(hydro2[,(i+1)]))>0),c("Code")]
      print(paste0("Selec = ",Select_hydro))
      
      #    Select_hydro = hydro[which(hydro$HER1 == i),c("Code")]
      Select_onde = onde[which(onde$HER1 == i),c("Code")]
      Weight_hydro <- as.numeric(as.vector(hydro2[which(as.numeric(as.vector(hydro2[,(i+1)]))>0),(i+1)]))
      print(paste0("Wei = ",Weight_hydro))
            
      #    Weight_hydro <- rep(1,length(Select_hydro))
      
      Obs_onde = ONDE_us[which(ONDE_us$Code %in% Select_onde),]
      
      if(nrow(Obs_onde) > 0){
        
        liste_mois <- sort(unique(format(as.Date(Obs_onde[,c("Date")], "%d/%m/%Y"),"%m")))
        
        for (date in 1:length(liste_mois)){
          obs_us=which(format(as.Date(Obs_onde[,c("Date")], "%d/%m/%Y"),"%m")==liste_mois[date])
          assec_us=which(format(as.Date(Obs_onde[,c("Date")], "%d/%m/%Y"),"%m")==liste_mois[date] & (Obs_onde[,c("Observation")]=="Assec" | Obs_onde[,c("Observation")]=="Ecoulement non visible"))
          
          # Calcul une date moyenne pour toutes les observations usuelles donn?es dans un mois
          jour_moy=round(mean(as.numeric((format(as.Date(Obs_onde[obs_us,c("Date")],format = "%d/%m/%Y"),"%d")))))
          
          if (jour_moy > 10) {
            date_moy=paste(jour_moy,"-",liste_mois[date],"-",annee,sep="")
          } else {
            date_moy=paste("0",jour_moy,"-",liste_mois[date],"-",annee,sep="")
          }
          
          
          if(length(Select_hydro) > 0 ){
            
            output_hydro = data.frame()
            compt = 0
            weightcompt = rep(0,13)
            
            for (st in 1:length(Select_hydro)){
              #st =1
              #code_hydro <- as.character(hydro[select_HYDRO1[select_HYDRO2[st]],2])
              
              #if (file.exists(paste0("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/SauvegardeCodesES_20230215/Changement Clim/eric/HYDRO/FDC FUT/",dir.in.GCM[inum],"/FDC_",Select_hydro[st],"_Sim.txt"))==TRUE){
              if (file.exists(paste0(folder_input_,"FlowDurationCurves/",presFut_param_,"/",ifelse(nom_FDC_=="",nomSim_,nom_FDC_),"/FDC_",Select_hydro[st],"_",obsSim_,".txt"))){
                  
                #st_hydro = read.table(paste0("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/SauvegardeCodesES_20230215/Changement Clim/eric/HYDRO/FDC FUT/",dir.in.GCM[inum],"/FDC_",Select_hydro[st],"_Sim.txt"), header = T, sep = ";", row.names = NULL, quote="")
                st_hydro = read.table(paste0(folder_input_,"FlowDurationCurves/",presFut_param_,"/",ifelse(nom_FDC_=="",nomSim_,nom_FDC_),"/FDC_",Select_hydro[st],"_",obsSim_,".txt"), header = T, sep = ";", row.names = NULL, quote="")
                
                # on transforme la date ONDE au format Hydro
                date_deb = paste0(substr(date_moy,7,10),"-",substr(date_moy,4,5),"-",substr(date_moy,1,2))
                print(date_deb)
                flow_cible = which(st_hydro[,1] == date_deb, arr.ind = TRUE)
                
                if (length(flow_cible)>0){
                  for(y in -6:6){
                    if(length(st_hydro[flow_cible[1]+y,2])> 0) {
                      if(flow_cible[1]+y<nrow(st_hydro) & flow_cible[1]+y >0 & !is.na(st_hydro[flow_cible[1]+y,2])) {
                        compt = compt + 1
                        weightcompt[(7+y)] = weightcompt[(7+y)]+Weight_hydro[st]
                        output_hydro[compt,y+7] = Weight_hydro[st]*st_hydro[flow_cible[1]+y,2]# Freq non d?passement des jours j-6 ? j+6
                        print(Weight_hydro[st])
                        print(weightcompt[(7+y)])
                        print(st_hydro[flow_cible[1]+y,2])
                        print(output_hydro[compt,y+7])
                        if (i == 21){
                          print(stooop)
                        }
                      }
                      else{
                        compt = compt + 1
                        output_hydro[compt,y+7] = NA
                      }
                    }
                    else{
                      print('JE SUIS LA')
                      compt = compt + 1
                      output_hydro[compt,y+7] = NA
                    }
                  }
                }
              }
            }  
            
            # On remplit la matrice finale
            compteur = compteur+1
            
            output[compteur,1] = i # Num?ro HER 1
            output[compteur,2] = date_moy # Date moyenne des obs usuelle ONDE utilis?e pour extraire les valeurs de d?bit
            output[compteur,3] = (length(assec_us)/length(obs_us))*100 # Calcul du pourcentage d'assec ? une date d'obs usuelle dans une HER
            
            if (nrow(output_hydro) > 0){
              print(sum(output_hydro[,1], na.rm = T))
              print(weightcompt[1])
              output[compteur,4]=sum(output_hydro[,1], na.rm = T)/weightcompt[1] # Moyenne des Fr?quence au non d?passement au jour j de toutes les stations HYDRO d'une HER1
              output[compteur,5]=sum(output_hydro[,2], na.rm = T)/weightcompt[2] # Moyenne des Fr?quence au non d?passement au jour j-1 de toutes les stations HYDRO d'une HER1
              output[compteur,6]=sum(output_hydro[,3], na.rm = T)/weightcompt[3] # Moyenne des Fr?quence au non d?passement au jour j-2 de toutes les stations HYDRO d'une HER1
              output[compteur,7]=sum(output_hydro[,4], na.rm = T)/weightcompt[4] # Moyenne des Fr?quence au non d?passement au jour j-3 de toutes les stations HYDRO d'une HER1
              output[compteur,8]=sum(output_hydro[,5], na.rm = T)/weightcompt[5] # Moyenne des Fr?quence au non d?passement au jour j-4 de toutes les stations HYDRO d'une HER1
              output[compteur,9]=sum(output_hydro[,6], na.rm = T)/weightcompt[6] # Moyenne des Fr?quence au non d?passement au jour j de toutes les stations HYDRO d'une HER1
              output[compteur,10]=sum(output_hydro[,7], na.rm = T)/weightcompt[7] # Moyenne des Fr?quence au non d?passement au jour j-1 de toutes les stations HYDRO d'une HER1
              output[compteur,11]=sum(output_hydro[,9], na.rm = T)/weightcompt[8] # Moyenne des Fr?quence au non d?passement au jour j-2 de toutes les stations HYDRO d'une HER1
              output[compteur,12]=sum(output_hydro[,9], na.rm = T)/weightcompt[9] # Moyenne des Fr?quence au non d?passement au jour j-3 de toutes les stations HYDRO d'une HER1
              output[compteur,13]=sum(output_hydro[,10], na.rm = T)/weightcompt[10] # Moyenne des Fr?quence au non d?passement au jour j-4 de toutes les stations HYDRO d'une HER1
              output[compteur,14]=sum(output_hydro[,11], na.rm = T)/weightcompt[11] # Moyenne des Fr?quence au non d?passement au jour j de toutes les stations HYDRO d'une HER1
              output[compteur,15]=sum(output_hydro[,12], na.rm = T)/weightcompt[12] # Moyenne des Fr?quence au non d?passement au jour j-1 de toutes les stations HYDRO d'une HER1
              output[compteur,16]=sum(output_hydro[,13], na.rm = T)/weightcompt[13] # Moyenne des Fr?quence au non d?passement au jour j-2 de toutes les stations HYDRO d'une HER1
            } else {
              output[compteur,4]=NA
              output[compteur,5]=NA
              output[compteur,6]=NA
              output[compteur,7]=NA
              output[compteur,8]=NA
              output[compteur,9]=NA
              output[compteur,10]=NA
              output[compteur,11]=NA
              output[compteur,12]=NA
              output[compteur,13]=NA
              output[compteur,14]=NA
              output[compteur,15]=NA
              output[compteur,16]=NA
            }
          } 
          else {
            compteur = compteur+1
            
            output[compteur,1]=liste_Her[id] # Num?ro HER
            output[compteur,4]=NA
            output[compteur,2]=date_moy # Date moyenne des obs usuelle ONDE utilis?e pour extraire les valeurs de d?bit
            output[compteur,3]=(length(assec_us)/length(obs_us))*100 # Calcul du pourcentage d'assec ? une date d'obs usuelle dans une HER
            output[compteur,5]=NA
            output[compteur,6]=NA
            output[compteur,7]=NA
            output[compteur,8]=NA
            output[compteur,9]=NA
            output[compteur,10]=NA
            output[compteur,11]=NA
            output[compteur,12]=NA
            output[compteur,13]=NA
            output[compteur,14]=NA
            output[compteur,15]=NA
            output[compteur,16]=NA
          }
        }
      }
    }
  }
  
  print(output)
  print(aaaa)
  colnames(output)<-c("HER1","Date","%_Assec","Freq_j+6","Freq_j+5","Freq_j+4","Freq_j+3","Freq_j+2","Freq_j+1","Freq_j","Freq_j-1","Freq_j-2","Freq_j-3","Freq_j-4","Freq_j-5","Freq_j-6")
  write.table(output, paste0("/home/tjaouen/Documents/Src/ChangementClimatique_Bottet2019/CodesTristan/TestsCodesES/",dir.in.GCM[inum],"_Matrice_KGESUp0.60_DispSup-1.csv"), sep=";", row.name=F, quote=F)
  
}
