# Get party info by name

A convenience function that combines party lookup with color and logo
extraction. Searches for a party by name, finds its Wikipedia URL, and
extracts both color and logo.

## Usage

``` r
get_party_info_by_name(
  party_name,
  country = NULL,
  all_colors = FALSE,
  data = NULL
)
```

## Arguments

- party_name:

  A character string with the party name to search for.

- country:

  Optional. ISO 3-letter country code to filter results.

- all_colors:

  Logical. If \`TRUE\`, includes all colors as a list-column. Default is
  \`FALSE\`.

- data:

  Optional. A Partyfacts dataset.

## Value

A tibble with party info, color, and logo_url columns. Returns a tibble
with zero rows if no party is found.

## Examples

``` r
if (FALSE) { # \dontrun{
# Get info for German SPD
get_party_info_by_name("SPD", country = "DEU")

# Search more broadly with all colors
get_party_info_by_name("Labour", country = "GBR", all_colors = TRUE)
} # }
```
