test_that("is_wikipedia_url validates URLs correctly", {
  # Valid URLs
  expect_true(is_wikipedia_url("https://en.wikipedia.org/wiki/Democratic_Party_(United_States)"))
  expect_true(is_wikipedia_url("https://wikipedia.org/wiki/Some_Party"))
  expect_true(is_wikipedia_url("http://en.wikipedia.org/wiki/Some_Party"))

  # Invalid URLs
  expect_false(is_wikipedia_url("https://google.com"))
  expect_false(is_wikipedia_url("not_a_url"))
  expect_false(is_wikipedia_url(NA))
  expect_false(is_wikipedia_url(NULL))
  expect_false(is_wikipedia_url(123))
  expect_false(is_wikipedia_url(""))
})

test_that("normalize_hex_color normalizes colors correctly", {
  # Valid 6-digit hex codes
  expect_equal(normalize_hex_color("#ff0000"), "#FF0000")
  expect_equal(normalize_hex_color("#0066CC"), "#0066CC")

  # 3-digit hex codes should expand

  expect_equal(normalize_hex_color("#f00"), "#FF0000")
  expect_equal(normalize_hex_color("#abc"), "#AABBCC")

  # Named colors
  expect_equal(normalize_hex_color("red"), "#FF0000")
  expect_equal(normalize_hex_color("blue"), "#0000FF")
  expect_equal(normalize_hex_color("white"), "#FFFFFF")

  # Invalid inputs
  expect_true(is.na(normalize_hex_color(NA)))
  expect_true(is.na(normalize_hex_color("")))
  expect_true(is.na(normalize_hex_color(NULL)))
  expect_true(is.na(normalize_hex_color("not_a_color_xyz")))

  # Whitespace handling
  expect_equal(normalize_hex_color("  #ff0000  "), "#FF0000")
})
