library(tidyverse)
library(cowplot)
library(gtable)
library(grid)
library(patchwork)


custom_barplot <- function(dataset, x_value, y_value, fill_value, nfill, xlab, ylab, y_limit, y_steps,legend_labels) {
  # Example color set to choose from
  colors=c("#CF232B","#942192","#000000","#f1eef6","#addd8e","#d0d1e6","#31a354","#a6bddb")
  
  # user function for adjusting the size of key-polygons in legend
  draw_key_polygon2 <- function(data, params, size) {
    lwd <- min(data$size, min(size) / 4)
    
    grid::rectGrob(
      width = grid::unit(0.8, "npc"),
      height = grid::unit(0.8, "npc"),
      gp = grid::gpar(
        col = data$colour,
        fill = alpha(data$fill, data$alpha),
        lty = data$linetype,
        lwd = lwd * .pt,
        linejoin = "mitre"
      ))
  }
  # user function for the plot itself
  plot <- function(dataset, x_value, y_value, fill_value, nfill, xlab, ylab, y_limit, y_steps,legend,legend_labels) 
  {ggplot(data=dataset, mapping=aes(x={{x_value}}, y={{y_value}}, fill={{fill_value}})) +
      geom_col(position=position_dodge(width=0.85),width=0.8,key_glyph="polygon2",show.legend=legend) + 
      geom_smooth(aes(color={{fill_value}}),method="lm",formula=y~x, se=FALSE,show.legend=legend, linetype="dashed") +
      labs(x=xlab,y=ylab) +
      theme(text=element_text(size=9,color="black"),
            panel.background = element_rect(fill="white"),
            panel.grid = element_line(color = "black",linetype="solid",size= 0.3),
            panel.grid.minor = element_blank(),
            panel.grid.major.x=element_blank(),
            axis.text=element_text(size=9),
            axis.line.x=element_line(color="black"),
            axis.ticks= element_blank(),
            legend.text=element_text(size=9),
            legend.position = "right",
            legend.justification = "top",
            legend.title = element_blank(),
            legend.key.size = unit(4,"mm"),
            legend.key = element_rect(fill="white"),
            plot.margin=unit(c(1,0.25,0.5,0.5),"cm")) +
      scale_y_continuous(breaks= seq(from=0, to=y_limit,by=y_steps),
                         limits=c(0,y_limit+1), 
                         expand=c(0,0)) +
      scale_x_continuous(breaks=min(data[,deparse(ensym(x_value))],na.rm=TRUE):max(data[,deparse(ensym(x_value))],na.rm=TRUE)) +
      scale_fill_manual(values = colors[1:nfill],labels={{legend_labels}})+
      scale_color_manual(values= colors[1:nfill],labels=paste("Trend ",{{legend_labels}},sep=""))+
      guides(color=guide_legend(override.aes=list(fill=NA),order=2),fill=guide_legend(override.aes = list(linetype=0),order=1))}
  
  # taking the legend of the plot and removing the first column of the gtable within the legend
  p_legend <- #cowplot::get_legend(plot(dataset, {{x_value}}, {{y_value}}, {{fill_value}}, nfill, xlab, ylab, y_limit, y_steps,legend=TRUE))
    gtable_squash_cols(cowplot::get_legend(plot(dataset, {{x_value}}, {{y_value}}, {{fill_value}},nfill, xlab, ylab, y_limit, y_steps,legend=TRUE,legend_labels)),1)
  
  # printing the plot without legend
  p_main <- plot(dataset, {{x_value}}, {{y_value}}, {{fill_value}}, nfill, xlab, ylab, y_limit, y_steps,legend=FALSE,legend_labels = NULL)
  
  #joining it all together
  Obj<- p_main+plot_spacer() + p_legend +
    plot_layout(widths=c(12.5,1.5,4))
  
  return(Obj)
  
}


set.seed(9)
data <- data.frame(Cat=c(rep("A",times=5),rep("B",times=5),rep("C", times=5)),
                   year=rep(c(2015,2016,2017,2018,2019),times=3),
                   count=c(sample(seq(60,80),replace=TRUE,size=5),sample(seq(100,140),replace=TRUE,size=5),sample(seq(20,30),replace=TRUE,size=5)))


plt <- custom_barplot(dataset=data %>% filter(year %in% c(2015,2016,2017)), 
                        x_value=year,
                        y_value=count, 
                        fill_value=Cat, 
                        nfill=3, 
                        xlab="Year",
                        ylab="Count",
                        y_limit=140,
                        y_steps=20,
                        legend_labels=c("A","B","C"))


plt_2 <- custom_barplot(dataset=data %>% filter(year %in% c(2015,2016,2017)), 
                        x_value=year,
                        y_value=count, 
                        fill_value=Cat, 
                        nfill=3, 
                        xlab="Year",
                        ylab="Count",
                        y_limit=140, 
                        y_steps=20,
                        legend_labels=c("Long Label A","Long Label B","Long Label C"))

plt_3 <- custom_barplot(dataset=data %>% filter(year %in% c(2015,2016,2017)), 
                        x_value=year,
                        y_value=count, 
                        fill_value=Cat, 
                        nfill=3, 
                        xlab="Year",
                        ylab="Count",
                        y_limit=140, 
                        y_steps=20,
                        legend_labels=c("Xtra Long Label A","Xtra Long Label B","Xtra Long Label C"))

plt_4 <- custom_barplot(dataset=data %>% filter(year %in% c(2015,2016,2017)), 
                        x_value=year,
                        y_value=count, 
                        fill_value=Cat, 
                        nfill=3, 
                        xlab="Year",
                        ylab="Count",
                        y_limit=140, 
                        y_steps=20,
                        legend_labels=c("Super Xtra Long Label A","Super Xtra Long Label B","Super Xtra Long Label C"))


