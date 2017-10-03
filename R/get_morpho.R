#' @title Lake physical morphology
#'
#' @description
#' Combine and return max observed depth and lake area from the NLA lakes
#'
#'
#' @note
#' For NLA2012, no DEPTHMAX column was supplied. Here it is estimated in the
#' same way as NLA2007, which basically looks at the maximum observed depth in
#' the profile data
#'
#' Personal Communication with A. Pollard
#' \emph{The field crews locate the max depth that they encounter in 30 minutes
#' on the lake. If folks have lake maps or other bathymetry information, this
#' really might be the maximum depth. In other lakes, the crews are simply looking
#' for the deepest area that they encounter in their 30 minute foray around the
#' lake. For this reason, I thought that a column marked as max depth was misleading
#' and it was not included in the NLA 2012 files. It looks like they left the files
#' in roughly the same format as the data sheets}
#'
#'
#' @export
get_morpho = function(){

  nla7 = readnlafile('extdata/nla2007/NLA2007_SampledLakeInformation_20091113.csv')

  # there are multiple visits which show up as duplicates. taking max to drop dups
  nla7 = nla7 %>% group_by(SITE_ID) %>% summarize(DEPTHMAX=max(DEPTHMAX, na.rm=TRUE), AREA_HA=median(AREA_HA, na.rm=TRUE), survey=2007) %>%
    select(SITE_ID, DEPTHMAX, AREA_HA, survey)


  #2012 data are harder to deal with due to the point made in the documentation note
  nla12 = readnlafile('extdata/nla2012/nla2012_wide_phab_08232016_0.csv')
  profile12 = readnlafile('extdata/nla2012/nla2012_wide_profile_08232016.csv')

  nla12area = readnlafile('extdata/nla2012/nla2012_wide_siteinfo_08232016.csv')
  nla12area = nla12area %>% group_by(SITE_ID) %>% summarize(AREA_HA=median(AREA_HA, na.rm=TRUE))
  #tmp = group_by(profile, SITE_ID) %>% summarize(DEPTHMAX=max(DEPTH, na.rm=TRUE))

  phabdepth = group_by(nla12, SITE_ID) %>% summarize(DEPTHMAX = max(DEPTH_AT_STATION, na.rm=TRUE))
  profdepth = group_by(profile12, SITE_ID) %>% summarize(DEPTHMAX = max(DEPTH, na.rm=TRUE))


  nla12 = rbind(phabdepth, profdepth) %>% group_by(SITE_ID) %>% summarize(DEPTHMAX = max(DEPTHMAX, na.rm=TRUE)) %>%
    left_join(nla12area, by='SITE_ID') %>% select(SITE_ID, DEPTHMAX, AREA_HA)

  nla12$survey = 2012


  return(merge(get_nla_sites(), rbind(nla12, nla7), by='SITE_ID'))
}
