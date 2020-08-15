saa.subjects <- fread("./Data_files/saaSubjects.csv")   %>% .[, Task := factor(Task, levels = c("ND","CT") )]
etCO2DataMean <- fread("./Data_files/etCO2DataMean.csv") %>% .[, Task := factor(Task, levels = c("ND","CT") )]
HRVPlotData <- fread("./Data_files/HRVPlotData.csv")     %>% .[, HRVData.Task := factor(HRVData.Task, levels = c("ND","CT") )]
ETPlotData <- fread("./Data_files/ETPlotData.csv")       %>% .[, EyeTask := factor(EyeTask, levels = c("Left-ND","Left-CT","Right-ND","Right-CT") )]
subjFeedback <- fread("./Data_files/subjFeedback.csv")

# HRVPlotData[, HRVData.FFTVLFPowPcnt := 100-HRVData.FFTVLFPowPcnt]
# HRVPlotData[, HRVData.MeanRR := 1/HRVData.MeanRR * 1000]
# ETPlotData[, PDLat := 1/PDLat * 100]
HRVPlotData[, HRVData.FFTVLFPowPcnt := -HRVData.FFTVLFPowPcnt]
HRVPlotData[, HRVData.MeanRR := -HRVData.MeanRR]
ETPlotData[, PDLat := -PDLat]


chamber_conditions <- read.xlsx("./Data_files/chamberConditions.xlsx", sheet = "Sheet1", rows = c(1:11581), cols = c(1:8) ) %>% setDT()
chamber_conditions[, Time := as_datetime(Time * 86400, origin= "1899-12-30") %>% floor_date(., unit = "minutes")]

# read wibs data------------------------------

all_csv_files <- list.files(no.. = FALSE, full.names = TRUE, recursive = TRUE, pattern = ".csv")

WIBS_data_long_60_n <- all_csv_files[all_csv_files %like% "WIBS_data_long_60_n.csv"] %>% fread() %>% 
  .[, `:=`(datetime = as_datetime(datetime),
           bin = fct_inorder(bin),
           date = as_date(date),
           Da = (lower+upper)/2
  )]
WIBS_data_long_60_n[, particle_type := factor(particle_type, levels = c("total", "unknown", "non_fl", "fl_all", "fl1", "fl2", "fl3",  "A", "B", "C", "AB", "AC", "BC", "ABC"))]


# add wibs conditions --------------------------------------

measure_loc <- all_csv_files[all_csv_files %like% "measure_loc"] %>% fread() %>% 
  .[, `:=`(start_time = mdy_hm(start_time),
           end_time = mdy_hm(end_time)
  )] %>% .[, measure_loc_interval := (start_time %--% end_time)]


for (i in 1:length(measure_loc$measure_loc_interval)) {
  WIBS_data_long_60_n[  datetime %within% measure_loc$measure_loc_interval[i],
                        `:=`( 
                          meas_loc = measure_loc$item[i]
                        )]
}

WIBS_data_long_60_n[, loc_index := seq.int(.N), by = list(meas_loc, date)]


exp_condi <- all_csv_files[all_csv_files %like% "exp_condi"] %>% fread() %>% 
  .[, `:=`(start_time = mdy_hm(paste(date,start_time)),
           end_time = mdy_hm(paste(date,end_time))
  )] %>% .[, exp_condi_interval := (start_time %--% end_time)]

for (i in 1:length(exp_condi$exp_condi_interval)) {
  period_t <- exp_condi$exp_condi_interval[i]
  condition_t <- exp_condi$condition[i]
  WIBS_data_long_60_n[datetime %within% period_t ,
                      exp_condi := condition_t
                      ]
}

WIBS_data_long_60_n[, condi_index := seq.int(.N), by = list(exp_condi, date, bin, particle_type)]
