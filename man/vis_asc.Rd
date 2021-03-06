% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/vis_asc.R
\name{vis_asc}
\alias{vis_asc}
\title{Visualize asc files}
\usage{
vis_asc(asc = file.choose(), proj = NA, pdf = FALSE, png = TRUE,
  overwrite = FALSE, outfile = asc$file, closedev = TRUE,
  pdfargs = NULL, add = FALSE, asp = 1, mar = c(0, 0, 0, 0),
  mgp = c(3, 0.7, 0), col = seqPal(100), bg = "grey", pch = 15,
  cex = 0.1, legend = TRUE, title = asc$name, legargs = NULL, ...)
}
\arguments{
\item{asc}{List returned by \code{\link{read_asc}} or character string
giving a filename (passed to read_asc). DEFAULT: file.choose()}

\item{proj}{Projection passed to \code{\link{read_asc}} if \code{asc}
is not a list. DEFAULT: NA}

\item{pdf, png}{Save output to disc? See \code{\link{pdf_png}}.
DEFAULT: PDF=FALSE, png=TRUE}

\item{overwrite}{Logical: overwrite existing \code{file} via \code{\link{pdf_png}}?
DEFAULT: FALSE (_n appended in filename)}

\item{outfile}{Output filename without pdf/png extension. DEFAULT: asc$file}

\item{closedev}{Logical: if pdf|png, close devica at end of function? DEFAULT: TRUE}

\item{pdfargs}{List of arguments passed to \code{\link{pdf_png}}.}

\item{add}{Logical: add to existing plot? DEFAULT: FALSE}

\item{asp}{Plot aspect ratio, see \code{\link{plot.window}}. DEFAULT: 1}

\item{mar, mgp}{Plot margins and margin placement, see \code{\link{par}}.
Margins are increased if missing and \code{asc$proj} != NA.
DEFAULT: c(0,0,0,0), c(3,0.7,0)}

\item{col}{Color palette. DEFAULT: \code{berryFunctions::\link{seqPal}(100)}}

\item{bg}{Graph background color. DEFAULT: "grey"}

\item{pch, cex}{Point type + size for colPoints if \code{asc$proj} != NA. DEFAULT: 15, 0.1}

\item{legend}{Logical: add \code{\link{colPointsLegend}}? DEFAULT: TRUE}

\item{title}{Character: Legend title. DEFAULT: asc$name (obtained from filename)}

\item{legargs}{List of arguments passed to \code{\link{colPointsLegend}}.}

\item{\dots}{Arguments passed to \code{graphics::\link{image}} or
\code{berryFunctions::\link[berryFunctions]{colPoints}}
(if \code{proj} != NA).}
}
\value{
Invisible list with pdf, png, add, closedev
}
\description{
plot mHM-typical ASC raster files
}
\examples{
# to be added

}
\seealso{
\code{\link{read_asc}}, \code{\link{vis_dem}}
}
\author{
Berry Boessenkool, \email{berry-b@gmx.de}, Feb-March 2017
}
\keyword{color}
\keyword{hplot}
\keyword{spatial}
