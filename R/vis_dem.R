#' Visualize dem and facc files
#'
#' Visualize mHM elevation input data: dem (Digital Elevation Model) and
#' facc (Flow Accumulation, rivers modeled from DEM)
#'
#' @return dem matrix
#' @author Berry Boessenkool, \email{berry-b@@gmx.de}, Feb 2017
#' @seealso \code{\link{vis_asc}} for plotting any asc file
#' @keywords hplot color spatial
#' @importFrom berryFunctions colPointsLegend seqPal
#' @importFrom graphics par image
#' @importFrom utils choose.dir
#' @importFrom grDevices terrain.colors
#' @export
#' @examples
#' # to be added
#'
#' @param inpath  Directory containing mHM input files "dem.asc" and "facc.asc".
#'                DEFAULT: \code{\link{choose.dir}()}
#' @param pdf,png Save output to disc? See \code{\link{pdf_png}}.
#'                DEFAULT: PDF=FALSE, png=TRUE
#' @param col     Color palette. DEFAULT: \code{\link{terrain.colors}(100)}
#' @param bg      Graph background color. DEFAULT: "grey"
#' @param \dots   Further arguments passed to
#'                \code{berryFunctions::\link[berryFunctions]{colPointsLegend}}
#'
vis_dem <- function(
 inpath=choose.dir(),
 pdf=FALSE,
 png=TRUE,
 col=terrain.colors(100),
 bg="grey",
 ...)
{
   dem <- read.table(file.path(inpath,"dem.asc"),  skip=6, na.strings=-9999)
  facc <- read.table(file.path(inpath,"facc.asc"), skip=6, na.strings=-9999)
  # Plot prep
  pdf_png(file, pdf, png)
  # plot dem:
  par(mar=rep(0,4), bg=bg)
  image(t(apply(dem, 2, rev)), col=col, asp=1)
  # add river lines:
  rivcol <- berryFunctions::seqPal(100, colors=c("lightblue","darkblue"))
  image(t(apply(facc, 2, rev)), col=c(NA, rivcol), add=TRUE )
  # legend:
  colPointsLegend(unlist(dem), colors=col, ...)
  if(pdf|png) dev.off()
  # output:
  return(invisible(dem))
}
