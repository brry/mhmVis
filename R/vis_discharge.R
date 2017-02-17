#' Visualize mHM discharge output
#'
#' Compare mHM modeled and observed streamflow
#'
#' @return invisible List with qout (data.frame), days (Date), NSE and KGE (numbers)
#' @note na.strings may not yet always be recognized correctly.
#' @author Berry Boessenkool, \email{berry-b@@gmx.de}, Feb 2017
#' @seealso \code{\link{pdf_png}}
#' @keywords hplot
#' @importFrom berryFunctions monthAxis nse kge lim0
#' @importFrom grDevices dev.off
#' @importFrom graphics legend lines plot
#' @importFrom utils read.table
#' @export
#' @examples
#' # to be added
#'
#' @param file    name of mHM output file like "some/path/output/daily_discharge.out".
#'                DEFAULT: \code{\link{file.choose}}
#' @param ylab    Y axis label. DEFAULT: "Discharge  [m^3/s]"
#' @param pdf,png Save output to disc? See \code{\link{pdf_png}}.
#'                DEFAULT: PDF=TRUE, png=FALSE
#' @param \dots   Further arguments passed to \code{\link{plot}}
#'
vis_discharge <- function(
 file=file.choose(),
 ylab="Discharge  [m\U00B3/s]",
 pdf=TRUE,
 png=FALSE,
 ...)
{
  qout <- read.table(file, header=TRUE, na.strings="-9999.0000000")
  days <- as.Date(paste(qout$Year, qout$Mon, qout$Day, sep="-"), format = "%Y-%m-%d")
  # Plot prep:
  pdf_png(file, pdf, png)
  # plot:
  plot(days, qout[,5], type="l", ylim=lim0(qout[,5:6]), las=1, xaxt="n", ylab=ylab, ...)
  monthAxis(ym=TRUE)
  lines(days, qout[,6], col=2)
  legend("topleft", c("Obs","Sim"), col=1:2, lty=1, title=substr(colnames(qout)[5], 6,100))
  # Goodness of fit
  NSE <- berryFunctions::nse(qout[,5], qout[,6])
  KGE <- berryFunctions::kge(qout[,5], qout[,6])
  legend("topright", paste(c("NSE","KGE"),round(c(NSE, KGE),2)), bty="n")
  if(pdf|png) dev.off()
  # output:
  return(invisible(list(qout=qout, days=days, NSE=NSE, KGE=KGE)))
}
