library(adehabitatHR)
library(rgdal)

occ <- read.csv("Data/Occ_Mfelipei.csv", header = T)

cooridinates(occ) <- ~Lon+Lat
proj4string(occ) <- CRS("+proj=longlat +datum=WGS84 +no_defs ")

mpcMf <- adehabitatHR::mcp(occ, percent = 100)

writeOGR(obj = mpcMf,driver = "ESRI Shapefile",dsn = "shp/M/", layer = "M_mpc")
