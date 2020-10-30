library(raster)
library(rgdal)
library(rgeos)
library(dismo)


pred <- raster::raster("Data/LQHP_LOGaAICbin.tif")

#SSP126 - 2040

proj1 <- raster::raster("Data/Proj1_126_40")  
proj2 <- raster::raster("Data/Proj2_126_40")
proj3 <- raster::raster("Data/Proj3_126_40")  
proj4 <- raster::raster("Data/Proj4_126_40")

fut.126.40 <- (pred*5)+proj1+proj2+proj3+proj4


writeRaster(fut.126.40, "Data/Fut_126_40", format="GTiff")


#SSP126 - 2100

proj1 <- raster::raster("Data/Proj1_126_100")  
proj2 <- raster::raster("Data/Proj2_126_100")
proj3 <- raster::raster("Data/Proj3_126_100")  
proj4 <- raster::raster("Data/Proj4_126_100")

fut.126.100 <- (pred*5)+proj1+proj2+proj3+proj4

writeRaster(fut.126.100, "Data/Fut_126_100", format="GTiff")


#SSP585 - 2040

proj1 <- raster::raster("Data/Proj1_585_40")  
proj2 <- raster::raster("Data/Proj2_585_40")
proj3 <- raster::raster("Data/Proj3_585_40")  
proj4 <- raster::raster("Data/Proj4_585_40")

fut.585.40 <- (pred*5)+proj1+proj2+proj3+proj4

writeRaster(fut.585.40, "Data/Fut_585_40", format="GTiff")


#SSP585 - 2100

proj1 <- raster::raster("Data/Proj1_585_100")  
proj2 <- raster::raster("Data/Proj2_585_100")
proj3 <- raster::raster("Data/Proj3_585_100")  
proj4 <- raster::raster("Data/Proj4_585_100")

fut.585.100 <- (pred*5)+proj1+proj2+proj3+proj4

writeRaster(fut.585.100, "Data/Fut_585_100", format="GTiff")
