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

occ <- read.csv("../Data/Occ.csv", header = T)
occs.xy <- occ[,c("Lon","Lat")]

####

Mpol <- readOGR("shp/M/M_mpc.shp") %>% gBuffer(width=2.5)
bgExt <- Mpol

####
#Read all 19 raster files at resolution of 2.5, then create a stack object as follows

envs <- stack(bio1,bio2,bio3,bio4,bio5,bio6,bio7,bio8,bio9,

####

envsBgCrop <- raster::crop(envs, bgExt)
envsBgMsk <- raster::mask(envsBgCrop, bgExt)

bg.xy <- dismo::randomPoints(envsBgMsk, 20000)

bg.xy <- as.data.frame(bg.xy)  

####

rms <- seq(1, 5, .5)

e <- ENMeval::ENMevaluate(occs.xy, envsBgMsk, bg.coords = bg.xy, RMvalues = rms, fc = c('L','LQ','LQH','LQHP'), 
                          method = 'jackknife', clamp = TRUE, algorithm = "maxent.jar")
                          
####

evalMods <- e@models
names(evalMods) <- e@results$settings
evalTbl <- e@results
evalPreds <- e@predictions

####

projPoly <- readOGR("../shp/Andes_M.shp") %>% gBuffer(width = 2.5)
predsProj <- raster::crop(envs, projPoly)
predsProj <- raster::mask(predsProj, projPoly)

####

ENMeval::eval.plot(evalTbl, value = "avg.test.orMTP")
ENMeval::eval.plot(evalTbl, value = "avg.test.or10pct")
ENMeval::eval.plot(evalTbl, value = "AICc")
ENMeval::eval.plot(evalTbl, value = "avg.test.AUC")

####

MTPtable <- evalTbl[which(evalTbl$avg.test.orMTP<0.5),]
MTPtable

AIC <- MTPtable$settings[which(MTPtable$delta.AICc == min(MTPtable$delta.AICc, na.rm=T))]
AIC


####

pred <- dismo::predict(evalMods$LQHP_4, envsBgMsk, args="outputformat=logistic")
plot(pred)

proj <- dismo::predict(evalMods$LQHP_4, predsProj, args="outputformat=logistic")
plot(proj)

####

occPredVals <- raster::extract(proj, occs.xy)

thr <- thresh(modOccVals = occPredVals, type = "mtp")
thr

pred.bin <- proj>thr
plot(pred.bin)

writeRaster(proj, filename = "LQHP_3.5aAIC", format = "GTiff")
writeRaster(pred.bin, filename = "LQHP_3.5aAICbin", format ="GTiff")
