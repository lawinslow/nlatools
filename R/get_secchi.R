#' @title Get secchi data
#'
#' @description
#' Processes the 2007 and 2012 NLA secchi data to return a unified secchi dataset
#'
#'
#' @import dplyr
#'
#' @export
get_secchi = function(){
  nla7 = readnlafile('extdata/nla2007/NLA2007_Secchi_20091008.csv')
  nla12 = readnlafile('extdata/nla2012/nla2012_secchi_08232016.csv')

  nla12 = nla12 %>% mutate(SECMEAN = SECCHI, datetime=DATE_COL) %>% select(SITE_ID, datetime, SECMEAN)
  nla7  = nla7 %>% mutate(datetime=DATE_SECCHI) %>% select(SITE_ID, datetime, SECMEAN)


  return(merge(get_nla_sites(), rbind(nla12, nla7), by='SITE_ID'))
}
