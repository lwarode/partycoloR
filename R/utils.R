# Internal utility functions for partycoloR
# These functions are not exported

#' Safely read HTML from a URL
#'
#' @param url A Wikipedia URL
#' @param timeout Request timeout in seconds
#' @return An xml_document object or NULL if the request fails
#' @noRd
read_html_safe <- function(url, timeout = 30) {
  tryCatch(
    {
      response <- httr::GET(
        url,
        httr::timeout(timeout),
        httr::user_agent("partycoloR R package (https://github.com/lwarode/partycoloR)")
      )
      httr::stop_for_status(response)
      xml2::read_html(response)
    },
    error = function(e) {
      NULL
    }
  )
}

#' Check if a URL is a valid Wikipedia party page URL
#'
#' @param url A URL string
#' @return Logical indicating if the URL appears to be a valid Wikipedia URL
#' @noRd
is_wikipedia_url <- function(url) {
  if (is.null(url) || is.na(url) || !is.character(url)) {
    return(FALSE)
  }
  grepl("^https?://(en\\.)?wikipedia\\.org/wiki/", url, ignore.case = TRUE)
}

#' Validate and normalize a hex color code
#'
#' @param color A color string (hex code or color name)
#' @return Normalized hex color code or NA if invalid
#' @noRd
normalize_hex_color <- function(color) {
  if (is.null(color) || is.na(color) || color == "") {
    return(NA_character_)
  }

  color <- trimws(color)

  # Already a hex code

  if (grepl("^#[0-9A-Fa-f]{6}$", color)) {
    return(toupper(color))
  }

  # 3-digit hex code - expand to 6 digits

  if (grepl("^#[0-9A-Fa-f]{3}$", color)) {
    chars <- strsplit(gsub("#", "", color), "")[[1]]
    return(toupper(paste0("#", chars[1], chars[1], chars[2], chars[2], chars[3], chars[3])))
  }

  # Try to convert named color to hex
  tryCatch(
    {
      rgb_vals <- grDevices::col2rgb(tolower(color))
      toupper(grDevices::rgb(rgb_vals[1], rgb_vals[2], rgb_vals[3], maxColorValue = 255))
    },
    error = function(e) {
      NA_character_
    }
  )
}

#' Extract color information from Wikipedia infobox
#'
#' @param html An xml_document object
#' @return Character vector of color values
#' @noRd
extract_colors_from_infobox <- function(html) {
  if (is.null(html)) {
    return(character(0))
  }

  # Try to find color spans in the party infobox (vcard table)
  color_nodes <- rvest::html_nodes(html, "table.infobox.vcard td span, table.vcard td span")

  if (length(color_nodes) == 0) {
    return(character(0))
  }

  # Extract style attributes containing background-color

  styles <- rvest::html_attr(color_nodes, "style")
  styles <- styles[!is.na(styles)]
  styles <- styles[grepl("background-color", styles, ignore.case = TRUE)]

  if (length(styles) == 0) {
    return(character(0))
  }

  # Extract the color values
  colors <- stringr::str_extract(styles, "(?<=background-color:)[^;]+")
  colors <- trimws(colors)
  colors <- colors[!is.na(colors) & colors != ""]

  unique(colors)
}

#' Extract logo URL from Wikipedia infobox
#'
#' @param html An xml_document object
#' @return Character string with logo URL or NA
#' @noRd
extract_logo_from_infobox <- function(html) {
  if (is.null(html)) {
    return(NA_character_)
  }

  # Look for logo in infobox - typically in a cell with class "infobox-image"
  # or in the first image in the vcard table
  logo_selectors <- c(
    "table.infobox.vcard .infobox-image img",
    "table.vcard .infobox-image img",
    "table.infobox.vcard td.infobox-image img",
    "table.vcard tr:first-child img",
    "table.infobox.vcard img"
  )

  for (selector in logo_selectors) {
    img_nodes <- rvest::html_nodes(html, selector)
    if (length(img_nodes) > 0) {
      # Get the src attribute
      src <- rvest::html_attr(img_nodes[1], "src")
      if (!is.na(src) && src != "") {
        # Convert protocol-relative URL to https
        if (grepl("^//", src)) {
          src <- paste0("https:", src)
        }
        return(src)
      }
    }
  }

  NA_character_
}

#' Look up party color from bundled cache
#'
#' @param url Wikipedia URL
#' @param all_colors Logical. Return all colors or just primary
#' @return Color(s) from bundled data, or NULL if not found
#' @noRd
lookup_cached_color <- function(url, all_colors = FALSE) {
  # Check if party_data exists (it should be loaded via LazyData)
  if (!exists("party_data", envir = asNamespace("partycoloR"), inherits = FALSE)) {
    return(NULL)
  }

  # Get the data from package namespace
  data <- get("party_data", envir = asNamespace("partycoloR"))

  # Find matching URL
  match_idx <- which(data$url == url)

  if (length(match_idx) == 0) {
    return(NULL)
  }

  # Return color(s)
  if (all_colors) {
    # Return the list element (all_colors column is a list column)
    return(data$all_colors[[match_idx[1]]])
  } else {
    # Return primary color
    return(data$color[match_idx[1]])
  }
}

#' Look up party logo from bundled cache
#'
#' @param url Wikipedia URL
#' @return Logo URL from bundled data, or NULL if not found
#' @noRd
lookup_cached_logo <- function(url) {
  # Check if party_data exists
  if (!exists("party_data", envir = asNamespace("partycoloR"), inherits = FALSE)) {
    return(NULL)
  }

  # Get the data from package namespace
  data <- get("party_data", envir = asNamespace("partycoloR"))

  # Find matching URL
  match_idx <- which(data$url == url)

  if (length(match_idx) == 0) {
    return(NULL)
  }

  # Return logo URL
  return(data$logo_url[match_idx[1]])
}

#' Look up party info from bundled cache
#'
#' @param url Wikipedia URL
#' @param all_colors Logical. Include all colors in result
#' @return Tibble row with party info, or NULL if not found
#' @noRd
lookup_cached_info <- function(url, all_colors = FALSE) {
  # Check if party_data exists
  if (!exists("party_data", envir = asNamespace("partycoloR"), inherits = FALSE)) {
    return(NULL)
  }

  # Get the data from package namespace
  data <- get("party_data", envir = asNamespace("partycoloR"))

  # Find matching URL
  match_idx <- which(data$url == url)

  if (length(match_idx) == 0) {
    return(NULL)
  }

  # Extract relevant columns
  if (all_colors) {
    row <- data[match_idx[1], c("url", "color", "all_colors", "logo_url")]
  } else {
    row <- data[match_idx[1], c("url", "color", "logo_url")]
  }

  return(row)
}

#' Show a package startup message
#'
#' @param libname Library name
#' @param pkgname Package name
#' @noRd
.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "partycoloR: Extract party colors and logos from Wikipedia\n",
    "Note: Wikipedia scraping depends on current page structure and may occasionally fail."
  )
}
