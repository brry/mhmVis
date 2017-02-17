#' Visualize asc files
#'
#' Visualize asc files (commonly used in mHM)
#'
#' @return asc matrix
#' @author Berry Boessenkool, \email{berry-b@@gmx.de}, Feb 2017
#' @seealso \code{\link{help}}
#' @keywords hplot color spatial
#' @importFrom berryFunctions colPointsLegend seqPal
#' @importFrom graphics par image
#' @export
#' @examples
#' # to be added
#'
#' @param file    name of file. DEFAULT: \code{\link{file.choose}}
#' @param pdf,png Save output to disc? See \code{\link{pdf_png}}.
#'                DEFAULT: PDF=FALSE, png=TRUE
#' @param col     Color palette. DEFAULT: \code{berryFunctions::\link[berryFunctions]{seqPal}(100)}
#' @param bg      Graph background color. DEFAULT: "grey"
#' @param \dots Further arguments passed to \code{berryFunctions::\link[berryFunctions]{colPointsLegend}}
#'
vis_asc <- function(
 file=file.choose(),
 pdf=FALSE,
 png=TRUE,
 col=seqPal(100),
 bg="grey",
 ...)
{
  asc <- read.table(file, skip=6, na.strings=-9999)
  # Plot prep
  pdf_png(file, pdf, png)
  # plot:
  par(mar=rep(0,4), bg=bg)
  image(t(apply(asc, 2, rev)), col=col, asp=1)
  colPointsLegend(unlist(asc), colors=col, ...)
  if(pdf|png) dev.off()
  # output:
  return(invisible(asc))
}
