# Scrape HTML
raw_html <- rvest::read_html("https://shakespeare.mit.edu/")

# Extract HTML links
works_links <- raw_html |>
  rvest::html_elements("table") |>
  _[[2]] |>
  rvest::html_elements("a") |>
  rvest::html_attr("href") |> 
  stringr::str_replace("index", "full")

# Process metadata
metadata <- raw_html |>
  rvest::html_table(header = TRUE) |>
  _[[2]] |> 
  tidyr::pivot_longer(
    cols = everything(),
    names_to = "Genre",
    values_to = "Title"
  ) |>
  tidyr::separate_longer_delim(
    cols = Title,
    delim = "\n\n"
  ) |>
  dplyr::mutate(
    Title = stringr::str_replace(Title, "\n", " "),
    Title = stringr::str_trim(Title),
    URL = paste0("https://shakespeare.mit.edu/", works_links),
    File = dplyr::case_when(
      Genre != "Poetry" ~ stringr::str_remove(works_links, "/.*"),
      TRUE ~ stringr::str_remove_all(works_links, "Poetry/|\\.html"))
  ) |>
  dplyr::select(Title, Genre, URL, File)

# Save to file
readr::write_csv(metadata, "data/metadata.csv")
