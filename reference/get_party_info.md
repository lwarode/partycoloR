# Extract party information from Wikipedia

Extracts both the party color(s) and logo URL from a political party's
English Wikipedia page in a single call.

## Usage

``` r
get_party_info(url, all_colors = FALSE, use_cache = TRUE)
```

## Arguments

- url:

  A character vector of Wikipedia URLs for political party pages.

- all_colors:

  Logical. If \`FALSE\` (default), returns only the primary color in the
  \`color\` column. If \`TRUE\`, adds an \`all_colors\` list-column.

- use_cache:

  Logical. If \`TRUE\` (default), looks up data in the bundled
  \`party_data\` dataset first before scraping Wikipedia. If \`FALSE\`,
  always scrapes live from Wikipedia. Using the cache is much faster and
  reduces load on Wikipedia servers.

## Value

A tibble with columns: \`url\`, \`color\` (primary color as hex),
\`logo_url\`, and optionally \`all_colors\` (list of all colors).

## Details

By default, this function uses the bundled \`party_data\` dataset which
contains pre-scraped data for major political parties. This provides
instant lookups without network requests. If a party is not in the
bundled data, the function automatically falls back to live Wikipedia
scraping. Set \`use_cache = FALSE\` to always scrape fresh data from
Wikipedia.

This function combines \[get_party_color()\] and \[get_party_logo()\]
into a single call, which is more efficient when you need both pieces of
information as it only fetches each Wikipedia page once.

## Examples

``` r
# \donttest{
if (curl::has_internet()) {
  # Fast lookup using bundled data (default)
  urls <- c(
    "https://en.wikipedia.org/wiki/Democratic_Party_(United_States)",
    "https://en.wikipedia.org/wiki/Republican_Party_(United_States)",
    "https://en.wikipedia.org/wiki/Social_Democratic_Party_of_Germany"
  )
  get_party_info(urls)

  # Force live scraping for most recent data
  get_party_info(urls, use_cache = FALSE)

  # Include all colors
  get_party_info(urls, all_colors = TRUE)
}
#> # A tibble: 3 × 4
#>   url                                                  color logo_url all_colors
#>   <chr>                                                <chr> <chr>    <list>    
#> 1 https://en.wikipedia.org/wiki/Democratic_Party_(Uni… #333… https:/… <chr [1]> 
#> 2 https://en.wikipedia.org/wiki/Republican_Party_(Uni… #E81… https:/… <chr [1]> 
#> 3 https://en.wikipedia.org/wiki/Social_Democratic_Par… #E30… https:/… <chr [1]> 
# }
```
