% edited for unicode escape
% Please edit documentation in R/vis_discharge.R
\name{vis_discharge}
\alias{vis_discharge}
\title{Visualize mHM discharge output}
\usage{
vis_discharge(file = file.choose(), ylab = "Discharge  [m\U{00B3}/s]",
  pdf = TRUE, png = FALSE, ...)
}
\arguments{
\item{file}{name of mHM output file like "some/path/output/daily_discharge.out".
DEFAULT: \code{\link{file.choose}}}

\item{ylab}{Y axis label. DEFAULT: "Discharge  [m^3/s]"}

\item{pdf, png}{Save output to disc? See \code{\link{pdf_png}}.
DEFAULT: PDF=TRUE, png=FALSE}

\item{\dots}{Further arguments passed to \code{\link{plot}}}
}
\value{
invisible List with qout (data.frame), days (Date), NSE and KGE (numbers)
}
\description{
Compare mHM modeled and observed streamflow
}
\note{
na.strings may not yet always be recognized correctly.
}
\examples{
# to be added

}
\seealso{
\code{\link{pdf_png}}
}
\author{
Berry Boessenkool, \email{berry-b@gmx.de}, Feb 2017
}
\keyword{hplot}
