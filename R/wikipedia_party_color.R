#' Wikipedia party color function
#'
#' @param party_url_list A list of Wikipedia political party URLs
#'
#' @return A data frame / tibble which contains all the extracted color codes from Wikipedia
#' @export wikipedia_party_color
#'
#' @name wikipedia_party_color
#'
#' @import rvest
#' @import xml2
#' @import dplyr
#' @import tidyr
#' @importFrom purrr is_character
#' @importFrom purrr map
#' @import stringr
#'
#' @examples
#' \dontrun{
#' party_list <- list("https://en.wikipedia.org/wiki/Democratic_Party_(United_States)",
#' "https://en.wikipedia.org/wiki/Republican_Party_(United_States)")
#' wikipedia_party_color(example_list)
#' }
utils::globalVariables(c(".", "type", "value"))

wikipedia_party_color <- function(party_url_list) {

  read_html_safe <- function(x) {

    tryCatch(read_html(x),
             error = function(e) return("url_not_existent"))

  }

  # function for extracting color data
  color_function <- function(x) {

    if(! is_character(x))
      html_nodes(x, "table.vcard td span") %>%
      html_attrs() %>%
      unlist() %>%
      str_subset("background-color")

  }

  # html_list <- list()
  #
  # for (i in party_url_list) {
  #   html_list[[i]] <- read_html_safe(i)
  # }

  html_list <- party_url_list %>%
    map(read_html_safe)

  names(html_list) <- party_url_list

  html_color_list <- html_list %>%
    map(color_function)

  party_color_df_raw <- rbind(html_color_list) %>%
    as_tibble() %>%
    pivot_longer(everything()) %>%
    mutate(value = na_if(value, "character(0)")) %>%
    filter(!is.na(value)) %>%
    unnest_wider(value, names_sep = "_V") %>%
    rename(url = name) %>%
    rename_at(vars(starts_with("value")), ~ str_sub(.x, 7))

  party_color_df <- party_color_df_raw %>%
    select(url, everything()) %>%
    # extract color information with string functions and regex for all variables
    mutate(across(starts_with("V"),
                  ~ str_extract(., "(?<=background-color:)[^;]+"),
                  .names = "color_{col}")) %>%
    select(! starts_with("V")) %>%
    gather(type, value, -url) %>%
    distinct(url, value, .keep_all = TRUE) %>%
    spread(type, value) %>%
    rename_at(vars(starts_with("c")),
              ~ str_replace(., "_V", "_")) %>%
    # add information variable
    mutate(across(starts_with("c"),
                  ~ case_when(
                    substr(., 1, 1) == "#" & str_count(.) < 7 ~ "color hex code too short",
                    substr(., 1, 1) == "#" & str_count(.) > 7 ~ "color hex code too long"
                  ),
                  .names = "{col}_check")
    ) %>%
    select_if(function(x) ! (all(is.na(x))))

  return(party_color_df)

}

