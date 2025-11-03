library(dplyr)

# Add a check to `my_summary()` to ensure that the `summary_var` is numeric. If
# not, throw an error. Hint: Use `dplyr::pull` to get a column from a data frame
# in a data-masking context.

my_summary <- function(df, summary_var, group_var = NULL) {
  var <- pull(df, {{ summary_var }})

  if (!is.numeric(var)) {
    stop("`summary_var` must be a column of numeric values")
  }

  df |>
    group_by(pick({{ group_var }})) |>
    summarise(
      median = median({{ summary_var }}, na.rm = TRUE),
      minimum = min({{ summary_var }}, na.rm = TRUE),
      maximum = max({{ summary_var }}, na.rm = TRUE),
      .groups = "drop"
    )
}

# Add a warning to `to_z()` if the input vector has fewer than 3 non-NA values,
# since the standard deviation may not be meaningful in that case.

to_z <- function(x, middle = 1, na.rm = TRUE) {
  n_not_na <- sum(!is.na(x))
  if (n_not_na < 3) {
    warning("There are fewer than 3 non-missing values in `x`")
  }

  trim = (1 - middle) / 2
  (x - mean(x, na.rm = na.rm, trim = trim)) / sd(x, na.rm = na.rm)
}
