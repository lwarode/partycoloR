#' Download Partyfacts Wikipedia data
#'
#' Downloads the current Partyfacts Wikipedia dataset containing party names,
#' countries, and Wikipedia URLs for thousands of political parties worldwide.
#'
#' @param cache Logical. If `TRUE` (default), caches the downloaded data for the
#'   current R session to avoid repeated downloads.
#'
#' @return A tibble with columns: country, partyfacts_id, url, name_short, name,
#'   name_native, year_founded, year_dissolved.
#'
#' @details
#' The data comes from the Partyfacts project
#' (<https://partyfacts.herokuapp.com/>), which links party datasets and provides
#' Wikipedia URLs for political parties. The data is downloaded from the
#' Partyfacts GitHub repository.
#'
#' @seealso [lookup_party_url()] for searching parties in the dataset.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Download the dataset
#' pf_data <- get_partyfacts_wikipedia()
#'
#' # View parties from Germany
#' pf_data[pf_data$country == "DEU", ]
#' }
get_partyfacts_wikipedia <- function(cache = TRUE) {
  # Check cache
  cache_env <- get_partycolor_cache()
  if (cache && !is.null(cache_env$partyfacts_data)) {
    return(cache_env$partyfacts_data)
  }

  url <- "https://raw.githubusercontent.com/hdigital/partyfactsdata/master/import/wikipedia/wikipedia.csv"

  tryCatch(
    {
      data <- utils::read.csv(
        url,
        stringsAsFactors = FALSE,
        na.strings = c("", "NA")
      )
      data <- tibble::as_tibble(data)

      # Cache the result
      if (cache) {
        cache_env$partyfacts_data <- data
      }

      data
    },
    error = function(e) {
      rlang::abort(
        paste0("Failed to download Partyfacts data: ", e$message),
        class = "partycoloR_download_error"
      )
    }
  )
}

#' Look up party Wikipedia URL
#'
#' Search the Partyfacts Wikipedia dataset for a party by name and/or country.
#'
#' @param party_name A character string to search for in party names. The search
#'   is case-insensitive and matches partial names.
#' @param country Optional. ISO 3-letter country code (e.g., "DEU", "USA", "GBR")
#'   to filter results.
#' @param data Optional. A Partyfacts dataset (from [get_partyfacts_wikipedia()]).
#'   If not provided, downloads the data automatically.
#' @param exact Logical. If `TRUE`, requires exact match on party name.
#'   Default is `FALSE` (partial matching).
#'
#' @return A tibble with matching parties and their Wikipedia URLs.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Search for parties with "Democratic" in the name
#' lookup_party_url("Democratic")
#'
#' # Search within a specific country
#' lookup_party_url("SPD", country = "DEU")
#'
#' # Exact match
#' lookup_party_url("CDU", country = "DEU", exact = TRUE)
#' }
lookup_party_url <- function(party_name, country = NULL, data = NULL, exact = FALSE) {
  if (!is.character(party_name) || length(party_name) != 1) {
    rlang::abort("`party_name` must be a single character string")
  }

  # Get data if not provided
  if (is.null(data)) {
    data <- get_partyfacts_wikipedia()
  }

  # Filter by country if specified
  if (!is.null(country)) {
    data <- data[toupper(data$country) == toupper(country), ]
  }

  # Search in name, name_short, and name_native
  if (exact) {
    pattern <- paste0("^", party_name, "$")
    matches <- grepl(pattern, data$name, ignore.case = TRUE) |
      grepl(pattern, data$name_short, ignore.case = TRUE) |
      grepl(pattern, data$name_native, ignore.case = TRUE)
  } else {
    matches <- grepl(party_name, data$name, ignore.case = TRUE) |
      grepl(party_name, data$name_short, ignore.case = TRUE) |
      grepl(party_name, data$name_native, ignore.case = TRUE)
  }

  result <- data[matches, ]

  if (nrow(result) == 0) {
    message("No parties found matching '", party_name, "'")
  }

  result
}

