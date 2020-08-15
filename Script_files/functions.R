library(data.table)
library(ggplot2)
library(magrittr)
library(patchwork)
library(openxlsx)
library(lubridate)
library(forcats)
library(scales)
library(ggsignif)
library(ggpubr)

# library(cowplot)
# library(gridExtra)

# plot_functions---------------------
HRVBoxPlot_fun <-  function(par) {
  HRVPlotData %>%
    ggplot(aes(x=HRVData.Task, y=get(par), fill=HRVData.Task)) +  
    geom_boxplot(outlier.size = 0.5, color = "#8a8a8a") + 
    geom_signif( comparisons = list(c("ND", "CT")),
                 map_signif_level=F, test = "t.test", test.args = list(paired = T)) +
    scale_fill_manual(name = NULL,
                      labels = task_names,
                      values = color_manual_task) +
    scale_x_discrete(labels = task_names) +
    
    mytheme_basic 
}

ETPlotData_fun <-  function(par) {
  ETPlotData %>% 
    ggplot(aes(x=EyeTask, y=get(par), fill=EyeTask)) +  
    geom_boxplot(outlier.size = 0.5, color = "#8a8a8a") + 
    geom_signif( comparisons = list( c("Left-ND","Left-CT"), c("Right-ND","Right-CT") ),
                 map_signif_level=F, test = "t.test", test.args = list(paired = T) ) +   # wilcox.test
    scale_fill_manual(name = NULL,
                      labels = task_eye_names,
                      values = color_manual_task_eye) +
    scale_x_discrete(labels = task_eye_names) +
    
    mytheme_basic 
}


# task-------------------------------

task_variables <- c("ND", 
                    "CT")
task_labels <- c("Relaxed", 
                 "Stressed")

task_names <- set_names(task_labels, task_variables)

color_manual_task <- c(
  ND = "#56B4E9",
  CT = "#E69F00"
)

# eye task ---------------------------------

task_eye_variables <- c("Left-CT", 
                    "Left-ND",
                    "Right-CT",
                    "Right-ND")
task_eye_labels <- c("Left eye, Stressed", 
                 "Left eye, Relaxed",
                 "Right eye, Stressed",
                 "Right eye, Relaxed")
               
task_eye_names <- set_names(task_eye_labels, task_eye_variables)

color_manual_task_eye <- c("Left-CT" = "#FFEBCD", 
                       "Left-ND" = "#82EEFD",
                       "Right-CT"= "#E69F00",
                       "Right-ND"= "#56B4E9")

# conditions-------------------------------


condi_variables <- c("Relaxed", 
                    "Stressed",
                    "Baseline",
                    "Flush",
                    "Tracer decay")

condi_labels <- c("Relaxed", 
                 "Stressed",
                 "Baseline",
                 "Flush",
                 "Tracer decay")

condi_names <- set_names(condi_labels, condi_variables)

color_manual_condi <- c(
  Relaxed = "#56B4E9",
  Stressed = "#E69F00",
  `Tracer decay` = "#bebada",
  Baseline = "#8dd3c7",
  Flush = "#b3de69"
  
)

# particles ---------------------------------------------------

particle_type_variables <- c("total" ,
                             "unknown",
                             "non_fl" ,
                             "fl_all" ,
                             "fl1"    ,
                             "fl2"    ,
                             "fl3"    ,
                             "A"      ,
                             "B"      ,
                             "C"      ,
                             "AB"     ,
                             "AC"     ,
                             "BC"     ,
                             "ABC"  
)

particle_type_labels <- c(
  "PM",
  "Unknown",
  "non-FBAP",
  "FBAP",
  "FL1", 
  "FL2", 
  "FL3", 
  "A",
  "B",
  "C",
  "AB",
  "AC",
  "BC",
  "ABC")

particle_type_names <- set_names(particle_type_labels, particle_type_variables)



colors_manual_particles <- c(  
  total = "black", 
  unknown = "#E5D8BD",
  non_fl = "#7f7f7f",
  fl_all = "#8c574c", 
  fl1 = "#f69696",
  fl2 = "#aec7e8",
  fl3 = "#fcba78",
  A   = "#fe0000",
  B   = "#0808ce",
  C   = "#ff8532",
  AB  = "#4ba847",
  AC  = "#ffa8a7",
  BC  = "#cc00ff",
  ABC = "#47c6f3") 

#themes---------------------------------------------
mytheme_basic <- theme(
  plot.title = element_text(size = 12, vjust = 0, face = "bold"),
  axis.text.x = element_text(size = 12, hjust=.5, vjust=1, colour="black"),
  axis.text.y = element_text(size = 12, hjust=1, vjust=.5, colour="black"),
  axis.title.y = element_text(size = 12, color = "black", face = "bold", vjust = 0.5, hjust = 0.5),
  axis.title.x = element_text(size = 12, color = "black", face = "bold", vjust = 0.5, hjust = 0.5),
  axis.line = element_line(color = "black"),
  panel.grid.major=element_blank(),
  panel.grid.minor=element_blank(),
  # panel.background=element_rect(fill='white',colour='black'),
  legend.text = element_text(size = 12),
  legend.key = element_rect(colour = NA, fill = NA),
  panel.background = element_blank(),
  # legend.position = "bottom",
  # legend.direction = "horizontal",
  # legend.key.size= unit(0.3, "cm"),
  # legend.margin = margin(0,0,0,0,"cm"),
  legend.title = element_text(face = "bold", size = 12),
  strip.background = element_rect(colour= NA, fill=NA),
  strip.text = element_text(face = "bold", size = 12)
)
