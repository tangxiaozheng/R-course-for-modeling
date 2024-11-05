### Working with data

## Reading data
#reading data from a file
b_pressure_dat <- read.csv("data/blood_pressure.csv", header = TRUE)
b_type_dat <- read.table("data/blood_types.txt", sep = ";", header = TRUE)

#reading from an excel file
#here is the data from the case example, very messy!
library(readxl)
aki_raw <- read_excel("data/messy_aki.xlsx")

#data available in R and packages
library(medicaldata)
data("strep_tb")

## Data exploration
#view the full data (if the data are not too big!)
View(strep_tb) #note: with capital 'V'

#summaries based on standard R functions
summary(strep_tb)
table(strep_tb$baseline_condition)

#you can check out the summaries of the other data e.g. b_pressure_dat

#type of data
typeof(strep_tb)
class(strep_tb)
#each column can have their own datatype
class(strep_tb$dose_strep_g)

## Data wrangling
#we can do different things with the data, depending on the needs
# the packages to use for data wrangling are in the tidyverse
library(tidyverse)

# a little intermezzo before starting to data wrangle: Using a pipe %>%
#a pipe puts the object before the pipe in the first argument of the following 
#function, so:
sum(c(1, 3, 7))
#using a pipe
c(1, 3, 7) %>% sum()
#or for rnorm, where the first argument is number of samples (n)
20 %>% rnorm(0, 1)
#this example is pretty useless, but it becomes very useful in data wrangling

#we can filter rows based on a condition, e.g. only the streptomycin arm
strep_tb_filtered <- strep_tb %>% 
  filter(arm == "Streptomycin")

#we can select columns
strep_tb_selected <- strep_tb %>% 
  select(contains("baseline"))

#we can mutate/add a new column
strep_tb_mutated <- strep_tb %>% 
  mutate(death = radiologic_6m == "1_Death")

#we can sort our data based on a certain or multiple columns
strep_tb_arranged <- strep_tb %>% 
  arrange(baseline_condition, desc(radiologic_6m))

#we can summarize our data
strep_tb %>% 
  summarize(n_ids = length(unique(patient_id)), 
            n_improved = sum(radiologic_6m == "6_Considerable_improvement"))
#or summarize based on groups!
strep_tb %>% 
  group_by(arm) %>% 
  summarize(n_ids = length(unique(patient_id)), 
            n_improved = sum(radiologic_6m == "6_Considerable_improvement")) %>%
  ungroup() %>% 
  mutate(p_improved = n_improved/n_ids)

#Exercise: Improved patients
# it might be interesting to see how different baseline_conditions have seen 
# improvement (radiologic_6m), use group_by() and summarize() to get the number 
# of patients that got a "6_Considerable_improvement" for each 
# baseline_condition. This can also be done using the base R function table()

#eventually we would (also) want show a plot! (see 04_visualization.R)

## Joining data
#some data are distributed over multiple dataset and need to be combined
#Such as: b_pressure_dat and b_type_dat, which contain the same id's
blood_dat_left <- b_type_dat %>% 
  left_join(b_pressure_dat)
#blood_dat_left contains all ids from b_type_dat and only the matching ids from 
# b_pressure_dat
#try out other possibilities (see slides)

#Exercise: which join?
# use join to keep all rows from both b_type_dat and b_pressure_dat,
# so this will introduce NAs for missing values. The number of rows should be 
# 56, (how would you check this number of rows?)

#Exercise (advanced): split resus and blood group
# try to create blood data with separate columns for resus and blood group:
#  - split the colum blood_type from b_type_dat (We have not provided code for 
#    this above!)
#  - left_join the result with b_pressure_dat, call the new data: blood_dat 

## Saving data
# after creating blood_dat, we might want to save it
#as an R object
save(blood_dat, file = "data/blood_data.Rdata")
#or as a csv file
write.csv(blood_dat, file = "data/blood_data.csv", row.names = FALSE)
#check out the functions and try them out!
?write.csv

## Pivoting data
# sometimes we want to switch between wide and long format
# lets try it on a dataset of hospitalized CAP patients
load("data/crp_data.Rdata")
# check out what the data look like
dim(crp_data)
View(crp_data)
#this has a wide format, which can be useful in certain situations
summary(crp_data)
#but lets make it in long format!
crp_long <- crp_data %>% 
  pivot_longer(contains("crp"), names_to = "day", values_to = "crp")
#Exercise: data cleaning
# the day column is still not perfect, change it to have only the numeric value 
# of the day, and not day_crp written in front of each value. Secondly, remove 
# rows that contain NA values for crp.

#Exercise: pivot_wider
# can we go back to the wide format? check out the function pivot_wider
?pivot_wider


## Advanced practice: Data wrangling and basic programming
#lets dive into a detailed example on the temperature in the data
#the temperatures are categorized and in Fahrenheit! 
table(strep_tb$baseline_temp)

#Luckily we made a functions to change this (from 01_basics.R)
convert_to_celsius <- function(fahr) {
  cels <- (fahr - 32)/1.8
  return(cels)
}

#however this gives an error!
convert_to_celsius(strep_tb$baseline_temp)
#lets find out what we are dealing with:
class(strep_tb$baseline_temp)
#baseline_temp is a factor! This corresponds to the error message
#lets write a small program to change the type and get the F values out

#step 1: explore what do we have?
strep_tb$baseline_temp[1:5]
levels(strep_tb$baseline_temp)

#next: how to now translate?
