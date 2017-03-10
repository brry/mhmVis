#' Read dem and facc files
#'
#' Read mHM-typical elevation input data: dem (Digital Elevation Model) and
#' facc (Flow Accumulation, rivers modeled from DEM)
#'
#' @return list as in \code{\link{read_asc}}, but "asc" is replaced with
#' elements "dem", "facc" and "fdir". The element "folder" is added as well.
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
#' @param quiet   Logical: should progress messages be suppressed? DEFAULT: FALSE
#' @param \dots   Further arguments passed to \code{\link{read_asc}}.
#'
read_dem <- function(
 inpath=if(.Platform$OS.type=="windows") choose.dir() else ".",
 proj=NA,
 quiet=FALSE,
 ...)
{
# expand and check paths:
inpath <- normalizePath(inpath, "/", mustWork=FALSE)
dempath  <- file.path(inpath,  "dem.asc", fsep="/")
faccpath <- file.path(inpath, "facc.asc", fsep="/")
fdirpath <- file.path(inpath, "fdir.asc", fsep="/")
berryFunctions::checkFile(c(dempath,faccpath,fdirpath))
# read DEM file:
if(!quiet) message("Reading ", dempath, "...")
dem <- read_asc(dempath, proj=proj, ...)
names(dem)[1] <- "dem"
dem$file <- file.path(inpath, "DEM", fsep="/")
# Read facc file (assuming same projection, extend etc. as dem):
if(!quiet) message("Reading ", faccpath, "...")
facc <- read.table(file=faccpath, skip=6, na.strings=dem$NAS, ...)
facc <- t(apply(facc, 2, rev))
facc <- unname(facc)
# Read fdir file (assuming same projection, extend etc. as dem):
if(!quiet) message("Reading ", fdirpath, "...")
fdir <- read.table(file=fdirpath, skip=6, na.strings=dem$NAS, ...)
fdir <- t(apply(fdir, 2, rev))
fdir <- unname(fdir)
# output:
out <- c(list(dem=dem[[1]], facc=facc, fdir=fdir), dem[-1], folder=inpath)
return(invisible(out))
}
