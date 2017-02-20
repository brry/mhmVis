#' Read NETCDF file
#'
#' Read NETCDF file and extract time, location and a variable from it.
#'
#' @return List with time, lat, lon, var, varname, file, cdf (result of
#' \code{ncdf4::\link[ncdf4]{nc_open}}, from which the previous elements are extracted.)
#' @section Warning: This has not yet been tested on many nc files! Please report any errors.
#' @author Berry Boessenkool, \email{berry-b@@gmx.de}, Feb 2017
#' @seealso \code{\link{vis_nc}}, \code{\link{get_ncPoint}}
#' @keywords list spatial
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
#' @param latvar,lonvar Name of latitude and longitude variables. DEFAULT: "lat","lon"
#' @param \dots Further arguments passed to \code{ncdf4::\link[ncdf4]{nc_open}},
#'              like verbose=TRUE
#'
read_nc <- function(
file=file.choose(),
var="",
latvar="lat",
lonvar="lon",
...
)
{
mycdf <- ncdf4::nc_open(file, ...)
unit <- mycdf$dim$time$units
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
latvar <- "lat"
lonvar <- "lon"
while(! latvar %in% varnames)
{
 if("lat2D" %in% varnames) var <- "lat2D" else
 latvar <- readline(paste0("Which latitude variable do you want? (",toString(varnames),"): "))
}
while(! lonvar %in% varnames)
{
 if("lon2D" %in% varnames) var <- "lon2D" else
 lonvar <- readline(paste0("Which longitude variable do you want? (",toString(varnames),"): "))
}
# Actually extract the desired variables:
lat <- ncdf4::ncvar_get(mycdf, latvar)
lon <- ncdf4::ncvar_get(mycdf, lonvar)
VAR <- ncdf4::ncvar_get(mycdf,    var)  # may take quite some to actually load into memory
# output:
return(invisible(list(time=time, lat=lat, lon=lon, var=VAR, varname=var, file=mycdf$filename, cdf=mycdf)))
}
