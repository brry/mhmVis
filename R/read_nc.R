#' Read NETCDF file
#' 
#' Read NETCDF file and extract time, location and a variable from it.
#' 
#' @return List with time, lat, lon, var, varname, file, cdf (result of
#' \code{ncdf4::\link[ncdf4]{nc_open}}, from which the previous elements are extracted.)
#' @section Warning: This has not yet been tested on many nc files! Please report any errors.
#' @author Berry Boessenkool, \email{berry-b@@gmx.de}, Feb 2017
#' @seealso \code{\link{vis_nc}}, \code{\link{get_ncPoint}}
#' @keywords list spatial file
#' @importFrom ncdf4 nc_open ncvar_get
#' @importFrom berryFunctions removeSpace
#' @export
#' @examples
#' # to be added
#' 
#' @param file  Name of nc file. May include relative or absolute path.
#'              DEFAULT: \code{\link{file.choose}()}
#' @param var   Name of variable to extract, interactive choice if \code{var} not
#'              available and there are more than 1 variables in the file. DEFAULT: ""
#' @param lat,lon Name of latitude and longitude variables. DEFAULT: "lat","lon"
#' @param \dots Further arguments passed to \code{ncdf4::\link[ncdf4]{nc_open}},
#'              like verbose=TRUE
#' 
read_nc <- function(
file=file.choose(),
var="",
lat="lat",
lon="lon",
...
)
{
mycdf <- ncdf4::nc_open(file, ...)
unit <- mycdf$dim$time$units
if(is.null(unit))
 {
 message("Time could not be read from cdf file and is set to 1.")
 time <- 1
 } else
if(substr(unit,1,4)=="days")
 {
 start <- sub("days since", "", unit)
 start <- strsplit(removeSpace(start), " ")[[1]][1]
 start <- as.Date(start)
 time <- start + ncdf4::ncvar_get(mycdf,'time')
 } else
 {
 start <- removeSpace(sub("hours since", "", unit))
 start <- strptime(start, format="%F %T")
 time <- start + ncdf4::ncvar_get(mycdf,'time')*3600
 }
# select one of the possible variable names if not given:
varnames <- names(mycdf$var)
while(! var %in% varnames)
{
 pos <- varnames[!varnames %in% c("lat2D","lon2D","lon","lat")]
 if(length(pos)==1) var <- pos else
 var <- readline(paste0("Which variable do you want? (",toString(pos),"): "))
}
# Select latitude and longitude variables:
lat <- "lat"
lon <- "lon"
while(! lat %in% varnames)
{
 if("lat2D" %in% varnames) var <- "lat2D" else
 lat <- readline(paste0("Which latitude variable do you want? (",toString(varnames),"): "))
}
while(! lon %in% varnames)
{
 if("lon2D" %in% varnames) var <- "lon2D" else
 lon <- readline(paste0("Which longitude variable do you want? (",toString(varnames),"): "))
}
message("nc file has been read. Now extracting ", toString(c(lat,lon,var)), ". This may take a minute.")
strt <- Sys.time()
# Actually extract the desired variables:
LAT <- ncdf4::ncvar_get(mycdf, lat)
LON <- ncdf4::ncvar_get(mycdf, lon)
VAR <- ncdf4::ncvar_get(mycdf, var)  # may take quite some time to actually load into memory
d <- difftime(Sys.time(), strt)
message("I'm done! (took ", round(d,2), " ", attr(d,"units"),")")
# output:
return(invisible(list(time=time, lat=LAT, lon=LON, var=VAR, varname=var, file=mycdf$filename, cdf=mycdf)))
}


if(FALSE){# generate random field nc object

n <- 50; nt=30 # number of cells in x and y direction, number of time steps
xy <- expand.grid(1:n, 1:n) ; names(xy) <- c('x','y')
StartVal <- rep(0,n^2)  ; StartVal[3/4*(n^2+n)] <- 1
xyz <- spate::spate.sim(par=c(rho0=0.05, sigma2=0.7^2, zeta=-log(0.99), rho1=0.06,
                            gamma=3 ,alpha=pi/4, muX=-0.05, muY=-0.1, tau2=0.00001),
                        n=n, T=nt+1, StartVal=StartVal, seed=1)$xi[-1,]
#spate::spate.plot(xyz)
xyz <- round((xyz-min(xyz))*10)
# for(i in 1:nrow(xyz)) colPoints(xy$x, xy$y, xyz[i,], add=F, pch=15, Range=range(xyz), main=i)
xyz <- t(xyz)  ;  dim(xyz) <- c(n,n,nt)
#
random_nc <- list(
time = strptime("2017-02-21 13:00:00", format="%F %T")+(1:nrow(xyz))*3600,
lon = matrix(xy$x, ncol=n),
lat = matrix(xy$y, ncol=n),
var = xyz,
varname = "random_field",
file = "spate_spate.sim",
cdf = "This is a list in real read_nc results")
rm(n,nt,xy,StartVal,xyz)


vis_nc_film(random_nc, cex=2.8, y2=0.95, asp=1, test=FALSE, ff=ffberry)


#library(SpatioTemporal) ##simulate.STmodel
# http://santiago.begueria.es/2010/10/generating-spatially-correlated-random-fields-with-r/
#library(gstat)
#xyz <- predict(gstat(formula=z~1, locations=~x+y, dummy=T, beta=1,
#                 model=vgm(psill=0.025, range=5, model='Exp'), nmax=20), newdata=xy, nsim=1)
#colPoints(x,y,sim1, data=xyz, add=FALSE, pch=15)

}
