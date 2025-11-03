library(dplyr)

# Write a new summary function which calculates the median, maximum and minimum
# values of a variable in a dataset. Incorporate an argument to allow the
# summary to be performed grouped by another variable.

my_summary <- function(df, summary_var, group_var) {
  df |>
    group_by({{ group_var }}) |>
    summarise(
      median = median({{ summary_var }}, na.rm = TRUE),
      minimum = min({{ summary_var }}, na.rm = TRUE),
      maximum = max({{ summary_var }}, na.rm = TRUE),
      .groups = "drop"
    )
}

my_summary(penguins, bill_len, species)

# Improvement: Have a default of `NULL` for the grouping variable. Why?

my_summary <- function(df, summary_var, group_var = NULL) {
  df |>
    group_by({{ group_var }}) |>
    summarise(
      median = median({{ summary_var }}, na.rm = TRUE),
      minimum = min({{ summary_var }}, na.rm = TRUE),
      maximum = max({{ summary_var }}, na.rm = TRUE),
      .groups = "drop"
    )
}
