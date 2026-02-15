#' Extract party information from Wikipedia
#'
#' Extracts both the party color(s) and logo URL from a political party's
#' English Wikipedia page in a single call.
#'
#' @param url A character vector of Wikipedia URLs for political party pages.
#' @param all_colors Logical. If `FALSE` (default), returns only the primary
#'   color in the `color` column. If `TRUE`, adds an `all_colors` list-column.
#' @param use_cache Logical. If `TRUE` (default), looks up data in the bundled
#'   `party_data` dataset first before scraping Wikipedia. If `FALSE`, always
#'   scrapes live from Wikipedia. Using the cache is much faster and reduces
#'   load on Wikipedia servers.
#'
#' @return A tibble with columns: `url`, `color` (primary color as hex),
#'   `logo_url`, and optionally `all_colors` (list of all colors).
#'
#' @details
#' By default, this function uses the bundled `party_data` dataset which contains
#' pre-scraped data for major political parties. This provides instant lookups
#' without network requests. If a party is not in the bundled data, the function
#' automatically falls back to live Wikipedia scraping. Set `use_cache = FALSE`
#' to always scrape fresh data from Wikipedia.
#'
#' This function combines [get_party_color()] and [get_party_logo()] into
#' a single call, which is more efficient when you need both pieces of
#' information as it only fetches each Wikipedia page once.
#'
#' @export
#'
#' @examples
#' \donttest{
#' if (curl::has_internet()) {
#'   # Fast lookup using bundled data (default)
#'   urls <- c(
#'     "https://en.wikipedia.org/wiki/Democratic_Party_(United_States)",
#'     "https://en.wikipedia.org/wiki/Republican_Party_(United_States)",
#'     "https://en.wikipedia.org/wiki/Social_Democratic_Party_of_Germany"
#'   )
#'   get_party_info(urls)
#'
#'   # Force live scraping for most recent data
#'   get_party_info(urls, use_cache = FALSE)
#'
#'   # Include all colors
#'   get_party_info(urls, all_colors = TRUE)
#' }
#' }
get_party_info <- function(url, all_colors = FALSE, use_cache = TRUE) {
  # Validate input
  if (!is.character(url)) {
    rlang::abort("`url` must be a character vector")
  }

  # Process each URL, fetching the page only once
  results <- purrr::map_dfr(url, function(u) {
    if (is.na(u) || !is_wikipedia_url(u)) {
      row <- tibble::tibble(
        url = u,
        color = NA_character_,
        logo_url = NA_character_
      )
      if (all_colors) {
        row$all_colors <- list(NA_character_)
      }
      return(row)
    }

    # Try cache lookup first if enabled
    if (use_cache) {
      cached <- lookup_cached_info(u, all_colors)
      if (!is.null(cached)) {
        return(cached)
      }
    }

    # Scrape from Wikipedia (cache miss or cache disabled)
    html <- read_html_safe(u)

    # Extract colors
    colors <- extract_colors_from_infobox(html)
    colors <- purrr::map_chr(colors, normalize_hex_color)
    colors <- colors[!is.na(colors)]

    primary_color <- if (length(colors) > 0) colors[1] else NA_character_

    # Extract logo
    logo <- extract_logo_from_infobox(html)

    row <- tibble::tibble(
      url = u,
      color = primary_color,
      logo_url = logo
    )

    if (all_colors) {
      row$all_colors <- list(if (length(colors) > 0) colors else NA_character_)
    }

    row
  })

  results
}
