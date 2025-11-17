library(purrr)

penguins_islands <- c("Torgersen", "Biscoe", "Dream")

walk(penguins_islands, \(x) {
  quarto::quarto_render(
    "solutions/05-quarto.qmd", 
    output_file = file.path(paste0("penguins_", x, ".pdf")), 
    execute_params = list(island = x))
})
