# Changelog

## partycoloR 0.2.0

### New Features

- New function
  [`get_party_color()`](https://lwarode.github.io/partycoloR/reference/get_party_color.md) -
  vectorized color extraction with support for multiple colors
  (`all_colors` parameter) and color normalization.

- New function
  [`get_party_logo()`](https://lwarode.github.io/partycoloR/reference/get_party_logo.md) -
  extract party logo URLs from Wikipedia pages.

- New function
  [`get_party_info()`](https://lwarode.github.io/partycoloR/reference/get_party_info.md) -
  extract both color and logo in a single call for better efficiency.

- New Partyfacts integration:

  - [`get_partyfacts_wikipedia()`](https://lwarode.github.io/partycoloR/reference/get_partyfacts_wikipedia.md) -
    download the Partyfacts Wikipedia dataset
  - [`lookup_party_url()`](https://lwarode.github.io/partycoloR/reference/lookup_party_url.md) -
    search for parties by name and country
  - [`get_party_color_by_name()`](https://lwarode.github.io/partycoloR/reference/get_party_color_by_name.md) -
    convenience function combining lookup and color extraction
  - [`clear_partycolor_cache()`](https://lwarode.github.io/partycoloR/reference/clear_partycolor_cache.md) -
    clear cached Partyfacts data

### Improvements

- Functions are now fully vectorized and work seamlessly with
  [`dplyr::mutate()`](https://dplyr.tidyverse.org/reference/mutate.html).

- Better error handling - invalid URLs return NA instead of throwing
  errors.

- Color normalization converts named colors (e.g., “red”) to hex codes
  and expands 3-digit hex codes to 6 digits.

- Added comprehensive test suite using testthat.

- Complete vignette with examples and best practices.

- Updated to use modern tidyverse patterns (replaced `gather`/`spread`
  with `pivot_longer`/`pivot_wider`).

### Breaking Changes

- The original
  [`wikipedia_party_color()`](https://lwarode.github.io/partycoloR/reference/wikipedia_party_color.md)
  function is now deprecated. Use
  [`get_party_color()`](https://lwarode.github.io/partycoloR/reference/get_party_color.md)
  instead.

- The package now requires R \>= 4.1.0.

### Documentation

- Added detailed function documentation with examples.

- New vignette: “Getting Started with partycoloR”.

- Updated README with feature overview and quick start guide.

## partycoloR 0.1.0

- Initial release with
  [`wikipedia_party_color()`](https://lwarode.github.io/partycoloR/reference/wikipedia_party_color.md)
  function.

- Extract party colors from English Wikipedia party pages.
