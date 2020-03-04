#' Translate from one type system to another
#'
#' @param type type (character)
#' @param to one of `athena` or `r`
#' @export
athena_type_trans <- function(type, to = c("r", "athena")) {
  if (match.arg(tolower(to[1]), c("athena", "r")) == "r") {
    sapply(type, switch,
           type,
           boolean = "logical",
           tinyint = "integer",
           smallint = "integer",
           int = "integer",
           integer = "integer",
           bigint = "integer64",
           double = "double",
           float = "double",
           decimal = "double",
           char = "character",
           varchar = "character",
           binary = "raw",
           date = "Date",
           timestamp = "POSIXct",
           array = "character",
           map = "character",
           struct = "character"
    )
  } else {
    sapply(
      type, switch,
      logical = "boolean",
      integer = "integer",
      integer64 = "bigint",
      double = "double",
      character = "varchar",
      raw = "binary",
      Date = "date",
      POSIXct = "timestamp"
    )
  }
}

#' @rdname athena_type_trans
#' @param name,type equal length character vectors; type should be an R type
#' @export
to_cols <- function(name, type) {

  lapply(
    type, switch,
    logical = readr::col_logical(),
    integer = readr::col_integer(),
    integer64 = readr::col_number(),
    double = readr::col_double(),
    character = readr::col_character(),
    raw = readr::col_character(),
    Date = readr::col_date(),
    POSIXct = readr::col_datetime()
  ) -> l

  l <- set_names(l)

  do.call(readr::cols, l)

}

