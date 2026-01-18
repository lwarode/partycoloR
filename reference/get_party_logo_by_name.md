# Get party logo by name

A convenience function that combines party lookup and logo extraction.
Searches for a party by name, finds its Wikipedia URL, and extracts the
party logo URL.

## Usage

``` r
get_party_logo_by_name(party_name, country = NULL, data = NULL)
```

## Arguments

- party_name:

  A character string with the party name to search for.

- country:

  Optional. ISO 3-letter country code to filter results.

- data:

  Optional. A Partyfacts dataset.

## Value

If exactly one party is found, returns the logo URL. If multiple parties
match, returns a tibble with party info and logo URLs. Returns NA if no
party is found.

## Examples

``` r
if (FALSE) { # \dontrun{
# Get logo for German SPD
get_party_logo_by_name("SPD", country = "DEU")

# Search more broadly
get_party_logo_by_name("Labour", country = "GBR")
} # }
```
