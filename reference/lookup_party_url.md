# Look up party Wikipedia URL

Search the Partyfacts Wikipedia dataset for a party by name and/or
country.

## Usage

``` r
lookup_party_url(party_name, country = NULL, data = NULL, exact = FALSE)
```

## Arguments

- party_name:

  A character string to search for in party names. The search is
  case-insensitive and matches partial names.

- country:

  Optional. ISO 3-letter country code (e.g., "DEU", "USA", "GBR") to
  filter results.

- data:

  Optional. A Partyfacts dataset (from \[get_partyfacts_wikipedia()\]).
  If not provided, downloads the data automatically.

- exact:

  Logical. If \`TRUE\`, requires exact match on party name. Default is
  \`FALSE\` (partial matching).

## Value

A tibble with matching parties and their Wikipedia URLs.

## Examples

``` r
if (FALSE) { # \dontrun{
# Search for parties with "Democratic" in the name
lookup_party_url("Democratic")

# Search within a specific country
lookup_party_url("SPD", country = "DEU")

# Exact match
lookup_party_url("CDU", country = "DEU", exact = TRUE)
} # }
```
