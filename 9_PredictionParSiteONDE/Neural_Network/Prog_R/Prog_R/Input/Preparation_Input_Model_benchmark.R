#---------------------------------------------
# Preparation input modèle simple naif
#---------------------------------------------
rm(list=ls())
nom_data <- paste("C:/Users/aurelien.beaufort/Documents/Onde/Données site/Test_4/Stations_ONDES_snap_corr_match_hydro_test4_50km_attrib.csv",sep="")
liste <- read.table(file = nom_data, header = TRUE, sep = ";",  row.names = NULL, quote="")
onde <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/RHT/Stations_ONDES_snap_corr_REGIME_hydro_HER2_group.csv", header = T, sep = ";", row.names = NULL, quote="")
HER2 <- read.table("C:/Users/aurelien.beaufort/Documents/SIG/HER/Hydroecoregion2_group.csv",sep=";",header=T,quote="")

for (HERc in HER2[,3]){
  id<-0
  compt=0
  output<-data.frame()
  if (length(which(onde[,18]==HERc))>0){
    while(id < nrow(liste)) {
      
      id=id+1
      code_ONDE <- liste[id,14]
      ligne_st=which(as.character(onde[,9]) == code_ONDE)
      HER = onde[ligne_st,18]
      
      if(HER==HERc){
        
        for(annee in 2012:2017){
          
          # lecture par annee de suivi
          if (annee==2017){
            metaData<-read.table(paste("C:/Users/aurelien.beaufort/Documents/Onde/Données site/onde_france_",annee,"/onde_france_",annee,".csv",sep=""),sep=";",header=T,fill=T,colClasses="character",quote="")  
          } else {
            metaData<-read.table(paste("C:/Users/aurelien.beaufort/Documents/Onde/Données site/onde_france_",annee,"/onde_france_",annee,".csv",sep=""),sep=";",header=T,fill=T,colClasses="character",quote="")  
          }
          # on cherche le nombre d'obervation ONDE dispo sur une année
          row_st<-which(metaData[,1]==code_ONDE & as.character(metaData[,4])=="usuelle")
          
          if (length(row_st)>0){
            for (nobs in 1:length(row_st)){
              compt=compt+1
              output[compt,1]=code_ONDE
              output[compt,2]=metaData[row_st[nobs],5]
              if (as.character(metaData[row_st[nobs],8])=="Ecoulement visible"){
                output[compt,3]=0
              } else if (as.character(metaData[row_st[nobs],8])=="Ecoulement non visible" | as.character(metaData[row_st[nobs],8])=="Assec"){
                output[compt,3]=1
              }
            }
          }
        }
      }
    }
    colnames(output)[1:3]<-c("Code_Onde","Date","Assec_bin")
    write.table(output,paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/Data/Input_model_benchmark/Input_test_model_simple_usuelle_",HERc,".txt",sep=""),sep=";", row.name=F,quote=F)
  }
} # boucle HER2

