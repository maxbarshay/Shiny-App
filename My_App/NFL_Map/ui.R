library(shiny) #downloading all the necessary packages
library(leaflet)
library(tidyverse)

my_data <- read_csv("https://www.dropbox.com/s/p6tua6h9uv4yj02/Real_Data2.csv?dl=1") #reading in the data

navbarPage(title = "Sports and Maps", #this is where I designate the page design
           
tabPanel("NFL", #this is my first tab panel
    sidebarLayout( #here I specift they layout
      sidebarPanel(
        checkboxGroupInput(inputId = "nfl_division", #this is my first slider
                    label = "Which Football Division to Display?:",
                    choices = c("NFC West", "NFC South", "NFC East", "NFC North", "AFC West", "AFC South", "AFC East", "AFC North"),
                    selected = "NFC West"),
        selectInput(inputId = "theme", #this slider I have on every single tab
                    label = "Which Map Theme do you Want?",
                    choices = c("OpenStreetMap.Mapnik", "Esri.WorldImagery", "Esri.NatGeoWorldMap", "Stamen.Watercolor"),
                    selected = "OpenStreetMap.Mapnik"),
        
        hr(), #this is an aesthetic line break
        helpText("These are NFL Teams. Hover over to see Team Name and their Stadium") #this is text explaining what is going on in the tab
      ),
      
      mainPanel(
        leafletOutput(outputId = "map") #here is where I am sending the output to be used in the server section
      )
    )
),
tabPanel("NBA", #this is my second tab panel
    sidebarLayout(
      sidebarPanel(
        checkboxGroupInput(inputId = "nba_division", #this is my first second checkbox input, this time for nba
                    label = "Which Basketball Division to Display?:",
                    choices = c("East Atlantic", "East Central", "East Southeast", "West Northwest", "West Pacific", "West Southwest"),
                    selected = "East Atlantic"), 
        selectInput(inputId = "theme2",
                    label = "Which Map Theme do you Want?",
                    choices = c("OpenStreetMap.Mapnik", "Esri.WorldImagery", "Esri.NatGeoWorldMap", "Stamen.Watercolor"),
                    selected = "OpenStreetMap.Mapnik"),
        hr(),
        helpText("These are NBA Teams. Hover over to see Team Name and their Stadium") 
      ),
      
      mainPanel(
        leafletOutput(outputId = "map2") #output to be used in server
      )
    )
),
tabPanel("Circle Championship Exploration", #title
    sidebarLayout(
      sidebarPanel(
        selectInput(inputId = "league", #this switches the data from nfl and nba team, only one can be selected at a time 
                    label = "Which League do you want to look at?:",
                    choices = c("NFL", "NBA"),
                    selected = "NFL"), 
        selectInput(inputId = "theme3",
                    label = "Which Map Theme do you Want?",
                    choices = c("OpenStreetMap.Mapnik", "Esri.WorldImagery", "Esri.NatGeoWorldMap", "Stamen.Watercolor"),
                    selected = "OpenStreetMap.Mapnik"),
        hr(), #line break and explanation of aspects of the tab
        helpText("These circle sizes are based on how many Championships this team has won, with information on how many Championships that team has won in the given league when clicked on")
      ),
      
      mainPanel(
        leafletOutput(outputId = "map3") #output to server
      )
    )
),
tabPanel("Popluation Circles", #this is my last tab
    sidebarLayout(
      sidebarPanel(
        selectInput(inputId = "theme4", #notice that this is the only user input for this one
                    label = "Which Map Theme do you Want?",
                    choices = c("OpenStreetMap.Mapnik", "Esri.WorldImagery", "Esri.NatGeoWorldMap", "Stamen.Watercolor"),
                    selected = "OpenStreetMap.Mapnik"),
        hr(), #read this explanation carefully, this one uses one thing for sizing and another for the popup
        helpText("The circle sizes are based on metropolitan population, with information on that cities total Championships won across leagues, when clicked on")
      ),
      
      mainPanel(
        leafletOutput(outputId = "map4") #last output to the server
      )
    )
)
)


