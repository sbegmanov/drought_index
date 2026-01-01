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

buffered_end <- today() - 5
buffered_start <- buffered_end - 30

# anti_join(prcp_data, station_data, by = "id")
# anti_join(station_data, prcp_data, by = "id")

lat_long_prcp <- inner_join(prcp_data, station_data, by = "id") |>
    filter((year != first_year & year != last_year) | year == year(buffered_end)) |>
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

# different month, same year
# end <- format(buffered_end, "%B %d, %Y")
# start <- format(buffered_start, "%B %d")

# buffered_end <- as.Date("2025-10-31")
# buffered_start <- buffered_end - 30

# same month, same year
# end <- format(buffered_end, "%d, %Y")
# start <- format(buffered_start, "%B %d")

#! different month, different year
# end <- format(buffered_end, "%B %d, %Y")
# start <- format(buffered_start, "%B %d, %Y")



end <- case_when(
    month(buffered_start) != month(buffered_end) ~ format(buffered_end, "%B %d, %Y"),
    month(buffered_start) == month(buffered_end) ~ format(buffered_end, "%d, %Y"),
    TRUE ~ NA_character_
)

start <- case_when(
    year(buffered_start) != year(buffered_end) ~ format(buffered_start, "%B %d, %Y"),
    year(buffered_start) == year(buffered_end) ~ format(buffered_start, "%B %d"),
    TRUE ~ NA_character_
)

data_range <- glue("{start} to {end}")

lat_long_prcp |>
    group_by(latitude, longtitude) |>
    mutate(z_score = (mean_prcp - mean(mean_prcp)) / sd(mean_prcp), n = n()) |>
    ungroup() |>
    filter(n >= 50 & year == year(buffered_end)) |>
    select(-n, -mean_prcp, -year) |>
    mutate(z_score = if_else(z_score > 2, 2, z_score),
           z_score = if_else(z_score < -2, -2, z_score)) |>
    # summarize(min = min(z_score), max = max(z_score))
    # |> filter(latitude == 42 & longtitude == -84, year == 2025)
    ggplot(aes(x = longtitude, y = latitude, fill = z_score)) +
    geom_tile() +
    coord_fixed() +
    scale_fill_gradient2(
        name = NULL,
        low = "#d8b365",
        mid = "#f5f5f5",
        high = "#5ab4ac",
        midpoint = 0,
        breaks = c(-2, -1, 0, 1, 2),
        labels = c("<-2", "-1", "0", "1", ">2")
    ) +
    labs(
        title = glue("Amount of precipitation for {data_range}"),
        substitute = "Standardized Z-scores for at least the past 50 years",
        capton = "Precipiation data collected from GHCN daily data at NOAA"
    ) +
    theme(
        plot.background = element_rect(fill = "black", color = "black"),
        panel.background = element_rect(fill = "black"),
        plot.title = element_text(color = "#f5f5f5", size = 18, family = "roboto-slab"),
        plot.subtitle = element_text(color = "#f5f5f5", size = 12, family = "montserrat"),
        plot.caption = element_text(color = "#f5f5f5"),
        panel.grid = element_blank(), 
        legend.background = element_blank(),
        legend.text = element_text(color = "#f5f5f5", family = "montserrat"),
        legend.position = c(0.15, 0.0),
        legend.direction = "horizontal",
        legend.key.height = unit(0.25, "cm"),
        axis.text = element_blank()
    )

ggsave("visuals/world_drought_on_2025_data.png", height = 4, width = 8)
