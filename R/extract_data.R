
# Functions ---------------------------------------------------------------

source("R/functions.R")


# Read metadata -----------------------------------------------------------

metadata <- readr::read_csv("data/metadata.csv")

# Romeo and Juliet --------------------------------------------------------

readr::write_csv(romeo_juliet_script, "data/romeo_juliet.csv")


romeo_juliet_script <- extract_data("https://shakespeare.mit.edu/romeo_juliet/full.html", "Tragedy")
romeo_juliet <- readr::read_csv("data/romeo_juliet.csv")


all.equal(romeo_juliet_script, romeo_juliet)

romeo_juliet

View(romeo_juliet)
View(romeo_juliet_script)

romeo_juliet$character |> unique() == romeo_juliet_script$character |> unique()









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

