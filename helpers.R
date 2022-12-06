clean_top_tracks <- function(.top_tracks) {
    
    .top_tracks <- .top_tracks %>%
        mutate(lang = map(name, detect_language)) %>% 
        filter(lang == "en") %>% 
        mutate(
            is_ok = map(
                .x = name,
                .f = function(x) create_moderation(x)$results$flagged
            )
        )
    
    str_c(.top_tracks$name, collapse = " ")
    
}

