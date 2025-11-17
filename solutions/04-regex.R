# simple stringr functions

parks <- c(
  "Banff National Park",
  "Jasper National Park",
  "Yoho National Park",
  "Kootenay National Park"
)



# Literal pattern matching

files <- c(
  "2024-08-12_site-1_plot-data.csv",
  "2024-08-12_site-2_plot-data.csv",
  "2024-09-15_site-1_plot-data.csv"
)




# Regex practice

species <- c("PIEN", "PICO", "ABLA", "POTR")



# Character classes []

codes <- c("Plot1", "Plot2", "Plot3", "PlotA", "PlotB")



# Negating character classes

measurements <- c("temp_C", "temp_F", "precip_mm", "wind_kph")



# Quantifiers

dates <- c("2024-8-12", "2024-08-12", "2024-8-1", "24-08-12", "20240523")



# Anchors

filenames <- c("data.csv", "plot-data.csv", "data-plot.csv")



# Special characters need escaping

prices <- c("$12.99", "$5.00", "12.99", "free")



# Shorthand character classes

prices <- c("$12.99", "$5.00", "12.99", "free")



# Extracting matches: `str_extract()`

data_files <- c("2024-08-12_banff_temp.csv", "2024-09-15_jasper_precip.csv")



# Capturing groups: `( )`

dates <- c("2024-08-12", "2024-09-15", "2023-12-31")



# Replacing text: `str_replace()`

messy_codes <- c("SITE_001", "SITE-002", "SITE_003", "PLOT_004", "PLOT-005")



## Your turn: Exercise 1

# You have these file names:

files <- c(
  "2024-08-12_site1_plot-A_data.csv",
  "2024-08-12_site2_plot-B_data.csv",
  "2024-09-15_site1_plot-C_data.csv",
  "2023-12-31_site3_plot-A_data.csv"
)

# 1. Extract all dates (YYYY-MM-DD format)
str_extract(files, "^\\d{4}-\\d{2}-\\d{2}")

# 2. Find files from site1
str_subset(files, "site1")

# 3. Extract the plot letter (A, B, or C)
str_extract(files, "plot-[A-Z]") |>
  str_extract("[A-Z]$")


## Your turn: Exercise 2 {.exercise}

# You have messy species codes:

species <- c(
  "PIEN (Engelmann Spruce)",
  "PICO   Lodgepole Pine",
  "ABLA - Subalpine Fir",
  "POTR/Trembling Aspen"
)

# 1. Extract just the 4-letter species codes
str_extract(species, "^[A-Z]{4}")

# 2. Replace all separators (spaces, -, /, parentheses) with a single space
cleaned <- str_replace_all(species, "[()/-]", " ") |>
  str_squish() # Remove extra whitespace

# 3. Create clean format: "CODE: Common Name"
codes <- str_extract(cleaned, "^[A-Z]{4}")
names <- str_replace_all(cleaned, "^[A-Z]{4} ", "")
paste0(codes, ": ", names)

# Hint: Check out `str_squish()` to remove extra whitespace!

