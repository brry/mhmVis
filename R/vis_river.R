#' Visialize DEM river as lines (not raster)
#'
#' Convert flow accumulation raster to line segments and plot it.
#' This enables much faster drawing, making it suitable e.g. for drawing small
#' maps with the river added on top in the corner of plots, e.g. with
#' \code{berryFunctions::\link{smallPlot}} as in the example.
#'
#' @return \code{\link{colPoints}} list with segment coordinates
#' @author Berry Boessenkool, \email{berry-b@@gmx.de}, Mar 2017
#' @seealso \code{\link{vis_dem}}, \code{\link{read_dem}}
#' @keywords aplot
#' @importFrom stats quantile
#' @importFrom berryFunctions rescale
#' @export
#' @examples
#' # To be added
#'
#' facc <- read_asc("U:/mHM_shared/basel_6935051/input/morph/facc.asc", proj=3035)
#' op <- par(no.readonly=TRUE)
#' vis_asc(facc, png=FALSE)
#' riv <- vis_river(facc)
#' par(op)
#'
#' library(berryFunctions)
#' logHist(facc$asc*(facc$cellsize/1000)^2, breaks=30) # km^2
#'
#' # Add rivers as small plot
#' \dontrun{ ## Not run in CRAN checks to avoid downloading background map
#' library(OSMscale)
#' map <- pointsMap(lat=riv$y, lon=riv$x, zoom=7, proj=pll(), plot=F)
#' par(mar=c(0,0,0,0))
#' plot(map, removeMargin=FALSE)
#' vis_river(facc, add=TRUE, lwd=1:3)
#'
#' par(op)
#' plot(cumsum(rnorm(300)), type="l") # some gauge properties, e.g.
#' smallPlot({
#'         plot(map, removeMargin=FALSE)
#'         vis_river(facc, add=TRUE, lwd=1:3, legend=FALSE)
#'         points(8, 47.55, col="red", pch=3, lwd=3, cex=2)
#'         }, x1=0, x2=0.4, y1=0.77, y2=1, mar=0, border=NA, bg=NA)
#'
#' } # end dontrun
#'
#' @param facc  List returned by \code{\link{read_asc}} or character string
#'              giving facc.asc filename (passed to read_asc).
#' @param proj  projection passed to \code{\link{read_asc}}. DEFAULT: NA
#' @param prop  Proportion of catchment areas (of each raster cell)
#'              beyond which a channel counts as river. DEFAULT: 0.98
#' @param zlab  Legend title. DEFAULT: "Catchment area  [1000 km^2]"
#' @param lwd   Line width range. CURRENTLY MAPPED TO POINT SIZE!! DEFAULT: 1:3
#' @param add   Logical: add to existing plot? DEFAULT: FALSE
#' @param \dots Further arguments passed to \code{\link{colPoints}} except for lines.
#'
vis_river <- function(
 facc,
 proj=NA,
 prop=0.98,
 zlab="Catchment area  [1000 km^2]",
 lwd=1:3,
 add=FALSE,
 ...)
{
# read file if facc is not an appropriate list:
if(!is.list(facc)) facc <- read_asc(facc,proj)
# check list elements:
elems <- c("asc","x","y","file","name","proj")
isin <-  elems %in% names(facc)
if(!all(isin)) stop("facc does not contain ", toString(elems[!isin]))
# extract river coordinates:
sel <- which(facc$asc > quantile(facc$asc, prop, na.rm=TRUE))
x <- facc$x[sel]
y <- facc$y[sel]
z <- facc$asc[sel]
z <- z*(facc$cellsize/1000)^2 # km^2
output <- colPoints(x,y,z/1000, add=add, zlab=zlab, lines=FALSE,
                    cex=rescale(z,min(lwd/2),max(lwd/2)), ...)
# output:
return(invisible(c(list(minfacc=min(z)), output)))
}


if(FALSE){
# development stuff


facc$asc <- replace(facc$asc, facc$asc<riv$minfacc, NA)
write_asc(facc)
# raster to polylines
library(rgdal)


facc <- read_asc("U:/mHM_shared/lobith_6435060/input/morph/facc.asc", proj=3035)
vis_river(facc)


}

