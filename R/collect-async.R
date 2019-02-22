#' Collect Amazon Athena `dplyr` query results asynchronously
#'
#' Long running Athena queries and Athena queries with large result
#' sets can seriously stall a `dplyr` processing chain due to poorly
#' implemented ODBC and JDBC drivers. This function converts a `dplyr`
#' chain to a raw SQL query then submits it via [start_query_execution()] and
#' returns the query execution id. You can retrieve the result set either
#' via [download_query_execution_results()] or your favorite S3 downloading
#' method.
#'
#' @md
#' @param obj the `dplyr` query
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
#' @note `dbplyr` must be installed for this to work. It is not listed in
#'       the `Imports` as it brings with it many dependencies that may not
#'       be necessary for general use of this package.
#' @export
#' @examples \dontrun{
#' library(odbc)
#' library(DBI)
#'
#' DBI::dbConnect(
#'   odbc::odbc(),
#'   driver = "/Library/simba/athenaodbc/lib/libathenaodbc_sbu.dylib",
#'   Schema = "sampledb",
#'   AwsRegion = "us-east-1",
#'   AwsProfile = "personal",
#'   AuthenticationType = "IAM Profile",
#'   S3OutputLocation = "s3://aws-athena-query-results-redacted"
#' ) -> con
#'
#' elb_logs <- tbl(con, "elb_logs")
#'
#' mutate(elb_logs, tsday = substr(timestamp, 1, 10)) %>%
#'   filter(tsday == "2014-09-29") %>%
#'   select(requestip, requestprocessingtime) %>%
#'   collect_async(
#'     database = "sampledb",
#'     output_location = "s3://aws-athena-query-results-redacted",
#'     profile = "personal"
#'   ) -> id
#'
#' get_query_execution(id, profile = "personal")
#'
#' # do this to get the data or use your favorite way to grab files from S3
#' get_query_results(id, profile = "personal")
#' }
collect_async <- function(obj,
                          database,
                          output_location,
                          client_request_token = uuid::UUIDgenerate(),
                          encryption_option = NULL,
                          kms_key = NULL,
                          region = "us-east-1",
                          profile = NULL,
                          properties_file = NULL) {

  if (!requireNamespace("dbplyr", quietly = TRUE)) {
    stop("dbplyr package required for this function", call. = FALSE)
  } else {
    start_query_execution(
      query = as.character(dbplyr::sql_render(obj)),
      database = database,
      output_location = output_location,
      client_request_token = client_request_token,
      encryption_option = encryption_option,
      kms_key = kms_key,
      region = region,
      profile = profile,
      properties_file = properties_file
    )
  }

}