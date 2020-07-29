
<!-- README.md is generated from README.Rmd. Please edit that file -->

# partycoloR

The goal of partycoloR is to extract color information from Wikipedia
articles of political parties. Party colors play a crucial role in
visually identifying political parties. The function
`wikipedia_party_color` extracts the party color code (HEX code or HTML
color name) from webscraped English Wikipedia political party pages. The
input argument needs to be a list and the function generates a data
frame / tibble.

## Installation

You can install the released version of partycoloR from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("partycoloR")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(partycoloR)
#> Warning: replacing previous import 'purrr::pluck' by 'rvest::pluck' when loading
#> 'partycoloR'
## basic example code
```
