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
