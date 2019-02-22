aws_athena_client <- function(region = "us-east-1", profile = NULL, properties_file = NULL) {

  regions <- J("com.amazonaws.regions.Regions")

  default_creds <- J(class = "com.amazonaws.auth.DefaultAWSCredentialsProviderChain")

  client_builder <- .jnew("com.amazonaws.services.athena.AmazonAthenaClientBuilder")

  builder <- client_builder$standard()
  builder <- builder$withRegion(.jawsregion(region))

  if (!is.null(profile)) {
    builder <- builder$withCredentials(
      .jnew("com.amazonaws.auth.profile.ProfileCredentialsProvider", profile)
    )
  } else if (!is.null(properties_file)) {
    builder <- builder$withCredentials(properties_file)
  } else {
    builder <- builder$withCredentials(default_creds$getInstance())
  }

  client <- builder$build()

}

aws_s3_client <- function(region = "us-east-1", profile = NULL, properties_file = NULL) {

  regions <- J("com.amazonaws.regions.Regions")

  default_creds <- J(class = "com.amazonaws.auth.DefaultAWSCredentialsProviderChain")

  client_builder <- .jnew("com.amazonaws.services.s3.AmazonS3ClientBuilder")

  builder <- client_builder$standard()
  builder <- builder$withRegion(.jawsregion(region))

  if (!is.null(profile)) {
    builder <- builder$withCredentials(
      .jnew("com.amazonaws.auth.profile.ProfileCredentialsProvider", profile)
    )
  } else if (!is.null(properties_file)) {
    builder <- builder$withCredentials(properties_file)
  } else {
    builder <- builder$withCredentials(default_creds$getInstance())
  }

  client <- builder$build()

}
