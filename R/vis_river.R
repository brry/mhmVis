#' Visialize DEM river as lines (not raster)
#' 
#' Convert flow accumulation raster to line segments and plot it.
#' This enables much faster drawing, making it suitable e.g. for drawing small
#' maps with the river added on top in the corner of plots, e.g. with
#' \code{berryFunctions::\link{smallPlot}} as in the example.
#' 
#' @return data.frame with segment indices
#' @author Berry Boessenkool, \email{berry-b@@gmx.de}, Mar 2017
#' @seealso \code{\link{vis_dem}}, \code{\link{read_dem}}
#' @keywords aplot
#' @importFrom stats quantile
#' @importFrom berryFunctions colPointsLegend owa
#' @importFrom utils read.table
#' @export
#' @examples
#' # To be added
#' 
#' if(FALSE){
#' dem <- read_dem("U:/mHM_shared/basel_6935051/input/morph", proj=3035)
#' op <- par(no.readonly=TRUE)
#' vis_dem(dem, png=FALSE)
#' riv <- vis_river(dem)
#' par(op)
#' ca <- riverlines(dem, riv, col="orange")
#' # for large catchments, computing is time consuming, so plotting can be outsourced
#' 
#' library(berryFunctions)
#' logHist(dem$facc*(facc$cellsize/1000)^2, breaks=30) # km^2
#' }
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
#' @param dem   List returned by \code{\link{read_dem}} or character string
#'              giving a directory (passed to read_dem).
#' @param proj  Projection passed to \code{\link{read_asc}}. DEFAULT: NA
#' @param prop  Proportion of catchment areas (of each raster cell)
#'              beyond which a channel counts as river. Lower values mean longer
#'              stretches identified as rivers. DEFAULT: 0.98
#' @param col   Color scale. DEFAULT: \code{\link{rivPal}(n=150)}
#' @param lwd   Line width range. DEFAULT: 1:6
#' @param add   Logical: add to existing plot? DEFAULT: FALSE
#' @param legend  Logical: add \code{\link{colPointsLegend}}? DEFAULT: TRUE
#' @param title   Character: Legend title. DEFAULT: "Catchment area  [1000 km^2]"
#' @param legargs List of arguments passed to \code{\link{colPointsLegend}}.
#' @param quiet   Logical: should progress messages be suppressed? DEFAULT: FALSE
#' @param \dots   Further arguments passed to \code{\link{segments}}.
#' 
vis_river <- function(
 dem,
 proj=NA,
 prop=0.98,
 col=rivPal(n=150),
 lwd=1:6,
 add=FALSE,
 legend=TRUE,
 title="Catchment area  [1000 km^2]",
 legargs=NULL,
 quiet=FALSE,
 ...)
{
# read file if dem is not an appropriate list:
if(!is.list(dem)) dem <- read_dem(dem,proj)
# check list elements:
check_list_elements(dem, "facc","fdir","x","y","file","name","proj","cellsize")
# extract river coordinates (sel=selection):
sel <- which(dem$facc > quantile(dem$facc, prop, na.rm=TRUE), arr.ind=TRUE)
sel <- data.frame(sel)
if(!quiet) message("Computing flow direction targets ...")
#
# find target cell for each river cell:
# 32 64 128 # flowdir
# 16     1
#  8  4  2
DIR <- read.table(header=TRUE, text="
fdir x y
1    1  0
2    1 -1
4    0 -1
8   -1 -1
16  -1  0
32  -1  1
64   0  1
128  1  1
")
# log(DIR$fdir, base=2)+1 # row index
rows <- log(diag(dem$fdir[sel$row,sel$col]), base=2)+1
# table(rows)
sel$torow <- sel$row + DIR[rows,"x"]
sel$tocol <- sel$col + DIR[rows,"y"]
#
# draw segments:
if(!quiet) message("Plotting river lines ...")
z <- riverlines(dem=dem, sel=sel, col=col, lwd=lwd, add=add, quiet=TRUE, ...)
# Add legend:
if(legend)
  {
  if(!quiet) message("Adding legend ...")
  legdefs <- list(z=z/1000, colors=col, bg="transparent", title=title, density=FALSE)
  do.call(berryFunctions::colPointsLegend, berryFunctions::owa(legdefs, legargs))
  }
# output:
return(invisible(sel))

}
