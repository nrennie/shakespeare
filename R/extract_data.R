# Functions ---------------------------------------------------------------

source("R/functions.R")


# Read metadata -----------------------------------------------------------

metadata <- readr::read_csv("data/metadata.csv")


# Extract data ------------------------------------------------------------

purrr::walk(
  .x = 1:nrow(metadata),
  .f = ~ extract_and_save(metadata, .x)
)
