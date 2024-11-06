### Visualization
# Getting to know your data and producing publication ready plots!

#libraries
library(tidyverse)
library(medicaldata)

## Read some data to work with
load("data/blood_data.Rdata") #blood_dat object
data("licorice_gargle")
data("strep_tb")

### 'base' plot
#R has a base plotting function, which makes data exploration very easy!
plot(blood_dat$sbp, blood_dat$dbp)
#it determines which type of plot makes sense:
plot(as.factor(blood_dat$group), blood_dat$dbp)
#a lot can be changed like coloring and sizes, limits of the plot etc.
plot(blood_dat$sbp, blood_dat$dbp, xlim = c(0, 160), ylim = c(0, 150), 
     pch = 16, col = "dark blue")

#R objects often have a method for a specific object, e.g. in linear regression
lm_blood <- lm(sbp ~ dbp, data = blood_dat) # code to apply a linear model
plot(lm_blood, which = 2)

### ggplot2: another way of plotting (tidyverse)
#adding more components to base plot can become tedious, we advise to use ggplot
# which is part of the tidyverse!
blood_dat %>% 
  ggplot(aes(x = dbp, y = sbp, color = group, shape = resus)) +
  geom_point(size = 6) +
  scale_shape_manual(values = c(45, 43)) +
  theme_bw()
#be aware! Above plot can only be made if you finished the exercise in script 03
  
#you can use it together with the data wrangling tidyverse functions
blood_dat %>% 
  filter(!is.na(blood_type)) %>% 
  ggplot(aes(x = resus, fill = group)) +
  geom_bar(position = position_dodge2(width = 1, preserve = "single")) +
  theme_bw()
#I would like to change the order of blood type (remember factors!):
blood_dat %>% 
  mutate(group = factor(group, levels = c("0", "A", "B", "AB"))) %>% 
  ggplot(aes(x = dbp, y = sbp, color = group, shape = resus)) +
  geom_point(size = 6) +
  scale_shape_manual(values = c(45, 43)) +
  scale_color_viridis_d(end = 0.9, option = "turbo") +
  theme_bw()

#Lets explore some other data
licorice_gargle %>% 
  ggplot(aes(x = preOp_age, y = preOp_calcBMI, color = as.factor(preOp_asa))) +
  geom_point(aes(shape = as.factor(preOp_smoking))) +
  geom_smooth(method = "lm", se = FALSE) +
  theme_bw()

#you can add custom colors with their hex values!
strep_tb %>% 
  ggplot(aes(x = strep_resistance, fill = improved)) +
  geom_bar() +
  scale_fill_manual(values = c( "#3ABAC1", "#C37121"))+
  facet_wrap("arm") +
  theme_bw()

#you can change options within specific plots
strep_tb %>% 
  ggplot(aes(x = baseline_condition, fill = radiologic_6m)) +
  geom_bar(position = "dodge") +
  scale_fill_viridis_d(direction = -1) +
  theme_bw()

#we can store our plot in an object 
strep_barplot <- strep_tb %>% 
  ggplot(aes(x = baseline_condition, fill = radiologic_6m)) +
  geom_bar(position = "dodge") +
  scale_fill_viridis_d(direction = -1) +
  theme_bw()

#let's output our plot to a pdf file!
pdf(file = "results/figures/strep_barplot.pdf", width = 6, height = 5)
print(strep_barplot)
dev.off()


ggsave(file = "results/figures/strep_barplot.png",,width = 6,
       height = 5, dpi=300)
print(strep_barplot)
dev.off()
# Exercise: create a png file
#use the function png() to create a png file, similar to how we created the pdf,
#play around with the width, height and res (resolution)

#Exercise: lets make a very nice plot! 
# - What don't you like yet about the strep_barplot? try to change those aspects
# - save your new plot as pdf output
#hint: use Google and Stack Overflow!