#' Get party color by name
#'
#' A convenience function that combines party lookup and color extraction.
#' Searches for a party by name, finds its Wikipedia URL, and extracts the
#' party color.
#'
#' @param party_name A character string with the party name to search for.
#' @param country Optional. ISO 3-letter country code to filter results.
#' @param all_colors Logical. If `TRUE`, returns all colors. Default is `FALSE`.
#' @param data Optional. A Partyfacts dataset.
#'
#' @return If exactly one party is found, returns the color(s). If multiple
#'   parties match, returns a tibble with party info and colors. Returns NA
#'   if no party is found.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get color for German SPD
#' get_party_color_by_name("SPD", country = "DEU")
#'
#' # Search more broadly
#' get_party_color_by_name("Labour", country = "GBR")
#' }
get_party_color_by_name <- function(party_name, country = NULL, all_colors = FALSE,
                                    data = NULL) {
  # Look up the party
 parties <- lookup_party_url(party_name, country = country, data = data, exact = FALSE)

  if (nrow(parties) == 0) {
    return(NA_character_)
  }

  # Get colors for all matching parties
  parties$color <- get_party_color(parties$url, all_colors = FALSE, normalize = TRUE)

  if (all_colors) {
    parties$all_colors <- get_party_color(parties$url, all_colors = TRUE, normalize = TRUE)
  }

  # If exactly one match, return just the color
  if (nrow(parties) == 1 && !all_colors) {
    return(parties$color[1])
  }

  parties
}

#' Get party logo by name
#'
#' A convenience function that combines party lookup and logo extraction.
#' Searches for a party by name, finds its Wikipedia URL, and extracts the
#' party logo URL.
#'
#' @param party_name A character string with the party name to search for.
#' @param country Optional. ISO 3-letter country code to filter results.
#' @param data Optional. A Partyfacts dataset.
#'
#' @return If exactly one party is found, returns the logo URL. If multiple
#'   parties match, returns a tibble with party info and logo URLs. Returns NA
#'   if no party is found.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get logo for German SPD
#' get_party_logo_by_name("SPD", country = "DEU")
#'
#' # Search more broadly
#' get_party_logo_by_name("Labour", country = "GBR")
#' }
get_party_logo_by_name <- function(party_name, country = NULL, data = NULL) {
  # Look up the party
  parties <- lookup_party_url(party_name, country = country, data = data, exact = FALSE)

  if (nrow(parties) == 0) {
    return(NA_character_)
  }

  # Get logos for all matching parties
  parties$logo_url <- get_party_logo(parties$url)

  # If exactly one match, return just the logo URL
  if (nrow(parties) == 1) {
    return(parties$logo_url[1])
  }

  parties
}

#' Get party info by name
#'
#' A convenience function that combines party lookup with color and logo
#' extraction. Searches for a party by name, finds its Wikipedia URL, and
#' extracts both color and logo.
#'
#' @param party_name A character string with the party name to search for.
#' @param country Optional. ISO 3-letter country code to filter results.
#' @param all_colors Logical. If `TRUE`, includes all colors as a list-column.
#'   Default is `FALSE`.
#' @param data Optional. A Partyfacts dataset.
#'
#' @return A tibble with party info, color, and logo_url columns. Returns a
#'   tibble with zero rows if no party is found.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get info for German SPD
#' get_party_info_by_name("SPD", country = "DEU")
#'
#' # Search more broadly with all colors
#' get_party_info_by_name("Labour", country = "GBR", all_colors = TRUE)
#' }
get_party_info_by_name <- function(party_name, country = NULL, all_colors = FALSE,
                                   data = NULL) {
  # Look up the party
  parties <- lookup_party_url(party_name, country = country, data = data, exact = FALSE)

  if (nrow(parties) == 0) {
    # Return empty tibble with expected columns
    parties$color <- character(0)
    parties$logo_url <- character(0)
    if (all_colors) {
      parties$all_colors <- list()
    }
    return(parties)
  }

  # Get colors and logos for all matching parties
  parties$color <- get_party_color(parties$url, all_colors = FALSE, normalize = TRUE)
  parties$logo_url <- get_party_logo(parties$url)

  if (all_colors) {
    parties$all_colors <- get_party_color(parties$url, all_colors = TRUE, normalize = TRUE)
  }

  parties
}

#' Internal cache environment for partycoloR
#' @noRd
partycolor_cache <- new.env(parent = emptyenv())

#' Get the package cache environment
#' @noRd
get_partycolor_cache <- function() {
  partycolor_cache
}

#' Clear the partycoloR cache
#'
#' Clears cached data (Partyfacts dataset) from the current R session.
#'
#' @return Invisible NULL.
#'
#' @export
#'
#' @examples
#' clear_partycolor_cache()
clear_partycolor_cache <- function() {
  cache <- get_partycolor_cache()
  rm(list = ls(cache), envir = cache)
  invisible(NULL)
}
