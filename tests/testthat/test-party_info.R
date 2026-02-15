test_that("get_party_info validates input", {
  expect_error(get_party_info(123), "`url` must be a character vector")
})

test_that("get_party_info handles NA and invalid URLs", {
  result <- get_party_info(NA_character_)

  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 1)
  expect_true(is.na(result$color[1]))
  expect_true(is.na(result$logo_url[1]))
})

test_that("get_party_info returns correct columns", {
  result <- get_party_info(NA_character_)

  expect_true("url" %in% names(result))
  expect_true("color" %in% names(result))
  expect_true("logo_url" %in% names(result))
})

test_that("get_party_info with all_colors adds column", {
  result <- get_party_info(NA_character_, all_colors = TRUE)

  expect_true("all_colors" %in% names(result))
  expect_type(result$all_colors, "list")
})

test_that("get_party_info handles multiple URLs", {
  urls <- c(NA_character_, NA_character_, NA_character_)
  result <- get_party_info(urls)

  expect_equal(nrow(result), 3)
})

# Integration tests
test_that("get_party_info extracts both color and logo", {
  skip_on_cran()
  skip_on_ci_network()

  url <- "https://en.wikipedia.org/wiki/Democratic_Party_(United_States)"
  result <- get_party_info(url, use_cache = FALSE)

  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 1)
  expect_equal(result$url[1], url)

  # Should have color
  expect_type(result$color, "character")
  expect_match(result$color[1], "^#[0-9A-F]{6}$")

  # Should have logo
  expect_type(result$logo_url, "character")
  expect_match(result$logo_url[1], "^https://")
})

test_that("get_party_info handles multiple URLs efficiently", {
  skip_on_cran()
  skip_on_ci_network()

  urls <- c(
    "https://en.wikipedia.org/wiki/Democratic_Party_(United_States)",
    "https://en.wikipedia.org/wiki/Social_Democratic_Party_of_Germany"
  )
  result <- get_party_info(urls, use_cache = FALSE)

  expect_equal(nrow(result), 2)
  expect_equal(result$url, urls)
})
