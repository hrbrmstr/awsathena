.properties_file_creds <- function(props_path) {

  props_path <- path.expand(props_path)
  if (!file.exists(props_path)) {
    stop(sprintf("%s file does not exist.", props_path), call.=FALSE)
  }

  .jnew(
    class = "com.amazonaws.auth.PropertiesFileCredentialsProvider",
    props_path # credentialsFilePath
  ) -> properties_file_creds

}

.jawsregion <- function(reg = "us-east-1") {
  regions <- J("com.amazonaws.regions.Regions")
  reg <- toupper(gsub("-", "_", reg, fixed=TRUE))
  switch(reg,
    "US_GOV_EAST_1" = regions$US_GOV_EAST_1,
    "US_EAST_1" = regions$US_EAST_1,
    "US_EAST_2" = regions$US_EAST_2,
    "US_WEST_1" = regions$US_WEST_1,
    "US_WEST_2" = regions$US_WEST_2,
    "EU_WEST_1" = regions$EU_WEST_1,
    "EU_WEST_2" = regions$EU_WEST_2,
    "EU_WEST_3" = regions$EU_WEST_3,
    "EU_CENTRAL_1" = regions$EU_CENTRAL_1,
    "EU_NORTH_1" = regions$EU_NORTH_1,
    "AP_SOUTH_1" = regions$AP_SOUTH_1,
    "AP_SOUTHEAST_1" = regions$AP_SOUTHEAST_1,
    "AP_SOUTHEAST_2" = regions$AP_SOUTHEAST_2,
    "AP_NORTHEAST_1" = regions$AP_NORTHEAST_1,
    "AP_NORTHEAST_2" = regions$AP_NORTHEAST_2,
    "SA_EAST_1" = regions$SA_EAST_1,
    "CN_NORTH_1" = regions$CN_NORTH_1,
    "CN_NORTHWEST_1" = regions$CN_NORTHWEST_1,
    "CA_CENTRAL_1" = regions$CA_CENTRAL_1,
    "DEFAULT" = regions$DEFAULT_REGION,
    stop("No such region.", call.=FALSE)
  )
}
