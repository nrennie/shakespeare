str_extract_between <- function(x, start, end) {
  pattern <- paste0("(?<=", start, ")(.*?)(?=", end, ")")
  return(stringr::str_extract(x, pattern = pattern))
}

scrape_play <- function(url) {
  # Scrape HTML
  raw_html <- rvest::read_html(url)

  # Extract elements
  a_char <- raw_html |>
    rvest::html_elements("h3, a, i") |>
    as.character()

  script <- tibble::tibble(raw_char = a_char) |>
    # Remove top two title rows
    dplyr::slice(-c(1, 2)) |>
    # What Act is it?
    dplyr::mutate(
      act = dplyr::case_when(
        stringr::str_detect(raw_char, "ACT") ~ str_extract_between(raw_char, "<h3>", "</h3>"),
        TRUE ~ NA_character_
      ),
      act = stringr::str_replace(act, "ACT", "Act")
    ) |>
    dplyr::mutate(
      act_line = stringr::str_detect(raw_char, "ACT")
    ) |>
    tidyr::fill(act, .direction = "down") |>
    dplyr::filter(!act_line) |>
    dplyr::select(-act_line) |>
    # What Scene is it?
    dplyr::mutate(
      scene_line = stringr::str_detect(raw_char, "SCENE"),
      scene = str_extract_between(raw_char, "<h3>", "</h3>"),
      scene = stringr::str_replace(scene, "SCENE", "Scene"),
      scene = stringr::str_replace(scene, "PROLOGUE", "Prologue"),
      scene = dplyr::case_when(
        stringr::str_detect(scene, "\\.") ~ sub("\\..*", "", scene),
        TRUE ~ scene
      )
    ) |>
    tidyr::fill(scene, .direction = "down") |>
    dplyr::filter(!scene_line) |>
    dplyr::select(-scene_line) |>
    # Who is speaking?
    dplyr::mutate(
      character = dplyr::case_when(
        stringr::str_detect(raw_char, "<b>") ~ str_extract_between(
          raw_char, "<b>", "</b>"
        ),
        TRUE ~ NA_character_
      ),
      character = stringr::str_to_title(character)
    ) |>
    dplyr::mutate(
      character_line = stringr::str_detect(raw_char, "<b>")
    ) |>
    tidyr::fill(character, .direction = "down") |>
    dplyr::filter(!character_line) |>
    dplyr::select(-character_line) |>
    # What are they saying?
    dplyr::mutate(
      dialogue = str_extract_between(
        raw_char, ">", "</a>"
      )
    ) |>
    dplyr::mutate(
      stage_dir = dplyr::case_when(
        stringr::str_detect(raw_char, "<i>") ~ str_extract_between(raw_char, "<i>", "</i>"),
        TRUE ~ NA_character_
      )
    ) |>
    dplyr::mutate(
      dialogue = dplyr::case_when(
        !is.na(stage_dir) ~ stage_dir,
        TRUE ~ dialogue
      ),
      character = dplyr::case_when(
        !is.na(stage_dir) ~ "[stage direction]",
        TRUE ~ character
      )
    ) |>
    dplyr::select(-c(stage_dir, raw_char)) |>
    dplyr::mutate(
      character = tidyr::replace_na(character, "Chorus")
    ) |>
    tidyr::drop_na(dialogue) |>
    dplyr::mutate(dialogue = stringr::str_trim(dialogue)) |>
    dplyr::mutate(is_stage_dir = (character == "[stage direction]")) |>
    dplyr::group_by(is_stage_dir) |>
    dplyr::mutate(line_number = dplyr::row_number()) |>
    dplyr::ungroup() |>
    dplyr::mutate(
      line_number = dplyr::case_when(
        is_stage_dir ~ NA,
        TRUE ~ line_number
      )
    ) |>
    dplyr::select(-is_stage_dir) |>
    dplyr::mutate(
      character = stringr::str_replace(character, "  ", " ")
    )
  return(script)
}

scrape_poem <- function(url) {
  # The Sonnets are a special case with more links
  if (stringr::str_detect(url, "sonnets")) {
    print("Sonnets")
  } else {
    # Scrape HTML
    raw_html <- rvest::read_html(url)

    # Process poem
    bq_char <- raw_html |>
      rvest::html_elements("blockquote") |>
      as.character()

    poem <- tibble::tibble(raw_char = bq_char) |>
      dplyr::mutate(
        stanza = dplyr::row_number()
      ) |>
      tidyr::separate_longer_delim(raw_char, "<br>") |>
      dplyr::mutate(
        raw_char = stringr::str_remove_all(
          string = raw_char,
          pattern = "<blockquote>|</blockquote>|\\n"
        )
      ) |>
      dplyr::filter(raw_char != "") |>
      dplyr::mutate(line_number = dplyr::row_number()) |>
      dplyr::rename(line = raw_char)
    return(poem)
  }
}

extract_data <- function(url, genre) {
  if (genre != "Poetry") {
    scrape_play(url)
  } else {
    scrape_poem(url)
  }
}

extract_and_save <- function(data, i) {
  work <- extract_data(url = data$URL[i], genre = data$Genre[i])
  fname <- paste0("data/", data$File[i], ".csv")
  readr::write_csv(work, fname)
}
