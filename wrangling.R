#Basic Wrangling

#----------------------------------------------
#tibble
#very similar to data frames but more strict
#They don't do the typical data frame coercions  
tib <- tibble(
  x = runif(5),
  y = rnorm(5)
)

#subsetting a tibble
tib$x
tib[["x"]]
tib[[1]]
#These are equivalent 

#convert a tibble back to a data frame
#occasionally an old method requires a data frame
df <- as.data.frame(tib)

#-------------------------------------------
#Import with readr 

#read_csv()
#There are many other functions for importing other data files 
#but they work very similarly to read_csv()

read_csv("a,b,c
         1,2,3
         4,5,6")
#default behavior is to read the first line as column names but
#that can be easily changed to either ignoring the first few lines
#or reading the file as data without column names. 

#NA
read_csv("a,b,c\n1,2,.", na = ".")
#The characters used for missing data can be specified. All missing
#data should be converted to NA before analysis begins. 

#------------------------------------------------
#Tidy data with tidyr

#Tidy data simply means that columns are variables, rows are 
#observations, and each value has its own cell. 
#In practice, all you need to do is ensure that your data in
#in a tibble with columns as variables. Although this problem
#sounds trivial, it is very challenging in practice. 

#Example of tidy data 
country <- c("Afghanistan", "Afghanistan", "Brazil", "Brazil", "China", "China")
year <- c(1999, 2000, 1999, 2000, 1999, 2000)
cases <- c(745, 2666, 37737, 80488, 212258, 213766)
population <- c(19987071, 20595360, 172006362, 174504898, 1272915272, 1280428583)
table_tidy <- tibble(country, year, cases, population)


#Messy data cames in 4 varieties.

#1. Column names are variable values, not variable names. 
country <- c("Afghanistan", "Brazil", "China")
`1999` <- c(745, 37737, 212258)
`2000` <- c(2666, 80488, 213766)
`2001` <- c(3002, 453, 1233)
table_messy <- tibble(country, `1999`, `2000`, `2001`)
# This table is a subset of the above tidy table that needs to be gathered. Although
# you can't get this table to look exactly like the above (it is missing the 
# population column), you can still get it tidy. 

# The problem is that year variable values are acting as column names. 
# Column names must be variable names, not variable values. The years
# must be "gathered" into one column with the variable name "year." 
# Next the values that are currenlty underneath the erronous column names
# need to be given a proper column name. In this situation, that proper
# name is cases (as in cases of infection or something). 

table_tidy <- table %>% gather(`1999`:`2001`, key = year, value = cases)
# Notice the arguments for key and value. The best I can do to understand
# these names is that, in the original untidy table, if the data were 
# represented as an array of objects, each object in the array would have
# a year values as keys and case values as values. That would be a very 
# strange way of structuring an array of objects, and it is likewise a very
# stange way of creating an R data frame. So, my understanding of the key 
# and value arguments in the gather function is that they are opportunities
# to rename the incorrect keys and values. 



# 2. Single observations take up multiple rows. 

country <- c("USA", "USA", "USA", "USA")
year <- c(1999, 1999, 2000, 2000)
type <- c("cases", "population", "cases", "population")
count <- c(745, 3435, 231, 8888)

table_messy <- tibble(country, year, type, count)

# The problem here is that each observation takes up two rows
# instead of one. The reason that happened is because of the 
# type column. If "cases" and "population" were considered 
# varlable values, this might be called tidy data. However, 
# cases and population are not variable values, they are 
# variable names. The values in the count column are really 
# variable values of "cases" and "population." 

table_tidy <- table_untidy %>% spread(key = type, value = count)

# Again, the names "spread", "key" and "value" are hard to
# understand. I think it is helpful to think in terms of 
# objects and arrays. The correct way to construct each object
# in the array is with a keys that are currently values in the 
# type column. And the values for those keys should be the current
# values that are in the count column. 

# 3. One column contains two variables 
country <- c("Afghanistan", "Afghanistan", "Brazil", "Brazil", "China", "China")
year <- c(1999, 2000, 1999, 2000, 1999, 2000)
rate <- c("745/19987071", "2666/20595360", "37737/172006362", "80488/174504898", "212258/1272915272", "213766/1280428583")

table_messy <- tibble(country, year, rate)

# This problem is the easiest of untidy data. You simply need to separate rate
# into coses and population. 

table_tidy <- table_untidy %>% 
  separate(rate, into = c("cases", "population"), sep = "/")

# 4. Two columns contain one variable
# This is a rare problem but it is easy to solve. It is essentially the opposite
# of problem #3. The tidyr funciton is called unite() and it works the same way 
# as separate. 

#------------------------------------------------------------

# Implicit Missing Values
# Imagine data on quarterly profits. If data on a current quarter is implicitly 
# missing, meaning nothing is there, not even NA, you may want to fill in the 
# quarter as explicitly missing, meaning using NAs. Another example is if there 
# are multiple observations on one individual subject. The name of that subject
# may be missing, either implicitly or explicitly, but the intention of the data 
# collecter was to imply that the observations applied to a single subjects name. 
# There are functions to help with both of this problems. They are called 
# complete() and fill(). 

#-----------------------------------------------------------
# Data cleaning example using the TB dataset from the world health organization. 
# dplyr::who

who %>%
  gather(code, value, new_sp_m014:newrel_f65, na.rm = TRUE) %>% 
  mutate(code = stringr::str_replace(code, "newrel", "new_rel")) %>%
  separate(code, c("new", "var", "sexage")) %>% 
  select(-new, -iso2, -iso3) %>% 
  separate(sexage, c("sex", "age"), sep = 1)