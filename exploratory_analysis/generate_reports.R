library(dplyr)
library(dlookr)
library(DataExplorer)

## load data

rain <- readRDS('data/rain.RDS')

## dlookr diagnose

rain %>%
  diagnose_report(output_format = 'html',
                  output_dir = '~/processo_cientista/exploratory_analysis/reports',
                  output_file = 'dlookr_diagnose.html',
                  browse = FALSE)

## dlookr eda

rain %>%
  eda_report(output_format = 'html',
             output_dir = '~/processo_cientista/exploratory_analysis/reports',
             output_file = 'dlookr_eda.html',
             browse = FALSE)

## DataExplorer

rain %>%
  create_report(y = 'raintomorrow',
                output_dir = '~/processo_cientista/exploratory_analysis/reports',
                output_file = 'dataexplorer.html')

