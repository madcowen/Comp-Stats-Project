library(shiny)

shinyUI(fluidPage(
  titlePanel("Storms Data"),

    sidebarLayout(
    sidebarPanel(
      helpText("Colored points indicate storms with variable 
               info obtained from buoys within 500 km of the storm. 
               Black points indicate buoys. 
               The gradient gives the intensity of the selected variable."),
      
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = c("Wind", "Air Temp",
                              "Water Temp", "Waveheight", "Wind Direction",
                              "Wind Speed", "Gust", "Average Wave Period", 
                              "Dominant Wave Period", "Pressure"),
                  selected = "Wind"),
      
      sliderInput("year", 
                  "Choose a year to display",
                  min = 2000,
                  max = 2014,
                  value = 2009,
                  ticks = FALSE,
                  step = 1, 
                  sep ="",
                  animate = animationOptions(interval = 2000)),
      
      selectInput("buoy", 
                  label = "Display Buoys",
                  choices = c("Show", "Hide"),
                  selected = "Hide")

      ),
    
    mainPanel(plotOutput("map"))
  )
))