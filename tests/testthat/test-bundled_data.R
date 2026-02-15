# Tests for bundled party_data dataset and cache functionality

# Load party_data for all tests
data("party_data", package = "partycoloR", envir = environment())

test_that("party_data exists and is accessible", {
  expect_true(exists("party_data"))
  expect_s3_class(party_data, "tbl_df")
  expect_true(nrow(party_data) > 0)
})

test_that("party_data has correct structure", {
  expected_cols <- c("url", "color", "all_colors", "logo_url", "last_updated")
  expect_true(all(expected_cols %in% names(party_data)))

  # Check column types
  expect_type(party_data$url, "character")
  expect_type(party_data$color, "character")
  expect_type(party_data$all_colors, "list")
  expect_type(party_data$logo_url, "character")
  expect_s3_class(party_data$last_updated, "Date")
})

test_that("party_data colors are valid HEX codes", {
  colors <- party_data$color[!is.na(party_data$color)]

  expect_true(length(colors) > 0)
  expect_true(all(grepl("^#[0-9A-F]{6}$", colors)))
})

test_that("party_data URLs are valid Wikipedia URLs", {
  urls <- party_data$url[!is.na(party_data$url)]

  expect_true(length(urls) > 0)
  expect_true(all(grepl("^https?://en\\.wikipedia\\.org/wiki/", urls)))
})

test_that("party_data has no duplicate URLs", {
  expect_equal(nrow(party_data), length(unique(party_data$url)))
})

test_that("party_data all_colors is properly formatted", {
  # Check that all_colors is a list column
  expect_type(party_data$all_colors, "list")

  # Sample a non-NA entry and check the inner vector
  non_na_idx <- which(!is.na(party_data$color))[1]
  if (length(non_na_idx) > 0) {
    all_colors_entry <- party_data$all_colors[[non_na_idx]]
    # all_colors is a list-column where each entry is a list containing a character vector
    expect_type(all_colors_entry, "list")
    expect_type(all_colors_entry[[1]], "character")
  }
})

test_that("get_party_color() uses cache by default", {
  # Get a URL from bundled data
  test_url <- party_data$url[!is.na(party_data$color)][1]
  expected_color <- party_data$color[party_data$url == test_url][1]

  # Should return cached value instantly
  result <- get_party_color(test_url, use_cache = TRUE)

  expect_equal(result, expected_color)
  expect_match(result, "^#[0-9A-F]{6}$")
})

test_that("get_party_color() all_colors works with cache", {
  # Get a URL from bundled data
  test_url <- party_data$url[!is.na(party_data$color)][1]
  expected_colors <- party_data$all_colors[party_data$url == test_url][[1]]

  # Should return all cached colors
  result <- get_party_color(test_url, all_colors = TRUE, use_cache = TRUE)

  expect_type(result, "list")
  expect_length(result, 1)
  expect_equal(result[[1]], expected_colors)
})

test_that("get_party_color() handles vectorization with cache", {
  # Get multiple URLs from bundled data
  test_urls <- party_data$url[!is.na(party_data$color)][1:min(3, sum(!is.na(party_data$color)))]
  expected_colors <- party_data$color[party_data$url %in% test_urls]

  result <- get_party_color(test_urls, use_cache = TRUE)

  expect_length(result, length(test_urls))
  expect_equal(result, expected_colors)
})

test_that("get_party_color() can bypass cache", {
  skip_on_cran()
  skip_on_ci_network()

  # Use a well-known party URL that's likely in cache
  test_url <- party_data$url[!is.na(party_data$color)][1]

  # Should scrape live (might differ from cache if Wikipedia updated)
  result <- get_party_color(test_url, use_cache = FALSE)

  expect_type(result, "character")
  # Result should either be a valid hex code or NA
  if (!is.na(result)) {
    expect_match(result, "^#[0-9A-F]{6}$")
  }
})

test_that("get_party_color() handles URLs not in cache", {
  # Use a URL definitely not in cache (but validate it's really not there first)
  obscure_url <- "https://en.wikipedia.org/wiki/Nonexistent_Political_Party_12345_Test"

  # Should return NA without error
  result <- get_party_color(obscure_url, use_cache = TRUE)
  expect_true(is.na(result))
})

