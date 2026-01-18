# Get party color by name

A convenience function that combines party lookup and color extraction.
Searches for a party by name, finds its Wikipedia URL, and extracts the
party color.

## Usage

``` r
get_party_color_by_name(
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

  Logical. If \`TRUE\`, returns all colors. Default is \`FALSE\`.

- data:

  Optional. A Partyfacts dataset.

## Value

If exactly one party is found, returns the color(s). If multiple parties
match, returns a tibble with party info and colors. Returns NA if no
party is found.

## Examples

``` r
if (FALSE) { # \dontrun{
# Get color for German SPD
get_party_color_by_name("SPD", country = "DEU")

# Search more broadly
get_party_color_by_name("Labour", country = "GBR")
} # }
```
