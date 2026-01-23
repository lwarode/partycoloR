# Extract party colors from Wikipedia (legacy function)

\`r lifecycle::badge("deprecated")\`

This function is deprecated. Please use \[get_party_color()\] instead.

## Usage

``` r
wikipedia_party_color(party_url_list)
```

## Arguments

- party_url_list:

  A list of Wikipedia political party URLs

## Value

A data frame / tibble containing extracted color codes from Wikipedia

## Examples

``` r
# \donttest{
if (curl::has_internet()) {
  party_list <- c(
    "https://en.wikipedia.org/wiki/Democratic_Party_(United_States)",
    "https://en.wikipedia.org/wiki/Republican_Party_(United_States)"
  )
  wikipedia_party_color(party_list)
}
#> Warning: 'wikipedia_party_color' is deprecated.
#> Use 'get_party_color' instead.
#> See help("Deprecated")
#> # A tibble: 2 × 2
#>   url                                                            color_1
#>   <chr>                                                          <chr>  
#> 1 https://en.wikipedia.org/wiki/Democratic_Party_(United_States) #3333FF
#> 2 https://en.wikipedia.org/wiki/Republican_Party_(United_States) #E81B23
# }
```
