test_that("lookup_party_url validates input", {
  expect_error(
    lookup_party_url(123),
    "`party_name` must be a single character string"
  )
  expect_error(
    lookup_party_url(c("SPD", "CDU")),
    "`party_name` must be a single character string"
  )
})

test_that("lookup_party_url works with provided data", {
  # Create mock data
  mock_data <- data.frame(
    country = c("DEU", "DEU", "USA"),
    partyfacts_id = c(1, 2, 3),
    url = c("https://en.wikipedia.org/wiki/SPD",
            "https://en.wikipedia.org/wiki/CDU",
            "https://en.wikipedia.org/wiki/Democrats"),
    name_short = c("SPD", "CDU", "Dems"),
    name = c("Social Democratic Party", "Christian Democratic Union", "Democratic Party"),
    name_native = c("Sozialdemokratische Partei Deutschlands", "Christlich Demokratische Union", NA),
    year_founded = c(1863, 1945, 1828),
    year_dissolved = c(NA, NA, NA),
    stringsAsFactors = FALSE
  )

  # Search by short name
  result <- lookup_party_url("SPD", data = mock_data)
  expect_equal(nrow(result), 1)
  expect_equal(result$name_short[1], "SPD")

  # Search by full name
  result <- lookup_party_url("Social Democratic", data = mock_data)
  expect_equal(nrow(result), 1)

  # Search by native name
  result <- lookup_party_url("Sozialdemokratische", data = mock_data)
  expect_equal(nrow(result), 1)

  # Filter by country
  result <- lookup_party_url("Christian", country = "DEU", data = mock_data)
  expect_equal(nrow(result), 1)
  expect_equal(result$country[1], "DEU")

  result <- lookup_party_url("Democratic", country = "USA", data = mock_data)
  expect_equal(nrow(result), 1)
  expect_equal(result$country[1], "USA")

  # No matches
  expect_message(
    result <- lookup_party_url("NonexistentParty", data = mock_data),
    "No parties found"
  )
  expect_equal(nrow(result), 0)
})

test_that("lookup_party_url exact matching works", {
  mock_data <- data.frame(
    country = c("DEU", "DEU"),
    partyfacts_id = c(1, 2),
    url = c("url1", "url2"),
    name_short = c("SPD", "SPD/KPD"),
    name = c("Social Democratic Party", "Social Democratic Party / Communist Party"),
    name_native = c(NA, NA),
    year_founded = c(1863, 1946),
    year_dissolved = c(NA, NA),
    stringsAsFactors = FALSE
  )

  # Partial match returns both
  result <- lookup_party_url("SPD", data = mock_data, exact = FALSE)
  expect_equal(nrow(result), 2)

  # Exact match returns only one
  result <- lookup_party_url("SPD", data = mock_data, exact = TRUE)
  expect_equal(nrow(result), 1)
  expect_equal(result$name_short[1], "SPD")
})

test_that("clear_partycolor_cache clears cache", {
  # Add something to cache
  cache <- get_partycolor_cache()
  cache$test_item <- "test"

  # Clear cache
  clear_partycolor_cache()

  # Check it's empty
  expect_length(ls(cache), 0)
})

# Integration tests
test_that("get_partyfacts_wikipedia downloads data", {
  skip_on_cran()
  skip_on_ci_network()

  # Clear cache first
  clear_partycolor_cache()

  result <- get_partyfacts_wikipedia()

  expect_s3_class(result, "tbl_df")
  expect_true(nrow(result) > 1000)  # Should have thousands of parties
  expect_true("url" %in% names(result))
  expect_true("country" %in% names(result))
  expect_true("name" %in% names(result))
})

test_that("get_partyfacts_wikipedia uses cache",
{
  skip_on_cran()
  skip_on_ci_network()

  # First call should populate cache
  result1 <- get_partyfacts_wikipedia(cache = TRUE)

  # Modify cached data to verify it's being used
  cache <- get_partycolor_cache()
  expect_false(is.null(cache$partyfacts_data))

  # Second call should use cache (same object)
  result2 <- get_partyfacts_wikipedia(cache = TRUE)
  expect_identical(result1, result2)

  # Clear for other tests
  clear_partycolor_cache()
})
