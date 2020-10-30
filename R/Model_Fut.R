####

library(spocc)
library(spThin)
library(dismo)
library(rgeos)
library(ENMeval)
library(dplyr)
library(rgdal)
library(rJava)
library(maptools)
library(ggplot2)
library(devtools)
library(ENMGadgets)
library(corrplot)
library(ntbox)
library(wallace)
library(usdm)

####

occ <- read.csv("/Data/In_Occ.csv", header = T)

####

Mpol <- readOGR("/shp/Andes_M.shp") %>% gBuffer(width = 2.5)

####

envs <- stack(bio1,bio2,bio3,bio4,bio5,bio6,bio7,bio8,bio9,
              bio10,bio11,bio12,bio13,bio14,bio15,bio16,bio17,bio18,bio19) %>% 
  raster::crop(y = Mpol)  %>% raster::mask(mask = Mpol)
  
####

fut1 <- raster::stack("ssp126/40/wc2.1_2.5m_bioc_MIROC6_ssp126_2021-2040.tif")
fut1 <- fut1 %>% raster::crop(y=Mpol) %>% raster::mask(mask = Mpol)

fut2 <- raster::stack("ssp126/40/wc2.1_2.5m_bioc_CNRM-CM6-1_ssp126_2021-2040.tif")
fut2 <- fut2 %>% raster::crop(y=Mpol) %>% raster::mask(mask = Mpol)

fut3 <- raster::stack("ssp126/40/wc2.1_2.5m_bioc_CanESM5_ssp126_2021-2040.tif")
fut3 <- fut3 %>% raster::crop(y=Mpol) %>% raster::mask(mask = Mpol)

fut4 <- raster::stack("ssp126/40/wc2.1_2.5m_bioc_BCC-CSM2-MR_ssp126_2021-2040.tif")
fut4 <- fut4 %>% raster::crop(y=Mpol) %>% raster::mask(mask = Mpol)

####

load("MaxEnt/M_felipei.rda")

names(e@models) <- e@results$settings

model <- e@models$LQHP_4

names(envs) <- colnames(model@presence)
names(fut1) <- colnames(model@presence)
names(fut2) <- colnames(model@presence)
names(fut3) <- colnames(model@presence)
names(fut4) <- colnames(model@presence)

####

pred <- dismo::predict(model, envs, args="outputformat=logistic")
plot(pred)

proj1 <- dismo::predict(model, fut1, args="outputformat=logistic")
proj2 <- dismo::predict(model, fut2, args="outputformat=logistic")
proj3 <- dismo::predict(model, fut3, args="outputformat=logistic")
proj4 <- dismo::predict(model, fut4, args="outputformat=logistic")

proj <- calc(stack(proj1,proj2,proj3,proj4), median, na.rm=T)

plot(proj)

####

occPredVals <- raster::extract(pred, occ[,c(2,3)])

thr <- thresh(modOccVals = occPredVals, type = "mtp")
thr

pred.bin <- proj>thr
plot(pred.bin)

writeRaster(proj1>thr, "Data/Proj1_126_40_Bin", format="GTiff")
writeRaster(proj2>thr, "Data/Proj2_126_40_Bin", format="GTiff")
writeRaster(proj3>thr, "Data/Proj3_126_40_Bin", format="GTiff")
writeRaster(proj4>thr, "Data/Proj4_126_40_Bin", format="GTiff")

