## app.R ##
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "My Spotify Dashboard"),
  dashboardSidebar(),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    fluidRow(
      box(plotOutput("plot1", height = 250)),
      
      box(
        title = "Enter username",
        textInput("username", "Username", value="chu23")
      )
    )
  )
)

server <- function(input, output) {
  library(spotifyr)
  access_token <- get_spotify_access_token()
  
  output$plot1 <- renderPlot({
    user <- get_user_audio_features(input$username)
    hist(user$danceability)
  })
}

shinyApp(ui, server)