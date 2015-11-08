# We'll use the XML package to get info from web pages
require(XML)

# Read and parse HTML file
buoylist.html = htmlTreeParse('http://www.ndbc.noaa.gov/to_station.shtml',
                         useInternal = TRUE)
# make a vector of each hyperlink
buoylist.text = unlist(xpathApply(buoylist.html, "//a/@href"))

hrefIndices <- grep("station=", buoylist.text)
buoyNums <- c()
for(i in 1:length(hrefIndices)){
  href <- hrefIndices[i]
  refString <- buoylist.text[href]
  startind <- unlist(gregexpr('=',refString)) + 1
  buoyNums[i] <- substr(refString, startind, startind + 4)
}
buoyNums <- buoyNums[substr(buoyNums, 1,2) %in% c("41", "42", "44")]

lat <- c()
lon <- c()
for(i in 1:length(buoyNums)){
  doc.html = htmlTreeParse(paste('http://www.ndbc.noaa.gov/station_page.php?station=', buoyNums[i], sep=""),
                           useInternal = TRUE)
  doc.text = unlist(xpathApply(doc.html, '//p', xmlValue))
  
  startind1 <- min(unlist(gregexpr(' N ',doc.text[2]))) - 6
  stopind1 <- startind1 + 5
  startind2 <- stopind1 + 4
  stopind2 <- startind2 + 5
  lat[i] <- as.numeric(substr(doc.text[2], startind1, stopind1))
  lon[i] <- as.numeric(substr(doc.text[2], startind2, stopind2))
}

buoyNums <- buoyNums[-which(is.na(lat))]
lat <- lat[-which(is.na(lat))]
lon <- lon[-which(is.na(lon))]


stormYears <- seq(from=2000, to=2015, by=1)
buoyLocsAndYears <- as.data.frame(matrix(nrow=length(buoyNums), ncol=19))
names(buoyLocsAndYears) <- c("BuoyNumber", "Latitude", "Longitude", as.character(stormYears))

for(i in 1:length(buoyNums)){
  historical.html <- htmlTreeParse(paste('http://www.ndbc.noaa.gov/station_history.php?station=', buoyNums[i]),
                                   useInternal = TRUE)
  
  historical.text = unlist(xpathApply(historical.html, '//li', xmlValue))
  
  histString <- historical.text[grep('Historical data', historical.text)]
  endpoints <- unlist(gregexpr('\n', histString))[c(1,2)]
  yearString <- substr(histString, endpoints[1]+2, endpoints[2]-1)
  yearsOfHistData <- as.numeric(unlist(strsplit(yearString, " ")))
  buoyLocsAndYears[i, 4:19] <- stormYears %in% yearsOfHistData
}
buoyLocsAndYears$BuoyNumber <- buoyNums
buoyLocsAndYears$Latitude <- lat
buoyLocsAndYears$Longitude <- -1*lon

# save the data frame as a text file
dput(buoyLocsAndYears, "buoyLocsAndYears.txt")

# If you want to access it again, use this
# dget("buoyLocsAndYears.txt")
