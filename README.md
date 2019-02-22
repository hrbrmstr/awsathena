
# awsathena

rJava Interface to AWS Athena SDK

## Description

Provides R wrapper methods to core ‘aws-java-sdk-athena’ Java library
methods to interrogate and orchestrate Amazon Athena queries.

## What’s Inside the Tin?

The following functions are implemented:

  - `collect_async`: Collect Amazon Athena ‘dplyr’ query results
    asynchronously
  - `download_query_execution_results`: Use S3 to download the results
    of an Athena Query
  - `get_query_execution`: Get Query Execution
  - `list_query_executions`: List Query Executions
  - `s3_download_file`: Download a key from a bucket to a local file
  - `start_query_execution`: Start Query Execution
  - `stop_query_execution`: Stop Query Execution

## Installation

``` r
devtools::install_git("git@git.sr.ht:~hrbrmstr/awsathena")
# OR
devtools::install_gitlab("hrbrmstr/awsathena")
# OR
devtools::install_github("hrbrmstr/awsathena")
```

## Usage

``` r
library(rJava)
library(awsathenajars)
library(awsathena)

packageVersion("awsathena")
```

    ## [1] '0.1.0'

### Basics

``` r
qx <- list_query_executions(profile = "personal")

head(qx)
```

    ## [1] "d287b857-5801-493e-a647-76b5cacdac71"
    ## [2] "cbaad9f0-9231-443b-82dc-4cd8c8fad21b"
    ## [3] "8e5d155f-4eda-44fa-b2a4-2245d71b7f41"
    ## [4] "fb1d48d3-6875-4681-b01e-c59a5a33377d"
    ## [5] "cb7d50fb-a2c7-4ada-a4f9-ea35fbbaf764"
    ## [6] "5ddc2339-1987-4890-a521-1cee09b1e291"

``` r
str(get_query_execution(qx[[1]], profile = "personal"), 1)
```

    ## List of 10
    ##  $ workgroup      : chr "primary"
    ##  $ query          : chr "SELECT \"tsday\", \"host\", \"receivedbytes\", \"requestprocessingtime\", \"proto_version\"\nFROM (SELECT \"tim"| __truncated__
    ##  $ context        : chr "sampledb"
    ##  $ statement_type : chr "DML"
    ##  $ state          : chr "SUCCEEDED"
    ##  $ started        : chr "19 Feb 2019 19:11:51 GMT"
    ##  $ completed      : chr "19 Feb 2019 19:11:52 GMT"
    ##  $ output_location: chr "s3://aws-athena-query-results-569593279821-us-east-1/d287b857-5801-493e-a647-76b5cacdac71.csv"
    ##  $ data_scanned   : num 351173
    ##  $ execution_time : num 1142

## `awsathenajars` Metrics

| Lang | \# Files |  (%) | LoC |  (%) | Blank lines |  (%) | \# Lines |  (%) |
| :--- | -------: | ---: | --: | ---: | ----------: | ---: | -------: | ---: |
| R    |       15 | 0.94 | 255 | 0.96 |         101 | 0.84 |      180 | 0.85 |
| Rmd  |        1 | 0.06 |  11 | 0.04 |          19 | 0.16 |       33 | 0.15 |
