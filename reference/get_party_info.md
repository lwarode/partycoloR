# Extract party information from Wikipedia

Extracts both the party color(s) and logo URL from a political party's
English Wikipedia page in a single call.

## Usage

``` r
get_party_info(url, all_colors = FALSE)
```

## Arguments

- url:

  A character vector of Wikipedia URLs for political party pages.

- all_colors:

  Logical. If \`FALSE\` (default), returns only the primary color in the
  \`color\` column. If \`TRUE\`, adds an \`all_colors\` list-column.

## Value

A tibble with columns: \`url\`, \`color\` (primary color as hex),
\`logo_url\`, and optionally \`all_colors\` (list of all colors).

## Details

This function combines \[get_party_color()\] and \[get_party_logo()\]
into a single call, which is more efficient when you need both pieces of
information as it only fetches each Wikipedia page once.

## Examples

``` r
if (FALSE) { # \dontrun{
# Get info for multiple parties
urls <- c(
  "https://en.wikipedia.org/wiki/Democratic_Party_(United_States)",
  "https://en.wikipedia.org/wiki/Republican_Party_(United_States)",
  "https://en.wikipedia.org/wiki/Social_Democratic_Party_of_Germany"
)
get_party_info(urls)

# Include all colors
get_party_info(urls, all_colors = TRUE)
} # }
```
