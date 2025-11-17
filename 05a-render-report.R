library(purrr)

penguins_islands <- c("Torgersen", "Biscoe", "Dream")

walk(penguins_islands, \(x) {
  # render the report with quarto::quarto_render()
})
