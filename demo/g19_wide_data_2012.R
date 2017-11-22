## Prep wide NLA data for GLEON 19
library(dplyr)
library(nlatools)

tox = read.table('inst/extdata/nla2012/nla2012_algaltoxins_08192016.csv', sep=',', header=TRUE)
chla = read.table('inst/extdata/nla2012/nla2012_chla_wide.csv', sep=',', header=TRUE)
secchi = read.table('inst/extdata/nla2012/nla2012_secchi_08232016.csv', sep=',', header=TRUE)
chem = read.table('inst/extdata/nla2012/nla2012_waterchem_wide.csv', sep=',', header=TRUE)
prof = readnlafile('extdata/nla2012/nla2012_wide_profile_08232016.csv')

site2012 = readnlafile('extdata/nla2012/nla2012_wide_siteinfo_08232016.csv') %>% select(UID, SITE_ID)

morpho = nlatools::get_morpho()



### toxins 
tox_thin    = tox %>% select(UID, MICL_RESULT, MICX_RESULT)
chla_thin   = chla %>% select(UID, CHLX_RESULT, CHLL_RESULT)
secchi_thin = secchi %>% select(UID, SECCHI)
chem_thin   = chem %>% select(UID, ends_with('_RESULT'))
site_thin   = 
prof_surf   = prof %>% filter(SAMPLE_TYPE!='CALIB') %>% select(UID, TEMPERATURE, PH, OXYGEN, CONDUCTIVITY, DEPTH) %>%
  group_by(UID) %>% slice(which.min(DEPTH))

prof_deep   = prof %>% filter(SAMPLE_TYPE!='CALIB') %>% select(UID, TEMPERATURE, PH, OXYGEN, CONDUCTIVITY, DEPTH) %>%
  group_by(UID) %>% slice(which.max(DEPTH))


