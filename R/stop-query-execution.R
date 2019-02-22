#' Stop Query Execution
#'
#' @md
#' @param qxid query execution id
#' @param region AWS region string
#' @param profile if not using the default credentials chain or a dedicated
#'        properties file then provide the named profile from `~/.aws/credentials`
#'        you wish to use
#' @param properties_file if not using the default credentials provider chain or
#'        a named profile then provide the path to an Athena credentials proeprty file.
#' @export
stop_query_execution <- function(qxid, region = "us-east-1", profile = NULL, properties_file = NULL) {

  client <- aws_athena_client(region = region, profile = profile, properties_file = properties_file)

  qx_req <- .jnew("com.amazonaws.services.athena.model.StopQueryExecutionRequest")
  qx_req <- qx_req$withQueryExecutionId(qxid)

  res <- client$stopQueryExecution(qx_req)

  qx_req <- .jnew("com.amazonaws.services.athena.model.GetQueryExecutionRequest")
  qx_req <- qx_req$withQueryExecutionId(qxid)

  res <- client$getQueryExecution(qx_req)

  out <- res$getQueryExecution()$getStatus()$getState()

  client$shutdown()

  out

}
