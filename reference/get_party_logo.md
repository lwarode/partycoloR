# Extract party logo URL from Wikipedia

Extracts the party logo image URL from a political party's English
Wikipedia page. The function scrapes the party infobox for the logo
image.

## Usage

``` r
get_party_logo(url, use_cache = TRUE)
```

## Arguments

- url:

  A character vector of Wikipedia URLs for political party pages.

- use_cache:

  Logical. If \`TRUE\` (default), looks up data in the bundled
  \`party_data\` dataset first before scraping Wikipedia. If \`FALSE\`,
  always scrapes live from Wikipedia. Using the cache is much faster and
  reduces load on Wikipedia servers.

## Value

A character vector of logo image URLs (or NA for failed extractions or
pages without logos).

## Details

By default, this function uses the bundled \`party_data\` dataset which
contains pre-scraped logo URLs for major political parties. This
provides instant lookups without network requests. If a party is not in
the bundled data, the function automatically falls back to live
Wikipedia scraping. Set \`use_cache = FALSE\` to always scrape fresh
data from Wikipedia.

The function looks for logo images in the Wikipedia infobox. The
returned URL is typically a Wikimedia Commons thumbnail URL. Note that
some party pages may not have logos, or the logo may be in a
non-standard location.

The returned URLs point to image files hosted on Wikimedia servers.
These can be used directly in R graphics or downloaded for further
processing.

For use with \`dplyr::mutate()\`, this function is vectorized over the
\`url\` argument.

## Examples

``` r
# \donttest{
if (curl::has_internet()) {
  # Fast lookup using bundled data (default)
  get_party_logo("https://en.wikipedia.org/wiki/Democratic_Party_(United_States)")

  # Force live scraping for most recent data
  get_party_logo("https://en.wikipedia.org/wiki/Democratic_Party_(United_States)",
                 use_cache = FALSE)

  # Multiple parties
  urls <- c(
    "https://en.wikipedia.org/wiki/Democratic_Party_(United_States)",
    "https://en.wikipedia.org/wiki/Republican_Party_(United_States)"
  )
  get_party_logo(urls)
}
#> [1] "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fd/US_Democratic_Party_2025_logo_%28positive%29.svg/330px-US_Democratic_Party_2025_logo_%28positive%29.svg.png"
#> [2] "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/GOP_logo_%28positive%29.svg/250px-GOP_logo_%28positive%29.svg.png"                                          
# }
```
