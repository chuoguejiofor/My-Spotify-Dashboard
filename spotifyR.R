install.packages('spotifyr')
library(spotifyr)
Sys.setenv(SPOTIFY_CLIENT_ID = 'XXXXX')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'XXXXX' )
access_token <- get_spotify_access_token()
obama <- get_user_audio_features('barackobama')

