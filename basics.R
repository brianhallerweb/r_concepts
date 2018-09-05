# R Basics

# Documentation
# ?function will show documentation for function

#--------------------------------
# Packages
# in R, packages are collections of useful functions and 
# data. They are stored in the library. 
# Packages are hosted on CRAN.
install.packages("ggplot2")
library(ggplot2)

#--------------------------------
# Running scripts in the command line
# Rscript myscript.R

# Running Scripts in the R interpreter
# source("path to R script")

#--------------------------------
#variables (vectors)
x <- 2L
typeof(x) #integer

y <- 4.5
typeof(y) #double
z <- 3 
typeof(z) #double, integers are stored as double be default

result <- y + z
result #7.5

w <- 3 + 2i
typeof(w) #complex

a <- "obie"
typeof(a) #character

h <- T
typeof(h) #logical

message = paste("obie", "the dog")
message  #obie the dog 

rm(message) #removes the message variable from the global environment

#--------------------------------
#logical operators 
4 < 5 
5 > 6
4 == 4
4 != 3
4 >= 4
T & F #false 
T | F #true 
mylogical = !T
isTRUE(mylogical) #false

#--------------------------------
# loops
# loops are not commmonly used in r. They are slow and
# functional approaches are preferred. 

i = 1 
while (i < 10){
  i = i + 1
  print(i) #must use print function inside loops
}

randoms <- rnorm(5)
for(i in randoms){
  print(i)
} #this is the r specific loop. i isn't the index,
# it is the element

for(j in 1:5){
  print(randoms[j])
} # j is the index in this style

#--------------------------------
# conditionals

if(T){
  5 #5
} else {
  "this wont print"
}

#--------------------------------
#Vectors 
#basically the same as a js array
#indexed starting with 1
#everythign is a vector, even a single number
#r is a vectorized programming language

vec <- c(1, 2, 3)
typeof(vec) #double 
is.numeric(vec) #true
is.double(vec) #true

vec <- c("a", "b", "c")
typeof(vec) #character

#vectors must be the same type. Coercion of numbers to 
# strings does automatically happen. 

#seq() or : opertor will also generate a vector
# these are equivalent ways of creating a vector
# 1, 2, 3, 4, 5
vec <- seq(1, 5)
vec <- 1: 5

#rep(value, reps) 
# rep will replicated a value a given number of times
vec <- rep(1,5)

vec <- rep(NA, 5)
vec # allocating memory for a vector of length 5

longVec <- rep(vec, 2)
longVec #rep will replicate existing vectors as well 

vec[1] #the first element in vec
vec[-1] #all elements in vec except the first
vec[1:3] #the first 3 elemets in vec. The elements are 
#specified with a vector, so any style of writing a 
#vector will work. 

vec = c(1, 2, 3, 4, 5)
vec[6] #NA

#--------------------------------
#Vector arithmetic 

# this is where r starts to become a very different 
# language. Arithmetic can be done on vectors very 
# easily.
vec1 <-  c(1, 2, 3, 4, 5)
vec2 <- c(1, 2, 3, 4, 5)
vec3 <- vec1 + vec2 # 2 4 6 8 10
vec1 == vec2 # T T T T T

# vectors of different length 
vec1 <-  c(1, 2, 3)
vec2 <- c(1, 2, 3, 4, 5)
vec1 + vec2 # Error because vec1 length 3 doesn't divide 
# length 5
vec1 <-  c(1, 2, 3)
vec2 <- c(1, 2, 3, 4, 5, 6)
vec1 + vec2 # 2 4 6 5 7 9 ------ ??????? This looks strange.
# vec1 is being "recycled" until the 2 vectors are the same 
# length 

vec <- c(1, 2, 3)
myVecLength <- length(vec) 
myVecLength # 3
# Notice that vectors are used as arguments to functions
# and returned from functions. Everything is a vector in R. 

# Vectors are not manipulated the way arrays typically are. 
# Creating empty arrays and pushing values into them is 
# a technique that should be avoided in R. R is designed 
# with vector arithmetic in mind and the performance of loops
# is terrible. That is because R is a wrapper around C and
# fortran. Vectors have known properties, such as a single 
# type, which makes the instructors to C much more efficient. 

#--------------------------------
# Functions 

# many functions have default arguments. To provide your own
# arguments, you can either follow the order found in the docs
# or used named arguments in any order. Also, when writing
# your own functions, you can set default values. 

rnorm(5) #5 random values from a standard normal 
rnorm(mean = 5, 5) # 5 random values from a normal with mean of 5

#FizzBuzz
fizzBuzz <- function(n){
  for (i in 1:n){
    if (i %% 15 == 0) {
      print("fizzBuzz")
    } else if(i %% 3 == 0 ){
      print("fizz")
    } else if (i %% 5 == 0){
      print("buzz")
    } else {
      print(i)
    }
  }
}
fizzBuzz(15)

#--------------------------------
# Matrices 
# A representation of tabular data of the same type

