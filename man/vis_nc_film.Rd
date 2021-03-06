% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/vis_nc_film.R
\name{vis_nc_film}
\alias{vis_nc_film}
\title{Visualize NETCDF file}
\usage{
vis_nc_film(nc, index = seq_along(nc$time), Range = range(nc$var, na.rm =
  TRUE), vlcnote = TRUE, test = TRUE, outfile = paste0(nc$file, ".mp4"),
  width = 7 * 200, height = 5 * 200, interval = 0.1,
  ffmpeg = ani.options("ffmpeg"), vidargs = NULL, mar = c(4, 7, 10, 1),
  mgp = c(3, 1.2, 0), xpd = TRUE, parargs = NULL, cex = 1,
  cex.axis = 3, cex.leg = cex.axis, bg.leg = NA, ...)
}
\arguments{
\item{nc}{nc object from \code{\link{read_nc}}}

\item{index}{Integer: time slice numbers to be plotted. See \code{\link{vis_nc_all}}.
DEFAULT: seq_along(nc$time)}

\item{Range}{Range of values, see \code{\link{vis_nc_all}}.
DEFAULT: range(nc$var, na.rm=TRUE)}

\item{vlcnote}{Add VLC instruction note in each frame? TO include other
information in each frame, use \code{expr},
see \code{\link{vis_nc_all}}. DEFAULT: TRUE}

\item{test}{Logical: test the resolution parameters etc by creating a single
png file of the first value in \code{index}.
This is useful to select useful settings before
creating an entire movie. DEFAULT: TRUE}

\item{outfile}{Output video filename. = video.name in
\code{animation::\link[animation]{saveVideo}}.
DEFAULT: paste0(nc$file,".mp4")}

\item{width, height}{Size of image frames in pixels. DEFAULT: 7*200, 5*200}

\item{interval}{Time interval of animation in seconds. DEFAULT: 0.1}

\item{ffmpeg}{Path to the progam ffmpeg. DEFAULT: ani.options("ffmpeg")}

\item{vidargs}{Further arguments passed to \code{animation::\link[animation]{saveVideo}}.}

\item{mar, mgp, xpd}{Graphical parameters passed to \code{\link{par}}.
DEFAULT: c(4,7,10,1), c(3,1.2,0), TRUE}

\item{parargs}{List of further parameters to \code{\link{par}}. DEFAULT: NULL}

\item{cex}{Symbol size passed to \code{\link{vis_nc}}. DEFAULT: 1}

\item{cex.axis, cex.leg}{Label size passed to \code{\link{vis_nc}}. DEFAULT: 3}

\item{bg.leg}{\code{\link[berryFunctions]{colPointsLegend}} Background. DEFAULT: NA}

\item{\dots}{Further arguments passed to \code{\link{vis_nc}}.
You likely do not want to mess with z!}
}
\value{
list of \code{\link{colPoints}} list outputs
}
\description{
Visualize several (or even all) time slices of a NETCDF object into an mp4 animation
}
\examples{
# to be added

}
\references{
\url{http://ffmpeg.org/documentation.html}
}
\seealso{
\code{\link{vis_nc}}, \code{\link{vis_nc_all}}
}
\author{
Berry Boessenkool, \email{berry-b@gmx.de}, Feb 2017
}
\keyword{hplot}
