#!/usr/bin/env Rscript

library(tidyverse)

prcp_data <- read_tsv("data/ghcnd_tidy.tsv.gz")
station_data <- read_tsv("data/gchnd_regions_years.tsv")

# anti_join(prcp_data, station_data, by = "id")
# anti_join(station_data, prcp_data, by = "id")

lat_long_prcp <- inner_join(prcp_data, station_data, by = "id") |> 
filter((year != first_year & year != last_year) | year == 2025) |> 
group_by(latitude, longtitude, year) |>
summarize(mean_prcp = mean(prcp)) |>
summarize(n = n())

lat_long_prcp |> ggplot(aes(x = n)) + geom_histogram()
lat_long_prcp |> filter(n >= 100)
