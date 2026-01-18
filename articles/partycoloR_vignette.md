# Getting Started with partycoloR

``` r
library(partycoloR)
library(dplyr)
```

## Introduction

The `partycoloR` package extracts political party colors and logos from
English Wikipedia party pages. This is useful for political scientists
and data visualization practitioners who want consistent, recognizable
colors for political parties in their charts and graphs.

## Basic Usage

### Extracting Party Colors

The main function
[`get_party_color()`](https://lwarode.github.io/partycoloR/reference/get_party_color.md)
takes Wikipedia URLs and returns the party’s primary color as a hex
code:

``` r
# Single party
dem_url <- "https://en.wikipedia.org/wiki/Democratic_Party_(United_States)"
get_party_color(dem_url)
#> "#0015BC"

# Multiple parties
urls <- c(
  "https://en.wikipedia.org/wiki/Democratic_Party_(United_States)",
  "https://en.wikipedia.org/wiki/Republican_Party_(United_States)",
  "https://en.wikipedia.org/wiki/Green_Party_of_the_United_States"
)
get_party_color(urls)
#> "#0015BC" "#E81B23" "#17AA5C"
```

### Extracting Multiple Colors

Some parties have more than one official color. Use `all_colors = TRUE`
to get all colors:

``` r
# German CDU has black and orange
cdu_url <- "https://en.wikipedia.org/wiki/Christian_Democratic_Union_of_Germany"
get_party_color(cdu_url, all_colors = TRUE)
#> [[1]]
#> [1] "#000000" "#FF6600"
```

### Extracting Party Logos

Use
[`get_party_logo()`](https://lwarode.github.io/partycoloR/reference/get_party_logo.md)
to get the URL of the party’s logo image:

``` r
get_party_logo(dem_url)
#> "https://upload.wikimedia.org/wikipedia/commons/thumb/..."
```

### Downloading Party Logos

You can download logos to a local file using
[`download_party_logo()`](https://lwarode.github.io/partycoloR/reference/download_party_logo.md):

``` r
# Get logo URL and download it
logo_url <- get_party_logo(dem_url)
download_party_logo(logo_url, "democratic_logo.png")

# Or use a pipeline with get_party_logo_by_name()
get_party_logo_by_name("SPD", country = "DEU") %>%
  download_party_logo("spd_logo.svg")
```

Note that the file extension should match the actual image format. Many
Wikipedia logos are SVGs, so check the URL to determine the correct
extension.

### Getting Both at Once

For efficiency, use
[`get_party_info()`](https://lwarode.github.io/partycoloR/reference/get_party_info.md)
to extract both color and logo in a single request:

``` r
get_party_info(urls)
#> # A tibble: 3 x 3
#>   url                                                      color   logo_url
#>   <chr>                                                    <chr>   <chr>
#> 1 https://en.wikipedia.org/wiki/Democratic_Party_(Unite... #0015BC https://...
#> 2 https://en.wikipedia.org/wiki/Republican_Party_(Unite... #E81B23 https://...
#> 3 https://en.wikipedia.org/wiki/Green_Party_of_the_Unit... #17AA5C https://...
```

## Working with dplyr

The functions are designed to work seamlessly with
[`dplyr::mutate()`](https://dplyr.tidyverse.org/reference/mutate.html):

``` r
parties <- tibble(
  party = c("Democrats", "Republicans", "Greens"),
  wiki_url = c(
    "https://en.wikipedia.org/wiki/Democratic_Party_(United_States)",
    "https://en.wikipedia.org/wiki/Republican_Party_(United_States)",
    "https://en.wikipedia.org/wiki/Green_Party_of_the_United_States"
  )
)

parties %>%
  mutate(
    color = get_party_color(wiki_url),
    logo = get_party_logo(wiki_url)
  )
```

### Working with Multiple Colors

When using `all_colors = TRUE`, the result is a list-column. Use `purrr`
functions to extract specific colors:

``` r
library(purrr)

german_parties <- tibble(
  party = c("CDU", "SPD"),
  wiki_url = c(
    "https://en.wikipedia.org/wiki/Christian_Democratic_Union_of_Germany",
    "https://en.wikipedia.org/wiki/Social_Democratic_Party_of_Germany"
  )
)

# Extract all colors as a list-column, then extract individual colors
german_parties %>%
  mutate(
    all_colors = get_party_color(wiki_url, all_colors = TRUE),
    color_1 = map_chr(all_colors, pluck, 1, 1, .default = NA_character_),
    color_2 = map_chr(all_colors, pluck, 1, 2, .default = NA_character_)
  )
#> # A tibble: 2 x 5
#>   party wiki_url                              all_colors color_1 color_2
#>   <chr> <chr>                                 <list>     <chr>   <chr>
#> 1 CDU   https://en.wikipedia.org/wiki/Chris.. <list [1]> #000000 #FF6600
#> 2 SPD   https://en.wikipedia.org/wiki/Soci..  <list [1]> #E3000F NA
```

Alternatively, unnest to long format (one row per color):

``` r
german_parties %>%
  mutate(all_colors = get_party_color(wiki_url, all_colors = TRUE)) %>%
  tidyr::unnest_longer(all_colors) %>%
  tidyr::unnest_longer(all_colors, values_to = "color")
#> # A tibble: 3 x 3
#>   party wiki_url                                               color
#>   <chr> <chr>                                                  <chr>
#> 1 CDU   https://en.wikipedia.org/wiki/Christian_Democratic...  #000000
#> 2 CDU   https://en.wikipedia.org/wiki/Christian_Democratic...  #FF6600
#> 3 SPD   https://en.wikipedia.org/wiki/Social_Democratic_Pa...  #E3000F
```

## Using Party Facts Integration

If you don’t have Wikipedia URLs, you can look up parties by name using
the [Party Facts](https://partyfacts.herokuapp.com/) database
integration.

### Download Party Facts Data

``` r
# Download the current Party Facts Wikipedia dataset
pf_data <- get_partyfacts_wikipedia()
head(pf_data)
#> # A tibble: 6 x 8
#>   country partyfacts_id url         name_short name  name_native year_founded
#>   <chr>           <int> <chr>       <chr>      <chr> <chr>              <int>
#> 1 AFG              6641 https://... NA         Afgh... NA                 1966
#> ...
```

### Look Up Parties by Name

``` r
# Search for a party by name
lookup_party_url("SPD", country = "DEU")
#> # A tibble: 1 x 8
#>   country partyfacts_id url                             name_short name
#>   <chr>           <int> <chr>                           <chr>      <chr>
#> 1 DEU              1375 https://en.wikipedia.org/wiki/... SPD      Social...

# Search across all countries
lookup_party_url("Labour")
```

### Convenience Function

Use
[`get_party_color_by_name()`](https://lwarode.github.io/partycoloR/reference/get_party_color_by_name.md)
to combine lookup and color extraction:

``` r
# Get SPD color directly by name
get_party_color_by_name("SPD", country = "DEU")
#> "#E3000F"

# If multiple parties match, returns a tibble with all matches
get_party_color_by_name("Labour")
#> # A tibble: 12 x 9
#>    country partyfacts_id url    name_short name  ... color
#>    ...
```

## Visualization Example

Here’s how to use party colors in a ggplot2 visualization:

``` r
library(ggplot2)

# Example data: German 2021 election results
german_parties <- tibble(
  party = c("SPD", "CDU/CSU", "Greens", "FDP", "AfD", "Left"),
  vote_share = c(25.7, 24.1, 14.8, 11.5, 10.3, 4.9),
  wiki_url = c(
    "https://en.wikipedia.org/wiki/Social_Democratic_Party_of_Germany",
    "https://en.wikipedia.org/wiki/Christian_Democratic_Union_of_Germany",
    "https://en.wikipedia.org/wiki/Alliance_90/The_Greens",
    "https://en.wikipedia.org/wiki/Free_Democratic_Party_(Germany)",
    "https://en.wikipedia.org/wiki/Alternative_for_Germany",
    "https://en.wikipedia.org/wiki/The_Left_(Germany)"
  )
)

# Get party colors
german_parties <- german_parties %>%
  mutate(color = get_party_color(wiki_url))

# Create bar chart with party colors
ggplot(german_parties, aes(x = reorder(party, -vote_share), y = vote_share)) +
  geom_col(fill = german_parties$color) +
  labs(
    title = "German Federal Election 2021",
    x = NULL,
    y = "Vote Share (%)"
  ) +
  theme_minimal()
```

## Error Handling

The functions handle errors gracefully:

``` r
# Invalid URLs return NA
get_party_color("https://not-wikipedia.com/page")
#> NA

# Non-existent pages return NA
get_party_color("https://en.wikipedia.org/wiki/Nonexistent_Party_12345")
#> NA

# Mixed valid and invalid URLs
urls <- c(
  "https://en.wikipedia.org/wiki/Democratic_Party_(United_States)",
  NA,
  "invalid_url"
)
get_party_color(urls)
#> "#0015BC" NA NA
```

## Caching

The Party Facts data is cached in the R session to avoid repeated
downloads:

``` r
# First call downloads the data
pf_data <- get_partyfacts_wikipedia()

# Subsequent calls use the cache (faster)
pf_data <- get_partyfacts_wikipedia()

# Clear the cache if needed
clear_partycolor_cache()
```

## Tips and Best Practices

1.  **Batch requests**: When processing many parties, pass all URLs to
    [`get_party_color()`](https://lwarode.github.io/partycoloR/reference/get_party_color.md)
    at once rather than calling it in a loop.

2.  **Cache Party Facts data**: If you’ll be doing multiple lookups,
    call
    [`get_partyfacts_wikipedia()`](https://lwarode.github.io/partycoloR/reference/get_partyfacts_wikipedia.md)
    once and pass the result to
    [`lookup_party_url()`](https://lwarode.github.io/partycoloR/reference/lookup_party_url.md).

3.  **Handle missing data**: Always check for NA values in the results,
    as some Wikipedia pages may not have color information or may have
    unexpected formatting.

4.  **Wikipedia changes**: The scraping depends on Wikipedia’s HTML
    structure. If results seem wrong, the Wikipedia page format may have
    changed.

## Related Resources

- [Party Facts](https://partyfacts.herokuapp.com/) - Party Facts links
  datasets on political parties across a wide range of social science
  datasets
- [ParlGov](https://www.parlgov.org/) - Database on parties, elections
  and cabinets from EU and OECD democracies
- [ParlGov Dashboard](https://lwarode.shinyapps.io/ParlGov_Dashboard/) -
  R Shiny dashboard with data from ParlGov and party colors from
  `partycoloR`
