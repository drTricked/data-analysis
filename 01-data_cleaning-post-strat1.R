#### Preamble ####
# Purpose: Prepare and clean the survey data downloaded from [...UPDATE ME!!!!!]
# Author: Mark Sabado
# Data: 22 October 2020
# Contact: markdavid.sabado@mail.utoronto.ca [PROBABLY CHANGE THIS ALSO!!!!]
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the ACS data and saved it to inputs/data
# - Don't forget to gitignore it!


#### Workspace setup ####
library(haven)
library(tidyverse)
# Read in the raw data.
setwd("C:/Users/markd/OneDrive/Documents/sta304/a3/a3")
raw_data <- read_dta("inputs/usa_00001.dta.gz")


# Add the labels
raw_data <- labelled::to_factor(raw_data)

# Just keep some variables that may be of interest (change 
# this depending on your interests)
reduced_data <- 
  raw_data %>% 
  select(#region,
         #stateicp,
         sex, 
         age,
         race) 
         #hispan,
         #bpl,
         #educd,
         #empstat)
         #inctot,
         #ftotinc)
         

#### What's next? ####

## Here I am only splitting cells by age, but you 
## can use other variables to split by changing
## count(age) to count(age, sex, ....)

reduced_data <- 
  reduced_data %>% 
  filter(age != "less than 1 year old") %>%
  filter(age != "90 (90+ in 1980 and 1990)") %>%
  filter(race != "two major races") %>%
  filter(race != "three or more major races")

reduced_data$age <- as.integer(reduced_data$age)

reduced_data<-
  reduced_data %>%
  mutate(age = ifelse(age < 20, "<20", 
               ifelse(age < 30, "20-29",
               ifelse(age < 40, "30-39",
               ifelse(age < 50, "40-49",
               ifelse(age < 60, "50-59",
               ifelse(age < 70, "60-69",
               ifelse(age < 80, "70-79",
                                "80+"
                                ))))))))

reduced_data <- 
  reduced_data %>%
  count(sex, age, race) %>%
  group_by(sex, age, race)
    # count(stateicp,
    #       sex, 
    #       age, 
    #       race, 
    #       hispan,
    #       bpl,
    #       educd,
    #       empstat) %>%
    # group_by(stateicp,
    #          sex, 
    #          age, 
    #          race, 
    #          hispan,
    #          bpl,
    #          educd,
    #          empstat) 

  reduced_data %>%
  count(race) %>%
  group_by(race)

# Saving the census data as a csv file in my
# working directory
write_csv(reduced_data, "outputs/census_data.csv")



         