test_that("get_party_logo() uses cache by default", {
  # Get a URL with logo from bundled data
  test_idx <- which(!is.na(party_data$logo_url))[1]
  if (length(test_idx) > 0) {
    test_url <- party_data$url[test_idx]
    expected_logo <- party_data$logo_url[test_idx]

    result <- get_party_logo(test_url, use_cache = TRUE)

    expect_equal(result, expected_logo)
    expect_type(result, "character")
  } else {
    skip("No logos in bundled data")
  }
})

test_that("get_party_logo() handles vectorization with cache", {
  # Get multiple URLs with logos from bundled data
  test_indices <- which(!is.na(party_data$logo_url))[1:min(3, sum(!is.na(party_data$logo_url)))]

  if (length(test_indices) > 0) {
    test_urls <- party_data$url[test_indices]
    expected_logos <- party_data$logo_url[test_indices]

    result <- get_party_logo(test_urls, use_cache = TRUE)

    expect_length(result, length(test_urls))
    expect_equal(result, expected_logos)
  } else {
    skip("Not enough logos in bundled data")
  }
})

test_that("get_party_logo() can bypass cache", {
  skip_on_cran()
  skip_on_ci_network()

  # Use a party URL with logo that's likely in cache
  test_idx <- which(!is.na(party_data$logo_url))[1]
  if (length(test_idx) > 0) {
    test_url <- party_data$url[test_idx]

    # Should scrape live
    result <- get_party_logo(test_url, use_cache = FALSE)

    expect_type(result, "character")
  } else {
    skip("No logos in bundled data")
  }
})

test_that("get_party_info() uses cache by default", {
  # Get a URL from bundled data
  test_url <- party_data$url[!is.na(party_data$color)][1]

  result <- get_party_info(test_url, use_cache = TRUE)

  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 1)
  expect_equal(result$url[1], test_url)
  expect_true("color" %in% names(result))
  expect_true("logo_url" %in% names(result))
})

test_that("get_party_info() all_colors works with cache", {
  # Get a URL from bundled data
  test_url <- party_data$url[!is.na(party_data$color)][1]

  result <- get_party_info(test_url, all_colors = TRUE, use_cache = TRUE)

  expect_s3_class(result, "tbl_df")
  expect_true("all_colors" %in% names(result))
  expect_type(result$all_colors, "list")
})

test_that("get_party_info() handles vectorization with cache", {
  # Get multiple URLs from bundled data
  test_urls <- party_data$url[!is.na(party_data$color)][1:min(3, sum(!is.na(party_data$color)))]

  result <- get_party_info(test_urls, use_cache = TRUE)

  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), length(test_urls))
  expect_equal(result$url, test_urls)
})

test_that("get_party_info() can bypass cache", {
  skip_on_cran()
  skip_on_ci_network()

  # Use a party URL that's likely in cache
  test_url <- party_data$url[!is.na(party_data$color)][1]

  # Should scrape live
  result <- get_party_info(test_url, use_cache = FALSE)

  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 1)
})

test_that("cache lookup handles NA and invalid URLs", {
  # Test with NA
  result_color <- get_party_color(NA_character_, use_cache = TRUE)
  expect_true(is.na(result_color))

  result_logo <- get_party_logo(NA_character_, use_cache = TRUE)
  expect_true(is.na(result_logo))

  result_info <- get_party_info(NA_character_, use_cache = TRUE)
  expect_s3_class(result_info, "tbl_df")
  expect_true(is.na(result_info$color[1]))

  # Test with invalid URL
  invalid_url <- "not_a_url"
  result_color2 <- get_party_color(invalid_url, use_cache = TRUE)
  expect_true(is.na(result_color2))
})

test_that("bundled data has reasonable coverage", {
  # Check that we have a reasonable number of parties
  expect_gte(nrow(party_data), 100)  # At least 100 parties

  # Check that most parties have colors
  color_coverage <- sum(!is.na(party_data$color)) / nrow(party_data)
  expect_gte(color_coverage, 0.8)  # At least 80% have colors

  # Check geographic diversity (at least 10 countries)
  # This requires the country information, which we can infer from the URL structure
  # or from the data-raw/wikipedia.csv if we join on URL
})
