% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get-query-results-meta.R
\name{get_query_results_metadata}
\alias{get_query_results_metadata}
\title{Get Query Execution Results Metadata (Schema)}
\usage{
get_query_results_metadata(
  qxid,
  region = "us-east-1",
  profile = NULL,
  properties_file = NULL
)
}
\arguments{
\item{qxid}{query execution id}

\item{region}{AWS region string}

\item{profile}{if not using the default credentials chain or a dedicated
properties file then provide the named profile from \verb{~/.aws/credentials}
you wish to use}

\item{properties_file}{if not using the default credentials provider chain or
a named profile then provide the path to an Athena credentials proeprty file.}
}
\description{
Get Query Execution Results Metadata (Schema)
}
