#' @title rJava logging
#' @description Toggle verbose rJava logging
#' @note This resets a global Java setting and may affect logging of other rJava operations,
#'       requiring a restart of R.
#' @return `NULL`, invisibly.
#' @author Thomas J. Leeper <thosjleeper@@gmail.com>
#' @noRd
#' @md
#' @examples
#' \dontrun{
#' stop_logging()
#' }
stop_logging <- function() {
  rJava::J("java.util.logging.LogManager")$getLogManager()$reset()
  invisible(NULL)
}