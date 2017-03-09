#' Visualize asc files
#'
#' plot mHM-typical ASC raster files
#'
#' @return Invisible list with pdf, png, add, closedev
#' @author Berry Boessenkool, \email{berry-b@@gmx.de}, Feb-March 2017
#' @seealso \code{\link{read_asc}}, \code{\link{vis_dem}}
#' @keywords hplot color spatial
#' @importFrom berryFunctions colPoints colPointsLegend seqPal owa almost.equal
#' @importFrom graphics par image
#' @export
#' @examples
#' # to be added
#'
#' @param asc     List returned by \code{\link{read_asc}} or character string
#'                giving a filename (passed to read_asc). DEFAULT: file.choose()
#' @param proj    Projection passed to \code{\link{read_asc}} if \code{asc}
#'                is not a list. DEFAULT: NA
#' @param pdf,png Save output to disc? See \code{\link{pdf_png}}.
#'                DEFAULT: PDF=FALSE, png=TRUE
#' @param outfile Output filename without pdf/png extension. DEFAULT: asc$file
#' @param closedev Logical: if pdf|png, close devica at end of function? DEFAULT: TRUE
#' @param pdfargs List of arguments passed to \code{\link{pdf_png}}.
#' @param add     Logical: add to existing plot? DEFAULT: FALSE
#' @param asp     Plot aspect ratio, see \code{\link{plot.window}}. DEFAULT: 1
#' @param mar,mgp Plot margins and margin placement, see \code{\link{par}}.
#'                Margins are increased if missing and \code{asc$proj} != NA.
#'                DEFAULT: c(0,0,0,0), c(3,0.7,0)
#' @param col     Color palette. DEFAULT: \code{berryFunctions::\link{seqPal}(100)}
#' @param bg      Graph background color. DEFAULT: "grey"
#' @param pch,cex Point type + size for colPoints if \code{asc$proj} != NA. DEFAULT: 15, 0.7
#' @param legend  Logical: add \code{\link{colPointsLegend}}? DEFAULT: TRUE
#' @param title   Character: Legend title. DEFAULT: asc$name (obtained from filename)
#' @param legargs List of arguments passed to \code{\link{colPointsLegend}}.
#' @param \dots   Arguments passed to \code{graphics::\link{image}} or
#'                \code{berryFunctions::\link[berryFunctions]{colPoints}}
#'                (if \code{proj} != NA).
#'
vis_asc <- function(
 asc=file.choose(),
 proj=NA,
 pdf=FALSE,
 png=TRUE,
 outfile=asc$file,
 closedev=TRUE,
 pdfargs=NULL,
 add=FALSE,
 asp=1,
 mar=c(0,0,0,0),
 mgp=c(3,0.7,0),
 col=seqPal(100),
 bg="grey",
 pch=15,
 cex=0.7,
 legend=TRUE,
 title=asc$name,
 legargs=NULL,
 ...)
{
# read file if asc is not an appropriate list:
if(!is.list(asc)) asc <- read_asc(asc,proj)
# check list elements:
check_list_elements(asc, "asc","x","y","file","name","proj")
# default margins
if(!is.na(asc$proj) & missing(mar)) mar <- c(2.1,2.7,0.5,0.5)
# saving plot setup
if(!add)
  {
  pdfdefaults <- list(file=outfile, pdf=pdf, png=png)
  do.call(pdf_png, berryFunctions::owa(pdfdefaults, pdfargs))
  par(mar=mar, mgp=mgp, bg=bg)
  }
# plot asc:
axes <- !all(almost.equal(mar,0))
if(is.na(asc$proj))
 graphics::image(asc$asc, col=col, asp=asp, add=add, axes=axes, ...) else
berryFunctions::colPoints(as.vector(asc$x), as.vector(asc$y), as.vector(asc$asc),
                          col=col, pch=pch, cex=cex, add=add, asp=asp,
                          axes=axes, legend=FALSE, ...)
# Add legend:
if(legend)
  {
  legdefs <- list(z=unlist(asc$asc), colors=col, bg="transparent", title=title)
  do.call(berryFunctions::colPointsLegend, berryFunctions::owa(legdefs, legargs))
  }
if(pdf|png) if(!add & closedev) dev.off()
# output:
return(invisible(   list(pdf=pdf,png=png,add=add,closedev=closedev)   ))
}
