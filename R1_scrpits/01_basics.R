### Welcome! This is a comment (starting with #)
#we can type in a script whatever we want to when using comments
#below you can read about different data types, don't be scared to play around!

### Types of data (also taught in Datacamp)
## Characters
#we can write strings (called character types) using quotation marks""
"This is a string"
class("This is a string")

## Numeric values
#we can calculate with numeric values
3 + 4

#and other calculations
3*7 #multiplication
3^4 #powers

## Booleans
#then we have Booleans (only true or false)
TRUE
FALSE
#Booleans are very useful to compare values in (in)equalities
2 == 1 + 1
"Hello" == "hello"
5 != 10
45 > 80

#you can use logical operators
(3 > 5) & (70 > 20) # & = AND: both should be true
(3 > 5) | (70 > 20) ## | = OR: either one or both should be true

#you can reverse the logical with exclamation mark !
!TRUE
!45 > 80

#we can calculate using Booleans where FALSE = 0 and TRUE = 1
TRUE*3
FALSE + 2
#this changes the data type!
class(TRUE)
class(TRUE*3) #this is numeric now

#NaN and NA
#are also unknown values
NA
class(NA)
#or NaN (not a number)
NaN
log(-2)

#logical operations don't work as nicely with those:
NA > 3 #we don't know
NaN < 20
#so working with NA's usually requires is.na()
is.na(NA)
is.na("string")

## Factors
#lastly, factors are a categorical variable type with a value attached to it
factor("happy")

#factors can be converted to their numeric value
as.numeric(factor("happy"))
#unlike characters!
as.numeric("happy")
#unless the character is a number
as.numeric("123")
#be aware! Factors do not take into account the character itself
as.numeric(factor("123"))
#you can change the order of a factor using 'levels', 
#it will automatically order it alphabetically
factor(c("not so happy", "very happy", "bit happy"))
# but we might want to provide the order!
factor(c("not so happy", "very happy", "bit happy"), 
       levels = c("not so happy", "bit happy", "very happy"))


### Variables and multiple values
#store your data in a variable, mind the naming!
bools_var <- TRUE
num_var <- 20

#we can concatenate multiple of the same type to create a vector
char_vec <- c("This is a string", "and another one")

#with numerics you can easily create a range of values
1:10
1:4 == c(1, 2, 3, 4)

#it is also possible to make a multidimensional object: such as a matrix
abcd_mat <- matrix(c("a", "b", "c", "d"), nrow = 2)

#numeric matrices and vectors can be used for (matrix) algebra
beta <- as.matrix(c(3, 0.1, 5))
X <- matrix(c(1, 13, 0.4, 
              1, 19, 0.2,
              1, 20, 0.7),
            byrow = TRUE, ncol = 3)
X %*% beta #matrix multiplication


#we can make a dataset using a data.frame!
blood_dat <- data.frame(patient = c(1, 2, 3),
                        sbp = c(100, 95, 68),
                        blood_type = factor(c("0+", "A+", "A+")))
class(blood_dat)
#think about your naming conventions!

### Other aspects
## Indexing
#after creating an object with multiple values, you can get a value using index
str_vec <- c("first string", "second string", "third string")
str_vec[1]
str_vec[2]
#R starts counting at 1 (other languages, e.g. Python, often start at 0)

#you can also deselect a part of the object by using the minus sign
str_vec[-2]

#with more dimensional objects, it can be a bit harder
blood_dat[, 1] #select first column
blood_dat[1, ] #get first row

#you can also select based on the name of the column
blood_dat$blood_type


## Print
#we ran code and it showed output by just running it, but you can use print()
# to show the result in the console
print("this is printing")
"this is not printing"
#the result is the same, because in the background, R is calling print after you 
# ran something! This can change in functions and loops (next part)

#Exercise: we have a matrix below, try to use the right indexing to get the 
# number 35. Hint: first print the object to see how it looks! Use the straight 
# brackets '[]' 
matrix_35 <- matrix(c(0, 6, 0, 0, 
                      35, 0, 0, 0,
                      0, 2, 0, 9), 
                    nrow = 3, byrow = TRUE)
#Exercise: for above matrix can you also get the number 2?