#' Extract party logo URL from Wikipedia
#'
#' Extracts the party logo image URL from a political party's English Wikipedia
#' page. The function scrapes the party infobox for the logo image.
#'
#' @param url A character vector of Wikipedia URLs for political party pages.
#'
#' @return A character vector of logo image URLs (or NA for failed extractions
#'   or pages without logos).
#'
#' @details
#' The function looks for logo images in the Wikipedia infobox. The returned
#' URL is typically a Wikimedia Commons thumbnail URL. Note that some party
#' pages may not have logos, or the logo may be in a non-standard location.
#'
#' The returned URLs point to image files hosted on Wikimedia servers. These
#' can be used directly in R graphics or downloaded for further processing.
#'
#' For use with `dplyr::mutate()`, this function is vectorized over the `url`
#' argument.
#'
#' @export
#'
#' @examples
#' \donttest{
#' if (curl::has_internet()) {
#'   # Single party
#'   get_party_logo("https://en.wikipedia.org/wiki/Democratic_Party_(United_States)")
#'
#'   # Multiple parties
#'   urls <- c(
#'     "https://en.wikipedia.org/wiki/Democratic_Party_(United_States)",
#'     "https://en.wikipedia.org/wiki/Republican_Party_(United_States)"
#'   )
#'   get_party_logo(urls)
#' }
#' }
get_party_logo <- function(url) {
  # Validate input
  if (!is.character(url)) {
    rlang::abort("`url` must be a character vector")
  }

  # Process each URL
  result <- purrr::map_chr(url, function(u) {
    if (is.na(u) || !is_wikipedia_url(u)) {
      return(NA_character_)
    }

    html <- read_html_safe(u)
    extract_logo_from_infobox(html)
  })

  result
}

#' Download party logo image
#'
#' Downloads a party logo image from a URL and saves it to a file.
#'
#' @param logo_url A character string with the logo URL (from [get_party_logo()]).
#' @param destfile Path where the image should be saved.
#' @param overwrite Logical. If `TRUE`, overwrite existing files.
#'
#' @return Invisible `TRUE` if successful, `FALSE` otherwise.
#'
#' @export
#'
#' @examples
#' \donttest{
#' if (curl::has_internet()) {
#'   logo_url <- get_party_logo(
#'     "https://en.wikipedia.org/wiki/Democratic_Party_(United_States)"
#'   )
#'   tmp_file <- tempfile(fileext = ".png")
#'   download_party_logo(logo_url, tmp_file)
#'   unlink(tmp_file)
#' }
#' }
download_party_logo <- function(logo_url, destfile, overwrite = FALSE) {
  if (is.na(logo_url) || logo_url == "") {
    warning("No logo URL provided")
    return(invisible(FALSE))
  }

  if (file.exists(destfile) && !overwrite) {
    warning("File already exists. Use overwrite = TRUE to replace.")
    return(invisible(FALSE))
  }

  tryCatch(
    {
      curl::curl_download(logo_url, destfile, quiet = TRUE)
      invisible(TRUE)
    },
    error = function(e) {
      warning("Failed to download logo: ", e$message)
      invisible(FALSE)
    }
  )
}
