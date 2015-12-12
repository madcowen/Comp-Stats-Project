library(shiny)
library(ggplot2)
library(ggmap)
require(lubridate)
require(dplyr)

stormsWithBuoyDataMap <- dget("stormsWithBuoyData.txt")
possibleBuoys <- dget("buoyLocationsFixed.txt")

# keep variables we want to use and that are not predominately NAs
stormsWithBuoyDataMap <- stormsWithBuoyDataMap %>% 
  dplyr::select(Latitude, Longitude, time, Wind_WMO, ATMP, WTMP, WVHT)

# find which rows have missing data of the variables we kept
rowLabs <- seq(1:nrow(stormsWithBuoyDataMap))
rowLabs <- rowLabs[rowSums(is.na(stormsWithBuoyDataMap)) > 0]

# take out all the rows with missing data
stormsWithBuoyDataMap <- stormsWithBuoyDataMap[-rowLabs,]

Map <- get_map("florida coast", zoom = 3)

shinyServer(function(input, output) {
  output$map<-renderPlot({
    
    dataToMap <- stormsWithBuoyDataMap %>% filter(year(time) == input$year)
    
    buoysToMap <- possibleBuoys[possibleBuoys[,(paste("year", input$year, sep=""))] == TRUE,]
    
    colorVar <- switch(input$var, 
                       "Wind" = "Wind_WMO",
                       "Air Temp" = "ATMP",
                       "Water Temp" = "WTMP",
                       "Waveheight" = "WVHT")
    
    
    theMap = ggmap(Map) + xlab("Longitude") + ylab("Latitude")
    
    if(colorVar == "Wind_WMO"){
      theMap = theMap + geom_point(aes(x = Longitude, y = Latitude, colour = Wind_WMO), 
                       data = dataToMap) + 
        scale_colour_gradientn(colours=rev(rainbow(4))) 
    } else if(colorVar == "ATMP"){
      theMap = theMap + geom_point(aes(x = Longitude, y = Latitude, colour = ATMP), 
                       data = dataToMap) + 
        scale_colour_gradientn(colours=rev(rainbow(4))) 
    } else if(colorVar == "WTMP"){
      theMap = theMap + geom_point(aes(x = Longitude, y = Latitude, colour = WTMP), 
                       data = dataToMap) + 
        scale_colour_gradientn(colours=rev(rainbow(4)))
    } else if(colorVar == "WVHT"){
      theMap = theMap + geom_point(aes(x = Longitude, y = Latitude, colour = WVHT), 
                       data = dataToMap) + 
        scale_colour_gradientn(colours=rev(rainbow(4)))
    }
    
    if(input$buoy == "Show"){
      theMap = theMap + geom_point(aes(x= Longitude, y= Latitude), data = buoysToMap)
    } else if (input$buoy == "Hide"){
      theMap = theMap
    }
    
    theMap

  })
})