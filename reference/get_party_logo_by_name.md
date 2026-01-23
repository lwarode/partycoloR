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
# \donttest{
if (curl::has_internet()) {
  # Get logo for German SPD
  get_party_logo_by_name("SPD", country = "DEU")

  # Search more broadly
  get_party_logo_by_name("Labour", country = "GBR")
}
#> # A tibble: 7 × 9
#>   country partyfacts_id url            name_short name  name_native year_founded
#>   <chr>           <int> <chr>          <chr>      <chr> <chr>              <int>
#> 1 GBR               234 https://en.wi… ILP        Inde… NA                  1893
#> 2 GBR              1516 https://en.wi… Lab        Labo… Labour Par…         1900
#> 3 GBR              2121 https://en.wi… NA         Nati… NA                  1918
#> 4 GBR              2122 https://en.wi… NLO        Nati… NA                  1931
#> 5 GBR              8757 https://en.wi… NILP       Nort… NA                  1924
#> 6 GBR               762 https://en.wi… SDLP       Soci… Páirtí Sói…         1970
#> 7 GBR              1277 https://en.wi… NA         Soci… NA                  1996
#> # ℹ 2 more variables: year_dissolved <int>, logo_url <chr>
# }
```
