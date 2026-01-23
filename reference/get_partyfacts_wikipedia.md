# Download Partyfacts Wikipedia data

Downloads the current Partyfacts Wikipedia dataset containing party
names, countries, and Wikipedia URLs for thousands of political parties
worldwide.

## Usage

``` r
get_partyfacts_wikipedia(cache = TRUE)
```

## Arguments

- cache:

  Logical. If \`TRUE\` (default), caches the downloaded data for the
  current R session to avoid repeated downloads.

## Value

A tibble with columns: country, partyfacts_id, url, name_short, name,
name_native, year_founded, year_dissolved.

## Details

The data comes from the Partyfacts project
(\<https://partyfacts.herokuapp.com/\>), which links party datasets and
provides Wikipedia URLs for political parties. The data is downloaded
from the Partyfacts GitHub repository.

## See also

\[lookup_party_url()\] for searching parties in the dataset.

## Examples

``` r
# \donttest{
if (curl::has_internet()) {
  # Download the dataset
  pf_data <- get_partyfacts_wikipedia()

  # View parties from Germany
  pf_data[pf_data$country == "DEU", ]
}
#> # A tibble: 60 × 8
#>    country partyfacts_id url           name_short name  name_native year_founded
#>    <chr>           <int> <chr>         <chr>      <chr> <chr>              <int>
#>  1 DEU              1976 https://en.w… AfD        Alte… Alternativ…         2013
#>  2 DEU              2068 https://en.w… NA         Bava… NA                  1895
#>  3 DEU              1825 https://en.w… NA         Bava… Bayerische…         1918
#>  4 DEU                61 https://en.w… BP         Bava… Bayernpart…         1946
#>  5 DEU              1816 https://en.w… GRÜNE      Alli… Bündnis 90…         1993
#>  6 DEU               865 https://en.w… GRÜNE      Alli… Bündnis 90…         1993
#>  7 DEU              1375 https://en.w… CDU        Chri… Christlich…         1945
#>  8 DEU               211 https://en.w… CDU/CSU    CDU/… NA                  1949
#>  9 DEU              1831 https://en.w… NA         Chri… NA                  1928
#> 10 DEU              8723 https://en.w… NA         Chri… Christlich…         1878
#> # ℹ 50 more rows
#> # ℹ 1 more variable: year_dissolved <int>
# }
```
