#---------------
# Scores boxplot
#---------------

library(ggplot2)
library(cowplot)

rm(list=ls())
seuil=""

input1<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Random_forest/Résultats_locaux_HER_97/critere_seuils_opti_test_2012_2016_FULL_j5_new_meteo_all_caract.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input2<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Random_forest/Résultats_locaux_HER_97/critere_seuils_opti_test_2012_2016_FULL_j5_new_meteo_all_ntry_5.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input3<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Random_forest/Résultats_locaux_HER_97/critere_seuils_opti_test_2012_2016_FULL_j5_new_meteo_all_ntry_10.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input4<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Random_forest/Résultats_locaux_HER_97/critere_seuils_opti_test_2012_2016_FULL_j5_new_meteo_all_ntry_15.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input5<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Random_forest/Résultats_locaux_HER_97/critere_seuils_opti_test_2012_2016_FULL_j5_new_meteo_all_ntry_20.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input6<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Random_forest/Résultats_locaux_HER_97/critere_seuils_opti_test_2012_2016_FULL_j5_new_meteo_all_ntry_25.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input7<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Random_forest/Résultats_locaux_HER_97/critere_seuils_opti_test_2012_2016_FULL_j5_new_meteo_all_ntry_30.csv", sep=";", header = T, quote="", stringsAsFactors=F)
# input8<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Random_forest/Résultats_locaux_HER_97/critere_seuils_opti_test_2012_2016_FULL_j5_new_meteo_all_caract_SANS_AI_REC.csv", sep=";", header = T, quote="", stringsAsFactors=F)
# input9<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Random_forest/Résultats_locaux_HER_97/critere_seuils_opti_test_2012_2016_FULL_j5_new_meteo_all_caract_SANS_METEO.csv", sep=";", header = T, quote="", stringsAsFactors=F)

# input10<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Random_forest/Résultats_locaux_HER_97/critere_seuils_opti_test_2012_2016_FULL_j9.csv", sep=";", header = T, quote="", stringsAsFactors=F)
# input11<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Random_forest/Résultats_locaux_HER_97/critere_seuils_opti_test_2012_2016_FULL_j10.csv", sep=";", header = T, quote="", stringsAsFactors=F)

#----------------------------------------------------------------------------------------------
# INPUT 1
full_input<-data.frame()
select1=which(input1[,9]==27)

full_input[1:length(select1),1]="J5"
full_input=cbind(full_input,input1[select1,])
colnames(full_input)<-c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Seuil_opti","Year","Param") #,"AUC")

# data_add<-data.frame()
# data_add[1:length(select2),1]="27p_TM_sel" #
# data_add=cbind(data_add,input1[select2,])
# colnames(data_add)<-c("Code","POD","FAR","ACC","Prec","Recall","F1.Score","Year","Param") #,"AUC")
# full_input=rbind(full_input,data_add)
#----------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------
# INPUT 2
select2 <- which(input2[,9]==27)
data_add <- data.frame()
data_add[1:length(select2),1]= "Tree_5" #"PRCP"
data_add=cbind(data_add,input2[select2,])
colnames(data_add)<-c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Seuil_opti","Year","Param") #,"AUC")
full_input=rbind(full_input,data_add)
#-----------------------------------------------
#-----------------------------------------------
# INPUT 3
select2 <- which(input3[,9]==27)
data_add <- data.frame()
data_add[1:length(select2),1]= "Try_10" # "ETP"
data_add=cbind(data_add,input3[select2,])
colnames(data_add)<-c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Seuil_opti","Year","Param") #,"AUC")
full_input=rbind(full_input,data_add)
#-----------------------------------------------
#-----------------------------------------------
# INPUT 4
select2 <- which(input4[,9]==27)
data_add <- data.frame()
data_add[1:length(select2),1]= "Try_15" #
data_add=cbind(data_add,input4[select2,])
colnames(data_add)<-c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Seuil_opti","Year","Param") #,"AUC")
full_input=rbind(full_input,data_add)
#-----------------------------------------------
#-----------------------------------------------
# INPUT 5
select2 <- which(input5[,9]==27)
data_add <- data.frame()
data_add[1:length(select2),1]= "Try_20" #
data_add=cbind(data_add,input5[select2,])
colnames(data_add)<-c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Seuil_opti","Year","Param") #,"AUC")
full_input=rbind(full_input,data_add)
#-----------------------------------------------
#-----------------------------------------------
# INPUT 6
select2 <- which(input6[,9]==27)
data_add <- data.frame()
data_add[1:length(select2),1]= "Try_25" #
data_add=cbind(data_add,input6[select2,])
colnames(data_add)<-c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Seuil_opti","Year","Param") #,"AUC")
full_input=rbind(full_input,data_add)
#-----------------------------------------------
#-----------------------------------------------
# INPUT 7
select2 <- which(input7[,9]==27)
data_add <- data.frame()
data_add[1:length(select2),1]= "Try_30" #
data_add=cbind(data_add,input7[select2,])
colnames(data_add)<-c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Seuil_opti","Year","Param") #,"AUC")
full_input=rbind(full_input,data_add)
#-----------------------------------------------
#-----------------------------------------------
# INPUT 8
# select2 <- which(input8[,9]==27)
# data_add <- data.frame()
# data_add[1:length(select2),1] = "AI_REC" #
# data_add=cbind(data_add,input8[select2,])
# colnames(data_add)<-c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Seuil_opti","Year","Param") #,"AUC")
# full_input=rbind(full_input,data_add)
#-----------------------------------------------
# #-----------------------------------------------
# INPUT 9
# select2 <- which(input9[,9]==27)
# data_add <- data.frame()
# data_add[1:length(select2),1]= "MET" #
# data_add=cbind(data_add,input9[select2,])
# colnames(data_add)<-c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Seuil_opti","Year","Param") #,"AUC")
# full_input=rbind(full_input,data_add)
# #-----------------------------------------------
# #-----------------------------------------------
# # INPUT 10
# select2 <- which(input6[,9]==27)
# data_add <- data.frame()
# data_add[1:length(select2),1]= "J9" #
# data_add=cbind(data_add,input6[select2,])
# colnames(data_add)<-c("Code","POD","FAR","ACC","Prec","Recall","F1.Score","Seuil_opti","Year","Param") #,"AUC")
# full_input=rbind(full_input,data_add)
# #-----------------------------------------------
# #-----------------------------------------------
# # INPUT 11
# select2 <- which(input11[,9]==27)
# data_add <- data.frame()
# data_add[1:length(select2),1]= "J10" #
# data_add=cbind(data_add,input11[select2,])
# colnames(data_add)<-c("Code","POD","FAR","ACC","Prec","Recall","F1.Score","Seuil_opti","Year","Param") #,"AUC")
# full_input=rbind(full_input,data_add)
# #-----------------------------------------------

