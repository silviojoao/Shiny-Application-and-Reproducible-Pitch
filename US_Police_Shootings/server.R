#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(lubridate)
library(leaflet)
library(dplyr)

shootings <- read.csv(file='Data.csv')
        
shootings <- shootings[,-(1:4)]
shootings$date <- ymd(shootings$date)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    output$sum <- renderPrint({
        summary(shootings[,-c(1,2,13,14,15,16)])
        })
    
    output$dates <- renderUI({
        datemax <- max(shootings$date)
        datemin <- min(shootings$date)
        
    })
    
    output$plot <- renderLeaflet({
        
        ## Date Part
        minDate <- input$sliderdate[1]
        maxDate <- input$sliderdate[2]
        
        Data <- shootings[shootings$date>=minDate & shootings$date<=maxDate,]
        
        ## Age Part
        minAge <- input$sliderage[1]
        maxAge <- input$sliderage[2]
        
        Data <-Data[Data$age>=minAge & Data$age<=maxAge,]
        
        ## State Part
        state <- input$state
        
        if (!state == 'All'){
            Data <- Data[Data$state == state,]
        }
        
        race <- input$race
        
        if(!race == 'All'){
            Data <- Data[Data$race == race,]
        }
        
        ## Plot
        leaflet() %>% addTiles() %>% addMarkers(lat=Data$lat, lng=Data$lng, clusterOptions = markerClusterOptions(),
                                                popup = paste(paste0(Data$name,', ',Data$age), paste('Armed:', Data$armed), 
                                                              paste('Race:', Data$race),paste('Sign of Mental Illness: ', Data$signs_of_mental_illness)
                                                              ,paste0(Data$city,', ',Data$state, ', ',Data$date),sep='<br>'))
        
    })
    
    
    
})
