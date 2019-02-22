.onAttach <- function(libname, pkgname) {
  stop_logging()
}


.onLoad <- function(libname, pkgname){
  rJava::.jpackage(pkgname, lib.loc=libname)
}