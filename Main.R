# improvements
# . Fix mins_played not working
# . Add song option:
# 1. make select()'s column-agnostic with negative logic
# 2. figure out how to pass different columns to arrange()' - though to be fair this would make 1. redundant. 
# . SOLOS
  # . Fix Upper/Lower case variant issues (solos) 
  # . Fix ROSÉ's name breaking

# load setup
source("setup.R")

# to inspect data
data_clean <- extract_data("~/Music/Spotify data/22-12-2025")

cfg <- list(
  # --- data sourcing ---
  root_dir = "~/Music/Spotify data",
  data_date = "latest",
  # --- data parameters ---
  mins_played = 0.5, # !!! this doesn't work so I bypassed it, check why // play length cutoff for considering streams
  filter_by = c("kpop"), # c("") if no filter. Available options: kpop
  smoothen = TRUE, # even out data over time to reduce 'glitchiness'
  smooth_factor = 3, # number of days before and after to smoothen data over (if: smoothen = TRUE)
  # --- calculation parameters ---
  unit = "streams", # options: streams, mins
  window = "rolling",  # options: cumulative, rolling
  window_days = 90, # length of window in days (if window = 'rolling')
  share = TRUE # abs if FALSE, % of total if TRUE
)

create_spotigeek()
