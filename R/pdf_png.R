#' graph output file management
#'
#' graph output file management.
#' Do not forget to close device again with code like \code{if(pdf|png) dev.off()}
#'
#' @return Nothing, but opens a pdf or png device if either pdf or png is TRUE.
#' @author Berry Boessenkool, \email{berry-b@@gmx.de}, Feb 2017
#' @seealso \code{\link{pdf}}, \code{\link{png}}
#' @keywords file
#' @importFrom berryFunctions newFilename
#' @importFrom grDevices pdf png
#' @export
#' @examples
#'
#' pdf_png("dummyplot", pdf=TRUE)
#' plot(cumsum(rnorm(1000)), type="l")
#' dev.off()
#'
#' unlink("dummyplot.pdf")
#'
#' @param file         filename without pdf/png extension. Files will never be overwritten,
#'                     _1 will be appended, see \code{\link[berryFunctions]{newFilename}}.
#' @param pdf          Write plots created after calling this function into PDF
#'                     instead of R graphics device? DEFAULT: FALSE
#' @param png          Ditto for PNG. Set either to TRUE, but not both
#'                     (will stop with an error). DEFAULT: FALSE
#' @param width,height Graph dimensions. DEFAULT: 7x5 inches
#' @param units,res    Graph quality arguments passed only to \code{\link{png}}.
#'                     DEFAULT: inches ("in"), 500 ppi
#' @param \dots        Further arguments passed to \code{\link{pdf}} or \code{\link{png}}
#'
#  ----

pdf_png <- function(
 file,
 pdf=FALSE,
 png=FALSE,
 width=7,
 height=5,
 units="in",
 res=500,
 ...
 )
{
  if(pdf & png) stop("png and pdf are both TRUE. Select either one, but not both.")
  figpath <- paste0(file, ".", if(pdf) "pdf" else if(png) "png")
  # do not overwrite existing files
  figpath <- berryFunctions::newFilename(figpath)
  if(pdf) pdf(figpath, width=width, height=height, ...)
  if(png) png(figpath, width=width, height=height, units=units, res=res, ...)
}