# VOC Study Repository
Data and codes associated with VOC emissions and psychological stress study

# Data from: Psychological stress increases human chemical emission: an experimental assessment

Gall, Elliott T.; Mishra, Asit K.; Li, Jiayu; Schiavon, Stefano; Laguerre,  Aurélie

## Usage Notes
Script_files .R and .m files
Please change the working directory as per the directory to which you download the folder.
For running the .R files, install all the packages mentioned in the functions.R file.
Data_files .csv and .xlsx files

This folder contains all the relevant data frames that may be imported by the relevant script files for processing and creation of the plots found in the source publication.

## Keywords
human emissions; bioeffluents; psychological stress; stress biomarkers; VOCs; isoprene

## Files

### Data_files
chamberConditions.xlsx – contains the indoor environmental parameters measured in the climatic chambers where the study took place, for all four days of study.

CO2AndIsoprene.csv – contains the average CO2 and Isoprene emissions from the participants on each study day, for both the relaxed and the stressed sessions.
etCO2DataMean.csv – contains the end tidal CO2 and and respiration rate of each participant (averaged over two minutes of measurments) taken at the end of each of relaxed and stressed session

ETPltData.csv – contains the pupil measurment data collected by the eye tracker. The data frame contains normalized values for maximu, mean, and median pupil diamter and the latency (time required to reach) of reaching maximum pupil dilation, during each of relaxed and stressed tasks. The data is provided separately for left and right eyes.

HRVPlotData.csv – contains the data for four parameters associated with ehart rate variability: minimum heart rate, mean RR interval, Sample entropy, and Percent of Very Low Frequency components’ power of the FFT of RR interval, time doamin data

RegressionSAAvsCO2andC5H8.csv – contains the session wise averaged values for stress biomarkers (salivary alpha amylase, minimum heart rate, mean RR, Sample entropy, and Percent of Very Low Frequency  power) and the emissions of carbon dioxide and isoprene from the participants. These data are used to generate Figure 5

saaSubjects.csv – contains the measured salivary alpha amylase (kIU per liter) values for each aprticpant, at the end of each of stressed and relaxed session

subjFeedback.csv – contains the responses given by participants on the questionnaire, measuring their subjective perception of the indoor evironment and their stress/fatigue level. 

### Script_files
fig2.R – the R script that can be used to generate Figure 2 in the main work. It relies on fucntions.R and loadData.R script files. It takes data from saaSubjects.csv, HRVPlotData.csv, and etCO2DataMean.csv.

fig3.R – the R script that can be used to generate Figure 3 in the main work.  It relies on fucntions.R and loadData.R script files. It takes data from chamberConditions.xlsx

fig4.R – the R script that can be used to generate Figure 3 in the main work.  It relies on fucntions.R script file. It has the data required contained in itself.

fig5.R – the R script that can be used to generate Figure 3 in the main work.  It relies on fucntions.R script file. It takes data from RegressionSAAvsCO2andC5H8.csv

figS2.R – the R script that can be used to generate Figure S2 in the supplementary information. It relies on fucntions.R and loadData.R script files. It takes data from ETPltData.csv

functions.R – contains the required R packages and themes for the plots

loadData.R – contains the R scripts used to import the data required for the different plots. 

