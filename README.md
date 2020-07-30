
<!-- README.md is generated from README.Rmd. Please edit that file -->

# partycoloR

The goal of partycoloR is to extract color information from Wikipedia
articles of political parties. Party colors are playing a crucial role
in visually identifying political parties. The function
`wikipedia_party_color` extracts the party color code (HEX/HTML color
codes / names) from webscraped English Wikipedia political party pages.
The input argument needs to be a list and the function generates a data
frame / tibble with all the extracted color codes / names.

## Installation

You can install the released version of partycoloR from
[GitHub](https://github.com/lwarode/partycoloR) with:

``` r
devtools::install_github("lwarode/partycoloR")
```

## Example

The input argument is a list of political party articles (URL) from
English Wikipedia. The function returns a data frame / tibble with all
party colors (as HEX color or HTML color code).

``` r
party_list <- list("https://en.wikipedia.org/wiki/Democratic_Party_(United_States)",
"https://en.wikipedia.org/wiki/Republican_Party_(United_States)")

party_color_df <- wikipedia_party_color(party_list)

glimpse(party_color_df)
```
