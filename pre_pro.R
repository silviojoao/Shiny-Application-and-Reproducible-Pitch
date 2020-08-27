a <- read.csv('shootings.csv')
b <- read.csv('uscities.csv')
c <- read.table('Countys.txt', sep=';', header = TRUE)

c$COUNTYNAME <- paste(c$COUNTYNAME,'County')

a <- a[!is.na(a$lat),]

library(leaflet)
my_map <- leaflet() %>% addTiles() %>% addMarkers(lat=a$lat, lng=a$lng, clusterOptions = markerClusterOptions())
my_map

a$lat <- NA
a$lng <- NA

library(doParallel) 
cl <- makeCluster(detectCores(), type='PSOCK')
registerDoParallel(cl)

for (j in 1:nrow(a)){
      for (i in 1:nrow(c)){
            if (a$city[j] == c$COUNTYNAME[i] & a$state[j] == c$STATE[i]){
                  a$lat[j] <- c$LAT[i]
                  a$lng[j] <- c$LON[i]
            }
      }
}

registerDoSEQ()

