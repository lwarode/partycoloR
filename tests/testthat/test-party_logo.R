test_that("get_party_logo validates input", {
  expect_error(get_party_logo(123), "`url` must be a character vector")
  expect_error(get_party_logo(list("url")), "`url` must be a character vector")
})

test_that("get_party_logo handles NA and invalid URLs", {
  # NA input
  expect_true(is.na(get_party_logo(NA_character_)))

  # Invalid URL (not Wikipedia)
  expect_true(is.na(get_party_logo("https://google.com")))

  # Empty string
  expect_true(is.na(get_party_logo("")))
})

test_that("get_party_logo returns character vector", {
  result <- get_party_logo(NA_character_)
  expect_type(result, "character")
  expect_length(result, 1)
})

test_that("get_party_logo is vectorized", {
  urls <- c(NA_character_, NA_character_)
  result <- get_party_logo(urls)
  expect_length(result, 2)
  expect_true(all(is.na(result)))
})

# Integration tests that require network access
test_that("get_party_logo extracts logo from Wikipedia", {
  skip_on_cran()
  skip_on_ci_network()

  url <- "https://en.wikipedia.org/wiki/Democratic_Party_(United_States)"
  result <- get_party_logo(url)

  expect_type(result, "character")
  expect_length(result, 1)
  # Should be a URL pointing to an image
  expect_match(result, "^https://")
})

test_that("get_party_logo handles multiple URLs", {
  skip_on_cran()
  skip_on_ci_network()

  urls <- c(
    "https://en.wikipedia.org/wiki/Democratic_Party_(United_States)",
    "https://en.wikipedia.org/wiki/Republican_Party_(United_States)"
  )
  result <- get_party_logo(urls)

  expect_type(result, "character")
  expect_length(result, 2)
})

test_that("download_party_logo handles missing URL", {
  expect_warning(
    result <- download_party_logo(NA, "test.png"),
    "No logo URL provided"
  )
  expect_false(result)
})

test_that("download_party_logo respects overwrite parameter", {
  skip_on_cran()

  # Create a temporary file
  tmp_file <- tempfile(fileext = ".txt")
  writeLines("test", tmp_file)

  # Should warn when file exists and overwrite = FALSE
  expect_warning(
    result <- download_party_logo("https://example.com/img.png", tmp_file, overwrite = FALSE),
    "File already exists"
  )
  expect_false(result)

  # Clean up
  unlink(tmp_file)
})
