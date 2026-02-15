test_that("get_party_color validates input", {
  expect_error(get_party_color(123), "`url` must be a character vector")
  expect_error(get_party_color(list("url")), "`url` must be a character vector")
})

test_that("get_party_color handles NA and invalid URLs", {
  # NA input
  expect_true(is.na(get_party_color(NA_character_)))

  # Invalid URL (not Wikipedia)
  expect_true(is.na(get_party_color("https://google.com")))

  # Empty string
  expect_true(is.na(get_party_color("")))
})

test_that("get_party_color returns character vector", {
  result <- get_party_color(NA_character_)
  expect_type(result, "character")
  expect_length(result, 1)
})

test_that("get_party_color with all_colors returns list", {
  result <- get_party_color(NA_character_, all_colors = TRUE)
  expect_type(result, "list")
  expect_length(result, 1)
})

test_that("get_party_color is vectorized", {
  urls <- c(NA_character_, NA_character_)
  result <- get_party_color(urls)
  expect_length(result, 2)
  expect_true(all(is.na(result)))
})

# Integration tests that require network access
# These are skipped on CRAN and in non-interactive sessions
test_that("get_party_color extracts color from Wikipedia", {
  skip_on_cran()
  skip_on_ci_network()

  url <- "https://en.wikipedia.org/wiki/Democratic_Party_(United_States)"
  result <- get_party_color(url, use_cache = FALSE)

  expect_type(result, "character")
  expect_length(result, 1)
  # Democrats typically have blue - check it's a valid hex
  expect_match(result, "^#[0-9A-F]{6}$")
})

test_that("get_party_color handles multiple URLs", {
  skip_on_cran()
  skip_on_ci_network()

  urls <- c(
    "https://en.wikipedia.org/wiki/Democratic_Party_(United_States)",
    "https://en.wikipedia.org/wiki/Republican_Party_(United_States)"
  )
  result <- get_party_color(urls, use_cache = FALSE)

  expect_type(result, "character")
  expect_length(result, 2)
  # Both should return valid hex codes
  expect_match(result[1], "^#[0-9A-F]{6}$")
  expect_match(result[2], "^#[0-9A-F]{6}$")
})

test_that("get_party_color with all_colors returns multiple colors", {
  skip_on_cran()
  skip_on_ci_network()

  url <- "https://en.wikipedia.org/wiki/Christian_Democratic_Union_of_Germany"
  result <- get_party_color(url, all_colors = TRUE, use_cache = FALSE)

  expect_type(result, "list")
  expect_length(result, 1)
  # CDU has multiple colors, so we should get a list containing a character vector
  expect_true(is.character(unlist(result[[1]])))
})

# Test for deprecated function
test_that("wikipedia_party_color is deprecated", {
  expect_warning(
    wikipedia_party_color(NA_character_),
    "deprecated"
  )
})
