#' @title Get Lake Chemistry Data
#'
#' @description
#' Returns unified lake chemistry data.
#'
#'
#'
#'
#' @export
nla_chemistry = function(){
  nla2007 = readnlafile('extdata/nla2007/NLA2007_Chemical_ConditionEstimates_20091123.csv')
  nla2012 = readnlafile('extdata/nla2012/nla2012_waterchem_wide.csv')

  site2012 = readnlafile('extdata/nla2012/nla2012_wide_siteinfo_08232016.csv') %>% select(UID, SITE_ID)

  mut2007 = nla2007 %>% select(SITE_ID, ANC, COND, DOC, NTL, PTL, TURB) %>% mutate(TSS=NA)
  mut2012 = nla2012 %>%
    mutate(ANC=ANC_RESULT, COND=COND_RESULT, DOC=DOC_RESULT, NTL=NTL_RESULT*1000, PTL=PTL_RESULT, TURB=TURB_RESULT, COLOR=COLOR_RESULT, TSS=TSS_RESULT) %>%
    left_join(site2012) %>% select(SITE_ID, ANC, COND, DOC, NTL, PTL, TURB, TSS)

  return(merge(rbind(mut2007, mut2012), get_nla_sites(), by='SITE_ID'))
}
