#' Get Query Execution Results Metadata (Schema)
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
get_query_results_metadata <- function(qxid, region = "us-east-1", profile = NULL, properties_file = NULL) {

  client <- aws_athena_client(region = region, profile = profile, properties_file = properties_file)

  qx_req <- .jnew("com.amazonaws.services.athena.model.GetQueryResultsRequest")
  qx_req$setQueryExecutionId(qxid)
  qx_req$setMaxResults(.jnew(class = "java/lang/Integer", "1"))

  res <- client$getQueryResults(qx_req)
  res_rs <- res$getResultSet()
  res_md <- res_rs$getResultSetMetadata()
  res_ci <- res_md$getColumnInfo()

  lapply(res_ci, function(.x) {
    data.frame(
      name = .x$getName(),
      type = .x$getType(),
      caseSensitive = .x$getCaseSensitive(),
      catalogName = .x$getCatalogName(),
      label = .x$getLabel(),
      nullable = .x$getNullable(),
      precision = .x$getPrecision(),
      scale = .x$getScale(),
      schemaName = .x$getSchemaName(),
      tableName = .x$getTableName(),
      stringsAsFactors = FALSE
    )
  }) %>%
    do.call(rbind.data.frame, .) -> out

  class(out) <- c("athena_query_metadata", "tbl_df", "tbl", "data.frame")

  client$shutdown()

  out

}
