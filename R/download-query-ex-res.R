#' Use S3 to download the results of an Athena Query
#'
#' This method is much faster than the paginated interface
#'
#' @md
#' @param qxid query execution id
#' @param output_dir either a full or relative path ([path.expand()] will be run on
#'        the value) to where you want the results to be stored.
#' @param progress show download progress?
#' @param region AWS region string
#' @param profile if not using the default credentials chain or a dedicated
#'        properties file then provide the named profile from `~/.aws/credentials`
#'        you wish to use
#' @param properties_file if not using the default credentials provider chain or
#'        a named profile then provide the path to an Athena credentials proeprty file.
#' @export
download_query_execution_results <- function(qxid,
                                             output_dir,
                                             progress = FALSE,
                                             region = "us-east-1",
                                             profile = NULL,
                                             properties_file = NULL) {

  if (missing(output_dir)) output_dir <- getwd()

  output_dir <- path.expand(output_dir)

  stopifnot(dir.exists(output_dir))

  get_query_execution(
    qxid, region = region, profile = profile, properties_file = properties_file
  ) -> qx_info

  s3_download_file(
    bucket = gsub("^s3://", "", dirname(qx_info$output_location)),
    key = basename(qx_info$output_location),
    output_dir = output_dir,
    progress = progress,
    region = region,
    profile = profile,
    properties_file = properties_file
  ) -> res

  message("Results saved to ", res)

  invisible(res)

}
