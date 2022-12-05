library(spotifyr)
library(tidyverse)
library(cld2)
library(openai)

top_trakcs <- get_my_top_artists_or_tracks(type = "tracks", limit = 50)


top_trakcs <- top_trakcs %>% 
    mutate(lang = map(name, detect_language)) %>% 
    filter(lang == "en") %>% 
    mutate(is_ok = map(name, .f = function(x) create_moderation(x)$results$flagged))

top_trakcs %>%
    select(name, lang, is_ok) %>% 
    View()

prompt <- str_c(top_trakcs$name, collapse = " ")

if (!create_moderation(prompt)$results$flagged)
    image <- create_image(prompt)

