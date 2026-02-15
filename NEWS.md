# partycoloR 0.3.0

## New Features

* **Bundled party data**: Package now includes pre-scraped color and logo data for
  major political parties, providing instant lookups without Wikipedia scraping.
  This dramatically improves performance and reduces load on Wikipedia servers.

* New dataset `party_data` - bundled party colors and logos from Wikipedia with
  columns: url, color, all_colors, logo_url, and last_updated. Covers parties
  from G20 countries and major European democracies.

* New parameter `use_cache` (default `TRUE`) in `get_party_color()`, `get_party_logo()`,
  and `get_party_info()` to prefer bundled data over live scraping. Set to `FALSE`
  to always scrape fresh data from Wikipedia.

* New script `data-raw/update.R` to regenerate bundled data from Wikipedia.
  Package maintainers can use this to periodically update the cached data.

## Improvements

* **Faster performance**: Bundled data lookups are ~100x faster than live scraping
  for parties in the cache.

* **Reduced Wikipedia server load**: Default behavior now uses cached data, with
  graceful fallback to live scraping for parties not in the bundled dataset.

* **Graceful fallback**: If a party is not in bundled data, functions automatically
  fall back to live scraping, ensuring full backward compatibility.

* **Offline capability**: Cached parties can be accessed without internet connection.

## Documentation

* Added comprehensive documentation for `party_data` dataset.

* Updated all function examples to demonstrate both cached and live scraping modes.

* Added new test suite `test-bundled_data.R` with 20+ tests for cache functionality.

* Updated vignette with section on bundled data vs. live scraping.

## Internal

* Added `LazyData: true` to DESCRIPTION for efficient data loading.

* Added cache lookup helper functions: `lookup_cached_color()`, `lookup_cached_logo()`,
  `lookup_cached_info()`.

* Updated all integration tests to explicitly use `use_cache = FALSE` for testing
  live scraping functionality.

# partycoloR 0.2.0

## New Features

* New function `get_party_color()` - vectorized color extraction with support for
  multiple colors (`all_colors` parameter) and color normalization.

* New function `get_party_logo()` - extract party logo URLs from Wikipedia pages.

* New function `get_party_info()` - extract both color and logo in a single call
  for better efficiency.

* New Partyfacts integration:
  - `get_partyfacts_wikipedia()` - download the Partyfacts Wikipedia dataset
  - `lookup_party_url()` - search for parties by name and country
  - `get_party_color_by_name()` - convenience function combining lookup and
    color extraction
  - `clear_partycolor_cache()` - clear cached Partyfacts data

## Improvements

* Functions are now fully vectorized and work seamlessly with `dplyr::mutate()`.

* Better error handling - invalid URLs return NA instead of throwing errors.

* Color normalization converts named colors (e.g., "red") to hex codes and
  expands 3-digit hex codes to 6 digits.

* Added comprehensive test suite using testthat.

* Complete vignette with examples and best practices.

* Updated to use modern tidyverse patterns (replaced `gather`/`spread` with
 `pivot_longer`/`pivot_wider`).

## Breaking Changes

* The original `wikipedia_party_color()` function is now deprecated. Use
  `get_party_color()` instead.

* The package now requires R >= 4.1.0.

## Documentation

* Added detailed function documentation with examples.

* New vignette: "Getting Started with partycoloR".

* Updated README with feature overview and quick start guide.

# partycoloR 0.1.0

* Initial release with `wikipedia_party_color()` function.

* Extract party colors from English Wikipedia party pages.
