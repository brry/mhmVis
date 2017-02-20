#' Visualize NETCDF file
#'
#' Visualize several (or even all) time slices of a NETCDF object
#'
#' @return list of \code{\link{colPoints}} list outputs
#' @author Berry Boessenkool, \email{berry-b@@gmx.de}, Feb 2017
#' @seealso \code{\link{vis_nc}}
#' @keywords hplot
#' @importFrom pbapply pblapply
#' @export
#' @examples
#' # to be added
#'
#' @param nc      nc object from \code{\link{read_nc}}
#' @param index   Integer: time slice numbers to be plotted. Will be truncated
#'                to values actually available. If \code{index} is very long,
#'                please make sure to be directing the output into a PDF, movie or similar.
#'                A progress bar will be displayed to estimate remaining time.
#'                DEFAULT: seq_along(nc$time)
#' @param Range   Range of values, passed to \code{\link{colPoints}}. Use
#'                \code{Range=NULL} to have an individually fitted range for each time slice.
#'                DEFAULT: range(nc$var, na.rm=TRUE)
#' @param \dots   Further arguments passed to \code{\link{vis_nc}}.
#'                You likely do not want to mess with z!
#'
vis_nc_all <- function(
 nc,
 index=seq_along(nc$time),
 Range=range(nc$var, na.rm=TRUE),
 ...
)
{
 index <- index[index<=length(nc$time)]
 out <- pbapply::pblapply(index, vis_nc, nc=nc, Range=Range, ...)
 return(invisible(out))
}
