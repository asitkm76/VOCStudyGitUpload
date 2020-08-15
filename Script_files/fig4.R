source("./Script_files/functions.R")

DT <- data.table(
  day = c(1:4,1:4),
task = c(rep("CT",4), rep("ND",4)),
E_co2 = c(152.316 ,161.46, 144.49, 148.31,
          138.98, 138.28, 127.00, 136.37),
E_isop = c( 517.36, 469.36, 619.54, 642.92,
            503.61, 463.96, NA, 422.71)
) %>% .[, `:=`(task = factor(task, levels = c("ND", "CT")),
               E_co2 = E_co2 / 5,
               E_isop = E_isop /5 )]

mean_DT_co2 <- DT %>% .[, .(mean_E_co2 = mean(E_co2, na.rm = T) ), by = task] 
mean_DT_isop <- DT %>% .[, .(mean_E_isop = mean(E_isop, na.rm = T) ), by = task] 

p1 <- DT %>%
  ggplot() +
  geom_point(aes(day, E_co2, color = task), size = 3) +
  geom_hline(data = mean_DT_co2, aes(yintercept = mean_E_co2, color = task), size = 2, alpha =0.5) +
  facet_grid(.~task, labeller = labeller(task = task_names)) +
  xlab("Day") +
  
  ylab(expression( bold("C"*O[2]*" emission (g/h/p)") ) ) +
  scale_color_manual(name = NULL,
                    labels = task_names,
                    values = color_manual_task) +
  mytheme_basic

p2 <-DT %>%
  ggplot() +
  geom_point(aes(day, E_isop, color = task), size = 3) +
  geom_hline(data = mean_DT_isop, aes(yintercept = mean_E_isop, color = task), size = 2, alpha =0.5) +
  facet_grid(.~task, labeller = labeller(task = task_names)) +
  ylab(expression( bold("Isoprene emission ("*mu*"g/h/p)") )) +
  xlab("Day") +
  scale_color_manual(name = NULL,
                     labels = task_names,
                     values = color_manual_task) +
  mytheme_basic

p1 + p2 + plot_layout(guides = "collect") & theme(legend.position = "right") & guides(color = F)

# ggsave("R/plots/Fig4_v2.pdf", 
#        width = 8, height = 3.5, useDingbats=FALSE)
