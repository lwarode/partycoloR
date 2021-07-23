library(hexSticker)
library(partycoloR)
library(dplyr)
library(stringr)
library(tibble)
library(ggplot2)
library(forcats)

# Package Hexagon Sticker -------------------------------------------------

## Sample Data for Visualization ----
party_list_de <- list("https://en.wikipedia.org/wiki/Social_Democratic_Party_of_Germany",
                      "https://en.wikipedia.org/wiki/Christian_Democratic_Union_of_Germany",
                      "https://en.wikipedia.org/wiki/Free_Democratic_Party_(Germany)",
                      "https://en.wikipedia.org/wiki/Christian_Social_Union_in_Bavaria",
                      "https://en.wikipedia.org/wiki/Alliance_90/The_Greens",
                      "https://en.wikipedia.org/wiki/The_Left_(Germany)",
                      "https://en.wikipedia.org/wiki/Alternative_for_Germany")


party_color_df_raw <- wikipedia_party_color(party_list_de)

party_color_df_raw

vote_share_2017 <- c(8.9, 12.6, 26.8, 6.2, 10.7, 20.5, 9.2)

party_color_df <- party_color_df_raw %>%
  mutate(
    color = case_when(
      str_detect(url, "Christian_Democratic_Union") ~ color_2,
      str_detect(url, "The_left") ~ color_2,
      TRUE ~ color_1
    )
  ) %>%
  add_column(vote_share_2017)

color_vec <- party_color_df %>%
  pull(color)

## Sample Plot DE 2017 ----
plot_2017 <- party_color_df %>%
  ggplot(aes(x = fct_reorder(url, - vote_share_2017), y = vote_share_2017, fill = url)) +
  geom_col() +
  theme_classic() +
  theme(aspect.ratio = .5,
        legend.position = "none",
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks.x = element_blank(),
        axis.ticks.y = element_blank()) +
  scale_fill_manual(values = color_vec)

plot_2017

## Sticker Creation
sticker(plot_2017,
        s_x = 1,
        s_y = 1.2,
        s_height = 1.5,
        s_width = 1.5,
        package = "partycoloR",
        p_size = 7.5,
        p_x = 1,
        p_y = 0.7,
        p_color = "#474749",
        h_fill = "white",
        h_color = "#474749",
        # h_color = "#2076B6",
        filename = "partycoloR_sticker.png",
        dpi = 600)
