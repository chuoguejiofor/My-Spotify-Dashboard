## app.R ##
library(shinydashboard)
library(shinycssloaders)

ui <- dashboardPage(
  dashboardHeader(title = "My Spotify Dashboard"),
  dashboardSidebar(),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    fluidRow(
      box(
        title = "Enter Username",
        textInput("username", "Username", value="chu23"),
        submitButton(text = "Submit")
      ),
      
      box(
        title = "Favorite Artists",
        withSpinner(plotOutput("plot1", height = 300))
      )
    ),
    fluidRow(
      box(
        title="Favorite Albums",
        withSpinner(plotOutput("plot2", height = 300))
      ),
      box(
        title="Other Stats",
        withSpinner(htmlOutput("textStats"))
      )
    )
  )
)

server <- function(input, output) {
  library(spotifyr)
  library(dplyr)
  library(ggplot2)
  
  #Sys.setenv(SPOTIFY_CLIENT_ID = 'XXXX')
  #Sys.setenv(SPOTIFY_CLIENT_SECRET = 'XXXX')
  
  output$plot1 <- renderPlot({
    user <- get_user_audio_features(input$username)
    top_artists <- user %>% group_by(artist_name) %>% summarise(count = n()) %>% arrange(desc(count))
    g <- ggplot(head(top_artists), aes(artist_name, count))
    g + geom_bar(stat='identity') + theme(axis.text.x=element_text(angle=50, hjust=1))
  })
  
  output$plot2 <- renderPlot({
    user <- get_user_audio_features(input$username)
    top_albums <- user %>% group_by(album_name, album_img) %>% summarise(count = n()) %>% arrange(desc(count))
    g <- ggplot(head(top_albums), aes(album_name, count))
    g + geom_bar(stat='identity') + theme(axis.text.x=element_text(angle=50, hjust=1))
  })
  
  output$textStats <- renderUI({
    user <- get_user_audio_features(input$username)
    keys <- user %>% group_by(key_mode) %>% summarise(count = n()) %>% arrange(desc(count))
    favorite_key <- sprintf("Favorite Key: %s", keys$key_mode[1])
    
    avg_length   <- sprintf("Average Length: %s seconds", mean(user$duration_ms)/1000 )
    HTML(paste(favorite_key, avg_length, sep="<br/>"))
  })
}

shinyApp(ui, server)