#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(lubridate)
library(leaflet)

shootings <- read.csv(file='Data.csv')

shootings <- shootings[,-(1:4)]
shootings$date <- ymd(shootings$date)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("US Police Shootings"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            p(style="text-align: justify;","The App provides a map representing the data on police shootings from US between 2015 and 2020, 
              you can choose a time period, the state wich it occurred and the individual's race."),
            
            p(style="text-align: justify;",'Try to click on a Marker to see more information.'),
            strong(style="text-align: justify;",'Some markers are centered at the County center, so they may appear to point nowhere.'),
            p(),
            
            sliderInput('sliderdate', 'Select the Date Range', min(shootings$date),
                        max(shootings$date),
                        value= c(min(shootings$date), max(shootings$date))),
            sliderInput('sliderage', 'Select the Age Range', min(shootings$age), 
                        max(shootings$age),
                        value= c(min(shootings$age), max(shootings$age))),
            selectInput('state', 'Select a State', choices = c('All',levels(shootings$state))),
            selectInput('race', 'Select a Race', choices = c('All', levels(shootings$race)))
            ),

        # Show a plot of the generated distribution
        mainPanel(
            leafletOutput('plot')
        )
    )
))