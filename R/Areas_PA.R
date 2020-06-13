library(rgeos)
library(dismo)
library(rgeos)
library(rgdal)
library(ggplot2)

####

m3p <- readOGR("shp/PA/M3pa.shp")
m3v <- readOGR("shp/PA/M3Vegpa.shp")

m3b <- readOGR("shp/PA/M3bin.shp")
m3vb <- readOGR("shp/PA/M3Vbin.shp")

pa <- readOGR("shp/PA/WDPA.shp")

####

inter3 <- raster::intersect(m3p, pa)
interV <- raster::intersect(m3v, pa)

####

Areas <- data.frame(ID=c("M3","M3v"),
                    AreaPA=c(sum(raster::area(inter3)),
                             sum(raster::area(interV)))/1000000,
                    PercPA= c((sum(raster::area(inter3))/sum(raster::area(m3b))),
                              (sum(raster::area(interV))/sum(raster::area(m3vb))) )*100,
                    AreaTotal=c(sum(raster::area(m3b))/1000000,
                                sum(raster::area(m3vb))/1000000) )
Areas

write.csv(Areas, "Data/Areas_PA_proj.csv", quote = F, row.names = F)

####

P3A <- c()
PA <- unique(inter3$PA)
Ar <- raster::area(inter3)

for(i in 1:length(PA)){
  n.p <- PA[i]
  ar.s <- sum(Ar[which(inter3$PA%in%n.p)])
  P3A <- c(P3A,ar.s)
}

P3A <- data.frame(PA=PA,
                  Area=P3A/1000000,
                  Contribution= (P3A/sum(raster::area(inter3)))*100 )

P3A <- P3A[order(P3A$Area, decreasing = T),]
P3A

write.csv(P3A, "Data/PA_areas_each_Proj.csv", quote = F, row.names = F)

####

PVA <- c()
PA <- unique(interV$PA)
Ar <- raster::area(interV)

for(i in 1:length(PA)){
  n.p <- PA[i]
  ar.s <- sum(Ar[which(interV$PA%in%n.p)])
  PVA <- c(PVA,ar.s)
}

PVA <- data.frame(PA=PA,
                  Area=PVA/1000000,
                  Contribution= (PVA/sum(raster::area(interV)))*100 )

PVA <- PVA[order(PVA$Area, decreasing = T),]
PVA

write.csv(PVA, "Data/PA_areas_each_Veg.csv", quote = F, row.names = F)
