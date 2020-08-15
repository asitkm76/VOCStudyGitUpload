source("./Script_files/functions.R")

DT <- fread("./Data_files/RegressionSAAvsCO2andC5H8.csv")
DT[, FFTVLFPower:= -FFTVLFPower]
DT[, MeanRR:= -MeanRR]

DT_long <- DT %>% melt(id.var = c("Task", "CO2", "isoprene","Day"), 
            masure.vars = c("sAA" , "MeanRR",  "MinHR", "FFTVLFPower", "SampEn"),
            value.name = "value",
            variable.name = "item")

DT_long [, item := factor(item, levels = c("sAA" , "FFTVLFPower",  "MinHR", "SampEn" , "MeanRR"))]


p1 <- DT_long %>%
  ggplot(aes(value, CO2) ) +

  geom_smooth(method = lm, se = T, color = "#A0A0A0", fill = "#A0A0A0") +
  geom_point(aes(color = Task), size = 2) +

  scale_color_manual(name = NULL,
                    labels = task_names,
                    values = color_manual_task) +
  facet_grid(.~item, scales = "free") +
  ylab(expression( bold("C"*O[2]*" emission (g/h/p)") ) ) +
  
  stat_cor(aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")),label.y = 34, r.digits = 2) +
  
  mytheme_basic
 

p2 <- DT_long %>%
  ggplot(aes(value, isoprene) ) +
  
  geom_smooth(method = lm, se = T, color = "#A0A0A0", fill = "#A0A0A0") +
  geom_point(aes(color = Task), size = 2) +
  
  scale_color_manual(name = NULL,
                     labels = task_names,
                     values = color_manual_task) +
  facet_grid(.~item, scales = "free") +
  ylab(expression( bold("Isoprene emission ("*mu*"g/h/p)") )) +
  
  stat_cor(aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")),label.y = 140, r.digits = 2) +
  
  mytheme_basic

p1+p2 + plot_layout( ncol = 1 , guides = "collect") & theme( legend.position = "top")

# ggsave("R/plots/Fig5_ver3.pdf", 
#        width = 10, height = 7, useDingbats=FALSE)
