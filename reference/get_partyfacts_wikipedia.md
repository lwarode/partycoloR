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
if (FALSE) { # \dontrun{
# Download the dataset
pf_data <- get_partyfacts_wikipedia()

# View parties from Germany
pf_data[pf_data$country == "DEU", ]
} # }
```
