# Extract party color from Wikipedia

Extracts the primary party color (or all colors) from a political
party's English Wikipedia page. The function scrapes the party infobox
for color information.

## Usage

``` r
get_party_color(url, all_colors = FALSE, normalize = TRUE, use_cache = TRUE)
```

## Arguments

- url:

  A character vector of Wikipedia URLs for political party pages.

- all_colors:

  Logical. If \`FALSE\` (default), returns only the first/primary color.
  If \`TRUE\`, returns all colors as a list.

- normalize:

  Logical. If \`TRUE\` (default), attempts to normalize color values to
  uppercase hex codes. Named colors (e.g., "red") are converted to hex
  codes.

- use_cache:

  Logical. If \`TRUE\` (default), looks up data in the bundled
  \`party_data\` dataset first before scraping Wikipedia. If \`FALSE\`,
  always scrapes live from Wikipedia. Using the cache is much faster and
  reduces load on Wikipedia servers.

## Value

If \`all_colors = FALSE\`, a character vector of hex color codes (or NA
for failed extractions). If \`all_colors = TRUE\`, a list of character
vectors containing all colors for each URL.

## Details

By default, this function uses the bundled \`party_data\` dataset which
contains pre-scraped data for major political parties. This provides
instant lookups without network requests. If a party is not in the
bundled data, the function automatically falls back to live Wikipedia
scraping. Set \`use_cache = FALSE\` to always scrape fresh data from
Wikipedia.

The function works by scraping the Wikipedia infobox (vcard table) for
spans with background-color style attributes. This depends on
Wikipedia's current HTML structure and may occasionally fail if the page
structure changes.

For use with \`dplyr::mutate()\`, this function is vectorized over the
\`url\` argument. Each URL is processed independently.

## Examples

``` r
# \donttest{
if (curl::has_internet()) {
  # Fast lookup using bundled data (default)
  get_party_color("https://en.wikipedia.org/wiki/Democratic_Party_(United_States)")

  # Force live scraping for most recent data
  get_party_color("https://en.wikipedia.org/wiki/Democratic_Party_(United_States)",
                  use_cache = FALSE)

  # Multiple parties
  urls <- c(
    "https://en.wikipedia.org/wiki/Democratic_Party_(United_States)",
    "https://en.wikipedia.org/wiki/Republican_Party_(United_States)"
  )
  get_party_color(urls)

  # Get all colors (some parties have multiple)
  get_party_color(urls, all_colors = TRUE)
}
#> [[1]]
#> [[1]][[1]]
#> [1] "#3333FF"
#> 
#> 
#> [[2]]
#> [[2]][[1]]
#> [1] "#E81B23"
#> 
#> 
# }
```
