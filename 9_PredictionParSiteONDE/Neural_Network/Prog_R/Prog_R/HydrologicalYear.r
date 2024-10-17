#-------------------------------------------------------------------------------------------------------------------------------------
#
#	Fonction permettant d'identifier le d?but de l'ann?e hydrologique centr?e sur la p?riode d'?tiage selon plusieurs proc?dures
#
#	Arguments :
#	- data = donn?es au format QJ
#	- m?thode = "min" pour l'identification de la date de d?but d'ann?e hydrologique comme la date plac?e 6 mois avant la date du minimum annuel
#	          = "max" pour l'identification de la date de d?but d'ann?e hydrologique comme la date du maximum annuel
#	- type = (1) pour l'identification de la date de d?but d'ann?e hydrologique ? partir des d?bits moyens mensuels interannuels
#        = (2) pour l'identification de la date de d?but d'ann?e hydrologique ? partir des dates moyennes des QMXA ou QMNA
#        = (3) pour l'identification de la date de d?but d'ann?e hydrologique ? partir des d?bits moyens journaliers interannuels
#
#	Sorties : liste contenant
#	- La valeur de la date de d?but d'ann?e hydrologique exprim?e en jour Julien (entre 1 et 366)
# - Le rang des dates de d?but et fin d'ann?e hydrologique
# - Un vecteur donnant l'?quivalence entre ann?es civiles et ann?es hydrologiques (une donn?e pour chaque observation)
# - Le nombre d'ann?es hydrologiques compl?tes sans lacunes
#
#-------------------------------------------------------------------------------------------------------------------------------------

