#' @title NLA file read helper function
#'
#'
#'
#' @export
readnlafile = function(fname){

  if(is.null(packageName())){
    return(read.table(system.file(fname, package=packageName()), sep=',', header=TRUE, comment.char = '', quote='\"', as.is=TRUE))
  }else{
    return(read.table(system.file(fname, package=packageName()), sep=',', header=TRUE, comment.char = '', quote='\"', as.is=TRUE))
  }

}
