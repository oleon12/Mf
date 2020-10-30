# R-scripts

***

1. **MCP.R:** Create a Minimum Convex Polygon using the initial occurrences
2. **Model.R:** Build and evaluate the MaxEnt model for the 'present-day' variables 
3. **Model_Fut.R:** Project the MaxEnt model into future climate conditions
4. **Areas_Fut.R:** Calculate the loss, gain and stable areas of the projected future climate conditions
5. **Areas_PAs.R:** Calculate the area of the potential distribution that are within the protected areas

***

Many scripts use the  WorldClim v2 (2.5') bioclimate variables, so, if you want to use these scripts, you must go to the website of [WorldClim](https://www.worldclim.org/data/worldclim21.html) and download the 19 variables. Then, load them into the scripts as follows:


```{r}
bio1 <- raster::raster("wc2.1_2.5m_bio_1.tif")
bio2 <- raster::raster("wc2.1_2.5m_bio_2.tif")
bio3 <- raster::raster("wc2.1_2.5m_bio_3.tif")
...
...
...
bio18 <- raster::raster("wc2.1_2.5m_bio_18.tif")
bio19 <- raster::raster("wc2.1_2.5m_bio_19.tif")
```
