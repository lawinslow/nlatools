#' @title NLA profiles
#'
#'
#' @description
#' Returns lake profile data for NLA dataset. Includes DO, Temp, and pH.
#'
#'
#' @import dplyr
#' @importFrom lubridate mdy dmy
#'
#' @export
nla_profiles = function(){
  prof7  = readnlafile('extdata/nla2007/NLA2007_Profile_20091008.csv')
  prof12 = readnlafile('extdata/nla2012/nla2012_wide_profile_08232016.csv')

  clean7 = prof7 %>% mutate(DATE=DATE_PROFILE, OXYGEN=DO_FIELD, PH=PH_FIELD, TEMP=TEMP_FIELD) %>%
    select(SITE_ID, DATE, DEPTH, OXYGEN, PH, TEMP)

  clean7$DATE = lubridate::mdy(clean7$DATE)

  clean12 = prof12 %>% mutate(DATE=DATE_COL, TEMP=TEMPERATURE) %>% select(SITE_ID, DATE, DEPTH, OXYGEN, PH, TEMP)
  clean12$DATE = lubridate::dmy(clean12$DATE)

  clean7$survey  = 2007
  clean12$survey = 2012
  bothdata = rbind(clean7, clean12)
  cleanprof = subset(bothdata, !is.na(DEPTH) & !is.na(DATE))

  #there are some obvious outliers I am going to drop
  cleanprof = subset(cleanprof, TEMP < 40 & DEPTH < 200)

  return(cleanprof)
}
