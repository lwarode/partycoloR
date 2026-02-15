# Bundled party colors and logos dataset

A dataset containing pre-scraped party colors and logos from Wikipedia
for major political parties worldwide. This dataset is bundled with the
package to provide fast lookups without requiring live Wikipedia
scraping.

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

This dataset contains pre-scraped color and logo information for major
political parties from around the world, with emphasis on parties from
G20 countries and major European democracies.

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
#> tibble [219 × 5] (S3: tbl_df/tbl/data.frame)
#>  $ url         : chr [1:219] "https://en.wikipedia.org/wiki/Cambiemos" "https://en.wikipedia.org/wiki/Kolina" "https://en.wikipedia.org/wiki/Workers%27_Left_Front" "https://en.wikipedia.org/wiki/National_Party_of_Australia" ...
#>  $ color       : chr [1:219] "#FFD700" "#04B45F" "#F65058" "#008000" ...
#>  $ all_colors  :List of 219
#>   ..$ :List of 1
#>   .. ..$ : chr "#FFD700"
#>   ..$ :List of 1
#>   .. ..$ : chr "#04B45F"
#>   ..$ :List of 1
#>   .. ..$ : chr "#F65058"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#008000" "#FEF032"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#008000" "#FEF032"
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
#>   .. ..$ : chr [1:2] "#FFA500" "#7F007F"
#>   ..$ :List of 1
#>   .. ..$ : chr "#FF5F61"
#>   ..$ :List of 1
#>   .. ..$ : chr "#87B529"
#>   ..$ :List of 1
#>   .. ..$ : chr "#0056A2"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:3] "#E4013B" "#000000" "#AA0000"
#>   ..$ :List of 1
#>   .. ..$ : chr "#01796F"
#>   ..$ :List of 1
#>   .. ..$ : chr "#F4761A"
#>   ..$ :List of 1
#>   .. ..$ : chr "#FF6200"
#>   ..$ :List of 1
#>   .. ..$ : chr "#FF6200"
#>   ..$ :List of 1
#>   .. ..$ : chr "#EA5B0D"
#>   ..$ :List of 1
#>   .. ..$ : chr "#DD0081"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:4] "#339933" "#FFCC00" "#BD0914" "#333333"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#FF2200" "#FFFF00"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#CC0000" "#FFE500"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#0033A1" "#2670CB"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:4] "#00A54F" "#FED304" "#015AAA" "#FFFFFF"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#0080FF" "#FFDF00"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:5] "#CC0033" "#F3F3F3" "#160064" "#00FF00" ...
#>   ..$ :List of 1
#>   .. ..$ : chr "#87CEFA"
#>   ..$ :List of 1
#>   .. ..$ : chr "#EC1C24"
#>   ..$ :List of 1
#>   .. ..$ : chr "#6495ED"
#>   ..$ :List of 1
#>   .. ..$ : chr "#99C955"
#>   ..$ :List of 1
#>   .. ..$ : chr "#EA6D6A"
#>   ..$ :List of 1
#>   .. ..$ : chr "#F4A460"
#>   ..$ :List of 1
#>   .. ..$ : chr "#6F5D9A"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#EFDA18" "#1161A6"
#>   ..$ :List of 1
#>   .. ..$ : chr "#0E52A0"
#>   ..$ :List of 1
#>   .. ..$ : chr "#84B414"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#B4DC00" "#119CD4"
#>   ..$ :List of 1
#>   .. ..$ : chr "#134B94"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:5] "#83B926" "#3865A1" "#E1153B" "#ED8611" ...
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#FF0000" "#FFFF00"
#>   ..$ :List of 1
#>   .. ..$ : chr "#1E90FF"
#>   ..$ :List of 1
#>   .. ..$ : chr "#03BF00"
#>   ..$ :List of 1
#>   .. ..$ : chr "#FF4500"
#>   ..$ :List of 1
#>   .. ..$ : chr "#EE1C25"
#>   ..$ :List of 1
#>   .. ..$ : chr "#000099"
#>   ..$ :List of 1
#>   .. ..$ : chr "#261060"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:3] "#000000" "#CE7BCB" "#FDC702"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:4] "#FAC469" "#FFFFFF" "#D80C13" "#09437F"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#FFDC00" "#0000AA"
#>   ..$ :List of 1
#>   .. ..$ : chr "#E8387F"
#>   ..$ :List of 1
#>   .. ..$ : chr "#10547D"
#>   ..$ :List of 1
#>   .. ..$ : chr "#C10506"
#>   ..$ :List of 1
#>   .. ..$ : chr "#00A2DE"
#>   ..$ :List of 1
#>   .. ..$ : chr "#409A3C"
#>   ..$ :List of 1
#>   .. ..$ : chr "#409A3C"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:3] "#51B8C2" "#151518" "#FFA600"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#005973" "#151518"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#008AC5" "#A2C516"
#>   ..$ :List of 1
#>   .. ..$ : chr "#409A3C"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#00D564" "#18942D"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:3] "#1B4D8B" "#EE243A" "#FCD03B"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:3] "#D2307E" "#02944F" "#733280"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:3] "#D0004C" "#15A06B" "#F7660D"
#>   ..$ :List of 1
#>   .. ..$ : chr "#D4337A"
#>   ..$ :List of 1
#>   .. ..$ : chr "#FFFF00"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#00583C" "#6B9249"
#>   ..$ :List of 1
#>   .. ..$ : chr "#1D84CE"
#>   ..$ :List of 1
#>   .. ..$ : chr "#ADCFEF"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:4] "#FFDD00" "#B2071B" "#000000" "#FFFFFF"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#EB6109" "#01383C"
#>   ..$ :List of 1
#>   .. ..$ : chr "#EC8953"
#>   ..$ :List of 1
#>   .. ..$ : chr "#006288"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:4] "#2B67C9" "#FFFFFF" "#B7D0EE" "#F18716"
#>   ..$ :List of 1
#>   .. ..$ : chr "#AE2375"
#>   ..$ :List of 1
#>   .. ..$ : chr "#3AAD2E"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:4] "#007AC9" "#B81224" "#000000" "#FFDD93"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:3] "#FFFFFF" "#DA2E31" "#8B0000"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:3] "#FFDE55" "#0036A5" "#FFFFFF"
#>   ..$ :List of 1
#>   .. ..$ : chr "#F54B4B"
#>   ..$ :List of 1
#>   .. ..$ : chr "#FF5500"
#>   ..$ :List of 1
#>   .. ..$ : chr "#F00A64"
#>   ..$ :List of 1
#>   .. ..$ : chr "#6495ED"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:3] "#0055A4" "#FFFFFF" "#EF4135"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:4] "#0043B0" "#FFFFFF" "#F0002B" "#0087CD"
#>   ..$ :List of 1
#>   .. ..$ : chr "#4BB166"
#>   ..$ :List of 1
#>   .. ..$ : chr "#254671"
#>   ..$ :List of 1
#>   .. ..$ : chr "#69B95A"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#F6CB2F" "#000000"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#2B45A2" "#FF0000"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#12B6CF" "#FFFFFF"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:3] "#FF0000" "#FFFFFF" "#2E3B74"
#>   ..$ :List of 1
#>   .. ..$ : chr "#0087DC"
#>   ..$ :List of 1
#>   .. ..$ : chr "#3F1D70"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:4] "#C93242" "#FFFFFF" "#051D3E" "#D46A4C"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#FF0000" "#FFFFFF"
#>   ..$ :List of 1
#>   .. ..$ : chr [1:2] "#38A3E7" "#F0001C"
#>   .. [list output truncated]
#>  $ logo_url    : chr [1:219] "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f1/Juntos-Por-El-Cambio-Logo.svg/250px-Juntos-Por-El-Cam"| __truncated__ "https://upload.wikimedia.org/wikipedia/commons/thumb/2/28/Kolina_logo.png/250px-Kolina_logo.png" "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/Logo_Frente_de_Izquierda_y_de_Trabajadores-Unidad.svg"| __truncated__ "https://upload.wikimedia.org/wikipedia/commons/thumb/6/64/The_National_Party_of_Australia_Logo.svg/250px-The_Na"| __truncated__ ...
#>  $ last_updated: Date[1:219], format: "2026-02-15" "2026-02-15" ...

# Number of parties in bundled dataset
nrow(party_data)
#> [1] 219

# Count of parties by availability of data
sum(!is.na(party_data$color))    # Parties with colors
#> [1] 219
sum(!is.na(party_data$logo_url)) # Parties with logos
#> [1] 212

# Example: Find a specific party
if (FALSE) { # \dontrun{
party_data[grepl("Democratic.*United States", party_data$url), ]
} # }
```
