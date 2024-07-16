#-------------------------------------------------------------------------------
# Calcul les frequences de non depassement pour les stations HYDRO
# Bottet Quentin - Irstea - 10/09/2019 - Version 1
#-------------------------------------------------------------------------------

### Librairies ###
library(doParallel)
library(lubridate)
library(hydroTSM)
# library(rgdal)
library(strex)

### Programmes ###
source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/PathsProgram/PathProgram_1_20230206.R")
source("/lustre/jaouent/Src/ChangementClimatique_Bottet2019/CodesTristan/8_RunsEtudeFrance_ApresCorrectionNcdfLH_MESO/1_Parameters_MESO/0_SimulationParameters_AvecCC_2_20230227_MESO.R")

### Study data ###
folder_input_ = folder_input_param_
obsSim_ = obsSim_param_
nomSim_ = nomSim_param_
date_variable_name_ = "Date"
FDC_dateBorneMin_ = FDC_dateBorneMin_param_
FDC_dateBorneMax_ = FDC_dateBorneMax_param_
nom_categorieSimu_ = nom_categorieSimu_param_


liste_GCM_ = list.files(paste0(folder_input_,"/Debits/Debits",
                               ifelse(obsSim_=="","",obsSim_),"/",
                               "NetcdfNotMerged_CorrLocPointsLH_20231123_FormatTxt/",
                               ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),"/"), full.names = T)

### Run ###
# cl <- makePSOCKcluster(detectCores()/2-1)
cl <- makePSOCKcluster(2)
registerDoParallel(cores=cl)

output <- foreach(folder_GCM_ = liste_GCM_) %dopar% { #, errorhandling='pass'
  
  liste = list.files(folder_GCM_, pattern = ".txt|.Rdata", full.names = T)
  # liste <- liste[201:length(liste)]
  
  for(i in liste){
    
    if (grepl("\\.Rdata",i)){
      tab_ = get(load(i))
      flow = data.frame(Date = tab_$Chron$Date, Qls = tab_$Chron$Qls)
      colnames(flow) <- c("Date","Debit")
      debit_variable_name_ = "Debit"
    }else{
      flow = read.table(i, header=T, sep=";")
      # flow$Qmmj[which(flow$Qmmj == -99)] = NA
      # flow$Qls[which(flow$Qls == -99)] = NA
      flow$Qm3s1[which(flow$Qm3s1 == -99)] = NA
      # debit_variable_name_ = "Qls"
      debit_variable_name_ = "Qm3s1"
    }
    
    flow$Date <- parse_date_time(flow$Date, orders = c("Ymd","dmY"))
    
    # Borner le flow entre deux dates
    if (!(is.null(FDC_dateBorneMin_param_))){
      flow <- flow[which((as.Date(flow$Date, format = "%Y-%m-%d") >= as.Date(FDC_dateBorneMin_, format = "%Y-%m-%d")) & (as.Date(flow$Date, format = "%Y-%m-%d") <= as.Date(FDC_dateBorneMax_, format = "%Y-%m-%d"))),]
    }
    fdcurve <- fdc(as.numeric((flow[, debit_variable_name_])),plot=F,lQ.thr=0.95,hQ.thr=0.2,ylab="Q [l/s]")
    
    # Creation d'un matrice avec date/debit/debit spe/% de depassement du debit -> Correction ? Creation d'un matrice avec date/frequence de non depassement/debit
    debExtract = flow[, date_variable_name_]
    debExtract = as.data.frame(cbind(Date = format(debExtract, "%Y%m%d"),
                                     FreqNonDep = 1-fdcurve,
                                     Debit = flow[, debit_variable_name_],
                                     Type = flow$Type))
    
    if (!(dir.exists(paste0(folder_input_,
                            "FlowDurationCurves/",
                            ifelse(obsSim_=="","",paste0("FDC_",obsSim_,"/")),
                            ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),
                            str_after_last(folder_GCM_,"/"),"/")))){
      dir.create(paste0(folder_input_,
                        "FlowDurationCurves/",
                        ifelse(obsSim_=="","",paste0("FDC_",obsSim_,"/")),
                        ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),
                        str_after_last(folder_GCM_,"/"),"/"))
    }
    
    if (".Rdata" %in% i){
      write.table(debExtract, paste0(folder_input_,
                                     "FlowDurationCurves/",
                                     ifelse(obsSim_=="","",paste0("FDC_",obsSim_,"/")),
                                     ifelse(nom_categorieSimu_=="","",nom_categorieSimu_),
                                     str_after_last(folder_GCM_,"/"),
                                     "/FDC_",sub("\\..*", "", basename(i)),".Rdata"), sep=";", row.name=F, quote=F)
    }else{
      write.table(debExtract, paste0(folder_input_,
                                     "FlowDurationCurves/",
                                     ifelse(obsSim_=="","",paste0("FDC_",obsSim_,"/")),
                                     ifelse(nom_categorieSimu_=="","",paste0(nom_categorieSimu_,"/")),
                                     str_after_last(folder_GCM_,"/"),
                                     "/FDC_",sub("\\..*", "", basename(i)),".txt"), sep=";", row.name=F, quote=F)
    }
  }
}

# Arreter le cluster doParallel
stopCluster(cl)
# beep(1)
