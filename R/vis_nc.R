#' Visualize NETCDF file
#'
#' Visualize a single time slice of a NETCDF object.
#' If you want to project correctly, use OSMscale as in the example below.
#' (\url{https://github.com/brry/OSMscale#intro}).
#'
#' @return \code{\link{colPoints}} list output
#' @author Berry Boessenkool, \email{berry-b@@gmx.de}, Feb 2017
#' @seealso \code{\link{read_nc}},
#'          \code{\link{vis_nc_all}} and \code{\link{vis_nc_film}} for several time slices,
#'          \code{\link{get_ncPoint}}, \code{\link{colPoints}}
#' @keywords hplot
#' @importFrom RColorBrewer brewer.pal
#' @importFrom berryFunctions colPoints owa
#' @importFrom pbapply pbapply
#' @export
#' @examples
#' # to be added
#'
#' \dontrun{ # too time consuming for CRAN checks
#' # install.packages("OSMscale)
#' library(OSMscale)
#' map <- pointsMap(nc$lat, nc$lon)
#' pp <- projectPoints(as.vector(nc$lat), as.vector(nc$lon), to=posm())
#' plot(map); scaleBar(map)
#' vis_nc(nc, x=pp$x, y=pp$y, add=TRUE)
#' }
#'
#' @param nc      nc object from \code{\link{read_nc}}
#' @param index   Integer: a single time slice number to be plotted.
#'                To plot several slices, use \code{\link{vis_nc_all}}. DEFAULT: 1
#' @param x,y,z   x,y,z Coordinates. DEFAULT: nc elements lon, lat, var (@@ time index)
#' @param apply   Function to be applied to aggregate time in nc$var, e.g. mean or median.
#'                If given, index and z are ignored! Should take na.rm as argument. DEFAULT: NA
#' @param zlab    Legend title. DEFAULT: varname time
#' @param add     Logical: add to existing plot? DEFAULT: FALSE
#' @param pch,cex Point character and character expansion (symbol size). DEFAULT: 15, 1.25
#' @param col     Color palette. DEFAULT: \code{berryFunctions::\link[berryFunctions]{seqPal}}
#'                using colors from \code{RColorBrewer::\link[RColorBrewer]{brewer.pal}(9, "OrRd")}
#' @param bg.leg,cex.leg Background and character size for legend. DEFAULT: NA, 1
#' @param legargs List of further arguments passed to legend (
#'                \code{berryFunctions::\link[berryFunctions]{colPointsLegend}})
#' @param \dots   Further arguments passed to
#'                \code{berryFunctions::\link[berryFunctions]{colPoints}}
#'
vis_nc <- function(
 nc,
 index=1,
 x=as.vector(nc$lon),
 y=as.vector(nc$lat),
 z=as.vector(nc$var[,,index]),
 apply=NA,
 zlab=paste(nc$varname, nc$time[index]),
 add=FALSE,
 pch=15,
 cex=1.25,
 col=seqPal(100, colors=RColorBrewer::brewer.pal(9, "OrRd")),
 bg.leg=NA,
 cex.leg=1,
 legargs=NULL,
 ...
)
{
check_list_elements(nc, "time", "lat", "lon", "var", "varname", "file", "cdf")
 #force(zlab)
 if(!suppressWarnings(is.na(apply)) )
   {
   if(missing(zlab)) zlab <- paste(nc$varname, substitute(apply))
   z <- as.vector(pbapply(nc$var, 1:2, apply, na.rm=TRUE))
   }
 colPoints(x=x,y=y,z=z, add=add, col=col, xlab="", ylab="", zlab=zlab,
           pch=pch, cex=cex, legargs=owa(list(bg=bg.leg,cex=cex.leg),legargs), ...)
}
