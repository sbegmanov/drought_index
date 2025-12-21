library(tidyverse)
library(archive)




 read_fwf(dly_files,
        fwf_widths(widths, headers),
        na = c("NA", "-9999"),
        col_types = cols(.default = col_character()),
        col_select = c(ID, YEAR, MONTH, ELEMENT, starts_with("VALUE"))) |>
    rename_all(tolower) |>
    filter(element == "PRCP") |>
    select(-element) |>
    pivot_longer(cols = starts_with("value"),
    names_to = "day", values_to = "prcp") |>
    drop_na() |>
    mutate(day = str_replace(day, "value", ""),
    date = ymd(glue("{year}-{month}-{day}")),
    prcp = as.numeric(prcp) / 100) |>
    select(id, date, prcp) |>
    write_tsv("data/composite_dly.tsv")