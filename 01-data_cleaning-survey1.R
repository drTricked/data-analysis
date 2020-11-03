#### Preamble ####
# Purpose: Prepare and clean the survey data downloaded from [...UPDATE ME!!!!!]
# Author: Mark Sabado
# Data: 22 October 2020
# Contact: markdavid.sabado@mail.utoronto.ca [PROBABLY CHANGE THIS ALSO!!!!]
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the data from X and save the folder that you're 
# interested in to inputs/data 
# - Don't forget to gitignore it!


#### Workspace setup ####
library(haven)
library(tidyverse)
setwd("C:/Users/markd/OneDrive/Documents/sta304/a3/a3")
# Read in the raw data (You might need to change this if you use a different dataset)
raw_data <- read_dta("inputs/ns20200625/ns20200625.dta")
# Add the labels
raw_data <- labelled::to_factor(raw_data)
# Just keep some variables
reduced_data <- 
  raw_data %>% 
  select(interest,
         registration,
         vote_2016,
         vote_intention,
         vote_2020,
         ideo5,
         employment,
         foreign_born,
         gender,
         census_region,
         hispanic,
         race_ethnicity,
         household_income,
         education,
         state,
         congress_district,
         age)


#### What else???? ####
# Maybe make some age-groups?
# Maybe check the values?
# Is vote a binary? If not, what are you going to do?

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
  rename(
    race = race_ethnicity,
    sex = gender
  )

reduced_data<-
  reduced_data %>%
  mutate(race = ifelse(race == "White", "white", 
               ifelse(race == "Black, or African American", "black/african american/negro",
               ifelse(race == "Asian (Chinese)", "chinese",
               ifelse(race == "Asian (Japanese)", "japanese",
               ifelse(race == "American Indian or Alaska Native", "american indian or alaska native",
               ifelse(race == "Some other race", "other race, nec",
               ifelse(race == "two major races", "two major races",
               ifelse(race == "three or more major races", "three or more major races",
                              "other asian or pacific islander"
                               )))))))))



reduced_data<-
  reduced_data %>%
  mutate(sex = ifelse(sex == "Male", "male", "female"))



reduced_data<-
  reduced_data %>%
  mutate(vote_trump = 
           ifelse(vote_2020=="Donald Trump", 1, 0))

reduced_data<-
  reduced_data %>%
  mutate(vote_biden = 
           ifelse(vote_2020=="Joe Biden", 1, 0))

# Saving the survey/sample data as a csv file in my
# working directory
write_csv(reduced_data, "outputs/survey_data.csv")

summary(reduced_data)
