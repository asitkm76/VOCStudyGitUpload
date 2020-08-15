source("./Script_files/functions.R")
source("./Script_files/loadData.R")

# CT/ND: cognitive stress or relaxed condition

saaPlot <-
  saa.subjects %>%
  ggplot(aes(x=Task, y=AlphaAmylase, fill=Task)) + 
  geom_boxplot(outlier.size = 0.5, color = "#8a8a8a") + 
  scale_x_discrete(labels = task_names) +
  scale_fill_manual(name = NULL,
                    labels = task_names,
                    values = color_manual_task) +
    geom_signif( comparisons = list(c("ND", "CT")),
                map_signif_level=F, test = "t.test", test.args = list(paired = T)) +   # wilcox.test
  # guides(fill = FALSE) + 
  ylab("sAA (kIU/liter)") +
  mytheme_basic 
    

plotetCO2 <- etCO2DataMean %>%
    ggplot(aes(x=Task, y=etCO2.mmHg, fill=Task)) + 
    geom_boxplot(outlier.size = 0.5, color = "#8a8a8a") + 
    ylab(expression( bold("End tidal "*CO[2]*" (mm Hg)") ) ) +
    scale_x_discrete(labels = task_names) +
  geom_signif( comparisons = list(c("ND", "CT")),
               map_signif_level=F, test = "t.test", test.args = list(paired = T)) +
    scale_fill_manual(name = NULL,
                    labels = task_names,
                    values = color_manual_task) +
    # guides(fill = FALSE) +
    scale_y_continuous(breaks=c(37,40,43,46),
                       labels=c("37","40","43","46"))+
    mytheme_basic

   # saaPlot + plotetCO2 + plot_layout( guides = "collect")   &  theme( axis.title.x=element_blank(),
   #                                                                axis.text.x = element_blank(),
   #                                                                axis.ticks.x = element_blank(),
   #                                                                axis.line.x = element_blank()) 

plotetCO2_2 <- etCO2DataMean %>%
  ggplot(aes(x=Task, y=RR.bpm, fill=Task)) + 
  geom_boxplot(outlier.size = 0.5, color = "#8a8a8a") +
  geom_signif( comparisons = list(c("ND", "CT")),
               map_signif_level=F, test = "t.test", test.args = list(paired = T)) +
  ylab("Respiration rate (breaths/minute)" ) +
  scale_x_discrete(labels = task_names) +
  scale_fill_manual(name = NULL,
                    labels = task_names,
                    values = color_manual_task) +
  # guides(fill = FALSE) +
  # scale_y_continuous(breaks=c(37,40,43,46),
  #                    labels=c("37","40","43","46"))+
  mytheme_basic

# HRVBoxPlot ------------------------

HRVBoxPlot1 <- HRVBoxPlot_fun ("HRVData.MeanRR") + ylab("Mean RR interval (ms)") + scale_y_continuous(trans = "reverse")
HRVBoxPlot2 <- HRVBoxPlot_fun ("HRVData.FFTVLFPowPcnt") + ylab("VLF Power (%)")  + scale_y_continuous(trans = "reverse") 
HRVBoxPlot3 <- HRVBoxPlot_fun ("HRVData.MinHR") + ylab("Minimum heart rate (bpm)") 
HRVBoxPlot4 <- HRVBoxPlot_fun ("HRVData.SampEn") + ylab("Sample entropy")          


  
  
saaPlot  + HRVBoxPlot2 + HRVBoxPlot3 + HRVBoxPlot4 + HRVBoxPlot1 + plotetCO2 + plotetCO2_2 + plot_layout( nrow = 1, guides = "collect") & theme(legend.position = "bottom") &theme( axis.title.x=element_blank(),
                                                                                         axis.text.x = element_blank(),
                                                                                         axis.ticks.x = element_blank(),
                                                                                         axis.line.x = element_blank()) 
  
# ggsave("R/plots/Fig2_ver7.pdf", 
#        width = 9, height = 6, useDingbats=FALSE)
