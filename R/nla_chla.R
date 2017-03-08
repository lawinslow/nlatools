#' 
#' 
#' 
#' 
#' 
#' 
#' @export
nla_chla = function(){
  
  nla2007 = readnlafile('extdata/nla2007/NLA2007_Chemical_ConditionEstimates_20091123.csv')
  nla2012 = readnlafile('extdata/nla2012/nla2012_chla_wide.csv')
  site2012 = readnlafile('extdata/nla2012/nla2012_wide_siteinfo_08232016.csv') %>% select(UID, SITE_ID)
  
  mut2012 = nla2012 %>% 
    mutate(CHLA=CHLX_RESULT) %>%
    left_join(site2012) %>% select(SITE_ID, CHLA) %>% 
    group_by(SITE_ID) %>% summarize(CHLA=mean(CHLA, na.rm=TRUE))
  
  mut2007 = nla2007 %>% select(SITE_ID, CHLA)
  
  return(rbind(mut2007, mut2012))
}