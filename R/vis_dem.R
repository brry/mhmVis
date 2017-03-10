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
#' @importFrom berryFunctions seqPal
#' @export
#' @examples
#' # to be added
#'
#' @param dem     List returned by \code{\link{read_dem}} or character string
#'                giving a directory (passed to read_dem).
#' @param proj    Projection passed to \code{\link{read_asc}}. DEFAULT: NA
#' @param col     DEM color palette. DEFAULT: \code{\link{terrain.colors}(100)}
#' @param rivcol  River color palette. NA will be prepended if rasterriv=TRUE.
#'                DEFAULT: \code{\link{seqPal}(150, colors=c("lightblue","darkblue"))}
#' @param rasterriv Logical: should river be added as raster (with \code{\link{vis_asc}})
#'                instead of lines (with \code{\link{vis_river}})?
#'                Useful to examine single cells exactly. DEFAULT: FALSE
#' @param pch,cex Point type + size for \code{\link{colPoints}}.
#'                Only used if \code{dem$proj} != NA.
#'                Can each be two values (DEM + FACC separately).
#'                DEFAULT: pch=15, cex=c(0.14, 0.25)
#' @param add     Logical: add to existing plot? DEFAULT: FALSE
#' @param legend  Logical: add \code{\link{colPointsLegend}}? DEFAULT: TRUE
#' @param title   Character string for legend title. DEFAULT: "Elevation"
#' @param \dots   Further arguments passed to \code{\link{vis_asc}} for DEM and
#'                \code{\link{vis_asc}} or \code{\link{vis_river}} for FACC.
#'
vis_dem <- function(
 dem,
 proj=NA,
 col=terrain.colors(100),
 rivcol=berryFunctions::seqPal(150, colors=c("lightblue","darkblue")),
 rasterriv=FALSE,
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
check_list_elements(dem, "dem","facc","x","y","file","name","proj")
if("asc" %in% names(dem)) stop("dem may not contain a list element named asc.")
# Plotting object element preparation:
pdem <- facc <- dem
names(pdem)[names(pdem)== "dem"] <- "asc"
names(facc)[names(facc)=="facc"] <- "asc"
# plot prep:
pch <- rep(pch, length.out=2)
cex <- rep(cex, length.out=2)
# Plot:
o <- vis_asc(pdem, closedev=FALSE, pch=pch[1], cex=cex[1], add=add,
             legend=legend, col=col, title=title, ...)
if(rasterriv)
  vis_asc(facc, closedev=FALSE, pch=pch[2], cex=cex[2], add=TRUE,
          legend=FALSE, col=c(NA,rivcol), ...)
    else
     vis_river(dem, add=TRUE, legend=FALSE, ...)
# Turn off device if needed:
if(o$pdf|o$png) if(!add) dev.off()
return(invisible(dem))
}
