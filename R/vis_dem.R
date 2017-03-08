#' Visualize dem and facc files
#'
#' Visualize mHM elevation input data: dem (Digital Elevation Model) and
#' facc (Flow Accumulation, rivers modeled from DEM)
#'
#' @return Invisible list dem or \code{\link{read_dem}} result
#' @author Berry Boessenkool, \email{berry-b@@gmx.de}, Feb-March 2017
#' @seealso \code{\link{read_dem}}, \code{\link{vis_asc}} for plotting any asc file
#' @keywords hplot color spatial
#' @importFrom grDevices terrain.colors
#' @export
#' @examples
#' # to be added
#'
#' @param dem     List returned by \code{\link{read_dem}} or character string
#'                giving a directory (passed to read_dem).
#' @param proj    projection passed to \code{\link{read_asc}}. DEFAULT: NA
#' @param col     DEM color palette. DEFAULT: \code{\link{terrain.colors}(100)}
#' @param nriv    Number of colors for default river palette. A higher number
#'                means more river stretches will be displayed. DEFAULT: 150
#' @param rivcol  River color palette. DEFAULT: c(NA, seqPal(nriv, ---))
#' @param pch,cex Point type + size for colPoints if \code{dem$proj} != NA.
#'                Can each be two values (DEM + FACC separately).
#'                DEFAULT: pch=15, cex=c(0.14, 0.25)
#' @param add     Logical: add to existing plot? DEFAULT: FALSE
#' @param legend  Logical: add \code{\link{colPointsLegend}}? DEFAULT: TRUE
#' @param title   CHaracter string for legend title. DEFAULT: "Elevation"
#' @param \dots   Further arguments passed to \code{\link{vis_asc}}.
#'
vis_dem <- function(
 dem,
 proj=NA,
 col=terrain.colors(100),
 nriv=150,
 rivcol=c(NA, berryFunctions::seqPal(nriv, colors=c("lightblue","darkblue"))),
 pch=15,
 cex=c(0.14, 0.25),
 add=FALSE,
 legend=TRUE,
 title="Elevation",
  ...)
{
# read file if dem is not an appropriate list:
if(!is.list(dem)) dem <- read_dem(dem,proj)
# check list elements:
elems <- c("dem","facc","x","y","file","name","proj")
isin <-  elems %in% names(dem)
if(!all(isin)) stop("dem does not contain ", toString(elems[!isin]))
if("asc" %in% names(dem)) stop("dem may not contain a list element named asc.")
# Object element preparation:
pdem <- facc <- dem
names(pdem)[names(pdem)== "dem"] <- "asc"
names(facc)[names(facc)=="facc"] <- "asc"
# plot prep:
pch <- rep(pch, length.out=2)
cex <- rep(cex, length.out=2)
# Plot:
     vis_asc(pdem, closedev=FALSE, pch=pch[1], cex=cex[1], add=add,  legend=legend, col=col, title=title, ...)
o <- vis_asc(facc, closedev=FALSE, pch=pch[2], cex=cex[2], add=TRUE, legend=FALSE, col=rivcol, ...)
# Turn off device if needed:
if(o$pdf|o$png) if(!add) dev.off()
return(invisible(dem))
}
