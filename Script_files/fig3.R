source("./Script_files/functions.R")
source("./Script_files/loadData.R")

#isoprene data
isoprene_dt <- data.table(
  condition = c("Baseline", "Relaxed", "Stressed"),
  isoprene_val = c(1.87, 5.85, 6.39),
  isoprene_std = c(0.64, 0.47, 0.25))



condition_dt <- data.table(
  condition = c("Baseline","Stressed", "Flush", "Relaxed", "Tracer decay"),
  start = ymd_hm(c("2019-09-10 11:25","2019-09-10 14:18", "2019-09-10 15:05", "2019-09-10 15:24", "2019-09-10 16:11")),
  end = ymd_hm(c("2019-09-10 11:55","2019-09-10 14:48", "2019-09-10 15:15", "2019-09-10 15:53", "2019-09-10 16:45")))

condi_dt <- isoprene_dt[condition_dt, on = .(condition)]

condi_dt[, mid := start + (end-start)/2]



fig_3_2 <- chamber_conditions %>% 
  ggplot() +
  geom_line(aes(Time, TempChamber), color = "#e41a1c") +
  geom_line(aes(Time, RHChamber/2), color = "#377eb8") +
  # scale_x_datetime()
  scale_x_datetime(breaks = "1 hours", date_labels = "%H:%M", expand = c(0, 0)) +
  scale_y_continuous(sec.axis = sec_axis(~.*2, name = "RH (%)" ), expand = c(0,0)) +
  ylab("Temp. (°C)" ) +
  coord_cartesian(xlim = c(ymd_hm( c("2019-09-10 11:00", "2019-09-10 19:00"))) ) +
  mytheme_basic+
  theme( axis.text.x = element_blank(),
         axis.title.x = element_blank(),
         panel.background = element_rect(fill='white', colour='black'),
         axis.line.y.left = element_line(colour = "#e41a1c"),
         axis.ticks.y.left = element_line(colour = "#e41a1c"),
         axis.text.y.left = element_text(colour = "#e41a1c"),
         axis.title.y.left = element_text(colour = "#e41a1c"),
         axis.line.y.right = element_line(colour = "#377eb8"),
         axis.ticks.y.right = element_line(colour = "#377eb8"),
         axis.text.y.right = element_text(colour = "#377eb8"),
         axis.title.y.right = element_text(colour = "#377eb8") )


fig_3_5 <- chamber_conditions %>% 
  ggplot() +
  geom_line(aes(Time,  CO2Chamber)) +
  ylab(expression( bold(CO[2]*" (ppm)") ) ) +
  # scale_x_datetime()
  scale_x_datetime(name = "Date and time", breaks = "1 hours", date_labels = "%H:%M", expand = c(0, 0)) +
  coord_cartesian(xlim = c(ymd_hm( c("2019-09-10 11:00", "2019-09-10 19:00"))), ylim = c(400, 1000) ) +
  mytheme_basic +
  theme( 
    panel.background = element_rect(fill='white', colour='black') )


fig_3_4 <- condi_dt %>%
  ggplot(aes(mid, isoprene_val)) +

   geom_errorbar(aes(ymin = isoprene_val - isoprene_std, ymax = isoprene_val + isoprene_std), width = 500) + 
  geom_errorbarh(aes(xmin = start, xmax = end), height = 1) +
  geom_point(color = "#4daf4a", size = 2) + 
  scale_x_datetime(breaks = "1 hours", date_labels = "%H:%M", expand = c(0, 0)) +
  scale_y_continuous(breaks = c(0,5,10), expand = c(0, 0)) +
  coord_cartesian(xlim = c(ymd_hm( c("2019-09-10 11:00", "2019-09-10 19:00"))) , ylim = c(0,10)) +
  ylab(expression( bold("Isoprene ("*mu*g/m^3*")") ) ) +
  mytheme_basic +
  theme( 
    panel.background = element_rect(fill='white', colour='black'),
    axis.text.x = element_blank(),
    axis.title.x = element_blank())
# fig_3_4

fig_3_1 <- condi_dt %>% ggplot() +
  geom_rect(aes(xmin = start, xmax = end, ymin = -1, ymax = 1, fill = condition), color = NA) +
  geom_text(aes(x = mid, y = 0, label = condition), size = 4) +
  scale_x_datetime(breaks = "1 hours", date_labels = "%H:%M", expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  coord_cartesian(xlim = c(ymd_hm( c("2019-09-10 11:00", "2019-09-10 19:00"))) , ylim = c(-1,1)) +
  scale_fill_manual(name = NULL,
                    labels = condi_names,
                    values = color_manual_condi) +
  guides(fill = FALSE) +
  mytheme_basic +
    theme( 
      panel.background = element_rect(fill='white', colour='black'),
      axis.title.y=element_blank(),
            axis.text.y = element_blank(),
           axis.ticks.y = element_blank(),
            axis.line.y = element_blank(),
            axis.text.x = element_blank(),
           axis.title.x = element_blank())
 
fig_3_wibs <- WIBS_data_long_60_n[datetime %within% interval(period_of_plot[1], period_of_plot[2])] %>% 
  .[particle_type %in% c("fl_all", "non_fl")] %>% 
  .[,.(conc = sum(conc, na.rm = T) ), by = .(datetime, date, particle_type, meas_loc, exp_condi)] %>%
  .[particle_type == "non_fl", conc := conc/3] %>% 
  ggplot() +
  geom_rect(data = measure_loc, aes(xmin = start_time, xmax = end_time, ymin = 1.9, ymax = 2, fill = item), color = NA) +
  geom_line(aes(datetime, conc, color = particle_type)) + 
  
  scale_y_continuous(sec.axis = sec_axis(~.*3, name = expression(bold("non-FBAP (#/"*cm^3*")") ) ), expand = c(0,0)) +
  
  scale_fill_manual(name="Sampling location",
                    labels= c("Return","Supply"),
                    values = c("#fccde5","#ccebc5")) +
  scale_color_manual(name="Particle type",
                     labels= particle_type_names,
                     values = colors_manual_particles) +
  
  scale_x_datetime(breaks = "1 hours", date_labels = "%H:%M", expand = c(0, 0)) +
  
  coord_cartesian(xlim = period_of_plot) +
  
  
  guides(color = F ) +
  xlab("Time") + 
  ylab(expression(bold("FBAP (#/"*cm^3*")") ) ) + 
  mytheme_basic + 
  theme(
    legend.position = c(0.22,0.85),
    legend.direction = "horizontal",
    legend.key.size = unit(0.3, "cm"),
    legend.background = element_blank(),
    # panel.background = element_rect(fill='white', colour='black'),
    axis.line.y.left = element_line(colour = "#8c574c"),
    axis.ticks.y.left = element_line(colour = "#8c574c"),
    axis.text.y.left = element_text(colour = "#8c574c"),
    axis.title.y.left = element_text(colour = "#8c574c"),
    axis.line.y.right = element_line(colour = "#7f7f7f"),
    axis.ticks.y.right = element_line(colour = "#7f7f7f"),
    axis.text.y.right = element_text(colour = "#7f7f7f"),
    axis.title.y.right = element_text(colour = "#7f7f7f"),
    axis.text.x = element_blank(),
    axis.title.x = element_blank())

fig_3_1 + fig_3_2  + fig_3_wibs + fig_3_4 + fig_3_5 + plot_layout(ncol = 1, heights = c(0.3,1,1.5,1.2,1.5))

# ggsave("R/plots/Fig3.pdf", 
#        width = 8, height = 8, useDingbats=FALSE)
