#' Read dem and facc files
#'
#' Read mHM-typical elevation input data: dem (Digital Elevation Model) and
#' facc (Flow Accumulation, rivers modeled from DEM)
#'
#' @return list as in \code{\link{read_asc}}, but "asc" is replaced with
#' elements "dem" and "facc": The element "folder" is added as well.
#' @author Berry Boessenkool, \email{berry-b@@gmx.de}, Feb-March 2017
#' @seealso \code{\link{vis_dem}}
#' @keywords hfile
#' @importFrom utils choose.dir
#' @importFrom berryFunctions checkFile
#' @export
#' @examples
#' # to be added
#'
#' @param inpath  Directory containing mHM input files "dem.asc" and "facc.asc".
#'                DEFAULT: \code{\link{choose.dir}()} on windows, \code{"."} on unix
#' @param proj    projection passed to \code{\link{read_asc}}. DEFAULT: NA
#' @param \dots   Further arguments passed to \code{\link{read_asc}}.
#'
read_dem <- function(
 inpath=if(.Platform$OS.type=="windows") choose.dir() else ".",
 proj=NA,
 ...)
{
# expand and check paths:
inpath <- normalizePath(inpath, "/", mustWork=FALSE)
dempath  <- file.path(inpath,  "dem.asc", fsep="/")
faccpath <- file.path(inpath, "facc.asc", fsep="/")
berryFunctions::checkFile(c(dempath,faccpath))
# read DEM file:
dem <- read_asc(dempath, proj=proj, ...)
names(dem)[1] <- "dem"
# Read facc file (assuming same projection etc as dem):
facc <- read.table(file=faccpath, skip=6, na.strings=dem$NAS, ...)
facc <- t(apply(facc, 2, rev))
facc <- unname(facc)
# output:
out <- c(list(dem=dem[[1]], facc=facc), dem[-1], folder=inpath)
return(invisible(out))
}
