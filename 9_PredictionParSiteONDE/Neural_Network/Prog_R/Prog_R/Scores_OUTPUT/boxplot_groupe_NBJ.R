# Plot boxplot groupe

rm(list=ls())

library(ggplot2)

input1<-read.table("C:/Users/aurelien.beaufort/Documents/Article/Article 2/Figures/Metrics/NBJ_LASSO_2012_2016.csv", sep=";", header = T, quote="", stringsAsFactors=F)


ggplot(data = input1, aes(x = as.factor(input1[,2]), y = input1[,3])) + geom_boxplot(aes(fill = factor(input1[,1]))) + scale_x_discrete(name ="") +
  scale_y_continuous(name ="NBJ (DAY)", limits=c(-50, 50)) + theme(legend.position='none', axis.text=element_text(size=8))
