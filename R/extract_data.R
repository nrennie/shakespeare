
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


# Macbeth -----------------------------------------------------------------

macbeth_raw <- rvest::read_html("https://shakespeare.mit.edu/macbeth/full.html")
macbeth_script <- extract_data(macbeth_raw) 
readr::write_csv(macbeth_script, "data/macbeth.csv")


# Othello -----------------------------------------------------------------

othello_raw <- rvest::read_html("https://shakespeare.mit.edu/othello/full.html")
othello_script <- extract_data(othello_raw) 
readr::write_csv(othello_script, "data/othello.csv")


# Hamlet ------------------------------------------------------------------

hamlet_raw <- rvest::read_html("https://shakespeare.mit.edu/hamlet/full.html")
hamlet_script <- extract_data(hamlet_raw) 
readr::write_csv(hamlet_script, "data/hamlet.csv")


# Julius Caesar -----------------------------------------------------------

julius_caesar_raw <- rvest::read_html("https://shakespeare.mit.edu/julius_caesar/full.html")
julius_caesar_script <- extract_data(julius_caesar_raw) 
readr::write_csv(julius_caesar_script, "data/julius_caesar.csv")