# the matrix function 
letter <- seq(1, 10)
myMatrix <- matrix(letter, nrow=2, ncol=5, byrow=T)
myMatrix # the matrix function will take a vector and "bend" it 
# into a matrix. This matrix will have the elements 1 through 10 
# bent into a 2 by 5 matrix. 

# rbind and cbind
row1 <- 1:3
row2 <- 4:6
row3 <- 7:9
myMatrix <- rbind(row1, row2, row3) 
myMatrix #each row is bound to a matrix
#cbind works the same way but for columns 
rm(row1, row2, row3) #after the matrix is created, the vectors 
# can be removed from the global environment

# indexing a matrix 
myMatrix[1, 2] # the element in row 1 column 2 
myNewMatrix <- myMatrix[1, ,drop=T] # the entire row 1
is.matrix(myNewMatrix) # false, because myNewMatrix is just one row
# which makes it a vector. That happens because the drop parameter is 
# set to T by default. If you want a one dimensional matrix, set 
# drop to FALSE. 
myMatrix[ ,5] # the entire column 5

# naming vectors 
# this is going to look weird...
# vectors indeces can be named like this:
vec <- seq(1,3)
names(vec) #NULL
names(vec) <- c("a", "b", "c")
names(vec) # "a" "b" "c"
vec # this is still 1 2 3 but each element is named "a" "b" "c" 
vec["b"] # 2
names(vec) <- NULL #this will clear the names 

# naming matrices 
# naming rows and columns is just naming the row and column vectors 
myMatrix <- rbind(1:3, 4:6, 7:9) 
rownames(myMatrix) #NULL 
colnames(myMatrix) #NULL
rownames(myMatrix) <- c("a", "b", "c")
rownames(myMatrix) # "a" "b" "c"
colnames(myMatrix) <- c("a", "b", "c")
colnames(myMatrix) # "a" "b" "c"
myMatrix # a matrix is printed with labeled rows and columns. These can be 
# used for indexing the matrix as well as the index numbers. 


# Matrix arithmetic 
# this works just like you could want it to. The corresponding elements are 
# added, for example 
myMatrix1 <- rbind(1:3, 4:6, 7:9) 
myMatrix2 <- rbind(1:3, 4:6, 7:9) 
summedMatrix <- myMatrix1 + myMatrix2

# Matrix visualization 
# matplot is a built in visualization function for matrices but it probably
# isn't worth thinking about too much. 

# Matrix Subsetting
myMatrix <- rbind(1:3, 4:6, 7:9) 
myMatrix
myMatrix[1:2, 1:2] # This will subset the matrix. It will return the first 
# two rows and the first two columns

#---------------------------------------------------

# Data Frames
# Unlike matrices, these are tables that do not have to have the same
# value type. The rows have numbers and the columns have names. Also,
# subsetting only one row doesn't convert the row into a vector, like
# it does in a matrix - it stays a data frame. If you subset a column,
# it will convert to a vector (unless drop=F)

# creating a data frame 
myDf <- data.frame(col1, col2, col3, ...)
colnames(myDf) <- c("col1name", "col2name", "col3name")
#or you can create the data frame and give column names in one step
myDf <- data.frame(col1name = col1, col2name = col2, col3name = col3)

# importing csv data as data frame
DemographicData <- read.csv("~/Desktop/DemographicData.csv")
DemographicData <- read.csv("DemographicData.csv") # This works if the 
# file is in the working directory. 

# subsetting a dataframe 
# this can work just like matrix subsetting
# The $ shortcut is helpful
# these 2 subsets are equivalents
DemographicData[2, "Internet.users"]
DemographicData$Internet.users[2]
#Both are targeting the column "Internet.users", row 2

#adding a column 
#just use the dollar sign as if you were subsetting 
DemographicData$myNewCol <- ...
#Perhaps he new column would be a result of arithmetic on 2 other columns

#remove a column 
DemographicData$myNewCol <- NULL

#filtering a data frame 
filter <- DemographicData$Internet.users < 2
DemographicData[filter, ]
#filter is a vector of logicals - T when a country has less than 2% internet
#use and F otherwise. 
DemographicData[DemographicData$Country.Name == "Malta", ]

#Creating factors 
#Factors are categorical variables with levels 
gender_vector <- c("Male", "Female", "Female", "Male", "Male")
factor_gender_vector <- factor(gender_vector) 
factor_gender_vector
#A factor can be ordinal
temperature_vector <- c("High", "Low", "High","Low", "Medium")
factor_temperature_vector <- factor(temperature_vector, order = TRUE, levels = c("Low", "Medium", "High"))
factor_temperature_vector
#Factor levels can be renamed
survey_vector <- c("M", "F", "F", "M", "M")
factor_survey_vector <- factor(survey_vector)
levels(factor_survey_vector) <- c("Female", "Male")
factor_survey_vector

#======================================

#Lists 
#Lists gather a variety of objects under one name.
#A list can contain matrixes, vectors, data frames,
#or even other lists. 

my_vector <- 1:10 
my_matrix <- matrix(1:9, ncol = 3)
my_df <- mtcars[1:10,]
my_list <- list(vec = my_vector, mat = my_matrix, df = my_df)

my_list[[2]] #subsetting the 2nd item in the list 


























