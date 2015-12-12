library(shiny)
library(ggplot2)
library(ggmap)
require(lubridate)
require(dplyr)

stormsWithBuoyDataMap <- dget("stormsWithBuoyData.txt")
possibleBuoys <- dget("buoyLocationsFixed.txt")

# keep variables we want to use and that are not predominately NAs
stormsWithBuoyDataMap <- stormsWithBuoyDataMap %>% 
  dplyr::select(Latitude, Longitude, time, Wind_WMO, ATMP, WTMP, WVHT, WD, APD, DPD, BAR, GST, WSPD)

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
  
    theMap = ggmap(Map) + xlab("Longitude") + ylab("Latitude")
    
    if(input$var == "Wind"){
      theMap = theMap + geom_point(aes(x = Longitude, y = Latitude, colour = Wind_WMO), 
                       data = dataToMap) + 
        scale_colour_gradientn(colours=rev(rainbow(4))) 
    } else if(input$var == "Air Temp"){
      theMap = theMap + geom_point(aes(x = Longitude, y = Latitude, colour = ATMP), 
                       data = dataToMap) + 
        scale_colour_gradientn(colours=rev(rainbow(4))) 
    } else if(input$var == "Water Temp"){
      theMap = theMap + geom_point(aes(x = Longitude, y = Latitude, colour = WTMP), 
                       data = dataToMap) + 
        scale_colour_gradientn(colours=rev(rainbow(4)))
    } else if(input$var == "Waveheight"){
      theMap = theMap + geom_point(aes(x = Longitude, y = Latitude, colour = WVHT), 
                       data = dataToMap) + 
        scale_colour_gradientn(colours=rev(rainbow(4)))
    } else if(input$var == "Wind Direction"){
      theMap = theMap + geom_point(aes(x = Longitude, y = Latitude, colour = WD), 
                                   data = dataToMap) + 
        scale_colour_gradientn(colours=rev(rainbow(4)))
    } else if(input$var == "Wind Speed"){
      theMap = theMap + geom_point(aes(x = Longitude, y = Latitude, colour = WSPD), 
                                   data = dataToMap) + 
        scale_colour_gradientn(colours=rev(rainbow(4)))
    } else if(input$var == "Gust"){
      theMap = theMap + geom_point(aes(x = Longitude, y = Latitude, colour = GST), 
                                   data = dataToMap) + 
        scale_colour_gradientn(colours=rev(rainbow(4)))
    } else if(input$var == "Average Wave Period"){
      theMap = theMap + geom_point(aes(x = Longitude, y = Latitude, colour = APD), 
                                   data = dataToMap) + 
        scale_colour_gradientn(colours=rev(rainbow(4)))
    } else if(input$var == "Dominant Wave Period"){
      theMap = theMap + geom_point(aes(x = Longitude, y = Latitude, colour = DPD), 
                                   data = dataToMap) + 
        scale_colour_gradientn(colours=rev(rainbow(4)))
    } else if(input$var == "Pressure"){
      theMap = theMap + geom_point(aes(x = Longitude, y = Latitude, colour = BAR), 
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