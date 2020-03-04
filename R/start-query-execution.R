#' Start Query Execution
#'
#' @md
#' @param query SQL query statements to be executed
#' @param database database within which the query executes.
#' @param output_location location in S3 where query results are stored.
#' @param client_request_token unique case-sensitive string used to ensure the
#'        request to create the query is idempotent (executes only once). If another
#'        `StartQueryExecution` request is received, the same response is returned
#'        and another query is not created. If a parameter has changed, for example,
#'        the `query` , an error is returned. **This is auto-generated-for-you**.
#' @param encryption_option indicates whether Amazon S3 server-side encryption
#'        with Amazon S3-managed keys (`SSE-S3`), server-side encryption with
#'        KMS-managed keys (`SSE-KMS`), or client-side encryption with KMS-managed
#'        keys (`CSE-KMS`) is used. Default is `NULL` (no encryption)
#' @param kms_key For `SSE-KMS` and `CSE-KMS`, this is the KMS key ARN or ID.
#'        Default is `NULL` (no encryption)
#' @param region AWS region string
#' @param profile if not using the default credentials chain or a dedicated
#'        properties file then provide the named profile from `~/.aws/credentials`
#'        you wish to use
#' @param properties_file if not using the default credentials provider chain or
#'        a named profile then provide the path to an Athena credentials proeprty file.
#' @param workgroup workgroup
#' @export
start_query_execution <- function(query, database, output_location,
                                  client_request_token = uuid::UUIDgenerate(),
                                  encryption_option = NULL,
                                  kms_key = NULL,
                                  region = "us-east-1",
                                  profile = NULL,
                                  properties_file = NULL,
                                  workgroup = "primary") {

  client <- aws_athena_client(region = region, profile = profile, properties_file = properties_file)

  ctx <- .jnew("com.amazonaws.services.athena.model.QueryExecutionContext")
  ctx <- ctx$withDatabase(database)

  res_cfg <- .jnew("com.amazonaws.services.athena.model.ResultConfiguration")
  res_cfg <- res_cfg$withOutputLocation(output_location)

  qx_req <- .jnew("com.amazonaws.services.athena.model.StartQueryExecutionRequest")
  qx_req <- qx_req$withQueryString(query)
  qx_req <- qx_req$withQueryExecutionContext(ctx)
  qx_req <- qx_req$withResultConfiguration(res_cfg)
  qx_req <- qx_req$withClientRequestToken(client_request_token)
  qx_req <- qx_req$withWorkGroup(workgroup)

  res <- client$startQueryExecution(qx_req)

  out <- res$getQueryExecutionId()

  client$shutdown()

  out

}
