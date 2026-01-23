# Download party logo image

Downloads a party logo image from a URL and saves it to a file.

## Usage

``` r
download_party_logo(logo_url, destfile, overwrite = FALSE)
```

## Arguments

- logo_url:

  A character string with the logo URL (from \[get_party_logo()\]).

- destfile:

  Path where the image should be saved.

- overwrite:

  Logical. If \`TRUE\`, overwrite existing files.

## Value

Invisible \`TRUE\` if successful, \`FALSE\` otherwise.

## Examples

``` r
# \donttest{
if (curl::has_internet()) {
  logo_url <- get_party_logo(
    "https://en.wikipedia.org/wiki/Democratic_Party_(United_States)"
  )
  tmp_file <- tempfile(fileext = ".png")
  download_party_logo(logo_url, tmp_file)
  unlink(tmp_file)
}
# }
```
