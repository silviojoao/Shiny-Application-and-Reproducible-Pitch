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
    titlePanel("US Police Fatal Shootings"),

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
            tabsetPanel(type='tabs',
                    tabPanel('Plot', br(), leafletOutput('plot')),
                    tabPanel('Documentation', br(), 
                             h1('About the Project'),
                             p(style="text-align: justify;",'This project is for Developing Data Products course wich is
                               part of Data Science Specialization in Coursera. In the recent killings,
                               a hot topic came into being, "Racism". So I chose to gather some data
                               to take out some insights and analyze the story around racism in US in a
                               more "geographic way".'),
                             p('The application include the following:'),

                             p(strong('1.'), 'Input Data describe below;'),
                             p(strong('2.'), 'Operations on the ui input in sever.R;'),
                             p(strong('3.'), 'Reactive output plot displayed as a result of server calculations;'),
                             p(strong('4.'), 'Documentation so that a novice user could use your application.'),
                             p("So you can choose a time period, the state wich it occurred, the individual's race and
                               the Leaflet maps will display a marker in the city or county center where the event occourred."),
                             h1('The Data'),
                             p(style='text-align: justify;',' The data is available in', a(href='https://github.com/washingtonpost/data-police-shootings',
                                                                                           'Washington Post Repo'), 'where you find more details about the
                               variables. The geographic including latitude and longitude information was extracted from', a(href='https://simplemaps.com/data/us-cities',
                                                                                                                 'Simple Maps Database'),
                               'comparing the cities in both datasets it was possible add the lat/long variable in the original dataset,
                               the R script used is available on my', a(href='https://github.com/silviojoao/Shiny-Application-and-Reproducible-Pitch', 'Developing Data Application Repo'),
                               "Let's take a look at a summary of our data:"),
                             verbatimTextOutput('sum')
                             
                             )
            )
        )
    )
))