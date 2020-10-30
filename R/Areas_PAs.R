##########################
#     Load libraries     #
##########################

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


########################
#      Load data       #
########################

setwd("/hdd/Mustela proyecto/calcular_areas/")

m3bin <- readOGR("MaxEnt/Elevation3/PA/M3bin.shp")
m3bin <- m3bin[which(m3bin$MTP_30r>0),]
#save(m3bin,file="MaxEnt/Elevation3/PA/m3bin.rda")
load("MaxEnt/Elevation3/PA/m3bin.rda")

m3ele <- readOGR("MaxEnt/Elevation3/PA/M3ele.shp")
m3ele <- m3ele[which(m3ele$el_M_30>0),]
#save(m3ele,file="MaxEnt/Elevation3/PA/m3ele.rda")
load("MaxEnt/Elevation3/PA/m3ele.rda")

m3veg <- readOGR("MaxEnt/Elevation3/PA/M3veg.shp")
m3veg <- m3veg[which(m3veg$E__TC_M>0),]
#save(m3veg,file="MaxEnt/Elevation3/PA/m3veg.rda")
load("MaxEnt/Elevation3/PA/m3veg.rda")

m3binv <- readOGR("MaxEnt/Elevation3/PA/M3binv.shp")
m3binv <- m3binv[which(m3binv$tr_M_30>0),]
#save(m3binv,file="MaxEnt/Elevation3/PA/m3binv.rda")
load("MaxEnt/Elevation3/PA/m3binv.rda")

m3binp <- readOGR("MaxEnt/Elevation3/PA/MbinPA.shp")
m3binp <- m3binp[which(m3binp$Class==1),]
#save(m3binp,file="MaxEnt/Elevation3/PA/m3binp.rda")
load("MaxEnt/Elevation3/PA/m3binp.rda")

m3elep <- readOGR("MaxEnt/Elevation3/PA/M3elePA.shp")
m3elep <- m3elep[which(m3elep$Class>0),]
#save(m3elep,file="MaxEnt/Elevation3/PA/m3elep.rda")
load("MaxEnt/Elevation3/PA/m3elep.rda")

m3vegp <- readOGR("MaxEnt/Elevation3/PA/M3elePA.shp") 
m3vegp <- m3vegp[which(m3vegp$Class>0),]
#save(m3vegp,file="MaxEnt/Elevation3/PA/m3vegp.rda")
load("MaxEnt/Elevation3/PA/m3vegp.rda")

m3binvp <- readOGR("MaxEnt/Elevation3/PA/M3binvPA.shp")
m3binvp <- m3binvp[which(m3binvp$Class>0),]
#save(m3binvp,file="MaxEnt/Elevation3/PA/m3binvp.rda")
load("MaxEnt/Elevation3/PA/m3binvp.rda")

pa <- readOGR("shp/WDPA.shp")

##########################

interBin <- raster::intersect(m3binp, pa)
interEle <- raster::intersect(m3elep, pa)
interVeg <- raster::intersect(m3vegp,pa)
interBinv <- raster::intersect(m3binvp,pa)

plot(interBin)

###########################

Areas <- data.frame(ID=c("Bin","Ele","Ele+Tc","Bin+Tc"),
                    AreaPA=c(sum(raster::area(interBin)),
                             sum(raster::area(interEle)),
                             sum(raster::area(interVeg)),
                             sum(raster::area(interBinv)))/1000000,
                    PercPA= c((sum(raster::area(interBin))/sum(raster::area(m3bin))),
                              (sum(raster::area(interEle))/sum(raster::area(m3ele))),
                              (sum(raster::area(interVeg))/sum(raster::area(m3veg))),
                              (sum(raster::area(interBinv))/sum(raster::area(m3binv))))*100,
                    AreaTotal=c(sum(raster::area(m3bin))/1000000,
                                sum(raster::area(m3ele))/1000000,
                                sum(raster::area(m3veg))/1000000,
                                sum(raster::area(m3binv))/1000000) )

Areas



#mean(Areas$AreaPA);mean(Areas$AreaTotal)
#mean(Areas$AreaPA)/mean(Areas$AreaTotal)*100

write.csv(Areas, "Data/Areas_PA_proj_Hystrix.csv", quote = F, row.names = F)

################################################################

P3A <- c()
PA <- unique(interBin$PA)
Ar <- raster::area(interBin)

for(i in 1:length(PA)){
  n.p <- PA[i]
  ar.s <- sum(Ar[which(interBin$PA%in%n.p)])
  P3A <- c(P3A,ar.s)
}

P3A <- data.frame(PA=PA,
                  Area=P3A/1000000,
                  Contribution= (P3A/sum(raster::area(interBin)))*100 )

P3A <- P3A[order(P3A$Area, decreasing = T),]
P3A

write.csv(P3A, "Data/PA_areas_each_MTP_Hystrix.csv", quote = F, row.names = F)
  
################################################

PVA <- c()
PA <- unique(interBinv$PA)
Ar <- raster::area(interBinv)

for(i in 1:length(PA)){
  n.p <- PA[i]
  ar.s <- sum(Ar[which(interBinv$PA%in%n.p)])
  PVA <- c(PVA,ar.s)
}

PVA <- data.frame(PA=PA,
                  Area=PVA/1000000,
                  Contribution= (PVA/sum(raster::area(interBinv)))*100 )

PVA <- PVA[order(PVA$Area, decreasing = T),]
PVA

write.csv(PVA, "Data/PA_areas_each_MTPVeg_Hystrix.csv", quote = F, row.names = F)
  
################################################

PTA <- c()
PA <- unique(interEle$PA)
Ar <- raster::area(interEle)

for(i in 1:length(PA)){
  n.p <- PA[i]
  ar.s <- sum(Ar[which(interEle$PA%in%n.p)])
  PTA <- c(PTA,ar.s)
}

PTA <- data.frame(PA=PA,
                  Area=PTA/1000000,
                  Contribution= (PTA/sum(raster::area(interEle)))*100 )

PTA <- PTA[order(PTA$Area, decreasing = T),]
PTA

write.csv(PTA, "Data/PA_areas_each_MTPEle_Hystrix.csv", quote = F, row.names = F)

################################################

PTA <- c()
PA <- unique(interVeg$PA)
Ar <- raster::area(interVeg)

for(i in 1:length(PA)){
  n.p <- PA[i]
  ar.s <- sum(Ar[which(interVeg$PA%in%n.p)])
  PTA <- c(PTA,ar.s)
}

PTA <- data.frame(PA=PA,
                  Area=PTA/1000000,
                  Contribution= (PTA/sum(raster::area(interVeg)))*100 )

PTA <- PTA[order(PTA$Area, decreasing = T),]
PTA

write.csv(PTA, "Data/PA_areas_each_MTPEleVeg_Hystrix.csv", quote = F, row.names = F)
