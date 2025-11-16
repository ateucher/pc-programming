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

rodent_sites <- # vector of plot IDs

out_dir <- "figures/rodent_sites/"
dir_create(out_dir)

for () {
  site_data <- # create a data frame for this plot

  site_plot <- ggplot() +
    geom_point() +
    labs(
      title = # Unique title for this plot,
      x = "Year",
      y = "Count of rodents"
    )

  ggsave(
    filename = # unique filename for this plot,
    plot = site_plot
  )
}

#### Functional programming with purrr

## Our turn
data1952 <- read_excel("data/gapminder/1952.xlsx")
data1957 <- read_excel("data/gapminder/1957.xlsx")
data1962 <- read_excel("data/gapminder/1952.xlsx")
data1967 <- read_excel("data/gapminder/1967.xlsx")

data_manual <- bind_rows(data1952, data1957, data1962, data1967)

# What problems do you see so far?
# (I see two "real" problems, one philosophical problem)

# ?basename(), ?str_extract()
get_year <- function(x) {

}

get_year("taylor/swift/1989.txt")

# ?as.list(), ?set_names()
paths <-
  # get the filepaths from the directory
  fs::dir_ls("data/gapminder") |>
  # extract the year as names

# ?read_excel(), ?list_rbind(), ?parse_number()
data <-
  paths |>
  # read each file from excel, into data frame
  # set list-names as column `year`
  # bind into single data-frame
  # convert year to number

###################################################################
##### Rodent plots with purrr

site_plots <- purrr::map(
  rodent_sites,
  \(p) {
    site_data <- # create a data frame for this plot

    site_plot <- ggplot() +
    geom_point() +
    labs(
      title = # Unique title for this plot,
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
      filename = # unique filename for this plot,
      plot = # plot
  )
)
