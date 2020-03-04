#' Download a key from a bucket to a local file
#'
#' @md
#' @param bucket,key S3 bucket and key (no `s3://` prefix)
#' @param output_dir where to store `key`
#' @param progress show download progress?
#' @param region AWS region string
#' @param profile if not using the default credentials chain or a dedicated
#'        properties file then provide the named profile from `~/.aws/credentials`
#'        you wish to use
#' @param buffer_size S3 temp buffer size; bigger = faster d/l
#' @param properties_file if not using the default credentials provider chain or
#'        a named profile then provide the path to an Athena credentials proeprty file.
#' @export
s3_download_file <- function(bucket, key, output_dir,
                             progress = FALSE,
                             region = "us-east-1",
                             profile = NULL,
                             buffer_size = 16384L,
                             properties_file = NULL) {

  aws_s3_client(
    region = region, profile = profile, properties_file = properties_file
  ) -> client

  obj <- client$getObject(bucket, key)
  meta <- obj$getObjectMetadata()

  total_size <- meta$getContentLength()
  utils::txtProgressBar(
    min = 0, max = total_size, initial = 0,
    title = "S3 download progress", label = key
  ) -> pb

  outpath <- file.path(path.expand(output_dir), key)

  s3is <- obj$getObjectContent()

  buf <- raw(buffer_size)
  jbuf <- .jarray(buf)

  read_len <- s3is$read(jbuf)

  so_far <- 0

  outfile <- file(outpath, open = "w+b")

  repeat {

    if (read_len <= 0) break

    outbuf <- .jevalArray(jbuf)
    outbuf <- outbuf[1:read_len]

    writeBin(object = outbuf, con = outfile, size = 1, useBytes = TRUE)

    so_far <- so_far + read_len

    if (progress) utils::setTxtProgressBar(pb, so_far)

    read_len <- s3is$read(jbuf)

  }

  if (progress) close(pb)

  s3is$close()

  close(outfile)

  client$shutdown()

  invisible(outpath)

}
