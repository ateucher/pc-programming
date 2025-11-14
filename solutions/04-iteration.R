library("tidyverse")
library("readxl")
library("fs")

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
  # get the filepaths from the directory
  fs::dir_ls("data/gapminder") |>
  # extract the year as names
  set_names(get_year)

paths

# ?read_excel(), ?list_rbind(), ?parse_number()
data <-
  paths |>
  # read each file from excel
  map(read_excel) |>
  # keep only non-null elements
  # set list-names as column `year`
  # bind into single data-frame
  list_rbind(names_to = "year") |>
  # convert year to number
  mutate(year = parse_number(year))
