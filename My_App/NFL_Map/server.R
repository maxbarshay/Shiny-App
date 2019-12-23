library(shiny) #downloading the neccesary packages
library(leaflet)
library(tidyverse)

my_data <- read_csv("https://www.dropbox.com/s/p6tua6h9uv4yj02/Real_Data2.csv?dl=1") #reading in the data

shinyServer(function(input, output) {  #heres where I define the server
  
  output$map <- renderLeaflet({ #my first leaflet output
    
    nfl_division_subset <- reactive({ #reactive to make a subset of divisions
      filter(my_data, Division %in% input$nfl_division) #filters the divisions to the specification set in the UI
    })
    
    provider_tile <- reactive({ #this reactive determines which provider tile to use, common in all of my tabs
      req(input$theme)
    })
    
    
    pal <- colorFactor(palette = c("Red", "Green", "Blue", "lightslateblue", "darkgoldenrod1", "Black", "gray48", "Brown"), #here I am defining a color pallete to determine which
                       levels = c("NFC West", "NFC South", "NFC East", "NFC North", "AFC West", "AFC South", "AFC East", "AFC North")) #colors my circle markers will be for each division in the NFl
    
    leaflet(nfl_division_subset(), options =  #this is my leaflet command with the reactive statement in the data slot
              leafletOptions(maxZoom = 17, #I also specified some options on zoom to keep the user focused on what I created
                             minZoom = 2.5)) %>% 
      addProviderTiles(provider_tile()) %>% #this is where the provider tiles are added using the provider_tile reactive
      setView(lng = -97.318332, lat = 38.730409, zoom = 2) %>% #this is what centers the map on the US
      setMaxBounds(lng1 = -150.236335, #these again are to keep my user focused on what I made
                   lat1 = 66.238897, #they are roughly the boundaries of the US, but I gave a little wiggle
                   lng2 = -47.624335, #room so that they wouldn't feel "trapped"
                   lat2 = 13.107207) %>% #up next is my call for circle markers, I am using the ~ operator because I put the data set in the call of leaflet
      addCircleMarkers(color = ~pal(nfl_division_subset()$Division), #I am specifying the color using color = and then my pallete that I created earlier
                       label = paste(nfl_division_subset()$Name, " at ", nfl_division_subset()$Stadium)) %>% #here I am adding a popup marker for the name of the team 
      addLegend(position = "bottomright", #from my reactive subset followed by "at" and then the name of their stadium
                pal = pal, #here I am adding a legend specifying the position and then the pal(colors) to pal, the one I created followed by the values which is a vector of the division names
                values = c("NFC West", "NFC South", "NFC East", "NFC North", "AFC West", "AFC South", "AFC East", "AFC North")) #which match up to the pal
    
  })
  
  output$map2 <- renderLeaflet({ #this is much of the same
    
    provider_tile <- reactive({
      req(input$theme2)
    })
    
    nba_division_subset <- reactive({ #division subsetting
      filter(my_data, Division %in% input$nba_division)
    })
    
    pal <- colorFactor(palette = c("Red", "Green", "Blue", "lightslateblue", "darkgoldenrod1", "Black"), #nba pallete
                       levels = c("East Atlantic", "East Central", "East Southeast", "West Northwest", "West Pacific", "West Southwest"))
    
    leaflet(nba_division_subset(), options =  
              leafletOptions(maxZoom = 17, 
                             minZoom = 2.5)) %>% 
      addProviderTiles(provider_tile()) %>% 
      setView(lng = -97.318332, lat = 38.730409, zoom = 2) %>% 
      setMaxBounds(lng1 = -150.236335, 
                   lat1 = 66.238897,
                   lng2 = -47.624335,
                   lat2 = 13.107207) %>% 
      addCircleMarkers(color = ~pal(nba_division_subset()$Division),
                       label = paste(nba_division_subset()$Name, " at ", nba_division_subset()$Stadium)) %>% 
      addLegend(position = "bottomright",
                pal = pal,
                values = c("East Atlantic", "East Central", "East Southeast", "West Northwest", "West Pacific", "West Southwest"))
  })
  
  output$map3 <- renderLeaflet({
    
    provider_tile <- reactive({
      req(input$theme3)
    })
    
    sport_choice <- reactive({ #this is a reactive that shifts the league we are looking at
      req(input$league)
      filter(my_data, League %in% input$league)
    })
    
    leaflet(sport_choice(), options = #notice I call sport_choice() here
              leafletOptions(maxZoom = 17, 
                             minZoom = 2.5)) %>% 
      addProviderTiles(provider_tile()) %>% 
      setView(lng = -97.318332, lat = 38.730409, zoom = 2) %>% 
      setMaxBounds(lng1 = -150.236335, 
                   lat1 = 66.238897,
                   lng2 = -47.624335, #now I am just adding regular circles using their coordinates, weight is how dark the outsides are 
                   lat2 = 13.107207) %>% #and I am aking the radius depend on how many championships they have won
      addCircles(lng = ~Lon, lat = ~Lat, weight = 1, radius = ~Champ_Wins * 14000, popup = ~paste(Name, " with ", Champ_Wins, " Championship Wins"))
  }) #I also add a popup to say the name of the team and how many championships they have won
  
  output$map4 <- renderLeaflet({
    
    provider_tile <- reactive({
      req(input$theme4)
    })
    
    total_ship <- my_data %>% #here I am creating a new data set that groups both leagues by city
      select(City, Champ_Wins) %>% 
      group_by(City) %>% 
      summarize( #I use summarize to add up the total wins the cities have across leagues
        Total_Champs_Won = sum(Champ_Wins)
      )
    
    ship_and_coord <- left_join(total_ship, my_data, by = "City") #here I join my new set with my original to get the coordinates back
    
    ship_and_coord <- ship_and_coord %>%  #this ensures we do not have repeats of the same city
      distinct(City, .keep_all = TRUE)
    
    leaflet(ship_and_coord, options = leafletOptions(maxZoom = 15, minZoom = 2.5)) %>%
      addProviderTiles(provider_tile()) %>%
      setView(lng = -97.318332, lat = 38.730409, zoom = 3) %>% 
      setMaxBounds(lng1 = -140.236335, 
                   lat1 = 56.238897,
                   lng2 = -57.624335,
                   lat2 = 23.107207) %>% #here I am adding circles in a similar way but using the square root of metro_pop for aesthetic reasons
      addCircles(lng = ~Lon, lat = ~Lat, weight = 1, radius = ~sqrt(Metro_Pop) * 50, popup = ~paste(City, " with ", Total_Champs_Won, " Total Championships Won"))
  }) #I also added an informative popup
})


