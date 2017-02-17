#' Visualize NETCDF file
#'
#' Visualize NETCDF object
#'
#' @return \code{\link{colPoints}} list output
#' @author Berry Boessenkool, \email{berry-b@@gmx.de}, Feb 2017
#' @seealso \code{\link{read_nc}}, \code{\link{colPoints}}
#' @keywords hplot
#' @importFrom RColorBrewer brewer.pal
#' @importFrom berryFunctions colPoints
#' @export
#' @examples
#' # to be added
#'
#' @param nc      nc object from \code{\link{read_nc}}
#' @param vals    Subset of \code{nc$var}iable values to be plotted.
#'                DEFAULT: first slice over time.
#' @param zlab    Legend title. DEFAULT: deparse(substitute(vals))
#' @param add     Logical: add to existing plot? DEFAULT: FALSE
#' @param pch,cex Point character and character expansion (symbol size). DEFAULT: 15, 1.25
#' @param col     Color palette. DEFAULT: \code{berryFunctions::\link[berryFunctions]{seqPal}}
#'                using colors from \code{RColorBrewer::\link[RColorBrewer]{brewer.pal}(9, "OrRd")}
#' @param x,y,z   x,y,z Coordinates. DEFAULT: nc elements lon and lat, \code{vals}
#' @param legargs List of arguments passed to
#'                \code{berryFunctions::\link[berryFunctions]{colPointsLegend}}
#' @param \dots   Further arguments passed to
#'                \code{berryFunctions::\link[berryFunctions]{colPoints}}
#'
vis_nc <- function(
 nc,
 vals=nc$var[,,1],
 zlab=deparse(substitute(vals)),
 add=FALSE,
 pch=15,
 cex=1.25,
 col=seqPal(100, colors=RColorBrewer::brewer.pal(9, "OrRd")),
 x=as.vector(nc$lon),
 y=as.vector(nc$lat),
 z=as.vector(vals),
 legargs=list(bg=NA),
 ...
)
{
 #force(zlab)
 colPoints(x=x,y=y,z=z, add=add, col=col, xlab="", ylab="", zlab=zlab,
           pch=pch, cex=cex, legargs=legargs, ...)
}
