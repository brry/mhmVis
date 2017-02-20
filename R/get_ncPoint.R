#' Get coordinates of point in nc plot
#'
#' Get coordinates of a point (or several points) in an nc plot
#'
#' @return data.frame with \code{n} rows and 3 columns (index, row, col)
#' @author Berry Boessenkool, \email{berry-b@@gmx.de}, Feb 2017
#' @seealso \code{\link{read_nc}}, \code{\link{vis_nc}}
#' @keywords iplot
#' @importFrom graphics identify
#' @export
#' @examples
#' # to be added
#'
#' @param nc    nc object from \code{\link{read_nc}}
#' @param n     Maximum number of poins to be identified. DEFAULT: 1
#' @param plot  Label the identified points? DEFAULT: FALSE
#' @param \dots Further arguments passed to \code{\link{identify}}
#'
get_ncPoint <- function(
 nc,
 n=1,
 plot=FALSE,
 ...
 )
{
 i <- identify(nc$lon, nc$lat, n=n, plot=plot, ...)
 out <- sapply(i, function(k) which(nc$lon==nc$lon[k] &
                                    nc$lat==nc$lat[k], arr.ind=TRUE))
 out <- t(out)
 colnames(out) <- c("row", "col")
 out <- cbind(index=i, out)
 as.data.frame(out)
}
