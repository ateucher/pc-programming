library("tidyverse")
library("readxl")
library("fs")

## Create a for loop to make and save a plot for each rodent site (plot)

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

## Exploring lists
my_list <- list(
  c(1, 2, 3),
  c("a", "b", "c"),
  data.frame(x = 1:3, y = c("A", "B", "C"))
)
my_list

my_named_list <- list(
  numbers = c(1, 2, 3),
  letters = c("a", "b", "c"),
  df = data.frame(x = 1:3, y = c("A", "B", "C"))
)
my_named_list
names(my_named_list)

## Our turn
data1952 <- read_excel("data/gapminder/1952.xlsx")
data1957 <- read_excel("data/gapminder/1957.xlsx")
data1962 <- read_excel("data/gapminder/1962.xlsx")
data1967 <- read_excel("data/gapminder/1967.xlsx")

data_manual <- bind_rows(data1952, data1957, data1962, data1967)

# What problems do you see so far?
# (I see one "real" problems, one philosophical problem)

# ?basename(), ?str_extract()
get_year <- function(x) {
  x |> basename() |> str_extract("[0-9]{4}")
}

get_year("taylor/swift/1989.txt")

# ?set_names()
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

###################################################################
##### Rodent plots with purrr

rodents <- read_csv("PortalData/Rodents/Portal_rodent.csv")

rodent_counts <- rodents |>
  filter(species == "DM") |>
  group_by(year, plot) |>
  summarise(n = n()) |>
  ungroup()

rodent_sites <- unique(rodent_counts$plot)

# Make a list of plot objects, one for each site
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

# Print all plots
site_plots

# Print one plot
site_plots[[15]]

# Use purrr::walk2() to save all plots
purrr::walk2(
  site_plots, # list of plot objects
  rodent_sites, # vector of site numbers
  \(p, n) {
    ggsave(
      filename = paste0(out_dir, "new_rodent_plot_", n, ".png"),
      plot = p
    )
  }
)
