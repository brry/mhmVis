#' DEM and river color palettes
#'
#' DEM and river color palettes
#'
#' @aliases demPal rivPal
#' @return color Palette
#' @author Berry Boessenkool, \email{berry-b@@gmx.de}, Mar 2017
#' @seealso \code{\link{seqPal}}, \code{\link{terrain.colors}}
#' @keywords aplot
#' @importFrom berryFunctions seqPal
#' @export
#' @examples
#' image(volcano, col=rivPal() )
#' op <- par(mfcol=c(3,3), mar=c(0,0.3,0,0.3), ann=FALSE)
#' for(l in seq(0.96, 1.04, 0.01))
#'    {image(volcano, col=demPal(l), axes=FALSE)
#'    legend("topright", legend=l)}
#'
#' @param logbase Numerical: stretch colors so that differences in small values
#'                become more apparent. 1 to use original \code{\link{terrain.colors}}.
#'                DEFAULT: 1.02 (demPal), 1 (rivPal)
#' @param n       Number of colors to be used in palette.
#'                DEFAULT: 100 (demPal), 150 (rivPal)
#' @param \dots   Further arguments passed to \code{berryFunctions::\link{seqPal}}
#'
demPal <- function(
logbase=1.02,
n=100,
...
)
{
berryFunctions::seqPal(n, colors=terrain.colors(n), logbase=logbase, ...)
}


#' @export
#' @rdname demPal
#'
rivPal <- function(
logbase=1,
n=150,
...
)
{
berryFunctions::seqPal(n, colors=c("lightblue","darkblue"), logbase=logbase, ...)
}
