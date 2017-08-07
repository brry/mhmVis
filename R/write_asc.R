#' Write asc files
#' 
#' Write asc file to disc (useful after changing the asc$asc element).
#' 
#' @return Nothing
#' @author Berry Boessenkool, \email{berry-b@@gmx.de}, March 2017
#' @seealso \code{\link{read_asc}}
#' @keywords file
#' @importFrom berryFunctions newFilename
#' @importFrom utils write.table
#' @export
#' @examples
#' # to be added
#' 
#' @param asc     List returned by \code{\link{read_asc}}.
#' @param file    Filename. DEFAULT: \code{berryFunctions::\link{newFilename}(asc$file)}
#' @param \dots   Further arguments passed to \code{\link{write.table}}.
#' 
write_asc <- function(
 asc,
 file=newFilename(asc$file),
  ...)
{
check_list_elements(asc, "asc","file","meta","NAS")
# Transpose back to original arrangement:
out <- apply(t(asc$asc), 2, rev)
# replace NA with appropriate value:
out <- replace(out, is.na(out), asc$NAS)
# Write to disc:
cat(asc$meta, file=file, sep="\n")
write.table(out, file=file, append=TRUE, row.names=FALSE, col.names=FALSE, quote=FALSE, ...)

}
