#' @title Lake physical morphology
#'
#' @description
#' Combine and return max observed depth and lake area from the NLA lakes
#'
#'
#'
#' @export
get_morpho = function(){

  nla7 = readnlafile('extdata/nla2007/NLA2007_SampledLakeInformation_20091113.csv')
  nla7$survey=2007

  #2012 data are harder to deal with, uggh
  nla12 = readnlafile('extdata/nla2012/nla2012_wide_phab_08232016_0.csv')
  profile12 = readnlafile('extdata/nla2012/nla2012_wide_profile_08232016.csv')

  nla12area = readnlafile('extdata/nla2012/nla2012_wide_siteinfo_08232016.csv')

  #tmp = group_by(profile, SITE_ID) %>% summarize(DEPTHMAX=max(DEPTH, na.rm=TRUE))

  phabdepth = group_by(nla12, SITE_ID) %>% summarize(DEPTHMAX = max(DEPTH_AT_STATION, na.rm=TRUE))
  profdepth = group_by(profile12, SITE_ID) %>% summarize(DEPTHMAX = max(DEPTH, na.rm=TRUE))


  nla12 = rbind(phabdepth, profdepth) %>% group_by(SITE_ID) %>% summarize(DEPTHMAX = max(DEPTHMAX, na.rm=TRUE)) %>%
    right_join(nla12area, by='SITE_ID') %>% select(SITE_ID, DEPTHMAX, AREA_HA)

  nla12$survey = 2012

  nla7 = nla7 %>% select(SITE_ID, DEPTHMAX, AREA_HA, survey)

  return(merge(get_nla_sites(), rbind(nla12, nla7), by='SITE_ID'))
}
