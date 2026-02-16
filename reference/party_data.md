# Bundled party colors and logos dataset

A dataset containing pre-scraped party colors and logos from Wikipedia
for political parties in the Party Facts database. This dataset is
bundled with the package to provide fast lookups without requiring live
Wikipedia scraping.

## Usage

``` r
party_data
```

## Format

A tibble with 5 columns:

- url:

  Wikipedia URL of the party page (character)

- color:

  Primary party color as normalized HEX code, e.g., "#0015BC"
  (character)

- all_colors:

  List column containing all party colors as character vector (list)

- logo_url:

  URL to the party logo image on Wikimedia Commons (character)

- last_updated:

  Date when the data was scraped from Wikipedia (Date)

## Source

Data scraped from English Wikipedia party pages. Party list from Party
Facts database: Döring and Regel (2019) \<doi:10.1177/1354068818820671\>
and Bederke, Döring, and Regel (2023) \<doi:10.7910/DVN/TJINLQ\>.

## Details

This dataset contains pre-scraped color and logo information for
political parties from the Party Facts Wikipedia dataset, covering
parties worldwide that have English Wikipedia pages with available color
data.

The data is used by default in \[get_party_color()\],
\[get_party_logo()\], and \[get_party_info()\] to provide instant
lookups. If a party is not found in this dataset, the functions
automatically fall back to live Wikipedia scraping.

Color codes are normalized to uppercase 6-digit HEX format (e.g.,
"#FF0000"). Logo URLs point to images hosted on Wikimedia Commons.

