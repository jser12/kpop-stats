create_spotigeek <- function() {
  
  # identify data directory
  data_dir <- if(cfg$data_date == "latest") {
    get_latest(cfg$root_dir)
  } else if (!is.na(as.Date(cfg$data_date, format = "%d-%m-%Y"))) {
    file.path(cfg$root_dir, cfg$data_date)
  } else {
    stop("data_date must be 'latest' or a valid DD-MM-YYYY string (e.g. '25-12-2025')")
  }
  
  # extract and tidy the data
  base_data <- extract_data(data_dir)
  
  # --- apply filter(s) ---
  # [k-pop]
  if("kpop" %in% cfg$filter_by) {
    base_data <- base_data %>%
      filter(artist %in% dict_kpop)
  }
  # [k-pop solos]
  if("solos" %in% cfg$filter_by) {
    base_data <- filter_solos(base_data, exclude = c("J", # "problematic" name
                                                     "ORION", # name of DnB artist
                                                     "LIZ")) # name of a non K-pop artist
  }
  
  # calculate daily data ('streams' or 'mins') and apply smoothing if enabled)
  daily_data <- calculate_daily_data(base_data)
  
  # calculate window data ('cumulative' or 'rolling')
  window_data <- calculate_window_data(daily_data)
  
  # add group col if solos
  if("solos" %in% cfg$filter_by) {
    window_data <- add_groupcol(window_data)
  }
  
  # identify available logos
  available_logos <- list.files("logos", pattern = "\\.png$", recursive = TRUE) %>% 
    basename() %>% 
    tools::file_path_sans_ext()
  
  folder_logos <- if ("solos" %in% cfg$filter_by) {
    "https://github.com/jser12/kpop-stats/blob/main/logos/members/"
  } else {
    "https://github.com/jser12/kpop-stats/blob/main/logos/"
  }
  
  #  prepare Flourish format 
  window_data_wide <- window_data %>% 
    arrange(date) %>%
    mutate(logo = ifelse(artist %in% available_logos, paste0(folder_logos, URLencode(artist), ".png?raw=true"), "")) %>% # URLencode() deals with percent-encoding (%20) characters
    pivot_wider(names_from = date, values_from = value_window) %>% 
    arrange(desc(pick(last_col())))
  
  ## ---- write file ----
  # build file name
  filters <- cfg$filter_by[nzchar(cfg$filter_by)]
  
  label_days <- if(cfg$window == "rolling") {cfg$window_days} else {""}
  label_smooth <- if(cfg$smoothen == TRUE) {"sm"} else {""}
  label_filters <- if(length(filters) == 0) {"all"} else {paste(sort(filters), collapse = "+")}
  label_share <- if(cfg$share) {"share"} else {"abs"}
  fname <- paste0(paste("spotigeek", label_filters, cfg$window, label_days, cfg$unit, label_share, label_smooth, sep = "_"), "_", format(Sys.time(), "%H%M%S"), ".csv")
  fpath <- file.path("output", fname)
  
  # write output file
  write_csv(window_data_wide, fpath)
}

extract_data <- function(data_dir) {
  
  zip_file <- file.path(data_dir, "my_spotify_data.zip")
  datafiles_dir <- file.path(data_dir, "Spotify Extended Streaming History")
  
  # unzip files
  unzip(zip_file, exdir = data_dir)
  
  files_json <- list.files(datafiles_dir, recursive = FALSE, full.names = TRUE, pattern = "\\.json")
  files_json <- files_json[grepl("Audio", files_json)]
  
  all_data <- data.frame()
  
  for(file in files_json) {
    data <- fromJSON(file, flatten = TRUE)
    all_data <- all_data %>% 
      rbind(data)
  }
  
  data_clean <- all_data %>%
    mutate(
      ts = ymd_hms(ts),
      date = as.Date(ts),
      time = format(ts, "%H:%M:%S"),
      ms_played = round(ms_played / 1000 / 60, digits = 2),
      master_metadata_album_artist_name = recode(master_metadata_album_artist_name, !!!dict_artist)
    ) %>% 
    rename(
      track = master_metadata_track_name,
      artist = master_metadata_album_artist_name,
      album = master_metadata_album_album_name,
      mins_played = ms_played,
      country = conn_country
    ) %>%
    filter(
      is.na(episode_name),
      mins_played >= 0.5
    ) %>% 
    select(-c(ip_addr, ts, spotify_track_uri, offline_timestamp, incognito_mode, matches("(audiobook|episode)")))
  
  return(data_clean)
  
}

calculate_daily_data <- function(data) {
  
  # sum daily streams per artist
  daily_data <- data %>% 
    group_by(artist, date) %>%
    summarise(value_day = case_when(
        cfg$unit == "streams" ~ n(),
        cfg$unit == "mins" ~ sum(mins_played),
        TRUE ~ NA_real_
    ), .groups = "drop"
    ) %>% 
    # complete time series (replace missing data with 0)
    complete(artist, date = seq(min(date), max(date), by = "day"), fill = list(value_day = 0)) %>%  # fill in missing days
    arrange(artist, date)
    
  # apply smoothing
  if(cfg$smoothen) {
    daily_data <- daily_data %>%
      arrange(artist, date) %>%
      group_by(artist) %>%
      mutate(value_day = slider::slide_dbl(value_day, mean, .before = cfg$smooth_factor, .after = cfg$smooth_factor, complete = FALSE)) %>%
      ungroup()
  }
  return(daily_data)
}  

