#!/usr/bin/env Rscript

library(tidyverse)

prcp_data <- read_tsv("data/ghcnd_tidy.tsv.gz")
station_data <- read_tsv("data/gchnd_regions_years.tsv")

# anti_join(prcp_data, station_data, by = "id")
# anti_join(station_data, prcp_data, by = "id")

lat_long_prcp <- inner_join(prcp_data, station_data, by = "id") |> 
filter((year != first_year & year != last_year) | year == 2025) |> 
group_by(latitude, longtitude, year) |>
summarize(mean_prcp = mean(prcp), .groups = "drop")
# |> summarize(n = n())

# lat_long_prcp |> ggplot(aes(x = n)) + geom_histogram()
# lat_long_prcp |> filter(n >= 100)

# this_year <- lat_long_prcp |> 
#     filter(year == 2025) |>
#     select(-year)


# inner_join(lat_long_prcp, this_year, by = c("latitude", "longtitude")) |>
#     rename(all_years = mean_prcp.x, this_year = mean_prcp.y) |>
#     group_by(latitude, longtitude) |>
#     # filter(latitude == 42 & longtitude == -84 & year == 2025)
#     # mutate(mean = mean(all_years),
#     #         sd = sd(all_years),
#     #         z_score = (this_year - mean(all_years)) / sd(all_years),
#     #         n = n()) |>
#     summarize(z_score = (min(this_year) - mean(all_years)) / sd(all_years),
#         n = n(),
#         .groups = "drop") |>
#     filter(n >= 50) |>
#     filter(latitude == 42 & longtitude == -84)


# # A tibble: 1 × 4
#   latitude longtitude z_score     n
#      <dbl>      <dbl>   <dbl> <int>
# 1       42        -84  -0.573    77

lat_long_prcp |>
    group_by(latitude, longtitude) |>
    mutate(z_score = (mean_prcp - mean(mean_prcp)) / sd(mean_prcp),
        n = n()) |>
    ungroup() |>
    filter(n >= 50 & year == 2025) |>
    select(-n, -mean_prcp, -year) 
    # |> filter(latitude == 42 & longtitude == -84, year == 2025)
