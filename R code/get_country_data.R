##############################
##     Data engineering     ##
##       Term project       ##
##                          ##
##                          ##
##  Getting and cleaning    ##
##      data from WDI       ##
##############################


# Clear memory
rm(list=ls())

# Call packages
#install.packages('WDI')
library(WDI)
#install.package('tidyverse')
library(tidyverse)

my_path <- '~/Documents/CEU/Fall_semester/Data_engineering_2/CEU-Data_Engineering2/'


# WDI is an API

# Find the indicators of the data I need
# Search for: GDP + something + capita + something + constant, and population + total
a <- WDIsearch('gdp.*capita.*constant') # indicator will be NY.GDP.PCAP.PP.KD
b <- WDIsearch('population, total') # SP.POP.TOTL
rm(a,b)

# Get all the data - in 2018 
df <- WDI(indicator=c('NY.GDP.PCAP.PP.KD', 'SP.POP.TOTL'), 
                country="all", start=2018, end=2018)


## Check the observations:
#   Lot of grouping observations
#     usually contains a number
d1 <- df %>% filter(grepl("[[:digit:]]", df$iso2c))
d1
rm(d1)


# Filter these out
df <- df %>% filter( !grepl("[[:digit:]]", df$iso2c) )

# Some grouping observations are still there, check each of them
#   HK - Hong Kong, China
#   OE - OECD members
#   all with starting X, except XK which is Kosovo
#   all with starting Z, except ZA-South Africa, ZM-Zambia and ZW-Zimbabwe

# 1st drop specific values
drop_id <- c("EU","HK","OE")
# Check for filtering
df %>% filter( grepl( paste( drop_id , collapse="|"), df$iso2c ) ) 
# Save the opposite
df <- df %>% filter( !grepl( paste( drop_id , collapse="|"), df$iso2c ) ) 

# 2nd drop values with certain starting char
# Get the first letter from iso2c
fl_iso2c <- substr(df$iso2c, 1, 1)
retain_id <- c("XK","ZA","ZM","ZW")
# Check
d1 <- df %>% filter( grepl( "X", fl_iso2c ) | grepl( "Z", fl_iso2c ) & 
                       !grepl( paste( retain_id , collapse="|"), df$iso2c ) ) 
# Save observations which are the opposite (use of !)
df <- df %>% filter( !( grepl( "X", fl_iso2c ) | grepl( "Z", fl_iso2c ) & 
                          !grepl( paste( retain_id , collapse="|"), df$iso2c ) ) ) 

# Clear non-needed variables
rm( d1 , drop_id, fl_iso2c , retain_id )

### 
# Check for missing observations
m <- df %>% filter( !complete.cases( df ) )
# Drop if gdp or total population missing 
df <- df %>% filter( complete.cases( df ) | is.na( df$iso2c ) )
rm(m)

###
# CLEAN VARIABLES
#
# Recreate table:
#   Rename variables 
#   Drop all the others !! in this case write into readme it is referring to year 2018!!
df <-df %>% transmute( 
  Country_code = iso2c,
  country = country,
  population=SP.POP.TOTL,
  gdppc=NY.GDP.PCAP.PP.KD)

write_csv(df, paste0(my_path,'data/Population_GDP.csv'))

