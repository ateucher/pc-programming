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
  nsim = 500,
  alpha = 0.2
) {
  library(simr)
  fixef(model)[yearcol] <- (log(fxsize))
  model_extended <- extend(model, along = yearcol, n = extend_n)
  result <- model_extended |>
    powerSim(
      nsim = nsim,
      alpha = alpha
    ) |>
    summary() |>
    as.data.frame()

  dplyr::mutate(result, fxsize = fxsize, Design = "Full dataset")
}

fx_sizes <- seq(1.01, 1.05, by = 0.01)

res_list <- map(
  fx_sizes,
  \(x) run_pa(rodent_mod, x, nsim = 10)
)

power_results <- list_rbind(res_list)
power_results

##########

# We can do this in parallel to make it faster. Let's try with 100 simulations
# with 10 effect sizes

fx_sizes <- seq(1.01, 1.10, by = 0.01)

tictoc::tic("Sequential")
res_list <- map(
  fx_sizes,
  \(x) run_pa(rodent_mod, x, nsim = 100)
)
tictoc::toc()

# This is weird, we have to add the data back into the model object so that
# when it gets sent into the parallel workers it has everything it needs
getData(rodent_mod) <- rodent_counts

parallel::detectCores()

tictoc::tic("Parallel, 10 workers")
mirai::daemons(10)

res_list <- map(
  fx_sizes,
  in_parallel(
    \(x) run_pa(model, x, nsim = 100),
    # need to send the objects into the workers
    run_pa = run_pa,
    model = rodent_mod
  )
)

mirai::daemons(0)
tictoc::toc()
