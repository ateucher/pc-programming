library(dplyr)
library(purrr)
library(lme4)
library(simr)

rodents <- read_csv("PortalData/Rodents/Portal_rodent.csv")

rodent_counts <- rodents |>
  filter(species == "DM") |>
  group_by(year, plot) |>
  summarise(n = n()) |>
  ungroup() |>
  mutate(
    plot = factor(plot),
    nyear = scale(year)
  )

rodent_mod <- glmer.nb(
  n ~ nyear + (1 | plot),
  data = rodent_counts
)

run_pa <- function(
  model,
  fxsize,
  yearcol = "nyear",
  extend_n = 10,
  nsim = 100,
  alpha = 0.2
) {
  fixef(model)[yearcol] <- (log(fxsize))
  model_extended <- extend(model, along = yearcol, n = extend_n)
  result <- model_extended |>
    powerSim(
      nsim = nsim,
      alpha = alpha
    ) |>
    summary() |>
    as.data.frame()

  mutate(result, fxsize = fxsize, Design = "Full dataset")
}

fx_sizes <- seq(1.01, 1.05, by = 0.01)

res_list <- map(
  fx_sizes,
  \(x) run_pa(rodent_mod, x, nsim = 10)
)

power_results <- list_rbind(res_list)
power_results
