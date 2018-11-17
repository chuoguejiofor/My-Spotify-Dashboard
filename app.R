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
        title = "Enter username",
        textInput("username", "Username", value="chu23"),
        submitButton(text = "Submit")
      ),
      
      box(
        title = "Favorite Artists",
        withSpinner(plotOutput("plot1", height = 250))
      )
    )
  )
)

server <- function(input, output) {
  library(spotifyr)
  library(dplyr)
  library(ggplot2)
  access_token <- get_spotify_access_token()

  output$plot1 <- renderPlot({
    user <- get_user_audio_features(input$username)
    top_artists <- user %>% group_by(artist_name) %>% summarise(count = n()) %>% arrange(desc(count))
    g <- ggplot(head(top_artists), aes(artist_name, count))
    g + geom_bar(stat='identity') + theme(axis.text.x=element_text(angle=50, hjust=1))
  })
}

shinyApp(ui, server)