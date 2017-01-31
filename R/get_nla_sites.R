#' @title Get the NLA sites
#'
#' @description
#' Processes the 2007 and 2012 NLA data to return a unified sites table.
#'
#'
#'
#' @import dplyr
#'
#' @export
get_nla_sites = function(){

  nla2007 = readnlafile('extdata/nla2007/NLA2007_SampledLakeInformation_20091113.csv')
  nla2012 = readnlafile('extdata/nla2012/nla2012_wide_siteinfo_08232016.csv')

  nla2012sites = select(nla2012, LON_DD83, LAT_DD83, COMID2012, SITE_ID, SITEID_07) %>%
    transmute(LON_DD=LON_DD83, LAT_DD=LAT_DD83, COM_ID=COMID2012, SITE_ID, SITEID_07)

  nla2007sites = select(nla2007, LON_DD, LAT_DD, COM_ID, SITE_ID)
  nla2007sites$SITEID_07 = nla2007sites$SITE_ID

  nlasites = bind_rows(nla2007sites, nla2012sites) %>% group_by(COM_ID) %>% slice(1)
  nlasites$MLGA_ID = paste0('COMID_', nlasites$COM_ID)

  return(as.data.frame(nlasites))
}
