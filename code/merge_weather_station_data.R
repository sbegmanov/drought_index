#!/usr/bin/env Rscript

library(tidyverse)
library(lubridate)
library(glue)
library(showtext)

font_add_google("Roboto slab", family = "roboto-slab")
font_add_google("Montserrat", family = "montserrat")
showtext_auto()

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

end <- format(today(), "%B %d, %Y")
start <- format(today() - 30, "%B %d, %Y")


lat_long_prcp |>
    group_by(latitude, longtitude) |>
    mutate(z_score = (mean_prcp - mean(mean_prcp)) / sd(mean_prcp), n = n()) |>
    ungroup() |>
    filter(n >= 50 & year == 2025) |>
    select(-n, -mean_prcp, -year) |>
    mutate(z_score = if_else(z_score > 2, 2, z_score),
           z_score = if_else(z_score < -2, -2, z_score)) |>
    # summarize(min = min(z_score), max = max(z_score))
    # |> filter(latitude == 42 & longtitude == -84, year == 2025)
    ggplot(aes(x = longtitude, y = latitude, fill = z_score)) +
    geom_tile() +
    coord_fixed() +
    scale_fill_gradient2(name = NULL, low = "#d8b365", 
                         mid = "#f5f5f5",
                         high = "#5ab4ac", 
                         midpoint = 0,
                         breaks = c(-2, -1, 0, 1, 2),
                         labels = c("<-2", "-1", "0", "1", ">2")) +
    labs(title = glue("Amount of precipitation for {start} to {end}"),
         substitute = "Standardized Z-scores for at least the past 50 years",
        capton = "Precipiation data collected from GHCN daily data at NOAA") +
    theme(plot.background = element_rect(fill = "black", color = "black"),
        panel.background = element_rect(fill = "black"),
        plot.title = element_text(color = "#f5f5f5", size = 18, family = "robot-slab"),
        plot.subtitle = element_text(color = "#f5f5f5", family = "montserrat"),
        plot.caption = element_text(color = "#f5f5f5"),
        panel.grid = element_blank(), 
        legend.background = element_blank(),
        legend.text = element_text(color = "#f5f5f5"),
        legend.position = c(0.15, 0.0),
        legend.direction = "horizontal",
        legend.key.height = unit(0.25, "cm"),
        axis.text = element_blank())

ggsave("visuals/world_drought_on_2025_data.png", height = 4, width = 8)
