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
if (FALSE) { # \dontrun{
party_list <- c(
  "https://en.wikipedia.org/wiki/Democratic_Party_(United_States)",
  "https://en.wikipedia.org/wiki/Republican_Party_(United_States)"
)
wikipedia_party_color(party_list)
} # }
```
