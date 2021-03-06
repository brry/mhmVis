% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pdf_png.R
\name{pdf_png}
\alias{pdf_png}
\title{Graph output file management}
\usage{
pdf_png(file, pdf = FALSE, png = FALSE, overwrite = FALSE, width = 7,
  height = 5, units = "in", res = 500, ...)
}
\arguments{
\item{file}{filename without pdf/png extension. Unless overwrite=TRUE,
files will not be overwritten. _1 will be appended instead,
see \code{\link[berryFunctions]{newFilename}}.}

\item{pdf}{Write plots created after calling this function into PDF
instead of R graphics device? DEFAULT: FALSE}

\item{png}{Ditto for PNG. Set either to TRUE, but not both
(will stop with an error). DEFAULT: FALSE}

\item{overwrite}{Logical: overwrite existing \code{file}?
DEFAULT: FALSE (_n appended in filename)}

\item{width, height}{Graph dimensions. DEFAULT: 7x5 inches}

\item{units, res}{Graph quality arguments passed only to \code{\link{png}}.
DEFAULT: inches ("in"), 500 ppi}

\item{\dots}{Further arguments passed to \code{\link{pdf}} or \code{\link{png}}}
}
\value{
Nothing, but opens a pdf or png device if either pdf or png is TRUE.
}
\description{
Graph output file management.
Do not forget to close the graphics device again with code like \code{if(pdf|png) dev.off()}\.cr
PDFs are vector graphics and nicely zoomable and thus the default for
\code{\link{vis_discharge}}. \cr
PNGs are pixely raster graphics but may have a much smaller file size.
They are better suited for spatial grids and thus the default in
\code{\link{vis_asc}} and \code{\link{vis_dem}}.
}
\examples{

pdf_png("dummyplot", pdf=TRUE)
plot(cumsum(rnorm(1000)), type="l")
dev.off()

unlink("dummyplot.pdf")

}
\seealso{
\code{\link{pdf}}, \code{\link{png}}
}
\author{
Berry Boessenkool, \email{berry-b@gmx.de}, Feb 2017
}
\keyword{file}
