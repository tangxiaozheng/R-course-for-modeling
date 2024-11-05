### Programming: basic building blocks
#with variables you might want to write a program
#testtest
### Control structures: if() and else()
#if() is used to run, or not run a piece of R based on a Boolean input
if (1 == 2) {
  print("will this run?")
}

#else, when if does not trigger what should then be done
if (1 == 2) {
  print("will this run?")
} else {
  print("apparently not!")
}

#you can also combine if and else, the else only runs if the if did not run!
if (1 == 2) {
  print("will this run?")
} else if (1 < 2) {
  print("maybe this runs?")
}
#when the first if runs:
if (1 != 2) {
  print("will this run?")
} else if (1 < 2) {
  print("maybe this runs?")
}


#in a program this can be useful when working with an input variable
a <- 20
if (a < 10) {
  print("a is definitely less than 10.")
} else if (a > 20) {
  print("a is definitely more than 20.")
} else {
  print("a is somewhere between 10 and 20 (inclusive 10 and 20).")
}
print("This is printed anyway")
#adapt the value of the variable a to get different outcomes

#'if' can be use with numeric values as well: all values are TRUE except for 0
b <- 20
if (b) {
  print(paste("b =", b))
}
#characters don't work as Booleans, so they give an error in 'if'!
d <- "something"
if (d) {
  print(paste("d =", d))
}
#note: I am skipping variable name c, because it is also the name of a function!

### Loops: for()
#programming becomes interesting when it can take away repetitive tasks!
for (i in c(1, 3, 6)) {
  print(paste("the value of i is", i))
}
#each time in the loop, the code is run again and the value of i changes

#this can be useful in many ways!
# if we want to convert temperatures in Fahrenheit  to Celsius
# (subtract 32 and divide by 1.8)
temp_f <- c(99.3, 98.42, 100.40, 98.96)
#for loop:
for (tf in temp_f) {
  tc <- (tf - 32)/1.8
  print(tc)
}
#save output:
temp_c <- numeric(length(temp_f))
for (i in 1:length(temp_f)) { #using the index of the vector!
  tf <- temp_f[i]
  tc <- (tf - 32)/1.8
  temp_c[i] <- tc
}
temp_c
#save output 2 (slower with large data!):
temp_c <- numeric()
for (tf in temp_f) {
  tc <- (tf - 32)/1.8
  temp_c <- c(temp_c, tc)
}

#reminder! You can also use the vector in algebra, this is even quicker!
temp_c <- (temp_f - 32)/1.8

## Loops: while()
#another type of loop is while, not very often used in R, but in Python or other
#languages very prevalent.
e <- 3
while (e < 10) { #choose the condition!
  e <- e + 1
  print(e) #you can print here if you want to show whats going on with e!
}
#you can get stuck in an infinite loop! (please don't run this!)
# f <- 3
# while (f < 10) { # f will always stay smaller then 10!
#   print(f)
# }
#press the [escape] button to stop it!

#Exercise: write a loop that prints, or stores the first 5 numbers to a 
# power of 3, starting with 2, so the result should be: 8, 64, 512, 4096, 32768
# Extra: it is also possible to do this without a loop!
start_number <- 2

## Combine loops and if else's
# we often use if and else within for loops!
for (a in c(2, 38, -3, 9, 20)) {
  print(a)
  if (a < 10) {
    print("a is definitely less than 10.")
  } else if (a > 20) {
    print("a is definitely more than 20.")
  } else {
    print("a is somewhere between 10 and 20 (inclusive 10 and 20).")
  }
}

#Exercise (advanced): lets fix it! 
#someone recorded a mix of Celsius and Fahrenheit, messy!
temp_mixed <- c(35.82, 36.67, 98.04, 37.32, 98.8, 36.11, 37.28, 36.49, 35.62, 
                98.31, 100.56, 37.86, 37.25, 36.25, 100.18, 98.69, 38.25, 36.61, 
                97.81, 38.2, 36.2, 36.85, 36.61, 99.48, 99.66, 97.3, 99.23, 
                36.52, 98.74, 37.09)
# write a loop that will translate all Fahrenheit to Celsius


### Functions
#a function allows you to store a bit of code for reuse
convert_to_celsius <- function(fahr) {
  cels <- (fahr - 32)/1.8
  return(cels)
}
#three important aspects: 
# input 'fahr', this is what is used inside the function
convert_to_celsius(fahr = 134)
# opening brackets {} these define where the function starts and ends
# return(): determines which part of the function is output of the function
fahr_value <- convert_to_celsius(fahr = 134)

#you can write your own function, but most code you use are already functions!
# everything with opening and closing brackets after the term is a function
c(1, 3, 7) #c() is a function to create a vector
sum(c(1, 3, 7)) #you can use a function inside a function!
#or split it up, store output of a function as variable
interesting_numbers <- c(1, 3, 7)
sum(interesting_numbers)
prod(interesting_numbers)

#and there are more complex functions with different inputs
random_numbers <- rnorm(n = 30, mean = 10, sd = 2)
#we created a vector with random numbers from a normal distribution
#we could leave out the arguments as long as we keep the order!
random_numbers2 <- rnorm(30, 10, 2)
#or we can change the order with the argument names
random_numbers3 <- rnorm(mean = 10, sd = 2, n = 30)
#use ? to read the help page for a function
?rnorm
# or help
help(rnorm)


### Packages and library()
#there are way more functions available, written by users that thought some 
#functions would make their lives easier
#you need to install a new package only once using
install.packages("lme4")
#the functions are not yet available, but will be available in R if you run
library(lme4)
# what is this library? Ask the help page (specify looking for a package!):
help(package = lme4)

#there are also libraries that store data (important for the next part!) such as
install.packages("medicaldata")
library(medicaldata)
help(package = "medicaldata")