H.year=function(data,method,type){

# Exclut la ligne de m?ta-donn?es

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

Q=as.numeric(as.vector(data[,2]))	  # Cr?ation d'un vecteur d?bit (m3/s)

year_start=years[1]                 # Premi?re ann?e de la chronique
year_end=years[N]                   # Derni?re ann?e de la chronique
N_year=year_end-year_start+1        # Nombre d'ann?e total


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
for(i in year_start:year_end){
l_year=length(which(years==i))                 # Nombre de jour dans l'ann?e examin?e

if(l_year>=365){
dispo_year=c(dispo_year,1)}

if(l_year<365){
dispo_year=c(dispo_year,0)}		# Vecteur binaire de disponibilit? des donn?es par ann?e (1 = ann?e sans lacune, 0 = ann?e avec lacune)
}

N_year_full=sum(dispo_year)		# Nombre d'ann?es compl?tes sans lacunes


#-------------------------------------------------------------------------------------------------------------------------------------
# TYPE1 = Identification de la date de d?but d'ann?e hydrologique ? partir des d?bits moyens mensuels interannuels
#-------------------------------------------------------------------------------------------------------------------------------------

if(type==1){  # Loop type=1

#---------------------------------------------------#
#	Extraction des d?bits moyens mensuels
#---------------------------------------------------#
QM_y=NULL							# Initialisation de la chronique de d?bits moyens mensuels (Mois complets)
for(i in year_start:year_end){

for(j in 1:12){
test=length(which(dispo[which(years==i & months==j)]==0))	# D?termine si le mois est complet

if(test==0){
QM_y=rbind(QM_y,c(i,j,mean(Q[which(years==i & months==j)])))}	# Calcul du d?bit moyen mensuel (Mois complets)

if(test>0){
QM_y=rbind(QM_y,c(i,j,NA))}					# Mois incomplets : QM_t = NA
}
}
#-----------------------------------------------------------------#
#	Extraction des d?bits moyens mensuels interannuels
#-----------------------------------------------------------------#

QM=NULL								# D?bits moyens mensuels interannuels
for(i in 1:12){
QM=c(QM,mean(QM_y[which(QM_y[,2]==i),3],na.rm=TRUE))}

var_QM=sd(QM)/mean(QM)						# Coefficient de variation des d?bits moyens mensuels interannuels

#---------------------------------------------------------------------------------------------------------------------------#
#	D?finition de l'ann?e hydrologique (mois correspondant au maximum des d?bits moyens mensuels interannuel)
#---------------------------------------------------------------------------------------------------------------------------#

if(method=="max"){            # Loop method="max"

month_start=which(QM==max(QM))				# Mois pour lequel le d?bit moyen mensuel est maximal (date de d?but de l'ann?e hydrologique au quinzi?me jour du mois)
day_start=15

### Disponibilit? des donn?es par ann?es hydrologiques

starts=which(months==month_start & days==day_start)	  # Dates de d?but des ann?es hydrologiques
ends=starts[-1]-1					                            # Dates de fin des ann?es hydrologiques
starts=starts[-length(starts)]

j_start=starts[1]-ts_start				                    # Jour calendaire du d?but d'ann?e hydrologique

N_H_year=length(starts)				                        # Nombre d'ann?e hydrologiques compl?tes de la chronique

H_years=years*0
for(i in 1:N_H_year){
H_years[starts[i]:ends[i]]=i}			                    # Renum?rotation des dates selon leur appartenance ? une ann?e hydrologique

year_to_H_year=1:(N_H_year+1)-(month_start-1)/12-1	  # Coordonn?es du d?but d'ann?e civile selon la num?rotation des ann?es hydrologiques

if(month_start==1){
year_to_H_year=1:(N_H_year)-(month_start-1)/12-1}

dispo_H_year=NULL					                            # Vecteur binaire de disponibilit? des donn?es par ann?e hydrologique (1 = ann?e sans lacune, 0 = ann?e avce lacune)
for(i in 1:N_H_year){	# Loop 1
test=length(which(dispo[which(H_years==i)]==0))	      # D?termine si l'ann?e est compl?te

if(test==0){
dispo_H_year=c(dispo_H_year,1)}

if(test>0){
dispo_H_year=c(dispo_H_year,0)}

}				# End Loop 1

N_H_year_full=sum(dispo_H_year)			                  # Nombre d'ann?es hydrologiques compl?tes sans lacunes
}              # End Loop method="max"


if(method=="min"){            # Loop method="min"
test=which(QM==min(QM))				# Mois pour lequel le d?bit moyen mensuel est minimal

if(test<=6){month_start=test+6}		  # Mois de d?but de l'ann?e hydrologique
if(test>6){month_start=test-6}			#
day_start=15					              # Quinzi?me jour du mois (par d?faut = jour de d?but de l'ann?e hydrologique)

### Disponibilit? des donn?es par ann?es hydrologiques

starts=which(months==month_start & days==day_start)	# Dates de d?but des ann?es hydrologiques
ends=starts[-1]-1					                          # Dates de fin des ann?es hydrologiques
starts=starts[-length(starts)]

j_start=starts[1]-ts_start				                  # Jour calendaire du d?but d'ann?e hydrologique

N_H_year=length(starts)				                      # Nombre d'ann?e hydrologiques compl?tes de la chronique

H_years=years*0
for(i in 1:N_H_year){
H_years[starts[i]:ends[i]]=i}			                  # Renum?rotation des dates selon leur appartenance ? une ann?e hydrologique

year_to_H_year=1:(N_H_year+1)-(month_start-1)/12-1	# Coordonn?es du d?but d'ann?e civile selon la num?rotation des ann?es hydrologiques

if(month_start==1){
year_to_H_year=1:(N_H_year)-(month_start-1)/12-1}

dispo_H_year=NULL					                          # Vecteur binaire de disponibilit? des donn?es par ann?e hydrologique (1 = ann?e sans lacune, 0 = ann?e avce lacune)
for(i in 1:N_H_year){
test=length(which(dispo[which(H_years==i)]==0))	    # D?termine si l'ann?e est compl?te

if(test==0){
dispo_H_year=c(dispo_H_year,1)}

if(test>0){
dispo_H_year=c(dispo_H_year,0)}

}
N_H_year_full=sum(dispo_H_year)			# Nombre d'ann?es hydrologiques compl?tes sans lacunes
}              # End Loop method="min"
}              # End Loop type=1


#-------------------------------------------------------------------------------------------------------------------------------------
# TYPE2 = Identification de la date de d?but d'ann?e hydrologique ? partir des dates moyennes des QMXA ou QMNA
#-------------------------------------------------------------------------------------------------------------------------------------

  if(type==2){   # Loop type=2

if(method=="max"){            # Loop method="max"

### Extraction des d?bits moyens mensuels minimums annuels ###

QMXA=NULL							                            # Initialisation de la chronique de d?bits moyens mensuels minimum annuels (Ann?es compl?tes)
for(i in year_start:year_end){
test=length(which(dispo[which(years==i)]==0))			# D?termine si l'ann?e est compl?te

if(test==0){
X=QM_y[which(QM_y[,1]==i),]
max=which(X[,3]==max(X[,3]))					            # Recherche le d?bit moyen mensuel maximal pour chaque ann?e
max=max[1]							                          # /!\ S?lection du premier maximal annuel
QMXA=rbind(QMXA,X[max,])}					                # Date du d?bit moyen mensuel maximal annuel
}

### Saisonnalit? du QMXA ###

m_QMXA=QMXA[,2]
m_QMXA=m_QMXA*2*pi/12			# Transformation pour statistiques circulaire

x=cos(m_QMXA)							# Coordonn?e x sur le cercle unitaire
y=sin(m_QMXA)							# Coordonn?e y sur le cercle unitaire

SI_QMXA=c(mean(x,na.rm=TRUE),mean(y,na.rm=TRUE))		# Coordonn?e x et y moyennes sur le cercle unitaire (indice de saisonnalit?)

if(SI_QMXA[1]<0){								                                                #
m_moy_QMXA=(atan(SI_QMXA[2]/SI_QMXA[1])+pi)*12/(2*pi)}				                  #
										                                                            #
if(SI_QMXA[1]>0){								                                                # Mois correspondant ? la date moyenne du QMNA
if(SI_QMXA[2]>0){m_moy_QMXA=(atan(SI_QMXA[2]/SI_QMXA[1]))*12/(2*pi)}		        #
if(SI_QMXA[2]<0){m_moy_QMXA=(atan(SI_QMXA[2]/SI_QMXA[1])+2*pi)*12/(2*pi)}	      #
}										                                                            #

j_start=365/12*m_moy_QMXA					                  # Jour calendaire correspondant ? la date moyenne du QMNA

var_t_QMXA=sqrt(SI_QMXA[1]^2+SI_QMXA[2]^2)			    # Variabilit? de la date moyenne (0 = tr?s variable, 1 = peu variable)

month_start=months[ts_start-1+j_start]
day_start=days[ts_start-1+j_start]
if(month_start==2 & day_start==29){day_start=28}

### Disponibilit? des donn?es par ann?es hydrologiques


starts=which(months==month_start & days==day_start)		# Dates de d?but des ann?es hydrologiques
ends=starts[-1]-1						                          # Dates de fin des ann?es hydrologiques
starts=starts[-length(starts)]

N_H_year=length(starts)					                      # Nombre d'ann?e hydrologiques compl?tes de la chronique

H_years=years*0
for(i in 1:N_H_year){
H_years[starts[i]:ends[i]]=i}				                  # Renum?rotation des dates selon leur appartenance ? une ann?e hydrologique

year_to_H_year=1:(N_H_year+1)-(j_start[s])/365-1		  # Coordonn?es du d?but d'ann?e civile selon la num?rotation des ann?es hydrologiques

dispo_H_year=NULL						                          # Vecteur binaire de disponibilit? des donn?es par ann?e hydrologique (1 = ann?e sans lacune, 0 = ann?e avce lacune)
for(i in 1:N_H_year){
test=length(which(dispo[which(H_years==i)]==0))		    # D?termine si l'ann?e est compl?te

if(test==0){
dispo_H_year=c(dispo_H_year,1)}

if(test>0){
dispo_H_year=c(dispo_H_year,0)}

}
N_H_year_full=sum(dispo_H_year)				                # Nombre d'ann?es hydrologiques compl?tes sans lacunes
}                             # End Loop method="max"


if(method=="min"){            # Loop method="min"

### Extraction des d?bits moyens mensuels minimums annuels ###

QMNA=NULL							                            # Initialisation de la chronique de d?bits moyens mensuels minimum annuels (Ann?es compl?tes)
for(i in year_start:year_end){	# Loop 1
test=length(which(dispo[which(years==i)]==0))			# D?termine si l'ann?e est compl?te

if(test==0){
X=QM_y[which(QM_y[,1]==i),]
min=which(X[,3]==min(X[,3]))			# Recherche le d?bit moyen mensuel maximal pour chaque ann?e
min=min[1]							          # /!\ S?lection du premier maximal annuel
QMNA=rbind(QMNA,X[min,])}					# Date du d?bit moyen mensuel maximal annuel

}	 			# End Loop 1

### Saisonnalit? du QMXA ###

m_QMNA=QMNA[,2]
m_QMNA=m_QMNA*2*pi/12			# Transformation pour statistiques circulaire

x=cos(m_QMNA)							# Coordonn?e x sur le cercle unitaire
y=sin(m_QMNA)							# Coordonn?e y sur le cercle unitaire

SI_QMNA=c(mean(x,na.rm=TRUE),mean(y,na.rm=TRUE))		  # Coordonn?e x et y moyennes sur le cercle unitaire (indice de saisonnalit?)

if(SI_QMNA[1]<0){								                                                #
m_moy_QMNA=(atan(SI_QMNA[2]/SI_QMNA[1])+pi)*12/(2*pi)}				                  #
										                                                            #
if(SI_QMNA[1]>0){								                                                # Mois correspondant ? la date moyenne du QMNA
if(SI_QMNA[2]>0){m_moy_QMNA=(atan(SI_QMNA[2]/SI_QMNA[1]))*12/(2*pi)}		        #
if(SI_QMNA[2]<0){m_moy_QMNA=(atan(SI_QMNA[2]/SI_QMNA[1])+2*pi)*12/(2*pi)}	      #
}										                                                            #

test=366/12*m_moy_QMNA						                    # Jour calendaire correspondant ? la date moyenne du QMNA

if(test<(366/2)){j_start=test+366/2}				          #
if(test==(366/2)){j_start=1}					                # Jour calendaire correspondant ? la date de d?but d'ann?e hydrologique
if(test>(366/2)){j_start=test-366/2}				          #

var_t_QMNA=sqrt(SI_QMNA[1]^2+SI_QMNA[2]^2)			      # Variabilit? de la date moyenne (0 = tr?s variable, 1 = peu variable)

month_start=months[ts_start-1+j_start]
day_start=days[ts_start-1+j_start]
if(month_start==2 & day_start==29){day_start=28}

### Disponibilit? des donn?es par ann?es hydrologiques


starts=which(months==month_start & days==day_start)		# Dates de d?but des ann?es hydrologiques
ends=starts[-1]-1						                          # Dates de fin des ann?es hydrologiques
starts=starts[-length(starts)]

N_H_year=length(starts)					                      # Nombre d'ann?e hydrologiques compl?tes de la chronique

H_years=years*0
for(i in 1:N_H_year){
H_years[starts[i]:ends[i]]=i}				                  # Renum?rotation des dates selon leur appartenance ? une ann?e hydrologique

year_to_H_year3=1:(N_H_year+1)-(j_start[s])/365-1		  # Coordonn?es du d?but d'ann?e civile selon la num?rotation des ann?es hydrologiques

dispo_H_year=NULL						                          # Vecteur binaire de disponibilit? des donn?es par ann?e hydrologique (1 = ann?e sans lacune, 0 = ann?e avce lacune)
for(i in 1:N_H_year){
test=length(which(dispo[which(H_years==i)]==0))		    # D?termine si l'ann?e est compl?te

if(test==0){
dispo_H_year=c(dispo_H_year,1)}

if(test>0){
dispo_H_year=c(dispo_H_year,0)}

}
N_H_year_full=sum(dispo_H_year)				                # Nombre d'ann?es hydrologiques compl?tes sans lacunes
}                             # End Loop method="min"

}                             # End Loop type=2

#-------------------------------------------------------------------------------------------------------------------------------------
# TYPE3 = Identification de la date de d?but d'ann?e hydrologique ? partir des d?bits moyens journaliers interannuels
#-------------------------------------------------------------------------------------------------------------------------------------

  if(type==3){   # Loop type=3

### Calcul des d?bits moyens journaliers interannuels ###

QJ=NULL								            # Initialisation de la chronique de d?bits moyens journaliers interannuels
for(i in 1:12){
for(j in 1:31){
QJ=rbind(QJ,c(i,j,mean(Q[which(months==i & days==j)],na.rm=TRUE)))
}
}

QJ=QJ[which(QJ[,3]>=0),3]					# D?bits moyens journaliers interannuels
var_QJ=sd(QJ)/mean(QJ)						# Coefficient de variation des d?bits moyens mensuels interannuels

### Calcul d'une moyenne glissante pour lisser la s?rie de d?bits moyens journaliers interannuels ###

d=30								              # Intervalle de calcul de la moyenne en jour (j-d/2 ? j+d/2)

X=c(QJ[(length(QJ)-(d/2)+1):length(QJ)],QJ,QJ[1:(d/2)])

QJ_d=NULL
for(j in (1+d/2):(length(X)-d/2)){
QJ_d=c(QJ_d,mean(X[(j-d/2):(j+(d/2)-1)]))}

#---------------------------------------------------------------------------------------------------------------------------#
#	D?finition de l'ann?e hydrologique (jour correspondant au maximum des d?bits moyens journaliers interannuel)
#---------------------------------------------------------------------------------------------------------------------------#

if(method=="max"){              # Loop method="max"
j_start=which(QJ_d==max(QJ_d))
j_start=j_start[1]						# Jour calendaire pour lequel le d?bit moyen journalier interannuels est maximal

month_start=months[ts_start-1+j_start]
day_start=days[ts_start-1+j_start]
if(month_start==2 & day_start==29){day_start=28}

### Disponibilit? des donn?es par ann?es hydrologiques

starts=which(months==month_start & days==day_start)	# Dates de d?but des ann?es hydrologiques
ends=starts[-1]-1					                          # Dates de fin des ann?es hydrologiques
starts=starts[-length(starts)]

N_H_year=length(starts)				                      # Nombre d'ann?e hydrologiques compl?tes de la chronique

H_years=years*0
for(i in 1:N_H_year){
H_years[starts[i]:ends[i]]=i}			                  # Renum?rotation des dates selon leur appartenance ? une ann?e hydrologique

year_to_H_year=1:(N_H_year+1)-(month_start-1)/365-1	# Coordonn?es du d?but d'ann?e civile selon la num?rotation des ann?es hydrologiques

dispo_H_year=NULL					                          # Vecteur binaire de disponibilit? des donn?es par ann?e hydrologique (1 = ann?e sans lacune, 0 = ann?e avce lacune)
for(i in 1:N_H_year){
test=length(which(dispo[which(H_years==i)]==0))	    # D?termine si l'ann?e est compl?te

if(test==0){
dispo_H_year=c(dispo_H_year,1)}

if(test>0){
dispo_H_year=c(dispo_H_year,0)}

}
N_H_year_full=sum(dispo_H_year)			                # Nombre d'ann?es hydrologiques compl?tes sans lacunes
}                               # End Loop method="max"

if(method=="min"){              # Loop method="min"

test=which(QJ_d==min(QJ_d))					        # Jour calendaire pour lequel le d?bit moyen journalier interannuels est minimal

if(test<(366/2)){j_start=test+366/2}				#
if(test==(366/2)){j_start=1}					      #
if(test>(366/2)){j_start=test-366/2}				# Jour calendaire correspondant ? la date de d?but d'ann?e hydrologique
								                            #
j_start=j_start[1]						              #

month_start=months[ts_start-1+j_start]	  # Mois de d?but de l'ann?e hydrologique
day_start=days[ts_start-1+j_start]				# Jour de d?but de l'ann?e hydrologique
if(month_start==2 & day_start==29){day_start=28}

### Disponibilit? des donn?es par ann?es hydrologiques

starts=which(months==month_start & days==day_start)	  # Dates de d?but des ann?es hydrologiques
ends=starts[-1]-1					                            # Dates de fin des ann?es hydrologiques
starts=starts[-length(starts)]

N_H_year=length(starts)				                        # Nombre d'ann?e hydrologiques compl?tes de la chronique

H_years=years*0
for(i in 1:N_H_year){
H_years[starts[i]:ends[i]]=i}			                    # Renum?rotation des dates selon leur appartenance ? une ann?e hydrologique

year_to_H_year=1:(N_H_year+1)-(month_start-1)/365-1	  # Coordonn?es du d?but d'ann?e civile selon la num?rotation des ann?es hydrologiques

dispo_H_year=NULL					                            # Vecteur binaire de disponibilit? des donn?es par ann?e hydrologique (1 = ann?e sans lacune, 0 = ann?e avce lacune)
for(i in 1:N_H_year){
test=length(which(dispo[which(H_years==i)]==0))	      # D?termine si l'ann?e est compl?te

if(test==0){
dispo_H_year=c(dispo_H_year,1)}

if(test>0){
dispo_H_year=c(dispo_H_year,0)}

}
N_H_year_full=sum(dispo_H_year)			                  # Nombre d'ann?es hydrologiques compl?tes sans lacunes
}                             # End Loop method="min"
}                             # End Loop type=3

#-------------------------------------------------------------------------------
# Mise en forme des r?sultats de sortie
#-------------------------------------------------------------------------------

Out=list("Date de debut (jour julien)"=j_start,"Rang des dates de debut "=starts,
"Equivalence annee civile / annee hydrologique "=cbind(years,H_years),
"Nombre d'annees hydrologiques completes sans lacunes"= N_H_year_full)
return(Out)

}												# End FUNCTION

