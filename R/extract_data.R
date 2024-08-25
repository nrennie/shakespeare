
# Functions ---------------------------------------------------------------

source("R/functions.R")

# Romeo and Juliet --------------------------------------------------------

romeo_juliet_raw <- rvest::read_html("https://shakespeare.mit.edu/romeo_juliet/full.html")
romeo_juliet_script <- extract_data(romeo_juliet_raw) |> 
  dplyr::mutate(
    character = dplyr::case_when(
      character == "Lady  Capulet" ~ "Lady Capulet",
      TRUE ~ character
    )
  )
readr::write_csv(romeo_juliet_script, "data/romeo_juliet.csv")
