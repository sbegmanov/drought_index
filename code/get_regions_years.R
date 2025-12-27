#!/usr/bin/env Rscript

library(tidyverse)

# Inventory
# ------------------------------
# Variable   Columns   Type
# ------------------------------
# ID            1-11   Character
# LATITUDE     13-20   Real
# LONGITUDE    22-30   Real
# ELEMENT      32-35   Character
# FIRSTYEAR    37-40   Integer
# LASTYEAR     42-45   Integer
# ------------------------------

read_fwf("data/ghcnd-inventory.txt",
col_positions = fwf_cols(
    id = c(1, 11),
    latitude = c(13, 20),
    longtitude = c(22, 30),
    element = c(32, 35),
    first_year = c(37, 40),
    last_year = c(42, 45))) |>
    filter(element == "PRCP") |>
mutate(latitude = round(latitude, 0),
longtitude = round(longtitude, 0)) |>
group_by(longtitude, latitude) |>
mutate(region = cur_group_id()) |>
select(-element) |>
write_tsv("data/gchnd_regions_years.tsv")
