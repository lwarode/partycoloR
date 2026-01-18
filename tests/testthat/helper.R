# Test helpers for partycoloR

# Skip if no internet connection
skip_if_offline <- function() {
  tryCatch(
    {
      con <- url("https://en.wikipedia.org", "r")
      close(con)
    },
    error = function(e) {
      skip("No internet connection")
    }
  )
}

# Skip network tests on CI to avoid flaky builds
# Wikipedia and GitHub may rate-limit or block CI runners
skip_on_ci_network <- function() {
  skip_on_ci()
  skip_if_offline()
}
