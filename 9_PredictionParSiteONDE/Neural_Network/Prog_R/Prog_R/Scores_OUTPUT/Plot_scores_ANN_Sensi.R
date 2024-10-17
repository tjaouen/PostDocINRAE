#---------------
# Scores boxplot
#---------------

library(ggplot2)
library(cowplot)

rm(list=ls())
seuil=""

input5<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/critere_seuils_opti_FULL_moy_j30_new_meteo_all_caract_NEW_decay_0_0001_HER_105_RANDOM_FINAL_SANS_Q.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input3<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/critere_seuils_opti_FULL_moy_j30_new_meteo_all_caract_NEW_decay_0_0001_HER_105_RANDOM_FINAL_SANS_ETP.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input2<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/critere_seuils_opti_FULL_moy_j30_new_meteo_all_caract_NEW_decay_0_0001_HER_105_RANDOM_FINAL_SANS_PRCP.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input6<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/critere_seuils_opti_FULL_moy_j30_new_meteo_all_caract_NEW_decay_0_0001_HER_105_RANDOM_FINAL_SANS_GW.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input4<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/critere_seuils_opti_FULL_moy_j30_new_meteo_all_caract_NEW_decay_0_0001_HER_105_RANDOM_FINAL_SANS_TA.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input1<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/Lambda_0_0001/critere_seuils_opti_FULL_moy_j30_new_meteo_all_caract_NEW_decay_0_0001_HER_105_RANDOM_FINAL.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input7<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/critere_seuils_opti_FULL_moy_j30_new_meteo_all_caract_NEW_decay_0_0001_HER_105_RANDOM_FINAL_SANS_GEOM.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input8<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/critere_seuils_opti_FULL_moy_j30_new_meteo_all_caract_NEW_decay_0_0001_HER_105_RANDOM_FINAL_SANS_MPDRY.csv", sep=";", header = T, quote="", stringsAsFactors=F)
# input9<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/Résultats_locaux_HER_97/critere_ANN_1layer_3nodes_2012_2016_FULL_j5_new_meteo_all_caract_SANS_AI_REC.csv", sep=";", header = T, quote="", stringsAsFactors=F)


#-----------------------------------------------
# INPUT 1
full_input<-data.frame()
full_input[1:nrow(input1),1] = "ALL"
full_input=cbind(full_input,input1)
colnames(full_input) <- c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Brier","Seuil_opti","Param","NbAssec","NbFlow")

#-----------------------------------------------
#-----------------------------------------------
# INPUT 2

data_add<-data.frame()
data_add[1:nrow(input2),1] = "PRCP" #
data_add=cbind(data_add,input2)
colnames(data_add) <- c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Brier","Seuil_opti","Param","NbAssec","NbFlow")
full_input = rbind(full_input,data_add)

#-----------------------------------------------
#-----------------------------------------------
# INPUT 3

data_add<-data.frame()
data_add[1:nrow(input3),1] = "ETP" #
data_add=cbind(data_add,input3)
colnames(data_add) <- c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Brier","Seuil_opti","Param","NbAssec","NbFlow")
full_input = rbind(full_input,data_add)

#-----------------------------------------------
# #-----------------------------------------------
# INPUT 4
data_add <- data.frame()
data_add[1:nrow(input4),1]= "TA" #
data_add=cbind(data_add,input4)
colnames(data_add) <- c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Brier","Seuil_opti","Param","NbAssec","NbFlow")
full_input=rbind(full_input,data_add)
#-----------------------------------------------
#-----------------------------------------------
# INPUT 5
data_add <- data.frame()
data_add[1:nrow(input5),1]= "Q" #
data_add=cbind(data_add,input5)
colnames(data_add) <- c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Brier","Seuil_opti","Param","NbAssec","NbFlow")
full_input=rbind(full_input,data_add)
# #-----------------------------------------------
# #-----------------------------------------------
# INPUT 6
data_add <- data.frame()
data_add[1:nrow(input6),1]="GW" #
data_add=cbind(data_add,input6)
colnames(data_add) <- c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Brier","Seuil_opti","Param","NbAssec","NbFlow")
full_input=rbind(full_input,data_add)
# #-----------------------------------------------
# #-----------------------------------------------
# INPUT 7
data_add <- data.frame()
data_add[1:nrow(input7),1]="Geom"  #
data_add=cbind(data_add,input7)
colnames(data_add) <- c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Brier","Seuil_opti","Param","NbAssec","NbFlow")
full_input=rbind(full_input,data_add)
# #-----------------------------------------------
# #-----------------------------------------------
# INPUT 8
data_add <- data.frame()
data_add[1:nrow(input8),1]="MPDry" #
data_add=cbind(data_add,input8)
colnames(data_add) <- c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Brier","Seuil_opti","Param","NbAssec","NbFlow")
full_input=rbind(full_input,data_add)
#-----------------------------------------------
#-----------------------------------------------
# INPUT 9
# data_add <- data.frame()
# data_add[1:nrow(input9),1]="METEO"
# data_add=cbind(data_add,input9)
# colnames(data_add) <- c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Seuil_opti","Param")
# full_input=rbind(full_input,data_add)
#-----------------------------------------------
#-----------------------------------------------
# INPUT 9
# data_add <- data.frame()
# data_add[1:nrow(input9),1]="A_MET"
# # data_add=cbind(data_add,input9[,1:6])
# # data_add=cbind(data_add,input9[,9:10])
# # data_add=cbind(data_add,input9[,8])
# 
# data_add=cbind(data_add,input9)
# colnames(data_add)<-c("Code","POD","FAR","ACC","Prec","Recall","F1.Score","Year","Param") #,"AUC")
# full_input=rbind(full_input,data_add)
#-----------------------------------------------

# Quantile <- as.factor(full_input[,1])
# Frequence <- full_input[,2]

a <- ggplot(data = full_input, aes(x = as.factor(full_input[,1]), y = full_input[,2])) + geom_boxplot(aes(fill = factor(full_input[,1]))) + scale_x_discrete(name ="") +
  scale_y_continuous(name ="%", limits=c(0, 100)) + theme(legend.position='none', axis.text=element_text(size=8))

b <- ggplot(data = full_input, aes(x = as.factor(full_input[,1]), y = full_input[,3])) + geom_boxplot(aes(fill = factor(full_input[,1]))) + scale_x_discrete(name ="") +
  scale_y_continuous(name ="%", limits=c(0, 100)) + theme(legend.position='none', axis.text=element_text(size=8))

# Si ACCURACY
# c <- ggplot(data = full_input, aes(x = as.factor(full_input[,1]), y = full_input[,4])) + geom_boxplot(aes(fill = factor(full_input[,1]))) + scale_x_discrete(name ="") +
#   scale_y_continuous(name ="%", limits=c(0, 100)) + theme(legend.position='none', axis.text=element_text(size=8))
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

# dev.print(png, filename = paste("C:/Users/aurelien.beaufort/Documents/Neural_network/OUTPUT/Graph_critères/Neural_network/Résultats_locaux_HER_97/Scores_ANN_seuil_opti_new_meteo_FULL_vs_HYDRO_RANDOM_t.png", sep=""), width=15 , height=7, units="in", res = 500)
dev.print(png, filename = paste("C:/Users/aurelien.beaufort/Documents/Neural_network/OUTPUT/Graph_critères/Neural_network/Scores_ANN_seuil_opti_new_meteo_RANDOM_HYDRO_ONLY_HER_FRANCE_HER_105_var_sensi.png", sep=""), width=15 , height=7, units="in", res = 500)

dev.off()
