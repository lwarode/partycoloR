#' Extract party color from Wikipedia
#'
#' Extracts the primary party color (or all colors) from a political party's
#' English Wikipedia page. The function scrapes the party infobox for color
#' information.
#'
#' @param url A character vector of Wikipedia URLs for political party pages.
#' @param all_colors Logical. If `FALSE` (default), returns only the first/primary
#'   color. If `TRUE`, returns all colors as a list.
#' @param normalize Logical. If `TRUE` (default), attempts to normalize color
#'   values to uppercase hex codes. Named colors (e.g., "red") are converted
#'   to hex codes.
#'
#' @return If `all_colors = FALSE`, a character vector of hex color codes
#'   (or NA for failed extractions). If `all_colors = TRUE`, a list of
#'   character vectors containing all colors for each URL.
#'
#' @details
#' The function works by scraping the Wikipedia infobox (vcard table) for
#' spans with background-color style attributes. This depends on Wikipedia's
#' current HTML structure and may occasionally fail if the page structure changes.
#'
#' For use with `dplyr::mutate()`, this function is vectorized over the `url`
#' argument. Each URL is processed independently.
#'
#' @export
#'
#' @examples
#' \donttest{
#' if (curl::has_internet()) {
#'   # Single party
#'   get_party_color("https://en.wikipedia.org/wiki/Democratic_Party_(United_States)")
#'
#'   # Multiple parties
#'   urls <- c(
#'     "https://en.wikipedia.org/wiki/Democratic_Party_(United_States)",
#'     "https://en.wikipedia.org/wiki/Republican_Party_(United_States)"
#'   )
#'   get_party_color(urls)
#'
#'   # Get all colors (some parties have multiple)
#'   get_party_color(urls, all_colors = TRUE)
#' }
#' }
get_party_color <- function(url, all_colors = FALSE, normalize = TRUE) {
  # Validate input
  if (!is.character(url)) {
    rlang::abort("`url` must be a character vector")
  }

  # Process each URL
  result <- purrr::map(url, function(u) {
    if (is.na(u) || !is_wikipedia_url(u)) {
      if (all_colors) {
        return(list(NA_character_))
      } else {
        return(NA_character_)
      }
    }

    html <- read_html_safe(u)
    colors <- extract_colors_from_infobox(html)

    if (length(colors) == 0) {
      if (all_colors) {
        return(list(NA_character_))
      } else {
        return(NA_character_)
      }
    }

    # Normalize colors if requested
    if (normalize) {
      colors <- purrr::map_chr(colors, normalize_hex_color)
      colors <- colors[!is.na(colors)]
      if (length(colors) == 0) {
        if (all_colors) {
          return(list(NA_character_))
        } else {
          return(NA_character_)
        }
      }
    }

    if (all_colors) {
      return(list(colors))
    } else {
      return(colors[1])
    }
  })

  if (all_colors) {
    return(result)
  } else {
    return(unlist(result))
  }
}

#' Extract party colors from Wikipedia (legacy function)
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' This function is deprecated. Please use [get_party_color()] instead.
#'
#' @param party_url_list A list of Wikipedia political party URLs
#'
#' @return A data frame / tibble containing extracted color codes from Wikipedia
#'
#' @export
#'
#' @examples
#' \donttest{
#' if (curl::has_internet()) {
#'   party_list <- c(
#'     "https://en.wikipedia.org/wiki/Democratic_Party_(United_States)",
#'     "https://en.wikipedia.org/wiki/Republican_Party_(United_States)"
#'   )
#'   wikipedia_party_color(party_list)
#' }
#' }
wikipedia_party_color <- function(party_url_list) {
  .Deprecated("get_party_color")

  # Convert list to character vector if needed
  urls <- unlist(party_url_list)

  # Get all colors
  all_colors <- get_party_color(urls, all_colors = TRUE, normalize = TRUE)

  # Build result dataframe in the old format
  results <- purrr::imap_dfr(all_colors, function(colors, idx) {
    url <- urls[idx]
    colors_vec <- unlist(colors)

    if (all(is.na(colors_vec))) {
      return(tibble::tibble(url = url, color_1 = NA_character_))
    }

    # Create a row with color_1, color_2, etc.
    row <- tibble::tibble(url = url)
    for (i in seq_along(colors_vec)) {
      row[[paste0("color_", i)]] <- colors_vec[i]
    }
    row
  })

  results
}
