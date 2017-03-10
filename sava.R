
# Sava catchment: Test Basin in mHM

map <- pointsMap(lat=c(43,49), long=c(12,17), zoom=6, proj=pll(), pch=NA)
dem <- read_dem("sava/input/morph", proj=3035)

par(mar=rep(0,4))
plot(map, removeMargin=FALSE) ; scaleBar(map)
vis_dem(dem, add=TRUE, bg="transparent", prop=0.985, legargs=c(x2=0.95), cex=0.2)

Q <- vis_discharge("sava/output/daily_discharge.out")
seasonality(Q$days, Q$qout$Qobs_0000000045, plot=1:5)


vis_asc("sava/input/morph/soil_class.asc")
vis_asc("sava/input/morph/soil_class.asc.bak")


read_nc("sava/output/mHM_Fluxes_States.nc")


#pet <- read_nc("sava/input/meteo/pet/pet.nc") # only locally, not in github
#pre <- read_nc("sava/input/meteo/pre/pre.nc")
tem <- read_nc("sava/input/meteo/tavg/tavg.nc")


seldate <- function(x, min, max) which(x>as.Date(min) & x< as.Date(max))

vis_nc_film(tem, xlim=c(13.5,15.2), ylim=c(45.3,46.8), cex=7.8, y1=0.8, y2=0.94,
            test=FALSE, width=500, height=500, cex.axis=2, cex.leg=2, asp=1.45,
            index=seldate(tem$time,"2000-07-01","2001-03-03"), ffmpeg=ffberry,
            quiet=TRUE)
