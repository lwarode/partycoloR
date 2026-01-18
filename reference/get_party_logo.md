# Extract party logo URL from Wikipedia

Extracts the party logo image URL from a political party's English
Wikipedia page. The function scrapes the party infobox for the logo
image.

## Usage

``` r
get_party_logo(url)
```

## Arguments

- url:

  A character vector of Wikipedia URLs for political party pages.

## Value

A character vector of logo image URLs (or NA for failed extractions or
pages without logos).

## Details

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
if (FALSE) { # \dontrun{
# Single party
get_party_logo("https://en.wikipedia.org/wiki/Democratic_Party_(United_States)")

# Multiple parties
urls <- c(
  "https://en.wikipedia.org/wiki/Democratic_Party_(United_States)",
  "https://en.wikipedia.org/wiki/Republican_Party_(United_States)"
)
get_party_logo(urls)

# Use with dplyr
library(dplyr)
parties <- tibble(
  party = c("Democrats", "Republicans"),
  wiki_url = urls
)
parties %>%
  mutate(logo_url = get_party_logo(wiki_url))
} # }
```
