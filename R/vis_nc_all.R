#' Visualize NETCDF file
#'
#' Visualize several (or even all) time slices of a NETCDF object
#'
#' @return list of \code{\link{colPoints}} list outputs
#' @author Berry Boessenkool, \email{berry-b@@gmx.de}, Feb 2017
#' @seealso \code{\link{vis_nc}}, \code{\link{vis_nc_film}} to create an animated movie
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
#'                For automated movie generation, see \code{\link{vis_nc_film}}.
#'                A progress bar will be displayed to estimate remaining time.
#'                DEFAULT: 1
#' @param Range   Range of values, passed to \code{\link{colPoints}}. Use
#'                \code{Range=NULL} to have an individually fitted range for each time slice.
#'                DEFAULT: range(nc$var, na.rm=TRUE)
#' @param expr    Expression (potentially several lines wrapped in curly braces)
#'                to be executed after each call of \code{\link{vis_nc}},
#'                like statements using axis, title, mtext etc. Can include
#'                references to current \code{index} value at each time step.
#'                DEFAULT: NULL
#' @param vlcnote Add VLC instruction note in each frame? DEFAULT: FALSE
#' @param \dots   Further arguments passed to \code{\link{vis_nc}}.
#'                You likely do not want to mess with z!
#'
vis_nc_all <- function(
 nc,
 index=1,
 Range=range(nc$var, na.rm=TRUE),
 expr=NULL,
 vlcnote=FALSE,
 ...
)
{
 index <- index[index<=length(nc$time)]
 expr2 <- substitute(expr)
 out <- pbapply::pblapply(index, function(index)
   {
   output <- vis_nc(nc=nc, index=index, Range=Range, ...)
   eval(expr2)
   if(vlcnote) mtext("VLC: 'e': single frame forward\n'SHIFT+LEFT': few seconds back",
                     side=3, line=-2.5, outer=TRUE, adj=0.01)
   output
   })
 return(invisible(out))
}