# Quantile <- as.factor(full_input[,1])
# Frequence <- full_input[,2]

a <- ggplot(data = full_input, aes(x = as.factor(full_input[,1]), y = full_input[,2])) + geom_boxplot(aes(fill = factor(full_input[,1]))) + scale_x_discrete(name ="") +
  scale_y_continuous(name ="%", limits=c(0, 100)) + theme(legend.position='none', axis.text=element_text(size=8))

b <- ggplot(data = full_input, aes(x = as.factor(full_input[,1]), y = full_input[,3])) + geom_boxplot(aes(fill = factor(full_input[,1]))) + scale_x_discrete(name ="") +
  scale_y_continuous(name ="%", limits=c(0, 100)) + theme(legend.position='none', axis.text=element_text(size=8))
# Si ACCURACY
# c <- ggplot(data = full_input, aes(x = as.factor(full_input[,1]), y = full_input[,4])) + geom_boxplot(aes(fill = factor(full_input[,1]))) + scale_x_discrete(name ="") +
#   scale_y_continuous(name ="%", limits=c(0, 1)) + theme(legend.position='none', axis.text=element_text(size=8))
# Si Area under the curve
c <- ggplot(data = full_input, aes(x = as.factor(full_input[,1]), y = full_input[,4])) + geom_boxplot(aes(fill = factor(full_input[,1]))) + scale_x_discrete(name ="") +
  scale_y_continuous(name ="%", limits=c(0, 1)) + theme(legend.position='none', axis.text=element_text(size=8))

d <- ggplot(data = full_input, aes(x = as.factor(full_input[,1]), y = full_input[,5])) + geom_boxplot(aes(fill = factor(full_input[,1]))) + scale_x_discrete(name ="") +
  scale_y_continuous(name ="%", limits=c(0, 1)) + theme(legend.position='none', axis.text=element_text(size=8))

e <- ggplot(data = full_input, aes(x = as.factor(full_input[,1]), y = full_input[,6])) + geom_boxplot(aes(fill = factor(full_input[,1]))) + scale_x_discrete(name ="") +
  scale_y_continuous(name ="%", limits=c(0, 1)) + theme(legend.position='none', axis.text=element_text(size=8))

f <- ggplot(data = full_input, aes(x = as.factor(full_input[,1]), y = full_input[,7])) + geom_boxplot(aes(fill = factor(full_input[,1]))) + scale_x_discrete(name ="") +
  scale_y_continuous(name ="%", limits=c(0, 1)) + theme(legend.position='none', axis.text=element_text(size=8))

# plot_grid(a, b, c, d, e, f, labels=c("POD", "FAR", "ACC", "PREC", "Recall", "F1.score"), ncol = 2, nrow = 3)

ggdraw() +
  draw_plot(a, 0, .5, .33, .5) +
  draw_plot(b, .33, 0.5, .33, .5) +
  draw_plot(c, .66, 0.5, .33, .5) +
  draw_plot(d, 0, 0, .33, 0.5) +
  draw_plot(e, .33, 0, .33, 0.5) +
  draw_plot(f, .66, 0, .33, 0.5) +
  draw_plot_label(c("POD", "FAR", "AUC", "PREC", "Recall", "F1.score"), c(0.165, 0.5, 0.82, 0.165, 0.5, 0.82), c(0.99, 0.99,0.99, 0.49, 0.49, 0.49), size = 10)

dev.print(png, filename = paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Random_forest/Résultats_locaux_HER_97/Scores_RF_nTry_change_new_meteo.png", sep=""), width=15 , height=7, units="in", res = 500)
dev.off()
