#' draw river lines
#' 
#' Draw river lines, used within \code{\link{vis_river}}.
#' 
#' @return catchment area of each cell
#' @author Berry Boessenkool, \email{berry-b@@gmx.de}, Mar 2017
#' @seealso \code{\link{vis_river}}
#' @keywords aplot
#' @importFrom graphics segments
#' @importFrom berryFunctions rescale classify
#' @export
#' @examples
#' # see vis_river
#' 
#' @param dem   List returned by \code{\link{read_dem}}
#' @param sel   Segment indices returned by \code{\link{vis_river}}
#' @param col   Color scale. DEFAULT: \code{\link{rivPal}(n=150)}
#' @param lwd   Line width range. DEFAULT: 1:6
#' @param add   Logical: add to existing plot? DEFAULT: FALSE
#' @param quiet Logical: should progress messages be suppressed? DEFAULT: FALSE
#' @param \dots Further arguments passed to \code{\link{segments}}.
#' 
riverlines <- function(
 dem,
 sel,
 col=rivPal(n=150),
 lwd=1:6,
 add=FALSE,
 quiet=FALSE,
 ...)
{
# prepare line width:
if(!quiet) message("Preparing line widths ...")
z <- diag(dem$facc[sel$row,sel$col])
z <- z*(dem$cellsize/1000)^2 # km^2
cl <- classify(x=z, breaks=length(col) )
lwd <- rescale(z,min(lwd),max(lwd))
# Set up plot:
if(!add) plot(1, type="n", ylim=range(dem$y), xlim=range(dem$x), las=1, ylab="", xlab="")
if(!quiet) message("Drawing river segments ...")
# actually draw lines
segments(x0=diag(dem$x[sel$row,sel$col]), x1=diag(dem$x[sel$torow,sel$tocol]),
         y0=diag(dem$y[sel$row,sel$col]), y1=diag(dem$y[sel$torow,sel$tocol]),
         col=col[cl$index], lwd=lwd, ...)
# output:
return(invisible(z))
}
