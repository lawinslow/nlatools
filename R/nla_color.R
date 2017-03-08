#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' @export
nla_color = function(){
  nla2007 = readnlafile('extdata/nla2007/NLA2007_WaterQuality_20091123.csv')
  nla2012 = readnlafile('extdata/nla2012/nla2012_waterchem_wide.csv')
  
  site2012 = readnlafile('extdata/nla2012/nla2012_wide_siteinfo_08232016.csv') %>% select(UID, SITE_ID)
  
  
  mut2007 = nla2007 %>% select(SITE_ID, COLOR)
  
  mut2012 = nla2012 %>% 
    mutate(COLOR=COLOR_RESULT) %>%
    left_join(site2012) %>% select(SITE_ID, COLOR)
  
  return(rbind(mut2007, mut2012))
}