calculate_window_data <- function(data) {
  window_data <- data %>%
    group_by(artist) %>%
    arrange(date, .by_group = TRUE) %>%
    mutate(
      value_window = if (cfg$window == "cumulative") {
        cumsum(value_day)
      } else if (cfg$window == "rolling") {
        slider::slide_dbl(value_day, sum,
                          .before = cfg$window_days - 1,
                          .complete = FALSE)
      } else {
        stop("cfg$window must be 'cumulative' or 'rolling'")
      }
    ) %>%
    ungroup() %>%
    select(date, artist, value_window)
  
  if(cfg$share) {
    # calculate total rolling streams (as separate df)  
    data_calc_tot <- data %>% 
      group_by(date) %>% 
      summarise(day_total = sum(value_day), .groups = "drop") %>% 
      arrange(date) %>% 
      mutate(
        value_tot = if (cfg$window == "cumulative") {
          cumsum(day_total)
        } else if (cfg$window == "rolling") {
          slider::slide_dbl(day_total, sum,
                            .before = cfg$window_days - 1,
                            .complete = FALSE)
        } else {
          stop("cfg$window must be 'cumulative' or 'rolling'")
        }
      ) %>% 
      select(-day_total)
    
    # bind total rolling streams and calculate % rolling streams per artist
    window_data <- window_data %>% 
      left_join(data_calc_tot, by = "date") %>%
      mutate(value_window = ifelse(value_tot > 0, round(value_window / value_tot * 100, digits = 1), NA_real_)) %>% 
      select(date, artist, value_window)
  }
  return(window_data)
}

get_latest <- function(path) {
  data_folders <- list.dirs(path, recursive = FALSE, full.names = TRUE)
  data_dates <- as.Date(basename(data_folders), format = "%d-%m-%Y")
  latest_folder <- data_folders[which.max(data_dates)]
  
  return(latest_folder)
}

filter_solos <- function(data, exclude) {
  # exclude soloists with "problematic" names
  exclude <- toupper(exclude)
  
  gg_soloists <- dict_kpop_gg %>% 
    unlist(use.names = FALSE) %>% 
    toupper() %>% 
    setdiff(exclude)
  
  # pattern: 1/ "(", "-", "&", or "," 2/ an optional space 3/ member name 4/ word boundary (start/end of word, "()", ","). Covers:
  # Mine (CHAERYEONG) -> "("
  # BLUE - WINTER Solo -> "-"
  # TALK (NAYEON, JIHYO) -> ","
  # Woke Up In Tokyo (RUKA & ASA) -> "&"
  pattern_solo <- regex(paste0("[\\(\\-,&]\\s*(", paste(gg_soloists, collapse = "|"), ")(?=\\s|\\)|,|$)"))
  
  # extract member name from solo tracks under the group artist name (e.g. Mine (CHAERYEONG) - ITZY) if only ONE member is included
  data_gg_solos <- data %>%
    mutate(artist = ifelse(str_count(track, pattern_solo) == 1, toupper(str_match(track, pattern_solo)[, 2]), artist))
  
  # filter base dataset by soloists
  data_gg_solos <- data_gg_solos %>% 
    filter(artist %in% gg_soloists)
  
  return(data_gg_solos)
}

add_groupcol <- function(data) {
  member_lookup <- dict_kpop_gg %>% 
    enframe(name = "group", value = "artist") %>% 
    unnest(artist) %>% 
    mutate(artist = toupper(artist))
  
  # filter base dataset by soloists
  data_gg_solos <- data %>% 
    left_join(member_lookup, by = "artist")
  
  return(data_gg_solos)
}
# ------------------------------------------------------------------------------
# deprecated
calculate_cum <- function(data) {
  cum_streams <- data %>%
    arrange(date, artist) %>%
    group_by(artist) %>%
    mutate(value_window = cumsum(value_day)) %>%
    ungroup() %>% 
    select(date, artist, value_window)
  
  return(cum_streams)
}

# deprecated
calculate_roll_pct <- function(data) {
  # calculate rolling streams per artist
  roll_streams_artist <- data %>%
    group_by(artist) %>% 
    arrange(date) %>%
    # slider::slide_dbl 
    mutate(roll_streams = slide_dbl(value_day, sum, .before = cfg$avg_days - 1, .complete = FALSE)) %>% 
    ungroup() 
  
  # calculate total rolling streams (as separate df)  
  roll_streams_tot <- data %>% 
    group_by(date) %>% 
    summarise(day_total = sum(value_day)) %>% 
    ungroup() %>% 
    arrange(date) %>% 
    mutate(roll_streams_tot = slide_dbl(day_total, sum, .before = cfg$avg_days - 1, .complete = FALSE)) %>% 
    select(-day_total)
  
  # bind total rolling streams and calculate % rolling streams per artist
  roll_streams_pct <- roll_streams_artist %>% 
    left_join(roll_streams_tot, by = "date") %>%
    mutate(value_window = round(roll_streams / roll_streams_tot * 100, digits = 1)) %>% 
    select(date, artist, value_window)
  
  return(roll_streams_pct)
}