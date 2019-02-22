#' List Query Executions
#'
#' @md
#' @param region AWS region string
#' @param profile if not using the default credentials chain or a dedicated
#'        properties file then provide the named profile from `~/.aws/credentials`
#'        you wish to use
#' @param properties_file if not using the default credentials provider chain or
#'        a named profile then provide the path to an Athena credentials proeprty file.
#' @param max maximum number of query execution ids to return. If `NULL` only the
#'        most recent query execution ids will be returned. Otherwise sufficient
#'        iterations of a call to the paginated API will be made to retrieve `max`
#'        values. Note that the final total number of returned query execution ids
#'        may be more or less than `max` depending on the number of paginated
#'        results and no attempt will be made to truncate to `max`.
#' @export
list_query_executions <- function(region = "us-east-1", profile = NULL, properties_file = NULL, max = NULL) {

  client <- aws_athena_client(region = region, profile = profile, properties_file = properties_file)

  qx_req <- .jnew("com.amazonaws.services.athena.model.ListQueryExecutionsRequest")

  res <- client$listQueryExecutions(qx_req)
  qxids <- res$getQueryExecutionIds()
  out <- vapply(as.list(qxids), .jsimplify, character(1))

  if (!is.null(max)) {

    repeat {

      if (max <= length(out)) break
      if (is.jnull(res$getNextToken())) break

      res <- client$listQueryExecutions(qx_req$withNextToken(res$getNextToken()))

      qxids <- res$getQueryExecutionIds()

      out <- c(out, vapply(as.list(qxids), .jsimplify, character(1)))

    }

  }

  client$shutdown()

  out

}
