#' Check list elements
#' 
#' Check list elements. Unexported function, documented for reference.
#' 
#' @return Nothing
#' @author Berry Boessenkool, \email{berry-b@@gmx.de}, March 2017
# @export
#' 
#' @param list  List object.
#' @param \dots Elements that should be checked for presence.
#' 
check_list_elements <- function(
 list,
  ...)
{
lname <- deparse(substitute(list))
elems <- unlist(list(...))
elems <- elems[elems!=""]
notin <- ! elems %in% names(list)
if(any(notin)) stop(lname, " list does not contain the element", if(sum(notin)>1) "s",
                    " ", toString(elems[notin]), ".", call.=FALSE)
}
