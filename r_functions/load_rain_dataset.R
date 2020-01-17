load_rain_dataset <- function(){
  require(data.table)
  `%>%` <- magrittr::`%>%`

  rain_data_aus <- fread('data/rain_data_aus.csv', )
  wind_table_01 <- fread('data/wind_table_01.csv')
  wind_table_02 <- fread('data/wind_table_02.csv')
  wind_table_03 <- fread('data/wind_table_03.csv')
  wind_table_04 <- fread('data/wind_table_04.csv')
  wind_table_05 <- fread('data/wind_table_05.csv')
  wind_table_06 <- fread('data/wind_table_06.csv')
  wind_table_07 <- fread('data/wind_table_07.csv')
  wind_table_08 <- fread('data/wind_table_08.csv')

  names(wind_table_01) <- names(wind_table_03)
  names(wind_table_02) <- names(wind_table_03)

  wind_data <- dplyr::bind_rows(wind_table_01,
                         wind_table_02,
                         wind_table_03,
                         wind_table_04,
                         wind_table_05,
                         wind_table_06,
                         wind_table_07,
                         wind_table_08)  %>%
    distinct()

  rain <- rain_data_aus %>%
    dplyr::inner_join(wind_data) %>%
    dplyr::distinct()

  return(rain)
}
