#' Visualize NETCDF file
#' 
#' Visualize several (or even all) time slices of a NETCDF object into an mp4 animation
#' 
#' @return list of \code{\link{colPoints}} list outputs
#' @author Berry Boessenkool, \email{berry-b@@gmx.de}, Feb 2017
#' @seealso \code{\link{vis_nc}}, \code{\link{vis_nc_all}}
#' @references \url{http://ffmpeg.org/documentation.html}
#' @keywords hplot
#' @importFrom animation saveVideo ani.options
#' @importFrom berryFunctions newFilename owa
#' @importFrom grDevices dev.off png
#' @export
#' @examples
#' # to be added
#' 
#' @param nc       nc object from \code{\link{read_nc}}
#' @param index    Integer: time slice numbers to be plotted. See \code{\link{vis_nc_all}}.
#'                 DEFAULT: seq_along(nc$time)
#' @param Range    Range of values, see \code{\link{vis_nc_all}}.
#'                 DEFAULT: range(nc$var, na.rm=TRUE)
#' @param vlcnote  Add VLC instruction note in each frame? TO include other
#'                 information in each frame, use \code{expr},
#'                 see \code{\link{vis_nc_all}}. DEFAULT: TRUE
#' @param test     Logical: test the resolution parameters etc by creating a single
#'                 png file of the first value in \code{index}.
#'                 This is useful to select useful settings before
#'                 creating an entire movie. DEFAULT: TRUE
#' @param outfile  Output video filename. = video.name in
#'                 \code{animation::\link[animation]{saveVideo}}.
#'                 DEFAULT: paste0(nc$file,".mp4")
#' @param width,height Size of image frames in pixels. DEFAULT: 7*200, 5*200
#' @param interval Time interval of animation in seconds. DEFAULT: 0.1
#' @param ffmpeg   Path to the progam ffmpeg. DEFAULT: ani.options("ffmpeg")
#' @param vidargs  Further arguments passed to \code{animation::\link[animation]{saveVideo}}.
#' @param mar,mgp,xpd Graphical parameters passed to \code{\link{par}}.
#'                 DEFAULT: c(4,7,10,1), c(3,1.2,0), TRUE
#' @param parargs  List of further parameters to \code{\link{par}}. DEFAULT: NULL
#' @param cex      Symbol size passed to \code{\link{vis_nc}}. DEFAULT: 1
#' @param cex.axis,cex.leg Label size passed to \code{\link{vis_nc}}. DEFAULT: 3
#' @param bg.leg   \code{\link[berryFunctions]{colPointsLegend}} Background. DEFAULT: NA
#' @param \dots    Further arguments passed to \code{\link{vis_nc}}.
#'                 You likely do not want to mess with z!
#' 
vis_nc_film <- function(
 nc,
 index=seq_along(nc$time),
 Range=range(nc$var, na.rm=TRUE),
 vlcnote=TRUE,

 test=TRUE,

 outfile=paste0(nc$file,".mp4"),
 width=7*200,
 height=5*200,
 interval=0.1,
 ffmpeg=ani.options("ffmpeg"),
 vidargs=NULL,

 mar=c(4,7,10,1),
 mgp=c(3,1.2,0),
 xpd=TRUE,
 parargs=NULL,
 cex=1,
 cex.axis=3,
 cex.leg=cex.axis,
 bg.leg=NA,
 ...
)
{
 if(test) outfile <- paste0(outfile,".png")
 outfile <- berryFunctions::newFilename(outfile, ignore=test, mid="")
 # single png for testing resolution etc
 if(test)
  {
  warning("vis_nc_film is only creating a single test image. ",
          "To create the actual video, use test=FALSE.",call.=FALSE)
  png(outfile, width=width, height=height)
  on.exit( dev.off() )
  do.call(par, owa(list(mar=mar, mgp=mgp, xpd=xpd), parargs))
  output <- vis_nc_all(nc=nc, index=index[1], Range=Range, vlcnote=vlcnote, cex=cex,
                       cex.axis=cex.axis, cex.leg=cex.leg, bg.leg=bg.leg, ...)
  return(invisible(output))
  }
# regular nontesting case:
saveVideo(
   {
   do.call(par, owa(list(mar=mar, mgp=mgp, xpd=xpd), parargs))
             vis_nc_all(nc=nc, index=index, Range=Range, vlcnote=vlcnote, cex=cex,
                        cex.axis=cex.axis, cex.leg=cex.leg, bg.leg=bg.leg, ...)
   },
  video.name=outfile, interval=interval, ffmpeg=ffmpeg,
  ani.width=width, ani.height=height)
}

#' ffmpeg path on berry's computers
#' @seealso \code{\link{vis_nc_film}}, where it is defined
#' @export
ffberry <- if(Sys.info()["sysname"]=="Linux") "/usr/bin/ffmpeg" else
 "C:/Program Files/R/ffmpeg/bin/ffmpeg.exe"

