#------------------------------------------------------------------------------------------------
#
#	Extraction des BFI
#
# /!\ Requiert l'importation du package zoo
#
# Arguments :
# - data = donn?es au format QJ
# - methode = choix de l'algorithme de s?paration d'hydrogramme (1 = Lyne et Hollick (1979), 
#             2 = Institut of Hydrology (1980))
#
# Sorties : liste contenant
# - Vecteur contenant la chronique de BFI par ann?es hydrologiques sans lacunes
# - BFI calcul? sur toute la p?riode d'observation
#
#------------------------------------------------------------------------------------------------

BFI=function(data,method){

  # Importe le package zoo
  library("zoo",character.only=TRUE)
  
  date=as.vector(data[,1])
  years=as.numeric(substr(date,1,4))		# Cr?ation d'un vecteur ann?e
  months=as.numeric(substr(date,5,6))		# Cr?ation d'un vecteur mois
  days=as.numeric(substr(date,7,8))		  # Cr?ation d'un vecteur jour
  date=as.numeric(date)				          # Cr?ation d'un vecteur date
  
  N=length(date)					# Longueur totale de la chronique en jour
  
  date_0=date[1]					# Date de d?but de la chronique
  date_N=date[N]					# Date de fin de la chronique
  year_0=years[1]					# Ann?e de d?but de la chronique
  year_N=years[N]					# Ann?e de fin de la chronique
  
  Q=as.numeric(as.vector(data[,2]))	  
  
  year_start=years[1]
  year_end=years[N]
  N_year=year_end-year_start+1
  
  # Convertit la chronique de d?bits moyen journalier en objet "time serie" ? partir de la premi?re ann?e compl?te observ?e
  
  ts_start=which(months==1 & days==1)
  ts_start=ts_start[1]
  ts_year_start=years[ts_start]			    # Premi?re ann?e compl?te observ?e
  
  ts_end=which(months==12 & days==31)
  ts_end=ts_end[length(ts_end)]
  ts_year_end=years[ts_end]				      # Derni?re ann?e compl?te observ?e
  
  N_year=(ts_year_end-ts_year_start)+1  # Nombre d'ann?e compl?tes de la chronique
  
  ts_Q=ts(Q[ts_start:N],frequency=365,start=ts_year_start,end=(ts_year_end+1))
  
  
  #-----------------------------------------#
  #	Disponibilit? des donn?es
  #-----------------------------------------#
  
  L=length(which(Q>=0)) 				 # Nombre d'observation au pas de temps journalier
  L_lac=N-L					             # Nombre d'observation manquantes au pas de temps journalier
  
  dispo=(1:N)*0
  dispo[which(Q>=0)]=1				   # Vecteur binaire de disponibilit? des donn?es (1 = donn?e disponible, 0 = donn?es manquante)
  
  date_lac=date[which(dispo==0)] # Vecteur contenant l'ensemble des dates pour lesquelles les donn?es sont manquantes
  
  dispo_year=NULL
  for(i in year_start:year_end){ # Loop 1
    l_year=length(which(years==i))                 # Nombre de jour dans l'ann?e examin?e
    test=length(which(dispo[which(years==i)]==1))	 # D?termine si l'ann?e est compl?te
    
    if(test==l_year){
      dispo_year=c(dispo_year,1)}
    
    if(test<l_year){
      dispo_year=c(dispo_year,0)}		# Vecteur binaire de disponibilit? des donn?es par ann?e (1 = ann?e sans lacune, 0 = ann?e avec lacune)
  }				# End Loop 1
  
  N_year_full=sum(dispo_year)		# Nombre d'ann?es compl?tes sans lacunes
  
  
  ### Disponibilit? des donn?es par ann?es hydrologiques ###
  dispo_H_year=H.year(data,"max",3)
  
  #start_H_year=dispo_H_year[[1]]        # Date de d?but de l'ann?e hydrologique (jour julien)
  H_years=dispo_H_year[[3]][,2]         # Vecteur de renum?rotation des ann?es civile en ann?e hydrologique
  N_H_year=max(H_years)                 # Nombre d'ann?es hydrologiques compl?tes
  N_H_year_full=dispo_H_year[[4]]       # Nombre d'ann?es hydrologiques compl?tes sans lacunes
  
  #---------------------------------------------------------------------------------------#
  #	Methode = 1 : D?termination du BFI (Algorithme de s?paration : Lyne et Hollick, 1979)
  #---------------------------------------------------------------------------------------#
  
  if(method==1){    # Loop method = 1
    
    k=0.925						# Param?tre du filtre : alpha (d?faut = 0.925)
    
    ### Algorithme de filtrage ###
    
    BF=NULL					               # Initialisation chronique de d?bit de base (BF = Base Flow)
    SF=0						               # Initialisation chronique de d?bit de surface (SF = Surface Flow)
    for(i in 2:N){
      
      if(is.na(Q[i])=="TRUE"){			 #
        SF=c(SF,0)					           # Traitement lacunes au pas de temps i (SF = 0 et BF = NA par d?faut)
        BF=c(BF,NA)}					         #
      
      if(is.na(Q[i])=="FALSE"){
        if(is.na(Q[i-1])=="TRUE"){		 #
          SF=c(SF,0)					           # Traitement lacunes au pas de temps (i-1) (SF = 0 et BF = NA par d?faut)
          BF=c(BF,NA)}					         #
        
        if(is.na(Q[i-1])=="FALSE"){
          SF=c(SF,(k*SF[i-1]+((1+k)*(Q[i]-Q[i-1]))/2))	    # Calcul de SF au pas de temps i
          if(SF[i]<0){SF[i]=0}				                      # Condition sur SF < 0 remplac? par 0
          BF=c(BF,Q[i]-SF[i])}				                      # Calcul de BF au pas de temps i
      }
    }
    
    ### Calcul du BFI ###
    
    BFI=sum(BF,na.rm=TRUE)/sum(Q,na.rm=TRUE)	        # Base Flow Index
    
    ### BFI annuels ###
    
    BFI_y=NULL							                          # Initialisation de la chronique des BFI annuels (Ann?es compl?tes)
    for(i in 1:N_H_year){
      test=length(which(dispo[which(H_years==i)]==0))	  # D?termine si l'ann?e hydrologique est compl?te (sans lacunes)
      
      if(test==0){
        BFI_y=c(BFI_y,sum(BF[which(H_years==i)],na.rm=TRUE)/sum(Q[which(H_years==i)],na.rm=TRUE))}
      
      if(test>0){
        BFI_y=c(BFI_y,NA)}	                              # Ann?es hydrologiques avec lacunes (BFI = NA)
    }
    
    BFI_y=cbind(1:N_H_year,BFI_y)					            # Chronique des BFI annuels (Ann?es compl?tes)
    
  }               # End loop method = 1
  
  #---------------------------------------------------------------------------------------#
  #	Methode = 2 : D?termination du BFI (Algorithme de s?paration : Institut of Hydrology, 1980)
  #---------------------------------------------------------------------------------------#
  
  if(method==2){    # Loop method = 2
    
    d=5						                         # Interval pour la recherche du d?bit minimum local (d?faut d = 5 jours)
    k=0.9						                       # Param?tre de pond?ration (d?faut = 0.9)
    
    ### Recherche des minimum locaux ###
    
    min_d=NULL
    for(i in 1:(N/d)){
      X=(i*d+1):((i+1)*d)
      Y=Q[X]						                     # S?lection des d?bits observ?s durant l'interval d
      min=which(Y==min(Y))				           # D?termination du d?bit minimum local
      min=min[1]					                   # /!\ S?lection du premier minimum local
      min_d=rbind(min_d,c(X[min],Y[min]))		 # Chronique des minimum locaux
    }
    
    
    ### Recherche des point pivots ###
    
    pivot=NULL
    for(i in 2:(length(min_d[,1])-1)){		 # Exclut la premi?re et la derni?re donn?e
      
      test1=k*min_d[i,2]<min_d[i-1,2]			   # Test si min_d[i-1] > min_d[i] < min_d[i+1]
      test2=k*min_d[i,2]<min_d[i+1,2]
      
      if(is.na(test1)=="FALSE"){			       # Condition 1 pour le traitement des lacunes
        if(is.na(test2)=="FALSE"){			       # Condition 2 pour le traitement des lacunes
          
          if(test1=="TRUE"){
            if(test2=="TRUE"){
              pivot=rbind(pivot,min_d[i,])}}			   # Chronique des points pivots
        }}
    }
    
    ### Constitution de la chronique de d?bit de base ###
    
    interp=approx(pivot[,1],pivot[,2],xout=1:N)	   # Interpole lin?airement entre les point pivots et fournit une valeur en chaque point de la chronique
    
    BF=interp$y					                           # Chronique des d?bits de base
    for(i in 1:N){
      if(is.na(BF[i])=="FALSE"){
        if(is.na(Q[i])=="FALSE"){
          if(BF[i]<0){BF[i]=0}				                   # Condition si l'interpolation fournit des valeurs < 0 : BF = 0
          if(BF[i]>Q[i]){BF[i]=Q[i]}}			               # Condition si l'interpolation fournit des valeurs > Qobs : BF = Qobs
        if(is.na(Q[i])=="TRUE"){BF[i]=NA}		           # Traitement des lacunes : BF = NA
      }
    }
    
    ### Calcul du BFI ###
    
    BFI=sum(BF,na.rm=TRUE)/sum(Q,na.rm=TRUE)	     # Base Flow Index
    
    ### BFI annuels ###
    
    BFI_y=NULL							                            # Initialisation de la chronique des BFI annuels (Ann?es compl?tes)
    for(i in 1:N_H_year){
      test=length(which(dispo[which(H_years==i)]==0))			# D?termine si l'ann?e hydrologique est compl?te (sans lacunes)
      
      if(test==0){
        BFI_y=c(BFI_y,sum(BF[which(H_years==i)],na.rm=TRUE)/sum(Q[which(H_years==i)],na.rm=TRUE))}
      
      if(test>0){
        BFI_y=c(BFI_y,NA)}	                                # Ann?es hydrologiques avec lacunes (BFI = NA)
    }
    
    BFI_y=cbind(1:N_H_year,BFI_y)					              # Chronique des BFI annuels (Ann?es compl?tes)
    
  }               # End loop method = 2
  
  #-------------------------------------------------------------------------------
  # Mise en forme des r?sultats de sortie
  #-------------------------------------------------------------------------------
  
  Out=list("Chronique des BFI par annees hydrologiques"=BFI_y," BFI interannuel"=BFI)
  # Out=list("Chronique des BFI par ann?es hydrologiques"=BFI_y,"BFI interannuel"=BFI)
  return(Out)

}           # End FUNCTION



