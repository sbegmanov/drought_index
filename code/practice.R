library(tidyverse)
library(archive)


quadruple <- function(x) {
    c(glue("VALUE{x}"), glue("MFLAG{x}"), glue("QFLAG{x}"), glue("SFLAG{x}"))
}

widths <- c(11, 4, 2, 4, rep(c(5, 1, 1, 1), 31))
headers <- c("ID", "YEAR", "MONTH", "ELEMENT", unlist(map(1:31, quadruple)))

read_fwf("data/temp/xaa.gz",
    fwf_widths(widths, headers),
    na = c("NA", "-9999"),
    col_types = cols(.default = col_character()),
    col_select = c(ID, YEAR, MONTH, starts_with("VALUE"))
) |> # removed ELEMENT,
    rename_all(tolower) |>
    # filter(element == "PRCP") |>
    # select(-element) |>
    pivot_longer(cols = starts_with("value"), names_to = "day", values_to = "prcp") |>
    drop_na() |>
    filter(prcp != 0) |> # update
    mutate(
        day = str_replace(day, "value", ""),
        date = ymd(glue("{year}-{month}-{day}")),
        prcp = as.numeric(prcp) / 100
    ) |>
    select(id, date, prcp) |>
    slice_sample(n = 1000) -> d

tday_julian <- yday(today())
window <- 30

d |>
    mutate(
        julian_day = yday(date),
        diff = tday_julian - julian_day,
        is_in_window = case_when(
            diff < window & diff > 0 ~ TRUE,
            diff > window ~ FALSE,
            tday_julian < window & diff + 365 < window ~ TRUE,
            diff < 0 ~ FALSE
            
        ),
        year = year(date),
        year = if_else(diff < 0 & is_in_window, year + 1, year)
    ) |>
    filter(is_in_window) |>
    group_by(id, year) |>
    summarize(prcp = sum(prcp), .groups = "drop") |> 
    write_tsv("data/composite_dly.tsv")



# dly_files <- list.files("data/ghcnd_all", full.names = TRUE)
dly_files <- archive("data/ghcnd_all.tar.gz") |>
    filter(str_detect(path, "dly")) |>
    slice_sample(n = 12) |>
    pull(path)
# Sys.time()
dly_files |>
    map_dfr(~ read_fwf(archive_read("data/ghcnd_all.tar.gz", .x),
        fwf_widths(widths, headers),
        na = c("NA", "-9999"),
        col_types = cols(.default = col_character()),
        col_select = c(ID, YEAR, MONTH, ELEMENT, starts_with("VALUE"))
    )) |>
    rename_all(tolower) |>
    filter(element == "PRCP") |>
    select(-element) |>
    pivot_longer(
        cols = starts_with("value"),
        names_to = "day", values_to = "prcp"
    ) |>
    drop_na() |>
    mutate(
        day = str_replace(day, "value", ""),
        date = ymd(glue("{year}-{month}-{day}")),
        prcp = as.numeric(prcp) / 100
    ) |>
    select(id, date, prcp) |>
    write_tsv("data/composite_dly.tsv")

# rounding numbers
tibble(x = seq(-2, 2, 0.1),
round = round(x),
trunc = trunc(x),
floor = floor(x),
ceiling = ceiling(x),
integer = as.integer(x),
signif = signif(x, digits = 1)) |> print(n = Inf)

x <- 100 * pi
round(x)
round(x, digits = -2)
round(x, digits = -1)
round(x, digits = 4)

signif(x, digits = 1)
signif(x, digits = 3)
signif(x, digits = 6)
