#' @title Get the NLA sites
#'
#' @description
#' Processesthe 2007 and 2012 NLA data to return a unified sites table.
#'
#'
#'
#' @import dplyr
#'
#' @export
get_nla_sites = function(){

  nla2007 = read.table(system.file('extdata/nla2007/NLA2007_SampledLakeInformation_20091113.csv', package=packageName()), sep=',', header=TRUE, comment.char = '', quote='\"', as.is=TRUE)
  nla2012 = read.table(system.file('extdata/nla2012/nla2012_wide_siteinfo_08232016.csv', package=packageName()), sep=',', header=TRUE, quote='\"', as.is=TRUE)

  nla2012sites = select(nla2012, LON_DD83, LAT_DD83, COMID2007, SITE_ID) %>% transmute(LON_DD=LON_DD83, LAT_DD=LAT_DD83, COM_ID=COMID2007, SITE_ID)
  nla2007sites = select(nla2007, LON_DD, LAT_DD, COM_ID, SITE_ID)

  nlasites = bind_rows(nla2007sites, nla2012sites) %>% group_by(COM_ID) %>% slice(1)
  nlasites$MLGA_ID = paste0('COMID_', nlasites$COM_ID)

  return(as.data.frame(nlasites))
}