To regenerate or update this dataset, see the script at
\`data-raw/update.R\` in the package source.

## See also

\[get_party_color()\], \[get_party_logo()\], \[get_party_info()\]

## Examples

``` r
# View structure of bundled data
str(party_data)
#> tibble [1,591 × 5] (S3: tbl_df/tbl/data.frame)
#>  $ url         : chr [1:1591] "https://en.wikipedia.org/wiki/Aruban_People%27s_Party" "https://en.wikipedia.org/wiki/People%27s_Electoral_Movement_(Aruba)" "https://en.wikipedia.org/wiki/Jamiat-e_Islami" "https://en.wikipedia.org/wiki/National_Coalition_of_Afghanistan" ...
#>  $ color       : chr [1:1591] "#65B22E" "#FFEC36" "#03913D" "#004E98" ...
#>  $ all_colors  :List of 1591
#>   ..$ :List of 1
#>   .. ..$ : chr "#65B22E"
#>   ..$ :List of 1
#>   .. ..$ : chr "#FFEC36"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#03913D" "#FFFFFF"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:5] "#004E98" "#8C6B33" "#19130F" "#DB1F16" ...
#>   ..$ :List of 1
#>   .. ..$ : chr "#FFD700"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#FF0000" "#FCDD09"
#>   ..$ :List of 1
#>   .. ..$ : chr "#CE0921"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#FFC614" "#095392"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#96CDEF" "#008000"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#ED1C24" "#000000"
#>   ..$ :List of 1
#>   .. ..$ : chr "#F8D308"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#009EE2" "#D0CC02"
#>   ..$ :List of 1
#>   .. ..$ : chr "#EF4A2E"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#0C5D34" "#AC2232"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:3] "#D51920" "#000000" "#FFFFFF"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:4] "#E3171B" "#6EB42C" "#5E3894" "#EA088B"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:3] "#2E4166" "#EFCB2D" "#019DC5"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#FF6600" "#0066FF"
#>   ..$ :List of 1
#>   .. ..$ : chr "#FF0000"
#>   ..$ :List of 1
#>   .. ..$ : chr "#192B6B"
#>   ..$ :List of 1
#>   .. ..$ : chr "#E30C1B"
#>   ..$ :List of 1
#>   .. ..$ : chr "#B51601"
#>   ..$ :List of 1
#>   .. ..$ : chr "#66FFCC"
#>   ..$ :List of 1
#>   .. ..$ : chr "#FFA500"
#>   ..$ :List of 1
#>   .. ..$ : chr "#FC2015"
#>   ..$ :List of 1
#>   .. ..$ : chr "#0F2B3D"
#>   ..$ :List of 1
#>   .. ..$ : chr "#FFD700"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#318CE7" "#FFFFFF"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#318CE7" "#FFFFFF"
#>   ..$ :List of 1
#>   .. ..$ : chr "#04B45F"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#0047AB" "#FFFFFF"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#192B6B" "#005C9E"
#>   ..$ :List of 1
#>   .. ..$ : chr "#00C4F0"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#E10019" "#FFFFFF"
#>   ..$ :List of 1
#>   .. ..$ : chr "#0E3C61"
#>   ..$ :List of 1
#>   .. ..$ : chr "#FFD700"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#E30C1B" "#FF9900"
#>   ..$ :List of 1
#>   .. ..$ : chr "#19BC9D"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#6495ED" "#FFFFFF"
#>   ..$ :List of 1
#>   .. ..$ : chr "#F65058"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#FF0000" "#FFD700"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:3] "#2C2755" "#FFFFFF" "#5169B1"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#ED1A24" "#183964"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#D9B368" "#1E3970"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#24AA96" "#FFCD00"
#>   ..$ :List of 1
#>   .. ..$ : chr "#10C25B"
#>   ..$ :List of 1
#>   .. ..$ : chr "#F00011"
#>   ..$ :List of 1
#>   .. ..$ : chr "#F00011"
#>   ..$ :List of 1
#>   .. ..$ : chr "#F00011"
#>   ..$ :List of 1
#>   .. ..$ : chr "#F00011"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#FF6300" "#000000"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#FFA500" "#7F007F"
#>   ..$ :List of 1
#>   .. ..$ : chr "#00557C"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#FF7F00" "#080CAB"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#1456F1" "#FF7F00"
#>   ..$ :List of 1
#>   .. ..$ : chr "#FFD425"
#>   ..$ :List of 1
#>   .. ..$ : chr "#B50204"
#>   ..$ :List of 1
#>   .. ..$ : chr "#1456F1"
#>   ..$ :List of 1
#>   .. ..$ : chr "#080CAB"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#080CAB" "#66C7DE"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#008000" "#FEF032"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#008000" "#FEF032"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#008000" "#FEF032"
#>   ..$ :List of 1
#>   .. ..$ : chr "#6495ED"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#FF6900" "#0076BC"
#>   ..$ :List of 1
#>   .. ..$ : chr "#3198FF"
#>   ..$ :List of 1
#>   .. ..$ : chr "#F00011"
#>   ..$ :List of 1
#>   .. ..$ : chr "#F8EF21"
#>   ..$ :List of 1
#>   .. ..$ : chr "#00008B"
#>   ..$ :List of 1
#>   .. ..$ : chr "#0056A2"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#63C3D0" "#000000"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:3] "#E4013B" "#000000" "#AA0000"
#>   ..$ :List of 1
#>   .. ..$ : chr "#FF5F61"
#>   ..$ :List of 1
#>   .. ..$ : chr "#87B529"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:3] "#ED2939" "#009258" "#FFFFFF"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:3] "#000000" "#FF0000" "#FFCC00"
#>   ..$ :List of 1
#>   .. ..$ : chr "#FFDC00"
#>   ..$ :List of 1
#>   .. ..$ : chr "#CB1667"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#FFFFFF" "#ADADAD"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:4] "#000000" "#FFFFFF" "#DE0000" "#964B00"
#>   ..$ :List of 1
#>   .. ..$ : chr "#162D68"
#>   ..$ :List of 1
#>   .. ..$ : chr "#008000"
#>   ..$ :List of 1
#>   .. ..$ : chr "#E42712"
#>   ..$ :List of 1
#>   .. ..$ : chr "#284696"
#>   ..$ :List of 1
#>   .. ..$ : chr "#D40000"
#>   ..$ :List of 1
#>   .. ..$ : chr "#FF0000"
#>   ..$ :List of 1
#>   .. ..$ : chr "#007DC3"
#>   ..$ :List of 1
#>   .. ..$ : chr "#007DC3"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#0075C1" "#F8D101"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:3] "#C8102E" "#43B02A" "#FFFFFF"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#FF0000" "#FFFFFF"
#>   ..$ :List of 1
#>   .. ..$ : chr "#FF66FF"
#>   ..$ :List of 1
#>   .. ..$ : chr "#DC241F"
#>   ..$ :List of 1
#>   .. ..$ : chr "#FF0000"
#>   ..$ :List of 1
#>   .. ..$ : chr "#FFD700"
#>   ..$ :List of 1
#>   .. ..$ : chr "#FF6200"
#>   ..$ :List of 1
#>   .. ..$ : chr "#FF6200"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#FFA500" "#000000"
#>   ..$ :List of 1
#>   .. ..$ : chr "#EA5B0D"
#>   .. [list output truncated]
#>  $ logo_url    : chr [1:1591] "https://upload.wikimedia.org/wikipedia/commons/thumb/0/08/Arubaanse_Volkspartij_logo.png/250px-Arubaanse_Volkspartij_logo.png" "https://upload.wikimedia.org/wikipedia/en/thumb/3/38/People%27s_Electoral_Movement_%28Aruba%29.png/250px-People"| __truncated__ "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/Logo_of_Jamiat-e_Islami.svg/250px-Logo_of_Jamiat-e_Islami.svg.png" "https://upload.wikimedia.org/wikipedia/en/thumb/f/fc/Emblem_of_the_National_Coalition_of_Afghanistan.svg/250px-"| __truncated__ ...
#>  $ last_updated: Date[1:1591], format: "2026-02-16" "2026-02-16" ...

# Number of parties in bundled dataset
nrow(party_data)
#> [1] 1591

# Count of parties by availability of data
sum(!is.na(party_data$color))    # Parties with colors
#> [1] 1591
sum(!is.na(party_data$logo_url)) # Parties with logos
#> [1] 1484

# Example: Find a specific party
if (FALSE) { # \dontrun{
party_data[grepl("Democratic.*United States", party_data$url), ]
} # }
```
