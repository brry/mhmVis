#' Visualize dem and facc files
#'
#' Visualize mHM elevation input data: dem (Digital Elevation Model) and
#' facc (Flow Accumulation, rivers modeled from DEM)
#'
#' @return list with dem + facc matrix and rivcol
#' @author Berry Boessenkool, \email{berry-b@@gmx.de}, Feb 2017
#' @seealso \code{\link{vis_asc}} for plotting any asc file
#' @keywords hplot color spatial
#' @importFrom berryFunctions colPoints colPointsLegend seqPal owa
#' @importFrom OSMscale projectPoints pll
#' @importFrom graphics par image
#' @importFrom utils choose.dir
#' @importFrom grDevices terrain.colors
#' @export
#' @examples
#' # to be added
#'
#' @param inpath  Directory containing mHM input files "dem.asc" and "facc.asc".
#'                DEFAULT: \code{\link{choose.dir}()}
#' @param plot    Logical: should plot be created? If FALSE, files are still read,
#'                processed and returned. DEFAULT: TRUE
#' @param add     Logical: add to existing plot? DEFAULT: FALSE
#' @param pdf,png Save output to disc? See \code{\link{pdf_png}}.
#'                DEFAULT: PDF=FALSE, png=TRUE
#' @param col     Color palette. DEFAULT: \code{\link{terrain.colors}(100)}
#' @param bg      Graph background color. DEFAULT: "grey"
#' @param mar,mgp Plot margins and margin placement, see \code{\link{par}}.
#'                DEFAULT: c(0,0,0,0), c(3,0.7,0)
#' @param proj    Current projection string. If not NA, coordinates will be converted
#'                to lat-long coordinates. If \code{proj} is a number, e.g. 3035,
#'                it will be replaced with the online epsg proj4 from
#'                \url{http://www.spatialreference.org/ref/epsg/3035/}.
#'                Note that this may increase plotting time a lot. DEFAULT: NA
#' @param pch,cex Point type + size for colPoints if \code{proj} != NA.
#'                Can each be two values (DEM + FACC separately). DEFAULT: 15, 0.7
#' @param pdfargs List of arguments passed to \code{\link{pdf_png}}.
#' @param \dots   Further arguments passed to
#'                \code{berryFunctions::\link[berryFunctions]{colPointsLegend}}
#'                (passed to colPoints first if \code{proj} != NA).
#'
vis_dem <- function(
 inpath=choose.dir(),
 plot=TRUE,
 add=FALSE,
 pdf=FALSE,
 png=TRUE,
 col=terrain.colors(100),
 bg="grey",
 mar=c(0,0,0,0),
 mgp=c(3,0.7,0),
 proj=NA,
 pch=15,
 cex=0.7,
 pdfargs=NULL,
 ...)
{
  # get meta information
  meta1 <- read.table(file.path(inpath,"dem.asc"),  nrows=6, as.is=TRUE)
  meta <- data.frame(t(meta1[,2]))
  colnames(meta) <- meta1[,1]     ;   rm(meta1)
  NAS <- meta$NODATA_value
  y <- seq(from=meta$yllcorner, by=meta$cellsize, length.out=meta$nrows)
  x <- seq(from=meta$xllcorner, by=meta$cellsize, length.out=meta$ncols)
  xy <- expand.grid(x,y)  ; colnames(xy) <- c("x","y")  ;  rm(x,y)
  # project coordinates:
  if(!is.na(proj))
    {
    # from mHM/pre-proc/create_latlon.py line 115
    # http://www.spatialreference.org/ref/epsg/31463/
    if(is.numeric(proj)) proj <- readLines(paste0("http://www.spatialreference.org/ref/epsg/",
                                                proj,"/proj4/"), warn=FALSE)
    if(!is.character(proj)) stop("proj must be a character, not a ",class(proj),".\n  ",proj)
    xy <- OSMscale::projectPoints(lat=xy$y, long=xy$x, from=proj, to=OSMscale::pll() )
    #plot(xy)
    if(missing(mar)) mar <- c(2.1,2.7,0.5,0.5)
    }
  # read asc files:
  dem  <- read.table(file.path(inpath,"dem.asc"),  skip=6, na.strings=NAS)
  facc <- read.table(file.path(inpath,"facc.asc"), skip=6, na.strings=NAS)
  dem  <- t(apply(dem,  2, rev))
  facc <- t(apply(facc, 2, rev))
  # Plot prep
  # color for added river lines:
  rivcol <- c(NA, berryFunctions::seqPal(100, colors=c("lightblue","darkblue")))
  if(plot)
  {
  if(!add)
    {
    pdfdefaults <- list(file=file.path(inpath,"dem"), pdf=pdf, png=png)
    do.call(pdf_png, berryFunctions::owa(pdfdefaults, pdfargs))
    }
  # plot dem:
  par(mar=mar, mgp=mgp, bg=bg)
  if(is.na(proj))
    {
    graphics::image(dem,  col=col, asp=1, add=add)
    graphics::image(facc, col=rivcol, add=TRUE )
    berryFunctions::colPointsLegend(unlist(dem), colors=col, bg=bg, title="Elevation", ...)
    } else
    {
    pch <- rep(pch, length.out=2)
    cex <- rep(cex, length.out=2)
    berryFunctions::colPoints(xy$x, xy$y, as.vector(dem), col=col,
                              pch=pch[1], cex=cex[1], add=add,  legend=FALSE, ...)
    berryFunctions::colPoints(xy$x, xy$y, as.vector(facc), col=rivcol,
                              pch=pch[2], cex=cex[2], add=TRUE, legend=FALSE, ...)
    berryFunctions::colPointsLegend(unlist(dem), colors=col, bg="transparent", title="Elevation", ...)
    }
  if(pdf|png) if(!add) dev.off()
  } # end if plot
  # output:
  return(invisible(list(dem=dem, facc=facc, rivcol=rivcol, xy=xy)))
}
