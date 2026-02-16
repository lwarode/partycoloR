## Code to prepare `party_data` dataset
## This script scrapes party colors and logos from Wikipedia
## to create the bundled dataset for fast lookups
##
## Run this script manually to update the bundled data:
##   source("data-raw/update.R")
##
## Note: This takes considerable time due to rate limiting (0.5s per party)
## For ~500 parties: approximately 4-5 minutes

library(dplyr)
library(readr)
library(purrr)

# Load Partyfacts Wikipedia dataset
message("Loading Partyfacts Wikipedia data...")
pf_data <- read_csv(
  "data-raw/wikipedia.csv",
  col_types = cols(
    country = col_character(),
    partyfacts_id = col_double(),
    url = col_character(),
    name_short = col_character(),
    name = col_character(),
    name_native = col_character(),
    year_founded = col_character(),
    year_dissolved = col_character()
  ),
  show_col_types = FALSE
)

message(sprintf("Loaded %d parties from Partyfacts", nrow(pf_data)))

message("Selecting parties to scrape...")

# Select all parties with Wikipedia URLs
selected_parties <- pf_data %>%
  filter(!is.na(url)) %>%
  # Sort by country and name for organized scraping
  arrange(country, name)

message(sprintf("Selected %d parties with Wikipedia URLs from %d countries",
                nrow(selected_parties),
                n_distinct(selected_parties$country)))

# Scrape colors and logos with rate limiting and error handling
message("Starting Wikipedia scraping (this will take 30-40 minutes)...")
message("Rate limit: 0.5 seconds per party")
message("Expected completion time: ~", round(nrow(selected_parties) * 0.5 / 60, 0), " minutes")

party_data_list <- vector("list", nrow(selected_parties))
failed_urls <- character(0)

for (i in seq_len(nrow(selected_parties))) {
  url <- selected_parties$url[i]
  party_name <- selected_parties$name[i]

  if (i %% 50 == 0) {
    message(sprintf("Progress: %d/%d parties scraped (%.1f%%)",
                    i, nrow(selected_parties), 100 * i / nrow(selected_parties)))
  }

  tryCatch({
    # Rate limiting: 0.5 seconds between requests
    if (i > 1) Sys.sleep(0.5)

    # Scrape using existing functions (without cache to force live scraping)
    color <- partycoloR::get_party_color(url)
    all_colors <- partycoloR::get_party_color(url, all_colors = TRUE)
    logo_url <- partycoloR::get_party_logo(url)

    # Only include if we got color data (logo is optional)
    if (!is.na(color)) {
      party_data_list[[i]] <- tibble(
        url = url,
        color = color,
        all_colors = all_colors,
        logo_url = logo_url,
        last_updated = Sys.Date()
      )
    }
  }, error = function(e) {
    message(sprintf("  Error scraping %s: %s", party_name, e$message))
    failed_urls <<- c(failed_urls, url)
  })
}

# Combine into single tibble
party_data <- bind_rows(party_data_list)

# Remove any NULL entries
party_data <- party_data %>%
  filter(!is.na(url))

message(sprintf("\nSuccessfully scraped %d parties", nrow(party_data)))

if (length(failed_urls) > 0) {
  message(sprintf("Failed to scrape %d parties", length(failed_urls)))
}

# Data quality checks
message("\nData quality checks:")
message(sprintf("  - Parties with colors: %d", sum(!is.na(party_data$color))))
message(sprintf("  - Parties with logos: %d", sum(!is.na(party_data$logo_url))))
message(sprintf("  - Unique URLs: %d", n_distinct(party_data$url)))
message(sprintf("  - Duplicate URLs: %d", nrow(party_data) - n_distinct(party_data$url)))

# Check color validity
invalid_colors <- party_data %>%
  filter(!is.na(color) & !grepl("^#[0-9A-F]{6}$", color))

if (nrow(invalid_colors) > 0) {
  warning(sprintf("Found %d invalid color codes!", nrow(invalid_colors)))
  print(invalid_colors)
}

# Save to data/ directory
message("\nSaving bundled data to data/party_data.rda...")
save(party_data, file = "data/party_data.rda", compress = "xz", version = 2)

# Print final statistics
message("\n=== Final Dataset Statistics ===")
message(sprintf("Total parties: %d", nrow(party_data)))
message(sprintf("Countries represented: %d", n_distinct(
  pf_data %>%
    filter(url %in% party_data$url) %>%
    pull(country)
)))

# Print size estimate
size_mb <- file.size("data/party_data.rda") / 1024^2
message(sprintf("Dataset size: %.2f MB", size_mb))

if (size_mb > 5) {
  warning("Dataset exceeds CRAN 5MB limit! Consider reducing number of parties.")
}

message("\n✓ Bundled data created successfully!")
message("  Location: data/party_data.rda")
message(sprintf("  Rows: %d", nrow(party_data)))
message(sprintf("  Columns: %d", ncol(party_data)))
