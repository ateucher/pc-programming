library(dplyr)

# Starting code for `to_z()`

penguins |>
  mutate(
    z_bill_len = (bill_len - mean(bill_len, na.rm = TRUE)) /
      sd(bill_len, na.rm = TRUE),
    z_bill_dep = (bill_dep - mean(bill_dep, na.rm = TRUE)) /
      sd(bill_dep, na.rm = TRUE),
    z_flipper_len = (flipper_len - mean(flipper_len, na.rm = TRUE)) /
      sd(flipper_len, na.rm = TRUE),
    z_body_mass = (body_mass - mean(body_mass, na.rm = TRUE)) /
      sd(body_mass, na.rm = TRUE)
  )

to_z <- function(x) {
  (x - mean(x, na.rm = TRUE)) / sd(x, na.rm = TRUE)
}

penguins |>
  mutate(
    z_bill_len = to_z(bill_len),
    z_bill_dep = to_z(bill_dep),
    z_flipper_len = to_z(flipper_len),
    z_body_mass = to_z(body_mass)
  )

# add middle argument, with default value

to_z <- function(x, middle = 1) {
  trim = (1 - middle) / 2
  (x - mean(x, na.rm = TRUE, trim = trim)) / sd(x, na.rm = TRUE)
}

# See if you can add another argument to `to_z()` to allow the user to specify
# if `NA` values should be removed or not. Give it a default value.

to_z <- function(x, middle = 1, na.rm = TRUE) {
  trim = (1 - middle) / 2
  (x - mean(x, na.rm = na.rm, trim = trim)) / sd(x, na.rm = na.rm)
}

# Create a function called `percent_diff` that calculates the percent difference
# between two (vectors of) values

percent_diff <- function(x, y) {
  (abs(x - y) /
    ((x + y) / 2)) *
    100
}

# Create a function called `is_big()` that takes a numeric vector and outputs a
# logical vector indicating whether each value is larger than a specified
# quantile threshold. The function should have two arguments: the numeric vector
# and the quantile threshold (default to 0.75).

is_big <- function(x, thresh = 0.75) {
  thresh_val <- quantile(x, probs = thresh, na.rm = TRUE)
  x > thresh_val
}

is_big(penguins$bill_dep)

penguins |>
  group_by(species) |>
  mutate(long_bill = is_big(bill_len, thresh = 0.95))
