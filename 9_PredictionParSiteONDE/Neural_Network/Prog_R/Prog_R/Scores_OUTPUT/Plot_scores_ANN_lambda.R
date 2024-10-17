#---------------
# Scores boxplot
#---------------

library(ggplot2)
library(cowplot)

rm(list=ls())
seuil=""

input1<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/Scores_ALL_HER_Lambda_best.csv", sep=";", header = T, quote="", stringsAsFactors=F)
# input1<-input1[,-c(7:12)]
input2<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/Scores_ALL_HER_Lambda_0_2.csv", sep=";", header = T, quote="", stringsAsFactors=F)
# input2<-input2[,-c(7:9)]
input3<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/Scores_ALL_HER_Lambda_0_1.csv", sep=";", header = T, quote="", stringsAsFactors=F)
# input3<-input3[,-c(7:11)]
input4<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/Scores_ALL_HER_Lambda_0_01.csv", sep=";", header = T, quote="", stringsAsFactors=F)
# input4<-input4[,-c(7:11)]
input5<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/Scores_ALL_HER_Lambda_0_001.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input6<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/Scores_ALL_HER_Lambda_0_0001.csv", sep=";", header = T, quote="", stringsAsFactors=F)

#----------------------------------------------------------------------------------------------
# INPUT 1
full_input<-data.frame()
full_input[1:nrow(input1),1] = "Best_L"
full_input=cbind(full_input,input1[,2])
# colnames(full_input)<-c("Code","POD","FAR","AUC","Prec","Recall","F1.Score")
colnames(full_input)<-c("Code","F1.Score")
#----------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------
# INPUT 2
data_add <- data.frame()
data_add[1:nrow(input2),1] = "L_0_2"
data_add=cbind(data_add,input2[,6])

# colnames(data_add)<-c("Code","POD","FAR","AUC","Prec","Recall","F1.Score")
colnames(data_add)<-c("Code","F1.Score")
full_input=rbind(full_input,data_add)

#-----------------------------------------------
#-----------------------------------------------
# INPUT 3
data_add <- data.frame()
data_add[1:nrow(input3),1] = "L_0_1" # 
data_add=cbind(data_add,input3[,6])
# colnames(data_add)<-c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Year","Param") #,"AUC")
# colnames(data_add)<-c("Code","POD","FAR","AUC","Prec","Recall","F1.Score")
colnames(data_add)<-c("Code","F1.Score")
full_input=rbind(full_input,data_add)

#-----------------------------------------------
#-----------------------------------------------
# INPUT 4
data_add <- data.frame()
data_add[1:nrow(input4),1] = "L_0_01" #
data_add=cbind(data_add,input4[,6])
# colnames(data_add)<-c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Year","Param") #,"AUC")
# colnames(data_add)<-c("Code","POD","FAR","AUC","Prec","Recall","F1.Score")
colnames(data_add)<-c("Code","F1.Score")
full_input=rbind(full_input,data_add)

#-----------------------------------------------
#-----------------------------------------------
# INPUT 5
data_add <- data.frame()
data_add[1:nrow(input5),1]= "L_0_001" # 
data_add=cbind(data_add,input5[,6])
# colnames(data_add)<-c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Year","Param") #,"AUC")
colnames(data_add)<-c("Code","F1.Score")
full_input=rbind(full_input,data_add)

# #-----------------------------------------------
# #-----------------------------------------------
# INPUT 6
data_add <- data.frame()
data_add[1:nrow(input6),1]= "L_0_0001" #
data_add=cbind(data_add,input6[,6])
# colnames(data_add)<-c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Year","Param") #,"AUC")
colnames(data_add)<-c("Code","F1.Score")
full_input=rbind(full_input,data_add)
#-----------------------------------------------

# Quantile <- as.factor(full_input[,1])
# Frequence <- full_input[,2]

a <- ggplot(data = full_input, aes(x = as.factor(full_input[,1]), y = full_input[,2])) + geom_boxplot(aes(fill = factor(full_input[,1]))) + scale_x_discrete(name ="") +
  scale_y_continuous(name ="%", limits=c(0, 1)) + theme(legend.position='none', axis.text=element_text(size=8))

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

# ggdraw() +
#   draw_plot(a, 0, .5, .33, .5) +
#   draw_plot(b, .33, 0.5, .33, .5) +
#   draw_plot(c, .66, 0.5, .33, .5) +
#   draw_plot(d, 0, 0, .33, 0.5) +
#   draw_plot(e, .33, 0, .33, 0.5) +
#   draw_plot(f, .66, 0, .33, 0.5) +
#   draw_plot_label(c("POD", "FAR", "AUC", "PREC", "Recall", "F1.score"), c(0.165, 0.5, 0.82, 0.165, 0.5, 0.82), c(0.99, 0.99,0.99, 0.49, 0.49, 0.49), size = 10)

ggdraw() +
  draw_plot(a) +
  draw_plot_label(c("F1.score"), c(0.5, 0.5, 0.82, 0.165, 0.5, 0.82), c(0.99, 0.99,0.99, 0.49, 0.49, 0.49), size = 10)

dev.print(png, filename = paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Graphiques_comparatifs_test_moy30_RANDOM.png", sep=""), width=15 , height=7, units="in", res = 500)
dev.off()
