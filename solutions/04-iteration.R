library("tidyverse")
library("readxl")
library("fs")

## Create a for loop to make and save plots for each rodent site (plot)

rodents <- read_csv("PortalData/Rodents/Portal_rodent.csv")

rodent_counts <- rodents |>
  filter(species == "DM") |>
  group_by(year, plot) |>
  summarise(n = n()) |>
  ungroup()

rodent_sites <- unique(rodent_counts$plot)
out_dir <- "figures/rodent_sites/"
dir_create(out_dir)

for (p in rodent_sites) {
  site_data <- rodent_counts |> filter(plot == p)

  site_plot <- ggplot(site_data, aes(x = year, y = n)) +
    geom_point() +
    labs(
      title = paste("Rodent counts for Plot", p),
      x = "Year",
      y = "Count of rodents"
    )

  ggsave(
    filename = paste0(out_dir, "rodent_plot_", p, ".png"),
    plot = site_plot
  )
}

#### Functional programming with purrr

## Our turn
data1952 <- read_excel("data/gapminder/1952.xlsx")
data1957 <- read_excel("data/gapminder/1957.xlsx")
data1962 <- read_excel("data/gapminder/1962.xlsx")
data1967 <- read_excel("data/gapminder/1967.xlsx")

data_manual <- bind_rows(data1952, data1957, data1962, data1967)

# What problems do you see so far?
# (I see two "real" problems, one philosophical problem)

# ?basename(), ?str_extract()
get_year <- function(x) {
  # ^\\d+ - starts with one or more digits
  x |> basename() |> str_extract("^\\d+")
}

get_year("taylor/swift/1989.txt")

# ?set_names(), ?as.list()
paths <-
  fs::dir_ls("data/gapminder") |>
  set_names(get_year)

paths

# ?read_excel(), ?list_rbind(), ?parse_number()
data <-
  paths |>
  map(read_excel) |>
  list_rbind(names_to = "year") |>
  mutate(year = parse_number(year))

# Rodent plots with purrr

site_plots <- purrr::map(
  rodent_sites,
  \(p) {
    site_data <- rodent_counts |> filter(plot == p)

    site_plot <- ggplot(site_data, aes(x = year, y = n)) +
      geom_point() +
      geom_line() +
      labs(
        title = paste("Rodent counts for Plot", p),
        x = "Year",
        y = "Count of rodents"
      )
  }
)

purrr::walk2(
  site_plots,
  rodent_sites,
  \(p, n) {
    ggsave(
      filename = paste0(out_dir, "new_rodent_plot_", n, ".png"),
      plot = p
    )
  }
)
