source("./Script_files/functions.R")
source("./Script_files/loadData.R")


# ETDBoxPlot1 <- ETPlotData_fun("PDLat") + ylab( expression(bold("1/[Max pupil dilation latency] (1"*0^-2*"/ms)")) )

ETDBoxPlot1 <- ETPlotData_fun("PDLat")  + ylab("-[Max pupil dilation latency] (ms)")
ETDBoxPlot2 <- ETPlotData_fun("PDndMax") + ylab("Max pupil dilation, normalized")
ETDBoxPlot3 <- ETPlotData_fun("PDndMean") + ylab("Mean pupil dilation, normalized")
ETDBoxPlot4 <- ETPlotData_fun("PDndMed") + ylab("Median pupil dilation, normalized")

ETDBoxPlot1 + ETDBoxPlot2 + ETDBoxPlot3 + ETDBoxPlot4 + plot_layout( nrow = 1, guides = "collect") & theme(legend.position = "bottom") &theme( axis.title.x=element_blank(),
                                                                                                                                                  axis.text.x = element_blank(),
                                                                                                                                                  axis.ticks.x = element_blank(),
                                                                                                                                                  axis.line.x = element_blank()) 
  
# ggsave("R/plots/FigS3_ver4.pdf", 
#        width = 9, height = 6, useDingbats=FALSE)
