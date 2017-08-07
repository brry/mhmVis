#' Read asc files
#' 
#' Read mHM-typical ASC raster files and create a full set of (projected) coordinates
#' 
 #' @return Invisible list with matrices for "asc", "x" and "y",
#' as well as character strings for the filename ("file" and "name"),
#' and the projection ("proj").
#' There are also values for the NA character string ("NAS") and "cellsize",
#' as well as the metainformation lines from the file ("meta").\cr#'
#' x and y are original coordinates, unless \code{proj != NA},
#' in which case they are transformed to lat-long degrees.
#' @author Berry Boessenkool, \email{berry-b@@gmx.de}, Feb-March 2017
#' @seealso \code{\link{vis_asc}} for plotting the result
#' @keywords file
#' @importFrom OSMscale projectPoints pll
#' @importFrom tools file_path_sans_ext
#' @export
#' @examples
#' # to be added
#' 
#' @param file      Name of file. DEFAULT: \code{\link{file.choose}()}
#' @param proj      Current projection string or NA.
#'                  If not NA, coordinates will be converted to lat-long coordinates.
#'                  If \code{proj} is a number, e.g. 3035,
#'                  it will be replaced with the online epsg proj4 from
#'                  \url{http://www.spatialreference.org/ref/epsg/3035/}.
#'                  Note that setting code{proj} may increase computing time a lot.
#'                  \code{proj} is passed as the \code{from} argument to
#'                  \code{OSMscale::\link[OSMscale]{projectPoints}}.
#'                  DEFAULT: NA
#' @param \dots     Further arguments passed to \code{\link{read.table}}
#' 
read_asc <- function(
 file=file.choose(),
 proj=NA,
 ...)
{
  # get meta information
  metalines <- readLines(file, n=6)
  meta1 <- read.table(file, nrows=6, as.is=TRUE)
  meta <- data.frame(t(meta1[,2]))
  colnames(meta) <- meta1[,1]
  rm(meta1)
  NAS <- meta$NODATA_value
  y <- seq(from=meta$yllcorner, by=meta$cellsize, length.out=meta$nrows)
  x <- seq(from=meta$xllcorner, by=meta$cellsize, length.out=meta$ncols)
  xy <- expand.grid(x,y, KEEP.OUT.ATTRS=FALSE)
  colnames(xy) <- c("x","y")
  rm(x,y)
  # project coordinates:
  if(!is.na(proj))
    {
    # from mHM/pre-proc/create_latlon.py line 115
    # http://www.spatialreference.org/ref/epsg/31463/
    if(is.numeric(proj)) proj <- readLines(paste0("http://www.spatialreference.org/ref/epsg/",
                                                proj,"/proj4/"), warn=FALSE)
    if(!is.character(proj)) stop("proj must be a character, not a ",class(proj),".\n  ",proj)
    xy <- OSMscale::projectPoints(lat=xy$y, long=xy$x, from=proj, to=OSMscale::pll() )
    }
  # read asc file itself:
  asc <- read.table(file=file, skip=6, na.strings=NAS, ...)
  asc <- t(apply(asc,  2, rev))
  asc <- unname(asc)
  # output:
  x <- matrix(xy$x, nrow=nrow(asc), ncol=ncol(asc))
  y <- matrix(xy$y, nrow=nrow(asc), ncol=ncol(asc))
  name <- tools::file_path_sans_ext(basename(file))
  return(invisible(list(asc=asc, x=x, y=y, file=file, name=name, proj=proj,
                        NAS=NAS, cellsize=meta$cellsize, meta=metalines)))
}
